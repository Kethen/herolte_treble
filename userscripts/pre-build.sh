#!/bin/bash
set -x
if false
then
	# replace default wallpaper
	convert /root/userscripts/Leaf.jpg vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-hdpi/default_wallpaper.png
	cp vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-hdpi/default_wallpaper.png vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-nodpi/default_wallpaper.png
	cp vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-hdpi/default_wallpaper.png vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-sw600dp-nodpi/default_wallpaper.png
	cp vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-hdpi/default_wallpaper.png vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-sw720dp-nodpi/default_wallpaper.png
	cp vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-hdpi/default_wallpaper.png vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-xhdpi/default_wallpaper.png
	cp vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-hdpi/default_wallpaper.png vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-xxhdpi/default_wallpaper.png
	cp vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-hdpi/default_wallpaper.png vendor/lineage/overlay/common/frameworks/base/core/res/res/drawable-xxxhdpi/default_wallpaper.png

	# add weather service to lineage sdk..?
	sed -i 's/<item>org.lineageos.platform.internal.PerformanceManagerService<\/item>/<item>org.lineageos.platform.internal.PerformanceManagerService<\/item><item>org.lineageos.platform.internal.LineageWeatherManagerService<\/item>/g' lineage-sdk/lineage/res/res/values/config.xml
fi

# add bromite to additional repo
if [ -d prebuilts/prebuiltapks ]
then
    OLD_IFS=$IFS
    IFS=$'\n'
    echo -n > /tmp/additional_repos.xml
    cat prebuilts/prebuiltapks/additional_repos.xml/additional_repos.xml | while read -r LINE
    do
        if [ -n "$(echo $LINE | grep '</string-array>')" ]
        then
            echo '
    <!-- name -->
    <item>Bromite official F-Droid repository</item>
    <!-- address -->
    <item>https://fdroid.bromite.org/fdroid/repo</item>
    <!-- description -->
    <item>The repository of Bromite</item>
    <!-- version -->
    <item>21</item>
    <!-- enabled -->
    <item>1</item>
    <!-- push requests -->
    <item>ignore</item>
    <!-- pubkey -->
    <item>3082036d30820255a00302010202041dcb268e300d06092a864886f70d01010b05003066310b30090603550406130244453110300e06035504081307556e6b6e6f776e310f300d060355040713064265726c696e3110300e060355040a130742726f6d6974653110300e060355040b130742726f6d6974653110300e0603550403130763736167616e353020170d3138303131393037323135375a180f32303638303130373037323135375a3066310b30090603550406130244453110300e06035504081307556e6b6e6f776e310f300d060355040713064265726c696e3110300e060355040a130742726f6d6974653110300e060355040b130742726f6d6974653110300e0603550403130763736167616e3530820122300d06092a864886f70d01010105000382010f003082010a0282010100b5a9231a3d1e4dabdb041daf5978fc2818b15a7e3381700a73ec8616edd22c4185d550796895b070c1f1548e79c87ffc33678d9c93f40644a275f2a03d5726d6c93f1ab344b3dba4e6c5a877d6f23b933941642618fd9111e4dde89d0155555a329d8c667a9e4774aede9c05ceb4b04ea206c9ff1d90f484cfb89f8fbf76f8479136ba2fe284502bb9487ea227cf0738777e30534ebd2ebc3a9bb27b1ccd0a6d16084ac58c8988f4db9420f9d4ebb5d5adee36dd723ee1b56d1e6322682ddf74face374569cea443665a9716bf51153f1503e2609d57d89d630a07448112a52bbd216bea0d9a7556845ce379cb82c35f341c2661d4e421a3e2cf59bb4c172bed0203010001a321301f301d0603551d0e04160414b96a0677b5bbc0cc90d6939d8e232fd746074d1d300d06092a864886f70d01010b050003820101000ee2c3a78acfe4fc1c8a4a0e80dc5f56308e7f49533b8216edb42e7b0bceb78efcfa20d7112b62374b012ecb4d9a247db0278ad06c90ef50855f416240e233442be6fdbf1ec253b716b59b3f72c02708dfa8db94ccae5c58fcb6ec1023dfedf62f85737f9b385055dededd8cfa3da97d5d20ad2567ab3c1dc22168235daa6eb97c7fa75a10bf1fd763a82eaa3adae44e20022847074386bfe5d7d1394d2ad0ce1b4b862e89a0105a08e219b8a4e0bad9f30657d5aa8908bb741ececccd7cb27f471148ed75148395887c3387a593646b9fab62776011573e89ddf242f190a2f72cd7b36e2e724dc79cc6c6ca43a392e3a0a720a732fccf1ab12ade2e9a020efc</item>
' >> /tmp/additional_repos.xml
        fi
        echo "$LINE" >> /tmp/additional_repos.xml
    done
    IFS=$OLD_IFS
    cp /tmp/additional_repos.xml prebuilts/prebuiltapks/additional_repos.xml/additional_repos.xml
fi

# remove e components
if [ -d "prebuilts/eapks" ]
then
	(
		cd prebuilts/eapks
		rm -r $(ls | grep -Ev 'OpenWeatherMapWeatherProvider|BlissLauncher')
	)
