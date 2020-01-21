#!/bin/bash
export MODULEPATH=/.mounts/labs/resit/modulator/modulefiles/data:/.mounts/labs/resit/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/data

module load samtools/1.9

# output_prefix=2487_TS_190201_D00355_0266_BCD5VRANXX_TTCACGCA-TCTTTCCC_L005
# output_dir=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Neo-antigens/HLA-VBSeq/${output_prefix}; mkdir -p ${output_dir}
# input_dir=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Seqware_BwaMem
output_prefix=$1
output_dir=$2/${output_prefix}; mkdir -p ${output_dir}
input_dir=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Seqware_BwaMem

ln -sf ${input_dir}/${output_prefix}.bam ${output_dir}/${output_prefix}.bam
ln -sf ${input_dir}/${output_prefix}.bai ${output_dir}/${output_prefix}.bai

samtools view ${output_dir}/${output_prefix}.bam \
chr6:29907037-29915661 \
chr6:31319649-31326989 \
chr6:31234526-31241863 \
chr6:32914391-32922899 \
chr6:32900406-32910847 \
chr6:32969960-32979389 \
chr6:32778540-32786825 \
chr6:33030346-33050555 \
chr6:33041703-33059473 \
chr6:32603183-32613429 \
chr6:32707163-32716664 \
chr6:32625241-32636466 \
chr6:32721875-32733330 \
chr6:32405619-32414826 \
chr6:32544547-32559613 \
chr6:32518778-32554154 \
chr6:32483154-32559613 \
chr6:30455183-30463982 \
chr6:29689117-29699106 \
chr6:29792756-29800899 \
chr6:29793613-29978954 \
chr6:29855105-29979733 \
chr6:29892236-29899009 \
chr6:30225339-30236728 \
chr6:31369356-31385092 \
chr6:31460658-31480901 \
chr6:29766192-29772202 \
chr6:32810986-32823755 \
chr6:32779544-32808599 \
chr6:29756731-29767588 | awk '{print $$1}' | sort | uniq > ${output_dir}/${output_prefix}_partial_reads.txt

# extract unmapped _partial_reads
samtools view -bh -f 12 -F 256 ${output_dir}/${output_prefix}.bam > ${output_dir}/${output_prefix}_unmapped.bam
