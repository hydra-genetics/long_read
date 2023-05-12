# Softwares used in the long_read module

## [pbsv_discover](https://github.com/PacificBiosciences/pbsv)
pbsv is a suite of tools to call and analyze structural variants in diploid genomes from PacBio single molecule real-time sequencing (SMRT) reads. This rule uses a bam file to find structural variant candidates.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__pbsv__pbsv_discover#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__pbsv__pbsv_discover#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__pbsv_discover#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__pbsv_discover#

## [pbsv_call](https://github.com/PacificBiosciences/pbsv)
pbsv is a suite of tools to call and analyze structural variants in diploid genomes from PacBio single molecule real-time sequencing (SMRT) reads. This rule Calls the structural variants from a candidate structural variant file. Use --ccs option when using hifi data.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__pbsv__pbsv_call#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__pbsv__pbsv_call#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__pbsv_call#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__pbsv_call#
