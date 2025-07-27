#!/usr/bin/env bash

today=$(date +%m%d%Y)
results_uuid=$(uuidgen)

results_folder=/opt/drop_files/results/$today/$results_uuid
json_folder=/opt/drop_files/results/json

FILE="$1"

# Yes I hate it very much
mkdir -p $json_folder/zeek/$results_uuid
mkdir -p $json_folder/dsniff
mkdir -p $json_folder/p0f
mkdir -p $json_folder/ntlmraw_unhide

# Create folders for each tool (so we can turn the raw output to json later on)
# Yes. I hate it.
mkdir -p $results_folder/dsniff
mkdir -p $results_folder/p0f
mkdir -p $results_folder/bruteshark
mkdir -p $results_folder/ntlmraw_unhide

cd $results_folder

dsniff -p "$FILE" -w $results_folder/dsniff/dsniff_results.log > /dev/null 2>&1 &
p0f -r "$FILE" -o $results_folder/p0f/p0f.log > /dev/null  2>&1 &

cd $json_folder/zeek/$results_uuid
./opt/zeek/bin/zeek -C -r "$FILE" LogAscii::use_json=T > /dev/null 2>&1 &
cd $results_folder

python3 /opt/NTLMRawUnHide.py -q -i "$FILE" -o $results_folder/ntlmraw_unhide/ntlmraw_unhide.log > /dev/null 2>&1 &

current=$(date)
echo "[$current] Processing file "$FILE"" >> /opt/drop_files/scripts/logs/processed_pcaps.log

# Wait for all the background processes to be done
wait

check_p0f=$(find $results_folder -type f -name "p0f.log")
check_dsniff=$(find $results_folder -type f -name "dsniff_results.log")
check_ntlmrawunhide=$(find $results_folder -type f -name "ntlmraw_unhide.log")

if [[ -n "$check_p0f" && -s "$check_p0f" ]]
then
	jq -Rn '[.,inputs] | map({p0f: .})' "$check_p0f" > $json_folder/p0f/$results_uuid.json
else
	echo "No p0f output for $FILE" >> /opt/drop_files/scripts/logs/processed_pcaps.log
	rm -rf $results_folder/p0f
fi

if [[ -n "$check_dsniff" && -s "$check_dsniff" ]]
then
	jq -Rn '[.,inputs] | map({dsniff: .})' "$check_dsniff" > $json_folder/dsniff/$results_uuid.json
else
	echo "No dsniff output for $FILE" >> /opt/drop_files/scripts/logs/processed_pcaps.log
	rm -rf $results_folder/dsniff
fi

if [[ -n "$check_ntlmrawunhide" && -s "$check_ntlmrawunhide" ]]
then
	jq -Rn '[.,inputs] | map({ntlm: .})' "$check_ntlmrawunhide" > $json_folder/ntlmraw_unhide/$results_uuid.json
else
	echo "No ntlmraw_unhide output for $FILE" >> /opt/drop_files/scripts/logs/processed_pcaps.log
	rm -rf $results_folder/ntlmraw_unhide
fi

brutesharkcli -i "$FILE" -m Credentials,NetworkMap,DNS -o $results_folder/bruteshark > /dev/null &

/opt/drop_files/scripts/merge_json.sh "$results_uuid"

finished=$(date)
echo "[$finished] Processed file "$FILE"" >> /opt/drop_files/scripts/logs/processed_pcaps.log
