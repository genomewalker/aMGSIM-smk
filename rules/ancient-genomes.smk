rule ancient_genomes:
    input:
        ag_config_file=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/ag-config.yaml',
        genome_table=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.filepaths.tsv',
        abund_table=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.communities.tsv',
        genome_composition=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.genome-compositions.tsv',
    output:
        json=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.json',
        tsv=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.tsv',
    params:
        results_dir=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}',
        wdir=f'{config["wdir"]}',
    threads: config["cpus"]
    log:
        f'{config["rdir"]}/logs/config/{{smp}}/{{seqlib}}/{{num_reads}}/ancient-genomes.log',
    benchmark:
        f'{config["rdir"]}/benchmarks/config/{{smp}}/{{seqlib}}/{{num_reads}}/ancient-genomes.bmk'
    conda:
        "../envs/aMGSIM.yaml"
    message:
        """--- Generating ancient genomes data"""
    shell:
        """
        cd {params.results_dir} || {{ echo "Cannot change dir"; exit 1; }}
        aMGSIM ancient-genomes {input.ag_config_file}
        cd {params.wdir} || {{ echo "Cannot change dir"; exit 1; }}
        """
