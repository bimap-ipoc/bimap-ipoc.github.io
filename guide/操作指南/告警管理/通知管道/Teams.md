# 新增 Microsoft Teams 群組並設定 Webhook

**1. 建立 Microsoft Teams 群組**

- 開啟 Microsoft Teams，點擊左側導航列的"群組"圖標。
- 點擊"加入或建立群組"按鈕。
- 選擇"建立團隊"。
- 在彈出的對話框中，輸入團隊名稱（例如"iPOC"）和描述，選擇團隊的隱私設定（例如"公開"）。
- 點擊"建立"按鈕。

![建立團隊](../../images/通知設定_1.建立團隊.jpg)

**2. 新增成員至群組**

- 進入剛剛建立的團隊，點擊團隊名稱右側的"更多選項"圖標（三個點）。
- 選擇"新增成員"。
- 在彈出的對話框中，輸入成員的名字或郵件地址（例如"zoe.lin@bimap.co"），並點擊"新增"。

![新增成員](../../images/通知設定_新增成員1.jpg)
![新增成員](../../images/通知設定_新增成員2.jpg)

**3. 搜尋並新增 Webhook 應用**

- 點擊左側導航列的"應用程式"圖標，並在搜尋框中輸入"webhook"。
- 在搜尋結果中，選擇"Incoming Webhook"應用，並點擊"新增"按鈕。

![搜尋 Webhook](../../images/通知設定_2.搜尋Webhook.jpg)
![添加 Webhook](../../images/通知設定_3.添加Webhook.jpg)

**4. 新增 Incoming Webhook 至團隊**

- 點擊"Incoming Webhook"應用，然後點擊"新增至團隊"按鈕。
- 選擇團隊（例如"iPOC"）並選擇一個頻道（例如"General"）。
- 點擊"設定連接器"按鈕。

![新增 Webhook 至團隊](../../images/通知設定_4.新增Webhook至團隊.jpg)

**5. 設定 Webhook 連接器**

- 在彈出的對話框中，輸入 Webhook 名稱（例如"ipoc_alert"），然後點擊"建立"按鈕。
- 複製生成的 Webhook URL，這個 URL 之後會在 iPOC 頁面設定中使用。

![設定 Webhook 連接器](../../images/通知設定_5.設定Webhook連接器.jpg)
![複製 Webhook URL](../../images/通知設定_6.複製WebhookURL.jpg)

**6. 在 iPOC 頁面設定 Teams Webhook**

- 開啟 iPOC 頁面，進入"通知管道"設定頁面。
- 輸入通知管道名稱（例如"test"），選擇告警級別（Info、Warning、Critical）。
- 選擇通知方式為"Microsoft Teams"。
- 將之前複製的 Webhook URL 粘貼到相應的欄位中，然後點擊"測試"按鈕進行測試。
- 測試成功後，點擊"保存"按鈕。

![iPOC 頁面設定 Teams Webhook](../../images/通知設定_7.ipoc頁面設定teams_webhook.jpg)

**7. 測試 Webhook 通知**

- 測試成功後，Teams 頻道將會收到測試訊息通知。

![收到測試訊息通知](../../images/通知設定_8.收到測試訊息通知.jpg)

**8. 設定頻道通知**

- 點擊 Teams 頻道名稱右側的"更多選項"圖標（三個點），選擇"頻道通知"。
- 選擇通知設定（例如"關閉通知"或"只在摘要中顯示"），然後點擊"儲存"。

![頻道通知設定](../../images/通知設定_頻道通知設定1.jpg)
![頻道通知設定](../../images/通知設定_頻道通知設定2.jpg)
![頻道通知設定](../../images/通知設定_頻道通知設定3-顯示新訊息提示.jpg)