fi

# Set up e support  permission
rm -rf vendor/e_permissions
mkdir -p vendor/e_permissions/etc
echo '<?xml version="1.0" encoding="utf-8"?>
<exceptions>
<exception package="foundation.e.blisslauncher">
	<!-- External storage -->
	<permission name="android.permission.READ_EXTERNAL_STORAGE" fixed="false"/>
</exception>
</exceptions>

' > vendor/e_permissions/etc/e_exceptions.xml
echo '<?xml version="1.0" encoding="utf-8"?>
<permissions>
<privapp-permissions package="com.android.systemui">
    <permission name="android.permission.BATTERY_STATS"/>
    <permission name="android.permission.BIND_APPWIDGET"/>
    <permission name="android.permission.BLUETOOTH_PRIVILEGED"/>
    <permission name="android.permission.CHANGE_COMPONENT_ENABLED_STATE"/>
    <permission name="android.permission.CHANGE_DEVICE_IDLE_TEMP_WHITELIST"/>
    <permission name="android.permission.CHANGE_OVERLAY_PACKAGES"/>
    <permission name="android.permission.CONTROL_KEYGUARD_SECURE_NOTIFICATIONS"/>
    <permission name="android.permission.CONTROL_REMOTE_APP_TRANSITION_ANIMATIONS"/>
    <permission name="android.permission.CONTROL_VPN"/>
    <permission name="android.permission.DUMP"/>
    <permission name="android.permission.GET_APP_OPS_STATS"/>
    <permission name="android.permission.INTERACT_ACROSS_USERS"/>
    <permission name="android.permission.MANAGE_DEBUGGING"/>
    <permission name="android.permission.MANAGE_SENSOR_PRIVACY"/>
    <permission name="android.permission.MANAGE_USB"/>
    <permission name="android.permission.MANAGE_USERS"/>
    <permission name="android.permission.MASTER_CLEAR"/>
    <permission name="android.permission.MEDIA_CONTENT_CONTROL"/>
    <permission name="android.permission.MODIFY_DAY_NIGHT_MODE"/>
    <permission name="android.permission.MODIFY_PHONE_STATE"/>
    <permission name="android.permission.MOUNT_UNMOUNT_FILESYSTEMS"/>
    <permission name="android.permission.CONNECTIVITY_INTERNAL"/>
    <permission name="android.permission.OBSERVE_NETWORK_POLICY"/>
    <permission name="android.permission.OVERRIDE_WIFI_CONFIG"/>
    <permission name="android.permission.READ_DREAM_STATE"/>
    <permission name="android.permission.READ_FRAME_BUFFER"/>
    <permission name="android.permission.READ_NETWORK_USAGE_HISTORY"/>
    <permission name="android.permission.READ_PRIVILEGED_PHONE_STATE"/>
    <permission name="android.permission.REAL_GET_TASKS"/>
    <permission name="android.permission.RECEIVE_MEDIA_RESOURCE_USAGE"/>
    <permission name="android.permission.START_ACTIVITIES_FROM_BACKGROUND" />
    <permission name="android.permission.START_ACTIVITY_AS_CALLER"/>
    <permission name="android.permission.START_TASKS_FROM_RECENTS"/>
    <permission name="android.permission.STATUS_BAR"/>
    <permission name="android.permission.STOP_APP_SWITCHES"/>
    <permission name="android.permission.SUBSTITUTE_NOTIFICATION_APP_NAME"/>
    <permission name="android.permission.TETHER_PRIVILEGED"/>
    <permission name="android.permission.UPDATE_APP_OPS_STATS"/>
    <permission name="android.permission.USE_RESERVED_DISK"/>
    <permission name="android.permission.WATCH_APPOPS"/>
    <permission name="android.permission.WRITE_DREAM_STATE"/>
    <permission name="android.permission.WRITE_MEDIA_STORAGE"/>
    <permission name="android.permission.WRITE_SECURE_SETTINGS"/>
    <permission name="android.permission.WRITE_EMBEDDED_SUBSCRIPTIONS"/>
    <permission name="android.permission.CONTROL_DISPLAY_COLOR_TRANSFORMS" />
</privapp-permissions>
</permissions>

' > vendor/e_permissions/etc/e_permissions.xml

echo '<?xml version="1.0" encoding="utf-8"?>
<permissions>
<feature name="org.lineageos.weather" />
</permissions>

' > vendor/e_permissions/etc/org.lineageos.weather.xml

