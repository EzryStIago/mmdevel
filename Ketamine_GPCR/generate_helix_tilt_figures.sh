#!/bin/bash
#
# Generates the helix tilt plots for the ketamine-GPCR binding affinity project.
# To make the plots look prettier, you will have to modify helix_tilt.py because
# that generates the Gnuplot script.

MMDEVEL=$HOME/mmdevel
B=$HOME

# Format of each entry is <helix-def>:<dir>
# Where dir is immediately under $B and helix-def is a helix-tilt.py helix spec or shortcut
SIMULATIONS="5c1m:MuOR/WithDISU 5c1m:MuOR/MD_SKE_r2.WithDISU 5c1m:MuOR/MD_SKP_r2 5c1m:MuOR/MD_SKP_r2_run2 $SIMULATIONS"
SIMULATIONS="5c1m:MuOR/MD_SKE_r2_HSP297 5c1m:MuOR/MD_SKE_r2_LEU147 $SIMULATIONS"
SIMULATIONS="5c1m:MuOR/MD_SKP_r2_HSP297 5c1m:MuOR/MD_SKP_r2_LEU147 $SIMULATIONS"
SIMULATIONS="4djh:KappaOR/MD_SKE_r2 4djh:KappaOR/MD_SKP_r2 $SIMULATIONS"
SIMULATIONS="4djh:KappaOR/MD_SKE_r2_HSP291 4djh:KappaOR/MD_SKP_r2_HSP291 $SIMULATIONS"
SIMULATIONS="5tvn:5HT2BR/MD_SKE_r2 5tvn:5HT2BR/MD_SKP_r2 $SIMULATIONS"

HERE=$PWD

for sim in $SIMULATIONS
do
    helixes=$(echo $sim | cut -d: -f1)
    dir=$(echo $sim | cut -d: -f2)
    cd $B/$dir/namd || exit
    echo Working on: $sim prod*.dcd
    gnuplot_script=`mktemp`
    python $MMDEVEL/helix_tilt.py $helixes ../step5_assembly.xplor_ext.psf ../step5_assembly.namd.pdb prod*.dcd > $gnuplot_script
    # gnuplot $gnuplot_script
    rm -f $gnuplot_script

    outname=$(echo $dir | sed s#/#-#)
    python $MMDEVEL/csv_stats.py helix-tilt.csv > $HOME/Dropbox/Ketamine_GPCR_Paper/HelixTilt/${outname}.csv
done

cd $HERE