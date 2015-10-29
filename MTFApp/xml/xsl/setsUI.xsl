<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="USMTF_SETS" select="document('../xsd/USMTF/GoE_sets.xsd')"/>
    <xsl:variable name="NATO_SETS" select="document('../xsd/NATOMTF/natomtf_goe_sets.xsd')"/>
    <xsl:variable name="usmtf_sets_out" select="'../../JSON/xml/usmtf_sets_ui.xml'"/>
    <xsl:variable name="nato_sets_out" select="'../../JSON/xml/nato_sets_ui.xml'"/>
    <xsl:variable name="usmtf_sets">
        <xsl:apply-templates select="$USMTF_SETS/xsd:schema/xsd:element"/>
    </xsl:variable>
    <xsl:variable name="nato_sets">
        <xsl:apply-templates select="$NATO_SETS/xsd:schema/xsd:element"/>
    </xsl:variable>
    <xsl:template name="setsUI">
        <xsl:result-document href="{$usmtf_sets_out}">
            <xsl:element name="USMTF_Sets">
                <xsl:for-each select="$usmtf_sets/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="{$nato_sets_out}">
            <xsl:element name="NATO_Sets">
                <xsl:for-each select="$nato_sets/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:element">
        <xsl:variable name="t">
            <xsl:value-of select="@type"/>
        </xsl:variable>
        <xsl:element name="Set">
            <xsl:attribute name="tag">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="@type"/>
            </xsl:attribute>
            <xsl:apply-templates select="ancestor::xsd:schema/xsd:complexType[@name = $t]"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:complexType[starts-with(@name, 'Amplification')]">
        <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set" mode="info"/>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:complexType[starts-with(@name, 'Narrative')]">
        <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set" mode="info"/>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:complexType[not(starts-with(@name, 'Amplification'))][not(starts-with(@name, 'Narrative'))]">
        <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="attr"/>
        <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set" mode="info"/>
        <Set ref="{//xsd:schema/xsd:complexType[@name='SetBaseType']/xsd:sequence/xsd:element[1]/@name}"/>
        <Set ref="{//xsd:schema/xsd:complexType[@name='SetBaseType']/xsd:sequence/xsd:element[2]/@name}"/>
        <xsl:apply-templates select="xsd:complexContent/xsd:extension/*"/>
    </xsl:template>
    <xsl:template match="xsd:documentation" mode="attr">
        <xsl:if test="text()">
            <xsl:attribute name="doc">
                <xsl:value-of select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:Set" mode="info">
        <xsl:element name="Info">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:Field" mode="info">
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
    <xsl:template match="xsd:sequence/xsd:element[@name][@type][not(starts-with(@type, 'field:'))]">
        <xsl:element name="Set">
            <xsl:attribute name="tag">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="@type"/>
            </xsl:attribute>
            <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="attr"/>
            <xsl:apply-templates select="@*[not(name() = 'name')][not(name() = 'type')]" mode="copy"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set" mode="info"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:sequence/xsd:element[@name][xsd:annotation/xsd:appinfo/*:Field]">
        <xsl:element name="Field">
            <xsl:attribute name="tag" select="@name"/>
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select=".//@base[1]" mode="copy"/>
            <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="attr"/>
            <xsl:apply-templates select=".//xsd:restriction[1]/*" mode="attr"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field" mode="info"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:element[@ref][starts-with(@ref, 'field:')]">
        <xsl:element name="Field">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field" mode="info"/>
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
