rule estimate:
    input:
        fb_config_file=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/fb-config.yaml',
    output:
        genome_table=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/{{smp}}.filepaths.tsv',
        abund_table=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/{{smp}}.communities.tsv',
        genome_composition=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/{{smp}}.genome-compositions.tsv',
    params:
        results_dir=f'{config["rdir"]}/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}',
        wdir=f'{config["wdir"]}',
    threads: config["cpus"]
    log:
        f'{config["rdir"]}/logs/config/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/estimate.log',
    benchmark:
        f'{config["rdir"]}/benchmarks/config/{{smp}}/{{libprep}}/{{seqlib}}/{{num_reads}}/estimate.bmk'
    conda:
        "../envs/aMGSIM.yaml"
    message:
        """--- Estimating simuated data composition"""
    shell:
        """
        cd {params.results_dir} || {{ echo "Cannot change dir"; exit 1; }}
        aMGSIM estimate {input.fb_config_file}
        cd {params.wdir} || {{ echo "Cannot change dir"; exit 1; }}
        """
