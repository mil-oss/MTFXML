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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:set="urn:int:nato:mtf:app-11(c):goe:sets"
    xmlns:segment="urn:int:nato:mtf:app-11(c):goe:segments" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <!--This Transform produces a "Garden of Eden" style global elements XML Schema for Segments in the USMTF Military Message Standard.-->
    <!--The Resulting Global Elements will be included in the "usmtf_fields" XML Schema per proposed changes of September 2014-->
    <!--Duplicate Segment Names are deconflicted using an XML document containing affected messages, elements and approved changes-->

    <xsl:variable name="goe_sets_xsd" select="document('../../XSD/APP-11C-GoE/natomtf_goe_sets.xsd')"/>
    <xsl:variable name="baseline_msgs" select="document('../../XSD/APP-11C-ch1/Consolidated/messages.xsd')"/>
    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/APP-11C-GoE/natomtf_goe_fields.xsd')"/>
    <xsl:variable name="new_set_names" select="document('../../XSD/Deconflicted/Set_Name_Changes.xml')"/>
    <xsl:variable name="outputdoc" select="'../../XSD/APP-11C-GoE/natomtf_goe_segments.xsd'"/>
    <!-- ***********************  Segment Elements  ************************-->
    <!-- Extract all Segments from Baseline XML Schema for messages-->
    <!-- Copy every Segment Element and make global.  Populates segment_elements variable which includes duplicates -->
    <!--This process preserves all structure and converts it to desired format with references which will be used in ComplexTypes-->
    <!-- Add id to match msdid and element name with proposed name change list -->
    <xsl:variable name="segment_elements">
        <xsl:for-each select="$baseline_msgs/*//xsd:element[xsd:annotation/xsd:appinfo/*:SegmentStructureName]">
            <xsl:sort select="@name" data-type="text"/>
            <xsl:variable name="mtfid" select="ancestor-or-self::xsd:element[parent::xsd:schema]/xsd:annotation/xsd:appinfo/*:MtfIdentifier"/>
            <xsl:variable name="baseline_name">
                <xsl:choose>
                    <xsl:when test="contains(@name, 'Segment_')">
                        <xsl:value-of select="substring-before(@name, '_')"/>
                    </xsl:when>
                    <xsl:when test="ends-with(@name, 'Segment')">
                        <xsl:value-of select="@name"/>
                    </xsl:when>
                    <xsl:when test="starts-with(@name, '_4W')">
                        <xsl:value-of select="replace(@name, '_4W', 'FourWhiskey')"/>
                    </xsl:when>
                    <xsl:when test="@name = 'ToBeMarked_2'">
                        <xsl:text>ToBeMarked</xsl:text>
                    </xsl:when>
                    <xsl:when test="@name = 'OrganizationDesignator_2'">
                        <xsl:text>OrganizationInformation</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:copy copy-namespaces="no">
                <xsl:attribute name="name">
                    <xsl:value-of select="$baseline_name"/>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="translate(ancestor::xsd:element[parent::xsd:schema]/xsd:annotation/xsd:appinfo/*:MtfIdentifier, ' ', '_')"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <xsl:apply-templates select="*"/>
            </xsl:copy>
        </xsl:for-each>
    </xsl:variable>
    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/> 
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    <!--Normalize extra whitespace and linefeeds in text-->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
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
    <!-- ***********************  Complex Types  ************************-->
    <xsl:variable name="complex_types">
        <xsl:for-each select="$segment_elements/*">
            <xsl:sort select="@name"/>
            <xsl:variable name="nm" select="@name"/>
            <xsd:complexType>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($nm, 'Type')"/>
                </xsl:attribute>
                <xsl:call-template name="Annotation">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
                <xsd:complexContent>
                    <xsd:extension base="SegmentBaseType">
                        <xsl:apply-templates select="xsd:complexType/xsd:sequence" mode="global"/>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
        </xsl:for-each>
    </xsl:variable>
    <xsl:template match="*" mode="global">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="global"/>
            <xsl:apply-templates select="text()" mode="global"/>
            <xsl:apply-templates select="*" mode="global"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:choice/xsd:annotation" mode="global"/>
    <xsl:template match="xsd:annotation" mode="global">
        <xsl:copy>
            <xsd:documentation>
                <xsl:value-of select="xsd:appinfo/*:Segment/@name"/>
                <xsl:value-of select="xsd:appinfo/*:Set/@name"/>
            </xsd:documentation>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@position" mode="global"/>
    <xsl:template match="@*" mode="global">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    <xsl:template match="text()" mode="global">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    <xsl:template match="xsd:element" mode="global">
        <xsl:variable name="elname">
            <xsl:choose>
                <xsl:when test="starts-with(@name, '_4W')">
                    <xsl:value-of select="replace(@name, '_4W', 'FourWhiskey')"/>
                </xsl:when>
                <xsl:when test="@name = 'ToBeMarked_2'">
                    <xsl:text>ToBeMarked</xsl:text>
                </xsl:when>
                <xsl:when test="@name = 'OrganizationDesignator_2'">
                    <xsl:text>OrganizationInformation</xsl:text>
                </xsl:when>
                <xsl:when test="contains(@name, '_')">
                    <xsl:value-of select="substring-before(@name, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:element/@name = concat($elname, 'Set')">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('set:', $elname, 'Set')"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@minOccurs" mode="global"/>
                    <xsl:apply-templates select="@maxOccurs" mode="global"/>
                    <xsl:copy-of select="xsd:annotation"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$segment_elements/xsd:element/@name = $elname">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="$elname"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@minOccurs" mode="global"/>
                    <xsl:apply-templates select="@maxOccurs" mode="global"/>
                    <xsl:copy-of select="xsd:annotation"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="xsd:complexType/xsd:complexContent/xsd:extension[@base] and count(xsd:complexType/xsd:complexContent/xsd:extension[@base]/*) &lt; 2">
                <xsl:variable name="b" select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
                <xsl:variable name="t">
                    <xsl:choose>
                        <xsl:when test="starts-with($b, 's:')">
                            <xsl:value-of select="concat('set:', concat(substring-after(substring($b, 0, string-length($b) - 3), 's:'), 'SetType'))"/>
                        </xsl:when>
                        <xsl:when test="starts-with($b, 'f:')">
                            <xsl:value-of select="concat('field:', substring-after($b, 'f:'))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$b"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="xsd:element">
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="type">
                        <xsl:value-of select="$t"/>
                    </xsl:attribute>
                    <xsl:copy-of select="xsd:annotation"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*" mode="global"/>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$elname"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="*" mode="global"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="xsd:extension[@base]" mode="global">
        <!--Create complex or simple type reference to match with global type in GoE fields-->
        <!--Because types have been normalized, it is necessary use element name to match-->
        <xsl:variable name="match_new_name">
            <xsl:call-template name="matchChange">
                <xsl:with-param name="matchEl">
                    <xsl:choose>
                        <xsl:when test="starts-with(@base, 's:')">
                            <xsl:value-of select="substring(substring-after(@base, 's:'), 0, string-length(substring-after(@base, 's:')) - 3)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(@base, 0, string-length(@base) - 3)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="match_new_name_set">
            <xsl:value-of select="concat(substring($match_new_name, 0, string-length($match_new_name) - 3), 'SetType')"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="base">
                <xsl:choose>
                    <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:complexType[@name = $match_new_name_set]">
                        <xsl:value-of select="concat('set:', $match_new_name_set)"/>
                    </xsl:when>
                    <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:simpleType[@name = $match_new_name_set]">
                        <xsl:value-of select="concat('set:', $match_new_name_set)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$match_new_name_set"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="*" mode="global"/>
        </xsl:copy>
    </xsl:template>

    <!-- ***********************  Global Types  ************************-->
    <xsl:variable name="global_types">
        <xsl:for-each select="$complex_types//xsd:element[@name][not(@type)]">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsd:complexType name="{concat($n,'Type')}">
                <xsl:call-template name="Annotation">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
                <xsd:complexContent>
                    <xsd:extension base="SetBaseType">
                        <xsl:apply-templates select="xsd:complexType/*" mode="globalize"/>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{$n}" type="{concat($n,'Type')}">
                <xsd:annotation>
                    <xsl:copy-of select="xsd:annotation/xsd:documentation"/>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:for-each select="$complex_types//xsd:element[@name][@type]">
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsd:element name="{$n}" type="{@type}">
                <xsd:annotation>
                    <xsl:copy-of select="xsd:annotation/xsd:documentation"/>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:apply-templates select="$complex_types/xsd:complexType" mode="globalize"/>
    </xsl:variable>
    <xsl:template match="*" mode="globalize">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="globalize"/>
            <xsl:apply-templates select="text()" mode="globalize"/>
            <xsl:apply-templates select="*" mode="globalize"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:element[@name]" mode="globalize">
        <xsl:variable name="nm" select="@name"/>
        <xsd:element ref="{$nm}">
            <xsl:apply-templates select="@minOccurs" mode="global"/>
            <xsl:call-template name="Annotation">
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
        </xsd:element>
    </xsl:template>
    <xsl:template match="@*" mode="globalize">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    <xsl:template match="xsd:element/@name" mode="globalize"/>
    <xsl:template match="xsd:appinfo" mode="globalize">
        <xsl:copy>
            <xsl:element name="Set" namespace="urn:int:nato:mtf:app-11(c):goe:segments">
                <xsl:copy-of select="ancestor::xsd:element[1]/@minOccurs"/>
                <xsl:copy-of select="ancestor::xsd:element[1]/@maxOccurs"/>
                <xsl:apply-templates select="*:Set/@*" mode="globalize"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@type" mode="globalize"/>
    <xsl:template match="@maxOccurs" mode="globalize"/>
    <xsl:template match="xsd:choice/@minOccurs" mode="globalize"/>
    <xsl:template match="@fixed" mode="globalize"/>
    <xsl:template match="@position" mode="globalize"/>
    <xsl:template match="text()" mode="globalize">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <!-- ********************  Global Elements  *********************-->
    <xsl:variable name="global_elements">
        <xsl:for-each select="$global_types/xsd:complexType">
            <xsl:variable name="nm" select="@name"/>
            <xsl:element name="xsd:element">
                <xsl:attribute name="name">
                    <xsl:value-of select="substring($nm, 0, string-length($nm) - 3)"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:value-of select="$nm"/>
                </xsl:attribute>
                <xsl:call-template name="Annotation">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="$global_types/xsd:element">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="dedup_global_types">
        <xsl:for-each select="$global_types/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n">
                <xsl:value-of select="@name"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="count($global_types/*[@name = $n]) = 1">
                    <xsl:copy-of select="."/>
                </xsl:when>
                <xsl:when test="deep-equal(preceding-sibling::xsd:complexType[1], .)"/>
                <xsl:when test="deep-equal(preceding-sibling::xsd:complexType[2], .)"/>
                <xsl:when test="deep-equal(preceding-sibling::xsd:complexType[3], .)"/>
                <xsl:when test="preceding-sibling::xsd:complexType/@name = $n"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="dedup_global_elements">
        <xsl:for-each select="$global_elements/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n">
                <xsl:value-of select="@name"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="count($global_elements/xsd:element[@name = $n]) = 1">
                    <xsl:copy-of select="."/>
                </xsl:when>
                <xsl:when test="deep-equal(preceding-sibling::xsd:element[1], .)"/>
                <xsl:when test="deep-equal(preceding-sibling::xsd:element[2], .)"/>
                <xsl:when test="deep-equal(preceding-sibling::xsd:element[3], .)"/>
                <xsl:when test="deep-equal(preceding-sibling::xsd:element[4], .)"/>
                <xsl:when test="deep-equal(preceding-sibling::xsd:element[5], .)"/>
                <xsl:when test="preceding-sibling::xsd:element/@name = $n"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>

    <!--Apply Workaround to avoid fixed values prohibited by NIEM-->
    <xsl:variable name="final">
        <xsl:for-each select="$dedup_global_types/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:apply-templates select="." mode="ncopy"/>
        </xsl:for-each>
        <xsl:for-each select="$dedup_global_elements/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:apply-templates select="." mode="ncopy"/>
        </xsl:for-each>
    </xsl:variable>


    <!-- ************************************************************-->
    <!--Build XML Schema and add Global Elements and Complex Types -->
    <xsl:template name="main">
        <xsl:result-document href="{$outputdoc}">
            <xsd:schema xmlns="urn:int:nato:mtf:app-11(c):goe:segments" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:field="urn:int:nato:mtf:app-11(c):goe:elementals"
                xmlns:set="urn:int:nato:mtf:app-11(c):goe:sets" targetNamespace="urn:int:nato:mtf:app-11(c):goe:segments">
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:elementals" schemaLocation="natomtf_goe_fields.xsd"/>
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:sets" schemaLocation="natomtf_goe_sets.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>Message Text Format Segments</xsd:documentation>
                </xsd:annotation>
                <xsd:complexType name="SegmentBaseType">
                    <xsd:annotation>
                        <xsd:documentation>For use to extend XML Schema at the Segment level</xsd:documentation>
                    </xsd:annotation>
                    <xsd:complexContent>
                        <xsd:extension base="field:CompositeType"/>
                    </xsd:complexContent>
                </xsd:complexType>
                <xsl:for-each select="$final/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$final/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <!-- **************************************-->

    <xsl:template name="matchChange">
        <xsl:param name="matchEl"/>
        <xsl:variable name="match">
            <xsl:choose>
                <xsl:when test="contains($matchEl, '_')">
                    <xsl:value-of select="substring-before($matchEl, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$matchEl"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:element[@name = $match]/@type">
                <xsl:value-of select="$goe_sets_xsd/xsd:schema/xsd:element[@name = $match]/@type"/>
            </xsl:when>
            <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:element[@name = $match]/xsd:simpleType/xsd:restriction/@base">
                <xsl:value-of select="$goe_sets_xsd/xsd:schema/xsd:element[@name = $match]/xsd:simpleType/xsd:restriction/@base"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($match, 'Type')"/>
            </xsl:otherwise>
        </xsl:choose>
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

    <!--Convert appinfo items-->
    <!--InitialSetFormatPosition only applies in context of containing message-->
    <xsl:template match="*:InitialSetFormatPosition" mode="attr"/>
    <!--Use Position relative to segment vice position relative to containing message-->
    <xsl:template match="*:SegmentStructureName" mode="attr">
        <xsl:attribute name="name">
            <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:if>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*:SegmentStructureUseDescription" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="usage">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionUseDescription" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="usage">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="name">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatIdentifier" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="id">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:VersionIndicator" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="version">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionConcept" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not($doc = normalize-space(text()))">
            <xsl:attribute name="concept">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="positionName">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatPositionName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="positionName">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatPositionConcept" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = $doc)">
            <xsl:attribute name="concept">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatName" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="name">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatDefinition" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = $doc)">
            <xsl:attribute name="definition">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatRemark" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="remark">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatRelatedDocument" mode="docs">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = 'NONE')">
            <xsl:if test="not(preceding-sibling::*:FieldFormatRelatedDocument)">
                <xsl:element name="Document" namespace="urn:int:nato:mtf:app-11(c):goe:segments">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:FieldFormatRelatedDocument">
                    <xsl:element name="Document" namespace="urn:int:nato:mtf:app-11(c):goe:segments">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatExample" mode="examples">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:if test="not(preceding-sibling::*:SetFormatExample)">
                <xsl:element name="Example" namespace="urn:int:nato:mtf:app-11(c):segments">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:SetFormatExample">
                    <xsl:element name="Example" namespace="urn:int:nato:mtf:app-11(c):goe:segments">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Annotation">
        <xsl:param name="node"/>
        <xsl:choose>
            <xsl:when test="$node/xsd:annotation">
                <xsl:apply-templates select="$node/xsd:annotation"/>
            </xsl:when>
            <xsl:when test="contains($node/@name, 'GroupOfFields')">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>A repeatable group of fields</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
            </xsl:when>
            <xsl:otherwise>
                <xsd:annotation>
                    <xsd:documentation>Data definition required</xsd:documentation>
                </xsd:annotation>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:annotation">
        <xsl:param name="nm"/>
        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="string-length($nm) &gt; 0">
                    <xsl:value-of select="$nm"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="ancestor::*[@name][1]/@name" mode="txt"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="xsd:documentation">
                    <xsl:apply-templates select="xsd:documentation">
                        <xsl:with-param name="nm" select="$name"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsd:documentation>
                        <xsl:choose>
                            <xsl:when test="string-length(xsd:appinfo[1]/*:FudExplanation/text()) &gt; 0">
                                <xsl:value-of select="xsd:appinfo/*:FudExplanation"/>
                            </xsl:when>
                            <xsl:when test="string-length(xsd:appinfo[1]/*:FudName/text()) &gt; 0">
                                <xsl:value-of select="xsd:appinfo/*:FudName"/>
                            </xsl:when>
                            <xsl:when test="xsd:appinfo/*:Field/@explanation">
                                <xsl:value-of select="xsd:appinfo/*:Field/@explanation"/>
                            </xsl:when>
                            <xsl:when test="xsd:appinfo/*:Field/@name">
                                <xsl:value-of select="xsd:appinfo/*:Field/@name"/>
                            </xsl:when>
                            <xsl:when test="string-length(xsd:appinfo[1]/*:SetFormatDescription/text()) &gt; 0">
                                <xsl:value-of select="xsd:appinfo/*:SetFormatDescription"/>
                            </xsl:when>
                            <xsl:when test="string-length(xsd:appinfo[1]/*:SetFormatRemark/text()) &gt; 0">
                                <xsl:value-of select="xsd:appinfo/*:SetFormatRemark"/>
                            </xsl:when>
                            <xsl:when test="string-length(xsd:appinfo[1]/*:SetFormatName/text()) &gt; 0">
                                <xsl:value-of select="xsd:appinfo/*:SetFormatName"/>
                            </xsl:when>
                            <xsl:when test="string-length(xsd:appinfo[1]/*:SetFormatIdentifier/text()) &gt; 0">
                                <xsl:value-of select="xsd:appinfo/*:SetFormatIdentifier"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="breakIntoWords">
                                    <xsl:with-param name="string">
                                        <xsl:value-of select="$name"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsd:documentation>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="xsd:appinfo"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:documentation">
        <xsl:param name="nm"/>
        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="string-length($nm) &gt; 0">
                    <xsl:value-of select="$nm"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="ancestor::*[@name][1]/@name" mode="txt"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="text() and not(text() = 'Data definition required')">
                    <xsl:apply-templates select="text()"/>
                </xsl:when>
                <xsl:when test="parent::xsd:annotation/xsd:appinfo/*:FudExplanation">
                    <xsl:value-of select="normalize-space(xsd:appinfo[1]/*:FudExplanation)"/>
                </xsl:when>
                <xsl:when test="parent::xsd:annotation/xsd:appinfo/*:FudName">
                    <xsl:value-of select="normalize-space(xsd:appinfo[1]/*:FudName)"/>
                </xsl:when>
                <xsl:when test="parent::xsd:annotation/xsd:appinfo/*:Field/@explanation">
                    <xsl:value-of select="parent::*/xsd:appinfo/*:Field/@explanation"/>
                </xsl:when>
                <xsl:when test="parent::xsd:annotation/xsd:appinfo/*:Field/@name">
                    <xsl:value-of select="parent::*/xsd:appinfo/*:Field/@name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="breakIntoWords">
                        <xsl:with-param name="string">
                            <xsl:value-of select="$name"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Field')]]">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="not(*:Field)">
                    <xsl:element name="Field" xmlns="urn:int:nato:mtf:app-11(c):goe:segments">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"> </xsl:apply-templates>
                        <xsl:apply-templates select="ancestor::xsd:element[1]/xsd:complexType/*/xsd:extension/xsd:annotation/xsd:appinfo/*" mode="attr"/>
                        <xsl:apply-templates select="*:FieldFormatRelatedDocument" mode="docs"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="*:Field" copy-namespaces="no"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Set')]]">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="not(*:Set)">
                    <xsl:element name="Set" xmlns="urn:int:nato:mtf:app-11(c):goe:segments">
                        <xsl:apply-templates select="*" mode="attr"/>
                        <xsl:apply-templates select="ancestor::xsd:element[1]/xsd:complexType/xsd:extension/xsd:annotation/xsd:appinfo/*" mode="attr"/>
                        <xsl:apply-templates select="*:SetFormatExample" mode="examples"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="*:Set" copy-namespaces="no"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <!-- ***************** SPLIT CAMEL CASE *****************-->

    <xsl:template name="breakIntoWords">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="string-length($string) &lt; 2">
                <xsl:value-of select="$string"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="breakIntoWordsHelper">
                    <xsl:with-param name="string" select="$string"/>
                    <xsl:with-param name="token" select="substring($string, 1, 1)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="breakIntoWordsHelper">
        <xsl:param name="string" select="''"/>
        <xsl:param name="token" select="''"/>
        <xsl:choose>
            <xsl:when test="string-length($string) = 0"/>
            <xsl:when test="string-length($token) = 0"/>
            <xsl:when test="string-length($string) = string-length($token)">
                <xsl:value-of select="$token"/>
            </xsl:when>
            <xsl:when test="contains('ABCDEFGHIJKLMNOPQRSTUVWXYZ', substring($string, string-length($token) + 1, 1))">
                <xsl:value-of select="concat($token, ' ')"/>
                <xsl:call-template name="breakIntoWordsHelper">
                    <xsl:with-param name="string" select="substring-after($string, $token)"/>
                    <xsl:with-param name="token" select="substring($string, string-length($token), 1)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="breakIntoWordsHelper">
                    <xsl:with-param name="string" select="$string"/>
                    <xsl:with-param name="token" select="substring($string, 1, string-length($token) + 1)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="ncopy">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="ncopy"/>
            <xsl:apply-templates select="text()" mode="ncopy"/>
            <xsl:apply-templates select="*" mode="ncopy"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="ncopy">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="text()" mode="ncopy">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>


    <!--************* Replaced Fixed Value with one item Enumeration for NIEM *****************-->

    <xsl:template match="xsd:element[@fixed]" mode="ncopy">
        <xsd:complexType name="{concat(@name,'Type')}">
            <xsl:copy-of select="xsd:annotation"/>
            <xsd:simpleContent>
                <xsd:restriction base="field:FieldEnumeratedBaseType">
                    <xsd:enumeration value="{@fixed}">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="concat(@fixed, ' fixed value')"/>
                            </xsd:documentation>
                        </xsd:annotation>
                    </xsd:enumeration>
                </xsd:restriction>
            </xsd:simpleContent>
        </xsd:complexType>
        <xsd:element name="{@name}" type="{concat(@name,'Type')}">
            <xsd:annotation>
                <xsl:copy-of select="xsd:annotation/xsd:documentation"/>
                <xsd:appinfo>
                    <Field fixed="{@fixed}"/>
                </xsd:appinfo>
            </xsd:annotation>
        </xsd:element>
    </xsl:template>

    <xsl:template match="*:SetFormatPositionNumber" mode="attr"/>
    <xsl:template match="*:FieldFormatPositionNumber" mode="attr"/>
    <xsl:template match="*:AlternativeType" mode="attr"/>
    <xsl:template match="*:AlternativeType" mode="global"/>
    <xsl:template match="*:OccurrenceCategory" mode="attr"/>
    <xsl:template match="*:SetFormatExample" mode="attr"/>
    <xsl:template match="*:SetFormatRelatedDocuments" mode="attr"/>
    <xsl:template match="*:RepeatabilityForGroupOfFields" mode="attr"/>
    <xsl:template match="*:SetFormatDescription" mode="attr"/>
    <xsl:template match="*:FieldFormatRelatedDocument" mode="attr"/>
    <xsl:template match="*:Repeatability" mode="attr"/>
    <!--Filter unneeded nodes-->
    <xsl:template match="xsd:attribute[@name = 'setSeq']"/>
    <xsl:template match="xsd:attributeGroup[@ref = 'ism:SecurityAttributesGroup']"/>
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
