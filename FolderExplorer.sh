#!/usr/bin/bash

# FolderExplorer.sh
# Richard Hawkins
# Created 01-14-2023
# A tool for folder and file exploration from command line. Running this script produces a .md text file that lists the folder structure of the target directory contents in a tree-like diagram, also listing the number of lines in each file found.


# Global Vars
VERSION="v0.0.1"


# Methods

# METHOD: usage
# Print help message to stdout
usage(){
    echo 'Thank you for using FolderExplorer.

    USAGE
    FolderExplorer [option]

    OPTIONS
    -h     --help print help documentation.
    -f     --file [path] run FolderExplorer on specified path.
    -v     --version print FolderExplorer version.'
    exit 1
}

# METHOD: version
# Print version message to stdout
version(){
    echo "FolderExplorer $VERSION
Created by Richard Hawkins
    We're just getting started, be patient with us...
    Me...
    Ok, it was all Richards fault.
    There.
    Are you happy?
    You monster."
    exit 1
}


# Main Functionality

# Accept option flags on startup command. Accept h, v, and f options. Suppress invalid option alerts from stderr to /dev/null
OPTIONS=$(getopt -o hvf: -l help,version,file:  -- "$@" 2>/dev/null)

# If invalid option supplied, display help message (usage method)
if [ $? -ne 0 ]; then
    usage
fi

eval set -- $OPTIONS
unset OPTIONS

while true; do
  case "$1" in
    -h|--help) HELP=1; usage ;;
    -v|--version) VER=1; version ;;
    -f|--file) FILE="$2" ; shift ;;
    --)        shift ; break ;;
    *)         HLEP=1; usage ;;
  esac
  shift
done

# If no file option used, set FILE to (.)
if [ -z $FILE ]; then
    if [[ $1 != "" ]] && [[ -d $1 ]]; then
      FILE=$1
      echo "Target directory specified."
    else
      FILE="."
      echo "No target directory specified."
    fi
fi

# Derive run-from folder name to SAVE to build output directory and files
SAVE=`pwd`

# Derive target folder name to DIR to be used in output file content and file names.
FULLDIR=`realpath $FILE`
DIR=`basename $FULLDIR`
echo "Operating on: "$DIR

# ###################################
# # Diagnostic Output
# echo " HELP: $HELP
# FILE: $FILE
# VER: $VER
# DIR: $DIR
# SAVE: $SAVE
# 0: $0
# 1: $1
# 2: $2"
# ###################################

# Set current directory to target file location
cd $FILE

# Suppress stderr to /dev/null
2>/dev/null

# create output file, and generate initial heading for file
echo "FolderExplorer run for: $DIR" > $SAVE/$DIR-anlysis.md

# Print find output to file named after folder.
#find . | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/" >> $SAVE/FolderExplorerOutput/$DIR.md
find . -exec wc -l {} \; 2>/dev/null | sed 's|/| |g' | sed 's|^0|--|g' | awk '{for(i=1;i<NF-1;i++)printf "|  ";print $1 " " $NF}' >> $SAVE/$DIR-anlysis.md

exit 1
