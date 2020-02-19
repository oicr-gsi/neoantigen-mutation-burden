#!/bin/bash
export MODULEPATH=/.mounts/labs/resit/modulator/modulefiles/data:/.mounts/labs/resit/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/Debian8.11:/.mounts/labs/gsi/modulator/modulefiles/data

output_prefix=$1
output_dir=$2/${output_prefix}

echo "To extract alleles from the HAL-VBSeq result files"
report_file=${output_dir}/${output_prefix}_report.d4.txt
# also appending HLA to the file
cat ${report_file} | grep -E "^A|^B|^C" | awk '{for (i=2; i<=NF; i++) print $i}' | sort | uniq | tr -d "*" | sed 's/^/HLA-/' > ${output_dir}/${output_prefix}_HLA.txt


# parse the data mutations file for all novel mutations
name=`echo ${output_prefix} | cut -d_ -f1-2`
data_mutations=/.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/jtorchia_amino/cbioportal_import_data/data_mutations_extended.txt

# cat ${data_mutations} | grep ${name} | grep "Missense_Mutation" | cut -f5,6,7,9,11,12,14 > ${output_dir}/${output_prefix}.muts
cat ${data_mutations} | grep ${name} | grep -v "Silent" | cut -f5,6,7,9,11,12,14 > ${output_dir}/${output_prefix}.muts
# chr start type ref alt rsid

# check if we see any muts

if [[ -n ${output_dir}/${output_prefix}.muts ]]; then
  # script to run netMHCpan
  echo "running netMHCpan"
  export PERL5LIB=/.mounts/labs/PCSI/perl/lib/x86_64-linux-gnu/perl/5.20.2/:/.mounts/labs/PCSI/perl/share/perl/5.20.2:/.mounts/labs/PCSI/perl/lib/perl5/:/.mounts/labs/PCSI/perl/lib/perl5/x86_64-linux-gnu-thread-multi/
  export PATH=/oicr/local/analysis/sw/NetMHC/netMHCpan-2.8/:$PATH
  netMHCpan=/oicr/local/analysis/sw/NetMHC/netMHCpan-2.8/netMHCpan

  # read the HLA txt file to obtain the peptide map
  cat ${output_dir}/${output_prefix}.muts | /.mounts/labs/gsiprojects/external/zadehglab/MPNST/data/TGL20/EXOME/Neo-antigens/neo-antigen/vcfToPeptide.pl > ${output_dir}/${output_prefix}.peptideMap
  # get peptides from peptide map
  cut -f 5 ${output_dir}/${output_prefix}.peptideMap | sort | uniq > ${output_dir}/${output_prefix}.peptides
  for hla in `cat ${output_dir}/${output_prefix}_HLA.txt`; do
    ${netMHCpan} -a $hla -p ${output_dir}/${output_prefix}.peptides | tail -n +38 > ${output_dir}/${output_prefix}.${hla}.netMHC.txt
  done


  # shuffle out accuracy
  for x in `ls ${output_dir}/${output_prefix}.*.netMHC.txt`; do cat $x | tail -n +5 | head -1; done > ${output_dir}/${output_prefix}.combined.netMHC.accuracy.txt
  # shuffle out high binders summary
  echo "#sample_id,Allele,high_binders,weak_binders,peptides" >  ${output_dir}/${output_prefix}.combined.netMHC.binders.txt
  for entry in  `cat ${output_dir}/${output_prefix}.*.netMHC.txt | grep "binders" | cut -d\. -f2,3,4,5 | tr " " "," | cut -d, -f3,8,13,17 | tr -d "."`; do
    echo ${output_prefix},$entry >> ${output_dir}/${output_prefix}.combined.netMHC.binders.txt
  done
  cat ${output_dir}/${output_prefix}.combined.netMHC.binders.txt | tr "," "\t" > tmp; mv tmp ${output_dir}/${output_prefix}.combined.netMHC.binders.txt
else
  echo "no muts in ${output_prefix}"
fi
