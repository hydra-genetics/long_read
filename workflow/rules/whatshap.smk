

rule whatshap_phase:
    input:
        reference=config['reference']['fasta'],
        vcf="parabricks/pbrun_deepvariant/{sample}_{type}_{flowcell}_{barcode}.deepvariant.g.vcf",
        tbi="parabricks/pbrun_deepvariant/{sample}_{type}_{flowcell}_{barcode}.deepvariant.g.vcf.idx",
        phaseinput="long_read/pbmm2_align/{sample}_{type}_{flowcell}_{barcode}.pbmm2.sort.bam",
        phaseinputindex="long_read/pbmm2_align/{sample}_{type}_{flowcell}_{barcode}.pbmm2.sort.bam.bai",
    output: 
        output="long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.whatshap.phased.vcf.gz",
        outindex="long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.whatshap.phased.vcf.gz.tbi",
    log: "long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.whatshap.phased.log",
    benchmark: "long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.whatshap.phased.tsv",
    params:
        extra=config.get("whatshap_phase", {}).get("extra", ""),
    threads: config.get("whatshap_phase", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("whatshap_phase", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("whatshap_phase", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("whatshap_phase", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("whatshap_phase", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("whatshap_phase", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("whatshap_phase", {}).get("container", config["default_container"])
    shell:
        """
        # Phase with WhatsHap, outputting an uncompressed VCF
        (whatshap phase {params.extra} \
            --output {output} \
            --reference {input.reference} \
            {input.vcf} \
            {input.phaseinput}) > {log} 2>&1

        # Index the compressed VCF file with tabix
        #(tabix -p vcf {output}) >> {log} 2>&1
        """



rule whatshap_haplotag:
    input:
        "long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.whatshap.phased.vcf.gz.tbi",
        "long_read/pbmm2_align/{sample}_{type}_{flowcell}_{barcode}.pbmm2.sort.bam.bai",
        config['reference']['fai'],
        vcf="long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.whatshap.phased.vcf.gz",
        aln="long_read/pbmm2_align/{sample}_{type}_{flowcell}_{barcode}.pbmm2.sort.bam",
        ref=config['reference']['fasta'],
    output:
        "long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.whatshap_haplotagged.bam"
    params:
        extra=config.get("whatshap_phase", {}).get("extra", ""), # optionally use --ignore-linked-read, --tag-supplementary, etc.
    log:
        "long_read/whatshap/{sample}_{type}_{flowcell}_{barcode}.whatshap_haplotagged.log"
    threads: config.get("whatshap_haplotag", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("whatshap_haplotag", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("whatshap_haplotag", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("whatshap_haplotag", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("whatshap_haplotag", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("whatshap_haplotag", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("whatshap_phase", {}).get("container", config["default_container"])
    wrapper:
        "v3.5.2/bio/whatshap/haplotag"




