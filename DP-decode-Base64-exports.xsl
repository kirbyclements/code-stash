<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dp="http://www.datapower.com/extensions"
    xmlns:man="http://www.datapower.com/schemas/management"
    extension-element-prefixes="dp"
    >
    <dp:output-mapping  href="store:///pkcs7-convert-input.ffd" type="ffd"/>
    
    <xsl:template match="/">
        <object>
            <message>
                <xsl:value-of select="dp:binary-decode(/*/*/man:response/man:file)"/>
            </message>
        </object>
    </xsl:template>
    
</xsl:stylesheet>
