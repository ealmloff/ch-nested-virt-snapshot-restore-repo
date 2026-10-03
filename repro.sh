#!/bin/bash
# Run ./download.sh first: needs static cloud-hypervisor, ch-remote and busybox in the current directory.
set -eux
k=$(uname -r)
mkdir -p root/dev
cp guest-init.sh root/init
cp cloud-hypervisor busybox /boot/vmlinuz-$k root/
cp /lib/modules/$k/kernel/{virt/lib/irqbypass,arch/x86/kvm/kvm,arch/x86/kvm/kvm-intel}.ko root/
mv root/vmlinuz-$k root/vmlinuz
(cd root && find . | cpio -o -H newc > ../initramfs)

./cloud-hypervisor -v --api-socket api.sock --cpus boot=2,nested=on --memory size=2G \
    --kernel root/vmlinuz --initramfs initramfs \
    --cmdline "console=ttyS0 rdinit=/init" --serial tty --console off &
sleep 6
./ch-remote --api-socket api.sock pause
./ch-remote --api-socket api.sock snapshot file://$PWD
kill $!
wait
./cloud-hypervisor -v --restore source_url=file://$PWD,resume=true
