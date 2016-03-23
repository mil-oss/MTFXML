<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!--This XSLT generates an XML file with data used to compare equivalency of one XML Schema with another.-->

    <xsl:variable name="baseline_sets" select="document('../../XSD/Baseline_Schema/sets.xsd')"/>
    <xsl:variable name="refactor_sets" select="document('../../XSD/GoE_Schema/GoE_sets.xsd')"/>
    <xsl:variable name="refactor_fields" select="document('../../XSD/GoE_Schema/GoE_fields.xsd')"/>

    <xsl:variable name="baseline_map">
        <Baseline_Sets count="{count($baseline_sets/xsd:schema/xsd:complexType)}">
            <xsl:apply-templates select="$baseline_sets/xsd:schema/xsd:complexType">
                <xsl:sort select="@name"/>
            </xsl:apply-templates>
        </Baseline_Sets>
    </xsl:variable>
    
    <xsl:variable name="refactor_map">
        <Refactor_Sets count="{count($refactor_sets/xsd:schema/xsd:complexType)}">
            <xsl:apply-templates select="$refactor_sets/xsd:schema/xsd:complexType">
                <xsl:sort select="@name"/>
            </xsl:apply-templates>
        </Refactor_Sets>
    </xsl:variable>

    <xsl:template match="xsd:complexType[@name]">
        <Set name="{@name}" fields="{count(.//xsd:element[not(@name='GroupOfFields')])}">
            <xsl:apply-templates select="*"/>
        </Set>
    </xsl:template>

    <xsl:template match="xsd:element">
        <Field>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select=".//@base"/>
            <xsl:apply-templates select="xsd:*"/>
        </Field>
    </xsl:template>
    
    
    <xsl:template match="xsd:element[@ref]">
        <Field>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="starts-with(@ref,'field:')">
                    <xsl:apply-templates select="$refactor_fields/xsd:schema/xsd:element[@name=substring-after(.,'field:')]/*"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$refactor_sets/xsd:schema/xsd:element[@name=.]/*"/>
                </xsl:otherwise>
            </xsl:choose>
        </Field>
    </xsl:template>

    <xsl:template match="xsd:element[@name = 'GroupOfFields']">
        <xsl:apply-templates select="xsd:*"/>
    </xsl:template>

    <xsl:template match="xsd:choice">
        <Choice>
            <xsl:apply-templates select="xsd:*"/>
        </Choice>
    </xsl:template>

    <xsl:template match="xsd:sequence">
        <Sequence>
            <xsl:apply-templates select="xsd:*"/>
        </Sequence>
    </xsl:template>

    <xsl:template match="xsd:*">
        <xsl:apply-templates select="xsd:*"/>
    </xsl:template>

    <xsl:template match="@base">
        <xsl:attribute name="type">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template name="main">
        <xsl:result-document href="../../XSD/Test/baseline_set_map.xml">
            <xsl:copy-of select="$baseline_map"/>
        </xsl:result-document>
        <xsl:result-document href="../../XSD/Test/refactor_set_map.xml">
            <xsl:copy-of select="$refactor_map"/>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
