### Mounting

Built treble boot.img and vendor.img support booting from sdcard

vendor.img (ext4/squashfs) is mounted in decreasing priority of this list
- `/dev/block/platform/15740000.dwmmc2/by-name/VENDOR_SD`, a partition on sdcard with partlabel `VENDOR_SD`
- `/dev/block/platform/155a0000.ufs/by-name/CACHE`, a partition on internal storage with partlabel `CACHE`

system.img (ext4/squashfs) is mounted in decreasing priority of this list
- `/dev/block/platform/15740000.dwmmc2/by-name/SYSTEM_SD`, a partition on sdcard with partlabel `SYSTEM_SD`
- `/dev/block/platform/155a0000.ufs/by-name/SYSTEM`, a partition on internal storage with partlabel `SYSTEM`

userdata (ext4) is mounted in decreasing priority of this list
- `/dev/block/platform/15740000.dwmmc2/by-name/USERDATA_SD`, a partition on sdcard with partlabel `USERDATA_SD`
- `/dev/block/platform/155a0000.ufs/by-name/USERDATA`, a partition on internal storage with partlabel `USERDATA`

to enable full disk encryption on `USERDATA_SD`, `/block/platform/15740000.dwmmc2/by-name/USERDATA_ENC_SD` is required for encryption metadata
