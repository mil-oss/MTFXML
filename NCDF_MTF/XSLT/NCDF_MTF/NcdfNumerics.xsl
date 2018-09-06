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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:include href="USMTF_Utility.xsl"/>
    
    <xsl:template name="main">
        <xsl:copy-of select="$numerics"/>
    </xsl:template>

    <!--Test Output-->
    <xsl:variable name="xsdoutputdoc" select="'../../XSD/Analysis/Normalized/Numerics_NCDF.xsd'"/>
    <xsl:variable name="numericsout" select="'../../XSD/Test/MTF_XML_Maps/NCDF_Numerics_NCDF.xml'"/>
    <xsl:variable name="nsdir" select="'../../XSD/'"/>
    <xsl:variable name="nfld_changes" select="document(concat($nsdir, 'Refactor_Changes/FieldChanges.xml'))/FieldChanges"/>

    <xsl:variable name="numsimpletypes" select="document(concat($nsdir, 'Refactor_Changes/NumericSimpleTypes.xml'))/NumericSimpleTypes"/>

    <xsl:variable name="integers_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/fields.xsd')/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:integer']]"/>

    <xsl:variable name="decimals_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/fields.xsd')/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:decimal']]"/>

    <!--Fragment containing all integer and decimal SimpleTypes from Original XML Schema-->
    <xsl:variable name="numerics_xsd">
        <xsl:for-each select="$integers_xsd">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$decimals_xsd">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <!--Create XML Map of Original XML Schema-->
    <xsl:variable name="numerics">
        <xsl:for-each select="$numerics_xsd/*">
            <xsl:sort select="@name"/>
            <xsl:variable name="mtfname" select="@name"/>
            <xsl:variable name="min" select="xsd:restriction/xsd:minInclusive/@value"/>
            <xsl:variable name="max" select="xsd:restriction/xsd:maxInclusive/@value"/>
            <xsl:variable name="pattern" select="xsd:restriction/xsd:pattern/@value"/>
            <xsl:variable name="base" select="xsd:restriction/@base"/>
            <xsl:variable name="numchange" select="$nfld_changes/Numeric[@name = $mtfname]"/>
            <xsl:variable name="e">
                <xsl:apply-templates select="@name" mode="fromtype"/>
            </xsl:variable>
            <xsl:variable name="ncdfelementname">
                <xsl:choose>
                    <xsl:when test="$numchange/@ncdfelementname">
                        <xsl:value-of select="$numchange/@ncdfelementname"/>
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
            <xsl:variable name="ncdftypename">
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
            <xsl:variable name="ncdfpattern">
                <xsl:choose>
                    <xsl:when test="$numchange/@ncdfpattern">
                        <xsl:value-of select="$numchange/@ncdfpattern"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$pattern"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ncdfcomplextype">
                <xsl:value-of select="concat($ncdftypename, 'Type')"/>
            </xsl:variable>
            <xsl:variable name="mtfdoc">
                <xsl:apply-templates select="xsd:annotation"/>
            </xsl:variable>
            <xsl:variable name="ncdftypedoc">
                <xsl:choose>
                    <xsl:when test="$numchange/@ncdftypedoc">
                        <xsl:value-of select="$numchange/@ncdftypedoc"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$mtfdoc"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ncdfelementdoc">
                <xsl:choose>
                    <xsl:when test="$numchange/@ncdftypedoc">
                        <xsl:value-of select="replace($numchange/@ncdftypedoc, 'A data type', 'A data item')"/>
                    </xsl:when>
                    <xsl:when test="$numchange/@ncdftypedoc">
                        <xsl:value-of select="replace($numchange/@ncdftypedoc, 'A data type', 'A data item')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace($mtfdoc, 'A data type', 'A data item')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="appinfo">
                <xsl:apply-templates select="xsd:annotation/xsd:appinfo"/>
            </xsl:variable>
            <xsl:variable name="ffirn" select="xsd:annotation/xsd:appinfo/*:FieldFormatIndexReferenceNumber"/>
            <xsl:variable name="fud" select="xsd:annotation/xsd:appinfo/*:FudNumber"/>
            <xsl:variable name="numnormstype" select="$numsimpletypes/Numeric[@base = $base][@min = $min][@max = $max]"/>
            <xsl:variable name="numpat" select="$numsimpletypes/Numeric[@base = $base][@min = $min][@max = $max][@pattern = $pattern]"/>
            <xsl:choose>
                <xsl:when test="$base = 'xsd:integer'">
                    <xsl:variable name="ncdfsimpletypename">
                        <xsl:choose>
                            <xsl:when test="$numpat/@ncdfsimpletypename">
                                <xsl:value-of select="$numpat/@ncdfsimpletypename"/>
                            </xsl:when>
                            <xsl:when test="$numnormstype/@ncdfsimpletypename">
                                <xsl:value-of select="$numnormstype/@ncdfsimpletypename"/>
                            </xsl:when>
                            <xsl:when test="$numchange/@ncdftype">
                                <xsl:value-of select="concat(substring($numchange/@ncdftype, 0, string-length($numchange/@ncdftype) - 3), 'SimpleType')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($ncdftypename, 'SimpleType')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <Field mtftype="{@name}" ncdfelementname="{$ncdfelementname}" ncdfsimpletype="{$ncdfsimpletypename}" ncdftype="{$ncdfcomplextype}" base="xsd:integer" min="{$min}" max="{$max}" pattern="{$pattern}" ncdfpattern="{$ncdfpattern}"
                        ncdfelementdoc="{$ncdfelementdoc}" mtfdoc="{$mtfdoc}" ncdftypedoc="{$ncdftypedoc}" ffirn="{$ffirn}" fud="{$fud}" format="{@format}" version="{@version}"
                        dist="{@dist}" remark="{@remark}">
                        <fappinfo>
                            <xsl:for-each select="$appinfo/*">
                                <xsl:copy-of select="mtfappinfo:Field" copy-namespaces="no"/>
                            </xsl:for-each>
                        </fappinfo>
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
                        <xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*:MinimumDecimalPlaces"/>
                    </xsl:variable>
                    <xsl:variable name="maxdec">
                        <xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*:MaximumDecimalPlaces"/>
                    </xsl:variable>
                    <xsl:variable name="fractionDigits">
                        <xsl:choose>
                            <xsl:when test="string-length($mindec)&gt;0">
                                <xsl:value-of select="$mindec"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="FindMaxDecimals">
                                    <xsl:with-param name="value1">
                                        <xsl:value-of select="$min"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="value2">
                                        <xsl:value-of select="$max"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="totalDigit">
                        <xsl:call-template name="FindTotalDigitCount">
                            <xsl:with-param name="value1">
                                <xsl:value-of select="$min"/>
                            </xsl:with-param>
                            <xsl:with-param name="value2">
                                <xsl:value-of select="$max"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="totalDigitCount">
                        <xsl:choose>
                            <xsl:when test="number($maxlen)-1 &gt; number($totalDigit)">
                                <xsl:value-of select="number($maxlen)-1"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$totalDigit"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="numfracdigit" select="$numsimpletypes/Numeric[@base = $base][@min = $min][@max = $max][@fractiondigits= $fractionDigits][@totaldigits= $totalDigitCount]"/>
                    <xsl:variable name="numnormstype" select="$numsimpletypes/Numeric[@base = $base][@min = $min][@max = $max]"/>
                    <xsl:variable name="ncdfsimpletypename">
                        <xsl:choose>
                            <xsl:when test="$numchange/@ncdftype">
                                <xsl:value-of select="concat(substring($numchange/@ncdftype, 0, string-length($numchange/@ncdftype) - 3), 'SimpleType')"/>
                            </xsl:when>
                            <xsl:when test="$numchange/@ncdfsimpletypename">
                                <xsl:value-of select="$numchange/@ncdfsimpletypename"/>
                            </xsl:when>
                            <xsl:when test="$numpat/@ncdfsimpletypename">
                                <xsl:value-of select="$numpat/@ncdfsimpletypename"/>
                            </xsl:when>
                            <xsl:when test="$numfracdigit/@ncdfsimpletypename">
                                <xsl:value-of select="$numfracdigit/@ncdfsimpletypename"/>
                            </xsl:when>
                            <xsl:when test="$numnormstype/@ncdfsimpletypename">
                                <xsl:value-of select="$numnormstype/@ncdfsimpletypename"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($ncdftypename, 'SimpleType')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <Field mtftype="{@name}" ncdfelementname="{$ncdfelementname}" ncdfsimpletype="{$ncdfsimpletypename}" ncdftype="{$ncdfcomplextype}" base="xsd:decimal" min="{$min}" max="{$max}"
                        fractionDigits="{$fractionDigits}" totalDigits="{$totalDigitCount}" ncdfelementdoc="{$ncdfelementdoc}" ncdftypedoc="{$ncdftypedoc}" mtfdoc="{$mtfdoc}"
                        ffirn="{$ffirn}" fud="{$fud}" length="{$length}" minlen="{$minlen}" maxlen="{$maxlen}" mindec="{$mindec}" maxdec="{$maxdec}">
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

    <xsl:variable name="normnumericsxsd">
        <xsl:apply-templates select="$numsimpletypes/Numeric" mode="makeSimpleType"/>
    </xsl:variable>

    <!--Create SimpleType from Normalized SimpleTypes -->
    <xsl:template match="Numeric" mode="makeSimpleType">
        <xsd:simpleType name="{@ncdfsimpletypename}">
            <xsd:annotation>
                <xsd:documentation>
                    <xsl:value-of select="@ncdftypedoc"/>
                </xsd:documentation>
                <xsd:appinfo>
                    <mtfappinfo:SimpleType name="{@simpletypename}">
                        <xsl:if test="@format !='.'">
                            <xsl:attribute name="format">
                                <xsl:value-of select="@format"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="version">
                            <xsl:value-of select="@version"/>
                        </xsl:attribute>
                        <xsl:attribute name="versiondate">
                            <xsl:value-of select="@versiondate"/>
                        </xsl:attribute>
                        <xsl:attribute name="remark">
                            <xsl:value-of select="@remark"/>
                        </xsl:attribute>
                        <xsl:attribute name="distribution">
                            <xsl:value-of select="@dist"/>
                        </xsl:attribute>
                    </mtfappinfo:SimpleType>
                </xsd:appinfo>
            </xsd:annotation>
            <xsd:restriction base="{@base}">
                <xsd:minInclusive value="{@min}"/>
                <xsd:maxInclusive value="{@max}"/>
                <xsl:if test="@totaldigits !='.'">
                    <xsd:totalDigits value="{@totaldigits}"/>
                </xsl:if>
                <xsl:if test="@fractiondigits !='.'">
                    <xsd:fractionDigits value="{@fractiondigits}"/>
                </xsl:if>
                <xsl:if test="@ncdfpattern !='.'">
                    <xsd:pattern value="{@ncdfpattern}"/>
                </xsl:if>
            </xsd:restriction>
        </xsd:simpleType>
    </xsl:template>

    <!--Create XSD from XML Map-->
    <xsl:variable name="numericsxsd">
        <xsl:for-each select="$numerics/Field">
            <xsl:sort select="@ncdfsimpletype"/>
            <xsl:variable name="nst" select="@ncdfsimpletype"/>
            <xsl:choose>
                <xsl:when test="$normnumericsxsd/*[@name = $nst]"/>
                <xsl:otherwise>
                    <xsd:simpleType name="{@ncdfsimpletype}">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="@ncdftypedoc"/>
                            </xsd:documentation>
                            <xsd:appinfo>
                                <xsl:for-each select="fappinfo/*">
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
                </xsl:otherwise>
            </xsl:choose>
            <xsd:complexType name="{@ncdftype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@ncdftypedoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="fappinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                </xsd:annotation>
                <xsd:simpleContent>
                    <xsd:extension base="{@ncdfsimpletype}">
                        <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                    </xsd:extension>
                </xsd:simpleContent>
            </xsd:complexType>
            <xsd:element name="{@ncdfelementname}" type="{@ncdftype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@ncdfelementdoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="fappinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:for-each select="$normnumericsxsd/*">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
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

<!--    <xsl:template name="main">
        <xsl:result-document href="{$xsdoutputdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:ncdf:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.ncdf.gov/ncdf/conformanceTargets/3.0/"
                xmlns:structures="http://release.ncdf.gov/ncdf/structures/4.0/" xmlns:term="http://release.ncdf.gov/ncdf/localTerminology/3.0/"
                xmlns:appinfo="http://release.ncdf.gov/ncdf/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:ncdf:mtf" ct:conformanceTargets="http://reference.ncdf.gov/ncdf/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/structures/4.0/" schemaLocation="../NCDF/structures.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/localTerminology/3.0/" schemaLocation="../NCDF/localTerminology.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/appinfo/4.0/" schemaLocation="../NCDF/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NCDF/mtfappinfo.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Numeric Fields for MTF Messages</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
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
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$numericsout}">
            <Numerics>
                <xsl:for-each select="$numerics">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </Numerics>
        </xsl:result-document>
    </xsl:template>-->

</xsl:stylesheet>
