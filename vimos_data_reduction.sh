#!/bin/bash

#Data reduction script written by Jimmy.

#This script takes two inputs, the SDSS-C4 target name of the galaxy, which will be used to create and identify the proper project folder.
#2nd input is the mask to be applied, either all, main, comp, or 2ndcomp
#Called like: vimos_data_reduction.sh 1050 all
#Should only need to edit the directories for the following files, and then most scripts will work when called from here.
#Of course that assumes you're following my naming scheme.

#Astro_Dir is the top level directory containing raw and reduced data.
ASTRO_DIR=$HOME/Astro
#Reduced dir is the directory containing the project directories for each galaxy and supporting files
REDUCED_DIR=$ASTRO_DIR/reduced
#Pro Dir is the project directory for that particular galaxy.  This is where the outputs are actually sent.
PRO_DIR=$REDUCED_DIR/$1pro
#SOF dir contains the "set of frames" files used by the VIMOS pipeline and is unique to each directory.
SOF_DIR=$REDUCED_DIR/$1sof
#Cal Dir contains the calbration files used by both VIMOS Pipeline and IDL
ROT_DIR=$REDUCED_DIR/$1-180sof
#Rot Dir contains the 180 degree rotated data for the galaxies that have said data.
PT2_DIR=$REDUCED_DIR/$1pt2sof
#PT2 Dir contains the second set of data for the galaxies that have said data.
CAL_DIR=$REDUCED_DIR/cal
#Used to automatically pull the IDL scripts out of testing mode.
export not_testing=1

