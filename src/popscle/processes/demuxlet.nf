nextflow.enable.dsl=2

binDir = !params.containsKey("test") ? "${workflow.projectDir}/src/popscle/bin/" : ""

process SC__POPSCLE__DEMUXLET {

    container params.tools.popscle.container
    publishDir "${params.global.outdir}/data/demuxlet", mode: params.utils.publish.mode
    label 'compute_resources__cpu'

    input:
        tuple val(sampleId), path(f)
        file vcf

    output:
        tuple val(sampleId), path("${sampleId}_demuxlet*")

    script:
        def sampleParams = params.parseConfig(sampleId, params.global, params.tools.popscle.demuxlet)
		processParams = sampleParams.local

        """
        popscle demuxlet \
            --vcf ${vcf} \
            ${(processParams.containsKey('field')) ? '--field ' + processParams.field : ''} \
            --plp ${sampleId}_dsc-pileup \
            --out ${sampleId}_demuxlet
        """
}

process SC__POPSCLE__FREEMUXLET {

    container params.tools.popscle.container
    publishDir "${params.global.outdir}/data/freemuxlet", mode: params.utils.publish.mode
    label 'compute_resources__cpu'

    input:
        tuple val(sampleId), path(f)

    output:
        tuple val(sampleId), path("${sampleId}_freemuxlet*")

    script:
        def sampleParams = params.parseConfig(sampleId, params.global, params.tools.popscle.freemuxlet)
		processParams = sampleParams.local

        """
        popscle freemuxlet \
            --nsample ${processParams.nSamples} \
            --plp ${sampleId}_dsc-pileup \
            --out ${sampleId}_freemuxlet
        """
}
