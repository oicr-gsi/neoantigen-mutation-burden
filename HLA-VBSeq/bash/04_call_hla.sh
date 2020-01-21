#!/bin/bash

export MODULEPATH=/.mounts/labs/resit/modulator/modulefiles/data:/.mounts/labs/resit/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/data

output_prefix=$1
output_dir=$2

#path to HLA-VBSeq codesjob_01_1034_TS_align.e5349983
VBSeq_dir=/.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq
#setting up aliases
Allele_list=${VBSeq_dir}/Allelelist_v2.txt
VBSeq_py=${VBSeq_dir}/call_hla_digits.py

module load python/3.6

python3 ${VBSeq_py} -v ${output_dir}/${output_prefix}_HLA-VBSeq_results.txt -a ${Allele_list} -r 90 -d 4 --ispaired > ${output_dir}/${output_prefix}_HLA-VBSeq_call.txt
