<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
    xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
    exclude-result-prefixes="xsd"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="baselineFields" select="document('../../../XSD/Baseline_Schema/fields.xsd')"/>
    <xsl:variable name="baselineCompostes" select="document('../../../XSD/Baseline_Schema/composites.xsd')"/>
    <xsl:variable name="baselineSets" select="document('../../../XSD/Baseline_Schema/sets.xsd')"/>
    <xsl:variable name="baselineMsgs" select="document('../../../XSD/Baseline_Schema/messages.xsd')"/>
   
    <xsl:variable name="allFldAppInfo">
        <xsl:for-each select="$baselineFields/*//xsd:appinfo/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$baselineCompostes/*//xsd:appinfo/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="allSetAppInfo">
        <xsl:for-each select="$baselineSets/*//xsd:appinfo/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="allMsgAppInfo">
        <xsl:for-each select="$baselineMsgs/*//xsd:appinfo/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:template match="/">
        <AppInfoNodes>
            <BaselineFieldsNodes>
                <xsl:for-each select="$allFldAppInfo/*">
                    <xsl:variable name="enm" select="name()"/>
                    <xsl:if test="not(preceding-sibling::*[name() = $enm])">
                        <xsl:element name="{name()}"/>
                    </xsl:if>
                </xsl:for-each>
            </BaselineFieldsNodes>
            <BaselineSetNodes>
                <xsl:for-each select="$allSetAppInfo/*">
                    <xsl:variable name="enm" select="name()"/>
                    <xsl:if test="not(preceding-sibling::*[name() = $enm])">
                        <xsl:element name="{name()}"/>
                    </xsl:if>
                </xsl:for-each>
            </BaselineSetNodes>
            <BaselineMsgNodes>
                <xsl:for-each select="$allMsgAppInfo/*">
                    <xsl:variable name="enm" select="name()"/>
                    <xsl:if test="not(preceding-sibling::*[name() = $enm])">
                        <xsl:element name="{name()}"/>
                    </xsl:if>
                </xsl:for-each>
            </BaselineMsgNodes>
        </AppInfoNodes>
    </xsl:template>
</xsl:stylesheet>
