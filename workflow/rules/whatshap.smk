

rule whatshap_phase:
    input:
        reference = config['ref']['fasta'],
        vcf = "parabricks/pbrun_deepvariant/{sample}_{type}_{flowcell}_{barcode}.deepvariant.g.vcf.gz",
        tbi = "parabricks/pbrun_deepvariant/{sample}_{type}_{flowcell}_{barcode}.deepvariant.g.vcf.gz.tbi",
        phaseinput = "long_read/pbmm2_align/{sample}_{type}_{flowcell}_{barcode}.pbmm2.sort.bam",
        phaseinputindex = "long_read/pbmm2_align/{sample}_{type}_{flowcell}_{barcode}.pbmm2.sort.bam.bai",
    output: "long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.deepvariant.phased.vcf.gz"),
    log: "long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.deepvariant.phased.log",
    benchmark: "long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.deepvariant.phased.tsv",
    params: 
        extra = "--indels",
    shell:
        """
        (whatshap phase {params.extra} \
            --output {output} \
            --reference {input.reference} \
            {input.vcf} \
            {input.phaseinput}) > {log} 2>&1
        """

# whatshap phase -o phased.vcf --reference=reference.fasta input.vcf input.bam


rule whatshap_haplotag:
    input:
        "phased.vcf.gz.tbi",
        "alignment.bam.bai",
        "reference.fasta.fai",
        vcf ="phased.vcf.gz",
        aln ="alignment.bam",
        ref = "reference.fasta"
    output:
        "alignment.phased.bam"
    params:
        extra="" # optionally use --ignore-linked-read, --tag-supplementary, etc.
    log:
        "logs/haplotag.10X.phased.log"
    threads: 4
    wrapper:
        "v3.5.2/bio/whatshap/haplotag"




