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

cd /trvapps/dev_datatpower_backups

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


        echo "<TABLE>"
        echo "<TR STYLE='background-color:#888888;color:#FFFFFF'><TH>DEVICE</TH><TH>DOMAIN</TH><TH>OBJECT</TH><TH>NAME</TH><TH>PASSWORD ALIAS</TH></TR>"
        zipdir=$(basename -s .zip $zipfile)
        unzip -jo $zipfile '*.zip' -d $zipdir > /dev/null
        for exportfile in $zipdir/*.zip; do
                exportxml=$(unzip -p $exportfile export.xml)
                domain=$(echo $exportxml | grep -o -P '(?<=domain\=").*(?=\")' | sed 's/".*//')
                device=$(echo $exportxml | grep -o -P '(?<=<device-name>)(?s).*(?=</device-name>)')
                while read -r line
                do
                        if [[ $line == *"<BasicAuthPolicies"* ]]; then
                        objname="BasicAuthPolicies"
						loopend="BasicAuthPolicies>"
						if [[ $line == *"$loopend"* ]]; then
							finished=true
						else
                        	finished=false
						fi
                        passwordalias=""
                        username=""
                        while [ "$finished" != "true" ]; do
                                read -r nextline
                                if [[ $nextline == *'<PasswordAlias class="PasswordAlias'* ]]; then
                                	passwordalias=$(echo $nextline | grep -o -P '(?<=<PasswordAlias class="PasswordAlias">)(?s).*(?=</PasswordAlias>)')
                                elif [[ $nextline == *'<UserName'* ]]; then
                                	username=$(echo $nextline | grep -o -P '(?<=<UserName>)(?s).*(?=</UserName>)')
                                fi
                                if [[ $nextline == *"$loopend"* ]]; then
                               		if [ -z "$passwordalias" ]
                                	then
                                        finished=true
                                    else
                                		echo "<TR STYLE='text-align:center'><TD>$device</TD><TD>$domain</TD><TD>$objname</TD>"
                                        echo "<TD STYLE='color:#000000'>$username</TD>"
                                        echo "<TD STYLE='color:#000000'>$passwordalias</TD>"
                                		echo "</TR>"
                                	fi
                                	finished=true
                                fi
                        done
                        fi
                done < <(unzip -p $exportfile export.xml | grep "BasicAuthPolicies\|<PasswordAlias class\|<UserName>\|</BasicAuthPolicies>" | sed 's/<BasicAuthPolicies/\n&/g')

                while read -r line
                do
                        if [[ $line == *"<CryptoKey"* ]]; then
                        objname="CryptoKey"
						loopend="</CryptoKey>"
						if [[ $line == *"$loopend"* ]]; then
							finished=true
						else
                        	finished=false
						fi
                        passwordalias=""
                        username=$(echo $line | grep -o -P '(?<=name\=").*(?=\")' | sed 's/".*//')
                        while [ "$finished" != "true" ]; do
                                read -r nextline
                                if [[ $nextline == *'<Alias class='* ]]; then
                                        passwordalias=$(echo $nextline | grep -o -P '(?<=<Alias class="PasswordAlias">)(?s).*(?=</Alias>)')
                                fi
                                if [[ $nextline == *"$loopend"* ]]; then
                                        if [ -z "$passwordalias" ]
                                        then
                                                finished=true
                                        else
                                                echo "<TR STYLE='text-align:center'><TD>$device</TD><TD>$domain</TD><TD>$objname</TD>"
                                                echo "<TD STYLE='color:#000000'>$username</TD>"
                                                echo "<TD STYLE='color:#000000'>$passwordalias</TD>"
                                                echo "</TR>"
                                        fi
                                		finished=true
                                fi
                        done
                        fi
                done < <(unzip -p $exportfile export.xml | grep "<CryptoKey\|<PasswordAlias>on\|</Alias class=\|</CryptoKey" | sed 's/<CryptoKey/\n&/g')
				
                while read -r line
                do
                        if [[ $line == *"<CryptoCertificate"* ]]; then
                        objname="CryptoCertificate"
						loopend="</CryptoCertificate>"
						if [[ $line == *"$loopend"* ]]; then
							finished=true
						else
                        	finished=false
						fi
                        passwordalias=""
                        username=$(echo $line | grep -o -P '(?<=name\=").*(?=\")' | sed 's/".*//')
                        while [ "$finished" != "true" ]; do
                                read -r nextline
                                if [[ $nextline == *'<Alias class='* ]]; then
                                        passwordalias=$(echo $nextline | grep -o -P '(?<=<Alias class="PasswordAlias">)(?s).*(?=</Alias>)')
                                fi
                                if [[ $nextline == *"$loopend"* ]]; then
                                        if [ -z "$passwordalias" ]
                                        then
                                                finished=true
                                        else
                                                echo "<TR STYLE='text-align:center'><TD>$device</TD><TD>$domain</TD><TD>$objname</TD>"
                                                echo "<TD STYLE='color:#000000'>$username</TD>"
                                                echo "<TD STYLE='color:#000000'>$passwordalias</TD>"
                                                echo "</TR>"
                                        fi
                                		finished=true
                                fi
                        done
                        fi
                done < <(unzip -p $exportfile export.xml | grep "<CryptoCertificate\|<PasswordAlias>on\|</Alias class=\|</CryptoCertificate" | sed 's/<CryptoCertificate/\n&/g')				

                while read -r line
                do
                        if [[ $line == *"<PostProcess"* ]]; then
                        objname="PostProcess"
						loopend="</PostProcess>"
						if [[ $line == *"$loopend"* ]]; then
							finished=true
						else
                        	finished=false
						fi
                        passwordalias=""
                        username=$(echo $line | grep -o -P '(?<=name\=").*(?=\")' | sed 's/".*//')
                        while [ "$finished" != "true" ]; do
                                read -r nextline
                                if [[ $nextline == *'<PPLTPAKeyFilePasswordAlias'* ]]; then
                                        passwordalias=$(echo $nextline | grep -o -P '(?<=<PPLTPAKeyFilePasswordAlias class="PasswordAlias">)(?s).*(?=</PPLTPAKeyFilePasswordAlias>)')
                                fi
                                if [[ $nextline == *"$loopend"* ]]; then
                                        if [ -z "$passwordalias" ]
                                        then
                                                finished=true
                                        else
                                                echo "<TR STYLE='text-align:center'><TD>$device</TD><TD>$domain</TD><TD>$objname</TD>"
                                                echo "<TD STYLE='color:#000000'>$username</TD>"
                                                echo "<TD STYLE='color:#000000'>$passwordalias</TD>"
                                                echo "</TR>"
                                        fi
                                		finished=true
                                fi
                        done
                        fi
                done < <(unzip -p $exportfile export.xml | grep "<PostProcess\|<PPLTPAKeyFilePasswordAlias\|</PostProcess" | sed 's/<PostProcess/\n&/g')

                while read -r line
                do
                        if [[ $line == *"<RBMSettings"* ]]; then
                        objname="RBMSettings"
						loopend="</RBMSettings>"
						if [[ $line == *"$loopend"* ]]; then
							finished=true
						else
                        	finished=false
						fi
                        auldappasswordalias=""
                        mcldappasswordalias=""
                        username=$(echo $line | grep -o -P '(?<=name\=").*(?=\")' | sed 's/".*//')
                        while [ "$finished" != "true" ]; do
                                read -r nextline
                                if [[ $nextline == *'<AULDAPBindPasswordAlias'* ]]; then
                                        auldappasswordalias=$(echo $nextline | grep -o -P '(?<=<AULDAPBindPasswordAlias class="PasswordAlias">)(?s).*(?=</AULDAPBindPasswordAlias>)')
                                fi
                                if [[ $nextline == *'<MCLDAPBindPasswordAlias'* ]]; then
                                        mcldappasswordalias=$(echo $nextline | grep -o -P '(?<=<MCLDAPBindPasswordAlias class="PasswordAlias">)(?s).*(?=</MCLDAPBindPasswordAlias>)')
                                fi
                                if [[ $nextline == *"$loopend"* ]]; then
                                        if [ -z "$auldappasswordalias" ]
										then
                                                finished=true
										fi
                                        if [ ! -z "$auldappasswordalias" ] 
										then
                                                echo "<TR STYLE='text-align:center'><TD>$device</TD><TD>$domain</TD><TD>$objname</TD>"
                                                echo "<TD STYLE='color:#000000'>$username</TD>"
                                                echo "<TD STYLE='color:#000000'>$auldappasswordalias</TD>"
                                                echo "</TR>"
										fi
                                        if [ ! -z "$mcldappasswordalias" ] 
										then
                                                echo "<TR STYLE='text-align:center'><TD>$device</TD><TD>$domain</TD><TD>$objname</TD>"
                                                echo "<TD STYLE='color:#000000'>$username</TD>"
                                                echo "<TD STYLE='color:#000000'>$mcldappasswordalias</TD>"
                                                echo "</TR>"
                                        fi
                                		finished=true
                                fi
                        done
                        fi
                done < <(unzip -p $exportfile export.xml | grep "<RBMSettings name\|<AULDAPBindPasswordAlias\|<MCLDAPBindPasswordAlias\|</RBMSettings" | sed 's/<RBMSettings/\n&/g')


                while read -r line
                do
                        if [[ $line == *"<AAAPolicy"* ]]; then
                        objname="AAAPolicy"
						loopend="</AAAPolicy"
						if [[ $line == *"$loopend"* ]]; then
							finished=true
						else
                        	finished=false
						fi
                        auldappasswordalias=""
						aultpapasswordalias=""
                        azldappasswordalias=""
                        username=$(echo $line | grep -o -P '(?<=name\=").*(?=\")' | sed 's/".*//')
                        while [ "$finished" != "true" ]; do
                                read -r nextline
                                if [[ $nextline == *'<AULDAPBindPasswordAlias'* ]]; then
                                        auldappasswordalias=$(echo $nextline | grep -o -P '(?<=<AULDAPBindPasswordAlias class="PasswordAlias">)(?s).*(?=</AULDAPBindPasswordAlias>)')
                                fi
                                if [[ $nextline == *'<AULTPAKeyFilePasswordAlias'* ]]; then
                                        aultpapasswordalias=$(echo $nextline | grep -o -P '(?<=<AULTPAKeyFilePasswordAlias class="PasswordAlias">)(?s).*(?=</AULTPAKeyFilePasswordAlias>)')
                                fi
                                if [[ $nextline == *'<AZLDAPBindPasswordAlias'* ]]; then
                                        azldappasswordalias=$(echo $nextline | grep -o -P '(?<=<AZLDAPBindPasswordAlias class="PasswordAlias">)(?s).*(?=</AZLDAPBindPasswordAlias>)')
                                fi
                                if [[ $nextline == *"$loopend"* ]]; then
                                        if [ -z "$auldappasswordalias" ]
                                        then
                                                finished=true
                                        elif [ ! -z "$auldappasswordalias" ]
										then
                                                echo "<TR STYLE='text-align:center'><TD>$device</TD><TD>$domain</TD><TD>$objname</TD>"
                                                echo "<TD STYLE='color:#000000'>$username</TD>"
                                                echo "<TD STYLE='color:#000000'>$auldappasswordalias</TD>"
                                                echo "</TR>"
                                        elif [ ! -z "$aultpapasswordalias" ]
										then
                                                echo "<TR STYLE='text-align:center'><TD>$device</TD><TD>$domain</TD><TD>$objname</TD>"
                                                echo "<TD STYLE='color:#000000'>$username</TD>"
                                                echo "<TD STYLE='color:#000000'>$aultpapasswordalias</TD>"
                                                echo "</TR>"
                                        elif [ ! -z "$azldappasswordalias" ]
										then
                                                echo "<TR STYLE='text-align:center'><TD>$device</TD><TD>$domain</TD><TD>$objname</TD>"
                                                echo "<TD STYLE='color:#000000'>$username</TD>"
                                                echo "<TD STYLE='color:#000000'>$azldappasswordalias</TD>"
                                                echo "</TR>"
                                        fi
                                		finished=true
                                fi
                        done
                        fi
                done < <(unzip -p $exportfile export.xml | grep "<AAAPolicy name\|<AULDAPBindPasswordAlias\|<AULTPAKeyFilePasswordAlias\|<AZLDAPBindPasswordAlias\|</AAAPolicy" | sed 's/<AAAPolicy/\n&/g')

        done
        echo "</TABLE><BR><BR>"

	#rm -rf *_backup-*2022
	rm -rf ./$zipdir
done
echo "</BODY>"
echo "</HTML>"
