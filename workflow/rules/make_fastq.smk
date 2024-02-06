
__author__ = "Magdalena Zarowiecki"
__copyright__ = "Copyright 2023, Uppsala Universitet"
__email__ = "magdalena.z@scilifelab.uu.se"
__license__ = "GPL-3"


rule extract_fastq_from_bam:
    input:
        query=lambda wildcards: get_minimap2_query(wildcards)
    output:
        fastq="long_read/fastq/{sample}_{type}.fastq"
    shell:
        """
        samtools fastq  -o  {output.fastq} {input.query}
        """

