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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!--  This XSLT refactors baseline USMTF "fields" XML Schema by replacing annotation elements
    with attributes, removing unused elements and other adjustments-->
    <!--Fields from the baseline Composites XML Schema are also included as ComplexTypes in accordance with the intent to 
    consolidate fields, composites and segments as global elements in the "Fields" XML Schema for the GoE refactor.
    type references are converted to local.-->
    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="baseline_sets_xsd" select="document('../../XSD/Baseline_Schema/sets.xsd')"/>
    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/GoE_Schema/GoE_fields_Initial.xsd')"/>
    <!--Set deconfliction and annotation changes-->
    <xsl:variable name="set_Changes" select="document('../../XSD/Deconflicted/Set_Name_Changes.xml')/USMTF_Sets"/>
    <xsl:variable name="sets_output" select="'../../XSD/GoE_Schema/GoE_sets.xsd'"/>
    <xsl:variable name="fields_output" select="'../../XSD/GoE_Schema/GoE_fields.xsd'"/>
    
    <!--Create root level complexTypes-->
    <xsl:variable name="complex_types">
        <xsl:for-each select="$baseline_sets_xsd/xsd:schema/xsd:complexType[not(@name = 'SetBaseType')]">
            <xsl:variable name="elname">
                <xsl:value-of select="concat(translate(substring(@name, 0, string-length(@name) - 3), '-', ''), 'Set')"/>
            </xsl:variable>
            <xsl:variable name="setid">
                <xsl:value-of select="xsd:annotation/xsd:appinfo/*:SetFormatIdentifier/text()"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:choose>
                    <xsl:when test="$setid = '1APHIB'">
                        <xsl:text>AmphibiousForcesSituationSet</xsl:text>
                    </xsl:when>
                    <xsl:when test="$setid = 'MARACT'">
                        <xsl:text>MaritimeActivitySet</xsl:text>
                    </xsl:when>
                    <xsl:when test="exists($set_Changes/Set[@SETNAMESHORT = $setid and string-length(@ProposedSetFormatName) > 0])">
                        <xsl:value-of select="concat(translate($set_Changes/Set[@SETNAMESHORT = $setid and string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/-()', ''), 'Set')"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$elname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsd:complexType name="{concat($newname, 'Type')}">
                <xsl:apply-templates select="*"/>
            </xsd:complexType>
        </xsl:for-each>
    </xsl:variable>

    <!--Create root level set Elements based on complexTypes-->
    <xsl:variable name="global_elements">
        <xsl:for-each select="$complex_types/xsd:complexType">
            <xsl:variable name="elname">
                <xsl:value-of select="translate(substring(@name, 0, string-length(@name) - 3), '-', '')"/>
            </xsl:variable>
            <xsl:variable name="setid">
                <xsl:value-of select="xsd:annotation/xsd:appinfo/*:Set/@id"/>
            </xsl:variable>
            <xsl:variable name="newname">
                <xsl:choose>
                    <xsl:when test="exists($set_Changes/*/*[@SETNAMESHORT = $setid][string-length(@ProposedSetFormatName) > 0])">
                        <xsl:value-of select="concat(translate($set_Changes/Set[@SETNAMESHORT = $setid][string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/-()', ''), 'Set')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$elname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsd:element>
                <xsl:attribute name="name">
                    <xsl:value-of select="$newname"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:value-of select="concat($newname, 'Type')"/>
                </xsl:attribute>
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>
 
    <!--Create root level Elements from non-global elements in complexTypes-->
    <xsl:variable name="globalized_elements">
        <xsl:apply-templates select="$complex_types//xsd:element[@name]" mode="non-globals"/>
    </xsl:variable>
    
    <!--Create root level Elements from non-global elements in complexTypes-->
    <xsl:variable name="normalized_globalized_elements">
        <xsl:for-each select="$globalized_elements/*">
            <xsl:sort select="@name"/>
            <xsl:variable name="e">
                <xsl:copy-of select="./xsd:element"/>
            </xsl:variable>
            <xsl:variable name="n">
                <xsl:value-of select="./xsd:element/@name"/>
            </xsl:variable>
            <xsl:variable name="p">
                <xsl:value-of select="@parent"/>
            </xsl:variable>
            <xsl:choose>
                <!--Omit all but last occurrence of duplicate nodes-->
                <xsl:when test="deep-equal(preceding-sibling::*[1]/xsd:element,$e)"/>
                <xsl:when test="deep-equal(preceding-sibling::*[2]/xsd:element,$e)"/>
                <xsl:when test="deep-equal(preceding-sibling::*[3]/xsd:element,$e)"/>
                <xsl:when test="deep-equal(preceding-sibling::*[4]/xsd:element,$e)"/>
                <xsl:when test="deep-equal(preceding-sibling::*[5]/xsd:element,$e)"/>
                <xsl:when test="deep-equal(preceding-sibling::*[6]/xsd:element,$e)"/>
                <xsl:when test="deep-equal(preceding-sibling::*[7]/xsd:element,$e)"/>
                <xsl:when test="deep-equal(preceding-sibling::*[8]/xsd:element,$e)"/>
                <xsl:when test="deep-equal(preceding-sibling::*[9]/xsd:element,$e)"/>
                <xsl:when test="deep-equal(preceding-sibling::*[10]/xsd:element,$e)"/>
                <!--Same name - diferrent content - rename by concatenating parent name-->
                <xsl:when test="preceding-sibling::*[1]/xsd:element/@name = $n">
                    <xsd:element name="{concat(substring-before($p,'SetType'),$n)}">
                        <xsl:copy-of select="./xsd:element/@type"/>
                        <xsl:apply-templates select="./xsd:element/*" mode="globalscopy"/>
                    </xsd:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="./xsd:element"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
         
    <xsl:variable name="complex_types_globalized">
        <xsl:apply-templates select="$complex_types/*" mode="refscopy"/>
    </xsl:variable>
    
    
    <!--Global Subsets-->
    <xsl:variable name="all_global_elements">
        <xsl:copy-of select="$global_elements"/>
        <xsl:copy-of select="$globalized_elements"/>
    </xsl:variable>
    <!--*****************************************************-->
    <xsl:template name="main">
        <xsl:result-document href="{$sets_output}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:goe:sets" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:field="urn:mtf:mil:6040b:goe:fields" xmlns:ism="urn:us:gov:ic:ism:v2"
                targetNamespace="urn:mtf:mil:6040b:goe:sets" xml:lang="en-US" elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:mtf:mil:6040b:goe:fields" schemaLocation="GoE_fields.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <!--<xsd:complexType name="SetBaseType">
                    <xsd:sequence>
                        <xsd:element ref="AmplificationSet" minOccurs="0" maxOccurs="1"/>
                        <xsd:element ref="NarrativeInformationSet" minOccurs="0" maxOccurs="1"/>
                    </xsd:sequence>
                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                </xsd:complexType>-->
                <!--<xsl:for-each select="$complex_types_globalized/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>-->
                <xsl:for-each select="$normalized_globalized_elements/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>
    <!--*****************************************************-->
    <!--Copy element and iterate child attributes and elements-->
    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    <!--Carry through attribute-->
    <xsl:template match="@*">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    <!--Normalize extra whitespace and linefeeds in text-->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(translate(., '&#34;', ''))"/>
    </xsl:template>
    <!--**************** ELEMENT NODES ********************-->
    <xsl:template match="xsd:element[@name = 'GroupOfFields']">
        <xsl:apply-templates select="xsd:complexType/xsd:sequence" mode="group">
            <xsl:with-param name="min" select="@minOccurs"/>
            <xsl:with-param name="max" select="@maxOccurs"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="xsd:element[not(@name = 'GroupOfFields')]">
        <xsl:variable name="n">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:variable name="b">
            <xsl:value-of select="xsd:complexType/*/xsd:extension/@base"/>
        </xsl:variable>
        <xsl:variable name="basetype">
            <xsl:choose>
                <xsl:when test="contains($b, ':')">
                    <xsl:value-of select="substring-after($b, ':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$b"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="basel" select="substring($basetype, 0, string-length($basetype) - 3)"/>
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="@name = 'Amplification'">
                    <xsl:attribute name="ref">
                        <xsl:text>AmplificationSet</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:when>
                <xsl:when test="@name = 'RoutingIndicator'">
                    <xsl:attribute name="ref">
                        <xsl:text>field:RoutingIndicator</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:when>
                <xsl:when test="@name = 'Activity'">
                    <xsl:attribute name="ref">
                        <xsl:text>field:Activity</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:when>
                <xsl:when test="@name = 'Event'">
                    <xsl:attribute name="ref">
                        <xsl:text>field:Event</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:when>
                <xsl:when test="$n = $basel and $goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('field:', $basel)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:when>
                <xsl:when test="$n != $basel and $goe_fields_xsd/xsd:schema/xsd:complexType[@name = $basetype]">
                    <xsl:attribute name="name">
                        <xsl:value-of select="$n"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="concat('field:', $basetype)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:when>
                <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basetype]//xsd:restriction">
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="type">
                        <xsl:value-of select="concat('field:', $goe_fields_xsd/xsd:schema/xsd:element[@name = $basetype]//xsd:restriction/@type)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basetype]">
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="type">
                        <xsl:value-of select="concat('field:', $basetype)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="*"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:extension[@base = 'SetBaseType']">
        <xsd:extension base="SetBaseType">
            <xsl:apply-templates select="*"/>
        </xsd:extension>
    </xsl:template>
    <xsl:template match="xsd:extension">
        <xsl:variable name="basetype">
            <xsl:choose>
                <xsl:when test="contains(@base, ':')">
                    <xsl:value-of select="substring-after(@base, ':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@base"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="basel" select="substring($basetype, 0, string-length($basetype) - 3)"/>
        <xsl:choose>
            <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:complexType[@name = $basetype]">
                <xsd:extension base="{concat('field:',$basetype)}"/>
            </xsl:when>
            <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction">
                <xsd:restriction base="{concat('field:',$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction/@base)}">
                    <xsl:apply-templates select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction/*"/>
                </xsd:restriction>
                <!--<xsl:copy-of select="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]//xsd:restriction"/>-->
            </xsl:when>
            <xsl:when test="$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]/@type">
                <xsd:extension base="{concat('field:',$goe_fields_xsd/xsd:schema/xsd:element[@name = $basel]/@type)}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsd:extension base="{concat($basel,'Type')}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="xsd:sequence" mode="group">
        <xsl:param name="min"/>
        <xsl:param name="max"/>
        <xsd:sequence minOccurs="{$min}" maxOccurs="{$max}">
            <xsl:apply-templates select="*"/>
        </xsd:sequence>
    </xsl:template>
    <!--Convert elements in xsd:appinfo to attributes-->
    <xsl:template match="*" mode="attr">
        <xsl:variable name="nm" select="name()"/>
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[name() = $nm] and not($txt = ' ') and not(*) and not($txt = '')">
                <xsl:attribute name="{concat(name(),count(preceding-sibling::*[name()=$nm]))}">
                    <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="not($txt = ' ') and not(*) and not($txt = '')">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!--Copy annotation only if it has descendents with text content-->
    <xsl:template match="xsd:annotation">
        <xsl:variable name="setid">
            <xsl:value-of select="xsd:appinfo/*:SetFormatIdentifier/text()"/>
        </xsl:variable>
        <xsl:variable name="doc">
            <xsl:value-of select="normalize-space(xsd:documentation/text())"/>
        </xsl:variable>
        <xsl:variable name="desc">
            <xsl:apply-templates select="xsd:appinfo/*:SetFormatDescription/text()"/>
            <xsl:apply-templates select="xsd:appinfo/*:FieldFormatDefinition/text()"/>
        </xsl:variable>
        <xsl:variable name="newdesc">
            <xsl:value-of select="normalize-space($set_Changes/*[@SETNAMESHORT = $setid][@ProposedSetFormatDescription][1]/@ProposedSetFormatDescription)"/>
        </xsl:variable>
        <xsl:variable name="doc">
            <xsl:choose>
                <xsl:when test="string-length($newdesc) > 0">
                    <xsl:value-of select="$newdesc"/>
                </xsl:when>
                <xsl:when test="string-length($doc) > 0">
                    <xsl:value-of select="$doc"/>
                </xsl:when>
                <xsl:when test="string-length($desc) > 0">
                    <xsl:value-of select="$desc"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="*//text()">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*">
                    <xsl:with-param name="doc" select="$doc"/>
                </xsl:apply-templates>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    <!--Copy documentation only if it has text content-->
    <xsl:template match="xsd:documentation">
        <xsl:param name="doc"/>
        <xsl:choose>
            <xsl:when test="string-length(normalize-space($doc)) &gt; 0">
                <xsl:copy copy-namespaces="no">
                    <xsl:value-of select="$doc"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="string-length(normalize-space(text())) &gt; 0">
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="text()"/>
                </xsl:copy>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!--Copy element and use template mode to convert elements to attributes in SET element-->
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Set')]]">
        <xsl:param name="doc"/>
        <xsl:variable name="setid">
            <xsl:value-of select="*:SetFormatIdentifier/text()"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Set" xmlns="urn:mtf:mil:6040b:goe:sets">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr">
                    <xsl:with-param name="doc" select="$doc"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="$set_Changes/*[@SETNAMESHORT = $setid]/@*[string-length(.) > 0][1]" mode="chg">
                    <xsl:with-param name="doc" select="$doc"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="ancestor::xsd:element[1]/xsd:complexType/xsd:extension/xsd:annotation/xsd:appinfo/*" mode="attr"/>
                <xsl:apply-templates select="*:SetFormatExample" mode="examples"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
   
    <!--*****************************************************-->
    
    <!--Non-Globals-->
    <!--Create a list of XML nodes containing XSD elements with parent info for use in naming de-confliction-->
    <xsl:template match="xsd:element[@name]" mode="non-globals">
        <xsl:variable name="parent">
            <xsl:value-of select="substring-before(ancestor::xsd:complexType[1]/@name,'SetType')"/>
        </xsl:variable>
        <xsl:variable name="n">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <Global node="{$n}" parent="{$parent}">
            <xsl:apply-templates select="." mode="globalscopy"/>
        </Global>
    </xsl:template>
    <xsl:template match="*" mode="globalscopy">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="globalscopy"/>
        </xsl:copy>
    </xsl:template>
    <!--    Leave documentation out of globals..-->
    <xsl:template match="xsd:documentation" mode="globalscopy"/>
    
        <!--*****************************************************-->
        
    <!--Refs Copy-->
    <xsl:template match="*" mode="refscopy">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="refscopy"/>
            <xsl:apply-templates select="*" mode="refscopy"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="refscopy">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="xsd:documentation" mode="refscopy">
        <xsl:if test="string-length(normalize-space(text())) &gt; 0">
            <xsl:copy copy-namespaces="no">
                <xsl:value-of select="normalize-space(translate(., '&#34;', ''))"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    <xsl:template match="xsd:complexType/*//xsd:element[@name]" mode="refscopy">
        <!--<xsl:variable name="namechange">
            <xsl:apply-templates select="." mode="copy"/>
        </xsl:variable>-->
        <xsl:variable name="n">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:variable name="parentsetname">
            <xsl:value-of select="substring-before(ancestor::xsd:complexType[1]/@name,'SetType')"/>
        </xsl:variable>
        <xsd:element>
            <xsl:attribute name="ref">
                <xsl:value-of select="concat($parentsetname,$n)"/>
                <!--<xsl:value-of select="$namechange/xsd:element/@name"/>-->
            </xsl:attribute>
            <xsl:apply-templates select="@*[not(name()='name')][not(name()='type')]" mode="copy"/>
            <xsl:apply-templates select="xsd:annotation" mode="copy"/>
            <!--<xsl:apply-templates select="$namechange/xsd:element/@*[not(name() = 'name')][not(name() = 'type')]" mode="copy"/>
            <xsl:apply-templates select="$namechange/xsd:element/xsd:annotation" mode="copy"/>-->
        </xsd:element>
    </xsl:template>

    <!--Copy-->
    <xsl:template match="*" mode="copy">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="copy">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="xsd:documentation" mode="copy">
        <xsl:if test="string-length(normalize-space(text())) &gt; 0">
            <xsl:copy copy-namespaces="no">
                <xsl:value-of select="normalize-space(translate(., '&#34;', ''))"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@minOccurs" mode="copy"/>
    <xsl:template match="@maxOccurs" mode="copy"/>
    <xsl:template match="@nillable" mode="copy"/>
    
    <!--<xsl:template match="@fixed" mode="copy"/>-->
    <xsl:template match="@ColumnHeader" mode="copy"/>
    <xsl:template match="@identifier" mode="copy"/>
    <xsl:template match="@Justification" mode="copy"/>
    <xsl:template match="@remark" mode="copy"/>
    
    <!--*****************************************************-->
    
    <xsl:template match="@nillable"/>
    <xsl:template match="@*" mode="chg"/>
    <!--Replace Data Specified in Deconfliction XML Document-->
    <xsl:template match="@ProposedSetFormatPositionName" mode="chg">
        <xsl:attribute name="positionName">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@ProposedSetFormatName" mode="chg">
        <xsl:attribute name="name">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@ProposedSetFormatDescription" mode="chg">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(.) = $doc)">
            <xsl:attribute name="description">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@ProposedSetFormatPositionConceptChanges" mode="chg">
        <xsl:if test="not(normalize-space(.) = ' ') and not(normalize-space(.) = '')">
            <xsl:attribute name="concept">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <!--Copy element and use template mode to convert elements to attributes in FIELD element-->
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Field')]]">
        <xsl:param name="doc"/>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Field" xmlns="urn:mtf:mil:6040b:goe:sets">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr">
                    <xsl:with-param name="doc" select="$doc"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="ancestor::xsd:element[1]/xsd:complexType/*/xsd:extension/xsd:annotation/xsd:appinfo/*" mode="attr">
                    <xsl:with-param name="doc" select="$doc"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="*:FieldFormatRelatedDocument" mode="docs"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:appinfo" mode="ref">
        <xsl:param name="fldinfo"/>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Field" namespace="urn:mtf:mil:6040b:goe:sets">
                <xsl:apply-templates select="*" mode="attr"/>
                <xsl:if test="parent::xsd:annotation/parent::xsd:extension">
                    <xsl:variable name="ffdno">
                        <xsl:value-of select="parent::xsd:annotation/parent::xsd:extension/xsd:attribute[@name = 'ffirnFudn']/@fixed"/>
                    </xsl:variable>
                    <xsl:variable name="ffdinfo">
                        <xsl:copy-of select="$goe_fields_xsd//*:Field[@ffirnFudn = $ffdno]"/>
                    </xsl:variable>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$ffdinfo/*/@FudName"/>
                    </xsl:attribute>
                    <xsl:attribute name="explanation">
                        <xsl:value-of select="$ffdinfo/*/@FudExplanation"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    <!--Convert appinfo items-->
    <xsl:template match="*:SetFormatName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="name">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatIdentifier" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="id">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatSponsor" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="sponsor">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatNote" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="note">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatRemark" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="remark">
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
    <xsl:template match="*:SetFormatPositionConcept" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not($doc = normalize-space(text()))">
            <xsl:attribute name="concept">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="positionName">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatPositionName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="positionName">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatPositionConcept" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = $doc)">
            <xsl:attribute name="concept">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="name">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatDefinition" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = $doc)">
            <xsl:attribute name="definition">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:AlphabeticIdentifier" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = $doc)">
            <xsl:attribute name="identifier">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldDescriptor" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = $doc)">
            <xsl:attribute name="name">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatRemark" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="remark">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:ColumnName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="column">
                <xsl:apply-templates select="text()"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatRelatedDocument" mode="docs">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = 'NONE')">
            <xsl:if test="not(preceding-sibling::*:FieldFormatRelatedDocument)">
                <xsl:element name="Document" namespace="urn:mtf:mil:6040b:goe:sets">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:FieldFormatRelatedDocument">
                    <xsl:element name="Document" namespace="urn:mtf:mil:6040b:goe:sets">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatExample" mode="examples">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:if test="not(preceding-sibling::*:SetFormatExample)">
                <xsl:element name="Example" namespace="urn:mtf:mil:6040b:goe:sets">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:SetFormatExample">
                    <xsl:element name="Example" namespace="urn:mtf:mil:6040b:goe:sets">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatPositionNumber" mode="attr"/>
    <xsl:template match="*:OccurrenceCategory" mode="attr"/>
    <xsl:template match="*:SetFormatExample" mode="attr"/>
    <xsl:template match="*:SetFormatRelatedDocuments" mode="attr"/>
    <xsl:template match="*:RepeatabilityForGroupOfFields" mode="attr"/>
    <xsl:template match="*:SetFormatDescription" mode="attr"/>
    <xsl:template match="*:FieldFormatRelatedDocument" mode="attr"/>
    <!--Filter unneeded nodes-->
    <xsl:template match="xsd:attributeGroup"/>
    <xsl:template match="*:GroupOfFieldsIndicator" mode="attr"/>
    <xsl:template match="*:ColumnarIndicator" mode="attr"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber" mode="attr"/>
    <xsl:template match="*:AssignedFfirnFudUseDescription" mode="attr"/>
    <xsl:template match="xsd:attribute[@name = 'ffSeq']"/>
    <xsl:template match="xsd:attribute[@name = 'ffirnFudn']"/>
    <!--Filter empty xsd:annotations-->
    <xsl:template match="xsd:restriction[@base = 'xsd:integer']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:string']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:decimal']/xsd:annotation"/>

</xsl:stylesheet>
