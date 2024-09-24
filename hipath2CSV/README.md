# Hipathia2CSV

Hipathia2CSV extracts graphs from Hipathia and generates SIF files with attributes, featuring:

- Each pathway is saved in two separate files: `.att` (ATT file: [KEGGID]__node.csv) and `.sif` (SIF file: [KEGGID]__relations.csv).
- The SIF and ATT files should have the same prefix in the name, e.g., `hsa04210_relations.csv` and `hsa04210_nodes.csv` for the pathway with ID `hsa04210`.
- Functions are included in these files, and the ID of these nodes has a suffix `_func`, e.g., `N-hsa04210-119_func` is the function of the node with the ID `N-hsa04210-119`.

## SIF FILE: [KEGGID]__relations.csv

This is a text file with four tab-separated columns:

- Each row represents an interaction in the pathway. The columns are:
  1. **from**: Source node 	
  2. **to**: Target node
  3. **arrow.size**: *Ignored for now* (contains fixed arrow size of 0.2)
  4. **relation**: Type of relation (either activation or inhibition)
  
- The node IDs have the following structure: `N-<pathway_ID>-<node_ID>`.
- Hipathia distinguishes between two types of nodes: simple and complex:
  - **Simple nodes** may include multiple genes, but only one is needed for the node to function.
  - **Complex nodes** represent protein complexes and require all simple nodes within the complex to function. The node ID for complex nodes is a juxtaposition of simple node IDs, separated by spaces, e.g., `N-hsa04210-34 35`.

### Example

| Source Node       | Target Node      | Arrow Size | Type       |
|-------------------|------------------|------------|------------|
| N-hsa04210-39     | N-hsa04210-34 35 | 0.2        | activation |


## ATT FILE: [KEGGID]__nodes.csv

This is a text file with 13 tab-separated columns. Each row represents a node (simple or complex) and contains additional attributes, including functions:

- **name**: Node ID (same as in the SIF file/relations.csv).
- **X, nodeX**: X-coordinate of the node in the pathway (duplicate columns, use one and ignore the other).
- **Y, nodeY**: Y-coordinate of the node in the pathway (duplicate columns, use one and ignore the other).
- **shape**: Default shape of the node. "rectangle" is used for genes, and "circle" for metabolites.
  In the final Hipathia web-report, gene nodes are transformed into ellipses, metabolites remain as circles, and functions take the rectangle shape. I advise to do same transfrmation.
- **size**: Default width of the node.
- **size2**: Default height of the node.
- **label.cex**: Scaling factor for the plotting label.(Not so relevant)
- **label**: Name to be shown in the pathway image. Usually the gene name of the first EntrezID gene in the node is used ([HGNC](https://www.genenames.org/) nomenclature is used for human readability.).
  For complex nodes, gene names of the first genes in each simple node are juxtaposed.
- **color**: Default node color. (Hipathia changes this after performing differential pathway activity analysis based on node activation or expression levels.) is afixed color for all for the moment.
- **tooltip**: A link to the KEGG database for more information about each node in the original KEGG pathway.
- **genesList**: EntrezIDs of the genes included in the node:
  - **Simple nodes**: Entrez IDs are separated by ";" (instead of commas, as used in the original Hipathia graphs, because CSV files use commas as delimiters. To avoid discrepancies, we changed the separator for the gene list to ";" without spaces), e.g., `4790;5970` for node `N-hsa04370-16`.
  - **Complex nodes**: Gene lists are separated by slashes (`/`) and listed in the same order as in the node ID. For example, node `N-hsa04210-34 35` includes two simple nodes: 34 and 35. Its `genesList` column would be `8772;/;8717`, meaning node 34 contains genes `8772`, and node 35 contains gene `8717`.

### Note:
- Node types included in these files:
  * **"gene" for genes**: either simple nodes, where genes are separated by ";" instead of a comma, e.g., `gene;gene`, or complex nodes separated  by slashes (`/`).
  * **"compound" for metabolites.**
  * **Functions** are also included in this file.



