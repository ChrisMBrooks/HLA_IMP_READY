rule move_hap:
    input: 
        hap = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.dose.{partition_id}.hap.gz"
    params:
        un_zipped_hap = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.dose.{partition_id}.hap"
    output:
        hap = "Output/{project}/HLA_IMP_READY/{filename}.chr6.20_to_40mb.dose.{partition_id}.hap.gz"
    shell:
        """
            gunzip {input.hap}
            mv {params.un_zipped_hap} {output.hap}
        """