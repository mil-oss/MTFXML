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
    
    <xsl:variable name="MsgList" select="document('../../XSD/Normalized/MessageList.xml')"/>
    <xsl:variable name="ConsolidatedMessagesPath" select="'../../XSD/APP-11C-ch1/Consolidated/messages.xsd'"/>

    <xsl:template name="main">
        <xsl:result-document method="xml" href="{$ConsolidatedMessagesPath}">
                <xs:schema targetNamespace="urn:int:nato:mtf:app-11(c):change01:msgs" 
                    xml:lang="en-GB"
                    elementFormDefault="unqualified" 
                    attributeFormDefault="unqualified" 
                    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                    xmlns="urn:int:nato:mtf:app-11(c):change01:msgs" 
                    xmlns:s="urn:int:nato:mtf:app-11(c):change01:sets">
                    <xs:import namespace="urn:int:nato:mtf:app-11(c):change01:sets" schemaLocation="sets.xsd" />
                <xsl:apply-templates select="$MsgList//Msg" mode="makemsgschema"/>
            </xs:schema>
        </xsl:result-document>
    </xsl:template>


    <xsl:template match="Msg" mode="makemsgschema">
        <xsl:if test="doc-available(concat(@path,'/messages.xsd'))">
            <xsl:apply-templates select="document(concat(@path,'/messages.xsd'))/*:schema/*:element" mode="xsdcopy"/>
        </xsl:if>
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
