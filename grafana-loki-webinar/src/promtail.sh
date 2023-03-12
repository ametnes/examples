#!/bin/bash

cd /usr/local/bin
apt-get update && apt-get install -y unzip acl curl
curl -O -L "https://github.com/grafana/loki/releases/download/v2.4.1/promtail-linux-amd64.zip"
unzip "promtail-linux-amd64.zip" && rm "promtail-linux-amd64.zip"
chmod a+x "promtail-linux-amd64"

cat > config-promtail.yml <<EOF
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: '${loki_endpoint}/loki/api/v1/push'

scrape_configs:
  - job_name: journal
    journal:
      json: false
      max_age: 12h
      path: /var/log/journal
      labels:
        job: systemd-journal
    relabel_configs:
      - source_labels: ["__journal__systemd_unit"]
        target_label: "unit"

  - job_name: system
    pipeline_stages:
    - multiline:
        firstline: '^\w{3}\s+\d{1,2}\s\d{2}:\d{2}:\d{2}'
        max_wait_time: 3s
    - regex:
        expression: '^(?P<timestamp>\w{3}\s+\d{1,2}\s\d{2}:\d{2}:\d{2})\s(?P<address>[\w\-]+)\s(?P<unit>[\w\-]+)\[\d+\]:\s(?P<message>(?s:.*))$'
    - timestamp:
        source: timestamp
        format: Mar  7 17:59:06
    - labels:
        address:
        unit:
        message:
    static_configs:
    - targets:
        - localhost
      labels:
        job: system
        region: ${region}
        cloud: ${cloud}
        __path__: /var/log/*log

EOF

useradd --system promtail
setfacl -R -m u:promtail:rX /var/log
chown promtail:promtail /tmp/positions.yaml
usermod -a -G systemd-journal promtail

cat > /etc/systemd/system/promtail.service <<EOF
[Unit]
Description=Promtail service
After=network.target

[Service]
Type=simple
User=promtail
ExecStart=/usr/local/bin/promtail-linux-amd64 -config.file /usr/local/bin/config-promtail.yml

[Install]
WantedBy=multi-user.target
EOF


cat > /etc/systemd/system/health.service <<EOF
[Unit]
Description=Health Service

[Service]
ExecStart=/bin/systemd-cat --priority=info --stderr-priority=warning --identifier=health /bin/bash -c "while true; do echo '[INFO] health log'; sleep 5; done"

[Install]
WantedBy=multi-user.target
EOF

service health start
service health status

service promtail start
service promtail status
