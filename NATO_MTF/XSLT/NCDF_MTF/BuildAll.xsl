<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2019 JD NEUSHUL
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:inf="urn:int:nato:ncdf:mtf:appinfo" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="NcdfMap.xsl"/>

    <xsl:variable name="dirpath" select="concat($srcdir, 'NCDF_MTF/')"/>

    <!-- _______________________________________________________ -->
    <!--Fields-->
    <xsl:variable name="fieldsxsd">
        <xsl:for-each select="$stringsxsd/*:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:simpleType/@name = $n)">
                <xsl:apply-templates select="." mode="identity"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$stringsxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                <xsl:apply-templates select="." mode="identity"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$numericsxsd/*:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:simpleType/@name = $n)">
                <xsl:apply-templates select="." mode="identity"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$numericsxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                <xsl:apply-templates select="." mode="identity"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$codelistxsd/*:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:simpleType/@name = $n)">
                <xsl:apply-templates select="." mode="identity"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$codelistxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                <xsl:apply-templates select="." mode="identity"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$all_field_elements_map/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:choose>
                <xsl:when test="@ncdftype">
                    <xsl:variable name="n" select="@ncdfelementname"/>
                    <xsl:variable name="t" select="@ncdftype"/>
                    <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                        <xs:element name="{@ncdfelementname}">
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
                            <xs:annotation>
                                <xs:documentation>
                                    <xsl:value-of select="@ncdfelementdoc"/>
                                </xs:documentation>
                                <xs:appinfo>
                                    <xsl:for-each select="info/*">
                                        <xsl:copy-of select="." copy-namespaces="no"/>
                                    </xsl:for-each>
                                </xs:appinfo>
                            </xs:annotation>
                        </xs:element>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="name() = 'Choice'">
                    <xs:element name="{@substgrpname}">
                        <xsl:attribute name="abstract">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <inf:Choice substitutionGroup="{@substgrpname}">
                                    <xsl:for-each select="Element">
                                        <xsl:sort select="@ncdfelementname"/>
                                        <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                    </xsl:for-each>
                                </inf:Choice>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_fields_xsd">
        <xsl:for-each select="$fieldsxsd/*:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="count(preceding-sibling::*:simpleType[@name = $n]) = 0">
                <xsl:apply-templates select="." mode="identity"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="count(preceding-sibling::*:complexType[@name = $n]) = 0">
                <xsl:apply-templates select="." mode="identity"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/*:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="count(preceding-sibling::*:element[@name = $n]) = 0">
                <xsl:apply-templates select="." mode="identity"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_fields_map">
        <xsl:for-each select="$all_field_elements_map/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:if test="string-length(@ncdftype) &gt; 0 and name() = 'Field'">
                <xsl:variable name="n" select="@ncdfelementname"/>
                <xsl:variable name="t" select="@ncdftype"/>
                <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                    <xsl:apply-templates select="." mode="identity"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$all_field_elements_map/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:if test="string-length(@ncdftype) &gt; 0 and name() = 'Element'">
                <xsl:variable name="n" select="@ncdfelementname"/>
                <xsl:variable name="t" select="@ncdftype"/>
                <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                    <xsl:apply-templates select="." mode="identity"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Composites-->
    <xsl:variable name="elementsxsd">
        <xsl:for-each select="$all_composite_elements_map/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:variable name="n" select="@ncdfelementname"/>
            <xsl:variable name="t">
                <xsl:value-of select="@ncdftype"/>
            </xsl:variable>
            <xsl:variable name="s" select="@substgrpname"/>
            <xsl:choose>
                <xsl:when test="$ncdf_fields_map//*[@ncdfelementname = $n]"/>
                <!--<xsl:when test="$all_field_elements_map//*[@ncdfelementname = $n]"/>-->
                <xsl:when test="@substgrpname and $all_field_elements_map//*[@substgrpname = $s]"/>
                <xsl:when test="name() = 'Choice'">
                    <xs:element name="{@substgrpname}">
                        <xsl:attribute name="abstract">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <inf:Choice substitutionGroup="{@substgrpname}">
                                    <xsl:for-each select="Element">
                                        <xsl:sort select="@ncdfelementname"/>
                                        <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                    </xsl:for-each>
                                </inf:Choice>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:when>
                <xsl:otherwise>
                    <xs:element name="{@ncdfelementname}" type="{$t}" nillable="true">
                        <xsl:if test="@substitutiongroup">
                            <xsl:attribute name="substitutionGroup">
                                <xsl:value-of select="@substitutiongroup"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:value-of select="@ncdfelementdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <xsl:for-each select="info/*">
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xsl:for-each>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="compositefields">
        <xsl:for-each select="$ncdf_composites_map//Sequence/Element[starts-with(@mtftype, 'c:')]">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:variable name="n" select="@ncdfelementname"/>
            <xs:element name="{@ncdfelementname}">
                <xsl:attribute name="type">
                    <xsl:value-of select="@ncdfelementtype"/>
                </xsl:attribute>
                <xsl:if test="@substitutiongroup">
                    <xsl:attribute name="substitutionGroup">
                        <xsl:value-of select="@substitutiongroup"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="nillable">
                    <xsl:text>true</xsl:text>
                </xsl:attribute>
                <xs:annotation>
                    <xs:documentation>
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
                    </xs:documentation>
                    <xsl:for-each select="info/*">
                        <xs:appinfo>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xs:appinfo>
                    </xsl:for-each>
                </xs:annotation>
            </xs:element>
        </xsl:for-each>
        <xsl:for-each select="$elementsxsd/*">
            <xsl:variable name="n" select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="compositexsd">
        <xsl:for-each select="$ncdf_composites_map/Composite">
            <xsl:sort select="@ncdftype"/>
            <xs:complexType name="{@ncdftype}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@ncdftypedoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:for-each select="info/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xs:appinfo>
                </xs:annotation>
                <xs:complexContent>
                    <xs:extension base="structures:ObjectType">
                        <xs:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="refname">
                                    <xsl:value-of select="@ncdfelementname"/>
                                </xsl:variable>
                                <xs:element ref="{$refname}"/>
                            </xsl:for-each>
                            <xs:element ref="{concat(substring(@ncdftype,0,string-length(@ncdftype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
            <xs:element name="{concat(substring(@ncdftype,0,string-length(@ncdftype)-3),'AugmentationPoint')}" abstract="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @ncdftype)"/>
                    </xs:documentation>
                </xs:annotation>
            </xs:element>
            <xs:element name="{@ncdfelementname}" type="{@ncdftype}" nillable="true">
                <xsl:if test="@substitutiongroup">
                    <xsl:attribute name="substitutionGroup">
                        <xsl:value-of select="@substitutiongroup"/>
                    </xsl:attribute>
                </xsl:if>
                <xs:annotation>
                    <xs:documentation>
                        <xsl:choose>
                            <xsl:when test="@ncdfelementname = 'BlankSpace'">
                                <xsl:text>A data item for a blank space character that is used to separate elements within a data chain, or to mark the beginning or end of a unit of data.</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@ncdfelementdoc"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:for-each select="info/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xs:appinfo>
                </xs:annotation>
            </xs:element>
        </xsl:for-each>
        <xsl:copy-of select="$compositefields"/>
    </xsl:variable>
    <xsl:variable name="mtf_composites_xsd">
        <xsl:for-each select="$compositexsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$compositexsd/*:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:choose>
                <xsl:when test="count($setsxsd/*:element[@name = $n and @type = $t]) &gt; 0"/>
                <xsl:when test="count(preceding-sibling::*[@name = $n]) &gt; 0"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_composites_map">
        <xsl:for-each select="$all_composite_elements_map/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:if test="string-length(@ncdftype) &gt; 0 and name() = 'Composite'">
                <xsl:variable name="n" select="@ncdfelementname"/>
                <xsl:variable name="t" select="@ncdftype"/>
                <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$all_composite_elements_map/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:if test="string-length(@ncdftype) &gt; 0 and name() = 'Element'">
                <xsl:variable name="n" select="@ncdfelementname"/>
                <xsl:variable name="t" select="@ncdftype"/>
                <xsl:if test="not(preceding-sibling::*:element/@name = $n)">
                    <xsl:copy-of select="."/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Sets-->
    <xsl:variable name="setfields">
        <!--Add New Elements for Field Groups when more than one child-->
        <xsl:for-each select="$ncdf_sets_map//Sequence[@name = 'GroupOfFields']">
            <xsl:choose>
                <xsl:when test="count(./Element) = 1"/>
                <xsl:otherwise>
                    <xsl:variable name="setname">
                        <xsl:value-of select="ancestor::Set/@ncdfelementname"/>
                    </xsl:variable>
                    <xsl:variable name="setdocname">
                        <xsl:value-of select="lower-case(ancestor::Set/info/inf:Set/@setname)"/>
                    </xsl:variable>
                    <xsl:variable name="setdoc">
                        <xsl:value-of select="ancestor::Set/@ncdftypedoc"/>
                    </xsl:variable>
                    <xsl:variable name="fielddocname">
                        <xsl:value-of select="lower-case(Element[1]/info/inf:Field/@positionName)"/>
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
                                                    <xsl:value-of select="@ncdfelementname"/>
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
                                                            <xsl:value-of select="@ncdfelementdoc"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xs:documentation>
                                                <xsl:for-each select="info/*">
                                                    <xs:appinfo>
                                                        <xsl:copy-of select="." copy-namespaces="no"/>
                                                    </xs:appinfo>
                                                </xsl:for-each>
                                                <xsl:if test="@substgrpname">
                                                    <xs:appinfo>
                                                        <inf:Choice substitutionGroup="{@substgrpname}">
                                                            <xsl:for-each select="Choice/Element">
                                                                <xsl:sort select="@name"/>
                                                                <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                                            </xsl:for-each>
                                                        </inf:Choice>
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
                <xsl:when test="$ncdf_sets_map/Set[@ncdfelementname = $n]"/>
                <xsl:otherwise>
                    <xs:element name="{$n}">
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
                        <xs:annotation>
                            <xs:documentation>
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
                            </xs:documentation>
                            <xsl:for-each select="info/*">
                                <xs:appinfo>
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xs:appinfo>
                            </xsl:for-each>
                            <xsl:if test="@substgrpname">
                                <xs:appinfo>
                                    <inf:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                        </xsl:for-each>
                                    </inf:Choice>
                                </xs:appinfo>
                            </xsl:if>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="ends-with(@mtftype, 'GeneralTextType')">
                <xs:complexType name="{@ncdftype}">
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:value-of select="@ncdfelementdoc"/>
                        </xs:documentation>
                        <xsl:for-each select="info/*">
                            <xs:appinfo>
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xs:appinfo>
                        </xsl:for-each>
                    </xs:annotation>
                    <xs:complexContent>
                        <xs:extension base="SetBaseType">
                            <xs:sequence>
                                <xs:element ref="{concat(@mtfname,'SubjectText')}" minOccurs="1" maxOccurs="1">
                                    <xs:annotation>
                                        <xs:documentation>
                                            <xsl:value-of select="concat('A data item for ', @mtfname, ' Subject Text')"/>
                                        </xs:documentation>
                                    </xs:annotation>
                                </xs:element>
                                <xs:element ref="FreeText" minOccurs="1" maxOccurs="1">
                                    <xs:annotation>
                                        <xs:documentation>A data item for text entry</xs:documentation>
                                        <xs:appinfo>
                                            <inf:Field positionName="FREE TEXT" identifier="A" justification="Left"
                                                definition="AN UNFORMATTED FREE TEXT FIELD CONTAINING AN UNLIMITED NUMBER OF CHARACTERS. USED IN THE FREE TEXT SETS AMPN, GENTEXT, NARR, AND REMARKS."
                                                remark="ANY NUMBER AND TYPE OF CHARACTERS ALLOWED EXCEPT DOUBLE SLANTS (//)." version="1.0" ffirn="1006" fud="1"/>
                                        </xs:appinfo>
                                    </xs:annotation>
                                </xs:element>
                                <xs:element ref="{concat(@mtfname,'GeneralTextSetAugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                            </xs:sequence>
                        </xs:extension>
                    </xs:complexContent>
                </xs:complexType>
                <xs:element name="{concat(@mtfname,'GeneralTextSetAugmentationPoint')}" abstract="true">
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:value-of select="concat('An augmentation point for ', @mtfname, ' General Text Set')"/>
                        </xs:documentation>
                    </xs:annotation>
                </xs:element>
                <xs:element name="{concat(@mtfname,'SubjectText')}" type="SubjectTextType">
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:value-of select="concat('A data item for ', @ncdfelementname, ' Subject Text')"/>
                        </xs:documentation>
                        <xs:appinfo>
                            <inf:Field fixed="{info/*/@textindicator}"/>
                        </xs:appinfo>
                    </xs:annotation>
                </xs:element>
            </xsl:if>
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
                    <xsl:when test="@mtfname = 'OperationCodewordType'">
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
            <xs:complexType name="{@ncdftype}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@ncdftypedoc"/>
                    </xs:documentation>
                    <xsl:for-each select="info/*">
                        <xs:appinfo>
                            <xsl:copy-of select="." copy-namespaces="no"/>
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
                                        </xs:documentation>
                                        <xsl:for-each select="info/*">
                                            <xs:appinfo>
                                                <xsl:copy-of select="." copy-namespaces="no"/>
                                            </xs:appinfo>
                                        </xsl:for-each>
                                        <xsl:if test="@substgrpname">
                                            <xs:appinfo>
                                                <inf:Choice substitutionGroup="{@substgrpname}">
                                                    <xsl:for-each select="Choice/Element">
                                                        <xsl:sort select="@name"/>
                                                        <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                                    </xsl:for-each>
                                                </inf:Choice>
                                            </xs:appinfo>
                                        </xsl:if>
                                    </xs:annotation>
                                </xs:element>
                            </xsl:for-each>
                            <xs:element ref="{concat(substring(@ncdftype,0,string-length(@ncdftype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
            <xs:element name="{concat(substring(@ncdftype,0,string-length(@ncdftype)-3),'AugmentationPoint')}" abstract="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @ncdftype)"/>
                    </xs:documentation>
                </xs:annotation>
            </xs:element>
            <xsl:choose>
                <xsl:when test="@ncdfelementname = 'SetBase'"/>
                <xsl:otherwise>
                    <xs:element name="{@ncdfelementname}" type="{@ncdftype}" nillable="true">
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@ncdfelementdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xs:documentation>
                            <xsl:choose>
                                <xsl:when test="@substgrpname">
                                    <xs:appinfo>
                                        <inf:Choice substitutionGroup="{@substgrpname}">
                                            <xsl:for-each select="Choice/Element">
                                                <xsl:sort select="@name"/>
                                                <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                            </xsl:for-each>
                                        </inf:Choice>
                                    </xs:appinfo>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xs:appinfo>
                                        <xsl:for-each select="info/*">
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xsl:for-each>
                                    </xs:appinfo>
                                </xsl:otherwise>
                            </xsl:choose>
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
        <xsl:for-each select="$all_set_elements_map//Element[@ncdfelementname][Choice]">
            <xsl:variable name="substgrp" select="Choice/@substgrpname"/>
            <xsl:variable name="substgrpdoc" select="Choice/@substgrpdoc"/>
            <xsl:variable name="setname" select="@setname"/>
            <xsl:variable name="n" select="@ncdfelementname"/>
            <xs:complexType name="{concat(@ncdfelementname,'ChoiceType')}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="$substgrpdoc"/>
                    </xs:documentation>
                    <xsl:for-each select="info/*">
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
                                        <inf:Choice substitutionGroup="{Choice/@substgrpname}">
                                            <xsl:for-each select="Choice/Element">
                                                <xsl:sort select="@ncdfelementname"/>
                                                <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                            </xsl:for-each>
                                        </inf:Choice>
                                    </xs:appinfo>
                                </xs:annotation>
                            </xs:element>
                            <xs:element ref="{concat(@ncdfelementname,'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
            <xs:element name="{@ncdfelementname}" type="{concat(@ncdfelementname,'ChoiceType')}" nillable="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@ncdfelementdoc"/>
                    </xs:documentation>
                    <xsl:choose>
                        <xsl:when test="Choice/@substgrpname">
                            <xs:appinfo>
                                <inf:Choice substitutionGroup="{Choice/@substgrpname}">
                                    <xsl:for-each select="Choice/Element">
                                        <xsl:sort select="@name"/>
                                        <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                    </xsl:for-each>
                                </inf:Choice>
                            </xs:appinfo>
                        </xsl:when>
                    </xsl:choose>
                </xs:annotation>
            </xs:element>
            <xs:element name="{concat(@ncdfelementname,'AugmentationPoint')}" abstract="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', concat(@ncdfelementname, 'Type'))"/>
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
                                <inf:Choice substitutionGroup="{Choice/@substgrpname}">
                                    <xsl:for-each select="Choice/Element">
                                        <xsl:sort select="@ncdfelementname"/>
                                        <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                    </xsl:for-each>
                                </inf:Choice>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
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
                <xsl:when test="count($mtf_fields_xsd/*:element[@name = $n]) &gt; 0"/>
                <xsl:when test="count($mtf_composites_xsd/*:element[@name = $n]) &gt; 0"/>
                <xsl:when test="count(preceding-sibling::*:element[@name = $n][@type = $t]) &gt; 0"/>
                <xsl:when test="count(preceding-sibling::*:element[@name = $n][ends-with(@name, 'Abstract') or ends-with(@name, 'AugmentationPoint')]) &gt; 0"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_sets_map">
        <xsl:for-each select="$ncdf_sets_map/*">
            <xsl:sort select="@mtfname"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Segments-->
    <xsl:variable name="segmentelements">
        <xsl:for-each select="$ncdf_segments_map//Sequence/Element">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:variable name="n" select="@ncdfelementname"/>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map/*[@substgrpname = $n]"/>
                <xsl:when test="$all_set_elements_map/*[@ncdfelementname = $n]"/>
                <xsl:when test="$ncdf_segments_map/Segment[@ncdfelementname = $n]"/>
                <xsl:when test="starts-with(Choice/Element[1]/@mtftype, 's:')"/>
                <xsl:otherwise>
                    <xsl:variable name="t" select="@ncdftype"/>
                    <xsl:variable name="d" select="@ncdfelementdoc"/>
                    <xsl:variable name="segSeq">
                        <xsl:value-of select="ancestor::Segment/@segseq"/>
                    </xsl:variable>
                    <xs:element name="{@ncdfelementname}">
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
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:choose>
                                    <xsl:when test="@ncdftype = 'GeneralTextType'">
                                        <xsl:value-of select="@ncdfelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="@ncdftype = 'HeadingInformationType'">
                                        <xsl:value-of select="@ncdfelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="@ncdftypedoc">
                                        <xsl:value-of select="@ncdftypedoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@ncdfelementdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xs:documentation>
                            <xsl:for-each select="info/*">
                                <xs:appinfo>
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xs:appinfo>
                            </xsl:for-each>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="ends-with(@mtftype, 'GeneralTextType')">
                <xs:complexType name="{@ncdftype}">
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:value-of select="@ncdfelementdoc"/>
                        </xs:documentation>
                        <xsl:for-each select="info/*">
                            <xs:appinfo>
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xs:appinfo>
                        </xsl:for-each>
                    </xs:annotation>
                    <xs:complexContent>
                        <xs:extension base="SetBaseType">
                            <xs:sequence>
                                <xs:element ref="{concat(@mtfname,'SubjectText')}" minOccurs="1" maxOccurs="1">
                                    <xs:annotation>
                                        <xs:documentation>
                                            <xsl:value-of select="concat('A data item for ', @ncdfelementname, ' Subject Text')"/>
                                        </xs:documentation>
                                    </xs:annotation>
                                </xs:element>
                                <xs:element ref="FreeText" minOccurs="1" maxOccurs="1">
                                    <xs:annotation>
                                        <xs:documentation>A data item for text entry</xs:documentation>
                                        <xs:appinfo>
                                            <inf:Field positionName="FREE TEXT" identifier="A" justification="Left"
                                                definition="AN UNFORMATTED FREE TEXT FIELD CONTAINING AN UNLIMITED NUMBER OF CHARACTERS. USED IN THE FREE TEXT SETS AMPN, GENTEXT, NARR, AND REMARKS."
                                                remark="ANY NUMBER AND TYPE OF CHARACTERS ALLOWED EXCEPT DOUBLE SLANTS (//)." version="1.0" ffirn="1006" fud="1"/>
                                        </xs:appinfo>
                                    </xs:annotation>
                                </xs:element>
                                <xs:element ref="GeneralTextSetAugmentationPoint" minOccurs="0" maxOccurs="unbounded"/>
                            </xs:sequence>
                        </xs:extension>
                    </xs:complexContent>
                </xs:complexType>
                <xs:element name="{concat(@mtfname,'SubjectText')}" type="SubjectTextType">
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:value-of select="concat('A data item for ', @mtfname, ' Subject Text')"/>
                        </xs:documentation>
                        <xs:appinfo>
                            <inf:Field fixed="{@positionname}"/>
                        </xs:appinfo>
                    </xs:annotation>
                </xs:element>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$ncdf_segments_map//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map/*[@substgrpname = $substgrp]"/>
                <xsl:when test="starts-with(Choice/Element[1]/@mtftype, 's:')"/>
                <xsl:otherwise>
                    <xs:element name="{@substgrpname}" abstract="true">
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <inf:Choice>
                                    <xsl:for-each select="Choice/Element">
                                        <xsl:sort select="@ncdfelementname"/>
                                        <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                    </xsl:for-each>
                                </inf:Choice>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="Choice/Element">
                <xsl:sort select="@ncdfelementname"/>
                <xsl:variable name="nn" select="@ncdfelementname"/>
                <xsl:choose>
                    <xsl:when test="$all_set_elements_map/Element[@ncdfelementname = $nn]"/>
                    <xsl:otherwise>
                        <xsl:variable name="ncdfelementdoc">
                            <xsl:choose>
                                <xsl:when test="string-length(@ncdfelementdoc) &gt; 0">
                                    <xsl:value-of select="@ncdfelementdoc"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@mtfdoc"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xs:element name="{@ncdfelementname}">
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
                            <xs:annotation>
                                <xs:documentation>
                                    <xsl:value-of select="@ncdfelementdoc"/>
                                </xs:documentation>
                            </xs:annotation>
                        </xs:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="$all_segment_elements_map/*">
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
                <xsl:when test="$all_set_elements_map/*[@ncdfelementname = $n]"/>
                <xsl:when test="starts-with(@mtftype, 's:')"/>
                <xsl:otherwise>
                    <xs:element name="{$n}">
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
                        <xs:annotation>
                            <xs:documentation>
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
                                    <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                        <xsl:value-of select="@mtfdoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="breakIntoWords">
                                            <xsl:with-param name="string" select="@ncdfelementname"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xs:documentation>
                            <xsl:for-each select="info/*">
                                <xs:appinfo>
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xs:appinfo>
                            </xsl:for-each>
                            <xsl:if test="@substgrpname">
                                <xs:appinfo>
                                    <inf:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                        </xsl:for-each>
                                    </inf:Choice>
                                </xs:appinfo>
                            </xsl:if>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="segmentsxsd">
        <xsl:for-each select="$ncdf_segments_map/Segment">
            <xsl:sort select="@ncdftype"/>
            <xs:complexType name="{@ncdftype}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@ncdftypedoc"/>
                    </xs:documentation>
                </xs:annotation>
                <xs:complexContent>
                    <xs:extension base="structures:ObjectType">
                        <xs:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="n" select="@ncdfelementname"/>
                                <xsl:variable name="refname">
                                    <xsl:choose>
                                        <xsl:when test="@substgrpname">
                                            <xsl:value-of select="@substgrpname"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$n"/>
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
                                                <xsl:when test="string-length(Choice/@substgrpdoc) &gt; 0">
                                                    <xsl:value-of select="Choice/@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                                    <xsl:value-of select="replace(@mtfdoc, 'A data type', 'A data item')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@ncdfelementdoc"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xs:documentation>
                                        <xsl:for-each select="info/*">
                                            <xs:appinfo>
                                                <xsl:copy-of select="." copy-namespaces="no"/>
                                            </xs:appinfo>
                                        </xsl:for-each>
                                        <xsl:if test="@substgrpname">
                                            <xs:appinfo>
                                                <inf:Choice substitutionGroup="{@substgrpname}">
                                                    <xsl:for-each select="Choice/Element">
                                                        <xsl:sort select="@name"/>
                                                        <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                                    </xsl:for-each>
                                                </inf:Choice>
                                            </xs:appinfo>
                                        </xsl:if>
                                    </xs:annotation>
                                </xs:element>
                            </xsl:for-each>
                            <xs:element ref="{concat(substring(@ncdftype,0,string-length(@ncdftype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
            <xs:element name="{concat(substring(@ncdftype,0,string-length(@ncdftype)-3),'AugmentationPoint')}" abstract="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @ncdftype)"/>
                    </xs:documentation>
                </xs:annotation>
            </xs:element>
            <xs:element name="{@ncdfelementname}" type="{@ncdftype}" nillable="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@ncdfelementdoc"/>
                    </xs:documentation>
                    <xsl:for-each select="info/*">
                        <xs:appinfo>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xs:appinfo>
                    </xsl:for-each>
                </xs:annotation>
            </xs:element>
        </xsl:for-each>
        <!--Global Set Elements-->
        <xsl:copy-of select="$segmentelements"/>
    </xsl:variable>
    <xsl:variable name="mtf_segments_xsd">
        <xsl:for-each select="$segmentsxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:choose>
                <xsl:when test="$setsxsd/*:complexType[@name = $n]"/>
                <xsl:when test="count(preceding-sibling::*:complexType[@name = $n]) &gt; 0"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$segmentsxsd/*:element[@name]">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:choose>
                <xsl:when test="$setsxsd/*:element[@name = $n]"/>
                <xsl:when test="string-length(@type) = 0 and not(@abstract)"/>
                <xsl:when test="not(@type) and not(@abstract)"/>
                <xsl:when test="count(preceding-sibling::*:element[@name = $n and @type = $t]) &gt; 0"/>
                <xsl:when test="count(preceding-sibling::*:element[@name = $n][ends-with(@name, 'Abstract') or ends-with(@name, 'AugmentationPoint')]) &gt; 0"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_segments_map">
        <xsl:for-each select="$ncdf_segments_map/*">
            <xsl:sort select="@mtfname"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Messages-->
    <xsl:variable name="messagelements">
        <xsl:for-each select="$ncdf_messages_map//Sequence/Element">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:variable name="n" select="@ncdfelementname"/>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map//*[@ncdfelementname = $n]"/>
                <xsl:when test="$all_segment_elements_map//*[@ncdfelementname = $n]"/>
                <xsl:otherwise>
                    <xsl:variable name="n" select="@ncdfelementname"/>
                    <xsl:variable name="segSeq">
                        <xsl:value-of select="ancestor::Segment/@segseq"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="@ncdfelementname">
                            <xs:element name="{@ncdfelementname}">
                                <xsl:attribute name="type">
                                    <xsl:value-of select="@ncdftype"/>
                                </xsl:attribute>
                                <xsl:attribute name="nillable">
                                    <xsl:text>true</xsl:text>
                                </xsl:attribute>
                                <xs:annotation>
                                    <xs:documentation>
                                        <xsl:choose>
                                            <xsl:when test="@ncdftypedoc">
                                                <xsl:value-of select="replace(@ncdftypedoc, 'A data type', 'A data item')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="@ncdfelementdoc"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xs:documentation>
                                    <xsl:for-each select="info/*">
                                        <xs:appinfo>
                                            <xsl:copy-of select="." copy-namespaces="no"/>
                                        </xs:appinfo>
                                    </xsl:for-each>
                                </xs:annotation>
                            </xs:element>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$ncdf_messages_map//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map//*[@substgrpname = $substgrp]"/>
                <xsl:when test="$all_segment_elements_map//*[@substgrpname = $substgrp]"/>
                <xsl:when test="@substgrpname">
                    <xs:element name="{@substgrpname}" abstract="true">
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <inf:Choice>
                                    <xsl:for-each select="Choice/Element">
                                        <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                    </xsl:for-each>
                                </inf:Choice>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                    <xsl:for-each select="Choice/Element">
                        <xsl:variable name="n" select="@ncdfelementname"/>
                        <xs:element name="{@ncdfelementname}" type="{@ncdftype}" substitutionGroup="{$substgrp}" nillable="true">
                            <xs:annotation>
                                <xs:documentation>
                                    <xsl:choose>
                                        <xsl:when test="@ncdftypedoc">
                                            <xsl:value-of select="@ncdftypedoc"/>
                                        </xsl:when>
                                        <xsl:when test="@ncdfelementdoc">
                                            <xsl:value-of select="@ncdfelementdoc"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xs:documentation>
                            </xs:annotation>
                        </xs:element>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="messagesxsd">
        <xsl:for-each select="$ncdf_messages_map/Message">
            <xsl:sort select="@ncdftype"/>
            <xs:complexType name="{@ncdftype}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@ncdftypedoc"/>
                    </xs:documentation>
                    <xsl:for-each select="info/*">
                        <xs:appinfo>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xs:appinfo>
                    </xsl:for-each>
                </xs:annotation>
                <xs:complexContent>
                    <xs:extension base="structures:ObjectType">
                        <xs:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="n" select="@ncdfelementname"/>
                                <!--<xsl:variable name="p" select="substring-before(@mtftype, ':')"/>-->
                                <xsl:variable name="refname">
                                    <xsl:choose>
                                        <xsl:when test="@substgrpname">
                                            <xsl:value-of select="@substgrpname"/>
                                        </xsl:when>
                                        <xsl:when test="$messagelements/*[@name = $n]">
                                            <xsl:value-of select="$n"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$n"/>
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
                                                <xsl:when test="string-length(@ncdfelementdoc) &gt; 0">
                                                    <xsl:value-of select="@ncdfelementdoc"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@ncdftypedoc"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xs:documentation>
                                        <xsl:for-each select="info/*">
                                            <xs:appinfo>
                                                <xsl:copy-of select="." copy-namespaces="no"/>
                                            </xs:appinfo>
                                        </xsl:for-each>
                                        <xsl:if test="@substgrpname">
                                            <xs:appinfo>
                                                <inf:Choice substitutionGroup="{@substgrpname}">
                                                    <xsl:for-each select="Choice/Element">
                                                        <xsl:sort select="@name"/>
                                                        <inf:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                                    </xsl:for-each>
                                                </inf:Choice>
                                            </xs:appinfo>
                                        </xsl:if>
                                    </xs:annotation>
                                </xs:element>
                            </xsl:for-each>
                            <xs:element ref="{concat(substring(@ncdftype,0,string-length(@ncdftype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
            <xs:element name="{concat(substring(@ncdftype,0,string-length(@ncdftype)-3),'AugmentationPoint')}" abstract="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @ncdftype)"/>
                    </xs:documentation>
                </xs:annotation>
            </xs:element>
            <xs:element name="{@ncdfelementname}" type="{@ncdftype}" nillable="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@ncdfelementdoc"/>
                    </xs:documentation>
                    <xsl:for-each select="info/*">
                        <xs:appinfo>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xs:appinfo>
                    </xsl:for-each>
                </xs:annotation>
            </xs:element>
        </xsl:for-each>
        <!--Global Elements-->
        <xsl:copy-of select="$messagelements"/>
    </xsl:variable>
    <xsl:variable name="mtf_messages_xsd">
        <xsl:for-each select="$messagesxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:choose>
                <xsl:when test="count(preceding-sibling::*:complexType[@name=$n])&gt;0"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$messagesxsd/*:element">
            <xsl:sort select="@name"/>
            <xsl:sort select="@type"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:choose>
                <xsl:when test="$segmentsxsd/*:element[@name = $n]"/>
                <xsl:when test="count(preceding-sibling::*:element[@name=$n][@type=$t])&gt;0"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_messages_map">
        <xsl:for-each select="$ncdf_messages_map/*">
            <xsl:sort select="@mtfname"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Consolidated-->
    <xsl:variable name="ALLMTF">
        <xsl:copy-of select="$mtf_fields_xsd"/>
        <xsl:copy-of select="$mtf_composites_xsd"/>
        <xsl:copy-of select="$mtf_sets_xsd"/>
        <xsl:copy-of select="$mtf_segments_xsd"/>
        <xsl:copy-of select="$mtf_messages_xsd"/>
    </xsl:variable>

    <xsl:variable name="ref-xsd-template">
        <xs:schema xmlns="urn:int:nato:ncdf:mtf" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/" xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
            xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/" xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo"
            xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:int:nato:ncdf:mtf"
            ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
            attributeFormDefault="unqualified" version="1.0">
            <xs:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="ncdf/utility/structures/4.0/structures.xsd"/>
            <xs:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="ncdf/localTerminology.xsd"/>
            <xs:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="ncdf/utility/appinfo/4.0/appinfo.xsd"/>
            <xs:import namespace="urn:int:nato:ncdf:mtf:appinfo" schemaLocation="ncdf/mtfappinfo.xsd"/>
        </xs:schema>
    </xsl:variable>

    <xsl:template name="main">
        <!--Schema-->
        <xsl:result-document href="{$dirpath}/NCDF_MTF_Fields.xsd">
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xs:include schemaLocation="NCDF_MTF_Sets.xsd"/>
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:text>Fields for MTF Messages</xsl:text>
                        </xs:documentation>
                    </xs:annotation>
                    <xsl:copy-of select="$mtf_fields_xsd" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/NCDF_MTF_Composites.xsd">
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xs:include schemaLocation="NCDF_MTF_Fields.xsd"/>
                    <xs:include schemaLocation="NCDF_MTF_Sets.xsd"/>
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:text>Composite fields for MTF Composite Fields</xsl:text>
                        </xs:documentation>
                    </xs:annotation>
                    <xsl:copy-of select="$mtf_composites_xsd" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/NCDF_MTF_Sets.xsd">
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xs:include schemaLocation="NCDF_MTF_Fields.xsd"/>
                    <xs:include schemaLocation="NCDF_MTF_Composites.xsd"/>
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:text>Set structures for MTF Messages</xsl:text>
                        </xs:documentation>
                    </xs:annotation>
                    <xsl:copy-of select="$mtf_sets_xsd" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/NCDF_MTF_Segments.xsd">
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xs:include schemaLocation="NCDF_MTF_Sets.xsd"/>
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:text>Segment structures for MTF Segments</xsl:text>
                        </xs:documentation>
                    </xs:annotation>
                    <xsl:copy-of select="$mtf_segments_xsd" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/NCDF_MTF_Messages.xsd">
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xs:include schemaLocation="NCDF_MTF_Sets.xsd"/>
                    <xs:include schemaLocation="NCDF_MTF_Segments.xsd"/>
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:text>Message structures for MTF Messages</xsl:text>
                        </xs:documentation>
                    </xs:annotation>
                    <xsl:copy-of select="$mtf_messages_xsd"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/NCDF_MTF.xsd">
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:text>UNIFIED MTF MESSAGE SCHEMA</xsl:text>
                        </xs:documentation>
                    </xs:annotation>
                    <xsl:for-each select="$ALLMTF/*:complexType">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:for-each select="$ALLMTF/*:simpleType">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:for-each select="$ALLMTF/*:element">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <!--Maps-->
        <xsl:result-document href="{$dirpath}/Maps/NCDF_MTF_Fieldmaps.xml">
            <Fields>
                <xsl:copy-of select="$mtf_fields_map"/>
            </Fields>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/Maps/NCDF_MTF_Compositemaps.xml">
            <Composites>
                <xsl:copy-of select="$mtf_composites_map" copy-namespaces="no"/>
            </Composites>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/Maps/NCDF_MTF_Setmaps.xml">
            <Sets>
                <xsl:copy-of select="$mtf_sets_map"/>
            </Sets>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/Maps/NCDF_MTF_Segmntmaps.xml">
            <Segments>
                <xsl:copy-of select="$mtf_segments_map" copy-namespaces="no"/>
            </Segments>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/Maps/NCDF_MTF_Msgsmaps.xml">
            <Messages>
                <xsl:copy-of select="$mtf_messages_map"/>
            </Messages>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/Maps/NCDF_MTF_AllMaps.xml">
            <MTF>
                <xsl:copy-of select="$mtf_messages_map" copy-namespaces="no"/>
                <xsl:copy-of select="$mtf_segments_map" copy-namespaces="no"/>
                <xsl:copy-of select="$mtf_sets_map" copy-namespaces="no"/>
                <xsl:copy-of select="$mtf_composites_map" copy-namespaces="no"/>
                <xsl:copy-of select="$mtf_fields_map" copy-namespaces="no"/>
            </MTF>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*" mode="identity">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="identity"/>
            <xsl:apply-templates select="text()" mode="identity"/>
            <xsl:apply-templates select="*" mode="identity"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="identity">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

    <xsl:template match="text()" mode="identity">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

</xsl:stylesheet>
