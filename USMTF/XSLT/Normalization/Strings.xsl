<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2015 JD NEUSHUL
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

    <!--  This XSLT refactors baseline USMTF "fields" XML Schema by replacing annotation elements
    with attributes, removing unused elements and other adjustments-->

    <!--Fields from the baseline Composites XML Schema are also included as ComplexTypes in accordance with the intent to 
    consolidate fields and composites as global elements in the "Fields" XML Schema for the GoE refactor.-->

    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="mtf_str" select="document('../../XSD/Baseline_Schema/fields.xsd')/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern]"/>

    <xsl:variable name="outputdoc" select="'../../XSD/Normalized/Strings.xsd'"/>

    <!--A normalized list of xsd:string types with common REGEX patterns without length qualifiers for re-use globally-->
    <xsl:variable name="normalizedstrtypes" select="document('../../XSD/Normalized/NormalizedSimpleTypes.xsd')/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern]"/>


    <xsl:variable name="str_types">
        <xsl:for-each select="$mtf_str">
            <xsl:variable name="pattern" select="xsd:restriction/xsd:pattern/@value"/>
            <xsl:variable name="patternvalue">
                <!-- Remove length qualifiers-->
                <xsl:call-template name="patternValue">
                    <xsl:with-param name="pattern">
                        <xsl:value-of select="$pattern"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <!--Compare unadjusted pattern-->
                <xsl:when test="$normalizedstrtypes/xsd:restriction/xsd:pattern/@value = $pattern">
                    <!--Will use normalized type .. don't process-->
                </xsl:when>
                <!-- Compare with normalized types-->
                <xsl:when test="$normalizedstrtypes/xsd:restriction/xsd:pattern/@value = $patternvalue">
                    <!--Will use normalized type .. don't process-->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="stypes"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>

    <!-- Contains a list of all baseline and normalized xsd:simpleTypes for sorting on output.-->
    <xsl:variable name="alltypes">
        <xsl:for-each select="$normalizedstrtypes">
            <xsd:complexType name="{concat(substring-before(@name,'SimpleType'),'Type')}">
                <xsl:apply-templates select="xsd:annotation"/>
                <xsd:simpleContent>
                    <xsd:restriction base="FieldStringBaseType">
                        <xsl:choose>
                            <xsl:when test="ends-with(./xsd:restriction/xsd:pattern/@value, '}')">
                                <xsd:pattern value="{./xsd:restriction/xsd:pattern/@value}"/>
                            </xsl:when>
                            <xsl:when test="ends-with(./xsd:restriction/xsd:pattern/@value, '*')">
                                <xsd:pattern value="{./xsd:restriction/xsd:pattern/@value}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsd:pattern value="{concat(./xsd:restriction/xsd:pattern/@value,'+')}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsd:restriction>
                </xsd:simpleContent>
            </xsd:complexType>
        </xsl:for-each>
        <xsl:for-each select="$str_types/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$global_elements/xsd:complexType">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>


    <!-- Contains a list of xsd:elements with normalized xsd:simpleTypes and 
        including xsd:maxLength and xsd:minLength extensions for xsd:simpleTypes 
        with base xsd:string-->
    <xsl:variable name="global_elements">
        <xsl:apply-templates select="$mtf_str" mode="el">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsd:element name="BlankSpaceCharacter" type="BlankSpaceType" nillable="true">
            <xsd:annotation>
                <xsd:documentation>Blank entry</xsd:documentation>
            </xsd:annotation>
        </xsd:element>
        <xsd:element name="FreeText" type="FreeTextType" nillable="true">
            <xsd:annotation>
                <xsd:documentation>Text entry</xsd:documentation>
            </xsd:annotation>
        </xsd:element>
    </xsl:variable>


    <!--    OUTPUT RESULT-->
    <xsl:template name="main">
        <xsl:result-document href="{$outputdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:goe:fields" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ism="urn:us:gov:ic:ism:v2" targetNamespace="urn:mtf:mil:6040b:goe:fields"
                xml:lang="en-US" elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:complexType name="FieldStringBaseType">
                    <xsd:annotation>
                        <xsd:documentation>MTF String base type</xsd:documentation>
                    </xsd:annotation>
                    <xsd:simpleContent>
                        <xsd:extension base="xsd:string">
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        </xsd:extension>
                    </xsd:simpleContent>
                </xsd:complexType>
                <xsl:for-each select="$alltypes/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:choose>
                        <xsl:when test="$n = .//@base"/>
                        <xsl:when test="preceding-sibling::xsd:complexType/@name = $n"/>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:for-each select="$global_elements/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <!-- ******************** SIMPLE TYPES ******************** -->
    <xsl:template match="xsd:simpleType" mode="stypes">
        <xsd:complexType name="{@name}">
            <xsd:simpleContent>
                <xsd:restriction base="FieldStringBaseType">
                    <xsl:apply-templates select="xsd:restriction/*"/>
                </xsd:restriction>
            </xsd:simpleContent>
        </xsd:complexType>
    </xsl:template>

    <!--Call patternValue template to remove min and max length qualifiers in RegEx
    for matching and output-->
    <xsl:template match="xsd:pattern">
        <xsl:copy copy-namespaces="no">
            <xsl:variable name="val">
                <xsl:call-template name="patternValue">
                    <xsl:with-param name="pattern" select="replace(@value, '&#x20;', ' ')"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="value">
                <xsl:choose>
                    <xsl:when test="ends-with($val, '}')">
                        <xsl:value-of select="$val"/>
                    </xsl:when>
                    <xsl:when test="ends-with($val, '*')">
                        <xsl:value-of select="$val"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($val, '+')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>

    <!--Remove min and max length qualifiers in RegEx for matching with normaized types-->
    <xsl:template name="patternValue">
        <xsl:param name="pattern"/>
        <!--TEST FOR MIN MAX IN REGEX-->
        <xsl:choose>
            <!--If Ends with max min strip off-->
            <xsl:when test="$normalizedstrtypes/xsd:schema/xsd:simpleType/xsd:restriction/xsd:pattern/@value = $pattern">
                <xsl:value-of select="$pattern"/>
            </xsl:when>
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

    <!-- _______________________________________________________ -->

    <!-- ******************** SIMPLE TYPE STR ELEMENTS ********************  -->

    <!--Compare REGEX to create Elements using normalized SimpleTypes-->
    <xsl:template match="xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern][not(@name = 'BlankSpaceCharacterBaseType')][not(@name = 'FreeTextBaseType')]" mode="el">
        <xsl:variable name="pattern" select="xsd:restriction/xsd:pattern/@value"/>
        <!--TEST FOR MIN MAX IN REGEX-->
        <xsl:variable name="patternvalue">
            <xsl:call-template name="patternValue">
                <xsl:with-param name="pattern">
                    <xsl:value-of select="$pattern"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="type">
            <xsl:choose>
                <!--If there is is a match - use it-->
                <xsl:when test="$normalizedstrtypes/xsd:restriction/xsd:pattern/@value = $pattern">
                    <xsl:value-of select="$normalizedstrtypes[xsd:restriction/xsd:pattern/@value = $pattern]/@name"/>
                </xsl:when>
                <xsl:when test="$normalizedstrtypes/xsd:restriction/xsd:pattern/@value = $patternvalue">
                    <xsl:value-of select="$normalizedstrtypes[xsd:restriction/xsd:pattern/@value = $patternvalue]/@name"/>
                </xsl:when>
                <!--If there is is no match - will use current type-->
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="xsd:complexType">
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <!--<xsl:attribute name="nillable">true</xsl:attribute>-->
            <xsl:apply-templates select="xsd:annotation"/>
            <!--<xsd:complexType>-->
            <xsd:simpleContent>
                <xsl:choose>
                    <xsl:when test="string-length($type) > 0">
                        <xsd:restriction base="{concat(substring-before($type,'SimpleType'),'Type')}">
                            <xsl:apply-templates select="xsd:restriction/*"/>
                        </xsd:restriction>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsd:restriction base="{@name}">
                            <xsl:apply-templates select="xsd:restriction/*"/>
                        </xsd:restriction>
                    </xsl:otherwise>
                </xsl:choose>
            </xsd:simpleContent>
            <!--</xsd:complexType>-->
        </xsl:element>
        <xsl:element name="xsd:element">
            <xsl:attribute name="name">
                <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="nillable">true</xsl:attribute>
            <xsd:annotation>
                <xsd:documentation>
                    <xsl:value-of select="xsd:annotation/xsd:documentation"/>
                </xsd:documentation>
            </xsd:annotation>
        </xsl:element>
    </xsl:template>

    <!-- _______________________________________________________ -->

    <!-- ******** FORMATIING ********-->
    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="replace(., '&#34;', '')"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="el"/>
            <xsl:apply-templates select="*" mode="el"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="replace(., '&#34;', '')"/>
        </xsl:copy>
    </xsl:template>


    <!--Copy annotation only it has descendents with text content-->
    <!--Add xsd:documentation using FudExplanation if it exists-->
    <xsl:template match="xsd:annotation">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!--Copy documentation using FudExplanation or text content-->
    <xsl:template match="xsd:documentation">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="exists(xsd:appinfo/*:FudExplanation) and not(xsd:documentation/text())">
                    <xsl:apply-templates select="text()"/>
                </xsl:when>
                <xsl:when test="text()">
                    <xsl:apply-templates select="text()"/>
                </xsl:when>
                <xsl:otherwise>
                    <text>Data definition required</text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <!--Copy element and use template mode to convert elements to attributes-->
    <xsl:template match="xsd:appinfo">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="exists(ancestor::xsd:enumeration)">
                    <xsl:element name="Enum" namespace="urn:mtf:mil:6040b:goe:fields">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="Field" namespace="urn:mtf:mil:6040b:goe:fields">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <!--Convert elements in xsd:appinfo to attributes-->
    <xsl:template match="*" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt = ' ') and not(*) and not($txt = '')">
            <xsl:attribute name="{name()}">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!--Normalize extra whitespace and linefeeds in text-->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    <!-- _______________________________________________________ -->

    <xsl:template match="*:FudName" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt = ' ') and not(*) and not($txt = '')">
            <xsl:attribute name="name">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:FudExplanation" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt = ' ') and not(*) and not($txt = '')">
            <xsl:attribute name="explanation">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:VersionIndicator" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt = ' ') and not(*) and not($txt = '')">
            <xsl:attribute name="version">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>


    <!-- ******************** FILTERS ******************** -->
    <!--<xsl:template match="*[@name = 'FreeTextType']"/>-->
    <xsl:template match="*[@name = 'FreeTextBaseType']" mode="el"/>
    <xsl:template match="*[@name = 'FreeTextBase']" mode="el"/>
    <xsl:template match="*[@name = 'BlankSpaceCharacterType']"/>
    <xsl:template match="*[@name = 'BlankSpaceCharacterBaseType']" mode="el"/>
    <!--- Remove Pattern for element generation-->
    <xsl:template match="xsd:pattern" mode="el"/>
    <!--- Remove Pattern from type containing base of xsd:integer -->
    <xsl:template match="xsd:pattern[parent::xsd:restriction/@base = 'xsd:integer']"/>
    <!--- Remove Pattern from type containing base of xsd:decimal -->
    <xsl:template match="xsd:pattern[parent::xsd:restriction/@base = 'xsd:decimal']"/>
    <!--- Remove Pattern from enumerations -->
    <xsl:template match="xsd:restriction/xsd:pattern[exists(parent::xsd:restriction/xsd:enumeration)]"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:integer']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:string']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:decimal']/xsd:annotation"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber" mode="attr"/>
    <xsl:template match="*:FudNumber" mode="attr"/>
    <xsl:template match="*:MinimumLength" mode="attr"/>
    <xsl:template match="*:MaximumLength" mode="attr"/>
    <xsl:template match="*:LengthLimitation" mode="attr"/>
    <xsl:template match="*:Type" mode="attr"/>
    <xsl:template match="*:FudRelatedDocument" mode="attr"/>
    <xsl:template match="*:ffirnFudn" mode="attr"/>
    <xsl:template match="*:DataCode" mode="attr"/>
    <xsl:template match="*:DataType" mode="attr"/>
    <xsl:template match="*:EntryType" mode="attr"/>
    <xsl:template match="*:MtfRegularExpression" mode="attr"/>
    <xsl:template match="*:MinimumInclusiveValue" mode="attr"/>
    <xsl:template match="*:MaximumInclusiveValue" mode="attr"/>
    <xsl:template match="*:Explanation" mode="attr"/>
    <!-- _______________________________________________________ -->
</xsl:stylesheet>
