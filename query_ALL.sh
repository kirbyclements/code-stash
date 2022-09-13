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

zipfiles=$(ls -lt | find -name "*_backup*.zip" -type f -ctime -3)
for zipfile in ./*$zipfiles; do
	echo "<BR>DataPower Export $zipfile<BR>"
	echo "<TABLE>"
	echo "<TR STYLE='background-color:#888888;color:#FFFFFF'><TH>DEVICE</TH><TH>DOMAIN</TH><TH>QMANAGER</TH><TH>RETRY INTERVAL</TH><TH>RETRY ATTEMPTS</TH><TH>MQQM PASSWORD ALIAS</TH><TH>PASSWORD</TH><TH>PASSWORD ALIAS</TH></TR>"

	zipdir=$(basename -s .zip $zipfile)
	unzip -jo $zipfile '*.zip' -d ./$zipdir > /dev/null
	for exportfile in $zipdir/*.zip; do
		exportxml=$(unzip -p $exportfile export.xml)
		domain=$(echo $exportxml | grep -o -P '(?<=domain\=").*(?=\")' | sed 's/".*//')
		device=$(echo $exportxml | grep -o -P '(?<=<device-name>)(?s).*(?=</device-name>)')

		echo $exportxml | grep -o -P '(?<=<MQQM)(?s).*(?=</MQQM>)''(?<=<PasswordAlias class="PasswordAlias">)(?s).*(?=</PasswordAlias>)' | while read -r qm pa; do
				qmname=$(echo $qm | grep -o -P '(?<=name\=").*(?=\")' | sed 's/".*//')
				retryinterval=$(echo $qm | grep -o -P '(?<=<RetryInterval>)(?s).*(?=</RetryInterval>)')
				retryattempts=$(echo $qm | grep -o -P '(?<=<RetryAttempts>)(?s).*(?=</RetryAttempts>)')
				csppasswordalias=$(echo $qm | grep -o -P '(?<=<CSPPasswordAlias class="PasswordAlias">)(?s).*(?=</CSPPasswordAlias>)')
				csppassword=$(echo $qm | grep -o -P '(?<=<CSPPassword>)(?s).*(?=</CSPPassword>)')
                passwordalias$(echo $pa | grep -o -P '(?<=<PasswordAlias class="PasswordAlias">)(?s).*(?=</PasswordAlias>)')

				if (( $retryinterval )) || (( $retryattempts )) || (( $csppasswordalias )) || (( $csppassword )) || (( $passwordalias )); then
				echo "<TR STYLE='text-align:center'><TD>$device</TD><TD>$domain</TD><TD>$qmname</TD>"
				if (( $retryinterval != '90' )); then
					echo "<TD STYLE='color:#FF0000'>$retryinterval</TD>"
				else
					echo "<TD STYLE='color:#000000'>$retryinterval</TD>"
				fi
				if (( $retryattempts != '30' )); then
					echo "<TD STYLE='color:#FF0000'>$retryattempts</TD>"
				else
					echo "<TD STYLE='color:#000000'>$retryattempts</TD>"
				fi
				if (( $csppasswordalias )); then
					echo "<TD STYLE='color:#FF0000'>$csppasswordalias</TD>"
				else
					echo "<TD STYLE='color:#000000'></TD>"
				fi
				if (( $csppassword )); then
					echo "<TD STYLE='color:#FF0000'>yes</TD>"
				else
					echo "<TD STYLE='color:#FF0000'></TD>"
				fi
                if (( $passwordalias )); then
					echo "<TD STYLE='color:#FF0000'>$passwordalias</TD>"
				else
					echo "<TD STYLE='color:#FF0000'></TD>"
				fi
				echo "</TR>"
				fi
			   done
	done
	echo "</TABLE><BR><BR>"
	rm -rf *_backup-*2022
	#rm -rf ./$zipdir
done
echo "</BODY>"
echo "</HTML>"
