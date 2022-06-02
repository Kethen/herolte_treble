## Treble vendor for herolte/hero2lte

<img src="https://user-images.githubusercontent.com/22017945/171661179-09231227-a1fc-46d0-96ab-b99a72dae768.png" width="300"/> <img src="https://user-images.githubusercontent.com/22017945/171661188-208eeaa5-dec3-4045-9dc9-1d96d0be66fd.png" width="300"/>


### Credits
https://github.com/8890q/ for LineageOS 19.1/18.1 device tree, kernel, hardware support, blobs

https://forum.xda-developers.com/t/treble-aosp-g930x-g935x-project_pizza-trebleport-v2-0.3956076/ for libsensor blobs

### Notes:
- I do not own a hero2lte(edge)
- I'll mostly work on this only during weekends/holidays
- and on that note the hero2lte build is not tested by myself
- for vndk30 based vendor (LineageOS 18.1), use with android 11 and up GSIs
- for vndk32 based vendor (LineageOS 19.1), use with android 12L and up GSIs

### Updates:

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
You can attempt to copy bpfloader and netd binaries from phh GSIs

a12_patcher.zip attempts to fix the above issues by creating /system_root/efs and importing bpfloader+netd from https://github.com/8890q/patches

**usb adb does not work on android 12 GSIs**
a legacy implementation of usb adb is required for this kernel, see https://review.lineageos.org/c/LineageOS/android_packages_modules_adb/+/326385

**fingerprint sensor does not work**, the vendor blob segfaults when it can't access /data/biometrics due to vndk selinux compliance

**neuralnetworks hal does not work**, perhaps it can be fix by linking it with another c/c++ library, missing a symbol that should be included in libc++ but not vndk libc++
```
phhgsi_arm64_ab:/ $ ldd /vendor/bin/hw/android.hardware.neuralnetworks@1.1-service-armnn                                                                                       
        linux-vdso.so.1 => [vdso] (0x7138c71000)
CANNOT LINK EXECUTABLE "linker64": cannot locate symbol "__cxa_demangle" referenced by "/vendor/bin/hw/android.hardware.neuralnetworks@1.1-service-armnn"...
```

**lpm/power off charging does not quite work**, /system/bin/lpm links libandroid.so (violates vndk) and looks for media assets in /system
**charging powered off will likely send you to recovery/system**
flash lpm_instasller.zip after installing gsi if power off charging is desired, it might or might not work depending on GSI (tested on phh 413)

```
$ readelf -d proprietary/bin/lpm | grep NEEDED
 0x0000000000000001 (NEEDED)             Shared library: [libcutils.so]
 0x0000000000000001 (NEEDED)             Shared library: [libbinder.so]
 0x0000000000000001 (NEEDED)             Shared library: [libutils.so]
 0x0000000000000001 (NEEDED)             Shared library: [libsuspend.so]
 0x0000000000000001 (NEEDED)             Shared library: [libhardware.so]
 0x0000000000000001 (NEEDED)             Shared library: [libandroid.so]
 0x0000000000000001 (NEEDED)             Shared library: [libmaet.so]
 0x0000000000000001 (NEEDED)             Shared library: [libsxqk_skia.so]
 0x0000000000000001 (NEEDED)             Shared library: [liblog.so]
 0x0000000000000001 (NEEDED)             Shared library: [libc++.so]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so]
 0x0000000000000001 (NEEDED)             Shared library: [libm.so]
 0x0000000000000001 (NEEDED)             Shared library: [libdl.so]
```

**Wifi tethering does not work on phh GSIs**
https://github.com/phhusson/vendor_hardware_overlay/tree/pie/Tethering conflicts with our Tethering overlay
flash phh_wifitethering_patcher.zip after installing phh GSIs

### Installation

There are two requirements for testing this treble build:
1. A /vendor partition that is at least 250 MB
2. A recovery that is aware of the /vendor partition


You can fulfill these requirements by:
1. Install twrp normally
2. Flash heroxlte_CreateVendor_2.0.zip from https://forum.xda-developers.com/t/treble-aosp-g930x-g935x-project_pizza-trebleport-v2-0.3956076/ , it will create a ~400 MiB vendor partition and patch the current twrp you have

Or:
- Modify the partition table manually and add a 250 MB partition named VENDOR, build/modify twrp manually to support the new partition

Once that's fulfilled, flash the zip in this release, herolte for flat and hero2lte for edge. The zips comes with an install of LineageOS 19.1/18.1. After Installing the zip you can write any system.img of your choice

After writing system.img, flash lpm_installer.zip if poweroff charging is needed. Note that that has been tested on phh v413 and google android 12 gsi

a12_patcher.zip replaces /system/bin/bpfloader and /system/bin/netd with patched versions, also creates /system_root/efs if required, allowing google android 12 gsi to boot

a11_patcher.zip creates /system_root/efs if required

deskclock_powersaving.zip installs com.android.deskclock_whitelist.xml so that alarm clock works consistently in vanilla aosp
https://github.com/LineageOS/android_packages_apps_DeskClock/commit/8dd096c4cfb647960be1695a57246727878b8c8d

phh_wifitethering_patcher.zip removes system/product/overlay/treble-overlay-tethering.apk from phh GSIs so that wifi hotspot works

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
Please use the issue tracker on this repository

### Downloads
https://github.com/Kethen/herolte_treble/releases
