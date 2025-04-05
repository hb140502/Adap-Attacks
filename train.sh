#!/bin/bash

. ./input_validation.sh
input_validation $@

repo_dir="$HOME/master-thesis/code/backdoorbench"
my_dir="/vol/csedu-nobackup/project/hberendsen"
data_dir="$my_dir/data"
record_dir="$my_dir/record"
timestamp=$(date +"T%d-%m_%H-%M")

pratio_label=$(echo p$pratio | tr . -)
attack_id="${attack}_${model}_${dataset}_${pratio_label}"

# Attack options depend on attack type (adap-blend vs adap-patch)
if [[ $attack == "adaptive_blend" ]]; then
    attack_opts="-poison_rate=$pratio -cover_rate=$pratio -alpha=0.15 -test_alpha=0.2"
else
    cratio=$(echo "2 * $pratio" | bc) # Conservatism ratio = 2/3, i.e. twice as many cover as poisoned samples
    attack_opts="-poison_rate=$pratio -cover_rate=$cratio"
fi

echo $attack_opts
# python create_poisoned_set.py -dataset=$dataset -poison_type=$attack -data_dir=$data_dir -save_dir=$record_dir/$attack_id $attack_opts

# # Handle poisoned set failure
# if [[ $? -ne 0 ]]; then
#     mv "$record_dir/$attack_id" "$record_dir/FAIL_${attack_id}_${timestamp}"
#     echo "!!! POISONED DATASET CREATION FAILURE !!!"
#     exit 1
# fi

# python train_on_poisoned_set.py -dataset=$dataset -poison_type=$attack -save_dir=$record_dir/$attack_id $attack_opts

# # Handle training failure
# if [[ $? -ne 0 ]]; then
#     mv "$record_dir/$attack_id" "$record_dir/FAIL_${attack_id}_${timestamp}"
#     echo "!!! TRAINING FAILURE !!!"
#     exit 1
# fi

# echo "!!! FINISHED TRAINING !!!"
# cd $record_dir
    
# tar -cf "${attack_id}_${timestamp}.tar" $attack_id && rm -rf $attack_id
