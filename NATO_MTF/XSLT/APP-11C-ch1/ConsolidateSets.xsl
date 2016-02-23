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
    
    <xsl:variable name="MsgList" select="document('../../XML/MessageList.xml')"/>
    <xsl:variable name="ConsolidatedSetsPath" select="'../../XSD/APP-11C-ch1/Consolidated/sets.xsd'"/>

    <xsl:variable name="allsets">
        <xsl:apply-templates select="$MsgList/NatoMsgs/Msg" mode="setlist"/>
    </xsl:variable>

    <xsl:variable name="uniquesets">
        <xsl:apply-templates select="$allsets/set" mode="uniquelist">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document method="xml" href="{$ConsolidatedSetsPath}">
            <xsd:schema targetNamespace="urn:int:nato:mtf:app-11(c):change01:sets" 
                xml:lang="en-GB" 
                elementFormDefault="unqualified" 
                attributeFormDefault="unqualified" 
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                xmlns="urn:int:nato:mtf:app-11(c):change01:sets" 
                xmlns:c="urn:int:nato:mtf:app-11(c):change01:composites" 
                xmlns:f="urn:int:nato:mtf:app-11(c):change01:elementals">
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):change01:composites" schemaLocation="composites.xsd" />
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):change01:elementals" schemaLocation="fields.xsd" />
            <xsl:apply-templates select="$uniquesets/set" mode="gettypes"/>
        </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="Msg" mode="setlist">
        <xsl:if test="doc-available(concat(@path,'/sets.xsd'))">
            <xsl:apply-templates select="document(concat(@path,'/sets.xsd'))/xsd:schema/xsd:*"
                mode="setlist"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xsd:import" mode="setlist"/>

    <xsl:template match="xsd:complexType | xsd:simpleType" mode="setlist">
        <xsl:element name="set">
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template match="set" mode="uniquelist">
        <xsl:variable name="nm">
            <xsl:value-of select="string(@name)"/>
        </xsl:variable>
        <xsl:if test="not($nm=preceding-sibling::set/@name)">
            <xsl:copy copy-namespaces="no">
                <xsl:attribute name="name">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="set" mode="gettypes">
        <xsl:variable name="t">
            <xsl:apply-templates select="$MsgList/NatoMsgs/Msg" mode="typelist">
                <xsl:with-param name="nm" select="string(@name)"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:copy-of select="$t/*[1]"/>
    </xsl:template>

    <xsl:template match="Msg" mode="typelist">
        <xsl:param name="nm"/>
        <xsl:copy-of select="document(concat(@path,'/sets.xsd'))/xsd:schema/xsd:*[@name=$nm]"
            copy-namespaces="no"/>
    </xsl:template>

</xsl:stylesheet>
