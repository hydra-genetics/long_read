__author__ = "Magdalena Zarowiecki"
__copyright__ = "Copyright 2023, Uppsala universitet"
__email__ = "magdalena.z@scilifelab.uu.se"
__license__ = "GPL-3"


#ruleorder: trgt_genotype > bgzip_vcf


rule trgt_genotype:
    input:
        reference=config['reference']['fasta'],
        bam = "long_read/pbmm2_align/{sample}_{type}_{flowcell}_{barcode}.pbmm2.sort.bam",
        bai = "long_read/pbmm2_align/{sample}_{type}_{flowcell}_{barcode}.pbmm2.sort.bam.bai",
        bed = config['trgt']['trgt_bed'],
    output:
        vcf = "long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.trgt.vcf.gz",
        bam = "long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.trgt.spanning.bam",
    log: "long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.genotype.log",
    benchmark: "long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.genotype.tsv",
    params:
        prefix = "long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.trgt",
        extra=config.get("whatshap_phase", {}).get("extra", ""),
    threads: config.get("whatshap_phase", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("trgt", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("trgt", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("trgt", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("trgt", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("trgt", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("trgt", {}).get("container", config["default_container"])
    message: "Executing {rule}: Genotyping tandem repeat regions from {input.bed} in {input.bam} using trgt."
    shell:
        """
        (trgt --threads {threads} \
            --genome {input.reference} \
            --repeats {input.bed} \
            --reads {input.bam} \
            --output-prefix {params.prefix}) > {log} 2>&1
        
        touch {output.vcf} {output.bam} 
        """


rule trgt_coverage_dropouts:
    input:
        bam = "long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.whatshap_haplotagged.bam",
        bai = "long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.whatshap_haplotagged.bam.bai",
        bed = config['reference']['trgt_bed'],
    output: "long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.trgt.dropouts.txt",
    log: "long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.dropouts.log",
    benchmark: "long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.dropouts.tsv",
    params:
        prefix = "long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.trgt",
        extra=config.get("trgt", {}).get("extra", ""),
    threads: config.get("trgt", {}).get("threads", config["default_resources"]["threads"]),
    resources:
        mem_mb=config.get("trgt", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("trgt", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("trgt", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("trgt", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("trgt", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("trgt", {}).get("container", config["default_container"])
    message: "Executing {rule}: Identify coverage dropouts in {input.bed} regions in {input.bam} using trgt."
    shell: "(python3 workflow/scripts/check_trgt_coverage.py {input.bed} {input.bam} > {output}) > {log} 2>&1"

# Originates from https://github.com/PacificBiosciences/pb-human-wgs-workflow-snakemake/blob/main/rules/sample_trgt.smk




