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
    <xsl:include href="../USMTF_GoE/USMTF_Utility.xsl"/>
    
    <xsl:variable name="fields_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')"/>
    <xsl:variable name="normalized_fields_xsd" select="document('../../XSD/Normalized/NormalizedSimpleTypes.xsd')"/>
    
    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="enumerations_xsd" select="$fields_xsd/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string'][xsd:enumeration]]"/>
    
    <!--Output-->
    <xsl:variable name="enumerationsoutdoc" select="'../../XSD/Normalized/Enumerations.xsd'"/>
    
    <xsl:variable name="enumerationchanges" select="'../../XSD/Normalized/EnumerationTypeChanges.xml'"/>
    
    
    <xsl:variable name="normenumerationtypes" select="$normalized_fields_xsd/*/xsd:simpleType[xsd:restriction/xsd:enumeration]"/>
    
    <!--xsd:simpleTypes with Enumerations-->
    <xsl:variable name="enumsimpletypes">
        <xsl:for-each select="$enumerations_xsd">
            <xsl:variable name="n">
                <xsl:apply-templates select="@name" mode="txt"/>
            </xsl:variable>
            <xsd:simpleType name="{$n}">
                <xsl:apply-templates select="*"/>
            </xsd:simpleType>
        </xsl:for-each>
    </xsl:variable>
    
    <!--xsd:simpleTypes with Enumerations-->
    <xsl:variable name="normenumtypes">
        <xsl:for-each select="$enumsimpletypes/*">
            <xsl:sort select="@name"/>
            <xsl:variable name="restr" select="xsd:restriction"/>
            <xsl:choose>
                <xsl:when test="$normenumerationtypes[deep-equal(xsd:restriction, $restr)]">
                    <xsd:simpleType name="{$normenumerationtypes[deep-equal(xsd:restriction, $restr)]/@name}">
                        <xsd:annotation>
                            <xsl:apply-templates select="$normenumerationtypes[deep-equal(xsd:restriction, $restr)]/xsd:annotation/xsd:documentation"/>
                        </xsd:annotation>
                        <xsl:copy-of select="$normenumerationtypes[deep-equal(xsd:restriction, $restr)]/xsd:restriction"/>
                    </xsd:simpleType>
                    <Change name="{@name}" changeto="{replace($normenumerationtypes[deep-equal(xsd:restriction, $restr)]/@name,'SimpleType','Type')}"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="enumtypes">
        <xsl:for-each select="$normenumtypes/xsd:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="codename">
                <xsl:choose>
                    <xsl:when test="ends-with($n,'SimpleType')">
                        <xsl:value-of select="$n"/>
                    </xsl:when>
                    <xsl:when test="ends-with($n,'Type')">
                        <xsl:value-of select="concat(substring($n,0,string-length($n)-3),'SimpleType')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="ends-with($n, 'SimpleType') and preceding-sibling::*/@name = $n"/>
                <xsl:otherwise>
                    <xsd:simpleType name="{$codename}">
                        <xsl:apply-templates select="*" mode="copy"/>
                    </xsd:simpleType>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template name="main">
        <xsl:result-document href="{$enumerationsoutdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:goe:fields" 
                xmlns:ism="urn:us:gov:ic:ism:v2" 
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                targetNamespace="urn:mtf:mil:6040b:goe:fields" 
                xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <!--<xsl:for-each select="$enumtypes/*">-->
                <xsl:for-each select="$enumtypes/*">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::*[@name=$n]"/>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$enumerationchanges}">
            <EnumerationChanges>
                <xsl:for-each select="$normenumtypes/Change">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </EnumerationChanges>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
