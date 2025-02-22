#!/bin/sh
export PATH=$PATH:/data/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/lib

pkill -9 -f 'app_monitor.sh'
pkill -9 -f 'openmiio_agent'
/data/openmiio_agent --zigbee.tcp=8889 >/dev/null &
sleep 3
lsof | grep /dev/ttyS1 && { echo "Something still using /dev/ttyS1, manually kill the remaining processes"; exit 1; } || true
curl --location --insecure --silent --output /data/zigbee_host/ota-files/Network-Co-Processor.zip https://github.com/Zhenia-l/XMG2/raw/refs/heads/main/firmware/Network-Co-Processor.zip
unzip -q -o /data/zigbee_host/ota-files/Network-Co-Processor.zip -d /data/zigbee_host/ota-files/ || exit 1
echo -e '------------------\n------------------'
echo 'The output should contain "transfer", and "ezsp ver 0x07 stack type 0x02 stack ver. [6.6.6 GA build 218]"'
echo 'this means that the flashing of the stock zigbee firmware was successful, delete "post_init.sh" script and reboot the gateway'
echo -e '------------------\n------------------'
umount /bin/mZ3GatewayHost_MQTT >/dev/null 2>&1
sleep 15
zigbee_isp.sh 0 && zigbee_reset.sh 1 && zigbee_reset.sh 0
mZ3GatewayHost_MQTT -n0 -d /data/zigbee_host/ -p /dev/ttyS1 -r c -l 1 -t 4 &
sleep 3.5
zigbee_isp.sh 0 && zigbee_reset.sh 1 && zigbee_reset.sh 0