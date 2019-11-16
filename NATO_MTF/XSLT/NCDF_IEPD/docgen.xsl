<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2019 JD NEUSHUL
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="xml" indent="no" xml:space="preserve"/>

    <!-- 
    input:  /iepd/xml/xsd/iep.xsd
    output: /iepd/xml/instance/test_instance.xml
   -->

    <xsl:variable name="lcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="_1sp">
        <xsl:text>&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="_2sp">
        <xsl:text>&#32;&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="Lvl2">
        <xsl:text/>
    </xsl:variable>
    <xsl:variable name="Lvl3">
        <xsl:text>&#32;&#32;&#32;&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="Lvl4">
        <xsl:text>&#32;&#32;&#32;&#32;&#32;&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="Lvl5">
        <xsl:text>&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="Lvl6">
        <xsl:text>&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="Lvl7">
        <xsl:text>&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="Lvl8">
        <xsl:text>&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="Lvl9">
        <xsl:text>&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="Lvl10">
        <xsl:text>&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="Lvl11">
        <xsl:text>&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="Lvl12">
        <xsl:text>&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;&#32;</xsl:text>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:call-template name="main"/>
    </xsl:template>

    <xsl:template name="main">
        <!--<xsl:result-document href="{$Out}">-->
        <xsl:variable name="t" select="//xs:schema/xs:annotation/xs:appinfo//@type"/>
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <style type="text/css">
                    body {
                        width: 7in;
                        padding: .75in;
                        font-family: "Courier New", Courier, monospace;
                        font-size: .9em;
                        border: thin black solid;
                    }
                    pre {
                        white-space: pre-wrap; /* css-3 */
                        white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
                        white-space: -pre-wrap; /* Opera 4-6 */
                        white-space: -o-pre-wrap; /* Opera 7 */
                        word-wrap: break-word;
                        font-family: "Courier New", Courier, monospace;
                        font-size: .9em;
                    }
                    
                    .tab {
                        padding-right: .2in;
                    }
                    .lvl2 {
                        display: inline;
                    }
                    .lvl3 {
                        display: inline;
                        padding-left: .3in;
                    }
                    .lvl4 {
                        display: inline;
                        padding-left: .6in;
                    }
                    .lvl5 {
                        display: inline;
                        padding-left: 1in;
                    }
                    .lvl6 {
                        display: inline;
                        padding-left: 1.4in;
                    }
                    .lvl7 {
                        display: inline;
                        padding-left: 1.8in;
                    }
                    .lvl8 {
                        display: inline;
                        padding-left: 2.2in;
                    }
                    .lvl9 {
                        display: inline;
                        padding-left: 2.6in;
                    }
                    .uline {
                        text-decoration: underline;
                    }
                    .ctr_title {
                        text-align: center;
                    }
                    .center
                    {
                        margin-left: auto;
                        margin-right: auto;
                        width: 100%;
                    }
                    P.pagebreak
                    {
                        page-break-before: always
                    }</style>
            </head>
            <body>
                <pre><div style="text-align:center">IC XML</div></pre>
                <xsl:choose>
                    <xsl:when test="//xs:schema/xs:annotation/xs:appinfo/*/@type">
                        <xsl:apply-templates select="xs:schema/xs:complexType[@name = $t]" mode="root"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="xs:schema/xs:complexType" mode="list"/>
                    </xsl:otherwise>
                </xsl:choose>
            </body>
        </html>
        <!--</xsl:result-document>-->
    </xsl:template>

    <xsl:template match="*" mode="root">
        <xsl:variable name="n" select="//xs:schema/xs:annotation/xs:appinfo/*/@name"/>
        <xsl:variable name="d" select="normalize-space(//xs:schema/xs:annotation/xs:documentation)"/>
        <pre>
            <div style="text-align:center"><b><span><xsl:value-of select="$n"/></span></b></div>
            <div style="text-align:center"><span><xsl:value-of select="$d"/></span></div>
        </pre>
        <xsl:apply-templates select="./*" mode="ref">
            <xsl:with-param name="lvl" select="2"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*" mode="list">
        <xsl:variable name="seq" select="count(preceding-sibling::xs:complexType) + 1"/>
        <xsl:if test="not(substring(@ref, string-length(@ref) - string-length('AugmentationPoint') + 1) = 'AugmentationPoint')">
            <xsl:variable name="d" select="xs:annotation/xs:documentation"/>
            <xsl:variable name="spacing" select="$Lvl2"/>
            <xsl:variable name="n" select="@name | @ref"/>
            <xsl:variable name="st" select=".//@base"/>
            <xsl:variable name="styp" select="//xs:schema/*[@name = $st]"/>
            <xsl:variable name="stb" select="$styp//@base"/>
            <xsl:variable name="sstyp" select="//xs:schema/*[@name = $stb]"/>
            <xsl:variable name="sstb" select="$sstyp//@base"/>
            <xsl:variable name="ssstyp" select="//xs:schema/*[@name = $stb]"/>
            <xsl:variable name="bullet" select="concat($seq, '.', $_2sp)"/>
            <pre>
                <div><xsl:value-of select="$bullet"/><u><xsl:value-of select="$n"/></u><xsl:value-of select="concat('.', $_2sp)"/><span><xsl:value-of select="normalize-space($d)"/></span></div>
                <xsl:if test="string-length($st) &gt; 0">
                    <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/><xsl:text>simpletype = </xsl:text><xsl:value-of select="$st"/></div>
                </xsl:if>
                <xsl:if test="string-length($stb) &gt; 0 or string-length($sstb) &gt; 0">
                    <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/><xsl:text>base = </xsl:text><xsl:value-of select="$stb | $sstb"/></div>
                 </xsl:if>   
            </pre>
            <xsl:apply-templates select=".//xs:sequence/xs:element" mode="ref">
                <xsl:with-param name="lvl" select="3"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="ref">
        <xsl:param name="lvl"/>
        <xsl:param name="typelist"/>
        <xsl:apply-templates select="*" mode="ref">
            <xsl:with-param name="lvl" select="$lvl"/>
            <xsl:with-param name="typelist" select="$typelist"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="xs:choice" mode="ref">
        <xsl:param name="lvl"/>
        <xsl:param name="typelist"/>
        <xsl:variable name="sg" select=".//Choice/@substitutionGroup"/>
        <xsl:variable name="seq" select="count(preceding-sibling::*[not(name() = 'xs:annotation')]) + 1"/>
        <xsl:variable name="bullet">
            <xsl:call-template name="makeBullet">
                <xsl:with-param name="lvl" select="$lvl"/>
                <xsl:with-param name="seq" select="$seq"/>
            </xsl:call-template>
        </xsl:variable>
        <pre>
            <div><xsl:value-of select="$bullet"/><xsl:value-of select="$sg"/></div>
            <xsl:if test="not(contains($typelist, concat('-', $sg)))">
              <xsl:apply-templates select="*" mode="ref">
                    <xsl:with-param name="lvl" select="$lvl + 1"/>
                    <xsl:with-param name="typelist" select="concat($typelist, '-', $sg)"/>
              </xsl:apply-templates>
            </xsl:if>
         </pre>
    </xsl:template>

    <xsl:template match="xs:element" mode="ref">
        <xsl:param name="lvl"/>
        <xsl:param name="typelist"/>
        <xsl:variable name="seq" select="count(preceding-sibling::xs:element) + 1"/>
        <xsl:if test="not(substring(@ref, string-length(@ref) - string-length('AugmentationPoint') + 1) = 'AugmentationPoint')">
            <xsl:variable name="r" select="@ref"/>
            <xsl:variable name="e" select="//xs:schema/xs:element[@name = $r]"/>
            <xsl:variable name="d" select="$e/xs:annotation/xs:documentation"/>
            <!--<xsl:variable name="n" select="$e/xs:annotation/xs:appinfo/*/@name"/>-->
            <xsl:variable name="n" select="@name | @ref"/>
            <xsl:variable name="xn">
                <xsl:apply-templates select="$e/xs:annotation/xs:appinfo/*/@xmlname" mode="txt"/>
            </xsl:variable>
            <xsl:variable name="t" select="$e/@type"/>
            <xsl:variable name="ctyp" select="//xs:schema/*[@name = $t]"/>
            <xsl:variable name="b">
                <xsl:if test="$ctyp//@base != 'structures:ObjectType'">
                    <xsl:value-of select="$ctyp//@base"/>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="etyp" select="//xs:schema/*[@name = $b]"/>
            <xsl:variable name="bse">
                <xsl:value-of select="$etyp//@base"/>
            </xsl:variable>
            <xsl:variable name="estyp" select="//xs:schema/*[@name = $bse]"/>
            <xsl:variable name="spacing">
                <xsl:call-template name="makeSpace">
                    <xsl:with-param name="lvl" select="$lvl"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="bullet">
                <xsl:call-template name="makeBullet">
                    <xsl:with-param name="lvl" select="$lvl"/>
                    <xsl:with-param name="seq" select="$seq"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="ty">
                <xsl:apply-templates select="$e/@type" mode="txt"/>
            </xsl:variable>
            <xsl:variable name="minoccur">
                <xsl:apply-templates select="@minOccurs" mode="txt"/>
            </xsl:variable>
            <xsl:variable name="maxoccur">
                <xsl:apply-templates select="@maxOccurs" mode="txt"/>
            </xsl:variable>
            <xsl:variable name="regex">
                <xsl:apply-templates select="$etyp/xs:restriction/xs:pattern/@value" mode="txt"/>
            </xsl:variable>
            <xsl:variable name="maxlen">
                <xsl:apply-templates select="$etyp/xs:restriction/xs:maxLength/@value" mode="txt"/>
            </xsl:variable>
            <xsl:variable name="length">
                <xsl:apply-templates select="$etyp/xs:restriction/xs:length/@value" mode="txt"/>
            </xsl:variable>
            <xsl:variable name="rdf">
                <xsl:apply-templates select="$etyp/xs:annotation/xs:appinfo/*/@rdf" mode="txt"/>
            </xsl:variable>
            <pre>
                <div><xsl:value-of select="$bullet"/><u><xsl:value-of select="$n"/></u><xsl:value-of select="concat('.', $_2sp)"/><span><xsl:value-of select="normalize-space($d)"/></span></div>
                <xsl:if test="string-length($ty) &gt; 0">
                    <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/><xsl:value-of select="$ty"/></div>
                </xsl:if>
                <xsl:if test="string-length($b) &gt; 0">
                    <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/><xsl:text>simpletype = </xsl:text><xsl:value-of select="$b"/></div>
                </xsl:if>
                <xsl:if test="string-length($bse) &gt; 0">
                    <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/><xsl:text>base = </xsl:text><xsl:value-of select="$bse"/></div>
                 </xsl:if>   
                <xsl:if test="string-length($minoccur) &gt; 0">
                    <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/><xsl:value-of select="$minoccur"/></div>
                </xsl:if>
                <xsl:if test="string-length($maxoccur) &gt; 0">
                    <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/><xsl:value-of select="$maxoccur"/></div>
                </xsl:if>
                <xsl:if test="string-length($maxlen) &gt; 0">
                    <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/><xsl:value-of select="$maxlen"/></div>
                </xsl:if>
                <xsl:if test="string-length($length) &gt; 0">
                    <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/><xsl:value-of select="$length"/></div>
                </xsl:if>
                <xsl:if test="string-length($regex) &gt; 0">
                    <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/><xsl:value-of select="$regex"/></div>
                </xsl:if>
                <xsl:if test="$etyp//xs:restriction/xs:enumeration or $estyp//xs:restriction/xs:enumeration">
                    <xsl:choose>
                        <xsl:when test="contains($typelist, concat('-', $etyp/@name))">
                              <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/>Enumerations: ...</div>
                        </xsl:when>
                        <xsl:when test="contains($typelist, concat('-', $estyp/@name))">
                              <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/>Enumerations: ...</div>
                        </xsl:when>
                        <xsl:when test="$etyp//xs:restriction/xs:enumeration">
                             <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/>Enumerations: ...</div>
                            <xsl:for-each select="$etyp//xs:restriction/xs:enumeration">
                               <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/><xsl:value-of select="concat(@value, $_2sp, ' - ', $_2sp)"/><xsl:value-of select="xs:annotation/xs:documentation"/></div>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="$estyp//xs:restriction/xs:enumeration">
                             <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/>Enumerations: ...</div>
                           <xsl:for-each select="$estyp//xs:restriction/xs:enumeration">
                               <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/><xsl:value-of select="concat(@value, $_2sp, ' - ', $_2sp)"/><xsl:value-of select="xs:annotation/xs:documentation"/></div>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>
                <xsl:for-each select="$e/xs:annotation/xs:appinfo/Choice">
                    <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp)"/>Choice:</div>
                    <xsl:for-each select="$e/xs:annotation/xs:appinfo/Choice/Element">
                        <div><xsl:value-of select="concat($spacing, $_2sp, $_2sp, $_2sp, $_2sp)"/><xsl:value-of select="@name"/></div>
                    </xsl:for-each>
                </xsl:for-each>
            </pre>
            <xsl:choose>
                <xsl:when test="$ctyp//xs:element">
                    <xsl:if test="not(contains($typelist, concat('-', $t)))">
                        <xsl:apply-templates select="$ctyp/*" mode="ref">
                            <xsl:with-param name="lvl" select="$lvl + 1"/>
                            <xsl:with-param name="typelist" select="concat($typelist, '-', $t)"/>
                        </xsl:apply-templates>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$etyp//xs:element">
                    <xsl:if test="not(contains($typelist, concat('-', $t)))">
                        <xsl:apply-templates select="$etyp/*" mode="ref">
                            <xsl:with-param name="lvl" select="$lvl + 1"/>
                            <xsl:with-param name="typelist" select="concat($typelist, '-', $t)"/>
                        </xsl:apply-templates>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xs:pattern/@*" mode="txt">
        <xsl:value-of select="concat('pattern', ' = ', ., ' ')"/>
    </xsl:template>

    <xsl:template match="xs:length/@*" mode="txt">
        <xsl:value-of select="concat('length', ' = ', ., ' ')"/>
    </xsl:template>

    <xsl:template match="xs:maxLength/@*" mode="txt">
        <xsl:value-of select="concat('maxLength', ' = ', ., ' ')"/>
    </xsl:template>

    <xsl:template match="@*" mode="txt">
        <xsl:value-of select="concat(name(), ' = ', ., ' ')"/>
    </xsl:template>

    <xsl:template name="makeSpace">
        <xsl:param name="lvl"/>
        <xsl:choose>
            <xsl:when test="$lvl = 2">
                <xsl:value-of select="$Lvl2"/>
            </xsl:when>
            <xsl:when test="$lvl = 3">
                <xsl:value-of select="$Lvl3"/>
            </xsl:when>
            <xsl:when test="$lvl = 4">
                <xsl:value-of select="$Lvl4"/>
            </xsl:when>
            <xsl:when test="$lvl = 5">
                <xsl:value-of select="$Lvl5"/>
            </xsl:when>
            <xsl:when test="$lvl = 6">
                <xsl:value-of select="$Lvl6"/>
            </xsl:when>
            <xsl:when test="$lvl = 7">
                <xsl:value-of select="$Lvl7"/>
            </xsl:when>
            <xsl:when test="$lvl = 8">
                <xsl:value-of select="$Lvl8"/>
            </xsl:when>
            <xsl:when test="$lvl = 9">
                <xsl:value-of select="$Lvl9"/>
            </xsl:when>
            <xsl:when test="$lvl = 10">
                <xsl:value-of select="$Lvl10"/>
            </xsl:when>
            <xsl:when test="$lvl = 11">
                <xsl:value-of select="$Lvl11"/>
            </xsl:when>
            <xsl:when test="$lvl = 12">
                <xsl:value-of select="$Lvl12"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="makeBullet">
        <xsl:param name="lvl"/>
        <xsl:param name="seq"/>
        <xsl:choose>
            <xsl:when test="$lvl = 2">
                <xsl:value-of select="$Lvl2"/>
                <xsl:value-of select="concat($seq, '.', $_1sp)"/>
            </xsl:when>
            <xsl:when test="$lvl = 3">
                <xsl:value-of select="$Lvl3"/>
                <xsl:value-of select="concat(substring($lcase, $seq, 1), '.', $_1sp)"/>
            </xsl:when>
            <xsl:when test="$lvl = 4">
                <xsl:value-of select="$Lvl4"/>
                <xsl:value-of select="concat('(', $seq, ')', $_1sp)"/>
            </xsl:when>
            <xsl:when test="$lvl = 5">
                <xsl:value-of select="$Lvl5"/>
                <xsl:value-of select="concat('(', substring($lcase, $seq, 1), ')', $_1sp)"/>
            </xsl:when>
            <xsl:when test="$lvl = 6">
                <xsl:value-of select="$Lvl6"/>
                <u><xsl:value-of select="$seq"/></u>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="$_1sp"/>
            </xsl:when>
            <xsl:when test="$lvl = 7">
                <xsl:value-of select="$Lvl7"/>
                <xsl:value-of select="concat(substring($lcase, $seq, 1), '.', $_1sp)"/>
            </xsl:when>
            <xsl:when test="$lvl = 8">
                <xsl:value-of select="$Lvl8"/>
                <xsl:value-of select="concat($seq, '.', $_1sp)"/>
            </xsl:when>
            <xsl:when test="$lvl = 9">
                <xsl:value-of select="$Lvl9"/>
                <xsl:value-of select="concat(substring($lcase, $seq, 1), $_1sp)"/>
            </xsl:when>
            <xsl:when test="$lvl = 10">
                <xsl:value-of select="$Lvl10"/>
                <u>
                    <xsl:value-of select="$seq"/>
                </u>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="$_1sp"/>
            </xsl:when>
            <xsl:when test="$lvl = 11">
                <xsl:value-of select="$Lvl11"/>
                <xsl:value-of select="concat('(', $seq, ')', $_1sp)"/>
            </xsl:when>
            <xsl:when test="$lvl = 12">
                <xsl:value-of select="$Lvl12"/>
                <xsl:value-of select="concat('(', $seq, ')', $_1sp)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
