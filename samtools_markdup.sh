
samtools markdup \
    -@ 4 \
    -d 100 \
    -s \
    -f HAR_ddseq_2_____R1.bwa.out.fixmate.chr22.sorted.markdup_opdist100.stats.tsv \
    -m t \
    --no-multi-dup \
    --barcode-tag CB \
    -t \
    HAR_ddseq_2_____R1.bwa.out.fixmate.chr22.sorted.bam \
    HAR_ddseq_2_____R1.bwa.out.fixmate.chr22.sorted.markdup_opdist100.bam


samtools view -a 30

s view --expr 'mapq >= 30 && flag.proper_pair && ! flag.dup && refid == mrefid && [CB] &&  ( (tlen >= 10 && tlen <= 5000) || (tlen <= -10 && tlen >= -5000))'



./samtools view -h /media/data/stg_00002/lcb/fderop/data/hca_atac_benchmark/2_vsn_preprocessing/work/7e/a759b4d675625c61548227b41666c9/BIO_ddseq_1_____R1.bwa.out.fixmate.bam | head -n 1000|  ./samtools view --expr 'flag.proper_pair && ! flag.dup && mapq >= 30 && [MQ] >= 30 && refid == mrefid && [CB] &&  ( (tlen >= 10 && tlen <= 5000) || (tlen <= -10 && tlen >= -5000))'|wc -l


./samtools view -h /media/data/stg_00002/lcb/fderop/data/hca_atac_benchmark/2_vsn_preprocessing/work/7e/a759b4d675625c61548227b41666c9/BIO_ddseq_1_____R1.bwa.out.fixmate.bam | head -n 1000|

./samtools view --expr 'flag.proper_pair && ! flag.dup && mapq >= 30 && [MQ] >= 30 && refid == mrefid && [CB] && rname~"^(chr|)([0-9]{1,2}|[XY]|[23][LR])$"'|wc -l

./samtools view --expr 'flag.proper_pair && ! flag.dup && mapq >= 30 && [MQ] >= 30 && refid == mrefid && [CB] && rname =~ "^(chr|)([0-9]{1,2}|[XY]|[23][LR])$"'


./samtools view --keep-tag CB --expr 'flag.proper_pair && ! flag.dup && mapq >= 30 && [MQ] >= 30 && refid == mrefid && [CB] && tlen >= 1 && rname =~ "^(chr|)([0-9]{1,2}|[XY]|[23][LR])$"' /media/data/stg_00002/lcb/fderop/data/hca_atac_benchmark/2_vsn_preprocessing/work/6f/52a01802d850ec43b334ddbc581fa3/CNA_10xv11_3_____R1.bwa.out.fixmate.bam | mawk -F '\t' -v OFS='\t' '{ print $3, $4 - 1 + 4, $4 + $9 - 5, substr($12, 6) }' |head

./samtools view -@ 4 --keep-tag CB --expr 'flag.proper_pair && ! flag.dup && refid == mrefid && mapq >= 30 && [MQ] >= 30 && [CB] && tlen >= 10 && rname =~ "^(chr|)([0-9]{1,2}|[XY]|[23][LR])$"' /media/data/stg_00002/lcb/fderop/data/hca_atac_benchmark/2_vsn_preprocessing/work/6f/52a01802d850ec43b334ddbc581fa3/CNA_10xv11_3_____R1.bwa.out.fixmate.bam | mawk -F '\t' -v OFS='\t' '{ print $3, $4 - 1 + 4, $4 - 1 + $9 - 5, substr($12, 6) }' |head

sort -k 1,1V -k 2,2n -k 3,3n -k 4,4 $GHULS/t2 | uniq -c | mawk -v 'OFS=\t' '{ print $2, $3, $4, $5, $1 }' > $GHULS/t3


./samtools view \
    -@ 4 \
    --keep-tag CB \
    --expr 'flag.proper_pair && ! flag.dup && refid == mrefid && mapq >= 30 && [MQ] >= 30 && [CB] && tlen >= 10 && rname =~ "^(chr|)([0-9]{1,2}|[XY]|[23][LR])$"' \
    /media/data/stg_00002/lcb/fderop/data/hca_atac_benchmark/2_vsn_preprocessing/work/6f/52a01802d850ec43b334ddbc581fa3/CNA_10xv11_3_____R1.bwa.out.fixmate.bam \
  | mawk \
    -F '\t' \
    -v OFS='\t' \
    '{ print $3, $4 - 1 + 4, $4 - 1 + $9 - 5, substr($12, 6) }' \
  | LC_ALL='C' sort -k 1,1V -k 2,2n -k 3,3n -k 4,4 \
  | uniq -c \
  | mawk -v 'OFS=\t' '{ print $2, $3, $4, $5, $1 }' \
  | bgzip \
  > $GHULS/tmp/t6.bed

# Create fragments file.

