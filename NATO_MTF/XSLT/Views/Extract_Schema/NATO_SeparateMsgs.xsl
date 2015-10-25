<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    version="2.0">
    <xsl:include href="NATO_GoE_Msg_Separate.xsl"/>
    <xsl:template name="MAIN">
        <!--<xsl:call-template name="ExtractMessageSchema">
            <xsl:with-param name="msgident" select="'ATO'"/>
            <xsl:with-param name="outdir" select="'../../../XSD/APP-11C-GoE/SeparateMessages/'"/>
        </xsl:call-template>-->
        <xsl:call-template name="ExtractAllMessageSchema">
            <xsl:with-param name="outdir" select="'../../../XSD/APP-11C-GoE/SeparateMessages/'"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
