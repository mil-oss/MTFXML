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
    <xsl:include href="Utility.xsl"/>
    <xsl:variable name="mtfmsgs" select="document('../../XSD/Baseline_Schema/messages.xsd')"/>
    <xsl:variable name="mtfsets" select="document('../../XSD/Baseline_Schema/sets.xsd')"/>
    <xsl:variable name="fields" select="document('../../XSD/GoE_Schema/GoE_fields.xsd')"/>
    <xsl:variable name="sets" select="document('../../XSD/GoE_Schema/GoE_sets.xsd')"/>
    <xsl:variable name="segments" select="document('../../XSD/GoE_Schema/GoE_segments.xsd')"/>
    <xsl:variable name="set_Changes" select="document('../../XSD/Deconflicted/Set_Name_Changes.xml')/USMTF_Sets"/>
    <xsl:variable name="segment_Changes" select="document('../../XSD/Deconflicted/Segment_Name_Changes.xml')/USMTF_Segments"/>
    <xsl:variable name="outputdoc" select="'../../XSD/GoE_Schema/GoE_messages.xsd'"/>
    <xsl:variable name="rulesdoc" select="'../../XSD/GoE_Schema/GoE_message_rules.xsd'"/>
    <!--*****************************************************-->
    <xsl:variable name="msgs">
        <xsl:apply-templates select="$mtfmsgs/xsd:schema/xsd:element" mode="el">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="rules">
        <xsl:for-each select="$mtfmsgs/xsd:schema/xsd:element">
            <xsd:element name="{concat(@name,'Rules')}">
                <xsd:annotation>
                    <xsd:appinfo>
                        <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*[name() = 'MtfStructuralRelationship']" mode="el"/>
                    </xsd:appinfo>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>
    <!--*****************************************************-->
    <xsl:template match="xsd:schema/xsd:element" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:variable name="n">
                <xsl:apply-templates select="@name" mode="txt"/>
            </xsl:variable>
            <xsl:attribute name="name">
                <xsl:value-of select="$n"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="concat($n, 'Type')"/>
            </xsl:attribute>
            <xsl:apply-templates select="xsd:annotation" mode="el"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:element/xsd:annotation" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="*" mode="el"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:element/xsd:annotation/xsd:appinfo" mode="el">
        <xsl:copy copy-namespaces="no">
            <Msg>
                <xsl:apply-templates select="*[not(name() = 'MtfStructuralRelationship')]" mode="attr"/>
                <xsl:apply-templates select="*:MtfRelatedDocument" mode="doc"/>
            </Msg>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:documentation" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:copy>
    </xsl:template>
    <!--Include Rules as attribute strings.  Replace double quotes with single quotes-->
    <xsl:template match="*[name() = 'MtfStructuralRelationship']" mode="el">
        <!--OMIT RULES ENFORCED BY ASSIGNED FIXED VALUES-->
        <!--<xsl:choose>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipRule/text(), '[3]F1')"/>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipRule/text(), '[3]F2')"/>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipRule/text(), '[3]F3')"/>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipExplanation/text(), 'Field 1 In GENTEXT')"/>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipExplanation/text(), 'Field 1 in GENTEXT')"/>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipExplanation/text(), 'Field 1 IN GENTEXT')"/>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipExplanation/text(), 'Field 1 in the GENTEXT')"/>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipExplanation/text(), 'Field 1 of GENTEXT')"/>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipExplanation/text(), 'Field 1 in HEADING')"/>
            <xsl:when test="starts-with(*:MtfStructuralRelationshipExplanation/text(), 'Field 1 of HEADING')"/>
            <xsl:otherwise>
                <!-\-<xsl:element name="MsgRule">-\->
                    <xsl:apply-templates select="*[string-length(text()[1]) > 0]" mode="trimattr"/>
                <!-\-</xsl:element>-\->
            </xsl:otherwise>
        </xsl:choose>-->
        <xsl:element name="Msg">
            <xsl:apply-templates select="*[string-length(text()[1]) > 0]" mode="trimattr"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*" mode="trimattr">
        <xsl:variable name="apos">&#39;</xsl:variable>
        <xsl:variable name="quot">&#34;</xsl:variable>
        <xsl:variable name="nm" select="lower-case(substring-after(name(), 'MtfStructuralRelationship'))"/>
        <xsl:choose>
            <xsl:when test="$nm = 'rule'">
                <xsl:attribute name="structure">
                    <xsl:value-of select="normalize-space(translate(replace(., $quot, $apos), '&#xA;', ''))" disable-output-escaping="yes"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="{$nm}">
                    <xsl:value-of select="normalize-space(translate(replace(., $quot, $apos), '&#xA;', ''))" disable-output-escaping="yes"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--*****************************************************-->
    <xsl:variable name="ctypes">
        <xsl:apply-templates select="$mtfmsgs/xsd:schema/xsd:element" mode="ctype"/>
    </xsl:variable>
    <xsl:template match="xsd:schema/xsd:element" mode="ctype">
        <xsd:complexType name="{concat(@name,'Type')}">
            <xsl:apply-templates select="@*" mode="ctype"/>
            <xsl:apply-templates select="xsd:annotation" mode="el"/>
            <xsd:complexContent>
                <xsd:extension base="MessageBaseType">
                    <xsl:apply-templates select="xsd:complexType/xsd:sequence" mode="ctype"/>
                </xsd:extension>
            </xsd:complexContent>
        </xsd:complexType>
    </xsl:template>
    <xsl:template match="@base" mode="ctype">
        <xsl:variable name="b">
            <xsl:apply-templates select="." mode="txt"/>
        </xsl:variable>
        <xsl:attribute name="base">
            <xsl:value-of select="concat('set:', $b)"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:element/@name" mode="ctype"/>
    <xsl:template match="xsd:schema/xsd:element/xsd:annotation/xsd:appinfo" mode="ctype">
        <xsl:copy>
            <xsl:apply-templates select="*" mode="attr"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:element" mode="ctype">
        <xsl:variable name="elname">
            <xsl:variable name="n">
                <xsl:apply-templates select="@name" mode="txt"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="starts-with($n, '_')">
                    <xsl:value-of select="substring-after($n, '_')"/>
                </xsl:when>
                <xsl:when test="contains($n, '_')">
                    <xsl:value-of select="substring-before($n, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$n"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="setid">
            <xsl:value-of select="$mtfsets/xsd:schema/xsd:complexType[@name = concat($elname, 'Type')]/xsd:annotation/xsd:appinfo/*:SetFormatIdentifier"/>
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
                    <xsl:value-of select="concat(translate($set_Changes/Set[@SETNAMESHORT = $setid and string-length(@ProposedSetFormatName) > 0][1]/@ProposedSetFormatName, ' ,/-().', ''), 'Set')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($elname, 'Set')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <!--DECONFLICT SPECIFICS-->
            <xsl:when test="$newname = 'ShipPositionAndMovementSet' and contains(xsd:annotation/xsd:documentation, '1SHIPARR')">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="name">
                        <xsl:text>ShipPositionAndMovementArrivalSet</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:text>set:ShipPositionAndMovementSetType</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')][not(name() = 'type')]" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$newname = 'ShipPositionAndMovementSet' and contains(xsd:annotation/xsd:documentation, '1SHIPDEP')">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="name">
                        <xsl:text>ShipPositionAndMovementDepartureSet</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:text>set:ShipPositionAndMovementSetType</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')][not(name() = 'type')]" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="exists($sets/xsd:schema/xsd:element[@name = $newname])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('set:', $newname)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="starts-with(./xsd:complexType/xsd:complexContent/xsd:extension/@base, 's:')">
                <xsl:variable name="b" select="./xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
                <xsl:variable name="bsettype">
                    <xsl:value-of select="concat(substring($b, 0, string-length($b) - 3), 'SetType')"/>
                </xsl:variable>
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="name">
                        <xsl:value-of select="$newname"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="replace($bsettype, 's:', 'set:')"/>
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
    <xsl:template match="xsd:element[xsd:annotation/xsd:appinfo/*:SegmentStructureName]" mode="ctype">
        <xsl:variable name="elname">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:variable name="mtfid">
            <xsl:value-of select="ancestor::xsd:element[parent::xsd:schema]/xsd:annotation/xsd:appinfo/*:MtfIdentifier"/>
        </xsl:variable>
        <xsl:variable name="newname">
            <xsl:choose>
                <xsl:when test="exists($segment_Changes/Segment[@MTF_NAME = $mtfid and @SegmentElement = $elname])">
                    <xsl:value-of select="$segment_Changes/Segment[@MTF_NAME = $mtfid and @SegmentElement = $elname]/@ProposedSegmentElement"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$elname"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exists($segments/xsd:schema/xsd:element[@name = $newname])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('seg:', $newname)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'name')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="exists($segments/xsd:schema/xsd:element[@name = $elname])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('seg:', $elname)"/>
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
    <xsl:template match="@*" mode="ctype">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="text()" mode="ctype">
        <xsl:value-of select="translate(normalize-space(.), '&#34;&#xA;', '')"/>
    </xsl:template>
    <xsl:template match="xsd:complexType/xsd:sequence/xsd:choice/xsd:annotation" mode="ctype"/>
    <xsl:template match="xsd:schema/xsd:element/xsd:complexType/xsd:attribute" mode="ctype"/>
    <!--*****************************************************-->
    <xsl:variable name="ref_ctypes">
        <xsl:for-each select="$ctypes/*">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="@*" mode="globalize"/>
                <xsl:apply-templates select="text()" mode="globalize"/>
                <xsl:copy-of select="xsd:annotation"/>
                <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]" mode="globalize"/>
            </xsl:copy>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="global_ctypes">
        <xsl:for-each select="$ctypes/*/*//xsd:element[@name]">
            <xsl:variable name="nm" select="@name"/>
            <xsl:choose>
                <xsl:when test="ends-with($nm, 'Indicator')">
                    <xsd:element name="{$nm}" type="field:AlphaNumericBlankSpecialTextType" fixed="{@fixed}">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="concat('Text Indicator Field with fixed value ', @fixed)"/>
                            </xsd:documentation>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
                <xsl:when test="ends-with($nm, 'HeadingText')">
                    <xsd:element name="{$nm}" type="field:AlphaNumericBlankSpecialTextType" fixed="{@fixed}">
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
                <xsl:when test="$nm='ShipPositionAndMovementArrivalSet'">
                    <xsd:element name="ShipPositionAndMovementArrivalSet" type="set:ShipPositionAndMovementSetType">
                        <xsd:annotation>
                            <xsd:documentation>The 9SHIP set reports the location and movement of the ships reported in the 1SHIPARR set.</xsd:documentation>
                            <xsd:appinfo>
                                <Set positionName="SHIP POSITION AND MOVEMENT DATA"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
                <xsl:when test="$nm='ShipPositionAndMovementDepartureSet'">
                    <xsd:element name="ShipPositionAndMovementDepartureSet" type="set:ShipPositionAndMovementSetType">
                        <xsd:annotation>
                            <xsd:documentation>The 9SHIP set reports the location and movement of the ships reported in the 1SHIPDEP set.</xsd:documentation>
                            <xsd:appinfo>
                                <Set positionName="SHIP POSITION AND MOVEMENT DATA"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsd:complexType name="{concat(@name,'Type')}">
                        <xsl:apply-templates select="xsd:annotation" mode="global"/>
                        <xsl:apply-templates select="xsd:complexType/xsd:complexContent" mode="globalize"/>
                    </xsd:complexType>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$ctypes//xsd:element[@ref = 'set:MessageIdentifierSet']">
            <xsl:variable name="msgnm" select="ancestor::xsd:complexType[@name][1]/@name"/>
            <xsl:call-template name="MSGidSet">
                <xsl:with-param name="msgnode" select="substring($msgnm,0,string-length($msgnm)-3)"/>
                <xsl:with-param name="appinfo">
                    <xsl:copy-of select="ancestor::xsd:complexType[@name][1]/xsd:annotation/xsd:appinfo"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:variable>
    <!--Replace named elements with refs-->
    <xsl:template match="*" mode="globalize">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="globalize"/>
            <xsl:apply-templates select="text()" mode="globalize"/>
            <xsl:apply-templates select="*" mode="globalize"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="xsd:element[@name]" mode="globalize">
        <xsl:variable name="nm" select="@name"/>
        <xsl:variable name="msgnm" select="ancestor::xsd:complexType[@name][1]/@name"/>
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
            <xsl:element name="Set" namespace="urn:mtf:mil:6040b:goe:mtf">
                <xsl:copy-of select="ancestor::xsd:element[1]/@minOccurs"/>
                <xsl:copy-of select="ancestor::xsd:element[1]/@maxOccurs"/>
                <xsl:apply-templates select="*:Set/@*" mode="globalize"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@ref[.='set:MessageIdentifierSet']" mode="globalize">
        <xsl:variable name="msgnode" select="ancestor::xsd:complexType[@name][1]/@name"/>
        <xsl:variable name="msgnoderef">
            <xsl:value-of select="substring($msgnode,0,string-length($msgnode)-3)"/>
        </xsl:variable>
        <xsl:attribute name="ref">
            <xsl:value-of select="concat($msgnoderef,'MessageIdentifierSet')"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@type" mode="globalize"/>
    <xsl:template match="@maxOccurs" mode="globalize"/>
    <xsl:template match="xsd:choice/@minOccurs" mode="globalize"/>
    <xsl:template match="@fixed" mode="globalize"/>
    <xsl:template match="@position" mode="globalize"/>

    <!--*****************************************************-->
    <xsl:template match="*" mode="global">
        <xsl:copy>
            <xsl:apply-templates select="*" mode="global"/>
            <xsl:apply-templates select="text()" mode="global"/>
            <xsl:apply-templates select="@*" mode="global"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="global">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="text()" mode="global">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="@concept" mode="global"/>
    <xsl:template match="@position" mode="global"/>
    <xsl:template match="@usage" mode="global"/>
    <xsl:template match="@minOccurs" mode="global"/>
    <!--*****************************************************-->
    <xsl:variable name="global_elements">
        <xsl:for-each select="$global_ctypes/xsd:complexType">
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
        <xsl:for-each select="$global_ctypes/xsd:element">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:call-template name="MsgStdandVersion"/>
    </xsl:variable>
    <xsl:variable name="deconfl_ctypes">
        <xsl:for-each select="$global_ctypes/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:choose>
                <xsl:when test="count($global_ctypes/xsd:complexType[@name = $n]) &gt; 1">
                    <xsl:choose>
                        <xsl:when test="not(preceding-sibling::xsd:complexType[@name = $n])">
                            <!--<xsl:copy-of select="."/>-->
                            <xsl:copy-of select="."/>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="deconfl_gels">
        <xsl:for-each select="$global_elements/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n">
                <xsl:value-of select="@name"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="count($global_elements/xsd:element[@name = $n]) &gt; 1">
                    <xsl:choose>
                        <xsl:when test="not(preceding-sibling::xsd:element[@name = $n])">
                            <!--<xsl:copy-of select="."/>-->
                            <xsl:apply-templates select="." mode="ncopy"/>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="ncopy"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="niem_ctypes">
        <xsl:copy-of select="$deconfl_ctypes"/>
        <xsl:for-each select="$deconfl_gels/xsd:complexType">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="niem_elements">
        <xsl:for-each select="$deconfl_gels/xsd:element">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <!--*****************************************************-->
    <xsl:template name="main">
        <xsl:result-document href="{$outputdoc}">
            <xsd:schema xml:lang="en-US" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="urn:mtf:mil:6040b:goe:mtf" targetNamespace="urn:mtf:mil:6040b:goe:mtf"
                xmlns:field="urn:mtf:mil:6040b:goe:fields" xmlns:set="urn:mtf:mil:6040b:goe:sets" xmlns:seg="urn:mtf:mil:6040b:goe:segments" xmlns:ism="urn:us:gov:ic:ism:v2"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="0.1">
                <xsd:import namespace="urn:mtf:mil:6040b:goe:fields" schemaLocation="GoE_fields.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:goe:sets" schemaLocation="GoE_sets.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:goe:segments" schemaLocation="GoE_segments.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>XML Schema for MTF Messages</xsd:documentation>
                </xsd:annotation>
                <xsd:complexType name="MessageBaseType">
                    <xsd:annotation>
                        <xsd:documentation>Base type for Messages which add security tagging.</xsd:documentation>
                    </xsd:annotation>
                    <xsd:complexContent>
                        <xsd:extension base="field:CompositeType">
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        </xsd:extension>
                    </xsd:complexContent>
                </xsd:complexType>
                <xsl:text>&#10;</xsl:text>
                <xsl:comment> ************** MESSAGE TYPES **************</xsl:comment>
                <xsl:text>&#10;</xsl:text>
                <xsl:copy-of select="$ref_ctypes"/>
                <xsl:text>&#10;</xsl:text>
                <xsl:comment> ************** MESSAGE ELEMENTS **************</xsl:comment>
                <xsl:text>&#10;</xsl:text>
                <xsl:copy-of select="$msgs"/>
                <xsl:text>&#10;</xsl:text>
                <xsl:comment> ************** GLOBAL TYPES **************</xsl:comment>
                <xsl:text>&#10;</xsl:text>
                <xsl:for-each select="$niem_ctypes/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:text>&#10;</xsl:text>
                <xsl:comment> ************** GLOBAL ELEMENTS **************</xsl:comment>
                <xsl:text>&#10;</xsl:text>
                <xsl:for-each select="$niem_elements/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$rulesdoc}">
            <xsd:schema xml:lang="en-US" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="urn:mtf:mil:6040b:goe:mtf" targetNamespace="urn:mtf:mil:6040b:goe:mtf" elementFormDefault="unqualified"
                attributeFormDefault="unqualified">
                <xsl:copy-of select="$rules"/>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <!--*************** GeneralText Fixed Values **********************-->
    <xsl:template match="xsd:element[starts-with(@name, 'GeneralText')]" mode="ctype">
        <xsl:variable name="per">&#46;</xsl:variable>
        <xsl:variable name="apos">&#34;</xsl:variable>
        <xsl:variable name="lparen">&#40;</xsl:variable>
        <xsl:variable name="rparen">&#41;</xsl:variable>
        <xsl:variable name="UseDesc">
            <xsl:value-of select="normalize-space(translate(upper-case(xsd:annotation/xsd:appinfo/*:SetFormatPositionUseDescription), '.', ''))"/>
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
            <xsl:choose>
                <xsl:when test="contains(xsd:annotation/xsd:documentation, 'GENTEXT/ACSIGN') and contains(xsd:annotation/xsd:documentation, 'airborne')">
                    <xsl:text>AirborneAcsign</xsl:text>
                </xsl:when>
                <xsl:when test="contains(xsd:annotation/xsd:documentation, 'GENTEXT/ACSIGN') and contains(xsd:annotation/xsd:documentation, 'ground')">
                    <xsl:text>GroundAcsign</xsl:text>
                </xsl:when>
                <xsl:when test="contains(xsd:annotation/xsd:documentation, 'GENTEXT/ACSIGN') and contains(xsd:annotation/xsd:documentation, 'shipborne')">
                    <xsl:text>ShipborneAcsign</xsl:text>
                </xsl:when>
                <xsl:when test="contains(xsd:annotation/xsd:documentation, 'GENTEXT/ARCHITECTURE') and contains(xsd:annotation/xsd:documentation, 'BGDBM')">
                    <xsl:text>BGDBMArchitectureConfigurationAmplification</xsl:text>
                </xsl:when>
                <xsl:when test="starts-with($CCase, '48-')">
                    <xsl:text>FortyeighthourOutlookForecast</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(replace(replace($CCase, '(TAS)', ''), '(mpa)', ''), ' ,/”()-', '')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="fixed">
            <xsl:value-of select="translate(replace($TextInd, $apos, ''), '”', '')"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <!--<xsl:apply-templates select="@*"/>-->
            <!--handle 2 special cases with parens-->
            <xsl:attribute name="name">
                <xsl:value-of select="concat($n, 'GenText')"/>
            </xsl:attribute>
            <xsl:element name="xsd:annotation">
                <xsl:apply-templates select="xsd:annotation/*" mode="ctype"/>
            </xsl:element>
            <xsd:complexType>
                <xsd:complexContent>
                    <xsd:extension base="set:GeneralTextSetType">
                        <xsd:sequence>
                            <xsd:element name="{concat($n,'Indicator')}" type="field:AlphaNumericBlankSpecialTextType" minOccurs="1" fixed="{$fixed}">
                                <xsd:annotation>
                                    <xsd:documentation>
                                        <xsl:value-of select="$fixed"/>
                                    </xsd:documentation>
                                </xsd:annotation>
                            </xsd:element>
                            <xsd:element ref="field:FreeTextField" minOccurs="1"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
        </xsl:copy>
    </xsl:template>
    <!--*************** HeadingInformation Fixed Values **********************-->
    <xsl:template match="xsd:element[starts-with(@name, 'HeadingInformation')]" mode="ctype">
        <xsl:variable name="per">&#46;</xsl:variable>
        <xsl:variable name="apos">&#34;</xsl:variable>
        <xsl:variable name="lparen">&#40;</xsl:variable>
        <xsl:variable name="rparen">&#41;</xsl:variable>
        <xsl:variable name="UseDesc">
            <xsl:value-of select="normalize-space(translate(upper-case(xsd:annotation/xsd:appinfo/*:SetFormatPositionUseDescription), '.', ''))"/>
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
            <xsl:value-of select="translate(replace(replace($CCase, '(TAS)', ''), '(mpa)', ''), ' ,/”()-', '')"/>
        </xsl:variable>
        <xsl:variable name="fixed">
            <xsl:value-of select="translate(replace($TextInd, $apos, ''), '”', '')"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="name">
                <xsl:value-of select="concat($n, 'HeadingSet')"/>
            </xsl:attribute>
            <xsl:element name="xsd:annotation">
                <xsl:apply-templates select="xsd:annotation/*" mode="ctype"/>
            </xsl:element>
            <xsd:complexType>
                <xsd:complexContent>
                    <xsd:extension base="set:HeadingInformationSetType">
                        <xsd:sequence>
                            <xsd:element name="{concat($n,'HeadingText')}" type="field:AlphaNumericBlankSpecialTextType" minOccurs="1" fixed="{$fixed}">
                                <xsd:annotation>
                                    <xsd:documentation>
                                        <xsl:value-of select="$fixed"/>
                                    </xsd:documentation>
                                </xsd:annotation>
                            </xsd:element>
                            <xsd:element ref="field:FreeTextField" minOccurs="1"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*:MtfRelatedDocument" mode="doc">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = 'NONE')">
            <xsl:if test="not(preceding-sibling::*:MtfRelatedDocument)">
                <xsl:element name="Document" namespace="urn:mtf:mil:6040b:goe:mtf">
                    <xsl:apply-templates select="text()"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:MtfRelatedDocument">
                    <xsl:element name="Document" namespace="urn:mtf:mil:6040b:goe:mtf">
                        <xsl:apply-templates select="text()"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <!--*****************************************************-->
    <xsl:template name="MSGidSet">
        <xsl:param name="msgnode"/>
        <xsl:param name="appinfo"/>
        <xsd:complexType name="{concat($msgnode,'MessageIdentifierSetType')}">
            <xsd:annotation>
                <xsd:documentation>
                    <xsl:value-of select="concat($appinfo/*/*:Msg/@name, ' MESSAGE IDENTIFIER SET')"/>
                </xsd:documentation>
                <xsl:copy-of select="$appinfo"/>
            </xsd:annotation>
            <xsd:complexContent>
                <xsd:extension base="set:SetBaseType">
                    <xsd:sequence>
                        <xsd:element ref="{concat($msgnode,'MessageIdentifier')}">
                            <xsd:annotation>
                                <xsd:documentation>THE IDENTIFIER OF A MESSAGE OR REPORT.</xsd:documentation>
                                <xsd:appinfo>
                                    <Field positionName="MESSAGE TEXT FORMAT IDENTIFIER" concept="THE IDENTIFIER OF A MESSAGE OR REPORT." identifier="A" name="MessageType"
                                        definition="THE TYPE OF MESSAGE OR REPORT." version="B.1.01.00"/>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                        <xsd:element ref="MessageTextFormatStandard" minOccurs="1" maxOccurs="1">
                            <xsd:annotation>
                                <xsd:documentation>The military standard that contains the message format rules.</xsd:documentation>
                                <xsd:appinfo>
                                    <Field positionName="STANDARD OF MESSAGE TEXT FORMAT" concept="The military standard that contains the message format rules." identifier="A" name="Standard"
                                        definition="The standard from which the message is derived." version="B.1.01.00"/>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                        <xsd:element ref="MessageTextFormatVersion" minOccurs="1" maxOccurs="1">
                            <xsd:annotation>
                                <xsd:documentation>The version of the message text format. The message version consists of four parts: Part 1 is the edition letter of MIL-STD-6040(SERIES), e.g., A, B,
                                    C through Z, Part 2 is the change number of the edition (0-5), Part 3 is the major change for the message, e.g., 01-99, and Part 4 is the minor change for the
                                    message, e.g., 00-99.</xsd:documentation>
                                <xsd:appinfo>
                                    <Field positionName="VERSION OF MESSAGE TEXT FORMAT"
                                        concept="The version of the message text format. The message version consists of four parts: Part 1 is the edition letter of MIL-STD-6040(SERIES), e.g., A, B, C through Z, Part 2 is the change number of the edition (0-5), Part 3 is the major change for the message, e.g., 01-99, and Part 4 is the minor change for the message, e.g., 00-99."
                                        identifier="A" name="Standard" definition="The standard from which the message is derived." version="B.1.01.00"/>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                        <xsd:element ref="field:Originator" minOccurs="1" maxOccurs="1">
                            <xsd:annotation>
                                <xsd:documentation>The identifier of the originator of the message.</xsd:documentation>
                                <xsd:appinfo>
                                    <Field positionName="ORIGINATOR" concept="The identifier of the originator of the message." identifier="A" name="Originator"
                                        definition="ANY COMBINATION OF CHARACTERS WHICH UNIQUELY IDENTIFY THE ORIGINATOR OF A MESSAGE." version="B.1.01.00"/>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                        <xsd:element ref="field:MessageSerialNumber" minOccurs="0" maxOccurs="1">
                            <xsd:annotation>
                                <xsd:documentation>The serial number assigned to a specific message. The originating command may develop the message serial number by any method.</xsd:documentation>
                                <xsd:appinfo>
                                    <Field positionName="MESSAGE SERIAL NUMBER"
                                        concept="The serial number assigned to a specific message. The originating command may develop the message serial number by any method." identifier="A"
                                        name="SerialNumber" definition="A UNIQUE IDENTIFIER SEQUENTIALLY ASSIGNED BY AN ORIGINATOR." version="B.1.01.00"/>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                        <xsd:element ref="set:ReferenceTimeOfPublication" minOccurs="1" maxOccurs="1">
                            <xsd:annotation>
                                <xsd:documentation>The reference time of publication using either the ISO 8601 standardized date-time or the abbreviated month name.</xsd:documentation>
                                <xsd:appinfo>
                                    <Field positionName="REFERENCE TIME OF PUBLICATION"
                                        concept="The reference time of publication using either the ISO 8601 standardized date-time or the abbreviated month name."/>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                        <xsd:element ref="field:Qualifier" minOccurs="0" maxOccurs="1">
                            <xsd:annotation>
                                <xsd:documentation>A qualifier which caveats a message status.</xsd:documentation>
                                <xsd:appinfo>
                                    <Field positionName="QUALIFIER" concept="A qualifier which caveats a message status." identifier="A" name="Qualifier"
                                        definition="A QUALIFIER WHICH CAVEATS A MESSAGE STATUS." version="B.1.01.00"/>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                        <xsd:element ref="field:SerialNumberOfQualifier" minOccurs="0" maxOccurs="1">
                            <xsd:annotation>
                                <xsd:documentation>A number assigned serially to identify the sequential version of a message qualifier for a basic message.</xsd:documentation>
                                <xsd:appinfo>
                                    <Field positionName="SERIAL NUMBER OF QUALIFIER" concept="A number assigned serially to identify the sequential version of a message qualifier for a basic message."
                                        identifier="A" name="Number" definition="AN IDENTIFIER OF AN ENTITY, COMMONLY CONSIDERED TO BE OR REFERRED TO AS A 'NUMBER.'" version="B.1.01.01"/>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                        <xsd:element ref="field:MessageSecurityPolicy" minOccurs="1" maxOccurs="1">
                            <xsd:annotation>
                                <xsd:documentation>The security policy that applies to the information contained in a message text format.</xsd:documentation>
                                <xsd:appinfo>
                                    <Field positionName="MESSAGE SECURITY POLICY" concept="The security policy that applies to the information contained in a message text format." identifier="A"
                                        name="SecurityMarkingsSchemaAttributes" definition="THE MARKINGS USED IN AN XML SCHEMA TO DOCUMENT SECURITY MARKINGS ATTRIBUTES." version="B.1.01.00"/>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                        <xsd:element ref="set:MessageSecurityClassification" minOccurs="1" maxOccurs="1">
                            <xsd:annotation>
                                <xsd:documentation>The security classification of the message.</xsd:documentation>
                                <xsd:appinfo>
                                    <Field positionName="MESSAGE SECURITY CLASSIFICATION" concept="The security classification of the message."/>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                        <xsd:element ref="field:MessageSecurityCategory" minOccurs="0" maxOccurs="1">
                            <xsd:annotation>
                                <xsd:documentation>The security category that applies to the information contained in a message text format.</xsd:documentation>
                                <xsd:appinfo>
                                    <Field positionName="MESSAGE SECURITY CATEGORY" concept="The security category that applies to the information contained in a message text format." identifier="A"
                                        name="SecurityMarkingsSchemaAttributes" definition="THE MARKINGS USED IN AN XML SCHEMA TO DOCUMENT SECURITY MARKINGS ATTRIBUTES." version="B.1.01.00"/>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                    </xsd:sequence>
                </xsd:extension>
            </xsd:complexContent>
        </xsd:complexType>
        <xsd:element name="{concat($msgnode,'MessageIdentifier')}" type="field:MessageTextFormatIdentifierType" fixed="MSGID">
            <xsd:annotation>
                <xsd:documentation>
                    <xsl:value-of select="concat($appinfo/*/*:Msg/@name, ' MESSAGE IDENTIFIER')"/>
                </xsd:documentation>
            </xsd:annotation>
        </xsd:element>
        <!--<xsd:element name="{concat($msgnode,'MessageIdentifierSet')}" type="{concat($msgnode,'MessageIdentifierSetType')}">
            <xsd:annotation>
                <xsd:documentation>
                    <xsl:value-of select="concat($appinfo/*:Msg/@name, ' MESSAGE IDENTIFIER SET')"/>
                </xsd:documentation>
            </xsd:annotation>
        </xsd:element>
        <xsd:element name="{concat($msgnode,'MessageIdentifier')}" type="field:MessageTextFormatIdentifierType" fixed="MSGID">
            <xsd:annotation>
                <xsd:documentation>
                    <xsl:value-of select="concat($appinfo/*:Msg/@name, ' MESSAGE IDENTIFIER')"/>
                </xsd:documentation>
            </xsd:annotation>
        </xsd:element>-->
    </xsl:template>

    <xsl:template name="MsgStdandVersion">

        <xsd:element name="MessageTextFormatStandard" type="field:StandardOfMessageTextFormatType" fixed="MIL-STD-6040(SERIES)">
            <xsd:annotation>
                <xsd:documentation>The military standard that contains the message format rules.</xsd:documentation>
            </xsd:annotation>
        </xsd:element>
        <xsd:element name="MessageTextFormatVersion" type="field:VersionOfMessageTextFormatType" fixed="B.1.01.12">
            <xsd:annotation>
                <xsd:documentation>The version of the message text format. The message version consists of four parts: Part 1 is the edition letter of MIL-STD-6040(SERIES), e.g., A, B, C through Z,
                    Part 2 is the change number of the edition (0-5), Part 3 is the major change for the message, e.g., 01-99, and Part 4 is the minor change for the message, e.g.,
                    00-99.</xsd:documentation>
            </xsd:annotation>
        </xsd:element>
    </xsl:template>

    <!--*****************************************************-->
    <xsl:template name="CamelCase">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text, '-')">
                <xsl:call-template name="CamelCaseWord">
                    <xsl:with-param name="text" select="substring-before($text, '-')"/>
                </xsl:call-template>
                <xsl:text>-</xsl:text>
                <xsl:call-template name="CamelCase">
                    <xsl:with-param name="text" select="substring-after($text, '-')"/>
                </xsl:call-template>
            </xsl:when>
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
                <xsd:restriction base="field:FieldEnumeratedBaseType">
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
</xsl:stylesheet>
