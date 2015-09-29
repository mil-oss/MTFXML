<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2015 JD NEUSHUL
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">

    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="mtfmsgs" select="document('../../XSD/APP-11C-ch1/Consolidated/messages.xsd')"/>
    <xsl:variable name="sets" select="document('../../XSD/APP-11C-GoE/natomtf_goe_sets.xsd')"/>
    <xsl:variable name="fields" select="document('../../XSD/APP-11C-GoE/natomtf_goe_fields.xsd')"/>
    <xsl:variable name="composites" select="document('../../XSD/APP-11C-GoE/natomtf_goe_composites.xsd')"/>

    <xsl:variable name="msgs">
        <xsl:apply-templates select="$mtfmsgs/xsd:schema/xsd:element" mode="el"/>
    </xsl:variable>

    <xsl:variable name="ctypes">
        <xsl:apply-templates select="$mtfmsgs/xsd:schema/xsd:element" mode="ctype"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="../../XSD/APP-11C-GoE/natomtf_goe_messages.xsd">
            <xsd:schema xmlns="urn:int:nato:mtf:app-11(c):goe:msg"
                xmlns:set="urn:int:nato:mtf:app-11(c):goe:sets"
                xmlns:comp="urn:int:nato:mtf:app-11(c):goe:composites"
                xmlns:field="urn:int:nato:mtf:app-11(c):goe:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:int:nato:mtf:app-11(c):goe:msg" 
                xml:lang="en-GB"
                elementFormDefault="unqualified" 
                attributeFormDefault="unqualified">
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:sets"
                    schemaLocation="natomtf_goe_sets.xsd"/>
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:composites"
                    schemaLocation="natomtf_goe_composites.xsd"/>
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:fields"
                    schemaLocation="natomtf_goe_fields.xsd"/>
                <xsl:copy-of select="$ctypes"/>
                <xsl:copy-of select="$msgs"/>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="concat(@name,'Type')"/>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:element/xsd:annotation" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="*" mode="el"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:documentation" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element/xsd:annotation/xsd:appinfo" mode="el">
        <xsl:copy copy-namespaces="no">
            <MsgInfo>
                <xsl:apply-templates select="*[not(name()='MtfStructuralRelationship')]" mode="attr"
                />
            </MsgInfo>
            <xsl:apply-templates select="*[name()='MtfStructuralRelationship']" mode="attr"/>
        </xsl:copy>
    </xsl:template>
    
    <!--Include Rules as attribute strings.  Replace double quotes with single quotes-->
    <xsl:template match="*" mode="trimattr">
        <xsl:variable name="apos">&#39;</xsl:variable>
        <xsl:variable name="quot">&#34;</xsl:variable>
        <xsl:attribute name="{substring-after(name(),'MtfStructuralRelationship')}">
            <xsl:value-of select="normalize-space(replace(.,$quot,$apos))"
                disable-output-escaping="yes"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element" mode="ctype">
        <xsd:complexType name="{concat(@name,'Type')}">
            <xsl:apply-templates select="@*" mode="ctype"/>
            <xsl:apply-templates select="xsd:annotation" mode="el"/>
            <xsl:apply-templates select="*[not(name()='xsd:annotation')]" mode="ctype"/>
        </xsd:complexType>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element/@name" mode="ctype"/>

    <xsl:template match="xsd:schema/xsd:element/xsd:annotation/xsd:appinfo" mode="ctype"/>

    <xsl:template match="xsd:element" mode="ctype">
        <xsl:variable name="nm" select="@name"/>
        <xsl:choose>
            <xsl:when test="exists($sets/xsd:schema/xsd:element[@name=$nm])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('set:',@name)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='name')][not(name()='type')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="exists($fields/xsd:schema/xsd:element[@name=$nm])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('field:',@name)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='name')][not(name()='type')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="exists($composites/xsd:schema/xsd:element[@name=$nm])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('comp:',@name)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='name')][not(name()='type')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*" mode="ctype"/>
                    <xsl:apply-templates select="*" mode="ctype"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="xsd:extension" mode="ctype">
        <xsl:variable name="b">
            <xsl:choose>
                <xsl:when test="starts-with(@base,'s:')">
                    <xsl:value-of select="substring-after(@base,'s:')"/>
                </xsl:when>
                <xsl:when test="starts-with(@base,'f:')">
                    <xsl:value-of select="substring-after(@base,'f:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="string(@base)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exists($sets/xsd:schema/xsd:complexType[@name=$b])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="base">
                        <xsl:value-of select="concat('set:',$b)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='base')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="exists($fields/xsd:schema/xsd:complexType[@name=$b])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="base">
                        <xsl:value-of select="concat('field:',$b)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='base')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="exists($composites/xsd:schema/xsd:complexType[@name=$b])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="base">
                        <xsl:value-of select="concat('comp:',$b)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='base')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*" mode="ctype"/>
                    <xsl:apply-templates select="*" mode="ctype"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element/xsd:complexType" mode="ctype">
        <xsl:apply-templates select="@*" mode="ctype"/>
        <xsl:apply-templates select="*" mode="ctype"/>
    </xsl:template>

    <xsl:template match="*" mode="ctype">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="ctype"/>
            <xsl:apply-templates select="*" mode="ctype"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xsd:documentation" mode="ctype">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="text()" mode="ctype"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:complexType/xsd:sequence/xsd:choice/xsd:annotation/xsd:appinfo"
        mode="ctype">
        <xsl:copy copy-namespaces="no">
            <AltInfo>
                <xsl:apply-templates select="*" mode="attr"/>
            </AltInfo>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:appinfo" mode="ctype">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="child::node()[starts-with(name(),'SetFormat')]">
                    <SetFormat>
                        <xsl:apply-templates select="*[string-length(text())&gt;0]" mode="attr"/>
                    </SetFormat>
                </xsl:when>
                <xsl:when test="child::node()[starts-with(name(),'SegmentStructure')]">
                    <SegmentStructure>
                        <xsl:apply-templates select="*[string-length(text())&gt;0]" mode="attr"/>
                    </SegmentStructure>
                </xsl:when>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" mode="ctype">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="@*" mode="ctype">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="*" mode="attr">
        <xsl:variable name="apos">
            <xsl:text>&apos;</xsl:text>
        </xsl:variable>
        <xsl:variable name="quot">
            <xsl:text>&quot;</xsl:text>
        </xsl:variable>
        <xsl:if test="string-length(text())!=0">
            <xsl:attribute name="{name()}">
                <xsl:value-of select="replace(normalize-space(.),$quot,$apos)"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[name()='MtfStructuralRelationship']" mode="attr">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="*[string-length(text()[1])&gt;0]" mode="trimattr"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
