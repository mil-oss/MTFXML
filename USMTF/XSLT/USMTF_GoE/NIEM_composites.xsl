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
    <xsl:include href="USMTF_Utility.xsl"/>
    <!--  This XSLT refactors baseline USMTF "fields" XML Schema by replacing annotation elements
    with attributes, removing unused elements and other adjustments-->
    <!--Fields from the baseline Composites XML Schema are also included as ComplexTypes in accordance with the intent to 
    consolidate fields and composites as global elements in the "Fields" XML Schema for the GoE refactor.
    type references are converted to local.-->
    <!--Normalized Fields XML Schema documents-->

    <!--Composite Fields Baseline XML Schema document-->
    <xsl:variable name="composites_xsd" select="document('../../XSD/Baseline_Schema/composites.xsd')"/>
    <!--Simple Fields Baseline XML Schema document-->
    <xsl:variable name="fields_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')"/>
    <!--Simple Fields Baseline XML Schema document-->
    <xsl:variable name="niem_fields_xsd" select="document('../../XSD/NIEM_Schema/NIEM_fields.xsd')"/>
    <!--Normalized xsd:simpleTypes-->
    <xsl:variable name="normalizedsimpletypes" select="document('../../XSD/Normalized/NormalizedSimpleTypes.xsd')"/>
    <xsl:variable name="normenumerationtypes" select="$normalizedsimpletypes/*/xsd:simpleType[xsd:restriction/xsd:enumeration]"/>
    <xsl:variable name="string_type_changes" select="document('../../XSD/Normalized/StringTypeChanges.xml')/StringChanges"/>
    <xsl:variable name="enumeration_type_changes" select="document('../../XSD/Normalized/EnumerationTypeChanges.xml')/EnumerationChanges"/>
    <!--Output Document-->
    <xsl:variable name="output_fields_xsd" select="'../../XSD/NIEM_Schema/NIEM_composites.xsd'"/>
    <!--Consolidated xsd:simpleTypes and xsd:elements for local referenece by xsd:complexTypes-->
    <!--*****************************************************-->
    <!--Build re-factored xsd:complexTypes using GoE schema design and references-->
    <xsl:variable name="complex_types_xsd">
        <xsl:apply-templates select="$composites_xsd/xsd:schema/xsd:complexType" mode="composite"/>
    </xsl:variable>
    <xsl:variable name="complex_elements">
        <xsl:for-each select="$composites_xsd/xsd:schema/xsd:complexType">
            <xsl:variable name="nn">
                <xsl:apply-templates select="@name" mode="fromtype"/>
            </xsl:variable>
            <xsl:variable name="typ">
                <xsl:choose>
                    <xsl:when test="@name = 'BeaconType'">
                        <xsl:text>BeaconSignalType</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsd:element name="{$nn}" type="{$typ}" nillable="true">
                <xsl:apply-templates select="xsd:annotation"/>
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>
    <!--*****************************************************-->
    <xsl:template name="main">
        <xsl:result-document href="{$output_fields_xsd}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:goe:composites" xmlns:ism="urn:us:gov:ic:ism:v2" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:mtf="urn:mtf:mil:6040b:goe"
                xmlns:f="urn:mtf:mil:6040b:goe:fields" xmlns:structures="http://release.niem.gov/niem/structures/3.0/" targetNamespace="urn:mtf:mil:6040b:goe:composites" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="0.1">
                <xsd:import namespace="urn:mtf:mil:6040b:goe:fields" schemaLocation="NIEM_fields.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/3.0/" schemaLocation="structures.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>NIEM XML Schema for MTF Composite Fields.</xsd:documentation>
                </xsd:annotation>
                <xsl:for-each select="$complex_types_xsd/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$complex_elements/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>
    <!--*****************************************************-->
    <!-- ******************** COMPLEX TYPES ******************** -->
    <!--Copy root level complexTypes-->
    <xsl:template match="xsd:complexType" mode="composite">
        <xsl:variable name="n">
            <xsl:choose>
                <xsl:when test="@name = 'BeaconType'">
                    <xsl:text>BeaconSignalType</xsl:text>
                </xsl:when>
                <xsl:when test="ends-with(@name, 'Type')">
                    <xsl:value-of select="@name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@name" mode="txt"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="annot">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="doc">
            <xsl:value-of select="substring-after($annot/*/xsd:documentation, 'A data type for ')"/>
        </xsl:variable>
        <xsl:variable name="eldoc">
            <xsl:value-of select="concat(upper-case(substring($doc, 1, 1)), substring($doc, 2))"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="name">
                <xsl:value-of select="$n"/>
            </xsl:attribute>
            <xsl:copy-of select="$annot"/>
            <xsd:complexContent>
                <xsd:extension base="structures:ObjectType">
                    <xsd:sequence>
                        <xsl:apply-templates select="xsd:sequence/*"/>
                    </xsd:sequence>
                </xsd:extension>
            </xsd:complexContent>
        </xsl:copy>
        <xsl:if test="not($n = @name)">
            <Change name="{@name}" changeto="{$n}"/>
        </xsl:if>
        <!--<xsd:element name="{substring($n, 0, string-length($n) - 3)}" type="{$n}" nillable="true">
            <xsd:annotation>
                <xsd:documentation>
                    <xsl:value-of select="$eldoc"/>
                </xsd:documentation>
            </xsd:annotation>
        </xsd:element>-->
    </xsl:template>

    <!-- Replace type names with normalized type names for xsd:element nodes used in xsd:complexTypes-->
    <xsl:template match="xsd:element[@type]">
        <xsl:variable name="typ">
            <xsl:value-of select="substring-after(@type, ':')"/>
        </xsl:variable>
        <xsl:variable name="t">
            <xsl:apply-templates select="@type" mode="fromtype"/>
        </xsl:variable>
        <xsl:variable name="nm">
            <xsl:apply-templates select="@name" mode="txt"/>
        </xsl:variable>
        <xsl:variable name="n" select="@name"/>

        <xsl:variable name="fldref">
            <xsl:choose>
                <xsl:when test="$niem_fields_xsd/xsd:schema/xsd:element[@name = $t]">
                    <xsl:value-of select="concat('f:', $t)"/>
                </xsl:when>
                <xsl:when test="$niem_fields_xsd/xsd:schema/xsd:element[@name = $nm]">
                    <xsl:value-of select="concat('f:', $nm)"/>
                </xsl:when>
                <xsl:when test="$string_type_changes/Change/@name = $typ">
                    <xsl:value-of select="concat('f:', substring-before($string_type_changes/Change[@name = $typ]/@changeto, 'SimpleType'))"/>
                </xsl:when>
                <xsl:when test="$enumeration_type_changes/Change/@name = $typ">
                    <xsl:value-of select="concat('f:', substring-before($enumeration_type_changes/Change[@name = $typ]/@changeto, 'SimpleType'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="typepattern">
                        <xsl:call-template name="patternValue">
                            <xsl:with-param name="pattern" select="$fields_xsd/xsd:simpleType[@name = $n]/xsd:restriction/xsd:pattern/@value"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$normalizedsimpletypes//xsd:simpleType/xsd:restriction/xsd:pattern/@value = $typepattern">
                            <xsl:value-of select="$normalizedsimpletypes//xsd:simpleType[xsd:restriction/xsd:pattern/@value = $typepattern]/@name"/>
                        </xsl:when>
                        <xsl:when test="$normalizedsimpletypes//xsd:simpleType[@name = $t]">
                            <xsl:value-of select="$normalizedsimpletypes//xsd:simpleType[@name = $t]/@name"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$nm"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsd:element ref="{$fldref}">
            <xsl:apply-templates select="@*[not(name() = 'name')][not(name() = 'type')]"/>
            <xsl:apply-templates select="xsd:annotation"/>
        </xsd:element>
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
            <xsl:when test="$normalizedsimpletypes/xsd:schema/xsd:simpleType/xsd:restriction/xsd:pattern/@value = $pattern">
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
    <xsl:template match="@name" mode="el">
        <xsl:copy>
            <xsl:apply-templates select="." mode="txt"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@type" mode="el">
        <xsl:copy>
            <xsl:apply-templates select="." mode="txt"/>
        </xsl:copy>
    </xsl:template>

    <!-- _______________________________________________________ -->
</xsl:stylesheet>
