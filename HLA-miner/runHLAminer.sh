#!/bin/bash

export MODULEPATH=/.mounts/labs/resit/modulator/modulefiles/data:/.mounts/labs/resit/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/data

input_dir=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Seqware_CASAVA
# output_dir=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Neo-antigens/HLA-VBSeq; mkdir -p ${output_dir}
output_dir=/scratch2/groups/gsi/bis/prath/HLA-miner; mkdir -p ${output_dir}

mastersheet=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/mastersheet/TGL20.mastersheet.csv

scrp=`pwd`/script ; mkdir -p $scrp
logd=`pwd`/logs ; mkdir -p $logd

for items in `cat $mastersheet | grep EX | grep -v Blood | cut -d, -f3,15-17`; do
  name=`echo $items | cut -d, -f1`
  output_prefix=`echo $items | tr "," "_"`
  FQ1=${input_dir}/${output_prefix}.R1.fastq.gz
  FQ2=${input_dir}/${output_prefix}.R2.fastq.gz
  # output_prefix=nameoutput_prefix

  # define jobs
  # there are 4 jobs
  hla_miner_align_job="hla_01_${name}_align"
  echo '#!/bin/sh' > $scrp/${align_job}.sh
  echo "`pwd`/bash/01_hla_miner_align.sh ${output_prefix} ${output_dir} ${input_dir}" >> $scrp/${hla_miner_align_job}.sh
  chmod +x $scrp/${hla_miner_align_job}.sh
  qsub -V -l h_vmem=32g -N ${hla_miner_align_job} -e $logd -o $logd $scrp/${hla_miner_align_job}.sh

  hla_miner_job="hla_02_${name}_hla_miner"
  echo '#!/bin/sh' > $scrp/${hla_miner_job}.sh
  echo "`pwd`/bash/02_generate_results.sh ${output_prefix} ${output_dir}" >> $scrp/${hla_miner_job}.sh
  chmod +x $scrp/${hla_miner_job}.sh
  qsub -V -l h_vmem=32g -hold_jid ${hla_miner_align_job} -N ${hla_miner_job} -e $logd -o $logd $scrp/${hla_miner_job}.sh
done
