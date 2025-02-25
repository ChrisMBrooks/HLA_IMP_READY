rule get_imp_precheck_ref_data:
    output:
        filename = "RefData/1000GP_Phase3_combined.legend"
    params:
        zip_filename = "RefData/1000GP_Phase3_combined.legend.gz",
        url = CONFIG['imp_precheck_ref_data_url']
    shell:
        """
            curl -o {params.zip_filename} {params.url}
            gunzip {params.zip_filename}
        """