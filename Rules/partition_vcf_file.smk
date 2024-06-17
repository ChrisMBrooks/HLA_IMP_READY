rule partition_vcf_file:
    input:
        split_id_file = "Output/{project}/MetaData/SamplePartitions/{filename}.sample_ids.{partition_id}.txt"
    params:
        phased_vcfgz = "{phase_results_filename}".format(phase_results_filename=PHASING_RESULTS)
    output:
        subset_filename = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.dose.{partition_id}.vcf.gz"
    conda: "../Envs/bcftools_env.yaml"
    shell:
        """
            bcftools view -S {input.split_id_file} -Oz -o {output.subset_filename} {params.phased_vcfgz}
        """