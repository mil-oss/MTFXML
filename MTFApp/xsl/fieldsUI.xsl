<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="usmtf_flds" select="document('../xml/xsd/USMTF/GoE_fields.xsd')"/>
    <xsl:variable name="nato_flds" select="document('../xml/xsd/NATOMTF/natomtf_goe_fields.xsd')"/>
    <xsl:variable name="usmtf_fields_out" select="'../xml/xml/usmtf_fields_ui.xml'"/>
    <xsl:variable name="nato_fields_out" select="'../xml/xml/nato_fields_ui.xml'"/>

    <xsl:template name="allfieldsUI">
        <xsl:result-document href="{$usmtf_fields_out}">
            <xsl:call-template name="fieldsUI">
                <xsl:with-param name="mtf_fields" select="$usmtf_flds"/>
            </xsl:call-template>
        </xsl:result-document>
        <xsl:result-document href="{$nato_fields_out}">
            <xsl:call-template name="fieldsUI">
                <xsl:with-param name="mtf_fields" select="$nato_flds"/>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="fieldsUI">
        <xsl:param name="mtf_fields"/>
        <xsl:variable name="fields">
            <xsl:apply-templates select="$mtf_fields/xsd:schema/xsd:element"/>
        </xsl:variable>
        <xsl:element name="Fields">
            <xsl:for-each select="$fields/*">
                <xsl:sort select="@name"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template match="/">
        <xsl:element name="Fields">
            <xsl:apply-templates select="xsd:schema/xsd:element">
                <xsl:sort select="@name"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:element[not(@type)][not(@ref)]">
        <xsl:variable name="b">
            <xsl:value-of select=".//@base[1]"/>
        </xsl:variable>
        <xsl:element name="Field">
            <xsl:attribute name="tag">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:if test="@type">
                <xsl:attribute name="type">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select=".//@base[1]" mode="copy"/>
            <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="att"/>
            <xsl:apply-templates select=".//xsd:restriction/*" mode="att"/>
            <xsl:apply-templates select="ancestor::xsd:schema/xsd:complexType[@name = $b]"/>
            <xsl:apply-templates select=".//*:Field" mode="info"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:element[@type]">
        <xsl:variable name="t">
            <xsl:value-of select="@type"/>
        </xsl:variable>
        <xsl:element name="Field">
            <xsl:attribute name="tag">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="@type"/>
            </xsl:attribute>
            <xsl:apply-templates select="ancestor::xsd:schema/xsd:complexType[@name = $t]//xsd:documentation" mode="att"/>
            <xsl:apply-templates select="ancestor::xsd:schema/xsd:complexType[@name = $t]//*:Field" mode="info"/>
            <xsl:apply-templates select="ancestor::xsd:schema/xsd:complexType[@name = $t]/xsd:sequence"/>
            <xsl:apply-templates select="ancestor::xsd:schema/xsd:complexType[@name = $t]//xsd:enumeration"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xsd:documentation" mode="att">
        <xsl:if test="text()">
            <xsl:attribute name="doc">
                <xsl:value-of select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="xsd:pattern">
        <xsl:attribute name="regex">
            <xsl:value-of select="@value"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="xsd:minLength | xsd:maxLength | xsd:length | xsd:minInclusive | xsd:maxInclusive | xsd:fractionDigits | xsd:totalDigits"
        mode="att">
        <xsl:attribute name="{substring-after(name(),'xsd:')}">
            <xsl:value-of select="@value"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*:Field" mode="info">
        <xsl:if test="not(preceding-sibling::*:Field)">
            <xsl:element name="Info">
                <xsl:apply-templates select="@*" mode="copy"/>
                <xsl:apply-templates select="*" mode="copy"/>
            </xsl:element>
            <xsl:for-each select="following-sibling::*:Field">
                <xsl:element name="Info">
                    <xsl:apply-templates select="@*" mode="copy"/>
                    <xsl:apply-templates select="*" mode="copy"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="xsd:sequence">
        <Sequence>
            <xsl:apply-templates select="*"/>
        </Sequence>
    </xsl:template>
    <xsl:template match="xsd:element[@ref]">
        <xsl:element name="Field">
            <xsl:attribute name="ref">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
        </xsl:element>
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
    <xsl:template match="xsd:enumeration">
        <xsl:if test="not(preceding-sibling::xsd:enumeration)">
            <xsl:element name="choice">
                <xsl:element name="enumeration">
                    <xsl:copy-of select="@value"/>
                    <xsl:for-each select=".//*:Enum/@*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:element>
                <xsl:for-each select="following-sibling::xsd:enumeration">
                    <xsl:element name="enumeration">
                        <xsl:copy-of select="@value"/>
                        <xsl:for-each select=".//*:Enum/@*">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*" mode="att">
        <xsl:apply-templates select="*" mode="att"/>
    </xsl:template>
    <xsl:template match="@ref[. = 'ism:SecurityAttributesOptionGroup']"/>
</xsl:stylesheet>
