#!/bin/bash

if [ -f $ACONTIS_EC_MASTER_SDK_PACKAGE ] ; then 
	mkdir -p acontis/EC-Master
	pushd acontis/EC-Master
	tar xf $ACONTIS_EC_MASTER_SDK_PACKAGE
	popd
else
	echo acontis EC-Master package $ACONTIS_EC_MASTER_SDK_PACKAGE not found! 
fi
