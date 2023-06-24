rule extract_list_of_sample_ids:
    input:
        vcfgz = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.vcf.gz",
        phased_vcf = "{phase_results_filename}".format(phase_results_filename=PHASING_RESULTS)
    output:
        sample_ids = "Output/{project}/MetaData/{filename}.sample_ids.txt"
    conda: "../Envs/bcftools_env.yaml"
    shell:
        """
            bcftools query -l {input.phased_vcf} > {output.sample_ids}
        """