#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

depends() {
    echo systemd network ignition coreos-live
}

install_ignition_unit() {
    local unit="$1"; shift
    local target="${1:-ignition-complete.target}"; shift
    local instantiated="${1:-$unit}"; shift
    inst_simple "$moddir/$unit" "$systemdsystemunitdir/$unit"
    # note we `|| exit 1` here so we error out if e.g. the units are missing
    # see https://github.com/coreos/fedora-coreos-config/issues/799
    systemctl -q --root="$initdir" add-requires "$target" "$instantiated" || exit 1
}

install() {
    # inst_multiple \
    #     basename \
    #     diff \
    #     lsblk \
    #     sed \
    #     grep \
    #     sgdisk \
    #     uname

    # inst_simple "$moddir/coreos-diskful-generator" \
    #     "$systemdutildir/system-generators/coreos-diskful-generator"

    # inst_script "$moddir/coreos-gpt-setup.sh" \
    #     "/usr/sbin/coreos-gpt-setup"

    # # This has to work only on diskful systems during firstboot.
    # # coreos-diskful-generator will create a symlink
    # inst_simple "$moddir/80-coreos-boot-disk.rules" \
    #     "/usr/lib/coreos/80-coreos-boot-disk.rules"

    # inst_script "$moddir/coreos-disk-contains-fs.sh" \
    #     "/usr/lib/udev/coreos-disk-contains-fs"

    # inst_script "$moddir/coreos-ignition-setup-user.sh" \
    #     "/usr/sbin/coreos-ignition-setup-user"

    # inst_script "$moddir/coreos-post-ignition-checks.sh" \
    #     "/usr/sbin/coreos-post-ignition-checks"
    
    # install_ignition_unit coreos-post-ignition-checks.service

    # # For consistency tear down the network and persist multipath between the initramfs and
    # # real root. See https://github.com/coreos/fedora-coreos-tracker/issues/394#issuecomment-599721763
    # inst_script "$moddir/coreos-teardown-initramfs.sh" \
    #     "/usr/sbin/coreos-teardown-initramfs"
    # install_ignition_unit coreos-teardown-initramfs.service

    # # units only started when we have a boot disk
    # # path generated by systemd-escape --path /dev/disk/by-label/root
    # install_ignition_unit coreos-gpt-setup.service ignition-diskful.target

    # # dracut inst_script doesn't allow overwrites and we are replacing
    # # the default script placed by Ignition
    # binpath="/usr/sbin/ignition-kargs-helper"
    # cp "$moddir/coreos-kargs.sh" "$initdir$binpath"
    # install_ignition_unit coreos-kargs-reboot.service

    # inst_script "$moddir/coreos-boot-edit.sh" \
    #     "/usr/sbin/coreos-boot-edit"
    # # Only start when the system has disks since we are editing /boot.
    # install_ignition_unit "coreos-boot-edit.service" \
    #     "ignition-diskful.target"

    # install_ignition_unit coreos-ignition-unique-boot.service ignition-diskful.target
    # install_ignition_unit coreos-unique-boot.service ignition-diskful.target
    # install_ignition_unit coreos-ignition-setup-user.service

    # # IBM Secure Execution. Ignition config for reencryption of / and /boot
    # inst_simple "$moddir/01-secex.ign" /usr/lib/coreos/01-secex.ign
}
