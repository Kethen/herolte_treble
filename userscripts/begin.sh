#!/bin/bash
set -x
checkout_project () {
	(
		if [ -d "$1" ]
		then
			cd "$1"
			git checkout .
		fi
	)
}
for f in *
do
	checkout_project "$f/prebuilts/prebuiltapks"
	checkout_project "$f/prebuilts/eapks"
	checkout_project "$f/packages/apps/Dialer"
	checkout_project "$f/lineage-sdk"
	checkout_project "$f/build"
	checkout_project "$f/system/bpf"
	checkout_project "$f/system/netd"

	if [ "$f" == "CM_14_1" ]
	then
		checkout_project "$f/frameworks/base"
		checkout_project "$f/hardware/ti/omap4"
	fi
	if [ -e $f/vendor/foss ]
	then
		rm -rf $f/vendor/foss
	fi
done

