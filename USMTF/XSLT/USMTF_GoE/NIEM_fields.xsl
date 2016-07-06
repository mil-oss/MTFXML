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
    <xsl:variable name="string_fields_xsd" select="document('../../XSD/Normalized/Strings.xsd')"/>
    <xsl:variable name="integer_fields_xsd" select="document('../../XSD/Normalized/Integers.xsd')"/>
    <xsl:variable name="decimal_fields_xsd" select="document('../../XSD/Normalized/Decimals.xsd')"/>
    <xsl:variable name="enumerated_fields_xsd" select="document('../../XSD/Normalized/Enumerations.xsd')"/>
    <!--Composite Fields Baseline XML Schema document-->
<!--    <xsl:variable name="composites_xsd" select="document('../../XSD/Baseline_Schema/composites.xsd')"/>-->
    <!--Simple Fields Baseline XML Schema document-->
    <xsl:variable name="fields_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')"/>
    <!--Normalized xsd:simpleTypes-->
    <xsl:variable name="normalizedsimpletypes" select="document('../../XSD/Normalized/NormalizedSimpleTypes.xsd')"/>
    <xsl:variable name="normenumerationtypes" select="$normalizedsimpletypes/*/xsd:simpleType[xsd:restriction/xsd:enumeration]"/>
    <!--Output Document-->
    <xsl:variable name="output_fields_xsd" select="'../../XSD/NIEM_Schema/NIEM_fields.xsd'"/>
    <!--Consolidated xsd:simpleTypes and xsd:elements for local referenece by xsd:complexTypes-->
    <xsl:variable name="refactor_fields_xsd">
        <xsl:text>&#10;</xsl:text>
        <xsl:comment> ************** STRING FIELDS **************</xsl:comment>
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="$string_fields_xsd/xsd:schema/*[not(name() = 'xsd:import')]">
            <xsl:copy-of select="."/>
            <xsl:variable name="basename" select="substring-before(@name, 'SimpleType')"/>
            <xsl:variable name="annot">
                <xsl:apply-templates select="xsd:annotation"/>
            </xsl:variable>
            <xsl:variable name="doc">
                <xsl:value-of select="substring-after($annot/*/xsd:documentation, 'A data type for ')"/>
            </xsl:variable>
            <xsl:variable name="eldoc">
                <xsl:value-of select="concat(upper-case(substring($doc, 1, 1)), substring($doc, 2))"/>
            </xsl:variable>
            <xsd:complexType name="{concat($basename,'Type')}">
                <xsl:copy-of select="xsd:annotation"/>
                <xsd:simpleContent>
                    <xsd:extension base="{@name}">
                        <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                    </xsd:extension>
                </xsd:simpleContent>
            </xsd:complexType>
            <xsd:element name="{$basename}" type="{concat($basename,'Type')}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="$eldoc"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:comment>************** INTEGER FIELDS **************</xsl:comment>
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="$integer_fields_xsd/xsd:schema/*[not(name() = 'xsd:import')]">
            <xsl:copy-of select="."/>
            <xsl:variable name="basename" select="substring-before(@name, 'SimpleType')"/>
            <xsl:variable name="annot">
                <xsl:apply-templates select="xsd:annotation"/>
            </xsl:variable>
            <xsl:variable name="doc">
                <xsl:value-of select="substring-after($annot/*/xsd:documentation, 'A data type for ')"/>
            </xsl:variable>
            <xsl:variable name="eldoc">
                <xsl:value-of select="concat(upper-case(substring($doc, 1, 1)), substring($doc, 2))"/>
            </xsl:variable>
            <xsd:complexType name="{concat($basename,'Type')}">
                <xsl:copy-of select="xsd:annotation"/>
                <xsd:simpleContent>
                    <xsd:extension base="{@name}">
                        <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                    </xsd:extension>
                </xsd:simpleContent>
            </xsd:complexType>
            <xsd:element name="{$basename}" type="{concat($basename,'Type')}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="$eldoc"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:comment>*************** DECIMAL FIELDS **************</xsl:comment>
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="$decimal_fields_xsd/xsd:schema/*[not(name() = 'xsd:import')]">
            <xsl:copy-of select="."/>
            <xsl:variable name="basename" select="substring-before(@name, 'SimpleType')"/>
            <xsl:variable name="annot">
                <xsl:apply-templates select="xsd:annotation"/>
            </xsl:variable>
            <xsl:variable name="doc">
                <xsl:value-of select="substring-after($annot/*/xsd:documentation, 'A data type for ')"/>
            </xsl:variable>
            <xsl:variable name="eldoc">
                <xsl:value-of select="concat(upper-case(substring($doc, 1, 1)), substring($doc, 2))"/>
            </xsl:variable>
            <xsd:complexType name="{concat($basename,'Type')}">
                <xsl:copy-of select="xsd:annotation"/>
                <xsd:simpleContent>
                    <xsd:extension base="{@name}">
                        <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                    </xsd:extension>
                </xsd:simpleContent>
            </xsd:complexType>
            <xsd:element name="{$basename}" type="{concat($basename,'Type')}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="$eldoc"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:comment>************* ENUMERATED FIELDS *************</xsl:comment>
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="$enumerated_fields_xsd/xsd:schema/*[not(name() = 'xsd:import')]">
            <xsl:copy-of select="."/>
            <xsl:variable name="basename" select="substring-before(@name, 'SimpleType')"/>
            <xsl:variable name="annot">
                <xsl:apply-templates select="xsd:annotation"/>
            </xsl:variable>
            <xsl:variable name="doc">
                <xsl:value-of select="substring-after($annot/*/xsd:documentation, 'A data type for ')"/>
            </xsl:variable>
            <xsl:variable name="eldoc">
                <xsl:value-of select="concat(upper-case(substring($doc, 1, 1)), substring($doc, 2))"/>
            </xsl:variable>
            <xsd:complexType name="{concat($basename,'Type')}">
                <xsl:copy-of select="xsd:annotation"/>
                <xsd:simpleContent>
                    <xsd:extension base="{@name}">
                        <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                    </xsd:extension>
                </xsd:simpleContent>
            </xsd:complexType>
            <xsd:element name="{$basename}" type="{concat($basename,'Type')}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="$eldoc"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>
    <!--*****************************************************-->
    <!--Build re-factored xsd:complexTypes using GoE schema design and references-->
<!--    <xsl:variable name="complex_types_xsd">
        <xsl:apply-templates select="$composites_xsd/xsd:schema/xsd:complexType" mode="composite"/>
    </xsl:variable>
    <xsl:variable name="complex_elements">
        <xsl:apply-templates select="$complex_types_xsd/*" mode="el"/>
    </xsl:variable>-->
    <!--*****************************************************-->
    <xsl:template name="main">
        <xsl:result-document href="{$output_fields_xsd}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:goe:fields" xmlns:ism="urn:us:gov:ic:ism:v2" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:structures="http://release.niem.gov/niem/structures/3.0/" targetNamespace="urn:mtf:mil:6040b:goe:fields" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="0.1">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/3.0/" schemaLocation="structures.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>XML Schema for MTF Fields.</xsd:documentation>
                </xsd:annotation>
                <xsl:copy-of select="$refactor_fields_xsd"/>
            </xsd:schema>
        </xsl:result-document>
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
