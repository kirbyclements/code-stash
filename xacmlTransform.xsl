<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dp="http://www.datapower.com/extensions"
	xmlns:dpxacml="urn:ibm:names:datapower:xacml:2.0"
	extension-element-prefixes="dp" exclude-result-prefixes="dp dpxacml"
	version="1.0">
	<xsl:include href="store:///utilities.xsl" />
	<xsl:include href="store:///dp/aaa-xacml-context.xsl" />
	<xsl:template match="/">
		<Request xmlns="urn:oasis:names:tc:xacml:2.0:context:schema:os"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation="urn:oasis:names:tc:xacml:2.0:context:schema:os http://docs.oasis-open.org/access_control-xacml-2.0-context-schema-os.xsd">
			<Subject>
				<xsl:copy-of select="//*[local-name()='Subject']/*" />
				</Subject>
			<Resource>		
				<xsl:copy-of select="//*[local-name()='Resource']/*" />
			</Resource>
			<Action>
				<xsl:copy-of select="//*[local-name()='Action']/*" />
			</Action>
			<Environment />
		</Request>
	</xsl:template>
</xsl:stylesheet>
