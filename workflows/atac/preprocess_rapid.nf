nextflow.enable.dsl=2

// process imports
include {
    SCTK__EXTRACT_HYDROP_ATAC_BARCODE as SCTK__EXTRACT_HYDROP_ATAC_BARCODE_v0;
    SCTK__EXTRACT_HYDROP_ATAC_BARCODE as SCTK__EXTRACT_HYDROP_ATAC_BARCODE_v1;
    SCTK__EXTRACT_HYDROP_ATAC_BARCODE as SCTK__EXTRACT_HYDROP_ATAC_BARCODE_v2;
} from './../../src/singlecelltoolkit/processes/extract_hydrop_atac_barcode.nf'
include {
    TRIMGALORE__TRIM;
} from './../../src/trimgalore/processes/trim.nf'

include {
    SIMPLE_PUBLISH as PUBLISH_FASTQS_TRIMLOG_PE1;
    SIMPLE_PUBLISH as PUBLISH_FASTQS_TRIMLOG_PE2;
    SIMPLE_PUBLISH as PUBLISH_FASTQS_TRIMLOG_FASTP;
    SIMPLE_PUBLISH as PUBLISH_FRAGMENTS;
    SIMPLE_PUBLISH as PUBLISH_FRAGMENTS_INDEX;
    SIMPLE_PUBLISH as PUBLISH_BAM;
    SIMPLE_PUBLISH as PUBLISH_BAM_INDEX;
    SIMPLE_PUBLISH as PUBLISH_MAPPING_SUMMARY;
} from '../../src/utils/processes/utils.nf'

// workflow imports:
include {
    BWA_MAPPING_PE;
} from './../../src/bwamaptools/main.nf'
include {
    SAMTOOLS__MERGE_BAM;
} from './../../src/samtools/processes/merge_bam.nf'
include {
    BAM_TO_FRAGMENTS;
    DETECT_BARCODE_MULTIPLETS;
} from './../../src/barcard/main.nf'
//} from './../../src/sinto/main.nf'


include {
    barcode_correction as bc_correct_standard;
    barcode_correction as bc_correct_hydrop_v0;
    barcode_correction as bc_correct_hydrop_v1;
    barcode_correction as bc_correct_hydrop_v2;
    biorad_bc as bc_correct_biorad;
} from './../../src/singlecelltoolkit/main.nf'

// include mapping stats
include {
    BWAMAPTOOLS__MAPPING_SUMMARY as MAPPING_SUMMARY;
} from './../../src/bwamaptools/processes/mapping_summary.nf' params(params)

//////////////////////////////////////////////////////
//  Define the workflow

workflow ATAC_PREPROCESS_RAPID {

    take:
        metadata

    main:

        // import metadata
        data = Channel.from(metadata)
                      .splitCsv(
                          header:true,
                          sep: '\t'
                          )
                      .map {
                          row -> tuple(
                              row.sample_name + "___" + file(row.fastq_PE1_path)
                                  .getSimpleName()
                                  .replaceAll(row.sample_name,""),
                              row.technology,
                              file(row.fastq_PE1_path, checkIfExists: true),
                              row.fastq_barcode_path,
                              file(row.fastq_PE2_path, checkIfExists: true)
                              )
                      }
                      .branch {
                        biorad:       it[1] == 'biorad'
                        hydrop_v0:    it[1] == 'hydrop_v0'
                        hydrop_v1:    it[1] == 'hydrop_v1'
                        hydrop_v2:    it[1] == 'hydrop_v2'
                        standard:     true // capture all other technology types here
                      }

        /* standard data
           barcode correction */
        bc_correct_standard(data.standard)

        /* HyDrop ATAC
           extract barcode and correct */
        // HyDrop v0
        SCTK__EXTRACT_HYDROP_ATAC_BARCODE_v0(data.hydrop_v0, 'v0') \
            | bc_correct_hydrop_v0
        // HyDrop v1
        SCTK__EXTRACT_HYDROP_ATAC_BARCODE_v1(data.hydrop_v1, 'v1') \
            | bc_correct_hydrop_v1
        // HyDrop v2
        SCTK__EXTRACT_HYDROP_ATAC_BARCODE_v2(data.hydrop_v2, 'v2') \
            | bc_correct_hydrop_v2

        /* BioRad data
           extract barcode and correct */
        bc_correct_biorad(data.biorad)

        /* downstream steps */
        bc_correct_standard.out
            .mix(bc_correct_hydrop_v0.out)
            .mix(bc_correct_hydrop_v1.out)
            .mix(bc_correct_hydrop_v2.out)
            .mix(bc_correct_biorad.out) \
            | adapter_trimming \
            | mapping

    emit:
        // emit in a format compatible with getDataChannel output:
        bam = mapping.out.bam.map { it -> tuple(it[0], [it[1], it[2]], 'bam') }
        fragments = mapping.out.fragments.map { it -> tuple(it[0], [it[1], it[2]], 'fragments') }
}


