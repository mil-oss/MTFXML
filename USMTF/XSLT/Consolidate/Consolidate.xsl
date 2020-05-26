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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="MsgList" select="document('../../XSD/Baseline_Schema/Consolidated/MessageList.xml')"/>
    <xsl:variable name="ConsolidatedFieldsPath" select="'../../XSD/Baseline_Schema/Consolidated/fields.xsd'"/>
    <xsl:variable name="ConsolidatedCompositesPath" select="'../../XSD/Baseline_Schema/Consolidated/composites.xsd'"/>
    <xsl:variable name="ConsolidatedSetsPath" select="'../../XSD/Baseline_Schema/Consolidated/sets.xsd'"/>
    <xsl:variable name="ConsolidatedMessagesPath" select="'../../XSD/Baseline_Schema/Consolidated/messages.xsd'"/>
    

    <xsl:variable name="allfields">
        <xsl:apply-templates select="$MsgList//Msg" mode="fieldlist"/>
    </xsl:variable>
    <xsl:variable name="uniquefields">
        <xsl:apply-templates select="$allfields/field" mode="uniquelist">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="allcomposites">
        <xsl:apply-templates select="$MsgList//Msg" mode="compositelist"/>
    </xsl:variable>  
    <xsl:variable name="uniquecomposites">
        <xsl:apply-templates select="$allcomposites/composite" mode="uniquelist">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="allsets">
        <xsl:apply-templates select="$MsgList//Msg" mode="setlist"/>
    </xsl:variable>    
    <xsl:variable name="uniquesets">
        <xsl:apply-templates select="$allsets/set" mode="uniquelist">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="alltypes">
        <xsl:apply-templates select="$uniquefields/field" mode="gettypes"/>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document method="xml" href="{$ConsolidatedFieldsPath}">
            <xs:schema targetNamespace="urn:mtf:mil:6040b:elemental" xml:lang="en-US" xmlns="urn:mtf:mil:6040b:elemental" xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xs:import namespace="http://www.w3.org/XML/1998/namespace" schemaLocation="http://www.w3.org/2001/xml.xsd"/>
                <xsl:copy-of select="$alltypes" copy-namespaces="no"/>
            </xs:schema>
        </xsl:result-document>
        <xsl:result-document method="xml" href="{$ConsolidatedCompositesPath}">
            <xs:schema targetNamespace="urn:mtf:mil:6040b:composite" xml:lang="en-US" xmlns="urn:mtf:mil:6040b:composite" xmlns:f="urn:mtf:mil:6040b:elemental" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xs:import namespace="urn:mtf:mil:6040b:elemental" schemaLocation="fields.xsd"/>
                <xsl:apply-templates select="$uniquecomposites/composite" mode="gettypes"/>
            </xs:schema>
        </xsl:result-document>
        <xsl:result-document method="xml" href="{$ConsolidatedSetsPath}">
            <xs:schema targetNamespace="urn:mtf:mil:6040b:set" xml:lang="en-US" xmlns="urn:mtf:mil:6040b:set" xmlns:c="urn:mtf:mil:6040b:composite" xmlns:f="urn:mtf:mil:6040b:elemental"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ism="urn:us:gov:ic:ism:v2" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:ICISM="urn:us:gov:ic:ism:v2" elementFormDefault="unqualified"
                attributeFormDefault="unqualified">
                <xs:import namespace="urn:mtf:mil:6040b:composite" schemaLocation="composites.xsd"/>
                <xs:import namespace="urn:mtf:mil:6040b:elemental" schemaLocation="fields.xsd"/>
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
                <xsl:apply-templates select="$uniquesets/set" mode="gettypes"/>
            </xs:schema>
        </xsl:result-document>
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

    <!--FIELDS-->
    <xsl:template match="Msg" mode="fieldlist">
        <xsl:if test="doc-available(concat(@path, '/fields.xsd'))">
            <xsl:apply-templates select="document(concat(@path, '/fields.xsd'))/*:schema/*" mode="fieldlist"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:import" mode="fieldlist"/>
    <xsl:template match="*:complexType | *:simpleType" mode="fieldlist">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="field" mode="uniquelist">
        <xsl:variable name="nm">
            <xsl:value-of select="string(@name)"/>
        </xsl:variable>
        <xsl:if test="not($nm = preceding-sibling::field/@name)">
            <xsl:copy copy-namespaces="no">
                <xsl:attribute name="name">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
            </xsl:copy>
        </xsl:if>
    </xsl:template>    
    <xsl:template match="field" mode="gettypes">
        <xsl:variable name="t">
            <xsl:apply-templates select="$MsgList//Msg" mode="fieldtypelist">
                <xsl:with-param name="nm" select="string(@name)"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:apply-templates select="$t/*[1]" mode="xsdcopy"/>
    </xsl:template>
    <xsl:template match="Msg" mode="fieldtypelist">
        <xsl:param name="nm"/>
        <xsl:apply-templates select="document(concat(@path, '/fields.xsd'))/*:schema/*[@name = $nm]" mode="xsdcopy"/>
    </xsl:template>

    <!--COMPOSITES-->
    <xsl:template match="Msg" mode="compositelist">
        <xsl:if test="doc-available(concat(@path, '/composites.xsd'))">
            <xsl:apply-templates select="document(concat(@path, '/composites.xsd'))/*:schema/*" mode="compositelist"/>
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
            <xsl:apply-templates select="$MsgList//Msg" mode="compositetypelist">
                <xsl:with-param name="nm" select="string(@name)"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:apply-templates select="$t/*[1]" mode="xsdcopy"/>
    </xsl:template>
    <xsl:template match="Msg" mode="compositetypelist">
        <xsl:param name="nm"/>
        <xsl:apply-templates select="document(concat(@path,'/composites.xsd'))/*:schema/*[@name=$nm]" mode="xsdcopy"/>
    </xsl:template>
    
    <!--SETS-->
    <xsl:template match="Msg" mode="setlist">
        <xsl:if test="doc-available(concat(@path,'/sets.xsd'))">
            <xsl:apply-templates select="document(concat(@path,'/sets.xsd'))/*:schema/*" mode="setlist"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:import" mode="setlist"/>
    <xsl:template match="*:complexType | *:simpleType" mode="setlist">
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
            <xsl:apply-templates select="$MsgList//Msg" mode="settypelist">
                <xsl:with-param name="nm" select="string(@name)"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:apply-templates select="$t/*[1]" mode="xsdcopy"/>
    </xsl:template>
    <xsl:template match="Msg" mode="settypelist">
        <xsl:param name="nm"/>
        <xsl:apply-templates select="document(concat(@path,'/sets.xsd'))/*:schema/*[@name=$nm]" mode="xsdcopy"/>
    </xsl:template>
    
    <!--MESSAGES-->
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
            <xsl:value-of select="replace(replace(., '&#34;', ''), 'xsd:', 'xs:')"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

</xsl:stylesheet>
