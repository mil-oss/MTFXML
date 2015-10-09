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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>

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
    <xsl:variable name="output" select="'../../XSD/GoE_Schema/GoE_sets.xsd'"/>

    <xsl:variable name="goe_types">
        <xsl:for-each select="$baseline_sets_xsd/xsd:schema/xsd:complexType[not(@name = 'SetBaseType')]">
            <xsl:copy>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*"/>
            </xsl:copy>
        </xsl:for-each>
    </xsl:variable>

    <!--Root level complexTypes-->
    <xsl:variable name="complex_types">
        <xsl:for-each select="$baseline_sets_xsd/xsd:schema/xsd:complexType[not(@name = 'SetBaseType')]">
            <xsl:variable name="elname">
                <xsl:value-of select="translate(substring(@name, 0, string-length(@name) - 3), '-', '')"/>
            </xsl:variable>
            <xsl:variable name="setid">
                <xsl:value-of select="xsd:annotation/xsd:appinfo/*:SetFormatIdentifier/text()"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:choose>
                    <xsl:when test="$setid = '1APHIB'">
                        <xsl:text>AmphibiousForceComposition</xsl:text>
                    </xsl:when>
                    <xsl:when test="$setid = 'MARACT'">
                        <xsl:text>MaritimeActivity</xsl:text>
                    </xsl:when>
                    <xsl:when test="exists($set_Changes/Set[@SETNAMESHORT = $setid and string-length(@ProposedSetFormatName) > 0])">
                        <xsl:value-of
                            select="translate($set_Changes/Set[@SETNAMESHORT = $setid and string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/-()', '')"
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

    <!--Root level elements-->
    <xsl:variable name="global_elements">
        <xsl:for-each select="$complex_types/xsd:complexType">
            <xsl:variable name="elname">
                <xsl:value-of select="translate(substring(@name, 0, string-length(@name) - 3), '-', '')"/>
            </xsl:variable>
            <xsl:variable name="setid">
                <xsl:value-of select="xsd:annotation/xsd:appinfo/*:Set/@id"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:choose>
                    <xsl:when test="exists($set_Changes/*/*[@SETNAMESHORT = $setid][string-length(@ProposedSetFormatName) > 0])">
                        <xsl:value-of
                            select="translate($set_Changes/Set[@SETNAMESHORT = $setid][string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/-()', '')"
                        />
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
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="{$output}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:sets" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:field="urn:mtf:mil:6040b:fields"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:ism="urn:us:gov:ic:ism:v2" targetNamespace="urn:mtf:mil:6040b:sets"
                xml:lang="en-US" elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:mtf:mil:6040b:fields" schemaLocation="GoE_fields.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:complexType name="SetBaseType">
                    <xsd:sequence>
                        <xsd:element name="Amplification" type="AmplificationType" minOccurs="0" maxOccurs="1"/>
                        <xsd:element name="NarrativeInformation" type="NarrativeInformationType" minOccurs="0" maxOccurs="1"/>
                    </xsd:sequence>
                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                </xsd:complexType>
                <xsl:for-each select="$goe_types/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
                <!--<xsl:for-each select="$global_elements/*">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*[@name = $n])">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:if>
                </xsl:for-each>-->
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>
    <!--Copy element and iterate child attributes and elements-->

    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
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

    <xsl:template match="xsd:element[@name = 'GroupOfFields']"/>

