__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2023, Jonas Almlöf"
__email__ = "jonas.almlof@scilife.uu.se"
__license__ = "GPL-3"


rule pbsv_discover:
    input:
        bam="long_read/samtools_merged_bam/{sample}_{type}.bam",
    output:
        svsig="long_read/pbsv_discover/{sample}_{type}.svsig.gz",
    params:
        extra=config.get("pbsv_discover", {}).get("extra", ""),
    log:
        "long_read/pbsv_discover/{sample}_{type}.svsig.gz.log",
    benchmark:
        repeat(
            "long_read/pbsv_discover/{sample}_{type}.svsig.gz.benchmark.tsv",
            config.get("pbsv_discover", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("pbsv_discover", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("pbsv_discover", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("pbsv_discover", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("pbsv_discover", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("pbsv_discover", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("pbsv_discover", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("pbsv_discover", {}).get("container", config["default_container"])
    message:
        "{rule}: create sv signatures using {input.bam}"
    shell:
        "(pbsv discover "
        "{input.bam} "
        "{output.svsig} "
        "{params.extra}) "
        "&> {log}"


rule pbsv_call:
    input:
        svsig="long_read/pbsv_discover/{sample}_{type}.svsig.gz",
        tabix="long_read/pbsv_discover/{sample}_{type}.svsig.gz.tbi",
        ref=config.get("reference", {}).get("fasta", ""),
    output:
        vcf="long_read/pbsv_call/{sample}_{type}.vcf",
    params:
        ccs=config.get("pbsv_call", {}).get("ccs", ""),
        extra=config.get("pbsv_call", {}).get("extra", ""),
    log:
        "long_read/pbsv_call/{sample}_{type}.vcf.log",
    benchmark:
        repeat(
            "long_read/pbsv_call/{sample}_{type}.vcf.benchmark.tsv",
            config.get("pbsv_call", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("pbsv_call", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("pbsv_call", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("pbsv_call", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("pbsv_call", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("pbsv_call", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("pbsv_call", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("pbsv_call", {}).get("container", config["default_container"])
    message:
        "{rule}: Call structural variants into {output.vcf}"
    shell:
        "(pbsv call "
        "{input.ref} "
        "-r {input.svsig} "
        "{output.vcf} "
        "{params.extra} "
        "&> {log}"
