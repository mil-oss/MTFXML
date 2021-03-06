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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
    xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
    exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="NcdfMap.xsl"/>

    <!--Outputs-->
    <xsl:variable name="messagesxsdoutputdoc" select="concat($srcdir, 'NCDF_MTF_Messages.xsd')"/>

<!-- _______________________________________________________ -->

    <!--XSD GENERATION-->
    <!-- _______________________________________________________ -->

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
                            <xsd:element name="{@ncdfelementname}">
                                <xsl:attribute name="type">
                                    <xsl:value-of select="@ncdftype"/>
                                </xsl:attribute>
                                <xsl:attribute name="nillable">
                                    <xsl:text>true</xsl:text>
                                </xsl:attribute>
                                <xsd:annotation>
                                    <xsd:documentation>
                                        <xsl:choose>
                                            <xsl:when test="@ncdftypedoc">
                                                <xsl:value-of select="replace(@ncdftypedoc,'A data type','A data item')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="@ncdfelementdoc"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsd:documentation>
                                    <xsl:for-each select="appinfo/*">
                                        <xsd:appinfo>
                                            <xsl:copy>
                                                <xsl:copy-of select="@positionName"/>
                                                <!--<xsl:copy-of select="@concept"/>
                                                    <xsl:copy-of select="@usage"/>-->
                                            </xsl:copy>
                                        </xsd:appinfo>
                                    </xsl:for-each>
                                </xsd:annotation>
                            </xsd:element>
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
                    <xsd:element name="{@substgrpname}" abstract="true">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xsd:documentation>
                            <xsd:appinfo>
                                <mtfappinfo:Choice>
                                    <xsl:for-each select="Choice/Element">
                                        <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsl:for-each select="Choice/Element">
                        <xsl:variable name="n" select="@ncdfelementname"/>
                        <xsd:element name="{@ncdfelementname}" type="{@ncdftype}" substitutionGroup="{$substgrp}" nillable="true">
                            <xsd:annotation>
                                <xsd:documentation>
                                    <xsl:choose>
                                        <xsl:when test="@ncdftypedoc">
                                            <xsl:value-of select="@ncdftypedoc"/>
                                        </xsl:when>
                                        <xsl:when test="@ncdfelementdoc">
                                            <xsl:value-of select="@ncdfelementdoc"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsd:documentation>
                            </xsd:annotation>
                        </xsd:element>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="messagesxsd">
        <xsl:for-each select="$ncdf_messages_map/Message">
            <xsl:sort select="@ncdftype"/>
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
                    <xsd:extension base="structures:ObjectType">
                        <xsd:sequence>
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
                                <xsd:element ref="{$refname}">
                                    <xsl:copy-of select="@minOccurs"/>
                                    <xsl:copy-of select="@maxOccurs"/>
                                    <xsd:annotation>
                                        <xsd:documentation>
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
            <xsd:element name="{@ncdfelementname}" type="{@ncdftype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@ncdfelementdoc"/>
                    </xsd:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xsd:appinfo>
                            <xsl:copy-of select="."/>
                           <!-- <xsl:copy>
                                <xsl:copy-of select="@name"/>
                                <xsl:copy-of select="@positionName"/>
                                <!-\-\\\\-<xsl:copy-of select="@usage"/>
                                <xsl:copy-of select="@concept"/> -\->
                            </xsl:copy>-->
                        </xsd:appinfo>
                    </xsl:for-each>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <!--Global Elements-->
        <xsl:copy-of select="$messagelements"/>
    </xsl:variable>
    <xsl:variable name="mtf_messages_xsd">
        <xsl:for-each select="$messagesxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="pre1" select="preceding-sibling::xsd:complexType[@name = $n][1]"/>
            <xsl:variable name="pre2" select="preceding-sibling::xsd:complexType[@name = $n][2]"/>
            <xsl:choose>
                <xsl:when test="$n = $pre1/@name"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$messagesxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:sort select="@type"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:variable name="pre1" select="preceding-sibling::xsd:element[@name = $n][1]"/>
            <xsl:variable name="pre2" select="preceding-sibling::xsd:element[@name = $n][2]"/>
            <xsl:choose>
                <xsl:when test="deep-equal(., $pre1)"/>
                <xsl:when test="deep-equal(., $pre2)"/>
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

    <!--    OUTPUT RESULT-->
    <!-- _______________________________________________________ -->

    <xsl:template name="main">
        <!--<xsl:result-document href="{$messagesxsdoutputdoc}">
            <xsd:schema xmlns="urn:int:nato:ncdf:mtf" 
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" 
                xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" 
                xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" 
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:int:nato:ncdf:mtf" 
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" 
                xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../NCDF/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../NCDF/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../NCDF/appinfo.xsd"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:appinfo" schemaLocation="../NCDF/mtfappinfo.xsd"/>
                <xsd:include schemaLocation="NCDF_MTF_Sets.xsd"/>
                <xsd:include schemaLocation="NCDF_MTF_Segments.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Message structures for MTF Messages</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:copy-of select="$mtf_messages_xsd"/>
            </xsd:schema>
        </xsl:result-document>-->
        <xsl:result-document href="{$messagesmapoutpath}">
            <Messages>
                <xsl:copy-of select="$mtf_messages_map"/>
            </Messages>
        </xsl:result-document>
    </xsl:template>

    <!--<xsl:template name="msg_nodes">
        <xsd:annotation>
            <xsd:documentation>
                <xsl:text>Message structures for MTF Messages</xsl:text>
            </xsd:documentation>
        </xsd:annotation>
        <xsl:for-each select="$messagesxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="pre1" select="preceding-sibling::xsd:complexType[@name = $n][1]"/>
            <xsl:variable name="pre2" select="preceding-sibling::xsd:complexType[@name = $n][2]"/>
            <xsl:choose>
                <xsl:when test="$n = $pre1/@name"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$messagesxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:sort select="@type"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:variable name="pre1" select="preceding-sibling::xsd:element[@name = $n][1]"/>
            <xsl:variable name="pre2" select="preceding-sibling::xsd:element[@name = $n][2]"/>
            <xsl:choose>
                <xsl:when test="deep-equal(., $pre1)"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>-->

</xsl:stylesheet>
