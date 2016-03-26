<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="Norms" select="document('../../XSD/Normalized/NormalizedSimpleTypes.xsd')"/>

    <xsl:template name="main">
        <xsl:apply-templates select="$Norms/*"/>
    </xsl:template>

    <xsl:template match="xsd:simpleType">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="not(xsd:annotation)">
                    <xsd:annotation>
                        <xsd:documentation>Data definition required</xsd:documentation>
                    </xsd:annotation>
                    <xsl:apply-templates select="*"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:annotation">
        <xsl:copy copy-namespaces="no">
        <xsl:choose>
            <xsl:when test="not(xsd:documentation)">
                <xsd:documentation>Data definition required</xsd:documentation>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*"/>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:copy-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="xsd:enumeration/xsd:annotation">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="not(xsd:documentation)">
                    <xsl:element name="xsd:documentation">
                        <xsl:value-of select="xsd:appinfo/*:Enum/@dataItem"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="xsd:documentation"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="xsd:appinfo"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*:Enum">
        <xsl:element name="Enum">
            <xsl:apply-templates select="@*"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
