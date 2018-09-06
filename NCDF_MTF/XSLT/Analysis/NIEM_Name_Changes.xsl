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

    <xsl:variable name="niem_fields_xsd" select="document('../../XSD/NIEM_Schema/NIEM_fields.xsd')"/>
    <xsl:variable name="niem_composites_xsd" select="document('../../XSD/NIEM_Schema/NIEM_composites.xsd')"/>

    <xsl:variable name="field_output" select="'../../XSD/Refactor_Node_Changes/field_changes.xml'"/>
    <xsl:variable name="field_xsd_output" select="'../../XSD/NIEM_Schema/NIEM_field_changed.xsd'"/>

    <xsl:variable name="comp_code_cmplxtype_chg">
        <xsl:for-each select="$niem_composites_xsd/xsd:schema/xsd:complexType[ends-with(@name, 'CodeType')]">
            <xsl:variable name="nn">
                <xsl:value-of select="substring(@name, 0, string-length(@name) - 7)"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:value-of select="concat($nn, 'CdeType')"/>
            </xsl:variable>
            <Composite name="{@name}" changename="{$newname}"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="field_code_smpletype_chg">
        <xsl:for-each select="$niem_fields_xsd/xsd:schema/xsd:simpleType[not(descendant::xsd:enumeration)][ends-with(@name, 'CodeSimpleType')]">
            <xsl:variable name="nn">
                <xsl:value-of select="substring(@name, 0, string-length(@name) - 13)"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:value-of select="concat($nn, 'CdeSimpleType')"/>
            </xsl:variable>
            <SimpleType name="{@name}" changename="{$newname}"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="field_code_cplxtype_chg">
        <xsl:for-each select="$niem_fields_xsd/xsd:schema/xsd:complexType[ends-with(@name, 'CodeType')]">
            <xsl:variable name="b" select="descendant::xsd:extension[1]/@base"/>
            <xsl:if test="not($niem_fields_xsd/xsd:schema/xsd:simpleType[@name = $b]/descendant::xsd:enumeration)">
                <xsl:variable name="nn">
                    <xsl:value-of select="substring(@name, 0, string-length(@name) - 7)"/>
                </xsl:variable>
                <xsl:variable name="newname">
                    <xsl:value-of select="concat($nn, 'CdeType')"/>
                </xsl:variable>
                <ComplexType name="{@name}" changename="{$newname}"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="enum_field_code_type_chg">
        <xsl:for-each select="$niem_fields_xsd/xsd:schema/xsd:simpleType[descendant::xsd:enumeration][not(ends-with(@name, 'CodeSimpleType'))]">
            <xsl:variable name="nn">
                <xsl:value-of select="substring(@name, 0, string-length(@name) - 9)"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:value-of select="concat($nn, 'CodeSimpleType')"/>
            </xsl:variable>
            <EnumeratedFieldSimpleType name="{@name}" changename="{$newname}"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_fields_xsd/xsd:schema/xsd:complexType[not(ends-with(@name, 'CodeType'))]">
            <xsl:variable name="b" select="descendant::*/@base"/>
            <xsl:if test="not($niem_fields_xsd/xsd:schema/xsd:simpleType[@name = $b]/descendant::xsd:enumeration)">
                <xsl:variable name="nn">
                    <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
                </xsl:variable>
                <xsl:variable name="newname">
                    <xsl:value-of select="concat($nn, 'CodeType')"/>
                </xsl:variable>
                <EnumeratedFieldComplexType name="{@name}" changename="{$newname}"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="element_code_chg">
        <xsl:for-each select="$niem_fields_xsd/xsd:schema/xsd:element[ends-with(@name, 'Code')]">
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:variable name="nn">
                <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:value-of select="concat($nn, 'Cde')"/>
            </xsl:variable>
            <xsl:variable name="newtype">
                <xsl:choose>
                    <xsl:when test="$comp_code_cmplxtype_chg/*[@name = $t]">
                        <xsl:value-of select="$comp_code_cmplxtype_chg/*[@name = $t]/@changename"/>
                    </xsl:when>
                    <xsl:when test="$field_code_smpletype_chg/*[@name = $t]">
                        <xsl:value-of select="$field_code_smpletype_chg/*[@name = $t]/@changename"/>
                    </xsl:when>
                    <xsl:when test="$field_code_cplxtype_chg/*[@name = $t]">
                        <xsl:value-of select="$field_code_cplxtype_chg/*[@name = $t]/@changename"/>
                    </xsl:when>
                    <xsl:when test="$enum_field_code_type_chg/*[@name = $t]">
                        <xsl:value-of select="$enum_field_code_type_chg/*[@name = $t]/@changename"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$t"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <Element name="{@name}" type="{@type}" changename="{$newname}">
                <xsl:if test="$newtype != @type">
                    <xsl:attribute name="changetype">
                        <xsl:value-of select="$newtype"/>
                    </xsl:attribute>
                </xsl:if>
            </Element>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="field_changes">
        <CompositeTypes>
            <xsl:for-each select="$comp_code_cmplxtype_chg/*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </CompositeTypes>
        <EnumeratedTypes>
            <xsl:for-each select="$enum_field_code_type_chg/*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </EnumeratedTypes>
        <FieldTypes>
            <xsl:for-each select="$field_code_smpletype_chg/*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="$field_code_cplxtype_chg/*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </FieldTypes>
        <Elements>
            <xsl:for-each select="$element_code_chg/*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </Elements>
    </xsl:variable>

    <xsl:variable name="new_fields_xsd">
        <xsl:apply-templates select="$niem_fields_xsd/*"/>
    </xsl:variable>

    <xsl:template match="*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:complexType/@name">
        <xsl:variable name="n" select="."/>
        <xsl:attribute name="name">
            <xsl:choose>
                <xsl:when test="$field_changes/FieldTypes/ComplexType[@name = $n]">
                    <xsl:value-of select="$field_changes/FieldTypes/ComplexType[@name = $n]/@changename"/>
                </xsl:when>
                <xsl:when test="$field_changes/EnumeratedTypes/EnumeratedFieldComplexType[@name = $n]">
                    <xsl:value-of select="$field_changes/EnumeratedTypes/EnumeratedFieldComplexType[@name = $n]/@changename"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$n"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:simpleType/@name">
        <xsl:variable name="n" select="."/>
        <xsl:attribute name="name">
            <xsl:choose>
                <xsl:when test="$n='TargetCategorySimpleType'">
                    <xsl:text>TargetLethalityCodeSimpleType</xsl:text>
                </xsl:when>
                <xsl:when test="$n='MissionStatusType'">
                    <xsl:text>SARMissionStatusCodeSimpleType</xsl:text>
                </xsl:when>
                <xsl:when test="$field_changes/FieldTypes/SimpleType[@name = $n]">
                    <xsl:value-of select="$field_changes/FieldTypes/SimpleType[@name = $n]/@changename"/>
                </xsl:when>
                <xsl:when test="$field_changes/EnumeratedTypes/EnumeratedFieldSimpleType[@name = $n]">
                    <xsl:value-of select="$field_changes/EnumeratedTypes/EnumeratedFieldSimpleType[@name = $n]/@changename"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$n"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element/@name">
        <xsl:variable name="n" select="."/>
        <xsl:attribute name="name">
            <xsl:choose>
                <xsl:when test="$field_changes/FieldTypes/ComplexType[@name = $n]">
                    <xsl:value-of select="$field_changes/FieldTypes/ComplexType[@name = $n]/@changename"/>
                </xsl:when>
                <xsl:when test="$field_changes/EnumeratedTypes/EnumeratedFieldComplexType[@name = $n]">
                    <xsl:value-of select="$field_changes/EnumeratedTypes/EnumeratedFieldComplexType[@name = $n]/@changename"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$n"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element/@type">
        <xsl:variable name="n" select="."/>
        <xsl:attribute name="type">
            <xsl:choose>
                <xsl:when test="$n='TargetCategorySimpleType'">
                    <xsl:text>TargetLethalityCodeSimpleType</xsl:text>
                </xsl:when>
                <xsl:when test="$n='MissionStatusType'">
                    <xsl:text>SARMissionStatusCodeSimpleType</xsl:text>
                </xsl:when>
                <xsl:when test="$field_changes/FieldTypes/ComplexType[@name = $n]">
                    <xsl:value-of select="$field_changes/FieldTypes/ComplexType[@name = $n]/@changename"/>
                </xsl:when>
                <xsl:when test="$field_changes/FieldTypes/SimpleType[@name = $n]">
                    <xsl:value-of select="$field_changes/FieldTypes/SimpleType[@name = $n]/@changename"/>
                </xsl:when>
                <xsl:when test="$field_changes/EnumeratedTypes/EnumeratedFieldComplexType[@name = $n]">
                    <xsl:value-of select="$field_changes/EnumeratedTypes/EnumeratedFieldComplexType[@name = $n]/@changename"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$n"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@base">
        <xsl:variable name="b" select="."/>
        <xsl:attribute name="base">
            <xsl:choose>
                <xsl:when test="$b='TargetCategorySimpleType'">
                    <xsl:text>TargetLethalityCodeSimpleType</xsl:text>
                </xsl:when>
                <xsl:when test="$field_changes/FieldTypes/SimpleType[@name = $b]">
                    <xsl:value-of select="$field_changes/FieldTypes/SimpleType[@name = $b]/@changename"/>
                </xsl:when>
                <xsl:when test="$field_changes/FieldTypes/ComplexType[@name = $b]">
                    <xsl:value-of select="$field_changes/FieldTypes/ComplexType[@name = $b]/@changename"/>
                </xsl:when>
                <xsl:when test="$field_changes/EnumeratedTypes/EnumeratedFieldSimpleType[@name = $b]">
                    <xsl:value-of select="$field_changes/EnumeratedTypes/EnumeratedFieldSimpleType[@name = $b]/@changename"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$b"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template name="main">
        <xsl:result-document href="{$field_output}">
            <xsl:copy-of select="$field_changes"/>
        </xsl:result-document>
        <xsl:result-document href="{$field_xsd_output}">
            <xsl:copy-of select="$new_fields_xsd"/>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
