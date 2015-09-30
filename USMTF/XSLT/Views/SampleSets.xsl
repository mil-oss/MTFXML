<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:mtf:mil:6040b"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:s="urn:mtf:mil:6040b:set"
    xmlns:ism="urn:us:gov:ic:ism:v2" xmlns:ICISM="urn:us:gov:ic:ism:v2"
    xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="sets" select="document('../XSD/Baseline_Schemas/sets.xsd')"/>

    <xsl:template match="/">
        <xsd:schema xmlns="urn:mtf:mil:6040b:set" xmlns:c="urn:mtf:mil:6040b:composite"
            xmlns:f="urn:mtf:mil:6040b:elemental" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
            xmlns:ism="urn:us:gov:ic:ism:v2" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
            xmlns:ICISM="urn:us:gov:ic:ism:v2" targetNamespace="urn:mtf:mil:6040b:set"
            elementFormDefault="unqualified" attributeFormDefault="unqualified" xml:lang="en-US">
            <xsd:import namespace="urn:mtf:mil:6040b:composite" schemaLocation="Baseline_Schemas/composites.xsd"/>
            <xsd:import namespace="urn:mtf:mil:6040b:elemental" schemaLocation="Baseline_Schemas/fields.xsd"/>
            <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="Baseline_Schemas/IC-ISM-v2.xsd"/>
            <xsl:apply-templates select="$sets/xsd:schema/xsd:complexType[xsd:sequence]"/>
            <xsl:apply-templates select="$sets/xsd:schema/xsd:complexType[not(xsd:sequence)][position()&lt;200]"/>
        </xsd:schema>
    </xsl:template>

    <xsl:template match="*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:copy-of select="normalize-space(.)"/>
    </xsl:template>
</xsl:stylesheet>
