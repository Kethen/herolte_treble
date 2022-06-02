zips="a11_patcher  a12_patcher  deskclock_powersaving  log_to_data  lpm_installer  phh_wifitethering_patcher"

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
