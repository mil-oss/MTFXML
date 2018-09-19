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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
    xmlns:appinfo="http://release.niem.gov/niem/appinfo/3.0/" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
    exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="USMTF_Utility.xsl"/>

    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="baseline_sets_xsd" select="document('../../XSD/Baseline_Schema/sets.xsd')"/>
    <xsl:variable name="niem_fields_map" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Fieldmaps.xml')/*"/>
    <xsl:variable name="niem_composites_map" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Compositemaps.xml')/*"/>
    <!--Set deconfliction and annotation changes-->
    <xsl:variable name="set_Changes" select="document('../../XSD/Refactor_Changes/SetChanges.xml')/SetChanges"/>
    <xsl:variable name="substGrp_Changes" select="document('../../XSD/Refactor_Changes/SubstitutionGroupChanges.xml')/SubstitionGroups"/>
    <!--Outputs-->
    <xsl:variable name="setmapsoutput" select="'../../XSD/NIEM_MTF/NIEM_MTF_SetMaps.xml'"/>
    <xsl:variable name="setxsdoutputdoc" select="'../../XSD/NIEM_MTF/NIEM_MTF_Sets.xsd'"/>

    <!-- SET XSD MAP-->
    <!-- _______________________________________________________ -->

    <xsl:variable name="setmaps">
        <xsl:apply-templates select="$baseline_sets_xsd/xsd:schema/xsd:complexType" mode="setglobal"/>
    </xsl:variable>
    <xsl:template match="xsd:schema/xsd:complexType" mode="setglobal">
        <xsl:variable name="annot">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="change" select="$set_Changes/Set[@mtfname = $mtfname]"/>
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="fromtype"/>
        </xsl:variable>
        <xsl:variable name="niemelementname">
            <xsl:choose>
                <xsl:when test="$change/@niemelementname">
                    <xsl:value-of select="$change/@niemelementname"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Set')">
                    <xsl:value-of select="$n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($n, 'Set')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemcomplextype">
            <xsl:choose>
                <xsl:when test="$change/@niemcomplextype">
                    <xsl:value-of select="$change/@niemcomplextype"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($niemelementname, 'Type')"/>
                </xsl:otherwise>
            </xsl:choose>
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
                    <xsl:value-of select="replace($niemtypedoc, 'A data type', 'A data item')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*:Set" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <Set mtfname="{@name}" niemcomplextype="{$niemcomplextype}" niemelementname="{$niemelementname}" niemelementdoc="{$niemelementdoc}" mtfdoc="{$mtfdoc}" niemtypedoc="{$niemtypedoc}">
            <appinfo>
                <xsl:for-each select="$appinfo">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </appinfo>
            <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]"/>
        </Set>
    </xsl:template>
    <xsl:template match="xsd:element">
        <xsl:param name="sbstgrp"/>
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="fromtype"/>
        </xsl:variable>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="setname">
            <xsl:value-of select="ancestor::xsd:complexType[@name][1]/@name"/>
        </xsl:variable>
        <xsl:variable name="change" select="$set_Changes/Element[@mtfname = $mtfname][@setname = $setname]"/>
        <xsl:variable name="mtftype">
            <xsl:value-of select="xsd:complexType/*/xsd:extension/@base"/>
        </xsl:variable>
        <xsl:variable name="elchange" select="$set_Changes/Element[@mtfname = $mtfname][@mtftype = $mtftype]"/>
        <xsl:variable name="niemmatch">
            <xsl:choose>
                <xsl:when test="starts-with($mtftype, 'f:')">
                    <xsl:copy-of select="$niem_fields_map/*[@mtfname = substring-after($mtftype, 'f:')]"/>
                </xsl:when>
                <xsl:when test="starts-with($mtftype, 'c:')">
                    <xsl:copy-of select="$niem_composites_map/*[@mtfname = substring-after($mtftype, 'c:')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$baseline_sets_xsd/xsd:schema/xsd:complexType[@name = $mtftype]" mode="setglobal"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelement">
            <xsl:choose>
                <xsl:when test="$elchange/@niemelementname">
                    <xsl:value-of select="$elchange/@niemelementname"/>
                </xsl:when>
                <xsl:when test="string-length($sbstgrp) &gt; 0">
                    <xsl:choose>
                        <xsl:when test="$change/@niemelementname">
                            <xsl:value-of select="$change/@niemelementname"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="niemel" select="$niemmatch/*/@niemelementname"/>
                            <xsl:variable name="subgrp">
                                <xsl:value-of select="substring-before($sbstgrp, 'Choice')"/>
                            </xsl:variable>
                            <xsl:variable name="trimName">
                                <xsl:choose>
                                    <xsl:when test="contains($niemel, $subgrp)">
                                        <xsl:value-of select="replace($niemel, $subgrp, '')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$niemel"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:value-of select="concat($subgrp, $trimName)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfname"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementname">
            <xsl:value-of select="replace($niemelement, 'Indicator', 'Code')"/>
        </xsl:variable>
        <xsl:variable name="ffirnfud">
            <xsl:value-of select="xsd:complexType/*//xsd:attribute[@name = 'ffirnFudn']/@fixed"/>
        </xsl:variable>
        <xsl:variable name="ffirn">
            <xsl:value-of select="substring-before(substring-after($ffirnfud, 'FF'), '-')"/>
        </xsl:variable>
        <xsl:variable name="fud">
            <xsl:value-of select="substring-after(substring-after($ffirnfud, 'FF'), '-')"/>
        </xsl:variable>
        <xsl:variable name="seq">
            <xsl:value-of select="xsd:complexType//xsd:attribute[@name = 'ffSeq'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="annot">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="typeannot">
            <xsl:apply-templates select="xsd:complexType/*/xsd:extension/xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="mtfdoc">
            <xsl:value-of select="$annot/*/xsd:documentation"/>
        </xsl:variable>
        <xsl:variable name="mtftypedoc">
            <xsl:value-of select="$typeannot/*/xsd:documentation"/>
        </xsl:variable>
        <xsl:variable name="niemelementdoc">
            <xsl:choose>
                <xsl:when test="$elchange/@niemelementdoc">
                    <xsl:value-of select="$elchange/@niemelementdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($niemmatch/*/@niemtypedoc, 'A data type', 'A data item')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*:Field" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="typeappinfo">
            <xsl:for-each select="$typeannot/*/xsd:appinfo">
                <xsl:copy-of select="*:Field" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <Element mtfname="{@name}" mtftype="{$mtftype}" setname="{$setname}" niemelementname="{$niemelementname}" niemtype="{$niemmatch/*/@niemcomplextype}" mtfdoc="{$mtfdoc}"
            mtftypedoc="{$mtftypedoc}" niemtypedoc="{$niemmatch/*/@niemtypedoc}" niemelementdoc="{$niemelementdoc}" ffirn="{$ffirn}" fud="{$fud}">
            <xsl:for-each select="@*[not(name() = 'name')]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:if test="string-length($seq) &gt; 0">
                <xsl:attribute name="seq">
                    <xsl:value-of select="$seq"/>
                </xsl:attribute>
            </xsl:if>
            <appinfo>
                <xsl:for-each select="$appinfo">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </appinfo>
            <typeappinfo>
                <xsl:for-each select="$typeappinfo">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </typeappinfo>
            <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]"/>
        </Element>
    </xsl:template>
    <!--  Choice / Substitution Groups Map -->
    <xsl:template match="xsd:element[xsd:complexType/xsd:choice]">
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="annot">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="seq">
            <xsl:value-of select="xsd:complexType/xsd:attribute[@name = 'ffSeq'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="mtfdoc">
            <xsl:value-of select="$annot/*/xsd:documentation"/>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*:Field" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="setname">
            <xsl:value-of select="ancestor::xsd:complexType[@name]/@name"/>
        </xsl:variable>
        <xsl:variable name="substmatch">
            <xsl:value-of select="$substGrp_Changes/Choice[@mtfname = $n][@setname = $setname]"/>
        </xsl:variable>
        <xsl:variable name="substgrpname">
            <xsl:choose>
                <xsl:when test="string-length($substmatch/*/@niemname) &gt; 0">
                    <xsl:value-of select="$substmatch/*/@niemname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($n, 'Choice')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="substgrpdoc">
            <xsl:choose>
                <xsl:when test="$substGrp_Changes/Choice[@mtfname = $n][@setname = $setname]">
                    <xsl:value-of select="concat('A data concept for a substitution group for a', substring($substmatch/*/@concept, 1))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($mtfdoc, 'A data type for', 'A data concept for a substitution group for')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Element mtfname="{@name}" substgrpname="{$substgrpname}" mtfdoc="{$mtfdoc}" substgrpdoc="{$substgrpdoc}" seq="{$seq}">
            <xsl:for-each select="@*[not(name() = 'name')]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <appinfo>
                <xsl:for-each select="$appinfo">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </appinfo>
            <Choice name="{$substgrpname}">
                <xsl:apply-templates select="xsd:complexType/xsd:choice/xsd:element">
                    <xsl:with-param name="sbstgrp">
                        <xsl:value-of select="$substgrpname"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </Choice>
        </Element>
    </xsl:template>
    <xsl:template match="xsd:choice">
        <Choice>
            <xsl:apply-templates select="*"/>
        </Choice>
    </xsl:template>
    <xsl:template match="xsd:sequence">
        <xsl:choose>
            <xsl:when test="xsd:element[@name = 'GroupOfFields']">
                <Sequence>
                    <xsl:for-each select="xsd:element[@name = 'GroupOfFields']/@*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:apply-templates select="xsd:element/xsd:complexType/xsd:sequence/*"/>
                </Sequence>
            </xsl:when>
            <xsl:when test="xsd:complexType/xsd:sequence">
                <xsl:apply-templates select="*"/>
            </xsl:when>
            <xsl:otherwise>
                <Sequence>
                    <xsl:apply-templates select="xsd:element"/>
                </Sequence>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="xsd:complexType">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="xsd:simpleContent">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="xsd:complexContent">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="xsd:extension">
        <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]"/>
    </xsl:template>
    
    <!-- XSD GENERATION-->
    <!-- _______________________________________________________ -->

    <xsl:variable name="setfields">
        <xsl:for-each select="$setmaps//Sequence/Element">
            <xsl:sort select="@niemelementname"/>
            <xsl:choose>
                <xsl:when test="string-length(@mtfdoc) = 0"/>
                <xsl:when test="@niemelementname">
                    <xsd:element name="{@niemelementname}">
                        <xsl:attribute name="type">
                            <xsl:choose>
                                <xsl:when test="starts-with(@mtftype, 'f:')">
                                    <xsl:value-of select="concat('f:', @niemtype)"/>
                                </xsl:when>
                                <xsl:when test="starts-with(@mtftype, 'c:')">
                                    <xsl:value-of select="concat('c:', @niemtype)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@niemtype"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="nillable">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:choose>
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
    <xsl:variable name="setsxsd">
        <xsl:for-each select="$setmaps/Set">
            <xsl:sort select="@niemcomplextype"/>
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
            <xsd:complexType name="{@niemcomplextype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xsd:appinfo>
                            <xsl:copy-of select="."/>
                        </xsd:appinfo>
                    </xsl:for-each>
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="{$basetype}">
                        <xsd:sequence>
                            <xsl:for-each select="*:Sequence/Element">
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
                                <xsd:element ref="{$refname}">
                                    <xsl:copy-of select="@minOccurs"/>
                                    <xsl:copy-of select="@maxOccurs"/>
                                    <xsd:annotation>
                                        <xsd:documentation>
                                            <xsl:choose>
                                                <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                                    <xsl:value-of select="replace(@mtfdoc, 'A data type', 'A data item')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@niemelementdoc"/>
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
            <xsl:if test="@niemelementname != 'SetBase'">
                <xsd:element name="{@niemelementname}" type="{@niemcomplextype}" nillable="true">
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="@niemelementdoc"/>
                        </xsd:documentation>
                    </xsd:annotation>
                </xsd:element>
            </xsl:if>
        </xsl:for-each>
        <!--Global Set Elements-->
        <xsl:copy-of select="$setfields"/>
        <!--Set Elements with Choice to Substitution Groups-->
        <xsl:for-each select="$setmaps//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xsd:element name="{@substgrpname}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@substgrpdoc"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsl:for-each select="Choice/Element">
                <xsl:variable name="prefix" select="substring-before(@mtftype, ':')"/>
                <xsd:element name="{@niemelementname}" type="{concat($prefix,':',@niemtype)}" substitutionGroup="{$substgrp}" nillable="true">
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="@niemelementdoc"/>
                        </xsd:documentation>
                    </xsd:annotation>
                </xsd:element>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>

<!-- _______________________________________________________ -->
    <!--    OUTPUT RESULT-->
    <xsl:template name="main">
        <xsl:result-document href="{$setxsdoutputdoc}">
            <xsd:schema xmlns="urn:int:nato:ncdf:mtf:niem:sets" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/" xmlns:structures="http://release.niem.gov/niem/structures/3.0/"
                xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/" xmlns:appinfo="http://release.niem.gov/niem/appinfo/3.0/" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:f="urn:int:nato:ncdf:mtf:niem:fields" xmlns:c="urn:int:nato:ncdf:mtf:niem:composites" targetNamespace="urn:int:nato:ncdf:mtf:niem:sets"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/3.0/" schemaLocation="../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/3.0/" schemaLocation="../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:appinfo" schemaLocation="../NIEM/mtfappinfo.xsd"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:fields" schemaLocation="NIEM_MTF_Fields.xsd"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:composites" schemaLocation="NIEM_MTF_Composites.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Set structures for MTF Messages</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:for-each select="$setsxsd/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$setsxsd/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:variable name="t" select="@type"/>
                    <xsl:variable name="pre1" select="preceding-sibling::xsd:element[@name = $n][1]"/>
                    <xsl:variable name="pre2" select="preceding-sibling::xsd:element[@name = $n][2]"/>
                    <xsl:variable name="pre3" select="preceding-sibling::xsd:element[@name = $n][3]"/>
                    <xsl:choose>
                        <xsl:when test="deep-equal(., $pre1)"/>
                        <xsl:when test="deep-equal(., $pre2)"/>
                        <xsl:when test="deep-equal(., $pre3)"/>
                        <xsl:when test="preceding-sibling::xsd:element[@name = $n] and preceding-sibling::xsd:element[@type = $t]"/>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$setmapsoutput}">
            <Sets>
                <xsl:for-each select="$setmaps/*">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </Sets>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