/* sub-workflows used above */

workflow adapter_trimming {

    take:
        fastq_dex

    main:

        // run adapter trimming:
        switch(params.atac_preprocess_tools.adapter_trimming_method) {
            case 'Trim_Galore':
                fastq_dex_trim = TRIMGALORE__TRIM(fastq_dex);
                PUBLISH_FASTQS_TRIMLOG_PE1(fastq_dex_trim.map{ it -> tuple(it[0], it[3]) }, '.R1.trimming_report.txt', 'reports/trim');
                PUBLISH_FASTQS_TRIMLOG_PE2(fastq_dex_trim.map{ it -> tuple(it[0], it[4]) }, '.R2.trimming_report.txt', 'reports/trim');
                break;
        }

    emit:
        fastq_dex_trim

}


workflow mapping {

    take:
        fastq_dex_trim

    main:

        // map with bwa mem:
        aligned_bam = BWA_MAPPING_PE(
            fastq_dex_trim.map { it -> tuple(it[0].split("___")[0], // [val(unique_sampleId),
                                             *it[0..2] ) // val(sampleId), path(fastq_PE1), path(fastq_PE2)]
                  })

        // split by sample size:
        aligned_bam.map{ it -> tuple(it[0].split("___")[0], it[1]) } // [ sampleId, bam ]
                   .groupTuple()
                   .branch {
                       to_merge: it[1].size() > 1
                       no_merge: it[1].size() == 1
                   }
                   .set { aligned_bam_size_split }

        // merge samples with multiple files:
        bam_merged = SAMTOOLS__MERGE_BAM(aligned_bam_size_split.to_merge)

        // re-combine with single files:
        bam_merged.mix(aligned_bam_size_split.no_merge.map { it -> tuple(it[0], *it[1]) })
           .set { bam }

        // publish merged BAM files or only BAM file per sample:
        PUBLISH_BAM(bam.map{ it -> tuple(it[0..1]) }, '.bwa.out.possorted.bam', 'bam')
        PUBLISH_BAM_INDEX(bam.map{ it -> tuple(it[0], it[1] + '.bai') }, '.bwa.out.possorted.bam.bai', 'bam')

        // publish mapping stats
        MAPPING_SUMMARY(bam.map( it -> tuple(it[0], it[1], it[1] + '.bai')))
        PUBLISH_MAPPING_SUMMARY(MAPPING_SUMMARY.out, '.mapping_stats.tsv', 'reports/mapping_stats')

        // generate a fragments file:
        fragments = BAM_TO_FRAGMENTS(bam)

        DETECT_BARCODE_MULTIPLETS(fragments)

        // publish fragments output:
        PUBLISH_FRAGMENTS(fragments.map{ it -> tuple(it[0..1]) }, '.fragments.tsv.gz', 'fragments')
        PUBLISH_FRAGMENTS_INDEX(fragments.map{ it -> tuple(it[0],it[2]) }, '.fragments.tsv.gz.tbi', 'fragments')

    emit:
        bam
        fragments

}
