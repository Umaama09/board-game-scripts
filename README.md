# Scripts usage
## Script: `empty_cells.sh`

### Description
This Bash script counts the number of empty fields per column in a delimited file.

### Usage
```bash
./empty_cells.sh <filename> <separator>

.\empty_cells.sh .\bgg_dataset.txt ';'
```

## Script: `preprocess.sh`

### Description
This script preprocesses a semicolon-separated file by:
- Removing carriage returns (`\r`)
- Stripping non-printable characters (except tabs/newlines)
- Replacing commas with dots
- Replacing empty IDs with new incremented numeric IDs
- Converting semicolon separators to tab-separated format

### Usage
```bash
./preprocess.sh <input_file> > <output_file>

./preprocess.sh bgg_dataset.csv > bgg_dataset.tsv
```

## Script: `analysis.sh`

### Description
Analyses a tab-separated dataset of games to:
- Identify the most common game mechanic and domain
- Calculate correlation between:
  - Year of publication and average rating
  - Game complexity and average rating

### Usage

**Note:** Here, `bgg_dataset.tsv` is an output file preprocessed using `preprocess.sh` script.

```bash
./analysis.sh <input_file>

./analysis.sh bgg_dataset.tsv
```