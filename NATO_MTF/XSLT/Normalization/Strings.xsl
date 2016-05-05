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
    <xsl:include href="../APP-11C-GoE/Utility.xsl"/>
    <!--  This XSLT refactors baseline USMTF "fields" XML Schema by replacing annotation elements
    with attributes, removing unused elements and other adjustments-->

    <!--Fields from the baseline Composites XML Schema are also included as ComplexTypes in accordance with the intent to 
    consolidate fields and composites as global elements in the "Fields" XML Schema for the GoE refactor.-->

    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="mtf_str" select="document('../../XSD/APP-11C-ch1/Consolidated/fields.xsd')/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern]"/>

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
            <xsl:variable name="nm">
                <xsl:value-of select="substring-before(@name, 'SimpleType')"/>
            </xsl:variable>
            <xsd:complexType name="{concat($nm,'Type')}">
                <xsl:apply-templates select="xsd:annotation">
                    <xsl:with-param name="nm" select="$nm"/>
                </xsl:apply-templates>
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
        <xsd:element name="BlankSpaceCharacter" type="BlankSpaceType">
            <xsd:annotation>
                <xsd:documentation>Blank Space Character</xsd:documentation>
            </xsd:annotation>
        </xsd:element>
    </xsl:variable>

    <!--    OUTPUT RESULT-->
    <xsl:template name="main">
        <xsl:result-document href="{$outputdoc}">
            <xsd:schema xmlns="urn:int:nato:mtf:app-11(c):goe:elementals" xmlns:xsd="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:int:nato:mtf:app-11(c):goe:elementals" xml:lang="en-GB"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:complexType name="FieldStringBaseType">
                    <xsd:annotation>
                        <xsd:documentation>MTF String base type</xsd:documentation>
                    </xsd:annotation>
                    <xsd:simpleContent>
                        <xsd:extension base="xsd:string"/>
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
        <xsl:variable name="nm">
            <xsl:apply-templates select="@name" mode="txt"/>
        </xsl:variable>
        <xsd:complexType>
            <xsl:attribute name="name">
                <xsl:value-of select="$nm"/>
            </xsl:attribute>
            <xsl:apply-templates select="xsd:annotation">
                <xsl:with-param name="nm" select="$nm"/>
            </xsl:apply-templates>
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
                    <xsl:apply-templates select="$normalizedstrtypes[xsd:restriction/xsd:pattern/@value = $pattern]/@name" mode="txt"/>
                </xsl:when>
                <xsl:when test="$normalizedstrtypes/xsd:restriction/xsd:pattern/@value = $patternvalue">
                    <xsl:apply-templates select="$normalizedstrtypes[xsd:restriction/xsd:pattern/@value = $patternvalue]/@name" mode="txt"/>
                </xsl:when>
                <!--If there is is no match - will use current type-->
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="xsd:complexType">
            <xsl:variable name="nm">
                <xsl:apply-templates select="@name" mode="txt"/>
            </xsl:variable>
            <xsl:variable name="t">
                <xsl:value-of select="concat(substring-before($type,'SimpleType'),'Type')"/>
            </xsl:variable>
            <xsl:attribute name="name">
                <xsl:value-of select="$nm"/>
            </xsl:attribute>
            <!--<xsl:attribute name="nillable">true</xsl:attribute>-->
            <xsl:apply-templates select="xsd:annotation">
                <xsl:with-param name="nm" select="$nm"/>
            </xsl:apply-templates>
            <!--<xsd:complexType>-->
            <xsd:simpleContent>
                <xsl:choose>
                    <xsl:when test="string-length($type) > 0">
                        <xsd:restriction base="{$t}">
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
            <xsl:variable name="nm">
                <xsl:apply-templates select="@name" mode="fromtype"/>
            </xsl:variable>
            <xsl:attribute name="name">
                <xsl:value-of select="$nm"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="concat($nm,'Type')"/>
            </xsl:attribute>
            <xsl:attribute name="nillable">true</xsl:attribute>
            <xsl:apply-templates select="xsd:annotation">
                <xsl:with-param name="nm" select="$nm"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <!-- _______________________________________________________ -->

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
                    <xsl:element name="Field" namespace="urn:int:nato:mtf:app-11(c):goe:elementals">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <!-- _______________________________________________________ -->


    <!-- ******************** FILTERS ******************** -->
    <!--<xsl:template match="*[@name = 'FreeTextType']"/>-->
    <xsl:template match="*[@name = 'FreeTextBaseType']" mode="stypes"/>
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

    <!-- _______________________________________________________ -->
</xsl:stylesheet>
