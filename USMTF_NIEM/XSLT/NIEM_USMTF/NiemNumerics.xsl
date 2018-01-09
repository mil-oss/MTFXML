<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2017 JD NEUSHUL
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
    xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" 
    exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <!--Input-->
    
    <!--Test Output-->
    <xsl:variable name="xsdoutputdoc" select="'../../XSD/Analysis/Normalized/Numerics_1_NS_NIEM.xsd'"/>
    <xsl:variable name="numericsout" select="'../../XSD/Test/MTF_XML_Maps/NIEM_Numerics_1_NS_NIEM.xml'"/>
    <xsl:variable name="nsdir" select="'../../XSD/'"/>
    <xsl:variable name="nfld_changes" select="document(concat($nsdir, 'Refactor_Changes/FieldChanges.xml'))/FieldChanges"/>

    <xsl:variable name="integers_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:integer']]"/>
    
    <xsl:variable name="decimals_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:decimal']]"/>
    
    <xsl:variable name="numerics_xsd">
        <xsl:for-each select="$integers_xsd">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$decimals_xsd">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>


    <xsl:variable name="numerics">
        <xsl:for-each select="$numerics_xsd/*">
            <xsl:sort select="@name"/>
            <xsl:variable name="mtfname" select="@name"/>
            <xsl:variable name="change" select="$nfld_changes/Numeric[@name = $mtfname]"/>
            <xsl:variable name="e">
                <xsl:apply-templates select="@name" mode="fromtype"/>
            </xsl:variable>
            <xsl:variable name="niemelementname">
                <xsl:choose>
                    <xsl:when test="$change/@niemelementname">
                        <xsl:value-of select="$change/@niemelementname"/>
                    </xsl:when>
                    <!--<xsl:when test="ends-with($e, 'Number')">
                        <xsl:value-of select="concat(substring($e, 0, string-length($e) - 5), 'Numeric')"/>
                    </xsl:when>
                    <xsl:when test="$e = 'TargetIdentification'">
                        <xsl:text>TargetID</xsl:text>
                    </xsl:when>
                    <xsl:when test="ends-with($e, 'Indicator')">
                        <xsl:value-of select="replace($e, 'Indicator', 'Numeric')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($e, 'Code')">
                        <xsl:value-of select="replace($e, 'Code', 'Numeric')"/>
                    </xsl:when>-->
                    <xsl:otherwise>
                        <xsl:value-of select="$e"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemtypename">
                <xsl:choose>
                    <xsl:when test="ends-with($e, 'Code')">
                        <xsl:value-of select="replace($e, 'Code', 'Text')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($e, 'Indicator')">
                        <xsl:value-of select="replace($e, 'Indicator', 'Text')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($e, 'Number')">
                        <xsl:value-of select="replace($e, 'Number', 'Numeric')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($e, 'Numeric')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="base">
                <xsl:value-of select="xsd:restriction/@base"/>
            </xsl:variable>
            <xsl:variable name="niemsimpletype">
                <xsl:choose>
                    <xsl:when test="$change/@niemtype">
                        <xsl:value-of select="concat(substring($change/@niemtype, 0, string-length($change/@niemtype) - 3), 'SimpleType')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($niemtypename, 'SimpleType')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemcomplextype">
                <xsl:value-of select="concat($niemtypename, 'Type')"/>
            </xsl:variable>
            <xsl:variable name="mtfdoc">
                <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
            </xsl:variable>
            <xsl:variable name="niemtypedoc">
                <xsl:choose>
                    <xsl:when test="$change/@niemtypedoc">
                        <xsl:value-of select="$change/@niemtypedoc"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$mtfdoc"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemelementdoc">
                <xsl:choose>
                    <xsl:when test="$change/@niemtypedoc">
                        <xsl:value-of select="replace($change/@niemtypedoc, 'A data type', 'A data item')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace($mtfdoc, 'A data type', 'A data item')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="appinfo">
                <xsl:apply-templates select="xsd:annotation/xsd:appinfo"/>
            </xsl:variable>
            <xsl:variable name="min" select="xsd:restriction/xsd:minInclusive/@value"/>
            <xsl:variable name="max" select="xsd:restriction/xsd:maxInclusive/@value"/>
            <xsl:variable name="ffirn" select="xsd:annotation/xsd:appinfo/*:FieldFormatIndexReferenceNumber"/>
            <xsl:variable name="fud" select="xsd:annotation/xsd:appinfo/*:FudNumber"/>
            <xsl:choose>
                <xsl:when test="$base = 'xsd:integer'">
                    <Field niemelementname="{$niemelementname}" niemsimpletype="{$niemsimpletype}" niemtype="{$niemcomplextype}" base="xsd:integer" min="{$min}" max="{$max}"
                        niemelementdoc="{$niemelementdoc}" mtfdoc="{$mtfdoc}" niemtypedoc="{$niemtypedoc}" mtftype="{@name}" ffirn="{$ffirn}" fud="{$fud}">
                        <appinfo>
                            <xsl:for-each select="$appinfo/*">
                                <xsl:copy-of select="mtfappinfo:Field" copy-namespaces="no"/>
                            </xsl:for-each>
                        </appinfo>
                    </Field>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="length">
                        <xsl:value-of select="xsd:restriction/xsd:length"/>
                    </xsl:variable>
                    <xsl:variable name="minlen">
                        <xsl:value-of select="xsd:annotation/xsd:appinfo/*:MinimumLength"/>
                    </xsl:variable>
                    <xsl:variable name="maxlen">
                        <xsl:value-of select="xsd:annotation/xsd:appinfo/*:MaximumLength"/>
                    </xsl:variable>
                    <xsl:variable name="mindec">
                        <xsl:value-of select="xsd:annotation/xsd:appinfo/*:MinimumDecimalPlaces"/>
                    </xsl:variable>
                    <xsl:variable name="maxdec">
                        <xsl:value-of select="xsd:annotation/xsd:appinfo/*:MaximumDecimalPlaces"/>
                    </xsl:variable>
                    <xsl:variable name="fractionDigits">
                        <xsl:call-template name="FindMaxDecimals">
                            <xsl:with-param name="value1">
                                <xsl:value-of select="$min"/>
                            </xsl:with-param>
                            <xsl:with-param name="value2">
                                <xsl:value-of select="$max"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="totalDigitCount">
                        <xsl:call-template name="FindTotalDigitCount">
                            <xsl:with-param name="value1">
                                <xsl:value-of select="$min"/>
                            </xsl:with-param>
                            <xsl:with-param name="value2">
                                <xsl:value-of select="$max"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <Field niemelementname="{$niemelementname}" niemsimpletype="{$niemsimpletype}" niemtype="{$niemcomplextype}" base="xsd:decimal" min="{$min}" max="{$max}"
                        fractionDigits="{$fractionDigits}" totalDigits="{number($maxlen) - 1}" niemelementdoc="{$niemelementdoc}" niemtypedoc="{$niemtypedoc}" mtftype="{@name}" mtfdoc="{$mtfdoc}" ffirn="{$ffirn}"
                        fud="{$fud}">
                        <appinfo>
                                <xsl:for-each select="$appinfo/*">
                                    <xsl:copy-of select="mtfappinfo:Field" copy-namespaces="no"/>
                                </xsl:for-each>
                        </appinfo>
                    </Field>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="numericsxsd">
        <xsl:for-each select="$numerics/Field">
            <xsl:sort select="@niemsimpletype"/>
            <xsd:simpleType name="{@niemsimpletype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                </xsd:annotation>
                <xsd:restriction base="{@base}">
                    <xsd:minInclusive value="{@min}"/>
                    <xsd:maxInclusive value="{@max}"/>
                    <xsl:if test="@fractionDigits">
                        <xsd:fractionDigits value="{@fractionDigits}"/>
                    </xsl:if>
                    <xsl:if test="@totalDigits">
                        <xsd:totalDigits value="{@totalDigits}"/>
                    </xsl:if>
                </xsd:restriction>
            </xsd:simpleType>
            <xsd:complexType name="{@niemtype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                </xsd:annotation>
                <xsd:simpleContent>
                    <xsd:extension base="{@niemsimpletype}">
                        <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                    </xsd:extension>
                </xsd:simpleContent>
            </xsd:complexType>
            <!--<xsd:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemelementdoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                </xsd:annotation>
            </xsd:element>-->
        </xsl:for-each>
    </xsl:variable>

    <!-- Determine how many placeholders are represented in the decimal value -->
    <xsl:template name="FindMaxDecimals">
        <xsl:param name="value1"/>
        <xsl:param name="value2"/>
        <xsl:choose>
            <xsl:when test="contains($value1, '.') and contains($value2, '.')">
                <xsl:if test="
                        (string-length(substring-after($value1, '.')) >
                        string-length(substring-after($value2, '.')))">
                    <xsl:value-of select="string-length(substring-after($value1, '.'))"/>
                </xsl:if>
                <xsl:if test="
                        (string-length(substring-after($value1, '.')) &lt;
                        string-length(substring-after($value2, '.')))">
                    <xsl:value-of select="string-length(substring-after($value2, '.'))"/>
                </xsl:if>
                <xsl:if test="
                        (string-length(substring-after($value1, '.')) =
                        string-length(substring-after($value2, '.')))">
                    <xsl:value-of select="string-length(substring-after($value1, '.'))"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="contains($value1, '.')">
                <xsl:value-of select="string-length(substring-after($value1, '.'))"/>
            </xsl:when>
            <xsl:when test="contains($value2, '.')">
                <xsl:value-of select="string-length(substring-after($value2, '.'))"/>
            </xsl:when>
            <xsl:when test="(not(contains($value1, '.')) and not(contains($value2, '.')))">
                <xsl:if test="string-length($value1) > string-length($value2)">
                    <xsl:value-of select="string-length(substring-after($value1, '.'))"/>
                </xsl:if>
                <xsl:if test="string-length($value1) &lt; string-length($value2)">
                    <xsl:value-of select="string-length(substring-after($value2, '.'))"/>
                </xsl:if>
                <xsl:if test="string-length($value2) = string-length($value1)">
                    <xsl:value-of select="string-length(substring-after($value1, '.'))"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'Error'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Determine how many digits are represented in the decimal value -->
    <xsl:template name="FindTotalDigitCount">
        <xsl:param name="value1"/>
        <xsl:param name="value2"/>
        <xsl:variable name="value1nodecimal">
            <xsl:choose>
                <xsl:when test="contains($value1, '.') and contains($value1, '-')">
                    <xsl:value-of select="substring-after(concat(substring-before($value1, '.'), substring-after($value1, '.')), '-')"/>
                </xsl:when>
                <xsl:when test="contains($value1, '.')">
                    <xsl:value-of select="concat(substring-before($value1, '.'), substring-after($value1, '.'))"/>
                </xsl:when>
                <xsl:when test="contains($value1, '-')">
                    <xsl:value-of select="substring-after($value1, '-')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$value1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="value2nodecimal">
            <xsl:choose>
                <xsl:when test="contains($value2, '.') and contains($value2, '-')">
                    <xsl:value-of select="substring-after(concat(substring-before($value2, '.'), substring-after($value2, '.')), '-')"/>
                </xsl:when>
                <xsl:when test="contains($value2, '.')">
                    <xsl:value-of select="concat(substring-before($value2, '.'), substring-after($value2, '.'))"/>
                </xsl:when>
                <xsl:when test="contains($value2, '-')">
                    <xsl:value-of select="substring-after($value2, '-')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$value2"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string-length($value1nodecimal) > string-length($value2nodecimal)">
                <xsl:value-of select="string-length($value1nodecimal)"/>
            </xsl:when>
            <xsl:when test="string-length($value1nodecimal) &lt; string-length($value2nodecimal)">
                <xsl:value-of select="string-length($value2nodecimal)"/>
            </xsl:when>
            <xsl:when test="string-length($value1nodecimal) = string-length($value2nodecimal)">
                <xsl:value-of select="string-length($value1nodecimal)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'Error'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- _______________________________________________________ -->

    <!-- <xsl:template name="main">
        <xsl:result-document href="{$xsdoutputdoc}">
            <xsl:call-template name="NIEMReferenceSchema">
                <xsl:with-param name="schemadoc">
                    <xsl:text>Numeric fields for MTF Messages</xsl:text>
                </xsl:with-param>
                <xsl:with-param name="content">
                    <xsl:for-each select="$numericsxsd/xsd:simpleType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="not(preceding-sibling::xsd:simpleType/@name = $n)">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$numericsxsd/xsd:complexType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$numericsxsd/xsd:element">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:result-document>
        <xsl:result-document href="{$numericsout}">
            <Numerics>
                <xsl:for-each select="$numerics">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </Numerics>
        </xsl:result-document>
    </xsl:template>
-->
</xsl:stylesheet>
