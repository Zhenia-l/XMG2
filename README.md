This repository contain scripts and custom zigbee firmware for flashing Xiaomi Multimode Gateway 2 (aka DMWG03LM, DMWG04LM, lumi.gateway.mgl001).

gateway with ncp 8.0.2 firmware tested and stable in zigbee2mqtt with ember driver.

**Everything you do, you do at your own risk.**

### Prepare gateway:
1. install and configure AlexxIT gateway3 integration
2. copy content of the data folder of this repository to the /data folder on the gateway (post_init.sh is optional). The easiest way is to open ftp via AlexxIT gateway3 integration
3. chmod +x /data/bin/* /data/scripts/*

Now you can use /data/scripts/flash_{stock/custom}_firmware.sh scripts. Follow the instructions in the output of the corresponding script.
During flashing you can choose between a long-tested firmware from this repository and the latest firmware from the [darkxst/silabs-firmware-builder](https://github.com/darkxst/silabs-firmware-builder) repository.

z2m adapter settings:
- port: tcp://gateway_ip:8888
- adapter: ember
- baudrate: 115200
- flow control: hardware/software, both work

Thanks [zalatnaicsongor](https://github.com/zalatnaicsongor), his posts on some related issues were helpful.