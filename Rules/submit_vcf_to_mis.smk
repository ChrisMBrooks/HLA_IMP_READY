rule submit_vcf_to_mis:
    input:
        script = 'Scripts/submit_vcf_to_mis2.py',
        vcfgz = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.ac.encoded.vcf.gz",
        config = "pipeline.config.json"
    output:
        file = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.ac.encoded.vcf.gz.submission_results.csv"
    conda: "../Envs/python_env.yaml"
    shell:
        """
            python {input.script} \
            --InputVCF {input.vcfgz} \
            --ConfigFile {input.config} \
            --Output  {output.file}
        """