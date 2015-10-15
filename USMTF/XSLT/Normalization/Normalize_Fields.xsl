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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <!--  This XSLT refactors baseline USMTF "fields" XML Schema by replacing annotation elements
    with attributes, removing unused elements and other adjustments-->

    <!--Fields from the baseline Composites XML Schema are also included as ComplexTypes in accordance with the intent to 
    consolidate fields and composites as global elements in the "Fields" XML Schema for the GoE refactor.-->
    
    <xsl:variable name="fields_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')"/>
    <xsl:variable name="normalized_fields_xsd" select="document('../../XSD/Normalized/NormalizedSimpleTypes.xsd')"/>

    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="strings_xsd"
        select="$fields_xsd/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern]"/>
    <xsl:variable name="integers_xsd"
        select="$fields_xsd/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:integer']]"/>
    <xsl:variable name="decimals_xsd"
        select="$fields_xsd/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:decimal']]"/>
    <xsl:variable name="enumerations_xsd"
        select="$fields_xsd/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string'][xsd:enumeration]]"/>
    
    <!--Output-->
    <xsl:variable name="string_outputdoc" select="'../../XSD/Normalized/Strings.xsd'"/>
    <xsl:variable name="integersoutputdoc" select="'../../XSD/Normalized/Integers.xsd'"/>
    <xsl:variable name="decimalsoutputdoc" select="'../../XSD/Normalized/Decimals.xsd'"/>
    <xsl:variable name="enumerationsoutdoc" select="'../../XSD/Normalized/Enumerations.xsd'"/>

    <!--A normalized list of xsd:string types with common REGEX patterns without length qualifiers for re-use globally-->
    <xsl:variable name="normalizedstrtypes"
        select="$normalized_fields_xsd/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern]"/>
    <xsl:variable name="normenumerationtypes"
        select="$normalized_fields_xsd/*/xsd:simpleType[xsd:restriction/xsd:enumeration]"/>

    <xsl:variable name="str_types">
        <xsl:for-each select="$strings_xsd">
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
                <xsl:when
                    test="$normalizedstrtypes/xsd:restriction/xsd:pattern/@value = $patternvalue">
                    <!--Will use normalized type .. don't process-->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="stypes"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>

    <!-- Contains a list of all baseline and normalized xsd:simpleTypes for sorting on output.-->
    <xsl:variable name="allstrtypes">
        <xsl:for-each select="$normalizedstrtypes">
            <xsd:complexType name="{concat(substring-before(@name,'SimpleType'),'Type')}">
            <xsd:simpleContent>
                <xsd:restriction base="FieldStringBaseType">
                <xsl:choose>
                    <xsl:when test="@name='AlphaNumericBlankSpecialTextSimpleType'">
                            <xsd:pattern value="{concat(./xsd:restriction/xsd:pattern/@value,'+')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                            <xsd:pattern value="{./xsd:restriction/xsd:pattern/@value}"/>
                    </xsl:otherwise>
                </xsl:choose>
                </xsd:restriction>
            </xsd:simpleContent>
            </xsd:complexType>
        </xsl:for-each>
        <xsl:for-each select="$str_types/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <!-- Contains a list of xsd:elements with normalized xsd:simpleTypes and 
        including xsd:maxLength and xsd:minLength extensions for xsd:simpleTypes 
        with base xsd:string-->
    <xsl:variable name="global_strelements">
        <xsl:apply-templates select="$strings_xsd" mode="el">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsd:element name="BlankSpaceCharacter" type="BlankSpaceType"/>
    </xsl:variable>

    <xsl:variable name="integers">
        <xsl:apply-templates select="$integers_xsd" mode="int"/>
    </xsl:variable>
    
    <xsl:variable name="decimals">
        <xsl:apply-templates select="$decimals_xsd" mode="dec"/>
    </xsl:variable>

    <!--xsd:simpleTypes with Enumerations-->
    <xsl:variable name="enumtypes">
        <xsl:apply-templates select="$enumerations_xsd">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>
    
    <!--This returns a list of generated enumeration xsd:elements and associated unique xsd:simpleType-->
    <xsl:variable name="enumelementsandtypes">
        <xsl:apply-templates select="$enumtypes/*" mode="el"/>
    </xsl:variable>
    
    <!--This consolidates normalized and unique enumeration xsd:simpleTypes for sorting  -->
    <xsl:variable name="combinedstrTypes">
        <xsl:for-each select="$normenumerationtypes">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$enumelementsandtypes/*[name() = 'xsd:simpleType']">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    

    <!--    OUTPUT RESULT-->
    <xsl:template match="/">
        <xsl:result-document href="{$string_outputdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:ism="urn:us:gov:ic:ism:v2"
                targetNamespace="urn:mtf:mil:6040b:fields" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                
                <xsd:complexType name="FieldStringBaseType">
                    <xsd:simpleContent>
                        <xsd:extension base="xsd:string">
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        </xsd:extension>
                    </xsd:simpleContent>
                </xsd:complexType>
                
                <xsl:for-each select="$allstrtypes/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$global_strelements/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$integersoutputdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:ism="urn:us:gov:ic:ism:v2"
                targetNamespace="urn:mtf:mil:6040b:fields" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:complexType name="FieldIntegerBaseType">
                    <xsd:simpleContent>
                        <xsd:extension base="xsd:integer">
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        </xsd:extension>
                    </xsd:simpleContent>
                </xsd:complexType>
                <xsl:for-each select="$integers/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$decimalsoutputdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:ism="urn:us:gov:ic:ism:v2"
                targetNamespace="urn:mtf:mil:6040b:fields" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:complexType name="FieldDecimalBaseType">
                    <xsd:simpleContent>
                        <xsd:extension base="xsd:decimal">
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        </xsd:extension>
                    </xsd:simpleContent>
                </xsd:complexType>
                <xsl:for-each select="$decimals/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$enumerationsoutdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                xmlns:ism="urn:us:gov:ic:ism:v2"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:fields"
                xml:lang="en-US"
                elementFormDefault="unqualified"
                attributeFormDefault="unqualified">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:complexType name="FieldEnumeratedBaseType">
                    <xsd:simpleContent>
                        <xsd:extension base="xsd:string">
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        </xsd:extension>
                    </xsd:simpleContent>
                </xsd:complexType>
                <xsl:for-each select="$combinedstrTypes/*">
                    <xsl:sort select="@name"/>
                    <xsd:complexType name="{concat(substring-before(@name,'SimpleType'),'Type')}">
                        <xsl:copy-of select="xsd:annotation"/>
                        <xsd:simpleContent>
                            <xsd:restriction base="FieldEnumeratedBaseType">
                                <xsl:for-each select="xsd:restriction/xsd:enumeration">
                                    <xsl:copy-of select="."/>
                                </xsl:for-each>
                            </xsd:restriction>
                        </xsd:simpleContent>
                    </xsd:complexType>
                </xsl:for-each>
                <xsl:for-each select="$enumelementsandtypes/*[name() = 'xsd:element']">
                    <xsl:sort select="@name"/>
                    <xsd:element name="{@name}" type="{concat(substring-before(@type,'SimpleType'),'Type')}">
                        <xsl:copy-of select="xsd:annotation"/>
                    </xsd:element>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <!-- ******************** SIMPLE TYPES ******************** -->
    <xsl:template match="xsd:simpleType" mode="stypes">
        <xsd:complexType name="{@name}">
            <xsd:simpleContent>
                <xsd:restriction base="FieldStringBaseType">
                    <xsd:pattern value="{./xsd:restriction/xsd:pattern/@value}"/>
                </xsd:restriction>
            </xsd:simpleContent>
        </xsd:complexType>
    </xsl:template>

    <!--Call patternValue template to remove min and max length qualifiers in RegEx
    for matching and output-->
    <xsl:template match="xsd:pattern">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="value">
                <xsl:call-template name="patternValue">
                    <xsl:with-param name="pattern" select="replace(@value,'&#x20;',' ')"/>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>

    <!--Remove min and max length qualifiers in RegEx for matching with normaized types-->
    <xsl:template name="patternValue">
        <xsl:param name="pattern"/>
        <!--TEST FOR MIN MAX IN REGEX-->
        <xsl:choose>
            <!--If Ends with max min strip off-->
            <xsl:when
                test="$normalizedstrtypes/xsd:schema/xsd:simpleType/xsd:restriction/xsd:pattern/@value = $pattern">
                <xsl:value-of select="$pattern"/>
            </xsl:when>
            <xsl:when test="ends-with($pattern, '}')">
                <xsl:choose>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 6), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 6)"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 5), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 5)"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 4), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 4)"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 3), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 3)"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 2), '{')">
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
    <xsl:template match="xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern][not(@name='BlankSpaceCharacterBaseType')][not(@name='FreeTextBaseType')]" mode="el">
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
                <xsl:when
                    test="$normalizedstrtypes/xsd:restriction/xsd:pattern/@value = $pattern">
                    <xsl:value-of
                        select="$normalizedstrtypes[xsd:restriction/xsd:pattern/@value = $pattern]/@name"
                    />
                </xsl:when>
                <xsl:when
                    test="$normalizedstrtypes/xsd:restriction/xsd:pattern/@value = $patternvalue">
                    <xsl:value-of
                        select="$normalizedstrtypes[xsd:restriction/xsd:pattern/@value = $patternvalue]/@name"
                    />
                </xsl:when>
                <!--If there is is no match - will use current type-->
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="xsd:element">
            <xsl:attribute name="name">
                <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
            </xsl:attribute>
            <xsl:apply-templates select="xsd:annotation"/>
            <xsd:complexType>
                <xsd:simpleContent>
                <xsl:choose>
                    <xsl:when test="string-length($type) > 0">
                        <xsd:restriction base="{concat(substring-before($type,'SimpleType'),'Type')}">
                            <xsl:apply-templates select="xsd:restriction/*" mode="el"/>
                        </xsd:restriction>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsd:restriction
                            base="{concat(substring-before(@name,'SimpleType'),'Type')}">
                            <xsl:apply-templates select="xsd:restriction/*" mode="el"/>
                        </xsd:restriction>
                    </xsl:otherwise>
                </xsl:choose>
                </xsd:simpleContent>
            </xsd:complexType>
        </xsl:element>
    </xsl:template>
    <!-- _______________________________________________________ -->

    <!-- ******************** Integer Types ******************** -->
    <xsl:template match="xsd:simpleType" mode="int">
        <xsl:variable name="nm">
            <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
        </xsl:variable>
        <xsl:variable name="min" select="xsd:restriction/xsd:minInclusive/@value"/>
        <xsl:variable name="max" select="xsd:restriction/xsd:maxInclusive/@value"/>
        <xsl:element name="xsd:element">
            <xsl:attribute name="name">
                <xsl:value-of select="$nm"/>
            </xsl:attribute>
            <xsl:apply-templates select="xsd:annotation"/>
            <xsd:complexType>
                <xsd:simpleContent>
                    <xsl:element name="xsd:restriction">
                        <xsl:attribute name="base">
                            <xsl:text>FieldIntegerBaseType</xsl:text>
                        </xsl:attribute>
                        <xsl:copy-of select="xsd:restriction/xsd:minInclusive" copy-namespaces="no"/>
                        <xsl:copy-of select="xsd:restriction/xsd:maxInclusive" copy-namespaces="no"/>
                        <xsl:copy-of select="xsd:restriction/xsd:pattern" copy-namespaces="no"/>
                    </xsl:element>
                </xsd:simpleContent>
            </xsd:complexType>
        </xsl:element>
    </xsl:template>
    
    <!-- ******************** Decimal Types ******************** -->
    <xsl:template match="xsd:simpleType" mode="dec">
        <xsl:variable name="nm">
            <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
        </xsl:variable>
        <xsl:variable name="min" select="xsd:restriction/xsd:minInclusive/@value"/>
        <xsl:variable name="max" select="xsd:restriction/xsd:maxInclusive/@value"/>
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
        <xsl:element name="xsd:element">
            <xsl:attribute name="name">
                <xsl:value-of select="$nm"/>
            </xsl:attribute>
            <xsl:apply-templates select="xsd:annotation"/>
            <xsd:complexType>
                <xsd:simpleContent>
                    <xsl:element name="xsd:restriction">
                        <xsl:attribute name="base">
                            <xsl:text>FieldDecimalBaseType</xsl:text>
                        </xsl:attribute>
                        <xsl:copy-of select="xsd:restriction/xsd:minInclusive" copy-namespaces="no"/>
                        <xsl:copy-of select="xsd:restriction/xsd:maxInclusive" copy-namespaces="no"/>
                        <xsl:element name="xsd:fractionDigits">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$fractionDigits"/>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="xsd:totalDigits">
                            <xsl:attribute name="value">
                                <xsl:value-of select="number($maxlen) - 1"/>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:copy-of select="xsd:restriction/xsd:pattern" copy-namespaces="no"/>
                    </xsl:element>
                </xsd:simpleContent>
            </xsd:complexType>
        </xsl:element>
    </xsl:template>
    
    <!-- Determine how many placeholders are represented in the decimal value -->
    <xsl:template name="FindMaxDecimals">
        <xsl:param name="value1"/>
        <xsl:param name="value2"/>
        <xsl:choose>
            <xsl:when test="contains($value1, '.') and contains($value2, '.')">
                <xsl:if
                    test="
                    (string-length(substring-after($value1, '.')) >
                    string-length(substring-after($value2, '.')))">
                    <xsl:value-of select="string-length(substring-after($value1, '.'))"/>
                </xsl:if>
                <xsl:if
                    test="
                    (string-length(substring-after($value1, '.')) &lt;
                    string-length(substring-after($value2, '.')))">
                    <xsl:value-of select="string-length(substring-after($value2, '.'))"/>
                </xsl:if>
                <xsl:if
                    test="
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
                    <xsl:value-of
                        select="substring-after(concat(substring-before($value1, '.'), substring-after($value1, '.')), '-')"
                    />
                </xsl:when>
                <xsl:when test="contains($value1, '.')">
                    <xsl:value-of
                        select="concat(substring-before($value1, '.'), substring-after($value1, '.'))"
                    />
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
                    <xsl:value-of
                        select="substring-after(concat(substring-before($value2, '.'), substring-after($value2, '.')), '-')"
                    />
                </xsl:when>
                <xsl:when test="contains($value2, '.')">
                    <xsl:value-of
                        select="concat(substring-before($value2, '.'), substring-after($value2, '.'))"
                    />
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
    
    <!-- ******************** SIMPLE TYPE ENUM  ELEMENTS ********************  -->
    <!-- ******** simpleType Generation ********-->
    <xsl:template match="xsd:simpleType">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xsd:simpleType/@name">
        <xsl:attribute name="name">
            <xsl:value-of select="concat(substring(., 0, string-length(.) - 3), 'SimpleType')"/>
        </xsl:attribute>
    </xsl:template>
    
    <!-- ******** Element Generation ********-->
    
    <xsl:template match="xsd:simpleType" mode="el">
        <xsl:variable name="restr" select="xsd:restriction"/>
        <xsl:variable name="match">
            <xsl:copy-of select="$normenumerationtypes[deep-equal(xsd:restriction, $restr)]"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string-length($match/*/@name) > 0">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="name">
                        <xsl:value-of select="substring-before(@name, 'SimpleType')"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="$match/*/@name"/>
                    </xsl:attribute>
                    <xsl:copy-of select="xsd:annotation"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="xsd:element">
                    <xsl:attribute name="name">
                        <xsl:value-of select="substring-before(@name, 'SimpleType')"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="@name"/>
                    </xsl:attribute>
                    <xsl:copy-of select="xsd:annotation"/>
                </xsl:element>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*:FudName" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt = ' ') and not(*) and not($txt = '')">
            <xsl:attribute name="name">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*:DataCode" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt = ' ') and not(*) and not($txt = '')">
            <xsl:attribute name="dataCode">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*:DataItem" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt = ' ') and not(*) and not($txt = '')">
            <xsl:attribute name="dataItem">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    
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

    <xsl:template match="xsd:annotation" mode="el"/>

    <!--Copy annotation only it has descendents with text content-->
    <!--Add xsd:documentation using FudExplanation if it exists-->
    <xsl:template match="xsd:annotation">
        <xsl:if test="*//text()">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="@*"/>
                <xsl:if
                    test="exists(xsd:appinfo/*:FudExplanation) and not(xsd:documentation/text())">
                    <xsl:element name="xsd:documentation">
                        <xsl:value-of select="normalize-space(xsd:appinfo[1]/*:FudExplanation[1])"/>
                    </xsl:element>
                </xsl:if>
                <xsl:apply-templates select="*"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!--Copy documentation only it has text content-->
    <xsl:template match="xsd:documentation">
        <xsl:if test="text()">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="text()"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!--Copy element and use template mode to convert elements to attributes-->
    <xsl:template match="xsd:appinfo">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="exists(ancestor::xsd:enumeration)">
                    <xsl:element name="Enum" namespace="urn:mtf:mil:6040b:fields">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="Field" namespace="urn:mtf:mil:6040b:fields">
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

    <!-- ******************** FILTERS ******************** -->
    <xsl:template match="*[@name = 'FreeTextType']"/>
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
    <xsl:template
        match="xsd:restriction/xsd:pattern[exists(parent::xsd:restriction/xsd:enumeration)]"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:integer']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:string']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:decimal']/xsd:annotation"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber" mode="attr"/>
    <xsl:template match="*:FudNumber" mode="attr"/>
    <xsl:template match="*:VersionIndicator" mode="attr"/>
    <xsl:template match="*:MinimumLength" mode="attr"/>
    <xsl:template match="*:MaximumLength" mode="attr"/>
    <xsl:template match="*:LengthLimitation" mode="attr"/>
    <xsl:template match="*:Type" mode="attr"/>
    <xsl:template match="*:FudRelatedDocument" mode="attr"/>
    <xsl:template match="*:ffirnFudn" mode="attr"/>
    <xsl:template match="*:DataType" mode="attr"/>
    <xsl:template match="*:EntryType" mode="attr"/>
    <xsl:template match="*:MtfRegularExpression" mode="attr"/>
    <xsl:template match="*:MinimumInclusiveValue" mode="attr"/>
    <xsl:template match="*:MaximumInclusiveValue" mode="attr"/>
    <xsl:template match="*:Explanation" mode="attr"/>
    <xsl:template match="*:FudExplanation" mode="attr"/>
    <xsl:template match="*:UnitOfMeasure" mode="attr"/>
    <xsl:template match="*:FudSponsor" mode="attr"/>
    <xsl:template match="*:LengthVariable" mode="attr"/>
    <xsl:template match="*:DataItemSponsor" mode="attr"/>
    <xsl:template match="*:DataItemSequenceNumber" mode="attr"/>
    
    <xsl:template match="*:FudName">
        <Field name="{text()}"/>
    </xsl:template>
    <xsl:template match="*:FudExplanation"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber"/>
    <xsl:template match="*:FudNumber"/>
    <xsl:template match="*:VersionIndicator"/>
    <xsl:template match="*:MinimumLength"/>
    <xsl:template match="*:MaximumLength"/>
    <xsl:template match="*:LengthLimitation"/>
    <xsl:template match="*:UnitOfMeasure"/>
    <xsl:template match="*:Type"/>
    <xsl:template match="*:FudSponsor"/>
    <xsl:template match="*:FudRelatedDocument"/>
    <xsl:template match="*:DataType"/>
    <xsl:template match="*:EntryType"/>
    <xsl:template match="*:Explanation"/>
    <xsl:template match="*:MinimumInclusiveValue"/>
    <xsl:template match="*:MaximumInclusiveValue"/>
    <xsl:template match="*:LengthVariable"/>
    <!-- _______________________________________________________ -->
</xsl:stylesheet>
