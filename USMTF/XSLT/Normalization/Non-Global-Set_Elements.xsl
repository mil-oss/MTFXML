<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="USMTF_Name_Changes.xsl"/>
    <xsl:variable name="Sets" select="document('../../XSD/GoE_Schema/GoE_sets.xsd')"/>
    <xsl:variable name="Fields" select="document('../../XSD/GoE_Schema/GoE_fields.xsd')"/>
    <xsl:variable name="global_fields_output" select="'../../XSD/Normalized/globalized_set_fields.xsd'"/>
    <xsl:variable name="setNonGlobals">
        <xsl:apply-templates select="$Sets/*/xsd:complexType//xsd:element[@name]"/>
    </xsl:variable>
    <xsl:template name="main">
        <xsl:result-document href="{$global_fields_output}">
            <xsd:schema xml:lang="en-US" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="urn:mtf:mil:6040b:goe:fields"
                targetNamespace="urn:mtf:mil:6040b:goe:fields" elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:include schemaLocation="../GoE_Schema/GoE_fields.xsd"/>
                <xsl:for-each select="$setNonGlobals/*">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:choose>
                        <xsl:when test="$Fields/xsd:schema/xsd:element[@name = $n]"/>
                        <xsl:when test="deep-equal(preceding-sibling::xsd:element[@name = $n][1], .)"/>
                        <xsl:when test="deep-equal(preceding-sibling::xsd:element[@name = $n][2], .)"/>
                        <xsl:when test="deep-equal(preceding-sibling::xsd:element[@name = $n][3], .)"/>
                        <xsl:when test="deep-equal(preceding-sibling::xsd:element[@name = $n][4], .)"/>
                        <xsl:when test="deep-equal(preceding-sibling::xsd:element[@name = $n][5], .)"/>
                        <xsl:otherwise>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="xsd:element">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*" mode="copy">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*:Field" mode="copy">
        <xsl:element name="Field" namespace="urn:mtf:mil:6040b:goe:fields">
            <xsl:apply-templates select="@*" mode="copy"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="@*" mode="copy">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="@type[starts-with(., 'field:')]" mode="copy">
        <xsl:attribute name="type">
            <xsl:value-of select="substring-after(., ':')"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@ref[starts-with(., 'field:')]" mode="copy">
        <xsl:attribute name="ref">
            <xsl:value-of select="substring-after(., ':')"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@base[starts-with(., 'field:')]" mode="copy">
        <xsl:attribute name="base">
            <xsl:value-of select="substring-after(., ':')"/>
        </xsl:attribute>
    </xsl:template>
    <!--FILTERS-->
    <xsl:template match="xsd:documentation" mode="copy"/>
    <xsl:template match="xsd:element[starts-with(@type, 'set:')]"/>
    <xsl:template match="xsd:element[@name = 'NarrativeInformationSet']"/>
    <xsl:template match="xsd:element[@name = 'AmplificationSet']"/>
    <xsl:template match="xsd:element[@fixed]"/>
    <xsl:template match="@minOccurs" mode="copy"/>
    <xsl:template match="@maxOccurs" mode="copy"/>
    <xsl:template match="@nillable" mode="copy"/>
    <xsl:template match="@fixed" mode="copy"/>
    <xsl:template match="@ColumnHeader" mode="copy"/>
    <xsl:template match="@identifier" mode="copy"/>
    <xsl:template match="@Justification" mode="copy"/>
    <xsl:template match="@remark" mode="copy"/>
</xsl:stylesheet>
