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
    <xsl:variable name="messagemapsoutput" select="concat($srcdir, 'Maps/NIEM_MTF_Msgsmaps.xml')"/>
    <xsl:variable name="messagesxsdoutputdoc"
        select="concat($srcdir, 'NIEM_MTF/NIEM_MTF_Messages.xsd')"/>

    <!-- _______________________________________________________ -->

    <!--XSD GENERATION-->
    <!-- _______________________________________________________ -->

    <!--Messages-->
    <xsl:variable name="messagelements">
        <xsl:for-each select="$niem_messages_map//Sequence/Element">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n" select="@niemelementname"/>
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
                                    <xs:documentation>
                                        <xsl:choose>
                                            <xsl:when test="@niemtypedoc">
                                                <xsl:value-of select="replace(@niemtypedoc, 'A data type', 'A data item')"/>
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
                                                <!--<xsl:copy-of select="@concept"/>
                                                    <xsl:copy-of select="@usage"/>-->
                                            </xsl:copy>
                                        </xs:appinfo>
                                    </xsl:for-each>
                                </xs:annotation>
                            </xs:element>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$niem_messages_map//Element[Choice]">
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
                                <mtfappinfo:Choice>
                                    <xsl:for-each select="Choice/Element">
                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                    <xsl:for-each select="Choice/Element">
                        <xsl:variable name="n" select="@niemelementname"/>
                        <xs:element name="{@niemelementname}" type="{@niemtype}" substitutionGroup="{$substgrp}" nillable="true">
                            <xs:annotation>
                                <xs:documentation>
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
                                                <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                                                    <xsl:value-of select="@niemelementdoc"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@niemtypedoc"/>
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
                    <xsl:for-each select="*:appinfo/*">
                        <xs:appinfo>
                            <xsl:copy-of select="."/>
                            <!-- <xsl:copy>
                                <xsl:copy-of select="@name"/>
                                <xsl:copy-of select="@positionName"/>
                                <!-\-\\\\-<xsl:copy-of select="@usage"/>
                                <xsl:copy-of select="@concept"/> -\->
                            </xsl:copy>-->
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
            <xsl:variable name="pre1" select="preceding-sibling::*:complexType[@name = $n][1]"/>
            <xsl:variable name="pre2" select="preceding-sibling::*:complexType[@name = $n][2]"/>
            <xsl:choose>
                <xsl:when test="$n = $pre1/@name"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:when test="deep-equal(., $pre2)"/>
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
            <xsl:variable name="pre1" select="preceding-sibling::*:element[@name = $n][1]"/>
            <xsl:variable name="pre2" select="preceding-sibling::*:element[@name = $n][2]"/>
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
        <xsl:for-each select="$niem_messages_map/*">
            <xsl:sort select="@mtfname"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
   
    <!-- _______________________________________________________ -->
    <!--    OUTPUT RESULT-->
    <!-- _______________________________________________________ -->

    <xsl:template name="main">
        <xsl:result-document href="{$messagesxsdoutputdoc}">
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
                <xs:include schemaLocation="NIEM_MTF_Segments.xsd"/>
                <xs:annotation>
                    <xs:documentation>
                        <xsl:text>Message structures for MTF Messages</xsl:text>
                    </xs:documentation>
                </xs:annotation>
                <xsl:copy-of select="$mtf_messages_xsd"/>
            </xs:schema>
        </xsl:result-document>
        <xsl:result-document href="{$messagemapsoutput}">
            <Messages>
                <xsl:copy-of select="$mtf_messages_map"/>
            </Messages>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="msg_nodes">
        <xs:annotation>
            <xs:documentation>
                <xsl:text>Message structures for MTF Messages</xsl:text>
            </xs:documentation>
        </xs:annotation>
        <xsl:for-each select="$messagesxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="pre1" select="preceding-sibling::*:complexType[@name = $n][1]"/>
            <xsl:variable name="pre2" select="preceding-sibling::*:complexType[@name = $n][2]"/>
            <xsl:choose>
                <xsl:when test="$n = $pre1/@name"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:when test="deep-equal(., $pre2)"/>
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
            <xsl:variable name="pre1" select="preceding-sibling::*:element[@name = $n][1]"/>
            <xsl:variable name="pre2" select="preceding-sibling::*:element[@name = $n][2]"/>
            <xsl:choose>
                <xsl:when test="deep-equal(., $pre1)"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
