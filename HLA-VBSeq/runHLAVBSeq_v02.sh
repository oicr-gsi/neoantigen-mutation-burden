#!/bin/bash

export MODULEPATH=/.mounts/labs/resit/modulator/modulefiles/data:/.mounts/labs/resit/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/data

# input_dir=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Seqware_CASAVA
# output_dir=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Neo-antigens/HLA-VBSeq; mkdir -p ${output_dir}
output_dir=/scratch2/groups/gsi/bis/prath/HLA-VBSeq; mkdir -p ${output_dir}

mastersheet=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/mastersheet/TGL20.mastersheet.csv

scrp=`pwd`/script ; mkdir -p $scrp
logd=`pwd`/logs ; mkdir -p $logd

for items in `cat $mastersheet | grep EX | grep -v Blood | cut -d, -f3,15-17`; do
  name=`echo $items | cut -d, -f1`
  output_prefix=`echo $items | tr "," "_"`
  # define jobs
  # there are 4 jobs
  align_job="vbseq_01_${name}_align"
  echo '#!/bin/sh' > $scrp/${align_job}.sh
  echo "`pwd`/bash/01_vbseq_extract_hla_alignments.sh ${output_prefix} ${output_dir}" >> $scrp/${align_job}.sh
  chmod +x $scrp/${align_job}.sh
  qsub -V -l h_vmem=64g -N ${align_job} -e $logd -o $logd $scrp/${align_job}.sh

  extract_reads="vbseq_02_${name}_extract_reads"
  echo '#!/bin/sh' > $scrp/${extract_reads}.sh
  echo "`pwd`/bash/02_vbseq_extract_reads_from_bam.sh ${output_prefix} ${output_dir}" >> $scrp/${extract_reads}.sh
  chmod +x $scrp/${extract_reads}.sh
  qsub -V -l h_vmem=64g -hold_jid ${align_job} -N ${extract_reads} -e $logd -o $logd $scrp/${extract_reads}.sh

  predict_hla_job="vbseq_03_${name}_predict_hla"
  echo '#!/bin/sh' > $scrp/${predict_hla_job}.sh
  echo "`pwd`/bash/03_hla_typing.sh ${output_prefix} ${output_dir}" >> $scrp/${predict_hla_job}.sh
  chmod +x $scrp/${predict_hla_job}.sh
  qsub -V -l h_vmem=64g -hold_jid ${extract_reads} -N ${predict_hla_job} -e $logd -o $logd $scrp/${predict_hla_job}.sh
done
