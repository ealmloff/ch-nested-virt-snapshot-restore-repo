# cloud hypervisor memory snapshot restore bug when nested virt is enabled

On an Intel host with KVM and nested virtualization enabled:

    ./download.sh
    sudo ./repro.sh

download.sh fetches cloud-hypervisor and ch-remote (v53.0 release, static) and
busybox (Ubuntu busybox-static) and checks their sha256. repro.sh reads the
host's own kernel and kvm modules from /boot and /lib/modules.

Expected: after the restore, the guest prints "starting a nested VM on CPU 1"
and hits `kernel BUG at arch/x86/kvm/x86.c:505` (kvm_spurious_fault).
Seen on host kernel 6.8.0-1060-aws.
