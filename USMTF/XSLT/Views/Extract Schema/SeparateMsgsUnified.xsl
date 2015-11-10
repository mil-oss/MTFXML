<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    version="2.0">
    <xsl:include href="GoE_Msg_SeparateUnified.xsl"/>
    <xsl:template name="main">
        <!--<xsl:call-template name="ExtractMessageSchemaUnified">
            <xsl:with-param name="msgident" select="'ATO'"/>
            <xsl:with-param name="outdir" select="'../../../XSD/GoE_Schema/SeparateMessagesUnified/'"/>
        </xsl:call-template>-->
        <xsl:call-template name="ExtractAllMessageSchemaUnified">
            <xsl:with-param name="outdir" select="'../../../XSD/GoE_Schema/SeparateMessagesUnified/'"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
