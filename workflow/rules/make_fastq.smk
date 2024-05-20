
__author__ = "Magdalena Zarowiecki"
__copyright__ = "Copyright 2023, Uppsala Universitet"
__email__ = "magdalena.z@scilifelab.uu.se"
__license__ = "GPL-3"


rule make_fastq:
    input:
        #query=lambda wildcards: get_minimap2_query(wildcards)
        query="long_read/minimap2/{sample}_{type}_{flowcell}_{barcode}.mm2.bam",
    output:
        #fastq="long_read/fastq/{sample}_{type}.fastq"
        fastq="long_read/hifiasm/{sample}_{type}_{flowcell}_{barcode}.s2fq.fastq.gz", 
    log:
        "long_read/hifiasm/{sample}_{type}_{flowcell}_{barcode}.interleaved.log",
    message:
        "Extracting fastq reads from BAM file"
    # Samtools takes additional threads through its option -@
    threads: config.get("make_fastq", {}).get("threads", config["default_resources"]["threads"]),  # This value - 1 will be sent to -@
    resources:
        partition=config.get("make_fastq", {}).get("partition", config["default_resources"]["partition"]),
        time=config.get("make_fastq", {}).get("time", config["default_resources"]["time"]),
        threads=config.get("make_fastq", {}).get("threads", config["default_resources"]["threads"]),
        mem_per_cpu=config.get("make_fastq", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
    params:
        extra="",
    shell:
        """
        (samtools fastq {params.extra}  {input} > {output}) &> {log}
        """



