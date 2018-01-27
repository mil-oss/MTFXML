<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="srcpath" select="'../../../XSD/NIEM_MTF/'"/>
    <xsl:variable name="outdir" select="'../../../XSD/NIEM_IEPD/MILSTD_MTF/'"/>
    <xsl:variable name="AllMTF" select="document(concat($srcpath, 'NIEM_MTF.xsd'))"/>
    <xsl:variable name="MILSTDMTF">
        <xsl:apply-templates select="$AllMTF/xsd:schema/*" mode="milstd"/>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="{concat($outdir,'MILSTD_MTF.xsd')}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf" xml:lang="en-US" elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsl:copy-of select="$MILSTDMTF" copy-namespaces="no"/>
            </xsd:schema>
        </xsl:result-document>
        <xsl:for-each select="$MILSTDMTF//xsd:element[xsd:annotation/xsd:appinfo/*:Msg]">
            <xsl:call-template name="ExtractMessageSchema">
                <xsl:with-param name="message" select="."/>
                <xsl:with-param name="outdir" select="concat($outdir, 'SepMsgs/')"/>
            </xsl:call-template>
        </xsl:for-each>
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
    <xsl:template name="ExtractMessageSchema">
        <xsl:param name="message"/>
        <xsl:param name="outdir"/>
        <xsl:variable name="msgid" select="$MILSTDMTF/*[@name = $message/@type]/xsd:annotation/xsd:appinfo/*:Msg/@mtfid"/>
        <xsl:variable name="mid" select="translate($msgid, ' .:()', '')"/>
        <!--<xsl:variable name="schtron">
            <xsl:value-of
                select="concat($lt, '?xml-model', ' href=', $q, '../../../Baseline_Schema/MTF_Schema_Tests/', $mid, '.sch', $q, ' type=', $q, 'application/xml', $q, ' schematypens=', $q, 'http://purl.oclc.org/dsdl/schematron', $q, '?', $gt)"
            />
        </xsl:variable>-->
        <xsl:result-document href="{$outdir}/{concat($mid,'.xsd')}">
            <!--<xsl:text>&#10;</xsl:text>
            <xsl:value-of select="$schtron" disable-output-escaping="yes"/>
            <xsl:text>&#10;</xsl:text>-->
            <xsd:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="../IC-ISM.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../mtfappinfo.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat($message/xsd:annotation/xsd:appinfo/*:Msg/@mtfname, ' MESSAGE SCHEMA')"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <mtfappinfo:Msg mtfname="{$message/xsd:annotation/xsd:appinfo/*:Msg/@mtfname}" mtfid="{$msgid}"/>
                    </xsd:appinfo>
                </xsd:annotation>
                <xsl:copy-of select="$message"/>
                <xsl:copy-of select="$MILSTDMTF/xsd:complexType[@name = $message/@type]"/>
                <xsl:variable name="all">
                    <xsl:for-each select="$MILSTDMTF/*[@name = $message/@type]//*[@ref | @base | @type]">
                        <xsl:variable name="n" select="@ref | @base | @type"/>
                        <xsl:call-template name="iterateNode">
                            <xsl:with-param name="node" select="$MILSTDMTF/*[@name = $n]"/>
                            <xsl:with-param name="iteration" select="18"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:for-each select="$all/xsd:complexType[not(@name = $message/@type)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:complexType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all/xsd:simpleType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:simpleType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all/xsd:element[not(@name = $message/@name)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:element[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="iterateNode">
        <xsl:param name="node"/>
        <xsl:param name="iteration"/>
        <xsl:copy-of select="$node"/>
        <xsl:if test="$iteration &gt; 0">
            <xsl:for-each select="$node//@*[name() = 'ref' or name() = 'type' or name() = 'base'][not(. = $node/@name)]">
                <xsl:variable name="n">
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="node" select="$MILSTDMTF/*[@name = $n]"/>
                    <xsl:with-param name="iteration" select="number($iteration - 1)"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
