<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:mtf="urn:mtf:mil:6040b:goe:mtf"
    xmlns:field="urn:mtf:mil:6040b:goe:fields" xmlns:set="urn:mtf:mil:6040b:goe:sets" xmlns:seg="urn:mtf:mil:6040b:goe:segments"
    xmlns:ism="urn:us:gov:ic:ism:v2" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="USMTF_MSG" select="document('../schema/USMTF/GoE_messages.xsd')"/>
    <xsl:param name="USMTF_SEGMENTS" select="document('../schema/USMTF/GoE_segments.xsd')"/>
    <xsl:param name="USMTF_SETS" select="document('../schema/USMTF/GoE_sets.xsd')"/>
    <xsl:param name="USMTF_FIELDS" select="document('../schema/USMTF/GoE_fields.xsd')"/>
    <xsl:param name="NATO_MSG" select="document('../schema/NATOMTF/natomtf_goe_messages.xsd')"/>
    <xsl:param name="NATO_SEGMENTS" select="document('../schema/NATOMTF/natomtf_goe_segments.xsd')"/>
    <xsl:param name="NATO_SETS" select="document('../schema/NATOMTF/natomtf_goe_sets.xsd')"/>
    <xsl:param name="NATO_FIELDS" select="document('../schema/NATOMTF/natomtf_goe_fields.xsd')"/>

    <xsl:variable name="usmtf_fields">
        <xsl:apply-templates select="$USMTF_FIELDS/xsd:schema/xsd:complexType"/>
    </xsl:variable>
    <xsl:variable name="usmtf_sets">
        <xsl:apply-templates select="$USMTF_SETS/xsd:schema/xsd:complexType"/>
    </xsl:variable>
    <xsl:variable name="usmtf_segments">
        <xsl:apply-templates select="$USMTF_SEGMENTS/xsd:schema/xsd:complexType"/>
    </xsl:variable>
    <xsl:variable name="usmtf_msgs">
        <xsl:apply-templates select="$USMTF_MSG/xsd:schema/xsd:complexType"/>
    </xsl:variable>

    <xsl:variable name="natomtf_fields">
        <xsl:apply-templates select="$NATO_FIELDS/xsd:schema/xsd:complexType"/>
    </xsl:variable>
    <xsl:variable name="natomtf_sets">
        <xsl:apply-templates select="$NATO_SETS/xsd:schema/xsd:complexType"/>
    </xsl:variable>
    <xsl:variable name="natomtf_segments">
        <xsl:apply-templates select="$NATO_SEGMENTS/xsd:schema/xsd:complexType"/>
    </xsl:variable>
    <xsl:variable name="natomtf_msgs">
        <xsl:apply-templates select="$NATO_MSG/xsd:schema/xsd:complexType"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="../mtf/usmtf_fields_ui.xml">
            <xsl:element name="USMTF_FIELDS">
                <xsl:copy-of select="$usmtf_fields"/>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="../mtf/usmtf_segments_ui.xml">
            <xsl:element name="USMTF_SEGMENTS">
                <xsl:copy-of select="$usmtf_segments"/>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="../mtf/usmtf_sets_ui.xml">
            <xsl:element name="USMTF_SETS">
                <xsl:copy-of select="$usmtf_sets"/>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="../mtf/usmtf_msgs_ui.xml">
            <xsl:element name="USMTF_MSGS">
                <xsl:copy-of select="$usmtf_msgs"/>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="../mtf/natomtf_fields_ui.xml">
            <xsl:element name="NATOMTF_FIELDS">
                <xsl:copy-of select="$natomtf_fields"/>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="../mtf/natomtf_segments_ui.xml">
            <xsl:element name="NATOMTF_SEGMENTS">
                <xsl:copy-of select="$natomtf_segments"/>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="../mtf/natomtf_sets_ui.xml">
            <xsl:element name="NATOMTF_SETS">
                <xsl:copy-of select="$natomtf_sets"/>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="../mtf/natomtf_msgs_ui.xml">
            <xsl:element name="NATOMTF_MSGS">
                <xsl:copy-of select="$natomtf_msgs"/>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xsd:complexType[@name][xsd:annotation/xsd:appinfo/*:Msg]">
        <xsl:element name="Msg">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="xsd:attribute" mode="att"/>
            <xsl:if test="string-length(xsd:annotation/xsd:documentation/text()) > 0">
                <xsl:attribute name="doc">
                    <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="doc"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Msg"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Segment"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:complexType[@name][xsd:annotation/xsd:appinfo/*:Segment]">
        <xsl:element name="Segment">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="xsd:attribute" mode="att"/>
            <xsl:if test="string-length(xsd:annotation/xsd:documentation/text()) > 0">
                <xsl:attribute name="doc">
                    <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="doc"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Msg"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Segment"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:complexType[@name][xsd:annotation/xsd:appinfo/*:Set]">
        <xsl:element name="Set">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="xsd:attribute" mode="att"/>
            <xsl:if test="string-length(xsd:annotation/xsd:documentation/text()) > 0">
                <xsl:attribute name="doc">
                    <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="doc"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Msg"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Segment"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:complexType[@name][xsd:annotation/xsd:appinfo/*:Field]">
        <xsl:element name="Field">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="xsd:attribute" mode="att"/>
            <xsl:if test="string-length(xsd:annotation/xsd:documentation/text()) > 0">
                <xsl:attribute name="doc">
                    <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="doc"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Msg"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Segment"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xsd:complexType[xsd:simpleType]">
        <xsl:element name="Field">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="xsd:attribute" mode="att"/>
            <xsl:if test="string-length(xsd:annotation/xsd:documentation/text()) > 0">
                <xsl:attribute name="doc">
                    <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="doc"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:complexType">
        <xsl:element name="FUCK">
        <xsl:apply-templates select="xsd:complexContent/xsd:extension/xsd:attribute" mode="att"/>
        <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:complexType/@name">
        <xsl:attribute name="name">
            <xsl:value-of select="substring(., 0, string-length(.) - 3)"/>
        </xsl:attribute>
        <xsl:attribute name="type">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="xsd:element[@name][xsd:annotation/xsd:appinfo/*:Set]">
        <xsl:element name="Set">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SetFormat"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SegmentStructure"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:FieldFormat"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:element[@name][xsd:annotation/xsd:appinfo/*:Segment]">
        <xsl:element name="Segment">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SetFormat"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SegmentStructure"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:FieldFormat"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:element[@name][xsd:annotation/xsd:appinfo/*:Field]">
        <xsl:element name="Field">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SetFormat"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SegmentStructure"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:FieldFormat"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:element[@ref][xsd:annotation/xsd:appinfo/*:Set]">
        <xsl:element name="Set" namespace="">
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="contains(@ref, ':')">
                        <xsl:value-of select="substring-after(@ref, ':')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@ref"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="ref">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Segment"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:element[@ref][xsd:annotation/xsd:appinfo/*:Segment]">
        <xsl:element name="Segment" namespace="">
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="contains(@ref, ':')">
                        <xsl:value-of select="substring-after(@ref, ':')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@ref"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="ref">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Segment"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:element[@ref][xsd:annotation/xsd:appinfo/*:Field]">
        <xsl:element name="Field" namespace="">
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="contains(@ref, ':')">
                        <xsl:value-of select="substring-after(@ref, ':')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@ref"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="ref">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Set"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Segment"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:complexContent">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="xsd:simpleContent">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="xsd:extension">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="xsd:restriction">
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="xsd:restriction[xsd:enumeration]">
        <xsl:element name="choice">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:enumeration">
        <xsl:element name="enumeration">
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Enum/@*" mode="copy"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:attribute" mode="att">
        <xsl:attribute name="{@name}{@ref}">
            <xsl:value-of select="@fixed"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="xsd:attribute"/>
    <xsl:template match="xsd:annotation"/>

    <xsl:template match="@*" mode="info">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="xsd:documentation" mode="doc">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="xsd:documentation"/>

    <xsl:template match="xsd:choice">
        <xsl:choose>
            <xsl:when test="preceding-sibling::xsd:choice">
                <xsl:element name="{concat('choice',count(preceding-sibling::xsd:choice))}">
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="*"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="choice">
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="*"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="xsd:sequence">
        <xsl:choose>
            <xsl:when test="preceding-sibling::xsd:sequence">
                <xsl:element name="{concat('sequence',count(preceding-sibling::xsd:sequence))}">
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="*"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="sequence">
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="*"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:*">
        <xsl:element name="{substring-after(name(),'xsd:')}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:annotation/xsd:appinfo/*:MsgInfo">
        <xsl:apply-templates select="@*" mode="copy"/>
    </xsl:template>
    <xsl:template match="xsd:annotation/xsd:appinfo/*:Set">
        <xsl:apply-templates select="@*" mode="copy"/>
    </xsl:template>
    <xsl:template match="xsd:annotation/xsd:appinfo/*:Segment">
        <xsl:apply-templates select="@*" mode="copy"/>
    </xsl:template>
    <xsl:template match="xsd:annotation/xsd:appinfo/*:Field">
        <xsl:apply-templates select="@*" mode="copy"/>
    </xsl:template>

    <xsl:template match="@type | @base">
        <xsl:variable name="ns" select="ancestor::xsd:schema/namespace-uri()"/>
        <xsl:copy-of select="."/>
        <xsl:variable name="t">
            <xsl:value-of select="substring-after(., 'field:')"/>
        </xsl:variable>
        <xsl:variable name="c">
            <xsl:value-of select="substring-after(., 'comp:')"/>
        </xsl:variable>
        <xsl:variable name="s">
            <xsl:value-of select="substring-after(., 'set:')"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="starts-with($ns, 'urn:int:nato')">
                <xsl:choose>
                    <xsl:when test="starts-with(., 'field:')">
                        <xsl:apply-templates select="$natomtf_fields/*[name() = $t]/@*" mode="copy"/>
                        <xsl:apply-templates select="$natomtf_fields/*[name() = $t]/*" mode="copy"/>
                    </xsl:when>
                    <xsl:when test="starts-with(., 'set:')">
                        <xsl:apply-templates select="$natomtf_sets/*[name() = $s]/@*" mode="copy"/>
                        <xsl:apply-templates select="$natomtf_sets/*[name() = $s]/*" mode="copy"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="tb" select="."/>
                        <xsl:apply-templates select="//xsd:schema/*[name() = $tb]/@*" mode="copy"/>
                        <xsl:apply-templates select="//xsd:schema/*[name() = $tb]" mode="copy"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with(., 'field:')">
                        <xsl:apply-templates select="$usmtf_fields/*[name() = $t]/@*" mode="copy"/>
                        <xsl:apply-templates select="$usmtf_fields/*[name() = $t]/*" mode="copy"/>
                    </xsl:when>
                    <xsl:when test="starts-with(., 'set:')">
                        <xsl:apply-templates select="$usmtf_sets/*[name() = $s]/@*" mode="copy"/>
                        <xsl:apply-templates select="$usmtf_sets/*[name() = $s]/*" mode="copy"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="tb" select="."/>
                        <xsl:apply-templates select="//xsd:schema/*[name() = $tb]/@*" mode="copy"/>
                        <xsl:apply-templates select="//xsd:schema/*[name() = $tb]" mode="copy"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="*" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="copy">
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>
