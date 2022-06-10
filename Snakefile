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
        "file",
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


rule all:
    input:
        done_fb_config_file=expand(
            config["rdir"] + "/{smp}/{libprep}/{seqlib}/{num_reads}/fb-config.yaml",
            smp=sample_label_read,
            seqlib=config["seq_library"],
            libprep=config["libprep"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
        done_ag_config_file=expand(
            config["rdir"] + "/{smp}/{libprep}/{seqlib}/{num_reads}/ag-config.yaml",
            smp=sample_label_read,
            seqlib=config["seq_library"],
            libprep=config["libprep"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),
        done_ar_config_file=expand(
            config["rdir"] + "/{smp}/{libprep}/{seqlib}/{num_reads}/ar-config.yaml",
            smp=sample_label_read,
            seqlib=config["seq_library"],
            libprep=config["libprep"],
            num_reads=[str(int(float(i))) for i in config["num_reads"]],
        ),


"""
##### load rules #####
"""


include: "rules/create-config-files.smk"
