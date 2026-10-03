#!/bin/bash
# Fetches the static binaries repro.sh needs into the current directory.
set -eux
ch=https://github.com/cloud-hypervisor/cloud-hypervisor/releases/download/v53.0
deb=busybox-static_1.30.1-7ubuntu3.1_amd64.deb
curl -fL -o cloud-hypervisor $ch/cloud-hypervisor-static
curl -fL -o ch-remote $ch/ch-remote-static
curl -fL -o $deb http://archive.ubuntu.com/ubuntu/pool/main/b/busybox/$deb
sha256sum -c <<SUMS
448af3d4e59b22c2987f7df94c213ad40fb53a10d437e42b5ee6c4fce7c29ecc  cloud-hypervisor
13f32ba952e6791fd901f2279be2055fbacc64005f96c42a8e90d58860df84a7  ch-remote
833b81ad44c4e201059e1bbb1dab285d5d0488736db169adfaa677fd953baae6  $deb
SUMS
ar p $deb data.tar.zst | tar --zstd -xO ./bin/busybox > busybox
rm $deb
echo "b3c1009e1b5c927e537487c80639cdf404f69e3eb49371d9be5d841672be3ff9  busybox" | sha256sum -c
chmod +x cloud-hypervisor ch-remote busybox
