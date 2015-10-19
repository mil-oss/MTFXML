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
    consolidate fields and composites as global elements in the "Fields" XML Schema for the GoE refactor.
    type references are converted to local.-->

    <!--Normalized Fields XML Schema documents-->
    <xsl:variable name="string_fields_xsd" select="document('../../XSD/Normalized/Strings.xsd')"/>
    <xsl:variable name="integer_fields_xsd" select="document('../../XSD/Normalized/Integers.xsd')"/>
    <xsl:variable name="decimal_fields_xsd" select="document('../../XSD/Normalized/Decimals.xsd')"/>
    <xsl:variable name="enumerated_fields_xsd"
        select="document('../../XSD/Normalized/Enumerations.xsd')"/>
    <!--Composite Fields Baseline XML Schema document-->
    <xsl:variable name="composites_xsd"
        select="document('../../XSD/Baseline_Schema/composites.xsd')"/>
    <!--Simple Fields Baseline XML Schema document-->
    <xsl:variable name="fields_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')"/>
    <!--Normalized xsd:simpleTypes-->
    <xsl:variable name="normalizedsimpletypes"
        select="document('../../XSD/Normalized/NormalizedSimpleTypes.xsd')"/>

    <!--Output Document-->
    <xsl:variable name="output_fields_xsd" select="'../../XSD/GoE_Schema/GoE_fields.xsd'"/>

    <!--Consolidated xsd:simpleTypes and xsd:elements for local referenece by xsd:complexTypes-->
    <xsl:variable name="refactor_fields_xsd">
        <xsl:text>&#10;</xsl:text>
        <xsl:comment> ************** STRING FIELDS **************</xsl:comment>
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="$string_fields_xsd/xsd:schema/*[not(name()='xsd:import')]">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:comment>************** INTEGER FIELDS **************</xsl:comment>
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="$integer_fields_xsd/xsd:schema/*[not(name()='xsd:import')]">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:comment>*************** DECIMAL FIELDS **************</xsl:comment>
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="$decimal_fields_xsd/xsd:schema/*[not(name()='xsd:import')]">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:comment>************* ENUMERATED FIELDS *************</xsl:comment>
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="$enumerated_fields_xsd/xsd:schema/*[not(name()='xsd:import')]">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <!-- **************-->
    <!--Build re-factored xsd:complexTypes using GoE schema design and references-->
    <xsl:variable name="complex_types_xsd">
        <xsl:apply-templates select="$composites_xsd/xsd:schema/xsd:complexType"/>
    </xsl:variable>

    <xsl:variable name="complex_elements">
        <xsl:apply-templates select="$complex_types_xsd/*" mode="el"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="{$output_fields_xsd}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:goe:fields"
                xmlns:ism="urn:us:gov:ic:ism:v2"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:goe:fields"
                xml:lang="en-US"
                elementFormDefault="unqualified"
                attributeFormDefault="unqualified">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsl:copy-of select="$refactor_fields_xsd"/>
                <xsl:text>&#10;</xsl:text>
                <xsl:comment> ************** COMPOSITE TYPES **************</xsl:comment>
                <xsl:text>&#10;</xsl:text>
                <xsl:for-each select="$complex_types_xsd/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:text>&#10;</xsl:text>
                <xsl:comment> ************** COMPOSITE ELEMENTS **************</xsl:comment>
                <xsl:text>&#10;</xsl:text>
                <xsl:for-each select="$complex_elements/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <!-- ******************** COMPLEX TYPES ******************** -->
    <!--Copy root level complexTypes-->
    <xsl:template match="xsd:complexType">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!--Create global xsd:element nodes for xsd:complexTypes -->
    <xsl:template match="xsd:complexType" mode="el">
        <xsd:element>
            <xsl:attribute name="name">
                <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
        </xsd:element>
    </xsl:template>

    <!-- Replace type names with normalized type names for xsd:element nodes used in xsd:complexTypes-->
    <xsl:template match="xsd:element[@type]">
        <xsl:variable name="nm">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:variable name="typename">
            <xsl:choose>
                <xsl:when test="starts-with(@type, 'f:')">
                    <xsl:value-of select="substring-after(@type, 'f:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@type"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--Use Regex from baseline fields without min max qalifiers to match with normalized types-->
        <xsl:variable name="typepattern">
            <xsl:call-template name="patternValue">
                <xsl:with-param name="pattern"
                    select="$fields_xsd/xsd:simpleType[@name = $nm]/xsd:restriction/xsd:pattern/@value"
                />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when
                    test="$normalizedsimpletypes//xsd:simpleType/xsd:restriction/xsd:pattern/@value = $typepattern">
                    <xsl:value-of
                        select="$normalizedsimpletypes//xsd:simpleType[xsd:restriction/xsd:pattern/@value = $typepattern]/@name"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="concat(substring($typename, 0, string-length($typename) - 3), 'SimpleType')"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--Use modifed name to replace elements with numeric qualifiers in the names with references to global types-->
        <xsl:variable name="refName">
            <xsl:value-of select="substring-before($nm, '_')"/>
        </xsl:variable>
        <xsl:choose>
            <!--Create reference when name matches global type-->
            <xsl:when test="$refactor_fields_xsd//@name = $nm">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="$nm"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="*"/>
                </xsl:copy>
            </xsl:when>

            <!--Create reference when modifed name matches global type-->
            <xsl:when test="exists($refactor_fields_xsd/*[@name = $refName])">
                <xsd:element ref="{$refName}">
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsd:element>
            </xsl:when>

            <!--Eliminate BlankSpaceCharacter type name variants-->
            <xsl:when test="starts-with(@name, 'BlankSpaceCharacter')">
                <xsd:element ref="BlankSpaceCharacter">
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsd:element>
            </xsl:when>

            <!--Include element name variants with normalized type-->
            <xsl:when test="starts-with($nm, 'BlankSpace')">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="name">
                        <xsl:value-of select="$nm"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:text>BlankSpaceSimpleType</xsl:text>
                    </xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:when
                test="exists($fields_xsd/*[@name = $type]/xsd:restriction[@base = 'xsd:string']/xsd:pattern)">
                <xsl:apply-templates select="$fields_xsd/*[@name = $type]" mode="el"/>
            </xsl:when>
            <!--Use type complex name or simple type name from matching normalized simple type-->
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="type">
                        <xsl:choose>
                            <xsl:when test="$composites_xsd//xsd:complexType/@name = $typename">
                                <xsl:value-of select="$typename"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="elname">
                                    <xsl:value-of
                                        select="substring($typename, 0, string-length($typename) - 3)"
                                    />
                                </xsl:variable>
                                <xsl:value-of select="$refactor_fields_xsd/*[@name = $elname]/@type"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates select="*"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Call patternValue template to remove min and max length qualifiers in RegEx
    for matching and output-->
    <xsl:template match="xsd:pattern">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="value">
                <xsl:call-template name="patternValue">
                    <xsl:with-param name="pattern" select="@value"/>
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
                test="$normalizedsimpletypes/xsd:schema/xsd:simpleType/xsd:restriction/xsd:pattern/@value = $pattern">
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

    <!-- ******************** FORMATTING ******************** -->
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
        <xsl:if test="not(preceding-sibling::xsd:appinfo)">
            <xsl:copy copy-namespaces="no">
                <xsl:element name="Field" namespace="urn:mtf:mil:6040b:goe:fields">
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="*" mode="attr"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::xsd:appinfo">
                    <xsl:element name="Field" namespace="urn:mtf:mil:6040b:goe:fields">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:copy>
        </xsl:if>
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
    <xsl:template match="xsd:element/xsd:annotation"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber" mode="attr"/>
    <xsl:template match="*:FudNumber" mode="attr"/>
    <xsl:template match="*:FudRelatedDocument" mode="attr"/>

    <!-- _______________________________________________________ -->

</xsl:stylesheet>
