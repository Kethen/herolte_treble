#lineage-18.1-20220618-UNOFFICIAL-herolte.zip
#lineage-18.1-20220618-UNOFFICIAL-hero2lte.zip

#lineage-19.1-20220624-UNOFFICIAL-herolte.zip
#lineage-19.1-20220625-UNOFFICIAL-hero2lte.zip

srcdir=$(realpath $(dirname $0))
zip_repository=$(realpath $1)
workdir=$(mktemp -d)
outputdir=$(realpath $(pwd))/output
cd "$workdir"

rm -rf "$outputdir"
mkdir "$outputdir"

for f in "$zip_repository"/lineage-*.zip
do
	filename=$(basename "$f")
	losversion=$(echo $filename | sed -E 's/lineage-(.+)-(.+)-UNOFFICIAL-(.+).zip/\1/')
	if [ "$losversion" == "19.1" ]
	then
		vndk_version="vndk32_12.1"
	fi
	if [ "$losversion" == "18.1" ]
	then
		vndk_version="vndk30_11"
	fi
	date=$(echo $filename | sed -E 's/lineage-(.+)-(.+)-UNOFFICIAL-(.+).zip/\2/')
	model=$(echo $filename | sed -E 's/lineage-(.+)-(.+)-UNOFFICIAL-(.+).zip/\3/')

	rm -rf *
	unzip "$f" vendor.new.dat.br vendor.transfer.list boot.img
	cat vendor.new.dat.br | brotli -d > vendor.new.dat
	python "$srcdir"/sdat2img/sdat2img.py vendor.transfer.list vendor.new.dat vendor.img
	mkdir -p META-INF/com/google/android
	cp "$srcdir"/template/META-INF/com/google/android/* META-INF/com/google/android/
	sed -i "/#!\/sbin\/sh/a MODEL=$model" META-INF/com/google/android/update-binary
	sed -i "/#!\/sbin\/sh/a VNDK=$vndk_version" META-INF/com/google/android/update-binary
	zip -r -y -9 "$outputdir"/${model}_${vndk_version}_${date}.zip META-INF vendor.img boot.img
done

cd ../
rm -r "$workdir"
