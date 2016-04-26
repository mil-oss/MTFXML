<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:set="urn:mtf:mil:6040b:goe:sets" xmlns:segment="urn:mtf:mil:6040b:goe:segments"
    exclude-result-prefixes="xsd" version="2.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:variable name="segments" select="document('../../XSD/GoE_Schema/GoE_segments.xsd')"/>
    
    <xsl:variable name="no_fixed_segments" select="'../../XSD/GoE_Schema/GoE_segments_no_fixed.xsd'"/>
       
    <xsl:template name="main">
        <xsl:result-document href="{$no_fixed_segments}">
            <xsl:apply-templates select="$segments/*" mode="copy"/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="*" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="text()" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*" mode="copy">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="text()" mode="copy">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <xsl:template match="xsd:element[@fixed]" mode="copy">
        <xsd:complexType name="{concat(@name,'Type')}">
            <xsl:copy-of select="xsd:annotation"/>
            <xsd:simpleContent>
                <xsd:restriction base="field:FieldEnumeratedBaseType">
                    <xsd:enumeration value="{@fixed}">
                        <xsd:annotation>
                            <xsd:documentation>
                            <xsl:value-of select="concat(@fixed,' fixed value')"/>
                            </xsd:documentation>
                        </xsd:annotation>
                    </xsd:enumeration>
                </xsd:restriction>
            </xsd:simpleContent>
        </xsd:complexType>
        <xsd:element name="{@name}" type="{concat(@name,'Type')}">
            <xsl:copy-of select="xsd:annotation"/>
        </xsd:element>
    </xsl:template>
    
</xsl:stylesheet>