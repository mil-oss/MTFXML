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
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="MsgList" select="document('../../XSD/Baseline_Schema/Consolidated/MessageList.xml')"/>
    <xsl:variable name="ConsolidatedCompositesPath" select="'../../XSD/Baseline_Schema/Consolidated/composites.xsd'"/>

    <xsl:variable name="allcomposites">
        <xsl:apply-templates select="$MsgList//Msg" mode="compositelist"/>
    </xsl:variable>

    <xsl:variable name="uniquecomposites">
        <xsl:apply-templates select="$allcomposites/composite" mode="uniquelist">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document method="xml" href="{$ConsolidatedCompositesPath}">
            <xs:schema targetNamespace="urn:mtf:mil:6040b:composite" xml:lang="en-US" xmlns="urn:mtf:mil:6040b:composite" xmlns:f="urn:mtf:mil:6040b:elemental" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xs:import namespace="urn:mtf:mil:6040b:elemental" schemaLocation="fields.xsd"/>
                <xsl:apply-templates select="$uniquecomposites/composite" mode="gettypes"/>
            </xs:schema>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="Msg" mode="compositelist">
        <xsl:if test="doc-available(concat(@path,'/composites.xsd'))">
            <xsl:apply-templates select="document(concat(@path,'/composites.xsd'))/*:schema/*"
                mode="compositelist"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:import" mode="compositelist"/>

    <xsl:template match="*:complexType | *:simpleType" mode="compositelist">
        <xsl:element name="composite">
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template match="composite" mode="uniquelist">
        <xsl:variable name="nm">
            <xsl:value-of select="string(@name)"/>
        </xsl:variable>
        <xsl:if test="not($nm=preceding-sibling::composite/@name)">
            <xsl:copy copy-namespaces="no">
                <xsl:attribute name="name">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="composite" mode="gettypes">
        <xsl:variable name="t">
            <xsl:apply-templates select="$MsgList//Msg" mode="typelist">
                <xsl:with-param name="nm" select="string(@name)"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:apply-templates select="$t/*[1]" mode="xsdcopy"/>
    </xsl:template>

    <xsl:template match="Msg" mode="typelist">
        <xsl:param name="nm"/>
        <xsl:apply-templates select="document(concat(@path,'/composites.xsd'))/*:schema/*[@name=$nm]" mode="xsdcopy"/>
    </xsl:template>

    <xsl:template match="*" mode="xsdcopy">
        <xsl:variable name="n">
            <xsl:choose>
                <xsl:when test="contains(name(), ':')">
                    <xsl:value-of select="substring-after(name(), ':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="prefix">
            <xsl:choose>
                <xsl:when test="starts-with(name(), 'xsd:')">
                    <xsl:value-of select="replace(substring-before(name(), ':'), 'xsd', 'xs')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(name(), ':')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$prefix = 'xs'">
                <xsl:element name="{concat($prefix,':',$n)}">
                    <xsl:apply-templates select="@*" mode="xsdcopy"/>
                    <xsl:apply-templates select="text()"/>
                    <xsl:apply-templates select="*" mode="xsdcopy"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{$n}">
                    <xsl:apply-templates select="@*" mode="xsdcopy"/>
                    <xsl:apply-templates select="text()"/>
                    <xsl:apply-templates select="*" mode="xsdcopy"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@*" mode="xsdcopy">
        <xsl:variable name="n">
            <xsl:choose>
                <xsl:when test="contains(name(), ':')">
                    <xsl:value-of select="substring-after(name(), ':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="{$n}">
            <xsl:value-of select="replace(replace(., '&#34;', ''),'xsd:','xs:')"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    

</xsl:stylesheet>
