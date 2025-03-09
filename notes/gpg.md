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

## Renew

```bash
sudo ip link set eno1 down
sudo cryptsetup luksOpen /dev/sdc1 gnupg-secrets
sudo mkdir /mnt/encrypted-storage
sudo mount /dev/mapper/gnupg-secrets /mnt/encrypted-storage

export GNUPGHOME=$(mktemp -d -t gnupg-$(date +%Y-%m-%d)-XXXXXXXXXX)
cd $GNUPGHOME
cp -avi /mnt/encrypted-storage/gnupg_*/* $GNUPGHOME

gpg -K

export IDENTITY="Avimitin <avimitin@gmail.com>"
export EXPIRATION=1y
export KEYID=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^pub:/ { print $5; exit }')
export KEYFP=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^fpr:/ { print $10; exit }')
echo $KEYID $KEYFP

export CERTIFY_PASS="--"
echo "$CERTIFY_PASS" | gpg --batch --pinentry-mode=loopback \
  --passphrase-fd 0 --quick-set-expire "$KEYFP" "$EXPIRATION" \
  $(gpg -K --with-colons | awk -F: '/^fpr:/ { print $10 }' | tail -n "+2")
gpg -K
gpg --armor --export $KEYID | tee /tmp/$KEYID-$(date +%F).asc

export ADMIN_PIN="--"
gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
key 1
keytocard
3
$CERTIFY_PASS
$ADMIN_PIN
save
EOF

gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
key 2
keytocard
2
$CERTIFY_PASS
$ADMIN_PIN
save
EOF

gpg --command-fd=0 --pinentry-mode=loopback --edit-key $KEYID <<EOF
key 3
keytocard
1
$CERTIFY_PASS
$ADMIN_PIN
save
EOF

gpg -K

sudo cp -rT "$PWD" /mnt/encrypted-storage/gnupg_2025-03-09
sudo umount /mnt/encrypted-storage
sudo cryptsetup luksClose gnupg-secrets
rm -rf "$GNUPGHOME"
gpg --import /tmp/*.asc

sudo ip link set eno1 up
gpg --send-key $KEYID
gpg --keyserver keys.gnupg.net --send-key $KEYID
gpg --keyserver hkps://keyserver.ubuntu.com:443 --send-key $KEYID
```
