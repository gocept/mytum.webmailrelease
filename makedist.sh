#!/bin/bash

set -e

VERSION=`sed -ne '/^release *=/s/^release *= *\(.*\)/\1/p' buildout.cfg`
CURDIR=$PWD
DISTDIR=$CURDIR/dist
HOST=download.gocept.com
DOWNLOADDIR=/var/www/download.gocept.com/htdocs/webmailer/
TARBALL=$DISTDIR/webmailer-$VERSION.tar.bz2

echo $VERSION >VERSION.txt

./bin/buildout

cd parts/omelette
tar cj --dereference --exclude .svn --exclude "*.pyc" --exclude "*.pyo" -f $TARBALL gocept/imapapi gocept/restmail gocept/webmail gocept/__init__.py mytum ../../CHANGES.txt ../../INSTALL.txt ../../VERSION.txt

rm ../../VERSION.txt

if [ `echo $VERSION |grep b` ]; then
    LATEST="testing"
else
    LATEST="final"
fi
LATESTFILE=$DISTDIR/$LATEST.txt

echo $VERSION >$LATESTFILE

scp $TARBALL $HOST:$DOWNLOADDIR
scp $LATESTFILE $HOST:$DOWNLOADDIR
ssh $HOST chmod g+w $DOWNLOADDIR/* 2>/dev/null
