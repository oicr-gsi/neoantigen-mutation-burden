#!/bin/bash
export MODULEPATH=/.mounts/labs/resit/modulator/modulefiles/data:/.mounts/labs/resit/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/data

# module load java/8
module load picard-tools

# output_prefix=2487_TS_190201_D00355_0266_BCD5VRANXX_TTCACGCA-TCTTTCCC_L005
# output_dir=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Neo-antigens/HLA-VBSeq/${output_prefix}
# input_dir=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Seqware_BwaMem

output_prefix=$1
output_dir=$2/${output_prefix}; mkdir -p ${output_dir}


#mapped reads
java -jar -Xmx32g -Xms32g /.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq/bamNameIndex.jar index ${output_dir}/${output_prefix}.bam --indexFile ${output_dir}/${output_prefix}.bam.idx
java -jar ${PICARD_TOOLS_ROOT}/SamToFastq.jar I=${output_dir}/${output_prefix}.sam F=${output_dir}/${output_prefix}.R1.fastq F2=${output_dir}/${output_prefix}.R2.fastq

# unmapped reads
java -jar /.mounts/labs/gsiprojects/external/zadehglab/SCOUT/tools/HLA-VBSeq/bamNameIndex.jar search ${output_dir}/${output_prefix}.bam  --name ${output_dir}/${output_prefix}_partial_reads.txt --output `pwd`/${output_prefix}.sam
java -jar ${PICARD_TOOLS_ROOT}/SamToFastq.jar I=${output_dir}/${output_prefix}_unmapped.bam F=${output_dir}/${output_prefix}_unmapped_1.fastq F2=${output_dir}/${output_prefix}_unmapped_2.fastq


# combine
cat ${output_dir}/${output_prefix}.R1.fastq ${output_dir}/${output_prefix}_unmapped_1.fastq > ${output_dir}/${output_prefix}_combined_R1.fastq
cat ${output_dir}/${output_prefix}.R2.fastq ${output_dir}/${output_prefix}_unmapped_2.fastq > ${output_dir}/${output_prefix}_combined_R2.fastq
