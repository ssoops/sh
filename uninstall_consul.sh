LOCAL_SRC=/usr/local/src

DIR=/data/consul
SERVICE_FILE=/etc/systemd/system/consul.service

CONSUL_VERSION=1.18.2

SERVER_USER=consul
SERVER_GROUP=consul

DATACENTER=YWKF

sudo systemctl stop consul
sudo systemctl disable consul
rm -rf /tmp/consul_${CONSUL_VERSION}_linux_amd64.zip.bak
rm -rf /tmp/consul_bin.bak
rm -rf /tmp/consul_service_file.bak
rm -rf /tmp/consul.bak
sudo mv ${LOCAL_SRC}/consul_${CONSUL_VERSION}_linux_amd64.zip /tmp/consul_${CONSUL_VERSION}_linux_amd64.zip.bak
sudo mv /usr/bin/consul /tmp/consul_bin.bak
sudo mv ${SERVICE_FILE} /tmp/consul_service_file.bak
sudo mv ${DIR} /tmp/consul.bak
sudo userdel consul

