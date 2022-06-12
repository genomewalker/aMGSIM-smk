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
        use_restimated_proportions=config["use_restimated_proportions"],
        filterbam_filter_conditions=config["filterbam_filter_conditions"],
        metadmg_filter_conditions=config["metadmg_filter_conditions"],
        taxonomic_rank=config["taxonomic_rank"],
        max_genomes_nondamaged=config["max_genomes_nondamaged"],
        max_genomes_damaged=config["max_genomes_damaged"],
        max_genomes_damaged_selection=config["max_genomes_damaged_selection"],
        max_genomes_nondamaged_selection=config["max_genomes_nondamaged_selection"],
        num_reads="{num_reads}",
        seq_library="{seqlib}",
        seq_system=config["seq_system"],
        seq_read_length=config["seq_read_length"],
        libprep="{libprep}",
        genome_table=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/{{smp}}.filepaths.tsv',
        abund_table=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/{{smp}}.communities.tsv',
        genome_composition=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/{{smp}}.genome-compositions.tsv',
        ag_tmp_dir=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/ag-tmp',
        ar_tmp_dir=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/ar-tmp',
        json=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/{{smp}}.json',
        cpus=config["cpus"],
        output_dir=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/reads',
    log:
        f'{config["rdir"]}/logs/config/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/create-config.log',
    benchmark:
        f'{config["rdir"]}/benchmarks/config/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/create-config.bmk'
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
            -e 's|USE_RESTIMATED_PROPORTIONS|{params.use_restimated_proportions}|' \
            -e 's|FILTERBAM_FILTER_CONDITIONS|{params.filterbam_filter_conditions}|' \
            -e 's|METADMG_FILTER_CONDITIONS|{params.metadmg_filter_conditions}|' \
            -e 's|TAXONOMIC_RANK|{params.taxonomic_rank}|' \
            -e 's|MAX_GENOMES_NONDAMAGED_SELECTION|{params.max_genomes_nondamaged_selection}|' \
            -e 's|MAX_GENOMES_DAMAGED_SELECTION|{params.max_genomes_damaged_selection}|' \
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
            -e 's|SEQ_SYSTEM|{params.seq_system}|' \
            -e 's|SEQ_READ_LENGTH|{params.seq_read_length}|' \
            -e 's|TMP_DIR|{params.ag_tmp_dir}|' {input.ag_config_file} > {output.ag_config_file}
        sed -e 's|TMP_DIR|{params.ar_tmp_dir}|' \
            -e 's|ANCIENT_GENOMES_FILE|{params.json}|' \
            -e 's|MAPDMG_MISINCORPORATION|{input.metadmg_misincorporations}|' \
            -e 's|CPUS|{params.cpus}|' \
            -e 's|LIBRARY_PREP|{params.libprep}|' \
            -e 's|OUTPUT_DIR|{params.output_dir}|' {input.ar_config_file} > {output.ar_config_file}
        sleep 5
        """
