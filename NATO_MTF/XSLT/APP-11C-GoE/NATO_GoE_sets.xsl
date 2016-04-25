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
    <xsl:variable name="baseline_sets_xsd" select="document('../../XSD/Baseline_Schema/sets.xsd')"/>
    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/GoE_Schema/GoE_fields.xsd')"/>
    <!--Set deconfliction and annotation changes-->
    <xsl:variable name="set_Changes" select="document('../../XSD/Deconflicted/Set_Name_Changes.xml')/USMTF_Sets"/>
    <xsl:variable name="set_field_Changes" select="document('../../XSD/Deconflicted/Set_Field_Name_Changes.xml')/SetElements"/>
    <!--*****************************************************-->
    <xsl:variable name="output" select="'../../XSD/GoE_Schema/GoE_sets.xsd'"/>
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
                        <xsl:text>AmphibiousForceCompositionSet</xsl:text>
                    </xsl:when>
                    <xsl:when test="$setid = 'MARACT'">
                        <xsl:text>MaritimeActivitySet</xsl:text>
                    </xsl:when>
                    <xsl:when test="exists($set_Changes/Set[@SETNAMESHORT = $setid and string-length(@ProposedSetFormatName) > 0])">
                        <xsl:value-of select="concat(translate($set_Changes/Set[@SETNAMESHORT = $setid and string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/-()', ''), 'Set')"
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
    <xsl:variable name="new_globals">
        <xsl:for-each select="$complex_types//xsd:element[@name][not(@type)][.//xsd:choice]">
            <xsl:sort select="@name"/>
            <xsl:variable name="parent">
                <xsl:choose>
                    <xsl:when test="ends-with(ancestor::xsd:complexType[1]/@name, 'SetType')">
                        <xsl:value-of select="replace(ancestor::xsd:complexType[1]/@name, 'SetType', '')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace(ancestor::xsd:complexType[1]/@name, 'Type', '')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="nn">
                <xsl:choose>
                    <xsl:when test="count($complex_types//xsd:element[@name = $n]) &gt; 1">
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
                    <xsd:extension base="ChoiceType">
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
        <xsl:for-each select="$complex_types//xsd:element[@name][not(@name = 'AmplificationSet')][not(@type)][not(.//xsd:choice)]">
            <xsl:sort select="@name"/>
            <xsl:variable name="parent">
                <xsl:choose>
                    <xsl:when test="ends-with(ancestor::xsd:complexType[1]/@name, 'SetType')">
                        <xsl:value-of select="replace(ancestor::xsd:complexType[1]/@name, 'SetType', '')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace(ancestor::xsd:complexType[1]/@name, 'Type', '')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="nn">
                <xsl:choose>
                    <xsl:when test="count($complex_types//xsd:element[@name = $n]) &gt; 1">
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
                        <xsl:value-of select="concat(translate($set_Changes/Set[@SETNAMESHORT = $setid][string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/-()', ''), 'Set')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$elname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsd:element>
                <xsl:attribute name="name">
                    <xsl:value-of select="$newname"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:value-of select="concat($newname, 'Type')"/>
                </xsl:attribute>
                <xsd:annotation>
                    <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:for-each select="$new_globals/xsd:element">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <!--Subsequences-->
    <xsl:variable name="subsequences">
        <xsl:for-each select="$new_globals//xsd:sequence/xsd:sequence[count(xsd:element) &gt; 1]">
            <xsl:variable name="seqname">
                <xsl:value-of select="concat(substring-before(ancestor::xsd:complexType/@name, 'SetType'), 'Subsequence')"/>
            </xsl:variable>
            <xsd:complexType name="{concat($seqname,'Type')}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat(ancestor::xsd:complexType//*:Set/@name, ' Sub-Sequence')"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:element name="Field" namespace="urn:mtf:mil:6040b:goe:sets">
                            <xsl:copy-of select="@minOccurs"/>
                            <xsl:copy-of select="@maxOccurs"/>
                        </xsl:element>
                    </xsd:appinfo>
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="SetBaseType">
                        <xsd:sequence>
                            <xsl:apply-templates select="*" mode="copyCTypes"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{$seqname}" type="{concat($seqname,'Type')}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat(ancestor::xsd:complexType//*:Set/@name, ' Sub-Sequence')"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:element name="Field" namespace="urn:mtf:mil:6040b:goe:sets">
                            <xsl:copy-of select="@minOccurs"/>
                            <xsl:copy-of select="@maxOccurs"/>
                        </xsl:element>
                    </xsd:appinfo>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>
    <!--Combined complexTypes-->
    <xsl:variable name="all_complexTypes">
        <!--<xsl:copy-of select="$complex_types"/>-->
        <xsl:for-each select="$new_globals/xsd:complexType">
            <xsl:apply-templates select="." mode="copyCTypes"/>
        </xsl:for-each>
        <xsl:for-each select="$subsequences/xsd:complexType">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <!--Combined elements-->
    <xsl:variable name="all_elements">
        <xsl:copy-of select="$global_elements"/>
        <xsl:for-each select="$subsequences/xsd:element">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <!--*****************************************************-->
    <xsl:template name="main">
        <xsl:result-document href="{$output}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:goe:sets" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:field="urn:mtf:mil:6040b:goe:fields" xmlns:ism="urn:us:gov:ic:ism:v2"
                targetNamespace="urn:mtf:mil:6040b:goe:sets" xml:lang="en-US" elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:mtf:mil:6040b:goe:fields" schemaLocation="GoE_fields_Initial.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:complexType name="SetBaseType">
                    <xsd:annotation>
                        <xsd:documentation>Base type for sets which adds AMPN, NARR and security tagging.</xsd:documentation>
                    </xsd:annotation>
                    <xsd:complexContent>
                        <xsd:extension base="field:FieldSequenceType">
                            <xsd:sequence>
                                <xsd:element ref="AmplificationSet" minOccurs="0" maxOccurs="1"/>
                                <xsd:element ref="NarrativeInformationSet" minOccurs="0" maxOccurs="1"/>
                            </xsd:sequence>
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        </xsd:extension>
                    </xsd:complexContent>
                </xsd:complexType>
                <xsd:complexType name="ChoiceType">
                    <xsd:annotation>
                        <xsd:documentation>Base type for alternate content.</xsd:documentation>
                    </xsd:annotation>
                    <xsd:complexContent>
                        <xsd:restriction base="SetBaseType">
                            <xsd:sequence/>
                        </xsd:restriction>
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
    <xsl:template match="xsd:element[@name = 'GroupOfFields']">
        <xsl:apply-templates select="xsd:complexType/xsd:sequence" mode="group">
            <xsl:with-param name="min" select="@minOccurs"/>
            <xsl:with-param name="max" select="@maxOccurs"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="xsd:element[not(@name = 'GroupOfFields')]">
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="txt"/>
        </xsl:variable>
        <xsl:variable name="bt">
            <xsl:apply-templates select="xsd:complexType/*/xsd:extension/@base" mode="txt"/>
            <xsl:apply-templates select="@type" mode="txt"/>
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
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:choose>
                        <xsl:when test="@name = 'RoutingIndicator'">
                            <xsl:attribute name="ref">
                                <xsl:text>field:RoutingIndicator</xsl:text>
                            </xsl:attribute>
                            <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                            <xsl:apply-templates select="xsd:annotation"/>
                        </xsl:when>
                        <xsl:when test="@name = 'Activity'">
                            <xsl:attribute name="ref">
                                <xsl:text>field:Activity</xsl:text>
                            </xsl:attribute>
                            <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                            <xsl:apply-templates select="xsd:annotation"/>
                        </xsl:when>
                        <xsl:when test="@name = 'Event'">
                            <xsl:attribute name="ref">
                                <xsl:text>field:Event</xsl:text>
                            </xsl:attribute>
                            <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                            <xsl:apply-templates select="xsd:annotation"/>
                        </xsl:when>
                        <xsl:when test="$n = $basel and $goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]">
                            <xsl:attribute name="ref">
                                <xsl:value-of select="concat('field:', $basel)"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                            <xsl:apply-templates select="xsd:annotation"/>
                        </xsl:when>
                        <xsl:when test="$n != $basel and $goe_fields_xsd/xsd:schema/xsd:complexType[@name = $baseortype]">
                            <xsl:attribute name="name">
                                <xsl:value-of select="$n"/>
                            </xsl:attribute>
                            <xsl:attribute name="type">
                                <xsl:value-of select="concat('field:', $baseortype)"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="xsd:annotation"/>
                        </xsl:when>
                        <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $baseortype]//xsd:restriction">
                            <xsl:apply-templates select="@*"/>
                            <xsl:attribute name="type">
                                <xsl:value-of select="concat('field:', $goe_fields_xsd/xsd:schema/xsd:element[@name = $baseortype]//xsd:restriction/@type)"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $baseortype]">
                            <xsl:apply-templates select="@*"/>
                            <xsl:attribute name="type">
                                <xsl:value-of select="concat('field:', $baseortype)"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="@*"/>
                            <xsl:apply-templates select="*"/>
                        </xsl:otherwise>
                    </xsl:choose>
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
                    <xsl:apply-templates select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction/*"/>
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
    <xsl:template match="xsd:sequence" mode="group">
        <xsl:param name="min"/>
        <xsl:param name="max"/>
        <xsd:sequence minOccurs="{$min}" maxOccurs="{$max}">
            <xsl:apply-templates select="*"/>
        </xsd:sequence>
    </xsl:template>
    <xsl:template match="xsd:annotation">
        <xsl:variable name="setid">
            <xsl:value-of select="xsd:appinfo/*:SetFormatIdentifier/text()"/>
        </xsl:variable>
        <xsl:variable name="doc">
            <xsl:value-of select="normalize-space(xsd:documentation/text())"/>
        </xsl:variable>
        <xsl:variable name="desc">
            <xsl:apply-templates select="xsd:appinfo/*:SetFormatDescription/text()"/>
            <xsl:apply-templates select="xsd:appinfo/*:FieldFormatDefinition/text()"/>
        </xsl:variable>
        <xsl:variable name="remark">
            <xsl:apply-templates select="xsd:appinfo/*:SetFormatRemark/text()"/>
        </xsl:variable>
        <xsl:variable name="newdesc">
            <xsl:value-of select="normalize-space($set_Changes/*[@SETNAMESHORT = $setid][@ProposedSetFormatDescription][1]/@ProposedSetFormatDescription)"/>
        </xsl:variable>
        <xsl:variable name="doc">
            <xsl:choose>
                <xsl:when test="string-length($newdesc) > 0">
                    <xsl:value-of select="$newdesc"/>
                </xsl:when>
                <xsl:when test="string-length($doc) > 0">
                    <xsl:value-of select="$doc"/>
                </xsl:when>
                <xsl:when test="string-length($desc) > 0">
                    <xsl:value-of select="$desc"/>
                </xsl:when>
                <xsl:when test="string-length($remark) > 0">
                    <xsl:value-of select="$remark"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Data definition required</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="xsd:documentation">
                    <xsl:apply-templates select="*">
                        <xsl:with-param name="doc" select="$doc"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsd:documentation>
                        <xsl:value-of select="$doc"/>
                    </xsd:documentation>
                    <xsl:apply-templates select="*"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:documentation">
        <xsl:param name="doc"/>
        <xsl:choose>
            <xsl:when test="string-length(normalize-space($doc)) &gt; 0">
                <xsl:copy copy-namespaces="no">
                    <xsl:value-of select="$doc"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="text()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--Copy element and use template mode to convert elements to attributes in SET element-->
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Set')]]">
        <xsl:param name="doc"/>
        <xsl:variable name="setid">
            <xsl:value-of select="*:SetFormatIdentifier/text()"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Set" xmlns="urn:mtf:mil:6040b:goe:sets">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr">
                    <xsl:with-param name="doc" select="$doc"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="$set_Changes/*[@SETNAMESHORT = $setid]/@*[string-length(.) > 0][1]" mode="chg">
                    <xsl:with-param name="doc" select="$doc"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="ancestor::xsd:element[1]/xsd:complexType/xsd:extension/xsd:annotation/xsd:appinfo/*" mode="attr"/>
                <xsl:apply-templates select="*:SetFormatExample" mode="examples"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:choice[not(parent::xsd:sequence)]">
        <xsd:sequence>
            <xsd:choice>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*"/>
            </xsd:choice>
        </xsd:sequence>
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
                    <xsl:apply-templates select="xsd:annotation" mode="globals"/>
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
                <xsd:extension base="field:FieldSequenceType">
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
                <xsd:extension base="field:FieldSequenceType">
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
                <xsd:extension base="field:FieldSequenceType">
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
    <xsl:template match="xsd:sequence[preceding-sibling::xsd:element][count(xsd:element) &gt; 1]" mode="copyCTypes">
        <xsl:variable name="seqname">
            <xsl:value-of select="concat(substring-before(ancestor::xsd:complexType/@name, 'SetType'), 'Subsequence')"/>
        </xsl:variable>
        <xsd:element ref="{$seqname}">
            <xsl:copy-of select="$subsequences/*[@name = $seqname]/xsd:annotation"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="@*" mode="copyCTypes">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="@ref" mode="copyCTypes">
        <xsl:variable name="r">
            <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:variable name="parent">
            <xsl:choose>
                <xsl:when test="ends-with(ancestor::xsd:complexType[1]/@name, 'SetType')">
                    <xsl:value-of select="replace(ancestor::xsd:complexType[1]/@name, 'SetType', '')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace(ancestor::xsd:complexType[1]/@name, 'Type', '')"/>
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
    <!--Copy element and use template mode to convert elements to attributes in FIELD element-->
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Field')]]">
        <xsl:param name="doc"/>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Field" xmlns="urn:mtf:mil:6040b:goe:sets">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr">
                    <xsl:with-param name="doc" select="$doc"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="ancestor::xsd:element[1]/xsd:complexType/*/xsd:extension/xsd:annotation/xsd:appinfo/*" mode="attr">
                    <xsl:with-param name="doc" select="$doc"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="*:FieldFormatRelatedDocument" mode="docs"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:appinfo" mode="ref">
        <xsl:param name="fldinfo"/>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Field" namespace="urn:mtf:mil:6040b:goe:sets">
                <xsl:apply-templates select="*" mode="attr"/>
                <xsl:if test="parent::xsd:annotation/parent::xsd:extension">
                    <xsl:variable name="ffdno">
                        <xsl:value-of select="parent::xsd:annotation/parent::xsd:extension/xsd:attribute[@name = 'ffirnFudn']/@fixed"/>
                    </xsl:variable>
                    <xsl:variable name="ffdinfo">
                        <xsl:copy-of select="$goe_fields_xsd//*:Field[@ffirnFudn = $ffdno]"/>
                    </xsl:variable>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$ffdinfo/*/@FudName"/>
                    </xsl:attribute>
                    <xsl:attribute name="explanation">
                        <xsl:value-of select="$ffdinfo/*/@FudExplanation"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*:FieldFormatRelatedDocument" mode="docs">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = 'NONE')">
            <xsl:if test="not(preceding-sibling::*:FieldFormatRelatedDocument)">
                <xsl:element name="Document" namespace="urn:mtf:mil:6040b:goe:sets">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:FieldFormatRelatedDocument">
                    <xsl:element name="Document" namespace="urn:mtf:mil:6040b:goe:sets">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatExample" mode="examples">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:if test="not(preceding-sibling::*:SetFormatExample)">
                <xsl:element name="Example" namespace="urn:mtf:mil:6040b:goe:sets">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:SetFormatExample">
                    <xsl:element name="Example" namespace="urn:mtf:mil:6040b:goe:sets">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
