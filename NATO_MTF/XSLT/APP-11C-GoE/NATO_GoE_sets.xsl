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
    consolidate fields, composites and segments as global elements in the "Fields" XML Schema for the GoE refactor.
    type references are converted to local.-->

    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="baseline_sets_xsd"
        select="document('../../XSD/APP-11C-ch1/Consolidated/sets.xsd')"/>

    <xsl:variable name="goe_fields_xsd"
        select="document('../../XSD/APP-11C-GoE/natomtf_goe_fields.xsd')"/>

    <xsl:variable name="goe_composites_xsd"
        select="document('../../XSD/APP-11C-GoE/natomtf_goe_composites.xsd')"/>

    <!--Root level complexTypes-->
    <xsl:variable name="complex_types">
        <xsl:for-each select="$baseline_sets_xsd/xsd:schema/xsd:complexType">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="@*"/>
                <!--<xsl:apply-templates select="xsd:annotation"/>-->
                <!--<xsl:apply-templates select="xsd:sequence"/>-->
                <xsl:apply-templates select="*"/>
            </xsl:copy>
        </xsl:for-each>
    </xsl:variable>

    <!--Root level elements-->
    <xsl:variable name="global_elements">
        <xsl:for-each select="$complex_types/xsd:complexType">
            <xsd:element>
                <xsl:attribute name="name">
                    <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
            </xsd:element>
        </xsl:for-each>
        <xsl:for-each select="$complex_types/xsd:element">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="sets_and_segments_cplx">
        <xsl:for-each select="$complex_types/*">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="sets_and_segments_el">
        <xsl:for-each select="$global_elements/*">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <!--<xsd:element name="SetBase" type="SetBaseType"/>-->
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="../../XSD/APP-11C-GoE/natomtf_goe_sets.xsd">
            <xsd:schema xmlns="urn:int:nato:mtf:app-11(c):goe:sets"
                xmlns:field="urn:int:nato:mtf:app-11(c):goe:fields"
                xmlns:comp="urn:int:nato:mtf:app-11(c):goe:composites"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:int:nato:mtf:app-11(c):goe:sets" xml:lang="en-GB"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:fields"
                    schemaLocation="natomtf_goe_fields.xsd"/>
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:composites"
                    schemaLocation="natomtf_goe_composites.xsd"/>
                <xsl:for-each select="$sets_and_segments_cplx/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$sets_and_segments_el/*">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*[@name = $n])">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <!-- Elements in Fields simple global types converted to references..-->
    <xsl:template match="xsd:element[@name][not(@nillable)][not(@type)]">
        <!-- <xsl:template match="xsd:element[@name][not(@nillable)][not(@type)][not(@name='GroupOfFields')]">-->
        <xsl:variable name="nm">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="child::xsd:complexType">
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="*"/>
                </xsl:when>
                <xsl:when test="exists($goe_composites_xsd/xsd:schema/xsd:element[@name = $nm])">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('comp:', $nm)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                    <xsl:element name="xsd:annotation">
                        <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
                        <xsl:apply-templates select="xsd:annotation/xsd:appinfo" mode="ref"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="exists($goe_fields_xsd/xsd:schema/xsd:element[@name = $nm])">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('field:', $nm)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                    <xsl:element name="xsd:annotation">
                        <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
                        <xsl:apply-templates select="xsd:annotation/xsd:appinfo" mode="ref"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="*"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <!-- Elements in Fields global types converted to references..-->
    <xsl:template match="xsd:element[@nillable]">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!-- type references are converted to local with SimpleType naming convention after verifying that it isn't ComplexType.-->
    <xsl:template match="xsd:element[@type]">
        <!--Create complex or simple type reference to match with global type in GoE fields-->
        <xsl:variable name="typename">
            <xsl:choose>
                <xsl:when test="starts-with(@type, 'f:')">
                    <xsl:value-of
                        select="substring-after(concat(substring(@type, 0, string-length(@type) - 3), 'SimpleType'), 'f:')"
                    />
                </xsl:when>
                <xsl:when test="starts-with(@type, 'c:')">
                    <xsl:value-of select="substring-after(@type, 'c:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@type"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="$goe_composites_xsd//xsd:complexType/@name = $typename">
                        <xsl:value-of select="concat('comp:', $typename)"/>
                    </xsl:when>
                    <xsl:when test="$goe_fields_xsd//xsd:simpleType/@name = $typename">
                        <xsl:value-of select="concat('field:', $typename)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$typename"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!-- base references are converted to local with SimpleType or ComplexType naming convention.-->
    <xsl:template match="xsd:extension[@base]">
        <!--<xsl:template match="xsd:extension[@base][not(@base='SetBaseType')]">-->
        <!--Create complex or simple type reference to match with global type in GoE fields-->
        <xsl:variable name="basename">
            <xsl:choose>
                <xsl:when test="starts-with(@base, 'f:')">
                    <xsl:value-of
                        select="substring-after(concat(substring(@base, 0, string-length(@base) - 3), 'SimpleType'), 'f:')"
                    />
                </xsl:when>
                <xsl:when test="starts-with(@base, 'c:')">
                    <xsl:value-of select="substring-after(@base, 'c:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@base"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="base">
                <xsl:choose>
                    <!--FreeTextSimpleType converted to  FreeTextType in complexTypes-->
                    <xsl:when test="$basename = 'FreeTextSimpleType'">
                        <xsl:text>comp:FreeTextType</xsl:text>
                    </xsl:when>
                    <xsl:when test="$goe_composites_xsd//xsd:complexType/@name = $basename">
                        <xsl:value-of select="concat('comp:', $basename)"/>
                    </xsl:when>
                    <xsl:when test="$goe_fields_xsd//xsd:simpleType/@name = $basename">
                        <xsl:value-of select="concat('field:', $basename)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$basename"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!--Copy element and iterate child attributes and elements-->
    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template
        match="xsd:sequence[ancestor::xsd:complexType[1]/xsd:annotation/xsd:appinfo/*:RepeatabilityForGroupOfFields]">
        <xsl:copy>
            <xsl:attribute name="maxOccurs">
                <xsl:value-of
                    select="ancestor::xsd:complexType[1]/xsd:annotation/xsd:appinfo/*:RepeatabilityForGroupOfFields"
                />
            </xsl:attribute>
            <xsl:attribute name="minOccurs">
                <xsl:text>1</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!--Carry through attribute-->
    <xsl:template match="@*">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

    <!--Normalize extra whitespace and linefeeds in text-->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <!--Convert elements in xsd:appinfo to attributes-->
    <xsl:template match="*" mode="attr">
        <xsl:variable name="nm" select="name()"/>
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:choose>
            <xsl:when
                test="preceding-sibling::*[name() = $nm] and not($txt = ' ') and not(*) and not($txt = '')">
                <xsl:attribute name="{concat(name(),count(preceding-sibling::*[name()=$nm]))}">
                    <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="not($txt = ' ') and not(*) and not($txt = '')">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--Copy annotation only if it has descendents with text content-->
    <xsl:template match="xsd:annotation">
        <xsl:if test="*//text()">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!--Copy documentation only if it has text content-->
    <xsl:template match="xsd:documentation">
        <xsl:if test="text()">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="text()"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!--Copy element and use template mode to convert elements to attributes in SET element-->
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Set')]]">
        <xsl:copy copy-namespaces="no">
            <xsl:element name="SetFormat">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <!--Copy element and use template mode to convert elements to attributes in FIELD element-->
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Field')]]">
        <xsl:copy copy-namespaces="no">
            <xsl:element name="FieldFormat">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
                <xsl:if test="parent::xsd:annotation/parent::xsd:extension">
                    <xsl:variable name="ffdno">
                        <xsl:value-of
                            select="parent::xsd:annotation/parent::xsd:extension/xsd:attribute[@name = 'ffirnFudn']/@fixed"
                        />
                    </xsl:variable>
                    <xsl:variable name="ffdinfo">
                        <xsl:copy-of select="$goe_fields_xsd//*:Field[@ffirnFudn = $ffdno]"/>
                    </xsl:variable>
                    <xsl:attribute name="FieldFormatPositionName">
                        <xsl:value-of select="$ffdinfo/*/@FudName"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:appinfo" mode="ref">
        <xsl:param name="fldinfo"/>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="FieldFormat" namespace="urn:mtf:mil:6040b:sets">
                <xsl:apply-templates select="*" mode="attr"/>
                <xsl:if test="parent::xsd:annotation/parent::xsd:extension">
                    <xsl:variable name="ffdno">
                        <xsl:value-of
                            select="parent::xsd:annotation/parent::xsd:extension/xsd:attribute[@name = 'ffirnFudn']/@fixed"
                        />
                    </xsl:variable>
                    <xsl:variable name="ffdinfo">
                        <xsl:copy-of select="$goe_fields_xsd//*:Field[@ffirnFudn = $ffdno]"/>
                    </xsl:variable>
                    <xsl:attribute name="FieldFormatName">
                        <xsl:value-of select="$ffdinfo/*/@FudName"/>
                    </xsl:attribute>
                    <xsl:attribute name="FieldFormatDefinition">
                        <xsl:value-of select="$ffdinfo/*/@FudExplanation"/>
                    </xsl:attribute>
                    <xsl:if test="contains(*:FieldFormatRemark/text(), $ffdno)"> </xsl:if>
                </xsl:if>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*:GroupOfFieldsIndicator" mode="attr"/>

    <xsl:template match="*:ColumnarIndicator" mode="attr"/>

    <!--Filter empty xsd:annotations-->
    <xsl:template match="xsd:restriction[@base = 'xsd:integer']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:string']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:decimal']/xsd:annotation"/>

</xsl:stylesheet>
