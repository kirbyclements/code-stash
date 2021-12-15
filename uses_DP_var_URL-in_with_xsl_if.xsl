<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
    xmlns:date="http://exslt.org/dates-and-times" xmlns:str="http://exslt.org/strings"
    xmlns:mgmt="http://www.datapower.com/schemas/management" extension-element-prefixes="dp" exclude-result-prefixes="dp xs">
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        
        <xsl:variable name="URLin" select="dp:variable('var://service/URL-in')"/>
        
        <xsl:if test="contains($URLin, 'DocManager')">
            <dp:set-variable name="'var://service/routing-url-sslprofile'" value="'ATS_sb_2_RoutingTest'"/>
            <dp:set-variable name="'var://service/routing-url'" value="'https://10.115.191.250:9445'"/>
            <dp:set-variable name="'var://service/URI'" value="'/PmInternetAccountServiceModuleWeb/ModuleContextExport/getBuildNumber'"/>
        </xsl:if>
        
        <xsl:if test="contains($URLin, 'AddressBook')">
            <dp:set-variable name="'var://service/routing-url-sslprofile'" value="'ATS_sb_2_RoutingTest'"/>
            <dp:set-variable name="'var://service/routing-url'" value="'https://10.115.191.250:9445'"/>
            <dp:set-variable name="'var://service/URI'" value="'/restservlet/restapi/helloworld'"/>
        </xsl:if>
        
        <xsl:if test="contains($URLin, 'Addy')">
            <dp:set-variable name="'var://service/routing-url-sslprofile'" value="'ATS_sb_2_RoutingTest'"/>
            <dp:set-variable name="'var://service/routing-url'" value="'https://10.115.191.250:9445'"/>
            <dp:set-variable name="'var://service/URI'" value="'/AddressBook'"/>
        </xsl:if>
        
        <xsl:if test="contains($URLin, 'Doccy')">
            <dp:set-variable name="'var://service/routing-url-sslprofile'" value="'ATS_sb_2_RoutingTest'"/>
            <dp:set-variable name="'var://service/routing-url'" value="'https://10.115.191.250:9445'"/>
            <dp:set-variable name="'var://service/URI'" value="'/DocReader'"/>
        </xsl:if>
        
    </xsl:template>
    
</xsl:stylesheet>