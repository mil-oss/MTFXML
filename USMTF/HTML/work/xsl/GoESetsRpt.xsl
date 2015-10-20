<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xhtml" indent="yes"/>

    <xsl:variable name="setsdoc" select="document('../../XSD/GoE_Schemas/GoE_sets.xsd')"/>
    <xsl:variable name="fieldfrmshtm" select="document('../fields/field_forms.html')"/>
    <xsl:variable name="fieldsdochtm" select="document('../fields/field_docs.html')"/>
    <xsl:variable name="localTypes">
        <xsl:apply-templates select="$setsdoc/xsd:schema/xsd:complexType[@name='AmplificationType']"/>
        <xsl:apply-templates
            select="$setsdoc/xsd:schema/xsd:complexType[@name='NarrativeInformationType']"/>
        <xsl:apply-templates select="$setsdoc/xsd:schema/xsd:complexType[@name='RemarksType']"/>
    </xsl:variable>
    <xsl:variable name="baseTypes">
        <xsl:apply-templates select="$setsdoc/xsd:schema/xsd:complexType[xsd:sequence]"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:for-each select="$setsdoc/xsd:schema/xsd:complexType">
            <xsl:call-template name="makeSet">
                <xsl:with-param name="setNode" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="makeSet">
        <xsl:param name="setNode"/>
        <xsl:variable name="setId">
            <xsl:value-of select="xsd:annotation/xsd:appinfo/*:SetFormat/@SetFormatIdentifier"/>
        </xsl:variable>
        <xsl:variable name="docout">
            <xsl:value-of select="$setId"/>
            <xsl:text>.html</xsl:text>
        </xsl:variable>
        <xsl:result-document href="../sets/{$docout}">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
            <html>
                <head>
                    <meta charset="UTF-8"/>
                    <title> </title>
                    <link rel="stylesheet" type="text/css" href="../css/mtf_fields.css"/>
                </head>
                <body>
                    <!--<xsl:copy-of select="$baseTypes"/>-->
                    <div class="doc">
                        <xsl:apply-templates select="$setNode/.">
                            <xsl:with-param name="makedocs" select="'true'"/>
                        </xsl:apply-templates>
                    </div>
                    <div class="form">
                        <xsl:apply-templates select="$setNode/.">
                            <xsl:with-param name="makeforms" select="'true'"/>
                        </xsl:apply-templates>
                    </div>
                    <script type="text/javascript" src="../js/lib/jquery/jquery-2.1.1.min.js"/>
                    <script type="text/javascript" src="../js/mtf_form.js"/>
                    <script type="text/javascript" src="../js/mtf_info.js"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <!--Global types defined in Sets schema-->
    <xsl:template match="xsd:schema/xsd:complexType[xsd:sequence][not(@name='SetBaseType')]">
        <xsl:param name="makedocs"/>
        <xsl:param name="makeforms"/>
        <xsl:variable name="setinfo">
            <xsl:copy-of select="./xsd:annotation/xsd:appinfo/*:SetFormat"/>
        </xsl:variable>
        <div id="{@name}" class="set">
            <xsl:call-template name="MakeSetDisplay">
                <xsl:with-param name="setinfo" select="$setinfo"/>
                <xsl:with-param name="makedocs" select="$makedocs"/>
                <xsl:with-param name="makeforms" select="$makeforms"/>
            </xsl:call-template>
            <xsl:apply-templates mode="def">
                <xsl:with-param name="base" select="'true'"/>
                <xsl:with-param name="makedocs" select="$makedocs"/>
                <xsl:with-param name="makeforms" select="$makeforms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <!--Global types for all sets-->
    <xsl:template match="xsd:schema/xsd:complexType[@name='SetBaseType']">
        <div id="{@name}" class="set">
            <div class="name">
                <b>
                    <xsl:text>SET BASE TYPES</xsl:text>
                </b>
            </div>
            <xsl:copy-of select="$localTypes//div[@id='AmplificationType']"/>
            <xsl:copy-of select="$localTypes//div[@id='NarrativeInformationType']"/>
        </div>
    </xsl:template>

    <xsl:template match="xsd:complexType">
        <xsl:param name="makedocs"/>
        <xsl:param name="makeforms"/>
        <xsl:variable name="setinfo">
            <xsl:copy-of select="./xsd:annotation/xsd:appinfo/*:SetFormat"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exists($localTypes/*//*[@id=./@ref])">
                <xsl:copy-of select="$localTypes/*//*[@id=./@ref]"/>
            </xsl:when>
            <xsl:otherwise>
                <div id="{@name}" class="set">
                    <xsl:call-template name="MakeSetDisplay">
                        <xsl:with-param name="setinfo" select="$setinfo"/>
                        <xsl:with-param name="makedocs" select="$makedocs"/>
                        <xsl:with-param name="makeforms" select="$makeforms"/>
                    </xsl:call-template>
                    <xsl:apply-templates mode="def">
                        <xsl:with-param name="makedocs" select="$makedocs"/>
                        <xsl:with-param name="makeforms" select="$makeforms"/>
                    </xsl:apply-templates>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:sequence" mode="def">
        <xsl:param name="makedocs"/>
        <xsl:param name="makeforms"/>
        <xsl:param name="base"/>
        <div class="fieldseq">
            <div class="desc">
                <xsl:if test="@minOccurs&gt;'0'">
                    <span class="txt">
                        <b>Occurrence:</b>
                        <xsl:text>Required</xsl:text>
                    </span>
                </xsl:if>
                <xsl:if test="@maxOccurs&gt;'0'">
                    <span class="txt">
                        <b> Repetition: </b>
                        <xsl:value-of select="@maxOccurs"/>
                    </span>
                </xsl:if>
            </div>
            <xsl:apply-templates mode="def">
                <xsl:with-param name="makedocs" select="$makedocs"/>
                <xsl:with-param name="makeforms" select="$makeforms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="xsd:element" mode="def">
        <xsl:param name="makedocs"/>
        <xsl:param name="makeforms"/>
        <xsl:param name="base"/>
        <xsl:variable name="finfo" select="xsd:annotation/xsd:appinfo/*:FieldFormat"/>
        <xsl:variable name="stype">
            <xsl:value-of select="substring-after(concat(@ref,'SimpleType'),'field:')"/>
        </xsl:variable>
        <xsl:variable name="ctype">
            <xsl:value-of select="substring-after(concat(@ref,'Type'),'field:')"/>
        </xsl:variable>
        <xsl:variable name="btype">
            <xsl:value-of select="*//xsd:extension/@base"/>
        </xsl:variable>
        <xsl:variable name="fid">
            <xsl:choose>
                <xsl:when test="*//xsd:extension/@base">
                    <xsl:choose>
                        <xsl:when test="starts-with($btype,'field:')">
                            <xsl:value-of select="substring-after($btype,'field:')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$btype"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@name='TextIndicator'">
                    <xsl:text>GentextTextIndicatorSimpleType</xsl:text>
                </xsl:when>
                <xsl:when test="exists(@name)">
                    <xsl:value-of select="@name"/>
                </xsl:when>
                <xsl:when test="@ref='field:FreeText'">
                    <xsl:text>FreeTextFieldSimpleType</xsl:text>
                </xsl:when>
                <xsl:when
                    test="exists($fieldfrmshtm/html/body/div[@class='fields']/div[@id=$stype])">
                    <xsl:value-of select="$stype"/>
                </xsl:when>
                <xsl:when
                    test="exists($fieldfrmshtm/html/body/div[@class='fields']/div[@id=$ctype])">
                    <xsl:value-of select="$ctype"/>
                </xsl:when>
                <xsl:when test="not($base) and exists($baseTypes//div[@id=$stype])">
                    <xsl:value-of select="$stype"/>
                </xsl:when>
                <xsl:when test="not($base) and exists($baseTypes//div[@id=$ctype])">
                    <xsl:value-of select="$ctype"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$ctype"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <!--Documentation for fields defined as BaseTypes in the Sets XML Schema-->
            <xsl:when
                test="$fid='AmplificationType' or $fid='NarrativeInformationType' or $fid='RemarksType'">
                <div id="{@name}" class="field">
                    <xsl:if test="$makedocs='true'">
                        <div class="desc">
                            <xsl:copy-of select="$localTypes//*[@id=$fid]//div[@class='desc']"/>
                            <xsl:if
                                test="xsd:annotation/xsd:appinfo/*:FieldFormat/@FieldFormatPositionNumber">
                                <div class="desc">
                                    <b>Sequence: </b>
                                    <xsl:value-of
                                        select="xsd:annotation/xsd:appinfo/*:FieldFormat/@FieldFormatPositionNumber"
                                    />
                                </div>
                            </xsl:if>
                            <xsl:if
                                test="xsd:annotation/xsd:appinfo/*:FieldFormat/@SetFormatIdentifier">
                                <div class="txt">
                                    <b>Identifier: </b>
                                    <xsl:value-of
                                        select="xsd:annotation/xsd:appinfo/*:FieldFormat/@SetFormatIdentifier"
                                    />
                                </div>
                            </xsl:if>
                        </div>
                        <div class="info">
                            <xsl:if test="@minOccurs&gt;'0'">
                                <span class="txt">
                                    <b>Occurrence:</b>
                                    <xsl:text>Required</xsl:text>
                                </span>
                            </xsl:if>
                            <xsl:if test="@minOccurs='0'">
                                <span class="txt">
                                    <b>Occurrence:</b>
                                    <xsl:text>Optional</xsl:text>
                                </span>
                            </xsl:if>
                            <xsl:if test="@maxOccurs&gt;'0'">
                                <span class="txt">
                                    <b> Repetition:</b>
                                    <xsl:value-of select="@maxOccurs"/>
                                </span>
                            </xsl:if>
                            <xsl:if test="@nillable='true'">
                                <span class="txt">
                                    <b>Occurrence:</b>
                                    <xsl:text>Required, Nillable</xsl:text>
                                </span>
                            </xsl:if>
                        </div>
                    </xsl:if>
                    <xsl:if test="$makeforms='true'">
                        <xsl:copy-of select="$localTypes//*[@id=$fid]//div[@class='desc']"/>
                        <xsl:copy-of
                            select="$fieldfrmshtm/html/body/div[@class='fields']//div[@id='FreeTextFieldSimpleType']/div[@class='frm'][1]"
                        />
                    </xsl:if>
                </div>
            </xsl:when>
            <!--Documentation for named composite fields defined in the Sets XML Schema-->
            <xsl:when test="@name">
                <div id="{@name}" class="field">
                    <xsl:if test="$makedocs='true'">
                        <div class="desc">
                            <!--<div><span>FID: </span><span><xsl:value-of select="$fid"/></span></div>-->
                            <!--<xsl:apply-templates select="$finfo/@AlphabeticIdentifier"/>-->
                            <xsl:apply-templates select="$finfo/@FieldFormatPositionNumber"/>
                            <xsl:apply-templates select="$finfo/@FieldFormatPositionName"/>
                            <xsl:apply-templates select="$finfo/@FieldFormatPositionConcept"/>
                        </div>
                        <div class="info">
                            <xsl:if test="@minOccurs&gt;'0'">
                                <span class="txt">
                                    <b>Occurrence:</b>
                                    <xsl:text>Required</xsl:text>
                                </span>
                            </xsl:if>
                            <xsl:if test="@minOccurs='0'">
                                <span class="txt">
                                    <b>Occurrence:</b>
                                    <xsl:text>Optional</xsl:text>
                                </span>
                            </xsl:if>
                            <xsl:if test="@maxOccurs&gt;'0'">
                                <span class="txt">
                                    <b> Repetition:</b>
                                    <xsl:value-of select="@maxOccurs"/>
                                </span>
                            </xsl:if>
                            <xsl:if test="@nillable='true'">
                                <span class="txt">
                                    <b>Occurrence:</b>
                                    <xsl:text>Required, Nillable</xsl:text>
                                </span>
                            </xsl:if>
                        </div>
                        <xsl:copy-of
                            select="$fieldsdochtm/html/body/div[@class='fields']//div[@id=$fid][1]/div[@class='enumregex']"/>
                        <xsl:copy-of
                            select="$fieldsdochtm/html/body/div[@class='fields']//div[@id=$fid][1]/div[@class='info']"/>
                        <xsl:copy-of
                            select="$fieldsdochtm/html/body/div[@class='fields']//div[@id=$fid][1]/div[@class='dbinfo']"/>
                        <xsl:copy-of
                            select="$fieldsdochtm/html/body/div[@class='fields']//div[@id=$fid][1]/div[@class='fieldseq']"
                        />
                    </xsl:if>
                    <xsl:if test="$makeforms='true'">
                        <div class="desc">
                            <xsl:apply-templates select="$finfo/@FieldFormatPositionNumber"/>
                            <xsl:apply-templates select="$finfo/@FieldFormatPositionName"/>
                            <span>: </span>
                            <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
                        </div>
                        <xsl:choose>
                            <xsl:when test="$fieldfrmshtm/html/body/div[@class='fields']//div[@id=$fid]/div[@class='frm']/div[@class='frmfldseq']">
                                <xsl:copy-of
                                    select="$fieldfrmshtm/html/body/div[@class='fields']//div[@id=$fid]/div[@class='frm']/div[@class='frmfldseq'][1]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <div class="frm">
                                    <xsl:copy-of
                                        select="$fieldfrmshtm/html/body/div[@class='fields']//div[@id=$fid]/div[@class='frm']/div[@class='frmfld'][1]"
                                    />
                                </div>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:apply-templates mode="def">
                        <xsl:with-param name="makedocs" select="$makedocs"/>
                        <xsl:with-param name="makeforms" select="$makeforms"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
            <!--Documentation for referenced simple and composite fields defined in the Fields XML Schema-->
            <xsl:otherwise>
                <div id="{$fid}" class="field">
                    <xsl:if test="$makedocs='true'">
                        <div class="desc">
                            <xsl:choose>
                                <xsl:when
                                    test="exists($fieldsdochtm/html/body/div[@class='fields']/div[@id=$fid])">
                                    <xsl:copy-of
                                        select="$fieldsdochtm/html/body/div[@class='fields']/div[@id=$fid]/div[@class='desc']/*"
                                    />
                                </xsl:when>
                                <xsl:when test="not($base) and exists($baseTypes//div[@id=$fid])">
                                    <xsl:copy-of
                                        select="$baseTypes//div[@id=$fid]/div[@class='desc']/*"/>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:apply-templates select="$finfo/*/@FieldFormatPositionNumber"/>
                            <xsl:apply-templates select="$finfo/*/@FieldFormatPositionName"/>
                            <xsl:apply-templates select="$finfo/*/@FieldFormatPositionConcept"/>
                        </div>
                        <div class="info">
                            <xsl:if test="@minOccurs&gt;'0'">
                                <span class="txt">
                                    <b>Occurrence:</b>
                                    <xsl:text>Required</xsl:text>
                                </span>
                            </xsl:if>
                            <xsl:if test="@minOccurs='0'">
                                <span class="txt">
                                    <b>Occurrence: </b>
                                    <xsl:text>Optional</xsl:text>
                                </span>
                            </xsl:if>
                            <xsl:if test="@maxOccurs&gt;'0'">
                                <span class="txt tab">
                                    <b> Repetition:</b>
                                    <xsl:value-of select="@maxOccurs"/>
                                </span>
                            </xsl:if>
                            <xsl:if test="@nillable='true'">
                                <span class="txt">
                                    <b>Occurrence:</b>
                                    <xsl:text>Required, Nillable</xsl:text>
                                </span>
                            </xsl:if>
                        </div>
                        <xsl:copy-of
                            select="$fieldsdochtm/html/body//div[@id=$fid][1]/div[@class='enumregex'][1]"/>
                        <xsl:copy-of
                            select="$fieldsdochtm/html/body//div[@id=$fid][1]/div[@class='info'][1]"/>
                        <xsl:copy-of
                            select="$fieldsdochtm/html/body//div[@id=$fid][1]/div[@class='dbinfo'][1]"/>
                        <xsl:copy-of
                            select="$fieldsdochtm/html/body//div[@id=$fid][1]/div[@class='fieldseq'][1]"
                        />
                    </xsl:if>
                    <xsl:if test="$makeforms='true'">
                        <xsl:choose>
                            <xsl:when
                                test="$finfo/@FieldFormatName or $finfo/@FieldFormatPositionName">
                                <div class="desc">
                                    <xsl:apply-templates select="$finfo/@FieldFormatPositionNumber"/>
                                    <xsl:apply-templates select="$finfo/@FieldFormatPositionName"/>
                                    <span>: </span>
                                    <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
                                </div>
                                <xsl:choose>
                                    <xsl:when test="$fieldfrmshtm/html/body/div[@class='fields']//div[@id=$fid]/div[@class='frm']/div[@class='frmfldseq']">
                                        <xsl:copy-of
                                            select="$fieldfrmshtm/html/body/div[@class='fields']//div[@id=$fid]/div[@class='frm']/div[@class='frmfldseq'][1]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <div class="frm">
                                            <xsl:copy-of
                                                select="$fieldfrmshtm/html/body/div[@class='fields']//div[@id=$fid]/div[@class='frm']/div[@class='frmfld'][1]"
                                            />
                                        </div>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of
                                    select="$fieldfrmshtm/html/body/div[@class='fields']//div[@id=$fid]/div[@class='frm'][1]"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:apply-templates mode="def">
                        <xsl:with-param name="makedocs" select="$makedocs"/>
                        <xsl:with-param name="makeforms" select="$makeforms"/>
                    </xsl:apply-templates>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:choice" mode="def">
        <xsl:param name="makedocs"/>
        <xsl:param name="makeforms"/>
        <xsl:param name="base"/>
        <div class="choicediv">
            <div class="name">
                <span>
                    <xsl:text>CHOICE:</xsl:text>
                </span>
            </div>
            <xsl:apply-templates select="xsd:element" mode="def">
                <xsl:with-param name="makedocs" select="$makedocs"/>
                <xsl:with-param name="makeforms" select="$makeforms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="*" mode="def">
        <xsl:param name="makedocs"/>
        <xsl:param name="makeforms"/>
        <xsl:param name="base"/>
        <xsl:apply-templates mode="def">
            <xsl:with-param name="makedocs" select="$makedocs"/>
            <xsl:with-param name="makeforms" select="$makeforms"/>
            <!--          <xsl:with-param name="base" select="$base"/>-->
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="@*" mode="doc">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template name="MakeSetDisplay">
        <xsl:param name="makedocs"/>
        <xsl:param name="makeforms"/>
        <xsl:param name="setinfo"/>
        <xsl:if test="$makedocs='true'">
            <div class="desc">
                <div class="name">
                    <b>
                        <xsl:text>Set Documentation: </xsl:text>
                        <xsl:value-of select="$setinfo/*/@SetFormatName"/>
                    </b>
                    <xsl:if test="exists($setinfo/*/@SetFormatIdentifier)">
                        <div class="txt">
                            <b>
                                <xsl:text>Identifier: </xsl:text>
                                <xsl:value-of select="$setinfo/*/@SetFormatIdentifier"/>
                            </b>
                        </div>
                    </xsl:if>
                </div>
                <xsl:if test="string-length(normalize-space($setinfo/*/@SetFormatNote))>0">
                    <div class="txt">
                        <b>
                            <xsl:text>Note:</xsl:text>
                        </b>
                        <xsl:value-of select="normalize-space($setinfo/*/@SetFormatNote)"/>
                    </div>
                </xsl:if>
                <xsl:if test="string-length(normalize-space($setinfo/*/@SetFormatRemark))>0">
                    <div class="txt">
                        <b>
                            <xsl:text>Remark:</xsl:text>
                        </b>
                        <xsl:value-of select="normalize-space($setinfo/*/@SetFormatRemark)"/>
                    </div>
                </xsl:if>
                <xsl:if test="string-length(normalize-space($setinfo/*/@SetFormatExample))>0">
                    <div class="txt">
                        <b>
                            <xsl:text>Example:</xsl:text>
                        </b>
                        <xsl:value-of select="normalize-space($setinfo/*/@SetFormatExample)"/>
                    </div>
                </xsl:if>
            </div>
            <div class="info">
                <xsl:if
                    test="string-length(normalize-space($setinfo/*/@SetFormatRelatedDocument))>0">
                    <xsl:if test="$setinfo/*:SetFormatRelatedDocuments[1]/text()!='NONE'">
                        <div class="txt">
                            <b>
                                <xsl:text>Related Documents:</xsl:text>
                            </b>
                            <xsl:apply-templates select="$setinfo/*/@SetFormatRelatedDocument"
                                mode="doc"/>
                        </div>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="string-length(normalize-space($setinfo/*/@VersionIndicator))>0">
                    <div class="txt">
                        <b>
                            <xsl:text>Version:</xsl:text>
                        </b>
                        <span>
                            <xsl:value-of select="$setinfo/*/@VersionIndicator"/>
                        </span>
                    </div>
                </xsl:if>
                <xsl:if test="string-length(normalize-space($setinfo/*/@SetFormatSponsor))>0">
                    <div class="txt">
                        <b>
                            <xsl:text>Sponsor:</xsl:text>
                        </b>
                        <xsl:apply-templates select="$setinfo/*/@SetFormatSponsor" mode="doc"/>
                    </div>
                </xsl:if>
            </div>
        </xsl:if>
        <xsl:if test="$makeforms='true'">
            <div class="desc">
                <div class="name">
                    <b>
                        <xsl:text>Set Form Fields: </xsl:text>
                        <xsl:value-of select="$setinfo/*/@SetFormatName"/>

                    </b>
                    <xsl:if test="exists($setinfo/*/@SetFormatIdentifier)">
                        <div class="txt">
                            <b>
                                <xsl:text>Identifier: </xsl:text>
                                <xsl:value-of select="$setinfo/*/@SetFormatIdentifier"/>
                            </b>
                        </div>
                    </xsl:if>
                </div>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@FieldFormatName">
        <span class="name">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="@FieldFormatPositionName">
        <span class="name">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="@FieldFormatPositionNumber">
        <b>
            <xsl:value-of select="."/>
            <xsl:text>.</xsl:text>
        </b>
    </xsl:template>

    <xsl:template match="@AlphabeticIdentifier">
        <span>
            <xsl:value-of select="."/>
            <xsl:text>. </xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="@FieldFormatPositionConcept">
        <div class="txt">
            <b>Description: </b>
            <span>
                <xsl:value-of select="."/>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="xsd:documentation">
        <i>
            <xsl:value-of select="."/>
        </i>
    </xsl:template>

    <xsl:template match="*"/>
    <xsl:template match="@*"/>
    <xsl:template match="text()" mode="def"/>
    <xsl:template match="xsd:schema/xsd:element"/>
</xsl:stylesheet>
