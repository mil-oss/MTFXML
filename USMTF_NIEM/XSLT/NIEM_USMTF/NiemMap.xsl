<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
    xmlns:ism="urn:us:gov:ic:ism" xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:include href="USMTF_Utility.xsl"/>
    <xsl:include href="NiemStrings.xsl"/>
    <xsl:include href="NiemNumerics.xsl"/>
    <xsl:include href="NiemCodeLists.xsl"/>

    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="lt" select="'&lt;'"/>
    <xsl:variable name="gt" select="'&gt;'"/>

    <xsl:variable name="srcdir" select="'../../XSD/'"/>
    <!--Baseline-->
    <xsl:variable name="baseline_fields_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')/*:schema"/>
    <xsl:variable name="baseline_composites_xsd" select="document('../../XSD/Baseline_Schema/composites.xsd')/*:schema"/>
    <xsl:variable name="baseline_sets_xsd" select="document('../../XSD/Baseline_Schema/sets.xsd')/*:schema"/>
    <xsl:variable name="baseline_msgs_xsd" select="document('../../XSD/Baseline_Schema/messages.xsd')/*:schema"/>
    <xsl:variable name="baseline_segments_xsd" select="$baseline_msgs_xsd/*//*:element[*:annotation/*:appinfo/*:SegmentStructureName]"/>
    <!--Changes-->
    <xsl:variable name="field_changes" select="document(concat($srcdir, 'Refactor_Changes/FieldChanges.xml'))/FieldChanges"/>
    <xsl:variable name="comp_changes" select="document(concat($srcdir, 'Refactor_Changes/CompositeChanges.xml'))"/>
    <xsl:variable name="set_changes" select="document(concat($srcdir, 'Refactor_Changes/SetChanges.xml'))/*"/>
    <xsl:variable name="message_changes" select="document(concat($srcdir, 'Refactor_Changes/MessageChanges.xml'))/*"/>
    <xsl:variable name="segment_changes" select="document(concat($srcdir, 'Refactor_Changes/SegmentChanges.xml'))/*"/>
    <xsl:variable name="substGrp_Changes" select="document(concat($srcdir, 'Refactor_Changes/SubstitutionGroupChanges.xml'))/*"/>
    <xsl:variable name="substGrp_Element_Changes" select="document(concat($srcdir, 'Refactor_Changes/ChoiceElementNames.xml'))/*"/>
    <!--Maps-->
    <xsl:variable name="niem_fields_map">
        <xsl:for-each select="$strings/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$numerics/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$codelists/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="all_field_elements_map">
        <xsl:copy-of select="$niem_fields_map" copy-namespaces="no"/>
        <xsl:for-each select="$niem_composites_map//Element[starts-with(@mtftype, 'f:') or appinfo/mtfappinfo:Field]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_sets_map//Element[starts-with(@mtftype, 'f:') or appinfo/mtfappinfo:Field]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_sets_map//Choice[Element[starts-with(@mtftype, 'f:') or Element/appinfo/mtfappinfo:Field]]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_segments_map//Element[starts-with(@mtftype, 'f:') or appinfo/mtfappinfo:Field]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_messages_map//Element[starts-with(@mtftype, 'f:') or appinfo/mtfappinfo:Field]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
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
                    <xsl:otherwise>
                        <xsl:value-of select="$n"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemcomplextype">
                <xsl:value-of select="concat($n, 'Type')"/>
            </xsl:variable>
            <xsl:variable name="niemelementname">
                <xsl:choose>
                    <xsl:when test="ends-with($niemname, 'Indicator')">
                        <xsl:value-of select="replace($niemname, 'Indicator', 'Text')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$niemname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="mtfdoc">
                <xsl:value-of select="$annot/*/*:documentation"/>
            </xsl:variable>
            <xsl:variable name="niemtypedoc">
                <xsl:choose>
                    <xsl:when test="$change/@niemtypedoc">
                        <xsl:value-of select="$change/@niemtypedoc"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$annot/*/*:documentation"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="niemelementdoc">
                <xsl:choose>
                    <xsl:when test="$change/@niemtypedoc">
                        <xsl:value-of select="replace($change/@niemtypedoc, 'A data type', 'A data item')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace($mtfdoc, 'A data type', 'A data item')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="annot">
                <xsl:apply-templates select="*:annotation"/>
            </xsl:variable>
            <xsl:variable name="appinfo">
                <xsl:for-each select="$annot/*/*:appinfo">
                    <mtfappinfo:Composite>
                        <xsl:for-each select="*:Field/@*">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </mtfappinfo:Composite>
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
                    <xsl:variable name="niemmatch" select="$niem_fields_map/*[@mtftype = $mtftypevar]"/>
                    <xsl:variable name="niemtypevar">
                        <xsl:choose>
                            <xsl:when test="$n = 'BlankSpace'">
                                <xsl:text>BlankSpaceTextType</xsl:text>
                            </xsl:when>
                            <xsl:when test="starts-with(@type, 'f:')">
                                <xsl:value-of select="$niemmatch/@niemtype"/>
                            </xsl:when>
                            <xsl:when test="starts-with(@type, 'f:')">
                                <xsl:value-of select="$niemmatch/@niemtype"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$mtftypevar"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <!--<xsl:variable name="field_chg" select="$field_changes/*/*[@name = $n]"/>-->
                    <xsl:variable name="comp_chg" select="$comp_changes/CompositeTypeChanges/Element[@name = $n]"/>
                    <xsl:variable name="seqniemelementname">
                        <xsl:choose>
                            <xsl:when test="$comp_chg/@niemelementname">
                                <xsl:value-of select="$comp_chg/@niemelementname"/>
                            </xsl:when>
                            <xsl:when test="$niemmatch/@niemelementname">
                                <xsl:value-of select="$niemmatch/@niemelementname"/>
                            </xsl:when>
                            <xsl:when test="ends-with($niemtypevar, 'TextType') and not(ends-with($n, 'Text'))">
                                <xsl:value-of select="concat($n, 'Text')"/>
                            </xsl:when>
                            <xsl:when test="ends-with($niemtypevar, 'NumericType') and not(ends-with($n, 'Numeric'))">
                                <xsl:value-of select="concat($n, 'Numeric')"/>
                            </xsl:when>
                            <xsl:when test="ends-with($niemtypevar, 'CodeType') and not(ends-with($n, 'Code'))">
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
                        <xsl:apply-templates select="$niemmatch/*/*:annotation"/>
                    </xsl:variable>
                    <Element mtfname="{@name}" mtftype="{@type}" niemtype="{$niemtypevar}" niemelementname="{$seqniemelementname}">
                        <xsl:attribute name="niemelementdoc">
                            <xsl:choose>
                                <xsl:when test="$n = 'BlankSpace'">
                                    <xsl:text>A data type for a blank space character that is used to separate elements within a data chain, or to mark the beginning or end of a unit of data.</xsl:text>
                                </xsl:when>
                                <xsl:when test="$comp_changes/CompositeTypeChanges/Element[@name = $n]">
                                    <xsl:value-of select="$comp_changes/CompositeTypeChanges/Element[@name = $n]/@niemelementdoc"/>
                                </xsl:when>
                                <xsl:when test="$niem_fields_map/*[@mtftype = $mtftypevar]/@niemelementdoc">
                                    <xsl:value-of select="$niem_fields_map/*[@mtftype = $mtftypevar]/@niemelementdoc"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="seq">
                            <xsl:value-of select="*:annotation/*:appinfo/*:ElementalFfirnFudnSequence"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$annot/*:appinfo">
                                <xsl:copy-of select="$annot/*:appinfo"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="$tpyeannot/*:appinfo"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </Element>
                </xsl:for-each>
            </xsl:variable>
            <Composite niemelementname="{$niemelementname}" niemtype="{$niemcomplextype}" niemname="{$niemname}" niemelementdoc="{$niemelementdoc}" mtfdoc="{$mtfdoc}" niemtypedoc="{$niemtypedoc}"
                mtfname="{@name}">
                <xs:appinfo>
                    <xsl:for-each select="$appinfo">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:for-each>
                </xs:appinfo>
                <Sequence>
                    <xsl:for-each select="$seq_fields">
                        <xsl:copy-of select="Element" copy-namespaces="no"/>
                    </xsl:for-each>
                </Sequence>
            </Composite>
        </xsl:for-each>
    </xsl:variable>  
    <xsl:variable name="all_composite_elements_map">
        <xsl:copy-of select="$niem_composites_map" copy-namespaces="no"/>
        <xsl:for-each select="$niem_sets_map//*:Element[starts-with(@mtftype, 'c:') or *:appinfo/mtfappinfo:Composite]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_sets_map//*:Choice[Element[starts-with(@mtftype, 'c:') or *:Element/*:appinfo/mtfappinfo:Composite]]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_segments_map//*:Element[starts-with(@mtftype, 'c:') or *:appinfo/mtfappinfo:Composite]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_messages_map//*:Element[starts-with(@mtftype, 'c:') or *:appinfo/mtfappinfo:Composite]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="niem_sets_map">
        <xsl:apply-templates select="$baseline_sets_xsd/*:complexType" mode="setglobal"/>
    </xsl:variable>
    <xsl:variable name="all_set_elements_map">
        <xsl:for-each select="$niem_sets_map//*:Element">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_segments_map//*:Element[starts-with(@mtftype, 's:') or *:appinfo/mtfappinfo:Set or starts-with(*:Choice/*:Element[1]/@mtftype, 's:')]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_messages_map//*:Element[starts-with(@mtftype, 's:') or *:appinfo/mtfappinfo:Set or starts-with(*:Choice/*:Element[1]/@mtftype, 's:')]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="niem_segments_map">
        <xsl:apply-templates select="$baseline_segments_xsd" mode="segmentglobal"/>
    </xsl:variable>
    <xsl:variable name="all_segment_elements_map">
        <xsl:for-each select="$niem_segments_map//*:Element[*:appinfo/mtfappinfo:Segment]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$niem_messages_map//*:Element[*:appinfo/mtfappinfo:Segment]">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="niem_messages_map">
        <xsl:apply-templates select="$baseline_msgs_xsd/*" mode="messageglobal"/>
    </xsl:variable>

    <!--Outputs-->
    <xsl:variable name="fieldsmapoutputdoc" select="concat($srcdir, 'NIEM_MTF/Maps/NIEM_MTF_Fieldmaps.xml')"/>
    <xsl:variable name="compositesmapoutputdoc" select="concat($srcdir, 'NIEM_MTF/Maps/NIEM_MTF_Compositemaps.xml')"/>
    <xsl:variable name="setsmapoutputdoc" select="concat($srcdir, 'NIEM_MTF/Maps/NIEM_MTF_Setmaps.xml')"/>
    <xsl:variable name="segmentsmapoutputdoc" select="concat($srcdir, 'NIEM_MTF/Maps/NIEM_MTF_Sgmntmaps.xml')"/>
    <xsl:variable name="messagesmapoutputdoc" select="concat($srcdir, 'NIEM_MTF/Maps/NIEM_MTF_Msgsmaps.xml')"/>

    <xsl:template name="map">
        <xsl:result-document href="{$fieldsmapoutputdoc}">
            <Fields>
                <xsl:for-each select="$all_field_elements_map/*">
                    <xsl:sort select="@niemelementname"/>
                    <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Field'">
                        <xsl:variable name="n" select="@niemelementname"/>
                        <xsl:variable name="t" select="@niemtype"/>
                        <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all_field_elements_map/*">
                    <xsl:sort select="@niemelementname"/>
                    <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Element'">
                        <xsl:variable name="n" select="@niemelementname"/>
                        <xsl:variable name="t" select="@niemtype"/>
                        <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </Fields>
        </xsl:result-document>
        <xsl:result-document href="{$compositesmapoutputdoc}">
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
        <xsl:result-document href="{$setsmapoutputdoc}">
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
        <xsl:result-document href="{$segmentsmapoutputdoc}">
            <Segments>
                <xsl:for-each select="$niem_segments_map/*">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </Segments>
        </xsl:result-document>
        <xsl:result-document href="{$messagesmapoutputdoc}">
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
        <xsl:variable name="change" select="$set_changes/Set[@mtfname = $mtfname]"/>
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="fromtype"/>
        </xsl:variable>
        <xsl:variable name="niemelementnamevar">
            <xsl:choose>
                <xsl:when test="$change/@niemelementname">
                    <xsl:value-of select="$change/@niemelementname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$n"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemcomplextypevar">
            <xsl:choose>
                <xsl:when test="$change/@niemcomplextype">
                    <xsl:value-of select="$change/@niemcomplextype"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($niemelementnamevar, 'Type')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfdocvar">
            <xsl:value-of select="$annot/*/*:documentation"/>
        </xsl:variable>
        <xsl:variable name="niemtypedocvar">
            <xsl:choose>
                <xsl:when test="$change/@niemtypedoc">
                    <xsl:value-of select="concat('A data type for the ', replace($change/@niemtypedoc, 'The', 'the'))"/>
                </xsl:when>
                <xsl:when test="starts-with($mtfdocvar, 'A data ')">
                    <xsl:value-of select="$mtfdocvar"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('A data type for the', substring($mtfdocvar, 4))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementdocvar">
            <xsl:value-of select="replace($niemtypedocvar, 'A data type', 'A data item')"/>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/*:appinfo">
                <xsl:apply-templates select="*:Set" mode="xsdcopy"/>
            </xsl:for-each>
        </xsl:variable>
        <Set niemelementname="{$niemelementnamevar}" niemtype="{$niemcomplextypevar}" niemelementdoc="{$niemelementdocvar}" mtfname="{@name}" mtfdoc="{$mtfdocvar}" niemtypedoc="{$niemtypedocvar}">
            <xs:appinfo>
                <xsl:for-each select="$appinfovar">
                    <xsl:apply-templates select="." mode="xsdcopy"/>
                </xsl:for-each>
            </xs:appinfo>
            <xsl:apply-templates select="*[not(name() = '*:annotation')]">
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
        <xsl:variable name="changename" select="$segment_changes/Segment[@mtfname = $mtfname]"/>
        <xsl:variable name="niemelementnamevar">
            <xsl:choose>
                <xsl:when test="$changename/@niemelementname">
                    <xsl:value-of select="$changename/@niemelementname"/>
                </xsl:when>
                <xsl:when test="ends-with($mtfname, 'Segment')">
                    <xsl:value-of select="$mtfname"/>
                </xsl:when>
                <xsl:when test="contains($mtfname, 'Segment_')">
                    <xsl:value-of select="concat(substring-before($mtfname, 'Segment_'), 'Segment')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($mtfname, 'Segment')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemcomplextype">
            <xsl:value-of select="concat($niemelementnamevar, 'Type')"/>
        </xsl:variable>
        <xsl:variable name="changedoc" select="$segment_changes/Segment[@mtfname = $mtfname][@niemcomplextype = $niemcomplextype]"/>
        <xsl:variable name="mtfdoc">
            <xsl:choose>
                <xsl:when test="*:annotation/*:documentation">
                    <xsl:value-of select="normalize-space(*:annotation/*:documentation)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($annot/*/*:documentation)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="segseq">
            <xsl:value-of select="*:complexType/*:attribute[@name = 'segSeq'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="niemtypedocvar">
            <xsl:choose>
                <xsl:when test="$changedoc/@niemtypedoc">
                    <xsl:value-of select="concat('A data type for the', $changedoc/@niemtypedoc, 'The')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('A data type for the', substring-after($mtfdoc, 'The'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementdocvar">
            <xsl:choose>
                <xsl:when test="$changedoc/@niemelementdoc">
                    <xsl:value-of select="$changedoc/@niemelementdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($niemtypedocvar, 'A data type for', 'A data item for')"/>
                    <!--<xsl:value-of select="normalize-space($niemtypedoc)"/>-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/*:appinfo">
                <xsl:copy-of select="*:Segment" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <Segment niemelementname="{$niemelementnamevar}" niemtype="{$niemcomplextype}" niemelementdoc="{$niemelementdocvar}" mtfname="{@name}" messagename="{$messagename}" mtfdoc="{$mtfdoc}"
            niemtypedoc="{$niemtypedocvar}">
            <xsl:if test="string-length($segseq) &gt; 0">
                <xsl:attribute name="segseq">
                    <xsl:value-of select="$segseq"/>
                </xsl:attribute>
            </xsl:if>
            <xs:appinfo>
                <xsl:for-each select="$appinfovar/*">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </xs:appinfo>
            <xsl:apply-templates select="*[not(name() = '*:annotation')]">
                <xsl:with-param name="segmentnamevar" select="$mtfname"/>
            </xsl:apply-templates>
        </Segment>
    </xsl:template>
    <xsl:template match="*:element" mode="messageglobal">
        <xsl:variable name="annot">
            <xsl:apply-templates select="*:annotation"/>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/*:appinfo">
                <xsl:copy-of select="*" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="mtfnamevar" select="@name"/>
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
                    <xsl:value-of select="normalize-space(*:annotation/*:documentation)"/>
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
                    <xsl:value-of select="concat('A data type for the', $message_changes/Element[@mtfname = $mtfnamevar][@niemname = $niemelementnamevar]/@niemtypedoc, 'The')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('A data type for the', substring-after($mtfdoc, 'The'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementdocvar">
            <xsl:choose>
                <xsl:when test="$message_changes/Element[@mtfname = $mtfnamevar][@niemname = $niemelementnamevar]/@niemelementdoc">
                    <xsl:value-of select="$message_changes/Element[@mtfname = $mtfnamevar][@niemname = $niemelementnamevar]/@niemelementdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($niemtypedocvar, 'A data type', 'A data item')"/>
                    <!--<xsl:value-of select="normalize-space($niemtypedoc)"/>-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Message niemelementname="{$niemelementnamevar}" niemtype="{$niemcomplextype}" niemelementdoc="{$niemelementdocvar}" mtfname="{@name}" mtfid="{$mtfid}" mtfdoc="{$mtfdoc}"
            niemtypedoc="{$niemtypedocvar}">
            <xs:appinfo>
                <xsl:for-each select="$appinfovar/*">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </xs:appinfo>
            <xsl:apply-templates select="*[not(name() = '*:annotation')]">
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
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfnamevar">
            <xsl:apply-templates select="@name" mode="txt"/>
        </xsl:variable>
        <xsl:variable name="mtfbase">
            <xsl:value-of select="*:complexType/*/*:extension/@base"/>
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
                <!--<xsl:when test="$segment_changes/Element[@mtfname = $mtfnamevar]">
                    <xsl:value-of select="$mtfnamevar"/>
                </xsl:when>-->
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
            <xsl:value-of select="ancestor::*:element[*:annotation/*:documentation/*:appinfo/MtfName]/@name"/>
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
        <xsl:variable name="isField" select="exists($annot/appinfo/mtfappinfo:Field) or starts-with($mtfbase, 'f:')"/>
        <xsl:variable name="isComposite" select="exists($annot/appinfo/mtfappinfo:Composite) or starts-with($mtfbase, 'c:')"/>
        <xsl:variable name="isSet" select="exists($annot/appinfo/mtfappinfo:Set) or starts-with($mtfbase, 's:')"/>
        <xsl:variable name="isSegment" select="exists($annot/appinfo/mtfappinfo:Segment)"/>
        <xsl:variable name="niemmatch">
            <xsl:choose>
                <xsl:when test="$isField">
                    <xsl:copy-of select="$niem_fields_map/Field[@mtftype = $mtftypevar][1]" copy-namespaces="no"/>
                </xsl:when>
                <xsl:when test="$isComposite">
                    <xsl:copy-of select="$niem_composites_map/Composite[@mtftype = $mtftypevar][1]" copy-namespaces="no"/>
                </xsl:when>
                <xsl:when test="$isSet">
                    <xsl:apply-templates select="$baseline_sets_xsd/*:complexType[@name = $mtftypevar][1]" mode="setglobal"/>
                </xsl:when>
                <xsl:when test="$isSegment">
                    <xsl:apply-templates select="$baseline_segments_xsd/*:element[@name = $mtfroot][1]" mode="segmentglobal"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemtypedocvar">
            <xsl:value-of select="$niemmatch/*/@mtfname"/>
        </xsl:variable>
        <xsl:variable name="setidvar">
            <xsl:value-of select="$niemmatch/*/appinfo/mtfappinfo:Set/@setid"/>
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
            <xsl:value-of select="$typeannot/*/*:documentation"/>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/*:appinfo">
                <xsl:copy-of select="*" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="UseDesc">
            <xsl:value-of select="translate(upper-case($appinfovar/*/@usage), '.', '')"/>
        </xsl:variable>
        <xsl:variable name="apos">
            <xsl:text>'</xsl:text>
        </xsl:variable>
        <xsl:variable name="TextIndicator">
            <xsl:if test="contains($UseDesc, 'MUST EQUAL')">
                <xsl:value-of select="replace(replace(replace(normalize-space(substring-after($UseDesc, 'MUST EQUAL')), $apos, ''), ',', ''), '”', '')"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="niemtypevar">
            <xsl:choose>
                <xsl:when test="string-length($niemmatch/*/@niemtype) &gt; 0">
                    <xsl:value-of select="$niemmatch/*/@niemtype"/>
                </xsl:when>
                <xsl:when test="$segmentnamevar and $segment_changes/Element[@mtfname = $mtfnamevar][1]/@niemtype">
                    <xsl:value-of select="$segment_changes/Element[@mtfname = $mtfnamevar][1]/@niemtype"/>
                </xsl:when>
                <xsl:when test="$messagenamevar and $message_changes/Element[@mtfname = $mtfnamevar][1]/@niemtype">
                    <xsl:value-of select="$segment_changes/Element[@mtfname = $mtfnamevar][1]/@niemtype"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtftypevar"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="niemel">
            <xsl:choose>
                <xsl:when test="$isField">
                    <xsl:variable name="field_chg" select="$field_changes/*[@name = substring-after($mtftypevar, ':')]"/>
                    <xsl:variable name="set_chg" select="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar]"/>
                    <xsl:choose>
                        <xsl:when test="$field_chg/@niemelementname">
                            <xsl:value-of select="$field_chg/@niemelementname"/>
                        </xsl:when>
                        <xsl:when test="$set_chg/@niemelementname">
                            <xsl:value-of select="$set_chg/@niemelementname"/>
                        </xsl:when>
                        <xsl:when test="$niemmatch/*/@niemelementname">
                            <xsl:value-of select="$niemmatch/*/@niemelementname"/>
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
                        <xsl:when test="$niemmatch/*/@niemelementname">
                            <xsl:value-of select="$niemmatch/*/@niemelementname"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$mtfnamevar"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="ends-with($niemtypevar, 'TextType') and not(ends-with($n, 'Text'))">
                    <xsl:value-of select="concat($n, 'Text')"/>
                </xsl:when>
                <xsl:when test="ends-with($niemtypevar, 'NumericType') and not(ends-with($n, 'Numeric'))">
                    <xsl:value-of select="concat($n, 'Numeric')"/>
                </xsl:when>
                <xsl:when test="ends-with($niemtypevar, 'CodeType') and not(ends-with($n, 'Code'))">
                    <xsl:value-of select="concat($n, 'Code')"/>
                </xsl:when>
                <xsl:when test="$niemmatch/*/@niemelementname">
                    <xsl:value-of select="$niemmatch/*/@niemelementname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfnamevar"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelement">
            <xsl:choose>
                <xsl:when test="$sbstgrp">
                    <xsl:choose>
                        <xsl:when test="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $segmentnamevar]">
                            <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $segmentnamevar]/@niemname"/>
                        </xsl:when>
                        <xsl:when test="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $setnamevar]">
                            <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $setnamevar]/@niemname"/>
                        </xsl:when>
                        <xsl:when test="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $messagenamevar]">
                            <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfroot][@parentname = $messagenamevar]/@niemname"/>
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
                        <xsl:when test="$niem_composites_map/*[@niemelementname = $niemel]">
                            <xsl:value-of select="concat($sbstgrp, $niemel)"/>
                        </xsl:when>
                        <xsl:when test="$niem_fields_map/*[@niemelementname = $niemel]">
                            <xsl:value-of select="concat($sbstgrp, $niemel)"/>
                        </xsl:when>
                        <xsl:when test="@name = $niemel">
                            <xsl:value-of select="concat($sbstgrp, @name)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($sbstgrp, $mtfroot)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="string-length($niemel) &gt; 0">
                    <xsl:value-of select="$niemel"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfnamevar"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementnamevar">
            <xsl:choose>
                <xsl:when test="$settypevar and $set_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar][1]/@niemelementname">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@setname = $settypevar][1]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$isField and $set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtfbase][1]/@niemelementname">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtfbase][1]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$segmentnamevar and $segment_changes/Element[@mtfname = $mtfnamevar]/@niemelementname">
                    <xsl:value-of select="$segment_changes/Element[@mtfname = $mtfnamevar][1]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$messagenamevar and $message_changes/Element[@mtfname = $mtfroot][@messagename = $messagenamevar]/@niemelementname">
                    <xsl:value-of select="$message_changes/Element[@mtfname = $mtfroot][@messagename = $messagenamevar]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$messagenamevar and $message_changes/Element[@mtfname = $mtfnamevar]/@niemelementname">
                    <xsl:value-of select="$message_changes/Element[@mtfname = $mtfnamevar]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="string-length($sbstgrp) &gt; 0">
                    <xsl:value-of select="$niemelement"/>
                </xsl:when>
                <xsl:when test="starts-with($mtfnamevar, 'GeneralText')">
                    <xsl:call-template name="GenTextName">
                        <xsl:with-param name="textind" select="$TextIndicator"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="starts-with($mtfnamevar, 'HeadingInformation') and not($mtfnamevar = 'HeadingInformation')">
                    <xsl:call-template name="HeadingInformation">
                        <xsl:with-param name="textind" select="$TextIndicator"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="starts-with($niemelement, '_')">
                    <xsl:value-of select="$mtfnamevar"/>
                </xsl:when>
                <xsl:when test="contains($niemelement, '_')">
                    <xsl:value-of select="substring-before($niemelement, '_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$niemelement"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="fixedval">
            <xsl:choose>
                <xsl:when test="starts-with($mtfnamevar, 'GeneralText')">
                    <xsl:value-of select="upper-case(substring-before(@niemelementname, 'GenText'))"/>
                </xsl:when>
                <xsl:when test="starts-with($mtfnamevar, 'Heading')">
                    <xsl:value-of select="upper-case(substring-before(@niemelementname, 'Heading'))"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ffirnfud">
            <xsl:value-of select="*:complexType/*//*:attribute[@name = 'ffirnFudn']/@fixed"/>
        </xsl:variable>
        <xsl:variable name="setseq">
            <xsl:value-of select="*:complexType/*:complexContent/*:extension/*:attribute[@name = 'setSeq'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="mtfdocvar">
            <xsl:choose>
                <xsl:when test="*:annotation/*:documentation">
                    <xsl:value-of select="normalize-space(*:annotation/*:documentation)"/>
                </xsl:when>
                <xsl:when test="$typeannot/*/*:documentation">
                    <xsl:value-of select="replace($typeannot/*/*:documentation, 'A data type', 'A data item')"/>
                </xsl:when>
                <xsl:when test="$niemmatch/*/@mtfdoc">
                    <xsl:value-of select="$niemmatch/*/@mtfdoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($annot/*:documentation)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemdocvar">
            <xsl:choose>
                <xsl:when test="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemelementdoc">
                    <xsl:value-of select="$set_changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar]/@niemelementdoc"/>
                </xsl:when>
                <xsl:when test="$annot/*/*:documentation and starts-with($niemelementnamevar, 'A data type')">
                    <xsl:value-of select="replace($mtfdocvar, 'A data type ', 'A data item ')"/>
                </xsl:when>
                <xsl:when test="$annot/*/*:documentation">
                    <xsl:value-of select="concat('A data item for ', replace($mtfdocvar, 'The', 'the'))"/>
                </xsl:when>
                <xsl:when test="starts-with($niemmatch/*/@niemelementdoc, 'A data type for the') and contains($niemelementnamevar, 'Name')">
                    <xsl:value-of select="replace(@niemelementdoc, 'A data type ', 'A data item for the name ')"/>
                </xsl:when>
                <xsl:when test="starts-with($niemmatch/*/@niemelementdoc, 'A data type for the')">
                    <xsl:value-of select="replace($niemmatch/*/@niemelementdoc, 'A data type for the', 'A data item for the')"/>
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
        <xsl:variable name="segmentname" select="ancestor::*:element[ends-with(@name, 'Segment')][1]/@name"/>
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
        <xsl:variable name="niemtypedocvar">
            <xsl:choose>
                <xsl:when test="starts-with($niemmatch/*[1]/@niemtypedoc, 'A data type')">
                    <xsl:value-of select="$niemmatch/*[1]/@niemtypedoc"/>
                </xsl:when>
                <xsl:when test="$niemmatch/*[1]/@niemtypedoc">
                    <xsl:value-of select="concat('A data type for ', replace($niemmatch/*[1]/@niemtypedoc, 'The', 'the'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfdocvar"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="typeappinfo">
            <xsl:for-each select="$typeannot/*/*:appinfo">
                <xsl:copy-of select="*:Field" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <Element niemelementname="{$niemelementnamevar}" niemtype="{$niemtypevar}" mtfname="{@name}" mtfdoc="{$mtfdocvar}" niemtypedoc="{$niemtypedocvar}" niemelementdoc="{$niemelementdocvar}"
            seq="{$seq}">
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
            <xsl:if test="string-length($fixedval) &gt; 0">
                <xsl:attribute name="fixedval">
                    <xsl:value-of select="$fixedval"/>
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
            <xs:appinfo>
                <xsl:for-each select="$appinfovar/*">
                    <xsl:copy>
                        <xsl:for-each select="@*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
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
                        <xsl:if test="string-length($ffirnfud) &gt; 0">
                            <xsl:attribute name="identifier">
                                <xsl:value-of select="$ffirnfud"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:copy>
                </xsl:for-each>
            </xs:appinfo>
            <xsl:if test="$typeappinfo/*">
                <typeappinfo>
                    <xsl:for-each select="$typeappinfo">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:for-each>
                </typeappinfo>
            </xsl:if>
            <xsl:apply-templates select="*[not(name() = '*:annotation')]">
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
        <xsl:variable name="niemelementnamevar">
            <xsl:choose>
                <xsl:when test="$substGrp_Changes/Choice[@mtfname = $mtfnamevar][@mtftype = $mtftypevar][@setname = $setnamevar]/@niemname">
                    <xsl:value-of select="$substGrp_Changes/Element[@mtfname = $mtfnamevar][@mtftype = $mtftypevar][@setname = $setnamevar]/@niemname"/>
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
            <xsl:for-each select="$annot/*/*:appinfo">
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
                    <xsl:value-of select="$niemelementnamevar"/>
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
        <Element mtfname="{@name}" niemelementname="{concat($niemelementnamevar,'Choice')}" seq="{$seq}">
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
            <xs:appinfo>
                <xsl:for-each select="$appinfovar">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </xs:appinfo>
            <Choice name="{$substgrpnamevar}" substgrpname="{concat($substgrpnamevar,'Abstract')}" substgrpdoc="{$substgrpniemdoc}">
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
        <Sequence name="GroupOfFields">
            <xsl:for-each select="@*">
                <xsl:copy-of select="." copy-namespaces="no"/>
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
            <xsl:value-of select="ancestor::*:element[@name][1]/@name"/>
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
                    <xsl:copy-of select="$substGrp_Changes/Choice[@substgrpname = $subgrpname][@parentname = ''][1]" copy-namespaces="no"/>
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
            <xsl:copy-of select="@minOccurs"/>
            <xsl:copy-of select="@maxOccurs"/>
            <Choice name="{$choicenamevar}">
                <xsl:apply-templates select="*[not(name() = '*:annotation')]">
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
        <xsl:apply-templates select="*[not(name() = '*:annotation')]">
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
            <xsl:when test="$n = '48hourOutlookForecast'">
                <xsl:text>FortyEightHourOutlookForecast</xsl:text>
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
    <xsl:template name="niemName">
        <xsl:param name="n"/>
        <xsl:param name="suffix"/>
        <xsl:choose>
            <xsl:when test="$n = 'TargetIdentification'">
                <xsl:text>TargetID</xsl:text>
            </xsl:when>
            <xsl:when test="ends-with($n, 'Indicator')">
                <xsl:value-of select="replace($n, 'Indicator', $suffix)"/>
            </xsl:when>
            <xsl:when test="ends-with($n, 'Number')">
                <xsl:value-of select="concat(substring($n, 0, string-length($n) - 5), $suffix)"/>
            </xsl:when>
            <xsl:when test="ends-with($n, 'Code')">
                <xsl:value-of select="replace($n, 'Code', $suffix)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($n, $suffix)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
