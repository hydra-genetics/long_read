# Softwares used in the long_read module

## [pbmm2_align](url_to_tool)
Introduction to pbmm2_align

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__pbmm2__pbmm2_align#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__pbmm2__pbmm2_align#
## [minimap2](https://github.com/lh3/minimap2)
A versatile pairwise aligner for genomic and spliced nucleotide sequences 

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__minimap2__minimap2#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__minimap2__minimap2#

#CONFIGSCHEMA__minimap2#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__minimap2#

#CONFIGSCHEMA__pbsv_discover#

#### Resources settings (`resources.yaml`)


## [pbsv_discover](https://github.com/PacificBiosciences/pbsv)
pbsv is a suite of tools to call and analyze structural variants in diploid genomes from PacBio single molecule real-time sequencing (SMRT) reads. This rule uses a bam file to find structural variant candidates.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__pbsv__pbsv_discover#

#### :left_right_arrow: input / output files

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__pbmm2_align#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__pbmm2_align#

#RESOURCESSCHEMA__pbsv_discover#

## [pbsv_call](https://github.com/PacificBiosciences/pbsv)
pbsv is a suite of tools to call and analyze structural variants in diploid genomes from PacBio single molecule real-time sequencing (SMRT) reads. This rule Calls the structural variants from a candidate structural variant file. Use --ccs option when using hifi data.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__pbsv__pbsv_call#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__pbsv__pbsv_call#

#CONFIGSCHEMA__pbsv_call#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__pbsv_call#

## [sniffles](https://github.com/fritzsedlazeck/Sniffles)
Introduction to sniffles


For somatic calling add --non-germline 

For improved calling in repetitive regions add --tandem-repeats annotations.bed. 
An annotation bed file can be found on the sniffles repository in annotations/folder

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__sniffles__sniffles#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__sniffles__sniffles#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__sniffles#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__sniffles#
