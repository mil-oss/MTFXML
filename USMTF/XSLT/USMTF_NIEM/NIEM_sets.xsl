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
    <xsl:include href="USMTF_Utility.xsl"/>
    <!--  This XSLT refactors baseline USMTF "fields" XML Schema by replacing annotation elements
    with attributes, removing unused elements and other adjustments-->
    <!--Fields from the baseline Composites XML Schema are also included as ComplexTypes in accordance with the intent to 
    consolidate fields, composites and segments as global elements in the "Fields" XML Schema for the GoE refactor.
    type references are converted to local.-->
    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="baseline_sets_xsd" select="document('../../XSD/Baseline_Schema/sets.xsd')"/>
    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/NIEM_Schema/NIEM_fields.xsd')"/>
    <xsl:variable name="goe_composites_xsd" select="document('../../XSD/NIEM_Schema/NIEM_composites.xsd')"/>
    <!--Set deconfliction and annotation changes-->
    <xsl:variable name="set_Changes" select="document('../../XSD/Deconflicted/Set_Name_Changes.xml')/USMTF_Sets"/>
    <xsl:variable name="set_field_Changes" select="document('../../XSD/Deconflicted/Set_Field_Name_Changes.xml')/SetElements"/>
    <xsl:variable name="string_type_changes" select="document('../../XSD/Normalized/StringTypeChanges.xml')/StringChanges"/>
    <xsl:variable name="enumeration_type_changes" select="document('../../XSD/Normalized/EnumerationTypeChanges.xml')/EnumerationChanges"/>

    <!--*****************************************************-->

    <xsl:variable name="output" select="'../../XSD/NIEM_Schema/NIEM_sets.xsd'"/>

    <!--Root level complexTypes-->
    <xsl:variable name="complex_types">
        <xsl:for-each select="$baseline_sets_xsd/xsd:schema/xsd:complexType[not(@name = 'SetBaseType')]">
            <xsl:variable name="n">
                <xsl:apply-templates select="@name" mode="fromtype"/>
            </xsl:variable>
            <xsl:variable name="elname">
                <xsl:value-of select="concat($n, 'Set')"/>
            </xsl:variable>
            <xsl:variable name="setid">
                <xsl:value-of select="xsd:annotation/xsd:appinfo/*:SetFormatIdentifier/text()"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:choose>
                    <xsl:when test="$setid = '1APHIB'">
                        <xsl:text>AmphibiousForcesSituationSet</xsl:text>
                    </xsl:when>
                    <xsl:when test="$setid = 'MARACT'">
                        <xsl:text>MaritimeActivitySet</xsl:text>
                    </xsl:when>
                    <xsl:when test="exists($set_Changes/Set[@SETNAMESHORT = $setid and string-length(@ProposedSetFormatName) > 0])">
                        <xsl:value-of select="concat(translate($set_Changes/Set[@SETNAMESHORT = $setid and string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' .,/-()', ''), 'Set')"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$elname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsd:complexType name="{concat($newname, 'Type')}">
                <xsl:apply-templates select="*"/>
            </xsd:complexType>
        </xsl:for-each>
    </xsl:variable>

    <!--New complexTypes from not global elements-->
    <xsl:variable name="all_global_names">
        <xsl:for-each select="$complex_types/xsd:element">
            <el name="{@name}"/>
        </xsl:for-each>
        <xsl:for-each select="$complex_types/xsd:complexType//xsd:element[@name]">
            <el name="{@name}"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="new_globals">
        <xsl:for-each select="$complex_types//xsd:element[@name][not(@name = 'AmplificationSet')][not(@type)]">
            <xsl:sort select="@name"/>
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
                <xsl:copy-of select="xsd:annotation"/>
                <xsd:complexContent>
                    <xsd:extension base="structures:ObjectType">
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
        <xsl:apply-templates select="$complex_types/*" mode="globals"/>
    </xsl:variable>

    <!--Root level elements-->
    <xsl:variable name="global_elements">
        <xsl:for-each select="$new_globals/xsd:complexType">
            <xsl:variable name="elname">
                <xsl:apply-templates select="@name" mode="fromtype"/>
            </xsl:variable>
            <xsl:variable name="setid">
                <xsl:value-of select="xsd:annotation/xsd:appinfo/*:Set/@id"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:choose>
                    <xsl:when test="exists($set_Changes/*/*[@SETNAMESHORT = $setid][string-length(@ProposedSetFormatName) > 0])">
                        <xsl:value-of select="concat(translate($set_Changes/Set[@SETNAMESHORT = $setid][string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/-().', ''), 'Set')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$elname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsd:element name="{$newname}" type="{concat($newname, 'Type')}" nillable="true">
                <xsd:annotation>
                    <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:for-each select="$new_globals/xsd:element">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <!--Combined complexTypes-->
    <xsl:variable name="all_complexTypes">
        <!--<xsl:copy-of select="$complex_types"/>-->
        <xsl:for-each select="$new_globals/xsd:complexType">
            <xsl:apply-templates select="." mode="copyCTypes"/>
        </xsl:for-each>
    </xsl:variable>

    <!--Combined elements-->
    <xsl:variable name="all_elements">
        <xsl:copy-of select="$global_elements"/>
    </xsl:variable>

    <!--*****************************************************-->

    <xsl:template name="main">
        <xsl:result-document href="{$output}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:goe:sets" xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                xmlns:mtf="urn:mtf:mil:6040b:goe"
                xmlns:f="urn:mtf:mil:6040b:goe:fields" 
                xmlns:c="urn:mtf:mil:6040b:goe:composites"
                xmlns:structures="http://release.niem.gov/niem/structures/3.0/" 
                xmlns:ism="urn:us:gov:ic:ism:v2" targetNamespace="urn:mtf:mil:6040b:goe:sets" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="0.1">
                <xsd:import namespace="urn:mtf:mil:6040b:goe:fields" schemaLocation="NIEM_fields.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:goe:composites" schemaLocation="NIEM_composites.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/3.0/" schemaLocation="structures.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>XML Schema for USMTF Message Text Format Sets</xsd:documentation>
                </xsd:annotation>
                <xsd:complexType name="SetBaseType">
                    <xsd:annotation>
                        <xsd:documentation>A data type for all sets which adds AMPN, NARR and security tagging.</xsd:documentation>
                    </xsd:annotation>
                    <xsd:complexContent>
                        <xsd:extension base="structures:ObjectType">
                            <xsd:sequence>
                                <xsd:element ref="AmplificationSet" minOccurs="0" maxOccurs="1"/>
                                <xsd:element ref="NarrativeInformationSet" minOccurs="0" maxOccurs="1"/>
                            </xsd:sequence>
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        </xsd:extension>
                    </xsd:complexContent>
                </xsd:complexType>

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

    <xsl:template match="xsd:element">
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="txt"/>
        </xsl:variable>
        <xsl:variable name="bt">
            <xsl:value-of select="xsd:complexType/*/xsd:extension/@base"/>
            <xsl:value-of select="@type"/>
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
            <xsl:when test="@name = 'RoutingIndicator'">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:text>f:RoutingIndicator</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="@name = 'Activity'">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:text>f:Activity</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="@name = 'Event'">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:text>f:Event</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="starts-with($bt, 'f:')">
                <xsl:choose>
                    <xsl:when test="$n = $basel and $goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]">
                        <xsl:copy copy-namespaces="no">
                            <xsl:attribute name="ref">
                                <xsl:value-of select="concat('f:', $basel)"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                            <xsl:call-template name="Annotation">
                                <xsl:with-param name="node" select="."/>
                            </xsl:call-template>
                        </xsl:copy>
                    </xsl:when>
                    <xsl:when test="$n != $basel and $goe_fields_xsd/xsd:schema/xsd:complexType[@name = $baseortype]">
                        <xsl:copy copy-namespaces="no">
                            <xsl:attribute name="name">
                                <xsl:value-of select="$n"/>
                            </xsl:attribute>
                            <xsl:attribute name="type">
                                <xsl:value-of select="concat('f:', $baseortype)"/>
                            </xsl:attribute>
                            <xsl:call-template name="Annotation">
                                <xsl:with-param name="node" select="."/>
                            </xsl:call-template>
                        </xsl:copy>
                    </xsl:when>
                    <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $baseortype]//xsd:restriction">
                        <xsl:copy copy-namespaces="no">
                            <xsl:apply-templates select="@*"/>
                            <xsl:attribute name="type">
                                <xsl:value-of select="concat('f:', $goe_fields_xsd/xsd:schema/xsd:element[@name = $baseortype]//xsd:restriction/@type)"/>
                            </xsl:attribute>
                            <xsl:call-template name="Annotation">
                                <xsl:with-param name="node" select="."/>
                            </xsl:call-template>
                        </xsl:copy>
                    </xsl:when>
                    <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $baseortype]">
                        <xsl:copy copy-namespaces="no">
                            <xsl:apply-templates select="@*"/>
                            <xsl:attribute name="type">
                                <xsl:value-of select="concat('f:', $baseortype)"/>
                            </xsl:attribute>
                            <xsl:call-template name="Annotation">
                                <xsl:with-param name="node" select="."/>
                            </xsl:call-template>
                        </xsl:copy>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with($bt, 'c:')">
                <xsl:choose>
                    <xsl:when test="$n = $basel and $goe_composites_xsd/xsd:schema/xsd:element[@name = $basel]">
                        <xsl:copy copy-namespaces="no">
                            <xsl:attribute name="ref">
                                <xsl:value-of select="concat('c:', $basel)"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                            <xsl:call-template name="Annotation">
                                <xsl:with-param name="node" select="."/>
                            </xsl:call-template>
                        </xsl:copy>
                    </xsl:when>
                    <xsl:when test="$n != $basel and $goe_composites_xsd/xsd:schema/xsd:complexType[@name = $baseortype]">
                        <xsl:copy copy-namespaces="no">
                            <xsl:attribute name="name">
                                <xsl:value-of select="$n"/>
                            </xsl:attribute>
                            <xsl:attribute name="type">
                                <xsl:value-of select="concat('c:', $baseortype)"/>
                            </xsl:attribute>
                            <xsl:call-template name="Annotation">
                                <xsl:with-param name="node" select="."/>
                            </xsl:call-template>
                        </xsl:copy>
                    </xsl:when>
                    <xsl:when test="$goe_composites_xsd/xsd:schema/xsd:element[@name = $baseortype]//xsd:restriction">
                        <xsl:copy copy-namespaces="no">
                            <xsl:apply-templates select="@*"/>
                            <xsl:attribute name="type">
                                <xsl:value-of select="concat('c:', $goe_composites_xsd/xsd:schema/xsd:element[@name = $baseortype]//xsd:restriction/@type)"/>
                            </xsl:attribute>
                            <xsl:call-template name="Annotation">
                                <xsl:with-param name="node" select="."/>
                            </xsl:call-template>
                        </xsl:copy>
                    </xsl:when>
                    <xsl:when test="$goe_composites_xsd/xsd:schema/xsd:element[@name = $baseortype]">
                        <xsl:copy copy-namespaces="no">
                            <xsl:apply-templates select="@*"/>
                            <xsl:attribute name="type">
                                <xsl:value-of select="concat('c:', $baseortype)"/>
                            </xsl:attribute>
                            <xsl:call-template name="Annotation">
                                <xsl:with-param name="node" select="."/>
                            </xsl:call-template>
                        </xsl:copy>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*"/>
                    <xsl:call-template name="Annotation">
                        <xsl:with-param name="node" select="."/>
                    </xsl:call-template>
                    <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="xsd:extension[@base = 'SetBaseType']">
        <xsd:extension base="SetBaseType">
            <xsl:apply-templates select="*"/>
        </xsd:extension>
    </xsl:template>
    <xsl:template match="xsd:extension[@base = 'AmplificationType']">
        <xsd:extension base="AmplificationSetType">
            <xsl:apply-templates select="*"/>
        </xsd:extension>
    </xsl:template>
    <xsl:template match="xsd:extension">
        <xsl:variable name="b">
            <xsl:value-of select="@base"/>
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
            <xsl:when test="$string_type_changes/Change/@name = $basetype">
                <xsd:extension base="{$string_type_changes/Change[@name=$basetype]/@changeto}"/>
            </xsl:when>
            <xsl:when test="$enumeration_type_changes/Change/@name = $basetype">
                <xsd:extension base="{$enumeration_type_changes/Change[@name=$basetype]/@changeto}"/>
            </xsl:when>
            <xsl:when test="starts-with($b, 'f:')">
                <xsl:choose>
                    <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:complexType[@name = $basetype]">
                        <xsd:extension base="{concat('f:',$basetype)}"/>
                    </xsl:when>
                    <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction">
                        <xsd:restriction base="{concat('f:',$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction/@base)}">
                            <xsl:apply-templates select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction/*"/>
                        </xsd:restriction>
                        <!--<xsl:copy-of select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction"/>-->
                    </xsl:when>
                    <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]/@type">
                        <xsd:extension base="{concat('f:',$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]/@type)}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with($b, 'c:')">
                <xsl:choose>
                    <xsl:when test="$goe_composites_xsd/xsd:schema/xsd:complexType[@name = $basetype]">
                        <xsd:extension base="{concat('c:',$basetype)}"/>
                    </xsl:when>
                    <xsl:when test="$goe_composites_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction">
                        <xsd:restriction base="{concat('c:',$goe_composites_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction/@base)}">
                            <xsl:apply-templates select="$goe_composites_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction/*"/>
                        </xsd:restriction>
                        <!--<xsl:copy-of select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction"/>-->
                    </xsl:when>
                    <xsl:when test="$goe_composites_xsd/xsd:schema/xsd:element[@name = $basel]/@type">
                        <xsd:extension base="{concat('c:',$goe_composites_xsd/xsd:schema/xsd:element[@name = $basel]/@type)}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsd:extension base="{concat($basel,'Type')}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="xsd:choice[not(parent::xsd:sequence)]">
        <xsd:sequence>
            <xsd:choice>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*"/>
            </xsd:choice>
        </xsd:sequence>
    </xsl:template>

    <xsl:template name="Annotation">
        <xsl:param name="node"/>
        <xsl:choose>
            <xsl:when test="$node/xsd:annotation">
                <xsl:apply-templates select="$node/xsd:annotation"/>
            </xsl:when>
            <xsl:when test="contains($node/@name, 'GroupOfFields')">
                <xsl:variable name="nametext">
                    <xsl:call-template name="breakIntoWords">
                        <xsl:with-param name="string">
                            <xsl:value-of select="ancestor::xsd:complexType[@name][1]/@name"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('A data type for the ',$nametext,' repeatable group of fields')"/>
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

    <!--*****************************************************-->

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
                            <xsd:extension base="structures:ObjectType">
                        <xsl:apply-templates select="*[not(name()='xsd:annotation')]" mode="globals"/>
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
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:copy>
    </xsl:template>

    <!--*****************************************************-->

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
                <xsd:extension base="structures:ObjectType">
                    <xsl:apply-templates select="xsd:sequence" mode="copyCTypes"/>
                </xsd:extension>
            </xsd:complexContent>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*[@name = 'NarrativeInformationSetType']" mode="copyCTypes">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="copyCTypes"/>
            <xsl:apply-templates select="xsd:annotation" mode="copyCTypes"/>
            <xsd:complexContent>
                <xsd:extension base="structures:ObjectType">
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
                <xsd:extension base="structures:ObjectType">
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

    <!--*****************************************************-->
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
                <xsl:when test="starts-with($r, 'f:')">
                    <xsl:value-of select="$r"/>
                </xsl:when>
                <xsl:when test="starts-with($r, 'c:')">
                    <xsl:value-of select="$r"/>
                </xsl:when>
                <xsl:when test="$global_elements/xsd:element[@name = $r]">
                    <xsl:value-of select="$r"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($parent, $r)"/>
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
            <xsl:value-of select="."/>
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

</xsl:stylesheet>
