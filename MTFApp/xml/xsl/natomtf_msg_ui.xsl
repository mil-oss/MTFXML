<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:msg="urn:int:nato:mtf:app-11(c):goe:msgs"
    xmlns:set="urn:int:nato:mtf:app-11(c):goe:sets"
    xmlns:comp="urn:int:nato:mtf:app-11(c):goe:composites"
    xmlns:field="urn:int:nato:mtf:app-11(c):goe:fields"
    exclude-result-prefixes="xsd msg set comp field" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="NATO_MTF_MSG"
        select="document('../../../MTFXML/NATO_MTF/XSD/APP-11C-GoE/natomtf_goe_messages.xsd')"/>
    <xsl:param name="NATO_MTF_SETS"
        select="document('../../../MTFXML/NATO_MTF/XSD/APP-11C-GoE/natomtf_goe_sets.xsd')"/>
    <xsl:param name="NATO_MTF_COMPOSITES"
        select="document('../../../MTFXML/NATO_MTF/XSD/APP-11C-GoE/natomtf_goe_composites.xsd')"/>
    <xsl:param name="NATO_MTF_FIELDS"
        select="document('../../../MTFXML/NATO_MTF/XSD/APP-11C-GoE/natomtf_goe_fields.xsd')"/>

    <xsl:variable name="fields">
        <xsl:apply-templates select="$NATO_MTF_FIELDS/xsd:schema/xsd:simpleType"/>
    </xsl:variable>

    <xsl:variable name="composites">
        <xsl:apply-templates select="$NATO_MTF_COMPOSITES/xsd:schema/xsd:complexType"/>
    </xsl:variable>

    <xsl:variable name="sets">
        <xsl:apply-templates select="$NATO_MTF_SETS/xsd:schema/xsd:complexType"/>
    </xsl:variable>

    <xsl:variable name="msgs">
        <xsl:apply-templates select="$NATO_MTF_MSG/xsd:schema/xsd:complexType"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="../mtf/natomtf_fields_ui.xml">
            <xsl:element name="NATO_MTF_FIELDS" namespace="">
                <xsl:copy-of select="$fields"/>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="../mtf/natomtf_composites_ui.xml">
            <xsl:element name="NATO_MTF_COMPOSITES" namespace="">
                <xsl:copy-of select="$composites"/>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="../mtf/natomtf_sets_ui.xml">
            <xsl:element name="NATO_MTF_SETS" namespace="">
                <xsl:copy-of select="$sets"/>
            </xsl:element>
        </xsl:result-document>
        <xsl:result-document href="../mtf/natomtf_msgs_ui.xml">
            <xsl:element name="NATO_MTF_MSGS" namespace="">
                <xsl:copy-of select="$msgs"/>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xsd:complexType">
        <xsl:choose>
            <xsl:when test="ends-with(@name,'Type')">
                <xsl:element name="{substring(@name,0,string-length(@name)-3)}">
                    <xsl:apply-templates select="@*[not(name()='name')]"/>
                    <xsl:apply-templates select="xsd:attribute" mode="att"/>
                    <xsl:if test="string-length(xsd:annotation/xsd:documentation/text())&gt;0">
                        <xsl:attribute name="doc">
                            <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="doc"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:MsgInfo"/>
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SetFormat"/>
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SegmentStructure"/>
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
                    <xsl:apply-templates select="*"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@name">
                <xsl:element name="{@name}">
                    <xsl:apply-templates select="@*[not(name()='name')]"/>
                    <xsl:apply-templates select="xsd:attribute" mode="att"/>
                    <xsl:if test="string-length(xsd:annotation/xsd:documentation/text())&gt;0">
                        <xsl:attribute name="doc">
                            <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="doc"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:MsgInfo"/>
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SetFormat"/>
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SegmentStructure"/>
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
                    <xsl:apply-templates select="*"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="xsd:complexContent/xsd:extension/xsd:attribute"
                    mode="att"/>
                <xsl:apply-templates select="*"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:complexType/@name">
        <xsl:attribute name="name">
            <xsl:value-of select="substring(.,0,string-length(.)-3)"/>
        </xsl:attribute>
        <xsl:attribute name="type">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="xsd:simpleType">
        <xsl:element name="{substring-before(@name,'SimpleType')}">
            <xsl:apply-templates select="@*[not(name()='name')]"/>
            <xsl:apply-templates select="*//xsd:attribute" mode="att"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:simpleType/@name">
        <xsl:attribute name="name">
            <xsl:value-of select="substring-before(.,'SimpleType')"/>
        </xsl:attribute>
        <xsl:attribute name="type">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="xsd:element">
        <xsl:choose>
            <xsl:when test="@name">
                <xsl:element name="{@name}">
                    <xsl:apply-templates select="@*[not(name()='name')]"/>
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SetFormat"/>
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SegmentStructure"/>
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:FieldFormat"/>
                    <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
                    <xsl:apply-templates select="*"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@ref">
                <xsl:choose>
                    <xsl:when test="contains(@ref,':')">
                        <xsl:element name="{substring-after(@ref,':')}" namespace="">
                            <xsl:attribute name="ref">
                                <xsl:value-of select="@ref"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SetFormat"/>
                            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SegmentStructure"/>
                            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:FieldFormat"/>
                            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="{@ref}" namespace="">
                            <xsl:attribute name="ref">
                                <xsl:value-of select="@ref"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SetFormat"/>
                            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:SegmentStructure"/>
                            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:FieldFormat"/>
                            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*:Field"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
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
        <xsl:element name="enumeration" namespace="">
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

    <xsl:template match="xsd:*">
        <xsl:element name="{substring-after(name(),'xsd:')}" namespace="">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xsd:annotation/xsd:appinfo/*:MsgInfo">
        <xsl:apply-templates select="@*" mode="copy"/>
    </xsl:template>
    <xsl:template match="xsd:annotation/xsd:appinfo/*:SetFormat">
        <xsl:apply-templates select="@*" mode="copy"/>
    </xsl:template>
    <xsl:template match="xsd:annotation/xsd:appinfo/*:SegmentStructure">
        <xsl:apply-templates select="@*" mode="copy"/>
    </xsl:template>
    <xsl:template match="xsd:annotation/xsd:appinfo/*:FieldFormat">
        <xsl:apply-templates select="@*" mode="copy"/>
    </xsl:template>
    <xsl:template match="xsd:annotation/xsd:appinfo/*:Field">
        <xsl:apply-templates select="@*" mode="copy"/>
    </xsl:template>

    <xsl:template match="@type | @base">
        <xsl:copy-of select="."/>
        <xsl:variable name="t">
            <xsl:value-of select="substring-after(.,'field:')"/>
        </xsl:variable>
        <xsl:variable name="c">
            <xsl:value-of select="substring-after(.,'comp:')"/>
        </xsl:variable>
        <xsl:variable name="s">
            <xsl:value-of select="substring-after(.,'set:')"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="starts-with(.,'field:')">
                <xsl:apply-templates select="$fields/*[name()=$t]/@*" mode="copy"/>
                <xsl:apply-templates select="$fields/*[name()=$t]/*" mode="copy"/>
            </xsl:when>
            <xsl:when test="starts-with(.,'comp:')">
                <xsl:apply-templates select="$composites/*[name()=$c]/@*" mode="copy"/>
                <xsl:apply-templates select="$composites/*[name()=$c]/*" mode="copy"/>
            </xsl:when>
            <xsl:when test="starts-with(.,'set:')">
                <xsl:apply-templates select="$sets/*[name()=$s]/@*" mode="copy"/>
                <xsl:apply-templates select="$sets/*[name()=$s]/*" mode="copy"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="tb" select="."/>
                <xsl:apply-templates select="//xsd:schema/*[name()=$tb]/@*" mode="copy"/>
                <xsl:apply-templates select="//xsd:schema/*[name()=$tb]" mode="copy"/>
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
    
    <xsl:template match="@Type" mode="copy"/>
    <xsl:template match="@EntryType" mode="copy"/>
    <xsl:template match="@FieldFormatIndexReferenceNumber" mode="copy"/>
    <xsl:template match="@FudNumber" mode="copy"/>
    <xsl:template match="@ffirnFudn" mode="copy"/>
    <xsl:template match="@VersionIndicator" mode="copy"/>
    <xsl:template match="@AssignedFfirnFudUseDescription" mode="copy"/>

</xsl:stylesheet>
