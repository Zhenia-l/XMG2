#!/bin/sh
# this script will be executed instead of 'fw_manager.sh -r' command
fw_manager.sh -r #DO NOT DELETE, without this the gateway will not load correctly and you will lose access via telnet, and it will NOT be possible to reset it by pressing the button 
mount --bind /bin/busybox /bin/mZ3GatewayHost_MQTT #mZ3GatewayHost_MQTT does not work with custom zigbee firmware, but appmonitor will try to start it every minute. Mount busybox binary instead
/data/openmiio_agent miio cache central mqtt --zigbee.tcp=8888 >/tmp/openmiio_agen.log & #run openmiio_agent without z3 key before gateway3 integration runs it. Z3GatewayHost does not work with custom zigbee firmware
passwd -d root &>/dev/null #reset root password
telnetd #run telnetd daemon