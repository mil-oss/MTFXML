<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <!--This transform extracts usable XML from MS EXCEL documents saved as XML-->

    <xsl:variable name="msgs" select="document('../../XSD/Baseline_Schemas/messages.xsd')"/>
    <xsl:variable name="sourceDoc" select="document('Segment_DeconflictionEXCEL.xml')"/>
    <xsl:variable name="outputDoc" select="'Segment_Name_Changes.xml'"/>

    <!--Create Attributes from first row labels-->
    <xsl:variable name="attributes">
        <ATTS>
            <xsl:for-each select="$sourceDoc//*:Table/*:Row[1]/*:Cell">
                <xsl:if test="string-length(*:Data/text()) > 0">
                    <xsl:attribute name="{replace(replace(*:Data/text(),' ','_'),':','')}"/>
                </xsl:if>
            </xsl:for-each>
        </ATTS>
    </xsl:variable>

    <!--Create list of all Segments from baseline XML Schemas-->
    <xsl:variable name="mtf_segment_elements">
        <SegmentElements>
            <xsl:for-each select="$msgs/*//*[ends-with(@name, 'Segment')]">
                <xsl:sort select="@name" data-type="text"/>
                <xsl:element name="{@name}">
                    <xsl:attribute name="SegmentStructureName">
                        <xsl:value-of select="*:annotation/*:appinfo/*:SegmentStructureName/text()"
                        />
                    </xsl:attribute>
                </xsl:element>
            </xsl:for-each>
        </SegmentElements>
    </xsl:variable>

    <!--Create list of all Segments identified as having duplicate names in provided Spreadsheet-->
    <xsl:variable name="new_segment_elements">
        <xsl:apply-templates select="$sourceDoc//*:Table"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="{$outputDoc}">
            <USMTF_Segments>
                <xsl:attribute name="count">
                    <xsl:value-of select="count($new_segment_elements/*)"/>
                </xsl:attribute>
                <xsl:copy-of select="$new_segment_elements"/>
            </USMTF_Segments>
        </xsl:result-document>
    </xsl:template>

    <!-- Extract Segments from Spreadsheet XML with required changes identified-->
    <xsl:template match="*:Table">
        <!--NO CHANGES FILTER-->
        <xsl:apply-templates select="*:Row[*:Cell/*:Data]"/>
    </xsl:template>

    <!-- Match Element names from Baseline XML Schema-->
    <xsl:template match="*:Row">
        <xsl:variable name="segname">
            <xsl:value-of select="*:Cell[4]/*:Data/text()"/>
        </xsl:variable>
        <xsl:variable name="newname">
            <xsl:apply-templates select="*:Cell[7]/*:Data/text()"/>
        </xsl:variable>
        <xsl:variable name="Elname">
            <xsl:value-of
                select="substring-before($mtf_segment_elements/SegmentElements/*[@SegmentStructureName = $segname][1]/name(),'Segment')"
            />
        </xsl:variable>
        <xsl:if test="string-length($Elname) > 0">
            <xsl:variable name="ProposedElementName">
                <xsl:choose>
                    <xsl:when test="starts-with(*:Cell[7]/*:Data/text()[1], 'No changes required')">
                        <xsl:value-of select="$Elname"/>
                    </xsl:when>
                    <xsl:when test="starts-with(*:Cell[7]/*:Data/text()[1], 'Change')">
                        <xsl:call-template name="CamelCase">
                            <xsl:with-param name="txt"
                                select="translate(normalize-space(substring-after($newname, ':')),',','')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$Elname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="not($ProposedElementName = $Elname)">
                <xsl:element name="Segment">
                    <xsl:attribute name="MsgId">
                        <xsl:value-of select="*:Cell[1]/*:Data/text()"/>
                    </xsl:attribute>
                    <xsl:attribute name="ElementName">
                        <xsl:value-of select="concat($Elname, 'Segment')"/>
                    </xsl:attribute>
                    <xsl:attribute name="NewFormatName">
                        <xsl:value-of select="normalize-space(substring-after($newname,':'))"/>
                    </xsl:attribute>
                    <xsl:attribute name="NewElementName">
                        <xsl:value-of select="concat($ProposedElementName, 'Segment')"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:if>
            <!--<xsl:apply-templates select="*:Cell"/>-->
        </xsl:if>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="replace(normalize-space(.), '&#34;', '')"/>
    </xsl:template>

    <!-- Add column date using header attribute names-->
    <xsl:template match="*:Cell">
        <xsl:variable name="pos" select="position()"/>
        <xsl:variable name="datatext">
            <xsl:value-of
                select="normalize-space($sourceDoc//*:Table/*:Row[1]/*:Cell[$pos]/*:Data/text())"/>
        </xsl:variable>
        <xsl:if test="string-length(*:Data/text()[1]) > 0">
            <xsl:attribute name="{replace(replace($datatext,' ','_'),':','')}">
                <xsl:value-of select="replace(normalize-space(*:Data/text()[1]), '&#34;', '')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

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

</xsl:stylesheet>
