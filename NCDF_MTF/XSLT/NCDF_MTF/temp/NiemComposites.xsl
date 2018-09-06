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

    <xsl:variable name="composites_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/composites.xsd')"/>
    <xsl:variable name="fieldmap" select="document('../../XSD/NCDF_MTF_1_NS/NCDF_MTF_Fieldmaps.xml')"/>
    <xsl:variable name="comp_changes" select="document('../../XSD/Refactor_Changes_1_NS/CompositeChanges.xml')"/>

    <!--Output-->
    <xsl:variable name="compositeoutputdoc" select="'../../XSD/NCDF_MTF_1_NS/NCDF_MTF_Composites.xsd'"/>
    <xsl:variable name="compositemapoutputdoc" select="'../../XSD/NCDF_MTF_1_NS/NCDF_MTF_Compositemaps.xml'"/>

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
            <xsl:variable name="ncdfname">
                <xsl:choose>
                    <xsl:when test="$change/@ncdfelementname">
                        <xsl:value-of select="$change/@ncdfelementname"/>
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
                        <xsl:value-of select="concat($n, 'Text')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ncdfcomplextype">
                <xsl:value-of select="concat($ncdfname, 'Type')"/>
            </xsl:variable>
            <xsl:variable name="ncdfelementname">
                <xsl:value-of select="$n"/>
            </xsl:variable>
            <xsl:variable name="mtfdoc">
                <xsl:value-of select="$annot/*/xsd:documentation"/>
            </xsl:variable>
            <xsl:variable name="ncdftypedoc">
                <xsl:choose>
                    <xsl:when test="$change/@ncdftypedoc">
                        <xsl:value-of select="$change/@ncdftypedoc"/>
                    </xsl:when>
                    <xsl:when test="$change/@ncdftypedoc">
                        <xsl:value-of select="$change/@ncdftypedoc"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$annot/*/xsd:documentation"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ncdfelementdoc">
                <xsl:choose>
                    <xsl:when test="$change/@ncdftypedoc">
                        <xsl:value-of select="replace($change/@ncdftypedoc, 'A data type', 'A data item')"/>
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
                        <xsl:attribute name="ncdfelementname">
                            <xsl:value-of select="$n"/>
                        </xsl:attribute>
                        <xsl:attribute name="ncdfelementtype">
                            <xsl:choose>
                                <xsl:when test="$n = 'BlankSpace'">
                                    <xsl:text>BlankSpaceTextType</xsl:text>
                                </xsl:when>
                                <xsl:when test="starts-with(@type, 'f:')">
                                    <xsl:value-of select="$fieldmap/Fields/*[@mtfname = $t]/@ncdfcomplextype"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$t"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="ncdfelementdoc">
                            <xsl:choose>
                                <xsl:when test="$n = 'BlankSpace'">
                                    <xsl:text>A data type for a blank space character that is used to separate elements within a data chain, or to mark the beginning or end of a unit of data.</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$fieldmap/Fields/*[@mtfname = $t]/@ncdfelementdoc"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="seq">
                            <xsl:value-of select="xsd:annotation/xsd:appinfo/*:ElementalFfirnFudnSequence"/>
                        </xsl:attribute>
                    </Element>
                </xsl:for-each>
            </xsl:variable>
            <Composite mtfname="{@name}" ncdfcomplextype="{$ncdfcomplextype}" ncdfname="{$ncdfname}" ncdfelementname="{$ncdfelementname}" ncdfelementdoc="{$ncdfelementdoc}" mtfdoc="{$mtfdoc}"
                ncdftypedoc="{$ncdftypedoc}">
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
            <xsl:sort select="@ncdfelementname"/>
            <xsl:variable name="n" select="@ncdfelementname"/>
            <xsl:choose>
                <xsl:when test="@ncdfelementname">
                    <xsd:element name="{@ncdfelementname}">
                        <xsl:attribute name="type">
                            <xsl:value-of select="@ncdfelementtype"/>
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
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="compositexsd">
        <xsl:for-each select="$compositemaps/Composite">
            <xsl:sort select="@ncdfcomplextype"/>
            <xsd:complexType name="{@ncdfcomplextype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@ncdftypedoc"/>
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
                                    <xsl:value-of select="@ncdfelementname"/>
                                </xsl:variable>
                                <xsd:element ref="{$refname}"/>
                            </xsl:for-each>
                            <xsd:element ref="{concat(substring(@ncdfcomplextype,0,string-length(@ncdfcomplextype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{concat(substring(@ncdfcomplextype,0,string-length(@ncdfcomplextype)-3),'AugmentationPoint')}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @ncdfcomplextype)"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="{@ncdfelementname}" type="{@ncdfcomplextype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:choose>
                            <xsl:when test="@ncdfelementname = 'BlankSpace'">
                                <xsl:text>A data item for a blank space character that is used to separate elements within a data chain, or to mark the beginning or end of a unit of data.</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@ncdfelementdoc"/>
                            </xsl:otherwise>
                        </xsl:choose>
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
            <xsd:schema xmlns="urn:mtf:mil:6040b:ncdf:mtf" 
                xmlns:ism="urn:us:gov:ic:ism" 
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                xmlns:ct="http://release.ncdf.gov/ncdf/conformanceTargets/3.0/"
                xmlns:structures="http://release.ncdf.gov/ncdf/structures/4.0/" 
                xmlns:term="http://release.ncdf.gov/ncdf/localTerminology/3.0/"
                xmlns:appinfo="http://release.ncdf.gov/ncdf/appinfo/4.0/" 
                xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" 
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:ncdf:mtf" 
                ct:conformanceTargets="http://reference.ncdf.gov/ncdf/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" 
                xml:lang="en-US"
                elementFormDefault="unqualified" 
                attributeFormDefault="unqualified" 
                version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/structures/4.0/" schemaLocation="../NCDF/structures.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/localTerminology/3.0/" schemaLocation="../NCDF/localTerminology.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/appinfo/4.0/" schemaLocation="../NCDF/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NCDF/mtfappinfo.xsd"/>
                <xsd:include schemaLocation="NCDF_MTF_Fields.xsd"/>
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
    <xsl:template name="cmp_nodes">
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
    </xsl:template>

</xsl:stylesheet>