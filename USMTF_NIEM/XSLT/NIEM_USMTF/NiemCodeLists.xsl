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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
    xmlns:ism="urn:us:gov:ic:ism" xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!--<xsl:include href="USMTF_Utility.xsl"/>-->
    
    <xsl:variable name="enumerations_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')/*:schema//*:simpleType[*:restriction[@base = 'xsd:string'][*:enumeration]]"/>
    <xsl:variable name="sdir" select="'../../XSD/'"/>
    <xsl:variable name="cfld_changes" select="document(concat($sdir, 'Refactor_Changes/FieldChanges.xml'))/FieldChanges"/>
    <xsl:variable name="norm_enum_types" select="document(concat($sdir, 'Refactor_Changes/M201804C0IF-EnumerationSimpleTypes.xml'))/EnumerationTypes"/>
    <xsl:variable name="norm_enums" select="document(concat($sdir, 'Refactor_Changes/M201804C0IF-Enumerations.xml'))/Enumerations"/>
    <!--Output-->
    <xsl:variable name="codelistout" select="'../../XSD/Analysis/Maps/CodeLists.xml'"/>
    <xsl:variable name="codelistxsdout" select="'../../XSD/Analysis/Normalized/CodeLists.xsd'"/>
    <!--Map Original Enumerated SimpleTypes to an XML fragment-->
    <xsl:variable name="codelists">
        <xsl:for-each select="$enumerations_xsd">
            <xsl:sort select="@name"/>
            <xsl:variable name="mtfname" select="@name"/>
            <xsl:variable name="ffirn">
                <xsl:value-of select="*:annotation/*:appinfo/*:FieldFormatIndexReferenceNumber"/>
            </xsl:variable>
            <xsl:variable name="fud">
                <xsl:value-of select="*:annotation/*:appinfo/*:FudNumber"/>
            </xsl:variable>
            <xsl:variable name="changeto" select="$cfld_changes/CodeList[@name = $mtfname]/@changeto"/>
            <xsl:variable name="etype" select="$norm_enum_types/EnumerationType[@ffirn = $ffirn][@fud = $fud]"/>
            <xsl:variable name="n">
                <xsl:choose>
                    <xsl:when test="$cfld_changes/CodeList[@name = $mtfname]/@changeto">
                        <xsl:value-of select="$changeto"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="@name" mode="fromtype"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemelementname">
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
                    <xsl:when test="ends-with($n, 'Code')">
                        <xsl:value-of select="$n"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($n, 'Code')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemsimpletype">
                <xsl:choose>
                    <xsl:when test="$etype/@niemname">
                        <xsl:value-of select="$etype/@niemname"/>
                    </xsl:when>
                    <xsl:when test="$cfld_changes/CodeList/@name = $n">
                        <xsl:value-of select="concat(substring($changeto, 0, string-length($changeto) - 3), 'CodeSimpleType')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($niemelementname, 'TypeType')">
                        <xsl:value-of select="concat(substring($niemelementname, 0, string-length($niemelementname) - 6), 'CodeSimpleType')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($niemelementname, 'Type')">
                        <xsl:value-of select="concat(substring($niemelementname, 0, string-length($niemelementname) - 3), 'CodeSimpleType')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($niemelementname, 'Code')">
                        <xsl:value-of select="concat($niemelementname, 'SimpleType')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($niemelementname, 'CodeSimpleType')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemcomplextype">
                <xsl:choose>
                    <xsl:when test="$cfld_changes/CodeList/@name = $n">
                        <xsl:value-of select="concat(substring($changeto, 0, string-length($changeto) - 3), 'CodeType')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($niemelementname, 'Type')">
                        <xsl:value-of select="concat(substring($niemelementname, 0, string-length($niemelementname) - 3), 'CodeType')"/>
                    </xsl:when>
                    <xsl:when test="ends-with($niemelementname, 'Code')">
                        <xsl:value-of select="concat($niemelementname, 'Type')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($niemelementname, 'CodeType')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="doc">
                <xsl:apply-templates select="*:annotation/*:documentation"/>
            </xsl:variable>
            <xsl:variable name="niemtypedoc">
                <xsl:choose>
                    <xsl:when test="$cfld_changes/CodeList[@name = $n]">
                        <xsl:value-of select="$cfld_changes/CodeList[@name = $n]/@doc"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$doc"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemelementdoc">
                <xsl:value-of select="replace($niemtypedoc, 'A data type', 'A data item')"/>
            </xsl:variable>
            <xsl:variable name="fappinfo">
                <xsl:apply-templates select="*:annotation/*:appinfo"/>
            </xsl:variable>
            <Field niemelementname="{$niemelementname}" niemsimpletype="{$niemsimpletype}" niemtype="{$niemcomplextype}" niemtypedoc="{$niemtypedoc}" niemelementdoc="{$niemelementdoc}"
                mtftype="{@name}" ffirn="{$ffirn}" fud="{$fud}">

                <xsl:for-each select="$fappinfo">
                    <xsl:copy-of select="$fappinfo" copy-namespaces="no"/>
                </xsl:for-each>

                <Codes>
                    <xsl:for-each select="*:restriction/*:enumeration">
                        <xsl:sort select="@value"/>
                        <Code value="{@value}" dataItem="{*:annotation/*:appinfo/*:DataItem}" doc="{normalize-space(*:annotation/*:documentation/text())}"/>
                    </xsl:for-each>
                </Codes>
            </Field>
        </xsl:for-each>
    </xsl:variable>

    <!--  <xsl:variable name="normcodelisttypes">
        <xsl:for-each select="$cfld_changes/CodeList">
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="ch" select="@changeto"/>
            <xsl:if test="not(preceding-sibling::CodeList[1]/@changeto = $ch)">
                <xsl:variable name="codes" select="$codelists/CodeList[@name = $n][1]/Codes"/>
                <xsl:variable name="stype" select="concat(substring($ch, 0, string-length($ch) - 3), 'CodeSimpleType')"/>
                <xsl:variable name="ctype" select="concat(substring($ch, 0, string-length($ch) - 3), 'CodeType')"/>
                <xsl:variable name="el" select="concat(substring($n, 0, string-length($n) - 3), 'Code')"/>
                <xs:simpleType name="{$stype}">
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:value-of select="@doc"/>
                        </xs:documentation>
                        <xs:appinfo>
                            <xsl:for-each select="appinfo/*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xs:appinfo>
                    </xs:annotation>
                    <xs:restriction base="xs:string">
                        <xsl:for-each select="$codes/Code">
                            <xs:enumeration value="{@value}">
                                <xs:annotation>
                                    <xs:documentation>
                                        <xsl:value-of select="@doc"/>
                                    </xs:documentation>
                                    <xs:appinfo>
                                        <Code dataItem="{@dataItem}"/>
                                    </xs:appinfo>
                                </xs:annotation>
                            </xs:enumeration>
                        </xsl:for-each>
                    </xs:restriction>
                </xs:simpleType>
                <xs:complexType name="{$ctype}">
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:value-of select="@doc"/>
                        </xs:documentation>
                        <xs:appinfo>
                            <xsl:for-each select="appinfo/*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xs:appinfo>
                    </xs:annotation>
                    <xs:simpleContent>
                        <xs:extension base="{$stype}">
                            <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                        </xs:extension>
                    </xs:simpleContent>
                </xs:complexType>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
