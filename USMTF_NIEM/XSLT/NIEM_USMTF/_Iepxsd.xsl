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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:inf="urn:mtf:mil:6040b:appinfo" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>

<!--    <xsl:include href="SubsetSchema.xsl"/>-->

    <xsl:variable name="srcpath" select="'../../XSD/NIEM_MTF/'"/>
    <xsl:variable name="Outdir" select="'../../XSD/NIEM_MTF/iepdxsd/'"/>
    <xsl:variable name="ALLMTF" select="document(concat($srcpath, 'refxsd/usmtf-ref.xsd'))"/>
    <xsl:variable name="mtfappinf" select="document(concat($srcpath, 'ext/niem/mtfappinfo.xsd'))"/>
    <xsl:variable name="locterm" select="document(concat($srcpath, 'ext/niem/localTerminology.xsd'))"/>
    <xsl:variable name="appinf" select="document(concat($srcpath, 'ext/niem/utility/appinfo/4.0/appinfo.xsd'))"/>
    <xsl:variable name="struct" select="document(concat($srcpath, 'ext/niem/utility/structures/4.0/structures.xsd'))"/>
    <xsl:variable name="icism" select="document(concat($srcpath, 'ext/ic-xml/ic-ism.xsd'))"/>

    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="lt" select="'&lt;'"/>
    <xsl:variable name="gt" select="'&gt;'"/>
    <xsl:variable name="cm" select="','"/>
    <xsl:variable name="ALLIEP">
        <xsl:apply-templates select="$ALLMTF/xs:schema/*" mode="iepd"/>
    </xsl:variable>
    <xsl:variable name="iep-xsd-template">
        <xs:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:inf="urn:mtf:mil:6040b:appinfo" xmlns:ism="urn:us:gov:ic:ism" xmlns:xs="http://www.w3.org/2001/XMLSchema"
            targetNamespace="urn:mtf:mil:6040b:niem:mtf" xml:lang="en-US" elementFormDefault="qualified" attributeFormDefault="unqualified" version="1.0">
            <xs:import namespace="urn:us:gov:ic:ism" schemaLocation="../ext/ic-xml/ic-ism.xsd"/>
        </xs:schema>
    </xsl:variable>

    <xsl:template name="main">
        <!--Create REF Folder-->
        <!--<xsl:call-template name="RefFolder"/>-->
        <!--COPY REF XSD TO ext FOLDER-->
        <!--<xsl:result-document href="{concat($Outdir,'xml/xsd/ext/usmtf-ref.xsd')}">
            <xsl:copy-of select="$ALLMTF"/>
        </xsl:result-document>-->
        <!--CREATE CUMULATIVE IEPD-->
        <xsl:result-document href="{concat($Outdir,'usmtf-iep.xsd')}">
            <xsl:for-each select="$iep-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xsl:copy-of select="$ALLIEP" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <!--CREATE MSG IEPD AND COPY TO MSG IEPD FOLDER-->
        <xsl:for-each select="$ALLIEP/xs:element[xs:annotation/xs:appinfo/*:Msg]">
            <xsl:sort select="xs:annotation/xs:appinfo/*:Msg/@mtfid"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:variable name="mid" select="translate(xs:annotation/xs:appinfo/*:Msg/@mtfid, ' .', '')"/>
            <xsl:call-template name="ExtractIepSchema">
                <xsl:with-param name="msgelement" select="."/>
                <xsl:with-param name="outdir" select="$Outdir"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="RefFolder">
        <!--COPY REF XSD TO ext FOLDER-->
        <xsl:result-document href="{concat($Outdir,'xml/xsd/ext/usmtf-ref.xsd')}">
            <xsl:copy-of select="$ALLMTF"/>
        </xsl:result-document>
        <!--CREATE CUMULATIVE IEPD AND COPY TO EXT FOLDER-->
        <xsl:result-document href="{concat($Outdir,'xml/xsd/ext/usmtf-iep.xsd')}">
            <xsl:for-each select="$iep-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xsl:copy-of select="$ALLIEP" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <!--COPY NCDF RESOURCES TO EXT FOLDER-->
        <xsl:result-document href="{concat($Outdir,'xml/xsd/ext/niem/utility/appinfo/4.0/appinfo.xsd')}">
            <xsl:copy-of select="$appinf/xs:schema"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'xml/xsd/ext/niem/utility/structures/4.0/structures.xsd')}">
            <xsl:copy-of select="$struct/xs:schema"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'xml/xsd/ext/niem/localTerminology.xsd')}">
            <xsl:copy-of select="$locterm/xs:schema"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'xml/xsd/ext/niem/mtfappinfo.xsd')}">
            <xsl:copy-of select="$mtfappinf/xs:schema"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'xml/xsd/ext/ic-xml/ic-ism.xsd')}">
            <xsl:copy-of select="$icism/xs:schema"/>
        </xsl:result-document>
    </xsl:template>

    <!--Exctract IEPD-->
    <xsl:template name="ExtractIepSchema">
        <xsl:param name="msgelement"/>
        <xsl:param name="outdir"/>
        <xsl:variable name="mid" select="translate($msgelement/xs:annotation/xs:appinfo/*:Msg/@mtfid, ' .()', '')"/>
        <xsl:variable name="t" select="$msgelement/@type"/>
        <xsl:result-document href="{$outdir}/{concat(lower-case($mid),'-iep.xsd')}">
            <xsl:for-each select="$iep-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xsl:apply-templates select="text()" mode="identity"/>
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:value-of select="concat($msgelement/*:annotation/*:appinfo/*:Msg/@name, ' MESSAGE SCHEMA')"/>
                        </xs:documentation>
                        <xsl:copy-of select="$msgelement/*:annotation/*:appinfo"/>
                    </xs:annotation>
                    <xsl:copy-of select="$msgelement" copy-namespaces="no"/>
                    <xsl:copy-of select="$ALLIEP/*:complexType[@name = $t]" copy-namespaces="no"/>
                    <xsl:variable name="msgnodes">
                        <xsl:for-each select="$ALLIEP/*:complexType[@name = $t]//*[@ref]">
                            <xsl:variable name="n" select="@ref"/>
                            <xsl:apply-templates select="$ALLIEP/*[@name = $n]" mode="iterateNode">
                                <xsl:with-param name="namelist">
                                    <node name="{$n}"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:for-each>
                        <xsl:for-each select="$ALLIEP/*:complexType[@name = $t]//*[@base]">
                            <xsl:variable name="n" select="@base"/>
                            <xsl:apply-templates select="$ALLIEP/*[@name = $n]" mode="iterateNode">
                                <xsl:with-param name="namelist">
                                    <node name="{$n}"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:for-each>
                        <xsl:for-each select="$ALLIEP/*:complexType[@name = $t]//*[@type]">
                            <xsl:variable name="n" select="@type"/>
                            <xsl:apply-templates select="$ALLIEP/*[@name = $n]" mode="iterateNode">
                                <xsl:with-param name="namelist">
                                    <node name="{$n}"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:for-each select="$msgnodes/*:complexType[not(@name = $t)]">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="count(preceding-sibling::*:complexType[@name = $n]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$msgnodes/*:simpleType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="count(preceding-sibling::*:simpleType[@name = $n]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$msgnodes/*:element[not(@name = $msgelement/@name)]">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="count(preceding-sibling::*:element[@name = $n]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xs:schema" mode="ExtractIepSchema">
        <xsl:param name="outdir"/>
        <xsl:variable name="xsd" select="."/>
        <xsl:variable name="msgelement" select="xs:element[1]"/>
        <xsl:variable name="mid" select="translate($msgelement/xs:annotation/xs:appinfo/*:Msg/@mtfid, ' .()', '')"/>
        <xsl:variable name="t" select="$msgelement/@type"/>
        <xsl:result-document href="{$outdir}/{concat(lower-case($mid),'-iep.xsd')}">
            <xsl:for-each select="$iep-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xsl:apply-templates select="text()" mode="identity"/>
                    <xs:annotation>
                        <xs:documentation>
                            <xsl:value-of select="concat($msgelement/*:annotation/*:appinfo/*:Msg/@name, ' MESSAGE SCHEMA')"/>
                        </xs:documentation>
                        <xsl:copy-of select="$msgelement/*:annotation/*:appinfo"/>
                    </xs:annotation>
                    <xsl:copy-of select="$msgelement" copy-namespaces="no"/>
                    <xsl:copy-of select="$xsd/*:complexType[@name = $t]" copy-namespaces="no"/>
                    <xsl:variable name="msgnodes">
                        <xsl:for-each select="$xsd/*:complexType[@name = $t]//*[@ref]">
                            <xsl:variable name="n" select="@ref"/>
                            <xsl:apply-templates select="$xsd/*[@name = $n]" mode="iterateNode">
                                <xsl:with-param name="namelist">
                                    <node name="{$n}"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:for-each>
                        <xsl:for-each select="$xsd/*:complexType[@name = $t]//*[@base]">
                            <xsl:variable name="n" select="@base"/>
                            <xsl:apply-templates select="$ALLIEP/*[@name = $n]" mode="iterateNode">
                                <xsl:with-param name="namelist">
                                    <node name="{$n}"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:for-each>
                        <xsl:for-each select="$xsd/*:complexType[@name = $t]//*[@type]">
                            <xsl:variable name="n" select="@type"/>
                            <xsl:apply-templates select="./*[@name = $n]" mode="iterateNode">
                                <xsl:with-param name="namelist">
                                    <node name="{$n}"/>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:for-each select="$msgnodes/*:complexType[not(@name = $t)]">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="count(preceding-sibling::*:complexType[@name = $n]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$msgnodes/*:simpleType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="count(preceding-sibling::*:simpleType[@name = $n]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$msgnodes/*:element[not(@name = $msgelement/@name)]">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="count(preceding-sibling::*:element[@name = $n]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$msgnodes/*:attributeGroup">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="count(preceding-sibling::*:attributeGroup[@name = $n]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$msgnodes/*:attribute">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="count(preceding-sibling::*:attribute[@name = $n]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*" mode="iterateNode">
        <xsl:param name="namelist"/>
        <xsl:variable name="node" select="."/>
        <xsl:copy-of select="$node" copy-namespaces="no"/>
        <xsl:for-each select="$node//@*[name() = 'ref' or name() = 'type' or name() = 'base' or name() = 'substitutionGroup' or name() = 'abstract'][not(. = $node/@name)]">
            <xsl:variable name="n">
                <xsl:value-of select="."/>
            </xsl:variable>
            <xsl:if test="not($namelist/node[@name = $n])">
                <xsl:apply-templates select="$ALLIEP/*[@name = $n]" mode="iterateNode">
                    <xsl:with-param name="namelist">
                        <xsl:copy-of select="$namelist"/>
                        <node name="{$n}"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!--Convert to IEPD-->
    <xsl:template match="*" mode="iepd">
        <xsl:variable name="r" select="@ref"/>
        <xsl:choose>
            <xsl:when test="parent::xs:schema and xs:annotation/xs:appinfo/*:Choice">
                <xs:element name="{@name}" type="{@type}">
                    <xsl:copy-of select="xs:annotation" copy-namespaces="no"/>
                    <xsl:for-each select="$ALLMTF//xs:element[@substitutionGroup = $r]">
                        <xsl:variable name="t" select="@type"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:variable name="match">
                            <xsl:copy-of select="$ALLMTF/xs:schema/xs:element[@name = $n][@type = $t]"/>
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
                    <xsl:for-each select="$ALLMTF//xs:element[@substitutionGroup = $r]">
                        <xsl:variable name="t" select="@type"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:variable name="match">
                            <xsl:copy-of select="$ALLMTF/xs:schema/xs:element[@name = $n][@type = $t]"/>
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
    <xsl:template match="xs:attributeGroup[@ref = 'structures:SimpleObjectAttributeGroup']" mode="iepd">
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
            <xsl:for-each select="$ALLMTF//xs:element[@substitutionGroup = $n]">
                <xsl:variable name="t" select="@type"/>
                <xsl:variable name="n" select="@name"/>
                <xsl:variable name="match" select="$ALLMTF/xs:schema/xs:element[@name = $n][@type = $t]"/>
                <xs:element ref="{@name}">
                    <xsl:copy-of select="$match/xs:annotation" copy-namespaces="no"/>
                </xs:element>
            </xsl:for-each>
        </xs:choice>
    </xsl:template>
    <xsl:template match="*[contains(@ref, 'AugmentationPoint')]" mode="iepd"/>
    <xsl:template match="@abstract" mode="iepd"/>
    <xsl:template match="*" mode="identity">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="identity"/>
            <xsl:apply-templates select="text()" mode="identity"/>
            <xsl:apply-templates select="*" mode="identity"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="identity">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    <xsl:template match="text()" mode="identity">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

</xsl:stylesheet>
