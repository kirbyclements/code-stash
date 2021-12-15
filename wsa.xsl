<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
    
    <xsl:output method="xml"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/*[namespace-uri()='http://www.w3.org/2003/05/soap-envelope' and local-name()='Envelope']/*[namespace-uri()='http://www.w3.org/2003/05/soap-envelope' and local-name()='Header']">
        <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
            <wsa:Action soap:mustUnderstand="1">http://www.ABC.com/sws/Calculator/ICalculator/Add</wsa:Action>
            <wsa:To soap:mustUnderstand="1">http://localhost:82/ConfigurationUpdateService.svc</wsa:To></soap:Header>
    </xsl:template>
</xsl:stylesheet>
