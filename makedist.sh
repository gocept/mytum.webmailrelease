#!/bin/bash

set -e

VERSION=`sed -ne '/^release *=/s/^release *= *\(.*\)/\1/p' buildout.cfg`
CURDIR=$PWD
DISTDIR=$CURDIR/dist
DOWNLOADDIR=download.gocept.com:/var/www/download.gocept.com/htdocs/webmailer/
TARBALL=$DISTDIR/webmailer-$VERSION.tar.bz2

./bin/buildout

cd parts/omelette
tar cj --dereference --exclude .svn --exclude "*.pyc" --exclude "*.pyo" -f $TARBALL gocept/imapapi gocept/restmail gocept/webmail gocept/__init__.py mytum ../../CHANGES.txt ../../INSTALL.txt

if [ `echo $VERSION |grep b` ]; then
    LATEST="testing"
else
    LATEST="final"
fi
LATESTFILE=$DISTDIR/$LATEST.txt

echo $VERSION >$LATESTFILE

scp $TARBALL $DOWNLOADDIR
scp $LATESTFILE $DOWNLOADDIR
