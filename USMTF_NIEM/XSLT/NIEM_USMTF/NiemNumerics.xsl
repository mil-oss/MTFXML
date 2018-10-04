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
    <!--<xsl:include href="USMTF_Utility.xsl"/>-->
    <!--Input-->

    <!--Test Output-->
    <xsl:variable name="xsdoutputdoc" select="'../../XSD/Analysis/Normalized/Numerics_NIEM.xsd'"/>
    <xsl:variable name="numericsout" select="'../../XSD/Test/MTF_XML_Maps/NIEM_Numerics_NIEM.xml'"/>
    <xsl:variable name="nsdir" select="'../../XSD/'"/>
    <xsl:variable name="nfld_changes" select="document(concat($nsdir, 'Refactor_Changes/FieldChanges.xml'))/FieldChanges"/>

    <xsl:variable name="numsimpletypes" select="document(concat($nsdir, 'Refactor_Changes/M201804C0IF-NumericSimpleTypes.xml'))/NumericSimpleTypes"/>

    <xsl:variable name="integers_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:integer']]"/>

    <xsl:variable name="decimals_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:decimal']]"/>

    <!--Fragment containing all integer and decimal SimpleTypes from Original XML Schema-->
    <xsl:variable name="numerics_xsd">
        <xsl:for-each select="$integers_xsd">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$decimals_xsd">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="version" select="'C.0.01.00'"/>
    <xsl:variable name="date" select="'October 2018'"/>
    <xsl:variable name="remark" select="'Created by ICP M2018-02.'"/>

    <!--Create XML Map of Original XML Schema-->
    <xsl:variable name="numerics">
        <xsl:for-each select="$numerics_xsd/*">
            <xsl:sort select="@name"/>
            <xsl:variable name="mtfname" select="@name"/>
            <xsl:variable name="min" select="xsd:restriction/xsd:minInclusive/@value"/>
            <xsl:variable name="max" select="xsd:restriction/xsd:maxInclusive/@value"/>
            <xsl:variable name="pattern" select="xsd:restriction/xsd:pattern/@value"/>
            <xsl:variable name="totaldigits" select="xsd:restriction/xsd:totalDigits/@value"/>
            <xsl:variable name="base" select="xsd:restriction/@base"/>
            <xsl:variable name="numchange" select="$nfld_changes/*:Numeric[@name = $mtfname]"/>
            <xsl:variable name="e">
                <xsl:choose>
                    <xsl:when test="ends-with(@name, 'Type')">
                        <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemelementname">
                <xsl:choose>
                    <xsl:when test="$numchange/@niemelementname">
                        <xsl:value-of select="$numchange/@niemelementname"/>
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
            <xsl:variable name="niemcomplextype" select="concat($niemtypename, 'Type')"/>
            <xsl:variable name="niempattern">
                <xsl:choose>
                    <xsl:when test="$numchange/@niempattern">
                        <xsl:value-of select="$numchange/@niempattern"/>
                    </xsl:when>
                    <xsl:when test="$numchange/@niempattern">
                        <xsl:value-of select="$numchange/@niempattern"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$numchange/@pattern"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="mtfdoc">
                <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
            </xsl:variable>
            <xsl:variable name="niemtypedoc">
                <xsl:choose>
                    <xsl:when test="$numchange/@niemtypedoc">
                        <xsl:value-of select="$numchange/@niemtypedoc"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$mtfdoc"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemelementdoc">
                <xsl:choose>
                    <xsl:when test="$numchange/@niemtypedoc">
                        <xsl:value-of select="replace($numchange/@niemtypedoc, 'A data type', 'A data item')"/>
                    </xsl:when>
                    <xsl:when test="$numchange/@niemtypedoc">
                        <xsl:value-of select="replace($numchange/@niemtypedoc, 'A data type', 'A data item')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace($mtfdoc, 'A data type', 'A data item')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="fappinfo">
                <xsl:apply-templates select="xsd:annotation/xsd:appinfo"/>
            </xsl:variable>
            <xsl:variable name="ffirn" select="xsd:annotation/xsd:appinfo/*:FieldFormatIndexReferenceNumber"/>
            <xsl:variable name="fud" select="xsd:annotation/xsd:appinfo/*:FudNumber"/>
            <xsl:choose>
                <xsl:when test="$base = 'xsd:integer'">
                    <xsl:variable name="numnormstype">
                        <xsl:choose>
                            <xsl:when test="starts-with(@name, 'ContextQuantity')">
                                <xsl:copy-of select="$numsimpletypes/*:Numeric[@base = $base][@min = $min][@max = $max]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="$numsimpletypes/*:Numeric[@base = $base][@min = $min][@max = $max][@totaldigits = $totaldigits][@pattern = $pattern]"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="niemsimpletypename">
                        <xsl:choose>
                            <xsl:when test="$numnormstype/*/@niemsimpletypename">
                                <xsl:value-of select="$numnormstype/*/@niemsimpletypename"/>
                            </xsl:when>
                            <xsl:when test="$numchange/*/@niemtype">
                                <xsl:value-of select="concat(substring($numchange/*/@niemtype, 0, string-length($numchange/@niemtype) - 3), 'SimpleType')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($niemtypename, 'SimpleType')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="complextypename">
                        <xsl:choose>
                            <xsl:when test="$numnormstype/*/@niemsimpletypename">
                                <xsl:value-of select="replace($numnormstype/*/@niemsimpletypename, 'SimpleType', 'Type')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$niemcomplextype"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <Field mtftype="{@name}" niemelementname="{$niemelementname}" niemsimpletype="{$niemsimpletypename}" niemtype="{$complextypename}" base="xsd:integer" min="{$min}" max="{$max}"
                        pattern="{$pattern}" niempattern="{$niempattern}" niemelementdoc="{$niemelementdoc}" mtfdoc="{$mtfdoc}" niemtypedoc="{$niemtypedoc}" ffirn="{$ffirn}" fud="{$fud}"
                        format="{$numnormstype/*/@format}" version="{$version}" date="{$version}" dist="{$numnormstype/*/@dist}" remark="{$remark}">
                        <fappinfo>
                            <xsl:for-each select="$fappinfo/*">
                                <xsl:copy>
                                    <xsl:for-each select="@*">
                                        <xsl:copy-of select="."/>
                                    </xsl:for-each>
                                    <xsl:attribute name="ffirn">
                                        <xsl:value-of select="$ffirn"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="fud">
                                        <xsl:value-of select="$fud"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="version">
                                        <xsl:value-of select="$version"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="date">
                                        <xsl:value-of select="$date"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="remark">
                                        <xsl:value-of select="$remark"/>
                                    </xsl:attribute>
                                </xsl:copy>
                            </xsl:for-each>
                        </fappinfo>
                    </Field>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="length" select="xsd:restriction/xsd:length"/>
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
                            <xsl:when test="number($mindec) &gt; 0">
                                <xsl:value-of select="$mindec"/>
                            </xsl:when>
                            <xsl:when test="number($maxdec) &gt; 0">
                                <xsl:value-of select="$maxdec"/>
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
                    <xsl:variable name="calcTotalDigit">
                        <xsl:call-template name="FindTotalDigitCount">
                            <xsl:with-param name="value1">
                                <xsl:value-of select="$min"/>
                            </xsl:with-param>
                            <xsl:with-param name="value2">
                                <xsl:value-of select="$max"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="totaldigits">
                        <xsl:choose>
                            <xsl:when test="number($maxlen) - 1 &gt; number($calcTotalDigit)">
                                <xsl:value-of select="number($maxlen) - 1"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$calcTotalDigit"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="numnormstype">
                        <xsl:choose>
                            <xsl:when test="starts-with(@name, 'ContextQuantity')">
                                <xsl:copy-of
                                    select="$numsimpletypes/*:Numeric[@base = $base][number(@min) = number($min)][number(@max) = number($max)][@fractiondigits = $fractionDigits][@totaldigits = $totaldigits]"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of
                                    select="$numsimpletypes/*:Numeric[@base = $base][@min = $min][@max = $max][@fractiondigits = $fractionDigits][@totaldigits = $totaldigits][@pattern = $pattern]"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="complextypename">
                        <xsl:choose>
                            <xsl:when test="$numnormstype/*/@niemsimpletypename">
                                <xsl:value-of select="replace($numnormstype/*[1]/@niemsimpletypename, 'SimpleType', 'Type')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$niemcomplextype"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="niemsimpletypename">
                        <xsl:choose>
                            <xsl:when test="$numchange/@niemtype">
                                <xsl:value-of select="concat(substring($numchange/@niemtype, 0, string-length($numchange/@niemtype) - 3), 'SimpleType')"/>
                            </xsl:when>
                            <xsl:when test="$numchange/@niemsimpletypename">
                                <xsl:value-of select="$numchange/@niemsimpletypename"/>
                            </xsl:when>
                            <xsl:when test="$numnormstype/*/@niemsimpletypename">
                                <xsl:value-of select="$numnormstype/*[1]/@niemsimpletypename"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($niemtypename, 'SimpleType')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <Field mtftype="{@name}" niemelementname="{$niemelementname}" niemsimpletype="{$niemsimpletypename}" niemtype="{$complextypename}" base="xsd:decimal" min="{$min}" max="{$max}"
                        fractiondigits="{$fractionDigits}" totaldigits="{$totaldigits}" niemelementdoc="{$niemelementdoc}" niemtypedoc="{$niemtypedoc}" mtfdoc="{$mtfdoc}" ffirn="{$ffirn}" fud="{$fud}"
                        length="{$length}" minlen="{$minlen}" maxlen="{$maxlen}" mindec="{$mindec}" maxdec="{$maxdec}">
                        <fappinfo>
                            <mtfappinfo:Field>
                            <xsl:for-each select="$fappinfo/*">
                                <xsl:copy>
                                    <xsl:for-each select="@*">
                                        <xsl:copy-of select="."/>
                                    </xsl:for-each>
                                    <xsl:attribute name="ffirn">
                                        <xsl:value-of select="@ffirn"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="fud">
                                        <xsl:value-of select="@fud"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="version">
                                        <xsl:value-of select="@version"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="date">
                                        <xsl:value-of select="@date"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="remark">
                                        <xsl:value-of select="@remark"/>
                                    </xsl:attribute>
                                </xsl:copy>
                            </xsl:for-each>
                            </mtfappinfo:Field>
                        </fappinfo>
                    </Field>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="normnumericsxsd">
        <xsl:apply-templates select="$numsimpletypes/Numeric" mode="makeSimpleType"/>
    </xsl:variable>

    <!--Create SimpleType from Normalized SimpleTypes -->
    <xsl:template match="*:Numeric" mode="makeSimpleType">
        <xsd:simpleType name="{@niemsimpletypename}">
            <xsd:annotation>
                <xsd:documentation>
                    <xsl:value-of select="normalize-space(@niemtypedoc)"/>
                </xsd:documentation>
                <xsd:appinfo>
                    <mtfappinfo:SimpleType name="{@simpletypename}">
                        <xsl:if test="@format != '.'">
                            <xsl:attribute name="format">
                                <xsl:value-of select="@format"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:attribute name="ffirn">
                            <xsl:value-of select="@ffirn"/>
                        </xsl:attribute>
                        <xsl:attribute name="fud">
                            <xsl:value-of select="@fud"/>
                        </xsl:attribute>
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
                <xsl:apply-templates select="@min" mode="fix"/>
                <xsl:apply-templates select="@max" mode="fix"/>
                <xsl:if test="@totaldigits != '.'">
                    <xsd:totalDigits value="{@totaldigits}"/>
                </xsl:if>
                <xsl:if test="@fractiondigits != '.'">
                    <xsd:fractionDigits value="{@fractiondigits}"/>
                </xsl:if>
                <xsl:if test="@niempattern != '.'">
                    <xsd:pattern value="{@niempattern}"/>
                </xsl:if>
            </xsd:restriction>
        </xsd:simpleType>
    </xsl:template>

    <xsl:template match="@min" mode="fix">
        <xsl:variable name="mn">
            <xsl:choose>
                <xsl:when test="contains(string(number(.)), 'E')">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="number(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="starts-with($mn, '0.')">
                <xsd:minInclusive value="{substring-after($mn, '0')}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsd:minInclusive value="{$mn}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@max" mode="fix">
        <xsl:variable name="mx">
            <xsl:choose>
                <xsl:when test="contains(string(number(.)), 'E')">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="number(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="starts-with($mx, '0.')">
                <xsd:maxInclusive value="{substring-after($mx, '0')}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsd:maxInclusive value="{$mx}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Create XSD from XML Map-->
    <xsl:variable name="numericsxsd">
        <xsl:for-each select="$numerics/Field">
            <xsl:sort select="@niemsimpletype"/>
            <xsl:variable name="nst" select="@niemsimpletype"/>
            <xsl:choose>
                <xsl:when test="$normnumericsxsd/*[@name = $nst]"/>
                <xsl:otherwise>
                    <xsd:simpleType name="{@niemsimpletype}">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="normalize-space(@niemtypedoc)"/>
                            </xsd:documentation>
                            <xsd:appinfo>
                                <xsl:for-each select="*:fappinfo/*">
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xsl:for-each>
                            </xsd:appinfo>
                        </xsd:annotation>
                        <xsd:restriction base="{@base}">
                            <xsl:apply-templates select="@min" mode="fix"/>
                            <xsl:apply-templates select="@max" mode="fix"/>
                            <xsl:if test="@fractiondigits">
                                <xsd:fractionDigits value="{@fractiondigits}"/>
                            </xsl:if>
                            <xsl:if test="@totaldigits">
                                <xsd:totalDigits value="{@totaldigits}"/>
                            </xsl:if>
                        </xsd:restriction>
                    </xsd:simpleType>
                </xsl:otherwise>
            </xsl:choose>
            <xsd:complexType name="{@niemtype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="normalize-space(@niemtypedoc)"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="*:fappinfo/*">
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
            <xsd:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="normalize-space(@niemelementdoc)"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="*:fappinfo/*">
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

    <xsl:template name="numerics">
        <xsl:result-document href="{$xsdoutputdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf" ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NIEM/mtfappinfo.xsd"/>
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
    </xsl:template>

</xsl:stylesheet>
