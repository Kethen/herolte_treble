## Treble vendor for herolte/hero2lte

<img src="https://user-images.githubusercontent.com/22017945/171661179-09231227-a1fc-46d0-96ab-b99a72dae768.png" width="300"/> <img src="https://user-images.githubusercontent.com/22017945/171661188-208eeaa5-dec3-4045-9dc9-1d96d0be66fd.png" width="300"/>

https://gitlab.com/hackintosh5/TrebleInfo

### Credits
https://github.com/8890q/ for LineageOS 19.1/18.1 device tree, kernel, hardware support, blobs

https://forum.xda-developers.com/t/treble-aosp-g930x-g935x-project_pizza-trebleport-v2-0.3956076/ for libsensor blobs

https://github.com/osm0sis/ for anykernel, used for the twrp patching zip

### Special thanks
https://github.com/ExpressLuke for hero2lte testing

https://github.com/00p513-dev for suggesting using squashfs for vendor partition, making it possible to skip partition table modding

https://github.com/phhusson for looking into the double tap to wake issues with phh GSI

### Notes:
- I do not own a hero2lte(edge)
- I'll mostly work on this only during weekends/holidays
- and on that note the hero2lte build is not tested by myself
- for vndk30 based vendor (LineageOS 18.1), use with android 11 and up GSIs
- for vndk32 based vendor (LineageOS 19.1), use with android 12L and up GSIs
- 2022-06-12 the CACHE partition is now used as vendor, the HIDDEN patition is now used as cache, no more partition table mods required

### Updates:

- 2022-06-24

lpm_installer.zip should work with Phh and Andy Yan GSIs better now

- 2022-06-18

vndk30 prop changes, might help booting exotic GSIs

- 2022-06-13

android 12 data usage meter now works with a12_patcher.zip

- 2022-06-12

fixed neural network api hal

fixed fingerprint sensor

switched vendor image to squashfs, no CreateVendor required anymore with it's small size

new twrp patcher zip, should no longer cause "twrp is stuck after flashing CreateVendor"

bigger GSIs should fit better now with the original ~4.5GB SYSTEM partition; device native roms can be used without RevertVendor

- 2022-05-31

fixed wifi tethering

vndk32: rebased on 2022-05-26 12L build from ivan

phh_wifitethering_patcher.zip for wifi hotspot on phh GSIs

- 2022-05-26

added vndk32 based release

lpm_installer.zip for offline charging

fixed keystore errors on android 12 GSIs, lock screens work now

- 2022-02-15

rebased on February build from 8890q

January android updates

- 2021-12-16

install libaudioroute into /vendor/lib

December android updates

- 2021-12-10

move properties to /vendor

### Tested GSIs
- vndk30

https://github.com/phhusson/treble_experimentations/releases/tag/v313 (vanilla/bvS)

https://github.com/phhusson/treble_experimentations/releases/tag/v413 (vanilla/bvS)

https://developer.android.com/topic/generic-system-image/releases (android 12 gsi, with a12_patch.zip flashed after)

- vndk32

https://github.com/phhusson/treble_experimentations/releases/tag/v413 (vanilla/bvS)

https://developer.android.com/topic/generic-system-image/releases (android 12 gsi, with a12_patch.zip flashed after)

**important: system as root builds, you'd want ab build GSIs**

### Known issues:

**some GSIs like official google GSIs lacks the /efs mount point, it has to be added manually or it will boot loop at samsung logo failing to mount /efs**

**some android 12 GSIs does not boot due to the lack of ebpf on the 3.18 kernel, android 12 GSIs needs to have patched bpfloader and netd, see below**

https://github.com/8890q/patches

https://github.com/phhusson/platform_system_bpf/commit/c81966c23d79241458ebf874cfa8662f44705549

https://github.com/phhusson/platform_system_netd/commit/3a6efa1ff3717a613d1ba4a0eff5e751262d1074

**data usage stays at 0 MB used on android 12 GSIs, because ebpf is used for metering**

a12_patcher.zip attempts to fix the above issues by creating /system_root/efs and importing bpfloader+netd from https://github.com/8890q/patches

a11_patcher.zip creates /system_root/efs if required

**usb adb does not work on android 12 GSIs**

a legacy implementation of usb adb is required for this kernel, see https://review.lineageos.org/c/LineageOS/android_packages_modules_adb/+/326385

as a workaround, disable usb adb and use wifi adb

**lpm/power off charging does not work**

lpm related blobs sadly has to be installed on /system, flash lpm_instasller.zip after installing gsi if power off charging is desired, it might or might not work depending on GSI (tested on phh 413 and 313)

**Wifi tethering does not work on phh GSIs**

https://github.com/phhusson/vendor_hardware_overlay/tree/pie/Tethering conflicts with our Tethering overlay

flash phh_wifitethering_patcher.zip after installing phh GSIs

**Alarm clock not working on aosp GSI**

it should be fixed on phh 414 and up, it is not a vendor issue. If you are using an older aosp GSI, flash deskclock_powersaving.zip to fix that. See https://github.com/LineageOS/android_packages_apps_DeskClock/commit/8dd096c4cfb647960be1695a57246727878b8c8d

### Installation
1. If you are using the old partition table mod zip heroxlte_CreateVendor_2.0.zip from older versions, first flash heroxlte_RevertVendor_2.0.zip, or revert your partition table other ways such as odin. Skip this step if you have never touched your partition table
2. Install the newest twrp from https://eu.dl.twrp.me/herolte/ (s7) or https://eu.dl.twrp.me/hero2lte/ (s7 edge)
3. Flash twrp_patcher.zip to enable system.img flashing, it'll reboot to recovery once it's done, tested on 3.6.2_9-0 but newer versions should work unless recovery.fstab changes
4. Flash Lineage 19.1 for android 12.1(api level 32) GSIs, flash Lineage 18.1 for android 11(api level 30) and 12(api level 31) GSIs, herolte for s7 and hero2lte for s7edge
5. Flash the system.img of your choice
6. If you are using a phh patched GSI, flash phh_wifitethering_patcher.zip
7. If you are using an android 12/12L GSI, flash a12_patcher.zip
8. If you are using an android 11 GSI, flash a11_patcher.zip
9. Flash lpm_installer.zip to enable poweroff charging
10. If you are using an aosp GSI that is not phh patched or older than phh 414, flash deskclock_powersaving.zip to fix alarm clock
11. If you are using phh GSI version <= 414, flash phh_dt2w_patcher.zip to fix double tap to wake

### Undo twrp_patcher.zip and revert to device native roms
**This is not required for using device native roms, however OTA updates might require this**
1. Flash the newest twrp again
2. Format cache using wipe -> select cache -> repair or change file system -> change file system -> ext4
3. Flash a device native rom

### Building
lineage_build_herolte_vendor_part, lineage_build_hero2lte_vendor_part, lineage_build_herolte_vendor_part_18.1 and lineage_build_hero2lte_vendor_part_18.1 builds lineageos along with treble vendor using https://github.com/lineageos4microg/docker-lineage-cicd

you'll need ~15GB of free ram, ~300GB free disk space and podman

```
# create directories
mkdir src
mkdir zips
mkdir logs
mkdir ccache

# builds lineage 19.1 along with vndk32 for herolte (s7 flat exynos)
bash lineage_build_herolte_vendor_part 
```

### Reporting issues besides the known ones:
You can report them over https://github.com/Kethen/herolte_treble/issues

### Downloads
https://github.com/Kethen/herolte_treble/releases
