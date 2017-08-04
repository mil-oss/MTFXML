<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="../NIEM_IEPD/MapJson.xsl"/>
    <xsl:variable name="all_field_map" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Fieldmaps.xml')"/>
    <xsl:variable name="all_composite_map" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Compositemaps.xml')"/>
    <xsl:variable name="all_set_map" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Setmaps.xml')"/>
    <xsl:variable name="all_segment_map" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Segmentmaps.xml')"/>
    <xsl:variable name="all_message_map" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Messagemaps.xml')"/>

    <xsl:variable name="sepxsdPath" select="'../../XSD/NIEM_IEPD/SeparateMessages/'"/>
    <xsl:variable name="output" select="'../../XSD/Analysis/ChangeCounts.xml'"/>
    <xsl:variable name="outputjson" select="'../../XSD/Analysis/ChangeCounts.json'"/>

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
                <xsl:variable name="msgxsd" select="document(concat($sepxsdPath, $mid, '/', $mid, '_message.xsd'))"/>
                <xsl:variable name="setxsd" select="document(concat($sepxsdPath, $mid, '/', $mid, '_sets.xsd'))"/>
                <xsl:variable name="compxsd" select="document(concat($sepxsdPath, $mid, '/', $mid, '_composites.xsd'))"/>
                <xsl:variable name="fldxsd" select="document(concat($sepxsdPath, $mid, '/', $mid, '_fields.xsd'))"/>
                <xsl:variable name="msgmap">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:variable>
                <xsl:variable name="segsmap">
                    <xsl:if test="$msgmap//*[appinfo/*:Segment]">
                        <xsl:variable name="segxsd" select="document(concat($sepxsdPath, $mid, '/', $mid, '_segments.xsd'))"/>
                        <xsl:for-each select="$segxsd/xsd:schema/xsd:complexType">
                            <xsl:sort select="@name"/>
                            <xsl:variable name="n" select="@name"/>
                            <xsl:copy-of select="$all_segment_map//Segment[@niemcomplextype = $n]" copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="setsmap">
                    <xsl:for-each select="$setxsd/xsd:schema/xsd:complexType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:copy-of select="$all_set_map//Set[@niemcomplextype = $n]" copy-namespaces="no"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="compositesmap">
                    <xsl:for-each select="$compxsd/xsd:schema/xsd:complexType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:copy-of select="$all_composite_map//Composite[@niemcomplextype = $n]" copy-namespaces="no"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="fieldsmap">
                    <xsl:for-each select="$fldxsd/xsd:schema/xsd:complexType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:copy-of select="$all_field_map//*[@niemcomplextype = $n]" copy-namespaces="no"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:element name="{$mid}">
                    <xsl:copy-of select="$msgmap"/>
                    <Segments>
                        <xsl:copy-of select="$segsmap"/>
                    </Segments>
                    <Sets>
                        <xsl:copy-of select="$setsmap"/>
                    </Sets>
                    <Composites>
                        <xsl:copy-of select="$compositesmap"/>
                    </Composites>
                    <Fields>
                        <xsl:copy-of select="$fieldsmap"/>
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
        </xsl:for-each>
        <xsl:variable name="changesout">
            <MTFChanges>
                <GlobalElementNames>
                    <xsl:copy-of select="$globalchanges"/>
                </GlobalElementNames>
                <MessageElementChanges>
                    <xsl:for-each select="$all_message_map/Messages/Message">
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

    <xsl:template name="calcChanges">
        <xsl:param name="field_map"/>
        <xsl:param name="composite_map"/>
        <xsl:param name="set_map"/>
        <xsl:param name="segment_map"/>
        <xsl:param name="message_map"/>
        <xsl:variable name="field_chg">
            <xsl:for-each select="$field_map/*">
                <xsl:choose>
                    <xsl:when test="@mtfname = @niemcomplextype"/>
                    <xsl:otherwise>
                        <Element mtfname="{@mtfname}" type="{name()}" niemcomplextype="{@niemcomplextype}" niemelementname="{@niemelementname}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="comp_chg">
            <xsl:for-each select="$composite_map//Element[@mtfelementname]">
                <xsl:choose>
                    <xsl:when test="@mtfelementname = @niemelementname"/>
                    <xsl:otherwise>
                        <Field type="{@mtfelementtype}" typechange="{@niemelementtype}" elementname="{@niemelementname}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="sets_chg_list">
            <xsl:for-each select="$set_map//Element[@niemelementname]">
                <xsl:choose>
                    <xsl:when test="@mtfname = @niemelementname"/>
                    <xsl:otherwise>
                        <Element mtfname="{@mtfname}" mtftype="{@mtftype}" niemtype="{@niemtype}" niemelementname="{@niemelementname}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="sets_chg">
            <xsl:for-each select="$sets_chg_list/*">
                <xsl:sort select="@mtfname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[@mtfname = $n and @niemelementname = $ne]"/>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
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
                            <Element mtfname="{@mtfname}" mtftype="{@mtftype}" niemelementname="{@niemelementname}" niemtype="{@niemtype}"/>
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
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="msg_chg">
            <xsl:for-each select="$message_map//Element">
                <xsl:choose>
                    <xsl:when test="@mtfname = @niemelementname"/>
                    <xsl:when test="not(@niemelementname)"/>
                    <xsl:otherwise>
                        <Element mtfname="{@mtfname}" mtftype="{@mtftype}" niemelementname="{@niemelementname}" niemtype="{@niemtype}"/>
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
        <FieldElements>
            <xsl:attribute name="count">
                <xsl:value-of select="$fcount"/>
            </xsl:attribute>
            <xsl:attribute name="changes">
                <xsl:value-of select="count($field_chg/*)"/>
            </xsl:attribute>
        </FieldElements>
        <CompositeElements>
            <xsl:attribute name="count">
                <xsl:value-of select="$ccount"/>
            </xsl:attribute>
            <xsl:attribute name="changes">
                <xsl:value-of select="count($comp_chg/*)"/>
            </xsl:attribute>
        </CompositeElements>
        <SetElements>
            <xsl:attribute name="count">
                <xsl:value-of select="$scount"/>
            </xsl:attribute>
            <xsl:attribute name="changes">
                <xsl:value-of select="count($sets_chg/*)"/>
            </xsl:attribute>
            <CamelCaseReq>
                <xsl:attribute name="count">
                    <xsl:value-of select="count($sets_chg/Element[contains(@mtfname, '_')])"/>
                </xsl:attribute>
                <xsl:for-each select="$sets_chg/Element[contains(@mtfname, '_')]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </CamelCaseReq>
            <NameConflict>
                <xsl:attribute name="count">
                    <xsl:value-of select="count($sets_chg/Element[not(contains(@mtfname, '_'))])"/>
                </xsl:attribute>
                <xsl:for-each select="$sets_chg/Element[not(contains(@mtfname, '_'))]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </NameConflict>
        </SetElements>
        <SegmentElements>
            <xsl:attribute name="count">
                <xsl:value-of select="$sgcount"/>
            </xsl:attribute>
            <xsl:attribute name="changes">
                <xsl:value-of select="count($segments_chg/*)"/>
            </xsl:attribute>
            <CamelCaseReq>
                <xsl:attribute name="count">
                    <xsl:value-of select="count($segments_chg/Element[contains(@mtfname, '_')])"/>
                </xsl:attribute>
                <xsl:for-each select="$segments_chg/Element[contains(@mtfname, '_')]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </CamelCaseReq>
            <NameConflict>
                <xsl:attribute name="count">
                    <xsl:value-of select="count($segments_chg/Element[not(contains(@mtfname, '_'))])"/>
                </xsl:attribute>
                <xsl:for-each select="$segments_chg/Element[not(contains(@mtfname, '_'))]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </NameConflict>
        </SegmentElements>
        <MessageElements>
            <xsl:attribute name="count">
                <xsl:value-of select="$msgcount"/>
            </xsl:attribute>
            <xsl:attribute name="changes">
                <xsl:value-of select="count($msg_chg/*)"/>
            </xsl:attribute>
            <CamelCaseReq>
                <xsl:attribute name="count">
                    <xsl:value-of select="count($msg_chg/Element[contains(@mtfname, '_')])"/>
                </xsl:attribute>
                <xsl:for-each select="$msg_chg/Element[contains(@mtfname, '_')]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </CamelCaseReq>
            <NameConflict>
                <xsl:attribute name="count">
                    <xsl:value-of select="count($msg_chg/Element[not(contains(@mtfname, '_'))])"/>
                </xsl:attribute>
                <xsl:for-each select="$msg_chg/Element[not(contains(@mtfname, '_'))]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </NameConflict>
        </MessageElements>
    </xsl:template>

</xsl:stylesheet>
