#!/bin/bash

export MODULEPATH=/.mounts/labs/resit/modulator/modulefiles/data:/.mounts/labs/resit/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/data

input_dir=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Seqware_CASAVA
# output_dir=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Neo-antigens/HLA-VBSeq; mkdir -p ${output_dir}
output_dir=/scratch2/groups/gsi/bis/prath/HLA; mkdir -p ${output_dir}

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
  align_job="job_01_${name}_align"
  echo '#!/bin/sh' > $scrp/${align_job}.sh
  echo "`pwd`/bash/01_align.sh ${output_prefix} ${output_dir} ${input_dir}" >> $scrp/${align_job}.sh
  chmod +x $scrp/${align_job}.sh
  qsub -V -l h_vmem=32g -N ${align_job} -e $logd -o $logd $scrp/${align_job}.sh

  generate_results_job="job_02_${name}_generate_results"
  echo '#!/bin/sh' > $scrp/${generate_results_job}.sh
  echo "`pwd`/bash/02_generate_results.sh ${output_prefix} ${output_dir} ${input_dir} ${ref_fasta}" >> $scrp/${generate_results_job}.sh
  chmod +x $scrp/${generate_results_job}.sh
  qsub -V -l h_vmem=32g -hold_jid ${align_job} -N ${generate_results_job} -e $logd -o $logd $scrp/${generate_results_job}.sh

  predict_hla_job="job_03_${name}_predict_hla"
  echo '#!/bin/sh' > $scrp/${predict_hla_job}.sh
  echo "`pwd`/bash/03_predict_hla.sh ${output_prefix} ${output_dir}" >> $scrp/${predict_hla_job}.sh
  chmod +x $scrp/${predict_hla_job}.sh
  qsub -V -l h_vmem=32g -hold_jid ${generate_results_job} -N ${predict_hla_job} -e $logd -o $logd $scrp/${predict_hla_job}.sh

  call_hla_job="job_04_${name}_call_hla"
  echo '#!/bin/sh' > $scrp/${call_hla_job}.sh
  echo "`pwd`/bash/04_call_hla.sh ${output_prefix} ${output_dir} ${input_dir} ${ref_fasta}" >> $scrp/${call_hla_job}.sh
  chmod +x $scrp/${call_hla_job}.sh
  qsub -V -l h_vmem=32g -hold_jid ${predict_hla_job} -N ${call_hla_job} -e $logd -o $logd $scrp/${call_hla_job}.sh

done
