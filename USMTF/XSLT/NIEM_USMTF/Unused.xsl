<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:inf="urn:mtf:mil:6040b:appinfo" exclude-result-prefixes="xs inf" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!--Tests for Generated XML Schema-->

    <xsl:variable name="srcpath" select="'../../XSD/NIEM_MTF/refxsd/'"/>
    <xsl:variable name="Outdir" select="'../../XSD/Test/'"/>
    <xsl:variable name="REFMTF" select="document(concat($srcpath, 'usmtf-ref.xsd'))"/>

    <xsl:variable name="unusedEl">
        <xsl:apply-templates select="$REFMTF/xs:schema/xs:element" mode="unused"/>
    </xsl:variable>
   
    <xsl:variable name="unassignedSG">
        <xsl:apply-templates select="$REFMTF/xs:schema//inf:Choice/inf:Element" mode="unassigned"/>
    </xsl:variable>


    
    <xsl:template name="main">
        <xsl:result-document href="{concat($Outdir,'Tests.xml')}">
            <Tests>
                <UnusedElements qty="{count($unusedEl/*)}">
                    <xsl:copy-of select="$unusedEl"/>
                </UnusedElements>
                <UnassignedSubGrps qty="{count($unassignedSG/*)}">
                    <xsl:copy-of select="$unassignedSG"/>
                </UnassignedSubGrps>
            </Tests>
        </xsl:result-document>
    </xsl:template>
    
    <!--List Unused Elements-->
    <xsl:template match="xs:element" mode="unused">
        <xsl:variable name="n" select="@name"/>
        <xsl:choose>
            <xsl:when test="//xs:schema/xs:complexType/xs:complexContent/xs:extension/xs:sequence/xs:element[@ref = $n]"/>
            <xsl:when test="//xs:schema/xs:complexType/xs:complexContent/xs:extension/xs:sequence/xs:element/xs:annotation/xs:appinfo/inf:Choice/inf:Element[@name = $n]"/>
            <xsl:otherwise>
                <element name="{@name}" type="{@type}">
                    <xsl:copy-of select="@substitutionGroup"/>
                </element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--List Unmatched Substitution Groups-->
    <xsl:template match="inf:Element" mode="unassigned">
        <xsl:variable name="sg" select="parent::inf:Choice/@substitutionGroup"/>
        <xsl:variable name="n" select="@name"/>
        <xsl:choose>
            <xsl:when test="//xs:schema/xs:element[@substitutionGroup = $sg]"/>
            <xsl:otherwise>
                <element name="{@name}" type="{@type}">
                    <xsl:copy-of select="@substitutionGroup"/>
                </element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



</xsl:stylesheet>
