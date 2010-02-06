#!/bin/bash

function usage()
{
  echo "Usage: $0 <path to sdlExtern>"
}

if [[ $# == 0 ]]; then
  usage
  exit
else
  SDLEXTERN=$1
  if [[ ! -d ${SDLEXTERN}/include ]]; then
    echo "Error: $1 does not appear to be sdlExtern"
    usage
    exit
  fi
fi
# Make sure that it is an absolute path
cd ${SDLEXTERN}
SDLEXTERN=`pwd`
cd - >/dev/null

# Remove the build directories first
rm -Rf _SunOS_Debug _SunOS_Release

# Run the configure script
# Debug
mkdir _SunOS_Debug
cd _SunOS_Debug
../configure CFLAGS="-g -mcpu=ultrasparc3 -O" CPPFLAGS="-g -mcpu=ultrasparc3 -O" CC=gcc
cd src/libjasper
gmake
let exitCode=$?
if [ ${exitCode} -ne 0 ]
then
   echo "Failed to build" >&2
   exit ${exitCode}
fi
cd ../../..

# Release
mkdir _SunOS_Release
cd _SunOS_Release
../configure CFLAGS="-mcpu=ultrasparc3 -O2" CPPFLAGS="-mcpu=ultrasparc3 -O2" CC=gcc
cd src/libjasper
gmake
let exitCode=$?
if [ ${exitCode} -ne 0 ]
then
   echo "Failed to build" >&2
   exit ${exitCode}
fi
cd ../../..

# Copy the library archive files to sdlExtern
svn lock ${SDLEXTERN}/lib/libjasperd.a
svn lock ${SDLEXTERN}/lib/libjasper.a
cp -p _SunOS_Debug/src/libjasper/.libs/libjasper.a   ${SDLEXTERN}/lib/libjasperd.a
cp -p _SunOS_Release/src/libjasper/.libs/libjasper.a  ${SDLEXTERN}/lib/
ls -eFh ${SDLEXTERN}/lib/libjasperd.a ${SDLEXTERN}/lib/libjasper.a|sed 's/  */ /g'
echo "Done."

#end of script
