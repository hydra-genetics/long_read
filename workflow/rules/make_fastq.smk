
__author__ = "Magdalena Zarowiecki"
__copyright__ = "Copyright 2023, Uppsala Universitet"
__email__ = "magdalena.z@scilifelab.uu.se"
__license__ = "GPL-3"


rule make_fastq:
    input:
        #query=lambda wildcards: get_minimap2_query(wildcards)
        query="long_read/minimap2/{sample}_{type}_{flowcell}_{barcode}.mm2.bam",
    output:
        #fastq="long_read/fastq/{sample}_{type}.fastq"
        fastq="long_read/hifiasm/{sample}_{type}_{flowcell}_{barcode}.s2fq.fastq.gz", 
    shell:
        """
        samtools fastq  -o  {output.fastq} {input.query}
        """

