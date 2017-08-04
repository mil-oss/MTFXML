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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="USMTF_Utility.xsl"/>

    <xsl:variable name="composites_xsd" select="document('../../XSD/Baseline_Schema/composites.xsd')"/>
    <xsl:variable name="fieldmap" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Fieldmaps.xml')"/>
    <xsl:variable name="comp_changes" select="document('../../XSD/Refactor_Changes/CompositeChanges.xml')"/>

    <!--Output-->
    <xsl:variable name="compositeoutputdoc" select="'../../XSD/NIEM_MTF/NIEM_MTF_Composites.xsd'"/>
    <xsl:variable name="compositemapoutputdoc" select="'../../XSD/NIEM_MTF/NIEM_MTF_Compositemaps.xml'"/>

    <xsl:variable name="compositemaps">
        <xsl:for-each select="$composites_xsd/xsd:schema/xsd:complexType">
            <xsl:variable name="annot">
                <xsl:apply-templates select="xsd:annotation"/>
            </xsl:variable>
            <xsl:variable name="mtfname" select="@name"/>
            <xsl:variable name="change" select="$comp_changes/CompositeTypeChanges/String[@name = $mtfname]"/>
            <xsl:variable name="n">
                <xsl:apply-templates select="@name" mode="fromtype"/>
            </xsl:variable>
            <xsl:variable name="niemname">
                <xsl:choose>
                    <xsl:when test="$change/@niemelementname">
                        <xsl:value-of select="$change/@niemelementname"/>
                    </xsl:when>
                    <xsl:when test="ends-with($n, 'Code')">
                        <xsl:value-of select="replace($n, 'Code', 'Text')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($n, 'Indicator')">
                        <xsl:value-of select="replace($n, 'Indicator', 'Text')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($n, 'Number')">
                        <xsl:value-of select="replace($n, 'Number', 'Numeric')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($n,'Text')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemcomplextype">
                <xsl:value-of select="concat($niemname, 'Type')"/>
            </xsl:variable>
            <xsl:variable name="niemelementname">
                <xsl:value-of select="$n"/>
                <!--<xsl:choose>
                    <xsl:when test="$change/@niemelementname">
                        <xsl:value-of select="$change/@niemelementname"/>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:value-of select="$n"/>
                    </xsl:otherwise>
                </xsl:choose>-->
            </xsl:variable>
            <xsl:variable name="mtfdoc">
                <xsl:value-of select="$annot/*/xsd:documentation"/>
            </xsl:variable>
            <xsl:variable name="niemtypedoc">
                <xsl:choose>
                    <xsl:when test="$change/@niemtypedoc">
                        <xsl:value-of select="$change/@niemtypedoc"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$annot/*/xsd:documentation"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemelementdoc">
                <xsl:choose>
                    <xsl:when test="$change/@niemtypedoc">
                        <xsl:value-of select="replace($change/@niemtypedoc, 'A data type', 'A data item')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace($mtfdoc, 'A data type', 'A data item')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="annot">
                <xsl:apply-templates select="xsd:annotation"/>
            </xsl:variable>
            <xsl:variable name="appinfo">
                <xsl:for-each select="$annot/*/xsd:appinfo">
                    <mtfappinfo:Composite>
                        <xsl:for-each select="*:Field/@*">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </mtfappinfo:Composite> 
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="seq_fields">
                <xsl:for-each select="xsd:sequence/xsd:element">
                    <xsl:variable name="n">
                        <xsl:apply-templates select="@name" mode="txt"/>
                    </xsl:variable>
                    <xsl:variable name="t">
                        <xsl:choose>
                            <xsl:when test="contains(@type, ':')">
                                <xsl:value-of select="substring-after(@type, ':')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@type"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <Element>
                        <xsl:attribute name="mtfelementname">
                            <xsl:value-of select="$n"/>
                        </xsl:attribute>
                        <xsl:attribute name="mtfelementtype">
                            <xsl:value-of select="@type"/>
                        </xsl:attribute>
                        <xsl:attribute name="niemelementname">
                            <xsl:value-of select="$n"/>
                            <!--<xsl:choose>
                                <xsl:when test="contains(@name,'_')">
                                    <xsl:value-of select="substring-before(@name,'_')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@name"/>
                                </xsl:otherwise>
                            </xsl:choose>-->
                        </xsl:attribute>
                        <xsl:attribute name="niemelementtype">
                            <xsl:choose>
                                <xsl:when test="$n='BlankSpace'">
                                    <xsl:text>f:BlankSpaceTextType</xsl:text>
                                    <!--<xsl:value-of select="$fieldmap/Fields/*[@mtfname = $t]/@niemcomplextype"/>-->
                                </xsl:when>
                                <xsl:when test="starts-with(@type, 'f:')">
                                    <xsl:value-of select="concat('f:', $fieldmap/Fields/*[@mtfname = $t]/@niemcomplextype)"/>
                                    <!--<xsl:value-of select="$fieldmap/Fields/*[@mtfname = $t]/@niemcomplextype"/>-->
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$t"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="niemelementdoc">
                                <xsl:value-of select="$fieldmap/Fields/*[@mtfname = $t]/@niemelementdoc"/>
                                <!--<xsl:value-of select="$fieldmap/Fields/*[@mtfname = $t]/@niemcomplextype"/>-->
                        </xsl:attribute>
                        <xsl:attribute name="seq">
                            <xsl:value-of select="xsd:annotation/xsd:appinfo/*:ElementalFfirnFudnSequence"/>
                        </xsl:attribute>
                    </Element>
                </xsl:for-each>
            </xsl:variable>
            <Composite mtfname="{@name}" niemcomplextype="{$niemcomplextype}" niemname="{$niemname}" niemelementname="{$niemelementname}" niemelementdoc="{$niemelementdoc}" mtfdoc="{$mtfdoc}" niemtypedoc="{$niemtypedoc}">
                <appinfo>
                    <xsl:for-each select="$appinfo">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </appinfo>
                <Sequence>
                    <xsl:for-each select="$seq_fields">
                        <xsl:copy-of select="Element"/>
                    </xsl:for-each>
                </Sequence>
            </Composite>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="compositefields">
        <xsl:for-each select="$compositemaps//Sequence/Element">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsl:choose>
                <xsl:when test="@niemelementname">
                    <xsd:element name="{@niemelementname}">
                        <xsl:attribute name="type">
                            <xsl:value-of select="@niemelementtype"/>
                            <!--<xsl:choose>
                                <xsl:when test="contains(@mtftype, ':')">
                                    <xsl:value-of select="concat(substring-before(@mtftype, ':'), ':', @niemtype)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@niemelementtype"/>
                                </xsl:otherwise>
                            </xsl:choose>-->
                        </xsl:attribute>
                        <xsl:attribute name="nillable">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xsd:annotation>
                            <xsd:documentation>
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
                            </xsd:documentation>
                            <xsl:for-each select="appinfo/*">
                                <xsd:appinfo>
                                    <xsl:copy-of select="."/>
                                </xsd:appinfo>
                            </xsl:for-each>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="compositexsd">
        <xsl:for-each select="$compositemaps/Composite">
            <xsl:sort select="@niemcomplextype"/>
            <xsd:complexType name="{@niemcomplextype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="structures:ObjectType">
                        <xsd:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="refname">
                                    <!--<xsl:choose>
                                        <xsl:when test="starts-with(@niemelementtype, 'f:')">
                                            <xsl:value-of select="concat('f:', @niemelementname)"/>
                                            <!-\-<xsl:value-of select="@niemelementname"/>-\->
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@niemelementname"/>
                                        </xsl:otherwise>
                                    </xsl:choose>-->
                                    <xsl:value-of select="@niemelementname"/>
                                </xsl:variable>
                                <xsd:element ref="{$refname}"/>
                            </xsl:for-each>
                            <xsd:element ref="{concat(substring(@niemcomplextype,0,string-length(@niemcomplextype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{concat(substring(@niemcomplextype,0,string-length(@niemcomplextype)-3),'AugmentationPoint')}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @niemcomplextype)"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="{@niemelementname}" type="{@niemcomplextype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemelementdoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:copy-of select="$compositefields"/>
    </xsl:variable>
    
    <!-- _______________________________________________________ -->
    <!--    OUTPUT RESULT-->
    <xsl:template name="main">
        <xsl:result-document href="{$compositeoutputdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:niem:mtf:composites" 
                xmlns:ism="urn:us:gov:ic:ism:v2" 
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/" 
                xmlns:structures="http://release.niem.gov/niem/structures/3.0/"
                xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/" 
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/3.0/" 
                xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" 
                xmlns:f="urn:mtf:mil:6040b:niem:mtf:fields" 
                targetNamespace="urn:mtf:mil:6040b:niem:mtf:composites"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/3.0/" schemaLocation="../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/3.0/" schemaLocation="../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NIEM/mtfappinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:niem:mtf:fields" schemaLocation="NIEM_MTF_Fields.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Composite fields for MTF Messages</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:for-each select="$compositexsd/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$compositexsd/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::xsd:element/@name = $n)">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$compositemapoutputdoc}">
            <Composites>
                <xsl:for-each select="$compositemaps">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </Composites>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
