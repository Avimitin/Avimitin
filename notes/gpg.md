---
id: gpg
aliases:
  - gpg
tags: []
---

# gpg
## How to sign others keys

```bash
# find the usb driver
sudo fdisk -l

# decrypt the luks device
sudo cryptsetup luksOpen /dev/sdc1 secret # secret is customizable, it is just device name

# mount the usb driver
sudo mount /dev/mapper/secret /mnt/gpgDevice

# set gpg home
set -x GNUPGHOME /mnt/gpgDevice

# receive the gpg key
set otherspubkey "aaabbbcccdddeeefffggg"
gpg --recv-keys $otherspubkey

# sign
gpg --sign-key --ask-cert-level $otherspubkey

# send it back to keyserver
gpg --send-key $otherspubkey

# send it to other keyserver
gpg --keyserver keys.openpgp.org --send-key $otherspubkey

# clean the database
gpg --delete-key $otherspubkey

# unmount the usb driver
sudo umount /mnt/gpgDevice

# encrypt the usb driver
sudo cryptsetup luksClose secret
```
