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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:term="http://release.ncdf.gov/ncdf/localTerminology/3.0/"
    xmlns:ism="urn:us:gov:ic:ism" xmlns:appinfo="http://release.ncdf.gov/ncdf/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
    exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="USMTF_Utility.xsl"/>

    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="baseline_msgs_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/messages.xsd')/xsd:schema/*"/>
    <xsl:variable name="baseline_segments_xsd" select="$baseline_msgs_xsd/*//xsd:element[xsd:annotation/xsd:appinfo/*:SegmentStructureName]"/>
    <xsl:variable name="srcdir" select="'../../XSD/NCDF_MTF_1_NS/'"/>
    <xsl:variable name="ncdf_fields_map" select="document(concat($srcdir, 'NCDF_MTF_Fieldmaps.xml'))/*"/>
    <xsl:variable name="ncdf_composites_map" select="document(concat($srcdir, 'NCDF_MTF_Compositemaps.xml'))/*"/>
    <xsl:variable name="ncdf_sets_map" select="document(concat($srcdir, 'NCDF_MTF_Setmaps.xml'))/*"/>
    <xsl:variable name="ncdf_segments_map" select="document(concat($srcdir, 'NCDF_MTF_Segmentmaps.xml'))/*"/>
    <xsl:variable name="segment_changes" select="document(concat($srcdir, 'Refactor_Changes/SegmentChanges.xml'))/*"/>
    <xsl:variable name="substGrp_Changes" select="document(concat($srcdir, 'Refactor_Changes/SubstitutionGroupChanges.xml'))/*"/>
    <!--Outputs-->
    <xsl:variable name="segmentmapsoutput" select="concat($srcdir, 'NCDF_MTF_Segmentmaps.xml')"/>
    <xsl:variable name="segmentsxsdoutputdoc" select="concat($srcdir, 'NCDF_MTF_Segments.xsd')"/>
    <xsl:variable name="apos">
        <xsl:text>'</xsl:text>
    </xsl:variable>
    <!-- XSD MAP-->
    <!-- _______________________________________________________ -->
    <xsl:variable name="segmentmaps">
        <xsl:apply-templates select="$baseline_segments_xsd" mode="segmentglobal"/>
    </xsl:variable>
    <xsl:template match="xsd:element" mode="segmentglobal">
        <xsl:variable name="annot">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="messagename" select="ancestor::xsd:element[parent::xsd:schema]/@name"/>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="changename" select="$segment_changes/Segment[@mtfname = $mtfname][@messagename = $messagename]"/>
        <xsl:variable name="ncdfelementnamevar">
            <xsl:choose>
                <xsl:when test="$changename/@ncdfelementname">
                    <xsl:value-of select="$changename/@ncdfelementname"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Segment')">
                    <xsl:value-of select="$n"/>
                </xsl:when>
                <xsl:when test="contains($n, 'Segment_')">
                    <xsl:value-of select="concat(substring-before($n, 'Segment_'), 'Segment')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($n, 'Segment')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfcomplextype">
            <xsl:value-of select="concat($ncdfelementnamevar, 'Type')"/>
        </xsl:variable>
        <xsl:variable name="changedoc" select="$segment_changes/Segment[@mtfname = $mtfname][@ncdfcomplextype = $ncdfcomplextype]"/>
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
        <xsl:variable name="segseq">
            <xsl:value-of select="xsd:complexType/xsd:attribute[@name = 'segSeq'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="ncdftypedocvar">
            <xsl:choose>
                <xsl:when test="$changedoc/@ncdftypedoc">
                    <xsl:value-of select="concat('A data type for the', $changedoc/@ncdftypedoc, 'The')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('A data type for the', substring-after($mtfdoc, 'The'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfelementdocvar">
            <xsl:choose>
                <xsl:when test="$changedoc/@ncdfelementdoc">
                    <xsl:value-of select="$changedoc/@ncdfelementdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($ncdftypedocvar, 'A data type for', 'A data item for')"/>
                    <!--<xsl:value-of select="normalize-space($ncdftypedoc)"/>-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*:Segment" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <Segment mtfname="{@name}" messagename="{$messagename}" ncdfcomplextype="{$ncdfcomplextype}" ncdfelementname="{$ncdfelementnamevar}" ncdfelementdoc="{$ncdfelementdocvar}" mtfdoc="{$mtfdoc}"
            ncdftypedoc="{$ncdftypedocvar}">
            <xsl:if test="string-length($segseq) &gt; 0">
                <xsl:attribute name="segseq">
                    <xsl:value-of select="$segseq"/>
                </xsl:attribute>
            </xsl:if>
            <appinfo>
                <xsl:for-each select="$appinfovar/*">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </appinfo>
            <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]"/>
        </Segment>
    </xsl:template>
    <xsl:template match="xsd:element">
        <xsl:param name="sbstgrp"/>
        <xsl:variable name="mtfnamevar" select="@name"/>
        <xsl:variable name="mtfroot">
            <xsl:choose>
                <xsl:when test="$segment_changes/Element[@mtfname = $mtfnamevar]">
                    <xsl:value-of select="$mtfnamevar"/>
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
        <xsl:variable name="appinfovar">
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
        <xsl:variable name="ncdfmatch">
            <xsl:choose>
                <xsl:when test="starts-with($mtftype, 'f:')">
                    <xsl:copy-of select="$ncdf_fields_map/*[@mtfname = substring-after($mtftype, 'f:')]"/>
                </xsl:when>
                <xsl:when test="starts-with($mtftype, 'c:')">
                    <xsl:copy-of select="$ncdf_composites_map/*[@mtfname = substring-after($mtftype, 'c:')]"/>
                </xsl:when>
                <xsl:when test="starts-with($mtftype, 's:')">
                    <xsl:copy-of select="$ncdf_sets_map/*[@mtfname = substring-after($mtftype, 's:')]"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdftypevar">
            <xsl:choose>
                <xsl:when test="string-length($ncdfmatch/*/@ncdfcomplextype) &gt; 0">
                    <xsl:value-of select="$ncdfmatch/*/@ncdfcomplextype"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfelement">
            <xsl:choose>
                <xsl:when test="string-length($sbstgrp) &gt; 0">
                    <xsl:variable name="ncdfel" select="$ncdfmatch/*/@ncdfelementname"/>
                    <xsl:variable name="subgrp">
                        <xsl:value-of select="substring-before($sbstgrp, 'Choice')"/>
                    </xsl:variable>
                    <!-- <xsl:value-of select="concat($subgrp, $ncdfel)"/>-->
                    <xsl:value-of select="$ncdfel"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfnamevar"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="UseDesc">
            <xsl:value-of select="translate(upper-case($appinfovar/*/@usage), '.', '')"/>
        </xsl:variable>
        <xsl:variable name="TextIndicator">
            <xsl:if test="contains($UseDesc, 'MUST EQUAL')">
                <xsl:value-of select="replace(normalize-space(substring-after($UseDesc, 'MUST EQUAL')),$apos,'')"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="ncdfnamevar">
            <xsl:choose>
                <xsl:when test="starts-with($mtfnamevar, 'GeneralText')">
                    <xsl:call-template name="GenTextName">
                        <xsl:with-param name="textind" select="$TextIndicator"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="starts-with($mtfnamevar, 'HeadingInformation')">
                    <xsl:call-template name="HeadingInformation">
                        <xsl:with-param name="textind" select="$TextIndicator"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="contains($ncdfelement, '_')">
                    <xsl:value-of select="substring-before($ncdfelement, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$ncdfelement"/>
                    <!--<xsl:value-of select="replace($ncdfelement, 'Indicator', 'Code')"/>-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="fixedval">
            <xsl:choose>
                <xsl:when test="starts-with($mtfnamevar, 'GeneralText')">
                    <xsl:value-of select="upper-case(substring-before(@ncdfelementname, 'GenText'))"/>
                </xsl:when>
                <xsl:when test="starts-with($mtfnamevar, 'HeadingSet')">
                    <xsl:value-of select="upper-case(substring-before(@ncdfelementname, 'GenText'))"/>
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
        <xsl:variable name="segmentname" select="ancestor::xsd:element[ends-with(@name, 'Segment')][1]/@name"/>
        <xsl:variable name="docchange" select="$segment_changes/Element[@mtfname = $mtfroot][@ncdfname = '']"/>
        <xsl:variable name="contxtchange" select="$segment_changes/Element[@mtfname = $mtfroot][@segmentname = $segmentname]"/>
        <xsl:variable name="namechange" select="$segment_changes/Element[@mtfname = $mtfroot][@changename]"/>
        <xsl:variable name="ncdfelementnamevar">
            <xsl:choose>
                <xsl:when test="$substGrp_Changes/Element[@mtfname = $mtfroot][@substitutionGroup = $sbstgrp]/@ncdfname">
                    <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfroot][@substitutionGroup = $sbstgrp]/@ncdfname"/>
                </xsl:when>
                <xsl:when test="$docchange/@ncdfelementname">
                    <xsl:value-of select="$docchange/@ncdfelementname"/>
                </xsl:when>
                <xsl:when test="$contxtchange/@ncdfelementname">
                    <xsl:value-of select="$contxtchange/@ncdfelementname"/>
                </xsl:when>
                <xsl:when test="$namechange/@changename">
                    <xsl:value-of select="$namechange/@changename"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$ncdfnamevar"/>
                </xsl:otherwise>

            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfelementdocvar">
            <xsl:choose>
                <xsl:when test="$docchange/@ncdfelementdoc">
                    <xsl:value-of select="$docchange/@ncdfelementdoc"/>
                </xsl:when>
                <xsl:when test="$contxtchange/@ncdfelementdoc">
                    <xsl:value-of select="$contxtchange/@ncdfelementdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('A data item for the', substring-after($mtfdoc, 'The'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdftypedocvar">
            <xsl:choose>
                <xsl:when test="$ncdfmatch/*/@ncdftypedoc">
                    <xsl:value-of select="
                            $ncdfmatch/*/@ncdftypedoc
                            "/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfdoc"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Element mtfname="{@name}" segmentname="{$segmentname}" ncdfelementname="{$ncdfelementnamevar}" mtfdoc="{$mtfdoc}">
            <xsl:if test="string-length($mtftype) &gt; 0">
                <xsl:attribute name="mtftype">
                    <xsl:value-of select="$mtftype"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($ncdfelementdocvar) &gt; 0">
                <xsl:attribute name="ncdfelementdoc">
                    <xsl:value-of select="$ncdfelementdocvar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($ncdftypevar) &gt; 0">
                <xsl:attribute name="ncdftype">
                    <xsl:value-of select="$ncdftypevar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($ncdftypedocvar) &gt; 0">
                <xsl:attribute name="ncdftypedoc">
                    <xsl:value-of select="$ncdftypedocvar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($sbstgrp) &gt; 0">
                <xsl:attribute name="substitutiongroup">
                    <xsl:value-of select="$sbstgrp"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($appinfovar/*/@usage) &gt; 0">
                <xsl:attribute name="usage">
                    <xsl:value-of select="$appinfovar/*/@usage"/>
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
                <xsl:for-each select="$appinfovar/*">
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
        <xsl:variable name="segname">
            <xsl:value-of select="ancestor::xsd:element[@name][1]/@name"/>
        </xsl:variable>
        <xsl:variable name="segmentnamevar">
            <xsl:choose>
                <xsl:when test="$segname = 'SpecialOptionDataAsrSegment'">
                    <xsl:choose>
                        <xsl:when test="xsd:element[@name = 'UnitDesignationData']">
                            <xsl:text>Designation</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>SupplyRate</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="starts-with($segname, '_')">
                    <xsl:value-of select="substring-after($segname, '_')"/>
                </xsl:when>
                <xsl:when test="contains($segname, '_')">
                    <xsl:value-of select="substring-before($segname, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$segname"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="segchoicename">
            <xsl:value-of select="concat($segmentnamevar, 'Choice')"/>
        </xsl:variable>
        <xsl:variable name="substmatch">
            <xsl:copy-of select="$substGrp_Changes/Choice[@choicename = $segchoicename][@segmentname = $segmentnamevar][1]"/>
        </xsl:variable>
        <xsl:variable name="choicenamevar">
            <xsl:choose>
                <xsl:when test="$substmatch/*/@ncdfname">
                    <xsl:value-of select="$substmatch/*/@ncdfname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$segchoicename"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="substgrpdocvar">
            <xsl:value-of select="concat('A data concept for a choice of', substring-after($substmatch/*/@substgrpdoc, 'A choice of'))"/>
        </xsl:variable>
        <xsl:variable name="seq" select="xsd:element[1]//xsd:extension[1]/xsd:attribute[@name = 'setSeq']/@fixed"/>
        <Element choicename="{$choicenamevar}" segmentname="{$segmentnamevar}" substgrpname="{$choicenamevar}" substgrpdoc="{$substgrpdocvar}" seq="{$seq}">
            <xsl:choose>
                <!--THIS MITIGATES AN ACTUAL INCONSISTENCY IN THE MIL STD-->
                <xsl:when test="$choicenamevar = 'Link16UnitSegmentChoice'">
                    <xsl:attribute name="minOccurs">
                        <xsl:text>0</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="MTFISSUEminOccurs">
                        <xsl:text>1</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <!-- _____________________________________-->
                <xsl:otherwise>
                    <xsl:copy-of select="@minOccurs"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="@maxOccurs"/>
            <Choice name="{$choicenamevar}">
                <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]">
                    <xsl:with-param name="sbstgrp">
                        <xsl:value-of select="$choicenamevar"/>
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
        <!--Name .. handle 2 special cases with parens-->
        <xsl:variable name="n">
            <xsl:value-of select="translate(replace(replace($CCase, '(TAS)', ''), '(mpa)', ''), ' ()', '')"/>
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

    <xsl:variable name="segmentelements">
        <xsl:for-each select="$segmentmaps//Sequence/Element">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:variable name="n" select="@ncdfelementname"/>
            <xsl:variable name="t" select="@ncdftype"/>
            <xsl:variable name="d" select="@ncdfelementdoc"/>
            <xsl:variable name="segSeq">
                <xsl:value-of select="ancestor::Segment/@segseq"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="appinfo/mtfappinfo:Segment"/>
                <xsl:when test="$ncdf_sets_map//*[@ncdfelementname = $n]"/>
                <xsl:when test="@ncdfelementname and @ncdftype">
                    <xsd:element name="{@ncdfelementname}">
                        <xsl:attribute name="type">
                            <xsl:value-of select="@ncdftype"/>
                        </xsl:attribute>
                        <xsl:attribute name="nillable">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:choose>
                                    <xsl:when test="@ncdftype = 'GeneralTextType'">
                                        <xsl:value-of select="@ncdfelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="@ncdftype = 'HeadingInformationType'">
                                        <xsl:value-of select="@ncdfelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="@ncdftypedoc">
                                        <xsl:value-of select="@ncdftypedoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@ncdfelementdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsd:documentation>
                            <xsl:choose>
                                <xsl:when test="appinfo/mtfappinfo:Segment">
                                    <xsd:appinfo>
                                        <xsl:copy-of select="appinfo/mtfappinfo:Segment"/>
                                    </xsd:appinfo>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="appinfo/*">
                                        <xsd:appinfo>
                                            <xsl:copy>
                                                <xsl:copy-of select="@positionName"/>
                                                <xsl:copy-of select="ancestor::Element/@textindicator"/>
                                                <xsl:copy-of select="@usage"/>
                                            </xsl:copy>
                                        </xsd:appinfo>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$segmentmaps//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xsd:element name="{@substgrpname}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@substgrpdoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <mtfappinfo:Choice>
                            <xsl:for-each select="Choice/Element">
                                <xsl:sort select="@ncdfelementname"/>
                                <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                            </xsl:for-each>
                        </mtfappinfo:Choice>
                    </xsd:appinfo>
                </xsd:annotation>
            </xsd:element>
            <xsl:for-each select="Choice/Element">
                <xsl:sort select="@ncdfelementname"/>
                <xsl:variable name="ncdfelementdoc">
                    <xsl:choose>
                        <xsl:when test="string-length(@ncdfelementdoc) &gt; 0">
                            <xsl:value-of select="@ncdfelementdoc"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@mtfdoc"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="n" select="@ncdfelementname"/>
                <xsl:if test="not($ncdf_sets_map//*[@ncdfelementname = $n])">
                    <xsd:element name="{@ncdfelementname}" type="{@ncdftype}" substitutionGroup="{$substgrp}" nillable="true">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="@ncdfelementdoc"/>
                            </xsd:documentation>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="segmentsxsd">
        <xsl:for-each select="$segmentmaps/Segment">
            <xsl:sort select="@ncdfcomplextype"/>
            <xsd:complexType name="{@ncdfcomplextype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@ncdftypedoc"/>
                    </xsd:documentation>
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="structures:ObjectType">
                        <xsd:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="n" select="@ncdfelementname"/>
                                <xsl:variable name="refname">
                                    <xsl:choose>
                                        <xsl:when test="@substgrpname">
                                            <xsl:value-of select="@substgrpname"/>
                                        </xsl:when>
                                        <xsl:when test="$segmentelements/*[@name = $n]">
                                            <xsl:value-of select="$n"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$n"/>
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
                                                    <xsl:value-of select="@ncdfelementdoc"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsd:documentation>
                                        <xsl:for-each select="appinfo/*">
                                            <xsd:appinfo>
                                                <xsl:copy>
                                                    <xsl:copy-of select="@positionName"/>
                                                    <xsl:copy-of select="ancestor::Element/@textindicator"/>
                                                    <xsl:copy-of select="@usage"/>
                                                </xsl:copy>
                                            </xsd:appinfo>
                                        </xsl:for-each>
                                        <xsl:if test="@substgrpname">
                                            <xsd:appinfo>
                                                <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                                    <xsl:for-each select="Choice/Element">
                                                        <xsl:sort select="@name"/>
                                                        <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                                    </xsl:for-each>
                                                </mtfappinfo:Choice>
                                            </xsd:appinfo>
                                        </xsl:if>
                                    </xsd:annotation>
                                </xsd:element>
                            </xsl:for-each>
                            <xsd:element ref="{concat(substring(@ncdfcomplextype,0,string-length(@ncdfcomplextype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{concat(substring(@ncdfcomplextype,0,string-length(@ncdfcomplextype)-3),'AugmentationPoint')}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @ncdfcomplextype)"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="{@ncdfelementname}" type="{@ncdfcomplextype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@ncdfelementdoc"/>
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
        <xsl:copy-of select="$segmentelements"/>
        <!--Set Elements with Choice to Substitution Groups-->
        <xsl:for-each select="$segmentmaps//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xsd:element name="{@substgrpname}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="normalize-space(@substgrpdoc)"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsl:for-each select="Choice/Element">
                <xsd:element name="{@ncdfelementname}" type="{@ncdftype}" substitutionGroup="{$substgrp}" nillable="true">
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="normalize-space(@ncdfelementdoc)"/>
                        </xsd:documentation>
                    </xsd:annotation>
                </xsd:element>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>

    <!--    OUTPUT RESULT-->
    <!-- _______________________________________________________ -->

    <xsl:template name="main">
        <xsl:result-document href="{$segmentsxsdoutputdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:ncdf:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.ncdf.gov/ncdf/conformanceTargets/3.0/"
                xmlns:structures="http://release.ncdf.gov/ncdf/structures/4.0/" xmlns:term="http://release.ncdf.gov/ncdf/localTerminology/3.0/"
                xmlns:appinfo="http://release.ncdf.gov/ncdf/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:ncdf:mtf" ct:conformanceTargets="http://reference.ncdf.gov/ncdf/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/structures/4.0/" schemaLocation="../NCDF/structures.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/localTerminology/3.0/" schemaLocation="../NCDF/localTerminology.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/appinfo/4.0/" schemaLocation="../NCDF/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NCDF/mtfappinfo.xsd"/>
                <xsd:include schemaLocation="NCDF_MTF_Sets.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Segment structures for MTF Messages</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:for-each select="$segmentsxsd/xsd:complexType">
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
                <xsl:for-each select="$segmentsxsd/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:sort select="@type"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::*[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$segmentmapsoutput}">
            <Segments>
                <xsl:for-each select="$segmentmaps/*">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </Segments>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="seg_nodes">
        <xsd:annotation>
            <xsd:documentation>
                <xsl:text>Segment structures for MTF Messages</xsl:text>
            </xsd:documentation>
        </xsd:annotation>
        <xsl:for-each select="$segmentsxsd/xsd:complexType">
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
        <xsl:for-each select="$segmentsxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:sort select="@type"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="count(preceding-sibling::*[@name = $n]) = 0">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
