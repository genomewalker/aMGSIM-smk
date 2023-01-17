if config["seq_library"][0] == "single":

    rule ancient_reads:
        input:
            ar_config_file=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/ar-config.yaml',
            genome_table=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.filepaths.tsv',
            json=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.communities.json',
        output:
            fragsim=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}_fragSim.fa.gz',
            deamsim=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}_deamSim.fa.gz',
            art_sr=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}_art.fq.gz',
            read_files=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.communities_read-files.json',
        params:
            results_dir=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}',
            output_dir=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}',
            ar_tmp_dir=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/ar-tmp',
            wdir=f'{config["wdir"]}',
        threads: config["cpus"]
        log:
            f'{config["rdir"]}/logs/config/{{smp}}/{{seqlib}}/{{num_reads}}/ancient-reads.log',
        benchmark:
            f'{config["rdir"]}/benchmarks/config/{{smp}}/{{seqlib}}/{{num_reads}}/ancient-reads.bmk'
        conda:
            "../envs/aMGSIM.yaml"
        message:
            """--- Generating ancient read data (single)"""
        shell:
            """
            cd {params.results_dir} || {{ echo "Cannot change dir"; exit 1; }}
            aMGSIM ancient-reads {input.genome_table} {input.ar_config_file}
            mv {params.output_dir}/*gz {params.results_dir}/reads/
            rm -rf {params.output_dir} {params.ar_tmp_dir} {params.results_dir}/reads/genomes
            cd {params.wdir} || {{ echo "Cannot change dir"; exit 1; }}
            """


if config["seq_library"] == "double":

    rule ancient_reads:
        input:
            ar_config_file=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/ar-config.yaml',
            genome_table=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.filepaths.tsv',
            json=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.json',
        output:
            fragsim=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}_fragSim.fa.gz',
            deamsim=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}_deamSim.fa.gz',
            art_p1=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}_art.1.fq.gz',
            art_p2=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}_art.2.fq.gz',
            read_files=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.communities_read-files.json',
        params:
            results_dir=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}',
            output_dir=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}',
            ar_tmp_dir=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/ar-tmp',
            wdir=f'{config["wdir"]}',
        threads: config["cpus"]
        log:
            f'{config["rdir"]}/logs/config/{{smp}}/{{seqlib}}/{{num_reads}}/ancient-reads.log',
        benchmark:
            f'{config["rdir"]}/benchmarks/config/{{smp}}/{{seqlib}}/{{num_reads}}/ancient-reads.bmk'
        conda:
            "../envs/aMGSIM.yaml"
        message:
            """--- Generating ancient read data (Paired)"""
        shell:
            """
            cd {params.results_dir} || {{ echo "Cannot change dir"; exit 1; }}
            aMGSIM ancient-reads {input.genome_table} {input.ar_config_file}
            mv {params.output_dir}/*gz {params.results_dir}/reads/
            rm -rf {params.output_dir} {params.ar_tmp_dir} {params.results_dir}/reads/genomes
            cd {params.wdir} || {{ echo "Cannot change dir"; exit 1; }}
            """
