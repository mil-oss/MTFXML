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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="../USMTF_NIEM/USMTF_Utility.xsl"/>

    <xsl:variable name="strings_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern]"/>
    <xsl:variable name="string_changes" select="document('../../XSD/Refactor_Changes/StringChanges.xml')"/>

    <xsl:variable name="normalized" select="document('../../XSD/Normalized/NormalizedSimpleTypes.xsd')/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern]"/>

    <!--Output-->
    <xsl:variable name="xsdoutputdoc" select="'../../XSD/Normalized/Strings.xsd'"/>
    <xsl:variable name="normstringsout" select="'../../XSD/Test/MTF_XML_Maps/NIEM_Normalized_Strings.xml'"/>

    <!--    <xsl:variable name="normstringtypes">
        <xsl:for-each select="$strings_xsd">
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="ch" select="@changeto"/>
            <xsl:if test="not(preceding-sibling::CodeList[1]/@changeto = $ch)">
                <xsl:variable name="codes" select="$codelists/CodeList[@name = $n][1]/Codes"/>
                <xsl:variable name="stype" select="concat(substring($ch, 0, string-length($ch) - 3), 'CodeSimpleType')"/>
                <xsl:variable name="ctype" select="concat(substring($ch, 0, string-length($ch) - 3), 'CodeType')"/>
                <xsl:variable name="el" select="concat(substring($n, 0, string-length($n) - 3), 'Code')"/>
                <xsd:simpleType name="{$stype}">
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="@doc"/>
                        </xsd:documentation>
                    </xsd:annotation>
                    <xsd:restriction base="xsd:string">
                        <xsl:for-each select="$codes/Code">
                            <xsd:enumeration value="{@value}">
                                <xsd:annotation>
                                    <xsd:documentation>
                                        <xsl:value-of select="@doc"/>
                                    </xsd:documentation>
                                    <xsd:appinfo>
                                        <Code dataItem="{@dataItem}"/>
                                    </xsd:appinfo>
                                </xsd:annotation>
                            </xsd:enumeration>
                        </xsl:for-each>
                    </xsd:restriction>
                </xsd:simpleType>
                <xsd:complexType name="{$ctype}">
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="@doc"/>
                        </xsd:documentation>
                    </xsd:annotation>
                    <xsd:simpleContent>
                        <xsd:extension base="{$stype}">
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                            <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                        </xsd:extension>
                    </xsd:simpleContent>
                </xsd:complexType>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

