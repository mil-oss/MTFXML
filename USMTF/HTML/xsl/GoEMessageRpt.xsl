<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xhtml" indent="yes"/>

    <xsl:param name="msgid" select="'ATO'"/>

    <xsl:variable name="msgsdoc" select="document('../../XSD/GoE_Schemas/GoE_messages.xsd')"/>
    <xsl:variable name="segmentfrmshtm" select="document('../segments_forms.html')"/>
    <xsl:variable name="setsfrmshtm" select="document('../set_forms.html')"/>
    <xsl:variable name="fieldsfrmshtm" select="document('../field_forms.html')"/>

    <xsl:variable name="makedocs" select="'false'"/>
    <xsl:variable name="makeforms" select="'true'"/>

    <xsl:variable name="docout">
        <xsl:choose>
            <xsl:when test="$makedocs='true' and not($makeforms='true')">
                <xsl:value-of select="concat($msgid,'_doc.html')"/>
            </xsl:when>
            <xsl:when test="$makeforms='true' and not($makedocs='true')">
                <xsl:value-of select="concat($msgid,'_form.html')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($msgid,'_info.html')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="../{$docout}">
            <html>
                <head>
                    <meta charset="UTF-8"/>
                    <title>USMTF MESSAGES</title>
                    <link rel="stylesheet" type="text/css" href="css/mtf_fields.css"/>
                </head>
                <body>
                    <xsl:apply-templates
                        select="$msgsdoc/*/xsd:complexType[xsd:attribute[@name='mtfid'][@fixed=$msgid]]"
                        mode="msg"/>
                    <script type="text/javascript" src="js/lib/jquery/jquery-2.1.1.min.js"/>
                    <script type="text/javascript" src="js/mtf_info.js"/>
                    <script type="text/javascript" src="js/mtf_form.js"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:complexType" mode="msg">
        <xsl:variable name="msginfo">
            <xsl:copy-of select="xsd:annotation/xsd:appinfo/*:MsgInfo"/>
        </xsl:variable>
        <div class="message" id="{@name}">
            <div class="desc">
                <div class="name">
                    <span>
                        <b>
                            <xsl:text>Message: </xsl:text>
                            <xsl:value-of select="$msginfo/*/@MtfName"/>
                        </b>
                    </span>
                </div>
                <div class="txt">
                    <span>
                        <b>
                            <xsl:text>Identifier: </xsl:text>
                        </b>
                        <xsl:value-of select="$msginfo/*/@MtfIdentifier"/>
                    </span>
                </div>
                <div class="txt">
                    <b>
                        <xsl:text>Description: </xsl:text>
                    </b>
                    <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/>
                </div>
            </div>
            <div class="info">
                <div class="txt">
                    <span>
                        <b>
                            <xsl:text>Sponsor: </xsl:text>
                        </b>
                        <xsl:value-of select="$msginfo/*/@MtfSponsor"/>
                    </span>
                </div>
                <div class="txt">
                    <span>
                        <b>
                            <xsl:text>Documents: </xsl:text>
                        </b>
                        <xsl:value-of select="$msginfo/*/@MtfRelatedDocument"/>
                    </span>
                </div>
            </div>
            <div class="dbinfo">
                <div class="txt">
                    <span>
                        <b>
                            <xsl:text>Ref No: </xsl:text>
                        </b>
                        <xsl:value-of select="$msginfo/*/@MtfIndexReferenceNumber"/>
                    </span>
                </div>
                <div class="txt">
                    <span>
                        <b>
                            <xsl:text>Version: </xsl:text>
                        </b>
                        <xsl:value-of select="$msginfo/*/@VersionIndicator"/>
                    </span>
                </div>
            </div>
            <xsl:apply-templates mode="msg"/>
        </div>
    </xsl:template>

    <xsl:template match="xsd:sequence" mode="msg">
        <div class="seq">
            <xsl:apply-templates mode="msg"/>
        </div>
    </xsl:template>

    <xsl:template match="xsd:element[@name]" mode="msg">
        <xsl:variable name="base" select="*//xsd:extension/@base"/>
        <xsl:variable name="ns">
            <xsl:choose>
                <xsl:when test="starts-with($base,'set:')">
                    <xsl:text>set:</xsl:text>
                </xsl:when>
                <xsl:when test="starts-with($base,'field:')">
                    <xsl:text>field:</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>seg:</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="cls">
            <xsl:choose>
                <xsl:when test="$ns='set:'">
                    <xsl:text>set</xsl:text>
                </xsl:when>
                <xsl:when test="$ns='seg:'">
                    <xsl:text>segment</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>field</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
            <xsl:choose>
                <xsl:when test="$ns='seg:'">
                    <div id="{@name}" class="segment">
                    <xsl:copy-of
                        select="$segmentfrmshtm//div[@class='segment'][@id=substring-after($base,$ns)]/*"
                    />
                    </div>
                </xsl:when>
                <xsl:when test="$ns='set:'">
                    <div id="{@name}" class="set">
                    <xsl:copy-of
                        select="$setsfrmshtm//div[@class='set'][@id=substring-after($base,$ns)]/*"/>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div id="{@name}" class="field">
                    <xsl:copy-of
                        select="$fieldsfrmshtm//div[@class='field'][@id=substring-after($base,$ns)]/*"
                    />
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        
    </xsl:template>

    <xsl:template match="xsd:element[@ref]" mode="msg">
        <xsl:variable name="ns">
            <xsl:choose>
                <xsl:when test="starts-with(@ref,'set:')">
                    <xsl:text>set:</xsl:text>
                </xsl:when>
                <xsl:when test="starts-with(@ref,'field:')">
                    <xsl:text>field:</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>seg:</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="refid" select="substring-after(@ref,$ns)"/>
        <xsl:variable name="cls">
            <xsl:choose>
                <xsl:when test="$ns='set:'">
                    <xsl:text>set</xsl:text>
                </xsl:when>
                <xsl:when test="$ns='seg:'">
                    <xsl:text>segment</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>field</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$ns='set:'">
                <xsl:copy-of select="$segmentfrmshtm/*//*[@id=$refid]"/>
            </xsl:when>
            <xsl:when test="$ns='seg:'">
                <xsl:copy-of select="$setsfrmshtm/*//*[@id=$refid]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$fieldsfrmshtm/*//*[@id=$refid]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:choice" mode="msg">
        <div class="choicediv">
            <div class="desc">
                <div class="name">
                    <xsl:text>CHOICE</xsl:text>
                </div>
            </div>
            <div class="info">
                <xsl:choose>
                    <xsl:when test="@minOccurs&gt;0">
                        <span class="tab">
                            <b>Usage: Required</b>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="tab">
                            <b>Usage: Optional</b>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="number(@maxOccurs)&gt;0">
                    <span class="desc tab">
                        <b> Repetition: </b>
                        <xsl:value-of select="@maxOccurs"/>
                    </span>
                </xsl:if>
            </div>
            <xsl:apply-templates mode="msg"/>
        </div>
    </xsl:template>

    <xsd:template match="*" mode="msg">
        <xsl:apply-templates mode="msg"/>
    </xsd:template>

    <xsl:template match="@*" mode="msg"/>
    <xsl:template match="text()" mode="msg"/>

</xsl:stylesheet>
