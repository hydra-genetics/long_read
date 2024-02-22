__author__ = "Magdalena Zarowiecki"
__copyright__ = "Copyright 2023, Uppsala Universitet"
__email__ = "magdalena.z@scilifelab.uu.se"
__license__ = "GPL-3"

# compile_paraphase_file_list(wildcards)
GENE = ["smn1","CR1","AMY1A","CTAG1A","BOLA2"]
#SAMPLE = get_samples(samples) # Example names
#TYPES = get_unit_types(units, samples) # Example types


rule paraphase:
    input:
        bam="long_read/minimap2/{sample}_{type}.bam",
        fasta=config.get("paraphase", {}).get("fasta", ""),
    output:
        outfCR1="long_read/paraphase/{sample}_{type}_vcfs/{sample}_{type}_CR1_variants.vcf",
        #outfCR1 = expand("long_read/paraphase/{{sample}}_{{type}}_vcfs/{{sample}}_{{type}}_{gene}_variants.vcf", gene=GENE),
    params:
        genome=config.get("paraphase", {}).get("genome", ""),
        extra=config.get("paraphase", {}).get("extra", ""),
        outfolder=directory("long_read/paraphase/"),
    log:
        "long_read/paraphase/{sample}_{type}.vcf.log",
    benchmark:
        repeat("long_read/paraphase/{sample}_{type}.out.benchmark.tsv", config.get("paraphase", {}).get("benchmark_repeats", 1))
    threads: config.get("paraphase", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("paraphase", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("paraphase", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("paraphase", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("paraphase", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("paraphase", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("paraphase", {}).get("container", config["default_container"])
    message:
        "{rule}: Calls SNVs on {input.bam} with paraphase to resolve SNVs in gene families"
    shell:
        """
        paraphase --bam {input.bam} \
        --reference {input.fasta} \
        --out {params.outfolder} \
        {params.genome} \
        {params.extra} &> {log}; \
        sleep 10
        """

# paraphase --bam /bam/HG002-rep4_m84011_220902_175841_s1.hifi_reads.bam -r /reference/homo_sapiens.fasta --out /paraphase/ --genome 38 -g smn1,CR1,AMY1A,CTAG1A,BOLA2


rule paraphase_merge_and_copy_vcf:
    input:
        vcf_files="long_read/paraphase/{sample}_{type}_vcfs/{sample}_{type}_CR1_variants.vcf"
        #vcf_files = expand("long_read/paraphase/{{sample}}_{{type}}_vcfs/{{sample}}_{{type}}_{gene}_variants.vcf", gene=GENE)
    params:
        variant_files="long_read/paraphase/{sample}_{type}_vcfs/*_variants.vcf.gz"
    output:
        merged_vcf = "long_read/paraphase/{sample}_{type}_paraphase.vcf.gz"
    threads: config.get("paraphase", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("paraphase", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("paraphase", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("paraphase", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("paraphase", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("paraphase", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("paraphase", {}).get("container", config["default_container"])
    message:
        "{rule}: Merging paraphrase output"
    shell:
        """
        find long_read/paraphase/{sample}_{type}_vcfs/*_variants.vcf -type f -exec bgzip {} \;
        find long_read/paraphase/{sample}_{type}_vcfs/*_variants.vcf.gz -type f -name '*_variants.vcf.gz' -exec bcftools index {} \;
        bcftools concat  -O v {params.variant_files} | bcftools annotate --header reference/vcf_chromosome_header.vcf | bcftools sort  -Oz -o {output.merged_vcf} 
        """


