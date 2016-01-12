<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd" version="2.0">
    <xsl:preserve-space elements="span"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 12, 2016</xd:p>
            <xd:p><xd:b>Author:</xd:b> JDN</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:output indent="yes" method="html"/>
    <xsl:param name="src" select="'MTF XML REFACTOR PROCESS.mm'"/>
    <xsl:param name="subj" select="'MTF XML REFACTOR PROCESS'"/>
    <xsl:param name="date" select="'Jan 16 2016'"/>
    <xsl:param name="output" select="'MTF XML REFACTOR PROCESS.md'"/>
    <xsl:variable name="lcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="_2sp">
        <xsl:text>&#160;&#160;</xsl:text>
    </xsl:variable>
    <xsl:variable name="lvl2">
        <xsl:text>&#160;&#160;&#160;</xsl:text>
    </xsl:variable>
    <xsl:variable name="lvl3">
        <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
    </xsl:variable>
    <xsl:variable name="lvl4">
        <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
    </xsl:variable>
    <xsl:variable name="lvl5">
        <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
    </xsl:variable>
    <xsl:variable name="lvl6">
        <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
    </xsl:variable>
    <xsl:variable name="lvl7">
        <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
    </xsl:variable>
    <xsl:variable name="rslt">
        <xsl:apply-templates select="document($src)/*/*"/>
    </xsl:variable>
    <xsl:template name="main">
        <xsl:result-document href="{$output}">
            <xsl:copy-of select="$rslt"/>
        </xsl:result-document>
        <xsl:copy-of select="$rslt"/>
    </xsl:template>
    <xsl:template match="node[parent::map]"> ###**<xsl:value-of select="$subj"/>** <xsl:apply-templates select="richcontent//p"/>
        <xsl:apply-templates select="richcontent//table"/>
        <xsl:apply-templates select="node" mode="level2"/>
    </xsl:template>
    <xsl:template match="node" mode="level2">
        <xsl:variable name="seq" select="count(preceding-sibling::node) + 1"/>
        <p>
            <span>
                <xsl:value-of select="concat($seq, '.')"/>
                <xsl:value-of select="$_2sp"/>
            </span>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span>
                        <u>
                            <xsl:value-of select="@TEXT"/>
                        </u>
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="$_2sp"/>
                    </span>
                    <xsl:variable name="txt">
                        <xsl:apply-templates select="richcontent//body/p"/>
                    </xsl:variable>
                    <span>
                        <xsl:value-of select="normalize-space($txt)"/>
                    </span>
                    <xsl:text>.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <u>
                        <xsl:value-of select="@TEXT"/>
                    </u>
                </xsl:otherwise>
            </xsl:choose>
        </p>
        <xsl:apply-templates select="node" mode="level3"/>
    </xsl:template>
    <xsl:template match="node" mode="level3">
        <xsl:variable name="seq" select="count(preceding-sibling::node) + 1"/>
        <p>
            <span>
                <xsl:value-of select="$lvl3"/>
                <xsl:value-of select="concat(substring($lcase, $seq, 1), '.')"/>
                <xsl:value-of select="$_2sp"/>
            </span>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span>
                        <u>
                            <xsl:value-of select="@TEXT"/>
                        </u>
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="$_2sp"/>
                    </span>
                    <xsl:variable name="txt">
                        <xsl:apply-templates select="richcontent//body/p"/>
                    </xsl:variable>
                    <span>
                        <xsl:value-of select="normalize-space($txt)"/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <span>
                        <xsl:value-of select="@TEXT"/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </p>
        <xsl:apply-templates select="node" mode="level4"/>
    </xsl:template>
    <xsl:template match="node" mode="level4">
        <xsl:variable name="seq" select="count(preceding-sibling::node) + 1"/>
        <p>
            <span>
                <xsl:value-of select="$lvl4"/>
                <xsl:value-of select="concat('(', $seq, ')')"/>
                <xsl:value-of select="$_2sp"/>
            </span>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span>
                        <u>
                            <xsl:value-of select="@TEXT"/>
                        </u>
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="$_2sp"/>
                    </span>
                    <xsl:variable name="txt">
                        <xsl:apply-templates select="richcontent//body/p"/>
                    </xsl:variable>
                    <span>
                        <xsl:value-of select="normalize-space($txt)"/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <span>
                        <xsl:value-of select="@TEXT"/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </p>
        <xsl:apply-templates select="node" mode="level5"/>
    </xsl:template>
    <xsl:template match="node" mode="level5">
        <xsl:variable name="seq" select="count(preceding-sibling::node) + 1"/>
        <div>
            <span>
                <xsl:value-of select="$lvl5"/>
                <xsl:value-of select="concat('(', substring($lcase, $seq, 1), ')')"/>
                <xsl:value-of select="$_2sp"/>
            </span>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <u>
                        <xsl:value-of select="@TEXT"/>
                    </u>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="$_2sp"/>
                    <xsl:variable name="txt">
                        <xsl:apply-templates select="richcontent//body/p"/>
                    </xsl:variable>
                    <span>
                        <xsl:value-of select="normalize-space($txt)"/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <span>
                        <xsl:value-of select="@TEXT"/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </div>
        <xsl:apply-templates select="node" mode="level6"/>
    </xsl:template>
    <xsl:template match="node" mode="level6">
        <xsl:variable name="seq" select="count(preceding-sibling::node) + 1"/>
        <p>
            <span>
                <xsl:value-of select="$lvl6"/>
                <u>
                    <xsl:value-of select="$seq"/>
                </u>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="$_2sp"/>
            </span>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span>
                        <u>
                            <xsl:value-of select="@TEXT"/>
                        </u>
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="$_2sp"/>
                    </span>
                    <xsl:variable name="txt">
                        <xsl:apply-templates select="richcontent//body/p"/>
                    </xsl:variable>
                    <span>
                        <xsl:value-of select="normalize-space($txt)"/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <span>
                        <xsl:value-of select="@TEXT"/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </p>
    </xsl:template>
    <xsl:template match="@TEXT" mode="nodetext">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="node">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="p">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    <xsl:template match="table">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="head"/>
    <xsl:template match="@POSITION"/>
    <xsl:template match="@ID"/>
    <xsl:template match="@CREATED"/>
    <xsl:template match="@MODIFIED"/>
    <xsl:template match="@HGAP"/>
    <xsl:template match="@VSHIFT"/>
</xsl:stylesheet>
