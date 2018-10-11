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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="NiemMap.xsl"/>

    <!--Outputs-->
    <xsl:variable name="compositeoutputdoc" select="concat($srcdir, 'NIEM_MTF/NIEM_MTF_Composites.xsd')"/>
    <xsl:variable name="compositemapoutputdoc" select="concat($srcdir, 'NIEM_MTF/Maps/NIEM_MTF_Compositemaps.xml')"/>

    <xsl:variable name="elementsxsd">
        <xsl:for-each select="$all_composite_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsl:variable name="t">
                <xsl:value-of select="@niemtype"/>
            </xsl:variable>
            <xsl:variable name="s" select="@substgrpname"/>
            <xsl:choose>
               <xsl:when test="$niem_fields_map//*[@niemelementname = $n]"/>
                <!--<xsl:when test="$all_field_elements_map//*[@niemelementname = $n]"/>-->
                <xsl:when test="@substgrpname and $all_field_elements_map//*[@substgrpname = $s]"/>
                <xsl:when test="name()='Choice'">
                    <xs:element name="{@substgrpname}">
                        <xsl:attribute name="abstract">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                    <xsl:for-each select="Element">
                                        <xsl:sort select="@niemelementname"/>
                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:when>
                <xsl:otherwise>
                    <xs:element name="{@niemelementname}" type="{$t}" nillable="true">
                        <xsl:if test="@substitutiongroup">
                            <xsl:attribute name="substitutionGroup">
                                <xsl:value-of select="@substitutiongroup"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:value-of select="@niemelementdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <xsl:for-each select="appinfo/*">
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
        <xsl:for-each select="$niem_composites_map//Sequence/Element[starts-with(@mtftype, 'c:')]">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n" select="@niemelementname"/>
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
            <xs:complexType name="{@niemtype}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xs:appinfo>
                </xs:annotation>
                <xs:complexContent>
                    <xs:extension base="structures:ObjectType">
                        <xs:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xs:element ref="{@niemelementname}"/>
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
                <xsl:if test="@substitutiongroup">
                    <xsl:attribute name="substitutionGroup">
                        <xsl:value-of select="@substitutiongroup"/>
                    </xsl:attribute>
                </xsl:if>
                <xs:annotation>
                    <xs:documentation>
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
                        <xsl:for-each select="appinfo/*">
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
            <xsl:if test="not(preceding-sibling::*:element/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_composites_map">
        <xsl:for-each select="$all_composite_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:if test="string-length(@niemtype)&gt;0 and name()='Composite'">
                <xsl:variable name="n" select="@niemelementname"/>
                <xsl:variable name="t" select="@niemtype"/>
                <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$all_composite_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:if test="string-length(@niemtype)&gt;0 and name()='Element'">
                <xsl:variable name="n" select="@niemelementname"/>
                <xsl:variable name="t" select="@niemtype"/>
                <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--    OUTPUT RESULT-->
    <xsl:template name="main">
        <xsl:result-document href="{$compositeoutputdoc}">
            <xs:schema xmlns="urn:mtf:mil:6040b:niem:mtf"
                xmlns:ism="urn:us:gov:ic:ism"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
                xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/"
                xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument"
                xml:lang="en-US"
                elementFormDefault="unqualified"
                attributeFormDefault="unqualified"
                version="1.0">
                <xs:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/structures/4.0/"
                    schemaLocation="ext/niem/utility/structures/4.0/structures.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/localTerminology/3.0/"
                    schemaLocation="./localTerminology.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/appinfo/4.0/"
                    schemaLocation="ext/niem/utility/appinfo/4.0/appinfo.xsd"/>
                <xs:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="./mtfappinfo.xsd"/>
                <xs:annotation>
                    <xs:documentation>
                        <xsl:text>Composite fields for MTF Composite Fields</xsl:text>
                    </xs:documentation>
                </xs:annotation>
                <xsl:copy-of select="$mtf_composites_xsd" copy-namespaces="no"/>
            </xs:schema>
        </xsl:result-document>
        <xsl:result-document href="{$compositemapoutputdoc}">
            <Composites>
                <xsl:copy-of select="$mtf_composites_map" copy-namespaces="no"/>
            </Composites>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="cmp_nodes">
        <xs:annotation>
            <xs:documentation>
                <xsl:text>Composite fields for MTF Messages</xsl:text>
            </xs:documentation>
        </xs:annotation>
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
    </xsl:template>

</xsl:stylesheet>
