# Utils

This repository contains scripts and code snippets that serve as utilities for various tasks. The goal is to provide reusable code to avoid rewriting and reinventing the wheel. All content in this repository is open and free to use under a Creative Commons license. Feel free to use and contribute!

## Current Content

### 1. Parse Hipathia Pathways to CSV for Neo4J: hipath2CSV Folder

This script extracts pathway information using the [Hipathia package](https://www.bioconductor.org/packages/release/bioc/html/hipathia.html). Hipathia for a specified species and pathway ID. It generates two output files:
1. A CSV file containing node attributes.
2. A CSV file containing interactions/relations between nodes.

The CSV files can be used for further implementations, such as loading into Neo4J.

[More information about Hipathia] (10.1016/j.csbj.2021.05.022) 
#### Usage

To use this script, run the following command:

```bash
Rscript get_path.R --species "hsa" --path_id "04210" --output_folder "pathways"

#### Options

- `-s`, `--species` : Species code (e.g., 'hsa' for Homo sapiens) [default: "hsa"]
- `-p`, `--path_id` : Pathway ID (e.g., '04210' for Apoptosis pathway) [default: "04210"]
- `-o`, `--output_folder` : Output folder name where the files will be saved [default: "pathways"]
- `-q`, `--quiet` : Suppress output messages
```
#### Example

Parsing the Apoptosis KEGG pathway for humans:

```bash
Rscript get_path.R --species "hsa" --path_id "04210" --output_folder "pathways"
```
For the Apoptosis KEGG pathway for mouse species with quiet mode:

```bash
Rscript get_path.R --species "mmu" --path_id "04150" --output_folder "mouse_pathways" -q
```
#### Dependencies

This script requires the following R packages: `hipathia`, `igraph`, `dplyr`, `optparse`.

#### License

This repository is licensed under a Creative Commons license. You are free to use, share, and adapt the content for any purpose, provided you give appropriate feedback :).

#### Author

Kinza Rian

#### Getting Started

To get started, clone this repository and explore the scripts available. Additional utilities and documentation will be added over time.
