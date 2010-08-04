#!/bin/bash

set -e

VERSION=`sed -ne '/^release *=/s/^release *= *\(.*\)/\1/p' buildout.cfg`
CURDIR=$PWD
TARBALL=$CURDIR/dist/webmailer-$VERSION.tar.bz2

./bin/buildout

cd parts/omelette
tar cj --dereference --exclude .svn --exclude "*.pyc" --exclude "*.pyo" -f $TARBALL gocept/imapapi gocept/restmail gocept/webmail gocept/__init__.py mytum ../../CHANGES.txt ../../INSTALL.txt

scp $TARBALL download.gocept.com:/var/www/download.gocept.com/htdocs/webmailer
