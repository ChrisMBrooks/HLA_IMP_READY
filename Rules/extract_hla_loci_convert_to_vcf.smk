rule extract_hla_loci_convert_to_vcf:
    input:
        bim = "Output/{project}/LiftOver/Results/{filename}.hg19.bim",
        bed = "Output/{project}/LiftOver/Results/{filename}.hg19.bed",
        fam = "Output/{project}/LiftOver/Results/{filename}.hg19.fam"
    params:
        filename = FULL_PATH_FILENAME,
        output_prefix = "Output/{project}/VCF/{filename}.chr6.20_to_40mb"
    output:
        result = "Output/{project}/VCF/{filename}.chr6.20_to_40mb.vcf"
    conda: "../Envs/plink_env.yaml"
    shell:
        """
            plink --bfile {params.filename} --chr 6 --from-mb 20 --to-mb 40 --recode vcf --out {params.output_prefix}
        """