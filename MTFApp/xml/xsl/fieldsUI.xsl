<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="USMTF_FIELDS" select="document('../xsd/USMTF/GoE_fields.xsd')"/>
    <xsl:variable name="NATO_FIELDS" select="document('../xsd/NATOMTF/natomtf_goe_fields.xsd')"/>
    <xsl:variable name="usmtf_fields_out" select="'../../json/usmtf_fields_ui.xml'"/>
    <xsl:variable name="nato_fields_out" select="'../../json/nato_fields_ui.xml'"/>

    <xsl:variable name="usmtf_fields">
        <xsl:apply-templates select="$USMTF_FIELDS/xsd:schema/xsd:element"/>
    </xsl:variable>

    <xsl:variable name="nato_fields">
        <xsl:apply-templates select="$NATO_FIELDS/xsd:schema/xsd:element"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="{$usmtf_fields_out}">
            <xsl:element name="USMTF_Fields">
                <xsl:for-each select="$usmtf_fields/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="{$nato_fields_out}">
            <xsl:element name="NATO_Fields">
                <xsl:for-each select="$nato_fields/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xsd:element">
        <xsl:variable name="b">
            <xsl:value-of select=".//@base[1]"/>
        </xsl:variable>
        <xsl:variable name="t">
            <xsl:value-of select="@type"/>
        </xsl:variable>
        <xsl:element name="Field">
            <xsl:attribute name="tag">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*" mode="att"/>
            <xsl:apply-templates select="*" mode="att"/>
            <xsl:apply-templates select="ancestor::xsd:schema/xsd:complexType[@name = $b]" mode="att"/>
            <xsl:apply-templates select="ancestor::xsd:schema/xsd:complexType[@name = $t]" mode="att"/>
            <xsl:apply-templates select="ancestor::xsd:schema/xsd:complexType[@name = $b]"/>
            <xsl:apply-templates select="ancestor::xsd:schema/xsd:complexType[@name = $t]"/>
            <xsl:apply-templates select=".//*:Field"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:element[@ref]">
        <xsl:element name="Field">
            <xsl:attribute name="ref">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[not(name() = 'ref')]"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:minLength | xsd:maxLength | xsd:length | xsd:minInclusive | xsd:maxInclusive" mode="att">
        <xsl:attribute name="{substring-after(name(),'xsd:')}">
            <xsl:value-of select="@value"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="*:Field">
        <xsl:if test="not(preceding-sibling::*:Field)">
            <xsl:element name="Info">
                <xsl:apply-templates select="@*"/>
            </xsl:element>
            <xsl:for-each select="following-sibling::*:Field">
                <xsl:element name="Info">
                    <xsl:apply-templates select="@*"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="xsd:pattern">
        <xsl:if test="not(preceding-sibling::xsd:pattern)">
            <xsl:element name="regex">
                <xsl:element name="pattern">
                    <xsl:value-of select="@value"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::xsd:pattern">
                    <xsl:element name="pattern">
                        <xsl:value-of select="@value"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
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

    <xsl:template match="xsd:complexType">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="*">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    
    <xsl:template match="xsd:documentation" mode="att">
        <xsl:attribute name="doc">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="*" mode="att">
        <xsl:apply-templates select="@*" mode="att"/>
        <xsl:apply-templates select="*" mode="att"/>
    </xsl:template>

    <xsl:template match="@*" mode="att">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="@base | @value"/>
    <xsl:template match="@ref[. = 'ism:SecurityAttributesOptionGroup']" mode="att"/>
    <xsl:template match="xsd:complexType/@name"/>
    <xsl:template match="xsd:element/@name"/>
</xsl:stylesheet>