#Take the input from the command line argument.
if [ $# -ne 2 ]
then
        echo "No target given."
        exit 1
fi
echo "Input target number: " $1
echo "Input object of interest: " $2

#If the project directory for this galaxy doesn't exist, we will make it.
if [ ! -d $PRO_DIR ];
then
    mkdir $PRO_DIR
    mkdir $PRO_DIR/all
    mkdir $PRO_DIR/main
    mkdir $PRO_DIR/comp
    mkdir $PRO_DIR/2ndcomp
fi

#If there is a SOF directory for this galaxy, then we will remove the sym links to whatever galaxy may have been previously used, and add new symlinks for our current directory.
#symlinks are used because it's the easiest way of using one script to do everything without having to refer to a specific project or sof directory every time.

if [ -d $SOF_DIR ];
then
    rm -rf $REDUCED_DIR/pro
    rm -rf $REDUCED_DIR/sof
    ln -s $REDUCED_DIR/$1pro $REDUCED_DIR/pro
    ln -s $REDUCED_DIR/$1sof $REDUCED_DIR/sof
else
    echo "Target sof directory not found in reduced data folder."
    exit 1
fi



#QUESTIONS TIME
#This determines which steps in the process will be performed.  The default for all steps is no, so unless a y is entered, that step will be skipped.  They are structured in this manner so that one can just hit enter a bunch of times to skip those steps.

export default="n"

read -p "Master Bias Creation?: " -e t1
if [ -n "$t1" ]
then
  msbias="$t1"
else
  msbias="$default"
fi

read -p "IFU Calibration?: " -e t1
if [ -n "$t1" ]
then
  calib="$t1"
else
  calib="$default"
fi

read -p "Science Reduction?: " -e t1
if [ -n "$t1" ]
then
  science="$t1"
else
  science="$default"
fi

read -p "Combine FOV files?: " -e t1
if [ -n "$t1" ]
then
  combine="$t1"
else
  combine="$default"
fi

#read -p "Create Cube using VIMOS?: " -e t1
#if [ -n "$t1" ]
#then
#  cube="$t1"
#else
  cube="$default"
#fi

read -p "Use IDL to make individual cubes?: " -e t1
if [ -n "$t1" ]
then
  make_cube_vimos="$t1"
else
  make_cube_vimos="$default"
fi

read -p "Use IDL to combine cubes?: " -e t1
if [ -n "$t1" ]
then
  make_idl_cube="$t1"
else
  make_idl_cube="$default"
fi

read -p "Use make mosaic to stack cubes?: " -e t1
if [ -n "$t1" ]
then
  mosaic="$t1"
else
  mosaic="$default"
fi

read -p "Perform mask?: " -e t1
if [ -n "$t1" ]
then
  mask="$t1"
else
  mask="$default"
fi

read -p "Perform S/N cut?: " -e t1
if [ -n "$t1" ]
then
  sncut="$t1"
else
  sncut="$default"
fi

read -p "Do Voronoi Binning?: " -e t1
if [ -n "$t1" ]
then
  vbinning="$t1"
else
  vbinning="$default"
fi

read -p "Bin Radially?: " -e t1
if [ -n "$t1" ]
then
  radial="$t1"
  #export rad="radial"
else
  radial="$default"
fi

read -p "Perform PPXF?: " -e t1
if [ -n "$t1" ]
then
  ppxf="$t1"
else
  ppxf="$default"
fi

read -p "Plot Data?: " -e t1
if [ -n "$t1" ]
then
  plot="$t1"
else
  plot="$default"
fi

read -p "Perform Monte Carlo Simulation?: " -e t1
if [ -n "$t1" ]
then
  mask="$t1"
  sncut="$t1"
  vbinning="$t1"
  ppxf="$t1"
  plot="$t1"
  monte="$t1"
else
  monte="$default"
fi

export montecarlointoppxf=$monte

    #If the standard files exist, they will be used, otherwise the regular files will be used.  Not pretty, but I STD seems to work better than    regular, so I'll give them preference.
#    read -p "Use standard test.fits for stacking?: " -e t1
#    if [ -n "$t1" ]
#    then
#      usephot="$t1"
#    else
      usephot="$default"
#    fi

#echo "Perform Lambda?"
#read lambda

#This section sests the specific variables and that need to be defined individually for each galaxy

#Default, saves time.
export rotation="n"
export twoparter="n"
export threeparter="n"

if [ $1 == 1027 ]
then
echo "Redshift for target 1027 identified as 088000."
export redshift=0.0900 
export rotation="n"
export twoparter="y"
if [ $2 == 'main' ]
then
    export r_e=7.0
fi
if [ $2 == 'comp' ]
then
    export r_e=4.0
fi

export skyfiber1astart=242
export skyfiber1aend=278
export skyfiber2astart=82
export skyfiber2aend=99
export skyfiber3astart=264
export skyfiber3aend=298
export skyfiber4astart=364
export skyfiber4aend=390

export skyfiber1bstart=174
export skyfiber1bend=198
export skyfiber2bstart=262
export skyfiber2bend=298
export skyfiber3bstart=240
export skyfiber3bend=258
export skyfiber4bstart=100
export skyfiber4bend=119

export skyfiber1cstart=249
export skyfiber1cend=278
export skyfiber2cstart=102
export skyfiber2cend=138
export skyfiber3cstart=182
export skyfiber3cend=218
export skyfiber4cstart=82
export skyfiber4cend=118

export skyfiber1astart_180=242
export skyfiber1aend_180=278
export skyfiber2astart_180=182
export skyfiber2aend_180=218
export skyfiber3astart_180=222
export skyfiber3aend_180=258
export skyfiber4astart_180=362
export skyfiber4aend_180=388

export skyfiber1bstart_180=122
export skyfiber1bend_180=158
export skyfiber2bstart_180=103
export skyfiber2bend_180=138
export skyfiber3bstart_180=101
export skyfiber3bend_180=120
export skyfiber4bstart_180=82
export skyfiber4bend_180=118

export skyfiber1cstart_180=250
export skyfiber1cend_180=277
export skyfiber2cstart_180=272
export skyfiber2cend_180=298
export skyfiber3cstart_180=262
export skyfiber3cend_180=298
export skyfiber4cstart_180=212
export skyfiber4cend_180=232
fi

if [ $1 == 1050 ]
then
echo "Redshift for target 1050 identified as 0.072730."
export redshift=0.072
export rotation="n"
export twoparter="n"
if [ $2 == 'main' ]
then
    export r_e=6.29
fi
if [ $2 == 'comp' ]
then
    export r_e=0.0
fi

export skyfiber1astart=162
export skyfiber1aend=197
export skyfiber2astart=187
export skyfiber2aend=213
export skyfiber3astart=264
export skyfiber3aend=290
export skyfiber4astart=282
export skyfiber4aend=318

export skyfiber1bstart=162
export skyfiber1bend=198
export skyfiber2bstart=262
export skyfiber2bend=298
export skyfiber3bstart=182
export skyfiber3bend=218
export skyfiber4bstart=202
export skyfiber4bend=238

export skyfiber1cstart=122
export skyfiber1cend=158
export skyfiber2cstart=102
export skyfiber2cend=138
export skyfiber3cstart=182
export skyfiber3cend=218
export skyfiber4cstart=82
export skyfiber4cend=118
fi

if [ $1 == 1066 ]
then
echo "Redshift for target 1066 identified as 0.085400."
export redshift=0.0837
export rotation="n"
export twoparter="n"
if [ $2 == 'main' ]
then
    export r_e=12
fi
if [ $2 == 'comp' ]
then
    export r_e=11
fi

export skyfiber1astart=175
export skyfiber1aend=197
export skyfiber2astart=320
export skyfiber2aend=338
export skyfiber3astart=274
export skyfiber3aend=298
export skyfiber4astart=202
export skyfiber4aend=238

export skyfiber1bstart=282
export skyfiber1bend=308
export skyfiber2bstart=342
export skyfiber2bend=378
export skyfiber3bstart=262
export skyfiber3bend=298
export skyfiber4bstart=202
export skyfiber4bend=238

export skyfiber1cstart=242
export skyfiber1cend=278
export skyfiber2cstart=102
export skyfiber2cend=138
export skyfiber3cstart=182
export skyfiber3cend=218
export skyfiber4cstart=202
export skyfiber4cend=238
fi

if [ $1 == 2001 ]
then
echo "Redshift for target 2001 identified as 0.041132"
export redshift=0.0415
export rotation="n"
export twoparter="n"
if [ $2 == 'main' ]
then
    export r_e=5
fi
if [ $2 == 'comp' ]
then
    export r_e=5
fi

export skyfiber1astart=361
export skyfiber1aend=382
export skyfiber2astart=102
export skyfiber2aend=138
export skyfiber3astart=264
export skyfiber3aend=290
export skyfiber4astart=242
export skyfiber4aend=278

export skyfiber1bstart=42
export skyfiber1bend=78
export skyfiber2bstart=102
export skyfiber2bend=138
export skyfiber3bstart=302
export skyfiber3bend=338
export skyfiber4bstart=202
export skyfiber4bend=238

export skyfiber1cstart=42
export skyfiber1cend=78
export skyfiber2cstart=102
export skyfiber2cend=138
export skyfiber3cstart=182
export skyfiber3cend=218
export skyfiber4cstart=202
export skyfiber4cend=238
fi

if [ $1 == 2086 ]
then
echo "Redshift for target 2086 identified as 0.083160."
export redshift=0.083160
export rotation="n"
export twoparter="n"
if [ $2 == 'main' ]
then
    export r_e=7
fi
if [ $2 == 'comp' ]
then
    export r_e=2
fi

export skyfiber1astart=42
export skyfiber1aend=78
export skyfiber2astart=109
export skyfiber2aend=138
export skyfiber3astart=262
export skyfiber3aend=298
export skyfiber4astart=42
export skyfiber4aend=78

export skyfiber1bstart=162
export skyfiber1bend=198
export skyfiber2bstart=182
export skyfiber2bend=218
export skyfiber3bstart=302
export skyfiber3bend=338
export skyfiber4bstart=2
export skyfiber4bend=38

export skyfiber1cstart=122
export skyfiber1cend=158
export skyfiber2cstart=102
export skyfiber2cend=138
export skyfiber3cstart=182
export skyfiber3cend=218
export skyfiber4cstart=82
export skyfiber4cend=118
fi

if [ $1 == 1153 ]
then
echo "Redshift for target 1153 identified as 0.060000."
export redshift=0.059
export rotation="y"
export twoparter="n"
if [ $2 == 'main' ]
then
    export r_e=12
fi
if [ $2 == 'all' ]
then
    export r_e=12
fi
if [ $2 == 'comp' ]
then
    export r_e=0
fi

export skyfiber1astart=282
export skyfiber1aend=318
export skyfiber2astart=263
export skyfiber2aend=298
export skyfiber3astart=303
export skyfiber3aend=338
export skyfiber4astart=82
export skyfiber4aend=118

export skyfiber1bstart=243
export skyfiber1bend=278
export skyfiber2bstart=303
export skyfiber2bend=338
export skyfiber3bstart=263
export skyfiber3bend=293
export skyfiber4bstart=202
export skyfiber4bend=237

export skyfiber1cstart=243
export skyfiber1cend=278
export skyfiber2cstart=263
export skyfiber2cend=298
export skyfiber3cstart=86
export skyfiber3cend=99
export skyfiber4cstart=243
export skyfiber4cend=278

export skyfiber1dstart=243
export skyfiber1dend=278
export skyfiber2dstart=182
export skyfiber2dend=218
export skyfiber3dstart=222
export skyfiber3dend=248
export skyfiber4dstart=122
export skyfiber4dend=150

export skyfiber1astart_180=42
export skyfiber1aend_180=78
export skyfiber2astart_180=343
export skyfiber2aend_180=368
export skyfiber3astart_180=223
export skyfiber3aend_180=258
export skyfiber4astart_180=123
export skyfiber4aend_180=158

export skyfiber1bstart_180=363
export skyfiber1bend_180=382
export skyfiber2bstart_180=263
export skyfiber2bend_180=292
export skyfiber3bstart_180=223
export skyfiber3bend_180=258
export skyfiber4bstart_180=123
export skyfiber4bend_180=158

export skyfiber1cstart_180=283
export skyfiber1cend_180=318
export skyfiber2cstart_180=183
export skyfiber2cend_180=202
export skyfiber3cstart_180=63
export skyfiber3cend_180=98
export skyfiber4cstart_180=203
export skyfiber4cend_180=238

export skyfiber1dstart_180=243
export skyfiber1dend_180=278
export skyfiber2dstart_180=263
export skyfiber2dend_180=298
export skyfiber3dstart_180=263
export skyfiber3dend_180=298
export skyfiber4dstart_180=43
export skyfiber4dend_180=78
fi

if [ $1 == 1067 ]
then
echo "Redshift for target 1067 identified as 0.09389."
export redshift=0.09389
export rotation="y"
export twoparter="n"
if [ $2 == 'main' ]
then
    export r_e=0
fi
if [ $2 == 'comp' ]
then
    export r_e=0
fi

export skyfiber1astart=42
export skyfiber1aend=78
export skyfiber2astart=263
export skyfiber2aend=298
export skyfiber3astart=343
export skyfiber3aend=375
export skyfiber4astart=42
export skyfiber4aend=78

export skyfiber1bstart=282
export skyfiber1bend=318
export skyfiber2bstart=343
export skyfiber2bend=375
export skyfiber3bstart=343
export skyfiber3bend=355
export skyfiber4bstart=282
export skyfiber4bend=318

export skyfiber1cstart=243
export skyfiber1cend=278
export skyfiber2cstart=343
export skyfiber2cend=378
export skyfiber3cstart=343
export skyfiber3cend=378
export skyfiber4cstart=243
export skyfiber4cend=278

export skyfiber1dstart=282
export skyfiber1dend=318
export skyfiber2dstart=343
export skyfiber2dend=378
export skyfiber3dstart=345
export skyfiber3dend=375
export skyfiber4dstart=82
export skyfiber4dend=118

export skyfiber1astart_180=242
export skyfiber1aend_180=278
export skyfiber2astart_180=102
export skyfiber2aend_180=138
export skyfiber3astart_180=222
export skyfiber3aend_180=258
export skyfiber4astart_180=202
export skyfiber4aend_180=238

export skyfiber1bstart_180=340
export skyfiber1bend_180=359
export skyfiber2bstart_180=183
export skyfiber2bend_180=218
export skyfiber3bstart_180=263
export skyfiber3bend_180=298
export skyfiber4bstart_180=82
export skyfiber4bend_180=118

export skyfiber1cstart_180=52
export skyfiber1cend_180=78
export skyfiber2cstart_180=262
export skyfiber2cend_180=298
export skyfiber3cstart_180=62
export skyfiber3cend_180=98
export skyfiber4cstart_180=122
export skyfiber4cend_180=158

export skyfiber1dstart_180=52
export skyfiber1dend_180=78
export skyfiber2dstart_180=342
export skyfiber2dend_180=378
export skyfiber3dstart_180=182
export skyfiber3dend_180=216
export skyfiber4dstart_180=42
export skyfiber4dend_180=78
fi

if [ $1 == 1048 ]
then
echo "Redshift for target 1048 identified as 0.077450."
export redshift=0.077450
export rotation="n"
export twoparter="y"
export threeparter="y"
if [ $2 == 'main' ]
then
    export r_e=0.0
fi
if [ $2 == 'comp' ]
then
    export r_e=0.0
fi

export skyfiber1astart=88
export skyfiber1aend=113
export skyfiber2astart=103
export skyfiber2aend=135
export skyfiber3astart=183
export skyfiber3aend=210
export skyfiber4astart=203
export skyfiber4aend=235

export skyfiber1bstart=340
export skyfiber1bend=359
export skyfiber2bstart=103
export skyfiber2bend=129
export skyfiber3bstart=200
export skyfiber3bend=219
export skyfiber4bstart=243
export skyfiber4bend=276

export skyfiber1cstart=340
export skyfiber1cend=359
export skyfiber2cstart=103
export skyfiber2cend=129
export skyfiber3cstart=200
export skyfiber3cend=219
export skyfiber4cstart=243
export skyfiber4cend=276

export skyfiber1astart_180=123
export skyfiber1aend_180=138
export skyfiber2astart_180=123
export skyfiber2aend_180=138
export skyfiber3astart_180=123
export skyfiber3aend_180=138
export skyfiber4astart_180=203
export skyfiber4aend_180=238

export skyfiber1bstart_180=83
export skyfiber1bend_180=118
export skyfiber2bstart_180=103
export skyfiber2bend_180=138
export skyfiber3bstart_180=185
export skyfiber3bend_180=203
export skyfiber4bstart_180=363
export skyfiber4bend_180=383

export skyfiber1cstart_180=83
export skyfiber1cend_180=118
export skyfiber2cstart_180=103
export skyfiber2cend_180=138
export skyfiber3cstart_180=185
export skyfiber3cend_180=203
export skyfiber4cstart_180=363
export skyfiber4cend_180=383
fi

if [ $1 == 1261 ]
then
echo "Redshift for target 1261 identified as 0.091000"
export redshift=0.091000
export rotation="n"
export twoparter="y"
export threeparter="y"
if [ $2 == 'main' ]
then
    export r_e=0.0
fi
if [ $2 == 'comp' ]
then
    export r_e=0.0
fi

export skyfiber1astart=
export skyfiber1aend=
export skyfiber2astart=
export skyfiber2aend=
export skyfiber3astart=
export skyfiber3aend=
export skyfiber4astart=
export skyfiber4aend=

export skyfiber1bstart=
export skyfiber1bend=
export skyfiber2bstart=
export skyfiber2bend=
export skyfiber3bstart=
export skyfiber3bend=
export skyfiber4bstart=
export skyfiber4bend=

export skyfiber1cstart=
export skyfiber1cend=
export skyfiber2cstart=
export skyfiber2cend=
export skyfiber3cstart=
export skyfiber3cend=
export skyfiber4cstart=
export skyfiber4cend=

export skyfiber1astart_180=
export skyfiber1aend_180=
export skyfiber2astart_180=
export skyfiber2aend_180=
export skyfiber3astart_180=
export skyfiber3aend_180=
export skyfiber4astart_180=
export skyfiber4aend_180=

export skyfiber1bstart_180=
export skyfiber1bend_180=
export skyfiber2bstart_180=
export skyfiber2bend_180=
export skyfiber3bstart_180=
export skyfiber3bend_180=
export skyfiber4bstart_180=
export skyfiber4bend_180=

export skyfiber1cstart_180=
export skyfiber1cend_180=
export skyfiber2cstart_180=
export skyfiber2cend_180=
export skyfiber3cstart_180=
export skyfiber3cend_180=
export skyfiber4cstart_180=
export skyfiber4cend_180=
fi

if [ $1 == 1042 ]
then
echo "Redshift for target 1042 identified as 0.097200"
export redshift=0.097200
export rotation="n"
export twoparter="y"
export threeparter="y"
if [ $2 == 'main' ]
then
    export r_e=0.0
fi
if [ $2 == 'comp' ]
then
    export r_e=0.0
fi

export skyfiber1astart=
export skyfiber1aend=
export skyfiber2astart=
export skyfiber2aend=
export skyfiber3astart=
export skyfiber3aend=
export skyfiber4astart=
export skyfiber4aend=

export skyfiber1bstart=
export skyfiber1bend=
export skyfiber2bstart=
export skyfiber2bend=
export skyfiber3bstart=
export skyfiber3bend=
export skyfiber4bstart=
export skyfiber4bend=

export skyfiber1cstart=
export skyfiber1cend=
export skyfiber2cstart=
export skyfiber2cend=
export skyfiber3cstart=
export skyfiber3cend=
export skyfiber4cstart=
export skyfiber4cend=

export skyfiber1astart_180=
export skyfiber1aend_180=
export skyfiber2astart_180=
export skyfiber2aend_180=
export skyfiber3astart_180=
export skyfiber3aend_180=
export skyfiber4astart_180=
export skyfiber4aend_180=

export skyfiber1bstart_180=
export skyfiber1bend_180=
export skyfiber2bstart_180=
export skyfiber2bend_180=
export skyfiber3bstart_180=
export skyfiber3bend_180=
export skyfiber4bstart_180=
export skyfiber4bend_180=

export skyfiber1cstart_180=
export skyfiber1cend_180=
export skyfiber2cstart_180=
export skyfiber2cend_180=
export skyfiber3cstart_180=
export skyfiber3cend_180=
export skyfiber4cstart_180=
export skyfiber4cend_180=
fi

if [ $1 == 2039 ]
then
echo "Redshift for target 2039 identified as 0.082000"
export redshift=0.082000
export rotation="n"
export twoparter="y"
export threeparter="y"
if [ $2 == 'main' ]
then
    export r_e=0.0
fi
if [ $2 == 'comp' ]
then
    export r_e=0.0
fi

export skyfiber1astart=
export skyfiber1aend=
export skyfiber2astart=
export skyfiber2aend=
export skyfiber3astart=
export skyfiber3aend=
export skyfiber4astart=
export skyfiber4aend=

export skyfiber1bstart=
export skyfiber1bend=
export skyfiber2bstart=
export skyfiber2bend=
export skyfiber3bstart=
export skyfiber3bend=
export skyfiber4bstart=
export skyfiber4bend=

export skyfiber1cstart=
export skyfiber1cend=
export skyfiber2cstart=
export skyfiber2cend=
export skyfiber3cstart=
export skyfiber3cend=
export skyfiber4cstart=
export skyfiber4cend=

export skyfiber1astart_180=
export skyfiber1aend_180=
export skyfiber2astart_180=
export skyfiber2aend_180=
export skyfiber3astart_180=
export skyfiber3aend_180=
export skyfiber4astart_180=
export skyfiber4aend_180=

export skyfiber1bstart_180=
export skyfiber1bend_180=
export skyfiber2bstart_180=
export skyfiber2bend_180=
export skyfiber3bstart_180=
export skyfiber3bend_180=
export skyfiber4bstart_180=
export skyfiber4bend_180=

export skyfiber1cstart_180=
export skyfiber1cend_180=
export skyfiber2cstart_180=
export skyfiber2cend_180=
export skyfiber3cstart_180=
export skyfiber3cend_180=
export skyfiber4cstart_180=
export skyfiber4cend_180=
fi


#MASTER BIAS CREATION
#Using the VIMOS pipeline, create the master bias frames that will be used for calibration.

if [ $msbias == y ]
then
for quadrant in 1 2 3 4; do
  echo " "
  echo "EXECUTING for VIMOS quadrant ${quadrant}: --> esorex vmbias vmbias${quadrant}.sof"
  
  #Not all command line switches have been explored.
  
  esorex --suppress-prefix=true  \
         --output-dir=$PRO_DIR   \
         --output-readonly=false \
         --suppress-prefix=true  \
         --suppress-link=true    \
         --log-level=off		 \
         vmbias                  \
         $SOF_DIR/vmbias${quadrant}.sof
 
  echo " "
  echo "Renaming product to $PRO_DIR/master_bias${quadrant}.fits"
  mv $PRO_DIR/master_bias.fits $PRO_DIR/master_bias${quadrant}.fits
  echo " "
done

if [ $rotation == y ]
then
    for quadrant in 1 2 3 4; do
    echo " "
    echo "EXECUTING for VIMOS quadrant ${quadrant}: --> esorex vmbias vmbias${quadrant}.sof"
  
    #Not all command line switches have been explored.
  
    esorex --suppress-prefix=true  \
             --output-dir=$PRO_DIR   \
             --output-readonly=false \
             --suppress-prefix=true  \
             --suppress-link=true    \
	         --log-level=off		 \
             vmbias                  \
             $ROT_DIR/vmbias${quadrant}.sof
 
    echo " "
    echo "Renaming product to $PRO_DIR/master_bias${quadrant}_180.fits"
    mv $PRO_DIR/master_bias.fits $PRO_DIR/master_bias${quadrant}_180.fits
    echo " "
    done
fi

if [ $twoparter == y ]
then
    for quadrant in 1 2 3 4; do
    echo " "
    echo "EXECUTING for VIMOS quadrant ${quadrant}: --> esorex vmbias vmbias${quadrant}.sof"
  
    #Not all command line switches have been explored.
  
    esorex --suppress-prefix=true  \
             --output-dir=$PRO_DIR   \
             --output-readonly=false \
             --suppress-prefix=true  \
             --suppress-link=true    \
	         --log-level=off		 \
             vmbias                  \
             $PT2_DIR/vmbias${quadrant}.sof
 
    echo " "
    echo "Renaming product to $PRO_DIR/master_bias${quadrant}_pt2.fits"
    mv $PRO_DIR/master_bias.fits $PRO_DIR/master_bias${quadrant}_pt2.fits
    echo " "
    done
fi
fi

#VIMOS IFU CALIBRATION
#Creates the calibration files using the master bias above, as well as the other inputs specified in the SOF.

if [ $calib == y ]
then
for quadrant in 1 2 3 4; do
  echo " "
  echo "EXECUTING for VIMOS quadrant ${quadrant}: --> esorex vmifucalib vmifucalib${quadrant}.sof"
  
  #Not all switches have been explored.
  
  esorex --suppress-prefix=true  \
         --output-dir=$PRO_DIR     \
         --output-readonly=false \
         --suppress-prefix=true  \
         --suppress-link=true    \
         --log-level=off		 \
         vmifucalib              \
         --LineIdent=FirstGuess       \
         --CleanBadPixel=true   \
         $SOF_DIR/vmifucalib${quadrant}.sof

  echo " "
  echo "Renaming product to $PRO_DIR/ifu_arc_spectrum_extracted${quadrant}.fits"
  mv $PRO_DIR/ifu_arc_spectrum_extracted.fits $PRO_DIR/ifu_arc_spectrum_extracted${quadrant}.fits
  echo " "
  echo "Renaming product to $PRO_DIR/ifu_flat_spectrum_extracted${quadrant}.fits"
  mv $PRO_DIR/ifu_flat_spectrum_extracted.fits $PRO_DIR/ifu_flat_spectrum_extracted${quadrant}.fits
  echo " "
  echo "Renaming product to $PRO_DIR/ifu_ids${quadrant}.fits"
  mv $PRO_DIR/ifu_ids.fits $PRO_DIR/ifu_ids${quadrant}.fits
  echo " "
  echo "Renaming product to $PRO_DIR/ifu_master_screen_flat${quadrant}.fits"
  mv $PRO_DIR/ifu_master_screen_flat.fits $PRO_DIR/ifu_master_screen_flat${quadrant}.fits
  echo " "
  echo "Renaming product to $PRO_DIR/ifu_trace${quadrant}.fits"
  mv $PRO_DIR/ifu_trace.fits $PRO_DIR/ifu_trace${quadrant}.fits
  echo " "
  echo "Renaming product to $PRO_DIR/ifu_transmission${quadrant}.fits"
  mv $PRO_DIR/ifu_transmission.fits $PRO_DIR/ifu_transmission${quadrant}.fits
  echo " "
done

if [ $rotation == y ]
then
    for quadrant in 1 2 3 4; do
    echo " "
    echo "EXECUTING for VIMOS quadrant ${quadrant}: --> esorex vmifucalib vmifucalib${quadrant}.sof"
  
    #Not all switches have been explored.
  
    esorex --suppress-prefix=true  \
             --output-dir=$PRO_DIR     \
             --output-readonly=false \
             --suppress-prefix=true  \
             --suppress-link=true    \
             --log-level=off		 \
             vmifucalib              \
             --LineIdent=FirstGuess       \
             --CleanBadPixel=true   \
             $ROT_DIR/vmifucalib${quadrant}.sof

    echo " "
    echo "Renaming product to $PRO_DIR/ifu_arc_spectrum_extracted${quadrant}_180.fits"
    mv $PRO_DIR/ifu_arc_spectrum_extracted.fits $PRO_DIR/ifu_arc_spectrum_extracted${quadrant}_180.fits
    echo " "
    echo "Renaming product to $PRO_DIR/ifu_flat_spectrum_extracted${quadrant}_180.fits"
    mv $PRO_DIR/ifu_flat_spectrum_extracted.fits $PRO_DIR/ifu_flat_spectrum_extracted${quadrant}_180.fits
    echo " "
    echo "Renaming product to $PRO_DIR/ifu_ids${quadrant}_180.fits"
    mv $PRO_DIR/ifu_ids.fits $PRO_DIR/ifu_ids${quadrant}_180.fits
    echo " "
    echo "Renaming product to $PRO_DIR/ifu_master_screen_flat${quadrant}_180.fits"
    mv $PRO_DIR/ifu_master_screen_flat.fits $PRO_DIR/ifu_master_screen_flat${quadrant}_180.fits
    echo " "
    echo "Renaming product to $PRO_DIR/ifu_trace${quadrant}_180.fits"
    mv $PRO_DIR/ifu_trace.fits $PRO_DIR/ifu_trace${quadrant}_180.fits
    echo " "
    echo "Renaming product to $PRO_DIR/ifu_transmission${quadrant}_180.fits"
    mv $PRO_DIR/ifu_transmission.fits $PRO_DIR/ifu_transmission${quadrant}_180.fits
    echo " "
    done
fi

if [ $twoparter == y ]
then
    for quadrant in 1 2 3 4; do
    echo " "
    echo "EXECUTING for VIMOS quadrant ${quadrant}: --> esorex vmifucalib vmifucalib${quadrant}.sof"
  
    #Not all switches have been explored.
  
    esorex --suppress-prefix=true  \
             --output-dir=$PRO_DIR     \
             --output-readonly=false \
             --suppress-prefix=true  \
             --suppress-link=true    \
             --log-level=off		 \
             vmifucalib              \
             --LineIdent=FirstGuess       \
             --CleanBadPixel=true   \
             $PT2_DIR/vmifucalib${quadrant}.sof

    echo " "
    echo "Renaming product to $PRO_DIR/ifu_arc_spectrum_extracted${quadrant}_pt2.fits"
    mv $PRO_DIR/ifu_arc_spectrum_extracted.fits $PRO_DIR/ifu_arc_spectrum_extracted${quadrant}_pt2.fits
    echo " "
    echo "Renaming product to $PRO_DIR/ifu_flat_spectrum_extracted${quadrant}_pt2.fits"
    mv $PRO_DIR/ifu_flat_spectrum_extracted.fits $PRO_DIR/ifu_flat_spectrum_extracted${quadrant}_pt2.fits
    echo " "
    echo "Renaming product to $PRO_DIR/ifu_ids${quadrant}_pt2.fits"
    mv $PRO_DIR/ifu_ids.fits $PRO_DIR/ifu_ids${quadrant}_pt2.fits
    echo " "
    echo "Renaming product to $PRO_DIR/ifu_master_screen_flat${quadrant}_pt2.fits"
    mv $PRO_DIR/ifu_master_screen_flat.fits $PRO_DIR/ifu_master_screen_flat${quadrant}_pt2.fits
    echo " "
    echo "Renaming product to $PRO_DIR/ifu_trace${quadrant}_pt2.fits"
    mv $PRO_DIR/ifu_trace.fits $PRO_DIR/ifu_trace${quadrant}_pt2.fits
    echo " "
    echo "Renaming product to $PRO_DIR/ifu_transmission${quadrant}_pt2.fits"
    mv $PRO_DIR/ifu_transmission.fits $PRO_DIR/ifu_transmission${quadrant}_pt2.fits
    echo " "
    done
fi
rm -rf *.paf
fi

#VIMOS IFU SCIENCE EXTRACTION
#Create the field of view for each quadrant, and reduce the science frames using the calibration files above.

if [ $science == y ]
then
for quadrant in 1 2 3 4; do
for run in a b c d; do
  if [ ! -e "$SOF_DIR/vmifuscience1${run}.sof" ]
  then
	break       	   #if we've only got 3 obs, then we should quit.
  fi
  echo " "
  echo "EXECUTING for VIMOS quadrant ${quadrant}: --> esorex vmifuscience  vmifuscience${quadrant}${run}.sof"

#Not all switches have been explored.

  esorex --suppress-prefix=true  \
         --output-dir=$PRO_DIR   \
         --output-readonly=false \
         --suppress-prefix=true  \
         --suppress-link=true    \
         --log-level=off		 \
         vmifuscience            \
         --CleanBadPixel=true   \
         --CalibrateFlux=false   \
         $SOF_DIR/vmifuscience${quadrant}${run}.sof

  echo " "
  echo "Renaming product to $PRO_DIR/ifu_fov${quadrant}${run}.fits"
  mv $PRO_DIR/ifu_fov.fits $PRO_DIR/ifu_fov${quadrant}${run}.fits
  echo " "
  echo "Renaming product to $PRO_DIR/ifu_science_reduced${quadrant}${run}.fits"
  mv $PRO_DIR/ifu_science_reduced.fits $PRO_DIR/ifu_science_reduced${quadrant}${run}.fits
  echo " "
done
done

if [ $rotation == y ]
then
    for quadrant in 1 2 3 4; do
    for run in a b c d; do
    if [ ! -e "$ROT_DIR/vmifuscience1${run}.sof" ]
    then
	   break       	   #if we've only got 3 obs, then we should quit.
    fi
    echo " "
    echo "EXECUTING for VIMOS quadrant ${quadrant}: --> esorex vmifuscience  vmifuscience${quadrant}${run}.sof"

        #Not all switches have been explored.

      esorex --suppress-prefix=true  \
             --output-dir=$PRO_DIR   \
             --output-readonly=false \
             --suppress-prefix=true  \
             --suppress-link=true    \
             --log-level=off		 \
             vmifuscience            \
             --CleanBadPixel=true   \
             --CalibrateFlux=false   \
             $ROT_DIR/vmifuscience${quadrant}${run}.sof

      echo " "
    echo "Renaming product to $PRO_DIR/ifu_fov${quadrant}${run}_180.fits"
    mv $PRO_DIR/ifu_fov.fits $PRO_DIR/ifu_fov${quadrant}${run}_180.fits
    echo " "
    echo "Renaming product to $PRO_DIR/ifu_science_reduced${quadrant}${run}_180.fits"
    mv $PRO_DIR/ifu_science_reduced.fits $PRO_DIR/ifu_science_reduced${quadrant}${run}_180.fits
    echo " "
    done
    done
fi

if [ $twoparter == y ]
then
    for quadrant in 1 2 3 4; do
    for run in a b c d; do
    if [ ! -e "$PT2_DIR/vmifuscience1${run}.sof" ]
    then
	   break       	   #if we've only got 3 obs, then we should quit.
    fi
    echo " "
    echo "EXECUTING for VIMOS quadrant ${quadrant}: --> esorex vmifuscience  vmifuscience${quadrant}${run}.sof"

        #Not all switches have been explored.

      esorex --suppress-prefix=true  \
             --output-dir=$PRO_DIR   \
             --output-readonly=false \
             --suppress-prefix=true  \
             --suppress-link=true    \
             --log-level=off		 \
             vmifuscience            \
             --CleanBadPixel=true   \
             --CalibrateFlux=false   \
             $PT2_DIR/vmifuscience${quadrant}${run}.sof

      echo " "
    echo "Renaming product to $PRO_DIR/ifu_fov${quadrant}${run}_pt2.fits"
    mv $PRO_DIR/ifu_fov.fits $PRO_DIR/ifu_fov${quadrant}${run}_pt2.fits
    echo " "
    echo "Renaming product to $PRO_DIR/ifu_science_reduced${quadrant}${run}_pt2.fits"
    mv $PRO_DIR/ifu_science_reduced.fits $PRO_DIR/ifu_science_reduced${quadrant}${run}_pt2.fits
    echo " "
    done
    done
fi
rm -rf *.paf
fi



#VIMOS IFU COMBINE
#Use the VIMOS Pipeline to combine the field of views for each quadrant into one.  Not necessary for science work, but is a nice check to see that the data looks right.

if [ $combine == y ]
then
for run in a b c d; do
  if [ ! -e "$SOF_DIR/vmifuscience1${run}.sof" ]
  then
	break       	   #if we've only got 3 obs, then we should quit.
  fi
echo "EXECUTING: --> esorex vmifucombine vmifucombine${run}.sof"
  
#Not all switches have been explored.
  
esorex --suppress-prefix=true  \
       --output-dir=$PRO_DIR     \
       --output-readonly=false \
       --suppress-prefix=true  \
       --suppress-link=true    \
       --log-level=off		 \
       vmifucombine            \
       $SOF_DIR/vmifucombine${run}.sof
       
echo "Renaming product to $PRO_DIR/ifu_full_fov${run}.fits"
echo " "
mv $PRO_DIR/ifu_full_fov.fits $PRO_DIR/ifu_full_fov${run}.fits
done

if [ $rotation == y ]
then
    for run in a b c d; do
    if [ ! -e "$ROT_DIR/vmifuscience1${run}.sof" ]
    then
	   break       	   #if we've only got 3 obs, then we should quit.
    fi
    echo "EXECUTING: --> esorex vmifucombine vmifucombine${run}.sof"
  
        #Not all switches have been explored.
  
    esorex --suppress-prefix=true  \
            --output-dir=$PRO_DIR     \
            --output-readonly=false \
            --suppress-prefix=true  \
            --suppress-link=true    \
            --log-level=off		 \
            vmifucombine            \
            $ROT_DIR/vmifucombine${run}.sof
       
    echo "Renaming product to $PRO_DIR/ifu_full_fov${run}_180.fits"
    echo " "
    mv $PRO_DIR/ifu_full_fov.fits $PRO_DIR/ifu_full_fov${run}_180.fits
    done
fi

if [ $twoparter == y ]
then
    for run in a b c d; do
    if [ ! -e "$PT2_DIR/vmifuscience1${run}.sof" ]
    then
	   break       	   #if we've only got 3 obs, then we should quit.
    fi
    echo "EXECUTING: --> esorex vmifucombine vmifucombine${run}.sof"
  
        #Not all switches have been explored.
  
    esorex --suppress-prefix=true  \
            --output-dir=$PRO_DIR     \
            --output-readonly=false \
            --suppress-prefix=true  \
            --suppress-link=true    \
            --log-level=off		 \
            vmifucombine            \
            $PT2_DIR/vmifucombine${run}.sof
       
    echo "Renaming product to $PRO_DIR/ifu_full_fov${run}_pt2.fits"
    echo " "
    mv $PRO_DIR/ifu_full_fov.fits $PRO_DIR/ifu_full_fov${run}_pt2.fits
    done
fi
	rm -rf *.paf
fi

#VIMOS COMBINE CUBE
#Use the Vimos Pipeline to turn the reduced data into the data cubes.  This is probably completely useless because the VIMOS has no procedure for subtracting skylines or identifying dead fibers.

if [ $cube == y ]
then
for run in a b c d; do
  if [ ! -e "$SOF_DIR/vmifuscience1${run}.sof" ]
  then
	break       	   #if we've only got 3 obs, then we should quit.
  fi
    echo "EXECUTING: --> esorex vmifucombine vmifucombine${run}.sof"

#Not all switches have been explored, and probably never will because the VIMOS pipeline is almost entirely, but not quite, completely useless.
  
    esorex --suppress-prefix=true  \
           --output-dir=$PRO_DIR     \
           --output-readonly=false \
           --suppress-prefix=true  \
           --suppress-link=true    \
           --log-level=off		 \
           vmifucombinecube        \
          $SOF_DIR/vmifucombinecube${run}.sof
    
    echo "Renaming product to $PRO_DIR/ifu_science_cube${run}_idl.fits"
    mv $PRO_DIR/ifu_science_cube.fits $PRO_DIR/ifu_science_cube${run}_vimos.fits

done

    if [ $rotation == y ]
    then
        for run in a b c d; do
          if [ ! -e "$ROT_DIR/vmifuscience1${run}.sof" ]
          then
        	break       	   #if we've only got 3 obs, then we should quit.
          fi
       echo "EXECUTING: --> esorex vmifucombine vmifucombine${run}.sof"

#Not all switches have been explored, and probably never well because the VIMOS pipeline is almost entirely, but not quite, completely useless.
  
        esorex --suppress-prefix=true  \
               --output-dir=$PRO_DIR     \
               --output-readonly=false \
               --suppress-prefix=true  \
               --suppress-link=true    \
               --log-level=off		 \
               vmifucombinecube        \
               $ROT_DIR/vmifucombinecube${run}.sof

        echo "Renaming product to $PRO_DIR/ifu_science_cube${run}_vimos_180.fits"
        mv $PRO_DIR/ifu_science_cube.fits $PRO_DIR/ifu_science_cube${run}_vimos_180.fits
        done
    fi

    if [ $twoparter == y ]
    then
        for run in a b c d; do
          if [ ! -e "$PT2_DIR/vmifuscience1${run}.sof" ]
          then
        	break       	   #if we've only got 3 obs, then we should quit.
          fi
       echo "EXECUTING: --> esorex vmifucombine vmifucombine${run}.sof"

#Not all switches have been explored, and probably never well because the VIMOS pipeline is almost entirely, but not quite, completely useless.
  
        esorex --suppress-prefix=true  \
               --output-dir=$PRO_DIR     \
               --output-readonly=false \
               --suppress-prefix=true  \
               --suppress-link=true    \
               --log-level=off		 \
               vmifucombinecube        \
               $PT2_DIR/vmifucombinecube${run}.sof

        echo "Renaming product to $PRO_DIR/ifu_science_cube${run}_vimos_pt2.fits"
        mv $PRO_DIR/ifu_science_cube.fits $PRO_DIR/ifu_science_cube${run}_vimos_pt2.fits
        done
    fi
    rm -rf *.paf
fi


#IDL DATA QUADRANT CREATION
#Redo some VIMOS Pipeline stuff in IDL because it's needed for the rest of the IDL scripts.  This takes the reduced spectra from the VIMOS Pipeline and creates a data cube for that quadrant.

if [ $make_cube_vimos == y ]
then
    echo "Using IDL to make the cube quadrants"
    #Take in just the pro dir and cal dir, inside the IDL script the files to be used are defined.
    export infile1=$PRO_DIR/
    export infile2=$CAL_DIR/
    for quadrant in 1 2 3 4; do
        echo " "
        echo "EXECUTING for VIMOS quadrant ${quadrant}: --> make_cube_vimos"
        for run in a b c d; do
            if [ ! -e "$SOF_DIR/vmifuscience1${run}.sof" ]
            then
                break       	   #if we've only got 3 obs, then we should quit.
            fi
            export fiber_mask=$SOF_DIR/bad_fibers_${quadrant}.txt

idl << EOF
.comp spectra_to_cube_quadrant.pro
spectra_to_cube_quadrant,'${quadrant}','${run}','dummy'
EOF

        done
    done

    if [ $rotation == y ]
    then
        echo "Using IDL to make the cube quadrants"
        #Take in just the pro dir and cal dir, inside the IDL script the files to be used are defined.
        export infile1=$PRO_DIR/
        export infile2=$CAL_DIR/
        export infile3=$ROT_DIR/
        for quadrant in 1 2 3 4; do
            echo " "
            echo "EXECUTING for VIMOS quadrant ${quadrant}: --> make_cube_vimos"
            for run in a b c d; do
                if [ ! -e "$ROT_DIR/vmifuscience1${run}.sof" ]
                then
                    break       	   #if we've only got 3 obs, then we should quit.
                fi
                export fiber_mask=$ROT_DIR/bad_fibers_${quadrant}.txt
idl << EOF
.comp spectra_to_cube_quadrant.pro
spectra_to_cube_quadrant,'${quadrant}','${run}','180'
EOF
            done
        done
    fi
    
    if [ $twoparter == y ]
    then
        echo "Using IDL to make the cube quadrants"
        #Take in just the pro dir and cal dir, inside the IDL script the files to be used are defined.
        export infile1=$PRO_DIR/
        export infile2=$CAL_DIR/
        export infile3=$PT2_DIR/
        for quadrant in 1 2 3 4; do
            echo " "
            echo "EXECUTING for VIMOS quadrant ${quadrant}: --> make_cube_vimos"
            for run in a b c d; do
                if [ ! -e "$PT2_DIR/vmifuscience1${run}.sof" ]
                then
                    break       	   #if we've only got 3 obs, then we should quit.
                fi
                export fiber_mask=$PT2_DIR/bad_fibers_${quadrant}.txt
idl << EOF
.comp spectra_to_cube_quadrant.pro
spectra_to_cube_quadrant,'${quadrant}','${run}','pt2'
EOF
            done
        done
    fi

fi



#CREATE SINGULAR CUBE
#This takes the four individual cubes from the make_cube_vimos IDL script and combines them into one cube.

if [ $make_idl_cube == y ]
then
    echo "Using IDL to combine the cube quadrants"
    export infile1=$PRO_DIR/
    for run in a b c d; do
        if [ ! -e "$SOF_DIR/vmifuscience1${run}.sof" ]
        then
            break       	   #if we've only got 3 obs, then we should quit.
        fi
idl << EOF
.comp combine_cube_quadrants.pro
combine_cube_quadrants,'${run}','dummy'
EOF
    done

    if [ $rotation == y ]
    then
        echo "Using IDL to combine the cube quadrants"
        export infile1=$PRO_DIR/
        for run in a b c d; do
            if [ ! -e "$ROT_DIR/vmifuscience1${run}.sof" ]
            then
	           break       	   #if we've only got 3 obs, then we should quit.
            fi
idl << EOF
set_colours
.comp combine_cube_quadrants.pro
combine_cube_quadrants,'${run}','180'
EOF
        done
    fi
    if [ $twoparter == y ]
    then
        echo "Using IDL to combine the cube quadrants"
        export infile1=$PRO_DIR/
        for run in a b c d; do
            if [ ! -e "$PT2_DIR/vmifuscience1${run}.sof" ]
            then
	           break       	   #if we've only got 3 obs, then we should quit.
            fi
idl << EOF
set_colours
.comp combine_cube_quadrants.pro
combine_cube_quadrants,'${run}','pt2'
EOF
        done
    fi
fi

#MAKE THE FINAL STACKED CUBE USING THE IDL MOSAIC SCRIPT

if [ $mosaic == y ]
then

    #Run the Mosaic procedure
    echo "Mosiac IFU Stacking"
    
    export infile=$SOF_DIR/idl.ifudat
    
    idl /Users/jimmy/Astro/coms/mosaic.com

    echo "Moving test file to project directory"
    mv test.fits /$PRO_DIR/temp.fits
fi

if [ $mask == y ]
then
    export infile1=$PRO_DIR/
    export final_mask=$SOF_DIR/$2_mask.txt
    
idl << EOF
.comp final_mask.pro
final_mask,'$1','$2'
EOF
fi


if [ $sncut == y ]
then
    #Perform Signal to Noise Cut
    echo "S/N Cut"
    #only input is the test.fits file   
    export infile=$PRO_DIR/$2/$1$2.fits
    export outfile1=$PRO_DIR/voronoi_2d_binning.txt
    export sncut=3.0
#    /Applications/itt/idl/idl/bin/idl /Users/jimmy/Astro/coms/sncut.com
idl <<EOF
.comp signal_noise_cut.pro
signal_noise_cut
EOF
    export outfile1=$PRO_DIR/radial_2d_binning.txt
    export sncut=1.0
idl <<EOF
.comp signal_noise_cut.pro
signal_noise_cut
EOF
fi

if [ $vbinning == y ]
then
    #Perform the Binning
    echo "Voronoi Binning"
    export infile=$PRO_DIR/voronoi_2d_binning.txt
    export outfile1=$PRO_DIR/voronoi_2d_binning_output.txt
    export outfile2=$PRO_DIR/voronoi_2d_bins.txt
    export targetsn=5.0
    #/Applications/itt/idl/idl/bin/idl /Users/jimmy/Astro/coms/vbinning.com
idl <<EOF
set_colours
.comp vbinning.pro
vbinning
EOF
fi

if [ $radial == y ]
then
    echo "Radial Binning and singular bin"
    export radius=$r_e
    export infile=$PRO_DIR/radial_2d_binning.txt
    export outfile1=$PRO_DIR/radial_2d_binning_output.txt
    export outfile2=$PRO_DIR/radial_2d_bins.txt
    export target=$1
idl << EOF
.comp radial_bin.pro
radial_bin
EOF

    export infile=$PRO_DIR/voronoi_2d_binning.txt
    export outfile1=$PRO_DIR/one_bin_output.txt
    export outfile2=$PRO_DIR/one_bin_bins.txt

idl <<EOF
.comp one_bin.pro
one_bin
EOF
fi

if [ $ppxf == y ]
then
    #Find Velocities
    echo "PPXF Velocities"
    export infile1=$PRO_DIR/$2/$1$2.fits
    export infile2=$PRO_DIR/one_bin_output.txt
    export infile3=$ASTRO_DIR/MILES_library
    export infile4=$PRO_DIR/one_bin_bins.txt
    export outfile=$PRO_DIR/ppxf_one_bin_output
    export start_range=1600
    export end_range=2600
    export template_list="/s025*.fits"
    export monte_iterations=10
    
idl << EOF
set_colours
.comp jimmy_ppxf.pro
jimmy_ppxf
EOF
    rm -rf /$PRO_DIR/$2/ppxf_fit_one
    mv ppxf_fits /$PRO_DIR/$2/ppxf_fit_one
    
    
    export infile2=$PRO_DIR/voronoi_2d_binning_output.txt
    export infile4=$PRO_DIR/voronoi_2d_bins.txt
    export outfile=$PRO_DIR/ppxf_v_bin_output
    
idl << EOF
set_colours
.comp jimmy_ppxf.pro
jimmy_ppxf
EOF
    rm -rf /$PRO_DIR/$2/ppxf_fits
    mv ppxf_fits /$PRO_DIR/$2/
    
    export infile2=$PRO_DIR/radial_2d_binning_output.txt
    export infile4=$PRO_DIR/radial_2d_bins.txt
    export outfile=$PRO_DIR/ppxf_rad_bin_output
idl << EOF
set_colours
.comp jimmy_ppxf.pro
jimmy_ppxf
EOF
    rm -rf /$PRO_DIR/$2/ppxf_fits_rad
    mv ppxf_fits /$PRO_DIR/$2/ppxf_fits_rad
fi

if [ $plot == y ]
then
    #Make Pretty Plots
    echo "Plot Data"
    export infile1=$PRO_DIR/one_bin_bins.txt
    export infile2=$PRO_DIR/ppxf_one_bin_output
    export infile3=$PRO_DIR/one_bin_output.txt
idl << EOF
set_colours
.comp display_data.pro
display_data,'one','$1'
EOF

    export infile1=$PRO_DIR/voronoi_2d_bins.txt
    export infile2=$PRO_DIR/ppxf_v_bin_output
    export infile3=$PRO_DIR/voronoi_2d_binning_output.txt
idl << EOF
set_colours
.comp display_data.pro
display_data,'vbinned','$1'
EOF

    export infile1=$PRO_DIR/radial_2d_bins.txt
    export infile2=$PRO_DIR/ppxf_rad_bin_output
    export infile3=$PRO_DIR/radial_2d_binning_output.txt
idl << EOF
set_colours
.comp display_data.pro
display_data,'radial','$1'
EOF

        mv table_one.txt /$PRO_DIR/$2/table_one.txt
        mv sigma_scale.eps /$PRO_DIR/$2/sigma_scale.eps
        mv velocity_scale.eps /$PRO_DIR/$2/velocity_scale.eps
        mv table.txt /$PRO_DIR/$2/table.txt
        mv sigma_rad.eps /$PRO_DIR/$2/sigma_rad.eps
        mv velocity_rad.eps /$PRO_DIR/$2/velocity_rad.eps
        mv table_rad.txt /$PRO_DIR/$2/table_rad.txt
        mv velocity.eps /$PRO_DIR/$2/velocity.eps
        mv signal_noise.eps /$PRO_DIR/$2/signal_noise.eps
fi

#not ready to use lambda yet.
#export lambda="n"

#if [ $lambda == y ]
#then
#Lambda still needs lots of work.
#echo "Lambda"
#export infile=$PRO_DIR
#export galaxy=$1
#idl << EOF
#set_colours
#.comp SAURON_lambda.pro
#SAURON_lambda
#EOF
#/Applications/itt/idl/bin/idl /Users/jimmy/Astro/coms/lambda.com
#fi