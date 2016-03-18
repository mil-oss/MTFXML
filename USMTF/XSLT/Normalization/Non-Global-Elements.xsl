<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="USMTF_Name_Changes.xsl"/>
    <xsl:variable name="Msgs" select="document('../../XSD/GoE_Schema/GoE_messages.xsd')"/>
    <xsl:variable name="Segments" select="document('../../XSD/GoE_Schema/GoE_segments.xsd')"/>
    <xsl:variable name="Sets" select="document('../../XSD/GoE_Schema/GoE_sets.xsd')"/>
    <xsl:variable name="Fields" select="document('../../XSD/GoE_Schema/GoE_fields.xsd')"/>
    <xsl:variable name="global_fields_output" select="'../../XSD/Normalized/globalized_set_fields.xsd'"/>
<!--    <xsl:variable name="global_simpleTypes_output" select="'../../XSD/Normalized/global_simpletypes.xsd'"/>
    <xsl:variable name="global_complexTypes_output" select="'../../XSD/Normalized/global_complextypes.xsd'"/>-->
    <xsl:variable name="nonGlobals">
        <xsl:apply-templates select="$Sets/*/*//xsd:element[@name]"/>
        <xsl:apply-templates select="$Segments/*/*//xsd:element[@name]"/>
        <xsl:apply-templates select="$Msgs/*/*//xsd:element[@name]"/>
    </xsl:variable>
    <xsl:template name="main">
        <xsl:result-document href="{$global_fields_output}">
            <xsd:schema xml:lang="en-US" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="urn:mtf:mil:6040b:goe:fields"
                targetNamespace="urn:mtf:mil:6040b:goe:fields" elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:include schemaLocation="../GoE_Schema/GoE_fields.xsd"/>
                <xsl:text>&#10;</xsl:text>
                <xsl:comment> ************** SimpleTypes **************</xsl:comment>
                <xsl:text>&#10;</xsl:text>
                <xsl:for-each select="$nonGlobals/*[@type]">
                    <xsl:sort select="@name"/>
                    <xsl:sort select="@type"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:variable name="t" select="@type"/>
                    <xsl:choose>
                        <xsl:when test="$Fields/xsd:schema/xsd:element[@name = $n][@type = $t]"/>
                        <xsl:when test="$Fields/xsd:schema/xsd:element[@name = $n][.//xsd:restriction/@base = $t]"/>
                        <xsl:when test="count($nonGlobals/*[@type][@name = $n]) &gt; 1">
                            <xsl:if test="not(deep-equal(preceding-sibling::xsd:element[@type][@name = $n][1], .))">
                                <xsl:variable name="rep" select="count(preceding-sibling::xsd:element[@type][@name = $n])"/>
                                <xsl:choose>
                                    <xsl:when test="$rep = 0">
                                        <xsl:copy-of select="." copy-namespaces="no"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsd:element name="{concat(@name,'_',$rep)}">
                                            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
                                            <xsl:apply-templates select="*" mode="copy"/>
                                        </xsd:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:text>&#10;</xsl:text>
                <xsl:comment> ************** ComplexTypes **************</xsl:comment>
                <xsl:text>&#10;</xsl:text>
                <xsl:for-each select="$nonGlobals/*[not(@type)][not(.//*:Set)][not(.//xsd:choice)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:choose>
                        <xsl:when test="$Fields/xsd:schema/xsd:element[@name = $n]"/>
                        <xsl:when test="deep-equal(preceding-sibling::xsd:element[@name = $n][1], .)"/>
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
    <xsl:template match="@positionName" mode="copy"/>
</xsl:stylesheet>
