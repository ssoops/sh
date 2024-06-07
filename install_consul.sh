LOCAL_SRC=/usr/local/src

DIR=/data/consul
DATA_DIR=${DIR}/data
PID_FILE=${DIR}/consul.pid
CONFIG_DIR=${DIR}/consul.d
DATA_LOG=${DIR}/logs
SERVICE_FILE=/etc/systemd/system/consul.service

CONSUL_VERSION=1.18.2

SERVER_USER=consul
SERVER_GROUP=consul

DATACENTER=YWKF

cd ${LOCAL_SRC}
wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
unzip -o consul_${CONSUL_VERSION}_linux_amd64.zip 
sudo chown root:root consul
sudo mv consul /usr/bin/
/usr/bin/consul --version
/usr/bin/consul -autocomplete-install
complete -C /usr/bin/consul consul
sudo mkdir  -p ${DATA_DIR}
sudo mkdir  -p ${CONFIG_DIR}
sudo mkdir  -p ${DATA_LOG}

sudo touch ${CONFIG_DIR}/consul.hcl
sudo touch ${CONFIG_DIR}/server.hcl
sudo chmod 640 ${CONFIG_DIR}/consul.hcl
sudo touch ${SERVICE_FILE}
cat > ${SERVICE_FILE} << END_TEXT
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=${CONFIG_DIR}/consul.hcl

[Service]
User=${SERVER_USER}
Group=${SERVER_GROUP}
ExecStart=/usr/bin/consul agent -config-dir=${CONFIG_DIR}
ExecReload=/usr/bin/consul reload
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
END_TEXT

sudo useradd --system --home ${DIR} --shell /bin/false consul


echo 'Enter the your Server Group IPs: 
Example: ["10.1.1.1","10.1.1.2","10.1.1.3"]'  
read SGIPs
echo "Your Server Group IPs is ${SGIPs}" 

if [ ! -n "${SGIPs}" ] ; then 
  echo "Not input Server Group IPs, Exit"
fi


cat > ${CONFIG_DIR}/consul.hcl << END_TEXT
datacenter = "${DATACENTER}"
data_dir = "${DATA_DIR}"
log_file = "${DATA_LOG}/consul.log"
pid_file = "${PID_FILE}"
encrypt = "aYzpAxIx8SX4YFNfsyr+t501M8G9TLRbGYeQhYsXUJ4="

retry_join = ${SGIPs}
performance {
  raft_multiplier = 1
}
END_TEXT

cat > ${CONFIG_DIR}/server.hcl << END_TEXT
server = true
bootstrap_expect = 1
ui = true
END_TEXT

sudo chown -R ${SERVER_USER}:${SERVER_GROUP} ${DIR}

sudo systemctl enable consul
sudo systemctl start consul
sudo systemctl status consul
consul members
