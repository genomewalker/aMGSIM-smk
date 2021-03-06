# A snakemake workflow to generate multiple synthetic datasets using aMGSIM

This workflow is designed to help in the generation of multiple synthetic datasets using [aMGSIM](https://github.com/genomewalker/aMGSIM). The workflow needs the results generated after processing a BAM file through [filterBAM](https://github.com/genomewalker/bam-filter) and [metaDMG](https://metadmg-dev.github.io/metaDMG-core/). An example of the config file is [here](config/config.yaml).

The [sample TSV](assets/metaDMGsamplelist-test.tsv) file must contain the following fields:
- **label**: The name of the sample
- **short_label**: A short name for the sample (if not provided will autogenerate a short name using the MD5 of the label)
- **libprep**: The type of library preparation to use (**single**-stranded or **double**-stranded)
- **read_length_freqs_file**: A JSON file with the empirical read length frequencies for the sample estimated by filterBAM
- **mapping_stats_filtered_file**: A TSV file with the filtered mapping statistics generated by filterBAM
- **metadmg_results**: The TSV generated by metaDMG when analyzing the filtered BAM file using the metaDMG's local mode
- **metadmg_misincorporations**: The misincorporations generated by metaDMG when analyzing the filtered BAM file using the metaDMG's local mode

Example data can be found [here](assets/data). Once the workflow is done will produce the following folders. In this example, we show the output for the sample `Cave-22`, where the workflow tried to produce a maximum of `1000000` single-end reads:

```
Cave-22/single/1000000
├── Cave-22.communities.json
├── Cave-22.communities.tsv
├── Cave-22.communities_read-abundances.tsv
├── Cave-22.communities_read-files.json
├── Cave-22.filepaths.tsv
├── Cave-22.genome-compositions.tsv
├── ag-config.yaml
├── ar-config.yaml
├── fb-config.yaml
└── reads
    ├── Cave-22_art.fq.gz
    ├── Cave-22_deamSim.fa.gz
    └── Cave-22_fragSim.fa.gz
```

The folder contains the generated config files for the aMGSIM `estimate`, `ancient-genomes` and `ancient-reads` programs:
- **fb-config.yaml**: The config file for the aMGSIM `estimate`
- **ag-config.yaml**: The config file for the aMGSIM workflow for the `ancient-genomes` program
- **ar-config.yaml**: The config file for the aMGSIM workflow for the `ancient-reads` program

Those are the ouput files after running aMGSIM `estimate`:
- **Cave-22.communities.tsv**: This file contains the estimated abundance table for the synthetic community.
- **Cave-22.filepaths.tsv**: This file contains the file paths for the reference genomes used in the filterBAM analysis.
- **Cave-22.genome-compositions.tsv**: This file is the one controlling how the genomes are going to be processed and will contain the empirical values.

And the files after produce by aMGSIM `ancient-genomes`:
- **Cave-22.communities.json**: A JSON file with the details to generate the synthetic data of each taxon in each sample.
- **Cave-22.communities.tsv**: A TSV file with the details of the synthetic data of each taxon in each sample.
- **Cave-22.communities_read-abundances.tsv**: A TSV file with the number of reads that will be generated for each taxon in each sample

And finally the files after produce by aMGSIM `ancient-reads`:
- **Cave-22_read-files.json**: The JSON file with the read files generated by aMGSIM
- **reads**: The folder containing the read files generated by metaDMG
  - **Cave-22_fragSim.fa.gz**: The read files generated by the fragSim program
  - **Cave-22_deamSim.fa.gz**: The read files generated by the deamSim program
  - **Cave-22_art.fq.gz**: The final fastq files generated by ART