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
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
    xmlns:term="http://release.ncdf.gov/ncdf/localTerminology/3.0/"
    xmlns:ism="urn:us:gov:ic:ism" 
    xmlns:appinfo="http://release.ncdf.gov/ncdf/appinfo/4.0/" 
    xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" 
    xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
    exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="USMTF_Utility.xsl"/>

    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="srcdir" select="'../../XSD/NCDF_MTF_1_NS/'"/>

    <xsl:variable name="baseline_sets_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/sets.xsd')/*"/>
    <xsl:variable name="ncdf_fields_map" select="document(concat($srcdir, 'NCDF_MTF_Fieldmaps.xml'))/*"/>
    <xsl:variable name="ncdf_composites_map" select="document(concat($srcdir, 'NCDF_MTF_Compositemaps.xml'))/*"/>
    <!--Set deconfliction and annotation changes-->
    <xsl:variable name="set_Changes" select="document(concat($srcdir, 'Refactor_Changes/SetChanges.xml'))/*"/>
    <xsl:variable name="substGrp_Changes" select="document(concat($srcdir, 'Refactor_Changes/SubstitutionGroupChanges.xml'))/*"/>
    <!--Outputs-->
    <xsl:variable name="setmapsoutput" select="concat($srcdir, 'NCDF_MTF_Setmaps.xml')"/>
    <xsl:variable name="setxsdoutputdoc" select="concat($srcdir, 'NCDF_MTF_Sets.xsd')"/>

    <!-- SET XSD MAP-->
    <!-- _______________________________________________________ -->

    <xsl:variable name="setmaps">
        <xsl:apply-templates select="$baseline_sets_xsd/xsd:complexType" mode="setglobal"/>
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
        <xsl:variable name="ncdfelementnamevar">
            <xsl:choose>
                <xsl:when test="$change/@ncdfelementname">
                    <xsl:value-of select="$change/@ncdfelementname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$n"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfcomplextypevar">
            <xsl:choose>
                <xsl:when test="$change/@ncdfcomplextype">
                    <xsl:value-of select="$change/@ncdfcomplextype"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($ncdfelementnamevar, 'Type')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfdocvar">
            <xsl:value-of select="$annot/*/xsd:documentation"/>
        </xsl:variable>
        <xsl:variable name="ncdftypedocvar">
            <xsl:choose>
                <xsl:when test="$change/@ncdftypedoc">
                    <xsl:value-of select="concat('A data type for the',substring($change/@ncdftypedoc,4))"/>
                </xsl:when>
                <xsl:when test="starts-with($mtfdocvar,'A data ')">
                    <xsl:value-of select="$mtfdocvar"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('A data type for the',substring($mtfdocvar,4))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfelementdocvar">
            <xsl:choose>
                <xsl:when test="starts-with($ncdftypedocvar,'A data ')">
                    <xsl:value-of select="$ncdftypedocvar"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($ncdftypedocvar, 'A data type', 'A data item')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*:Set" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <Set mtfname="{@name}" ncdfcomplextype="{$ncdfcomplextypevar}" ncdfelementname="{$ncdfelementnamevar}" ncdfelementdoc="{$ncdfelementdocvar}" mtfdoc="{$mtfdocvar}"
            ncdftypedoc="{$ncdftypedocvar}">
            <appinfo>
                <xsl:for-each select="$appinfovar">
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
        <xsl:variable name="mtfnamevar">
            <xsl:apply-templates select="@name" mode="txt"/>
        </xsl:variable>
        <xsl:variable name="settypevar">
            <xsl:apply-templates select="ancestor::xsd:complexType[@name][1]/@name" mode="txt"/>
        </xsl:variable>
        <xsl:variable name="mtftypevar">
            <xsl:value-of select="xsd:complexType/*/xsd:extension/@base"/>
        </xsl:variable>
        <xsl:variable name="ffirnfud">
            <xsl:value-of select="xsd:complexType/*//xsd:attribute[@name = 'ffirnFudn']/@fixed"/>
        </xsl:variable>
        <xsl:variable name="ffirnvar">
            <xsl:value-of select="substring-before(substring-after($ffirnfud, 'FF'), '-')"/>
        </xsl:variable>
        <xsl:variable name="fudvar">
            <xsl:value-of select="substring-after(substring-after($ffirnfud, 'FF'), '-')"/>
        </xsl:variable>
        <xsl:variable name="ncdfmatch">
            <xsl:choose>
                <xsl:when test="starts-with($mtftypevar, 'f:')">
                    <xsl:choose>
                        <xsl:when test="$ncdf_fields_map/*[@mtfname = substring-after($mtftypevar, 'f:')]">
                            <xsl:copy-of select="$ncdf_fields_map/*[@mtfname = substring-after($mtftypevar, 'f:')]"/>
                        </xsl:when>
                        <xsl:when test="$ncdf_fields_map/*[@ncdfcomplextype = substring-after($mtftypevar, 'f:')]">
                            <xsl:copy-of select="$ncdf_fields_map/*[@ncdfcomplextype = substring-after($mtftypevar, 'f:')]"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="starts-with($mtftypevar, 'c:')">
                    <xsl:copy-of select="$ncdf_composites_map/*[@mtfname = substring-after($mtftypevar, 'c:')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$baseline_sets_xsd/xsd:schema/xsd:complexType[@name = $mtftypevar]" mode="setglobal"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdftypedocvar">
            <xsl:value-of select="$ncdfmatch/*/@ncdftypedoc"/>
        </xsl:variable> 
        <xsl:variable name="ncdftypevar">
            <xsl:value-of select="$ncdfmatch/*/@ncdfcomplextype"/>
        </xsl:variable>
        <xsl:variable name="setnamevar">
            <xsl:value-of select="substring-before($settypevar, 'Type')"/>
        </xsl:variable>
        <xsl:variable name="ncdfelementnamevar">
            <xsl:choose>
                <xsl:when test="$set_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@ncdfelementname">
                    <xsl:value-of select="$set_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@ncdfelementname"/>
                </xsl:when>
                <xsl:when test="string-length($sbstgrp) &gt; 0">
                    <xsl:choose>
                        <xsl:when test="$substGrp_Changes/Element[@mtfname = $mtfnamevar][@substitutionGroup = $sbstgrp]/@ncdfname">
                            <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfnamevar][@substitutionGroup = $sbstgrp]/@ncdfname"/>
                        </xsl:when>          
                       <xsl:when test="ends-with($ncdftypevar, 'CodeType') and not(ends-with($mtfnamevar, 'Code'))">
                            <xsl:value-of select="concat($mtfnamevar, 'Code')"/>
                        </xsl:when>
                        <xsl:when test="ends-with($mtfnamevar, 'Code')">
                            <xsl:value-of select="concat(substring-before($mtfnamevar, 'Code'),'OptionCode')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($mtfnamevar, 'Option')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfnamevar"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="seq">
            <xsl:choose>
                <xsl:when test="xsd:complexType/xsd:attribute[@name = 'ffSeq']">
                    <xsl:value-of select="xsd:complexType/xsd:attribute[@name = 'ffSeq'][1]/@fixed"/>
                </xsl:when>
                <xsl:when test="xsd:complexType/xsd:simpleContent/xsd:extension/xsd:attribute[@name = 'ffSeq']">
                    <xsl:value-of select="xsd:complexType/xsd:simpleContent/xsd:extension/xsd:attribute[@name = 'ffSeq'][1]/@fixed"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="position()"/>
                </xsl:otherwise>
            </xsl:choose>
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
        <xsl:variable name="ncdfelementdocvar">
            <xsl:choose>
                <xsl:when test="$set_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@ncdfelementdoc">
                    <xsl:value-of select="$set_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@ncdfelementdoc"/>
                </xsl:when>
                <xsl:when test="$annot/*/xsd:documentation and contains($ncdfelementnamevar, 'Name')">
                    <xsl:value-of select="replace($mtfdoc, 'A data type ', 'A data item for the name ')"/>
                </xsl:when>
                <xsl:when test="$annot/*/xsd:documentation">
                    <xsl:value-of select="replace($mtfdoc, 'A data type ', 'A data item ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($ncdfmatch/*/@ncdftypedoc, 'A data type for the', 'A data item for the')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="typeappinfo">
            <xsl:for-each select="$typeannot/*/xsd:appinfo">
                <xsl:copy-of select="*:Field" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <Element mtfname="{@name}" mtftype="{$mtftypevar}" setname="{$setnamevar}" ncdfelementname="{$ncdfelementnamevar}" ncdftype="{$ncdftypevar}" mtfdoc="{$mtfdoc}" mtftypedoc="{$mtftypedoc}"
            ncdftypedoc="{$ncdftypedocvar}" ncdfelementdoc="{$ncdfelementdocvar}" seq="{$seq}" ffirn="{$ffirnvar}" fud="{$fudvar}">
            <xsl:if test="string-length($sbstgrp) &gt; 0">
                <xsl:attribute name="substitutiongroup">
                    <xsl:value-of select="$sbstgrp"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:for-each select="@*[not(name() = 'name')]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <appinfo>
                <xsl:for-each select="$appinfovar">
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
        <xsl:variable name="typeannot">
            <xsl:apply-templates select="xsd:element[1]/*/xsd:extension/xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="mtftypedoc">
            <xsl:value-of select="$typeannot/xsd:documentation"/>
        </xsl:variable>
        <xsl:variable name="seq">
            <xsl:choose>
                <xsl:when test="xsd:complexType/xsd:attribute[@name = 'ffSeq']">
                    <xsl:value-of select="xsd:complexType/xsd:attribute[@name = 'ffSeq'][1]/@fixed"/>
                </xsl:when>
                <xsl:when test="xsd:complexType/xsd:simpleContent/xsd:extension/xsd:attribute[@name = 'ffSeq']">
                    <xsl:value-of select="xsd:complexType/xsd:simpleContent/xsd:extension/xsd:attribute[@name = 'ffSeq'][1]/@fixed"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="position()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*:Field" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="setnamevar">
            <xsl:value-of select="ancestor::xsd:complexType[@name]/@name"/>
        </xsl:variable>
        <xsl:variable name="substgrpname">
            <xsl:choose>
                <xsl:when test="string-length($substGrp_Changes/Choice[@mtfname = $n][@setname = $setnamevar]/@ncdfname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@mtfname = $n][@setname = $setnamevar]/@ncdfname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($n, 'Choice')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="substgrpdoc">
            <xsl:choose>
                <xsl:when test="$substGrp_Changes/Choice[@mtfname = $n][@setname = $setnamevar]">
                    <xsl:value-of select="$substGrp_Changes/Choice[@mtfname = $n][@setname = $setnamevar][1]/@concept"/>
                </xsl:when>
                <xsl:when test="$substGrp_Changes/Choice[@mtfname = $n][@setname = '']">
                    <xsl:value-of select="$substGrp_Changes/Choice[@mtfname = $n][@setname = ''][1]/@concept"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="splitname">
                        <xsl:call-template name="breakIntoWords">
                            <xsl:with-param name="string" select="$n"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="concat('A data concept for a substitution group for ', lower-case($splitname))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="substgrpncdfdoc">
            <xsl:choose>
                <xsl:when test="starts-with($substgrpdoc, 'A data concept for')">
                    <xsl:value-of select="$substgrpdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('A data concept for a substitution group for ', lower-case($substgrpdoc))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Element mtfname="{@name}" substgrpname="{$substgrpname}" setname="{$setnamevar}" mtftypedoc="{$mtftypedoc}" substgrpdoc="{$substgrpncdfdoc}" seq="{$seq}">
            <xsl:for-each select="@*[not(name() = 'name')]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <appinfo>
                <xsl:for-each select="$appinfovar">
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
    <xsl:template match="xsd:element[@name = 'GroupOfFields']">
        <Sequence name="GroupOfFields">
            <xsl:for-each select="@*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:apply-templates select="xsd:complexType/xsd:sequence/*"/>
        </Sequence>
    </xsl:template>
    <xsl:template match="xsd:choice">
        <Choice>
            <xsl:apply-templates select="*">
                <xsl:sort select="@name"/>
            </xsl:apply-templates>
        </Choice>
    </xsl:template>
    <xsl:template match="xsd:sequence[xsd:element[1][@name = 'GroupOfFields']][not(xsd:element[not(@name = 'GroupOfFields')])]">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="xsd:sequence">
        <Sequence>
            <xsl:apply-templates select="*"/>
        </Sequence>
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
        <xsl:for-each select="$setmaps//Sequence[@name = 'GroupOfFields']">
            <xsl:variable name="setname">
                <xsl:value-of select="ancestor::Set/@ncdfelementname"/>
            </xsl:variable>
            <xsl:variable name="setdocname">
                <xsl:value-of select="ancestor::Set/appinfo/mtfappinfo:Set/@name"/>
            </xsl:variable>
            <xsl:variable name="fielddocname">
                <xsl:value-of select="Element[1]/appinfo/mtfappinfo:Field/@positionName"/>
            </xsl:variable>
            <xsl:variable name="fgname">
                <xsl:choose>
                    <xsl:when test="exists(Element[1]/@ncdfelementname) and count(Element) = 1">
                        <xsl:value-of select="concat(Element[1]/@ncdfelementname, 'FieldGroup')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($setname, 'FieldGroup')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="doc">
                <xsl:choose>
                    <xsl:when test="exists(Element[1]/@ncdfelementname) and count(Element) = 1">
                        <xsl:value-of select="Element[1]/@ncdftypedoc"/>
                    </xsl:when>
                    <xsl:when test="count(Element) = 1">
                        <xsl:value-of select="concat($fielddocname, ' FIELD GROUP')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($setdocname, ' FIELD GROUP')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="datadefdoc">
                <xsl:choose>
                    <xsl:when test="starts-with($doc, 'A data type')">
                        <xsl:value-of select="$doc"/>
                    </xsl:when>
                    <xsl:when test="starts-with($doc, 'A ')">
                        <xsl:value-of select="concat('A ', substring(lower-case($doc), 1))"/>
                    </xsl:when>
                    <xsl:when test="starts-with($doc, 'An ')">
                        <xsl:value-of select="concat('A ', substring(lower-case($doc), 1))"/>
                    </xsl:when>
                    <xsl:when test="contains('AEIOU', substring($doc, 0, 1))">
                        <xsl:value-of select="concat('An ', lower-case($doc))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('A ', lower-case($doc))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsd:element name="{$fgname}" type="{concat($fgname,'Type')}" nillable="true">
                <!--<xsl:copy-of select="@minOccurs"/>
                        <xsl:copy-of select="@maxOccurs"/>-->
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="$datadefdoc"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:complexType name="{concat($fgname,'Type')}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('A data type for ', lower-case($datadefdoc))"/>
                    </xsd:documentation>
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="structures:ObjectType">
                        <xsd:sequence>
                            <xsl:for-each select="Element">
                                <xsl:variable name="refname">
                                    <xsl:choose>
                                        <xsl:when test="@substgrpname">
                                            <xsl:value-of select="@substgrpname"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@ncdfelementname"/>
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
                                                <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                                    <xsl:value-of select="replace(@mtfdoc, 'A data type', 'A data item')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@ncdfelementdoc"/>
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
                            <xsd:element ref="{concat($fgname,'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{concat($fgname,'AugmentationPoint')}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', lower-case($datadefdoc))"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:for-each select="$setmaps//Sequence/Element">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:variable name="n" select="@ncdfelementname"/>
            <xsl:choose>
                <xsl:when test="$ncdf_composites_map/*//Element/@ncdfelementname = $n"/>
                <xsl:when test="$ncdf_composites_map/*/@ncdfelementname = $n"/>
                <xsl:when test="$ncdf_fields_map/*/@ncdfelementname = $n"/>
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
    <xsl:variable name="setsxsd">
        <xsl:for-each select="$setmaps/Set">
            <xsl:sort select="@ncdfcomplextype"/>
            <xsl:variable name="setname">
                <xsl:value-of select="@ncdfelementname"/>
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
            <xsd:complexType name="{@ncdfcomplextype}">
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
                    <xsd:extension base="{$basetype}">
                        <xsd:sequence>
                            <xsl:for-each select="*:Sequence/*">
                                <xsl:variable name="refname">
                                    <xsl:choose>
                                        <xsl:when test="@name = 'GroupOfFields'">
                                            <xsl:choose>
                                                <xsl:when test="count(Element) = 1">
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(Element/@substgrpname) &gt; 0">
                                                            <xsl:value-of select="Element/@substgrpname"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="Element/@ncdfelementname"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat($setname, 'FieldGroup')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:when test="@substgrpname">
                                            <xsl:value-of select="@substgrpname"/>
                                        </xsl:when>
                                        <!--<xsl:when test="contains(@mtftype, ':')">
                                            <xsl:value-of select="concat(substring-before(@mtftype, ':'), ':', @ncdfelementname)"/>
                                        </xsl:when>-->
                                        <xsl:otherwise>
                                            <xsl:value-of select="@ncdfelementname"/>
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
                                                <xsl:when test="string-length(Element[1]/@substgrpdoc) &gt; 0">
                                                    <xsl:value-of select="Element[1]/@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(@ncdfelementdoc) &gt; 0">
                                                    <xsl:value-of select="@ncdfelementdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(Element[1]/@ncdfelementdoc) &gt; 0">
                                                    <xsl:value-of select="Element[1]/@ncdfelementdoc"/>
                                                </xsl:when>
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
            <xsl:choose>
                <xsl:when test="@ncdfelementname = 'SetBase'"/>
                <xsl:when test="@ncdfcomplextype">
                    <xsd:element name="{@ncdfelementname}" type="{@ncdfcomplextype}" nillable="true">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@ncdfelementdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsd:documentation>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
            </xsl:choose>
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
                    <xsd:appinfo>
                        <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                            <xsl:for-each select="Choice/Element">
                                <xsl:sort select="@ncdfelementname"/>
                                <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                            </xsl:for-each>
                        </mtfappinfo:Choice>
                    </xsd:appinfo>
                </xsd:annotation>
            </xsd:element>
            <xsl:for-each select="Choice/Element">
                <xsl:sort select="@ncdfelementname"/>
                <xsl:variable name="n" select="@ncdfelementname"/>
                <xsl:choose>
                    <xsl:when test="$ncdf_composites_map/*//Element/@ncdfelementname = $n"/>
                    <xsl:when test="$ncdf_composites_map/*/@ncdfelementname = $n"/>
                    <xsl:when test="$ncdf_fields_map/*/@ncdfelementname = $n"/>
                    <xsl:otherwise>
                        <xsd:element name="{@ncdfelementname}" type="{@ncdftype}" substitutionGroup="{$substgrp}" nillable="true">
                            <xsd:annotation>
                                <xsd:documentation>
                                    <xsl:value-of select="@ncdfelementdoc"/>
                                </xsd:documentation>
                                <xsd:appinfo>
                                    <xsl:for-each select="appinfo/*">
                                        <xsl:copy-of select="." copy-namespaces="no"/>
                                    </xsl:for-each>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>

    <!-- _______________________________________________________ -->
    <!--    OUTPUT RESULT-->
    <xsl:template name="main">
        <xsl:result-document href="{$setxsdoutputdoc}">
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
                xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/structures/4.0/" schemaLocation="../NCDF/structures.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/localTerminology/3.0/" schemaLocation="../NCDF/localTerminology.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/appinfo/4.0/" schemaLocation="../NCDF/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NCDF/mtfappinfo.xsd"/>
                <xsd:include schemaLocation="NCDF_MTF_Fields.xsd"/>
                <xsd:include schemaLocation="NCDF_MTF_Composites.xsd"/>
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

    <xsl:template name="set_nodes">
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
    </xsl:template>

</xsl:stylesheet>
