__author__ = "Patrik Smeds"
__copyright__ = "Copyright 2023, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "GPL-3"


rule minimap2:
    input:
        query=lambda wildcards: get_minimap2_query(wildcards),
        target=config.get("reference", {}).get("fasta", ""),
        index=config.get("minimap2", {}).get("index", ""),
    output:
        bam="long_read/minimap2/{sample}_{type}.bam",
        bai="long_read/minimap2/{sample}_{type}.bai",
    params:
        extra=config.get("minimap2", {}).get("extra", ""),
        sorting=config.get("minimap2", {}).get("sorting", ""),
        sorting_extra=config.get("minimap2", {}).get("sorting_extra", ""),
    log:
        "long_read/minimap2/{sample}_{type}.bam.log",
    benchmark:
        repeat("long_read/minimap2/{sample}_{type}.bam.benchmark.tsv", config.get("minimap2", {}).get("benchmark_repeats", 1))
    threads: config.get("minimap2", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("minimap2", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("minimap2", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("minimap2", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("minimap2", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("minimap2", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("minimap2", {}).get("container", config["default_container"])
    message:
        "{rule}: run minimap2 on {input}"
    wrapper:
        "v3.3.5/bio/minimap2/aligner"
    shell:
        "samtools index {output.bam}"