-->
    <xsl:variable name="codelisttypes">
        <xsl:for-each select="$codelists/*">
            <xsl:variable name="n" select="@niemelementname"/>
            <xsl:variable name="codes" select="Codes"/>
            <xs:simpleType name="{@niemsimpletype}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xs:documentation>
                    <xsl:if test="*:appinfo/*">
                        <xs:appinfo>
                            <xsl:for-each select="*:appinfo/*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xs:appinfo>
                    </xsl:if>
                </xs:annotation>
                <xs:restriction base="xs:string">
                    <xsl:for-each select="$codes/Code">
                        <xs:enumeration value="{@value}">
                            <xs:annotation>
                                <xs:documentation>
                                    <xsl:value-of select="@doc"/>
                                </xs:documentation>
                            </xs:annotation>
                        </xs:enumeration>
                    </xsl:for-each>
                </xs:restriction>
            </xs:simpleType>
            <xs:complexType name="{@niemtype}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:for-each select="*:appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xs:appinfo>
                </xs:annotation>
                <xs:simpleContent>
                    <xs:extension base="{@niemsimpletype}">
                        <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                    </xs:extension>
                </xs:simpleContent>
            </xs:complexType>
        </xsl:for-each>
        <xsl:apply-templates select="$norm_enum_types/*" mode="makeCodeSimpleType"/>
    </xsl:variable>

    <xsl:variable name="codelistxsd">
        <xsl:for-each select="$codelisttypes/*:simpleType">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$codelisttypes/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$codelisttypes/*:element">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <!--Create SimpleType from Normalized SimpleTypes -->
    <xsl:template match="*" mode="makeCodeSimpleType">
        <xsl:variable name="n" select="translate(@niemname, ',()', '')"/>
        <xsl:choose>
            <xsl:when test="$n = ''"/>
            <xsl:when test="$n = '.'"/>
            <xsl:otherwise>
                <xs:simpleType name="{$n}">
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:value-of select="@comment"/>
                        </xs:documentation>
                        <xs:appinfo>
                            <mtfappinfo:SimpleType>
                                <xsl:apply-templates select="@*[name() != 'fudexp']" mode="copy"/>
                            </mtfappinfo:SimpleType>
                        </xs:appinfo>
                    </xs:annotation>
                    <xs:restriction base="xs:string">
                        <xsl:apply-templates select="$norm_enums/Enumeration[@niemtype = $n]" mode="enum">
                            <xsl:sort select="@seq"/>
                        </xsl:apply-templates>
                    </xs:restriction>
                </xs:simpleType>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- <xsl:template match="@*" mode="copy">
        <xsl:if test=". != '.'">
            <xsl:attribute name="{name()}">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>-->

    <xsl:template match="*" mode="enum">
        <xs:enumeration value="{@datacode}">
            <xs:annotation>
                <xs:documentation>
                    <xsl:value-of select="@doc"/>
                </xs:documentation>
            </xs:annotation>
        </xs:enumeration>
    </xsl:template>

    <xsl:template name="codelistmain">
        <xsl:result-document href="{$codelistxsdout}">
            <xs:schema xmlns="urn:mtf:mil:6040b:niem:mtf:fields" xmlns:ism="urn:us:gov:ic:ism" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/" xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
                xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/" xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" targetNamespace="urn:mtf:mil:6040b:niem:mtf:fields"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xs:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../NIEM/structures.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../NIEM/localTerminology.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../NIEM/appinfo.xsd"/>
                <xs:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NIEM/mtfappinfo.xsd"/>
                <xs:annotation>
                    <xs:documentation>
                        <xsl:text>Code Lists for MTF Messages</xsl:text>
                    </xs:documentation>
                </xs:annotation>
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
                <xsl:for-each select="$codelistxsd/*:element">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xs:schema>
        </xsl:result-document>
        <xsl:result-document href="{$codelistout}">
            <CodeLists>
                <xsl:copy-of select="$codelists"/>
            </CodeLists>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
