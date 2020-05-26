<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="msgmap_xsd"
        select="document('../../XSD/NIEM_MTF/refxsd/maps/usmtf-msgsmaps.xml')"/>
    <xsl:variable name="segmap_xsd"
        select="document('../../XSD/NIEM_MTF/refxsd/maps/usmtf-segmntmaps.xml')"/>
    <xsl:variable name="setmap_xsd"
        select="document('../../XSD/NIEM_MTF/refxsd/maps/usmtf-setmaps.xml')"/>

    <xsl:variable name="changenames">
        <xsl:variable name="all">
            <xsl:apply-templates select="$msgmap_xsd//Element" mode="chg"/>
            <xsl:apply-templates select="$segmap_xsd//Element" mode="chg"/>
            <xsl:apply-templates select="$setmap_xsd//Element" mode="chg"/>
        </xsl:variable>
        <xsl:for-each select="$all/*">
            <xsl:sort select="@mtfname"/>
            <xsl:variable name="m" select="@mtfname"/>
            <xsl:variable name="t" select="@mtftype"/>
            <xsl:variable name="n" select="@niemame"/>
            <xsl:variable name="nt" select="@niemtype"/>
            <xsl:variable name="p" select="@mtfparent"/>
            <xsl:if test="count(preceding-sibling::Change[@mtfname = $m][@mtftype = $t][@niemame = $n][@niemtype = $nt][@mtfparent = $p]) = 0">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="*" mode="chg">
        <xsl:variable name="p" select="@messagename | @segmentname | @setname"/>
        <xsl:variable name="m" select="@mtfname"/>
        <xsl:variable name="t" select="@mtftype"/>
        <xsl:variable name="n" select="@niemelementname"/>
        <xsl:variable name="nt" select="@niemtype"/>
        <xsl:if test="string($m) != string($n)">
            <Change mtfname="{$m}" mtftype="{$t}" niemame="{$n}" niemtype="{$nt}" mtfparent="{$p}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="main">
        <xsl:result-document href="../../XSD/Analysis/Rules/allchanges.xml">
            <Changes>
                <xsl:copy-of select="$changenames"/>
            </Changes>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*" mode="addniemname">
        <xsl:copy>
            <xsl:copy-of select="@mtfname"/>
            <xsl:variable name="pname">
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[@mtfname]">
                        <xsl:value-of select="preceding-sibling::*[@mtfname][1]/@mtfname"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="parent::Rule/@msg"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!--<xsl:attribute name="parentname" select="$pname"/>-->
            <xsl:attribute name="niemname">
                <xsl:call-template name="niemchg">
                    <xsl:with-param name="mname" select="@mtfname"/>
                    <xsl:with-param name="pname" select="$pname"/>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    <xsl:template name="niemchg">
        <xsl:param name="mname"/>
        <xsl:param name="pname"/>
        <xsl:choose>
            <xsl:when test="$msgmap_xsd//Element[@mtfname = $mname][@messagename = $pname]">
                <xsl:value-of
                    select="$msgmap_xsd//Element[@mtfname = $mname][@messagename = $pname]/@niemelementname"/>
            </xsl:when>
            <xsl:when test="$segmap_xsd//Element[@mtfname = $mname][@segmentname = $pname]">
                <xsl:value-of
                    select="$segmap_xsd//Element[@mtfname = $mname][@segmentname = $pname]/@niemelementname"/>
            </xsl:when>
            <xsl:when test="$setmap_xsd//Element[@mtfname = $mname][@setname= $pname]">
                <xsl:value-of
                    select="$setmap_xsd//Element[@mtfname = $mname][@setname = $pname]/@niemelementname"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$mname"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

</xsl:stylesheet>
