nextflow.enable.dsl=2

// binDir = !params.containsKey("test") ? "${workflow.projectDir}/src/template/bin/" : ""


process SAMTOOLS__SORT_BAM {
    label 'compute_resources__samtools__sort_bam'

    input:
        tuple val(sampleId),
              path(bam)

    output:
        tuple val(sampleId),
              path("${sampleId}.bwa.out.fixmate.possorted.bam"),
              path("${sampleId}.bwa.out.fixmate.possorted.bai")

    script:
        def sampleParams = params.parseConfig(sampleId, params.global)
        processParams = sampleParams.local
        """
        set -euo pipefail
        samtools sort \
            -o ${sampleID}.bwa.out.fixmate.possorted.bam
            -@ 4 \
            ${bam}
        samtools index \
            -@ 4 \
            ${bam}
        """
}
