#!/busybox sh
/busybox mount -t devtmpfs dev /dev
for m in irqbypass kvm kvm-intel; do /busybox insmod /$m.ko; done
# VMXON on both CPUs, VMCS only on CPU 0
/busybox taskset 1 /cloud-hypervisor --kernel /vmlinuz --console off &
/busybox sleep 10
echo "guest: starting a nested VM on CPU 1"
/busybox taskset 2 /cloud-hypervisor --kernel /vmlinuz --console off
