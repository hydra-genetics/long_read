__author__ = "Nina Hollfelder"
__copyright__ = "Copyright 2023, Nina Hollfelder"
__email__ = "nina_hollfelder@scilifelab.uu.se"
__license__ = "GPL-3"


rule paraphrase:
    input:
        bam="long_read/minimap2/{sample}_{type}.bam",
        fasta=config.get("paraphrase", {}).get("fasta", ""),
    output:
        outfolder="long_read/paraphrase/",
    params:
        genome=config.get("paraphrase", {}).get("genome", ""),
        extra=config.get("paraphrase", {}).get("extra", ""),
        
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
        "paraphrase --bam {input.bam} "
        "--reference {input.fasta} "
        "--out {output.outfolder} "
        "{params.genome} "
        "{params.extra} &> {log} "

# paraphase --bam /bam/HG002-rep4_m84011_220902_175841_s1.hifi_reads.bam -r /reference/homo_sapiens.fasta --out /paraphrase/ --genome 38 -g smn1,CR1,AMY1A,CTAG1A,BOLA2
