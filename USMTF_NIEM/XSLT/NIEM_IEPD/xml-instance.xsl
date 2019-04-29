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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="maxdepth" select="30"/>

    <xsl:variable name="iepsrc" select="'../../XSD/IEPD/xml/xsd/'"/>

    <xsl:variable name="TestData" select="exsl:node-set(document('../../XSD/IEPD/xml/instance/common/mtf-testdata-edit.xml')/TestData)"/>

    <xsl:variable name="ChoiceSelections" select="$TestData/ChoiceSelections"/>

    <xsl:template match="xs:schema/xs:element" mode="root">
        <xsl:param name="xsdv"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:variable name="s" select="//xs:schema"/>
        <xsl:variable name="xmltemplate">
            <el>
                <xsl:element name="{@name}" xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
            </el>
        </xsl:variable>
        <xsl:for-each select="$xmltemplate/*/*">
            <xsl:copy>
                <xsl:apply-templates select="@*" mode="identity"/>
                <xsl:attribute name="xsi:schemaLocation">
                    <xsl:value-of select="concat('urn:mtf:mil:6040b:niem:mtf ',$xsdv)"/>
                </xsl:attribute>
                <xsl:apply-templates select="$s/xs:complexType[@name = $t]">
                    <xsl:with-param name="depth" select="1"/>
                </xsl:apply-templates>
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="xs:schema/xs:complexType" mode="root">
        <xsl:apply-templates select="*">
            <xsl:with-param name="depth" select="1"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="xs:group[@ref]">
        <xsl:param name="depth"/>
        <xsl:variable name="gref" select="@ref"/>
        <xsl:apply-templates select="//xs:schema/*[@name = $gref]/*">
            <xsl:with-param name="depth" select="$depth + 1"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="xs:element[@ref]">
        <xsl:param name="depth"/>
        <xsl:if test="$depth &lt; $maxdepth">
            <xsl:variable name="elref">
                <xsl:choose>
                    <xsl:when test="contains(@ref, ':')">
                        <xsl:value-of select="substring-after(@ref, ':')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@ref"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="elnode" select="//xs:schema/*[@name = $elref]"/>
            <xsl:variable name="typname">
                <xsl:choose>
                    <xsl:when test="contains($elnode/@type, ':')">
                        <xsl:value-of select="substring-after($elnode/@type, ':')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$elnode/@type"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="typnode" select="//xs:schema/*[@name = $typname]"/>
            <xsl:variable name="typbase" select="$typnode/*/*/@base"/>
            <xsl:variable name="basenode" select="//xs:schema/*[@name = $typbase]"/>
            <xsl:variable name="simplebase">
                <xsl:choose>
                    <xsl:when test="$basenode/*/*/@base">
                        <xsl:value-of select="$basenode/*/*/@base"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$typbase"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="simplenode" select="//xs:schema/*[@name = $simplebase]"/>
            <xsl:variable name="testvalue">
                <xsl:choose>
                    <xsl:when test="$TestData//*[name() = $elnode]">
                        <xsl:value-of select="$TestData/*[name() = $elnode]/Test[@valid = 'true'][1]/@value"/>
                    </xsl:when>
                    <xsl:when test="$TestData//*[name() = $typbase]">
                        <xsl:value-of select="$TestData/*[name() = $typbase]/Test[@valid = 'true'][1]/@value"/>
                    </xsl:when>
                    <xsl:when test="$TestData//*[name() = $simplebase]">
                        <xsl:value-of select="$TestData/*[name() = $simplebase]/Test[@valid = 'true'][1]/@value"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="elname">
                <xsl:value-of select="$elref"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$elnode/@abstract = 'true'">
                    <xsl:apply-templates select="$typnode">
                        <xsl:with-param name="depth" select="$depth + 1"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="{$elname}" namespace="urn:mtf:mil:6040b:niem:mtf">
                        <!--<xsl:attribute name="typname">
                            <xsl:value-of select="$typname"/>
                        </xsl:attribute>
                       <xsl:attribute name="typbase">
                            <xsl:value-of select="$typbase"/>
                        </xsl:attribute>-->
                        <xsl:choose>
                            <xsl:when test="$basenode/@name = 'ResponseWithExplanationType'">
                                <xsl:attribute name="ism:classification">
                                    <xsl:text>U</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="ism:ownerProducer">
                                    <xsl:text>NFK</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$basenode/@name = 'ComplianceType'">
                                <xsl:attribute name="ism:classification">
                                    <xsl:text>U</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="ism:ownerProducer">
                                    <xsl:text>NFK</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="contains($typnode//xs:attributeGroup/@ref, 'Security') or @ref = 'Security' or @ref = 'ProfileDes'">
                                <xsl:attribute name="ism:classification">
                                    <xsl:text>U</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="ism:ownerProducer">
                                    <xsl:text>NFK</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="contains($basenode//xs:attributeGroup/@ref, 'Security')">
                                <xsl:attribute name="ism:classification">
                                    <xsl:text>U</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="ism:ownerProducer">
                                    <xsl:text>NFK</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:apply-templates select="$typnode//xs:attribute" mode="att">
                            <xsl:with-param name="depth" select="$depth"/>
                            <xsl:with-param name="parentname" select="$elname"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="$basenode//xs:attribute" mode="att">
                            <xsl:with-param name="depth" select="$depth"/>
                            <xsl:with-param name="parentname" select="$elname"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="$typnode//xs:attributeGroup" mode="att">
                            <xsl:with-param name="depth" select="$depth"/>
                            <xsl:with-param name="parentname" select="$elname"/>
                        </xsl:apply-templates>
                        <xsl:value-of select="$testvalue"/>
                        <xsl:variable name="n" select="substring-after(@ref, 'ism:')"/>
                        <xsl:apply-templates select="$typnode">
                            <xsl:with-param name="depth" select="$depth + 1"/>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xs:group[@ref]">
        <xsl:param name="depth"/>
        <xsl:if test="$depth &lt; $maxdepth">
            <xsl:variable name="elref" select="@ref"/>
            <xsl:variable name="elnode" select="//xs:schema/xs:group[@name = $elref]"/>
            <xsl:apply-templates select="$elnode/*">
                <xsl:with-param name="depth" select="$depth + 1"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xs:attributeGroup[@ref]" mode="att">
        <xsl:param name="depth"/>
        <xsl:variable name="elref" select="@ref"/>
        <xsl:variable name="attgrnode" select="//xs:schema/*[@name = $elref]"/>
        <xsl:apply-templates select="$attgrnode/xs:attribute[@use = 'required']" mode="att">
            <xsl:with-param name="depth" select="$depth"/>
            <xsl:with-param name="parentname" select="@ref"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$attgrnode/xs:attributeGroup[@ref]" mode="att">
            <xsl:with-param name="depth" select="$depth"/>
            <xsl:with-param name="parentname" select="@ref"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="xs:attribute[@ref]" mode="att">
        <xsl:param name="depth"/>
        <xsl:param name="parentname"/>
        <xsl:variable name="r" select="@ref"/>
        <xsl:variable name="attnode" select="//xs:schema/*[@name = $r]"/>
        <xsl:variable name="typname" select="$attnode/@type"/>
        <xsl:variable name="typnode" select="//xs:schema/*[@name = $typname]"/>
        <xsl:variable name="typbase" select="//xs:schema/*[@name = $typnode/*/xs:extension/@base]"/>
        <xsl:variable name="simplebase" select="$typnode/*/xs:extension/@base[1]"/>
        <xsl:variable name="base" select="$typbase/*/@base"/>
        <xsl:variable name="testValue">
            <xsl:choose>
                <xsl:when test="@ref = 'id'">
                    <xsl:value-of select="concat($parentname, position(), $depth, 'id')"/>
                </xsl:when>
                <xsl:when test="@ref = 'idRef'">
                    <xsl:value-of select="concat($parentname, position(), $depth, 'idRef')"/>
                </xsl:when>
                <xsl:when test="@ref = 'sequenceNum'">
                    <xsl:value-of select="position()"/>
                </xsl:when>
                <xsl:when test="@ref = 'ownerProducer'">
                    <xsl:text>NFK</xsl:text>
                </xsl:when>
                <xsl:when test="$TestData//*[name() = $r]//*[@valid = 'true']">
                    <xsl:value-of select="$TestData//*[name() = $r]/*[@valid = 'true'][1]/@value"/>
                </xsl:when>
                <xsl:when test="$TestData//*[name() = $typname]//*[@valid = 'true']">
                    <xsl:value-of select="$TestData//*[name() = $typname]/*[@valid = 'true'][1]/@value"/>
                </xsl:when>
                <xsl:when test="$simplebase = 'xs:boolean'">
                    <xsl:value-of select="$TestData//*[name() = 'xs:boolean']//*[@valid = 'true'][1]/@value"/>
                </xsl:when>
                <xsl:when test="$simplebase = 'xs:integer'">
                    <xsl:value-of select="$TestData//*[name() = 'xs:integer']/*[@valid = 'true'][1]/@value"/>
                </xsl:when>
                <xsl:when test="$simplebase = 'xs:string'">
                    <xsl:value-of select="$TestData//*[name() = 'xs:string']//*[@valid = 'true'][1]/@value"/>
                </xsl:when>
                <xsl:when test="$simplebase = 'xs:dateTime'">
                    <xsl:value-of select="$TestData//*[name() = 'xs:dateTime']//*[@valid = 'true'][1]/@value"/>
                </xsl:when>
                <xsl:when test="$simplebase = 'xs:anyURI'">
                    <xsl:value-of select="$TestData//*[name() = 'xs:anyURI']//*[@valid = 'true'][1]/@value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$TestData//*[name() = $typbase/@name]/*[@valid = 'true'][1]/@value"/>
                    <xsl:value-of select="$TestData//*[name() = $typname]//*[@valid = 'true'][1]/@value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="{$attnode/@name}">
            <xsl:value-of select="$testValue"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="xs:extension">
        <xsl:param name="depth"/>
        <xsl:variable name="b" select="@base"/>
        <xsl:apply-templates select="//xs:schema/xs:complexType[@name = $b]">
            <xsl:with-param name="depth" select="$depth + 1"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="*">
            <xsl:with-param name="depth" select="$depth + 1"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="xs:annotation"/>

    <xsl:template match="xs:*">
        <xsl:param name="depth"/>
        <xsl:apply-templates select="*">
            <xsl:with-param name="depth" select="$depth + 1"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="xs:choice">
        <xsl:param name="depth"/>
        <xsl:variable name="n" select="xs:annotation/xs:appinfo//@substitutionGroup"/>
        <xsl:variable name="c">
            <xsl:value-of select="exsl:node-set($ChoiceSelections)/*[name() = $n]/@choice"/>
        </xsl:variable>
        <xsl:comment>
            <xsl:value-of select="concat($n, ' .. ', $c)"/>
        </xsl:comment>
        <xsl:apply-templates select="xs:element[@ref = $c]">
            <xsl:with-param name="depth" select="$depth + 1"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="@*" mode="identity">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
</xsl:stylesheet>
