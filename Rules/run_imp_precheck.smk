rule run_imp_precheck:
    input:
        script = "RefSoftware/HRC-1000G-check-bim-v4.3.0/HRC-1000G-check-bim.pl",
        legend = "RefData/1000GP_Phase3_combined.legend",
        bim = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb.bim",
        frq = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb.frq"
    params:
        script = "Output/{project}/PreImpQC/Run-plink.sh",
    output:
        exclude = "Output/{project}/PreImpQC/Exclude-{filename}.hg19.chr6.20_to_40mb-1000G.txt",
        chrom = "Output/{project}/PreImpQC/Chromosome-{filename}.hg19.chr6.20_to_40mb-1000G.txt",
        position = "Output/{project}/PreImpQC/Position-{filename}.hg19.chr6.20_to_40mb-1000G.txt",
        strand_flip = "Output/{project}/PreImpQC/Strand-Flip-{filename}.hg19.chr6.20_to_40mb-1000G.txt",
        force_allele = "Output/{project}/PreImpQC/Force-Allele1-{filename}.hg19.chr6.20_to_40mb-1000G.txt"
    conda: "../Envs/perl_env.yaml"
    shell:
        """
            perl {input.script} \
            -b {input.bim} \
            -f {input.frq} \
            -r {input.legend} \
            -g \
            -p ALL \
            -c 6
        """