__author__ = "Magdalena Zarowiecki"
__copyright__ = "Copyright 2023, Uppsala Universitet"
__email__ = "magdalena.z@scilifelab.uu.se"
__license__ = "GPL-3"

# Snakefile

# Load configuration
configfile: "config.yaml"

# Rule for running Parabricks DeepVariant
rule run_deepvariant:
    input:
        bam=config['parabricks']['input_bam'],
        ref=config['parabricks']['reference']
    output:
        vcf=config['parabricks']['output_vcf']
    params:
        chunk_size=config['parabricks']['chunk_size'],
        num_gpus=config['parabricks']['num_gpus'],
        num_workers=config['parabricks']['num_workers']
    shell:
        """
        parabricks deepvariant \
          --input-bam {input.bam} \
          --output-vcf {output.vcf} \
          --reference {input.ref} \
          --chunk-size {params.chunk_size} \
          --num-gpus {params.num_gpus} \
          --num-workers {params.num_workers}
        """

# Rule for running MitoHiFi with Docker
rule run_mitohifi:
    input:
        fasta="path/to/input.fasta"  # Replace with actual input
    output:
        outdir="path/to/output_dir"  # Replace with actual output directory
    params:
        docker_image=config['docker_containers']['mitohifi']
    singularity:
        "docker://{params.docker_image}"
    shell:
        """
        mkdir -p {output.outdir}
        singularity exec docker://{params.docker_image} mitohifi \
          -i {input.fasta} \
          -o {output.outdir}
        """

# Use ruleorder if needed to prioritize certain rules
ruleorder: run_deepvariant > run_mitohifi



