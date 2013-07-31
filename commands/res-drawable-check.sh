### compare images in res/drawable, res/drawable-hdpi and res/drawable-mdpi, copy mismatches picture

#not in a explicit project

echo "please input project path as: (path/DX-Guard)" 

read project

echo "=========copy the picture called for by drawable-mdpi to the directory ~/need-mdpi-picture ==========="

mkdir ~/picture-hdpi 2>/dev/null
for image in $(ls $project/res/drawable-hdpi)
do
    img=$(find $project/res/drawable -name $image 2>/dev/null)
    if [ ! -z "$img" ]; then
        continue;
    fi

    img=$(find $project/res/drawable*mdpi* -name $image 2>/dev/null)
    if [ ! -z  "$img" ]; then
        continue;
    fi

    echo "$project/res/drawable-hdpi/$image"
    cp "$project/res/drawable-hdpi/$image" ~/need-mdpi-picture
done
echo
echo "*******************************************************"
echo

echo "=========copy the picture called for by drawable-hdpi to the directory ~/need-hdpi-picture ==========="

mkdir ~/need-hdpi-picture 2>/dev/null
for image in $(ls $project/res/drawable-mdpi)
do

    img=$(find $project/res/drawable -name $image 2>/dev/null)
    if [ ! -z "$img" ]; then
        continue;
    fi

    img=$(find $project/res/drawable*hdpi* -name $image 2>/dev/null)
    if [ ! -z  "$img" ]; then
        continue;
    fi

    echo "$project/res/drawable-mdpi/$image"
    cp "$project/res/drawable-mdpi/$image" ~/need-hdpi-picture
done

