#!/bin/bash

source ./prepare
./configure --prefix=$PREFIX CFLAGS='-g -O2' FFLAGS='-g -O2'

make
make install

make -C util/print_resid
make -C util/print_resid install

tempodir=$PREFIX/share/tempo
mkdir -p $tempodir
cat tempo.cfg.in | sed 's%@abs_top_srcdir@%'$tempodir'%' > $tempodir/tempo.cfg
cp -a tempo.hlp $tempodir
# clock files are in a separate package now:
#cp -a clock $tempodir
cp -a ephem $tempodir
cp -a obsys.dat $tempodir

cp -a util/dmxparse/dmxparse.py $PREFIX/bin/
cp -a util/res_avg/res_avg $PREFIX/bin/

# This foo will make conda automatically define a TEMPO env variable
# when the environment is activated.
etcdir=$PREFIX/etc/conda
mkdir -p $etcdir/activate.d
echo "setenv TEMPO $tempodir" > $etcdir/activate.d/tempo-env.csh
echo "export TEMPO=$tempodir" > $etcdir/activate.d/tempo-env.sh
mkdir -p $etcdir/deactivate.d
echo "unsetenv TEMPO" > $etcdir/deactivate.d/tempo-env.csh
echo "unset TEMPO" > $etcdir/deactivate.d/tempo-env.sh
