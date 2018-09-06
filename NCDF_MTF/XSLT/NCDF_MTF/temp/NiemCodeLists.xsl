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
    xmlns:ism="urn:us:gov:ic:ism" xmlns:appinfo="http://release.ncdf.gov/ncdf/appinfo/4.0/" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo"
    exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!--<xsl:include href="../USMTF_NCDF/USMTF_Utility.xsl"/>-->

    <xsl:variable name="enumerations_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/fields.xsd')/xsd:schema//xsd:simpleType[xsd:restriction[@base = 'xsd:string'][xsd:enumeration]]"/>
    <xsl:variable name="codelist_changes" select="document('../../XSD/Refactor_Changes/CodeListChanges.xml')"/>

    <!--Output-->
    <xsl:variable name="codelistout" select="'../../XSD/Analysis/NCDF_CodeLists.xml'"/>
    <xsl:variable name="codelistxsdout" select="'../../XSD/Normalized/CodeLists.xsd'"/>

    <xsl:variable name="codelists">
        <xsl:for-each select="$enumerations_xsd">
            <xsl:sort select="@name"/>
            <xsl:variable name="mtfname" select="@name"/>
            <xsl:variable name="changeto" select="$codelist_changes/CodeListTypeChanges/CodeList[@name = $mtfname]/@changeto"/>
            <xsl:variable name="n">
                <xsl:choose>
                    <xsl:when test="$codelist_changes/CodeListTypeChanges/CodeList[@name = $mtfname]/@changeto">
                        <xsl:value-of select="$changeto"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="@name" mode="fromtype"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ncdfelementname">
                <xsl:choose>
                    <xsl:when test="$mtfname = 'WaterTypeType'">
                        <xsl:text>WaterCategoryCode</xsl:text>
                    </xsl:when>
                    <xsl:when test="$mtfname = 'MissionStatusType'">
                        <xsl:text>StatusOfMissionCode</xsl:text>
                    </xsl:when>
                    <xsl:when test="$mtfname = 'TargetCategoryCodeType'">
                        <xsl:text>TargetNumberCode</xsl:text>
                    </xsl:when>
                    <xsl:when test="$mtfname = 'IndicatorOnOrOffType'">
                        <xsl:text>OnOffUnknownCode</xsl:text>
                    </xsl:when>
                    <xsl:when test="ends-with($n, 'Indicator')">
                        <xsl:value-of select="replace($n, 'Indicator', 'Code')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($n, 'Code')">
                        <xsl:value-of select="$n"/>
                    </xsl:when>
                    <xsl:when test="ends-with($n, 'CodeType')">
                        <xsl:value-of select="substring($n, 0, string-length($n) - 3)"/>
                    </xsl:when>
                    <xsl:when test="ends-with($n, 'Type')">
                        <xsl:value-of select="concat(substring($n, 0, string-length($n) - 3),'Code')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($n, 'Code')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ncdfsimpletype">
                <xsl:choose>
                    <xsl:when test="$codelist_changes/CodeListTypeChanges/CodeList/@name = $n">
                        <xsl:value-of select="concat(substring($changeto, 0, string-length($changeto) - 3), 'CodeSimpleType')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($ncdfelementname,'TypeType')">
                        <xsl:value-of select="concat(substring($ncdfelementname, 0, string-length($ncdfelementname) - 6), 'CodeSimpleType')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($ncdfelementname,'Type')">
                        <xsl:value-of select="concat(substring($ncdfelementname, 0, string-length($ncdfelementname) - 3), 'CodeSimpleType')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($ncdfelementname,'Code')">
                        <xsl:value-of select="concat($ncdfelementname, 'SimpleType')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($ncdfelementname, 'CodeSimpleType')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ncdfcomplextype">
                <xsl:choose>
                    <xsl:when test="$codelist_changes/CodeListTypeChanges/CodeList/@name = $n">
                        <xsl:value-of select="concat(substring($changeto, 0, string-length($changeto) - 3), 'CodeType')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($ncdfelementname,'Type')">
                        <xsl:value-of select="concat(substring($ncdfelementname, 0, string-length($ncdfelementname) - 3), 'CodeType')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($ncdfelementname,'Code')">
                        <xsl:value-of select="concat($ncdfelementname, 'Type')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($ncdfelementname, 'CodeType')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="doc">
                <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
            </xsl:variable>
            <xsl:variable name="ncdftypedoc">
                <xsl:choose>
                    <xsl:when test="$codelist_changes/CodeListTypeChanges/CodeList[@name = $n]">
                        <xsl:value-of select="$codelist_changes/CodeListTypeChanges/CodeList[@name = $n]/@doc"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$doc"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ncdfelementdoc">
                <xsl:value-of select="replace($ncdftypedoc, 'A data type','A data item')"/>
            </xsl:variable>
            <xsl:variable name="ffirn" select="xsd:annotation/xsd:appinfo/*:FieldFormatIndexReferenceNumber"/>
            <xsl:variable name="fud" select="xsd:annotation/xsd:appinfo/*:FudNumber"/>
            <xsl:variable name="appinfo">
                <xsl:apply-templates select="xsd:annotation/xsd:appinfo"/>
            </xsl:variable>
            <CodeList mtfname="{@name}" ncdfsimpletype="{$ncdfsimpletype}" ncdfcomplextype="{$ncdfcomplextype}" ncdfelementname="{$ncdfelementname}" ncdftypedoc="{$ncdftypedoc}"
                ncdfelementdoc="{$ncdfelementdoc}" ffirn="{$ffirn}" fud="{$fud}">
                <appinfo>
                    <xsl:for-each select="$appinfo/*">
                        <xsl:copy-of select="mtfappinfo:Field" copy-namespaces="no"/>
                    </xsl:for-each>
                </appinfo>
                <Codes>
                    <xsl:for-each select="xsd:restriction/xsd:enumeration">
                        <xsl:sort select="@value"/>
                        <Code value="{@value}" dataItem="{xsd:annotation/xsd:appinfo/*:DataItem}" doc="{normalize-space(xsd:annotation/xsd:documentation/text())}"/>
                    </xsl:for-each>
                </Codes>
            </CodeList>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="normcodelisttypes">
        <xsl:for-each select="$codelist_changes/CodeListTypeChanges/CodeList">
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="ch" select="@changeto"/>
            <xsl:if test="not(preceding-sibling::CodeList[1]/@changeto = $ch)">
                <xsl:variable name="codes" select="$codelists/CodeList[@name = $n][1]/Codes"/>
                <xsl:variable name="stype" select="concat(substring($ch, 0, string-length($ch) - 3), 'CodeSimpleType')"/>
                <xsl:variable name="ctype" select="concat(substring($ch, 0, string-length($ch) - 3), 'CodeType')"/>
                <xsl:variable name="el" select="concat(substring($n, 0, string-length($n) - 3), 'Code')"/>
                <xsd:simpleType name="{$stype}">
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="@doc"/>
                        </xsd:documentation>
                        <xsd:appinfo>
                            <xsl:for-each select="appinfo/*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsd:appinfo>
                    </xsd:annotation>
                    <xsd:restriction base="xsd:string">
                        <xsl:for-each select="$codes/Code">
                            <xsd:enumeration value="{@value}">
                                <xsd:annotation>
                                    <xsd:documentation>
                                        <xsl:value-of select="@doc"/>
                                    </xsd:documentation>
                                    <xsd:appinfo>
                                        <Code dataItem="{@dataItem}"/>
                                    </xsd:appinfo>
                                </xsd:annotation>
                            </xsd:enumeration>
                        </xsl:for-each>
                    </xsd:restriction>
                </xsd:simpleType>
                <xsd:complexType name="{$ctype}">
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="@doc"/>
                        </xsd:documentation>
                        <xsd:appinfo>
                            <xsl:for-each select="appinfo/*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsd:appinfo>
                    </xsd:annotation>
                    <xsd:simpleContent>
                        <xsd:extension base="{$stype}">
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                            <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                        </xsd:extension>
                    </xsd:simpleContent>
                </xsd:complexType>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="codelisttypes">
        <xsl:for-each select="$codelists/*">
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="codes" select="Codes"/>
            <xsl:choose>
                <!-- If codelist has normalized type, create simpleType and complexType only-->
                <xsl:when test="@changeto">
                    <xsd:simpleType name="{@ncdfsimpletype}">
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
                        <xsd:restriction base="xsd:string">
                            <xsl:for-each select="$codes/Code">
                                <xsd:enumeration value="{@value}">
                                    <xsd:annotation>
                                        <xsd:documentation>
                                            <xsl:value-of select="@doc"/>
                                        </xsd:documentation>
                                        <xsd:appinfo>
                                            <Code dataItem="{@dataItem}"/>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                </xsd:enumeration>
                            </xsl:for-each>
                        </xsd:restriction>
                    </xsd:simpleType>
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
                        <xsd:simpleContent>
                            <xsd:extension base="{@ncdfsimpletype}">
                                <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                            </xsd:extension>
                        </xsd:simpleContent>
                    </xsd:complexType>
                </xsl:when>
                <!-- Otherwise, create simpleType if not already in normalized types,complexType-->
                <xsl:otherwise>
                    <xsl:if test="not($normcodelisttypes/xsd:simpleType[@name = @ncdfsimpletype])">
                        <xsd:simpleType name="{@ncdfsimpletype}">
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
                            <xsd:restriction base="xsd:string">
                                <xsl:for-each select="$codes/Code">
                                    <xsd:enumeration value="{@value}">
                                        <xsd:annotation>
                                            <xsd:documentation>
                                                <xsl:value-of select="@doc"/>
                                            </xsd:documentation>
                                        </xsd:annotation>
                                    </xsd:enumeration>
                                </xsl:for-each>
                            </xsd:restriction>
                        </xsd:simpleType>
                    </xsl:if>
                    <xsl:if test="not($normcodelisttypes/xsd:complexType[@name = @ncdfcomplextype])">
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
                            <xsd:simpleContent>
                                <xsd:extension base="{@ncdfsimpletype}">
                                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                    <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                                </xsd:extension>
                            </xsd:simpleContent>
                        </xsd:complexType>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsd:element name="{@ncdfelementname}" type="{@ncdfcomplextype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@ncdfelementdoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                    <!--<xsd:appinfo>
                        <mtfappinfo:Field name="{appinfo/Field/@name}" explanation="{appinfo/Field/@explanation}" version="{appinfo/Field/@version}"/>
                    </xsd:appinfo>-->
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="codelistxsd">
        <xsl:for-each select="$codelisttypes/xsd:simpleType">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$codelisttypes/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$codelisttypes/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template name="codelistmain">
        <xsl:result-document href="{$codelistxsdout}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:ncdf:mtf:fields" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:ct="http://release.ncdf.gov/ncdf/conformanceTargets/3.0/" xmlns:structures="http://release.ncdf.gov/ncdf/structures/4.0/"
                xmlns:term="http://release.ncdf.gov/ncdf/localTerminology/3.0/" xmlns:appinfo="http://release.ncdf.gov/ncdf/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" targetNamespace="urn:mtf:mil:6040b:ncdf:mtf:fields"
                ct:conformanceTargets="http://reference.ncdf.gov/ncdf/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/structures/4.0/" schemaLocation="../NCDF/structures.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/localTerminology/3.0/" schemaLocation="../NCDF/localTerminology.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/appinfo/4.0/" schemaLocation="../NCDF/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NCDF/mtfappinfo.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Code Lists for MTF Messages</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:for-each select="$codelistxsd/xsd:simpleType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::xsd:simpleType/@name = $n)">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$codelistxsd/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$codelistxsd/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$codelistout}">
            <CodeLists>
                <xsl:copy-of select="$codelists"/>
            </CodeLists>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>