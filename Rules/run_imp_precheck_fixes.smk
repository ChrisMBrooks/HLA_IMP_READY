rule run_imp_precheck_fixes:
    input:
        bfile = "Output/{project}/PreImpQC/LabExMI_HLA_locus.hg19.chr6.20_to_40mb.bed",
        exclude = "Output/{project}/PreImpQC/Exclude-{filename}.hg19.chr6.20_to_40mb-1000G.txt",
        chrom = "Output/{project}/PreImpQC/Chromosome-{filename}.hg19.chr6.20_to_40mb-1000G.txt",
        position = "Output/{project}/PreImpQC/Position-{filename}.hg19.chr6.20_to_40mb-1000G.txt",
        strand_flip = "Output/{project}/PreImpQC/Strand-Flip-{filename}.hg19.chr6.20_to_40mb-1000G.txt",
        force_allele = "Output/{project}/PreImpQC/Force-Allele1-{filename}.hg19.chr6.20_to_40mb-1000G.txt"
    params:
        output_dir = "Output/{project}/PreImpQC",
        bfile_prefix = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb",
        interim_vcf = "Output/{project}/PreImpQC/{filename}.hg19.chr6.20_to_40mb-updated-chr6.vcf",
    output:
        vcfgz = "Output/{project}/VCF/{filename}.hg19.chr6.20_to_40mb.encoded.vcf.gz"
    conda: "../Envs/plink_env.yaml"
    shell:
        """
            plink --bfile {params.bfile_prefix} --exclude {input.exclude} --make-bed --out {params.output_dir}/TEMP1
            plink --bfile {params.output_dir}/TEMP1 --update-map {input.chrom} --update-chr --make-bed --out {params.output_dir}/TEMP2
            plink --bfile {params.output_dir}/TEMP2 --update-map {input.position} --make-bed --out {params.output_dir}/TEMP3
            plink --bfile {params.output_dir}/TEMP3 --flip {input.strand_flip} --make-bed --out {params.output_dir}/TEMP4
            plink --bfile {params.output_dir}/TEMP4 --a2-allele {input.force_allele} --make-bed --out {params.bfile_prefix}-updated
            plink --bfile {params.bfile_prefix}-updated --real-ref-alleles --recode vcf --chr 6 --out {params.bfile_prefix}-updated-chr6
            bgzip -c {params.interim_vcf} > {output.vcfgz}
        """