import json, os, sys
def load_pipeline_config():
    try:
        full_path = os.path.join(os.getcwd(), "pipeline.config.json")
        f = open(full_path)
        config = json.load(f)
        return config
    except Exception as e:
        print('Failed to load pipeline config. Exiting...')
        sys.exit(1)

CONFIG = load_pipeline_config()
PROJECT = CONFIG["project"]
FULL_PATH_FILENAME = CONFIG["bed_bim_fam_filename"]
FILENAME = os.path.basename(CONFIG["bed_bim_fam_filename"])
NUM_PARTITIONS = int(CONFIG["num_data_partitions"])
PARTITION_IDS = range(1, NUM_PARTITIONS+1,1)
PHASING_RESULTS = CONFIG["phasing_results_loc"]

rule hla_imp_ready:
    input:
        hap_file = expand(
            "Output/{project}/HLA_IMP_READY/{filename}.chr6.20_to_40mb.dose.{partition_id}.hap.gz",
            project = PROJECT,
            filename = FILENAME,
            partition_id=PARTITION_IDS
        ),
        samp_file = expand(
            "Output/{project}/HLA_IMP_READY/{filename}.chr6.20_to_40mb.dose.{partition_id}.sample",
            project = PROJECT,
            filename = FILENAME,
            partition_id=PARTITION_IDS
        )

include: "Rules/LiftOver/conditional_lifover.smk"
include: "Rules/extract_hla_loci_convert_to_vcf.smk"
include: "Rules/compress_and_index_vcf.smk"
include: "Rules/submit_vcf_to_mis.smk"
include: "Rules/extract_list_of_sample_ids.smk"
include: "Rules/split_sample_ids_file.smk"
include: "Rules/partition_vcf_file.smk"
include: "Rules/get_snp_ref_panel.smk"
include: "Rules/convert_vcf_to_hap_samp.smk"
include: "Rules/move_hap.smk"
include: "Rules/move_samp.smk"

# snakemake --cores 8 --until "extract_list_of_sample_ids" --rerun-incomplete --use-conda
# snakemake --cores 8 --rerun-incomplete --use-conda

