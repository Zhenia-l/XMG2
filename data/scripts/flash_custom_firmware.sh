#!/bin/sh
export PATH=$PATH:/data/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/lib

pkill -9 -f 'app_monitor.sh'
pkill -9 -f 'openmiio_agent'
/data/openmiio_agent --zigbee.tcp=8889 >/dev/null &
sleep 3
lsof | grep /dev/ttyS1 && { echo "Something still using /dev/ttyS1, manually kill the remaining processes"; exit 1; } || true
curl --location --insecure --silent --output /tmp/firmware.gbl https://github.com/darkxst/silabs-firmware-builder/releases/latest/download/lumi-gateway-mgl001_zigbee_ncp_8.0.2.0_115200.gbl
zigbee_isp.sh 0 && zigbee_reset.sh 1 && zigbee_reset.sh 0
sleep 1
echo 1 > /dev/ttyS1
sx -X /tmp/firmware.gbl </dev/ttyS1 >/dev/ttyS1
rm -f /tmp/firmware.gbl
echo 'The firmware is complete, now reboot the gateway. You can also optionally add the "post_init.sh" script'