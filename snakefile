import json
from snakemake.remote.iRODS import RemoteProvider

irods = RemoteProvider(irods_env_file='/app/.irods/irods_environment.json')
files, = irods.glob_wildcards("{files}")
input_files = list(map(lambda file : file["path"], config["inputData"].values()))
output_files = list(map(lambda file : file["path"], config["outputData"].values()))

rule do_dgea_analysis:
  input:
    "analysis/data_model/dgea_input_data.json",
    irods.remote(config["inputData"]["counts"]["path"]),
    irods.remote(config["inputData"]["sample_info"]["path"]),
  output:
    irods.remote(expand('{f}',f=output_files))
  script:
    "dgea.Rmd"
