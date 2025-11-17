## Pre-install

OVH Cloud buy link: <https://eco.ovhcloud.com/en-ie/kimsufi/ks-stor/>

Chinese ID can remove VAT

## VPS2Arch

Install Script: <https://github.com/felixonmars/vps2arch>

- Issue 1: fail reboot, `/usr/bin/reboot` not found
  * Fixed by trigger IPMI reboot manually
- Issue 2: fail install when default system have multiple `if`
  * Fixed by manually editing `/etc/systemd/network/default.conf` by removing
  trailing `eno4` String, adding `DHCP=yes` to `[Network]` section.

## pacman

- Add `Color` option in `/etc/pacman.conf`

## Kernel
- Switch to `linux-lts` kernel for zfs

```bash
pacman -S linux-lts linux-lts-headers
pacman -Rs linux # avoid waiting on upgrading unused stuff

grub-mkconfig -o /boot/grub/grub.cfg
cat /boot/grub/grub.cfg | grep '$menuentry_id_option' | grep 'linux-lts'
echo "GRUB_DEFAULT='<MENU_ID>'" | tee -a /etc/default/grub
```

## File System

### Arch ZFS
Arch ZFS Repo: <https://wiki.archlinux.org/title/Unofficial_user_repositories#archzfs>

- Add repo to `/etc/pacman.conf`
- Download gpg key and rename to `pubring.gpg`
- Import key

```bash
pacman-key --init
pacman-key --import <DIR_TO_KEY>
pacman-key --lsign <KEYID>
pacman -Syu
```

### Installation

```bash
pacman -S zfs-dkms libunwind
modprobe -i -v zfs # or reboot
zfs --version
```

### Create FS

```bash
tree /dev/disk/by-id
zpool create <name> /dev/disk/by-id/... /dev/disk/by-id/... ...
zpool status
zpool list

systemctl enable zfs.target
systemctl enable zfs-import.target
systemctl enable zfs-import-cache.service
zpool set cachefile=/etc/zfs/zpool.cache tank

systemctl enable zfs-mount.service
```

## Services

### SSHD
- Fixed sshd option: set `PasswordAuthentication no` in `/etc/ssh/sshd_config`

### Network
- Add `fail2ban`:

```bash
pacman -S fail2ban
systemctl enable --now fail2ban
```

### Nginx

```bash
pacman -S nginx


cd /etc/nginx
mkdir -p sites.d
vim nginx.conf
```

- Append `/etc/nginx/nginx.conf`

```conf
# My modification

http {
  include sites.d/*.conf;

  server {
    listen 80 default_server;  # 默认站点
    listen [::]:80 default_server;
    listen 443 default_server ssl;  # 默认站点（HTTPS）
    listen [::]:443 default_server ssl;
    ssl_reject_handshake on;  # 拒绝 SSL 握手
    return 444;  # 直接关闭连接
  }
}
```

- Add `/etc/nginx/sites.d/domain.conf`

### Certs

```bash
pacman -S acme.sh
acme.sh --register-account --server zerossl --eab-kid $KID --eab-hmac-key $HMAC
acme.sh --issue --nginx -d $DOMAIN
acme.sh --install-cert -d $DOMAIN \
  --key-file /etc/nginx/certs/zerossl/$DOMAIN/key.pem \
  --fullchain-file /etc/nginx/certs/zerossl/$DOMAIN/fullchain.pem \
  --reloadcmd "systemctl force-reload nginx"
```

### QB

### Install
```bash
pacman -S qbittorrent-nox
systemctl enable --now qbittorrent-nox
```

### Create dataset for qbittorrent
```bash
# Create a new dataset w/o extend attr (SELinux, ACL...etc), w/o access time,
# w/ zstd as transparent compression, w/ 1MiB record size (block allocated)
zfs create -o xattr=off -o atime=off -o compression=zstd -o recordsize=1M tank/pt

groupadd pt
gpasswd -a qbt pt
chown -R root:pt /tank/pt
chmod -R g+w /tank/pt
# check
ls -alh /tank/pt
```

### Change port:

```bash
systemctl edit qbittorrent-nox --drop-in=webui-port
```

```text
[Service]
Environment="QBT_WEBUI_PORT=28001"
```

```bash
systemctl restart qbittorrent-nox
```

### Reverse Proxy

```nginx
server {
	listen 80;
	listen [::]:80;
	server_name example.com;
	if ($host = example.com) {
		return 301 https://$host$request_uri;
	}
	return 404;
}

server {
	http2 on;
	server_name example.com;
	listen 443 ssl;
	ssl_certificate_key /etc/nginx/certs/zerossl/example.com/key.pem;
	ssl_certificate /etc/nginx/certs/zerossl/example.com/fullchain.pem;
	ssl_session_cache shared:le_nginx_SSL:10m;
	ssl_session_timeout 1440m;
	ssl_session_tickets off;
	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_prefer_server_ciphers off;
	ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";

	location /example/ {
	    proxy_pass         http://127.0.0.1:28001/;
	    proxy_http_version 1.1;

	    # headers recognized by qBittorrent
	    proxy_set_header   Host               $proxy_host;
	    proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
	    proxy_set_header   X-Forwarded-Host   $http_host;
	    proxy_set_header   X-Forwarded-Proto  $scheme;
	}
}
```

### WireGuard

```bash
pacman -S wireguard-tools
```

- Peer A

```bash
wg genkey | (umask 0077 && tee peerA.key) | wg pubkey > peerA.pub
(umask 0077; wg genpsk > peerA-peerB.psk)
```

`/etc/systemd/network/99-wg0.netdev`

```systemd
[NetDev]
Name=wg0
Kind=wireguard
Description=WireGuard tunnel wg0

[WireGuard]
ListenPort=51871
PrivateKey=PEER_A_PRIVATE_KEY
RouteTable=main

[WireGuardPeer]
PublicKey=PEER_B_PUBLIC_KEY
PresharedKey=PEER_A-PEER_B-PRESHARED_KEY
AllowedIPs=10.0.0.2/32,fdc9:281f:04d7:9ee9::2/128
Endpoint=Peer_B_IP:51902
```

`/etc/systemd/network/99-wg0.network`

```systemd
[Match]
Name=wg0

[Network]
Address=10.0.0.1/24
Address=fdc9:281f:04d7:9ee9::1/64
```

- Peer B

```bash
wg genkey | (umask 0077 && tee peerB.key) | wg pubkey > peerB.pub
```

`/etc/systemd/network/99-wg0.netdev`

```systemd
[NetDev]
Name=wg0
Kind=wireguard
Description=WireGuard tunnel wg0

[WireGuard]
ListenPort=51902
PrivateKey=PEER_B_PRIVATE_KEY
RouteTable=main

[WireGuardPeer]
PublicKey=PEER_A_PUBLIC_KEY
PresharedKey=PEER_A-PEER_B-PRESHARED_KEY
AllowedIPs=10.0.0.1/32,fdc9:281f:04d7:9ee9::1/128
Endpoint=198.51.100.101:51871
```

`/etc/systemd/network/99-wg0.network`

```systemd
[Match]
Name=wg0

[Network]
Address=10.0.0.2/24
Address=fdc9:281f:04d7:9ee9::2/64
```

### rsync

```bash
pacman -S rsync
```
