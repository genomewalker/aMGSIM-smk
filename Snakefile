import glob
import pandas as pd
from snakemake.utils import validate, min_version


def get_md5sum(x):
    import hashlib

    return hashlib.md5(x.encode("utf-8")).hexdigest()[:10]


"""
Author: A. Fernandez-Guerra
Affiliation: Lundbeck Foundation GeoGenetics Centre
Aim: Create synthetic data to test metaDMG
Run: snakemake   -s Snakefile
"""
#
##### set minimum snakemake version #####
min_version("5.20.1")

# configfile: "config/config.yaml"
# report: "report/workflow.rst"

# This should be placed in the Snakefile.

"""
Working directory
"""


workdir: config["wdir"]


# message("The current working directory is " + WDIR)

"""
 The list of samples to be processed
"""

sample_table_read = pd.read_table(
    config["sample_file_read"], sep="\t", lineterminator="\n"
)

# let's check that the basic columns are present
if not all(
    item in sample_table_read.columns
    for item in [
        "label",
        "libprep",
        "read_length_freqs_file",
        "mapping_stats_filtered_file",
        "metadmg_results",
        "metadmg_misincorporations",
    ]
):
    raise ValueError("The sample table must contain the columns 'label' and 'file'")
    exit(1)

if not "libprep" in sample_table_read.columns:
    sample_table_read["libprep"] = "double"

sample_table_read = sample_table_read.drop_duplicates(
    subset="label", keep="first", inplace=False
)
sample_table_read = sample_table_read.dropna()

if not "short_label" in sample_table_read.columns:
    sample_table_read["short_label"] = sample_table_read.apply(
        lambda row: get_md5sum(row.label), axis=1
    )

sample_table_read.set_index("short_label", inplace=True)
sample_label_dict_read = sample_table_read.to_dict()["label"]
sample_label_read = sample_table_read.index.values


done_art_sr = []
done_art_p1 = []
done_art_p2 = []
done_fragsim = []
done_deamsim = []
if config["seq_library"][0] == "single":
    done_art_sr = (
        expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}/{{smp}}_art.fq.gz',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
    )
    done_fragsim = (
        expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}/{{smp}}_fragSim.fa.gz',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
    )
    done_deamsim = (
        expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}/{{smp}}_deamSim.fa.gz',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
    )
    done_read_json = (
        expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}/{{smp}}.communities_read-files.json',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
    )

if config["seq_library"][0] == "double":
    done_art_p1 = (
        (
            expand(
                f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}/{{smp}}_art.1.fq.gz',
                smp=sample_label_read,
                seqlib=config["seq_library"],
                num_reads=[str(int(float(i))) for i in config["num_reads"]],
            ),
        ),
    )
    done_art_p2 = (
        (
            expand(
                f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}/{{smp}}_art.2.fq.gz',
                smp=sample_label_read,
                seqlib=config["seq_library"],
                num_reads=[str(int(float(i))) for i in config["num_reads"]],
            ),
        ),
    )
    done_fragsim = (
        expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}/{{smp}}_fragSim.fa.gz',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
    )
    done_deamsim = (
        expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}/{{smp}}_deamSim.fa.gz',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
    )
    done_read_json = (
        expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{smp}.communities_read-files.json',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
    )

rule all:
    input:
        done_art_sr,
        done_art_p1,
        done_art_p2,
        done_fragsim,
        done_deamsim,
        done_fb_config_file=expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/fb-config.yaml',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
        done_ag_config_file=expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/ag-config.yaml',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
        done_ar_config_file=expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/ar-config.yaml',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
        done_genome_table=expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.filepaths.tsv',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
        done_abund_table=expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.communities.tsv',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
        done_genome_composition=expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.genome-compositions.tsv',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
        done_json=expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.communities.json',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
        done_tsv=expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/{{smp}}.communities_read-abundances.tsv',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
        done_prots=expand(
            f'{config["rdir"]}/{{smp}}/{{seqlib}}/{{num_reads}}/reads/{{smp}}_prot.done',
            smp=sample_label_read,
            seqlib=config["seq_library"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),


"""
##### load rules #####
"""


include: "rules/create-config-files.smk"
include: "rules/estimate.smk"
include: "rules/ancient-genomes.smk"
include: "rules/ancient-reads.smk"
include: "rules/ancient-proteins.smk"
