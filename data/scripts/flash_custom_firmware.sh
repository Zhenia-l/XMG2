#!/bin/sh
export PATH=$PATH:/data/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/lib

echo "Choose firmware"
echo "1) Use long-tested NCP 8.0.2 firmware from this repository"
echo "2) Use latest NCP firmware from 'darkxst/silabs-firmware-builder' repository"

while true; do
    read choice
    case $choice in
      1)
        firmware_url=https://github.com/Zhenia-l/XMG2/raw/refs/heads/main/firmware/lumi-gateway-mgl001_zigbee_ncp_8.0.2.0_115200.gbl
        break;;
      2)
        firmware_url=$(curl --insecure --silent https://api.github.com/repos/darkxst/silabs-firmware-builder/releases/latest | grep browser_download_url | grep 'lumi-gateway-mgl001_zigbee_ncp' | cut -d '"' -f 4)
        [ $(echo $firmware_url | grep -o https | wc -l) -gt 1 ] && { echo "Can't get the firmware download link. Use the tested version from this repository or create an isssue."; exit 1; }
        echo "Founded firmware: ${firmware_url##*/}"
        echo "Type yes, if you want to use it."
        read choice
        [ $choice != 'yes' ] && { echo "That was not a yes. Exiting."; exit 1; }
        break;;
      *) echo "Incorrect input. Try again."
    esac
done
curl --location --insecure --silent --output /tmp/firmware.gbl $firmware_url
pkill -9 -f 'app_monitor.sh'
pkill -9 -f 'openmiio_agent'
/data/openmiio_agent --zigbee.tcp=8889 >/dev/null &
sleep 3
lsof | grep /dev/ttyS1 && { echo "Something still using /dev/ttyS1, manually kill the remaining processes"; exit 1; } || true
zigbee_isp.sh 0 && zigbee_reset.sh 1 && zigbee_reset.sh 0
sleep 1
echo 1 > /dev/ttyS1
sx -X /tmp/firmware.gbl </dev/ttyS1 >/dev/ttyS1
rm -f /tmp/firmware.gbl
echo 'Firmware flashing is complete, now reboot the gateway. You can also optionally add the "post_init.sh" script'