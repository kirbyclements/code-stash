#!/bin/bash
#echo "Processing files in zip folder $1"
echo "<HTML>"
echo "<HEAD>"
echo "<TITLE>DataPower-MQQM Report</TITLE>"
echo "<STYLE>"
echo "table, th, td {"
echo "        border: 1px solid black;"
echo "}"
echo 
echo "th, td {"
echo "        padding: 10px;"
echo "}"
echo "</STYLE>"
echo "</HEAD>"
echo "<BODY>"

zipfiles=$(ls -lt | find -name "*backup*.zip" -type f -ctime -10)
for zipfile in $zipfiles; do
	echo "<BR>DataPower Export $zipfile<BR>"
	echo "<TABLE>"
	echo "<TR STYLE='background-color:#888888;color:#FFFFFF'><TH>DEVICE</TH><TH>DOMAIN</TH><TH>QMANAGER</TH><TH>RETRY INTERVAL</TH><TH>RETRY ATTEMPTS</TH><TH>PASSWORD ALIAS</TH></TR>"

	zipdir=$(basename -s .zip $zipfile)
	unzip -jo $zipfile '*.zip' -d $zipdir > /dev/null
	for exportfile in $zipdir/*.zip; do
		exportxml=$(unzip -p $exportfile export.xml)
		domain=$(echo $exportxml | grep -o -P '(?<=domain\=").*(?=\")' | sed 's/".*//')
		device=$(echo $exportxml | grep -o -P '(?<=<device-name>)(?s).*(?=</device-name>)')
		while read -r qm
		do
			if [[ $qm == *"<MQQM"* ]]; then
			qmname=$(echo $qm | grep -o -P '(?<=name\=").*(?=\")' | sed 's/".*//')
			#echo QMNAME: $qmname
			finished=false
			retryinterval=""
			retryattempts=""
			csppasswordalias=""
			while [ "$finished" != "true" ]; do
				read -r qmdata
				qmend="MQQM>"
				if [[ $qmdata == *"$qmend"* ]]; then
                                echo "<TR STYLE='text-align:center'><TD>$device</TD><TD>$domain</TD><TD>$qmname</TD>"
                                if (( $retryinterval != '30' )); then
                                        echo "<TD STYLE='color:#FF0000'>$retryinterval</TD>"
                                else
                                        echo "<TD STYLE='color:#000000'>$retryinterval</TD>"
                                fi
                                if (( $retryattempts != '90' )); then
                                        echo "<TD STYLE='color:#FF0000'>$retryattempts</TD>"
                                else
                                        echo "<TD STYLE='color:#000000'>$retryattempts</TD>"
                                fi
                                if [ ! -z "$csppasswordalias" ]
                                then
                                        echo "<TD STYLE='color:#000000'>$csppasswordalias</TD>"
                                else
                                        echo "<TD STYLE='color:#000000'>$csppasswordalias</TD>"
                                fi
                                echo "</TR>"

					finished=true
				else if [[ $qmdata == *"<RetryInterval>"* ]]; then
					#retryinterval=$(echo $qmdata | grep -oP '(?<=<RetryInterval>)[\s\S]*?(?=</RetryInterval>)')
					retryinterval=$(echo $qmdata | grep -o -P '(?<=<RetryInterval>)(?s).*(?=</RetryInterval>)' )
				else if [[ $qmdata == *"<RetryAttempts>"* ]]; then
					retryattempts=$(echo $qmdata | grep -Po '(?<=<RetryAttempts>).*?(?=</RetryAttempts>)')
				else if [[ $qmdata == *"<CSPPasswordAlias"* ]]; then
					csppasswordalias=$(echo $qmdata | grep -o -P '(?<=<CSPPasswordAlias class="PasswordAlias">)(?s).*(?=</CSPPasswordAlias>)')
				fi
				fi
				fi
				fi
			done 
			fi
		done < <(unzip -p $exportfile export.xml | grep "MQQM\|RetryInterval\|RetryAttempts\|CSPPasswordAlias" | sed 's/<MQQM/\n&/g')
	done
	echo "</TABLE><BR><BR>"
	#rm -rf *_backup-*2022
	rm -rf ./$zipdir
done
echo "</BODY>"
echo "</HTML>"
