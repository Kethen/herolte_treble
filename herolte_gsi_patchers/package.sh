zips="a11_patcher a12_patcher deskclock_powersaving log_to_data lpm_installer phh_wifitethering_patcher phh_dt2w_patcher charger_log phh_aosp13_patcher store_mode"

if [ -d output ]
then
	rm -r output
fi
mkdir output


for zip in $zips
do
	(
		cd $zip
		zip -r -y -9 ../output/${zip}.zip .
	)
done
