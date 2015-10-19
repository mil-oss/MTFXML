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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="mtfmsgs" select="document('../../XSD/APP-11C-ch1/Consolidated/messages.xsd')"/>
    <xsl:variable name="fields" select="document('../../XSD/APP-11C-GoE/natomtf_goe_fields.xsd')"/>
    <xsl:variable name="sets" select="document('../../XSD/APP-11C-GoE/natomtf_goe_sets.xsd')"/>
    <xsl:variable name="segments" select="document('../../XSD/APP-11C-GoE/natomtf_goe_segments.xsd')"/>
    <xsl:variable name="outputdoc" select="'../../XSD/APP-11C-GoE/natomtf_goe_messages.xsd'"/>
    <xsl:variable name="msgs">
        <xsl:apply-templates select="$mtfmsgs/xsd:schema/xsd:element" mode="el"/>
    </xsl:variable>
    <xsl:variable name="ctypes">
        <xsl:apply-templates select="$mtfmsgs/xsd:schema/xsd:element" mode="ctype"/>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:result-document href="{$outputdoc}">
            <xsd:schema xml:lang="en-US" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="urn:int:nato:mtf:app-11(c):goe:mtf"
                targetNamespace="urn:int:nato:mtf:app-11(c):goe:mtf" xmlns:field="urn:int:nato:mtf:app-11(c):goe:elementals"
                xmlns:set="urn:int:nato:mtf:app-11(c):goe:sets" xmlns:seg="urn:int:nato:mtf:app-11(c):goe:segments" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:elementals" schemaLocation="natomtf_goe_fields.xsd"/>
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:sets" schemaLocation="natomtf_goe_sets.xsd"/>
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:segments" schemaLocation="natomtf_goe_segments.xsd"/>
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
                <xsl:value-of select="concat(@name, 'Type')"/>
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
            <Msg>
                <xsl:apply-templates select="*[not(name() = 'MtfStructuralRelationship')]" mode="attr"/>
                <xsl:apply-templates select="*:MtfRelatedDocument" mode="doc"/>
            </Msg>
            <xsl:apply-templates select="*[name() = 'MtfStructuralRelationship']" mode="attr"/>
        </xsl:copy>
    </xsl:template>
    <!--Include Rules as attribute strings.  Replace double quotes with single quotes-->
    <xsl:template match="*[name() = 'MtfStructuralRelationship']" mode="attr">
        <!--OMIT RULES ENFORCED BY ASSIGNED FIXED VALUES-->
        <xsl:choose>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipRule/text(), '[3]F1')"/>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipRule/text(), '[3]F2')"/>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipRule/text(), '[3]F3')"/>
            <xsl:otherwise>
                <xsl:element name="Structure">
                    <xsl:apply-templates select="*[string-length(text()[1]) > 0]" mode="trimattr"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>   
    <xsl:template match="*" mode="trimattr">
        <xsl:variable name="apos">&#39;</xsl:variable>
        <xsl:variable name="quot">&#34;</xsl:variable>
        <xsl:attribute name="{substring-after(name(),'MtfStructuralRelationship')}">
            <xsl:value-of select="normalize-space(replace(., $quot, $apos))" disable-output-escaping="yes"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:element" mode="ctype">
        <xsd:complexType name="{concat(@name,'Type')}">
            <xsl:apply-templates select="@*" mode="ctype"/>
            <xsl:apply-templates select="xsd:annotation" mode="el"/>
            <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]" mode="ctype"/>
        </xsd:complexType>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:element/@name" mode="ctype"/>
    <xsl:template match="xsd:schema/xsd:element/xsd:annotation/xsd:appinfo" mode="ctype"/>
    <xsl:template match="xsd:element" mode="ctype">
        <xsl:variable name="elname">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exists($sets/xsd:schema/xsd:element[@name = $elname])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('set:', $elname)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')][not(name() = 'type')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="starts-with(./xsd:complexType/xsd:complexContent/xsd:extension/@base, 's:')">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="name">
                        <xsl:value-of select="$elname"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="replace(xsd:complexType/xsd:complexContent/xsd:extension/@base, 's:', 'set:')"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]" mode="ctype"/>
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
    <xsl:template match="xsd:element[ends-with(@name, 'Segment')]" mode="ctype">
        <xsl:variable name="elname">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:variable name="mtfid">
            <xsl:value-of select="ancestor::xsd:element[parent::xsd:schema]/xsd:annotation/xsd:appinfo/*:MtfIdentifier"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exists($segments/xsd:schema/xsd:element[@name = $elname])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('seg:', $elname)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')][not(name() = 'type')]" mode="ctype"/>
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
    <xsl:template match="xsd:complexType/xsd:sequence/xsd:choice/xsd:annotation/xsd:appinfo" mode="ctype"/>
    <xsl:template match="xsd:appinfo" mode="ctype">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="child::node()[starts-with(name(), 'Set')]">
                    <Set>
                        <xsl:apply-templates select="*[string-length(text()) > 0]" mode="attr"/>
                    </Set>
                </xsl:when>
                <xsl:when test="child::node()[starts-with(name(), 'Segment')]">
                    <Segment>
                        <xsl:apply-templates select="*[string-length(text()) > 0]" mode="attr"/>
                    </Segment>
                </xsl:when>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()" mode="ctype">
        <xsl:value-of select="replace(normalize-space(.), '&#34;', '')"/>
    </xsl:template>
    <xsl:template match="@*" mode="ctype">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="@base" mode="ctype">
        <xsl:attribute name="base">
            <xsl:value-of select="replace(., 's:', 'set:')"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*" mode="attr">
        <xsl:variable name="apos">
            <xsl:text>&apos;</xsl:text>
        </xsl:variable>
        <xsl:variable name="quot">
            <xsl:text>&quot;</xsl:text>
        </xsl:variable>
        <xsl:if test="string-length(text()) != 0">
            <xsl:attribute name="{name()}">
                <xsl:value-of select="replace(normalize-space(.), $quot, $apos)"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template name="CamelCase">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text, ' ')">
                <xsl:call-template name="CamelCaseWord">
                    <xsl:with-param name="text" select="substring-before($text, ' ')"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="CamelCase">
                    <xsl:with-param name="text" select="substring-after($text, ' ')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="CamelCaseWord">
                    <xsl:with-param name="text" select="$text"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="CamelCaseWord">
        <xsl:param name="text"/>
        <xsl:value-of select="translate(substring($text, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        <xsl:value-of select="translate(substring($text, 2, string-length($text) - 1), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionUseDescription" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="usage">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="positionName">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionNumber" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="position">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionConcept" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="concept">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:MtfName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="name">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:MtfIdentifier" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="identifier">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:MtfSponsor" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="sponsor">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:MtfPurpose" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="purpose">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:VersionIndicator" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="version">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:MtfNote" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="note">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:MtfRelatedDocument" mode="doc">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = 'NONE')">
            <xsl:if test="not(preceding-sibling::*:MtfRelatedDocument)">
                <xsl:element name="Document" namespace="urn:mtf:mil:6040b:goe:mtf">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:MtfRelatedDocument">
                    <xsl:element name="Document" namespace="urn:mtf:mil:6040b:goe:mtf">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:MtfIndexReferenceNumber" mode="attr"/>
    <xsl:template match="*:MtfRelatedDocument" mode="attr"/>
    <xsl:template match="*:OccurrenceCategory" mode="attr"/>
    <xsl:template match="*:Repeatability" mode="attr"/>

    <!--*************** Message Identifier Fixed Values **********************-->

    <xsl:template match="xsd:element[@name = 'MessageIdentifier']" mode="ctype">
        <xsd:element name="MessageIdentifier">
            <xsl:apply-templates select="@*" mode="msgid"/>
            <xsl:apply-templates select="$sets/xsd:schema/xsd:complexType[@name = 'MessageIdentifierType']/xsd:annotation" mode="msgid"/>
            <xsd:complexType>
                <xsl:apply-templates select="$sets/xsd:schema/xsd:complexType[@name = 'MessageIdentifierType']/xsd:complexContent" mode="msgid">
                    <xsl:with-param name="msgid" select="ancestor::xsd:complexType/xsd:attribute[@name = 'mtfid']/@fixed"/>
                </xsl:apply-templates>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="*" mode="msgid">
        <xsl:param name="msgid"/>
        <xsl:variable name="nm" select="@name"/>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="msgid"/>
            <xsl:apply-templates select="*" mode="msgid">
                <xsl:with-param name="msgid" select="$msgid"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*:Example" mode="msgid"/>
    <xsl:template match="*:Set" mode="msgid">
        <xsl:element name="Set" namespace="urn:mtf:mil:6040b:goe:mtf">
            <xsl:apply-templates select="@*" mode="msgid"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:Field" mode="msgid">
        <xsl:element name="Set" namespace="urn:mtf:mil:6040b:goe:mtf">
            <xsl:apply-templates select="@*" mode="msgid"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="@*" mode="msgid">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="@base[. = 'SetBaseType']" mode="msgid">
        <xsl:attribute name="base">
            <xsl:text>set:SetBaseType</xsl:text>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="text()" mode="msgid">
        <xsl:value-of select="normalize-space(translate(., '&#34;', ''))"/>
    </xsl:template>
    <xsl:template match="*[@name = 'MessageTextFormatIdentifier']" mode="msgid">
        <xsl:param name="msgid"/>
        <xsd:element name="MessageTextFormatIdentifier" type="field:MessageTextFormatIdentifierType" minOccurs="1" maxOccurs="1" nillable="true"
            fixed="{$msgid}"/>
    </xsl:template>
    <xsl:template match="*[@name = 'Standard']" mode="msgid">
        <xsd:element name="Standard" type="field:AlphaNumericBlankSpecialInitDataLoadIDType" minOccurs="1" maxOccurs="1" nillable="true"
            fixed="APP-11(C)"/>
    </xsl:template>
    <xsl:template match="*[@name = 'Version']" mode="msgid">
        <xsd:element name="Version" type="field:AlphaNumericBlankSpecialInitDataLoadIDType" minOccurs="1" maxOccurs="1" nillable="true"
            fixed="CHANGE01"/>
    </xsl:template>
</xsl:stylesheet>
