__author__ = "Nina Hollfelder"
__copyright__ = "Copyright 2023, Nina Hollfelder"
__email__ = "nina_hollfelder@scilifelab.uu.se"
__license__ = "GPL-3"


rule sniffles:
    input:
        bam="long_read/minimap2/{sample}_{type}.bam",
        fasta=config.get("reference", {}).get("fasta", ""),
    output:
        vcf="long_read/sniffles/{sample}_{type}.vcf",
    params:
        extra=config.get("sniffles", {}).get("extra", ""),
        non_germline=config.get("sniffles", {}).get("non_germline", ""),
    log:
        "long_read/sniffles/{sample}_{type}.vcf.log",
    benchmark:
        repeat("long_read/sniffles/{sample}_{type}.vcf.benchmark.tsv", config.get("sniffles", {}).get("benchmark_repeats", 1))
    threads: config.get("sniffles", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("sniffles", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("sniffles", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("sniffles", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("sniffles", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("sniffles", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("sniffles", {}).get("container", config["default_container"])
    message:
        "{rule}: Calls SVs on {input.bam} with sniffles"
    script:
        "sniffles -i {input.bam} "
        "--reference {input.fasta} "
        "-t {threads} "
        "{params.non_germline} "
        "{params.extra} "
        "-v {output.vcf} &> {log} "
