rule create_config_files:
    input:
        read_length_freqs_file=(
            lambda wildcards: f'{config["sdir"]}/{sample_table_read.read_length_freqs_file[wildcards.smp]}'
        ),
        mapping_stats_filtered_file=(
            lambda wildcards: f'{config["sdir"]}/{sample_table_read.mapping_stats_filtered_file[wildcards.smp]}'
        ),
        metadmg_results=(
            lambda wildcards: f'{config["sdir"]}/{sample_table_read.metadmg_results[wildcards.smp]}'
        ),
        metadmg_misincorporations=(
            lambda wildcards: f'{config["sdir"]}/{sample_table_read.metadmg_misincorporations[wildcards.smp]}'
        ),
        fb_config_file=config["fb_config_file"],
        ag_config_file=config["ag_config_file"],
        ar_config_file=config["ar_config_file"],
    output:
        fb_config_file=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/fb-config.yaml',
        ag_config_file=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/ag-config.yaml',
        ar_config_file=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/ar-config.yaml',
    params:
        label="{smp}",
        genome_paths=config["genome_paths"],
        names_dmp=config["names_dmp"],
        nodes_dmp=config["nodes_dmp"],
        acc2taxid=config["acc2taxid"],
        max_genomes_nondamaged=config["max_genomes_nondamaged"],
        max_genomes_damaged=config["max_genomes_damaged"],
        num_reads="{num_reads}",
        seq_library=config["seq_library"],
        libprep=config["libprep"],
        genome_table=f"{smp}.filepaths.tsv",
        abund_table=f"{smp}.communities.tsv",
        genome_composition=f"{smp}.genome-composition.tsv",
        ag_tmp_dir=f'{config["rdir"]}/logs/config/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/ag-tmp',
        ar_tmp_dir=f'{config["rdir"]}/logs/config/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/ar-tmp',
        cpus=config["cpus"],
        output_dir=f'{config["rdir"]}/logs/config/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}'
    log:
        f'{config["rdir"]}/logs/config/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}.log',
    benchmark:
        f'{config["rdir"]}/benchmarks/config/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}.bmk'
    message:
        """--- Creating config files"""
    shell:
        """
        sed -e 's|GENOMES_PATH_FILE|{params.genome_paths}|' \
            -e 's|NAMES_DMP_FILE|{params.names_dmp}|' \
            -e 's|NODES_DMP_FILE|{params.nodes_dmp}|' \
            -e 's|ACC2TAXID_FILE|{params.acc2taxid}|' \
            -e 's|SAMPLE_NAME|{params.label}|' \
            -e 's|FB_STATS|{input.mapping_stats_filtered_file}|' \
            -e 's|METADMG_RESULTS|{input.metadmg_results}|' \
            -e 's|MAX_GENOMES_NONDAMAGED|{params.max_genomes_nondamaged}|' \
            -e 's|MAX_GENOMES_DAMAGED|{params.max_genomes_damaged}|' \
            -e 's|CPUS|{params.cpus}|' {input.fb_config_file} > {output.fb_config_file}
        sed -e 's|GENOME_TABLE|{params.genome_table}|' \
            -e 's|ABUND_TABLE|{params.abund_table}|' \
            -e 's|GENOME_COMPOSITION|{params.genome_composition}|' \
            -e 's|READ_LENGTH_FREQS|{input.read_length_freqs_file}|' \
            -e 's|CPUS|{params.cpus}|' \
            -e 's|NUM_READS|{params.num_reads}|' \
            -e 's|SEQ_LIBRARY|{params.seq_library}|' \
            -e 's|TMP_DIR|{params.ag_tmp_dir}|' {input.ag_config_file} > {output.ag_config_file}
        sed -e 's|TMP_DIR|{params.ar_tmp_dir}|' \
            -e 's|CPUS|{params.cpus}|' \
            -e 's|LIBRARY_PREP|{params.libprep}|' \
            -e 's|OUTPUT_DIR|{params.output_dir}|' {input.ar_config_file} > {output.ar_config_file}
        """
