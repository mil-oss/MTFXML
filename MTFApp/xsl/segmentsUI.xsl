<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="USMTF_SEGMENTS" select="document('../xml/xsd/USMTF/GoE_segments.xsd')"/>
    <xsl:variable name="NATO_SEGMENTS" select="document('../xml/xsd/NATOMTF/natomtf_goe_segments.xsd')"/>
    <xsl:variable name="usmtf_segments_out" select="'../xml/xml/usmtf_segments_ui.xml'"/>
    <xsl:variable name="nato_segments_out" select="'../xml/xml/nato_segments_ui.xml'"/>
    <xsl:template name="allsegmentsUI">
        <xsl:result-document href="{$usmtf_segments_out}">
            <xsl:call-template name="segmentsUI">
                <xsl:with-param name="mtf_segments" select="$USMTF_SEGMENTS"/>
            </xsl:call-template>
        </xsl:result-document>
        <xsl:result-document href="{$nato_segments_out}">
            <xsl:call-template name="segmentsUI">
                <xsl:with-param name="mtf_segments" select="$NATO_SEGMENTS"/>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="segmentsUI">
        <xsl:param name="mtf_segments"/>
        <xsl:variable name="segments">
            <xsl:apply-templates select="$mtf_segments/xsd:schema/xsd:element"/>
        </xsl:variable>
        <xsl:element name="Segments">
            <xsl:for-each select="$segments/*">
                <xsl:sort select="name()"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match="/">
        <xsl:element name="Segments">
            <xsl:apply-templates select="xsd:schema/xsd:element">
                <xsl:sort select="name()"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:element">
        <xsl:variable name="t">
            <xsl:value-of select="@type"/>
        </xsl:variable>
        <xsl:element name="{@name}">
           <!-- <xsl:attribute name="tag">
                <xsl:value-of select="@name"/>
            </xsl:attribute>-->
            <xsl:attribute name="type">
                <xsl:value-of select="@type"/>
            </xsl:attribute>
            <xsl:apply-templates select="ancestor::xsd:schema/xsd:complexType[@name = $t]"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:complexType">
        <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Segment" mode="info"/>
        <xsl:apply-templates select="xsd:complexContent/xsd:extension/*"/>
    </xsl:template>
    <xsl:template match="*:Segment" mode="info">
        <xsl:element name="Info">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:Set" mode="info">
        <xsl:element name="Info">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:sequence">
        <xsl:element name="Sequence">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:choice">
        <xsl:element name="Choice">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:sequence/xsd:element[@name][xsd:annotation/xsd:appinfo/*:Set]">
        <xsl:element name="{@name}">
          <!--  <xsl:attribute name="tag">
                <xsl:value-of select="@name"/>
            </xsl:attribute>-->
            <xsl:attribute name="type">
                <xsl:value-of select="@type"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[not(name() = 'name')][not(name() = 'type')]" mode="copy"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set" mode="info"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:sequence/xsd:element[@name][xsd:annotation/xsd:appinfo/*:Field]">
        <xsl:element name="{@name}">
            <!--<xsl:attribute name="tag" select="@name"/>-->
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select=".//@base[1]" mode="copy"/>
            <xsl:apply-templates select=".//xsd:restriction[1]/*" mode="attr"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field" mode="info"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:element[@ref][starts-with(@ref, 'set:')]">
        <xsl:element name="{substring-after(@ref, 'set:')}">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set" mode="info"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:element[@ref][not(contains(@ref, ':'))]">
        <xsl:element name="{@ref}">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Segment" mode="info"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:minLength | xsd:maxLength | xsd:length | xsd:minInclusive | xsd:maxInclusive" mode="attr">
        <xsl:attribute name="{substring-after(name(),'xsd:')}">
            <xsl:value-of select="@value"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*:Document">
        <xsl:apply-templates select="." mode="copy"/>
    </xsl:template>
    <xsl:template match="*:Example">
        <xsl:apply-templates select="." mode="copy"/>
    </xsl:template>
    <xsl:template match="*">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="*" mode="copy">
        <xsl:element name="{name()}">
            <xsl:value-of select="text()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="@*" mode="copy">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="*:Field">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="*:Set">
        <xsl:apply-templates select="*"/>
    </xsl:template>
</xsl:stylesheet>
