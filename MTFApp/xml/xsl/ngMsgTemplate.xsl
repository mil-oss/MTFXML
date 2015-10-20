<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsd"
    version="2.0">
    
    <xsl:param name="msgid" select="'ATO'"/>
    
    <xsl:param name="msg" select="/*/*[@mtfid=$msgid]"/>
    
    <xsl:template match="/">
        <xsl:copy-of select="$msg"/>
    </xsl:template>
    
</xsl:stylesheet>