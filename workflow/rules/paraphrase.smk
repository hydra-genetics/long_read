__author__ = "Magdalena Zarowiecki"
__copyright__ = "Copyright 2023, Uppsala Universitet"
__email__ = "magdalena.z@scilifelab.uu.se"
__license__ = "GPL-3"


rule paraphrase:
    input:
        bam="long_read/minimap2/{sample}_{type}.bam",
        fasta=config.get("paraphrase", {}).get("fasta", ""),
    output:
        outfolder="long_read/paraphrase/",
        outfCR1="long_read/paraphrase/{sample}_{type}_vcfs/{sample}_{type}_CR1_variants.vcf",
    params:
        genome=config.get("paraphrase", {}).get("genome", ""),
        extra=config.get("paraphrase", {}).get("extra", ""),
    log:
        "long_read/paraphrase/{sample}_{type}.vcf.log",
    threads: config.get("paraphrase", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("paraphrase", {}).get("mem_mb", config["paraphrase_resources"]["mem_mb"]),
        mem_per_cpu=config.get("paraphrase", {}).get("mem_per_cpu", config["paraphrase_resources"]["mem_per_cpu"]),
        partition=config.get("paraphrase", {}).get("partition", config["paraphrase_resources"]["partition"]),
        threads=config.get("paraphrase", {}).get("threads", config["paraphrase_resources"]["threads"]),
        time=config.get("paraphrase", {}).get("time", config["paraphrase_resources"]["time"]),
    container:
        config.get("paraphrase", {}).get("container", config["default_container"])
    message:
        "{rule}: Calls SNVs on {input.bam} with paraphrase to resolve SNVs in gene families"
    script:
        "paraphrase --bam {input.bam} "
        "--reference {input.fasta} "
        "--out {output.outfolder} "
        "{params.genome} "
        "{params.extra} &> {log} "

# paraphase --bam /bam/HG002-rep4_m84011_220902_175841_s1.hifi_reads.bam -r /reference/homo_sapiens.fasta --out /paraphrase/ --genome 38 -g smn1,CR1,AMY1A,CTAG1A,BOLA2