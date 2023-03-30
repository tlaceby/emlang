#!/bin/bash

# Default build type and clean option
BUILD_TYPE=debug
CLEAN=true

# Process command-line options
while getopts ":dpc" opt; do
  case ${opt} in
    d )
      BUILD_TYPE=debug
      ;;
    p )
      BUILD_TYPE=release
      ;;
    c )
      CLEAN=true
      ;;
    \? )
      echo "Usage: build.sh [-d|-p] [-c]"
      exit 1
      ;;
  esac
done

# Remove the processed options
shift $((OPTIND -1))

# Clean the project if requested
if [ "${CLEAN}" = true ]; then
  make clean
fi

# Build the project using the Makefile
make BUILD_TYPE=${BUILD_TYPE} -j 4

# Check if the build was successful
if [ $? -eq 0 ]; then
  # Run the produced executable with the provided flags
  echo ""
  ./emu "$@"
  echo ""
  # Clean the project after running the executable if the -c flag is set
  if [ "${CLEAN}" = true ]; then
    make clean >> /dev/null
  fi
else
  echo "Build failed. Please check the error messages."
fi
