<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dp="http://www.datapower.com/extensions" extension-element-prefixes="dp" exclude-result-prefixes="dp">
    <xsl:template match="/">
        <xsl:variable name="ServiceMemoryStatus">
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:man="http://www.datapower.com/schemas/management">
                <soapenv:Header/>
                <soapenv:Body>
                    <man:request domain="kirbyc">
                        <man:get-status class="ServicesMemoryStatus"/>
                    </man:request>
                </soapenv:Body>
            </soapenv:Envelope>
        </xsl:variable>
        <dp:url-open target="https://pswdp3.rtp.raleigh.ibm.com:5550/service/mgmt/3.0">
            <xsl:copy-of select="$ServiceMemoryStatus"/>
        </dp:url-open>
    </xsl:template>
</xsl:stylesheet>