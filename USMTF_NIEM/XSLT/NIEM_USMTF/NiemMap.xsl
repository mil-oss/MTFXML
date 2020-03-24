<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2019 JD NEUSHUL
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:inf="urn:mtf:mil:6040b:appinfo" version="2.0">

    <xsl:include href="USMTF_Utility.xsl"/>
    <xsl:include href="NiemStrings.xsl"/>
    <xsl:include href="NiemNumerics.xsl"/>
    <xsl:include href="NiemCodeLists.xsl"/>

    <xsl:variable name="fieldspath" select="'../../XSD/Baseline_Schema/Consolidated/fields.xsd'"/>
    <xsl:variable name="compositespath" select="'../../XSD/Baseline_Schema/Consolidated/composites.xsd'"/>
    <xsl:variable name="setspath" select="'../../XSD/Baseline_Schema/Consolidated/sets.xsd'"/>
    <xsl:variable name="messagespath" select="'../../XSD/Baseline_Schema/Consolidated/messages.xsd'"/>

    <xsl:variable name="fieldsxsdoutpath" select="'../../XSD/NIEM_MTF/niem-mtf-fields.xsd'"/>
    <xsl:variable name="compositesxsdoutpath" select="'../../XSD/NIEM_MTF/niem-mtf-composites.xsd'"/>
    <xsl:variable name="setsxsdoutpath" select="'../../XSD/NIEM_MTF/niem-mtf-sets.xsd'"/>
    <xsl:variable name="segmentsxsdoutpath" select="'../../XSD/NIEM_MTF/niem-mtf-segments.xsd'"/>
    <xsl:variable name="messagesxsdoutpath" select="'../../XSD/NIEM_MTF/niem-mtf-messages.xsd'"/>

    <xsl:variable name="fieldsmapoutpath" select="'../../XSD/NIEM_MTF/maps/niem-mtf-fieldmaps.xml'"/>
    <xsl:variable name="compositesmapoutpath" select="'../../XSD/NIEM_MTF/maps/niem-mtf-compositemaps.xml'"/>
    <xsl:variable name="setsmapoutpath" select="'../../XSD/NIEM_MTF/maps/niem-mtf-setmaps.xml'"/>
    <xsl:variable name="segmentsmapoutpath" select="'../../XSD/NIEM_MTF/maps/niem-mtf-segmntmaps.xml'"/>
    <xsl:variable name="messagesmapoutpath" select="'../../XSD/NIEM_MTF/maps/niem-mtf-msgsmaps.xml'"/>

    <xsl:variable name="srcdir" select="'../../XSD/'"/>
    <!--Baseline-->
    <xsl:variable name="baseline_fields_xsd" select="document($fieldspath)/*:schema"/>
    <xsl:variable name="baseline_composites_xsd" select="document($compositespath)/*:schema"/>
    <xsl:variable name="baseline_sets_xsd" select="document($setspath)/*:schema"/>
    <xsl:variable name="baseline_msgs_xsd" select="document($messagespath)/*:schema"/>
    <xsl:variable name="baseline_segments_xsd" select="$baseline_msgs_xsd/*//*:element[*:annotation/*:appinfo/*:SegmentStructureName]"/>

    <!--Changes-->
    <xsl:variable name="field_changes" select="document('../../XSD/Refactor_Changes/FieldChanges.xml')/FieldChanges"/>
    <xsl:variable name="comp_changes" select="document('../../XSD/Refactor_Changes/CompositeChanges.xml')"/>
    <xsl:variable name="set_changes" select="document('../../XSD/Refactor_Changes/SetChanges.xml')/*"/>
    <xsl:variable name="message_changes" select="document('../../XSD/Refactor_Changes/MessageChanges.xml')/*"/>
    <xsl:variable name="segment_changes" select="document('../../XSD/Refactor_Changes/SegmentChanges.xml')/*"/>
    <xsl:variable name="substGrp_Changes" select="document('../../XSD/Refactor_Changes/SubstitutionGroupChanges.xml')/*"/>
    <xsl:variable name="substGrp_Element_Changes" select="document('../../XSD/Refactor_Changes/ChoiceElementNames.xml')/*"/>
    <!--Maps-->
    <xsl:variable name="niem_fields_map">
        <xsl:for-each select="$strings/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$numerics/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$codelists/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="all_field_elements_map">
        <xsl:for-each select="$niem_messages_map//Element[starts-with(@mtftype, 'f:') or info/inf:Field]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_segments_map//Element[starts-with(@mtftype, 'f:') or info/inf:Field]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_sets_map//Choice[Element[starts-with(@mtftype, 'f:') or Element/info/inf:Field]]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_sets_map//Element[starts-with(@mtftype, 'f:') or info/inf:Field]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_composites_map//Element[starts-with(@mtftype, 'f:') or info/inf:Field]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:copy-of select="$niem_fields_map"/>
    </xsl:variable>

    <xsl:variable name="niem_composites_map">
        <xsl:for-each select="$baseline_composites_xsd/*:complexType">
            <xsl:variable name="annot">
                <xsl:apply-templates select="*:annotation"/>
            </xsl:variable>
            <xsl:variable name="mtfname" select="@name"/>
            <xsl:variable name="change" select="$comp_changes/CompositeTypeChanges/Composite[@name = $mtfname]"/>
            <xsl:variable name="n">
                <xsl:apply-templates select="@name" mode="fromtype"/>
            </xsl:variable>
            <xsl:variable name="niemname">
                <xsl:choose>
                    <xsl:when test="$change/@niemelementname">
                        <xsl:value-of select="$change/@niemelementname"/>
                    </xsl:when>
                    <xsl:when test="contains($n, 'BlankSpace')">
                        <xsl:text>BlankSpaceText</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$n"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemcomplextype">
                <xsl:choose>
                    <xsl:when test="ends-with($n, 'Indicator')">
                        <xsl:value-of select="concat($change/@niemelementname, 'Type')"/>
                    </xsl:when>
                    <xsl:when test="$change/@niemtype">
                        <xsl:value-of select="$change/@niemtype"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($n, 'Type')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemelementname">
                <xsl:value-of select="$niemname"/>
            </xsl:variable>
            <xsl:variable name="mtfdoc">
                <xsl:apply-templates select="$annot/*/*:documentation" mode="normlize"/>
            </xsl:variable>
            <xsl:variable name="niemtypedoc">
                <xsl:choose>
                    <xsl:when test="$change/@niemtypedoc">
                        <xsl:value-of select="$change/@niemtypedoc"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('A data type for ', lower-case($mtfdoc))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemelementdoc">
                <xsl:choose>
                    <xsl:when test="$change/@niemtypedoc">
                        <xsl:value-of select="replace($change/@niemtypedoc, 'A data type', 'A data item')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace($niemtypedoc, 'A data type', 'A data item')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="annot">
                <xsl:apply-templates select="*:annotation"/>
            </xsl:variable>
            <xsl:variable name="fappinfo">
                <xsl:apply-templates select="*:annotation/*:appinfo"/>
            </xsl:variable>
            <xsl:variable name="DistStmnt">
                <xsl:choose>
                    <xsl:when test="$change/@dist = 'A'">
                        <xsl:text>DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use. Other requests for this document shall be
   referred to Defense Information Systems Agency Interoperability Directorate. WARNING - This document contains technical data whose export is restricted by the Arms Export Control Act (Title 22,
   U.S.C., Sec. 2751) or the Export Administration Act of 1979, as amended, Title 50, U.S.C., App. 2401. Violations of these export laws are subject to severe criminal penalties. Disseminate in
   accordance with provisions of DOD Directive 5230.25.</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Version">
                <xsl:choose>
                    <xsl:when test="$change/@version">
                        <xsl:value-of select="$change/@version"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>C.0.01.00</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Date">
                <xsl:choose>
                    <xsl:when test="$change/@versiondate">
                        <xsl:value-of select="$change/@versiondate"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>October 2018</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Remark">
                <xsl:choose>
                    <xsl:when test="$change/@remark">
                        <xsl:value-of select="$change/@remark"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="appinfo">
                <xsl:for-each select="$annot/*/info">
                    <inf:Composite>
                        <xsl:for-each select="*:Field/@*">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                        <xsl:attribute name="version">
                            <xsl:value-of select="$Version"/>
                        </xsl:attribute>
                        <xsl:attribute name="date">
                            <xsl:value-of select="$Date"/>
                        </xsl:attribute>
                        <xsl:attribute name="remark">
                            <xsl:value-of select="$Remark"/>
                        </xsl:attribute>
                        <!--<xsl:attribute name="doddist">
                            <xsl:choose>
                                <xsl:when test="$change/@dist = 'A'">
                                    <xsl:text>DoD-Dist-A</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>DoD-Dist-C</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>-->
                        <!--<xsl:attribute name="diststatement">
                            <xsl:value-of select="$DistStmnt"/>
                        </xsl:attribute>-->
                    </inf:Composite>
                </xsl:for-each>
            </xsl:variable>
            <Composite niemelementname="{$niemelementname}" niemtype="{$niemcomplextype}" niemelementdoc="{$niemelementdoc}" mtfdoc="{$mtfdoc}" niemtypedoc="{$niemtypedoc}"
                mtfname="{@name}">
                <info>
                    <xsl:for-each select="$appinfo">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </info>
                <Sequence>
                    <xsl:apply-templates select="*:sequence/*:element"/>
                    <!--<xsl:for-each select="$seq_fields">
                        <xsl:copy-of select="Element"/>
                    </xsl:for-each>-->
                </Sequence>
            </Composite>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="all_composite_elements_map">
        <xsl:copy-of select="$niem_composites_map"/>
        <xsl:for-each select="$niem_sets_map//Element[starts-with(@mtftype, 'c:') or info/inf:Composite]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_sets_map//Choice[Element[starts-with(@mtftype, 'c:') or Element/info/inf:Composite]]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_segments_map//Element[starts-with(@mtftype, 'c:') or info/inf:Composite]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_messages_map//Element[starts-with(@mtftype, 'c:') or info/inf:Composite]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="niem_sets_map">
        <xsl:apply-templates select="$baseline_sets_xsd/*:complexType" mode="setglobal"/>
    </xsl:variable>
    <xsl:variable name="all_set_elements_map">
        <xsl:copy-of select="$niem_sets_map"/>
        <xsl:for-each select="$niem_sets_map//Element">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_segments_map//Element[starts-with(@mtftype, 's:') or info/inf:Set or starts-with(Choice/Element[1]/@mtftype, 's:')]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_messages_map//Element[starts-with(@mtftype, 's:') or info/inf:Set or starts-with(Choice/Element[1]/@mtftype, 's:')]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="niem_segments_map">
        <xsl:apply-templates select="$baseline_segments_xsd" mode="segmentglobal"/>
    </xsl:variable>
    <xsl:variable name="all_segment_elements_map">
        <xsl:for-each select="$niem_segments_map//Element[info/inf:Segment]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_messages_map//Element[info/inf:Segment]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="niem_messages_map">
        <xsl:apply-templates select="$baseline_msgs_xsd/*" mode="messageglobal"/>
    </xsl:variable>

    <xsl:template name="map">
        <xsl:result-document href="{$fieldsmapoutpath}">
            <Fields>
                <xsl:for-each select="$all_field_elements_map/*">
                    <xsl:sort select="@niemelementname"/>
                    <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Field'">
                        <xsl:variable name="n" select="@niemelementname"/>
                        <xsl:variable name="t" select="@niemtype"/>
                        <!--<xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">-->
                        <xsl:copy-of select="." copy-namespaces="no"/>
                        <!--</xsl:if>-->
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all_field_elements_map/*">
                    <xsl:sort select="@niemelementname"/>
                    <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Element'">
                        <xsl:variable name="n" select="@niemelementname"/>
                        <xsl:variable name="t" select="@niemtype"/>
                        <!--<xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">-->
                        <xsl:copy-of select="." copy-namespaces="no"/>
                        <!--</xsl:if>-->
                    </xsl:if>
                </xsl:for-each>
            </Fields>
        </xsl:result-document>
        <xsl:result-document href="{$compositesmapoutpath}">
            <Composites>
                <xsl:for-each select="$all_composite_elements_map/*">
                    <xsl:sort select="@niemelementname"/>
                    <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Composite'">
                        <xsl:variable name="n" select="@niemelementname"/>
                        <xsl:variable name="t" select="@niemtype"/>
                        <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all_composite_elements_map/*">
                    <xsl:sort select="@niemelementname"/>
                    <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Element'">
                        <xsl:variable name="n" select="@niemelementname"/>
                        <xsl:variable name="t" select="@niemtype"/>
                        <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </Composites>
        </xsl:result-document>
        <xsl:result-document href="{$setsmapoutpath}">
            <Sets>
                <xsl:for-each select="$all_set_elements_map/*">
                    <xsl:sort select="@niemelementname"/>
                    <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Set'">
                        <xsl:variable name="n" select="@niemelementname"/>
                        <xsl:variable name="t" select="@niemtype"/>
                        <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all_set_elements_map/*">
                    <xsl:sort select="@niemelementname"/>
                    <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Element'">
                        <xsl:variable name="n" select="@niemelementname"/>
                        <xsl:variable name="t" select="@niemtype"/>
                        <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </Sets>
        </xsl:result-document>
        <xsl:result-document href="{$segmentsmapoutpath}">
            <Segments>
                <xsl:for-each select="$niem_segments_map/*">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </Segments>
        </xsl:result-document>
        <xsl:result-document href="{$messagesmapoutpath}">
            <Messages>
                <xsl:for-each select="$niem_messages_map/*">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </Messages>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*:schema/*:complexType" mode="setglobal">
        <xsl:variable name="annot">
            <xsl:apply-templates select="*:annotation"/>
        </xsl:variable>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="fromtype"/>
        </xsl:variable>
        <xsl:variable name="setid" select="$annot/*/*/@setid"/>
        <xsl:variable name="change" select="$set_changes/Set[@setid = $setid]"/>
        <xsl:variable name="niemelementnamevar">
            <xsl:choose>
                <xsl:when test="$change/@niemelementname">
                    <xsl:value-of select="$change/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$mtfname = 'SetBaseType'">
                    <xsl:text>SetBase</xsl:text>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Set')">
                    <xsl:value-of select="$n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($n, 'Set')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemcomplextypevar">
            <xsl:choose>
                <xsl:when test="$change/@niemcomplextype">
                    <xsl:value-of select="$change/@niemcomplextype"/>
                </xsl:when>
                <xsl:when test="$niemelementnamevar = 'SetBase'">
                    <xsl:value-of select="concat($niemelementnamevar, 'Type')"/>
                </xsl:when>
                <xsl:when test="ends-with($niemelementnamevar, 'Set')">
                    <xsl:value-of select="concat($niemelementnamevar, 'Type')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($niemelementnamevar, 'SetType')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfdocvar">
            <xsl:apply-templates select="$annot/*/*:documentation" mode="normlize"/>
        </xsl:variable>
        <xsl:variable name="niemtypedocvar">
            <xsl:choose>
                <xsl:when test="$change/@niemtypedoc">
                    <xsl:apply-templates select="concat('A data type for the ', replace($change/@niemtypedoc, 'The', 'the'))" mode="normlize"/>
                </xsl:when>
                <xsl:when test="starts-with($mtfdocvar, 'A data ')">
                    <xsl:apply-templates select="$mtfdocvar" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="concat('A data type for the ', $mtfdocvar)" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementdocvar">
            <xsl:apply-templates select="replace($niemtypedocvar, 'A data type', 'A data item')" mode="normlize"/>
        </xsl:variable>
        <xsl:variable name="fappinfo">
            <xsl:apply-templates select="*:annotation/*:appinfo"/>
        </xsl:variable>
        <xsl:variable name="DistStmnt">
            <xsl:choose>
                <xsl:when test="$change/@dist = 'A'">
                    <xsl:text>DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use. Other requests for this document shall be
   referred to Defense Information Systems Agency Interoperability Directorate. WARNING - This document contains technical data whose export is restricted by the Arms Export Control Act (Title 22,
   U.S.C., Sec. 2751) or the Export Administration Act of 1979, as amended, Title 50, U.S.C., App. 2401. Violations of these export laws are subject to severe criminal penalties. Disseminate in
   accordance with provisions of DOD Directive 5230.25.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Version">
            <xsl:choose>
                <xsl:when test="$change/@version">
                    <xsl:value-of select="$change/@version"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>C.0.01.00</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Date">
            <xsl:choose>
                <xsl:when test="$change/@versiondate">
                    <xsl:value-of select="$change/@versiondate"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>October 2018</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Remark">
            <xsl:choose>
                <xsl:when test="$change/@remark">
                    <xsl:value-of select="$change/@remark"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Created by ICP M2018-02</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <xsl:for-each select="$annot/*/info">
                <inf:Set>
                    <xsl:for-each select="*:Field/@*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:attribute name="name">
                        <xsl:value-of select="$Version"/>
                    </xsl:attribute>
                    <xsl:attribute name="version">
                        <xsl:value-of select="$Version"/>
                    </xsl:attribute>
                    <xsl:attribute name="date">
                        <xsl:value-of select="$Date"/>
                    </xsl:attribute>
                    <xsl:attribute name="remark">
                        <xsl:value-of select="$Remark"/>
                    </xsl:attribute>
                    <!--<xsl:attribute name="doddist">
                        <xsl:choose>
                            <xsl:when test="$change/@dist = 'C'">
                                <xsl:text>DoD-Dist-C</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>DoD-Dist-A</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>-->
                    <!--  <xsl:attribute name="diststatement">
                        <xsl:value-of select="$DistStmnt"/>
                    </xsl:attribute>-->
                </inf:Set>
            </xsl:for-each>
        </xsl:variable>
        <Set niemelementname="{$niemelementnamevar}" niemtype="{$niemcomplextypevar}" niemelementdoc="{$niemelementdocvar}" mtfname="{@name}" mtfdoc="{$mtfdocvar}"
            niemtypedoc="{$niemtypedocvar}">
            <xsl:apply-templates select="$annot/*:annotation/info" mode="copy"/>
            <xsl:apply-templates select="*[not(contains(name(), ':annotation'))]">
                <xsl:with-param name="settypevar" select="$mtfname"/>
            </xsl:apply-templates>
        </Set>
    </xsl:template>
    <xsl:template match="*:element" mode="segmentglobal">
        <xsl:variable name="annot">
            <xsl:apply-templates select="*:annotation"/>
        </xsl:variable>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="messagename" select="ancestor::*:element[parent::*:schema]/@name"/>
        <xsl:variable name="change" select="$segment_changes/Segment[@mtfname = $mtfname]"/>
        <xsl:variable name="niemelementnamevar">
            <xsl:choose>
                <xsl:when test="$change/@niemelementname">
                    <xsl:value-of select="$change/@niemelementname"/>
                </xsl:when>
                <xsl:when test="ends-with($mtfname, 'Segment')">
                    <xsl:value-of select="$mtfname"/>
                </xsl:when>
                <xsl:when test="contains($mtfname, 'Segment_')">
                    <xsl:value-of select="concat(substring-before($mtfname, 'Segment_'), 'Segment')"/>
                </xsl:when>
                <xsl:when test="contains($mtfname, '_')">
                    <xsl:value-of select="concat(substring-before($mtfname, '_'), 'Segment')"/>
                </xsl:when>
                <xsl:when test="ends-with($mtfname, 'Segment')">
                    <!--<xsl:apply-templates select="@name" mode="txt"/>-->
                    <xsl:value-of select="$mtfname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($mtfname, 'Segment')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemcomplextype">
            <xsl:choose>
                <xsl:when test="$change/@niemtype">
                    <xsl:value-of select="$change/@niemtype"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($niemelementnamevar, 'Type')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="changedoc" select="$segment_changes/Segment[@mtfname = $mtfname][@niemcomplextype = $niemcomplextype]"/>
        <xsl:variable name="mtfdoc">
            <xsl:choose>
                <xsl:when test="*:annotation/*:documentation">
                    <xsl:apply-templates select="*:annotation/*:documentation" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$annot/*/*:documentation" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="segseq">
            <xsl:value-of select="*:complexType/*:attribute[@name = 'segSeq'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="niemtypedocvar">
            <xsl:choose>
                <xsl:when test="$changedoc/@niemtypedoc">
                    <xsl:apply-templates select="$changedoc/@niemtypedoc" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="concat('A data type that ', lower-case($mtfdoc))" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementdocvar">
            <xsl:choose>
                <xsl:when test="$changedoc/@niemelementdoc">
                    <xsl:apply-templates select="$changedoc/@niemelementdoc" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="replace($niemtypedocvar, 'A data type', 'A data item')" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="fappinfo">
            <xsl:apply-templates select="*:annotation/*:appinfo"/>
        </xsl:variable>
        <xsl:variable name="DistStmnt">
            <xsl:choose>
                <xsl:when test="$change/@dist = 'A'">
                    <xsl:text>DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use. Other requests for this document shall be
   referred to Defense Information Systems Agency Interoperability Directorate. WARNING - This document contains technical data whose export is restricted by the Arms Export Control Act (Title 22,
   U.S.C., Sec. 2751) or the Export Administration Act of 1979, as amended, Title 50, U.S.C., App. 2401. Violations of these export laws are subject to severe criminal penalties. Disseminate in
   accordance with provisions of DOD Directive 5230.25.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Version">
            <xsl:choose>
                <xsl:when test="$change/@version">
                    <xsl:value-of select="$change/@version"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>C.0.01.00</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Date">
            <xsl:choose>
                <xsl:when test="$change/@versiondate">
                    <xsl:value-of select="$change/@versiondate"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>October 2018</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Remark">
            <xsl:choose>
                <xsl:when test="$change/@remark">
                    <xsl:value-of select="$change/@remark"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Created by ICP M2018-02</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <xsl:for-each select="$annot/xs:annotation/info">
                <inf:Segment>
                    <xsl:for-each select="*:Field/@*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:attribute name="version">
                        <xsl:value-of select="$Version"/>
                    </xsl:attribute>
                    <xsl:attribute name="date">
                        <xsl:value-of select="$Date"/>
                    </xsl:attribute>
                    <xsl:attribute name="remark">
                        <xsl:value-of select="$Remark"/>
                    </xsl:attribute>
                    <!--<xsl:attribute name="doddist">
                        <xsl:choose>
                            <xsl:when test="$change/@dist = 'A'">
                                <xsl:text>DoD-Dist-A</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>DoD-Dist-C</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>-->
                    <!--  <xsl:attribute name="diststatement">
                        <xsl:value-of select="$DistStmnt"/>
                    </xsl:attribute>-->
                </inf:Segment>
            </xsl:for-each>
        </xsl:variable>
        <Segment niemelementname="{$niemelementnamevar}" niemtype="{$niemcomplextype}" niemelementdoc="{$niemelementdocvar}" mtfname="{@name}" messagename="{$messagename}"
            mtfdoc="{$mtfdoc}" niemtypedoc="{$niemtypedocvar}">
            <xsl:if test="string-length($segseq) &gt; 0">
                <xsl:attribute name="segseq">
                    <xsl:value-of select="$segseq"/>
                </xsl:attribute>
            </xsl:if>
            <info>
                <xsl:for-each select="$annot/*:annotation/info/*">
                    <xsl:copy>
                        <xsl:apply-templates select="@*" mode="copy"/>
                        <xsl:if test="string-length($segseq) &gt; 0">
                            <xsl:attribute name="segseq">
                                <xsl:value-of select="$segseq"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:copy>
                </xsl:for-each>
            </info>
            <xsl:apply-templates select="*[not(contains(name(), ':annotation'))]">
                <xsl:with-param name="segmentnamevar" select="$mtfname"/>
            </xsl:apply-templates>
        </Segment>
    </xsl:template>
    <xsl:template match="*:element" mode="messageglobal">
        <xsl:variable name="annot">
            <xsl:apply-templates select="*:annotation"/>
        </xsl:variable>
        <xsl:variable name="mtfnamevar" select="@name"/>
        <xsl:variable name="change" select="$message_changes/Message[@mtfname = $mtfnamevar]"/>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="niemelementnamevar">
            <xsl:choose>
                <xsl:when test="$message_changes/Element[@messagename = $mtfnamevar]/@niemname">
                    <xsl:value-of select="$message_changes/Element[@messagename = $mtfnamevar]/@niemname"/>
                </xsl:when>
                <xsl:when test="$message_changes/Element[@mtfname = $mtfnamevar][@messagename = '']/@niemelementname">
                    <xsl:value-of select="$message_changes/Element[@mtfname = $mtfnamevar][@messagename = '']/@niemelementname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$n"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemcomplextype">
            <xsl:value-of select="concat($niemelementnamevar, 'Type')"/>
        </xsl:variable>
        <xsl:variable name="mtfdoc">
            <xsl:choose>
                <xsl:when test="*:annotation/*:documentation">
                    <xsl:apply-templates select="*:annotation/*:documentation" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($annot/*/*:documentation)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfid">
            <xsl:value-of select="*:complexType/*:attribute[@name = 'mtfid'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="niemtypedocvar">
            <xsl:choose>
                <xsl:when test="$message_changes/Element[@mtfname = $mtfnamevar][@niemname = $niemelementnamevar]/@niemtypedoc">
                    <xsl:apply-templates
                        select="concat('A data type for the', $message_changes/Element[@mtfname = $mtfnamevar][@niemname = $niemelementnamevar]/@niemtypedoc, 'The')"
                        mode="normlize"/>
                </xsl:when>
                <xsl:when test="starts-with($mtfdoc, 'A data type')">
                    <xsl:value-of select="$mtfdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('A data type for ', lower-case(substring($mtfdoc, 1, 1)), substring($mtfdoc, 2))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementdocvar">
            <xsl:choose>
                <xsl:when test="$message_changes/Element[@mtfname = $mtfnamevar][@niemname = $niemelementnamevar]/@niemelementdoc">
                    <xsl:apply-templates select="$message_changes/Element[@mtfname = $mtfnamevar][@niemname = $niemelementnamevar]/@niemelementdoc" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="replace($niemtypedocvar, 'A data type', 'A data item')" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="fappinfo">
            <xsl:apply-templates select="*:annotation/*:appinfo"/>
        </xsl:variable>
        <xsl:variable name="DistStmnt">
            <xsl:choose>
                <xsl:when test="$change/@dist = 'A'">
                    <xsl:text>DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use. Other requests for this document shall be
   referred to Defense Information Systems Agency Interoperability Directorate. WARNING - This document contains technical data whose export is restricted by the Arms Export Control Act (Title 22,
   U.S.C., Sec. 2751) or the Export Administration Act of 1979, as amended, Title 50, U.S.C., App. 2401. Violations of these export laws are subject to severe criminal penalties. Disseminate in
   accordance with provisions of DOD Directive 5230.25.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Version">
            <xsl:choose>
                <xsl:when test="$change/@version">
                    <xsl:value-of select="$change/@version"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>C.0.01.00</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Date">
            <xsl:choose>
                <xsl:when test="$change/@versiondate">
                    <xsl:value-of select="$change/@versiondate"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>October 2018</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Remark">
            <xsl:choose>
                <xsl:when test="$change/@remark">
                    <xsl:value-of select="$change/@remark"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Created by ICP M2018-02</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <xsl:for-each select="$annot/*/info">
                <inf:Msg>
                    <xsl:for-each select="*:Msg/@*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:attribute name="version">
                        <xsl:value-of select="$Version"/>
                    </xsl:attribute>
                    <xsl:attribute name="date">
                        <xsl:value-of select="$Date"/>
                    </xsl:attribute>
                    <xsl:attribute name="remark">
                        <xsl:value-of select="$Remark"/>
                    </xsl:attribute>
                    <!--<xsl:attribute name="doddist">
                        <xsl:choose>
                            <xsl:when test="$change/@dist = 'A'">
                                <xsl:text>DoD-Dist-A</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>DoD-Dist-C</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>-->
                    <!--<xsl:attribute name="diststatement">
                        <xsl:value-of select="$DistStmnt"/>
                    </xsl:attribute>-->
                </inf:Msg>
            </xsl:for-each>
        </xsl:variable>
        <Message niemelementname="{$niemelementnamevar}" niemtype="{$niemcomplextype}" niemelementdoc="{$niemelementdocvar}" mtfname="{@name}" mtfid="{$mtfid}" mtfdoc="{$mtfdoc}"
            niemtypedoc="{$niemtypedocvar}">
            <info>
                <xsl:for-each select="$appinfo/*">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </info>
            <xsl:apply-templates select="*[not(contains(name(), ':annotation'))]">
                <xsl:with-param name="messagenamevar" select="$mtfnamevar"/>
            </xsl:apply-templates>
        </Message>
    </xsl:template>
    <!--  Element -->
    <xsl:template match="*:element">
        <xsl:param name="sbstgrp"/>
        <xsl:param name="settypevar"/>
        <xsl:param name="segmentnamevar"/>
        <xsl:param name="messagenamevar"/>
        <xsl:variable name="n">
            <xsl:choose>
                <xsl:when test="ends-with(@name, 'Type')">
                    <xsl:apply-templates select="@name" mode="fromtype"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="mtfnamevar">
            <xsl:apply-templates select="@name" mode="txt"/>
        </xsl:variable>
        <xsl:variable name="mtfbase">
            <xsl:choose>
                <xsl:when test="@type">
                    <xsl:value-of select="@type"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="*:complexType/*/*:extension/@base"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtftypevar">
            <xsl:choose>
                <xsl:when test="contains($mtfbase, ':')">
                    <xsl:value-of select="substring-after($mtfbase, ':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfbase"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfroot">
            <xsl:choose>
                <xsl:when test="starts-with(@name, '_')">
                    <xsl:apply-templates select="@name" mode="txt"/>
                </xsl:when>
                <xsl:when test="contains(@name, '_')">
                    <xsl:value-of select="substring-before(@name, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="setnamevar">
            <xsl:value-of select="substring($settypevar, 0, string-length($settypevar) - 3)"/>
        </xsl:variable>
        <xsl:variable name="msgnamevar">
            <xsl:value-of select="ancestor::*:element[*:annotation/*/*:MtfName]/@name"/>
        </xsl:variable>
        <xsl:variable name="ffirnfud">
            <xsl:value-of select="*:complexType/*//*:attribute[@name = 'ffirnFudn']/@fixed"/>
        </xsl:variable>
        <xsl:variable name="ffirnvar">
            <xsl:value-of select="substring-before(substring-after($ffirnfud, 'FF'), '-')"/>
        </xsl:variable>
        <xsl:variable name="fudvar">
            <xsl:value-of select="substring-after(substring-after($ffirnfud, 'FF'), '-')"/>
        </xsl:variable>
        <xsl:variable name="annot">
            <xsl:apply-templates select="*:annotation"/>
            <xsl:if test="contains($mtfbase, 'f:')">
                <xsl:apply-templates select="$baseline_fields_xsd/*[@name = $mtftypevar]/*:annotation"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="typeannot">
            <xsl:choose>
                <xsl:when test="*:complexType/*/*:extension/*:annotation">
                    <xsl:apply-templates select="*:complexType/*/*:extension/*:annotation"/>
                </xsl:when>
                <xsl:when test="starts-with(*:complexType/*/*:extension/@base, 'f:')">
                    <xsl:apply-templates select="$baseline_fields_xsd/*[@name = substring-after(*:complexType/*/*:extension/@base, 'f:')]/*:annotation"/>
                </xsl:when>
                <xsl:when test="starts-with(*:complexType/*/*:extension/@base, 'c:')">
                    <xsl:apply-templates select="$baseline_composites_xsd/*[@name = substring-after(*:complexType/*/*:extension/@base, 'c:')]/*:annotation"/>
                </xsl:when>
                <xsl:when test="starts-with(*:complexType/*/*:extension/@base, 's:')">
                    <xsl:apply-templates select="$baseline_sets_xsd/*[@name = substring-after(*:complexType/*/*:extension/@base, 's:')]/*:annotation"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="segmentname" select="ancestor::*:element[ends-with(@name, 'Segment')][1]/@name"/>
        <xsl:variable name="isField" select="exists($annot/*/info/inf:Field) or starts-with($mtfbase, 'f:')"/>
        <xsl:variable name="isComposite" select="exists($annot/*/info/inf:Composite) or starts-with($mtfbase, 'c:')"/>
        <xsl:variable name="isSet" select="exists($annot/*/info/inf:Set) or starts-with($mtfbase, 's:')"/>
        <xsl:variable name="isSegment" select="exists($annot/*/info/inf:Segment)"/>
        <xsl:variable name="niemmatch">
            <xsl:choose>
                <xsl:when test="$isSet">
                    <xsl:copy-of select="$niem_sets_map/Set[@mtftype = $mtftypevar][1]"/>
                </xsl:when>
                <xsl:when test="$isField">
                    <xsl:copy-of select="$niem_fields_map/Field[@mtftype = $mtftypevar][1]"/>
                </xsl:when>
                <xsl:when test="$isComposite">
                    <xsl:copy-of select="$niem_composites_map/Composite[@mtftype = $mtftypevar][1]"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemtypedocvar">
            <xsl:value-of select="$niemmatch/*/@niemelementdoc"/>
        </xsl:variable>
        <xsl:variable name="setidvar">
            <xsl:value-of select="$niemmatch/*/info/inf:Set/@setid"/>
        </xsl:variable>
        <xsl:variable name="fieldseq">
            <xsl:choose>
                <xsl:when test="*:complexType/*:attribute[@name = 'ffSeq']">
                    <xsl:value-of select="*:complexType/*:attribute[@name = 'ffSeq'][1]/@fixed"/>
                </xsl:when>
                <xsl:when test="*:complexType/*:simpleContent/*:extension/*:attribute[@name = 'ffSeq']">
                    <xsl:value-of select="*:complexType/*:simpleContent/*:extension/*:attribute[@name = 'ffSeq'][1]/@fixed"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="position()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="segseq">
            <xsl:value-of select="*:complexType/*:attribute[@name = 'segSeq'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="setseq">
            <xsl:value-of select="*:complexType/*:complexContent/*:extension/*:attribute[@name = 'setSeq'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="mtftypedoc">
            <xsl:apply-templates select="$typeannot/*/*:documentation" mode="normlize"/>
        </xsl:variable>
        <xsl:variable name="apos">
            <xsl:text>'</xsl:text>
        </xsl:variable>
        <xsl:variable name="UseDesc" select="replace($annot/*/info/*[1]/@usage, '”&quot;', $apos)"/>
        <xsl:variable name="TextIndicator">
            <xsl:if test="contains($UseDesc, 'must equal')">
                <xsl:value-of select="normalize-space(substring-before(substring-after($UseDesc, concat('must equal ', $apos)), $apos))"/>
            </xsl:if>
            <xsl:if test="contains($UseDesc, 'must equalL')">
                <xsl:value-of select="normalize-space(substring-before(substring-after($UseDesc, concat('must equalL ', $apos)), $apos))"/>
            </xsl:if>
            <xsl:if test="contains($UseDesc, 'MUST EQUAL')">
                <xsl:value-of select="normalize-space(substring-before(substring-after($UseDesc, concat('must equalL ', $apos)), $apos))"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="GenText">
            <xsl:call-template name="GenTextName">
                <xsl:with-param name="textind" select="$TextIndicator"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="HeaderInfo">
            <xsl:call-template name="HeadingInformation">
                <xsl:with-param name="textind" select="$TextIndicator"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="niemtypevar">
            <xsl:choose>
                <xsl:when test="ends-with($mtftypevar, 'GeneralTextType')">
                    <xsl:value-of select="concat($GenText, 'Type')"/>
                </xsl:when>
                <xsl:when test="$isSet and ends-with($mtfnamevar, 'HeadingInformation') and not(contains($mtfnamevar,'Ditch'))">
                    <xsl:value-of select="concat($mtfnamevar, 'SetType')"/>
                </xsl:when>
                <xsl:when test="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemtype">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemtype"/>
                </xsl:when>
                <xsl:when test="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar]/@niemtype">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar]/@niemtype"/>
                </xsl:when>
                <xsl:when test="$segmentnamevar and $segment_changes/Element[@mtfname = $mtfnamevar][1]/@niemtype">
                    <xsl:value-of select="$segment_changes/Element[@mtfname = $mtfnamevar][1]/@niemtype"/>
                </xsl:when>
                <xsl:when test="$messagenamevar and $message_changes/Element[@mtfname = $mtfnamevar][1]/@niemtype">
                    <xsl:value-of select="$message_changes/Element[@mtfname = $mtfnamevar][1]/@niemtype"/>
                </xsl:when>
                <xsl:when test="$comp_changes//CompositeTypeChanges/Composite[@name = $mtftypevar]/@niemtype">
                    <xsl:value-of select="$comp_changes//CompositeTypeChanges/Composite[@name = $mtftypevar]/@niemtype"/>
                </xsl:when>
                <!--BlankText -->
                <xsl:when test="contains($mtftypevar, 'BlankSpace')">
                    <xsl:text>BlankSpaceTextType</xsl:text>
                </xsl:when>
                <xsl:when test="string-length($niemmatch//@niemtype) &gt; 0">
                    <xsl:apply-templates select="$niemmatch//@niemtype" mode="txt"/>
                </xsl:when>

                <xsl:when test="$isSet and $niem_sets_map/Set[@mtfname = $mtftypevar]">
                    <xsl:value-of select="$niem_sets_map/Set[@mtfname = $mtftypevar]/@niemtype"/>
                </xsl:when>
                <xsl:when test="*:complexType/*/*:extension/@base">
                    <xsl:apply-templates select="*:complexType/*/*:extension/@base" mode="txt"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($mtfnamevar, 'Type')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemel">
            <xsl:choose>
                <xsl:when test="$isField">
                    <xsl:variable name="set_chg" select="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar]"/>
                    <xsl:choose>
                        <xsl:when test="$field_changes/*[@name = $mtfnamevar]">
                            <xsl:value-of select="$field_changes/*[@name = $mtfnamevar]/@niemelementname"/>
                        </xsl:when>
                        <xsl:when test="$field_changes/*[@name = $mtfname]">
                            <xsl:value-of select="$field_changes/*[@name = $mtfname]/@niemelementname"/>
                        </xsl:when>
                        <xsl:when test="$set_chg/@niemelementname">
                            <xsl:value-of select="$set_chg/@niemelementname"/>
                        </xsl:when>
                        <xsl:when test="ends-with($mtftypevar, 'GeneralTextType')">
                            <xsl:value-of select="$GenText"/>
                        </xsl:when>
                        <xsl:when test="ends-with($niemtypevar, 'TextType') and not(ends-with($n, 'Text'))">
                            <xsl:value-of select="concat($n, 'Text')"/>
                        </xsl:when>
                        <xsl:when test="ends-with($niemtypevar, 'CodeType') and not(ends-with($mtfnamevar, 'Code'))">
                            <xsl:value-of select="concat($mtfnamevar, 'Code')"/>
                        </xsl:when>
                        <xsl:when test="contains($niemtypevar, 'Integer') and not(ends-with($mtfnamevar, 'Numeric'))">
                            <xsl:value-of select="concat($mtfnamevar, 'Numeric')"/>
                        </xsl:when>
                        <xsl:when test="contains($niemtypevar, 'Decimal') and not(ends-with($mtfnamevar, 'Numeric'))">
                            <xsl:value-of select="concat($mtfnamevar, 'Numeric')"/>
                        </xsl:when>
                        <xsl:when test="ends-with($niemtypevar, 'IndicatorType') and not(ends-with($mtfnamevar, 'Indicator'))">
                            <xsl:value-of select="concat($mtfnamevar, 'Indicator')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$mtfnamevar"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$isComposite">
                    <xsl:variable name="comp_chg" select="$comp_changes/CompositeTypeChanges/Composite[@name = $mtfnamevar]"/>
                    <xsl:variable name="set_chg" select="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar]"/>
                    <xsl:choose>
                        <xsl:when test="$comp_chg/@niemelementname">
                            <xsl:value-of select="$comp_chg/@niemelementname"/>
                        </xsl:when>
                        <xsl:when test="$set_chg/@niemelementname">
                            <xsl:value-of select="$set_chg/@niemelementname"/>
                        </xsl:when>
                        <!-- <xsl:when test="$niemmatch/*/@niemelementname">
                            <xsl:value-of select="$niemmatch/*/@niemelementname"/>
                        </xsl:when>-->
                        <xsl:otherwise>
                            <xsl:value-of select="$mtfnamevar"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$isSegment">
                    <xsl:variable name="seg_chg" select="$segment_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar]"/>
                    <xsl:choose>
                        <xsl:when test="$seg_chg/@niemelementname">
                            <xsl:value-of select="$seg_chg/@niemelementname"/>
                        </xsl:when>
                        <xsl:when test="ends-with($mtfnamevar, 'Segment')">
                            <xsl:value-of select="$mtfnamevar"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($mtfnamevar, 'Segment')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$isSet">
                    <xsl:variable name="set_chg" select="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar]"/>
                    <xsl:choose>
                        <xsl:when test="$set_chg/@niemelementname">
                            <xsl:value-of select="$set_chg/@niemelementname"/>
                        </xsl:when>
                        <xsl:when test="@segmentname">
                            <xsl:value-of select="$mtfnamevar"/>
                        </xsl:when>
                        <xsl:when test="ends-with($mtftypevar, 'GeneralTextType')">
                            <xsl:value-of select="$GenText"/>
                        </xsl:when>
                        <xsl:when test="ends-with($mtfnamevar, 'Set')">
                            <xsl:value-of select="$mtfnamevar"/>
                        </xsl:when>
                        <xsl:when test="ends-with($mtfnamevar, 'Base')">
                            <xsl:value-of select="$mtfnamevar"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($mtfnamevar, 'Set')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="ends-with($mtftypevar, 'TextType') and not(ends-with($n, 'Text'))">
                    <xsl:value-of select="concat($n, 'Text')"/>
                </xsl:when>
                <xsl:when test="ends-with($mtftypevar, 'NumericType') and not(ends-with($n, 'Numeric'))">
                    <xsl:value-of select="concat($n, 'Numeric')"/>
                </xsl:when>
                <xsl:when test="ends-with($mtftypevar, 'CodeType') and not(ends-with($n, 'Code'))">
                    <xsl:value-of select="concat($n, 'Code')"/>
                </xsl:when>
                <xsl:when test="$niemmatch/*/@niemelementname">
                    <xsl:value-of select="$niemmatch/*/@niemelementname"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelement">
            <xsl:choose>
                <xsl:when test="$sbstgrp">
                    <xsl:choose>
                        <xsl:when test="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $setnamevar]">
                            <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $setnamevar]/@niemname"/>
                        </xsl:when>
                        <xsl:when test="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $segmentnamevar]">
                            <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $segmentnamevar]/@niemname"/>
                        </xsl:when>
                        <xsl:when test="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $messagenamevar]">
                            <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $messagenamevar]/@niemname"/>
                        </xsl:when>
                        <xsl:when test="$substGrp_Element_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtfbase]">
                            <xsl:variable name="shortSubgrp">
                                <xsl:call-template name="removeStrings">
                                    <xsl:with-param name="targetStr" select="$sbstgrp"/>
                                    <xsl:with-param name="strings" select="$substGrp_Element_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtfbase]/@filter"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="shortOption" select="$substGrp_Element_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtfbase]/@shortname"/>
                            <xsl:value-of select="concat($shortSubgrp, $shortOption)"/>
                        </xsl:when>
                        <xsl:when test="$substGrp_Element_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]">
                            <xsl:variable name="shortSubgrp">
                                <xsl:call-template name="removeStrings">
                                    <xsl:with-param name="targetStr" select="$sbstgrp"/>
                                    <xsl:with-param name="strings" select="$substGrp_Element_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@filter"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="shortOption" select="$substGrp_Element_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@shortname"/>
                            <xsl:value-of select="concat($shortSubgrp, $shortOption)"/>
                        </xsl:when>
                        <xsl:when test="$niem_composites_map/*[@niemelementname = $niemel]">
                            <xsl:value-of select="concat($sbstgrp, $niemel)"/>
                        </xsl:when>
                        <xsl:when test="$niem_fields_map/*[@niemelementname = $niemel]">
                            <xsl:value-of select="concat($sbstgrp, $niemel)"/>
                        </xsl:when>
                        <xsl:when test="$isSet and contains(@name, 'HeadingInformation') and not(contains(@name,'Ditch'))">
                            <xsl:call-template name="HeadingInformation">
                                <xsl:with-param name="textind" select="$TextIndicator"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="@name = $niemel">
                            <xsl:value-of select="concat($sbstgrp, $niemel)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($sbstgrp, $niemel)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="string-length($niemel) &gt; 0">
                    <xsl:value-of select="$niemel"/>
                </xsl:when>
                <xsl:when test="$message_changes/Element[@mtfname = $mtfnamevar][@messagename = $msgnamevar]/@niemelementname">
                    <xsl:value-of select="$message_changes/Element[@mtfname = $mtfnamevar][@messagename = $msgnamevar]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemelementname">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$set_changes/Element[@mtfname = $mtfnamevar][@segmentname = $segmentnamevar]/@niemelementname">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@segmentname = $segmentnamevar]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$segment_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemelementname">
                    <xsl:value-of select="$segment_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemelementname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfnamevar"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementnamevar">
            <xsl:choose>
                <!--Use Set Change-->
                <xsl:when test="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemelementname">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$settypevar and $set_changes/Element[@mtfname = $mtfnamevar][@setname = $setnamevar][1]/@niemelementname">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $setnamevar][1]/@niemelementname"/>
                </xsl:when>
                <!--Use Set Field Change-->
                <xsl:when test="$isField and $set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtfbase][1]/@niemelementname">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtfbase][1]/@niemelementname"/>
                </xsl:when>
                <!--Use Segment Change-->
                <xsl:when test="$segment_changes/Element[@mtfname = $n]/@niemelementname">
                    <xsl:value-of select="$segment_changes/Element[@mtfname = $n]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$isComposite and $comp_changes/Composite[@name = $mtfnamevar]/@niemelementname">
                    <xsl:value-of select="$comp_changes/Composite[@name = $mtfnamevar]/@niemelementname"/>
                </xsl:when>
                <!--Use Segment Change-->
                <xsl:when test="$isSegment and $segment_changes/Element[@mtfname = $mtfnamevar][1]/@niemelementname">
                    <xsl:value-of select="$segment_changes/Element[@mtfname = $mtfnamevar][1]/@niemelementname"/>
                </xsl:when>
                <!--Use Message element Change-->
                <xsl:when test="$messagenamevar and $message_changes/Element[@mtfname = $mtfname][@messagename = $messagenamevar]/@niemelementname">
                    <xsl:value-of select="$message_changes/Element[@mtfname = $mtfname][@messagename = $messagenamevar]/@niemelementname"/>
                </xsl:when>
                <!--Use Subsitution group name -->
                <xsl:when test="string-length($sbstgrp) &gt; 0">
                    <xsl:value-of select="$niemelement"/>
                </xsl:when>
                <!--Create GenText Name -->
                <xsl:when test="contains($mtftypevar, 'GeneralText')">
                    <xsl:value-of select="$GenText"/>
                </xsl:when>
                <xsl:when test="$isSet and contains($mtftypevar, 'HeadingInformation') and not(contains($mtftypevar,'Ditch'))">
                    <xsl:value-of select="$HeaderInfo"/>
                </xsl:when>
                <!--Create GenText Name -->
                <xsl:when test="$setidvar = 'GENTEXT'">
                    <xsl:value-of select="$GenText"/>
                </xsl:when>
                <!--Remove leading underscore in name -->
                <xsl:when test="starts-with($niemelement, '_')">
                    <xsl:apply-templates select="@name" mode="txt"/>
                </xsl:when>
                <!--Numeric repetition -->
                <xsl:when test="ends-with($mtfname, '_1')">
                    <xsl:value-of select="concat('First', replace($niemelement, '_1', ''))"/>
                </xsl:when>
                <xsl:when test="ends-with($mtfname, '_2')">
                    <xsl:value-of select="concat('Second', replace($niemelement, '_2', ''))"/>
                </xsl:when>
                <xsl:when test="ends-with($mtfname, '_3')">
                    <xsl:value-of select="concat('Third', replace($niemelement, '_3', ''))"/>
                </xsl:when>
                <xsl:when test="ends-with($mtfname, '_4')">
                    <xsl:value-of select="concat('Fourth', replace($niemelement, '_4', ''))"/>
                </xsl:when>
                <xsl:when test="ends-with($mtfname, '_5')">
                    <xsl:value-of select="concat('Fifth', replace($niemelement, '_5', ''))"/>
                </xsl:when>
                <xsl:when test="ends-with($mtfname, '_6')">
                    <xsl:value-of select="concat('Sixth', replace($niemelement, '_6', ''))"/>
                </xsl:when>
                <xsl:when test="ends-with($mtfname, '_7')">
                    <xsl:value-of select="concat('Seventh', replace($niemelement, '_7', ''))"/>
                </xsl:when>
                <!--BlankText -->
                <xsl:when test="contains($mtftypevar, 'BlankSpace')">
                    <xsl:text>BlankSpaceText</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$niemelement"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="fixedval">
            <xsl:choose>
                <xsl:when test="contains($mtftypevar, 'GeneralText')">
                    <xsl:value-of select="$TextIndicator"/>
                </xsl:when>
                <xsl:when test="contains($mtftypevar, 'Heading')">
                    <xsl:value-of select="$TextIndicator"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfdocvar">
            <xsl:choose>
                <xsl:when test="$niemmatch/*/@mtfdoc">
                    <xsl:apply-templates select="$niemmatch/*/@mtfdoc" mode="normlize"/>
                </xsl:when>
                <xsl:when test="*:annotation/*:documentation">
                    <xsl:apply-templates select="*:annotation/*:documentation" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$annot/*:documentation" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemdocvar">
            <xsl:choose>
                <xsl:when test="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtfbase]/@niemelementdoc">
                    <xsl:apply-templates select="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtfbase]/@niemelementdoc" mode="normlize"/>
                </xsl:when>
                <xsl:when test="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemelementdoc">
                    <xsl:apply-templates select="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemelementdoc" mode="normlize"/>
                </xsl:when>
                <xsl:when test="$annot/*:documentation">
                    <xsl:apply-templates select="concat('A data item for ', lower-case($mtfdocvar))" mode="normlize"/>
                </xsl:when>
                <xsl:when test="starts-with($niemmatch/*/@niemelementdoc, 'A data type for') and contains($niemelementnamevar, 'Name')">
                    <xsl:apply-templates select="replace(@niemelementdoc, 'A data type ', 'A data item for the name ')" mode="normlize"/>
                </xsl:when>
                <xsl:when test="starts-with($niemmatch/*/@niemelementdoc, 'A data type for ')">
                    <xsl:apply-templates select="replace($niemmatch/*/@niemelementdoc, 'A data type', 'A data item')" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="e">
                        <xsl:call-template name="breakIntoWords">
                            <xsl:with-param name="string" select="$niemelementnamevar"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="concat('A data item for ', $e)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="docchange" select="$segment_changes/Element[@mtfname = $mtfroot][@niemname = '']"/>
        <xsl:variable name="contxtchange" select="$segment_changes/Element[@mtfname = $mtfroot][@segmentname = $segmentname]"/>
        <xsl:variable name="namechange" select="$segment_changes/Element[@mtfname = $mtfroot][@changename]"/>
        <xsl:variable name="niemelementdocvar">
            <xsl:choose>
                <xsl:when test="$segmentnamevar and $docchange/@niemelementdoc">
                    <xsl:value-of select="$docchange/@niemelementdoc"/>
                </xsl:when>
                <xsl:when test="$segmentnamevar and $contxtchange/@niemelementdoc">
                    <xsl:value-of select="$contxtchange/@niemelementdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$niemdocvar"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemtypedocvar" select="replace($niemelementdocvar, 'A data item', 'A data type')"/>
        <xsl:variable name="typeappinfo">
            <xsl:for-each select="$typeannot/*/info">
                <xsl:copy-of select="*:Field" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="fappinfo">
            <xsl:apply-templates select="*:annotation/*:appinfo"/>
        </xsl:variable>
        <xsl:variable name="DistStmnt">
            <xsl:choose>
                <xsl:when test="$niemmatch/info/*/@dist = 'A'">
                    <xsl:text>DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use. Other requests for this document shall be
   referred to Defense Information Systems Agency Interoperability Directorate. WARNING - This document contains technical data whose export is restricted by the Arms Export Control Act (Title 22,
   U.S.C., Sec. 2751) or the Export Administration Act of 1979, as amended, Title 50, U.S.C., App. 2401. Violations of these export laws are subject to severe criminal penalties. Disseminate in
   accordance with provisions of DOD Directive 5230.25.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Version">
            <xsl:choose>
                <xsl:when test="$niemmatch/*/info/*/@version">
                    <xsl:value-of select="$niemmatch/*/info/*/@version"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>C.0.01.00</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Date">
            <xsl:choose>
                <xsl:when test="$niemmatch/*/info/*/@versiondate">
                    <xsl:value-of select="$niemmatch/*/info/*/@versiondate"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>October 2018</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="Remark">
            <xsl:choose>
                <xsl:when test="$niemmatch/*/info/*/@remark">
                    <xsl:value-of select="$niemmatch/*/info/*/@remark"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Created by ICP M2018-02</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/info/*">
                <xsl:copy>
                    <xsl:for-each select="@*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:attribute name="version">
                        <xsl:value-of select="$Version"/>
                    </xsl:attribute>
                    <xsl:attribute name="date">
                        <xsl:value-of select="$Date"/>
                    </xsl:attribute>
                    <xsl:attribute name="remark">
                        <xsl:value-of select="$Remark"/>
                    </xsl:attribute>
                    <!--<xsl:attribute name="doddist">
                        <xsl:choose>
                            <xsl:when test="$niemmatch/*/info/*/@dist = 'A'">
                                <xsl:text>DoD-Dist-A</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>DoD-Dist-C</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>-->
                    <!-- <xsl:attribute name="diststatement">
                        <xsl:value-of select="$DistStmnt"/>
                    </xsl:attribute>-->
                </xsl:copy>
            </xsl:for-each>
        </xsl:variable>
        <Element niemelementname="{$niemelementnamevar}" niemtype="{$niemtypevar}" mtfname="{@name}" mtfdoc="{$mtfdocvar}" niemtypedoc="{$niemtypedocvar}"
            niemelementdoc="{$niemelementdocvar}">
            <xsl:for-each select="@*[not(name() = 'name')]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:if test="string-length($sbstgrp) &gt; 0">
                <xsl:attribute name="substitutiongroup">
                    <xsl:value-of select="concat($sbstgrp, 'Abstract')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($fixedval) &gt; 0">
                <xsl:attribute name="fixed">
                    <xsl:value-of select="$fixedval"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($segmentnamevar) &gt; 0">
                <xsl:attribute name="segmentname">
                    <xsl:value-of select="$segmentnamevar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($messagenamevar) &gt; 0">
                <xsl:attribute name="messagename">
                    <xsl:value-of select="$messagenamevar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($mtfbase) &gt; 0">
                <xsl:attribute name="mtftype">
                    <xsl:value-of select="$mtfbase"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($mtftypedoc) &gt; 0">
                <xsl:attribute name="mtftypedoc">
                    <xsl:value-of select="$mtftypedoc"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($setidvar) &gt; 0">
                <xsl:attribute name="identifier">
                    <xsl:value-of select="$setidvar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($ffirnfud) &gt; 0">
                <xsl:attribute name="ffirnfud">
                    <xsl:value-of select="$ffirnfud"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($ffirnvar) &gt; 0">
                <xsl:attribute name="ffirn">
                    <xsl:value-of select="$ffirnvar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($fudvar) &gt; 0">
                <xsl:attribute name="fud">
                    <xsl:value-of select="$fudvar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($niemelementdocvar) &gt; 0">
                <xsl:attribute name="niemelementdoc">
                    <xsl:value-of select="$niemelementdocvar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($niemtypevar) &gt; 0">
                <xsl:attribute name="niemtype">
                    <xsl:value-of select="$niemtypevar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($niemtypedocvar) &gt; 0">
                <xsl:attribute name="niemtypedoc">
                    <xsl:value-of select="$niemtypedocvar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($UseDesc) &gt; 0">
                <xsl:attribute name="usage">
                    <xsl:value-of select="$UseDesc"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($setseq) &gt; 0">
                <xsl:attribute name="setseq">
                    <xsl:value-of select="$setseq"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($segseq) &gt; 0">
                <xsl:attribute name="segseq">
                    <xsl:value-of select="$segseq"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($fieldseq) &gt; 0">
                <xsl:attribute name="fieldseq">
                    <xsl:value-of select="$fieldseq"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="string-length($setnamevar) &gt; 0">
                    <xsl:attribute name="setname">
                        <xsl:value-of select="$setnamevar"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="string-length($segmentnamevar) &gt; 0">
                    <xsl:attribute name="segmentname">
                        <xsl:value-of select="$segmentnamevar"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="string-length($messagenamevar) &gt; 0">
                    <xsl:attribute name="messagename">
                        <xsl:value-of select="$messagenamevar"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <info>
                <xsl:if test="$niemelementnamevar = 'UnformattedFreeText'">
                    <inf:Field positionName="FREE TEXT"/>
                </xsl:if>
                <xsl:if test="ends-with($niemelementnamevar,'GeneralTextSubjectText')">
                    <inf:Field positionName="SUBJECT TEXT" fixed="{$fixedval}"/>
                </xsl:if>
                <xsl:for-each select="$appinfovar/*">
                    <xsl:copy>
                        <xsl:if test="not(@name) and not(@positionName) or @positionName = ''">
                            <xsl:variable name="pn">
                                <xsl:call-template name="breakIntoWords">
                                    <xsl:with-param name="string">
                                        <xsl:choose>
                                            <xsl:when test="ends-with($niemelementnamevar, 'Text')">
                                                <xsl:value-of select="substring($niemelementnamevar, 0, string-length($niemelementnamevar) - 3)"/>
                                            </xsl:when>
                                            <xsl:when test="ends-with($niemelementnamevar, 'Numeric')">
                                                <xsl:value-of select="substring($niemelementnamevar, 0, string-length($niemelementnamevar) - 6)"/>
                                            </xsl:when>
                                            <xsl:when test="ends-with($niemelementnamevar, 'Code')">
                                                <xsl:value-of select="substring($niemelementnamevar, 0, string-length($niemelementnamevar) - 3)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$niemelementnamevar"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:attribute name="positionName">
                                <xsl:value-of select="upper-case($pn)"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:for-each select="@*">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                        <xsl:if test="string-length($TextIndicator) &gt; 0">
                            <xsl:attribute name="textindicator">
                                <xsl:value-of select="$TextIndicator"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($setidvar) &gt; 0">
                            <xsl:attribute name="setid">
                                <xsl:value-of select="$setidvar"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($ffirnvar) &gt; 0">
                            <xsl:attribute name="ffirn">
                                <xsl:value-of select="$ffirnvar"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($fudvar) &gt; 0">
                            <xsl:attribute name="fud">
                                <xsl:value-of select="$fudvar"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($ffirnfud) &gt; 0">
                            <xsl:attribute name="identifier">
                                <xsl:value-of select="$ffirnfud"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($setseq) &gt; 0">
                            <xsl:attribute name="setseq">
                                <xsl:value-of select="$setseq"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($segseq) &gt; 0">
                            <xsl:attribute name="segseq">
                                <xsl:value-of select="$segseq"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($fieldseq) &gt; 0">
                            <xsl:attribute name="fieldseq">
                                <xsl:value-of select="$fieldseq"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:copy>
                </xsl:for-each>
            </info>
            <xsl:if test="$typeappinfo/*">
                <typeinfo>
                    <xsl:for-each select="$typeappinfo">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </typeinfo>
            </xsl:if>
            <xsl:apply-templates select="*[not(contains(name(), ':annotation'))]">
                <xsl:with-param name="settypevar" select="$settypevar"/>
                <xsl:with-param name="segmentnamevar" select="$segmentnamevar"/>
                <xsl:with-param name="messagenamevar" select="$messagenamevar"/>
            </xsl:apply-templates>
        </Element>

    </xsl:template>

    <!--  Choice / Substitution Groups Map -->
    <xsl:template match="*:element[*:complexType/*:choice]">
        <xsl:param name="settypevar"/>
        <xsl:param name="segmentnamevar"/>
        <xsl:param name="messagenamevar"/>
        <xsl:variable name="mtfnamevar" select="@name"/>
        <xsl:variable name="mtftypevar">
            <xsl:value-of select="*:complexType/*/*:extension/@base"/>
        </xsl:variable>
        <xsl:variable name="settypevar">
            <xsl:apply-templates select="ancestor::*:complexType[@name][1]/@name" mode="txt"/>
        </xsl:variable>
        <xsl:variable name="setnamevar">
            <xsl:value-of select="substring($settypevar, 0, string-length($settypevar) - 3)"/>
        </xsl:variable>
        <xsl:variable name="parentnamevar">
            <xsl:choose>
                <xsl:when test="ancestor::*:element[@name][not(@name = 'GroupOfFields')]/@name">
                    <xsl:value-of select="ancestor::*:element[@name][not(@name = 'GroupOfFields')][1]/@name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="ancestor::*[@name][not(@name = 'GroupOfFields')][1]/@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelvar">
            <xsl:choose>
                <xsl:when test="$substGrp_Changes/*[@mtfname = $mtfnamevar][@mtftype = $mtftypevar][@setname = $setnamevar]/@niemname">
                    <xsl:value-of select="$substGrp_Changes/*[@mtfname = $mtfnamevar][@mtftype = $mtftypevar][@setname = $setnamevar]/@niemname"/>
                </xsl:when>
                <xsl:when test="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@setname = $settypevar]/@niemname">
                    <xsl:value-of select="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@setname = $settypevar]/@niemname"/>
                </xsl:when>
                <xsl:when test="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@segmentname = $segmentnamevar]/@niemname">
                    <xsl:value-of select="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@segmentname = $segmentnamevar]/@niemname"/>
                </xsl:when>
                <xsl:when test="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@messagename = $messagenamevar]/@niemname">
                    <xsl:value-of select="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@messagename = $messagenamevar]/@niemname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfnamevar"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementnamevar" select="concat($niemelvar, 'AlternativeContent')"/>
        <xsl:variable name="niemtypevar" select="concat($niemelvar, 'AlternativeContentType')"/>
        <xsl:variable name="annot">
            <xsl:apply-templates select="*:annotation"/>
        </xsl:variable>
        <xsl:variable name="typeannot">
            <xsl:apply-templates select="*:element[1]/*/*:extension/*:annotation"/>
        </xsl:variable>
        <xsl:variable name="mtftypedoc">
            <xsl:value-of select="$typeannot/*:documentation"/>
        </xsl:variable>
        <xsl:variable name="mtfdocvar">
            <xsl:choose>
                <xsl:when test="starts-with($annot/*/*:documentation, 'A data type')">
                    <xsl:value-of select="$annot/*/*:documentation"/>
                </xsl:when>
                <xsl:when test="$annot/*/*:documentation">
                    <xsl:value-of select="concat('A data type for ', replace($annot/*/*:documentation, 'The', 'the'))"/>
                </xsl:when>
                <xsl:when test="$typeannot/*/*:documentation">
                    <xsl:value-of select="replace($typeannot/*/*:documentation, 'A data type', 'A data item')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($annot/*/*:documentation)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementdocvar">
            <xsl:choose>
                <xsl:when test="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemelementdoc">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemelementdoc"/>
                </xsl:when>
                <xsl:when test="$annot/*/*:documentation and contains($niemelementnamevar, 'Name')">
                    <xsl:value-of select="replace($mtfdocvar, 'A data type ', 'A data item for the name ')"/>
                </xsl:when>
                <xsl:when test="$annot/*/*:documentation">
                    <xsl:value-of select="replace($mtfdocvar, 'A data type ', 'A data item ')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemtypedocvar">
            <xsl:choose>
                <xsl:when test="starts-with($mtfdocvar, 'A data type')">
                    <xsl:value-of select="$mtfdocvar"/>
                </xsl:when>
                <xsl:when test="$annot/*/*:documentation">
                    <xsl:apply-templates select="concat('A data type for ', lower-case($annot/*/*:documentation))" mode="normlize"/>
                </xsl:when>
                <xsl:when test="$typeannot/*/*:documentation">
                    <xsl:apply-templates select="replace($typeannot/*/*:documentation, 'A data type', 'A data item')" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$annot/*/*:documentation" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="fieldseq">
            <xsl:choose>
                <xsl:when test="*:complexType/*:attribute[@name = 'ffSeq']">
                    <xsl:value-of select="*:complexType/*:attribute[@name = 'ffSeq'][1]/@fixed"/>
                </xsl:when>
                <xsl:when test="*:complexType/*:simpleContent/*:extension/*:attribute[@name = 'ffSeq']">
                    <xsl:value-of select="*:complexType/*:simpleContent/*:extension/*:attribute[@name = 'ffSeq'][1]/@fixed"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="segseq">
            <xsl:value-of select="*:complexType/*:attribute[@name = 'segSeq'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="setseq">
            <xsl:value-of select="*:complexType/*:complexContent/*:extension/*:attribute[@name = 'setSeq'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/info">
                <xsl:copy-of select="*:Field" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="setnamevar">
            <xsl:value-of select="ancestor::*:complexType[@name]/@name"/>
        </xsl:variable>
        <xsl:variable name="segmentnamevar">
            <xsl:value-of select="ancestor::*:element[*:annotation/*:documentation/*:appinfo/*:SegmentStructureName]/@name"/>
        </xsl:variable>
        <xsl:variable name="msgnamevar">
            <xsl:value-of select="ancestor::*:element[*:annotation/*:documentation/*:appinfo/MtfName]/@name"/>
        </xsl:variable>
        <xsl:variable name="substgrpnamevar">
            <xsl:choose>
                <xsl:when test="string-length($substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@setname = $settypevar]/@niemname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@setname = $settypevar]/@niemname"/>
                </xsl:when>
                <xsl:when test="string-length($substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@setname = '']/@niemname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@setname = '']/@niemname"/>
                </xsl:when>
                <xsl:when test="string-length($substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@segmentname = $segmentnamevar]/@niemname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@segmentname = $segmentnamevar]/@niemname"/>
                </xsl:when>
                <xsl:when test="string-length($substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@segmentname = '']/@niemname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@segmentname = '']/@niemname"/>
                </xsl:when>
                <xsl:when test="string-length($substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@smessagename = $messagenamevar]/@niemname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@messagename = $messagenamevar]/@niemname"/>
                </xsl:when>
                <xsl:when test="string-length($substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@messagenamevar = '']/@niemname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@messagenamevar = '']/@niemname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$niemelvar"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="substgrpdocvar">
            <xsl:choose>
                <xsl:when test="$niemelementdocvar">
                    <xsl:value-of select="concat('A data concept for a choice of ', lower-case($niemelementdocvar))"/>
                </xsl:when>
                <xsl:when test="$substgrpnamevar">
                    <xsl:variable name="splitname">
                        <xsl:call-template name="breakIntoWords">
                            <xsl:with-param name="string" select="$substgrpnamevar"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="concat('A data concept for a substitution group for ', lower-case($splitname))"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="substgrpniemdoc">
            <xsl:choose>
                <xsl:when test="starts-with($substgrpdocvar, 'A data concept for')">
                    <xsl:value-of select="$substgrpdocvar"/>
                </xsl:when>
                <xsl:when test="string-length($substgrpdocvar) &gt; 0">
                    <xsl:value-of select="concat('A data concept for a substitution group for ', lower-case($substgrpdocvar))"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <Element mtfname="{@name}" niemelementname="{$niemelementnamevar}" niemtype="{$niemtypevar}">
            <xsl:for-each select="@*[not(name() = 'name')]">
                <xsl:copy-of select="." copy-namespaces="no"/>
            </xsl:for-each>
            <xsl:if test="string-length($settypevar) &gt; 0">
                <xsl:attribute name="setname">
                    <xsl:value-of select="$settypevar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($mtfdocvar) &gt; 0">
                <xsl:attribute name="mtfdoc">
                    <xsl:value-of select="$mtfdocvar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($niemelementdocvar) &gt; 0">
                <xsl:attribute name="niemelementdoc">
                    <xsl:value-of select="$niemelementdocvar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($parentnamevar) &gt; 0">
                <xsl:attribute name="parentname">
                    <xsl:value-of select="$parentnamevar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($niemtypedocvar) &gt; 0">
                <xsl:attribute name="niemtypedoc">
                    <xsl:value-of select="$niemtypedocvar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($niemtypedocvar) &gt; 0">
                <xsl:attribute name="niemtypedoc">
                    <xsl:value-of select="$niemtypedocvar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($setseq) &gt; 0">
                <xsl:attribute name="setseq">
                    <xsl:value-of select="$setseq"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($segseq) &gt; 0">
                <xsl:attribute name="segseq">
                    <xsl:value-of select="$segseq"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($fieldseq) &gt; 0">
                <xsl:attribute name="fieldseq">
                    <xsl:value-of select="$fieldseq"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="string-length($setnamevar) &gt; 0">
                    <xsl:attribute name="setname">
                        <xsl:value-of select="$setnamevar"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="string-length($segmentnamevar) &gt; 0">
                    <xsl:attribute name="segmentname">
                        <xsl:value-of select="$segmentnamevar"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="string-length($messagenamevar) &gt; 0">
                    <xsl:attribute name="messagename">
                        <xsl:value-of select="$messagenamevar"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <!--<xsl:copy-of select="$annot"/>-->
            <info>
                <xsl:for-each select="$appinfovar/*">
                    <xsl:copy>
                        <xsl:if test="not(@name) and not(@positionName) or @positionName = ''">
                            <xsl:variable name="pn">
                                <xsl:call-template name="breakIntoWords">
                                    <xsl:with-param name="string">
                                        <xsl:choose>
                                            <xsl:when test="ends-with($niemelementnamevar, 'Text')">
                                                <xsl:value-of select="substring($niemelementnamevar, 0, string-length($niemelementnamevar) - 3)"/>
                                            </xsl:when>
                                            <xsl:when test="ends-with($niemelementnamevar, 'Numeric')">
                                                <xsl:value-of select="substring($niemelementnamevar, 0, string-length($niemelementnamevar) - 6)"/>
                                            </xsl:when>
                                            <xsl:when test="ends-with($niemelementnamevar, 'Code')">
                                                <xsl:value-of select="substring($niemelementnamevar, 0, string-length($niemelementnamevar) - 3)"/>
                                            </xsl:when>
                                            <xsl:when test="ends-with($niemelementnamevar, 'InKOrM')">
                                                <xsl:value-of
                                                    select="concat(substring($niemelementnamevar, 0, string-length($niemelementnamevar) - 5), ' in Thousands or Milllions')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$niemelementnamevar"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:attribute name="positionName">
                                <xsl:value-of select="upper-case($pn)"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:for-each select="@*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                        <xsl:if test="string-length($setseq) &gt; 0">
                            <xsl:attribute name="setseq">
                                <xsl:value-of select="$setseq"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($segseq) &gt; 0">
                            <xsl:attribute name="segseq">
                                <xsl:value-of select="$segseq"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($fieldseq) &gt; 0">
                            <xsl:attribute name="fieldseq">
                                <xsl:value-of select="$fieldseq"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:copy>
                </xsl:for-each>
            </info>
            <Choice substgrpname="{concat($substgrpnamevar,'Abstract')}" substgrpdoc="{$substgrpniemdoc}">
                <xsl:apply-templates select="*:complexType/*:choice/*:element">
                    <xsl:sort select="@name"/>
                    <xsl:with-param name="settypevar" select="$settypevar"/>
                    <xsl:with-param name="segmentnamevar" select="$segmentnamevar"/>
                    <xsl:with-param name="messagenamevar" select="$messagenamevar"/>
                    <xsl:with-param name="sbstgrp">
                        <xsl:value-of select="$substgrpnamevar"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </Choice>
        </Element>
    </xsl:template>
    <xsl:template match="*:element[@name = 'GroupOfFields']">
        <xsl:param name="settypevar"/>
        <xsl:param name="segmentnamevar"/>
        <xsl:param name="messagenamevar"/>
        <xsl:variable name="typ" select="ancestor::*:complexType/@name"/>
        <Sequence name="GroupOfFields">
            <xsl:for-each select="@*">
                <xsl:copy-of select="." copy-namespaces="no"/>
            </xsl:for-each>
            <xsl:attribute name="niemname">
                <xsl:value-of select="concat(substring($typ, 0, string-length($typ) - 3), 'FieldGroup')"/>
            </xsl:attribute>
            <xsl:apply-templates select="*:complexType/*:sequence/*">
                <xsl:with-param name="settypevar" select="$settypevar"/>
                <xsl:with-param name="segmentnamevar" select="$segmentnamevar"/>
                <xsl:with-param name="messagenamevar" select="$messagenamevar"/>
            </xsl:apply-templates>
        </Sequence>
    </xsl:template>
    <!--sets.xsd choice occur in *:element complexType-->
    <xsl:template match="*:complexType/*:choice">
        <xsl:param name="settypevar"/>
        <xsl:param name="segmentnamevar"/>
        <xsl:param name="messagenamevar"/>
        <Choice>
            <xsl:apply-templates select="*">
                <xsl:sort select="@name"/>
                <xsl:with-param name="settypevar" select="$settypevar"/>
                <xsl:with-param name="segmentnamevar" select="$segmentnamevar"/>
                <xsl:with-param name="messagenamevar" select="$messagenamevar"/>
            </xsl:apply-templates>
        </Choice>
    </xsl:template>
    <!--messages.xsd choice occur in sequence-->
    <xsl:template match="*:sequence/*:choice">
        <xsl:param name="settypevar"/>
        <xsl:param name="segmentnamevar"/>
        <xsl:param name="messagenamevar"/>
        <xsl:variable name="msgnamevar">
            <xsl:value-of select="ancestor::*:element[parent::*:schema][1]/@name"/>
        </xsl:variable>
        <xsl:variable name="parentnamevar">
            <xsl:choose>
                <xsl:when test="ends-with(ancestor::*:element[@name][1]/@name, 'Segment')">
                    <xsl:value-of select="ancestor::*:element[@name][1]/@name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(ancestor::*:element[@name][1]/@name, 'Segment')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="segnamevar">
            <xsl:value-of select="ancestor::*:element[*:annotation/*:appinfo/*:SegmentStructureName][1]/@name"/>
        </xsl:variable>
        <xsl:variable name="subname">
            <xsl:value-of select="*:element[@name][1]/@name"/>
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
        <xsl:variable name="substmatch">
            <xsl:choose>
                <xsl:when test="$substGrp_Changes/Choice[@substgrpname = $subgrpname][@parentname = $parentnamevar]">
                    <xsl:copy-of select="$substGrp_Changes/Choice[@substgrpname = $subgrpname][@parentname = $parentnamevar][1]" copy-namespaces="no"/>
                </xsl:when>
                <xsl:when test="$substGrp_Changes/Choice[@substgrpname = $subgrpname][@segmentname = $segnamevar]">
                    <xsl:copy-of select="$substGrp_Changes/Choice[@substgrpname = $subgrpname][@segmentname = $segnamevar][1]" copy-namespaces="no"/>
                </xsl:when>
                <xsl:when test="$substGrp_Changes/Choice[@substgrpname = $subgrpname][@parentname = '']">
                    <xsl:copy-of select="$substGrp_Changes/Choice[@substgrpname = $subgrpname][@parentname = ''][1]"/>
                </xsl:when>
                <xsl:when test="$substGrp_Changes/Choice[@mtfname = $subgrpname][@messagename = $msgnamevar]">
                    <xsl:copy-of select="$substGrp_Changes/Choice[@mtfname = $subgrpname][@messagename = $msgnamevar][1]"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="choicenamevar">
            <xsl:choose>
                <xsl:when test="$substmatch/*/@niemname">
                    <xsl:value-of select="$substmatch/*/@niemname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$subgrpname"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="substgrpdocvar">
            <xsl:choose>
                <xsl:when test="$subname = 'ExerciseOperation'">
                    <xsl:text>A data concept for a choice of Exercise or Operation context.</xsl:text>
                </xsl:when>
                <xsl:when test="$substmatch/*/@substgrpdoc">
                    <xsl:value-of select="concat('A data concept for a substitution group for ', substring-after($substmatch/*/@substgrpdoc, 'A choice of '))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="splitname">
                        <xsl:call-template name="breakIntoWords">
                            <xsl:with-param name="string" select="$subgrpname"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="concat('A data concept for a substitution group for ', lower-case($splitname))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="seq" select="*:element[1]//*:extension[1]/*:attribute[@name = 'setSeq']/@fixed"/>
        <Element substgrpname="{concat($choicenamevar,'Abstract')}" messagename="{$msgnamevar}" parentname="{$parentnamevar}" substgrpdoc="{$substgrpdocvar}">
            <xsl:for-each select="@*[not(name() = 'name')]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <Choice name="{$choicenamevar}">
                <xsl:apply-templates select="*[not(contains(name(), ':annotation'))]">
                    <xsl:sort select="@name"/>
                    <xsl:with-param name="sbstgrp">
                        <xsl:value-of select="$choicenamevar"/>
                    </xsl:with-param>
                    <xsl:with-param name="settypevar" select="$settypevar"/>
                    <xsl:with-param name="segmentnamevar" select="$segmentnamevar"/>
                    <xsl:with-param name="messagenamevar" select="$messagenamevar"/>
                </xsl:apply-templates>
            </Choice>
        </Element>
    </xsl:template>
    <xsl:template match="*:sequence[*:element[1][@name = 'GroupOfFields']][not(*:element[not(@name = 'GroupOfFields')])]">
        <xsl:param name="settypevar"/>
        <xsl:param name="segmentnamevar"/>
        <xsl:param name="messagenamevar"/>
        <xsl:apply-templates select="*">
            <xsl:with-param name="settypevar" select="$settypevar"/>
            <xsl:with-param name="segmentnamevar" select="$segmentnamevar"/>
            <xsl:with-param name="messagenamevar" select="$messagenamevar"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="*:sequence">
        <xsl:param name="settypevar"/>
        <xsl:param name="segmentnamevar"/>
        <xsl:param name="messagenamevar"/>
        <Sequence>
            <xsl:apply-templates select="*">
                <xsl:with-param name="settypevar" select="$settypevar"/>
                <xsl:with-param name="segmentnamevar" select="$segmentnamevar"/>
                <xsl:with-param name="messagenamevar" select="$messagenamevar"/>
            </xsl:apply-templates>
        </Sequence>
    </xsl:template>
    <xsl:template match="*:complexType">
        <xsl:param name="settypevar"/>
        <xsl:param name="segmentnamevar"/>
        <xsl:param name="messagenamevar"/>
        <xsl:apply-templates select="*">
            <xsl:with-param name="settypevar" select="$settypevar"/>
            <xsl:with-param name="segmentnamevar" select="$segmentnamevar"/>
            <xsl:with-param name="messagenamevar" select="$messagenamevar"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="*:simpleContent">
        <xsl:param name="settypevar"/>
        <xsl:param name="segmentnamevar"/>
        <xsl:param name="messagenamevar"/>
        <xsl:apply-templates select="*">
            <xsl:with-param name="settypevar" select="$settypevar"/>
            <xsl:with-param name="segmentnamevar" select="$segmentnamevar"/>
            <xsl:with-param name="messagenamevar" select="$messagenamevar"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="*:complexContent">
        <xsl:param name="settypevar"/>
        <xsl:param name="segmentnamevar"/>
        <xsl:param name="messagenamevar"/>
        <xsl:apply-templates select="*">
            <xsl:with-param name="settypevar" select="$settypevar"/>
            <xsl:with-param name="segmentnamevar" select="$segmentnamevar"/>
            <xsl:with-param name="messagenamevar" select="$messagenamevar"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="*:extension">
        <xsl:param name="settypevar"/>
        <xsl:param name="segmentnamevar"/>
        <xsl:param name="messagenamevar"/>
        <xsl:apply-templates select="*[not(contains(name(), ':annotation'))]">
            <xsl:with-param name="settypevar" select="$settypevar"/>
            <xsl:with-param name="segmentnamevar" select="$segmentnamevar"/>
            <xsl:with-param name="messagenamevar" select="$messagenamevar"/>
        </xsl:apply-templates>
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
                    <xsl:value-of select="$textind"/>
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
                <xsl:text>SecurityAndDefensesRemarksGeneralText</xsl:text>
            </xsl:when>
            <xsl:when test="$n = '48hourOutlookForecast'">
                <xsl:text>FortyEightHourOutlookForecast</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($n, 'GeneralText')"/>
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
        <xsl:value-of select="concat($n, 'HeadingInformation')"/>
    </xsl:template>
    <xsl:template name="niemName">
        <xsl:param name="n"/>
        <xsl:param name="suffix"/>
        <xsl:variable name="sn">
            <xsl:value-of select="$n"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$sn = 'TargetIdentification'">
                <xsl:text>TargetID</xsl:text>
            </xsl:when>
            <xsl:when test="starts-with($sn, 'Gentext')">
                <xsl:value-of select="$sn"/>
            </xsl:when>
            <xsl:when test="ends-with($sn, 'Indicator')">
                <xsl:value-of select="replace($sn, 'Indicator', $suffix)"/>
            </xsl:when>
            <xsl:when test="ends-with($sn, 'Number')">
                <xsl:value-of select="concat(substring($sn, 0, string-length($sn) - 5), $suffix)"/>
            </xsl:when>
            <xsl:when test="ends-with($sn, 'Code')">
                <xsl:value-of select="replace($sn, 'Code', $suffix)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($sn, $suffix)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
