<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="Msgs" select="document('../../XSD/GoE_Schema/GoE_messages.xsd')"/>
    <xsl:variable name="Sets" select="document('../../XSD/GoE_Schema/GoE_sets.xsd')"/>
    <xsl:variable name="Segments" select="document('../../XSD/GoE_Schema/GoE_segments.xsd')"/>
    <xsl:variable name="output" select="'../../XSD/Normalized/non_globals.xsd'"/>

    <xsl:variable name="nonGlobals">
        <xsl:apply-templates select="$Sets//*/xsd:element[@name]"/>
        <!--        <xsl:apply-templates select="$Segments//*/xsd:element[@name]"/>-->
        <!--        <xsl:apply-templates select="$Msgs/*/*//xsd:element[@name]"/>-->
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="{$output}">
            <xsd:schema xml:lang="en-US" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns="urn:mtf:mil:6040b:goe:mtf" targetNamespace="urn:mtf:mil:6040b:goe:sets"
                xmlns:field="urn:mtf:mil:6040b:goe:fields" xmlns:set="urn:mtf:mil:6040b:goe:sets"
                xmlns:seg="urn:mtf:mil:6040b:goe:segments" xmlns:ism="urn:us:gov:ic:ism:v2"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:mtf:mil:6040b:goe:fields" schemaLocation="GoE_fields.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:goe:sets" schemaLocation="GoE_sets.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:goe:segments"
                    schemaLocation="GoE_segments.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:element name="Non_Global_Set_Elements">
                    <xsd:complexType>
                        <xsd:sequence>
                            <xsl:for-each select="$nonGlobals/*">
                                <xsl:sort select="@name"/>
                                <xsl:variable name="n" select="@name"/>
                                <xsl:if test="not(deep-equal(preceding-sibling::xsd:element[@name = $n][1],.))">
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsd:sequence>
                    </xsd:complexType>
                </xsd:element>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xsd:element">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="copy">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="@minOccurs" mode="copy"/>
    <xsl:template match="@maxOccurs" mode="copy"/>
    <xsl:template match="xsd:annotation" mode="copy"/>

</xsl:stylesheet>
