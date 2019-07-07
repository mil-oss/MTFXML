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
    <xsl:variable name="ConsolidatedMessagesPath" select="'../../XSD/Baseline_Schema/Consolidated/messages.xsd'"/>

    <xsl:template name="main">
        <xsl:result-document method="xml" href="{$ConsolidatedMessagesPath}">
            <xs:schema targetNamespace="urn:mtf:mil:6040b" xml:lang="en-US" xmlns="urn:mtf:mil:6040b" xmlns:s="urn:mtf:mil:6040b:set" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ism="urn:us:gov:ic:ism:v2"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:ICISM="urn:us:gov:ic:ism:v2" elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xs:import namespace="urn:mtf:mil:6040b:set" schemaLocation="sets.xsd"/>
                <xs:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xs:annotation>
                    <xs:appinfo>
                        <ddms:security ICISM:classification="U" ICISM:ownerProducer="USA" ICISM:nonICmarkings="DIST_STMT_C"/>
                    </xs:appinfo>
                    <xs:appinfo>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use. Other requests for this document shall be
                        referred to Defense Information Systems Agency Interoperability Directorate. WARNING - This document contains technical data whose export is restricted by the Arms Export Control Act (Title 22,
                        U.S.C., Sec. 2751) or the Export Administration Act of 1979, as amended, Title 50, U.S.C., App. 2401. Violations of these export laws are subject to severe criminal penalties. Disseminate in
                        accordance with provisions of DOD Directive 5230.25.</xs:appinfo>
                </xs:annotation>
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
                <xsl:when test="starts-with(name(), 'xsd:')">
                    <xsl:value-of select="replace(name(),'xsd', 'xs')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

                <xsl:element name="{$n}">
                    <xsl:apply-templates select="@*" mode="xsdcopy"/>
                    <xsl:apply-templates select="text()"/>
                    <xsl:apply-templates select="*" mode="xsdcopy"/>
                </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*" mode="xsdcopy">
        <xsl:variable name="n">
            <xsl:choose>
                <xsl:when test="starts-with(name(), 'xsd:')">
                    <xsl:value-of select="replace(name(), 'xsd', 'xs')"/>
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
