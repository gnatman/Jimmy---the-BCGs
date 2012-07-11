echo "Updating the images on the wiki."

PASSWORD=$(gpg --decrypt $HOME/Astro/wiki.gpg)

idl << EOF
.comp lambda_v_m.pro
.comp lambda_v_r.pro
.comp lambda_v_re.pro
.comp lambda_v_z.pro
.comp lambda_v_e.pro
lambda_v_m
lambda_v_r
lambda_v_re
lambda_v_z
lambda_v_e
EOF

#curl -c cookies.txt -d "lgname=Jimmy&lgpassword="$PASSWORD"&action=login&format=xml" https://galaxies.physics.tamu.edu/api.php -o token.txt
#TOKEN=$(cat token.txt | cut -d \" -f 6)

#curl -b cookies.txt -d "action=login&lgname=Jimmy&lgpassword=IjGN4yrH&format=xml&lgtoken="$TOKEN https://galaxies.physics.tamu.edu/api.php
#curl -b cookies.txt -d "action=login&lgname=Jimmy&lgpassword=IjGN4yrH&format=xml&lgtoken="$TOKEN https://galaxies.physics.tamu.edu/api.php
#curl -b cookies.txt -d "action=query&prop=info|revisions&titles="$1"_"$2"&format=xml&intoken=edit" https://galaxies.physics.tamu.edu/api.php > edit.txt

#EDITTOKEN=$(cat edit.txt | awk -F \(edittoken\) '{print $2}')
#EDITTOKEN2=$(echo $EDITTOKEN | cut -c 3-34)
#TIMESTAMP=$(cat edit.txt | cut -d \" -f 22)

#TEXT="%3d%3d%3dKinematic%20Maps%20S%2fN%205%3d%3d%3d%0d%3cimg%20size%3d360%3ehttps%3a%2f%2fgalaxies.physics.tamu.edu%2fimages%2fjimmy%2f$BCG%2f$target%2fvelocity_sn5.jpg%3c%2fimg%3e%0d%3cimg%20size%3d360%3ehttps%3a%2f%2fgalaxies.physics.tamu.edu%2fimages%2fjimmy%2f$BCG%2f$target%2fdispersion_sn5.jpg%3c%2fimg%3e%0d%3cimg%20size%3d360%3ehttps%3a%2f%2fgalaxies.physics.tamu.edu%2fimages%2fjimmy%2f$BCG%2f$target%2fsn_sn5.jpg%3c%2fimg%3e%0d%3d%3d%3dKinematic%20Maps%20S%2fN%2010%3d%3d%3d%0d%3cimg%20size%3d360%3ehttps%3a%2f%2fgalaxies.physics.tamu.edu%2fimages%2fjimmy%2f$BCG%2f$target%2fvelocity_sn10.jpg%3c%2fimg%3e%0d%3cimg%20size%3d360%3ehttps%3a%2f%2fgalaxies.physics.tamu.edu%2fimages%2fjimmy%2f$BCG%2f$target%2fdispersion_sn10.jpg%3c%2fimg%3e%0d%3cimg%20size%3d360%3ehttps%3a%2f%2fgalaxies.physics.tamu.edu%2fimages%2fjimmy%2f$BCG%2f$target%2fsn_sn10.jpg%3c%2fimg%3e%0d%3d%3d%3dTable%20Data%3d%3d%3d%0d{{BCG_Table|$a1|$a2|$a3|$a4|$a5|$a6|$a7|$a8|$a9|$a10|$a11|$a12|$a13|$a14|$a15|$a16|$a17|$a18|$a19|$a20|$a21|$a22|$a23|$a24|$a25|$a26|$a27|$a28|$a29|$a30|$a31|$a32|$a33}}"

#curl -b cookies.txt -d "format=xml&action=edit&title="$1"_"$2"&recreate&summary=Automatically%20Generated%20Page&text="$TEXT"&token="$EDITTOKEN2"%2B%5C" https://galaxies.physics.tamu.edu/api.php

convert -density 300 "lambda_v_mass.eps" -flatten temp.jpg
scp temp.jpg jimmy@io.physics.tamu.edu:/home/websites/galaxies.physics.tamu.edu/htdocs/images/jimmy/plots/lambda_v_mass.jpg
convert -density 300 "half_lambda_v_mass.eps" -flatten temp.jpg
scp temp.jpg jimmy@io.physics.tamu.edu:/home/websites/galaxies.physics.tamu.edu/htdocs/images/jimmy/plots/half_lambda_v_mass.jpg
convert -density 300 "lambda_v_r_e.eps" -flatten temp.jpg
scp temp.jpg jimmy@io.physics.tamu.edu:/home/websites/galaxies.physics.tamu.edu/htdocs/images/jimmy/plots/lambda_v_r_e.jpg
convert -density 300 "half_lambda_v_r_e.eps" -flatten temp.jpg
scp temp.jpg jimmy@io.physics.tamu.edu:/home/websites/galaxies.physics.tamu.edu/htdocs/images/jimmy/plots/half_lambda_v_r_e.jpg
convert -density 300 "lambda_v_rad.eps" -flatten temp.jpg
scp temp.jpg jimmy@io.physics.tamu.edu:/home/websites/galaxies.physics.tamu.edu/htdocs/images/jimmy/plots/lambda_v_rad.jpg
convert -density 300 "lambda_v_rad_raw.eps" -flatten temp.jpg
scp temp.jpg jimmy@io.physics.tamu.edu:/home/websites/galaxies.physics.tamu.edu/htdocs/images/jimmy/plots/lambda_v_rad_raw.jpg
convert -density 300 "lambda_v_z.eps" -flatten temp.jpg
scp temp.jpg jimmy@io.physics.tamu.edu:/home/websites/galaxies.physics.tamu.edu/htdocs/images/jimmy/plots/lambda_v_z.jpg
convert -density 300 "half_lambda_v_z.eps" -flatten temp.jpg
scp temp.jpg jimmy@io.physics.tamu.edu:/home/websites/galaxies.physics.tamu.edu/htdocs/images/jimmy/plots/half_lambda_v_z.jpg
convert -density 300 "lambda_v_e.eps" -flatten temp.jpg
scp temp.jpg jimmy@io.physics.tamu.edu:/home/websites/galaxies.physics.tamu.edu/htdocs/images/jimmy/plots/lambda_v_e.jpg
convert -density 300 "half_lambda_v_e.eps" -flatten temp.jpg
scp temp.jpg jimmy@io.physics.tamu.edu:/home/websites/galaxies.physics.tamu.edu/htdocs/images/jimmy/plots/half_lambda_v_e.jpg


ssh jimmy@io.physics.tamu.edu chmod a+r -R /home/websites/galaxies.physics.tamu.edu/htdocs/images/jimmy/

rm lambda_v_mass.eps
rm half_lambda_v_mass.eps
rm lambda_v_r_e.eps
rm half_lambda_v_r_e.eps
rm lambda_v_rad.eps
rm lambda_v_rad_raw.eps
rm lambda_v_z.eps
rm half_lambda_v_z.eps
rm lambda_v_e.eps
rm half_lambda_v_e.eps
rm temp.jpg