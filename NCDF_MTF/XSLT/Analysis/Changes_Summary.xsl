<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="CalcChangeAnalysis.xsl"/>
    <xsl:include href="../NIEM_IEPD/MapJson.xsl"/>
    <xsl:variable name="all_field_map" select="document('../../XSD/NIEM_MTF_1_NS/Maps/NIEM_MTF_Fieldmaps.xml')"/>
    <xsl:variable name="all_composite_map" select="document('../../XSD/NIEM_MTF_1_NS/Maps/NIEM_MTF_Compositemaps.xml')"/>
    <xsl:variable name="all_set_map" select="document('../../XSD/NIEM_MTF_1_NS/Maps/NIEM_MTF_Setmaps.xml')"/>
    <xsl:variable name="all_segment_map" select="document('../../XSD/NIEM_MTF_1_NS/Maps/NIEM_MTF_Sgmntmaps.xml')"/>
    <xsl:variable name="all_message_map" select="document('../../XSD/NIEM_MTF_1_NS/Maps/NIEM_MTF_Msgsmaps.xml')"/>

    <xsl:variable name="sepxsdPath" select="'../../XSD/NIEM_MTF_1_NS/SepMsgs_1_NS/'"/>
    <xsl:variable name="output" select="'../../XSD/Analysis/ChangeCounts_1_NS.xml'"/>
    <xsl:variable name="outputjson" select="'../../XSD/Analysis/ChangeCounts_1_NS.json'"/>

    <xsl:template name="main">
        <xsl:variable name="globalchanges">
            <xsl:call-template name="calcChanges">
                <xsl:with-param name="field_map" select="$all_field_map/Fields"/>
                <xsl:with-param name="composite_map" select="$all_composite_map/Composites"/>
                <xsl:with-param name="set_map" select="$all_set_map/Sets"/>
                <xsl:with-param name="segment_map" select="$all_segment_map/Segments"/>
                <xsl:with-param name="message_map" select="$all_message_map/Messages"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="maps">
            <xsl:for-each select="$all_message_map/Messages/Message">
                <xsl:variable name="mid" select="translate(@mtfid, ' .:()', '')"/>
                <xsl:variable name="msgallxsd" select="document(concat($sepxsdPath, $mid, '/', $mid, '.xsd'))"/>
                <xsl:variable name="msgmap">
                    <xsl:for-each select="$msgallxsd/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*:Msg]">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:copy-of select="$all_message_map//Message[@niemcomplextype = $n]" copy-namespaces="no"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="segsmap">
                    <xsl:for-each select="$msgallxsd/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*:Segment]">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:copy-of select="$all_segment_map//Segment[@niemcomplextype = $n]" copy-namespaces="no"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="setsmap">
                    <xsl:for-each select="$msgallxsd/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*:Set]">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:copy-of select="$all_set_map//Set[@niemcomplextype = $n]" copy-namespaces="no"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="compositesmap">
                    <xsl:for-each select="$msgallxsd/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*:Composite]">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:copy-of select="$all_composite_map//Composite[@niemcomplextype = $n]" copy-namespaces="no"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="fieldsmap">
                    <xsl:for-each select="$msgallxsd/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*:Field]">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:copy-of select="$all_field_map//*[@niemcomplextype = $n]" copy-namespaces="no"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:element name="{$mid}">
                    <xsl:copy-of select="$msgmap" copy-namespaces="no"/>
                    <Segments>
                        <xsl:copy-of select="$segsmap" copy-namespaces="no"/>
                    </Segments>
                    <Sets>
                        <xsl:copy-of select="$setsmap" copy-namespaces="no"/>
                    </Sets>
                    <Composites>
                        <xsl:copy-of select="$compositesmap" copy-namespaces="no"/>
                    </Composites>
                    <Fields>
                        <xsl:for-each select="$fieldsmap/*">
                            <xsl:sort select="name()"/>
                            <xsl:sort select="@name"/>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </Fields>
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$maps/*">
            <xsl:variable name="n" select="name()"/>
            <xsl:result-document href="{concat($sepxsdPath, $n, '/', $n, '_map.xml')}">
                <xsl:copy copy-namespaces="no">
                    <xsl:for-each select="*">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:result-document>
            <xsl:result-document href="{concat($sepxsdPath,'/_MsgMaps/', $n, '_map.xml')}">
                <xsl:copy copy-namespaces="no">
                    <xsl:for-each select="*">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:result-document>
        </xsl:for-each>
        <xsl:variable name="changesout">
            <MTFChanges>
                <GlobalElementNames>
                    <xsl:copy-of select="$globalchanges"/>
                </GlobalElementNames>
                <MessageElementChanges>
                    <xsl:for-each select="$all_message_map/Messages/Message">
                        <xsl:sort select="@mtfid"/>
                        <xsl:variable name="mid" select="translate(@mtfid, ' .:()', '')"/>
                        <Message name="{$mid}">
                            <xsl:call-template name="calcChanges">
                                <xsl:with-param name="field_map" select="$maps/*[name() = $mid]/Fields"/>
                                <xsl:with-param name="composite_map" select="$maps/*[name() = $mid]/Composites"/>
                                <xsl:with-param name="set_map" select="$maps/*[name() = $mid]/Sets"/>
                                <xsl:with-param name="segment_map" select="$maps/*[name() = $mid]/Segments"/>
                                <xsl:with-param name="message_map" select="$maps/*[name() = $mid]/Message"/>
                            </xsl:call-template>
                        </Message>
                    </xsl:for-each>
                </MessageElementChanges>
            </MTFChanges>
        </xsl:variable>
        <xsl:variable name="jsonchangesout">
            <xsl:call-template name="toJson">
                <xsl:with-param name="xdoc" select="$changesout"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:result-document href="{$output}">
            <xsl:copy-of select="$changesout"/>
        </xsl:result-document>
        <xsl:result-document href="{$outputjson}">
            <xsl:copy-of select="$jsonchangesout"/>
        </xsl:result-document>
    </xsl:template>

<!--    <xsl:template name="calcChanges">
        <xsl:param name="field_map"/>
        <xsl:param name="composite_map"/>
        <xsl:param name="set_map"/>
        <xsl:param name="segment_map"/>
        <xsl:param name="message_map"/>
        <xsl:variable name="field_chg">
            <xsl:for-each select="$field_map//*[@niemelementname]">
                <xsl:choose>
                    <xsl:when test="@mtfname = @niemcomplextype"/>
                    <xsl:otherwise>
                        <Element mtfname="{@mtfname}" niemelementname="{@niemelementname}" niemsimpletype="{@niemsimpletype}" niemcomplextype="{@niemcomplextype}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="comp_chg">
            <xsl:for-each select="$composite_map//*[@mtfelementname]">
                <xsl:choose>
                    <xsl:when test="@mtfelementname = @niemelementname"/>
                    <xsl:otherwise>
                        <Element mtfname="{@mtfname}" mtftype="{@mtfelementtype}" niemcomplextype="{@niemelementtype}" niemelementname="{@niemelementname}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="sets_chg_list">
            <xsl:for-each select="$set_map//Element[@niemelementname]">
                <xsl:choose>
                    <xsl:when test="@mtfname = @niemelementname"/>
                    <xsl:otherwise>
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="$set_map//Sequence[@name = 'GroupOfFields']">
                <xsl:choose>
                    <xsl:when test="count(Element) = 1 and Element/@substgrpname">
                        <xsl:copy-of select="Element"/>
                    </xsl:when>
                    <xsl:when test="count(Element) = 1 and Element/@mtfname!=Element/@niemelementname">
                        <xsl:copy-of select="Element"/>
                    </xsl:when>
                    <xsl:when test="count(Element) &gt; 1 and ancestor::Set/@niemelementname">
                        <Element mtfname="FieldGroup" setname="{ancestor::Set/@mtfname}" setniemname="{ancestor::Set/@niemelementname}"
                            niemelementname="{concat(ancestor::Set/@niemelementname,'FieldGroup')}" niemtype="{concat(ancestor::Set/@niemelementname,'FieldGroupType')}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="sets_chg">
            <xsl:for-each select="$sets_chg_list/*[@niemelementname]">
                <xsl:sort select="@niemelementname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="fn" select="@fieldname"/>
                <xsl:variable name="sn" select="@setniemname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="count(preceding-sibling::*[@mtfname = $n and @niemelementname = $ne])>0"/>
                    <xsl:when test="count(preceding-sibling::*[@fieldname = $fn and @niemelementname = $ne])>0"/>
                    <xsl:when test="count(preceding-sibling::*[@setniemname = $sn and @niemelementname = $ne])>0"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="segments_chg_list">
            <xsl:if test="$segment_map">
                <xsl:for-each select="$segment_map//Element">
                    <xsl:choose>
                        <xsl:when test="@mtfname = @niemelementname"/>
                        <xsl:when test="not(@niemelementname)"/>
                        <xsl:otherwise>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="segments_chg">
            <xsl:for-each select="$segments_chg_list/*">
                <xsl:sort select="@mtfname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[@mtfname = $n and @niemelementname = $ne]"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="message_chg_list">
            <xsl:for-each select="$message_map//Element">
                <xsl:choose>
                    <xsl:when test="@mtfname = @niemelementname"/>
                    <xsl:when test="not(@niemelementname)"/>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="msg_chg">
            <xsl:for-each select="$message_chg_list/*">
                <xsl:sort select="@mtfname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[@mtfname = $n and @niemelementname = $ne]"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="fcount">
            <xsl:value-of select="count($field_map//*[@niemelementname])"/>
        </xsl:variable>
        <xsl:variable name="ccount">
            <xsl:value-of select="count($composite_map//Element[@niemelementname])"/>
        </xsl:variable>
        <xsl:variable name="scount">
            <xsl:value-of select="count($set_map//Element[@mtfname])"/>
        </xsl:variable>
        <xsl:variable name="sgcount">
            <xsl:value-of select="count($segment_map//Element[@niemelementname])"/>
        </xsl:variable>
        <xsl:variable name="msgcount">
            <xsl:value-of select="count($message_map//Element[@niemelementname])"/>
        </xsl:variable>
        <xsl:variable name="fchg">
            <xsl:value-of select="count($field_chg//Element)"/>
        </xsl:variable>
        <xsl:variable name="cchg">
            <xsl:value-of select="count($comp_chg//Element)"/>
        </xsl:variable>
        <xsl:variable name="schg">
            <xsl:value-of select="count($sets_chg//Element)"/>
        </xsl:variable>
        <xsl:variable name="sgchg">
            <xsl:value-of select="count($segments_chg//Element)"/>
        </xsl:variable>
        <xsl:variable name="msgchg">
            <xsl:value-of select="count($msg_chg//Element)"/>
        </xsl:variable>
        <Elements>
            <xsl:attribute name="fieldcount">
                <xsl:value-of select="$fcount"/>
            </xsl:attribute>
            <xsl:attribute name="fieldchanges">
                <xsl:value-of select="count($field_chg/*)"/>
            </xsl:attribute>
            <xsl:attribute name="compositecount">
                <xsl:value-of select="$ccount"/>
            </xsl:attribute>
            <xsl:attribute name="compositechanges">
                <xsl:value-of select="count($comp_chg/*)"/>
            </xsl:attribute>
            <xsl:attribute name="setcount">
                <xsl:value-of select="$scount"/>
            </xsl:attribute>
            <xsl:attribute name="setchanges">
                <xsl:value-of select="count($sets_chg/*)"/>
            </xsl:attribute>
            <xsl:attribute name="setnaming">
                <xsl:value-of select="count($sets_chg/Element[not(@mtfname)][not(@setniemname)][contains(@mtfname, '_')])"/>
            </xsl:attribute>
            <xsl:attribute name="setconflicts">
                <xsl:value-of select="count($sets_chg/Element[not(@mtfname)][not(@setniemname)][not(contains(@mtfname, '_'))])"/>
            </xsl:attribute>
            <xsl:attribute name="setfieldgroup">
                <xsl:value-of select="count($sets_chg/Element[@mtfname]) + count($sets_chg/Element[@setniemname])"/>
            </xsl:attribute>
            <xsl:attribute name="setsubgroup">
                <xsl:value-of select="count($sets_chg/Element[@substitutiongroup])"/>
            </xsl:attribute>
            <xsl:attribute name="segmentcount">
                <xsl:value-of select="$sgcount"/>
            </xsl:attribute>
            <xsl:attribute name="segmentchanges">
                <xsl:value-of select="count($segments_chg/*)"/>
            </xsl:attribute>
            <xsl:attribute name="segmentnaming">
                <xsl:value-of select="count($segments_chg/Element[contains(@mtfname, '_')])"/>
            </xsl:attribute>
            <xsl:attribute name="segmentconflicts">
                <xsl:value-of select="count($segments_chg/Element[not(contains(@mtfname, '_'))])"/>
            </xsl:attribute>
            <xsl:attribute name="segmentsubgroup">
                <xsl:value-of select="count($segments_chg/Element[@substitutiongroup])"/>
            </xsl:attribute>
            <xsl:attribute name="messagecount">
                <xsl:value-of select="$msgcount"/>
            </xsl:attribute>
            <xsl:attribute name="messagechanges">
                <xsl:value-of select="count($msg_chg/*)"/>
            </xsl:attribute>
            <xsl:attribute name="messagenaming">
                <xsl:value-of select="count($msg_chg/Element[contains(@mtfname, '_')])"/>
            </xsl:attribute>
            <xsl:attribute name="messageconflicts">
                <xsl:value-of select="count($msg_chg/Element[not(contains(@mtfname, '_'))])"/>
            </xsl:attribute>
            <xsl:attribute name="msgsubgroup">
                <xsl:value-of select="count($msg_chg/Element[@substitutiongroup])"/>
            </xsl:attribute>
            <MessageChanges count="{count($msg_chg/*)}">
                <xsl:for-each select="$msg_chg/Element[@mtfname]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </MessageChanges>
            <SegmentChanges count="{count($segments_chg/*)}">
                <xsl:for-each select="$segments_chg/Element[@mtfname]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </SegmentChanges>
            <SetChanges count="{count($sets_chg/*)}">
                <xsl:for-each select="$sets_chg/Element[@mtfname]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </SetChanges>
            <CompositeChanges count="{count($sets_chg/*)}">
                <xsl:for-each select="$sets_chg/Element[@mtfname]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </CompositeChanges>
            <FieldChanges count="{count($field_chg/*)}">
                <xsl:for-each select="$field_chg/*[@mtfname]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </FieldChanges>
            <xsl:if test="count($sets_chg/Element[contains(@mtfname, '_')])&gt;0">
                <SetNaming count="{count($sets_chg/Element[contains(@mtfname, '_')])}">
                    <xsl:for-each select="$sets_chg/Element[contains(@mtfname, '_')]">
                        <xsl:sort select="@mtfname"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </SetNaming>
            </xsl:if>
            <xsl:if test="count($sets_chg/Element[not(contains(@mtfname, '_'))][@mtfname!='FieldGroup'])&gt;0">
                <SetConflicts count="{count($sets_chg/Element[not(contains(@mtfname, '_'))][@mtfname!='FieldGroup'])}">
                    <xsl:for-each select="$sets_chg/Element[not(contains(@mtfname, '_'))][@mtfname!='FieldGroup']">
                        <xsl:sort select="@mtfname"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </SetConflicts>
            </xsl:if>
            <xsl:if test="count($sets_chg/Element[not(@setniemname)])&gt;0">
                <SetGroupOfFieldSingleItemChanges count="{count($sets_chg/Element[not(@setniemname)])}">
                    <xsl:for-each select="$sets_chg/Element[not(@setniemname)]">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </SetGroupOfFieldSingleItemChanges>
            </xsl:if>
            <xsl:if test="count($sets_chg/Element[@setniemname][@mtfname='FieldGroup'])&gt;0">
                <SetGroupOfFieldMultipleItemChanges count="{count($sets_chg/Element[@setniemname][@mtfname='FieldGroup'])}">
                    <xsl:for-each select="$sets_chg/Element[@setniemname][@mtfname='FieldGroup']">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </SetGroupOfFieldMultipleItemChanges>
            </xsl:if>
            <xsl:if test="count($sets_chg/Element[@substitutiongroup])&gt;0">
                <SetSubstitutionGroupMemberChanges count="{count($sets_chg/Element[@substitutiongroup])}">
                    <xsl:for-each select="$sets_chg/Element[@substitutiongroup]">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </SetSubstitutionGroupMemberChanges>
            </xsl:if>
            <xsl:if test="count($segments_chg/Element[contains(@mtfname, '_')])&gt;0">
                <SegmentNaming count="{count($segments_chg/Element[contains(@mtfname, '_')])}">
                    <xsl:for-each select="$segments_chg/Element[contains(@mtfname, '_')]">
                        <xsl:sort select="@mtfname"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </SegmentNaming>
            </xsl:if>
            <xsl:if test="count($segments_chg/Element[@substitutiongroup])&gt;0">
                <SegmentSubstitutionGroupMemberChanges count="{count($segments_chg/Element[@substitutiongroup])}">
                    <xsl:for-each select="$segments_chg/Element[@substitutiongroup]">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </SegmentSubstitutionGroupMemberChanges>
            </xsl:if>
            <xsl:if test="count($segments_chg/Element[not(contains(@mtfname, '_'))])&gt;0">
                <SegmentConflicts count="{count($segments_chg/Element[not(contains(@mtfname, '_'))])}">
                    <xsl:for-each select="$segments_chg/Element[not(contains(@mtfname, '_'))]">
                        <xsl:sort select="@mtfname"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </SegmentConflicts>
            </xsl:if>
            <xsl:if test="count($msg_chg/Element[contains(@mtfname, '_')])&gt;0">
                <MessageNaming count="{count($msg_chg/Element[contains(@mtfname, '_')])}">
                    <xsl:for-each select="$msg_chg/Element[contains(@mtfname, '_')]">
                        <xsl:sort select="@mtfname"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </MessageNaming>
            </xsl:if>
            <xsl:if test="count($msg_chg/Element[not(contains(@mtfname, '_'))])&gt;0">
                <MessageConflicts count="{count($msg_chg/Element[not(contains(@mtfname, '_'))])}">
                    <xsl:for-each select="$msg_chg/Element[not(contains(@mtfname, '_'))]">
                        <xsl:sort select="@mtfname"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </MessageConflicts>
            </xsl:if>
            <xsl:if test="count($msg_chg/Element[@substitutiongroup])&gt;0">
                <MessageSubstitutionGroupMemberChanges count="{count($msg_chg/Element[@substitutiongroup])}">
                    <xsl:for-each select="$msg_chg/Element[@substitutiongroup]">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </MessageSubstitutionGroupMemberChanges>
            </xsl:if>
        </Elements>
    </xsl:template>-->

</xsl:stylesheet>
