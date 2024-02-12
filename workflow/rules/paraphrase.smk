__author__ = "Magdalena Zarowiecki"
__copyright__ = "Copyright 2023, Uppsala Universitet"
__email__ = "magdalena.z@scilifelab.uu.se"
__license__ = "GPL-3"

# compile_paraphrase_file_list(wildcards)
GENE = ["smn1","CR1","AMY1A","CTAG1A","BOLA2"]
#SAMPLE = get_samples(samples) # Example names
#TYPES = get_unit_types(units, samples) # Example types


rule paraphrase:
    input:
        bam="long_read/minimap2/{sample}_{type}.bam",
        fasta=config.get("paraphrase", {}).get("fasta", ""),
    output:
        outfCR1="long_read/paraphrase/{sample}_{type}_vcfs/{sample}_{type}_CR1_variants.vcf",
        #outfCR1 = expand("long_read/paraphrase/{{sample}}_{{type}}_vcfs/{{sample}}_{{type}}_{gene}_variants.vcf", gene=GENE),
    params:
        genome=config.get("paraphrase", {}).get("genome", ""),
        extra=config.get("paraphrase", {}).get("extra", ""),
        outfolder=directory("long_read/paraphrase/"),
    log:
        "long_read/paraphrase/{sample}_{type}.vcf.log",
    benchmark:
        repeat("long_read/paraphrase/{sample}_{type}.out.benchmark.tsv", config.get("paraphrase", {}).get("benchmark_repeats", 1))
    threads: config.get("paraphrase", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("paraphrase", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("paraphrase", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("paraphrase", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("paraphrase", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("paraphrase", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("paraphrase", {}).get("container", config["default_container"])
    message:
        "{rule}: Calls SNVs on {input.bam} with paraphrase to resolve SNVs in gene families"
    script:
        "paraphrase --bam {input.bam} "
        "--reference {input.fasta} "
        "--out {params.outfolder} "
        "{params.genome} "
        "{params.extra} &> {log} "

# paraphase --bam /bam/HG002-rep4_m84011_220902_175841_s1.hifi_reads.bam -r /reference/homo_sapiens.fasta --out /paraphrase/ --genome 38 -g smn1,CR1,AMY1A,CTAG1A,BOLA2


rule paraphrase_merge_and_copy_vcf:
    input:
        vcf_files="long_read/paraphrase/{sample}_{type}_vcfs/{sample}_{type}_CR1_variants.vcf"
        #vcf_files = expand("long_read/paraphrase/{{sample}}_{{type}}_vcfs/{{sample}}_{{type}}_{gene}_variants.vcf", gene=GENE)
    output:
        merged_vcf = "long_read/paraphrase/{sample}_{type}_paraphrase.vcf.gz"
    shell:
        """
        bcftools concat -o {output.merged_vcf} -O v {input.vcf_files}
        bgzip {output.merged_vcf}
        """


 #bcftools concat -o {output.merged_vcf} -O v {input.vcf_files}

