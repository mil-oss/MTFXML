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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:set="urn:mtf:mil:6040b:goe:sets" xmlns:segment="urn:mtf:mil:6040b:goe:segments"
    exclude-result-prefixes="xsd" version="2.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <!--This Transform produces a "Garden of Eden" style global elements XML Schema for Segments in the USMTF Military Message Standard.-->
    <!--The Resulting Global Elements will be included in the "usmtf_fields" XML Schema per proposed changes of September 2014-->
    <!--Duplicate Segment Names are deconflicted using an XML document containing affected messages, elements and approved changes-->
    
    <xsl:variable name="baseline_sets" select="document('../../XSD/Baseline_Schema/sets.xsd')"/>
    <xsl:variable name="baseline_msgs" select="document('../../XSD/Baseline_Schema/messages.xsd')"/>
    <xsl:variable name="goe_sets_xsd" select="document('../../XSD/NIEM_Schema/NIEM_sets.xsd')"/>
    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/NIEM_Schema/NIEM_fields.xsd')"/>
    <xsl:variable name="new_segment_names" select="document('../../XSD/Deconflicted/Segment_Name_Changes.xml')"/>
    <xsl:variable name="new_set_names" select="document('../../XSD/Deconflicted/Set_Name_Changes.xml')"/>
    <xsl:variable name="segment_output" select="'../../XSD/NIEM_Schema/NIEM_segments.xsd'"/>
    
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
                    <xsl:otherwise>
                        <xsl:value-of select="@name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="SegChange" select="$new_segment_names/USMTF_Segments/Segment[@MSGIDENTIFIER = $mtfid and @SegmentElement = $baseline_name]"/>
            <xsl:copy copy-namespaces="no">
                <xsl:attribute name="name">
                    <xsl:choose>
                        <xsl:when test="$baseline_name = 'SurveillanceAreaSegment' and descendant::xsd:element[@name = 'ElectronicSurveillanceTaskingData']">
                            <xsl:text>AirborneC2SurveillanceArea</xsl:text>
                        </xsl:when>
                        <xsl:when test="$baseline_name = 'SurveillanceAreaSegment' and not(descendant::xsd:element[@name = 'ElectronicSurveillanceTaskingData'])">
                            <xsl:text>C2SurveillanceArea</xsl:text>
                        </xsl:when>
                        <xsl:when test="$new_segment_names/USMTF_Segments/Segment[@MSGIDENTIFIER = $mtfid and @SegmentElement = $baseline_name and @ProposedElementName]">
                            <xsl:value-of select="$new_segment_names/USMTF_Segments/Segment[@MSGIDENTIFIER = $mtfid and @SegmentElement = $baseline_name]/@ProposedElementName"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$baseline_name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="translate(ancestor::xsd:element[parent::xsd:schema]/xsd:annotation/xsd:appinfo/*:MtfIdentifier, ' ', '_')"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <xsl:apply-templates select="*">
                    <xsl:with-param name="SegChange" select="$SegChange"/>
                </xsl:apply-templates>
            </xsl:copy>
        </xsl:for-each>
    </xsl:variable>
    <xsl:template match="*">
        <xsl:param name="SegChange"/>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*">
            </xsl:apply-templates>
            <xsl:apply-templates select="*">
                <xsl:with-param name="SegChange" select="$SegChange"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    <!--Normalize extra whitespace and linefeeds in text-->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    <!--Copy documentation only it has text content-->
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Segment')]]">
        <xsl:param name="SegChange"/>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Segment" xmlns="urn:mtf:mil:6040b:goe:segments">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Set')]]">
        <xsl:param name="doc"/>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Set" xmlns="urn:mtf:mil:6040b:goe:segments">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Field')]]">
        <xsl:param name="doc"/>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Field" xmlns="urn:mtf:mil:6040b:goe:segments">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
            </xsl:element>
        </xsl:copy>
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
                <xsl:apply-templates select="xsd:annotation" mode="global"/>
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
    <xsl:template match="xsd:element[not(starts-with(@name, 'GeneralText'))][not(starts-with(@name, 'HeadingInformation'))]" mode="global">
        <xsl:variable name="elname">
            <xsl:choose>
               <xsl:when test="@name= 'SurveillanceAreaSegment_1'">
                    <xsl:text>C2SurveillanceArea</xsl:text>
                </xsl:when>
                <xsl:when test="@name= 'SurveillanceAreaSegment_2'">
                    <xsl:text>AirborneC2SurveillanceArea</xsl:text>
                </xsl:when>
                <xsl:when test="contains(@name, '_')">
                    <xsl:value-of select="substring-before(@name, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="setID">
            <xsl:value-of select="$baseline_sets/xsd:schema/xsd:complexType[@name = concat($elname, 'Type')]/xsd:annotation/xsd:appinfo/*:SetFormatIdentifier"/>
        </xsl:variable>
        <xsl:variable name="newSetName">
            <xsl:value-of select="concat(translate($new_set_names/USMTF_Sets/Set[@SETNAMESHORT = $setID][string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/-()', ''), 'Set')"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:element/@name = $newSetName">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('s:', $newSetName)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@minOccurs" mode="global"/>
                    <xsl:apply-templates select="@maxOccurs" mode="global"/>
                    <xsl:copy-of select="xsd:annotation"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:element/@name = concat($elname, 'Set')">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('s:', $elname, 'Set')"/>
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
                            <xsl:value-of select="concat('s:', concat(substring-after(substring($b, 0, string-length($b) - 3), 's:'), 'SetType'))"/>
                        </xsl:when>
                        <xsl:when test="starts-with($b, 'f:')">
                            <xsl:value-of select="concat('f:', substring-after($b, 'f:'))"/>
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
    <xsl:template match="xsd:element[starts-with(@name, 'GeneralText')]" mode="global">
        <xsl:variable name="per">&#46;</xsl:variable>
        <xsl:variable name="apos">&#34;</xsl:variable>
        <xsl:variable name="lparen">&#40;</xsl:variable>
        <xsl:variable name="rparen">&#41;</xsl:variable>
        <xsl:variable name="UseDesc">
            <xsl:value-of select="translate(upper-case(xsd:annotation/xsd:appinfo/*:Set/@usage), '.', '')"/>
        </xsl:variable>
        <xsl:variable name="TextInd">
            <xsl:value-of select="normalize-space(substring-after($UseDesc, 'MUST EQUAL'))"/>
        </xsl:variable>
        <xsl:variable name="CCase">
            <xsl:call-template name="CamelCase">
                <xsl:with-param name="text">
                    <xsl:value-of select="replace($TextInd, $apos, '')"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <!--Name .. handle 2 special cases with parens-->
        <xsl:variable name="n">
            <xsl:value-of select="translate(replace(replace($CCase, '(TAS)', ''), '(mpa)', ''), ' ()', '')"/>
        </xsl:variable>

        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="name">
                <xsl:value-of select="concat($n, 'GenText')"/>
            </xsl:attribute>
            <xsl:copy-of select="xsd:annotation"/>
            <xsd:complexType>
                <xsd:complexContent>
                    <xsd:extension base="s:GeneralTextSetType">
                        <xsd:sequence>
                            <xsd:element name="{concat($n,'Indicator')}" type="f:AlphaNumericBlankSpecialTextType" minOccurs="1" fixed="{replace($TextInd,$apos,'')}">
                                <xsd:annotation>
                                    <xsd:documentation>
                                        <xsl:value-of select="@fixed"/>
                                    </xsd:documentation>
                                </xsd:annotation>
                            </xsd:element>
                            <xsd:element ref="f:FreeTextField" minOccurs="1"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:element[starts-with(@name, 'HeadingInformation')]" mode="global">
        <xsl:variable name="per">&#46;</xsl:variable>
        <xsl:variable name="apos">&#34;</xsl:variable>
        <xsl:variable name="lparen">&#40;</xsl:variable>
        <xsl:variable name="rparen">&#41;</xsl:variable>
        <xsl:variable name="UseDesc">
            <xsl:value-of select="translate(upper-case(xsd:annotation/xsd:appinfo/*:Set/@usage), '.', '')"/>
        </xsl:variable>
        <xsl:variable name="TextInd">
            <xsl:value-of select="normalize-space(substring-after($UseDesc, 'MUST EQUAL'))"/>
        </xsl:variable>
        <xsl:variable name="CCase">
            <xsl:call-template name="CamelCase">
                <xsl:with-param name="text">
                    <xsl:value-of select="replace($TextInd, $apos, '')"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="n">
            <xsl:value-of select="translate(replace(replace($CCase, '(TAS)', ''), '(mpa)', ''), ' ,/”()', '')"/>
        </xsl:variable>
        <xsl:variable name="fixed">
            <xsl:value-of select="translate(replace($TextInd, $apos, ''), '”', '')"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="name">
                <xsl:value-of select="concat($n, 'HeadingSet')"/>
            </xsl:attribute>
            <xsl:copy-of select="xsd:annotation"/>
            <xsd:complexType>
                <xsd:complexContent>
                    <xsd:extension base="s:HeadingInformationSetType">
                        <xsd:sequence>
                            <xsd:element name="{concat($n,'HeadingText')}" type="f:AlphaNumericBlankSpecialTextType" minOccurs="1" fixed="{$fixed}">
                                <xsd:annotation>
                                    <xsd:documentation>
                                        <xsl:value-of select="$fixed"/>
                                    </xsd:documentation>
                                </xsd:annotation>
                            </xsd:element>
                            <xsd:element ref="f:FreeTextField" minOccurs="1"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
        </xsl:copy>
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
                        <xsl:value-of select="concat('s:', $match_new_name_set)"/>
                    </xsl:when>
                    <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:simpleType[@name = $match_new_name_set]">
                        <xsl:value-of select="concat('s:', $match_new_name_set)"/>
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
        <xsl:for-each select="$complex_types//*/*//xsd:element[@name]">
            <xsl:variable name="nm" select="@name"/>
            <xsl:choose>
                <xsl:when test="ends-with($nm, 'Indicator')">
                    <xsd:element name="{$nm}" type="f:AlphaNumericBlankSpecialTextType" fixed="{@fixed}">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="concat('Text Indicator Field with fixed value ', @fixed)"/>
                            </xsd:documentation>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
                <xsl:when test="ends-with($nm, 'HeadingText')">
                    <xsd:element name="{$nm}" type="f:AlphaNumericBlankSpecialTextType" fixed="{@fixed}">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="concat('Heading fixed value ', @fixed)"/>
                            </xsd:documentation>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
                <xsl:when test="ends-with($nm, 'HeadingSet')">
                    <xsd:complexType>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($nm, 'Type')"/>
                        </xsl:attribute>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="xsd:annotation/xsd:appinfo/*/@positionName"/>
                            </xsd:documentation>
                        </xsd:annotation>
                        <xsl:apply-templates select="xsd:complexType/xsd:complexContent" mode="globalize"/>
                    </xsd:complexType>
                </xsl:when>
                <xsl:when test="ends-with($nm, 'GenText')">
                    <xsd:complexType>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($nm, 'Type')"/>
                        </xsl:attribute>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="xsd:annotation/xsd:appinfo/*/@positionName"/>
                            </xsd:documentation>
                        </xsd:annotation>
                        <xsl:apply-templates select="xsd:complexType/xsd:complexContent" mode="globalize"/>
                    </xsd:complexType>
                </xsl:when>
                <xsl:otherwise>
                    <xsd:complexType>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($nm, 'Type')"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="xsd:annotation" mode="globalize"/>
                        <xsl:apply-templates select="xsd:complexType/xsd:complexContent" mode="globalize"/>
                    </xsd:complexType>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$complex_types/*">
            <xsd:complexType name="{@name}">
                <xsl:copy-of select="xsd:annotation"/>
                <xsl:apply-templates select="xsd:complexContent" mode="globalize"/>
            </xsd:complexType>
        </xsl:for-each>
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
        <xsl:choose>
            <xsl:when test="ends-with($nm, 'Indicator')">
                <xsd:element ref="{$nm}">
                    <xsl:apply-templates select="@*" mode="globalize"/>
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="concat('Text Indicator Field with value ', @fixed)"/>
                        </xsd:documentation>
                    </xsd:annotation>
                </xsd:element>
            </xsl:when>
            <xsl:when test="ends-with($nm, 'SetHeading')">
                <xsd:element ref="{$nm}">
                    <xsl:apply-templates select="@minOccurs" mode="global"/>
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="concat('Heading with fixed value ', @fixed)"/>
                        </xsd:documentation>
                    </xsd:annotation>
                </xsd:element>
            </xsl:when>
            <xsl:otherwise>
                <xsd:element ref="{$nm}">
                    <xsl:apply-templates select="@minOccurs" mode="global"/>
                    <xsl:apply-templates select="xsd:annotation" mode="globalize"/>
                </xsd:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@*" mode="globalize">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    <xsl:template match="xsd:element/@name" mode="globalize"/>
    <xsl:template match="xsd:appinfo" mode="globalize">
        <xsl:copy>
            <xsl:element name="Set" namespace="urn:mtf:mil:6040b:goe:segments">
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

 <!-- ************** Unique Particle Attribution Mitigation ***********************-->
    <xsl:template match="xsd:element[@ref = 's:TimeAndPositionSet'][preceding-sibling::*[1]/@ref = 's:ReactionSet']" mode="globalize">
        <xsd:element ref="ReactionTimeAndPositionSet">
            <xsd:annotation>
                <xsd:documentation>The Reaction TMPOS set indicates the loss of visual contact or last pass of the of the aircraft or ship</xsd:documentation>
                <xsd:appinfo>
                    <Set positionName="TIME AND POSITION" concept="The TMPOS set indicates the loss of visual contact or last pass of the of the aircraft or ship"
                        usage="The TMPOS set is REQUIRED if the preceding REACT set is used; otherwise the TMPOS set is PROHIBITED."/>
                </xsd:appinfo>
            </xsd:annotation>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@ref = 's:DefenseMessageSystemSet'][preceding-sibling::*[1]/@ref = 's:TaskCommanderAddressRoutingSet']" mode="globalize">
        <xsd:element ref="TaskCommanderDefenseMessageSystemSet">
            <xsd:annotation>
                <xsd:documentation>The DMSINFO set provides information necessary to maintain correct routing information in the DMS community.</xsd:documentation>
                <xsd:appinfo>
                    <Set positionName="DEFENSE MESSAGE SYSTEM INFORMATION" concept="The DMSINFO set provides information necessary to maintain correct routing information in the DMS community."/>
                </xsd:appinfo>
            </xsd:annotation>
        </xsd:element>
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
                <xsd:annotation>
                    <xsl:copy-of select="xsd:annotation/xsd:documentation"/>
                </xsd:annotation>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="$global_types/xsd:element">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsd:element name="ReactionTimeAndPositionSet" type="s:TimeAndPositionSetType">
            <xsd:annotation>
                <xsd:documentation>The Reaction TMPOS set indicates the loss of visual contact or last pass of the of the aircraft or ship</xsd:documentation>
                <xsd:appinfo>
                    <Set positionName="TIME AND POSITION" concept="The TMPOS set indicates the loss of visual contact or last pass of the of the aircraft or ship"
                        usage="The TMPOS set is REQUIRED if the preceding REACT set is used; otherwise the TMPOS set is PROHIBITED."/>
                </xsd:appinfo>
            </xsd:annotation>
        </xsd:element>
        <xsd:element name="TaskCommanderDefenseMessageSystemSet" type="s:DefenseMessageSystemSetType">
            <xsd:annotation>
                <xsd:documentation>The DMSINFO set provides information necessary to maintain correct routing information in the DMS community.</xsd:documentation>
                <xsd:appinfo>
                    <Set positionName="DEFENSE MESSAGE SYSTEM INFORMATION" concept="The DMSINFO set provides information necessary to maintain correct routing information in the DMS community."/>
                </xsd:appinfo>
            </xsd:annotation>
        </xsd:element>
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
        <xsl:result-document href="{$segment_output}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:goe:segments" 
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                xmlns:mtf="urn:mtf:mil:6040b:goe"
                xmlns:f="urn:mtf:mil:6040b:goe:fields" 
                xmlns:s="urn:mtf:mil:6040b:goe:sets"
                xmlns:ism="urn:us:gov:ic:ism:v2" 
                targetNamespace="urn:mtf:mil:6040b:goe:segments" version="0.1">
                <xsd:import namespace="urn:mtf:mil:6040b:goe:fields" schemaLocation="GoE_fields.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:goe:sets" schemaLocation="GoE_sets.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>Message Text Format Segments</xsd:documentation>
                </xsd:annotation>
                <xsd:complexType name="SegmentBaseType">
                    <xsd:annotation>
                        <xsd:documentation>Base type for Segments which add security tagging.</xsd:documentation>
                    </xsd:annotation>
                    <xsd:complexContent>
                        <xsd:extension base="f:CompositeType">
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        </xsd:extension>
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
        <xsl:variable name="setID">
            <xsl:value-of select="$baseline_sets/xsd:schema/xsd:complexType[@name = concat($match, 'Type')]/xsd:annotation/xsd:appinfo/*:SetFormatIdentifier"/>
        </xsl:variable>
        <xsl:variable name="SetChangedName">
            <xsl:value-of select="translate($new_set_names/USMTF_Sets/Set[@SETNAMESHORT = $setID][string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/-()', '')"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:element[@name = $SetChangedName]/@type">
                <xsl:value-of select="$goe_sets_xsd/xsd:schema/xsd:element[@name = $SetChangedName]/@type"/>
            </xsl:when>
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
    <xsl:template match="xsd:documentation" mode="global">
        <xsl:if test="string-length(normalize-space(text())) > 0">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="text()"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    <xsl:template match="xsd:documentation">
        <xsl:if test="string-length(normalize-space(text())) > 0">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="text()"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
    <!--Convert appinfo items-->
    <!--InitialSetFormatPosition only applies in context of containing message-->
    <xsl:template match="*:InitialSetFormatPosition" mode="attr"/>
    <!--Use Position relative to segment vice position relative to containing message-->
    <xsl:template match="*:SegmentStructureName" mode="attr">
        <xsl:param name="SegChange"/>
        <xsl:attribute name="name">
            <xsl:choose>
                <xsl:when test="$SegChange">
                    <xsl:choose>
                        <xsl:when test="$SegChange/* and string-length($SegChange/@ProposedSegmentName) > 0">
                            <xsl:value-of select="$SegChange/@ProposedSegmentName"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
                                <xsl:attribute name="name">
                                    <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
                                </xsl:attribute>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
                        <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*:SegmentStructureUseDescription" mode="attr">
        <xsl:param name="SegChange"/>
        <xsl:choose>
            <xsl:when test="$SegChange">
                <xsl:choose>
                    <xsl:when test="$SegChange/@SEGMENT_CONCEPTUSE_DESCRIPTION">
                        <xsl:attribute name="usage">
                            <xsl:value-of select="$SegChange/@SEGMENT_CONCEPTUSE_DESCRIPTION"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
                            <xsl:attribute name="usage">
                                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
                    <xsl:attribute name="usage">
                        <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionUseDescription" mode="attr">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="usage">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionNumber" mode="attr">
        <xsl:variable name="pos" select="number(text())"/>
        <xsl:variable name="initpos">
            <xsl:value-of select="ancestor::xsd:complexType[1]/ancestor::xsd:element[1]/xsd:annotation/xsd:appinfo/*:InitialSetFormatPosition"/>
        </xsl:variable>
        <xsl:attribute name="position">
            <xsl:value-of select="number($pos) - $initpos + 1"/>
        </xsl:attribute>
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
                <xsl:element name="Document" namespace="urn:mtf:mil:6040b:segments">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:FieldFormatRelatedDocument">
                    <xsl:element name="Document" namespace="urn:mtf:mil:6040b:segments">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatExample" mode="examples">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:if test="not(preceding-sibling::*:SetFormatExample)">
                <xsl:element name="Example" namespace="urn:mtf:mil:6040b:segments">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:SetFormatExample">
                    <xsl:element name="Example" namespace="urn:mtf:mil:6040b:segments">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!--************* Replaced Fixed Value with one item Enumeratoin for NIEM *****************-->
    
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
    
    <xsl:template match="xsd:element[@fixed]" mode="ncopy">
        <xsd:complexType name="{concat(@name,'Type')}">
            <xsl:copy-of select="xsd:annotation"/>
            <xsd:simpleContent>
                <xsd:restriction base="f:FieldEnumeratedBaseType">
                    <xsd:enumeration value="{@fixed}">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="concat(@fixed,' fixed value')"/>
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
