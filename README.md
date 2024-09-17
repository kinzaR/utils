# Utils

This repository contains scripts and code snippets that serve as utilities for various tasks. The goal is to provide reusable code to avoid rewriting and reinventing the wheel. All content in this repository is open and free to use under a Creative Commons license. Feel free to use and contribute!

## Current Content

### 1. Parse Hipathia Pathways to CSV for Neo4J: `hipath2CSV` Folder

This script extracts pathway information using the [Hipathia package](https://www.bioconductor.org/packages/release/bioc/html/hipathia.html) for a specified species and pathway ID. It generates two output files:
1. A CSV file containing node attributes.
2. A CSV file containing interactions/relations between nodes.

The CSV files can be used for further implementations, such as loading into Neo4J.

#### Clarification about `Path_ID`

- **`path_id`**:
  - This is a number that should be a valid pathway identifier from the [KEGG pathway database](https://www.genome.jp/kegg/pathway.html).
  - Example: `04210` for the Apoptosis pathway.

- **`Path_ID1 Path_ID2 ... Path_IDN`**:
  - This represents a space-separated list of pathway IDs that you want to process when using the multiple pathways option.
  - Example: `"04210 04150 04010"` for processing the Apoptosis pathway, the Cell Cycle pathway, and the Glycolysis pathway simultaneously.


[More information read this paper about Hipathia](https://doi.org/10.1016/j.csbj.2021.05.022)

#### 1.1. Run for One Pathway

##### Usage

For a single pathway, you can use the `get_path.R` script. Run the following command:

```bash
Rscript get_path.R --species "hsa" --path_id "04210" --output_folder "pathways"
```
##### Options

- `-s`, `--species` : Species code (e.g., 'hsa' for Homo sapiens) [default: "hsa"]
- `-p`, `--path_id` : Pathway ID (e.g., '04210' for Apoptosis pathway) [default: "04210"]
- `-o`, `--output_folder` : Output folder name where the files will be saved [default: "pathways"]
- `-q`, `--quiet` : Suppress output messages

##### Example

Parsing the Apoptosis KEGG pathway for humans:

```bash
Rscript get_path.R --species "hsa" --path_id "04210" --output_folder "pathways"
```
For the Apoptosis KEGG pathway for mouse species with quiet mode:

```bash
Rscript get_path.R --species "mmu" --path_id "04150" --output_folder "mouse_pathways" -q
```

#### 1.2. Run Multiple Pathways in Parallel: `get_paths_parallel.sh`

This script runs `get_path.R` for a list of pathway IDs in parallel using [GNU Parallel](https://www.gnu.org/software/parallel/search.html?q=Run+n+jobs+in+parallel&check_keywords=yes&area=default#). It allows you to process multiple pathways simultaneously, improving efficiency.

**Note**: if you are using conda env, please run this before:

```bash
conda activate <your_env>
conda install -c conda-forge parallel
```
[More information](https://anaconda.org/conda-forge/parallel) 

##### Usage

To use this script, run the following command:

```bash
chmod +x get_paths_parallel.sh
./get_paths_parallel.sh "Path_ID1 Path_ID2 ... Path_IDN" "output_folder_name" [-q]
```
##### Options
    
    -q : Suppress output messages

##### Example

Running get_path.R for multiple pathways:

```bash
./get_paths_parallel.sh "04210 04150 04010" "ThreePathways"
```
Running get_path.R for multiple pathways with quiet mode:

```bash
./get_paths_parallel.sh "04210 04150 04010" "ThreePathways" -q
```
**Note:** `-j` is set to 0 by default (Actualy is hardcoded inside the `get_paths_parallel.sh` script :/), which uses all available CPU cores. Please adjust this value as needed in the script.

#### Dependencies

This script requires the following R packages: `hipathia`, `igraph`, `dplyr`, `optparse`.

#### License

This repository is licensed under a Creative Commons license. You are free to use, share, and adapt the content for any purpose, provided you give appropriate feedback :).

#### Author

Kinza Rian

#### Getting Started

To get started, clone this repository and explore the scripts available. Additional utilities and documentation will be added over time.
