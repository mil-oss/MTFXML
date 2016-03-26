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
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="fields_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')"/>
    <xsl:variable name="normalized_fields_xsd" select="document('../../XSD/Normalized/NormalizedSimpleTypes.xsd')"/>

    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="enumerations_xsd" select="$fields_xsd/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string'][xsd:enumeration]]"/>

    <!--Output-->
    <xsl:variable name="enumerationsoutdoc" select="'../../XSD/Normalized/Enumerations.xsd'"/>

    <!--A normalized list of xsd:string types with common REGEX patterns without length qualifiers for re-use globally-->
    <xsl:variable name="normenumerationtypes" select="$normalized_fields_xsd/*/xsd:simpleType[xsd:restriction/xsd:enumeration]"/>

    <!--xsd:simpleTypes with Enumerations-->
    <xsl:variable name="enumtypes">
        <xsl:apply-templates select="$fields_xsd/*/xsd:simpleType[xsd:restriction[@base = 'xsd:string'][xsd:enumeration]]">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>

    <!--This returns a list of generated xsd:elements and associated unique xsd:simpleType-->
    <xsl:variable name="enumelementsandtypes">
        <xsl:apply-templates select="$enumtypes/*" mode="el"/>
    </xsl:variable>

    <!--This consolidates normalized and unique xsd:simpleTypes for sorting  -->
    <xsl:variable name="enumcombinedTypes">
        <xsl:for-each select="$normenumerationtypes">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$enumelementsandtypes/*[name() = 'xsd:simpleType']">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="{$enumerationsoutdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:goe:fields" xmlns:ism="urn:us:gov:ic:ism:v2" xmlns:xsd="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:mtf:mil:6040b:goe:fields"
                xml:lang="en-US" elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:complexType name="FieldEnumeratedBaseType">
                    <xsd:annotation>
                        <xsd:documentation>Base type for MTF enumerated fields</xsd:documentation>
                    </xsd:annotation>
                    <xsd:simpleContent>
                        <xsd:extension base="xsd:string">
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        </xsd:extension>
                    </xsd:simpleContent>
                </xsd:complexType>
                <xsl:for-each select="$enumcombinedTypes/*">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:choose>
                        <xsl:when test="following-sibling::*[@name=$n] and xsd:annotation/xsd:documentation='Data definition required'"/>
                        <xsl:when test="preceding-sibling::*[@name=$n] and xsd:annotation/xsd:documentation='Data definition required'"/>   
                        <xsl:otherwise>
                            <xsd:complexType name="{concat(substring-before(@name,'SimpleType'),'Type')}">
                                <xsl:copy-of select="xsd:annotation"/>
                                <xsd:simpleContent>
                                    <xsd:restriction base="FieldEnumeratedBaseType">
                                        <xsl:for-each select="xsd:restriction/xsd:enumeration">
                                            <xsl:copy-of select="."/>
                                        </xsl:for-each>
                                    </xsd:restriction>
                                </xsd:simpleContent>
                            </xsd:complexType>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:for-each select="$enumelementsandtypes/*[name() = 'xsd:element']">
                    <xsl:sort select="@name"/>
                    <xsd:element name="{@name}" type="{concat(substring-before(@type,'SimpleType'),'Type')}" nillable="true">
                        <xsl:copy-of select="xsd:annotation"/>
                    </xsd:element>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <!-- ******** simpleType Generation ********-->
    <xsl:template match="xsd:simpleType">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:simpleType/@name">
        <xsl:attribute name="name">
            <xsl:value-of select="concat(substring(., 0, string-length(.) - 3), 'SimpleType')"/>
        </xsl:attribute>
    </xsl:template>

    <!-- ******** Element Generation ********-->
    <xsl:template match="xsd:simpleType" mode="el">
        <xsl:variable name="restr" select="xsd:restriction"/>
        <xsl:variable name="match">
            <xsl:copy-of select="$normenumerationtypes[deep-equal(xsd:restriction, $restr)]"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string-length($match/*/@name) > 0">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="name">
                        <xsl:value-of select="substring-before(@name, 'SimpleType')"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="$match/*/@name"/>
                    </xsl:attribute>
                    <xsl:copy-of select="xsd:annotation"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="xsd:element">
                    <xsl:attribute name="name">
                        <xsl:value-of select="substring-before(@name, 'SimpleType')"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="@name"/>
                    </xsl:attribute>
                    <xsl:copy-of select="xsd:annotation"/>
                </xsl:element>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ******** FORMATIING ********-->
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:copy-of select="normalize-space(.)"/>
    </xsl:template>

    <!--Copy annotation only it has descendents with text content-->
    <!--Add xsd:documentation using FudExplanation if it exists-->
    <xsl:template match="xsd:annotation">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="@*"/>
                <xsl:if test="exists(xsd:appinfo/*:FudExplanation) and not(xsd:documentation/text())">
                    <xsl:element name="xsd:documentation">
                        <xsl:value-of select="normalize-space(xsd:appinfo[1]/*:FudExplanation[1])"/>
                    </xsl:element>
                </xsl:if>
                <xsl:apply-templates select="*"/>
            </xsl:copy>
    </xsl:template>

    <!--Copy documentation -->
    <xsl:template match="xsd:documentation">
        <xsl:copy copy-namespaces="no">
        <xsl:choose>
            <xsl:when test="text()">
                    <xsl:apply-templates select="text()"/>
            </xsl:when>
            <xsl:when test="ancestor::xsd:enumeration">
                <xsl:value-of select="normalize-space(parent::xsd:annotation/xsd:appinfo/*:DataItem/text())"/>
            </xsl:when>
            <xsl:otherwise>
                    <xsl:text>Data definition required</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <!--Copy element and use template mode to convert elements to attributes-->
    <xsl:template match="xsd:appinfo">
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Field" namespace="urn:mtf:mil:6040b:goe:fields">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:enumeration/xsd:annotation">
        <xsl:copy copy-namespaces="no">
