#!/bin/bash
export MODULEPATH=/.mounts/labs/resit/modulator/modulefiles/data:/.mounts/labs/resit/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/data
module load perl/5.30

HLAminer_tool=/.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLAminer
hla_miner=${HLAminer}/HLAminer_v1.4/bin/HLAminer_V2.pl
HLA_gene_fasta=${HLAminer_tool}/HLAminer_v1.4/bwa_index/hla_genes.fasta
HLA_nom=${HLAminer_tool}/HLAminer_v1.4/database//hla_nom_p.txt

output_prefix=$1
output_dir=$2

${hla_miner} -a ${output_dir}/${output_prefix}_HLAminer.sam -h ${HLA_gene_fasta} -s 500 -p ${HLA_nom} -l ${output_prefix}
