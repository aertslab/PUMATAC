PUMATAC
==============

A repository of pipelines for single-cell data analysis in Nextflow DSL2.

|PUMATAC| |ReadTheDocs| |Zenodo| |Gitter| |Nextflow|



If PUMATAC is useful for your research, consider citing:

- PUMATAC All Versions (latest): `10.5281/zenodo.7764892 <https://zenodo.org/record/7764892>`_.


Single cell ATAC-seq processing steps are now included in VSN Pipelines.
Currently, a preprocesing workflow is available, which will take fastq inputs, apply barcode correction, read trimming, bwa mapping, and output bam and fragments files for further downstream analysis.
See `here <https://vsn-pipelines.readthedocs.io/en/latest/scatac-seq.html>`_ for complete documentation.


Full tutorial under construction.


.. |VSN-Pipelines| image:: https://img.shields.io/github/v/release/vib-singlecell-nf/vsn-pipelines
    :target: https://github.com/vib-singlecell-nf/vsn-pipelines/releases
    :alt: GitHub release (latest by date)
    
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
    :target: https://zenodo.org/badge/latestdoi/199477571
    :alt: Zenodo

.. _VIB-Singlecell-NF: https://github.com/vib-singlecell-nf
.. _pySCENIC: https://github.com/aertslab/pySCENIC
.. _SCENIC: https://aertslab.org/#scenic
.. _loom: http://loompy.org/
.. _SCope: http://scope.aertslab.org/

.. |single_sample| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/single_sample/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#single-sample-single-sample
    :alt: Single-sample Pipeline

.. |single_sample_scenic| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/single_sample_scenic/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#single-sample-scenic-single-sample-scenic
    :alt: Single-sample SCENIC Pipeline

.. |scenic| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/scenic/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#scenic-scenic
    :alt: SCENIC Pipeline

.. |scenic_multiruns| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/scenic_multiruns/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#scenic-multiruns-scenic-multiruns-single-sample-scenic-multiruns
    :alt: SCENIC Multi-runs Pipeline

.. |single_sample_scenic_multiruns| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/single_sample_scenic_multiruns/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#scenic-multiruns-scenic-multiruns-single-sample-scenic-multiruns
    :alt: Single-sample SCENIC Multi-runs Pipeline

.. |single_sample_scrublet| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/single_sample_scrublet/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#single-sample-scrublet-single-sample-scrublet
    :alt: Single-sample Scrublet Pipeline

.. |decontx| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/decontx/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#decontx-decontx
    :alt: DecontX Pipeline

.. |single_sample_decontx| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/single_sample_decontx/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#single-sample-decontx-single-sample-decontx
    :alt: Single-sample DecontX Pipeline

.. |single_sample_decontx_scrublet| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/single_sample_decontx_scrublet/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#single-sample-decontx-scrublet-single-sample-decontx-scrublet
    :alt: Single-sample DecontX Scrublet Pipeline

.. |bbknn| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/bbknn/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#bbknn-bbknn
    :alt: BBKNN Pipeline

.. |bbknn_scenic| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/bbknn_scenic/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#bbknn-scenic
    :alt: BBKNN SCENIC Pipeline

.. |harmony| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/harmony/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#harmony-harmony
    :alt: Harmony Pipeline

.. |harmony_scenic| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/harmony_scenic/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#harmony-scenic
    :alt: Harmony SCENIC Pipeline

.. |mnncorrect| image:: https://github.com/vib-singlecell-nf/vsn-pipelines/workflows/mnncorrect/badge.svg
    :target: https://vsn-pipelines.readthedocs.io/en/latest/pipelines.html#mnncorrect-mnncorrect
    :alt: MNN-correct Pipeline

