<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dp="http://www.datapower.com/extensions" extension-element-prefixes="dp" exclude-result-prefixes="dp">
    <xsl:template match="/">
        <xsl:variable name="GetDeviceInfoRequest">
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.datapower.com/schemas/appliance/management/2.0">
                <soapenv:Header/>
                <soapenv:Body>
                    <ns:GetDeviceInfoRequest/>
                </soapenv:Body>
            </soapenv:Envelope>
        </xsl:variable>
        <dp:url-open target="https://10.1.90.86:5550/service/mgmt/amp/2.0">
            <xsl:copy-of select="$GetDeviceInfoRequest"/>
        </dp:url-open>
    </xsl:template>
</xsl:stylesheet>
