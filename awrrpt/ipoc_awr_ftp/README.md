# [SOP設定手冊] collect_awr_sop

## 1. AWR Log 收集格式說明：
將一天中每60分鐘的 Oracle AWR 日誌輸出為html格式， 一天共有24個文件。程式架構如下：
```

├── ipoc_awr.sh
├── custom.sql
├── ftplog.txt               # 程式執行後會自動產生
├── master_awr_control.sql   # 程式執行後會自動產生
├── SENT                     # 須自行創建SENT資料夾  (放等待上傳的檔案)
└── BACKUP                   # 須自行創建BACKUP資料夾(放上傳完成的檔案)
    ├── bimap-230531.tar.gz  # 昨日檔案會自動壓縮
    ├── orcl_2609_2610_202306010009_202306010109.html
    ├── orcl_2610_2611_202306010109_202306010209.html
    ├── orcl_2611_2612_202306010209_202306010308.html
    ├── orcl_2620_2621_202306011109_202306011208.html
    └── orcl_2627_2628_202306011809_202306011909.html
```

## 2. 確認 AWR 目前配置是否需要調整
- 設定參考文章 https://dbaclass.com/article/modify-awr-snapshot-interval-setting

1. 查詢 awr 目前設置，預設為快照間隔 60 分鐘和保留 8 天
```
select snap_interval, retention from dba_hist_wr_control;

SNAP_INTERVAL RETENTION
-------------------------------------------------------------------------- --------------------------------------------------------------------------
+00000 01:00:00.0 +00008 00:00:00.0
```

2. 修改 interval 為 60 分鐘，保留 14 天 (60x24x14)
```
execute dbms_workload_repository.modify_snapshot_settings(interval => 60,retention => 20160);
```

3. 再次檢查設置如下所示
```
SQL> select snap_interval, retention from dba_hist_wr_control;

SNAP_INTERVAL RETENTION
-------------------------------------------------------------------------- -----------------------------------------
+00000 00:60:00.0 +00014 00:00:00.0

```

## 3. 設定步驟如下：

1. 調整 ipoc_awr.sh
- 需要依據 Oracle 的環境進行環境的修改，程式路徑
- 因預設保留8天，可以直接測試執行拉取一週的html檔案來看，修改$HourAgo參數調整範圍
- 打開 html 檔看 table 是否有值，如果db設定有問題、權限沒打開之類，表格欄位都會是空的
![](image/empty_table_1.jpg)
![](image/empty_table_2.jpg)

2. 設定定時任務 crontab 

```
0 * * * * /bin/bash /home/資料夾名稱/ipoc_awr.sh
```

