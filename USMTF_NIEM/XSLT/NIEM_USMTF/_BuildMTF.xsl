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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:inf="urn:mtf:mil:6040b:appinfo" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:include href="NiemMap.xsl"/>

    <xsl:include href="_SubsetSchema.xsl"/>

    <xsl:variable name="dirpath" select="concat($srcdir, 'NIEM_MTF/')"/>
    <xsl:variable name="subsetoutdir" select="concat($dirpath, 'subsetxsd/')"/>
    <xsl:variable name="iepdoutdir" select="concat($dirpath, 'iepdxsd/')"/>

    <xsl:variable name="structRel"
        select="document(concat($srcdir, 'NIEM_MTF/schematron/usmtf-structural-relationships.sch'))/*"/>

    <!-- _______________________________________________________ -->

    <!--Fields-->
    <xsl:variable name="fieldsxsd">
        <xsl:for-each select="$stringsxsd/*:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$stringsxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$numericsxsd/*:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$numericsxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$codelistxsd/*:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$codelistxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$all_field_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="DodDist">
                <xsl:choose>
                    <xsl:when test="info/*[1]/@doddist">
                        <xsl:value-of select="info/*[1]/@doddist"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DoD-Dist-A</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="ends-with(@niemelementname, 'AlternativeContent')">
                    <xsl:variable name="n" select="@niemelementname"/>
                    <xsl:variable name="t" select="@niemtype"/>
                    <xsl:if
                        test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                        <xs:element name="{@niemelementname}">
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
                            <xsl:attribute name="nillable">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                            <xs:annotation>
                                <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                    ism:noticeType="{$DodDist}">
                                    <xsl:value-of select="@niemelementdoc"/>
                                </xs:documentation>
                                <xs:appinfo>
                                    <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                                </xs:appinfo>
                            </xs:annotation>
                        </xs:element>
                        <xs:complexType name="{@niemtype}">
                            <xs:annotation>
                                <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                    ism:noticeType="{$DodDist}">A data type for alternative
                                    content.</xs:documentation>
                            </xs:annotation>
                            <xs:complexContent>
                                <xs:extension base="structures:ObjectType">
                                    <xs:sequence>
                                        <xs:element ref="{Choice/@substgrpname}">
                                            <xsl:copy-of select="@minOccurs"/>
                                            <xsl:copy-of select="@minOccurs"/>
                                            <xs:annotation>
                                                <xs:documentation ism:classification="U"
                                                  ism:ownerProducer="USA"
                                                  ism:noticeType="DoD-Dist-A">
                                                  <xsl:value-of select="Choice/@substgrpdoc"/>
                                                </xs:documentation>
                                                <xs:appinfo>
                                                  <xsl:apply-templates select="info/*[1]"
                                                  mode="refinfo"/>
                                                  <inf:Choice
                                                  substitutionGroup="{Choice/@substgrpname}">
                                                  <xsl:for-each select="Choice/Element">
                                                  <xsl:sort select="@niemelementname"/>
                                                  <inf:Element name="{@niemelementname}"
                                                  type="{@niemtype}"/>
                                                  </xsl:for-each>
                                                  </inf:Choice>
                                                </xs:appinfo>
                                            </xs:annotation>
                                        </xs:element>
                                        <xs:element
                                            ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                                            minOccurs="0" maxOccurs="unbounded"/>
                                    </xs:sequence>
                                </xs:extension>
                            </xs:complexContent>
                        </xs:complexType>
                        <xs:element
                            name="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                            abstract="true">
                            <xs:annotation>
                                <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                    ism:noticeType="{$DodDist}">
                                    <xsl:value-of
                                        select="concat('An augmentation point for ', @niemtype)"/>
                                </xs:documentation>
                            </xs:annotation>
                        </xs:element>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="@niemtype">
                    <xsl:variable name="n" select="@niemelementname"/>
                    <xsl:variable name="t" select="@niemtype"/>
                    <xsl:if
                        test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                        <xs:complexType name="{@niemtype}">
                            <xs:annotation>
                                <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                    ism:noticeType="{$DodDist}">A data type for alternative
                                    content.</xs:documentation>
                            </xs:annotation>
                            <xs:complexContent>
                                <xs:extension base="structures:ObjectType">
                                    <xs:sequence>
                                        <xs:element ref="{Choice/@substgrpname}">
                                            <xsl:copy-of select="@minOccurs"/>
                                            <xsl:copy-of select="@minOccurs"/>
                                            <xs:annotation>
                                                <xs:documentation ism:classification="U"
                                                  ism:ownerProducer="USA"
                                                  ism:noticeType="DoD-Dist-A">
                                                  <xsl:value-of select="Choice/@substgrpdoc"/>
                                                </xs:documentation>
                                                <xs:appinfo>
                                                  <xsl:apply-templates select="info/*[1]"
                                                  mode="refinfo"/>
                                                  <inf:Choice
                                                  substitutionGroup="{Choice/@substgrpname}">
                                                  <xsl:for-each select="Choice/Element">
                                                  <xsl:sort select="@niemelementname"/>
                                                  <inf:Element name="{@niemelementname}"
                                                  type="{@niemtype}"/>
                                                  </xsl:for-each>
                                                  </inf:Choice>
                                                </xs:appinfo>
                                            </xs:annotation>
                                        </xs:element>
                                        <xs:element
                                            ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                                            minOccurs="0" maxOccurs="unbounded"/>
                                    </xs:sequence>
                                </xs:extension>
                            </xs:complexContent>
                        </xs:complexType>
                        <xs:element name="{@niemelementname}" type="{@niemtype}">
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
                            <xsl:attribute name="nillable">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                            <xs:annotation>
                                <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                    ism:noticeType="{$DodDist}">
                                    <xsl:value-of select="@niemelementdoc"/>
                                </xs:documentation>
                                <xs:appinfo>
                                    <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
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
                            <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                ism:noticeType="{$DodDist}">
                                <xsl:value-of select="@substgrpdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                                <inf:Choice substitutionGroup="{@substgrpname}">
                                    <xsl:for-each select="Element">
                                        <xsl:sort select="@niemelementname"/>
                                        <inf:Element name="{@niemelementname}" type="{@niemtype}"/>
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
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="count(preceding-sibling::*:complexType[@name = $n]) = 0">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/*:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="s" select="@substitutionGroup"/>
            <xsl:choose>
                <xsl:when
                    test="@substitutionGroup and count(preceding-sibling::*:element[@name = $n][@substitutionGroup = $s]) = 0">
                    <xsl:copy-of select="."/>
                </xsl:when>
                <xsl:when test="count(preceding-sibling::*:element[@name = $n]) = 0">
                    <xsl:copy-of select="."/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_fields_map">
        <xsl:for-each select="$all_field_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Element'">
                <xsl:variable name="n" select="@niemelementname"/>
                <xsl:variable name="t" select="@niemtype"/>
                <xsl:if
                    test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Composites-->
    <xsl:variable name="elementsxsd">
        <xsl:for-each select="$all_composite_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="m" select="@mtfname"/>
            <xsl:variable name="mt" select="@mtftype"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsl:variable name="t">
                <xsl:value-of select="@niemtype"/>
            </xsl:variable>
            <xsl:variable name="s" select="@substgrpname"/>
            <xsl:variable name="DodDist">
                <xsl:choose>
                    <xsl:when test="info/*[1]/@doddist">
                        <xsl:value-of select="info/*[1]/@doddist"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DoD-Dist-A</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$niem_fields_map//*[@mtfname = $m][@mtftype = $mt]"/>
                <xsl:when test="$niem_fields_map//*[@niemelementname = $n]"/>
                <!--<xsl:when test="$all_field_elements_map//*[@niemelementname = $n]"/>-->
                <xsl:when test="@substgrpname and $all_field_elements_map//*[@substgrpname = $s]"/>
                <xsl:when test="name() = 'Choice'"/>
                <xsl:otherwise>
                    <xs:element name="{@niemelementname}" type="{$t}" nillable="true">
                        <xsl:if test="@substitutiongroup">
                            <xsl:attribute name="substitutionGroup">
                                <xsl:value-of select="@substitutiongroup"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xs:annotation>
                            <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                ism:noticeType="{$DodDist}">
                                <xsl:value-of select="@niemelementdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="compositefields">
        <xsl:for-each select="$niem_composites_map//Sequence/Element[starts-with(@mtftype, 'c:')]">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsl:variable name="DodDist">
                <xsl:choose>
                    <xsl:when test="info/*[1]/@doddist">
                        <xsl:value-of select="info/*[1]/@doddist"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DoD-Dist-A</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xs:element name="{@niemelementname}">
                <xsl:attribute name="type">
                    <xsl:value-of select="@niemelementtype"/>
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
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                        ism:noticeType="{$DodDist}">
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
                    <xs:appinfo>
                        <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                    </xs:appinfo>
                </xs:annotation>
            </xs:element>
        </xsl:for-each>
        <xsl:for-each select="$elementsxsd/*">
            <xsl:variable name="n" select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="compositexsd">
        <xsl:for-each select="$niem_composites_map/Composite">
            <xsl:sort select="@niemtype"/>
            <xsl:variable name="DodDist">
                <xsl:choose>
                    <xsl:when test="info/*[1]/@doddist">
                        <xsl:value-of select="info/*[1]/@doddist"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DoD-Dist-A</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xs:complexType name="{@niemtype}">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                        ism:noticeType="{$DodDist}">
                        <xsl:value-of select="@niemtypedoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                    </xs:appinfo>
                </xs:annotation>
                <xs:complexContent>
                    <xs:extension base="structures:ObjectType">
                        <xs:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="refname">
                                    <xsl:value-of select="@niemelementname"/>
                                </xsl:variable>
                                <xsl:variable name="ntyp">
                                    <xsl:value-of select="@niemtype"/>
                                </xsl:variable>
                                <xs:element ref="{$refname}">
                                    <xs:annotation>
                                        <xs:documentation>
                                            <xsl:value-of select="@niemelementdoc"/>
                                        </xs:documentation>
                                        <xs:appinfo>
                                            <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                                        </xs:appinfo>
                                    </xs:annotation>
                                </xs:element>
                            </xsl:for-each>
                            <xs:element
                                ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                                minOccurs="0" maxOccurs="unbounded"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
            <xs:element
                name="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                abstract="true">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                        ism:noticeType="{$DodDist}">
                        <xsl:value-of select="concat('An augmentation point for ', @niemtype)"/>
                    </xs:documentation>
                </xs:annotation>
            </xs:element>
            <xs:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                <xsl:if test="@substitutiongroup">
                    <xsl:attribute name="substitutionGroup">
                        <xsl:value-of select="@substitutiongroup"/>
                    </xsl:attribute>
                </xsl:if>
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                        ism:noticeType="{$DodDist}">
                        <xsl:choose>
                            <xsl:when test="@niemelementname = 'BlankSpace'">
                                <xsl:text>A data item for a blank space character that is used to separate elements within a data chain, or to mark the beginning or end of a unit of data.</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@niemelementdoc"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
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
            <xsl:if test="not(preceding-sibling::*:element/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_composites_map">
        <xsl:for-each select="$all_composite_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Composite'">
                <xsl:variable name="n" select="@niemelementname"/>
                <xsl:variable name="t" select="@niemtype"/>
                <xsl:if
                    test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <!--  <xsl:for-each select="$all_composite_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Element'">
                <xsl:variable name="n" select="@niemelementname"/>
                <xsl:variable name="t" select="@niemtype"/>
                <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>-->
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Sets-->
    <xsl:variable name="setfields">
        <!--Add New Elements for Field Groups when more than one child-->
        <xsl:for-each select="$niem_sets_map//Sequence[@name = 'GroupOfFields']">
            <xsl:choose>
                <xsl:when test="count(./Element) = 1"/>
                <xsl:otherwise>
                    <xsl:variable name="setname">
                        <xsl:value-of select="ancestor::Set/@niemelementname"/>
                    </xsl:variable>
                    <xsl:variable name="setdocname">
                        <xsl:value-of select="lower-case(ancestor::Set/info/inf:Set/@setname)"/>
                    </xsl:variable>
                    <xsl:variable name="setdoc">
                        <xsl:value-of select="ancestor::Set/@niemtypedoc"/>
                    </xsl:variable>
                    <xsl:variable name="fielddocname">
                        <xsl:value-of select="lower-case(Element[1]/info/inf:Field/@positionName)"/>
                    </xsl:variable>
                    <xsl:variable name="fgname">
                        <xsl:choose>
                            <xsl:when
                                test="exists(Element[1]/@niemelementname) and count(Element) = 1">
                                <xsl:value-of
                                    select="concat(Element[1]/@niemelementname, 'FieldGroup')"/>
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
                                <xsl:value-of
                                    select="concat('A data type for ', $fielddocname, ' field group')"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="concat('A data type for ', $setdocname, ' field group')"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="datadefdoc">
                        <xsl:choose>
                            <xsl:when test="starts-with($doc, 'A data type')">
                                <xsl:value-of select="$doc"/>
                            </xsl:when>
                            <xsl:when test="starts-with($doc, 'A ')">
                                <xsl:value-of select="concat('A ', substring(lower-case($doc), 1))"
                                />
                            </xsl:when>
                            <xsl:when test="starts-with($doc, 'An ')">
                                <xsl:value-of select="concat('A ', substring(lower-case($doc), 1))"
                                />
                            </xsl:when>
                            <xsl:when test="contains('AEIOU', substring($doc, 0, 1))">
                                <xsl:value-of select="concat('An ', lower-case($doc))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('A ', lower-case($doc))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="DodDist">
                        <xsl:choose>
                            <xsl:when test="info/*[1]/@doddist">
                                <xsl:value-of select="info/*[1]/@doddist"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>DoD-Dist-A</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xs:element name="{$fgname}" type="{concat($fgname,'Type')}" nillable="true">
                        <!--<xsl:copy-of select="@minOccurs"/>
                        <xsl:copy-of select="@maxOccurs"/>-->
                        <xs:annotation>
                            <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                ism:noticeType="{$DodDist}">
                                <xsl:value-of select="replace($datadefdoc, 'type', 'item')"/>
                            </xs:documentation>
                        </xs:annotation>
                    </xs:element>
                    <xs:complexType name="{concat($fgname,'Type')}">
                        <xs:annotation>
                            <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                ism:noticeType="{$DodDist}">
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
                                        <xsl:variable name="ntyp" select="@niemtype"/>
                                        <xs:element ref="{$refname}">
                                            <xsl:copy-of select="@minOccurs"/>
                                            <xsl:copy-of select="@maxOccurs"/>
                                            <xs:annotation>
                                                <!--<xs:documentation ism:classification="U" ism:ownerProducer="USA" ism:noticeType="{info/*/@doddist}">-->
                                                <xs:documentation>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="string-length(@substgrpdoc) &gt; 0">
                                                  <xsl:value-of select="@substgrpdoc"/>
                                                  </xsl:when>
                                                  <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                                  <xsl:value-of
                                                  select="replace(@mtfdoc, 'A data type', 'A data item')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="@niemelementdoc"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xs:documentation>
                                                <xs:appinfo>
                                                  <xsl:apply-templates select="info/*[1]"
                                                  mode="refinfo"/>
                                                  <xsl:if test="@substgrpname">
                                                  <inf:Choice substitutionGroup="{@substgrpname}">
                                                  <xsl:for-each select="Choice/Element">
                                                  <xsl:sort select="@name"/>
                                                  <inf:Element name="{@niemelementname}"
                                                  type="{@niemtype}"/>
                                                  </xsl:for-each>
                                                  </inf:Choice>
                                                  </xsl:if>
                                                </xs:appinfo>
                                            </xs:annotation>
                                        </xs:element>
                                    </xsl:for-each>
                                    <xs:element ref="{concat($fgname,'AugmentationPoint')}"
                                        minOccurs="0" maxOccurs="unbounded"/>
                                </xs:sequence>
                            </xs:extension>
                        </xs:complexContent>
                    </xs:complexType>
                    <xs:element name="{concat($fgname,'AugmentationPoint')}" abstract="true">
                        <xs:annotation>
                            <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                ism:noticeType="{$DodDist}">
                                <xsl:value-of
                                    select="concat('An augmentation point for ', replace($datadefdoc, 'A data type for', ''))"
                                />
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
            <xsl:variable name="DodDist">
                <xsl:choose>
                    <xsl:when test="info/*[1]/@doddist">
                        <xsl:value-of select="info/*[1]/@doddist"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DoD-Dist-A</xsl:text>
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
                        <xsl:attribute name="nillable">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xs:annotation>
                            <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                ism:noticeType="{$DodDist}">
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
                            <xs:appinfo>
                                <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                                <xsl:if test="@substgrpname">
                                    <inf:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <inf:Element name="{@niemelementname}"
                                                type="{@niemtype}"/>
                                        </xsl:for-each>
                                    </inf:Choice>
                                </xsl:if>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name="label">
                <xsl:call-template name="breakIntoWords">
                    <xsl:with-param name="string" select="@niemelementname"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:if test="ends-with(@mtftype, 'GeneralTextType')">
                <xs:complexType name="{@niemtype}">
                    <xs:annotation>
                        <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                            ism:noticeType="{$DodDist}">
                            <xsl:value-of select="@niemtypedoc"/>
                        </xs:documentation>
                        <xs:appinfo>
                            <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                        </xs:appinfo>
                    </xs:annotation>
                    <xs:complexContent>
                        <xs:extension base="SetBaseType">
                            <xs:sequence>
                                <xs:element
                                    ref="{concat(substring(@niemelementname,0,string-length(@niemelementname)-10),'SubjectText')}"
                                    minOccurs="1" maxOccurs="1">
                                    <xs:annotation>
                                        <xs:documentation ism:classification="U"
                                            ism:ownerProducer="USA" ism:noticeType="{$DodDist}">
                                            <xsl:value-of
                                                select="concat('A data item for ', $label, '  Text Indicator')"
                                            />
                                        </xs:documentation>
                                        <xs:appinfo>
                                            <inf:Field positionName="TEXT INDICATOR"
                                                fixed="{@fixed}"
                                                concept="An indication of the subject matter addressed in a General Text (GENTEXT) set. Field 1 in the GENTEXT set is assigned at the message level. Therefore refer to the message instructions for the correct entry."
                                                fieldseq="1"/>
                                        </xs:appinfo>
                                    </xs:annotation>
                                </xs:element>
                                <xs:element ref="UnformattedFreeText" minOccurs="1" maxOccurs="1">
                                    <xs:annotation>
                                        <xs:documentation>A data item for text
                                            entry</xs:documentation>
                                        <xs:appinfo>
                                            <inf:Field positionName="FREE TEXT"
                                                concept="The free text information expressed in natural language. The field format length is artificial symbology representing an unrestricted length field, i.e., there is no limitation on the number of characters to be entered in the field. Classification and caveats may be added as necessary, e.g., (U REL GBR CAN)."
                                                definition="An unformatted free text field containing an unlimited number of characters (the structure is used here to represent an unlimited number). Used in the free-text sets AMPN, NARR, RMKS, and GENTEXT."
                                                fieldseq="2"/>
                                        </xs:appinfo>
                                    </xs:annotation>
                                </xs:element>
                                <xs:element
                                    ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                                    minOccurs="0" maxOccurs="unbounded"/>
                            </xs:sequence>
                        </xs:extension>
                    </xs:complexContent>
                </xs:complexType>
                <xs:element
                    name="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                    abstract="true">
                    <xs:annotation>
                        <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                            ism:noticeType="{$DodDist}">
                            <xsl:value-of select="concat('An augmentation point for ', @niemtype)"/>
                        </xs:documentation>
                    </xs:annotation>
                </xs:element>
                <xs:element
                    name="{concat(substring(@niemelementname,0,string-length(@niemelementname)-10),'SubjectText')}"
                    type="SubjectTextType" nillable="true">
                    <xs:annotation>
                        <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                            ism:noticeType="{$DodDist}">
                            <xsl:value-of
                                select="concat('A data item for ', @niemelementname, 'Text Indicator')"
                            />
                        </xs:documentation>
                        <xs:appinfo>
                            <inf:Field name="TEXT INDICATOR" fixed="{info/*/@textindicator}"/>
                        </xs:appinfo>
                    </xs:annotation>
                </xs:element>
            </xsl:if>
            <xsl:if test="ends-with(@niemtype, 'HeadingInformationType')">
                <xs:complexType name="{@niemtype}">
                    <xs:annotation>
                        <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                            ism:noticeType="{$DodDist}">
                            <xsl:value-of select="@niemtypedoc"/>
                        </xs:documentation>
                        <xs:appinfo>
                            <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                        </xs:appinfo>
                    </xs:annotation>
                    <xs:complexContent>
                        <xs:extension base="SetBaseType">
                            <xs:sequence>
                                <xs:element ref="{concat(@niemelementname,'SubjectText')}"
                                    minOccurs="1" maxOccurs="1">
                                    <xs:annotation>
                                        <xs:documentation>
                                            <xsl:value-of
                                                select="concat('A data item for ', $label, ' Subject Text')"
                                            />
                                        </xs:documentation>
                                        <xs:appinfo>
                                            <inf:Field positionName="'SUBJECT TEXT'"
                                                fixed="{@fixed}"
                                                concept="A word or phrase used to identify the particular subject matter (HEADING) of a group of related subsequent consecutive sets. Field 1 in the HEADING set is assigned at the message level. Refer to the message instructions for the correct entry of Field 1 in the HEADING set as it occurs in the message."
                                                fieldseq="1"/>
                                        </xs:appinfo>
                                    </xs:annotation>
                                </xs:element>
                                <xs:element ref="UnformattedFreeText" minOccurs="1" maxOccurs="1">
                                    <xs:annotation>
                                        <xs:documentation>A data item for text
                                            entry</xs:documentation>
                                        <xs:appinfo>
                                            <inf:Field positionName="FREE TEXT"
                                                concept="The free text information expressed in natural language. The field format length is artificial symbology representing an unrestricted length field, i.e., there is no limitation on the number of characters to be entered in the field. Classification and caveats may be added as necessary, e.g., (U REL GBR CAN)."
                                                definition="An unformatted free text field containing an unlimited number of characters (the structure is used here to represent an unlimited number). Used in the free-text sets AMPN, NARR, RMKS, and GENTEXT."
                                                fieldseq="2"/>
                                        </xs:appinfo>
                                    </xs:annotation>
                                </xs:element>
                                <xs:element
                                    ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                                    minOccurs="0" maxOccurs="unbounded"/>
                            </xs:sequence>
                        </xs:extension>
                    </xs:complexContent>
                </xs:complexType>
                <xs:element
                    name="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                    abstract="true">
                    <xs:annotation>
                        <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                            ism:noticeType="{$DodDist}">
                            <xsl:value-of select="concat('An augmentation point for ', @niemtype)"/>
                        </xs:documentation>
                    </xs:annotation>
                </xs:element>
                <xs:element name="{concat(@niemelementname,'SubjectText')}" type="SubjectTextType"
                    nillable="true">
                    <xs:annotation>
                        <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                            ism:noticeType="{$DodDist}">
                            <xsl:value-of
                                select="concat('A data item for ', @niemelementname, ' Subject Text')"
                            />
                        </xs:documentation>
                        <xs:appinfo>
                            <inf:Field positionName="SUBJECT TEXT" fixed="{@fixed}"
                                concept="A word or phrase used to identify the particular subject matter (HEADING) of a group of related subsequent consecutive sets. Field 1 in the HEADING set is assigned at the message level. Refer to the message instructions for the correct entry of Field 1 in the HEADING set as it occurs in the message."
                            />
                        </xs:appinfo>
                    </xs:annotation>
                </xs:element>
            </xsl:if>
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
            <xsl:variable name="DodDist">
                <xsl:choose>
                    <xsl:when test="info/*[1]/@doddist">
                        <xsl:value-of select="info/*[1]/@doddist"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DoD-Dist-A</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xs:complexType name="{@niemtype}">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                        ism:noticeType="{$DodDist}">
                        <xsl:value-of select="@niemtypedoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                    </xs:appinfo>
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
                                                  <xsl:when
                                                  test="string-length(Element/@substgrpname) &gt; 0"
                                                  >Fil <xsl:value-of select="Element/@substgrpname"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="Element/@niemelementname"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="concat($setname, 'FieldGroup')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@niemelementname"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="ntyp" select="@niemtype"/>
                                <xs:element ref="{$refname}">
                                    <xsl:copy-of select="@minOccurs"/>
                                    <xsl:copy-of select="@maxOccurs"/>
                                    <xs:annotation>
                                        <xs:documentation>
                                            <xsl:choose>
                                                <xsl:when test="$refname = 'UnformattedFreeText'">
                                                  <xsl:text>A data item for unformatted text entry</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                                  <xsl:value-of select="@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when
                                                  test="string-length(Choice/@substgrpdoc) &gt; 0">
                                                  <xsl:value-of select="Choice/@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when
                                                  test="string-length(Element[1]/@substgrpdoc) &gt; 0">
                                                  <xsl:value-of select="Element[1]/@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when
                                                  test="string-length(@niemelementdoc) &gt; 0">
                                                  <xsl:value-of select="@niemelementdoc"/>
                                                </xsl:when>
                                                <xsl:when
                                                  test="string-length(Element[1]/@niemelementdoc) &gt; 0">
                                                  <xsl:value-of select="Element[1]/@niemelementdoc"
                                                  />
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
                                        <xsl:choose>
                                            <xsl:when test="@name = 'GroupOfFields'">
                                                <xs:appinfo>
                                                  <inf:Field positionName="FIELD GROUP"/>
                                                </xs:appinfo>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xs:appinfo>
                                                  <xsl:apply-templates select="info/*[1]"
                                                  mode="refinfo"/>
                                                  <xsl:if test="@substgrpname">
                                                  <inf:Choice substitutionGroup="{@substgrpname}">
                                                  <xsl:for-each select="Choice/Element">
                                                  <xsl:sort select="@name"/>
                                                  <inf:Element name="{@niemelementname}"
                                                  type="{@niemtype}"/>
                                                  </xsl:for-each>
                                                  </inf:Choice>
                                                  </xsl:if>
                                                </xs:appinfo>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xs:annotation>
                                </xs:element>
                            </xsl:for-each>
                            <xs:element
                                ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                                minOccurs="0" maxOccurs="unbounded"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
            <xs:element
                name="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                abstract="true">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                        ism:noticeType="{$DodDist}">
                        <xsl:value-of select="concat('An augmentation point for ', @niemtype)"/>
                    </xs:documentation>
                </xs:annotation>
            </xs:element>
            <xsl:choose>
                <xsl:when test="@niemelementname = 'SetBase'"/>
                <xsl:otherwise>
                    <xs:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                        <xs:annotation>
                            <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                ism:noticeType="{$DodDist}">
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xs:documentation>
                            <xs:appinfo>
                                <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                                <xsl:if test="@substgrpname">
                                    <inf:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <inf:Element name="{@niemelementname}"
                                                type="{@niemtype}"/>
                                        </xsl:for-each>
                                    </inf:Choice>
                                </xsl:if>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <!--Global Set Elements-->
        <xsl:for-each select="$setfields/*">
            <xsl:choose>
                <xsl:when test="starts-with(@mtftype, 'f:')"/>
                <xsl:otherwise>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <!--Set Elements with Choice to Substitution Groups-->
        <xsl:for-each select="$all_set_elements_map//Element[@niemelementname][Choice]">
            <xsl:variable name="substgrp" select="Choice/@substgrpname"/>
            <xsl:variable name="substgrpdoc" select="Choice/@substgrpdoc"/>
            <xsl:variable name="setname" select="@setname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsl:choose>
                <xsl:when test="$all_field_elements_map/Element[@substitutiongroup = $substgrp]"/>
                <xsl:otherwise>
                    <xs:element name="{Choice/@substgrpname}" abstract="true">
                        <xs:annotation>
                            <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                ism:noticeType="DoD-Dist-A">
                                <xsl:value-of select="Choice/@substgrpdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <inf:Choice substitutionGroup="{Choice/@substgrpname}">
                                    <xsl:for-each select="Choice/Element">
                                        <xsl:sort select="@niemelementname"/>
                                        <inf:Element name="{@niemelementname}" type="{@niemtype}"/>
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
            <xsl:if test="count(preceding-sibling::*:complexType[@name = $n]) = 0">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$setsxsd/*:element[@name]">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:variable name="aug" select="ends-with(@name, 'AugmentationPoint')"/>
            <xsl:variable name="fg" select="ends-with(@name, 'FieldGroup')"/>
            <xsl:variable name="setf" select="ends-with(@name, 'Set')"/>
            <xsl:choose>
                <xsl:when test="@name = 'SubjectText'"/>
                <xsl:when
                    test="count(preceding-sibling::*:element[@name = $n and @type = $t]) &gt; 0"/>
                <xsl:when
                    test="count(preceding-sibling::*:element[@name = $n][ends-with(@name, 'Abstract') or ends-with(@name, 'AugmentationPoint')]) &gt; 0"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_sets_map">
        <xsl:for-each select="$niem_sets_map/*">
            <xsl:sort select="@mtfname"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Segments-->
    <xsl:variable name="segmentelements">
        <xsl:for-each select="$niem_segments_map//Element">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map/*[@substgrpname = $n]"/>
                <xsl:when test="$all_set_elements_map/*[@niemelementname = $n]"/>
                <xsl:when test="starts-with(Choice/Element[1]/@mtftype, 's:')"/>
                <xsl:otherwise>
                    <xsl:variable name="t" select="@niemtype"/>
                    <xsl:variable name="d" select="@niemelementdoc"/>
                    <xsl:variable name="segSeq">
                        <xsl:value-of select="ancestor::Segment/@segseq"/>
                    </xsl:variable>
                    <xs:element name="{@niemelementname}">
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
                        <xsl:attribute name="nillable">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xs:annotation>
                            <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                ism:noticeType="DoD-Dist-A">
                                <xsl:choose>
                                    <xsl:when test="@niemtype = 'GeneralTextType'">
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="@niemtype = 'HeadingInformationType'">
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="@niemtypedoc">
                                        <xsl:value-of select="@niemtypedoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xs:documentation>
                            <xsl:choose>
                                <xsl:when test="info/inf:Segment">
                                    <xs:appinfo>
                                        <xsl:copy-of select="info/inf:Segment"/>
                                    </xs:appinfo>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xs:appinfo>
                                        <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                                    </xs:appinfo>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$niem_segments_map//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map/*[@substgrpname = $substgrp]"/>
                <xsl:when test="starts-with(Choice/Element[1]/@mtftype, 's:')"/>
                <xsl:otherwise>
                    <xs:element name="{@substgrpname}" abstract="true">
                        <xs:annotation>
                            <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                ism:noticeType="DoD-Dist-A">
                                <xsl:value-of select="@substgrpdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <inf:Choice>
                                    <xsl:for-each select="Choice/Element">
                                        <xsl:sort select="@niemelementname"/>
                                        <inf:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </inf:Choice>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="Choice/Element">
                <xsl:sort select="@niemelementname"/>
                <xsl:variable name="nn" select="@niemelementname"/>
                <xsl:variable name="DodDist">
                    <xsl:choose>
                        <xsl:when test="info/*[1]/@doddist">
                            <xsl:value-of select="info/*[1]/@doddist"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>DoD-Dist-A</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$all_set_elements_map/Element[@niemelementname = $nn]"/>
                    <xsl:otherwise>
                        <xsl:variable name="niemelementdoc">
                            <xsl:choose>
                                <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                                    <xsl:value-of select="@niemelementdoc"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@mtfdoc"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xs:element name="{@niemelementname}">
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
                                <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                    ism:noticeType="{$DodDist}">
                                    <xsl:value-of select="@niemelementdoc"/>
                                </xs:documentation>
                                <xs:appinfo>
                                    <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                                </xs:appinfo>
                            </xs:annotation>
                        </xs:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="$all_segment_elements_map/*">
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
            <xsl:variable name="DodDist">
                <xsl:choose>
                    <xsl:when test="info/*[1]/@doddist">
                        <xsl:value-of select="info/*[1]/@doddist"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DoD-Dist-A</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map/*[@niemelementname = $n]"/>
                <xsl:when test="starts-with(@mtftype, 's:')"/>
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
                            <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                ism:noticeType="{$DodDist}">
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
                                    <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                        <xsl:value-of select="@mtfdoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="breakIntoWords">
                                            <xsl:with-param name="string" select="@niemelementname"
                                            />
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xs:documentation>
                            <xs:appinfo>
                                <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                                <xsl:if test="@substgrpname">
                                    <inf:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <inf:Element name="{@niemelementname}"
                                                type="{@niemtype}"/>
                                        </xsl:for-each>
                                    </inf:Choice>
                                </xsl:if>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="segmentsxsd">
        <xsl:for-each select="$niem_segments_map/Segment">
            <xsl:sort select="@niemtype"/>
            <xsl:variable name="DodDist">
                <xsl:choose>
                    <xsl:when test="info/*[1]/@doddist">
                        <xsl:value-of select="info/*[1]/@doddist"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DoD-Dist-A</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xs:complexType name="{@niemtype}">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                        ism:noticeType="{$DodDist}">
                        <xsl:value-of select="@niemtypedoc"/>
                    </xs:documentation>
                </xs:annotation>
                <xs:complexContent>
                    <xs:extension base="structures:ObjectType">
                        <xs:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="n" select="@niemelementname"/>
                                <xsl:variable name="ntyp" select="@niemtype"/>
                                <xsl:variable name="refname">
                                    <xsl:choose>
                                        <xsl:when test="@substgrpname">
                                            <xsl:value-of select="@substgrpname"/>
                                        </xsl:when>
                                        <xsl:when test="$segmentelements/*[@name = $n]">
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
                                                <xsl:when
                                                  test="string-length(Choice/@substgrpdoc) &gt; 0">
                                                  <xsl:value-of select="Choice/@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                                  <xsl:value-of
                                                  select="replace(@mtfdoc, 'A data type', 'A data item')"
                                                  />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="@niemelementdoc"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xs:documentation>
                                        <xs:appinfo>
                                            <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                                            <xsl:if test="@substgrpname">
                                                <inf:Choice substitutionGroup="{@substgrpname}">
                                                  <xsl:for-each select="Choice/Element">
                                                  <xsl:sort select="@name"/>
                                                  <inf:Element name="{@niemelementname}"
                                                  type="{@niemtype}"/>
                                                  </xsl:for-each>
                                                </inf:Choice>
                                            </xsl:if>
                                        </xs:appinfo>
                                    </xs:annotation>
                                </xs:element>
                            </xsl:for-each>
                            <xs:element
                                ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                                minOccurs="0" maxOccurs="unbounded"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
            <xs:element
                name="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                abstract="true">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                        ism:noticeType="{$DodDist}">
                        <xsl:value-of select="concat('An augmentation point for ', @niemtype)"/>
                    </xs:documentation>
                </xs:annotation>
            </xs:element>
            <xs:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                        ism:noticeType="{$DodDist}">
                        <xsl:value-of select="@niemelementdoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                    </xs:appinfo>
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
                <xsl:when
                    test="count(preceding-sibling::*:element[@name = $n and @type = $t]) &gt; 0"/>
                <xsl:when
                    test="count(preceding-sibling::*:element[@name = $n][ends-with(@name, 'Abstract') or ends-with(@name, 'AugmentationPoint')]) &gt; 0"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_segments_map">
        <xsl:for-each select="$niem_segments_map/*">
            <xsl:sort select="@mtfname"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Messages-->
    <xsl:variable name="messagelements">
        <xsl:for-each select="$niem_messages_map//Sequence/Element">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsl:variable name="DodDist">
                <xsl:choose>
                    <xsl:when test="info/*[1]/@doddist">
                        <xsl:value-of select="info/*[1]/@doddist"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DoD-Dist-A</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map//*[@niemelementname = $n]"/>
                <xsl:when test="$all_segment_elements_map//*[@niemelementname = $n]"/>
                <xsl:otherwise>
                    <xsl:variable name="n" select="@niemelementname"/>
                    <xsl:variable name="segSeq">
                        <xsl:value-of select="ancestor::Segment/@segseq"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="@niemelementname">
                            <xs:element name="{@niemelementname}">
                                <xsl:attribute name="type">
                                    <xsl:value-of select="@niemtype"/>
                                </xsl:attribute>
                                <xsl:attribute name="nillable">
                                    <xsl:text>true</xsl:text>
                                </xsl:attribute>
                                <xs:annotation>
                                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                        ism:noticeType="{$DodDist}">
                                        <xsl:choose>
                                            <xsl:when test="@niemtypedoc">
                                                <xsl:value-of
                                                  select="replace(@niemtypedoc, 'A data type', 'A data item')"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="@niemelementdoc"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xs:documentation>
                                    <xs:appinfo>
                                        <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                                    </xs:appinfo>
                                </xs:annotation>
                            </xs:element>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$niem_messages_map//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xsl:variable name="DodDist">
                <xsl:choose>
                    <xsl:when test="info/*[1]/@doddist">
                        <xsl:value-of select="info/*[1]/@doddist"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DoD-Dist-A</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map//*[@substgrpname = $substgrp]"/>
                <xsl:when test="$all_segment_elements_map//*[@substgrpname = $substgrp]"/>
                <xsl:when test="@substgrpname">
                    <xs:element name="{@substgrpname}" abstract="true">
                        <xs:annotation>
                            <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                ism:noticeType="{$DodDist}">
                                <xsl:value-of select="@substgrpdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <inf:Choice>
                                    <xsl:for-each select="Choice/Element">
                                        <inf:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </inf:Choice>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                    <xsl:for-each select="Choice/Element">
                        <xsl:variable name="n" select="@niemelementname"/>
                        <xs:element name="{@niemelementname}" type="{@niemtype}"
                            substitutionGroup="{$substgrp}" nillable="true">
                            <xs:annotation>
                                <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                                    ism:noticeType="{$DodDist}">
                                    <xsl:choose>
                                        <xsl:when test="@niemtypedoc">
                                            <xsl:value-of select="@niemtypedoc"/>
                                        </xsl:when>
                                        <xsl:when test="@niemelementdoc">
                                            <xsl:value-of select="@niemelementdoc"/>
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
        <xsl:for-each select="$niem_messages_map/Message">
            <xsl:sort select="@niemtype"/>
            <xsl:variable name="mn" select="@niemelementname"/>
            <xsl:variable name="DodDist">
                <xsl:choose>
                    <xsl:when test="info/*[1]/@doddist">
                        <xsl:value-of select="info/*[1]/@doddist"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DoD-Dist-A</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xs:complexType name="{@niemtype}">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                        ism:noticeType="{$DodDist}">
                        <xsl:value-of select="@niemtypedoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                    </xs:appinfo>
                </xs:annotation>
                <xs:complexContent>
                    <xs:extension base="structures:ObjectType">
                        <xs:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="n" select="@niemelementname"/>
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
                                                <xsl:when
                                                  test="string-length(@niemelementdoc) &gt; 0">
                                                  <xsl:value-of select="@niemelementdoc"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="@niemtypedoc"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xs:documentation>
                                        <xs:appinfo>
                                            <xsl:apply-templates select="info/*[1]" mode="refinfo"/>
                                            <xsl:if test="@substgrpname">
                                                <inf:Choice substitutionGroup="{@substgrpname}">
                                                  <xsl:for-each select="Choice/Element">
                                                  <xsl:sort select="@name"/>
                                                  <inf:Element name="{@niemelementname}"
                                                  type="{@niemtype}"/>
                                                  </xsl:for-each>
                                                </inf:Choice>
                                            </xsl:if>
                                        </xs:appinfo>
                                    </xs:annotation>
                                </xs:element>
                            </xsl:for-each>
                            <xs:element
                                ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                                minOccurs="0" maxOccurs="unbounded"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
            <xs:element
                name="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}"
                abstract="true">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                        ism:noticeType="{$DodDist}">
                        <xsl:value-of select="concat('An augmentation point for ', @niemtype)"/>
                    </xs:documentation>
                </xs:annotation>
            </xs:element>
            <xs:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                        ism:noticeType="{$DodDist}">
                        <xsl:value-of select="@niemelementdoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:for-each select="info/*">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                        <inf:StructuralRelationships>
                            <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                queryBinding="xslt">
                                <sch:ns uri="urn:mtf:mil:6040b:niem:mtf" prefix="mtf"/>
                                <sch:ns uri="urn:us:gov:ic:ism" prefix="ism"/>
                                <sch:title>
                                    <xsl:value-of
                                        select="concat(@msgid, ' Structural Relationship Rules')"/>
                                </sch:title>
                                <xsl:copy-of select="$structRel/sch:pattern[@id = $mn]"/>
                            </sch:schema>
                        </inf:StructuralRelationships>
                    </xs:appinfo>
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
                <xsl:when test="$mtf_segments_xsd/*:complexType[@name = $n]"/>
                <xsl:when test="count(preceding-sibling::*:complexType[@name = $n]) &gt; 0"/>
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
                <xsl:when test="ends-with($n, 'Segment')"/>
                <xsl:when test="count(preceding-sibling::*:element[@name = $n][@type = $t]) &gt; 0"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_messages_map">
        <xsl:for-each select="$niem_messages_map/*">
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
    <xsl:variable name="ALLMAP">
        <xsl:copy-of select="$mtf_messages_map" copy-namespaces="no"/>
        <xsl:copy-of select="$mtf_segments_map" copy-namespaces="no"/>
        <xsl:copy-of select="$mtf_sets_map" copy-namespaces="no"/>
        <xsl:copy-of select="$mtf_composites_map" copy-namespaces="no"/>
        <xsl:copy-of select="$mtf_fields_map" copy-namespaces="no"/>
    </xsl:variable>
    <xsl:variable name="sub-xsd-template">
        <xs:schema xmlns="urn:mtf:mil:6040b:niem:mtf"
            xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
            xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
            xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
            xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/"
            xmlns:inf="urn:mtf:mil:6040b:appinfo"
            xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:ism="urn:us:gov:ic:ism"
            xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:mtf:mil:6040b:niem:mtf"
            ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument"
            xml:lang="en-US" elementFormDefault="qualified" attributeFormDefault="qualified"
            version="1.0">
            <xs:import namespace="http://release.niem.gov/niem/structures/4.0/"
                schemaLocation="../ext/niem/utility/structures/4.0/structures.xsd"/>
            <xs:import namespace="http://release.niem.gov/niem/localTerminology/3.0/"
                schemaLocation="../ext/niem/localTerminology.xsd"/>
            <xs:import namespace="http://release.niem.gov/niem/appinfo/4.0/"
                schemaLocation="../ext/niem/utility/appinfo/4.0/appinfo.xsd"/>
            <xs:import namespace="urn:mtf:mil:6040b:appinfo"
                schemaLocation="../ext/niem/mtfappinfo.xsd"/>
        </xs:schema>
    </xsl:variable>
    <xsl:variable name="DodDistC" select="'C'"/>
    <xsl:variable name="DodDistA" select="'A'"/>
    <xsl:variable name="DistCStmnt"
        select="
            'DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use. Other requests for this document shall be
        referred to Defense Information Systems Agency Interoperability Directorate. WARNING - This document contains technical data whose export is restricted by the Arms Export Control Act (Title 22,
        U.S.C., Sec. 2751) or the Export Administration Act of 1979, as amended, Title 50, U.S.C., App. 2401. Violations of these export laws are subject to severe criminal penalties. Disseminate in
        accordance with provisions of DOD Directive 5230.25.'"/>
    <xsl:variable name="DistAStmnt"
        select="'DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.'"/>

    <xsl:template name="mapmtf">
        <!--Maps-->
        <xsl:result-document href="{$dirpath}/maps/usmtf-fieldmaps.xml">
            <Fields>
                <xsl:copy-of select="$mtf_fields_map"/>
            </Fields>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/maps/usmtf-compositemaps.xml">
            <Composites>
                <xsl:copy-of select="$mtf_composites_map" copy-namespaces="no"/>
            </Composites>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/maps/usmtf-setmaps.xml">
            <Sets>
                <xsl:copy-of select="$mtf_sets_map"/>
            </Sets>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/maps/usmtf-segmntmaps.xml">
            <Segments>
                <xsl:copy-of select="$mtf_segments_map" copy-namespaces="no"/>
            </Segments>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/maps/usmtf-msgsmaps.xml">
            <Messages>
                <xsl:copy-of select="$mtf_messages_map"/>
            </Messages>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/maps/usmtf-allmaps.xml">
            <MTF>
                <xsl:copy-of select="$ALLMAP" copy-namespaces="no"/>
            </MTF>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="buildmtf">
        <xsl:call-template name="mapmtf"/>
        <!--Schema-->
        <xsl:result-document href="{$dirpath}/refxsd/usmtf-fields.xsd">
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xs:include schemaLocation="usmtf-sets.xsd"/>
                    <xs:annotation>
                        <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                            ism:noticeType="{$DodDistC}">
                            <xsl:text>Fields for MTF Messages</xsl:text>
                        </xs:documentation>
                        <xs:appinfo>
                            <inf:Distro distro="{$DodDistC}"
                                statement="{normalize-space($DistCStmnt)}"/>
                        </xs:appinfo>
                    </xs:annotation>
                    <xsl:copy-of select="$mtf_fields_xsd" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/refxsd/usmtf-composites.xsd">
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xs:include schemaLocation="usmtf-fields.xsd"/>
                    <xs:include schemaLocation="usmtf-sets.xsd"/>
                    <xs:annotation>
                        <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                            ism:noticeType="{$DodDistC}">
                            <xsl:text>Composite fields for MTF Composite Fields</xsl:text>
                        </xs:documentation>
                        <xs:appinfo>
                            <inf:Distro distro="{$DodDistC}"
                                statement="{normalize-space($DistCStmnt)}"/>
                        </xs:appinfo>
                    </xs:annotation>
                    <xsl:copy-of select="$mtf_composites_xsd" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/refxsd/usmtf-sets.xsd">
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xs:include schemaLocation="usmtf-fields.xsd"/>
                    <xs:include schemaLocation="usmtf-composites.xsd"/>
                    <xs:annotation>
                        <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                            ism:noticeType="{$DodDistC}">
                            <xsl:text>Set structures for MTF Messages</xsl:text>
                        </xs:documentation>
                        <xs:appinfo>
                            <inf:Distro distro="{$DodDistC}"
                                statement="{normalize-space($DistCStmnt)}"/>
                        </xs:appinfo>
                    </xs:annotation>
                    <xsl:copy-of select="$mtf_sets_xsd" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/refxsd/usmtf-segments.xsd">
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xs:include schemaLocation="usmtf-sets.xsd"/>
                    <xs:annotation>
                        <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                            ism:noticeType="{$DodDistC}">
                            <xsl:text>Segment structures for MTF Segments</xsl:text>
                        </xs:documentation>
                        <xs:appinfo>
                            <inf:Distro distro="{$DodDistC}"
                                statement="{normalize-space($DistCStmnt)}"/>
                        </xs:appinfo>
                    </xs:annotation>
                    <xsl:copy-of select="$mtf_segments_xsd" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/refxsd/usmtf-messages.xsd">
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xs:include schemaLocation="usmtf-sets.xsd"/>
                    <xs:include schemaLocation="usmtf-segments.xsd"/>
                    <xs:annotation>
                        <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                            ism:noticeType="{$DodDistC}">
                            <xsl:text>Message structures for MTF Messages</xsl:text>
                        </xs:documentation>
                        <xs:appinfo>
                            <inf:Distro distro="{$DodDistC}"
                                statement="{normalize-space($DistCStmnt)}"/>
                        </xs:appinfo>
                    </xs:annotation>
                    <xsl:copy-of select="$mtf_messages_xsd" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/refxsd/usmtf-ref.xsd">
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xs:annotation>
                        <xs:documentation ism:classification="U" ism:ownerProducer="USA"
                            ism:noticeType="{$DodDistC}">
                            <xsl:text>UNIFIED MTF MESSAGE SCHEMA</xsl:text>
                        </xs:documentation>
                        <xs:appinfo>
                            <inf:Distro distro="{$DodDistC}"
                                statement="{normalize-space($DistCStmnt)}"/>
                        </xs:appinfo>
                    </xs:annotation>
                    <xsl:for-each select="$ALLMTF/*:complexType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="count(preceding-sibling::*[@name = $n]) = 0">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$ALLMTF/*:simpleType">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:for-each select="$ALLMTF/*:element">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="count(preceding-sibling::*[@name = $n]) = 0">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <!--<xsl:call-template name="subsetXSD"/>-->
    </xsl:template>

   <!-- <xsl:template name="subsetXSD">
        <xsl:for-each select="$mtf_messages_xsd/*[@name][@type][@mtfid]">
            <xsl:variable name="msg" select="."/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:variable name="mid" select="lower-case(translate(@mtfid, ' .()-', ''))"/>
            <xsl:result-document href="{concat($dirpath,'lists/',$mid,'-list.xml')}">
                <xsl:copy-of select="$ALLMAP/*[@name = $n]" copy-namespaces="no"/>
            </xsl:result-document>
            <xsl:result-document href="{concat($subsetoutdir,$mid,'-ref.xsd')}">
                <xsl:for-each select="$ref-xsd-template/*">
                    <xsl:copy>
                        <xsl:apply-templates select="@*" mode="ssidentity"/>
                        <xsl:apply-templates select="*" mode="ssidentity"/>
                        <xsl:apply-templates
                            select="$ALLMTF/*[@name = $msg/element[1]/@name]/*:annotation"
                            mode="ssidentity"/>
                        <xsl:apply-templates select="$msg/*" mode="filter">
                            <xsl:with-param name="msg" select="$msg"/>
                        </xsl:apply-templates>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:result-document>
            <xsl:result-document href="{concat($iepdoutdir,$mid,'-iep.xsd')}">
                <xsl:for-each select="$iep-xsd-template/*">
                    <xsl:copy>
                        <xsl:apply-templates select="@*" mode="identity"/>
                        <xsl:apply-templates select="*" mode="identity"/>
                        <xsl:apply-templates select="$msg/xs:schema/*" mode="iepd"/>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:result-document>
        </xsl:for-each>
        <!-\-All MTF IEPD-\->
        <xsl:result-document href="{concat($iepdoutdir,'usmtf-iep.xsd')}">
            <xsl:for-each select="$iep-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xsl:apply-templates select="$ALLMTF/xs:schema/*" mode="iepd"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>-->

    <xsl:template match="info/*" mode="refinfo">
        <xsl:copy>
            <xsl:copy-of select="@mtfid" copy-namespaces="no"/>
            <xsl:copy-of select="@setid" copy-namespaces="no"/>
            <xsl:copy-of select="@name" copy-namespaces="no"/>
            <xsl:copy-of select="@positionName" copy-namespaces="no"/>
            <xsl:copy-of select="@version" copy-namespaces="no"/>
            <xsl:copy-of select="@ffirn" copy-namespaces="no"/>
            <xsl:copy-of select="@fud" copy-namespaces="no"/>
            <xsl:copy-of select="@date" copy-namespaces="no"/>
            <xsl:copy-of select="@remark" copy-namespaces="no"/>
            <xsl:if test="parent::info/parent::*/@niemtype and not(parent::info/Choice)">
                <xsl:attribute name="type">
                    <xsl:value-of select="parent::info/parent::*/@niemtype"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="@segseq" copy-namespaces="no"/>
            <xsl:copy-of select="@setseq" copy-namespaces="no"/>
            <xsl:if test="not(@segseq) and not(@setseq)">
                <xsl:copy-of select="@fieldseq" copy-namespaces="no"/>
            </xsl:if>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
