# oracle 腳本測試執行指令
/usr/bin/su/ - su oraedv -c /home/colt_dev/ipoc_conn.sh

# FTP
ftp.alphanetworks.com
basis
cjo40

## grafana deb
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/oss/release/grafana_10.2.0_amd64.deb
sudo dpkg -i grafana_10.2.0_amd64.deb

## grafana datatable plugin
grafana-cli plugins install briangann-datatable-panel
systemctl restart grafana-server
cp -rp /tmp/briangann-datatable-panel  /var/lib/grafana/plugins/
chown -R grafana:grafana /var/lib/grafana/plugins/*

# 服務
cd /etc/systemd/system
systemctl restart ipoc.service
systemctl status ipoc.service

# mysql 連線
mysql -u bimap -p1qaz2wsx
show databases;

# 查看 firewall 設定
firewall-cmd --list-all
firewall-cmd --permanent --add-port 3306/tcp
firewall-cmd --reload

# 安裝 deb
sudo dpkg -i keycloak.deb
sudo dpkg -i bimap-ipoc.deb
sudo dpkg -i bimap-ipoc-frontend.deb
systemctl daemon-reload

# 卸除
sudo dpkg --purge bimap-ipoc-frontend.deb
# 卸載 grafana 及其依賴項：
sudo apt-get remove --auto-remove grafana
# 重置 grafana 密碼
sudo grafana-cli --homepath “/usr/share/grafana/” admin reset-admin-password newpass

# 刪除空檔案
find . -name "*" -type f -size 0c | xargs -n 1 rm -f





