PUMATAC
==============
Pipeline for Universal Mapping of ATAC-seq

|PUMATAC| |ReadTheDocs| |Zenodo| |Gitter| |Nextflow| |Tutorial|

A detailed, step-by-step tutorial with examples is available [here](https://github.com/aertslab/PUMATAC_tutorial).

If PUMATAC is useful for your research, consider citing:

- PUMATAC All Versions (latest): `10.5281/zenodo.7764892 <https://doi.org/10.5281/zenodo.7764884>`_.

Currently, a preprocesing workflow is available, which will take fastq inputs, apply barcode correction, read trimming, bwa mapping, and output bam and fragments files for further downstream analysis.
See `here <https://vsn-pipelines.readthedocs.io/en/latest/scatac-seq.html>`_ for complete documentation.

.. |VSN-Pipelines| image:: https://img.shields.io/github/v/release/vib-singlecell-nf/vsn-pipelines
    :target: https://github.com/vib-singlecell-nf/vsn-pipelines/releases
    :alt: GitHub release (latest by date)

.. |Tutorial| image:: https://img.shields.io/github/v/release/vib-singlecell-nf/vsn-pipelines
    :target: https://github.com/aertslab/PUMATAC_tutorial
    :alt: Tutorial
    
.. |PUMATAC| image:: https://img.shields.io/github/v/release/vib-singlecell-nf/vsn-pipelines
    :target: https://github.com/aertslab/ATACflow/releases
    :alt: GitHub release (latest by date)

.. |ReadTheDocs| image:: https://readthedocs.org/projects/vsn-pipelines/badge/?version=latest
    :target: https://vsn-pipelines.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation Status

.. |Nextflow| image:: https://img.shields.io/badge/nextflow-21.04.3-brightgreen.svg
    :target: https://www.nextflow.io/
    :alt: Nextflow

.. |Gitter| image:: https://badges.gitter.im/vib-singlecell-nf/community.svg
    :target: https://gitter.im/vib-singlecell-nf/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge
    :alt: Gitter

.. |Zenodo| image:: https://zenodo.org/badge/199477571.svg
    :target: https://doi.org/10.5281/zenodo.7764884
    :alt: Zenodo
