rule submit_vcf_to_mis:
    input:
        script = 'Scripts/submit_vcf_to_mis2.py',
        vcfgz = "Output/{project}/VCF/{filename}.hg19.chr6.20_to_40mb.encoded.vcf.gz",
        config = "pipeline.config.json"
    output:
        file = "Output/{project}/VCF/{filename}.hg19.chr6.20_to_40mb.encoded.vcf.gz.submission_results.csv"
    conda: "../Envs/python_env.yaml"
    shell:
        """
            python {input.script} \
            --InputVCF {input.vcfgz} \
            --ConfigFile {input.config} \
            --Output  {output.file}
        """