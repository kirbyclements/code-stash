#!/bin/bash

curl -k -X POST https://dpbuddy:If6was90@192.168.0.53:5550/service/mgmt/3.0 -H "Accept: application/xml" -H "Content-Type: application/xml" -u dpbuddy:If6was90 --data-binary @- <<DATA 
<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
    <env:Body>
        <dp:request xmlns:dp="http://www.datapower.com/schemas/management"  domain="default">
            <dp:do-action>
                <SecureBackup>
                    <cert>iop-mgmt-cert</cert>
                    <destination>local:///secure-backup</destination>
                    <include-iscsi>off</include-iscsi>
                    <include-raid>off</include-raid>
                </SecureBackup>
            </dp:do-action>
        </dp:request>
    </env:Body>
</env:Envelope>
DATA