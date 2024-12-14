#!/usr/bin/env bash

today=$(date +%m%d%Y)
results_uuid=$(uuidgen)

results_folder=/opt/drop_files/results/$today/$results_uuid
json_folder=/opt/drop_files/results/json

# Yes I hate it very much
mkdir -p $json_folder/zeek/$results_uuid
mkdir -p $json_folder/dsniff
mkdir -p $json_folder/p0f
mkdir -p $json_folder/bruteshark
mkdir -p $json_folder/ntlmraw_unhide

# Create folders for each tool (so we can turn the raw output to json later on)
# Yes. I hate it.
mkdir -p $results_folder/dsniff
mkdir -p $results_folder/p0f
mkdir -p $results_folder/bruteshark
mkdir -p $results_folder/ntlmraw_unhide

cd $results_folder

dsniff -p "$2""$1" -w $results_folder/dsniff/dsniff_results.log > /dev/null 2>&1 &
p0f -r "$2""$1" -o $results_folder/p0f/p0f.log > /dev/null  2>&1 &

cd $json_folder/zeek/$results_uuid
zeek -C -r "$2""$1" LogAscii::use_json=T > /dev/null 2>&1 &
cd $results_folder

python3 /opt/NTLMRawUnHide.py -q -i "$2""$1" -o $results_folder/ntlmraw_unhide/ntlmraw_unhide.log > /dev/null 2>&1 &

current=$(date)
echo "[$current] Processing file $1" >> /opt/drop_files/scripts/logs/processed_pcaps.log

# Wait for all the background processes to be done
wait

find $results_folder -type f -name "p0f.log" -exec jq -Rn '[.,inputs] | map({p0f: .})' "{}" \; > $json_folder/p0f/$results_uuid.json
find $results_folder -type f -name "dsniff_results.log"  -exec jq -Rn '[.,inputs] | map({dsniff: .})' "{}" \; > $json_folder/dsniff/$results_uuid.json
find $results_folder -type f -name "ntlmraw_unhide.log" -exec jq -Rn '[.,inputs] | map({ntlm: .})' "{}" \; > $json_folder/ntlmraw_unhide/$results_uuid.json

brutesharkcli -i "$2""$1" -m Credentials,NetworkMap,DNS -o $results_folder/bruteshark > /dev/null &

/opt/drop_files/scripts/merge_json.sh "$results_uuid"

finished=$(date)
echo "[$finished] Processed file $1" >> /opt/drop_files/scripts/logs/processed_pcaps.log
