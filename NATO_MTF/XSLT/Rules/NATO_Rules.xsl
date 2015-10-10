<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="mtfmsgs" select="document('../../XSD/GoE_Schema/GoE_messages.xsd')"/>

    <xsl:variable name="outputdoc" select="'../../XSD/Rules/MTF_Rules.xml'"/>

    <xsl:template match="/">
        <xsl:result-document href="{$outputdoc}">
            <MTFRules>
                <xsl:for-each select="$mtfmsgs/xsd:schema/xsd:complexType">
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo"/>
                </xsl:for-each>
            </MTFRules>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xsd:appinfo">
        <AppInfo>
            <xsl:apply-templates select="*"/>
        </AppInfo>
    </xsl:template>

    <xsl:template match="*:MsgInfo">
        <xsl:element name="MsgInfo">
            <xsl:apply-templates select="@*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*:MtfStructuralRelationship">
        <xsl:element name="MtfStructuralRelationship">
            <xsl:apply-templates select="@*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*:MtfStructuralRelationship[contains(@Explanation,'Field 1 in MSGID')]"/>

</xsl:stylesheet>
