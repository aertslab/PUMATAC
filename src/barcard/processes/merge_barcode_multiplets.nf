nextflow.enable.dsl=2

// binDir = !params.containsKey("test") ? "${workflow.projectDir}/src/template/bin/" : ""


process MERGE_BARCODE_MULTIPLETS {
    //container params.tools.barcard.container
    container "vibsinglecellnf/singlecelltoolkit:2022-07-07-0638c1d"
    label 'compute_resources__barcard__merge_barcode_multiplets'
    publishDir "${params.global.outdir}/data/fragments", mode: 'copy'

    input:
        tuple val(sampleId),
              path(bam) //,
//              path(bai)

    output:
        tuple val(sampleId),
              path("${sampleId}.fragments.raw.tsv.gz"),
              path("${sampleId}.fragments.raw.tsv.gz.tbi")

    script:
        //def sampleParams = params.parseConfig(sampleId, params.global)
        //processParams = sampleParams.local
        """
        set -euo pipefail

        create_fragments_file \
            "${bam}" \
            _unused \
          | coreutils sort --parallel=8 -S 16G -k 1,1V -k 2,2n -k 3,3n -k 4,4 \
          | uniq -c \
          | mawk -v 'OFS=\t' '{ print \$2, \$3, \$4, \$5, \$1 }' \
          | bgzip -@ 4 -c /dev/stdin \
          > ${sampleId}.fragments.raw.tsv.gz

        tabix -p bed ${sampleId}.fragments.raw.tsv.gz
        """
}



nextflow.enable.dsl=2

// binDir = !params.containsKey("test") ? "${workflow.projectDir}/src/template/bin/" : ""
