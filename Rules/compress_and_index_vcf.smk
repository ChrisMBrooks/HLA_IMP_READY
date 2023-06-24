rule compress_and_index_vcf:
    input:
        vcf = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.vcf"
    output:
        vcfgz = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.vcf.gz",
        index = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.vcf.gz.tbi"
    conda: "../Envs/htslib_env.yaml"
    shell:
        """
            bgzip -c {input.vcf} > {output.vcfgz}
            tabix -p vcf {output.vcfgz}
        """