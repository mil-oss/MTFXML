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
    <xsl:include href="Utility.xsl"/>
    <!--  This XSLT refactors baseline USMTF "fields" XML Schema by replacing annotation elements
    with attributes, removing unused elements and other adjustments-->
    <!--Fields from the baseline Composites XML Schema are also included as ComplexTypes in accordance with the intent to 
    consolidate fields, composites and segments as global elements in the "Fields" XML Schema for the GoE refactor.
    type references are converted to local.-->
    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="baseline_sets_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/sets.xsd')"/>
    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/APP-11C-GoE/natomtf_goe_fields.xsd')"/>
    <!--Set deconfliction and annotation changes-->
    <xsl:variable name="output" select="'../../XSD/APP-11C-GoE/natomtf_goe_sets.xsd'"/>
    <xsl:variable name="set_field_Changes" select="document('../../XSD/Deconflicted/Set_Field_Name_Changes.xml')/SetElements"/>
    <!--*****************************************************-->
    <!--Root level complexTypes-->
    <!--*****************************************************-->

    <xsl:variable name="complex_types">
        <xsl:for-each select="$baseline_sets_xsd/xsd:schema/xsd:complexType[not(@name = 'SetBaseType')]">
            <xsl:sort select="@name"/>
            <xsl:variable name="nm">
                <xsl:apply-templates select="@name" mode="txt"/>
            </xsl:variable>
            <xsl:variable name="elname">
                <xsl:value-of select="concat(translate(substring($nm, 0, string-length($nm) - 3), '-', ''), 'Set')"/>
            </xsl:variable>
            <xsd:complexType name="{concat($elname, 'Type')}">
                <xsl:apply-templates select="xsd:annotation"/>
                <xsl:apply-templates select="*" mode="baseline"/>
            </xsd:complexType>
            <xsd:element name="{$elname}" type="{concat($elname, 'Type')}">
                <xsl:apply-templates select="xsd:annotation"/>
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>
    <xsl:template match="xsd:element" mode="baseline">
        <xsl:variable name="fn" select="@name"/>
        <xsl:variable name="p" select="ancestor::*[@name][1]/@name"/>
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="txt"/>
        </xsl:variable>
        <xsl:variable name="bt">
            <xsl:choose>
                <xsl:when test="@type">
                    <xsl:apply-templates select="@type" mode="txt"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="xsd:complexType/*/*/@base" mode="txt"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseortype">
            <xsl:choose>
                <xsl:when test="contains($bt, ':')">
                    <xsl:value-of select="substring-after($bt, ':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$bt"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="basel" select="substring($baseortype, 0, string-length($baseortype) - 3)"/>
        <xsl:choose>
            <xsl:when test="@name = 'Amplification'"/>
            <xsl:when test="$set_field_Changes/*[@name = $fn][@type = $bt][@parent = $p]">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="name">
                        <xsl:value-of select="$set_field_Changes/*[@name = $fn][@type = $bt][@parent = $p]/@changeto"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="concat('field:', $bt)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]" mode="baseline"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$n = $basel and $goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('field:', $basel)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')][not(name() = 'nillable')]" mode="baseline"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$n != $basel and $goe_fields_xsd/xsd:schema/xsd:complexType[@name = $baseortype]">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="name">
                        <xsl:value-of select="$n"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="concat('field:', $baseortype)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $baseortype]//xsd:restriction">
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="type">
                        <xsl:value-of select="concat('field:', $goe_fields_xsd/xsd:schema/xsd:element[@name = $baseortype]//xsd:restriction/@type)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $baseortype]">
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="type">
                        <xsl:value-of select="concat('field:', $baseortype)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                    <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]" mode="baseline"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="xsd:extension[@base = 'SetBaseType']" mode="baseline">
        <xsd:extension base="SetBaseType">
            <xsl:apply-templates select="*" mode="baseline"/>
        </xsd:extension>
    </xsl:template>
    <xsl:template match="xsd:extension[@base = 'AmplificationType']" mode="baseline">
        <xsd:extension base="AmplificationSetType">
            <xsl:apply-templates select="*" mode="baseline"/>
        </xsd:extension>
    </xsl:template>
    <xsl:template match="xsd:extension" mode="baseline">
        <xsl:variable name="b">
            <xsl:apply-templates select="@base" mode="txt"/>
        </xsl:variable>
        <xsl:variable name="basetype">
            <xsl:choose>
                <xsl:when test="contains($b, ':')">
                    <xsl:value-of select="substring-after($b, ':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$b"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="basel" select="substring($basetype, 0, string-length($basetype) - 3)"/>
        <xsl:choose>
            <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:complexType[@name = $basetype]">
                <xsd:extension base="{concat('field:',$basetype)}"/>
            </xsl:when>
            <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction">
                <xsd:restriction base="{concat('field:',$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction/@base)}">
                    <xsl:apply-templates select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction/*" mode="baseline"/>
                </xsd:restriction>
                <!--<xsl:copy-of select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction"/>-->
            </xsl:when>
            <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]/@type">
                <xsd:extension base="{concat('field:',$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]/@type)}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsd:extension base="{concat($basel,'Type')}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="xsd:choice[not(parent::xsd:sequence)]" mode="baseline">
        <xsd:sequence>
            <xsd:choice>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="baseline"/>
            </xsd:choice>
        </xsd:sequence>
    </xsl:template>
    <xsl:template match="text()" mode="baseline">
        <xsl:value-of select="normalize-space(translate(., '&#34;&#xA;', ''))"/>
    </xsl:template>
    <xsl:template match="*" mode="baseline">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="baseline"/>
            <xsl:apply-templates select="text()" mode="baseline"/>
            <xsl:apply-templates select="*" mode="baseline"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="baseline">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="xsd:attribute" mode="baseline"/>
    <xsl:template match="xsd:annotation" mode="baseline"/>

    <!--New complexTypes from not global elements-->
    <xsl:variable name="all_global_names">
        <xsl:for-each select="$complex_types/xsd:element">
            <Element name="{@name}"/>
        </xsl:for-each>
        <xsl:for-each select="$complex_types/xsd:complexType//xsd:element[@name]">
            <Element name="{@name}"/>
        </xsl:for-each>
    </xsl:variable>
    <!--*****************************************************-->
    <xsl:variable name="new_globals">
        <xsl:for-each select="$complex_types//xsd:element[@name][not(@type)]">
            <xsl:sort select="@name"/>
            <xsl:variable name="p">
                <xsl:value-of select="ancestor::xsd:complexType[@name][1]/@name"/>
            </xsl:variable>
            <xsl:variable name="parent">
                <xsl:choose>
                    <xsl:when test="ends-with($p, 'SetType')">
                        <xsl:value-of select="replace($p, 'SetType', '')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace($p, 'Type', '')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="nn">
                <xsl:choose>
                    <xsl:when test="count($all_global_names//*[@name = $n]) &gt; 1">
                        <xsl:value-of select="concat($parent, $n)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$n"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsd:complexType name="{concat($nn,'Type')}">
                <xsl:call-template name="Annotation">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
                <xsd:complexContent>
                    <xsd:extension base="SetBaseType">
                        <xsl:apply-templates select="xsd:complexType/*" mode="globals"/>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{$nn}" type="{concat($nn,'Type')}">
                <xsd:annotation>
                    <xsl:copy-of select="xsd:annotation/xsd:documentation"/>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:for-each select="$complex_types//xsd:element[@name][@type]">
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:variable name="nn">
                <xsl:choose>
                    <xsl:when test="$set_field_Changes/*[@name = $n][@type = $t]">
                        <xsl:value-of select="$set_field_Changes/*[@name = $n][@type = $t]/@changeto"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsd:element name="{$nn}" type="{@type}">
                <xsd:annotation>
                    <xsl:copy-of select="xsd:annotation/xsd:documentation"/>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:apply-templates select="$complex_types/xsd:complexType" mode="globals"/>
    </xsl:variable>
    <xsl:template match="xsd:complexType" mode="globals">
        <xsl:choose>
            <xsl:when test="xsd:complexContent">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="globals"/>
                    <xsl:apply-templates select="text()" mode="globals"/>
                    <xsl:apply-templates select="*" mode="globals"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="globals"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                    <xsd:complexContent>
                        <xsd:extension base="SetBaseType">
                            <xsl:apply-templates select="xsd:sequence" mode="globals"/>
                        </xsd:extension>
                    </xsd:complexContent>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*" mode="globals">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="globals"/>
            <xsl:apply-templates select="text()" mode="globals"/>
            <xsl:apply-templates select="*" mode="globals"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:choice" mode="globals">
        <xsl:copy>
            <xsl:apply-templates select="*" mode="globals">
                <xsl:sort select="@ref | @name"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="globals">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="text()" mode="globals">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="xsd:element[@name]" mode="globals">
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:variable name="nn">
            <xsl:choose>
                <xsl:when test="$set_field_Changes/*[@name = $n][@type = $t]">
                    <xsl:value-of select="$set_field_Changes/*[@name = $n][@type = $t]/@changeto"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy>
            <xsl:attribute name="ref">
                <xsl:value-of select="$nn"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[not(name() = 'name') and not(name() = 'type')]"/>
            <xsl:apply-templates select="xsd:annotation" mode="globals"/>
        </xsl:copy>
    </xsl:template>
    
    <!--*****************************************************--> 
    <!--Root level elements-->
    <xsl:variable name="global_elements">
        <xsl:for-each select="$new_globals/xsd:complexType">
            <xsl:variable name="elname">
                <xsl:apply-templates select="@name" mode="fromtype"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:value-of select="$elname"/>
            </xsl:variable>
            <xsd:element>
                <xsl:attribute name="name">
                    <xsl:value-of select="$newname"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:value-of select="concat($newname, 'Type')"/>
                </xsl:attribute>
                <xsl:apply-templates select="xsd:annotation"/>
            </xsd:element>
        </xsl:for-each>
        <xsl:for-each select="$new_globals/xsd:element">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    
    <!--Combined complexTypes-->
    <xsl:variable name="all_complexTypes">
        <xsl:for-each select="$new_globals/xsd:complexType">
            <xsl:apply-templates select="." mode="copyCTypes"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:template match="*" mode="copyCTypes">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="copyCTypes"/>
            <xsl:apply-templates select="text()" mode="copyCTypes"/>
            <xsl:apply-templates select="*" mode="copyCTypes"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:element" mode="copyCTypes">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="copyCTypes"/>
            <xsl:apply-templates select=".//xsd:sequence[1]/@maxOccurs" mode="copy"/>
            <xsl:apply-templates select="text()" mode="copyCTypes"/>
            <xsl:apply-templates select="*" mode="copyCTypes"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*[@name = 'AmplificationSetType']" mode="copyCTypes">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="copyCTypes"/>
            <xsl:apply-templates select="xsd:annotation" mode="copyCTypes"/>
            <xsd:complexContent>
                <xsd:extension base="field:CompositeType">
                    <xsl:apply-templates select="xsd:sequence" mode="copyCTypes"/>
                </xsd:extension>
            </xsd:complexContent>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*[@name = 'NarrativeSetType']" mode="copyCTypes">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="copyCTypes"/>
            <xsl:apply-templates select="xsd:annotation" mode="copyCTypes"/>
            <xsd:complexContent>
                <xsd:extension base="field:CompositeType">
                    <xsl:apply-templates select="xsd:sequence" mode="copyCTypes"/>
                </xsd:extension>
            </xsd:complexContent>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*[@name = 'RemarksSetType']" mode="copyCTypes">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="copyCTypes"/>
            <xsl:apply-templates select="xsd:annotation" mode="copyCTypes"/>
            <xsd:complexContent>
                <xsd:extension base="field:CompositeType">
                    <xsl:apply-templates select="xsd:sequence" mode="copyCTypes"/>
                </xsd:extension>
            </xsd:complexContent>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:extension/xsd:sequence[not(xsd:element)][not(xsd:choice)]" mode="copyCTypes">
        <xsl:apply-templates select="*" mode="copyCTypes"/>
    </xsl:template>
    <xsl:template match="xsd:sequence[preceding-sibling::xsd:element][count(xsd:element) = 1]" mode="copyCTypes">
        <xsd:element>
            <xsl:apply-templates select="./xsd:element/@*" mode="copyCTypes"/>
            <!--<xsl:copy-of select="@minOccurs"/>-->
            <xsd:annotation>
                <xsl:copy-of select="./xsd:element/xsd:annotation/xsd:documentation"/>
                <xsd:appinfo>
                    <xsl:for-each select="./xsd:element/xsd:annotation/xsd:appinfo/*">
                        <xsl:copy>
                            <xsl:apply-templates select="@*" mode="copyCTypes"/>
                            <xsl:copy-of select="ancestor::xsd:sequence[1]/@minOccurs"/>
                            <xsl:copy-of select="ancestor::xsd:sequence[1]/@maxOccurs"/>
                        </xsl:copy>
                    </xsl:for-each>
                </xsd:appinfo>
            </xsd:annotation>
        </xsd:element>
    </xsl:template>
    <xsl:template match="@*" mode="copyCTypes">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="@ref" mode="copyCTypes">
        <xsl:variable name="r">
            <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:variable name="p">
            <xsl:value-of select="ancestor::xsd:complexType[@name][1]/@name"/>
        </xsl:variable>
        <xsl:variable name="parent">
            <xsl:choose>
                <xsl:when test="contains($p, 'GroupOfFields')">
                    <xsl:value-of select="substring-before($p, 'GroupOfFields')"/>
                </xsl:when>
                <xsl:when test="ends-with($p, 'SetType')">
                    <xsl:value-of select="replace($p, 'SetType', '')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($p, 'Type', '')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="nr">
            <xsl:choose>
                <xsl:when test="starts-with($r, 'field:')">
                    <xsl:value-of select="$r"/>
                </xsl:when>
                <xsl:when test="$global_elements/xsd:element[@name = $r]">
                    <xsl:value-of select="$r"/>
                </xsl:when>
                <xsl:when test="count($all_global_names/*[@name = $r]) &gt; 1">
                    <xsl:value-of select="concat($parent, $r)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$r"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="ref">
            <xsl:value-of select="$nr"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="text()" mode="copyCTypes">
        <xsl:value-of select="."/>
    </xsl:template>
    <!--*****************************************************-->
    <!--Combined elements-->
    <xsl:variable name="all_elements">
        <xsl:copy-of select="$global_elements"/>
    </xsl:variable>
    <!--*****************************************************-->
    <xsl:template name="main">
        <xsl:result-document href="{$output}">
            <xsd:schema xmlns="urn:int:nato:mtf:app-11(c):goe:sets" xmlns:field="urn:int:nato:mtf:app-11(c):goe:elementals" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:int:nato:mtf:app-11(c):goe:sets" xml:lang="en-GB" elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:elementals" schemaLocation="natomtf_goe_fields.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>XML Schema for NATO Message Text Format Sets</xsd:documentation>
                </xsd:annotation>
                <xsd:complexType name="SetBaseType">
                    <xsd:annotation>
                        <xsd:documentation>Base type for sets which adds AMPN, NARR and security tagging.</xsd:documentation>
                    </xsd:annotation>
                    <xsd:complexContent>
                        <xsd:extension base="field:CompositeType">
                            <xsd:sequence>
                                <xsd:element ref="AmplificationSet" minOccurs="0" maxOccurs="1">
                                    <xsd:annotation>
                                        <xsd:documentation>AN UNFORMATTED FIELD CONTAINING AN UNLIMITED NUMBER OF ALPHANUMERIC CHARACTERS</xsd:documentation>
                                    </xsd:annotation>
                                </xsd:element>
                                <xsd:element ref="NarrativeSet" minOccurs="0" maxOccurs="1">
                                    <xsd:annotation>
                                        <xsd:documentation>NARRATIVE</xsd:documentation>
                                    </xsd:annotation>
                                </xsd:element>
                            </xsd:sequence>
                        </xsd:extension>
                    </xsd:complexContent>
                </xsd:complexType>

               <!-- <xsl:for-each select="$new_globals/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$new_globals/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>-->

                <xsl:for-each select="$all_complexTypes/*">
                    <xsl:sort select="@name"/>
                    <xsl:choose>
                        <xsl:when test="deep-equal(preceding-sibling::xsd:complexType/xsd:complexContent, ./xsd:complexContent)"/>
                        <xsl:otherwise>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>

                <xsl:for-each select="$all_elements/*">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:variable name="t" select="@type"/>
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::*[@name = $n and @type = $t]"/>
                        <xsl:otherwise>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>
    
    <!--*****************************************************-->
    <xsl:template name="Annotation">
        <xsl:param name="node"/>
        <xsl:choose>
            <xsl:when test="$node/xsd:annotation">
                <xsl:apply-templates select="$node/xsd:annotation"/>
            </xsl:when>
            <xsl:when test="contains($node/@name,'GroupOfFields')">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>A repeatable group of fields</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
            </xsl:when>
            <xsl:otherwise>
                <xsd:annotation>
                    <xsd:documentation>Data definition required</xsd:documentation>
                </xsd:annotation>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>   
    <xsl:template match="@nillable"/>
    <xsl:template match="@*" mode="chg"/>
    <!--Replace Data Specified in Deconfliction XML Document-->
    <xsl:template match="@ProposedSetFormatPositionName" mode="chg">
        <xsl:attribute name="positionName">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@ProposedSetFormatName" mode="chg">
        <xsl:attribute name="name">
            <xsl:value-of select="translate(., ' ,/-().', '')"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@ProposedSetFormatDescription" mode="chg">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(.) = $doc)">
            <xsl:attribute name="description">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@ProposedSetFormatPositionConceptChanges" mode="chg">
        <xsl:if test="not(normalize-space(.) = ' ') and not(normalize-space(.) = '')">
            <xsl:attribute name="concept">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <!--Copy element and use template mode to convert elements to attributes in FIELD element-->

</xsl:stylesheet>
