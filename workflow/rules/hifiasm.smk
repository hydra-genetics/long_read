__author__ = "Magdalena Zarowiecki"
__copyright__ = "Copyright 2023, Uppsala universitet"
__email__ = "magdalena.z@scilifelab.uu.se"
__license__ = "GPL-3"


rule hifiasm:
    input:
        fasta=[
            "reads/HiFi_dataset_01.fasta.gz",
            "reads/HiFi_dataset_02.fasta.gz",
        ],
    # optional
    output:
        multiext(
            "hifiasm/{sample}.",
            "a_ctg.gfa",
            "a_ctg.lowQ.bed",
            "a_ctg.noseq.gfa",
            "p_ctg.gfa",
            "p_ctg.lowQ.bed",
            "p_ctg.noseq.gfa",
            "p_utg.gfa",
            "p_utg.lowQ.bed",
            "p_utg.noseq.gfa",
            "r_utg.gfa",
            "r_utg.lowQ.bed",
            "r_utg.noseq.gfa",
        ),
    log:
        "logs/hifiasm/{sample}.log",
    params:
        extra="--primary -f 37 -l 1 -s 0.75 -O 1",
    threads: 2
    resources:
        mem_mb=1024,
    wrapper:
        "v3.3.6/bio/hifiasm"

# Dervied from https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/hifiasm.html
