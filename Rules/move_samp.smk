rule move_samp:
    input:
        sample = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.dose.{partition_id}.sample"
    output:
        sample = "Output/{project}/HLA_IMP_READY/{filename}.chr6.20_to_40mb.dose.{partition_id}.sample"
    shell:
        """
            mv {input.sample} {output.sample}
        """