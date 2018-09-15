<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">


    <xsl:template name="main">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="/">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="identity"/>
            <xsl:apply-templates select="text()" mode="identity"/>
            <xsl:apply-templates select="*" mode="identity"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>


    <xsl:template match="*" mode="identity">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="identity"/>
            <xsl:apply-templates select="text()" mode="identity"/>
            <xsl:apply-templates select="*" mode="identity"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="identity">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="text()" mode="identity">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="xs:complexType[not(ends-with(@name, 'Type'))]">
        <xsl:attribute name="name">
            <xsl:value-of select="concat(., 'Type')"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="xs:simpleType[not(ends-with(@name, 'SimpleType'))]">
        <xsl:variable name="newname">
            <xsl:choose>
                <xsl:when test="ends-with(@name, 'Type')">
                    <xsl:value-of
                        select="concat(substring(@name, string-length(@name) - 3), 'SimpleType')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(@name, 'Type')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="{$newname}"/>
            <xsl:apply-templates select="@*[not(name()='name')]" mode="identity"/>
            <xsl:apply-templates select="*" mode="identity"/>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>
