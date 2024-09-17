#!/usr/bin/env /opt/R/4.3.1/bin/Rscript

# =============================================================================
# Main Script to Extract Pathway Information Using Hipathia
# Author: Kinza Rian
# Date: 2024-09-17 
#
# Description:
# This script extracts pathway information using the Hipathia package for a
# specified species and pathway ID. It generates two output files:
# 1. A CSV file containing node attributes.
# 2. A CSV file containing interactions/relations between nodes.
#
# Usage:
# Rscript get_path.R --species "hsa" --path_id "04210" --output_folder "pathways"
# 
# Options:
#   -s, --species        Species code (e.g., 'hsa' for Homo sapiens) [default: "hsa"]
#   -p, --path_id        Pathway ID (e.g., '04210' for Apoptosis pathway) [default: "04210"]
#   -o, --output_folder  Output folder name where the files will be saved [default: "pathways"]
#   -q, --quiet          Suppress output messages
#
# Example:
# Parsing Apoptosis KEGG pathway for Human:
# Rscript get_path.R --species "hsa" --path_id "04210" --output_folder "pathways"
# Fore Apoptosis KEGG pathway for mouse species  and with a quiet mode:
# Rscript get_path.R --species "mmu" --path_id "04150" --output_folder "mouse_pathways" -q
#
# Dependencies:
# This script requires the following R packages: hipathia, igraph, dplyr, optparse
# =============================================================================

suppressPackageStartupMessages(library(hipathia))
suppressPackageStartupMessages(library("igraph"))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(optparse))
# Vars
option_list <- list(
  make_option(c("-s", "--species"), type = "character", default = "hsa",
              help = "Species code, e.g., 'hsa' for Homo sapiens [default: %default]"),
  make_option(c("-p", "--path_id"), type = "character", default = "04210",
              help = "Pathway ID, e.g., '04210' for Apoptosis pathway [default: %default]"),
  make_option(c("-o", "--output_folder"), type = "character", default = "pathways",
              help = "Output folder name [default: %default]"),
  make_option(c("-q", "--quiet"), action = "store_true", default = FALSE,
              help = "Suppress output messages")
)
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
# Get the variables from the parsed options
species <- opt$species
path_id <- paste0(species,opt$path_id)
output_folder <- opt$output_folder
quiet<-opt$quiet
# Load pathway information using Hipathia
path <- if (quiet) {
  suppressMessages(hipathia::load_pathways(species = species, pathways_list = path_id))
} else {
  hipathia::load_pathways(species = species, pathways_list = path_id)
}
# get node att
path_tables <-  igraph::as_data_frame(path$pathigraphs[[path_id]]$graph, what = "both")
nodes <- path_tables$vertices
# NOTE: Normally, the separator is a simple "," but I changed it to ";" to avoid confusion with the CSV file separator for the Neo4J converter!
# More information about Neo4J data import formats : https://neo4j.com/docs/getting-started/data-import/
nodes$genesList <- sapply(nodes$genesList,function(x)paste(x,collapse = ";")) # get interaction /relation betwen these nodes
# Note: Please be careful with labels that contain special characters, as they can confuse parsers. Commonly, metabolite names contain characters that can interfere with data reading.
relations <- path_tables$edges
relations$relation <- ifelse(edge_attr(path$pathigraphs[[path_id]]$graph)$relation>0,
                             "activation",
                             "inhibition")
## Writing files
# Create output folder if it doesn't exist
if (!dir.exists(output_folder)) {
  # If the folder does not exist, create it
  dir.create(output_folder, recursive = TRUE)
}

# Write node attributes to a CSV file
write.table(x = nodes, file = file.path(output_folder, paste0(path_id, "_nodes.csv")),
            quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")

# Write relations to a CSV file
write.table(x = relations, file = file.path(output_folder, paste0(path_id, "_relations.csv")),
            quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ",")
## Notes:
if(!quiet)
message("Pathway ", path_id, " parsed successfully to CSV format. However, please pay attention to the following:\n
        1. This parser generates 2 CSV files: ", path_id, "_nodes.csv and ", path_id, "_relations.csv, for node attributes and for relations/interactions, respectively.\n
        2. Normally, the separator for the gene list is a simple ',', but here changed it to ';' to avoid confusion with the CSV file separator for the Neo4J converter.\n
        More information about Neo4J data import formats: https://neo4j.com/docs/getting-started/data-import/\n
        3. Please be careful with gene labels or tooltips that contain special characters, as they can confuse parsers. Commonly, metabolite names contain characters that can interfere with data reading.")

