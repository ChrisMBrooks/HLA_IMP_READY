rule extract_list_of_sample_ids:
    input:
        mis_sub_results = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.ac.encoded.vcf.gz.submission_results.csv",
        vcfgz = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.ac.encoded.vcf.gz"
    params:
        phased_vcf = "{phase_results_filename}".format(phase_results_filename=PHASING_RESULTS)
    output:
        sample_ids = "Output/{project}/MetaData/{filename}.sample_ids.txt"
    conda: "../Envs/bcftools_env.yaml"
    shell:
        """
            bcftools query -l {params.phased_vcf} > {output.sample_ids}
        """