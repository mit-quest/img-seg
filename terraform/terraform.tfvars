username = "jmjoseph_google"
project_name = "necstlab"
account_key_file_location = "../keys/necstlab-5270ccc61914.json"
public_ssh_key_location = "~/.ssh/gcp.pub"
private_ssh_key_location = "~/.ssh/gcp"

disk_image = "projects/ml-images/global/images/c2-deeplearning-tf-1-13-cu100-20190227"
//disk_image = "projects/ml-images/global/images/c1-deeplearning-pytorch-1-0-cu100-20190228"
hard_drive_size_gp = "200"
ram_size_mb = "25600"
number_of_cpus = "8"
//gpu_type = "nvidia-tesla-p100"
gpu_type = "nvidia-tesla-k80"
number_of_gpus = "1"

script_to_run_on_machine_creation = "../scripts/machine-creation.sh"
script_to_run_on_machine_startup = "../scripts/machine-startup.sh"
start_jupyter_server = "True"
