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
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:set="urn:mtf:mil:6040b:sets"
    xmlns:segment="urn:mtf:mil:6040b:segments" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <!--This Transform produces a "Garden of Eden" style global elements XML Schema for Segments in the USMTF Military Message Standard.-->
    <!--The Resulting Global Elements will be included in the "usmtf_fields" XML Schema per proposed changes of September 2014-->
    <!--Duplicate Segment Names are deconflicted using an XML document containing affected messages, elements and approved changes-->

    <xsl:variable name="baseline_sets" select="document('../../XSD/Baseline_Schema/sets.xsd')"/>
    <xsl:variable name="baseline_msgs" select="document('../../XSD/Baseline_Schema/messages.xsd')"/>
    <xsl:variable name="goe_sets_xsd" select="document('../../XSD/GoE_Schema/GoE_sets.xsd')"/>
    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/GoE_Schema/GoE_fields.xsd')"/>
    <xsl:variable name="new_segment_names"
        select="document('../../XSD/Deconflicted/Segment_Name_Changes.xml')"/>
    <xsl:variable name="new_set_names"
        select="document('../../XSD/Deconflicted/Set_Name_Changes.xml')"/>

    <!-- ***********************  Segment Elements  ************************-->
    <!-- Extract all Segments from Baseline XML Schema for messages-->
    <!-- Copy every Segment Element and make global.  Populates segment_elements variable which includes duplicates -->
    <!--This process preserves all structure and converts it to desired format with references which will be used in ComplexTypes-->
    <!-- Add id to match msdid and element name with proposed name change list -->
    <xsl:variable name="segment_elements">
        <xsl:for-each select="$baseline_msgs/*//xsd:element[contains(@name, 'Segment')]">
            <xsl:sort select="@name" data-type="text"/>
            <xsl:variable name="mtfid"
                select="ancestor-or-self::xsd:element[parent::xsd:schema]/xsd:annotation/xsd:appinfo/*:MtfIdentifier"/>
            <xsl:variable name="baseline_name">
                <xsl:choose>
                    <xsl:when test="ends-with(@name, 'Segment')">
                        <xsl:value-of select="@name"/>
                    </xsl:when>
                    <xsl:when test="contains(@name, 'Segment_')">
                        <xsl:value-of select="substring-before(@name, '_')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:copy copy-namespaces="no">
                <xsl:attribute name="name">
                    <xsl:choose>
                        <xsl:when
                            test="$new_segment_names/USMTF_Segments/Segment[@MtfId = $mtfid and @ElementName = $baseline_name]">
                            <xsl:value-of
                                select="$new_segment_names/USMTF_Segments/Segment[@MtfId = $mtfid and @ElementName = $baseline_name]/@NewElementName"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$baseline_name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of
                        select="translate(ancestor::xsd:element[parent::xsd:schema]/xsd:annotation/xsd:appinfo/*:MtfIdentifier, ' ', '_')"/>
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

    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Segment')]]">
        <xsl:param name="doc"/>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Segment" xmlns="urn:mtf:mil:6040b:segments">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Set')]]">
        <xsl:param name="doc"/>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Set" xmlns="urn:mtf:mil:6040b:segments">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Field')]]">
        <xsl:param name="doc"/>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Field" xmlns="urn:mtf:mil:6040b:segments">
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
            <xsl:when
                test="preceding-sibling::*[name() = $nm] and not($txt = ' ') and not(*) and not($txt = '')">
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

    <!-- ***********************  Global Types  ************************-->

    <xsl:variable name="global_types">
        <xsl:for-each select="$segment_elements/*">
            <xsl:variable name="nm" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:element[@name = $nm])">
                <xsl:apply-templates select="." mode="globaltype"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="xsd:element" mode="globaltype">
        <xsl:variable name="segmentName">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsd:complexType>
            <xsl:attribute name="name">
                <xsl:value-of select="concat($segmentName, 'Type')"/>
            </xsl:attribute>
            <xsl:apply-templates select="xsd:annotation" mode="global"/>
            <xsl:apply-templates select="xsd:complexType/xsd:sequence" mode="global"/>
        </xsd:complexType>
    </xsl:template>

    <xsl:template match="*" mode="global">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="global"/>
            <xsl:apply-templates select="*" mode="global"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="global">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

    <!--Normalize extra whitespace and linefeeds in text-->
    <xsl:template match="text()" mode="global">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="xsd:element[not(starts-with(@name, 'GeneralText_'))]" mode="global">
        <xsl:variable name="elname">
            <xsl:choose>
                <xsl:when test="contains(@name, '_')">
                    <xsl:value-of select="substring-before(@name, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="setID">
            <xsl:value-of
                select="$baseline_sets/xsd:schema/xsd:complexType[@name = concat($elname, 'Type')]/xsd:annotation/xsd:appinfo/*:SetFormatIdentifier"
            />
        </xsl:variable>
        <xsl:variable name="newSetName">
            <xsl:value-of
                select="translate($new_set_names/USMTF_Sets/Set[@SETNAMESHORT = $setID][string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/-()', '')"
            />
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:element/@name = $newSetName">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('set:', $newSetName)"/>
                    </xsl:attribute>
                    <xsl:copy-of select="xsd:annotation"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:element/@name = $elname">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('set:', $elname)"/>
                    </xsl:attribute>
                    <xsl:copy-of select="xsd:annotation"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$segment_elements/xsd:element/@name = $elname">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="$elname"/>
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

    <xsl:template match="xsd:element[starts-with(@name, 'GeneralText_')]" mode="global">
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
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <!--handle 2 special cases with parens-->
            <xsl:attribute name="name">
                <xsl:value-of
                    select="translate(concat('GenText', replace(replace($CCase, '(TAS)', ''), '(mpa)', '')), ' ()', '')"
                />
            </xsl:attribute>
            <xsl:copy-of select="xsd:annotation"/>
            <xsd:complexType>
                <xsd:complexContent>
                    <xsd:extension base="set:GeneralTextType">
                        <xsd:sequence>
                            <xsd:element name="GentextTextIndicator"
                                type="field:AlphaNumericBlankSpecialTextType" minOccurs="1"
                                fixed="{replace($TextInd,$apos,'')}"/>
                            <xsd:element ref="field:FreeTextField" minOccurs="1"/>
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
                            <xsl:value-of
                                select="substring(substring-after(@base, 's:'), 0, string-length(substring-after(@base, 's:')) - 3)"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(@base, 0, string-length(@base) - 3)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="base">
                <xsl:choose>
                    <xsl:when
                        test="$goe_sets_xsd/xsd:schema/xsd:complexType[@name = $match_new_name]">
                        <xsl:value-of select="concat('set:', $match_new_name)"/>
                    </xsl:when>
                    <xsl:when
                        test="$goe_sets_xsd/xsd:schema/xsd:simpleType[@name = $match_new_name]">
                        <xsl:value-of select="concat('set:', $match_new_name)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$match_new_name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="*" mode="global"/>
        </xsl:copy>
    </xsl:template>

    <!-- ********************  Global Elements  *********************-->

    <xsl:variable name="global_elements">
        <xsl:for-each select="$global_types/*">
            <xsl:variable name="nm" select="@name"/>
            <xsl:element name="xsd:element">
                <xsl:attribute name="name">
                    <xsl:value-of select="substring($nm,0,string-length($nm)-3)"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:value-of select="$nm"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:for-each>
    </xsl:variable>

    <!-- ************************************************************-->

    <!--Build XML Schema and add Global Elements and Complex Types -->
    <xsl:template match="/">
        <xsl:result-document href="../../XSD/GoE_Schema/GoE_segments.xsd">
            <xsd:schema xmlns="urn:mtf:mil:6040b:segments"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:field="urn:mtf:mil:6040b:fields"
                xmlns:ism="urn:us:gov:ic:ism:v2" targetNamespace="urn:mtf:mil:6040b:segments">
                <xsd:import namespace="urn:mtf:mil:6040b:fields" schemaLocation="GoE_fields.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:sets" schemaLocation="GoE_sets.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsl:copy-of select="$global_types"/>
                <xsl:copy-of select="$global_elements"/>
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
            <xsl:value-of
                select="$baseline_sets/xsd:schema/xsd:complexType[@name = concat($match, 'Type')]/xsd:annotation/xsd:appinfo/*:SetFormatIdentifier"
            />
        </xsl:variable>
        <xsl:variable name="SetChangedName">
            <xsl:value-of
                select="translate($new_set_names/USMTF_Sets/Set[@SETNAMESHORT = $setID][string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/-()', '')"
            />
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:element[@name = $SetChangedName]/@type">
                <xsl:value-of
                    select="$goe_sets_xsd/xsd:schema/xsd:element[@name = $SetChangedName]/@type"/>
            </xsl:when>
            <xsl:when test="$goe_sets_xsd/xsd:schema/xsd:element[@name = $match]/@type">
                <xsl:value-of select="$goe_sets_xsd/xsd:schema/xsd:element[@name = $match]/@type"/>
            </xsl:when>
            <xsl:when
                test="$goe_sets_xsd/xsd:schema/xsd:element[@name = $match]/xsd:simpleType/xsd:restriction/@base">
                <xsl:value-of
                    select="$goe_sets_xsd/xsd:schema/xsd:element[@name = $match]/xsd:simpleType/xsd:restriction/@base"
                />
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
        <xsl:value-of
            select="translate(substring($text, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        <xsl:value-of
            select="translate(substring($text, 2, string-length($text) - 1), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"
        />
    </xsl:template>

    <xsl:template match="xsd:appinfo" mode="ref">
        <xsl:param name="fldinfo"/>
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Field" namespace="urn:mtf:mil:6040b:sets">
                <xsl:apply-templates select="*" mode="attr"/>
                <xsl:if test="parent::xsd:annotation/parent::xsd:extension">
                    <xsl:variable name="ffdno">
                        <xsl:value-of
                            select="parent::xsd:annotation/parent::xsd:extension/xsd:attribute[@name = 'ffirnFudn']/@fixed"
                        />
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
    <!--InitialSetFormatPosition only applies in context of containing message-->
    <xsl:template match="*:InitialSetFormatPosition" mode="attr"/>
    <!--Use Position relative to segment vice position relative to containing message-->
    <xsl:template match="*:SegmentStructureName" mode="attr">
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="name">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SegmentStructureUseDescription" mode="attr">
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="usage">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionUseDescription" mode="attr">
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="usage">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionNumber" mode="attr">
        <xsl:variable name="pos" select="number(text())"/>
        <xsl:variable name="initpos">
            <xsl:value-of
                select="ancestor::xsd:complexType[1]/ancestor::xsd:element[1]/xsd:annotation/xsd:appinfo/*:InitialSetFormatPosition"
            />
        </xsl:variable>
        <xsl:attribute name="position">
            <xsl:value-of select="number($pos) - $initpos + 1"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*:SetFormatName" mode="attr">
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="name">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatIdentifier" mode="attr">
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="id">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:VersionIndicator" mode="attr">
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="version">
                <xsl:value-of select="replace(normalize-space(text()), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionConcept" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not($doc = normalize-space(text()))">
            <xsl:attribute name="concept">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatPositionName" mode="attr">
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="positionName">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatPositionName" mode="attr">
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="positionName">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatPositionConcept" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = $doc)">
            <xsl:attribute name="concept">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatName" mode="attr">
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="name">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatDefinition" mode="attr">
        <xsl:param name="doc"/>
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = $doc)">
            <xsl:attribute name="definition">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatRemark" mode="attr">
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:attribute name="remark">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatRelatedDocument" mode="docs">
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = 'NONE')">
            <xsl:if test="not(preceding-sibling::*:FieldFormatRelatedDocument)">
                <xsl:element name="Document" namespace="urn:mtf:mil:6040b:sets">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:FieldFormatRelatedDocument">
                    <xsl:element name="Document" namespace="urn:mtf:mil:6040b:sets">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:SetFormatExample" mode="examples">
        <xsl:if
            test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:if test="not(preceding-sibling::*:SetFormatExample)">
                <xsl:element name="Example" namespace="urn:mtf:mil:6040b:sets">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:SetFormatExample">
                    <xsl:element name="Example" namespace="urn:mtf:mil:6040b:sets">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:FieldFormatPositionNumber" mode="attr"/>
    <xsl:template match="*:AlternativeType" mode="attr"/>
    <xsl:template match="*:OccurrenceCategory" mode="attr"/>
    <xsl:template match="*:SetFormatExample" mode="attr"/>
    <xsl:template match="*:SetFormatRelatedDocuments" mode="attr"/>
    <xsl:template match="*:RepeatabilityForGroupOfFields" mode="attr"/>
    <xsl:template match="*:SetFormatDescription" mode="attr"/>
    <xsl:template match="*:FieldFormatRelatedDocument" mode="attr"/>
    <xsl:template match="*:Repeatability" mode="attr"/>

    <!--Filter unneeded nodes-->
    <xsl:template match="xsd:attribute[@name='setSeq']"/>
    <xsl:template match="xsd:attributeGroup[@ref='ism:SecurityAttributesGroup']"/>
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
