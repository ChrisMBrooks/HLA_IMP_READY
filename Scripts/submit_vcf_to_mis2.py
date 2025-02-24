import argparse, json, os, requests, sys
import pandas as pd

def load_pipeline_config(filename:str):
    try:
        full_path = os.path.join(filename)
        f = open(full_path)
        config = json.load(f)
        return config
    except Exception as e:
        print('Failed to load pipeline config. Exiting...')
        sys.exit(1)

def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Script to submit vcf.gz to michigan imputations service.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser._action_groups.pop()
    required = parser.add_argument_group("required arguments")

    required.add_argument(
        "-c",
        "--ConfigFile",
        help="Config file location as .json.",
        required=True,
        type=str,
    )

    required.add_argument(
        "-i",
        "--InputVCF",
        help="Input file location as .vcf.gz",
        required=True,
        type=str,
    )

    required.add_argument(
        "-o",
        "--Output",
        help="Output file name as .csv",
        required=True,
        type=str,
    )
    
    return vars(parser.parse_args())

def submit_post_request(vcf_file:str, full_url:str, token:str, data:dict, ):
    # add token to header (see Authentication)
    headers = {'X-Auth-Token' : token }

    # submit new job
    files = {'files' : open(vcf_file, 'rb')}
    r = requests.post(full_url, files=files, data=data, headers=headers)
    if r.status_code != 200:
        print(r.json()['message'])
        raise Exception('POST /jobs/submit/imputationserver2 {}'.format(r.status_code))

    # print response and job id
    message = r.json()['message']
    job_id = r.json()['id']
    
    return(message, job_id)

def export_results(message:str, job_id:str, filename:str):
    series = pd.Series()
    series['message'] = message
    series['job_id'] = job_id
    series.to_csv(filename)

def main():
    args = parse_arguments()
    config_file = args["ConfigFile"]
    vcf_file = args["InputVCF"]
    output_file = args["Output"]
    config = load_pipeline_config(config_file)["mich_imp2_config"]
    
    full_url = "{url}/{endpoint}".format(
        url=config['url'], 
        endpoint=config["endpoint_suffix"]    
    )
    
    (message, job_id) = submit_post_request(
        vcf_file=vcf_file, 
        full_url=full_url, 
        token=config['auth_token'], 
        data=config['params']
    )

    print(message)
    print(job_id)

    export_results(
        message=message, 
        job_id=job_id, 
        filename=output_file
    )

try:
    main()
except Exception as e:
    print('Failed to submit post request due to the following error: ')
    print(e)
    sys.exit(1)
