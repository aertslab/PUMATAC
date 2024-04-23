nextflow.enable.dsl=2

// binDir = !params.containsKey("test") ? "${workflow.projectDir}/src/template/bin/" : ""


process CREATE_FRAGMENTS_FROM_BAM {
    //container params.tools.barcard.container
    container "vibsinglecellnf/singlecelltoolkit:2024-04-09-62429e9"
    label 'compute_resources__barcard__create_fragments_from_bam'
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

        create_fragments_file --bam "${bam}" --fragments "${sampleId}.fragments.raw.tsv.gz"

        tabix -p bed "${sampleId}.fragments.raw.tsv.gz"
        """
}
