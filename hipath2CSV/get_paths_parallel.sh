#!/bin/bash

# =============================================================================
# Script to Run get_path.R in Parallel for Multiple Pathways
# Author: Kinza Rian
# Date: 2024-09-17 
#
# Description:
# This script runs `get_path.R` for a list of pathway IDs in parallel using GNU parallel.
# Usage:
# ./run_paths_parallel.sh "Path_ID1 Path_ID2 ... Path_IDN" "output_folder_name" [-q]
# =============================================================================

# Check if at least pathway IDs and output folder are provided as arguments
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Please provide a list of pathway IDs and an output folder name."
  echo "Usage: $0 \"Path_ID1 Path_ID2 ... Path_IDN\" \"output_folder_name\" [-q]"
  exit 1
fi

# Path to the `get_path.R` script
GET_PATH_SCRIPT="get_path.R"

# Define species
SPECIES="hsa"

# Get the pathway IDs from the command-line argument
IFS=' ' read -r -a PATHWAY_IDS <<< "$1"

# Get the output folder name from the command-line argument
OUTPUT_FOLDER="$2"

# Check if the quiet option (-q) is provided
QUIET=""
CITATION=""
if [ "$3" == "-q" ]; then
  QUIET="-q"
  CITATION="--citation"
fi

# Export the variables for GNU parallel
export GET_PATH_SCRIPT SPECIES OUTPUT_FOLDER QUIET CITATION

# Run `get_path.R` in parallel for each pathway ID
parallel -j 0 Rscript $GET_PATH_SCRIPT --species $SPECIES --path_id {} --output_folder $OUTPUT_FOLDER $QUIET ::: "${PATHWAY_IDS[@]}" 
# Use this parallel -j+0  if you want to tell GNU Parallel to use as many jobs as the number of available CPU cores.

