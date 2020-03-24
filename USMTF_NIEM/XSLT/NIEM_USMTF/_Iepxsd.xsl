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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:inf="urn:mtf:mil:6040b:appinfo" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <!--    <xsl:include href="SubsetSchema.xsl"/>-->

    <xsl:variable name="srcpath" select="'../../XSD/NIEM_MTF/'"/>
    <xsl:variable name="Outdir" select="'../../XSD/NIEM_MTF/iepdxsd/'"/>
    <xsl:variable name="REFMTF" select="document(concat($srcpath, 'refxsd/usmtf-ref.xsd'))"/>
    <xsl:variable name="mtfappinf" select="document(concat($srcpath, 'ext/niem/mtfappinfo.xsd'))"/>
    <xsl:variable name="locterm"
        select="document(concat($srcpath, 'ext/niem/localTerminology.xsd'))"/>
    <xsl:variable name="appinf"
        select="document(concat($srcpath, 'ext/niem/utility/appinfo/4.0/appinfo.xsd'))"/>
    <xsl:variable name="struct"
        select="document(concat($srcpath, 'ext/niem/utility/structures/4.0/structures.xsd'))"/>
    <xsl:variable name="icism" select="document(concat($srcpath, 'ext/ic-xml/ic-ism.xsd'))"/>

    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="lt" select="'&lt;'"/>
    <xsl:variable name="gt" select="'&gt;'"/>
    <xsl:variable name="cm" select="','"/>
    <xsl:variable name="ALLIEP">
        <xsl:apply-templates select="$REFMTF/xs:schema/*" mode="iepd"/>
    </xsl:variable>
    <xsl:variable name="iep-xsd-template">
        <xs:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:inf="urn:mtf:mil:6040b:appinfo"
            xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:mtf:mil:6040b:niem:mtf"
            xml:lang="en-US" elementFormDefault="qualified" attributeFormDefault="unqualified"
            version="1.0">
            <xs:import namespace="urn:us:gov:ic:ism" schemaLocation="../ext/ic-xml/ic-ism.xsd"/>
        </xs:schema>
    </xsl:variable>

    <xsl:template name="main">
        <!--CREATE CUMULATIVE IEPD-->
        <xsl:result-document href="{concat($Outdir,'usmtf-iep.xsd')}">
            <xsl:for-each select="$iep-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="iepdidentity"/>
                    <xsl:apply-templates select="*" mode="iepdidentity"/>
                    <xsl:copy-of select="$ALLIEP" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <!--CREATE MSG IEPD AND COPY TO MSG IEPD FOLDER-->
        <xsl:for-each select="$ALLIEP/xs:element[xs:annotation/xs:appinfo/*:Msg]">
            <xsl:sort select="xs:annotation/xs:appinfo/*:Msg/@mtfid"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:variable name="mid"
                select="lower-case(translate(xs:annotation/xs:appinfo/*:Msg/@mtfid, ' .()-', ''))"/>
            <xsl:variable name="reflist"
                select="document(concat($srcpath, 'lists/', $mid, '-list.xml'))"/>
            <xsl:variable name="mname" select="$reflist/Message/element[1]/@name"/>
            <xsl:result-document href="{$Outdir}/{concat(lower-case($mid),'-iep.xsd')}">
                <xsl:for-each select="$iep-xsd-template/*">
                    <xsl:copy>
                        <xsl:apply-templates select="@*" mode="iepdidentity"/>
                        <xsl:apply-templates select="*" mode="iepdidentity"/>
                        <xsl:copy-of select="$REFMTF/*/xs:element[@name = $mname]/xs:annotation"/>
                        <xsl:for-each select="$reflist/Message/*">
                            <xsl:variable name="n" select="@name"/>
                            <xsl:apply-templates select="$REFMTF/xs:schema/*[@name = $n]" mode="iepd"/>
                        </xsl:for-each>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <!--Convert to IEPD-->
    <xsl:template match="*" mode="iepd">
        <xsl:variable name="r" select="@ref"/>
        <xsl:choose>
            <xsl:when test="parent::xs:schema and xs:annotation/xs:appinfo/*:Choice">
                <xs:element name="{@name}" type="{@type}">
                    <xsl:copy-of select="xs:annotation" copy-namespaces="no"/>
                    <xsl:for-each select="parent::xs:schema//xs:element[@substitutionGroup = $r]">
                        <xsl:variable name="t" select="@type"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:variable name="match">
                            <xsl:copy-of
                                select="parent::xs:schema/xs:element[@name = $n][@type = $t]"/>
                        </xsl:variable>
                        <xs:element ref="{@name}">
                            <xsl:copy-of select="$match/*/xs:annotation" copy-namespaces="no"/>
                        </xs:element>
                    </xsl:for-each>
                </xs:element>
            </xsl:when>
            <xsl:when test="xs:annotation/xs:appinfo/*:Choice">
                <xs:choice>
                    <xsl:copy-of select="@minOccurs"/>
                    <xsl:copy-of select="@maxOccurs"/>
                    <xsl:copy-of select="xs:annotation" copy-namespaces="no"/>
                    <xsl:for-each select="parent::xs:schema/xs:element[@substitutionGroup = $r]">
                        <xsl:variable name="t" select="@type"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:variable name="match">
                            <xsl:copy-of
                                select="parent::xs:schema/xs:element[@name = $n][@type = $t]"/>
                        </xsl:variable>
                        <xs:element ref="{@name}">
                            <xsl:copy-of select="$match/*/xs:annotation" copy-namespaces="no"/>
                        </xs:element>
                    </xsl:for-each>
                </xs:choice>
            </xsl:when>
            <xsl:when test="name() = 'xs:sequence' and count(*) = 1 and *[1][name() = 'xs:choice']">
                <xsl:apply-templates select="*" mode="iepd"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*" mode="iepd"/>
                    <xsl:apply-templates select="*" mode="iepd"/>
                    <xsl:apply-templates select="text()" mode="iepd"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@substitutionGroup" mode="iepd"/>
    <xsl:template match="@*" mode="iepd">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="text()" mode="iepd">
        <xsl:copy-of select="normalize-space(.)"/>
    </xsl:template>
    <xsl:template match="xs:complexType/xs:complexContent" mode="iepd">
        <xsl:apply-templates select="xs:extension/*" mode="iepd"/>
    </xsl:template>
    <xsl:template match="xs:attributeGroup[@ref = 'structures:SimpleObjectAttributeGroup']"
        mode="iepd">
        <xs:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
    </xsl:template>
    <xsl:template match="xs:schema/xs:import" mode="iepd"/>
    <xsl:template match="xs:schema/xs:element[@abstract]" mode="iepd"/>
    <xsl:template match="xs:element[ends-with(@ref, 'Abstract')]" mode="iepd">
        <xsl:variable name="n" select="@ref"/>
        <xs:choice>
            <xsl:copy-of select="@minOccurs"/>
            <xsl:copy-of select="@maxOccurs"/>
            <xsl:copy-of select="xs:annotation" copy-namespaces="no"/>
            <xsl:for-each select="parent::xs:schema/xs:element[@substitutionGroup = $n]">
                <xsl:variable name="t" select="@type"/>
                <xsl:variable name="n" select="@name"/>
                <xsl:variable name="match"
                    select="parent::xs:schema/xs:element[@name = $n][@type = $t]"/>
                <xs:element ref="{@name}">
                    <xsl:copy-of select="$match/xs:annotation" copy-namespaces="no"/>
                </xs:element>
            </xsl:for-each>
        </xs:choice>
    </xsl:template>
    <xsl:template match="*[contains(@ref, 'AugmentationPoint')]" mode="iepd"/>
    <xsl:template match="xs:element/xs:annotation/xs:appinfo/*:StructuralRelationships" mode="iepd"/>
    <xsl:template match="@abstract" mode="iepd"/>
    <xsl:template match="*" mode="iepdidentity">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="iepdidentity"/>
            <xsl:apply-templates select="text()" mode="iepdidentity"/>
            <xsl:apply-templates select="*" mode="iepdidentity"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="iepdidentity">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    <xsl:template match="text()" mode="iepdidentity">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

</xsl:stylesheet>
