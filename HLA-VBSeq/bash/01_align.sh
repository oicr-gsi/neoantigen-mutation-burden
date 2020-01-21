#!/bin/bash
export MODULEPATH=/.mounts/labs/resit/modulator/modulefiles/data:/.mounts/labs/resit/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/data

output_prefix=$1
output_dir=$2
input_dir=$3

#path to HLA-VBSeq codes
VBSeq_dir=/.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq
ref_fasta=${VBSeq_dir}/hla_all_v2.fasta


FQ1=${input_dir}/${output_prefix}.R1.fastq.gz
FQ2=${input_dir}/${output_prefix}.R2.fastq.gz

module load bwa/0.7.17

bwa mem -t 8 -P -L 10000 -a ${ref_fasta} ${FQ1} ${FQ2} > ${output_dir}/${output_prefix}_HLA-VBSeq.bam
