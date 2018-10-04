<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="srcpath" select="'../../../XSD/NCDF_MTF_REF/'"/>
    <xsl:variable name="Outdir" select="'../../../XSD/NCDF_MTF_IEPD/'"/>
    <xsl:variable name="AllMTF" select="document(concat($srcpath, 'NCDF_MTF_REF.xsd'))"/>
    <xsl:variable name="mtfappinf" select="document(concat($srcpath, 'NCDF/mtfappinfo.xsd'))"/>
    <xsl:variable name="appinf" select="document(concat($srcpath, 'NCDF/appinfo.xsd'))"/>
    <xsl:variable name="struct" select="document(concat($srcpath, 'NCDF/structures.xsd'))"/>
    <xsl:variable name="locterm" select="document(concat($srcpath, 'NCDF/localTerminology.xsd'))"/>

    <xsl:template name="main">
        <!--COPY REF XSD TO IEPD FOLDER-->
        <xsl:result-document href="{concat($Outdir,'/_ALL/xml/xsd/NCDF_MTF_REF.xsd')}">
            <xsl:copy-of select="$AllMTF/*"/>
        </xsl:result-document>
        <!--CREATE CUMULATIVE IEPD AND COPY TO ALL_IEPD FOLDER-->
        <xsl:result-document href="{concat($Outdir,'/_ALL/xml/xsd/NCDF_MTF.xsd')}">
            <xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="urn:int:nato:ncdf:mtf" targetNamespace="urn:int:nato:ncdf:mtf" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xsl:apply-templates select="$AllMTF/xsd:schema/*" mode="milstd"/>
            </xsd:schema>
        </xsl:result-document>
        <!--COPY REF XSD, NCDF RESOURCES, AND CREATED MSG IEPD TO MSG IEPD FOLDER-->
        <xsl:for-each select="$AllMTF/xsd:schema/xsd:element[xsd:annotation/xsd:appinfo/*:Msg]">
            <xsl:sort select="xsd:annotation/xsd:appinfo/*:Msg/@mtfid"/>
            <xsl:variable name="mid" select="translate(xsd:annotation/xsd:appinfo/*:Msg/@mtfid, ' .', '')"/>
            <xsl:variable name="indoc" select="document(concat($srcpath, 'SepMsgRef/', $mid, '_REF.xsd'))"/>
            <!--COPY MSG REF XSD TO MSG IEPD FOLDER-->
            <xsl:result-document href="{$Outdir}/{concat($mid,'_IEPD/xml/xsd/',$mid,'_REF.xsd')}">
                <xsl:copy-of select="$indoc"/>
            </xsl:result-document>
            <!--COPY NCDF RESOURCES TO EACH MSG IEPD FOLDER-->
            <xsl:result-document href="{$Outdir}/{concat($mid,'_IEPD/xml/xsd/NCDF/appinfo.xsd')}">
                <xsl:copy-of select="$appinf/xsd:schema"/>
            </xsl:result-document>
            <xsl:result-document href="{$Outdir}/{concat($mid,'_IEPD/xml/xsd/NCDF/mtfappinfo.xsd')}">
                <xsl:copy-of select="$mtfappinf/xsd:schema"/>
            </xsl:result-document>
            <xsl:result-document href="{$Outdir}/{concat($mid,'_IEPD/xml/xsd/NCDF/structures.xsd')}">
                <xsl:copy-of select="$struct/xsd:schema"/>
            </xsl:result-document>
            <xsl:result-document href="{$Outdir}/{concat($mid,'_IEPD/xml/xsd/NCDF/localTerminology.xsd')}">
                <xsl:copy-of select="$locterm/xsd:schema"/>
            </xsl:result-document>
            <!--COPY CREATTED IMPLEMENTATION XSD TO MSG IEPD FOLDER-->
            <xsl:result-document href="{concat($Outdir,$mid,'_IEPD/xml/xsd/',$mid,'.xsd')}">
                <xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="urn:int:nato:ncdf:mtf" targetNamespace="urn:int:nato:ncdf:mtf" xml:lang="en-US" elementFormDefault="unqualified"
                    attributeFormDefault="unqualified" version="1.0">
                    <xsl:apply-templates select="$indoc/xsd:schema/*" mode="milstd"/>
                </xsd:schema>
            </xsl:result-document>
        </xsl:for-each>
        <!--  <xsl:result-document href="{concat($outdir,'MILSTD_MTF.xsd')}">
            <xsd:schema xmlns="urn:int:nato:ncdf:mtf" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:int:nato:ncdf:mtf" xml:lang="en-US" elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsl:copy-of select="$MILSTDMTF" copy-namespaces="no"/>
            </xsd:schema>
        </xsl:result-document>-->
        <!--<xsl:for-each select="$AllMTF/*/xsd:element[xsd:annotation/xsd:appinfo/*:Msg]">
            <xsl:variable name="mid" select="translate(xsd:annotation/xsd:appinfo/*:Msg/@mtfid,' .','')"/>
            <xsl:call-template name="ExtractMessageSchema">
                <xsl:with-param name="message" select="."/>
                <xsl:with-param name="outdir" select="concat($Outdir,$mid,'_IEPD/')"/>
            </xsl:call-template>
        </xsl:for-each>-->
    </xsl:template>

    <xsl:template match="*" mode="milstd">
        <xsl:variable name="r" select="@ref"/>
        <xsl:choose>
            <xsl:when test="parent::xsd:schema and xsd:annotation/xsd:appinfo/*:Choice">
                <xsd:element name="{@name}" type="{@type}">
                    <xsl:copy-of select="xsd:annotation" copy-namespaces="no"/>
                    <xsl:for-each select="$AllMTF//xsd:element[@substitutionGroup = $r]">
                        <xsl:variable name="t" select="@type"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:variable name="match">
                            <xsl:copy-of select="$AllMTF/xsd:schema/xsd:element[@name = $n][@type = $t]"/>
                        </xsl:variable>
                        <xsd:element ref="{@name}">
                            <xsl:copy-of select="$match/*/xsd:annotation" copy-namespaces="no"/>
                        </xsd:element>
                    </xsl:for-each>
                </xsd:element>
            </xsl:when>
            <xsl:when test="xsd:annotation/xsd:appinfo/*:Choice">
                <xsd:choice>
                    <xsl:copy-of select="@minOccurs"/>
                    <xsl:copy-of select="@maxOccurs"/>
                    <xsl:copy-of select="xsd:annotation" copy-namespaces="no"/>
                    <xsl:for-each select="$AllMTF//xsd:element[@substitutionGroup = $r]">
                        <xsl:variable name="t" select="@type"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:variable name="match">
                            <xsl:copy-of select="$AllMTF/xsd:schema/xsd:element[@name = $n][@type = $t]"/>
                        </xsl:variable>
                        <xsd:element ref="{@name}">
                            <xsl:copy-of select="$match/*/xsd:annotation" copy-namespaces="no"/>
                        </xsd:element>
                    </xsl:for-each>
                </xsd:choice>
            </xsl:when>
            <xsl:when test="xsd:annotation/xsd:appinfo/*:Choice">
                <xsd:choice>
                    <xsl:copy-of select="xsd:annotation" copy-namespaces="no"/>
                    <xsl:for-each select="$AllMTF//xsd:element[@substitutionGroup = $r]">
                        <xsl:variable name="t" select="@type"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:variable name="match">
                            <xsl:copy-of select="$AllMTF/xsd:schema/xsd:element[@name = $n][@type = $t]"/>
                        </xsl:variable>
                        <xsd:element ref="{@name}">
                            <xsl:copy-of select="$match/*/xsd:annotation" copy-namespaces="no"/>
                        </xsd:element>
                    </xsl:for-each>
                </xsd:choice>
            </xsl:when>
            <xsl:when test="name() = 'xsd:sequence' and count(*) = 1 and *[1]/name() = 'xsd:choice'">
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
        <xsl:variable name="t" select="$xsd/xsd:schema/xsd:element[@name = .]/@type"/>
        <xsl:copy-of select="$xsd/xsd:schema/xsd:complexType[@name = $t]" copy-namespaces="no"/>
    </xsl:template>
    <xsl:template match="xsd:complexType/xsd:complexContent" mode="milstd">
        <xsl:apply-templates select="xsd:extension/*" mode="milstd"/>
    </xsl:template>

    <!--<xsl:template match="*[contains(@name, 'AugmentationPoint')]" mode="milstd"/>-->

    <xsl:template match="xsd:schema/*[@type = 'GeneralTextType']" mode="milstd">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@name"/>
            <xsl:copy-of select="xsd:annotation" copy-namespaces="no"/>
            <xsd:complexType>
                <xsd:complexContent>
                    <xsd:extension base="GeneralTextType">
                        <xsd:sequence>
                            <xsd:element name="TextIndicatorText" minOccurs="1" maxOccurs="1" fixed="{xsd:annotation/*/*/@textindicator}"/>
                            <xsd:element ref="FreeText" minOccurs="1" maxOccurs="1"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:schema/*[@type = 'HeadingInformationType']" mode="milstd">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@name"/>
            <xsl:copy-of select="xsd:annotation" copy-namespaces="no"/>
            <xsd:complexType>
                <xsd:complexContent>
                    <xsd:extension base="HeadingInformationType">
                        <xsd:sequence>
                            <xsd:element name="TextIndicatorText" minOccurs="1" maxOccurs="1" fixed="{xsd:annotation/*/*/@textindicator}"/>
                            <xsd:element ref="FreeText" minOccurs="1" maxOccurs="1"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:element[@ref = 'MessageIdentifier']" mode="milstd">
        <xsl:variable name="msgidset">
            <xsl:variable name="r" select="@ref"/>
            <xsl:variable name="t" select="$AllMTF/xsd:schema/xsd:element[@name = $r]/@type"/>
            <xsl:copy-of select="$AllMTF/xsd:schema/xsd:complexType[@name = $t]"/>
        </xsl:variable>
        <xsd:element name="MessageIdentifier">
            <xsl:copy-of select="$msgidset/xsd:annotation" copy-namespaces="no"/>
            <xsd:complexType>
                <xsl:apply-templates select="$msgidset/*/xsd:complexContent" mode="milstd"/>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@ref = 'MessageTextFormatIdentifierText']" mode="milstd">
        <xsd:element name="MessageTextFormatIdentifierText" type="MessageTextFormatIdentifierTextType">
            <xsl:apply-templates select="@*[not(name() = 'ref')]" mode="milstd"/>
            <xsl:apply-templates select="*" mode="milstd"/>
            <xsl:apply-templates select="text()" mode="milstd"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@ref = 'StandardOfMessageTextFormatCode']" mode="milstd">
        <xsd:element name="StandardOfMessageTextFormatCode" type="StandardOfMessageTextFormatCodeType">
            <xsl:apply-templates select="@*[not(name() = 'ref')]" mode="milstd"/>
            <xsl:apply-templates select="*" mode="milstd"/>
            <xsl:apply-templates select="text()" mode="milstd"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@ref = 'VersionOfMessageTextFormatText']" mode="milstd">
        <xsd:element name="VersionOfMessageTextFormatText" type="VersionOfMessageTextFormatTextType">
            <xsl:apply-templates select="@*[not(name() = 'ref')]" mode="milstd"/>
            <xsl:apply-templates select="*" mode="milstd"/>
            <xsl:apply-templates select="text()" mode="milstd"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:attributeGroup[@ref = 'structures:SimpleObjectAttributeGroup']" mode="milstd"/>
    <xsl:template match="xsd:schema/xsd:import" mode="milstd"/>
    <xsl:template match="xsd:schema/xsd:element[@abstract]" mode="milstd"/>
    <xsl:template match="*[contains(@ref, 'AugmentationPoint')]" mode="milstd"/>
    <xsl:template match="@abstract" mode="milstd"/>
</xsl:stylesheet>
