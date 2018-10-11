<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2017 JD NEUSHUL
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
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/" xmlns:ism="urn:us:gov:ic:ism"
    xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/"
    xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo"
    xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="NiemMap.xsl"/>
    <!--Outputs-->
    <xsl:variable name="setxsdoutputdoc" select="concat($srcdir, 'NIEM_MTF/NIEM_MTF_Sets.xsd')"/>
    <xsl:variable name="setmapsoutput"
        select="concat($srcdir, 'NIEM_MTF/Maps/NIEM_MTF_Setmaps.xml')"/>

    <!-- XSD GENERATION-->
    <!-- _______________________________________________________ -->

    <xsl:variable name="setfields">
        <!--Add New Elements for Field Groups when more than one child-->
        <xsl:for-each select="$niem_sets_map//Sequence[@name = 'GroupOfFields']">
            <xsl:choose>
                <xsl:when test="count(./Element) = 1"/>
                <!--                    <xsl:variable name="n" select="Element[1]/@niemelementname"/>
                    <xs:element name="{$n}">
                        <xsl:if test="Element[1]/@niemtype">
                            <xsl:attribute name="type">
                                <xsl:value-of select="Element[1]/@niemtype"/>
                            </xsl:attribute>
                        </xsl:if>
                      
                        <xsl:if test="not(@substgrpname)">
                            <xsl:attribute name="nillable">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@niemtypedoc) &gt; 0">
                                        <xsl:value-of select="@niemtypedoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@mtfdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xs:documentation>
                            <xsl:for-each select="appinfo/*">
                                <xs:appinfo>
                                    <xsl:copy-of select="."/>
                                </xs:appinfo>
                            </xsl:for-each>
                            <xsl:if test="@substgrpname">
                                <xs:appinfo>
                                    <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                        </xsl:for-each>
                                    </mtfappinfo:Choice>
                                </xs:appinfo>
                            </xsl:if>
                        </xs:annotation>
                    </xs:element>
                </xsl:when>-->
                <xsl:otherwise>
                    <xsl:variable name="setname">
                        <xsl:value-of select="ancestor::Set/@niemelementname"/>
                    </xsl:variable>
                    <xsl:variable name="setdocname">
                        <xsl:value-of select="lower-case(ancestor::Set/appinfo/mtfappinfo:Set/@setname)"/>
                    </xsl:variable>
                    <xsl:variable name="setdoc">
                        <xsl:value-of select="ancestor::Set/@niemtypedoc"/>
                    </xsl:variable>
                    <xsl:variable name="fielddocname">
                        <xsl:value-of select="lower-case(Element[1]/appinfo/mtfappinfo:Field/@positionName)"/>
                    </xsl:variable>
                    <xsl:variable name="fgname">
                        <xsl:choose>
                            <xsl:when test="exists(Element[1]/@niemelementname) and count(Element) = 1">
                                <xsl:value-of select="concat(Element[1]/@niemelementname, 'FieldGroup')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($setname, 'FieldGroup')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="doc">
                        <xsl:choose>
                            <xsl:when test="exists(Element[1]/@niemtypedoc) and count(Element) = 1">
                                <xsl:value-of select="Element[1]/@niemtypedoc"/>
                            </xsl:when>
                            <xsl:when test="count(Element) = 1">
                                <xsl:value-of select="concat('A data type for ', $fielddocname, ' field group')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('A data type for ', $setdocname, ' field group')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="datadefdoc">
                        <xsl:choose>
                            <xsl:when test="starts-with($doc, 'A data type')">
                                <xsl:value-of select="$doc"/>
                            </xsl:when>
                            <xsl:when test="starts-with($doc, 'A ')">
                                <xsl:value-of select="concat('A ', substring(lower-case($doc), 1))"/>
                            </xsl:when>
                            <xsl:when test="starts-with($doc, 'An ')">
                                <xsl:value-of select="concat('A ', substring(lower-case($doc), 1))"/>
                            </xsl:when>
                            <xsl:when test="contains('AEIOU', substring($doc, 0, 1))">
                                <xsl:value-of select="concat('An ', lower-case($doc))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('A ', lower-case($doc))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xs:element name="{$fgname}" type="{concat($fgname,'Type')}" nillable="true">
                        <!--<xsl:copy-of select="@minOccurs"/>
                        <xsl:copy-of select="@maxOccurs"/>-->
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:value-of select="replace($datadefdoc, 'type', 'item')"/>
                            </xs:documentation>
                        </xs:annotation>
                    </xs:element>
                    <xs:complexType name="{concat($fgname,'Type')}">
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:value-of select="$datadefdoc"/>
                            </xs:documentation>
                        </xs:annotation>
                        <xs:complexContent>
                            <xs:extension base="structures:ObjectType">
                                <xs:sequence>
                                    <xsl:for-each select="Element">
                                        <xsl:variable name="refname">
                                            <xsl:choose>
                                                <xsl:when test="@substgrpname">
                                                    <xsl:value-of select="@substgrpname"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@niemelementname"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xs:element ref="{$refname}">
                                            <xsl:copy-of select="@minOccurs"/>
                                            <xsl:copy-of select="@maxOccurs"/>
                                            <xs:annotation>
                                                <xs:documentation>
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                                            <xsl:value-of select="@substgrpdoc"/>
                                                        </xsl:when>
                                                        <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                                            <xsl:value-of select="replace(@mtfdoc, 'A data type', 'A data item')"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="@niemelementdoc"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xs:documentation>
                                                <xsl:for-each select="appinfo/*">
                                                    <xs:appinfo>
                                                        <xsl:copy-of select="."/>
                                                    </xs:appinfo>
                                                </xsl:for-each>
                                                <xsl:if test="@substgrpname">
                                                    <xs:appinfo>
                                                        <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                                            <xsl:for-each select="Choice/Element">
                                                                <xsl:sort select="@name"/>
                                                                <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                                            </xsl:for-each>
                                                        </mtfappinfo:Choice>
                                                    </xs:appinfo>
                                                </xsl:if>
                                            </xs:annotation>
                                        </xs:element>
                                    </xsl:for-each>
                                    <xs:element ref="{concat($fgname,'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                                </xs:sequence>
                            </xs:extension>
                        </xs:complexContent>
                    </xs:complexType>
                    <xs:element name="{concat($fgname,'AugmentationPoint')}" abstract="true">
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:value-of select="concat('An augmentation point for ', replace($datadefdoc, 'A data type for', ''))"/>
                            </xs:documentation>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <!--Process all elements that reference set objects -->
        <xsl:for-each select="$all_set_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n">
                <xsl:choose>
                    <xsl:when test="@substgrpname">
                        <xsl:value-of select="@substgrpname"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@niemelementname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="starts-with(@mtftype, 'f:')"/>
                <xsl:when test="starts-with(Choice/Element[1]/@mtftype, 'f:')"/>
                <xsl:when test="starts-with(@mtftype, 'c:')"/>
                <xsl:when test="starts-with(Choice/Element[1]/@mtftype, 'c:')"/>
                <xsl:when test="@niemelementname = 'FreeText'"/>
                <xsl:otherwise>
                    <xs:element name="{$n}">
                        <xsl:if test="@niemtype">
                            <xsl:attribute name="type">
                                <xsl:value-of select="@niemtype"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@substgrpname">
                            <xsl:attribute name="abstract">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@substitutiongroup">
                            <xsl:attribute name="substitutionGroup">
                                <xsl:value-of select="@substitutiongroup"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="not(@substgrpname)">
                            <xsl:attribute name="nillable">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@niemtypedoc) &gt; 0">
                                        <xsl:value-of select="@niemtypedoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@mtfdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xs:documentation>
                            <xsl:for-each select="appinfo/*">
                                <xs:appinfo>
                                    <xsl:copy-of select="."/>
                                </xs:appinfo>
                            </xsl:for-each>
                            <xsl:if test="@substgrpname">
                                <xs:appinfo>
                                    <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                        </xsl:for-each>
                                    </mtfappinfo:Choice>
                                </xs:appinfo>
                            </xsl:if>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="setsxsd">
        <xsl:for-each select="$niem_sets_map/Set">
            <xsl:sort select="@niemtype"/>
            <xsl:variable name="setname">
                <xsl:value-of select="@niemelementname"/>
            </xsl:variable>
            <xsl:variable name="basetype">
                <xsl:choose>
                    <xsl:when test="@mtfname = 'SetBaseType'">
                        <xsl:text>structures:ObjectType</xsl:text>
                    </xsl:when>
                    <xsl:when test="@mtfname = 'OperationIdentificationDataType'">
                        <xsl:text>structures:ObjectType</xsl:text>
                    </xsl:when>
                    <xsl:when test="@mtfname = 'ExerciseIdentificationType'">
                        <xsl:text>structures:ObjectType</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>SetBaseType</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xs:complexType name="{@niemtype}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xs:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xs:appinfo>
                            <xsl:copy-of select="."/>
                        </xs:appinfo>
                    </xsl:for-each>
                </xs:annotation>
                <xs:complexContent>
                    <xs:extension base="{$basetype}">
                        <xs:sequence>
                            <xsl:for-each select="*:Sequence/*">
                                <xsl:variable name="refname">
                                    <xsl:choose>
                                        <xsl:when test="@name = 'GroupOfFields'">
                                            <xsl:choose>
                                                <xsl:when test="count(Element) = 1">
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(Element/@substgrpname) &gt; 0">
                                                            <xsl:value-of select="Element/@substgrpname"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="Element/@niemelementname"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat($setname, 'FieldGroup')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@niemelementname"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xs:element ref="{$refname}">
                                    <xsl:copy-of select="@minOccurs"/>
                                    <xsl:copy-of select="@maxOccurs"/>
                                    <xs:annotation>
                                        <xs:documentation>
                                            <xsl:choose>
                                                <xsl:when test="$refname = 'FreeText'">
                                                    <xsl:text>A data item for text entry</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                                    <xsl:value-of select="@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(Choice/@substgrpdoc) &gt; 0">
                                                    <xsl:value-of select="Choice/@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(Element[1]/@substgrpdoc) &gt; 0">
                                                    <xsl:value-of select="Element[1]/@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                                                    <xsl:value-of select="@niemelementdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(Element[1]/@niemelementdoc) &gt; 0">
                                                    <xsl:value-of select="Element[1]/@niemelementdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(@niemtypedoc) &gt; 0">
                                                    <xsl:value-of select="@niemtypedoc"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:call-template name="breakIntoWords">
                                                        <xsl:with-param name="string" select="$refname"/>
                                                    </xsl:call-template>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xs:documentation>
                                        <xsl:for-each select="appinfo/*">
                                            <xs:appinfo>
                                                <xsl:copy-of select="." copy-namespaces="no"/>
                                            </xs:appinfo>
                                        </xsl:for-each>
                                        <xsl:if test="@substgrpname">
                                            <xs:appinfo>
                                                <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                                    <xsl:for-each select="Choice/Element">
                                                        <xsl:sort select="@name"/>
                                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                                    </xsl:for-each>
                                                </mtfappinfo:Choice>
                                            </xs:appinfo>
                                        </xsl:if>
                                    </xs:annotation>
                                </xs:element>
                            </xsl:for-each>
                            <xs:element ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
            <xs:element name="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}" abstract="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @niemtype)"/>
                    </xs:documentation>
                </xs:annotation>
            </xs:element>
            <xsl:choose>
                <xsl:when test="@niemelementname = 'SetBase'"/>
                <xsl:otherwise>
                    <xs:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xs:documentation>
                            <xsl:if test="@substgrpname">
                                <xs:appinfo>
                                    <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                        </xsl:for-each>
                                    </mtfappinfo:Choice>
                                </xs:appinfo>
                            </xsl:if>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <!--Global Set Elements-->
        <xsl:for-each select="$setfields/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <!--Set Elements with Choice to Substitution Groups-->
        <xsl:for-each select="$all_set_elements_map//Element[@niemelementname][Choice]">
            <xsl:variable name="substgrp" select="Choice/@substgrpname"/>
            <xsl:variable name="substgrpdoc" select="Choice/@substgrpdoc"/>
            <xsl:variable name="setname" select="@setname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xs:complexType name="{concat(@niemelementname,'Type')}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="$substgrpdoc"/>
                    </xs:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xs:appinfo>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xs:appinfo>
                    </xsl:for-each>
                </xs:annotation>
                <xs:complexContent>
                    <xs:extension base="SetBaseType">
                        <xs:sequence>
                            <xs:element ref="{Choice/@substgrpname}">
                                <xs:annotation>
                                    <xs:documentation>
                                        <xsl:value-of select="$substgrpdoc"/>
                                    </xs:documentation>
                                    <xs:appinfo>
                                        <mtfappinfo:Choice substitutionGroup="{Choice/@substgrpname}">
                                            <xsl:for-each select="Choice/Element">
                                                <xsl:sort select="@niemelementname"/>
                                                <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                            </xsl:for-each>
                                        </mtfappinfo:Choice>
                                    </xs:appinfo>
                                </xs:annotation>
                            </xs:element>
                            <xs:element ref="{concat(@niemelementname,'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
            <xs:element name="{@niemelementname}" type="{concat(@niemelementname,'Type')}" nillable="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@niemelementdoc"/>
                    </xs:documentation>
                    <xsl:choose>
                        <xsl:when test="Choice/@substgrpname">
                            <xs:appinfo>
                                <mtfappinfo:Choice substitutionGroup="{Choice/@substgrpname}">
                                    <xsl:for-each select="Choice/Element">
                                        <xsl:sort select="@name"/>
                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xs:appinfo>
                        </xsl:when>
                        <!--<xsl:when test="appinfo">
                            <xs:appinfo>
                                <xsl:for-each select="appinfo/*">
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xsl:for-each>
                            </xs:appinfo>
                        </xsl:when>-->
                    </xsl:choose>
                </xs:annotation>
            </xs:element>
            <xs:element name="{concat(@niemelementname,'AugmentationPoint')}" abstract="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', concat(@niemelementname, 'Type'))"/>
                    </xs:documentation>
                </xs:annotation>
            </xs:element>
            <xsl:choose>
                <xsl:when test="$all_field_elements_map/Element[@substitutiongroup = $substgrp]"/>
                <!--<xsl:when test="$all_composite_elements_map/Element[@substitutiongroup=$substgrp]"/>-->
                <xsl:otherwise>
                    <xs:element name="{Choice/@substgrpname}" abstract="true">
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:value-of select="Choice/@substgrpdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <mtfappinfo:Choice substitutionGroup="{Choice/@substgrpname}">
                                    <xsl:for-each select="Choice/Element">
                                        <xsl:sort select="@niemelementname"/>
                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
            <!--<xsl:for-each select="Choice/Element">
                <xsl:sort select="@niemelementname"/>
                <xsl:variable name="n" select="@niemelementname"/>
                <xs:element name="{@niemelementname}" type="{@niemtype}" substitutionGroup="{$substgrp}" nillable="true">
                    <xs:annotation> 
                        <xs:documentation>
                            <xsl:value-of select="@niemelementdoc"/>
                        </xs:documentation>
                        <!-\-<xs:appinfo>
                                <xsl:for-each select="appinfo/*">
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xsl:for-each>
                            </xs:appinfo>-\->
                    </xs:annotation>
                </xs:element>
            </xsl:for-each>-->
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_sets_xsd">
        <xsl:for-each select="$setsxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$setsxsd/*:element[@name]">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:choose>
                <xsl:when test="count(preceding-sibling::*:element[@name = $n and @type = $t]) &gt; 0"/>
                <xsl:when test="count(preceding-sibling::*:element[@name = $n][ends-with(@name, 'Abstract') or ends-with(@name, 'AugmentationPoint')]) &gt; 0"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
   <!-- _______________________________________________________ -->
    <!--    OUTPUT RESULT-->
    <xsl:template name="main">
        <xsl:result-document href="{$setxsdoutputdoc}">
            <xs:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
                xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/"
                xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument"
                xml:lang="en-US" elementFormDefault="unqualified" attributeFormDefault="unqualified"
                version="1.0">
                <xs:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/structures/4.0/"
                    schemaLocation="ext/niem/utility/structures/4.0/structures.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/localTerminology/3.0/"
                    schemaLocation="./localTerminology.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/appinfo/4.0/"
                    schemaLocation="ext/niem/utility/appinfo/4.0/appinfo.xsd"/>
                <xs:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="./mtfappinfo.xsd"/>
                <xs:include schemaLocation="NIEM_MTF_Fields.xsd"/>
                <xs:include schemaLocation="NIEM_MTF_Composites.xsd"/>
                <xs:annotation>
                    <xs:documentation>
                        <xsl:text>Set structures for MTF Messages</xsl:text>
                    </xs:documentation>
                </xs:annotation>
                <xsl:copy-of select="$mtf_sets_xsd" copy-namespaces="no"/>
            </xs:schema>
        </xsl:result-document>
        <xsl:result-document href="{$setmapsoutput}">
            <Sets>
                <xsl:copy-of select="$niem_sets_map"/>
            </Sets>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
