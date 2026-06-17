define CD_INFO
RELEASE='9.2'
ISORELEASE='1'
ISONAME='proxmox-ve'
PRODUCT='pve'
PRODUCTLONG='Proxmox VE'
endef

export CD_INFO

CDROM := config/includes.chroot_after_packages/cdrom

all: $(CDROM)/pve-base.squashfs config/includes.chroot_after_packages/.cd-info live-image-loong64.iso

live-image-loong64.iso: lb-clean packages
	lb config
	yes | sudo lb build

packages:
	./refresh-packages.sh

$(CDROM)/pve-base.squashfs:
	mmdebstrap --include=ca-certificates,debian-loong64-non-official-archive-keyring,pve-loong64-archive-keyring,proxmox-ve,grub-efi-loong64,proxmox-grub,e2fsprogs,zfsutils-linux,btrfs-progs,xfsprogs,lvm2,nano,vim --skip=output/dev --variant=minbase stable $@ /etc/apt/sources.list /etc/apt/sources.list.d/pve-loong64.sources
	unsquashfs -l $@ | wc -l > $(CDROM)/proxmox/pve-base.cnt

config/includes.chroot_after_packages/.cd-info:
	echo "$$CD_INFO" > $@

clean: lb-clean
	rm -vf config/includes.chroot_after_packages/.cd-info

squashfs-clean:
	rm -vf $(CDROM)/*.squashfs
	rm -vf $(CDROM)/proxmox/*.cnt

packages-clean:
	rm -rfv $(CDROM)/proxmox/packages/*.deb

lb-clean:
	sudo lb clean

lb-purge: squashfs-clean packages-clean
	sudo lb clean --purge

.PHONY: lb packages clean squashfs-clean lb-clean lb-purge
