rule get_snp_ref_panel:
    output:
        file = "Output/RefData/hlaimp3.all.snps.txt"
    params:
        url = CONFIG['snp_ref_panel_url']
    shell:
        """
            curl {params.url} > {output.file}
        """