<!--            <xsl:element name="xsd:documentation">
                <xsl:value-of select="normalize-space(xsd:appinfo/*:DataItem/text())"/>
            </xsl:element>-->
            <xsl:apply-templates select="xsd:documentation"/>
            <xsl:apply-templates select="xsd:appinfo"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:enumeration/xsd:annotation/xsd:appinfo">
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Enum" namespace="urn:mtf:mil:6040b:goe:fields">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
            </xsl:element>
        </xsl:copy>
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

    <xsl:template match="*:FudName" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt = ' ') and not(*) and not($txt = '')">
            <xsl:attribute name="name">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:DataCode" mode="attr"/>

    <!--    <xsl:template match="*:DataCode" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt = ' ') and not(*) and not($txt = '')">
            <xsl:attribute name="dataCode">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>-->

    <xsl:template match="*:DataItem" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt = ' ') and not(*) and not($txt = '')">
            <xsl:attribute name="dataItem">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FudExplanation" mode="attr"/>
    <xsl:template match="*:Explanation" mode="attr"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber" mode="attr"/>
    <xsl:template match="*:FudNumber" mode="attr"/>
    <xsl:template match="*:VersionIndicator" mode="attr"/>
    <xsl:template match="*:MinimumLength" mode="attr"/>
    <xsl:template match="*:MaximumLength" mode="attr"/>
    <xsl:template match="*:LengthLimitation" mode="attr"/>
    <xsl:template match="*:UnitOfMeasure" mode="attr"/>
    <xsl:template match="*:Type" mode="attr"/>
    <xsl:template match="*:FudSponsor" mode="attr"/>
    <xsl:template match="*:FudRelatedDocument" mode="attr"/>
    <xsl:template match="*:DataType" mode="attr"/>
    <xsl:template match="*:EntryType" mode="attr"/>
    <xsl:template match="*:MinimumInclusiveValue" mode="attr"/>
    <xsl:template match="*:MaximumInclusiveValue" mode="attr"/>
    <xsl:template match="*:LengthVariable" mode="attr"/>
    <xsl:template match="*:DataItemSponsor" mode="attr"/>
    <xsl:template match="*:DataItemSequenceNumber" mode="attr"/>
    <xsl:template match="*" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="text()" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="copy">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="text()" mode="copy">
        <xsl:value-of select="."/>
    </xsl:template>

</xsl:stylesheet>
