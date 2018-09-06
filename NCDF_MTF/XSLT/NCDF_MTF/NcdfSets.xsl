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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:term="http://release.ncdf.gov/ncdf/localTerminology/3.0/"
    xmlns:ism="urn:us:gov:ic:ism" xmlns:appinfo="http://release.ncdf.gov/ncdf/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
    exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="NiemMap.xsl"/>
    <!--Outputs-->
    <xsl:variable name="setxsdoutputdoc" select="concat($srcdir, 'NCDF_MTF/NCDF_MTF_Sets.xsd')"/>
    <xsl:variable name="setmapsoutput" select="concat($srcdir, 'NCDF_MTF/Maps/NCDF_MTF_Setmaps.xml')"/>

    <!-- XSD GENERATION-->
    <!-- _______________________________________________________ -->

    <xsl:variable name="setfields">
        <!--Add New Elements for Field Groups when more than one child-->
        <xsl:for-each select="$ncdf_sets_map//Sequence[@name = 'GroupOfFields']">
            <xsl:choose>
                <xsl:when test="count(./Element) = 1"/>
                <!--                    <xsl:variable name="n" select="Element[1]/@ncdfelementname"/>
                    <xsd:element name="{$n}">
                        <xsl:if test="Element[1]/@ncdftype">
                            <xsl:attribute name="type">
                                <xsl:value-of select="Element[1]/@ncdftype"/>
                            </xsl:attribute>
                        </xsl:if>
                      
                        <xsl:if test="not(@substgrpname)">
                            <xsl:attribute name="nillable">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@ncdfelementdoc) &gt; 0">
                                        <xsl:value-of select="@ncdfelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@ncdftypedoc) &gt; 0">
                                        <xsl:value-of select="@ncdftypedoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@mtfdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsd:documentation>
                            <xsl:for-each select="appinfo/*">
                                <xsd:appinfo>
                                    <xsl:copy-of select="."/>
                                </xsd:appinfo>
                            </xsl:for-each>
                            <xsl:if test="@substgrpname">
                                <xsd:appinfo>
                                    <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                        </xsl:for-each>
                                    </mtfappinfo:Choice>
                                </xsd:appinfo>
                            </xsl:if>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>-->
                <xsl:otherwise>
                    <xsl:variable name="setname">
                        <xsl:value-of select="ancestor::Set/@ncdfelementname"/>
                    </xsl:variable>
                    <xsl:variable name="setdocname">
                        <xsl:value-of select="lower-case(ancestor::Set/appinfo/mtfappinfo:Set/@setname)"/>
                    </xsl:variable>
                    <xsl:variable name="setdoc">
                        <xsl:value-of select="ancestor::Set/@ncdftypedoc"/>
                    </xsl:variable>
                    <xsl:variable name="fielddocname">
                        <xsl:value-of select="lower-case(Element[1]/appinfo/mtfappinfo:Field/@positionName)"/>
                    </xsl:variable>
                    <xsl:variable name="fgname">
                        <xsl:choose>
                            <xsl:when test="exists(Element[1]/@ncdfelementname) and count(Element) = 1">
                                <xsl:value-of select="concat(Element[1]/@ncdfelementname, 'FieldGroup')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($setname, 'FieldGroup')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="doc">
                        <xsl:choose>
                            <xsl:when test="exists(Element[1]/@ncdftypedoc) and count(Element) = 1">
                                <xsl:value-of select="Element[1]/@ncdftypedoc"/>
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
                    <xsd:element name="{$fgname}" type="{concat($fgname,'Type')}" nillable="true">
                        <!--<xsl:copy-of select="@minOccurs"/>
                        <xsl:copy-of select="@maxOccurs"/>-->
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="replace($datadefdoc, 'type', 'item')"/>
                            </xsd:documentation>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:complexType name="{concat($fgname,'Type')}">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="$datadefdoc"/>
                            </xsd:documentation>
                        </xsd:annotation>
                        <xsd:complexContent>
                            <xsd:extension base="structures:ObjectType">
                                <xsd:sequence>
                                    <xsl:for-each select="Element">
                                        <xsl:variable name="refname">
                                            <xsl:choose>
                                                <xsl:when test="@substgrpname">
                                                    <xsl:value-of select="@substgrpname"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@ncdfelementname"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsd:element ref="{$refname}">
                                            <xsl:copy-of select="@minOccurs"/>
                                            <xsl:copy-of select="@maxOccurs"/>
                                            <xsd:annotation>
                                                <xsd:documentation>
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                                            <xsl:value-of select="@substgrpdoc"/>
                                                        </xsl:when>
                                                        <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                                            <xsl:value-of select="replace(@mtfdoc, 'A data type', 'A data item')"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="@ncdfelementdoc"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsd:documentation>
                                                <xsl:for-each select="appinfo/*">
                                                    <xsd:appinfo>
                                                        <xsl:copy-of select="."/>
                                                    </xsd:appinfo>
                                                </xsl:for-each>
                                                <xsl:if test="@substgrpname">
                                                    <xsd:appinfo>
                                                        <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                                            <xsl:for-each select="Choice/Element">
                                                                <xsl:sort select="@name"/>
                                                                <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                                            </xsl:for-each>
                                                        </mtfappinfo:Choice>
                                                    </xsd:appinfo>
                                                </xsl:if>
                                            </xsd:annotation>
                                        </xsd:element>
                                    </xsl:for-each>
                                    <xsd:element ref="{concat($fgname,'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                                </xsd:sequence>
                            </xsd:extension>
                        </xsd:complexContent>
                    </xsd:complexType>
                    <xsd:element name="{concat($fgname,'AugmentationPoint')}" abstract="true">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="concat('An augmentation point for ', replace($datadefdoc, 'A data type for', ''))"/>
                            </xsd:documentation>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <!--Process all elements that reference set objects -->
        <xsl:for-each select="$all_set_elements_map/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:variable name="n">
                <xsl:choose>
                    <xsl:when test="@substgrpname">
                        <xsl:value-of select="@substgrpname"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@ncdfelementname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="starts-with(@mtftype, 'f:')"/>
                <xsl:when test="starts-with(Choice/Element[1]/@mtftype, 'f:')"/>
                <xsl:when test="starts-with(@mtftype, 'c:')"/>
                <xsl:when test="starts-with(Choice/Element[1]/@mtftype, 'c:')"/>
                <xsl:when test="@ncdfelementname = 'FreeText'"/>
                <xsl:otherwise>
                    <xsd:element name="{$n}">
                        <xsl:if test="@ncdftype">
                            <xsl:attribute name="type">
                                <xsl:value-of select="@ncdftype"/>
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
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@ncdfelementdoc) &gt; 0">
                                        <xsl:value-of select="@ncdfelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@ncdftypedoc) &gt; 0">
                                        <xsl:value-of select="@ncdftypedoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@mtfdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsd:documentation>
                            <xsl:for-each select="appinfo/*">
                                <xsd:appinfo>
                                    <xsl:copy-of select="."/>
                                </xsd:appinfo>
                            </xsl:for-each>
                            <xsl:if test="@substgrpname">
                                <xsd:appinfo>
                                    <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                        </xsl:for-each>
                                    </mtfappinfo:Choice>
                                </xsd:appinfo>
                            </xsl:if>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="setsxsd">
        <xsl:for-each select="$ncdf_sets_map/Set">
            <xsl:sort select="@ncdftype"/>
            <xsl:variable name="setname">
                <xsl:value-of select="@ncdfelementname"/>
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
            <xsd:complexType name="{@ncdftype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@ncdftypedoc"/>
                    </xsd:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xsd:appinfo>
                            <xsl:copy-of select="."/>
                        </xsd:appinfo>
                    </xsl:for-each>
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="{$basetype}">
                        <xsd:sequence>
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
                                                            <xsl:value-of select="Element/@ncdfelementname"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat($setname, 'FieldGroup')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@ncdfelementname"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsd:element ref="{$refname}">
                                    <xsl:copy-of select="@minOccurs"/>
                                    <xsl:copy-of select="@maxOccurs"/>
                                    <xsd:annotation>
                                        <xsd:documentation>
                                            <xsl:choose>
                                                <xsl:when test="$refname ='FreeText'">
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
                                                <xsl:when test="string-length(@ncdfelementdoc) &gt; 0">
                                                    <xsl:value-of select="@ncdfelementdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(Element[1]/@ncdfelementdoc) &gt; 0">
                                                    <xsl:value-of select="Element[1]/@ncdfelementdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(@ncdftypedoc) &gt; 0">
                                                    <xsl:value-of select="@ncdftypedoc"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:call-template name="breakIntoWords">
                                                        <xsl:with-param name="string" select="$refname"/>
                                                    </xsl:call-template>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsd:documentation>
                                        <xsl:for-each select="appinfo/*">
                                            <xsd:appinfo>
                                                <xsl:copy-of select="." copy-namespaces="no"/>
                                            </xsd:appinfo>
                                        </xsl:for-each>
                                        <xsl:if test="@substgrpname">
                                            <xsd:appinfo>
                                                <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                                    <xsl:for-each select="Choice/Element">
                                                        <xsl:sort select="@name"/>
                                                        <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                                    </xsl:for-each>
                                                </mtfappinfo:Choice>
                                            </xsd:appinfo>
                                        </xsl:if>
                                    </xsd:annotation>
                                </xsd:element>
                            </xsl:for-each>
                            <xsd:element ref="{concat(substring(@ncdftype,0,string-length(@ncdftype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{concat(substring(@ncdftype,0,string-length(@ncdftype)-3),'AugmentationPoint')}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @ncdftype)"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsl:choose>
                <xsl:when test="@ncdfelementname = 'SetBase'"/>
                <xsl:otherwise>
                    <xsd:element name="{@ncdfelementname}" type="{@ncdftype}" nillable="true">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@ncdfelementdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsd:documentation>
                            <xsl:if test="@substgrpname">
                                <xsd:appinfo>
                                    <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                        </xsl:for-each>
                                    </mtfappinfo:Choice>
                                </xsd:appinfo>
                            </xsl:if>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <!--Global Set Elements-->
        <xsl:for-each select="$setfields/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <!--Set Elements with Choice to Substitution Groups-->
        <xsl:for-each select="$all_set_elements_map//Element[@ncdfelementname][Choice]">
            <xsl:variable name="substgrp" select="Choice/@substgrpname"/>
            <xsl:variable name="substgrpdoc" select="Choice/@substgrpdoc"/>
            <xsl:variable name="setname" select="@setname"/>
            <xsl:variable name="n" select="@ncdfelementname"/>
            <xsd:complexType name="{concat(@ncdfelementname,'Type')}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="$substgrpdoc"/>
                    </xsd:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xsd:appinfo>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsd:appinfo>
                    </xsl:for-each>
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="SetBaseType">
                        <xsd:sequence>
                            <xsd:element ref="{Choice/@substgrpname}">
                                <xsd:annotation>
                                    <xsd:documentation>
                                        <xsl:value-of select="$substgrpdoc"/>
                                    </xsd:documentation>
                                    <xsd:appinfo>
                                        <mtfappinfo:Choice substitutionGroup="{Choice/@substgrpname}">
                                            <xsl:for-each select="Choice/Element">
                                                <xsl:sort select="@ncdfelementname"/>
                                                <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                            </xsl:for-each>
                                        </mtfappinfo:Choice>
                                    </xsd:appinfo>
                                </xsd:annotation>
                            </xsd:element>
                            <xsd:element ref="{concat(@ncdfelementname,'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{@ncdfelementname}" type="{concat(@ncdfelementname,'Type')}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@ncdfelementdoc"/>
                    </xsd:documentation>
                    <xsl:choose>
                        <xsl:when test="Choice/@substgrpname">
                            <xsd:appinfo>
                                <mtfappinfo:Choice substitutionGroup="{Choice/@substgrpname}">
                                    <xsl:for-each select="Choice/Element">
                                        <xsl:sort select="@name"/>
                                        <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xsd:appinfo>
                        </xsl:when>
                        <!--<xsl:when test="appinfo">
                            <xsd:appinfo>
                                <xsl:for-each select="appinfo/*">
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xsl:for-each>
                            </xsd:appinfo>
                        </xsl:when>-->
                    </xsl:choose>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="{concat(@ncdfelementname,'AugmentationPoint')}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', concat(@ncdfelementname, 'Type'))"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsl:choose>
                <xsl:when test="$all_field_elements_map/Element[@substitutiongroup=$substgrp]"/>
                <!--<xsl:when test="$all_composite_elements_map/Element[@substitutiongroup=$substgrp]"/>-->
                <xsl:otherwise>
                    <xsd:element name="{Choice/@substgrpname}" abstract="true">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="Choice/@substgrpdoc"/>
                            </xsd:documentation>
                            <xsd:appinfo>
                                <mtfappinfo:Choice substitutionGroup="{Choice/@substgrpname}">
                                    <xsl:for-each select="Choice/Element">
                                        <xsl:sort select="@ncdfelementname"/>
                                        <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:otherwise>
            </xsl:choose>
            <!--<xsl:for-each select="Choice/Element">
                <xsl:sort select="@ncdfelementname"/>
                <xsl:variable name="n" select="@ncdfelementname"/>
                <xsd:element name="{@ncdfelementname}" type="{@ncdftype}" substitutionGroup="{$substgrp}" nillable="true">
                    <xsd:annotation> 
                        <xsd:documentation>
                            <xsl:value-of select="@ncdfelementdoc"/>
                        </xsd:documentation>
                        <!-\-<xsd:appinfo>
                                <xsl:for-each select="appinfo/*">
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xsl:for-each>
                            </xsd:appinfo>-\->
                    </xsd:annotation>
                </xsd:element>
            </xsl:for-each>-->
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="mtf_sets_xsd">
        <xsl:for-each select="$setsxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$setsxsd/xsd:element[@name]">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:choose>
                <xsl:when test="count(preceding-sibling::xsd:element[@name = $n and @type = $t]) &gt; 0"/>
                <xsl:when test="count(preceding-sibling::xsd:element[@name = $n][ends-with(@name, 'Abstract') or ends-with(@name, 'AugmentationPoint')]) &gt; 0"/>
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
            <xsd:schema xmlns="urn:mtf:mil:6040b:ncdf:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.ncdf.gov/ncdf/conformanceTargets/3.0/"
                xmlns:structures="http://release.ncdf.gov/ncdf/structures/4.0/" xmlns:term="http://release.ncdf.gov/ncdf/localTerminology/3.0/"
                xmlns:appinfo="http://release.ncdf.gov/ncdf/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:ncdf:mtf" ct:conformanceTargets="http://reference.ncdf.gov/ncdf/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/structures/4.0/" schemaLocation="../NCDF/structures.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/localTerminology/3.0/" schemaLocation="../NCDF/localTerminology.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/appinfo/4.0/" schemaLocation="../NCDF/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NCDF/mtfappinfo.xsd"/>
                <xsd:include schemaLocation="NCDF_MTF_Fields.xsd"/>
                <xsd:include schemaLocation="NCDF_MTF_Composites.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Set structures for MTF Messages</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:copy-of select="$mtf_sets_xsd" copy-namespaces="no"/>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$setmapsoutput}">
            <Sets>
                <xsl:copy-of select="$ncdf_sets_map"/>
            </Sets>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