<!--    <xsl:template match="xsd:element[//xsd:extension]">
        <xsl:variable name="b">
            <xsl:value-of select="xsd:complexType/*/xsd:extension/@base"/>
        </xsl:variable>
        <xsl:variable name="base">
            <xsl:choose>
                <xsl:when test="starts-with($b, 'f:')">
                    <xsl:value-of select="substring-after($b, 'f:')"/>
                </xsl:when>
                <xsl:when test="starts-with($b, 'c:')">
                    <xsl:value-of select="substring-after($b, 'c:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$b"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="basel" select="$goe_fields_xsd/xsd:schema/xsd:element[@name =substring(@base, 0, string-length(@base) - 3)]"/>
        <xsl:variable name="basetype">
            <xsl:choose>
                <xsl:when test="exists($basel/@type)">
                    <xsl:value-of select="$basel/@type"/>
            </xsl:when>
                <xsl:when test="exists($basel/xsd:complexType/*/xsd:restriction/@base)">
                    <xsl:value-of select="$basel/xsd:complexType/*/xsd:restriction/@base"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@base"/>
            </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not(@nillable) and $basel">
                <xsd:element ref="{concat('field:',$basel/@name)}">
                    <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                </xsd:element>
            </xsl:when>
            <xsl:when test="$basel/xsd:complexType/xsd:simpleContent/xsd:restriction/@base='FieldEnumeratedBaseType'">
                <xsd:element name="{@name}">
                    <xsl:apply-templates select="@*[not(name() = 'name') and not(name() = 'type')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                    <xsd:complexType>
                        <xsd:simpleContent>
                            <xsd:restriction base="field:FieldEnumeratedBaseType">
                                <xsl:apply-templates select="$basel/xsd:complexType/xsd:simpleContent/xsd:restriction"/>
                            </xsd:restriction>
                        </xsd:simpleContent>
                    </xsd:complexType>
                </xsd:element>
            </xsl:when>
            <xsl:when test="$basel/xsd:complexType/xsd:simpleContent/xsd:restriction/@base='FieldIntegerBaseType'">
                <xsd:element name="{@name}">
                    <xsl:apply-templates select="@*[not(name() = 'name') and not(name() = 'type')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                    <xsd:complexType>
                        <xsd:simpleContent>
                            <xsd:restriction base="field:FieldIntegerBaseType">
                                <xsl:apply-templates select="$basel/xsd:complexType/xsd:simpleContent/xsd:restriction/*"/>
                            </xsd:restriction>
                        </xsd:simpleContent>
                    </xsd:complexType>
                </xsd:element>
            </xsl:when>
            <xsl:when test="$basel/xsd:complexType/xsd:simpleContent/xsd:restriction/@base='FieldDecimalBaseType'">
                <xsl:variable name="dec" select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]/xsd:complexType/xsd:simpleContent/xsd:restriction"/>
                <xsd:element name="{@name}">
                    <xsl:apply-templates select="@*[not(name() = 'name') and not(name() = 'type')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                    <xsd:complexType>
                        <xsd:simpleContent>
                            <xsd:restriction base="field:FieldDecimalBaseType">
                                <xsl:apply-templates select="$dec/*"/>
                            </xsd:restriction>
                        </xsd:simpleContent>
                    </xsd:complexType>
                </xsd:element>
            </xsl:when>
            <xsl:when test="$basel/xsd:complexType/xsd:simpleContent/xsd:restriction/@base='FieldStringBaseType'">
                <xsd:element name="{@name}">
                    <xsl:apply-templates select="@*[not(name() = 'name') and not(name() = 'type')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                    <xsd:complexType>
                        <xsd:simpleContent>
                            <xsd:restriction base="field:FieldStringBaseType">
                                <xsl:apply-templates select="$basel/xsd:complexType/xsd:simpleContent/xsd:restriction/*"/>
                            </xsd:restriction>
                        </xsd:simpleContent>
                    </xsd:complexType>
                </xsd:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>-->

    <xsl:template match="xsd:extension[starts-with(@base, 'f:')]">
        <xsl:copy>
            <xsl:attribute name="base">
                <xsl:value-of select="substring-after(@base, 'f:')"/>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:extension[starts-with(@base, 'c:')]">
        <xsl:copy>
            <xsl:attribute name="base">
                <xsl:value-of select="substring-after(@base, 'c:')"/>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:sequence[ancestor::xsd:element[@name = 'GroupOfFields'][1]]">
        <xsl:copy>
            <xsl:copy-of select="ancestor::xsd:element[@name = 'GroupOfFields'][1]/@minOccurs"/>
            <xsl:copy-of select="ancestor::xsd:element[@name = 'GroupOfFields'][1]/@maxOccurs"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!--Convert elements in xsd:appinfo to attributes-->
    <xsl:template match="*" mode="attr">
        <xsl:variable name="nm" select="name()"/>
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[name() = $nm] and not($txt = ' ') and not(*) and not($txt = '')">
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
        <xsl:variable name="setid">
            <xsl:value-of select="xsd:appinfo/*:SetFormatIdentifier/text()"/>
        </xsl:variable>
        <xsl:variable name="doc">
            <xsl:apply-templates select="xsd:documentation/text()"/>
        </xsl:variable>
        <xsl:variable name="desc">
            <xsl:apply-templates select="xsd:appinfo/*:SetFormatDescription/text()"/>
            <xsl:apply-templates select="xsd:appinfo/*:FieldFormatDefinition/text()"/>
        </xsl:variable>
        <xsl:variable name="newdesc">
            <xsl:value-of
                select="normalize-space($set_Changes/*[@SETNAMESHORT = $setid][@ProposedSetFormatDescription][1]/@ProposedSetFormatDescription)"/>
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
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="*//text()">
            <xsl:copy copy-namespaces="no">
                <xsl:if test="not(xsd:documentation)">
                    <xsd:documentation>
                        <xsl:value-of select="$doc"/>
                    </xsd:documentation>
                </xsl:if>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*">
                    <xsl:with-param name="doc" select="$doc"/>
                </xsl:apply-templates>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xsd:annotation[parent::xsd:extension]"/>

    <!--Copy documentation only if it has text content-->
    <xsl:template match="xsd:documentation">
        <xsl:param name="doc"/>
        <xsl:if test="string-length($doc) > 0">
            <xsl:copy copy-namespaces="no">
                <xsl:value-of select="$doc"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!--Copy element and use template mode to convert elements to attributes in SET element-->
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Set')]]">
        <xsl:param name="doc"/>
        <xsl:variable name="setid">
            <xsl:value-of select="*:SetFormatIdentifier/text()"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Set" xmlns="urn:mtf:mil:6040b:sets">
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

    <!--*****************************************************-->

    <xsl:template match="xsd:element" mode="sets">
        <xsl:variable name="nm">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:variable name="field">
            <xsl:value-of select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $nm]"/>
        </xsl:variable>
        <xsl:variable name="ftypename">
            <xsl:value-of select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $nm]/@type"/>
        </xsl:variable>
        <xsl:variable name="fbase">
            <xsl:value-of select="$field/xsd:complexType/xsd:simpleContent/xsd:restriction/@base"/>
        </xsl:variable>
        <xsl:variable name="ftype">
            <xsl:value-of select="$goe_fields_xsd/xsd:schema/xsd:complexType[@name = $ftypename]"/>
        </xsl:variable>
        <xsl:variable name="extbase">
            <xsl:value-of select=".//xsd:extension/@base"/>
        </xsl:variable>
        <xsl:variable name="base_element">
            <xsl:choose>
                <xsl:when test="starts-with($extbase, 'f:')">
                    <xsl:value-of select="substring-after(substring($extbase, 0, string-length($extbase) - 3), 'f:')"/>
                </xsl:when>
                <xsl:when test="starts-with($extbase, 'c:')">
                    <xsl:value-of select="substring-after(substring($extbase, 0, string-length($extbase) - 3), 'c:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring($extbase, 0, string-length($extbase) - 3)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="match_base">
            <xsl:choose>
                <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $base_element]/@type">
                    <xsl:value-of select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $base_element]/@type"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $base_element]//xsd:restriction/@base"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@name = 'Amplification'">
                <xsd:element name="Amplification" type="AmplificationType" minOccurs="0" maxOccurs="0"/>
            </xsl:when>
            <xsl:when test="@name = 'NarrativeInformation'">
                <xsd:element name="NarrativeInformation" type="NarrativeInformationType" minOccurs="0" maxOccurs="0"/>
            </xsl:when>
            <xsl:when test="exists($field/xsd:simpleContent/xsd:restriction[@base = 'FieldStringBaseType'])">
                <xsl:choose>
                    <xsl:when test="@nillable">
                        <xsd:element name="{@name}">
                            <xsd:complexType>
                                <xsd:complexContent>
                                    <xsd:restriction base="{concat('field:',$field/xsd:simpleContent/xsd:restriction/@base)}">
                                        <xsl:apply-templates select="$field/xsd:simpleContent/xsd:restriction/*"/>
                                    </xsd:restriction>
                                </xsd:complexContent>
                            </xsd:complexType>
                        </xsd:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsd:element name="{@name}" type="{$field/xsd:complexType/xsd:simpleContent/xsd:restriction/@base}">
                            <xsd:apply-templates select="@*[not(name()='name'][not(name()='type']"/>
                        </xsd:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when
                test="exists($goe_fields_xsd/xsd:schema/xsd:complexType[@name = $nm]/xsd:simpleContent/xsd:restriction[@base = 'FieldEnumeratedBaseType'])">
                <xsd:element name="{@name}" type="{$field/xsd:complexType/xsd:simpleContent/xsd:restriction/@base}">
                    <xsd:apply-templates select="@*[not(name()='name'][not(name()='type']"/>
                </xsd:element>
            </xsl:when>
            <xsl:when test="exists($goe_fields_xsd/xsd:schema/xsd:complexType[@name = $nm]/xsd:sequence)">
                <xsd:element name="{@name}" type="{$fbase}">
                    <xsd:apply-templates select="@*[not(name()='name'][not(name()='type']"/>
                </xsd:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:element[@name = 'FreeText']" mode="sets">
        <xsd:element name="FreeText" type="field:AlphaNumericSpecialFreeTextType" minOccurs="1" maxOccurs="1" nillable="true"/>
    </xsl:template>

    <xsl:template match="xsd:extension[@base = 'SetBaseType']" mode="sets">
        <xsd:extension base="SetBaseType">
            <xsl:apply-templates select="*"/>
        </xsd:extension>
    </xsl:template>

    <!-- base references are converted to local with SimpleType or ComplexType naming convention.-->
    <xsl:template match="xsd:extension[@base][not(@base = 'SetBaseType')]" mode="sets">
        <!--Create complex or simple type reference to match with global type in GoE fields-->
        <!--Because types have been normalized, it is necessary use element name to match-->
        <xsl:variable name="base_element">
            <xsl:choose>
                <xsl:when test="starts-with(@base, 'f:')">
                    <xsl:value-of select="substring-after(substring(@base, 0, string-length(@base) - 3), 'f:')"/>
                </xsl:when>
                <xsl:when test="starts-with(@base, 'c:')">
                    <xsl:value-of select="substring-after(substring(@base, 0, string-length(@base) - 3), 'c:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring(@base, 0, string-length(@base) - 3)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="match_base">
            <xsl:choose>
                <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $base_element]/@type">
                    <xsl:value-of select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $base_element]/@type"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $base_element]//xsd:restriction/@base"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsd:restriction>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="base">
                <xsl:choose>
                    <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $base_element]">
                        <xsl:value-of select="concat('field:', $match_base)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$match_base"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates
                select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $base_element]/xsd:complexType/xsd:simpleContent/xsd:restriction/*"/>
        </xsd:restriction>
        <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]"/>
    </xsl:template>

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
            <xsl:element name="Field" xmlns="urn:mtf:mil:6040b:sets">
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
            <xsl:element name="Field" namespace="urn:mtf:mil:6040b:sets">
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
    <!--Convert appinfo items-->
    <xsl:template match="*:SetFormatName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="name">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatIdentifier" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="id">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:VersionIndicator" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="version">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionConcept" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not($doc = normalize-space(text()))">
            <xsl:attribute name="concept">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="positionName">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatPositionName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="positionName">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatPositionConcept" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = $doc)">
            <xsl:attribute name="concept">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="name">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatDefinition" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = $doc)">
            <xsl:attribute name="definition">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:AlphabeticIdentifier" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = $doc)">
            <xsl:attribute name="identifier">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldDescriptor" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = $doc)">
            <xsl:attribute name="name">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatRemark" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="remark">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:ColumnName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="column">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatRelatedDocument" mode="docs">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = 'NONE')">
            <xsl:if test="not(preceding-sibling::*:FieldFormatRelatedDocument)">
                <xsl:element name="Document" namespace="urn:mtf:mil:6040b:sets">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:FieldFormatRelatedDocument">
                    <xsl:element name="Document" namespace="urn:mtf:mil:6040b:sets">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatExample" mode="examples">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:if test="not(preceding-sibling::*:SetFormatExample)">
                <xsl:element name="Example" namespace="urn:mtf:mil:6040b:sets">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:SetFormatExample">
                    <xsl:element name="Example" namespace="urn:mtf:mil:6040b:sets">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatPositionNumber" mode="attr"/>
    <xsl:template match="*:OccurrenceCategory" mode="attr"/>
    <xsl:template match="*:SetFormatExample" mode="attr"/>
    <xsl:template match="*:SetFormatRelatedDocuments" mode="attr"/>
    <xsl:template match="*:RepeatabilityForGroupOfFields" mode="attr"/>
    <xsl:template match="*:SetFormatDescription" mode="attr"/>
    <xsl:template match="*:FieldFormatRelatedDocument" mode="attr"/>
    <!--Filter unneeded nodes-->
    <xsl:template match="xsd:attributeGroup"/>
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
