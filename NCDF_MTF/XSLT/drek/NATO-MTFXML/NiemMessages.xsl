<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2017 JD NEUSHUL
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
    xmlns:ism="urn:us:gov:ic:ism:v2" xmlns:appinfo="http://release.niem.gov/niem/appinfo/3.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
    exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="USMTF_Utility.xsl"/>

    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="baseline_msgs_xsd" select="document('../../XSD/Baseline_Schema/messages.xsd')/xsd:schema/*"/>

    <xsl:variable name="niem_sets_map" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Setmaps.xml')/*"/>
    <xsl:variable name="niem_segments_map" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Segmentmaps.xml')/*"/>

    <xsl:variable name="message_changes" select="document('../../XSD/Refactor_Changes/MessageChanges.xml')/*"/>
    <xsl:variable name="substGrp_Changes" select="document('../../XSD/Refactor_Changes/SubstitutionGroupChanges.xml')/SubstitionGroups"/>
    <!--Outputs-->
    <xsl:variable name="messagemapsoutput" select="'../../XSD/NIEM_MTF/NIEM_MTF_Messagemaps.xml'"/>
    <xsl:variable name="messagesxsdoutputdoc" select="'../../XSD/NIEM_MTF/NIEM_MTF_Messages.xsd'"/>
    <xsl:variable name="choiceanalysisoutputdoc" select="'../../XSD/Analysis/MessageChoices.xml'"/>

    <!-- MESSAGE XSD MAP-->
    <!-- _______________________________________________________ -->
    <xsl:variable name="messagemaps">
        <xsl:apply-templates select="$baseline_msgs_xsd" mode="messageglobal"/>
    </xsl:variable>
    <xsl:template match="xsd:element" mode="messageglobal">
        <xsl:variable name="annot">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*:Segment" copy-namespaces="no"/>
                <xsl:copy-of select="*:Set" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="changename" select="$message_changes/Message[@mtfname = $mtfname]"/>
        <xsl:variable name="niemelementname">
            <xsl:choose>
                <xsl:when test="$changename/@niemelementname">
                    <xsl:value-of select="$changename/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$changename/@niemelementname">
                    <xsl:value-of select="$changename/@niemelementname"/>
                </xsl:when>
                <xsl:when test="ends-with($n,'Message')">
                    <xsl:value-of select="$n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($n,'Message')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemcomplextype">
            <xsl:value-of select="concat($niemelementname, 'Type')"/>
        </xsl:variable>
        <xsl:variable name="changedoc" select="$message_changes/Message[@mtfname = $mtfname][@niemcomplextype = $niemcomplextype]"/>
        <xsl:variable name="mtfdoc">
            <xsl:choose>
                <xsl:when test="xsd:annotation/xsd:documentation">
                    <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($annot/*/xsd:documentation)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfid">
            <xsl:value-of select="xsd:complexType/xsd:attribute[@name = 'mtfid'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="niemtypedoc">
            <xsl:choose>
                <xsl:when test="$changedoc/@niemtypedoc">
                    <xsl:value-of select="concat('A data type for the', $changedoc/@niemtypedoc, 'The')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('A data type for the', substring-after($mtfdoc, 'The'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementdoc">
            <xsl:choose>
                <xsl:when test="$changedoc/@niemelementdoc">
                    <xsl:value-of select="$changedoc/@niemelementdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($niemtypedoc, 'A data type for', 'A data item for')"/>
                    <!--<xsl:value-of select="normalize-space($niemtypedoc)"/>-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Message mtfname="{@name}" mtfid="{$mtfid}" niemcomplextype="{$niemcomplextype}" niemelementname="{$niemelementname}" niemelementdoc="{$niemelementdoc}" mtfdoc="{$mtfdoc}"
            niemtypedoc="{$niemtypedoc}">
            <appinfo>
                <xsl:for-each select="$appinfo/*">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </appinfo>
            <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]"/>
        </Message>
    </xsl:template>
    <xsl:template match="xsd:element">
        <xsl:param name="sbstgrp"/>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="mtfroot">
            <xsl:choose>
                <xsl:when test="$message_changes/Element[@mtfname = $mtfname]">
                    <xsl:value-of select="$mtfname"/>
                </xsl:when>
                <xsl:when test="starts-with(@name, '_')">
                    <xsl:value-of select="substring-after(@name, '_')"/>
                </xsl:when>
                <xsl:when test="contains(@name, '_')">
                    <xsl:value-of select="substring-before(@name, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="annot">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="mtftype">
            <xsl:value-of select="xsd:complexType/*/xsd:extension/@base"/>
        </xsl:variable>
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="fromtype"/>
        </xsl:variable>
        <xsl:variable name="niemmatch">
            <xsl:choose>
                <xsl:when test="starts-with($mtftype, 's:')">
                    <xsl:copy-of select="$niem_sets_map/*[@mtfname = substring-after($mtftype, 's:')]"/>
                </xsl:when>
                <xsl:when test="$niem_segments_map/Segment[@mtfname = $mtfname]">
                    <xsl:copy-of select="$niem_segments_map/Segment[@mtfname = $mtfname][1]"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelement">
            <xsl:choose>
                <xsl:when test="string-length($sbstgrp) &gt; 0">
                    <xsl:variable name="niemel" select="$niemmatch/*/@niemelementname"/>
                    <xsl:variable name="subgrp">
                        <xsl:value-of select="substring-before($sbstgrp, 'Choice')"/>
                    </xsl:variable>
                    <xsl:value-of select="concat($subgrp, $niemel)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@name" mode="txt"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="UseDesc">
            <xsl:value-of select="translate(upper-case($appinfo/*/@usage), '.', '')"/>
        </xsl:variable>
        <xsl:variable name="TextIndicator">
            <xsl:if test="contains($UseDesc, 'MUST EQUAL')">
                <xsl:value-of select="normalize-space(substring-after($UseDesc, 'MUST EQUAL'))"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="niemname">
            <xsl:choose>
                <xsl:when test="starts-with($mtfname, 'GeneralText')">
                    <xsl:call-template name="GenTextName">
                        <xsl:with-param name="textind" select="$TextIndicator"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="starts-with($mtfname, 'HeadingInformation')">
                    <xsl:call-template name="HeadingInformation">
                        <xsl:with-param name="textind" select="$TextIndicator"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="contains($niemelement, '_')">
                    <xsl:value-of select="substring-before($niemelement, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($niemelement, 'Indicator', 'Code')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="fixedval">
            <xsl:choose>
                <xsl:when test="starts-with($mtfname, 'GeneralText')">
                    <xsl:value-of select="upper-case(substring-before(niemelementname, 'GenText'))"/>
                </xsl:when>
                <xsl:when test="starts-with($mtfname, 'HeadingSet')">
                    <xsl:value-of select="upper-case(substring-before(niemelementname, 'GenText'))"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ffirnfud">
            <xsl:value-of select="xsd:complexType/*//xsd:attribute[@name = 'ffirnFudn']/@fixed"/>
        </xsl:variable>
        <xsl:variable name="setseq">
            <xsl:value-of select="xsd:complexType/xsd:complexContent/xsd:extension/xsd:attribute[@name = 'setSeq'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="mtfdoc">
            <xsl:choose>
                <xsl:when test="xsd:annotation/xsd:documentation">
                    <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($annot/xsd:documentation)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="messagename" select="ancestor::xsd:element[parent::xsd:schema][1]/@name"/>
        <xsl:variable name="docchange" select="$message_changes/Element[@mtfname = $mtfroot][@niemname = $niemname]"/>
        <xsl:variable name="contxtchange" select="$message_changes/Element[@mtfname = $mtfroot][@messagename = $messagename]"/>
        <xsl:variable name="niemelementname">
            <xsl:choose>
                <xsl:when test="$docchange/@niemelementname">
                    <xsl:value-of select="$docchange/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$contxtchange/@niemelementname">
                    <xsl:value-of select="$contxtchange/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$appinfo/mtfappinfo:Segment">
                    <xsl:value-of select="concat('sg:', $niemname)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$niemname"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementdoc">
            <xsl:choose>
                <xsl:when test="$docchange/@niemelementdoc">
                    <xsl:value-of select="$docchange/@niemelementdoc"/>
                </xsl:when>
                <xsl:when test="$contxtchange/@niemelementdoc">
                    <xsl:value-of select="$contxtchange/@niemelementdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('A data item for the', substring-after($mtfdoc, 'The'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemtypedoc">
            <xsl:choose>
                <xsl:when test="$docchange/@niemtypedoc">
                    <xsl:value-of select="$docchange/@niemtypedoc"/>
                </xsl:when>
                <xsl:when test="$niemmatch/*/@niemtypedoc">
                    <xsl:value-of select="$niemmatch/*/@niemtypedoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfdoc"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Element mtfname="{@name}" messagename="{$messagename}" niemelementname="{$niemelementname}" mtfdoc="{$mtfdoc}">
            <xsl:if test="string-length($mtftype) &gt; 0">
                <xsl:attribute name="mtftype">
                    <xsl:value-of select="$mtftype"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($niemelementdoc) &gt; 0">
                <xsl:attribute name="niemelementdoc">
                    <xsl:value-of select="$niemelementdoc"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($niemmatch/*/@niemcomplextype) &gt; 0">
                <xsl:attribute name="niemtype">
                    <xsl:value-of select="$niemmatch/*/@niemcomplextype"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($niemtypedoc) &gt; 0">
                <xsl:attribute name="niemtypedoc">
                    <xsl:value-of select="$niemtypedoc"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($appinfo/*/@usage) &gt; 0">
                <xsl:attribute name="usage">
                    <xsl:value-of select="$appinfo/*/@usage"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($TextIndicator) &gt; 0">
                <xsl:attribute name="textindicator">
                    <xsl:value-of select="$TextIndicator"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($setseq) &gt; 0">
                <xsl:attribute name="setseq">
                    <xsl:value-of select="$setseq"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="@minOccurs"/>
            <xsl:copy-of select="@maxOccurs"/>
            <appinfo>
                <xsl:for-each select="$appinfo/*">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </appinfo>
            <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]"/>
        </Element>
    </xsl:template>
    <xsl:template match="xsd:sequence">
        <Sequence>
            <xsl:apply-templates select="xsd:*"/>
        </Sequence>
    </xsl:template>
    <xsl:template match="xsd:complexType">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="xsd:simpleContent">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="xsd:complexContent">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="xsd:extension">
        <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]"/>
    </xsl:template>
    <xsl:template match="xsd:attribute"/>
    <!--  Choice / Substitution Groups Map -->
    <xsl:template match="xsd:choice">
        <xsl:variable name="msgname">
            <xsl:value-of select="ancestor::xsd:element[parent::xsd:schema][1]/@name"/>
        </xsl:variable>
        <xsl:variable name="subname">
            <xsl:choose>
                <xsl:when test="xsd:element[@name = 'ExerciseIdentification']">
                    <xsl:text>ExerciseOperation</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="ancestor::xsd:element[@name][1]/@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="subgrpname">
            <xsl:choose>
                <xsl:when test="starts-with($subname, '_')">
                    <xsl:value-of select="substring-after($subname, '_')"/>
                </xsl:when>
                <xsl:when test="contains($subname, '_')">
                    <xsl:value-of select="substring-before($subname, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$subname"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="msgchoicename">
            <xsl:value-of select="concat($subgrpname, 'Choice')"/>
        </xsl:variable>
        <xsl:variable name="substmatch">
            <xsl:copy-of select="$substGrp_Changes/Choice[@choicename = $msgchoicename][@msgname = $msgname][1]"/>
        </xsl:variable>
        <xsl:variable name="choicename">
            <xsl:choose>
                <xsl:when test="$substmatch/*/@niemname">
                    <xsl:value-of select="$substmatch/*/@niemname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$msgchoicename"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="substgrpdoc">
            <xsl:value-of select="concat('A data concept for a choice of', substring-after($substmatch/*/@substgrpdoc, 'A choice of'))"/>
        </xsl:variable>
        <xsl:variable name="seq" select="xsd:element[1]//xsd:extension[1]/xsd:attribute[@name = 'setSeq']/@fixed"/>
        <Element choicename="{$choicename}" msgname="{$msgname}" substgrpname="{$choicename}" substgrpdoc="{$substgrpdoc}" seq="{$seq}">
            <xsl:copy-of select="@minOccurs"/>
            <xsl:copy-of select="@maxOccurs"/>
            <Choice name="{$choicename}">
                <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]">
                    <xsl:with-param name="sbstgrp">
                        <xsl:value-of select="$choicename"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </Choice>
        </Element>
    </xsl:template>
    <xsl:template name="GenTextName">
        <xsl:param name="textind"/>
        <xsl:variable name="per">&#46;</xsl:variable>
        <xsl:variable name="qot">&#34;</xsl:variable>
        <xsl:variable name="apos">&#39;</xsl:variable>
        <xsl:variable name="lparen">&#40;</xsl:variable>
        <xsl:variable name="rparen">&#41;</xsl:variable>
        <xsl:variable name="CCase">
            <xsl:call-template name="CamelCase">
                <xsl:with-param name="text">
                    <xsl:value-of select="replace($textind, $apos, '')"/>
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
        <xsl:choose>
            <!--THIS IS FROM AN ACTUAL INCONSISTENCY IN THE MIL STD-->
            <xsl:when test="$n = 'SecurityAndDefenseRemarks'">
                <xsl:text>SecurityAndDefensesRemarksGenText</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($n, 'GenText')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="HeadingInformation">
        <xsl:param name="textind"/>
        <xsl:variable name="per">&#46;</xsl:variable>
        <xsl:variable name="qot">&#34;</xsl:variable>
        <xsl:variable name="apos">&#39;</xsl:variable>
        <xsl:variable name="lparen">&#40;</xsl:variable>
        <xsl:variable name="rparen">&#41;</xsl:variable>
        <xsl:variable name="CCase">
            <xsl:call-template name="CamelCase">
                <xsl:with-param name="text">
                    <xsl:value-of select="replace($textind, $apos, '')"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="n">
            <xsl:value-of select="translate(replace(replace($CCase, '(TAS)', ''), '(mpa)', ''), ' ,/”()', '')"/>
        </xsl:variable>
        <xsl:variable name="fixed">
            <xsl:value-of select="translate(replace($textind, $apos, ''), '”', '')"/>
        </xsl:variable>
        <xsl:value-of select="concat($n, 'HeadingSet')"/>
    </xsl:template>
    <!-- _______________________________________________________ -->

    <!--XSD GENERATION-->
    <!-- _______________________________________________________ -->

    <xsl:variable name="messagelements">
        <xsl:for-each select="$messagemaps//Sequence/Element">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="segSeq">
                <xsl:value-of select="ancestor::Segment/@segseq"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="appinfo/mtfappinfo:Segment"/>
                <xsl:when test="@niemelementname">
                    <xsd:element name="{@niemelementname}">
                        <xsl:attribute name="type">
                            <xsl:value-of select="concat('s:', @niemtype)"/>
                        </xsl:attribute>
                        <xsl:attribute name="nillable">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:choose>
                                    <xsl:when test="@niemtypedoc">
                                        <xsl:value-of select="@niemtypedoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsd:documentation>
                            <xsl:for-each select="appinfo/*">
                                <xsd:appinfo>
                                    <xsl:copy>
                                        <xsl:copy-of select="@positionName"/>
                                        <!--<xsl:copy-of select="@concept"/>-->
                                        <!--<xsl:copy-of select="@usage"/>-->
                                    </xsl:copy>
                                </xsd:appinfo>
                            </xsl:for-each>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$messagemaps//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xsd:element name="{@substgrpname}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@substgrpdoc"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsl:for-each select="Choice/Element">
                <xsl:variable name="prefix" select="substring-before(@mtftype, ':')"/>
                <xsl:variable name="niemelementdoc">
                    <xsl:choose>
                        <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                            <xsl:value-of select="@niemelementdoc"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@mtfdoc"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsd:element name="{@niemelementname}" type="{concat($prefix,':',@niemtype)}" substitutionGroup="{$substgrp}" nillable="true">
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="@niemelementdoc"/>
                        </xsd:documentation>
                    </xsd:annotation>
                </xsd:element>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="messagesxsd">
        <xsl:for-each select="$messagemaps/Message">
            <xsl:sort select="@niemcomplextype"/>
            <xsd:complexType name="{@niemcomplextype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                    <!--<xsl:for-each select="appinfo/*">
                        <xsd:appinfo>
                            <xsl:copy-of select="."/>
                        </xsd:appinfo>
                    </xsl:for-each>-->
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="structures:ObjectType">
                        <xsd:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="refname">
                                    <xsl:choose>
                                        <xsl:when test="@substgrpname">
                                            <xsl:value-of select="@substgrpname"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@niemelementname"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsd:element ref="{$refname}">
                                    <xsl:copy-of select="@minOccurs"/>
                                    <xsl:copy-of select="@maxOccurs"/>
                                    <xsd:annotation>
                                        <xsd:documentation>
                                            <xsl:choose>
                                                <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                                    <xsl:value-of select="replace(@mtfdoc, 'A data type', 'A data item')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@niemelementdoc"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsd:documentation>
                                        <xsl:for-each select="appinfo/*">
                                            <xsd:appinfo>
                                                <xsl:copy>
                                                    <xsl:copy-of select="@positionName"/>
                                                    <xsl:copy-of select="@concept"/>
                                                    <xsl:copy-of select="@usage"/>
                                                </xsl:copy>
                                            </xsd:appinfo>
                                        </xsl:for-each>
                                    </xsd:annotation>
                                </xsd:element>
                            </xsl:for-each>
                            <xsd:element ref="{concat(substring(@niemcomplextype,0,string-length(@niemcomplextype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{concat(substring(@niemcomplextype,0,string-length(@niemcomplextype)-3),'AugmentationPoint')}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @niemcomplextype)"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="{@niemelementname}" type="{@niemcomplextype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemelementdoc"/>
                    </xsd:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xsd:appinfo>
                            <xsl:copy>
                                <xsl:copy-of select="@name"/>
                                <xsl:copy-of select="@positionName"/>
                                <!--<xsl:copy-of select="@usage"/>
                                <xsl:copy-of select="@concept"/>-->
                            </xsl:copy>
                        </xsd:appinfo>
                    </xsl:for-each>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <!--Global Set Elements-->
        <xsl:copy-of select="$messagelements"/>
        <!--Set Elements with Choice to Substitution Groups-->
        <xsl:for-each select="$messagemaps//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xsd:element name="{@substgrpname}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="normalize-space(@substgrpdoc)"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsl:for-each select="Choice/Element">
                <xsl:variable name="prefix" select="substring-before(@mtftype, ':')"/>
                <xsd:element name="{@niemelementname}" type="{concat($prefix,':',@niemtype)}" substitutionGroup="{$substgrp}" nillable="true">
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="normalize-space(@niemelementdoc)"/>
                        </xsd:documentation>
                    </xsd:annotation>
                </xsd:element>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>

    <!--    OUTPUT RESULT-->
    <!-- _______________________________________________________ -->

    <xsl:template name="main">
        <xsl:result-document href="{$messagesxsdoutputdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:niem:messages" xmlns:ism="urn:us:gov:ic:ism:v2" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/" xmlns:structures="http://release.niem.gov/niem/structures/3.0/"
                xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/" xmlns:appinfo="http://release.niem.gov/niem/appinfo/3.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:s="urn:mtf:mil:6040b:niem:sets" xmlns:sg="urn:mtf:mil:6040b:niem:segments" targetNamespace="urn:mtf:mil:6040b:niem:messages"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/3.0/" schemaLocation="../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/3.0/" schemaLocation="../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NIEM/mtfappinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:niem:sets" schemaLocation="NIEM_MTF_Sets.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:niem:segments" schemaLocation="NIEM_MTF_Segments.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Message structures for MTF Messages</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:for-each select="$messagesxsd/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:variable name="pre1" select="preceding-sibling::xsd:complexType[@name = $n][1]"/>
                    <xsl:variable name="pre2" select="preceding-sibling::xsd:complexType[@name = $n][2]"/>
                    <xsl:choose>
                        <xsl:when test="$n = $pre1/@name"/>
                        <xsl:when test="deep-equal(., $pre2)"/>
                        <xsl:when test="deep-equal(., $pre2)"/>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:for-each select="$messagesxsd/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:sort select="@type"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:variable name="t" select="@type"/>
                    <xsl:variable name="pre1" select="preceding-sibling::xsd:element[@name = $n][1]"/>
                    <xsl:variable name="pre2" select="preceding-sibling::xsd:element[@name = $n][2]"/>
                    <xsl:choose>
                        <xsl:when test="deep-equal(., $pre1)"/>
                        <xsl:when test="deep-equal(., $pre2)"/>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$messagemapsoutput}">
            <Messages>
                <xsl:for-each select="$messagemaps/*">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </Messages>
        </xsl:result-document>
        <xsl:result-document href="{$choiceanalysisoutputdoc}">
            <Choices>
                <xsl:for-each select="$messagemaps/*//Element[Choice]">
                    <xsl:sort select="@choicename"/>
                    <Choice>
                        <xsl:copy-of select="@choicename"/>
                        <xsl:copy-of select="@substgrpname"/>
                        <xsl:attribute name="segmentname">
                            <xsl:value-of select="ancestor::Segment[1]/@mtfname"/>
                        </xsl:attribute>
                        <xsl:copy-of select="@substgrpdoc"/>
                        <xsl:for-each select="Choice/Element">
                            <xsl:sort select="@mtftype"/>
                            <xsl:copy>
                                <xsl:copy-of select="@mtftype"/>
                                <xsl:copy-of select="@mtfname"/>
                                <xsl:copy-of select="@mtfdoc"/>
                                <xsl:copy-of select="@niemtype"/>
                                <xsl:copy-of select="@niemelementname"/>
                            </xsl:copy>
                        </xsl:for-each>
                    </Choice>
                </xsl:for-each>
            </Choices>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