create_fragments_file () {
    bam_filename="${1}";
    fragments_bed_filename="${2}";
    # "^(chr|)([0-9]{1,2}|[MXY]|MT|[23][LR])$"
    chrom_regex="${3:-^(chr|)([0-9]{1,2\}|[MXY]|MT|[23][LR])\$}"

    /staging/leuven/stg_00002/lcb/ghuls/software/samtools/samtools view \
        -@ 4 \
        --keep-tag CB \
        --expr 'flag.proper_pair && ! flag.dup && refid == mrefid && mapq >= 30 && [MQ] >= 30 && [CB] && tlen >= 10 && rname =~ "'"${chrom_regex}"'"' \
        "${bam_filename}" \
      | mawk \
        -F '\t' \
        -v OFS='\t' \
        '{ print $3, $4 - 1 + 4, $4 - 1 + $9 - 5, substr($12, 6) }' \
      | LC_ALL='C' sort --parallel=8 -S 16G -k 1,1V -k 2,2n -k 3,3n -k 4,4 \
      | uniq -c \
      | mawk -v 'OFS=\t' '{ print $2, $3, $4, $5, $1 }' \
      > "${fragments_bed_filename}"
}


create_fragments_file () {
    bam_filename="${1}";
    fragments_bed_filename="${2}";
    # "^(chr|)([0-9]{1,2}|[MXY]|MT|[23][LR])$"
    chrom_regex="${3:-^(chr|)([0-9]{1,2\}|[MXY]|MT|[23][LR])\$}"

    /staging/leuven/stg_00002/lcb/ghuls/software/single_cell_toolkit_rust/target/release/create_fragments_file \
        "${bam_filename}" \
        "${fragments_bed_filename}"_unused \
      | LC_ALL='C' sort --parallel=4 -S 1G -k 1,1V -k 2,2n -k 3,3n -k 4,4 \
      | uniq -c \
      | mawk -v 'OFS=\t' '{ print $2, $3, $4, $5, $1 }' \
      > "${fragments_bed_filename}"
}


create_fragments_file () {
    bam_filename="${1}";
    fragments_bed_filename="${2}";
    # "^(chr|)([0-9]{1,2}|[MXY]|MT|[23][LR])$"
    chrom_regex="${3:-^(chr|)([0-9]{1,2\}|[MXY]|MT|[23][LR])\$}"

    /staging/leuven/stg_00002/lcb/ghuls/software/single_cell_toolkit_rust/target/release/create_fragments_file \
        "${bam_filename}" \
        "${fragments_bed_filename}"_unused \
      | /staging/leuven/stg_00002/lcb/ghuls/software/coreutils/target/release/coreutils sort --parallel=8 -S 16G -k 1,1V -k 2,2n -k 3,3n -k 4,4 \
      | uniq -c \
      | mawk -v 'OFS=\t' '{ print $2, $3, $4, $5, $1 }' \
      > "${fragments_bed_filename}"
}

create_fragments_file () {
    bam_filename="${1}";
    fragments_bed_filename="${2}";
    # "^(chr|)([0-9]{1,2}|[MXY]|MT|[23][LR])$"
    chrom_regex="${3:-^(chr|)([0-9]{1,2\}|[MXY]|MT|[23][LR])\$}"

    /staging/leuven/stg_00002/lcb/ghuls/software/single_cell_toolkit_rust/target/release/create_fragments_file \
        "${bam_filename}" \
        "${fragments_bed_filename}"_unused \
      | /staging/leuven/stg_00002/lcb/ghuls/software/coreutils/target/release/coreutils sort --parallel=8 -S 16G -k 1,1V -k 2,2n -k 3,3n -k 4,4 \
      | uniq -c \
      | mawk -v 'OFS=\t' '{ print $2, $3, $4, $5, $1 }' \
      | /staging/leuven/stg_00002/lcb/ghuls/software/htslib/bgzip -@ 4 -c -i -I "${fragments_bed_filename%.gz}.gz.gzi" /dev/stdin \
      > "${fragments_bed_filename%.gz}.gz"
}

create_fragments_file () {
    bam_filename="${1}";
    fragments_bed_filename="${2}";
    # "^(chr|)([0-9]{1,2}|[MXY]|MT|[23][LR])$"
    chrom_regex="${3:-^(chr|)([0-9]{1,2\}|[MXY]|MT|[23][LR])\$}"

    /staging/leuven/stg_00002/lcb/ghuls/software/single_cell_toolkit_rust/target/release/create_fragments_file \
        "${bam_filename}" \
        "${fragments_bed_filename}"_unused \
      | /staging/leuven/stg_00002/lcb/ghuls/software/coreutils/target/release/coreutils sort --parallel=8 -S 16G -k 1,1V -k 2,2n -k 3,3n -k 4,4 \
      | uniq -c \
      | mawk -v 'OFS=\t' '{ print $2, $3, $4, $5, $1 }' \
      | /staging/leuven/stg_00002/lcb/ghuls/software/htslib/bgzip -@ 4 -c -i -I "${fragments_bed_filename%.gz}.gz.gzi" /dev/stdin \
      > "${fragments_bed_filename%.gz}.gz"
}


time target/release/create_fragments_file /media/data/stg_00002/lcb/fderop/data/hca_atac_benchmark/2_vsn_preprocessing/work/6f/52a01802d850ec43b334ddbc581fa3/CNA_10xv11_3_____R1.bwa.out.fixmate.bam f | /staging/leuven/stg_00002/lcb/ghuls/software/coreutils/target/release/coreutils sort -S 4G --parallel=8 -k 1,1V -k 2,2n -k 3,3n -k 4,4 | uniq -c | mawk -v 'OFS=\t' '{ print $2, $3, $4, $5, $1 }' > $GHULS/tmp/t17.bed

MACS3 callpeaks BEDPE



n
