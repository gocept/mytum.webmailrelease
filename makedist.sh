#!/bin/bash

VERSION=`sed -ne '/^release *=/s/^release *= *\(.*\)/\1/p' buildout.cfg`
CURDIR=$PWD

./bin/buildout

cd parts/omelette
tar cj --dereference --exclude .svn --exclude "*.pyc" -f $CURDIR/dist/webmailer-$VERSION.tar.bz2 gocept/imapapi gocept/restmail gocept/webmail mytum/webmail ../../CHANGES.txt ../../INSTALL.txt