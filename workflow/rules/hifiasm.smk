__author__ = "Magdalena Zarowiecki"
__copyright__ = "Copyright 2023, Uppsala universitet"
__email__ = "magdalena.z@scilifelab.uu.se"
__license__ = "GPL-3"


rule hifiasm:
    input:
            "long_read/hifiasm/{sample}_{type}_{flowcell}_{barcode}.s2fq.fasta",
    # optional
    output:
        "long_read/hifiasm/{sample}_{type}_{flowcell}_{barcode}.a_ctg.gfa",
    log:
        "long_read/hifiasm/{sample}_{type}_{flowcell}_{barcode}.log",
    params:
        extra="--primary -f 37 -l 1 -s 0.75 -O 1",
    threads: 2
    resources:
        mem_mb=1024,
    wrapper:
        "v3.3.6/bio/hifiasm"

# Dervied from https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/hifiasm.html
