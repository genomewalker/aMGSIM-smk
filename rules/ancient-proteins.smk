
rule ancient_proteins:
    input:
        read_files=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.communities_read-files.json',
    output:
        prot_tsv=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}_prot.done',
    params:
        results_dir=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}',
        output_dir=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}',
        ar_tmp_dir=f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/ar-tmp',
        wdir=f'{config["wdir"]}',
        cpus=config["cpus"],
        procs=config["procs"]
    threads: config["prot_threads"]
    log:
        f'{config["rdir"]}/logs/config/{{smp}}/{{seqlib}}/{{num_reads}}/ancient-proteins.log',
    benchmark:
        f'{config["rdir"]}/benchmarks/config/{{smp}}/{{seqlib}}/{{num_reads}}/ancient-proteins.bmk'
    conda:
        "../envs/aMGSIM.yaml"
    message:
        """--- Generating ancient read data (single)"""
    shell:
        """
        cd {params.results_dir} || {{ echo "Cannot change dir"; exit 1; }}
        aMGSIM protein-analysis --cpus {params.cpus} --procs {params.procs} {input.read_files}
        touch {output.prot_tsv}
        cd {params.wdir} || {{ echo "Cannot change dir"; exit 1; }}
        """
