<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd" version="2.0">
    <xsl:preserve-space elements="span"/>    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 4, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> JDN</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:output indent="yes" method="html"/>
    <xsl:variable name="MindMap" select="document('MTFXML REFACTOR.mm')"/>
    <xsl:param name="subj" select="'MESSSAGE TEXT FORMAT XML SCHEMA REFACTORING PROJECT'"/>
    <xsl:param name="date" select="'21 Oct 2015'"/>
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
    
    <xsl:template name="init">
        <xsl:result-document href="Refactor.html">
            <html>
                <head>
                    <style type="text/css">
                    <xsl:comment>
                  body {
                        width : 8in;
                        margin-left : auto;
                        margin-right : auto;
                        font:courier-new; 
                        font-size:12px;
                    }
                    div {
                        padding-bottom : 10px;
                    }
 
                    .tab {
                        padding-right : .2in;
                    }
                    .lvl2 {
                        display : inline;
                    }
                    .lvl3 {
                        display : inline;
                        padding-left : .3in;
                    }
                    .lvl4 {
                        display : inline;
                        padding-left : .6in;
                    }
                    .lvl5 {
                        display : inline;
                        padding-left : 1in;
                    }
                    .lvl6 {
                        display : inline;
                        padding-left : 1.4in;
                    }
                     .lvl7 {
                        display : inline;
                        wpadding-left : 1.8in;
                    }
                      .lvl8 {
                        display : inline;
                        padding-left : 2.2in;
                    }
                    .uline {
                        text-decoration : underline;
                    }
                    .ctr_title {
                        text-align : center;
                    }
                    .center
                    {
                        margin-left : auto;
                        margin-right : auto;
                        width : 100%;
                    }
                      P.pagebreak
                      {
                        page-break-before: always
                      }
                    </xsl:comment>
                </style>
                </head>
                <body>
                    <xsl:apply-templates select="$MindMap/*"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="node[parent::map]">
        <p style="text-align:center">Information Paper</p>
        <p style="text-align:right">
            <xsl:value-of select="$date"/>
        </p>
        <p>
            <span>Subj:<xsl:value-of select="$lvl2"/></span>
            <span>
                <xsl:value-of select="$subj"/>
            </span>
        </p>
        <xsl:apply-templates select="richcontent//p"/>
        <xsl:apply-templates select="richcontent//table"/>
        <div>
            <xsl:apply-templates select="node" mode="level2"/>
        </div>
    </xsl:template>
    <xsl:template match="node" mode="level2">
        <xsl:variable name="seq" select="count(preceding-sibling::node) + 1"/>
        <div>
            <span>
                <xsl:value-of select="concat($seq, '.')"/>
                <xsl:value-of select="$_2sp"/>
            </span>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span>
                        <span class="uline">
                            <xsl:value-of select="@TEXT"/>
                        </span>
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
                    <span class="uline">
                        <xsl:value-of select="@TEXT"/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </div>
        <div class="center">
            <xsl:apply-templates select="richcontent//table"/>
        </div>
        <xsl:apply-templates select="node" mode="level3"/>
    </xsl:template>
    <xsl:template match="node" mode="level3">
        <xsl:variable name="seq" select="count(preceding-sibling::node) + 1"/>
        <div>
            <span>
                <xsl:value-of select="$lvl3"/>
                <xsl:value-of select="concat(substring($lcase, $seq, 1), '.')"/>
                <xsl:value-of select="$_2sp"/>
            </span>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span><span><xsl:value-of select="@TEXT"/></span>.</span>
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
        <xsl:apply-templates select="node" mode="level4"/>
    </xsl:template>
    <xsl:template match="node" mode="level4">
        <xsl:variable name="seq" select="count(preceding-sibling::node) + 1"/>
        <div>
            <span>
                <xsl:value-of select="$lvl4"/>
                <xsl:value-of select="concat('(', $seq, ')')"/>
                <xsl:value-of select="$_2sp"/>
            </span>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span class="tab">
                        <span class="uline">
                            <xsl:value-of select="@TEXT"/>
                            <xsl:text>.</xsl:text>
                        </span>
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
        </div>
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
                    <span>
                        <span class="uline">
                            <xsl:value-of select="@TEXT"/>
                        </span>
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
        </div>
        <xsl:apply-templates select="node" mode="level6"/>
    </xsl:template>
    <xsl:template match="node" mode="level6">
        <xsl:variable name="seq" select="count(preceding-sibling::node) + 1"/>
        <div>
            <span>
                <xsl:value-of select="$lvl6"/>
                <span class="uline"><xsl:value-of select="$seq"/></span><xsl:text>.</xsl:text>
                <xsl:value-of select="$_2sp"/>
            </span>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span>
                        <span class="uline">
                            <xsl:value-of select="@TEXT"/>
                        </span>
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
        </div>
    </xsl:template>
    <xsl:template match="@TEXT" mode="nodetext">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="node">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="p">
        <xsl:value-of select="."/>
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
