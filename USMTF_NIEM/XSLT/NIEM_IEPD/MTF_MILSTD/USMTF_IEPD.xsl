<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="srcpath" select="'../../../XSD/NIEM_MTF/'"/>
    <xsl:variable name="Outdir" select="'../../../XSD/NIEM_IEPD/MILSTD_MTF/'"/>
    <xsl:variable name="AllMTF" select="document(concat($srcpath, 'NIEM_MTF_REF.xsd'))"/>
    <xsl:variable name="mtfappinf" select="document(concat($srcpath, 'ext/mtfappinfo.xsd'))"/>
    <xsl:variable name="locterm" select="document(concat($srcpath, 'ext/localTerminology.xsd'))"/>
    <xsl:variable name="appinf" select="document(concat($srcpath, 'ext/niem/appinfo/4.0/appinfo.xsd'))"/>
    <xsl:variable name="struct" select="document(concat($srcpath, 'ext/niem/utility/structures/4.0/structures.xsd'))"/>
    <xsl:variable name="icism" select="document(concat($srcpath, 'ext/ic-xml/ic-ism.xsd'))"/>

    <xsl:template name="main">
        <!--COPY REF XSD TO USMTF-IEPD FOLDER-->
        <xsl:result-document href="{concat($Outdir,'USMTF-IEPD/xml/xsd/NIEM_MTF_REF.xsd')}">
            <xsl:copy-of select="$AllMTF/*"/>
        </xsl:result-document>
        <!--CREATE CUMULATIVE IEPD AND COPY TO USMTF-IEPD FOLDER-->
        <xsl:result-document href="{concat($Outdir,'USMTF-IEPD/xml/xsd/MILSTD_MTF.xsd')}">
            <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="urn:int:nato:ncdf:mtf" targetNamespace="urn:int:nato:ncdf:mtf" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xsl:apply-templates select="$AllMTF/xs:schema/*" mode="milstd"/>
            </xs:schema>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'USMTF-IEPD/xml/xsd/ext/niem/appinfo/4.0/appinfo.xsd')}">
            <xsl:copy-of select="$appinf/xs:schema"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'USMTF-IEPD/xml/xsd/ext/niem/utility/structures/4.0/structures.xsd')}">
            <xsl:copy-of select="$struct/xs:schema"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'USMTF-IEPD/xml/xsd/ext/mtfappinfo.xsd')}">
            <xsl:copy-of select="$mtfappinf/xs:schema"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'USMTF-IEPD/xml/xsd/ext/localTerminology.xsd')}">
            <xsl:copy-of select="$locterm/xs:schema"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'USMTF-IEPD/xml/xsd/ext/ic-xml/ic-ism.xsd')}">
            <xsl:copy-of select="$icism/xs:schema"/>
        </xsl:result-document>
        
        <!--COPY REF XSD, NCDF RESOURCES, AND CREATED MSG IEPD TO MSG IEPD FOLDER-->
        <xsl:for-each select="$AllMTF/xs:schema/xs:element[xs:annotation/xs:appinfo/*:Msg]">
            <xsl:sort select="xs:annotation/xs:appinfo/*:Msg/@mtfid"/>
            <xsl:variable name="mid" select="translate(xs:annotation/xs:appinfo/*:Msg/@mtfid, ' .()', '')"/>
            <xsl:variable name="indoc" select="document(concat($srcpath, 'SepMsgs/', $mid, '-REF.xsd'))"/>
            <!--COPY MSG REF XSD TO MSG IEPD FOLDER-->
            <xsl:result-document href="{$Outdir}/{concat($mid,'-IEPD/xml/xsd/',$mid,'-REF.xsd')}">
                <xsl:copy-of select="$indoc"/>
            </xsl:result-document>
            <!--COPY NIEM RESOURCES TO EACH MSG IEPD FOLDER-->
            <xsl:result-document href="{$Outdir}/{concat($mid,'-IEPD/xml/xsd/ext/niem/appinfo/4.0/appinfo.xsd')}">
                <xsl:copy-of select="$appinf/xs:schema"/>
            </xsl:result-document>
            <xsl:result-document href="{$Outdir}/{concat($mid,'-IEPD/xml/xsd/ext/niem/utility/structures/4.0/structures.xsd')}">
                <xsl:copy-of select="$struct/xs:schema"/>
            </xsl:result-document>
            <xsl:result-document href="{$Outdir}/{concat($mid,'-IEPD/xml/xsd/ext/mtfappinfo.xsd')}">
                <xsl:copy-of select="$mtfappinf/xs:schema"/>
            </xsl:result-document>
            <xsl:result-document href="{$Outdir}/{concat($mid,'-IEPD/xml/xsd/ext/localTerminology.xsd')}">
                <xsl:copy-of select="$locterm/xs:schema"/>
            </xsl:result-document>
            <xsl:result-document href="{$Outdir}/{concat($mid,'-IEPD/xml/xsd/ext/ic-xml/ic-ism.xsd')}">
                <xsl:copy-of select="$icism/xs:schema"/>
            </xsl:result-document>
            <!--COPY CREATED IMPLEMENTATION XSD TO MSG IEPD FOLDER-->
            <xsl:result-document href="{concat($Outdir,$mid,'-IEPD/xml/xsd/',$mid,'.xsd')}">
                <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="urn:int:nato:ncdf:mtf" targetNamespace="urn:int:nato:ncdf:mtf" xml:lang="en-US" elementFormDefault="unqualified"
                    attributeFormDefault="unqualified" version="1.0">
                    <xsl:apply-templates select="$indoc/xs:schema/*" mode="milstd"/>
                </xs:schema>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*" mode="milstd">
        <xsl:variable name="r" select="@ref | @name"/>
        <xsl:choose>
            <xsl:when test="@name and xs:annotation/xs:appinfo/*:Choice">
                <xs:element name="{@name}" type="{@type}">
                    <xsl:copy-of select="xs:annotation" copy-namespaces="no"/>
                    <xsl:for-each select="$AllMTF//xs:element[@substitutionGroup = $r]">
                        <xsl:variable name="t" select="@type"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:variable name="match">
                            <xsl:copy-of select="$AllMTF/xs:schema/xs:element[@name = $n][@type = $t]"/>
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
                    <xsl:for-each select="$AllMTF//xs:element[@substitutionGroup = $r]">
                        <xsl:variable name="t" select="@type"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:variable name="match">
                            <xsl:copy-of select="$AllMTF/xs:schema/xs:element[@name = $n][@type = $t]"/>
                        </xsl:variable>
                        <xs:element ref="{@name}">
                            <xsl:copy-of select="$match/*/xs:annotation" copy-namespaces="no"/>
                        </xs:element>
                    </xsl:for-each>
                </xs:choice>
            </xsl:when>
            <xsl:when test="name() = 'xs:sequence' and count(*) = 1 and *[1]/name() = 'xs:choice'">
                <xsl:apply-templates select="*" mode="milstd"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*" mode="milstd"/>
                    <xsl:apply-templates select="*" mode="milstd"/>
                    <xsl:apply-templates select="text()" mode="milstd"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@substitutionGroup" mode="milstd"/>
    <xsl:template match="@*" mode="milstd">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="text()" mode="milstd">
        <xsl:copy-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="@ref" mode="getRefComplexType">
        <xsl:param name="xsd"/>
        <xsl:variable name="t" select="$xsd/xs:schema/xs:element[@name = .]/@type"/>
        <xsl:copy-of select="$xsd/xs:schema/xs:complexType[@name = $t]" copy-namespaces="no"/>
    </xsl:template>
    <xsl:template match="xs:complexType/xs:complexContent" mode="milstd">
        <xsl:apply-templates select="xs:extension/*" mode="milstd"/>
    </xsl:template>

    <!--<xsl:template match="*[contains(@name, 'AugmentationPoint')]" mode="milstd"/>-->

    <xsl:template match="xs:schema/*[@type = 'GeneralTextType']" mode="milstd">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@name"/>
            <xsl:copy-of select="xs:annotation" copy-namespaces="no"/>
            <xs:complexType>
                <xs:complexContent>
                    <xs:extension base="GeneralTextType">
                        <xs:sequence>
                            <xs:element name="TextIndicatorText" minOccurs="1" maxOccurs="1" fixed="{xs:annotation/*/*/@textindicator}"/>
                            <xs:element ref="FreeText" minOccurs="1" maxOccurs="1"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xs:schema/*[@type = 'HeadingInformationType']" mode="milstd">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@name"/>
            <xsl:copy-of select="xs:annotation" copy-namespaces="no"/>
            <xs:complexType>
                <xs:complexContent>
                    <xs:extension base="HeadingInformationType">
                        <xs:sequence>
                            <xs:element name="TextIndicatorText" minOccurs="1" maxOccurs="1" fixed="{xs:annotation/*/*/@textindicator}"/>
                            <xs:element ref="FreeText" minOccurs="1" maxOccurs="1"/>
                        </xs:sequence>
                    </xs:extension>
                </xs:complexContent>
            </xs:complexType>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xs:element[@ref = 'MessageIdentifier']" mode="milstd">
        <xsl:variable name="msgidset">
            <xsl:variable name="r" select="@ref"/>
            <xsl:variable name="t" select="$AllMTF/xs:schema/xs:element[@name = $r]/@type"/>
            <xsl:copy-of select="$AllMTF/xs:schema/xs:complexType[@name = $t]"/>
        </xsl:variable>
        <xs:element name="MessageIdentifier">
            <xsl:copy-of select="$msgidset/xs:annotation" copy-namespaces="no"/>
            <xs:complexType>
                <xsl:apply-templates select="$msgidset/*/xs:complexContent" mode="milstd"/>
            </xs:complexType>
        </xs:element>
    </xsl:template>
    <xsl:template match="xs:element[@ref = 'MessageTextFormatIdentifierText']" mode="milstd">
        <xs:element name="MessageTextFormatIdentifierText" type="MessageTextFormatIdentifierTextType">
            <xsl:apply-templates select="@*[not(name() = 'ref')]" mode="milstd"/>
            <xsl:apply-templates select="*" mode="milstd"/>
            <xsl:apply-templates select="text()" mode="milstd"/>
        </xs:element>
    </xsl:template>
    <xsl:template match="xs:element[@ref = 'StandardOfMessageTextFormatCode']" mode="milstd">
        <xs:element name="StandardOfMessageTextFormatCode" type="StandardOfMessageTextFormatCodeType">
            <xsl:apply-templates select="@*[not(name() = 'ref')]" mode="milstd"/>
            <xsl:apply-templates select="*" mode="milstd"/>
            <xsl:apply-templates select="text()" mode="milstd"/>
        </xs:element>
    </xsl:template>
    <xsl:template match="xs:element[@ref = 'VersionOfMessageTextFormatText']" mode="milstd">
        <xs:element name="VersionOfMessageTextFormatText" type="VersionOfMessageTextFormatTextType">
            <xsl:apply-templates select="@*[not(name() = 'ref')]" mode="milstd"/>
            <xsl:apply-templates select="*" mode="milstd"/>
            <xsl:apply-templates select="text()" mode="milstd"/>
        </xs:element>
    </xsl:template>
    <xsl:template match="xs:attributeGroup[@ref = 'structures:SimpleObjectAttributeGroup']" mode="milstd"/>
    <xsl:template match="xs:schema/xs:import" mode="milstd"/>
    <xsl:template match="xs:schema/xs:element[@abstract]" mode="milstd"/>
    <xsl:template match="*[contains(@ref, 'AugmentationPoint')]" mode="milstd"/>
    <xsl:template match="@abstract" mode="milstd"/>
</xsl:stylesheet>