echo '
LOCAL_PATH := $(my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := e_permissions.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/permissions
LOCAL_SRC_FILES := etc/e_permissions.xml
LOCAL_REQUIRED_MODULES := org.lineageos.weather.xml
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := e_exceptions.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/default-permissions
LOCAL_SRC_FILES := etc/e_exceptions.xml
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := org.lineageos.weather.xml
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/permissions
LOCAL_SRC_FILES := etc/org.lineageos.weather.xml
include $(BUILD_PREBUILT)' > vendor/e_permissions/Android.mk

# Set up /vendor/foss if exists
if [ -d "vendor/foss" ]
then
  (
    echo ">> [$(date)] bootstraping vendor/foss"
    cd vendor/foss
    for cmd in unzip xmlstarlet aapt
    do
        if [ -z "$(command -v $cmd)" ]
        then
            apt-get update; apt-get install -y $cmd
        fi
    done
    bash update.sh
  )
  if [ -d "prebuilts/prebuiltapks" ]
  then
    rm -rf prebuilts/prebuiltapks/FDroidPrivilegedExtension
    rm -rf prebuilts/prebuiltapks/FDroid
  fi
fi

# Remove packages by build target name
if ! [ -z "$REMOVE_PACKAGES" ]; then
  mkdir -p vendor/remove_unused_module
  echo '
include $(CLEAR_VARS)
LOCAL_MODULE := remove_unused_module
LOCAL_MODULE_TAGS := optional

LOCAL_MODULE_CLASS := FAKE
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)

LOCAL_OVERRIDES_PACKAGES +='" $REMOVE_PACKAGES"'
include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE):
    $(hide) echo "Fake: $@"
    $(hide) mkdir -p $(dir $@)
    $(hide) touch $@

PACKAGES.$(LOCAL_MODULE).OVERRIDES := $(strip $(LOCAL_OVERRIDES_PACKAGES))
' > vendor/remove_unused_module/Android.mk
  echo "PRODUCT_PACKAGES += remove_unused_module" >> "vendor/$vendor/config/common.mk"
else
  if [ -d vendor/remove_unused_module ]
  then
    rm -r vendor/remove_unused_module
  fi
fi

# patch Dialer to remove call record country restriction
echo patching call recorder to ignore country restrictions, please refer to your country\'s law and use at your own risk
if [ -e packages/apps/Dialer/java/com/android/incallui/call/CallRecorder.java ]
then
# android 10, 11 and 12
    OLD_IFS=$IFS
    IFS=$'\n'
    echo > /tmp/CallRecorder.java
    cat packages/apps/Dialer/java/com/android/incallui/call/CallRecorder.java | while read -r LINE
    do
        if [ -z "$write_disabled" ]
        then
            echo "$LINE" >> /tmp/CallRecorder.java
        fi
        if [ -n "$(echo $LINE | grep 'public boolean canRecordInCurrentCountry() {')" ]
        then
            echo "return true;" >> /tmp/CallRecorder.java
            write_disabled=true
        fi
        if [ -n "$(echo $LINE | grep 'private CallRecorder() {')" ]
        then
            echo '}' >> /tmp/CallRecorder.java
            echo "$LINE" >> /tmp/CallRecorder.java
            write_disabled=""
        fi
    done
    IFS=$OLD_IFS
    cp /tmp/CallRecorder.java packages/apps/Dialer/java/com/android/incallui/call/CallRecorder.java
else
    if [ -e packages/apps/Dialer/src/com/android/services/callrecorder/CallRecorderService.java ]
    then
        # android 7
        sed -i 's/context.getResources().getBoolean(R.bool.call_recording_enabled)/true/g' packages/apps/Dialer/src/com/android/services/callrecorder/CallRecorderService.java
    fi
fi

# patching -mapcs away for clang + android 7
if [ "$BRANCH_NAME" == "cm-14.1" ]
then
	no_mapcs_device_list="tuna"
	no_mapcs=false
	for device in $(echo "$DEVICE_LIST" | sed 's/,/ /g')
	do
		for no_mapcs_device in $no_mapcs_device_list
		do
			if [ "$device" == "$no_mapcs_device" ]
			then
				no_mapcs=true
				break
			fi
		done
		if $no_mapcs
		then
			break
		fi
	done
	if $no_mapcs
	then
		sed -i 's/-mapcs//g' frameworks/base/libs/hwui/Android.mk
		#sed -i 's/-mapcs//g' hardware/ti/omap4/domx/make/build.mk
	fi
fi

# skip vintf checking if needed
if [ "$SKIP_VINTF_PATCH" == "true" ]
then
	sed -i "s/if info_dict.get('vintf_enforce') != 'true':/if True:/" build/make/tools/releasetools/check_target_files_vintf.py
fi

# for older kernels that has no bpf support
if [ "$PATCH_BPFL" == "true" ]
then
	(
		cd system/bpf
		git apply /patches/system_bpf/0001-Ignore-bpf-errors-for-4.9-kernels.patch
	)
	(
		cd system/netd
		git apply /patches/system_netd/0001-Add-back-support-for-non-bpf-trafic-monitoring.patch
	)
	#sed -i 's/sleep(20);/android::base::SetProperty("bpf.progs_loaded", "1");/' system/bpf/bpfloader/BpfLoader.cpp
	#sed -i 's/return 2;/return 0;/' system/bpf/bpfloader/BpfLoader.cpp

	#sed -i 's/sleep(60);//' system/netd/server/Controllers.cpp
	#sed -i 's/exit(1);//' system/netd/server/Controllers.cpp
fi

# run repopick on request
if [ -n "$REPOPICK" ]
then
	for change in $REPOPICK
	do
		./vendor/lineage/build/tools/repopick.py $change
	done
fi
