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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="text" indent="yes"/>


    <!-- <xsl:template match="/">
        <xsl:call-template name="makego">
            <xsl:with-param name="rootname" select="'Root'"/>
        </xsl:call-template>
    </xsl:template>-->

    <xsl:variable name="a">
        <xsl:text>&amp;</xsl:text>
    </xsl:variable>
    <xsl:variable name="as">
        <xsl:text>*</xsl:text>
    </xsl:variable>
    <xsl:variable name="lb">
        <xsl:text>{</xsl:text>
    </xsl:variable>
    <xsl:variable name="rb">
        <xsl:text>}</xsl:text>
    </xsl:variable>
    <xsl:variable name="cm">
        <xsl:text>,</xsl:text>
    </xsl:variable>
    <xsl:variable name="cr">
        <xsl:text>&#10;</xsl:text>
    </xsl:variable>
    <xsl:variable name="lf">
        <xsl:text>&#13;</xsl:text>
    </xsl:variable>
    <xsl:variable name="qt">
        <xsl:text>&quot;</xsl:text>
    </xsl:variable>
    <xsl:variable name="bq">
        <xsl:text>&#96;</xsl:text>
    </xsl:variable>
    <xsl:variable name="sp">
        <xsl:text>&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="in">
        <xsl:value-of select="concat($sp, $sp, $sp, $sp)"/>
    </xsl:variable>
    <xsl:variable name="tab">
        <xsl:text>&#09;</xsl:text>
    </xsl:variable>
    <xsl:variable name="json" select="' json:'"/>
    <xsl:variable name="omitempty" select="'omitempty'"/>

    <xsl:variable name="goVarChanges">
        <Rename from="id" to="ID"/>
        <Rename from="idRef" to="IDRef"/>
        <Rename from="Assertion" to="TdfAssertion"/>
        <Rename from="uri" to="URI"/>
        <Rename from="testId" to="TestID"/>
        <Rename from="requirementId" to="RequirementID"/>
    </xsl:variable>

    <xsl:template match="xs:element[@name]" mode="func">
        <xsl:param name="rootname"/>
        <xsl:param name="pckgname"/>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:if test="//xs:schema/xs:complexType[@name = $t]//*[@ref]">
            <xsl:variable name="b" select="/xs:schema/xs:complexType[@name = $t]//xs:extension/@base"/>
            <xsl:value-of select="concat('//New', $rootname, ' ...', $cr)"/>
            <xsl:value-of select="concat('func ', 'New', $rootname, '() ', $as, $n, $lb, $cr)"/>
            <xsl:value-of select="concat($in, 'return ', $a, $n, $lb, $cr)"/>
            <xsl:if test="@name = $rootname">
                <!--<xsl:value-of select="concat($in, $in, '// Required for the proper namespacing', $cr)"/>-->
                <xsl:value-of select="concat($tab, $tab, 'AttrXmlnsXsi', ':', $qt, 'http://www.w3.org/2001/XMLSchema-instance', $qt, $cm, $cr)"/>
                <!--<xsl:value-of select="concat($tab, $tab, 'AttrXmlns', ':', $qt, 'urn:us:gov:ic:niem:icxsd', $qt, $cm, $cr)"/>
                <xsl:value-of select="concat($tab, $tab, 'AttrXmlnsIsm', ':', $qt, 'urn:us:gov:ic:niem:ism', $qt, $cm, $cr)"/>-->
            </xsl:if>
            <!-- <xsl:apply-templates select="/xs:schema/xs:complexType[@name = $b]//xs:element[@ref]" mode="makevar"/>
            <xsl:apply-templates select="/xs:schema/xs:complexType[@name = $t]//xs:element[@ref]" mode="makevar"/>-->
            <xsl:value-of select="concat($in, $rb, $cr)"/>
            <xsl:value-of select="concat($rb, $cr)"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xs:schema/*[not(name() = 'xs:attributeGroup')]">
        <xsl:param name="rootname"/>
        <xsl:param name="pckgname"/>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:variable name="b" select="/xs:schema/*[@name = $t]//xs:*/@base"/>
        <xsl:variable name="ct" select="/xs:schema/*[@name = $b]//xs:*/@base"/>
        <xsl:variable name="st" select="/xs:schema/*[@name = $ct]//xs:*/@base"/>
        <xsl:variable name="varname">
            <xsl:call-template name="varname">
                <xsl:with-param name="n" select="$n"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <!--Recursion Check-->
            <xsl:when test="concat($rootname, 'Type') = $t and $n != $rootname"/>
            <xsl:when test="/xs:schema/*[@name = $t]//*[@ref] or /xs:schema/*[@name = $b]//*[@ref]">
                <xsl:value-of select="concat('//', $varname, ' ... ', normalize-space(substring-before(xs:annotation/xs:documentation, '.')), $cr)"/>
                <xsl:value-of select="concat('type ', $varname, ' struct ', $lb, $cr)"/>
                <xsl:if test="@name = $rootname">
                    <xsl:value-of
                        select="concat($in, $in, 'AttrXmlnsXsi', $tab, 'string', $tab, $tab, $bq, 'xml:', $qt, 'xmlns:xsi,attr', $qt, $json, $qt, 'AttrXmlnsXsi', $cm, $omitempty, $qt, $bq, $cr)"/>
                    <!--<xsl:value-of select="concat($tab, 'AttrXmlns', $tab, 'string', $tab, $tab, $bq, 'xml:', $qt, 'xmlns,attr', $qt, $json, $qt, 'AttrXmlns', $cm, $omitempty, $qt, $bq, $cr)"/>
                    <xsl:value-of select="concat($tab, 'AttrXmlnsIsm', $tab, 'string', $tab, $tab, $bq, 'xml:', $qt, 'xmlns:ism,attr', $qt, $json, $qt, 'AttrXmlnsIsm', $cm, $omitempty, $qt, $bq, $cr)"/>-->
                </xsl:if>
                <xsl:if test="not(/xs:schema/xs:complexType[@name = $t]) or /xs:schema/xs:complexType[@name = $t]/xs:simpleContent">
                    <xsl:value-of select="concat($tab, 'Value', $tab, 'string', $tab, $tab, $bq, 'xml:', $qt, $cm, 'chardata', $qt, ' ', $json, $qt, 'Value', $cm, $omitempty, $qt, $bq, $cr)"/>
                </xsl:if>
                <xsl:apply-templates select="/xs:schema/*[@name = $t]//*[@ref]" mode="makevar">
                    <xsl:with-param name="rootname" select="$rootname"/>
                    <xsl:with-param name="pckgname" select="$pckgname"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="/xs:schema/*[@name = $b]//*[@ref]" mode="makevar">
                    <xsl:with-param name="rootname" select="$rootname"/>
                    <xsl:with-param name="pckgname" select="$pckgname"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="/xs:schema/*[@name = $ct]//*[@ref]" mode="makevar">
                    <xsl:with-param name="rootname" select="$rootname"/>
                    <xsl:with-param name="pckgname" select="$pckgname"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="/xs:schema/*[@name = $st]//*[@ref]" mode="makevar">
                    <xsl:with-param name="rootname" select="$rootname"/>
                    <xsl:with-param name="pckgname" select="$pckgname"/>
                </xsl:apply-templates>
                <xsl:value-of select="concat($tab, 'XMLName', $tab, 'xml.Name', $tab, $tab, $bq, 'xml:', $qt, $n, $cm, $omitempty, $qt, ' ', $json, $qt, $n, $cm, $omitempty, $qt, $bq, $cr)"/>
                <!--  <xsl:for-each select=".//xs:attributeGroup">
                    <xsl:variable name="r" select="@ref"/>
                    <xsl:variable name="agvarname">
                        <xsl:call-template name="varname">
                            <xsl:with-param name="n" select="@ref"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="typ">
                        <xsl:choose>
                            <xsl:when test="/xs:schema/xs:attributeGroup[@name = $r]">
                                <xsl:value-of select="concat('*', $r)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$r"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:value-of select="concat($tab, $agvarname, $tab, $tab, '//', $agvarname, $cr)"/>
                    <!-\-<xsl:value-of select="concat($tabchar, $agvarname, $tabchar, $typ, $cr)"/>-\->
                    <!-\-<xsl:value-of
                select="concat($tabchar, $agvarname, $tabchar, $typ, $tabchar, $bq, 'xml:', $qt, @ref, $cm, 'attr', $cm, $omitempty, $qt, ' ', $json, $qt, @ref, $cm, $omitempty, $qt, $bq, $cr)"/>-\->
                </xsl:for-each>-->
                <!--  <xsl:apply-templates select=".//xs:attribute">
                    <xsl:with-param name="rootname" select="$rootname"/>
                    <xsl:with-param name="pckgname" select="$pckgname"/>
                </xsl:apply-templates>-->
                <xsl:value-of select="concat($rb, $cr)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xs:schema/xs:attributeGroup">
        <xsl:variable name="varname">
            <xsl:call-template name="varname">
                <xsl:with-param name="n" select="@name"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat('//', $varname, ' ... ', normalize-space(xs:annotation/xs:documentation), $lf)"/>
        <xsl:value-of select="concat('type ', $varname, ' struct ', $lb, $cr)"/>
        <xsl:for-each select="xs:attributeGroup">
            <xsl:variable name="r" select="@ref"/>
            <xsl:variable name="agvarname">
                <xsl:call-template name="varname">
                    <xsl:with-param name="n" select="@ref"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="typ">
                <xsl:choose>
                    <xsl:when test="/xs:schema/xs:attributeGroup[@name = $r]">
                        <xsl:value-of select="concat('*', $r)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$r"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="concat($tab, $agvarname, $tab, $tab, '//', $agvarname, $cr)"/>
            <!--<xsl:value-of select="concat($tabchar, $agvarname, $tabchar, $typ, $cr)"/>-->
            <!--<xsl:value-of
                select="concat($tabchar, $agvarname, $tabchar, $typ, $tabchar, $bq, 'xml:', $qt, @ref, $cm, 'attr', $cm, $omitempty, $qt, ' ', $json, $qt, @ref, $cm, $omitempty, $qt, $bq, $cr)"/>-->
        </xsl:for-each>
        <xsl:for-each select="xs:attribute">
            <xsl:variable name="r" select="@ref"/>
            <xsl:variable name="t" select="/xs:schema/xs:attribute[@name = $r]/@type"/>
            <xsl:variable name="agvarname">
                <xsl:call-template name="varname">
                    <xsl:with-param name="n" select="@ref"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="strtype">
                <xsl:choose>
                    <xsl:when test="/xs:schema/xs:simpleType[@name = $t]//xs:list">
                        <xsl:text>[]Attrib</xsl:text>
                    </xsl:when>
                    <xsl:when test="/xs:schema/xs:simpleType[@name = $t]//xs:union">
                        <xsl:text>[]Attrib</xsl:text>
                    </xsl:when>
                    <xsl:when test="/xs:schema/xs:simpleType//@base = 'xsd:NMTOKENS'">
                        <xsl:text>[]Attrib</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Attrib</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="concat($tab, $agvarname, $tab, 'Attrib', $tab, $bq, 'xml:', $qt, @ref, $cm, 'attr', $cm, $omitempty, $qt, ' ', $json, $qt, @ref, $cm, $omitempty, $qt, $bq, $cr)"/>
        </xsl:for-each>
        <xsl:value-of select="concat($rb, $cr)"/>
    </xsl:template>

    <xsl:template match="*" mode="makevar">
        <xsl:param name="rootname"/>
        <xsl:variable name="attyp">
            <xsl:if test="name() = 'xs:attribute'">
                <xsl:text>,attr</xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="r" select="@ref"/>
        <xsl:variable name="varname">
            <xsl:call-template name="varname">
                <xsl:with-param name="n" select="$r"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="t" select="/xs:schema/xs:element[@name = $r]/@type"/>
        <xsl:variable name="b" select="/xs:schema/xs:complexType[@name = $t]//@base"/>
        <xsl:variable name="ary">
            <xsl:if test="@maxOccurs &gt; 1">
                <xsl:text>[0]</xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="ptr">
            <xsl:choose>
                <xsl:when test="/xs:schema/*[@name = $t]//*[@ref]">
                    <xsl:text>*</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dt">
            <xsl:choose>
                <xsl:when test="/xs:schema/xs:complexType[@name = $t]//*[@ref]">
                    <xsl:value-of select="concat($ary, $ptr, $varname)"/>
                </xsl:when>
                <xsl:when test="name() = 'xs:attribute'">
                    <xsl:text>Attrib</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'xs:attributeGroup'">
                    <xsl:value-of select="concat('*', $varname)"/>
                </xsl:when>
                <xsl:when test="/xs:schema/*[@name = $t]//*[@ref]">
                    <xsl:value-of select="concat($ary, $ptr, $varname)"/>
                </xsl:when>
                <xsl:when test="/xs:schema/*[@name = $b]//*[@ref]">
                    <xsl:value-of select="concat($ary, $ptr, $varname)"/>
                </xsl:when>
                <xsl:when test="/xs:schema/*[@name = $t]//@base = 'xs:boolean'">
                    <xsl:value-of select="concat($ary, 'bool')"/>
                </xsl:when>
                <xsl:when test="$ptr = ''">
                    <xsl:value-of select="concat($ary, 'string')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($ary, $ptr, $varname)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$varname = 'Response'">
                <xsl:choose>
                    <xsl:when test="parent::xs:extension/@base = 'LongStringWithSecurityType'"/>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="concat($tab, $varname, $tab, $dt, $tab, $tab, $bq, 'xml:', $qt, $r, $attyp, $cm, $omitempty, $qt, ' ', $json, $qt, $r, $attyp, $cm, $omitempty, $qt, $bq, $cr)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="name() = 'xs:attributeGroup'">
                <xsl:value-of select="concat($tab, $varname, $tab, $tab, '//', $varname, $cr)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($tab, $varname, $tab, $dt, $tab, $tab, $bq, 'xml:', $qt, $r, $attyp, $cm, $omitempty, $qt, ' ', $json, $qt, $r, $attyp, $cm, $omitempty, $qt, $bq, $cr)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

     <!--Processes Ref Elements-->
    <xsl:template match="xs:element[@ref]">
        <xsl:variable name="r" select="@ref"/>
        <xsl:variable name="varname">
            <xsl:call-template name="varname">
                <xsl:with-param name="n" select="$r"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="t" select="/xs:schema/xs:element[@name = $r]/@type"/>
        <xsl:variable name="ary">
            <xsl:choose>
                <xsl:when test="@maxOccurs &gt; 1">
                    <xsl:text>[0]</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ptr">
            <xsl:choose>
                <xsl:when test="ancestor::xs:complexType">
                    <xsl:text/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>*</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dt" select="concat($ary, '*', $varname)"/>
        <xsl:value-of select="concat($tab, $varname, $tab, $dt, $tab, $tab, $bq, 'xml:', $qt, @ref, $cm, $omitempty, $qt, ' ', $json, $qt, @ref, $ary, $cm, $omitempty, $qt, $bq, $cr)"/>
    </xsl:template>

    <!--Processes Ref Attributes-->
    <xsl:template match="xs:attribute[@ref]"> sl:for-each select=".//xs:attribute"> <xsl:variable name="r" select="@ref"/>
        <xsl:variable name="tp" select="/xs:schema/xs:attribute[@name = $r]/@type"/>
        <xsl:variable name="agvarname">
            <xsl:call-template name="varname">
                <xsl:with-param name="n" select="@ref"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="strtype">
            <xsl:choose>
                <xsl:when test="/xs:schema/xs:simpleType[@name = $tp]//xs:list">
                    <xsl:text>[]Attrib</xsl:text>
                </xsl:when>
                <xsl:when test="/xs:schema/xs:simpleType[@name = $tp]//xs:union">
                    <xsl:text>[]Attrib</xsl:text>
                </xsl:when>
                <xsl:when test="/xs:schema/xs:simpleType//@base = 'xsd:NMTOKENS'">
                    <xsl:text>[]Attrib</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Attrib</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($tab, $agvarname, $tab, 'Attrib', $tab, $bq, 'xml:', $qt, @ref, $cm, 'attr', $cm, $omitempty, $qt, ' ', $json, $qt, @ref, $cm, $omitempty, $qt, $bq, $cr)"/>
    </xsl:template>

    <!--Processes Ref AttributeGroups-->
    <xsl:template match="xs:attributeGroup[@ref]">
        <xsl:variable name="r" select="@ref"/>
        <xsl:variable name="varname">
            <xsl:call-template name="varname">
                <xsl:with-param name="n" select="$r"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="t" select="/xs:schema/xs:element[@name = $r]/@type"/>
        <xsl:variable name="ary">
            <xsl:choose>
                <xsl:when test="@maxOccurs &gt; 1">
                    <xsl:text>[0]</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ptr">
            <xsl:choose>
                <xsl:when test="ancestor::xs:complexType">
                    <xsl:text/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>*</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dt" select="concat($ary, '*', $varname)"/>
        <xsl:value-of select="concat($tab, $varname, $tab, $dt, $cr)"/>
        <!--<xsl:value-of select="concat($tab, $varname, $tab, $dt, $tab, $tab, $bq, 'xml:', $qt, @ref, $cm, $omitempty, $qt, ' ', $json, $qt, @ref, $ary, $cm, $omitempty, $qt, $bq, $cr)"/>-->
    </xsl:template>

    <xsl:template name="varname">
        <xsl:param name="n"/>
        <xsl:choose>
            <xsl:when test="$n = 'testId'">
                <xsl:text>TestID</xsl:text>
            </xsl:when>
            <xsl:when test="$n = 'requirementId'">
                <xsl:text>RequirementID</xsl:text>
            </xsl:when>
            <xsl:when test="exsl:node-set($goVarChanges)/Rename[@from = $n]">
                <xsl:value-of select="exsl:node-set($goVarChanges)/Rename[@from = $n]/@to"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="uppercase">
                    <xsl:with-param name="txt" select="$n"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="uppercase">
        <xsl:param name="txt"/>
        <xsl:value-of select="translate(substring($txt, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        <xsl:value-of select="substring($txt, 2, string-length($txt) - 1)"/>
    </xsl:template>

    <xsl:template name="lowercase">
        <xsl:param name="txt"/>
        <xsl:value-of select="translate($txt, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
    </xsl:template>

    <xsl:template match="*">
        <xsl:param name="rootname"/>
        <xsl:apply-templates select="*">
            <xsl:with-param name="rootname" select="$rootname"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*" mode="def">
        <xsl:param name="rootname"/>
        <xsl:apply-templates select="*" mode="def">
            <xsl:with-param name="rootname" select="$rootname"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template name="lastel">
        <xsl:param name="str"/>
        <xsl:choose>
            <xsl:when test="contains($str, '.')">
                <xsl:call-template name="lastel">
                    <xsl:with-param name="str" select="substring-after($str, '.')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$str"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="xmlcopy">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*" mode="xmlcopy"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*" mode="xmlcopy"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*" mode="xmlcopy">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="text()" mode="xmlcopy">
        <xsl:value-of select="normalize-space(translate(., '&#34;&#xA;', ''))"/>
    </xsl:template>

</xsl:stylesheet>
