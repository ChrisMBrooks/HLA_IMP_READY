rule calc_bed_frequencies:
    input:
        bim = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb.bim",
        bed = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb.bed",
        fam = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb.fam"
    params:
        prefix = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb"
    output:
        frq = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb.frq"
    conda: "../Envs/plink_env.yaml"
    shell:
        """
            plink \
            --bfile {params.prefix} \
            --freq \
            --out {params.prefix}
        """