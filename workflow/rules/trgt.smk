__author__ = "Magdalena Zarowiecki"
__copyright__ = "Copyright 2023, Uppsala universitet"
__email__ = "magdalena.z@scilifelab.uu.se"
__license__ = "GPL-3"


ruleorder: trgt_genotype > bgzip_vcf


rule trgt_genotype:
    input:
        reference=config['reference']['fasta'],
        bam = f"long_read/pbmm2_align/{sample}_{type}_{flowcell}_{barcode}.pbmm2.sort.bam",
        bai = f"long_read/pbmm2_align/{sample}_{type}_{flowcell}_{barcode}.pbmm2.sort.bam.bai",
        bed = config['reference']['trgt_bed'],
    output:
        vcf = f"long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.trgt.vcf.gz",
        bam = f"long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.trgt.spanning.bam",
    log: f"long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.genotype.log"
    benchmark: f"long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.genotype.tsv"
    conda: "envs/trgt.yaml"
    params:
        prefix = f"long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.trgt"
    threads: 32
    message: "Executing {rule}: Genotyping tandem repeat regions from {input.bed} in {input.bam}."
    shell:
        """
        (trgt --threads {threads} \
            --genome {input.reference} \
            --repeats {input.bed} \
            --reads {input.bam} \
            --output-prefix {params.prefix}) > {log} 2>&1
        """


rule trgt_coverage_dropouts:
    input:
        bam = f"long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.whatshap_haplotagged.bam",
        bai = f"long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.whatshap_haplotagged.bam.bai",
        bed = config['reference']['trgt_bed']
    output: f"long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.trgt.dropouts.txt"
    log: f"long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.dropouts.log"
    benchmark: f"long_read/trgt/{sample}_{type}_{flowcell}_{barcode}.dropouts.tsv"
    conda: "envs/tandem-genotypes.yaml"
    message: "Executing {rule}: Identify coverage dropouts in {input.bed} regions in {input.bam}."
    shell: "(python3 workflow/scripts/check_trgt_coverage.py {input.bed} {input.bam} > {output}) > {log} 2>&1"

# Originates from https://github.com/PacificBiosciences/pb-human-wgs-workflow-snakemake/blob/main/rules/sample_trgt.smk

