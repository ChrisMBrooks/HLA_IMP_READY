rule get_imp_precheck_script:
    output:
        filename = "RefSoftware/HRC-1000G-check-bim-v4.3.0/HRC-1000G-check-bim.pl"
    params:
        zip_filename = "RefSoftware/HRC-1000G-check-bim-v4.3.0.zip",
        output_path = "RefSoftware/HRC-1000G-check-bim-v4.3.0",
        url = CONFIG['imp_precheck_script_url']
    shell:
        """
            curl -o {params.zip_filename} {params.url}
            unzip {params.zip_filename} -d {params.output_path}
        """