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

    <!--Set deconfliction and annotation changes-->
    <!--Outputs-->
    <xsl:variable name="segmentmapsoutput"
        select="concat($srcdir, 'NIEM_MTF/Maps/NIEM_MTF_Segmntmaps.xml')"/>
    <xsl:variable name="segmentsxsdoutputdoc"
        select="concat($srcdir, 'NIEM_MTF/NIEM_MTF_Segments.xsd')"/>
    <!-- _________________________________________ -->

    <!--XSD GENERATION-->
    <!-- _______________________________________________________ -->
    <!--Segments-->
    <xsl:variable name="segmentelements">
        <xsl:for-each select="$niem_segments_map//Sequence/Element">
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
                        <xs:annotation>
                            <xs:documentation>
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
                                <xsl:when test="appinfo/mtfappinfo:Segment">
                                    <xs:appinfo>
                                        <xsl:copy-of select="appinfo/mtfappinfo:Segment"/>
                                    </xs:appinfo>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="appinfo/*">
                                        <xs:appinfo>
                                            <xsl:copy>
                                                <xsl:copy-of select="@positionName"/>
                                                <xsl:copy-of select="ancestor::Element/@textindicator"/>
                                                <xsl:copy-of select="@usage"/>
                                            </xsl:copy>
                                        </xs:appinfo>
                                    </xsl:for-each>
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
                            <xs:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <mtfappinfo:Choice>
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
            <xsl:for-each select="Choice/Element">
                <xsl:sort select="@niemelementname"/>
                <xsl:variable name="nn" select="@niemelementname"/>
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
                                <xs:documentation>
                                    <xsl:value-of select="@niemelementdoc"/>
                                </xs:documentation>
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
                                    <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                        <xsl:value-of select="@mtfdoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="breakIntoWords">
                                            <xsl:with-param name="string" select="@niemelementname"/>
                                        </xsl:call-template>
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
    <xsl:variable name="segmentsxsd">
        <xsl:for-each select="$niem_segments_map/Segment">
            <xsl:sort select="@niemtype"/>
            <xs:complexType name="{@niemtype}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xs:documentation>
                </xs:annotation>
                <xs:complexContent>
                    <xs:extension base="structures:ObjectType">
                        <xs:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="n" select="@niemelementname"/>
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
                                                <xsl:when test="string-length(Choice/@substgrpdoc) &gt; 0">
                                                    <xsl:value-of select="Choice/@substgrpdoc"/>
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
                                                <xsl:copy>
                                                    <xsl:copy-of select="@positionName"/>
                                                    <xsl:copy-of select="ancestor::Element/@textindicator"/>
                                                    <xsl:copy-of select="@usage"/>
                                                </xsl:copy>
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
            <xs:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@niemelementdoc"/>
                    </xs:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xs:appinfo>
                            <xsl:copy>
                                <xsl:copy-of select="@segmentname"/>
                                <!--<xsl:copy-of select="@positionName"/>-->
                                <xsl:copy-of select="@usage"/>
                                <xsl:copy-of select="@concept"/>
                            </xsl:copy>
                        </xs:appinfo>
                    </xsl:for-each>
                </xs:annotation>
            </xs:element>
        </xsl:for-each>
        <!--Global Set Elements-->
        <xsl:copy-of select="$segmentelements"/>
        <!--Set Elements with Choice to Substitution Groups-->
        <!--<xsl:for-each select="$niem_segments_map//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xs:element name="{@substgrpname}" abstract="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="normalize-space(@substgrpdoc)"/>
                    </xs:documentation>
                </xs:annotation>
            </xs:element>
            <xsl:for-each select="Choice/Element">
                <xs:element name="{@niemelementname}" type="{@niemtype}" substitutionGroup="{$substgrp}" nillable="true">
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:value-of select="normalize-space(@niemelementdoc)"/>
                        </xs:documentation>
                    </xs:annotation>
                </xs:element>
            </xsl:for-each>
        </xsl:for-each>-->
    </xsl:variable>
    <xsl:variable name="mtf_segments_xsd">
        <xsl:for-each select="$segmentsxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="pre1" select="preceding-sibling::*:complexType[@name = $n][1]"/>
            <xsl:variable name="pre2" select="preceding-sibling::*:complexType[@name = $n][2]"/>
            <xsl:variable name="pre3" select="preceding-sibling::*:complexType[@name = $n][3]"/>
            <xsl:choose>
                <xsl:when test="$n = $pre1/@name"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:when test="deep-equal(., $pre3)"/>
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
        <xsl:for-each select="$niem_segments_map/*">
            <xsl:sort select="@mtfname"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    
    <!--    OUTPUT RESULT-->
    <!-- _______________________________________________________ -->

    <xsl:template name="main">
        <xsl:result-document href="{$segmentsxsdoutputdoc}">
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
                <xs:include schemaLocation="NIEM_MTF_Sets.xsd"/>
                <xs:annotation>
                    <xs:documentation>
                        <xsl:text>Segment structures for MTF Segments</xsl:text>
                    </xs:documentation>
                </xs:annotation>
                <xsl:copy-of select="$mtf_segments_xsd" copy-namespaces="no"/>
            </xs:schema>
        </xsl:result-document>
        <xsl:result-document href="{$segmentmapsoutput}">
            <Segments>
                <xsl:copy-of select="$mtf_segments_map" copy-namespaces="no"/>
            </Segments>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
