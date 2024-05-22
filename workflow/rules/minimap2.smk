__author__ = "Patrik Smeds"
__copyright__ = "Copyright 2023, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "GPL-3"

import os
from pathlib import Path

# Get the current working directory
current_working_dir1 = Path.cwd() 
current_working_dir2 = Path.cwd() / 'workflow' 
current_working_dir3 = Path.cwd() / 'workflow'  / 'scripts'
'''    
# Construct the path to the Snakefile
scripts_file_path = current_working_dir / 'workflow' / 'scripts'
    
# Normalize the path to remove any redundant separators
scripts_file_path = scripts_file_path.resolve()

print("MOD: ", scripts_file_path)

# Add the directory containing the module to the Python path
if scripts_file_path not in sys.path:
    sys.path.insert(0, scripts_file_path)
'''

print("MOD: ", current_working_dir1,  current_working_dir2, current_working_dir3 )

# Add the directory containing the module to the Python path
if current_working_dir not in sys.path:
    sys.path.insert(0, current_working_dir1)
    sys.path.insert(0, current_working_dir2)
    sys.path.insert(0, current_working_dir3)

# Import the function from the module
try:
    from workflow.scripts.minimap2_get_readgroups import extract_rg_lines
except:
    pass
try:
    from scripts.minimap2_get_readgroups import extract_rg_lines
except:
    pass
try:
    from minimap2_get_readgroups import extract_rg_lines
except:
    pass

rule minimap2:
    input:
        query=lambda wildcards: get_minimap2_query(wildcards),
        target=config.get("reference", {}).get("fasta", ""),
        index=config.get("minimap2", {}).get("index", ""),
    output:
        bam="long_read/minimap2/{sample}_{type}_{flowcell}_{barcode}.mm2.bam",
    params:
        extra=config.get("minimap2", {}).get("extra", ""),
        sorting=config.get("minimap2", {}).get("sorting", ""),
        sorting_extra=config.get("minimap2", {}).get("sorting_extra", ""),
        extra_rg=minimap2_get_readgroups.extract_rg_lines(query)
    log:
        "long_read/minimap2/{sample}_{type}_{flowcell}_{barcode}.bam.log",
    benchmark:
        repeat("long_read/minimap2/{sample}_{type}_{flowcell}_{barcode}.bam.benchmark.tsv", config.get("minimap2", {}).get("benchmark_repeats", 1))
    threads: config.get("minimap2", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("minimap2", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("minimap2", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("minimap2", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("minimap2", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("minimap2", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("minimap2", {}).get("container", config["default_container"])
    message:
        "{rule}: run minimap2 on {input}"
    wrapper:
        "v3.3.5/bio/minimap2/aligner"

rule minimap2_index:
    input:
        bam="long_read/minimap2/{sample}_{type}_{flowcell}_{barcode}.mm2.bam",
    output:
        bai="long_read/minimap2/{sample}_{type}_{flowcell}_{barcode}.mm2.bam.bai",
    log:
        "long_read/minimap2/{sample}_{type}_{flowcell}_{barcode}.bamindex.log",
    threads: config.get("minimap2", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("minimap2_index", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("minimap2_index", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("minimap2_index", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("minimap2_index", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("minimap2_index", {}).get("time", config["default_resources"]["time"]),
    #shell:
    #    "samtools index {input.bam} &> log"
    wrapper:
        "v3.4.1/bio/samtools/index"

