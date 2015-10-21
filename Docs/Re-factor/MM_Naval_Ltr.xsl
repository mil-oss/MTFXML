<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 4, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> JDN</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:output indent="yes" method="html"/>

    <xsl:variable name="MindMap" select="document('/home/jdn/Work/Dropbox/MTF%XML')"/>

    <xsl:variable name="lcase" select="'abcdefghijklmnopqrstuvwxyz'"/>

    <xsl:template match="/">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="*">
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
                        padding-left : 1.8in;
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
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="node[parent::map]">
        <p style="text-align:center">Information Paper</p>
        <p style="text-align:right">06 OCT 2014</p>
        <p>
            <span class="tab">Subj:</span>
            <span>MESSSAGE TEXT FORMAT XML SCHEMA REFACTORING PROJECT</span>
        </p>
        <xsl:apply-templates select="richcontent//p"/>
        <xsl:apply-templates select="richcontent//table"/>
        <div>
            <xsl:apply-templates select="node" mode="level2"/>
        </div>
    </xsl:template>

    <xsl:template match="node" mode="level2">
        <xsl:variable name="seq" select="count(preceding-sibling::node)+1"/>
        <div>
            <p class="lvl2 tab">
                <xsl:value-of select="$seq"/>.</p>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span class="tab"><span class="uline"><xsl:value-of select="@TEXT"
                        /></span>.</span>
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
        <div class="center">
            <xsl:apply-templates select="richcontent//table"/>
        </div>
        <xsl:apply-templates select="node" mode="level3"/>
    </xsl:template>

    <xsl:template match="node" mode="level3">
        <xsl:variable name="seq" select="count(preceding-sibling::node)+1"/>
        <div>
            <p class="lvl3 tab"><xsl:value-of select="substring($lcase,$seq,1)"/>.</p>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span class="tab"><span class="uline"><xsl:value-of select="@TEXT"
                        /></span>.</span>
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
        <xsl:variable name="seq" select="count(preceding-sibling::node)+1"/>
        <div>
            <p class="lvl4 tab">(<xsl:value-of select="$seq"/>)</p>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span class="tab"><span class="uline"><xsl:value-of select="@TEXT"
                        /></span>.</span>
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
        <xsl:variable name="seq" select="count(preceding-sibling::node)+1"/>
        <div>
            <p class="lvl5 tab">(<xsl:value-of select="substring($lcase,$seq,1)"/>)</p>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span class="tab"><span class="uline"><xsl:value-of select="@TEXT"
                        /></span>.</span>
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
        <xsl:variable name="seq" select="count(preceding-sibling::node)+1"/>
        <div>
            <p class="lvl6 tab"><span class="uline"><xsl:value-of select="$seq"/></span>.</p>
            <xsl:choose>
                <xsl:when test="child::richcontent">
                    <span class="tab"><span class="uline"><xsl:value-of select="@TEXT"
                        /></span>.</span>
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

    <xsl:template match="node[@TEXT='Information Exchange Requirements']" mode="level6">
        <xsl:variable name="seq" select="count(preceding-sibling::node)+1"/>
        <div>
            <p class="lvl6 tab"><span class="uline"><xsl:value-of select="$seq"/></span>.</p>
            <span>
                <xsl:value-of select="@TEXT"/>
            </span>
            <p/>
            <xsl:variable name="ier_tbl">
                <table style="font:courier-new; font-size:12px;width:100%" border="1">
                    <xsl:variable name="ier_totals">
                        <xsl:element name="totals"/>
                    </xsl:variable>
                    <tr style="text-align:center;font-weight:bold;">
                        <td colspan="2"/>
                        <td colspan="3" style="border:none">Averaged Link Budgets</td>
                    </tr>
                    <tr style="text-align:center;font-weight:bold;">
                        <td width="25%">IER</td>
                        <td width="40%">Networks</td>
                        <td width="11%">Company</td>
                        <td width="11%">Battalion</td>
                        <td width="11%">Brigade</td>
                    </tr>
                    <xsl:for-each select="node">
                        <xsl:variable name="TXT" select="@TEXT"/>
                        <xsl:variable name="co"
                            select="number(substring-before($IER_DOC//node[@TEXT=$TXT]/node[@TEXT='Averaged Link Budgets']//table/tr[2]/td[2]/p/text(),' M'))"/>
                        <xsl:variable name="bn"
                            select="number(substring-before($IER_DOC//node[@TEXT=$TXT]/node[@TEXT='Averaged Link Budgets']//table/tr[3]/td[2]/p/text(),' M'))"/>
                        <xsl:variable name="bd"
                            select="number(substring-before($IER_DOC//node[@TEXT=$TXT]/node[@TEXT='Averaged Link Budgets']//table/tr[4]/td[2]/p/text(),' M'))"/>
                        <tr style="text-align:center;">
                            <td style="text-align:left;">
                                <xsl:value-of select="$TXT"/>
                            </td>
                            <td style="text-align:left;">
                                <xsl:apply-templates
                                    select="$IER_DOC//node[@TEXT=$TXT]/node[@TEXT='Networks']//table/tr"
                                    mode="nets"/>
                            </td>
                            <td>
                                <span>
                                    <xsl:value-of select="$co"/>
                                </span>
                                <span> Mbps</span>
                            </td>
                            <td>
                                <span>
                                    <xsl:value-of select="$bn"/>
                                </span>
                                <span> Mbps</span>
                            </td>
                            <td>
                                <span>
                                    <xsl:value-of select="$bd"/>
                                </span>
                                <span> Mbps</span>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </xsl:variable>
            <xsl:copy-of select="$ier_tbl"/>
            <table style="font:courier-new; font-size:12px;width:100%" border="1">
                <tr style="text-align:center; font-weight:bold;">
                    <td width="65%" style="text-align:right; padding-right:5px;">
                        <span>Total link budgets not including LAN:</span>
                    </td>
                    <td width="11%">
                        <span>
                            <xsl:value-of
                                select="round-half-to-even(sum($ier_tbl//tr[not(td[1]/text()='Stored Raw Data')][position()>2]/td[3]/span[1]),2)"
                            />
                        </span>
                        <span> Mbps</span>
                    </td>
                    <td width="11%">
                        <span>
                            <xsl:value-of
                                select="round-half-to-even(sum($ier_tbl//tr[not(td[1]/text()='Stored Raw Data')][position()>2]/td[4]/span[1]),2)"
                            />
                        </span>
                        <span> Mbps</span>
                    </td>
                    <td width="11%">
                        <span>
                            <xsl:value-of
                                select="round-half-to-even(sum($ier_tbl//tr[not(td[1]/text()='Stored Raw Data')][position()>2]/td[5]/span[1]),2)"
                            />
                        </span>
                        <span> Mbps</span>
                    </td>
                </tr>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="@TEXT" mode="getiersummary">
        <xsl:variable name="TXT" select="."/>
        <tr style="text-align:center;">
            <td width="35%" style="text-align:left;">
                <xsl:value-of select="$TXT"/>
            </td>
            <td width="35%" style="text-align:left;">
                <xsl:apply-templates
                    select="$IER_DOC//node[@TEXT=$TXT]/node[@TEXT='Networks']//table/tr" mode="nets"
                />
            </td>
            <td width="10%">
                <xsl:value-of
                    select="$IER_DOC//node[@TEXT=$TXT]/node[@TEXT='Averaged Link Budgets']//table/tr[2]/td[2]/p"
                />
            </td>
            <td width="10%">
                <xsl:value-of
                    select="$IER_DOC//node[@TEXT=$TXT]/node[@TEXT='Averaged Link Budgets']//table/tr[3]/td[2]/p"
                />
            </td>
            <td width="10%">
                <xsl:value-of
                    select="$IER_DOC//node[@TEXT=$TXT]/node[@TEXT='Averaged Link Budgets']//table/tr[4]/td[2]/p"
                />
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="tr[1]" mode="nets"/>

    <xsl:template match="tr" mode="nets">
        <span>
            <xsl:value-of select="td[1]//p"/>
        </span>
        <xsl:if test="following-sibling::tr">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="node[@TEXT='Communication Networks']" mode="level5">
        <div>
            <table style="font:courier-new; font-size:12px;width:100%" border="1">
                <tr style="text-align: center">
                    <td width="10%">
                        <p> NET </p>
                    </td>
                    <td width="5%">
                        <p> MDA </p>
                    </td>
                    <td width="5%">
                        <p> SB </p>
                    </td>
                    <td width="5%">
                        <p> LM </p>
                    </td>
                    <td width="5%">
                        <p> EMO </p>
                    </td>
                    <td width="5%">
                        <p> C2E </p>
                    </td>
                    <td width="5%">
                        <p> UAS </p>
                    </td>
                    <td width="60%">
                        <p> Remarks </p>
                    </td>
                </tr>
                <xsl:apply-templates select="node//tr[2]" mode="colorcode"/>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="tr" mode="colorcode">
        <tr style="text-align:center;">
            <xsl:apply-templates select="@*" mode="colorcode"/>
            <xsl:apply-templates select="td" mode="colorcode"/>
        </tr>
    </xsl:template>

    <xsl:template match="td" mode="colorcode">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="td[normalize-space(*/text())='S']" mode="colorcode">
        <td bgcolor="green" style="color:white;">
            <xsl:value-of select="p"/>
        </td>
    </xsl:template>

    <xsl:template match="td[contains(.,'NR')]" mode="colorcode">
        <td bgcolor="gray" style="color:white;">
            <xsl:value-of select="p"/>
        </td>
    </xsl:template>

    <xsl:template match="td[contains(.,'NS')]" mode="colorcode">
        <td bgcolor="yellow">
            <xsl:value-of select="p"/>
        </td>
    </xsl:template>

    <xsl:template match="td[contains(.,'NP')]" mode="colorcode">
        <td bgcolor="red">
            <xsl:value-of select="p"/>
        </td>
    </xsl:template>

    <xsl:template match="@*" mode="colorcode">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="node[@TEXT='Networks']" mode="level6">
        <xsl:variable name="seq" select="count(preceding-sibling::node)+1"/>
        <div style="font:courier-new; font-size:12px;width:100%" border="1">
            <p class="lvl6 tab"><span class="uline"><xsl:value-of select="$seq"/></span>.</p>
            <span>
                <xsl:value-of select="@TEXT"/>
            </span>
        </div>
        <xsl:apply-templates
            select="parent::node/preceding-sibling::node[@TEXT='Communication Networks']/node"
            mode="commnets"/>
    </xsl:template>

    <xsl:template match="node" mode="commnets">
        <xsl:variable name="seq" select="count(preceding-sibling::node)+1"/>
        <div style="font:courier-new; font-size:12px;width:100%" border="1">
            <p class="lvl7 tab"><span class="uline"><xsl:value-of select="substring($lcase,$seq,1)"
                    /></span>.</p>
            <span class="tab"><span><xsl:value-of select="@TEXT"/></span>.</span>
        </div>
        <xsl:apply-templates select="node[*//@TEXT]" mode="nettext"/>
    </xsl:template>

    <xsl:template match="node" mode="nettext">
        <xsl:variable name="seq" select="count(preceding-sibling::node)+1"/>
        <div style="font:courier-new; font-size:12px;width:100%" border="1">
            <p class="lvl8 tab">(<span class="uline"><xsl:value-of select="$seq"/></span>)</p>
            <span class="tab"><span class="uline"><xsl:value-of select="@TEXT"/></span>.</span>
            <xsl:apply-templates select="node/@TEXT" mode="nodetext"/>
        </div>
    </xsl:template>

    <xsl:template match="@TEXT" mode="nodetext">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="node[@TEXT='Platforms']" mode="level5">
        <xsl:variable name="seq" select="count(preceding-sibling::node)+1"/>
        <div>
            <p class="lvl5 tab">(<xsl:value-of select="substring($lcase,$seq,1)"/>)</p>
            <span>
                <xsl:value-of select="@TEXT"/>
                <xsl:text>:  </xsl:text>
                <xsl:for-each select="node">
                    <xsl:value-of select="@TEXT"/>
                    <xsl:if test="following-sibling::node">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </span>
            <p/>
        </div>
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

    <xsl:template match="node[@TEXT='Acronyms']"/>
    <xsl:template match="head"/>
    <xsl:template match="@POSITION"/>
    <xsl:template match="@ID"/>
    <xsl:template match="@CREATED"/>
    <xsl:template match="@MODIFIED"/>
    <xsl:template match="@HGAP"/>
    <xsl:template match="@VSHIFT"/>


</xsl:stylesheet>
