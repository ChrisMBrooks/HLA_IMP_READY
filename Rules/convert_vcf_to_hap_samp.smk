rule convert_vcf_to_hap_samp:
    input:
        phased_vcfgz = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.dose.{partition_id}.vcf.gz",
        snps_reference = "Output/{project}/MetaData/hlaimp3.all.snps.txt"
    params:
        vcf_prefix = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.dose.{partition_id}",
        hap_samp_prefix = "Output/{project}/HLA_IMP_READY/{filename}.chr6.20_to_40mb.dose.{partition_id}"
    output:
        hap = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.dose.{partition_id}.hap.gz",
        samp = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.dose.{partition_id}.sample"
    conda: "../Envs/bcftools_env.yaml"
    shell:
        """
            bcftools view -p -T \
            {input.snps_reference} \
            {input.phased_vcfgz} \
            | bcftools convert --hapsample {params.vcf_prefix}
        """