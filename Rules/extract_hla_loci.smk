rule extract_hla_loci:
    input:
        bim = "Output/{project}/LiftOver/Results/{filename}.hg19.bim",
        bed = "Output/{project}/LiftOver/Results/{filename}.hg19.bed",
        fam = "Output/{project}/LiftOver/Results/{filename}.hg19.fam"
    params:
        input_prefix = "Output/{project}/LiftOver/Results/{filename}.hg19",
        output_prefix = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb"
    output:
        bim = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb.bim",
        bed = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb.bed",
        fam = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb.fam"
    conda: "../Envs/plink_env.yaml"
    shell:
        """
            plink \
            --bfile {params.input_prefix} \
            --chr 6 \
            --from-mb 20 \
            --to-mb 40 \
            --make-bed \
            --out {params.output_prefix} \
            --snps-only just-acgt
        """