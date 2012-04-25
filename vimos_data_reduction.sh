#!/bin/bash
#Data reduction script written by Jimmy.

#This script takes two inputs, the SDSS-C4 target name of the galaxy, which will be used to create and identify the proper project folder.
#2nd input is the mask to be applied, either all, main, comp, or 2ndcomp
#Called like: vimos_data_reduction.sh 1050 all
#Should only need to edit the directories for the following files, and then most scripts will work when called from here.
#Of course that assumes you're following my naming scheme.

date

#Astro_Dir is the top level directory containing raw and reduced data.
ASTRO_DIR=$HOME/Astro
#Reduced dir is the directory containing the project directories for each galaxy and supporting files
REDUCED_DIR=$ASTRO_DIR/reduced
#Pro Dir is the project directory for that particular galaxy.  This is where the outputs are actually sent.
PRO_DIR=$REDUCED_DIR/$1pro
#SOF dir contains the "set of frames" files used by the VIMOS pipeline and is unique to each directory.
SOF_DIR=$REDUCED_DIR/$1pt1sof
#Cal Dir contains the calbration files used by both VIMOS Pipeline and IDL
CAL_DIR=$REDUCED_DIR/cal
#Used to automatically pull the IDL scripts out of testing mode.
export not_testing=1

#Take the input from the command line argument.
if [ $# -ne 2 ]; then
        echo "No target given."
        exit 1
fi
echo "Input target number: " $1
echo "Input object of interest: " $2

#If the project directory for this galaxy doesn't exist, we will make it.
if [ ! -d $PRO_DIR ]; then
    mkdir $PRO_DIR
    mkdir $PRO_DIR/all
    mkdir $PRO_DIR/main
    mkdir $PRO_DIR/comp
    mkdir $PRO_DIR/2ndcomp
fi

#If there is a SOF directory for this galaxy, then we will remove the sym links to whatever galaxy may have been previously used, and add new symlinks for our current directory.
#symlinks are used because it's the easiest way of using one script to do everything without having to refer to a specific project or sof directory every time.

if [ -d $SOF_DIR ]; then
	if [ $(whoami) != 'jimmyerickson' ]; then
    	rm -rf $REDUCED_DIR/pro
    	rm -rf $REDUCED_DIR/sof
    	ln -s $REDUCED_DIR/$1pro $REDUCED_DIR/pro
    	ln -s $REDUCED_DIR/$1sof $REDUCED_DIR/sof
    fi
else
    echo "Target sof directory not found in reduced data folder."
    exit 1
fi



#QUESTIONS TIME
#This determines which steps in the process will be performed.  The default for all steps is no, so unless a y is entered, that step will be skipped.  They are structured in this manner so that one can just hit enter a bunch of times to skip those steps.

export default="n"

#This sets all the properties for running on the supercomputing cluster where everything runs better automatically.
if [ $(whoami) == 'jimmyerickson' ]; then
	calibration="n"
	science="n"
	idl_spectra_to_cube="n"
	mosaic="n"
	mask="n"
	sncut="n"
	bin="n"
	ppxf="n"
	plot="n"
	monte="n"
	plot="n"
	lambda="y"
else
	read -p "Create Master Bias and Calibration Files?: " -e t1
	if [ -n "$t1" ]; then
		calibration="$t1"
	else
		calibration="$default"
	fi

	read -p "Extract Science Spectra and create cubes using VIMOS?: " -e t1
	if [ -n "$t1" ]; then
		science="$t1"
	else
		science="$default"
	fi

	read -p "Use IDL to create data cubes?: " -e t1
	if [ -n "$t1" ]; then
		idl_spectra_to_cube="$t1"
	else
		idl_spectra_to_cube="$default"
	fi

	read -p "Use make mosaic to stack cubes?: " -e t1
	if [ -n "$t1" ]; then
		mosaic="$t1"
	else
		mosaic="$default"
	fi

	read -p "Perform mask?: " -e t1
	if [ -n "$t1" ]; then
		mask="$t1"
	else
		mask="$default"
	fi

	read -p "Perform S/N cut?: " -e t1
	if [ -n "$t1" ]; then
		sncut="$t1"
	else
		sncut="$default"
	fi

	read -p "Bin the data?: " -e t1
	if [ -n "$t1" ]; then
		bin="$t1"
	else
		bin="$default"
	fi

	read -p "Perform PPXF?: " -e t1
	if [ -n "$t1" ]; then
		ppxf="$t1"
	else
		ppxf="$default"
	fi

	read -p "Plot Data?: " -e t1
	if [ -n "$t1" ]; then
		plot="$t1"
	else
		plot="$default"
	fi

	read -p "Perform Monte Carlo Simulation?: " -e t1
	if [ -n "$t1" ]; then
		mask="$t1"
		sncut="$t1"
		bin="$t1"
		ppxf="$t1"
		plot="$t1"
		monte="$t1"
	else
		monte="$default"
	fi

	export montecarlointoppxf=$monte

	read -p "Perform Lambda?: " -e t1
	if [ -n "$t1" ]; then
		lambda="$t1"
	else
		lambda="$default"
	fi

fi

#Pull in environmental variables like redshift and sky fibers
. $SOF_DIR/$1_env.sh



#MASTER BIAS AND CALIBRATION FILES CREATION
#Using the VIMOS pipeline, create the master bias frames that will be used for calibration.
if [ $calibration == y ]; then
	for pointing in 1 2 3 4 5 180; do
		SOF_DIR=$REDUCED_DIR/$1pt${pointing}sof
		if [ -d $SOF_DIR ]; then
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
				echo "Renaming product to $PRO_DIR/master_bias${quadrant}_pt${pointing}.fits"
				mv $PRO_DIR/master_bias.fits $PRO_DIR/master_bias${quadrant}_pt${pointing}.fits
				echo " "
			done
		fi
	done
	#VIMOS IFU CALIBRATION
	#Creates the calibration files using the master bias above, as well as the other inputs specified in the SOF.
	for pointing in 1 2 3 4 5 180; do
		SOF_DIR=$REDUCED_DIR/$1pt${pointing}sof
		if [ -d $SOF_DIR ]; then
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
        			--LineIdent=Blind       \
        			--CleanBadPixel=true   \
        			$SOF_DIR/vmifucalib${quadrant}.sof

				echo " "
				echo "Renaming product to $PRO_DIR/ifu_arc_spectrum_extracted${quadrant}_pt${pointing}.fits"
				mv $PRO_DIR/ifu_arc_spectrum_extracted.fits $PRO_DIR/ifu_arc_spectrum_extracted${quadrant}_pt${pointing}.fits
				echo " "
				echo "Renaming product to $PRO_DIR/ifu_flat_spectrum_extracted${quadrant}_pt${pointing}.fits"
				mv $PRO_DIR/ifu_flat_spectrum_extracted.fits $PRO_DIR/ifu_flat_spectrum_extracted${quadrant}_pt${pointing}.fits
				echo " "
				echo "Renaming product to $PRO_DIR/ifu_ids${quadrant}_pt${pointing}.fits"
				mv $PRO_DIR/ifu_ids.fits $PRO_DIR/ifu_ids${quadrant}_pt${pointing}.fits
				echo " "
				echo "Renaming product to $PRO_DIR/ifu_master_screen_flat${quadrant}_pt${pointing}.fits"
				mv $PRO_DIR/ifu_master_screen_flat.fits $PRO_DIR/ifu_master_screen_flat${quadrant}_pt${pointing}.fits
				echo " "
				echo "Renaming product to $PRO_DIR/ifu_trace${quadrant}_pt${pointing}.fits"
				mv $PRO_DIR/ifu_trace.fits $PRO_DIR/ifu_trace${quadrant}_pt${pointing}.fits
				echo " "
				echo "Renaming product to $PRO_DIR/ifu_transmission${quadrant}_pt${pointing}.fits"
				mv $PRO_DIR/ifu_transmission.fits $PRO_DIR/ifu_transmission${quadrant}_pt${pointing}.fits
				echo " "
			done
		fi
	done
	rm *.paf
	SOF_DIR=$REDUCED_DIR/$1pt1sof
fi



#VIMOS IFU SCIENCE EXTRACTION
#Create the field of view for each quadrant, and reduce the science frames using the calibration files above.
if [ $science == y ]; then
	for pointing in 1 2 3 4 5 180; do
		SOF_DIR=$REDUCED_DIR/$1pt${pointing}sof
		if [ -d $SOF_DIR ]; then
			for quadrant in 1 2 3 4; do
				for run in a b c d; do
					if [ -e "$SOF_DIR/vmifuscience1${run}.sof" ]; then
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
						echo "Renaming product to $PRO_DIR/ifu_fov${quadrant}${run}_pt${pointing}.fits"
						mv $PRO_DIR/ifu_fov.fits $PRO_DIR/ifu_fov${quadrant}${run}_pt${pointing}.fits
						echo " "
						echo "Renaming product to $PRO_DIR/ifu_science_reduced${quadrant}${run}_pt${pointing}.fits"
						mv $PRO_DIR/ifu_science_reduced.fits $PRO_DIR/ifu_science_reduced${quadrant}${run}_pt${pointing}.fits
						echo " "
					fi
				done
			done
		fi
	done
	rm -rf *.paf
	#VIMOS IFU COMBINE
	#Use the VIMOS Pipeline to combine the field of views for each quadrant into one.  Not necessary for science work, but is a nice check to see that the data looks right.
	for pointing in 1 2 3 4 5 180; do
		SOF_DIR=$REDUCED_DIR/$1pt${pointing}sof
		if [ -d $SOF_DIR ]; then
			for quadrant in 1 2 3 4; do
				for run in a b c d; do
					if [ -e "$SOF_DIR/vmifuscience1${run}.sof" ]; then
						echo " "
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
       
						echo "Renaming product to $PRO_DIR/ifu_full_fov${run}_pt${pointing}.fits"
						echo " "
						mv $PRO_DIR/ifu_full_fov.fits $PRO_DIR/ifu_full_fov${run}_pt${pointing}.fits
					fi
				done
			done
		fi
	done
	#VIMOS COMBINE CUBE
	#Use the Vimos Pipeline to turn the reduced data into the data cubes.  This is probably completely useless because the VIMOS has no procedure for subtracting skylines or identifying dead fibers.
	for pointing in 1 2 3 4 5 180; do
		SOF_DIR=$REDUCED_DIR/$1pt${pointing}sof
		if [ -d $SOF_DIR ]; then
			for quadrant in 1 2 3 4; do
				for run in a b c d; do
					if [ -e "$SOF_DIR/vmifuscience1${run}.sof" ]; then
						echo " "
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
    
						echo "Renaming product to $PRO_DIR/ifu_science_cube${run}_vimos_pt${pointing}.fits"
						mv $PRO_DIR/ifu_science_cube.fits $PRO_DIR/ifu_science_cube${run}_vimos_pt${pointing}.fits
					fi
				done
			done
		fi
	done
	SOF_DIR=$REDUCED_DIR/$1pt1sof
fi



#IDL DATA QUADRANT CREATION
#Redo some VIMOS Pipeline stuff in IDL because it's needed for the rest of the IDL scripts.  This takes the reduced spectra from the VIMOS Pipeline and creates a data cube for that quadrant.
if [ $idl_spectra_to_cube == y ]; then
    echo "Using IDL to make the cube quadrants"
    #Take in just the pro dir and cal dir, inside the IDL script the files to be used are defined.
    export infile1=$PRO_DIR/
    export infile2=$CAL_DIR/
    for pointing in 1 2 3 4 5 180; do
    	SOF_DIR=$REDUCED_DIR/$1pt${pointing}sof
		if [ -d $SOF_DIR ]; then
			for quadrant in 1 2 3 4; do
				echo " "
        		echo "Using IDL to extract spectra from Quadrant ${quadrant} Part ${pointing}"
				for run in a b c d; do
					if [ -e "$SOF_DIR/vmifuscience1${run}.sof" ]; then
			            export fiber_mask=$SOF_DIR/bad_fibers_${quadrant}.txt
idl << EOF
.comp spectra_to_cube_quadrant.pro
spectra_to_cube_quadrant,'${quadrant}','${run}','pt${pointing}'
EOF
					fi
				done
			done
		fi
	done
    for pointing in 1 2 3 4 5 180; do
    	SOF_DIR=$REDUCED_DIR/$1pt${pointing}sof
		if [ -d $SOF_DIR ]; then
			for run in a b c d; do
				if [ -e "$SOF_DIR/vmifuscience1${run}.sof" ]; then
					echo " "
        			echo "Combining quadrants into a cube for Run ${run} Pointing ${pointing}"
idl << EOF
.comp combine_cube_quadrants.pro
combine_cube_quadrants,'${run}','pt${pointing}'
EOF
				fi
			done
		fi
	done
	SOF_DIR=$REDUCED_DIR/$1pt1sof
fi



#MAKE THE FINAL STACKED CUBE USING THE IDL MOSAIC SCRIPT
if [ $mosaic == y ]; then
	#Finding the brightest point to attempt automatic stacking
	echo "Finding brightest pixels"
	
	export infile1=$PRO_DIR
	export outfile1=$SOF_DIR
	
idl << EOF
.comp brightest_point.pro
brightest_point
EOF
	
    #Run the Mosaic procedure
    echo "Mosiac IFU Stacking"
    
    if [ -e "$SOF_DIR/idl.ifudat" ]; then
    	export infile=$SOF_DIR/idl.ifudat
    else
	    export infile=$SOF_DIR/auto.ifudat
    fi
    
    idl /Users/jimmy/Astro/coms/mosaic.com

    echo "Moving test file to project directory"
    mv test.fits /$PRO_DIR/temp.fits
fi


#MASK TO OBSERVE ONLY THE BCG OR COMPANION
if [ $mask == y ]; then
    export infile1=$PRO_DIR/
    export final_mask=$SOF_DIR/$2_mask.txt
    
idl << EOF
.comp final_mask.pro
final_mask,'$1','$2'
EOF
fi



#PERFORM THE SIGNAL TO NOISE CUT
if [ $sncut == y ]; then
    #Perform Signal to Noise Cut
    echo "S/N Cut"
    #only input is the test.fits file   
    export infile=$PRO_DIR/$2/$1$2.fits
    export outfile1=$PRO_DIR/$2/voronoi_2d_binning.txt
    export galaxy=$1
    export sncut=3.0
    # Using the com file allows you to stop and check the s/n cut, EOF requires no user intervention
#    /Applications/itt/idl/idl/bin/idl /Users/jimmy/Astro/coms/sncut.com
idl <<EOF
.comp signal_noise_cut.pro
signal_noise_cut
EOF
    export outfile1=$PRO_DIR/$2/radial_2d_binning.txt
    export sncut=1.0
idl <<EOF
.comp signal_noise_cut.pro
signal_noise_cut
EOF

fi

if [ $bin == y ]; then
    #Perform the Binning
    echo "Voronoi Binning"
    export infile=$PRO_DIR/$2/voronoi_2d_binning.txt
    export outfile1=$PRO_DIR/$2/voronoi_2d_binning_output.txt
    export outfile2=$PRO_DIR/$2/voronoi_2d_bins.txt
    export targetsn=5.0
    #/Applications/itt/idl/idl/bin/idl /Users/jimmy/Astro/coms/vbinning.com
idl <<EOF
.comp vbinning.pro
vbinning
EOF

    echo "Radial Binning and singular bin"
    export radius=$r_e
    export infile=$PRO_DIR
    export outfile1=$PRO_DIR/$2/radial_2d_binning_output.txt
    export outfile2=$PRO_DIR/$2/radial_2d_bins.txt
    export target=$1
idl <<EOF
.comp radial_bin.pro
radial_bin
EOF

    export infile=$PRO_DIR/$2/voronoi_2d_binning.txt
    export outfile1=$PRO_DIR/$2/one_bin_output.txt
    export outfile2=$PRO_DIR/$2/one_bin_bins.txt
idl <<EOF
.comp one_bin.pro
one_bin
EOF
fi

if [ $ppxf == y ]; then
    #Find Velocities
    echo "PPXF Velocities"
    export infile1=$PRO_DIR/$2/$1$2.fits
    export infile2=$PRO_DIR/$2/one_bin_output.txt
    export infile3=$ASTRO_DIR/MILES_library
    export infile4=$PRO_DIR/$2/one_bin_bins.txt
    export outfile=$PRO_DIR/$2/ppxf_one_bin_output
    export start_range=1600
    export end_range=2600
    export template_list="/s025*.fits"
    export monte_iterations=10
    
idl << EOF
.comp jimmy_ppxf.pro
jimmy_ppxf
EOF
    rm -rf /$PRO_DIR/$2/ppxf_fit_one
    if [ -d ppxf_fits ]; then
    	mv ppxf_fits /$PRO_DIR/$2/ppxf_fit_one
    fi
    
    export infile2=$PRO_DIR/$2/voronoi_2d_binning_output.txt
    export infile4=$PRO_DIR/$2/voronoi_2d_bins.txt
    export outfile=$PRO_DIR/$2/ppxf_v_bin_output
    
idl << EOF
.comp jimmy_ppxf.pro
jimmy_ppxf
EOF
    rm -rf /$PRO_DIR/$2/ppxf_fits
    if [ -d ppxf_fits ]; then
	    mv ppxf_fits /$PRO_DIR/$2/
    fi
    
    export infile2=$PRO_DIR/$2/radial_2d_binning_output.txt
    export infile4=$PRO_DIR/$2/radial_2d_bins.txt
    export outfile=$PRO_DIR/$2/ppxf_rad_bin_output
idl << EOF
.comp jimmy_ppxf.pro
jimmy_ppxf
EOF
    rm -rf /$PRO_DIR/$2/ppxf_fits_rad
    if [ -d ppxf_fits ]; then
	    mv ppxf_fits /$PRO_DIR/$2/ppxf_fits_rad
	fi
fi

if [ $plot == y ]; then
    #Make Pretty Plots
    echo "Plot Data"
    export infile1=$PRO_DIR/$2/one_bin_bins.txt
    export infile2=$PRO_DIR/$2/ppxf_one_bin_output
    export infile3=$PRO_DIR/$2/one_bin_output.txt
idl << EOF
.comp display_data.pro
display_data,'one','$1'
EOF

    export infile1=$PRO_DIR/$2/voronoi_2d_bins.txt
    export infile2=$PRO_DIR/$2/ppxf_v_bin_output
    export infile3=$PRO_DIR/$2/voronoi_2d_binning_output.txt
idl << EOF
.comp display_data.pro
display_data,'vbinned','$1'
EOF

    export infile1=$PRO_DIR/$2/radial_2d_bins.txt
    export infile2=$PRO_DIR/$2/ppxf_rad_bin_output
    export infile3=$PRO_DIR/$2/radial_2d_binning_output.txt
idl << EOF
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
        mv signal_noise_rad.eps /$PRO_DIR/$2/signal_noise_rad.eps
fi

if [ $lambda == y ]
	then
	echo "Running Lambda calculation"
	export indir=$PRO_DIR/$2/
#	if [ $2 == 'main' ]; then
#	    export onetwo="1"
#	fi
#	if [ $2 == 'all' ]; then
#	    export onetwo="1"
#	fi
#	if [ $2 == 'comp' ]; then
#	    export onetwo="2"
#	fi
#	echo "$onetwo"
#idl << EOF
#.comp jimmy_lambda.pro
#jimmy_lambda,'$1','$onetwo'
#EOF
idl << EOF
.comp lambda.pro
lambda,'$1','$2'
EOF

	#/Applications/itt/idl/bin/idl /Users/jimmy/Astro/coms/lambda.com
fi
date