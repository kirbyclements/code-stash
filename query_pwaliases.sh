#!/bin/bash
#echo "Processing files in zip folder $1"
echo "<HTML>"
echo "<HEAD>"
echo "<TITLE>DataPower Report</TITLE>"
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

zipfiles=$(ls -lt | find -name "*backup*.zip" -type f -ctime -90)
for zipfile in $zipfiles; do
	echo "<BR>DataPower Export $zipfile<BR>"
	echo "<TABLE>"
	echo "<TR STYLE='background-color:#888888;color:#FFFFFF'><TH>DEVICE</TH><TH>DOMAIN</TH><TH>QMANAGER</TH><TH>RETRY INTERVAL</TH><TH>RETRY ATTEMPTS</TH><TH>PASSWORD ALIAS</TH><TH>UA PASSWORD ALIAS</TH></TR>"

	zipdir=$(basename -s .zip $zipfile)
	unzip -jo $zipfile '*.zip' -d $zipdir > /dev/null
	for exportfile in $zipdir/*.zip; do
		exportxml=$(unzip -p $exportfile export.xml)
		domain=$(echo $exportxml | grep -o -P '(?<=domain\=").*(?=\")' | sed 's/".*//')
		device=$(echo $exportxml | grep -o -P '(?<=<device-name>)(?s).*(?=</device-name>)')
		while read -r qm pa
		do
			if [[ $qm == *"<MQQM"* ]] | [[ $pa == *"<PasswordAlias"* ]]; then
			qmname=$(echo $qm | grep -o -P '(?<=name\=").*(?=\")' | sed 's/".*//')
			paname=$(echo $pa | grep -o -P '(?<=name\=").*(?=\")' | sed 's/".*//')
			finished=false
			retryinterval=""
			retryattempts=""
			csppasswordalias=""
			passwordalias=""
			
			while [ "$finished" != "true" ]; do
				read -r qmdata
				read -r padata
				qmend="MQQM>"
				if [[ $qmdata == *"$qmend"* ]] | [[ $padata == *"$paend"* ]]; then
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
                                if [ ! -z "$passwordalias" ]
                                then
                                        echo "<TD STYLE='color:#000000'>$passwordalias</TD>"
                                else
                                        echo "<TD STYLE='color:#000000'>$passwordalias</TD>"
                                fi
                                echo "</TR>"

					finished=true

				else if [[ $qmdata == *"<RetryInterval>"* ]]; then
					retryinterval=$(echo $qmdata | grep -o -P '(?<=<RetryInterval>)(?s).*(?=</RetryInterval>)' )
				else if [[ $qmdata == *"<RetryAttempts>"* ]]; then
					retryattempts=$(echo $qmdata | grep -Po '(?<=<RetryAttempts>).*?(?=</RetryAttempts>)')
				else if [[ $qmdata == *"<CSPPasswordAlias"* ]]; then
					csppasswordalias=$(echo $qmdata | grep -o -P '(?<=<CSPPasswordAlias class="PasswordAlias">)(?s).*(?=</CSPPasswordAlias>)')
				else if [[ $padata == *"<PasswordAlias"* ]]; then
					passwordalias=$(echo $qmdata | grep -o -P '(?<=<PasswordAlias class="PasswordAlias">)(?s).*(?=</PasswordAlias>)')
				fi
				fi
				fi
				fi
				fi
			done 
			fi
		done < <(unzip -p $exportfile export.xml | grep "MQQM\|RetryInterval\|RetryAttempts\|CSPPasswordAlias\|PasswordAlias" | sed -e 's/<MQQM/\n&/g' -e 's/<PasswordAlias/\n&/g')
		#done < <(unzip -p $exportfile export.xml | grep "MQQM\|RetryInterval\|RetryAttempts\|CSPPasswordAlias\|PasswordAlias\|AULDAPBindPasswordAlias\|AULTPAKeyPasswordAlias\|AZLDAPBindPasswordAlias\|PPLTPAKeyPasswordAlias" | sed 's/<MQQM/\n&/g')
	done
	echo "</TABLE><BR><BR>"
	rm -rf ./$zipdir
done
echo "</BODY>"
echo "</HTML>"