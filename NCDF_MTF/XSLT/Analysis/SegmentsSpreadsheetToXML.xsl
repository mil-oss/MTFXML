<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!--This transform extracts usable XML from MS EXCEL documents saved as XML-->
    <xsl:variable name="msgs" select="document('../../XSD/Baseline_Schema/messages.xsd')"/>
    <xsl:variable name="sourceDoc" select="document('../../XSD/Deconflicted/M2014-10-C0-FSegmentDeconfliction.xml')"/>
    <xsl:variable name="outputDoc" select="'../../XSD/Deconflicted/Segment_Name_Changes.xml'"/>
    <!--Create Attributes from first row labels-->
    <xsl:variable name="colhdrs">
        <Cols>
            <xsl:for-each select="$sourceDoc//*:table/*:table-row[1]/*:table-cell[*:p]">
                <xsl:variable name="datatext">
                    <xsl:apply-templates select="*:p/text()[1]"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains($datatext, '(')">
                        <Col name="{substring-before(translate($datatext,' :/_',''),'(')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <Col name="{translate($datatext,' :/_','')}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </Cols>
    </xsl:variable>
    <!--Create list of all Segments identified as having duplicate names in provided Spreadsheet-->
    <xsl:variable name="new_segment_elements">
        <xsl:apply-templates select="$sourceDoc//*:table[1]"/>
    </xsl:variable>
    <xsl:template name="main">
        <xsl:variable name="segchanges">
            <xsl:for-each select="$new_segment_elements/*">
                <xsl:if test="not(contains(@REQUIREDUSMTFCHANGES, 'No changes required'))">
                    <xsl:copy>
                        <xsl:attribute name="SegmentElement">
                            <xsl:call-template name="CamelCase">
                                <xsl:with-param name="txt">
                                    <xsl:apply-templates select="./@SEGMENTNAME"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="starts-with(@REQUIREDUSMTFCHANGES, 'Change segment name')">
                            <xsl:attribute name="ProposedSegmentName">
                                <xsl:value-of
                                    select="translate(translate(normalize-space(substring-after(@REQUIREDUSMTFCHANGES, ':')), '&#xA;,', ' '), '&#34;', '')"
                                />
                            </xsl:attribute>
                            <xsl:attribute name="ProposedElementName">
                                <xsl:call-template name="CamelCase">
                                    <xsl:with-param name="txt">
                                        <xsl:value-of
                                            select="translate(translate(normalize-space(substring-after(@REQUIREDUSMTFCHANGES, ':')), '&#xA;,', ' '), '&#34;', '')"
                                        />
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:for-each select="@*">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </xsl:copy>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:result-document href="{$outputDoc}">
            <USMTF_Segments>
                <xsl:attribute name="count">
                    <xsl:value-of select="count($segchanges/*)"/>
                </xsl:attribute>
                <xsl:for-each select="$segchanges/*">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </USMTF_Segments>
        </xsl:result-document>
    </xsl:template>
    <!-- Extract Segments from Spreadsheet XML with required changes identified-->
    <xsl:template match="*:table">
        <xsl:apply-templates select="*:table-row[*:table-cell/*:p]"/>
    </xsl:template>
    <xsl:template match="*:table-row[1]"/>
    <xsl:template match="*:table-row">
        <xsl:element name="Segment">
            <xsl:apply-templates select="*:table-cell[1]">
                <xsl:with-param name="pos" select="1"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:table-cell">
        <xsl:param name="pos"/>
        <xsl:variable name="adjpos">
            <xsl:choose>
                <xsl:when test="./@*:number-columns-repeated">
                    <xsl:value-of select="number(@*:number-columns-repeated)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="./@*:number-columns-repeated">
                <xsl:if test="*:p">
                    <xsl:call-template name="reptVal">
                        <xsl:with-param name="pos">
                            <xsl:value-of select="$pos"/>
                        </xsl:with-param>
                        <xsl:with-param name="rpt">
                            <xsl:value-of select="./@*:number-columns-repeated"/>
                        </xsl:with-param>
                        <xsl:with-param name="val">
                            <xsl:apply-templates select="*:p"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="following-sibling::*:table-cell[*:p]">
                    <xsl:apply-templates select="following-sibling::*:table-cell[1]">
                        <xsl:with-param name="pos">
                            <xsl:value-of select="number($pos) + number($adjpos)"/>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="{$colhdrs//Col[number($pos)]/@name}">
                    <xsl:apply-templates select="*:p"/>
                </xsl:attribute>
                <xsl:if test="following-sibling::*:table-cell[*:p]">
                    <xsl:apply-templates select="following-sibling::*:table-cell[1]">
                        <xsl:with-param name="pos">
                            <xsl:value-of select="number($pos) + number($adjpos)"/>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="reptVal">
        <xsl:param name="pos"/>
        <xsl:param name="rpt"/>
        <xsl:param name="val"/>
        <xsl:attribute name="{$colhdrs//Col[number($pos)]/@name}">
            <xsl:value-of select="$val"/>
        </xsl:attribute>
        <xsl:variable name="cnt">
            <xsl:value-of select="number($rpt) - 1"/>
        </xsl:variable>
        <xsl:if test="$cnt &gt; 0">
            <xsl:call-template name="reptVal">
                <xsl:with-param name="pos">
                    <xsl:value-of select="number($pos) + 1"/>
                </xsl:with-param>
                <xsl:with-param name="rpt">
                    <xsl:value-of select="$cnt"/>
                </xsl:with-param>
                <xsl:with-param name="val">
                    <xsl:value-of select="$val"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- Match Element names from Baseline XML Schema-->
    <!--    <xsl:template match="*:table-row">
        <xsl:variable name="R" select="."/>
        <xsl:variable name="Seg">
            <Segment>
                <xsl:for-each select="$colhdrs/*">
                    <xsl:variable name="p" select="position()"/>
                    <xsl:attribute name="{name()}">
                        <xsl:apply-templates select="$R/*:table-cell[position() = $p]/*:p/text()"/>
                        <!-\-<xsl:value-of select="$p"/>-\->
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="name() = 'MSGID'">
                            <xsl:attribute name="MsgId">
                                <xsl:apply-templates select="$R/*:table-cell[position() = $p]/*:p/text()"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="name() = 'REQUIRED_USMTF_CHANGES'">
                            <xsl:if test="not(contains($R/*:table-cell[position() = $p]/*:p[1], 'No changes required'))">
                                <xsl:variable name="newname">
                                    <xsl:apply-templates select="$R/*:table-cell[position() = $p]/*:p/text()"/>
                                </xsl:variable>
                                <xsl:attribute name="ProposedElementName">
                                    <xsl:call-template name="CamelCase">
                                        <xsl:with-param name="txt">
                                            <xsl:value-of select="normalize-space(substring-after($newname, ':'))"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="ProposedFormatName">
                                    <xsl:value-of select="substring-after($newname, ':')"/>
                                </xsl:attribute>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="name() = 'SEGMENTNAME'">
                            <xsl:attribute name="ElementName">
                                <xsl:call-template name="CamelCase">
                                    <xsl:with-param name="txt">
                                        <xsl:apply-templates select="$R/*:table-cell[position() = $p]/*:p/text()"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="name() = 'SEGMENT_NAME'">
                            <xsl:attribute name="ElementName">
                                <xsl:call-template name="CamelCase">
                                    <xsl:with-param name="txt">
                                        <xsl:apply-templates select="$R/*:table-cell[position() = $p]/*:p/text()"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="name() = 'PROPOSED_COMPONENT_NAME'">
                            <xsl:attribute name="ProposedSegmentElement">
                                <xsl:call-template name="CamelCase">
                                    <xsl:with-param name="txt">
                                        <xsl:apply-templates select="$R/*:table-cell[position() = $p]/*:p/text()"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="name() = 'PROPOSED_SEGMENT_TYPE_NAME'">
                            <xsl:attribute name="ProposedSegmentType">
                                <xsl:call-template name="CamelCase">
                                    <xsl:with-param name="txt">
                                        <xsl:apply-templates select="$R/*:table-cell[position() = $p]/*:p/text()"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </Segment>
        </xsl:variable>
        <xsl:if test="not(contains($Seg/Segment/@REQUIRED_USMTF_CHANGES, 'No change')) and not(contains($Seg/Segment/@NewElementName,' ')) and not($Seg/Segment/@NewElementName='')">
            <xsl:copy-of select="$Seg"/>
        </xsl:if>
    </xsl:template>-->
    <!-- Add column date using header attribute names-->
    <xsl:template name="CamelCase">
        <xsl:param name="txt"/>
        <xsl:variable name="FirstChar">
            <xsl:value-of select="upper-case(substring($txt, 1, 1))"/>
        </xsl:variable>
        <xsl:variable name="Lcase">
            <xsl:choose>
                <xsl:when test="contains($txt, '.')">
                    <xsl:value-of select="substring(lower-case(substring-before($txt, '.')), 2)"/>
                    <xsl:call-template name="CamelCase">
                        <xsl:with-param name="txt">
                            <xsl:value-of select="substring-after($txt, '.')"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="contains($txt, ' ')">
                    <xsl:value-of select="substring(lower-case(substring-before($txt, ' ')), 2)"/>
                    <xsl:call-template name="CamelCase">
                        <xsl:with-param name="txt">
                            <xsl:value-of select="substring-after($txt, ' ')"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="lower-case(substring($txt, 2))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($FirstChar, $Lcase)"/>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="translate(translate(normalize-space(.), '&#xA;,', ' '), '&#34;', '')"/>
    </xsl:template>
    <xsl:template match="@*">
        <xsl:value-of select="translate(translate(normalize-space(.), '&#xA;,', ' '), '&#34;', '')"/>
    </xsl:template>
</xsl:stylesheet>
