#!/bin/bash
if [ "$1" == "lineage_x86_64-eng" ]
then
	source build/envsetup.sh
	echo packing avd image
	if mka -j $(nproc) sdk_addon
	then
		cp out/host/linux-x86/sdk_addon/lineage-eng.root-linux-x86-img.zip /srv/zips/lineage_x86_64-eng/lineage-eng.$(date "+%Y%m%d").root-linux-x86-img.zip
	else
		echo failed packing adv image
	fi
fi
