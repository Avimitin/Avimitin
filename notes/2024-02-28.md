---
id: "2024-02-28"
aliases:
  - February 28, 2024
tags:
  - daily-notes
---

# February 28, 2024

- 上电，用网线把路由器 LAN1 和电脑连接。
- 浏览器打开 192.168.10.1，登录账户进入设置，关闭 2.4G WIFI 和 5G WIFI，设置 DHCP。
- 等待重启，然后再次登录，进入 192.168.10.1/#/home/manage/sysLog，点击日志管理，打开日志开关，日志等级设置 DEBUG
- 然后点击配置管理，点击导出文件
- 回到日志管理，ctrl-f 搜索 openssl，找到加密的命令: `openssl aes-256-cbc -pbkdf2 -k $CmDc#RaX30O0M@!$ -out /tmp/cfg_export_config_file.conf`
- 这里 `$CmDc` 和最后一个 `$` 实际上是会被 bash escape 的，需要删掉。（我怀疑这里是 unintended behaviour，有可能之后的固件他们会发现这个问题，然后给他们 quote 上）
- 反过来用 -in 和 -out 来解压下载的 .conf 文件  `openssl aes-256-cbc -d -pbkdf2 -k '#RaX30O0M@!$' -in cfg_export_config_file.conf -out cfg_export.tar.gz`，得到一个 gzip 压缩文件。
- 解压 `mkdir cfg && tar -zxf cfg_export.tar.gz -C cfg`，在 cfg 文件夹下有个 etc 文件夹。
- 编辑 /etc/shadow 删掉 root 密码，修改成 `root::19797:0:99999:7:::`
- 编辑 /etc/config/dropbeat ，将 enable 改成 `option enable '1'` 启动 ssh service。
- 用同样的方式把配置重新打包： `tar -zcf cfg_modified.tar.gz -C cfg etc`，可能会有权限报错，可以不管。
- 然后用同样的方式加密回去 `openssl aes-256-cbc -pbkdf2 -k '#RaX30O0M@!$' -in cfg_modified.tar.gz -out cfg_export_config_file_new.conf
- 上传，等待它重启完毕之后，尝试 ssh 上去： `ssh root@192.168.10.1`
- 接下来跟着这个 [commit](https://github.com/openwrt/openwrt/commit/423186d7d8b4f23aee91fca4f1774a195eba00d8) 走。
> * Flash 类型可以用 `mtdinfo /dev/mtd0` 来分辨
> * Factory 的具体位置可以 `cat /proc/mtd` 看，我的版本是 mtd3，那就 `dd if=/dev/mtd3 of=/tmp/factory.bin`，然后 `scp -O root@192.168.10.1:/tmp/factory.bin .` 拉下来备份。
> * 包装盒上会写生产批次，如果是生产日期是 1127 之后的，mtd1 可能是只读的，mtd erase BL2 会 fail。这个时候可以用[这个方法](https://github.com/openwrt/openwrt/commit/423186d7d8b4f23aee91fca4f1774a195eba00d8#commitcomment-139164795)来绕过。记得确认一下 md5sum 的值，确定是同个 block。如果这样还不行，那就先刷 immortal
> * FIP 应该暂时没什么影响，正常按照 commit message 教的来刷就好
> * tftp server 可以看 archwiki 教的来起，记得用 tftp 的 get 命令测一下确实能拉的下来文件
> * 用 ip addr add 来设置本机静态 IP 可能会在插拔电的过程中掉线，最好还是持久化。比如我用 NetworkManager，那就用 nm-connection-editor 设置。
> * NAND recovery boot 可以不要，20MB 空间还是挺宝贵的
> * sysupgrade 是在 openwrt 的 web 操作，把 `*-squashfs-sysupgrade.itb` 拖进去就行。