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
    <xsl:variable name="baseline_sets_xsd" select="document('../../XSD/Baseline_Schemas/sets.xsd')"/>
    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/GoE_Schemas/GoE_fields.xsd')"/>
    <!--Set deconfliction and annotation changes-->
    <xsl:variable name="set_Changes" select="document('Set_DeconflictionXML.xml')/USMTF_Sets"/>

    <!--Root level complexTypes-->
    <xsl:variable name="complex_types">
        <xsl:for-each select="$baseline_sets_xsd/xsd:schema/xsd:complexType">
            <xsl:variable name="elname">
                <xsl:value-of select="substring(@name,0,string-length(@name)-3)"/>
            </xsl:variable>
            <xsl:variable name="setid">
                <xsl:value-of select="xsd:annotation/xsd:appinfo/*:SetFormatIdentifier/text()"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:choose>
                    <xsl:when test="$setid='1APHIB'">
                        <xsl:text>AmphibiousForceCompositionType</xsl:text>
                    </xsl:when>
                    <xsl:when test="$setid='MARACT'">
                        <xsl:text>MaritimeActivityType</xsl:text>
                    </xsl:when>
                    <xsl:when
                        test="exists($set_Changes/Set[@SETNAMESHORT = $setid][string-length(@ProposedSetFormatName) > 0])">
                        <xsl:value-of select="translate($set_Changes/Set[@SETNAMESHORT = $setid][string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/()', '')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(@name,0,string-length(@name)-3)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsd:complexType name="{concat($newname,'Type')}">
                <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                <xsl:apply-templates select="*"/>
                <xsl:if test="@name = 'SetBaseType'">
                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                </xsl:if>
            </xsd:complexType>
        </xsl:for-each>
    </xsl:variable>

    <!--Root level elements-->
    <xsl:variable name="global_elements">
        <xsl:for-each select="$complex_types/xsd:complexType">
            <xsl:variable name="elname">
                <xsl:value-of select="substring(@name,0,string-length(@name)-3)"/>
            </xsl:variable>
            <xsl:variable name="setid">
                <xsl:value-of select="xsd:annotation/xsd:appinfo/*:SetFormatIdentifier/text()"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:choose>
                    <xsl:when
                        test="exists($set_Changes/*/*[@SETNAMESHORT = $setid][string-length(@ProposedSetFormatName) > 0])">
                        <xsl:apply-templates
                            select="$set_Changes/*[@SETNAMESHORT = $setid][string-length(@ProposedSetFormatName) > 0][1]"
                            mode="propname"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(@name,0,string-length(@name)-3)"/>
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
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>


    <xsl:template match="/">
        <xsl:result-document href="../../XSD/GoE_Schemas/GoE_sets.xsd">
            <xsd:schema xmlns="urn:mtf:mil:6040b:sets" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:field="urn:mtf:mil:6040b:fields"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                xmlns:ism="urn:us:gov:ic:ism:v2" targetNamespace="urn:mtf:mil:6040b:sets"
                xml:lang="en-US" elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:mtf:mil:6040b:fields" schemaLocation="GoE_fields.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsl:for-each select="$complex_types/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
                <xsl:for-each select="$global_elements/*">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*[@name = $n])">
                        <xsl:copy-of select="." copy-namespaces="no"/>
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
                        <xsl:text>field:FreeTextType</xsl:text>
                    </xsl:when>
                    <xsl:when test="$basename = 'MissionVerificationIndexType'">
                        <xsl:text>field:MissionVerificationIndexComplexType</xsl:text>
                    </xsl:when>
                    <xsl:when test="$goe_fields_xsd//xsd:complexType/@name = $basename">
                        <xsl:value-of select="concat('field:', $basename)"/>
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
        <xsl:variable name="setid">
            <xsl:value-of select="*:SetFormatIdentifier/text()"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="SetFormat" xmlns="urn:mtf:mil:6040b:sets">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
                <xsl:apply-templates select="$set_Changes/*[@SETNAMESHORT = $setid]/@*" mode="chg"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="chg"/>

    <!--Replace Data Specified in Deconfliction XML Document-->
    <xsl:template match="@ProposedSetFormatPositionName" mode="chg">
        <xsl:attribute name="SetFormatPositionName">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@ProposedSetFormatName" mode="chg">
        <xsl:attribute name="SetFormatName">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@ProposedSetFormatDescription" mode="chg">
        <xsl:attribute name="SetFormatDescription">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@ProposedSetFormatPositionConceptChanges" mode="chg">
        <xsl:attribute name="SetFormatPositionConcept">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <!--Copy element and use template mode to convert elements to attributes in FIELD element-->
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Field')]]">
        <xsl:copy copy-namespaces="no">
            <xsl:element name="FieldFormat">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
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

    <!--Filter unneeded nodes-->
    <xsl:template match="*:GroupOfFieldsIndicator" mode="attr"/>
    <xsl:template match="*:ColumnarIndicator" mode="attr"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber" mode="attr"/>
    <xsl:template match="*:AssignedFfirnFudUseDescription" mode="attr"/>
    <xsl:template match="xsd:attribute[@name = 'ffSeq']"/>
    <xsl:template match="xsd:attribute[@name = 'ffirnFudn']"/>
    <!--Filter empty xsd:annotations-->
    <xsl:template match="xsd:restriction[@base = 'xsd:integer']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:string']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:decimal']/xsd:annotation"/>

</xsl:stylesheet>
