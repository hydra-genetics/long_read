__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2023, Jonas Almlöf"
__email__ = "jonas.almlof@scilife.uu.se"
__license__ = "GPL-3"


rule pbsv_discover:
    input:
        bam="long_read/samtools_merged_bam/{samnple}_{type}.bam",
    output:
        svsig="long_read/pbsv_discover/{sample}_{type}.svsig.gz",
    params:
        extra=config.get("pbsv_discover", {}).get("extra", ""),
    log:
        "long_read/pbsv_discover/{sample}_{type}.output.log",
    benchmark:
        repeat(
            "long_read/pbsv_discover/{sample}_{type}.output.benchmark.tsv",
            config.get("pbsv_discover", {}).get("benchmark_repeats", 1)
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
        "{rule}: Do stuff on long_read/{rule}/{wildcards.sample}_{wildcards.type}.input"
    wrapper:
        "..."
