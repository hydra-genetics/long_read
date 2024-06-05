__author__ = "Padraic Corcoran"
__copyright__ = "Copyright 2024, Padraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"

rule cpgtools_aligned_bam_to_cpg_scores:
    input:
        bai=config.get("pbmm2_align", {}).get("index", ""),
        bam=pbmm2_input
    output:
        outbed="long_read/cpgtools/{sample}_{type}_{processing_unit}_{barcode}.combined.bed",
        outcov="long_read/cpgtools/{sample}_{type}_{processing_unit}_{barcode}.combined.bw"
    params:
        model=config.get("cpgtools_aligned_bam_to_cpg_scores", {}).get("model", ""),
        sample=lambda wildcards: wildcards.sample,
        extra=config.get("cpgtools_aligned_bam_to_cpg_scores", {}).get("extra", "")
    log:
        bam="long_read/cpgtools/{sample}_{type}_{processing_unit}_{barcode}.bam.log"
    benchmark:
        repeat(
            "long_read/cpgtools/{sample}_{type}_{processing_unit}_{barcode}.bam.benchmark.tsv",
            config.get("cpgtools_aligned_bam_to_cpg_scores", {}).get("benchmark_repeats", 1)
        )
    threads: config.get("cpgtools_aligned_bam_to_cpg_scores", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("cpgtools_aligned_bam_to_cpg_scores", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("cpgtools_aligned_bam_to_cpg_scores", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("cpgtools_aligned_bam_to_cpg_scores", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("cpgtools_aligned_bam_to_cpg_scores", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("cpgtools_aligned_bam_to_cpg_scores", {}).get("time", config["default_resources"]["time"])
    container:
        config.get("cpgtools_aligned_bam_to_cpg_scores", {}).get("container", config["default_container"])
    message:
        "{rule}: Identify methylated regions in {input.bam}"
    shell:
        "pb-CpG-tools-v2.3.2-x86_64-unknown-linux-gnu/bin/aligned_bam_to_cpg_scores "
        "--bam {input.bam} "
        "--output-prefix long_read/cpgtools/{wildcards.sample}_{wildcards.type}_{wildcards.processing_unit}_{wildcards.barcode} "
        "--model {params.model} "
        "--threads {threads} "
        "{params.extra} &> {log}"

