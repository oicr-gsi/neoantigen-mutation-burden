#!/bin/bash
export MODULEPATH=/.mounts/labs/resit/modulator/modulefiles/data:/.mounts/labs/resit/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/data

module load bwa/0.7.17
module load java/8
module load perl/5.30
# module load python/3.6

# output_prefix=2487_TS_190201_D00355_0266_BCD5VRANXX_TTCACGCA-TCTTTCCC_L005
# output_dir=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Neo-antigens/HLA-VBSeq/${output_prefix}; mkdir -p ${output_dir}
output_prefix=$1
output_dir=$2/${output_prefix}; mkdir -p ${output_dir}

# # bwa index /.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq/hla_all_v2.fasta
# bwa mem -t 8 -P -L 10000 -a /.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq/hla_all_v2.fasta ${output_dir}/${output_prefix}_combined_R1.fastq ${output_dir}/${output_prefix}_combined_R2.fastq > ${output_dir}/${output_prefix}_hla.sam
#
# # estimation of HLA types
# java -jar /.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq/HLAVBSeq.jar /.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq/hla_all_v2.fasta ${output_dir}/${output_prefix}_hla.sam ${output_dir}/${output_prefix}_result.txt --alpha_zero 0.01 --is_paired


perl /.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq/parse_result.pl /.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq/Allelelist_v2.txt ${output_dir}/${output_prefix}_result.txt  > ${output_dir}/${output_prefix}_HLA-VBSeq_prediction.txt

# next
/.mounts/labs/PDE/Modules/sw/python/Python-3.6.4/bin/python3 /.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq/call_hla_digits.py \
-v ${output_dir}/${output_prefix}_result.txt \
-a /.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq/Allelelist_v2.txt \
-r 90 \
-d 4 \
--ispaired > ${output_dir}/${output_prefix}_report.d4.txt
