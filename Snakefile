# snakemake --cores 8 --use-conda --conda-frontend conda --rerun-incomplete --until "extract_list_of_sample_ids"
# snakemake --cores 8 --use-conda --conda-frontend conda --rerun-incomplete

#--printshellcmds

# snakemake --rulegraph | dot -Tpng > Docs/rule-graph.png

import json, os, sys
def load_pipeline_config(config_filename:str):
    try:
        full_path = os.path.join(os.getcwd(), config_filename)
        f = open(full_path)
        config = json.load(f)
        return config
    except Exception as e:
        print('Failed to load pipeline config. Exiting...')
        sys.exit(1)

CONFIG_FILENAME = "pipeline.config.json"
CONFIG = load_pipeline_config(config_filename=CONFIG_FILENAME)
FES_CONFIG = CONFIG["freq_encode_snps_config"]
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
include: "Rules/extract_hla_loci.smk"
include: "Rules/get_imp_precheck_ref_data.smk"
include: "Rules/get_imp_precheck_script.smk"
include: "Rules/calc_bed_frequencies.smk"
include: "Rules/run_imp_precheck.smk"
include: "Rules/run_imp_precheck_fixes.smk"

include: "Rules/submit_vcf_to_mis.smk"

include: "Rules/extract_list_of_sample_ids.smk"
include: "Rules/split_sample_ids_file.smk"
include: "Rules/partition_vcf_file.smk"
include: "Rules/get_snp_ref_panel.smk"
include: "Rules/convert_vcf_to_hap_samp.smk"
include: "Rules/move_hap.smk"
include: "Rules/move_samp.smk"

