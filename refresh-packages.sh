#!/usr/bin/env bash
pushd config/includes.chroot_after_packages/cdrom/proxmox/packages
for p in $(cat ../../../../../proxmox-packages); do if [ ! -f "${p}*" ]; then apt download $p; fi; done
popd
