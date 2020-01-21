#!/bin/bash

export MODULEPATH=/.mounts/labs/resit/modulator/modulefiles/data:/.mounts/labs/resit/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/data
module load java/8

output_prefix=$1
output_dir=$2


#path to HLA-VBSeq codes
VBSeq_dir=/.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq
ref_fasta=${VBSeq_dir}/hla_all_v2.fasta
VBSeq_jar=${VBSeq_dir}/HLAVBSeq.jar

java -jar -Xmx32g -Xms32g \
  ${VBSeq_jar} ${ref_fasta} \
  ${output_dir}/${output_prefix}_HLA-VBSeq.bam \
  ${output_dir}/${output_prefix}_HLA-VBSeq_results.txt \
  --alpha_zero 0.01 \
  --is_paired
