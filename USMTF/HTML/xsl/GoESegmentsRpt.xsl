<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xhtml" indent="yes"/>

    <xsl:variable name="segmentsdoc" select="document('../../XSD/GoE_Schemas/GoE_segments.xsd')"/>
    <xsl:variable name="setsdoc" select="document('../../XSD/GoE_Schemas/GoE_sets.xsd')"/>
    <xsl:variable name="setfrmshtm" select="document('../set_forms.html')"/>
    <xsl:variable name="fieldfrmshtm" select="document('../field_forms.html')"/>

    <xsl:variable name="makedocs" select="'false'"/>
    <xsl:variable name="makeforms" select="'true'"/>

    <xsl:variable name="docout">
        <xsl:choose>
            <xsl:when test="$makedocs='true' and not($makeforms='true')">
                <xsl:text>segment_info.html</xsl:text>
            </xsl:when>
            <xsl:when test="$makeforms='true' and not($makedocs='true')">
                <xsl:text>segment_forms.html</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>segments.html</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="../{$docout}">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html>
        </xsl:text>
            <html>
                <head>
                    <meta charset="UTF-8"/>
                    <title>USMTF SEGMENTS</title>
                    <link rel="stylesheet" type="text/css" href="css/mtf_fields.css"/>
                </head>
                <body>
                    <xsl:apply-templates select="$segmentsdoc/*/xsd:complexType" mode="seg"/>
                    <script type="text/javascript" src="js/lib/jquery/jquery-2.1.1.min.js"/>
                    <script type="text/javascript" src="js/mtf_info.js"/>
                    <script type="text/javascript" src="js/mtf_form.js"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xsd:complexType" mode="seg">
        <xsl:variable name="seginfo">
            <xsl:copy-of select="xsd:annotation/xsd:appinfo/*:SegmentStructure"/>
        </xsl:variable>
        <div class="segment" id="{@name}">
            <div class="desc">
                <div class="name">
                    <xsl:text>Segment: </xsl:text>
                    <xsl:value-of select="$seginfo/*/@SegmentStructureName"/>
                </div>
                <div class="txt">
                    <b>
                        <xsl:text>Description: </xsl:text>
                    </b>
                    <xsl:value-of select="$seginfo/*/@SegmentStructureUseDescription"/>
                </div>
            </div>
            <div class="info">
                <div class="txt">
                    <b>
                        <xsl:text>Occurrence: </xsl:text>
                    </b>
                    <xsl:value-of select="$seginfo/*/@OccurrenceCategory"/>
                </div>
                <div class="txt">
                    <b>
                        <xsl:text>Repeatability: </xsl:text>
                    </b>
                    <xsl:value-of select="$seginfo/*/@Repeatability"/>
                </div>
                <xsl:if test="xsd:complexType//xsd:element[@fixed]">
                    <div class="txt">
                        <b>
                            <xsl:text>Fixed Value: </xsl:text>
                        </b>
                        <xsl:value-of select="xsd:complexType//xsd:element/@fixed"/>
                    </div>
                </xsl:if>
            </div>
            <div class="setseq">
                <xsl:apply-templates select="xsd:sequence/xsd:element" mode="segdef"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="xsd:element" mode="segdef">
        <xsl:variable name="setid">
            <xsl:choose>
                <xsl:when test="exists(xsd:complexType/xsd:complexContent/xsd:extension/@base)">
                    <xsl:value-of
                        select="substring-after(xsd:complexType/xsd:complexContent/xsd:extension/@base,'set:')"
                    />
                </xsl:when>
                <xsl:when test="exists(@ref)">
                    <xsl:value-of select="substring-after(concat(@ref,'Type'),'set:')"/>
                </xsl:when>
                <xsl:when test="exists(@name)">
                    <xsl:value-of select="concat(@name,'Type')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="setinfo">
            <xsl:copy-of select="xsd:annotation/xsd:appinfo/*:SetFormat"/>
        </xsl:variable>
        <div class="set" id="{$setid}">
            <xsl:if test="$makedocs='true'">
                <div class="desc">
                    <div class="name">
                        <b>
                            <xsl:text>Set: </xsl:text>
                            <xsl:value-of
                                select="normalize-space($setinfo/*/@SetFormatPositionName)"/>
                        </b>
                    </div>
                    <div class="name">
                        <b>
                            <xsl:text>Identifier: </xsl:text>
                            <xsl:value-of
                                select="normalize-space($setinfo/*/@SetFormatPositionName)"/>
                        </b>
                    </div>
                    <div class="txt">
                        <b>
                            <xsl:text>Description: </xsl:text>
                        </b>
                        <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/>
                    </div>
                    <xsl:if test="normalize-space($setinfo/*/@SetFormatPositionUseDescription)">
                        <div class="txt">
                            <b>
                                <xsl:text>Usage: </xsl:text>
                            </b>
                            <xsl:value-of
                                select="normalize-space($setinfo/*/@SetFormatPositionUseDescription)"
                            />
                        </div>
                    </xsl:if>
                </div>
                <div class="info">
                    <div class="txt">
                        <b>
                            <xsl:text>Occurrence: </xsl:text>
                        </b>
                        <xsl:value-of select="$setinfo/*/@OccurrenceCategory"/>
                    </div>
                    <div class="txt">
                        <b>
                            <xsl:text>Repeatability: </xsl:text>
                        </b>
                        <xsl:value-of select="$setinfo/*/@Repeatability"/>
                    </div>
                    <xsl:if test="xsd:complexType//xsd:element[@fixed]">
                        <div class="txt">
                            <b>
                                <xsl:text>Fixed Value: </xsl:text>
                            </b>
                            <xsl:value-of select="xsd:complexType//xsd:element/@fixed"/>
                        </div>
                    </xsl:if>
                </div>
            </xsl:if>
            <xsl:if test="$makeforms='true'">
                <div class="desc">
                    <div class="name">
                        <b>
                            <xsl:text>Set: </xsl:text>
                            <xsl:value-of
                                select="normalize-space($setinfo/*/@SetFormatPositionName)"/>
                        </b>
                    </div>
                    <div class="txt">
                        <b>
                            <xsl:text>Description: </xsl:text>
                        </b>
                        <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/>
                    </div>
                </div>
                <xsl:copy-of select="$setfrmshtm/*//div[@id=$setid]/div[@class='setform']"/>
            </xsl:if>
        </div>
    </xsl:template>

    <!--NESTED SEGEMENTS-->
    <xsl:template match="xsd:element[ends-with(@name,'Segment')]" mode="segdef">
        <xsl:variable name="seginfo">
            <xsl:copy-of select="xsd:annotation/xsd:appinfo/*:SegmentStructure"/>
        </xsl:variable>
        <div class="segment" id="{@name}">
            <div class="desc">
                <div class="name">
                    <xsl:text>Nested Segment: </xsl:text>
                    <xsl:value-of select="$seginfo/*/@SegmentStructureName"/>
                </div>
                <div class="txt">
                    <b>
                        <xsl:text>Description: </xsl:text>
                    </b>
                    <xsl:value-of select="$seginfo/*/@SegmentStructureUseDescription"/>
                </div>
            </div>
            <div class="info">
                <div class="txt">
                    <b>
                        <xsl:text>Occurrence: </xsl:text>
                    </b>
                    <xsl:value-of select="$seginfo/*/@OccurrenceCategory"/>
                </div>
                <div class="txt">
                    <b>
                        <xsl:text>Repeatability: </xsl:text>
                    </b>
                    <xsl:value-of select="$seginfo/*/@Repeatability"/>
                </div>
                <xsl:if test="xsd:complexType//xsd:element[@fixed]">
                    <div class="value">
                        <b>
                            <xsl:text>Fixed Value: </xsl:text>
                        </b>
                        <xsl:value-of select="xsd:complexType//xsd:element/@fixed"/>
                    </div>
                </xsl:if>
            </div>
            <div class="setseq">
                <xsl:apply-templates select="xsd:complexType/xsd:sequence/xsd:element" mode="segdef"
                />
            </div>
        </div>
    </xsl:template>

    <!--FIXED GENTEXT TEXT INDICATOR VALUES -->
    <xsl:template
        match="xsd:element[xsd:complexType/xsd:complexContent/xsd:extension/xsd:sequence/xsd:element[@name='GentextTextIndicator']/@fixed]"
        mode="segdef">
        <div id="{@name}" class="field">
            <xsl:if test="$makedocs='true'">
                <div class="desc">
                    <div class="name">
                        <b>
                            <xsl:text>GENTEXT:  </xsl:text>
                            <xsl:value-of
                                select="xsd:complexType/xsd:complexContent/xsd:extension/xsd:sequence/xsd:element/@fixed"
                            />
                        </b>
                    </div>
                    <xsl:if test="string-length(xsd:annotation/xsd:documentation)>0">
                        <div class="txt">
                            <b>
                                <xsl:text>Description: </xsl:text>
                            </b>
                            <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"
                            />
                        </div>
                    </xsl:if>
                </div>
                <div class="info">
                    <span class="txt">
                        <b>Occurrence: Operationally Determined</b>
                    </span>
                </div>
            </xsl:if>
            <xsl:if test="$makeforms='true'">
                <div class="frm">
                    <div class="txt">
                        <b>GENTEXT: </b>
                        <xsl:value-of
                            select="xsd:complexType/xsd:complexContent/xsd:extension/xsd:sequence/xsd:element[@name='GentextTextIndicator']/@fixed"
                        />
                    </div>
                    <textarea style="display:none;">
                        <xsl:value-of
                            select="xsd:complexType/xsd:complexContent/xsd:extension/xsd:sequence/xsd:element[@name='GentextTextIndicator']/@fixed"
                        />
                    </textarea>
                    <xsl:copy-of select="$fieldfrmshtm//*[@id='FreeTextFieldSimpleType']"/>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
</xsl:stylesheet>
