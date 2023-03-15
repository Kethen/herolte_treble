# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=hades Recovery patch by corsicanu @ xda-developers
do.devicecheck=0
do.modules=0
do.cleanup=0
do.cleanuponabort=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
'; } # end properties

# shell variables
block=/dev/block/platform/155a0000.ufs/by-name/RECOVERY;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;

DEVICE_MODEL=$(getprop ro.omni.device)
if [ "$DEVICE_MODEL" != "gracelte" ]
then
	ui_print "this zip is for gracelte, refuse to flash on $DEVICE_MODEL"
	exit 1
fi

ui_print "twrp patcher with anykernel";

if [ -n "$(cat /etc/recovery.fstab | grep '/cache		ext4	/dev/block/bootdevice/by-name/HIDDEN')" ];
then
	ui_print "twrp is already patched, aborting";
	exit 0;
fi;

ui_print "begin twrp patching";

## AnyKernel install
dump_boot;

# begin ramdisk changes
# etc/recovery.fstab
backup_file etc/recovery.fstab;
replace_line etc/recovery.fstab "/cache		ext4	/dev/block/bootdevice/by-name/CACHE" "/cache		ext4	/dev/block/bootdevice/by-name/HIDDEN";
insert_line etc/recovery.fstab "" after "/dev/block/bootdevice/by-name/SYSTEM" "/vendor_image  emmc   /dev/block/bootdevice/by-name/CACHE     flags=backup=1";
insert_line etc/recovery.fstab "" after "/dev/block/bootdevice/by-name/SYSTEM" "/system_image  emmc   /dev/block/bootdevice/by-name/SYSTEM     flags=backup=1";

# end ramdisk changes

write_boot;
## end install

ui_print "preparing /dev/block/platform/155a0000.ufs/by-name/HIDDEN to be used as cache";
make_ext4fs /dev/block/platform/155a0000.ufs/by-name/HIDDEN;
sync;

ui_print "rebooting recovery in 10 seconds...";
sleep 10;
reboot recovery;