-->

    <xsl:variable name="strings">
        <xsl:apply-templates select="$strings_xsd" mode="maptype">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="normstrings">
        <Strings>
            <xsl:for-each select="$strings/String">
                <xsl:variable name="p" select="@niempattern"/>
                <xsl:copy>
                    <!--<xsl:for-each select="@*">
                        <xsl:copy-of select="@mtfname"/>
                    </xsl:for-each>-->
                    <xsl:copy-of select="@mtfname"/>
                    <!--<xsl:copy-of select="@niemsimpletype"/>-->
                    <!--<xsl:copy-of select="@niemcomplextype"/>-->
                    <!--<xsl:copy-of select="@niemelementname"/>-->
                    <xsl:if test="$normalized/xsd:restriction/xsd:pattern/@value = $p">
                        <xsl:attribute name="NormalizedType">
                            <xsl:value-of select="$normalized[xsd:restriction/xsd:pattern/@value = $p]/@name"/>
                            <!--<xsl:value-of select="$p"/>-->
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:copy-of select="@pattern"/>
                    <xsl:copy-of select="@mtfname"/>
                    <xsl:copy-of select="@minLength"/>
                    <xsl:copy-of select="@maxLength"/>
                    <xsl:copy-of select="@length"/>
                </xsl:copy>
            </xsl:for-each>
        </Strings>
    </xsl:variable>

    <xsl:variable name="normstringsxsd">
        <xsl:for-each select="$normstrings/String">
            <xsl:sort select="@niemsimpletype"/>
            <xsd:simpleType name="{@niemsimpletype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                </xsd:annotation>
                <xsd:restriction base="{@base}">
                    <xsd:pattern value="{@niempattern}"/>
                    <xsl:if test="@length">
                        <xsd:length value="{@length}"/>
                    </xsl:if>
                    <xsl:if test="@minLength">
                        <xsd:minLength value="{@minLength}"/>
                    </xsl:if>
                    <xsl:if test="@maxLength">
                        <xsd:maxLength value="{@maxLength}"/>
                    </xsl:if>
                </xsd:restriction>
            </xsd:simpleType>
            <xsd:complexType name="{@niemcomplextype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                </xsd:annotation>
                <xsd:simpleContent>
                    <xsd:extension base="{@niemsimpletype}">
                        <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                    </xsd:extension>
                </xsd:simpleContent>
            </xsd:complexType>
            <xsd:element name="{@niemelementname}" type="{@niemcomplextype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemelementdoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:copy-of select="appinfo/*"/>
                    </xsd:appinfo>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>

    <!--Remove min and max length qualifiers in RegEx for matching with normalized types-->
    <xsl:template name="patternValue">
        <xsl:param name="pattern"/>
        <!--TEST FOR MIN MAX IN REGEX-->
        <xsl:choose>
            <!--If Ends with max min strip off-->
            <xsl:when test="ends-with($pattern, '}')">
                <xsl:choose>
                    <xsl:when test="starts-with(substring($pattern, string-length($pattern) - 6), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 6)"/>
                    </xsl:when>
                    <xsl:when test="starts-with(substring($pattern, string-length($pattern) - 5), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 5)"/>
                    </xsl:when>
                    <xsl:when test="starts-with(substring($pattern, string-length($pattern) - 4), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 4)"/>
                    </xsl:when>
                    <xsl:when test="starts-with(substring($pattern, string-length($pattern) - 3), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 3)"/>
                    </xsl:when>
                    <xsl:when test="starts-with(substring($pattern, string-length($pattern) - 2), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 2)"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$pattern"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:simpleType" mode="maptype">
        <xsl:param name="mtfsimpletype"/>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="change" select="$string_changes/StringTypeChanges/String[@name = $mtfname]"/>
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="fromtype"/>
        </xsl:variable>
        <xsl:variable name="niemterm">
            <xsl:call-template name="niemTerm">
                <xsl:with-param name="str" select="$n"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="niemelementname">
            <xsl:choose>
                <xsl:when test="$change/@niemelementname">
                    <xsl:value-of select="$change/@niemelementname"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Code')">
                    <xsl:value-of select="replace($n, 'Code', 'Text')"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Indicator')">
                    <xsl:value-of select="replace($n, 'Indicator', 'Text')"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Number')">
                    <xsl:value-of select="replace($n, 'Number', 'Numeric')"/>
                </xsl:when>
                <xsl:when test="$niemterm/NIEMTerm">
                    <xsl:value-of select="$n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($n, 'Text')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="pattern" select="xsd:restriction/xsd:pattern/@value"/>
        <xsl:variable name="patternvalue">
            <!-- Remove length qualifiers-->
            <xsl:call-template name="patternValue">
                <xsl:with-param name="pattern">
                    <xsl:value-of select="$pattern"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="niempattern">
            <xsl:choose>
                <xsl:when test="ends-with($patternvalue, '}')">
                    <xsl:value-of select="$patternvalue"/>
                </xsl:when>
                <xsl:when test="ends-with($patternvalue, '*')">
                    <xsl:value-of select="$patternvalue"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$patternvalue"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemsimpletype">
            <xsl:choose>
                <!--Compare unadjusted pattern-->
                <xsl:when test="$change/@name = $mtfname">
                    <xsl:value-of select="concat(substring($change/@niemtype, 0, string-length($change/@niemtype) - 3), 'SimpleType')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($niemelementname, 'SimpleType')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemcomplextype">
            <xsl:value-of select="concat($niemelementname, 'Type')"/>
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
        <xsl:variable name="minlength">
            <xsl:value-of select="xsd:restriction/xsd:minLength/@value"/>
        </xsl:variable>
        <xsl:variable name="maxlength">
            <xsl:value-of select="xsd:restriction/xsd:maxLength/@value"/>
        </xsl:variable>
        <xsl:variable name="length">
            <xsl:value-of select="xsd:restriction/xsd:length/@value"/>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo"/>
        </xsl:variable>
        <String mtfname="{@name}" niemsimpletype="{$niemsimpletype}" niemcomplextype="{$niemcomplextype}" niemelementname="{$niemelementname}" base="xsd:string" pattern="{$pattern}"
            niempattern="{$niempattern}" niemelementdoc="{$niemelementdoc}" mtfdoc="{$mtfdoc}" niemtypedoc="{$niemtypedoc}">
            <xsl:if test="string-length($length) &gt; 0">
                <xsl:attribute name="length" select="$length"/>
            </xsl:if>
            <xsl:if test="string-length($minlength) &gt; 0">
                <xsl:attribute name="minLength" select="$minlength"/>
            </xsl:if>
            <xsl:if test="string-length($maxlength) &gt; 0">
                <xsl:attribute name="maxLength" select="$maxlength"/>
            </xsl:if>
            <appinfo>
                <xsl:copy-of select="$appinfo/*/*" copy-namespaces="no"/>
            </appinfo>
        </String>
    </xsl:template>

    <!-- _______________________________________________________ -->
    <!--    OUTPUT RESULT-->
    <xsl:template name="main">
        <!--<xsl:result-document href="{$xsdoutputdoc}">
            <xsl:call-template name="NIEMReferenceSchema">
                <xsl:with-param name="schemadoc">
                    <xsl:text>String fields for MTF Messages</xsl:text>
                </xsl:with-param>
                <xsl:with-param name="content">
                    <xsl:for-each select="$normstringsxsd/xsd:simpleType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="not(preceding-sibling::xsd:simpleType/@name = $n)">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$normstringsxsd/xsd:complexType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$normstringsxsd/xsd:element">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="not(preceding-sibling::xsd:element/@name = $n)">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:result-document>-->
        <xsl:result-document href="{$normstringsout}">
            <Strings>
                <xsl:for-each select="$normstrings/Strings/String">
                    <xsl:sort select="@pattern"/>
                    <xsl:variable name="pat">
                        <xsl:value-of select="@pattern"/>
                    </xsl:variable>
                    <xsl:variable name="min">
                        <xsl:value-of select="@minLength"/>
                    </xsl:variable>
                    <xsl:variable name="max">
                        <xsl:value-of select="@maxLength"/>
                    </xsl:variable>
                    <xsl:variable name="len">
                        <xsl:value-of select="@length"/>
                    </xsl:variable>
                    <xsl:variable name="pre_pat">
                        <xsl:value-of select="preceding-sibling::String[1]/@pattern"/>
                    </xsl:variable>
                    <xsl:variable name="pre_min">
                        <xsl:value-of select="preceding-sibling::String[1]/@minLength"/>
                    </xsl:variable>
                    <xsl:variable name="pre_max">
                        <xsl:value-of select="preceding-sibling::String[1]/@maxLength"/>
                    </xsl:variable>
                    <xsl:variable name="pre_len">
                        <xsl:value-of select="preceding-sibling::String[1]/@length"/>
                    </xsl:variable>
                    <xsl:if test="$pat=$pre_pat and $min=$pre_min and $max=$pre_max and $len=$pre_len">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </Strings>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
