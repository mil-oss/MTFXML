<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="allmtf" select="document('../../XSD/NIEM_MTF/refxsd/usmtf-ref.xsd')/*:schema"/>
    <xsl:variable name="outDir" select="'../../XSD/Analysis/samenames.xml'"/>

    <xsl:variable name="samenamelist">
        <xsl:for-each select="$allmtf//xs:element[@ref]">
            <xsl:variable name="r" select="@ref"/>
            <xsl:variable name="t" select="$allmtf//xs:element[@name = $r]/@type"/>
            <xsl:variable name="c" select="count(preceding-sibling::xs:element[@ref = $r])"/>
            <xsl:variable name="f" select="count(following-sibling::xs:element[@ref = $r])"/>
            <xsl:variable name="ordertxt">
                <xsl:choose>
                    <xsl:when test="$f != 0 and $c = 0">
                        <xsl:text>First</xsl:text>
                    </xsl:when>
                    <xsl:when test="$c = 1">
                        <xsl:text>Second</xsl:text>
                    </xsl:when>
                    <xsl:when test="$c = 2">
                        <xsl:text>Third</xsl:text>
                    </xsl:when>
                    <xsl:when test="$c = 3">
                        <xsl:text>Fourth</xsl:text>
                    </xsl:when>
                    <xsl:when test="$c = 4">
                        <xsl:text>Fifth</xsl:text>
                    </xsl:when>
                    <xsl:when test="$c = 5">
                        <xsl:text>Sixth</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="$f != 0 or $c != 0">
                <El name="{@ref}" type="{$t}" parent="{ancestor::*[@name][1]/@name}" order="{count(preceding-sibling::xs:element[@ref=$r])+1}" newname="{concat($ordertxt,@ref)}"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="{$outDir}">
            <SameNames>
                <xsl:for-each select="$samenamelist/*">
                    <xsl:variable name="n" select="@newname"/>
                    <xsl:if test="count(preceding-sibling::El[@newname = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </SameNames>
        </xsl:result-document>
    </xsl:template>



</xsl:stylesheet>
