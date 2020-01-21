#!/bin/bash

export MODULEPATH=/.mounts/labs/resit/modulator/modulefiles/data:/.mounts/labs/resit/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/data

output_prefix=$1
output_dir=$2

#path to HLA-VBSeq codes
VBSeq_dir=/.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq
#setting up aliases
Allele_list=${VBSeq_dir}/Allelelist_v2.txt
VBSeq_pl=${VBSeq_dir}/parse_result.pl

module load perl/5.30

perl ${VBSeq_pl} ${Allele_list} ${output_dir}/${output_prefix}_HLA-VBSeq_results.txt  > ${output_dir}/${output_prefix}_HLA-VBSeq_prediction.txt
