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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:inf="urn:int:nato:ncdf:mtf:appinfo" version="2.0">

    <xsl:include href="NMTF_Utility.xsl"/>
    <xsl:include href="NcdfStrings.xsl"/>
    <xsl:include href="NcdfNumerics.xsl"/>
    <xsl:include href="NcdfCodeLists.xsl"/>

    <xsl:variable name="fieldspath" select="'../../XSD/APP-11C-ch1/Consolidated/fields.xsd'"/>
    <xsl:variable name="compositespath" select="'../../XSD/APP-11C-ch1/Consolidated/composites.xsd'"/>
    <xsl:variable name="setspath" select="'../../XSD/APP-11C-ch1/Consolidated/sets.xsd'"/>
    <xsl:variable name="messagespath" select="'../../XSD/APP-11C-ch1/Consolidated/messages.xsd'"/>

    <xsl:variable name="fieldsxsdoutpath" select="'../../XSD/NCDF_MTF/NCDF_MTF_Fields.xsd'"/>
    <xsl:variable name="compositesxsdoutpath" select="'../../XSD/NCDF_MTF/NCDF_MTF_Composites.xsd'"/>
    <xsl:variable name="setsxsdoutpath" select="'../../XSD/NCDF_MTF/NCDF_MTF_Sets.xsd'"/>
    <xsl:variable name="segmentsxsdoutpath" select="'../../XSD/NCDF_MTF/NCDF_MTF_Segments.xsd'"/>
    <xsl:variable name="messagesxsdoutpath" select="'../../XSD/NCDF_MTF/NCDF_MTF_Messages.xsd'"/>

    <xsl:variable name="fieldsmapoutpath" select="'../../XSD/NCDF_MTF/Maps/NCDF_MTF_Fieldmaps.xml'"/>
    <xsl:variable name="compositesmapoutpath" select="'../../XSD/NCDF_MTF/Maps/NCDF_MTF_Compositemaps.xml'"/>
    <xsl:variable name="setsmapoutpath" select="'../../XSD/NCDF_MTF/Maps/NCDF_MTF_Setmaps.xml'"/>
    <xsl:variable name="segmentsmapoutpath" select="'../../XSD/NCDF_MTF/Maps/NCDF_MTF_Segmntmaps.xml'"/>
    <xsl:variable name="messagesmapoutpath" select="'../../XSD/NCDF_MTF/Maps/NCDF_MTF_Msgsmaps.xml'"/>

    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="lt" select="'&lt;'"/>
    <xsl:variable name="gt" select="'&gt;'"/>
    <xsl:variable name="cm" select="','"/>
    <xsl:variable name="srcdir" select="'../../XSD/'"/>
    
    <!--Baseline-->
    <xsl:variable name="baseline_fields_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/fields.xsd')/*:schema"/>
    <xsl:variable name="baseline_composites_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/composites.xsd')/*:schema"/>
    <xsl:variable name="baseline_sets_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/sets.xsd')/*:schema"/>
    <xsl:variable name="baseline_msgs_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/messages.xsd')/*:schema"/>
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
    <xsl:variable name="ncdf_fields_map">
        <xsl:for-each select="$strings/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$numerics/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$codelists/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="all_field_elements_map">
        <xsl:copy-of select="$ncdf_fields_map"/>
        <xsl:for-each select="$ncdf_composites_map//Element[starts-with(@mtftype, 'f:') or info/inf:Field]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$ncdf_sets_map//Element[starts-with(@mtftype, 'f:') or info/inf:Field]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$ncdf_sets_map//Choice[Element[starts-with(@mtftype, 'f:') or Element/info/inf:Field]]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$ncdf_segments_map//Element[starts-with(@mtftype, 'f:') or info/inf:Field]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$ncdf_messages_map//Element[starts-with(@mtftype, 'f:') or info/inf:Field]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="ncdf_composites_map">
        <xsl:for-each select="$baseline_composites_xsd/*:complexType">
            <xsl:variable name="annot">
                <xsl:apply-templates select="*:annotation"/>
            </xsl:variable>
            <xsl:variable name="mtfname" select="@name"/>
            <xsl:variable name="change" select="$comp_changes/CompositeTypeChanges/Composite[@name = $mtfname]"/>
            <xsl:variable name="n">
                <xsl:apply-templates select="@name" mode="fromtype"/>
            </xsl:variable>
            <xsl:variable name="ncdfname">
                <xsl:choose>
                    <xsl:when test="$change/@ncdfelementname">
                        <xsl:value-of select="$change/@ncdfelementname"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$n"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ncdfcomplextype">
                <xsl:value-of select="concat($n, 'Type')"/>
            </xsl:variable>
            <xsl:variable name="ncdfelementname">
                <xsl:value-of select="$ncdfname"/>
            </xsl:variable>
            <xsl:variable name="mtfdoc">
                <xsl:apply-templates select="$annot/*/*:documentation" mode="normlize"/>
            </xsl:variable>
            <xsl:variable name="ncdftypedoc">
                <xsl:choose>
                    <xsl:when test="$change/@ncdftypedoc">
                        <xsl:value-of select="$change/@ncdftypedoc"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('A data type for ', lower-case($mtfdoc))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ncdfelementdoc">
                <xsl:choose>
                    <xsl:when test="$change/@ncdftypedoc">
                        <xsl:value-of select="replace($change/@ncdftypedoc, 'A data type', 'A data item')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace($ncdftypedoc, 'A data type', 'A data item')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="annot">
                <xsl:apply-templates select="*:annotation"/>
            </xsl:variable>
            <xsl:variable name="appinfo">
                <xsl:for-each select="$annot/*/info">
                    <inf:Composite>
                        <xsl:for-each select="*:Field/@*">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </inf:Composite>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="seq_fields">
                <xsl:for-each select="*:sequence/*:element">
                    <xsl:variable name="n">
                        <xsl:apply-templates select="@name" mode="txt"/>
                    </xsl:variable>
                    <xsl:variable name="mtftypevar">
                        <xsl:choose>
                            <xsl:when test="contains(@type, ':')">
                                <xsl:value-of select="substring-after(@type, ':')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@type"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="ncdfmatch" select="$ncdf_fields_map/*[@mtftype = $mtftypevar]"/>
                    <xsl:variable name="ncdftypevar">
                        <xsl:choose>
                            <xsl:when test="$n = 'BlankSpace'">
                                <xsl:text>BlankSpaceTextType</xsl:text>
                            </xsl:when>
                            <xsl:when test="starts-with(@type, 'f:')">
                                <xsl:value-of select="$ncdfmatch/@ncdftype"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$mtftypevar"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="field_chg" select="$field_changes/*/*[@name = $n]"/>
                    <xsl:variable name="comp_chg" select="$comp_changes/CompositeTypeChanges/Element[@mtfname = $n][@mtftype = $mtftypevar]"/>
                    <xsl:variable name="seqncdfelementname">
                        <xsl:choose>
                            <xsl:when test="$field_chg/@ncdfelementname">
                                <xsl:value-of select="$field_chg/@ncdfelementname"/>
                            </xsl:when>
                            <xsl:when test="$comp_chg/@ncdfelementname">
                                <xsl:value-of select="$comp_chg/@ncdfelementname"/>
                            </xsl:when>
                            <xsl:when test="ends-with($ncdftypevar, 'TextType') and not(ends-with($n, 'Text'))">
                                <xsl:value-of select="concat($n, 'Text')"/>
                            </xsl:when>
                            <xsl:when test="ends-with($ncdftypevar, 'NumericType') and not(ends-with($n, 'Numeric'))">
                                <xsl:value-of select="concat($n, 'Numeric')"/>
                            </xsl:when>
                            <xsl:when test="ends-with($ncdftypevar, 'CodeType') and not(ends-with($n, 'Code'))">
                                <xsl:value-of select="concat($n, 'Code')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$n"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="annot">
                        <xsl:apply-templates select="*:annotation"/>
                    </xsl:variable>
                    <xsl:variable name="tpyeannot">
                        <xsl:apply-templates select="$ncdfmatch/*/*:annotation"/>
                    </xsl:variable>
                    <Element mtfname="{$n}" mtftype="{@type}" ncdftype="{$ncdftypevar}" ncdfelementname="{$seqncdfelementname}">
                        <xsl:for-each select="@*[not(name() = 'name')]">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                        <xsl:attribute name="ncdfelementdoc">
                            <xsl:choose>
                                <xsl:when test="$n = 'BlankSpace'">
                                    <xsl:text>A data type for a blank space character that is used to separate elements within a data chain, or to mark the beginning or end of a unit of data.</xsl:text>
                                </xsl:when>
                                <xsl:when test="$comp_changes/CompositeTypeChanges/Element[@mtfname = $n][@mtftype = $mtftypevar]/@ncdfelementdoc">
                                    <xsl:value-of select="$comp_changes/CompositeTypeChanges/Element[@name = $n][@mtftype = $mtftypevar]/@ncdfelementdoc"/>
                                </xsl:when>
                                <xsl:when test="$ncdf_fields_map/*[@mtftype = $mtftypevar]/@ncdfelementdoc">
                                    <xsl:value-of select="$ncdf_fields_map/*[@mtftype = $mtftypevar]/@ncdfelementdoc"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="seq">
                            <xsl:value-of select="*:annotation/*:appinfo/*:ElementalFfirnFudnSequence"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$annot/info">
                                <xsl:copy-of select="$annot/info"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="$tpyeannot/info"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </Element>
                </xsl:for-each>
            </xsl:variable>
            <Composite ncdfelementname="{$ncdfelementname}" ncdftype="{$ncdfcomplextype}" ncdfname="{$ncdfname}" ncdfelementdoc="{$ncdfelementdoc}" mtfdoc="{$mtfdoc}" ncdftypedoc="{$ncdftypedoc}"
                mtfname="{@name}">
                <info>
                    <xsl:for-each select="$appinfo">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </info>
                <Sequence>
                    <xsl:for-each select="$seq_fields">
                        <xsl:copy-of select="Element"/>
                    </xsl:for-each>
                </Sequence>
            </Composite>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="all_composite_elements_map">
        <xsl:copy-of select="$ncdf_composites_map"/>
        <xsl:for-each select="$ncdf_sets_map//Element[starts-with(@mtftype, 'c:') or info/inf:Composite]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$ncdf_sets_map//Choice[Element[starts-with(@mtftype, 'c:') or Element/info/inf:Composite]]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$ncdf_segments_map//Element[starts-with(@mtftype, 'c:') or info/inf:Composite]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$ncdf_messages_map//Element[starts-with(@mtftype, 'c:') or info/inf:Composite]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="ncdf_sets_map">
        <xsl:apply-templates select="$baseline_sets_xsd/*:complexType" mode="setglobal"/>
    </xsl:variable>
    <xsl:variable name="all_set_elements_map">
        <xsl:for-each select="$ncdf_sets_map//Element">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$ncdf_segments_map//Element[starts-with(@mtftype, 's:') or info/inf:Set or starts-with(Choice/Element[1]/@mtftype, 's:')]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$ncdf_messages_map//Element[starts-with(@mtftype, 's:') or info/inf:Set or starts-with(Choice/Element[1]/@mtftype, 's:')]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="ncdf_segments_map">
        <xsl:apply-templates select="$baseline_segments_xsd" mode="segmentglobal"/>
    </xsl:variable>
    <xsl:variable name="all_segment_elements_map">
        <xsl:for-each select="$ncdf_segments_map//Element[info/inf:Segment]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$ncdf_messages_map//Element[info/inf:Segment]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="ncdf_messages_map">
        <xsl:apply-templates select="$baseline_msgs_xsd/*" mode="messageglobal"/>
    </xsl:variable>

    <xsl:template name="map">
        <xsl:result-document href="{$fieldsmapoutpath}">
            <Fields>
                <xsl:for-each select="$all_field_elements_map/*">
                    <xsl:sort select="@ncdfelementname"/>
                    <xsl:if test="string-length(@ncdftype) &gt; 0 and name() = 'Field'">
                        <xsl:variable name="n" select="@ncdfelementname"/>
                        <xsl:variable name="t" select="@ncdftype"/>
                        <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all_field_elements_map/*">
                    <xsl:sort select="@ncdfelementname"/>
                    <xsl:if test="string-length(@ncdftype) &gt; 0 and name() = 'Element'">
                        <xsl:variable name="n" select="@ncdfelementname"/>
                        <xsl:variable name="t" select="@ncdftype"/>
                        <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </Fields>
        </xsl:result-document>
        <xsl:result-document href="{$compositesmapoutpath}">
            <Composites>
                <xsl:for-each select="$all_composite_elements_map/*">
                    <xsl:sort select="@ncdfelementname"/>
                    <xsl:if test="string-length(@ncdftype) &gt; 0 and name() = 'Composite'">
                        <xsl:variable name="n" select="@ncdfelementname"/>
                        <xsl:variable name="t" select="@ncdftype"/>
                        <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all_composite_elements_map/*">
                    <xsl:sort select="@ncdfelementname"/>
                    <xsl:if test="string-length(@ncdftype) &gt; 0 and name() = 'Element'">
                        <xsl:variable name="n" select="@ncdfelementname"/>
                        <xsl:variable name="t" select="@ncdftype"/>
                        <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </Composites>
        </xsl:result-document>
        <xsl:result-document href="{$setsmapoutpath}">
            <Sets>
                <xsl:for-each select="$all_set_elements_map/*">
                    <xsl:sort select="@ncdfelementname"/>
                    <xsl:if test="string-length(@ncdftype) &gt; 0 and name() = 'Set'">
                        <xsl:variable name="n" select="@ncdfelementname"/>
                        <xsl:variable name="t" select="@ncdftype"/>
                        <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all_set_elements_map/*">
                    <xsl:sort select="@ncdfelementname"/>
                    <xsl:if test="string-length(@ncdftype) &gt; 0 and name() = 'Element'">
                        <xsl:variable name="n" select="@ncdfelementname"/>
                        <xsl:variable name="t" select="@ncdftype"/>
                        <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </Sets>
        </xsl:result-document>
        <xsl:result-document href="{$segmentsmapoutpath}">
            <Segments>
                <xsl:for-each select="$ncdf_segments_map/*">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </Segments>
        </xsl:result-document>
        <xsl:result-document href="{$messagesmapoutpath}">
            <Messages>
                <xsl:for-each select="$ncdf_messages_map/*">
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
        <xsl:variable name="change" select="$set_changes/Set[@mtfname = $mtfname]"/>
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="fromtype"/>
        </xsl:variable>
        <xsl:variable name="ncdfelementnamevar">
            <xsl:choose>
                <xsl:when test="$change/@ncdfelementname">
                    <xsl:value-of select="$change/@ncdfelementname"/>
                </xsl:when>
                <xsl:when test="$mtfname = 'SetBaseType'">
                    <xsl:text>SetBase</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($n, 'Set')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfcomplextypevar">
            <xsl:choose>
                <xsl:when test="$change/@ncdfcomplextype">
                    <xsl:value-of select="$change/@ncdfcomplextype"/>
                </xsl:when>
                <xsl:when test="$ncdfelementnamevar = 'SetBase'">
                    <xsl:value-of select="concat($ncdfelementnamevar, 'Type')"/>
                </xsl:when>
                <xsl:when test="ends-with($ncdfelementnamevar, 'Set')">
                    <xsl:value-of select="concat($ncdfelementnamevar, 'Type')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($ncdfelementnamevar, 'SetType')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfdocvar">
            <xsl:apply-templates select="$annot/*/*:documentation" mode="normlize"/>
        </xsl:variable>
        <xsl:variable name="ncdftypedocvar">
            <xsl:choose>
                <xsl:when test="$change/@ncdftypedoc">
                    <xsl:apply-templates select="concat('A data type for the ', replace($change/@ncdftypedoc, 'The', 'the'))" mode="normlize"/>
                </xsl:when>
                <xsl:when test="starts-with($mtfdocvar, 'A data ')">
                    <xsl:apply-templates select="$mtfdocvar" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="concat('A data type for the ', $mtfdocvar)" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfelementdocvar">
            <xsl:apply-templates select="replace($ncdftypedocvar, 'A data type', 'A data item')" mode="normlize"/>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/info">
                <xsl:copy-of select="*:Set" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <Set ncdfelementname="{$ncdfelementnamevar}" ncdftype="{$ncdfcomplextypevar}" ncdfelementdoc="{$ncdfelementdocvar}" mtfname="{@name}" mtfdoc="{$mtfdocvar}" ncdftypedoc="{$ncdftypedocvar}">
            <info>
                <xsl:for-each select="$appinfovar">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </info>
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
        <xsl:variable name="changename" select="$segment_changes/*[@mtfname = $mtfname]"/>
        <xsl:variable name="ncdfelementnamevar">
            <xsl:choose>
                <xsl:when test="$changename/@ncdfelementname">
                    <xsl:value-of select="$changename/@ncdfelementname"/>
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
        <xsl:variable name="ncdfcomplextype">
            <xsl:choose>
                <xsl:when test="$changename/@ncdfcomplextype">
                    <xsl:value-of select="$changename/@ncdfcomplextype"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($ncdfelementnamevar, 'Type')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="changedoc" select="$segment_changes/Segment[@mtfname = $mtfname][@ncdfcomplextype = $ncdfcomplextype]"/>
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
        <xsl:variable name="ncdftypedocvar">
            <xsl:choose>
                <xsl:when test="$changedoc/@ncdftypedoc">
                    <xsl:apply-templates select="$changedoc/@ncdftypedoc" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="concat('A data type that ', lower-case($mtfdoc))" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfelementdocvar">
            <xsl:choose>
                <xsl:when test="$changedoc/@ncdfelementdoc">
                    <xsl:apply-templates select="$changedoc/@ncdfelementdoc" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="replace($ncdftypedocvar, 'A data type', 'A data item')" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/info">
                <xsl:copy-of select="*:Segment" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <Segment ncdfelementname="{$ncdfelementnamevar}" ncdftype="{$ncdfcomplextype}" ncdfelementdoc="{$ncdfelementdocvar}" mtfname="{@name}" messagename="{$messagename}" mtfdoc="{$mtfdoc}"
            ncdftypedoc="{$ncdftypedocvar}">
            <xsl:if test="string-length($segseq) &gt; 0">
                <xsl:attribute name="segseq">
                    <xsl:value-of select="$segseq"/>
                </xsl:attribute>
            </xsl:if>
            <info>
                <xsl:for-each select="$appinfovar/*">
                    <xsl:copy-of select="."/>
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
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/info">
                <xsl:copy-of select="*" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="mtfnamevar" select="@name"/>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="ncdfelementnamevar">
            <xsl:choose>
                <xsl:when test="$message_changes/Element[@messagename = $mtfnamevar]/@niemelementname">
                    <xsl:value-of select="$message_changes/Element[@messagename = $mtfnamevar]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$message_changes/Element[@mtfname = $mtfnamevar][@messagename = '']/@ncdfelementname">
                    <xsl:value-of select="$message_changes/Element[@mtfname = $mtfnamevar][@messagename = '']/@ncdfelementname"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Message')">
                    <xsl:value-of select="$n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($n, 'Message')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfcomplextype">
            <xsl:value-of select="concat($ncdfelementnamevar, 'Type')"/>
        </xsl:variable>
        <xsl:variable name="mtfdoc">
            <xsl:choose>
                <xsl:when test="*:annotation/*:documentation">
                    <xsl:apply-templates select="*:annotation/*:documentation" mode="normlize"/>
                </xsl:when>
                <!--Use purpose for documentaton-->
                <xsl:when test="$appinfovar/*/@purpose">
                    <xsl:variable name="p">
                        <xsl:value-of select="substring($appinfovar/*/@purpose, 1, 1)"/>
                        <xsl:value-of select="lower-case(substring($appinfovar/*/@purpose, 2))"/>
                    </xsl:variable>
                    <xsl:apply-templates select="$p" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$annot/*/*:documentation" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfid">
            <xsl:value-of select="*:complexType/*:attribute[@name = 'mtfid'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="ncdftypedocvar">
            <xsl:choose>
                <xsl:when test="$message_changes/Element[@mtfname = $mtfnamevar][@ncdfname = $ncdfelementnamevar]/@ncdftypedoc">
                    <xsl:apply-templates select="concat('A data type for the', $message_changes/Element[@mtfname = $mtfnamevar][@ncdfname = $ncdfelementnamevar]/@ncdftypedoc, 'The')" mode="normlize"/>
                </xsl:when>
                <xsl:when test="starts-with($mtfdoc, 'A data type')">
                    <xsl:value-of select="$mtfdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="concat('A data type for the', substring-after($mtfdoc, 'The'))" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfelementdocvar">
            <xsl:choose>
                <xsl:when test="$message_changes/Element[@mtfname = $mtfnamevar][@ncdfname = $ncdfelementnamevar]/@ncdfelementdoc">
                    <xsl:apply-templates select="$message_changes/Element[@mtfname = $mtfnamevar][@ncdfname = $ncdfelementnamevar]/@ncdfelementdoc" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="replace($ncdftypedocvar, 'A data type', 'A data item')" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Message ncdfelementname="{$ncdfelementnamevar}" ncdftype="{$ncdfcomplextype}" ncdfelementdoc="{$ncdfelementdocvar}" mtfname="{@name}" mtfid="{$mtfid}" mtfdoc="{$mtfdoc}"
            ncdftypedoc="{$ncdftypedocvar}">
            <info>
                <xsl:for-each select="$appinfovar/*">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </info>
            <xsl:apply-templates select="*[not(contains(name(), ':annotation'))]">
                <xsl:with-param name="messagenamevar" select="$mtfnamevar"/>
            </xsl:apply-templates>
        </Message>
    </xsl:template>
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
                <xsl:when test="$segment_changes/Element[@mtfname = $mtfnamevar]">
                    <xsl:value-of select="$mtfnamevar"/>
                </xsl:when>
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
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/info">
                <xsl:copy-of select="*" copy-namespaces="no"/>
            </xsl:for-each>
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
        <xsl:variable name="ncdfmatch">
            <xsl:choose>
                <xsl:when test="$isSet">
                    <xsl:copy-of select="$ncdf_sets_map/Set[@mtftype = $mtftypevar][1]"/>
                </xsl:when>
                <xsl:when test="$isField">
                    <xsl:copy-of select="$ncdf_fields_map/Field[@mtftype = $mtftypevar][1]"/>
                </xsl:when>
                <xsl:when test="$isComposite">
                    <xsl:copy-of select="$ncdf_composites_map/Composite[@mtftype = $mtftypevar][1]"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdftypedocvar">
            <xsl:value-of select="$ncdfmatch/*/@ncdfelementdoc"/>
        </xsl:variable>
        <xsl:variable name="setidvar">
            <xsl:value-of select="$ncdfmatch/*/info/inf:Set/@setid"/>
        </xsl:variable>
        <xsl:variable name="seq">
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
        <xsl:variable name="mtftypedoc">
            <xsl:apply-templates select="$typeannot/*/*:documentation" mode="normlize"/>
        </xsl:variable>
        <xsl:variable name="UseDesc" select="$annot/*/info//@usage"/>
        <xsl:variable name="apos">
            <xsl:text>'</xsl:text>
        </xsl:variable>
        <xsl:variable name="TextIndicator" select="$annot/*/info/inf:Set/@positionName"/>
        <xsl:variable name="ncdftypevar">
            <xsl:choose>
                <xsl:when test="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar]/@ncdftype">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar]/@ncdftype"/>
                </xsl:when>
                <xsl:when test="$segmentnamevar and $segment_changes/Element[@mtfname = $mtfnamevar][1]/@ncdftype">
                    <xsl:value-of select="$segment_changes/Element[@mtfname = $mtfnamevar][1]/@ncdftype"/>
                </xsl:when>
                <xsl:when test="$messagenamevar and $message_changes/Element[@mtfname = $mtfnamevar][1]/@ncdftype">
                    <xsl:value-of select="$message_changes/Element[@mtfname = $mtfnamevar][1]/@ncdftype"/>
                </xsl:when>
                <xsl:when test="ends-with($mtftypevar, 'GeneralTextType')">
                    <xsl:value-of select="concat($mtfnamevar, 'GeneralTextType')"/>
                </xsl:when>
                <xsl:when test="string-length($ncdfmatch//@ncdftype) &gt; 0">
                    <xsl:apply-templates select="$ncdfmatch//@ncdftype" mode="txt"/>
                </xsl:when>
                <xsl:when test="$isSet and $ncdf_sets_map/Set[@mtfname = $mtftypevar]">
                    <xsl:value-of select="$ncdf_sets_map/Set[@mtfname = $mtftypevar]/@ncdftype"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*:complexType/*/*:extension/@base" mode="txt"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfel">
            <xsl:choose>
                <xsl:when test="$isField">
                    <xsl:variable name="set_chg" select="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar]"/>
                    <xsl:choose>
                        <xsl:when test="$field_changes/*[@name = $mtfnamevar][@mtftype = $mtftypevar]">
                            <xsl:value-of select="$field_changes/*[@name = $mtfnamevar][@mtftype = $mtftypevar]/@ncdfelementname"/>
                        </xsl:when>
                        <xsl:when test="$field_changes/*[@name = $mtfnamevar]">
                            <xsl:value-of select="$field_changes/*[@name = $mtfnamevar]/@ncdfelementname"/>
                        </xsl:when>
                        <xsl:when test="$set_chg/@ncdfelementname">
                            <xsl:value-of select="$set_chg/@ncdfelementname"/>
                        </xsl:when>
                        <xsl:when test="ends-with($ncdftypevar, 'GeneralTextType')">
                            <xsl:value-of select="$n"/>
                        </xsl:when>
                        <xsl:when test="ends-with($ncdftypevar, 'TextType') and not(ends-with($n, 'Text'))">
                            <xsl:value-of select="concat($n, 'Text')"/>
                        </xsl:when>
                        <xsl:when test="ends-with($ncdftypevar, 'CodeType') and not(ends-with($mtfnamevar, 'Code'))">
                            <xsl:value-of select="concat($mtfnamevar, 'Code')"/>
                        </xsl:when>
                        <xsl:when test="contains($ncdftypevar, 'Integer') and not(ends-with($mtfnamevar, 'Numeric'))">
                            <xsl:value-of select="concat($mtfnamevar, 'Numeric')"/>
                        </xsl:when>
                        <xsl:when test="contains($ncdftypevar, 'Decimal') and not(ends-with($mtfnamevar, 'Numeric'))">
                            <xsl:value-of select="concat($mtfnamevar, 'Numeric')"/>
                        </xsl:when>
                        <xsl:when test="ends-with($ncdftypevar, 'IndicatorType') and not(ends-with($mtfnamevar, 'Indicator'))">
                            <xsl:value-of select="concat($mtfnamevar, 'Indicator')"/>
                        </xsl:when>
                        <!--<xsl:when test="$ncdfmatch/*/@ncdfelementname">
                            <xsl:value-of select="$ncdfmatch/*/@ncdfelementname"/>
                        </xsl:when>-->
                        <xsl:otherwise>
                            <xsl:value-of select="$mtfnamevar"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$isComposite">
                    <xsl:variable name="comp_chg" select="$comp_changes/CompositeTypeChanges/Composite[@name = $mtfnamevar]"/>
                    <xsl:variable name="set_chg" select="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar]"/>
                    <xsl:choose>
                        <xsl:when test="$comp_chg/@ncdfelementname">
                            <xsl:value-of select="$comp_chg/@ncdfelementname"/>
                        </xsl:when>
                        <xsl:when test="$set_chg/@ncdfelementname">
                            <xsl:value-of select="$set_chg/@ncdfelementname"/>
                        </xsl:when>
                        <!-- <xsl:when test="$ncdfmatch/*/@ncdfelementname">
                            <xsl:value-of select="$ncdfmatch/*/@ncdfelementname"/>
                        </xsl:when>-->
                        <xsl:otherwise>
                            <xsl:value-of select="$mtfnamevar"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$isSegment">
                    <xsl:variable name="seg_chg" select="$segment_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar]"/>
                    <xsl:choose>
                        <xsl:when test="$seg_chg/@ncdfelementname">
                            <xsl:value-of select="$seg_chg/@ncdfelementname"/>
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
                        <xsl:when test="$set_chg/@ncdfelementname">
                            <xsl:value-of select="$set_chg/@ncdfelementname"/>
                        </xsl:when>
                        <xsl:when test="@segmentname">
                            <xsl:value-of select="$mtfnamevar"/>
                        </xsl:when>
                        <xsl:when test="ends-with($mtftypevar, 'GeneralTextType')">
                            <xsl:value-of select="concat($mtfnamevar, 'GeneralText')"/>
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
                <xsl:when test="$ncdfmatch/*/@ncdfelementname">
                    <xsl:value-of select="$ncdfmatch/*/@ncdfelementname"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfelement">
            <xsl:choose>
                <xsl:when test="$sbstgrp">
                    <xsl:choose>
                        <xsl:when test="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $setnamevar]">
                            <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $setnamevar]/@ncdfname"/>
                        </xsl:when>
                        <xsl:when test="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $segmentnamevar]">
                            <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $segmentnamevar]/@ncdfname"/>
                        </xsl:when>
                        <xsl:when test="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $messagenamevar]">
                            <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $messagenamevar]/@ncdfname"/>
                        </xsl:when>
                        <xsl:when test="$substGrp_Element_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]">
                            <xsl:variable name="subgrpchg" select="$substGrp_Element_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]"/>
                            <xsl:variable name="shortSubgrp">
                                <xsl:call-template name="removeStrings">
                                    <xsl:with-param name="targetStr" select="$sbstgrp"/>
                                    <xsl:with-param name="strings" select="$subgrpchg/@filter"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="shortOption" select="$subgrpchg/@shortname"/>
                            <xsl:value-of select="concat($shortSubgrp, $shortOption)"/>
                        </xsl:when>
                        <xsl:when test="$ncdf_composites_map/*[@ncdfelementname = $ncdfel]">
                            <xsl:value-of select="concat($sbstgrp, $ncdfel)"/>
                        </xsl:when>
                        <xsl:when test="$ncdf_fields_map/*[@ncdfelementname = $ncdfel]">
                            <xsl:value-of select="concat($sbstgrp, $ncdfel)"/>
                        </xsl:when>
                        <xsl:when test="@name = $ncdfel">
                            <xsl:value-of select="concat($sbstgrp, @name)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($sbstgrp, $mtfroot)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="string-length($ncdfel) &gt; 0">
                    <xsl:value-of select="$ncdfel"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfnamevar"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfelementnamevar">
            <xsl:choose>
                <!--Use Element Change-->
                <xsl:when test="$segment_changes/Element[@mtfname = $n]/@ncdfelementname">
                    <xsl:value-of select="$segment_changes/Element[@mtfname = $n]/@ncdfelementname"/>
                </xsl:when>
                <!--Use Set Change-->
                <xsl:when test="$settypevar and $set_changes/Element[@mtfname = $mtfnamevar][@setname = $setnamevar][1]/@ncdfelementname">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $setnamevar][1]/@ncdfelementname"/>
                </xsl:when>
                <!--Use Set Field Change-->
                <xsl:when test="$isField and $set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtfbase][1]/@ncdfelementname">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtfbase][1]/@ncdfelementname"/>
                </xsl:when>
                <!--Use Segment Change-->
                <xsl:when test="$isSegment and $segment_changes/Element[@mtfname = $mtfnamevar][1]/@ncdfelementname">
                    <xsl:value-of select="$segment_changes/Element[@mtfname = $mtfnamevar][1]/@ncdfelementname"/>
                </xsl:when>
                <!--Use Message element Change-->
                <xsl:when test="$messagenamevar and $message_changes/Element[@mtfname = $mtfroot][@messagename = $messagenamevar]/@ncdfelementname">
                    <xsl:value-of select="$message_changes/Element[@mtfname = $mtfroot][@messagename = $messagenamevar]/@ncdfelementname"/>
                </xsl:when>
                <!--Use Message Change-->
                <xsl:when test="$messagenamevar and $message_changes/Element[@mtfname = $mtfnamevar]/@ncdfelementname">
                    <xsl:value-of select="$message_changes/Element[@mtfname = $mtfnamevar]/@ncdfelementname"/>
                </xsl:when>
                <!--Use Subsitution group name -->
                <xsl:when test="string-length($sbstgrp) &gt; 0">
                    <xsl:value-of select="$ncdfelement"/>
                </xsl:when>
                <!--Create GenText Name -->
                <xsl:when test="contains($mtftypevar, 'GeneralText')">
                    <xsl:value-of select="concat($mtfnamevar, 'GeneralText')"/>
                </xsl:when>
                <!--Create Heading Information Name -->
                <xsl:when test="starts-with($mtfnamevar, 'HeadingInformation') and not($mtfnamevar = 'HeadingInformation')">
                    <xsl:call-template name="HeadingInformation">
                        <xsl:with-param name="textind" select="$TextIndicator"/>
                    </xsl:call-template>
                </xsl:when>
                <!--Create GenText Name -->
                <xsl:when test="$setidvar = 'GENTEXT'">
                    <xsl:choose>
                        <xsl:when test="contains($ncdfelement, '_')">
                            <xsl:value-of select="concat(substring-before($ncdfelement, '_'), 'GeneralText')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($ncdfelement, 'GeneralText')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!--Remove leading underscore in name -->
                <xsl:when test="starts-with($ncdfelement, '_')">
                    <xsl:apply-templates select="@name" mode="txt"/>
                </xsl:when>
                <!--Remove underscore in name -->
                <xsl:when test="contains($ncdfelement, '_')">
                    <xsl:value-of select="substring-before($ncdfelement, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$ncdfelement"/>
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
        <xsl:variable name="setseq">
            <xsl:value-of select="*:complexType/*:complexContent/*:extension/*:attribute[@name = 'setSeq'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="mtfdocvar">
            <xsl:choose>
                <xsl:when test="$ncdfmatch/*/@mtfdoc">
                    <xsl:apply-templates select="$ncdfmatch/*/@mtfdoc" mode="normlize"/>
                </xsl:when>
                <xsl:when test="*:annotation/*:documentation">
                    <xsl:apply-templates select="*:annotation/*:documentation" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$annot/*:documentation" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfdocvar">
            <xsl:choose>
                <xsl:when test="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@ncdfelementdoc">
                    <xsl:apply-templates select="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@ncdfelementdoc" mode="normlize"/>
                </xsl:when>
                <xsl:when test="$annot/*:documentation">
                    <xsl:apply-templates select="concat('A data item for ', lower-case($mtfdocvar))" mode="normlize"/>
                </xsl:when>
                <xsl:when test="starts-with($ncdfmatch/*/@ncdfelementdoc, 'A data type for') and contains($ncdfelementnamevar, 'Name')">
                    <xsl:apply-templates select="replace(@ncdfelementdoc, 'A data type ', 'A data item for the name ')" mode="normlize"/>
                </xsl:when>
                <xsl:when test="starts-with($ncdfmatch/*/@ncdfelementdoc, 'A data type for ')">
                    <xsl:apply-templates select="replace($ncdfmatch/*/@ncdfelementdoc, 'A data type', 'A data item')" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="e">
                        <xsl:call-template name="breakIntoWords">
                            <xsl:with-param name="string" select="$ncdfelementnamevar"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="concat('A data item for ', $e)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="docchange" select="$segment_changes/Element[@mtfname = $mtfroot][@ncdfname = '']"/>
        <xsl:variable name="contxtchange" select="$segment_changes/Element[@mtfname = $mtfroot][@segmentname = $segmentname]"/>
        <xsl:variable name="namechange" select="$segment_changes/Element[@mtfname = $mtfroot][@changename]"/>
        <xsl:variable name="ncdfelementdocvar">
            <xsl:choose>
                <xsl:when test="$segmentnamevar and $docchange/@ncdfelementdoc">
                    <xsl:value-of select="$docchange/@ncdfelementdoc"/>
                </xsl:when>
                <xsl:when test="$segmentnamevar and $contxtchange/@ncdfelementdoc">
                    <xsl:value-of select="$contxtchange/@ncdfelementdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$ncdfdocvar"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdftypedocvar" select="replace($ncdfelementdocvar, 'A data item', 'A data type')"/>
        <xsl:variable name="typeappinfo">
            <xsl:for-each select="$typeannot/*/info">
                <xsl:copy-of select="*:Field" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <Element ncdfelementname="{$ncdfelementnamevar}" ncdftype="{$ncdftypevar}" mtfname="{@name}" mtfdoc="{$mtfdocvar}" ncdftypedoc="{$ncdftypedocvar}" ncdfelementdoc="{$ncdfelementdocvar}"
            seq="{$seq}">
            <xsl:for-each select="@*[not(name() = 'name')]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:if test="string-length($sbstgrp) &gt; 0">
                <xsl:attribute name="substitutiongroup">
                    <xsl:value-of select="concat($sbstgrp, 'Abstract')"/>
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
            <xsl:if test="string-length($UseDesc) &gt; 0">
                <xsl:attribute name="usage">
                    <xsl:value-of select="$UseDesc"/>
                </xsl:attribute>
            </xsl:if>
            <!-- <xsl:if test="string-length($TextIndicator) &gt; 0">
                <xsl:attribute name="textindicator">
                    <xsl:value-of select="$TextIndicator"/>
                </xsl:attribute>
            </xsl:if>-->
            <xsl:if test="string-length($setseq) &gt; 0">
                <xsl:attribute name="setseq">
                    <xsl:value-of select="$setseq"/>
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
                <xsl:for-each select="$appinfovar/*">
                    <xsl:copy>
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
                <xsl:when test="ends-with(ancestor::*:element[@name][not(@name = 'GroupOfFields')]/@name, 'Segment')">
                    <xsl:value-of select="ancestor::*:element[@name][1]/@name"/>
                </xsl:when>
                <xsl:when test="ancestor::*:element[@name][not(@name = 'GroupOfFields')]/@name">
                    <xsl:value-of select="concat(ancestor::*:element[@name][not(@name = 'GroupOfFields')][1]/@name, 'Segment')"/>
                </xsl:when>
                <xsl:when test="ends-with(ancestor::*[@name][not(@name = 'GroupOfFields')][1]/@name, 'Segment')">
                    <xsl:value-of select="ancestor::*[@name][not(@name = 'GroupOfFields')][1]/@name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(ancestor::*[@name][not(@name = 'GroupOfFields')][1]/@name, 'Segment')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfelementnamevar">
            <xsl:choose>
                <xsl:when test="$substGrp_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar][@parentname = $setnamevar]/@ncdfname">
                    <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar][@setname = $setnamevar]/@ncdfname"/>
                </xsl:when>
                <xsl:when test="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@setname = $settypevar]/@ncdfname">
                    <xsl:value-of select="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@setname = $settypevar]/@ncdfname"/>
                </xsl:when>
                <xsl:when test="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@segmentname = $segmentnamevar]/@ncdfname">
                    <xsl:value-of select="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@segmentname = $segmentnamevar]/@ncdfname"/>
                </xsl:when>
                <xsl:when test="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@messagename = $messagenamevar]/@ncdfname">
                    <xsl:value-of select="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@messagename = $messagenamevar]/@ncdfname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$mtfnamevar" mode="txt"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="annot">
            <xsl:apply-templates select="*:annotation"/>
        </xsl:variable>
        <xsl:variable name="typeannot">
            <xsl:apply-templates select="*:element[1]/*/*:extension/*:annotation"/>
        </xsl:variable>
        <xsl:variable name="mtftypedoc">
            <xsl:apply-templates select="$typeannot/*:documentation" mode="normlize"/>
        </xsl:variable>
        <xsl:variable name="mtfdocvar">
            <xsl:choose>
                <xsl:when test="starts-with($annot/*/*:documentation, 'A data type')">
                    <xsl:apply-templates select="$annot/*/*:documentation" mode="normlize"/>
                </xsl:when>
                <xsl:when test="$annot/*/*:documentation">
                    <xsl:apply-templates select="concat('A data type for ', lower-case($annot/*/*:documentation))" mode="normlize"/>
                </xsl:when>
                <xsl:when test="$typeannot/*/*:documentation">
                    <xsl:apply-templates select="concat('A data item for ', lower-case($typeannot/*/*:documentation))" mode="normlize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$annot/*/*:documentation" mode="normlize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfelementdocvar">
            <xsl:choose>
                <xsl:when test="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@ncdfelementdoc">
                    <xsl:apply-templates select="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@ncdfelementdoc" mode="normlize"/>
                </xsl:when>
                <xsl:when test="$annot/*/*:documentation and contains($ncdfelementnamevar, 'Name')">
                    <xsl:apply-templates select="replace($mtfdocvar, 'A data type ', 'A data concept for the name ')" mode="normlize"/>
                </xsl:when>
                <xsl:when test="$annot/*/*:documentation">
                    <xsl:apply-templates select="replace($mtfdocvar, 'A data type ', 'A data concept ')" mode="normlize"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdftypedocvar">
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
        <xsl:variable name="seq">
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
                <xsl:when test="string-length($substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@setname = $settypevar]/@ncdfname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@setname = $settypevar]/@ncdfname"/>
                </xsl:when>
                <xsl:when test="string-length($substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@setname = '']/@ncdfname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@setname = '']/@ncdfname"/>
                </xsl:when>
                <xsl:when test="string-length($substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@segmentname = $segmentnamevar]/@ncdfname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@segmentname = $segmentnamevar]/@ncdfname"/>
                </xsl:when>
                <xsl:when test="string-length($substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@segmentname = '']/@ncdfname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@segmentname = '']/@ncdfname"/>
                </xsl:when>
                <xsl:when test="string-length($substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@smessagename = $messagenamevar]/@ncdfname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@messagename = $messagenamevar]/@ncdfname"/>
                </xsl:when>
                <xsl:when test="string-length($substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@messagenamevar = '']/@ncdfname) &gt; 0">
                    <xsl:value-of select="$substGrp_Changes/Choice[@substgrpname = $mtfnamevar][@messagenamevar = '']/@ncdfname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($ncdfelementnamevar, 'Choice')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="substgrpdocvar">
            <xsl:choose>
                <xsl:when test="$ncdfelementdocvar">
                    <xsl:value-of select="$ncdfelementdocvar"/>
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
        <xsl:variable name="substgrpncdfdoc">
            <xsl:choose>
                <xsl:when test="starts-with($substgrpdocvar, 'A data concept')">
                    <xsl:apply-templates select="$substgrpdocvar" mode="normlize"/>
                </xsl:when>
                <xsl:when test="string-length($substgrpdocvar) &gt; 0">
                    <xsl:apply-templates select="$substgrpdocvar" mode="normlize"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <Element mtfname="{@name}" ncdfelementname="{$ncdfelementnamevar}" seq="{$seq}">
            <xsl:for-each select="@*[not(name() = 'name')]">
                <xsl:copy-of select="."/>
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
            <xsl:if test="string-length($ncdfelementdocvar) &gt; 0">
                <xsl:attribute name="ncdfelementdoc">
                    <xsl:value-of select="$ncdfelementdocvar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($parentnamevar) &gt; 0">
                <xsl:attribute name="parentname">
                    <xsl:value-of select="$parentnamevar"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($ncdftypedocvar) &gt; 0">
                <xsl:attribute name="ncdftypedoc">
                    <xsl:value-of select="$ncdftypedocvar"/>
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
                <xsl:for-each select="$appinfovar">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </info>
            <Choice name="{$substgrpnamevar}" substgrpname="{concat($substgrpnamevar,'Abstract')}" substgrpdoc="{$substgrpncdfdoc}">
                <xsl:apply-templates select="*:complexType/*:choice/*:element">
                    <xsl:sort select="@name"/>
                    <xsl:with-param name="settypevar" select="$settypevar"/>
                    <xsl:with-param name="segmentnamevar" select="$segmentnamevar"/>
                    <xsl:with-param name="messagenamevar" select="$messagenamevar"/>
                    <xsl:with-param name="sbstgrp" select="$substgrpnamevar"/>
                </xsl:apply-templates>
            </Choice>
        </Element>
    </xsl:template>
    <xsl:template match="*:element[@name = 'GroupOfFields']">
        <xsl:param name="settypevar"/>
        <xsl:param name="segmentnamevar"/>
        <xsl:param name="messagenamevar"/>
        <Sequence name="GroupOfFields">
            <xsl:for-each select="@*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
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
                    <xsl:copy-of select="$substGrp_Changes/Choice[@substgrpname = $subgrpname][@parentname = $parentnamevar][1]"/>
                </xsl:when>
                <xsl:when test="$substGrp_Changes/Choice[@substgrpname = $subgrpname][@segmentname = $segnamevar]">
                    <xsl:copy-of select="$substGrp_Changes/Choice[@substgrpname = $subgrpname][@segmentname = $segnamevar][1]"/>
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
                <xsl:when test="$substmatch/*/@ncdfname">
                    <xsl:value-of select="$substmatch/*/@ncdfname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$subgrpname"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="substgrpdocvar">
            <xsl:choose>
                <xsl:when test="$subname = 'ExerciseOperation'">
                    <xsl:text>A data type for a choice of Exercise or Operation context.</xsl:text>
                </xsl:when>
                <xsl:when test="$substmatch/*/@substgrpdoc">
                    <xsl:value-of select="concat('A data type for a substitution group for ', substring-after($substmatch/*/@substgrpdoc, 'A choice of '))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="splitname">
                        <xsl:call-template name="breakIntoWords">
                            <xsl:with-param name="string" select="$subgrpname"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="concat('A data type for a substitution group for ', lower-case($splitname))"/>
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
                    <xsl:with-param name="sbstgrp" select="$choicenamevar"/>
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
                <xsl:text>SecurityAndDefensesRemarksGenText</xsl:text>
            </xsl:when>
            <xsl:when test="$n = '48-hourOutlookForecast'">
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
        <xsl:value-of select="concat($n, 'HeadingSet')"/>
    </xsl:template>
    <xsl:template name="makeNcdfName">
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
