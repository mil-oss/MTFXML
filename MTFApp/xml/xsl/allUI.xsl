<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="messagesUI.xsl"/>
    <xsl:import href="setsUI.xsl"/>
    <xsl:import href="segmentsUI.xsl"/>
    <xsl:import href="fieldsUI.xsl"/>
    
    <xsl:template name="AllUI">
        <xsl:call-template name="messagesUI"/>
        <xsl:call-template name="setsUI"/>
        <xsl:call-template name="segmentsUI"/>
        <xsl:call-template name="fieldsUI"/>
    </xsl:template>
    
</xsl:stylesheet>