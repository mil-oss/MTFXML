<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xhtml" include-content-type="no" omit-xml-declaration="yes" indent="yes"/>

    <xsl:variable name="fielddoc" select="document('../../XSD/GoE_Schemas/GoE_fields.xsd')"/>

    <xsl:variable name="makedocs" select="'true'"/>
    <xsl:variable name="makeforms" select="'false'"/>

    <xsl:variable name="docout">
        <xsl:choose>
            <xsl:when test="$makedocs='true' and not($makeforms='true')">
                <xsl:text>field_docs.html</xsl:text>
            </xsl:when>
            <xsl:when test="$makeforms='true' and not($makedocs='true')">
                <xsl:text>field_forms.html</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>fields.html</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="simpleTypesRpt">
        <xsl:apply-templates select="$fielddoc/xsd:schema/xsd:simpleType">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="complexTypesRpt">
        <xsl:apply-templates select="$fielddoc/xsd:schema/xsd:complexType">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="../fields/{$docout}">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html>
        </xsl:text>
            <html>
                <head>
                    <meta charset="UTF-8"/>
                    <title>USMTF FIELDS</title>
                    <link rel="stylesheet" type="text/css" href="../css/mtf_fields.css"/>
                </head>
                <body>
                    <div class="fields">
                        <xsl:copy-of select="$complexTypesRpt"/>
                        <xsl:copy-of select="$simpleTypesRpt"/>
                    </div>
                    <script type="text/javascript" src="../js/lib/jquery/jquery-2.1.1.min.js"/>
                    <script type="text/javascript" src="../js/mtf_form.js"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*">
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="xsd:simpleType">
        <xsl:variable name="fieldinfo">
            <xsl:copy-of select="xsd:annotation/xsd:appinfo/*:Field"/>
        </xsl:variable>
        <xsl:variable name="doc">
            <xsl:choose>
                <xsl:when
                    test="string-length(normalize-space(xsd:annotation/xsd:documentation/text()))&gt;0">
                    <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation/text())"
                    />
                </xsl:when>
                <xsl:when
                    test="string-length(normalize-space(xsd:restriction/xsd:annotation/xsd:documentation/text()))&gt;0">
                    <xsl:value-of
                        select="normalize-space(xsd:restriction/xsd:annotation/xsd:documentation/text())"
                    />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="minlen">
            <xsl:choose>
                <xsl:when test="exists(xsd:restriction/xsd:length)">
                    <xsl:value-of select="xsd:restriction/xsd:length/@value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="exists(xsd:restriction/xsd:minLength)">
                            <xsl:value-of select="xsd:restriction/xsd:minLength/@value"/>
                        </xsl:when>
                        <xsl:when test="exists(xsd:restriction/xsd:minInclusive)">
                            <xsl:value-of
                                select="string-length(xsd:restriction/xsd:minInclusive/@value)"/>
                        </xsl:when>
                        <xsl:when test="exists($fieldinfo/*/@MinimumLength)">
                            <xsl:value-of select="$fieldinfo/*/@MinimumLength"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="maxlen">
            <xsl:choose>
                <xsl:when test="exists(*//xsd:length)">
                    <xsl:value-of select="*//xsd:length/@value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="number($fieldinfo/*/@MaximumLength)=-1">
                            <xsl:text>Unlimited</xsl:text>
                        </xsl:when>
                        <xsl:when test="exists(*//xsd:maxLength)">
                            <xsl:value-of select="*//xsd:maxLength/@value"/>
                        </xsl:when>
                        <xsl:when test="exists(*//xsd:maxInclusive)">
                            <xsl:value-of select="string-length(*//xsd:maxInclusive/@value)"/>
                        </xsl:when>
                        <xsl:when test="exists($fieldinfo/*/@MaximumLength)">
                            <xsl:value-of select="$fieldinfo/*/@MaximumLength"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$minlen"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="regx">
            <xsl:value-of select="xsd:restriction/xsd:pattern/@value" disable-output-escaping="no"/>
        </xsl:variable>
        <xsl:variable name="values">
            <div class="values">
                <span class="label">
                    <xsl:text>Values: </xsl:text>
                </span>
                <span class="minval">
                    <xsl:value-of select="xsd:restriction/xsd:minInclusive/@value"/>
                </span>
                <span> - </span>
                <span class="maxval">
                    <xsl:value-of select="xsd:restriction/xsd:maxInclusive/@value"/>
                </span>
            </div>
        </xsl:variable>
        <div id="{@name}" class="field">
            <xsl:if test="$makedocs='true'">
                <div class="desc">
                    <div class="name">
                        <b>
                            <xsl:text>Field: </xsl:text>
                            <xsl:value-of select="$fieldinfo/*/@FudName"/>
                        </b>
                    </div>
                    <xsl:if test="string-length($doc)>0">
                        <div class="txt">
                            <b>
                                <xsl:text>Description: </xsl:text>
                            </b>
                            <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"
                            />
                        </div>
                    </xsl:if>
                </div>
                <div class="enumregex">
                    <div class="txt">
                        <xsl:choose>
                            <xsl:when test="exists(xsd:restriction/xsd:pattern)">
                                <xsl:text>Regex: </xsl:text>
                                <xsl:value-of select="$regx"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <div class="enumtit">
                                    <xsl:text>Enumerations</xsl:text>
                                </div>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <xsl:if test="not(exists(xsd:restriction/xsd:pattern))">
                        <span class="enumcode">
                            <xsl:text>Code</xsl:text>
                        </span>
                        <span class="enumdesc">
                            <xsl:text>Definition</xsl:text>
                        </span>
                        <div class="enumview">
                            <xsl:apply-templates select="xsd:restriction/xsd:enumeration">
                                <xsl:with-param name="len" select="number($maxlen)"/>
                            </xsl:apply-templates>
                        </div>
                    </xsl:if>
                </div>
                <div class="info">
                    <xsl:if test="not(exists(descendant::xsd:enumeration))">
                        <div class="txt">
                            <div>
                                <span class="label">
                                    <xsl:text>Type:</xsl:text>
                                </span>
                                <span>
                                    <xsl:value-of select="$fieldinfo/*/@Type"/>
                                </span>
                            </div>
                        </div>
                    </xsl:if>
                    <div class="txt">
                        <span class="label">Length:</span>
                        <xsl:choose>
                            <xsl:when test="exists(*//xsd:length)">
                                <span>
                                    <xsl:value-of select="$maxlen"/>
                                </span>
                            </xsl:when>
                            <xsl:when test="$minlen=''">
                                <span>
                                    <xsl:value-of select="$maxlen"/>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span>
                                    <xsl:value-of select="$minlen"/>
                                </span>
                                <xsl:if test="$minlen !=$maxlen">
                                    <span> - </span>
                                    <span>
                                        <xsl:value-of select="$maxlen"/>
                                    </span>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <xsl:if
                        test="exists(xsd:restriction/xsd:minInclusive/@value) and exists(xsd:restriction/xsd:maxInclusive/@value)">
                        <xsl:copy-of select="$values"/>
                    </xsl:if>
                    <div class="txt">
                        <span class="label">
                            <xsl:text>Length Limitation:</xsl:text>
                        </span>
                        <span>
                            <xsl:value-of select="$fieldinfo/*/@LengthLimitation"/>
                        </span>
                    </div>
                </div>
                <div class="dbinfo">
                    <div class="txt">
                        <span class="label">
                            <xsl:text>FFIRN-FUD:</xsl:text>
                        </span>
                        <span>
                            <xsl:value-of select="concat($fieldinfo/*/@FieldFormatIndexReferenceNumber,'-',$fieldinfo/*/@FudNumber)"/>
                        </span>
                    </div>
                    <xsl:apply-templates
                        select="$fieldinfo/*/@FudRelatedDocument[not(.='NONE')][not(.='')]"/>
                    <div class="txt">
                        <span class="label">
                            <xsl:text>Version:</xsl:text>
                        </span>
                        <span>
                            <xsl:value-of select="$fieldinfo/*/@VersionIndicator"/>
                        </span>
                    </div>
                </div>
            </xsl:if>
            <xsl:if test="$makeforms='true'">
                <div class="frm">
                    <div class="desc">
                        <div class="name">
                            <b>
                                <xsl:value-of select="$fieldinfo/*/@FudName"/>
                            </b>
                        </div>
                    </div>
                    <div class="frmfld">
                        <xsl:call-template name="makeFormField">
                            <xsl:with-param name="minlen" select="number($minlen)"/>
                            <xsl:with-param name="maxlen" select="number($maxlen)"/>
                        </xsl:call-template>
                    </div>
                    <div class="frmdesc">
                        <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/>
                        <xsl:if
                            test="exists(xsd:restriction/xsd:minInclusive/@value) and exists(xsd:restriction/xsd:maxInclusive/@value)">
                            <xsl:copy-of select="$values"/>
                        </xsl:if>
                    </div>
                </div>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="xsd:restriction ">
        <div>
            <xsl:apply-templates select="*"/>
        </div>
    </xsl:template>

    <xsl:template match="xsd:enumeration">
        <xsl:param name="len"/>
        <div class="enumlisting">
            <div class="enumcode" style="width:{$len+1}ch;">
                <xsl:value-of select="@value"/>
            </div>
            <div class="enumdesc">
                <xsl:value-of select="xsd:annotation/xsd:appinfo/*:Enum/@DataItem"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="xsd:complexType">
        <xsl:variable name="fieldinfo">
            <xsl:copy-of select="xsd:annotation/xsd:appinfo/*:Field"/>
        </xsl:variable>
        <xsl:variable name="fname">
            <xsl:choose>
                <xsl:when test="exists($fieldinfo/*/@FudName)">
                    <xsl:value-of select="$fieldinfo/*/@FudName"/>
                </xsl:when>
                <xsl:when test="@name='AltitudeBandInFeetHundredsOfFeetOrMetersAglOrAmslType'">
                    <xsl:text>ALTITIDE BAND IN HUNDREDS OF FEET OR METERS AGL OR AMSL</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <div id="{@name}" class="field">
            <xsl:if test="$makedocs='true'">
                <div class="desc">
                    <div class="name">
                        <b>
                            <xsl:text>Field: </xsl:text>
                            <xsl:value-of select="$fname"/>
                        </b>
                    </div>
                    <xsl:if test="exists(xsd:annotation/xsd:appinfo)">
                        <div class="txt">
                            <b>
                                <xsl:text>Description: </xsl:text>
                            </b>
                            <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"
                            />
                        </div>
                    </xsl:if>
                </div>
                <xsl:if test="exists(xsd:annotation/xsd:appinfo)">
                    <div class="info">
                        <div class="desc">
                            <span class="label">
                                <xsl:text>Version:</xsl:text>
                            </span>
                            <span>
                                <xsl:value-of select="$fieldinfo/*/@VersionIndicator"/>
                            </span>
                        </div>
                        <xsl:variable name="fdoc"
                            select="normalize-space($fieldinfo/*[1]/@FudRelatedDocument/.)"/>
                        <xsl:if test="not($fdoc = '') and not($fdoc = ' ') and not($fdoc = 'NONE')">
                            <div class="desc">
                                <span class="label">
                                    <xsl:text>Related Document:</xsl:text>
                                </span>
                                <span>
                                    <xsl:value-of select="."/>
                                </span>
                            </div>
                        </xsl:if>
                        <xsl:apply-templates
                            select="$fieldinfo/*/@FudRelatedDocument[not(.='NONE')][not(.='')]"/>
                    </div>
                </xsl:if>
                <div class="fieldseq">
                    <div class="label">Fields:</div>
                    <xsl:apply-templates select="xsd:sequence/xsd:element" mode="compdef"/>
                </div>
            </xsl:if>
            <xsl:if test="$makeforms='true'">
                <div class="frm">
                    <div class="desc">
                        <div class="txt">
                            <b>
                                <xsl:value-of select="$fname"/>
                            </b>
                            <xsl:if test="parent::xsd:schema and exists(xsd:annotation/xsd:appinfo)">
                                <span class="txt">
                                    <b>
                                        <xsl:text>: </xsl:text>
                                    </b>
                                    <i>
                                        <xsl:value-of
                                            select="normalize-space(xsd:annotation/xsd:documentation)"
                                        />
                                    </i>
                                </span>
                            </xsl:if>
                        </div>
                    </div>
                    <div class="frmfldseq">
                        <xsl:apply-templates select="xsd:sequence/xsd:element" mode="compform"/>
                    </div>
                </div>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="xsd:complexType[count(xsd:annotation/xsd:appinfo)&gt;1]">
        <xsl:variable name="fieldinfo">
            <xsl:copy-of select="xsd:annotation/xsd:appinfo[1]/*:Field"/>
        </xsl:variable>
        <div id="{@name}" class="field">
            <xsl:if test="$makedocs='true'">
                <div class="desc">
                    <div class="name">
                        <b>
                            <xsl:text>Field: </xsl:text>
                            <xsl:value-of select="$fieldinfo/*/@FudName"/>
                        </b>
                    </div>
                    <xsl:if test="exists(xsd:annotation/xsd:appinfo)">
                        <div class="txt">
                            <b>
                                <xsl:text>Description: </xsl:text>
                            </b>
                            <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"
                            />
                        </div>
                    </xsl:if>
                </div>
                <xsl:if test="exists(xsd:annotation/xsd:appinfo)">
                    <div class="info">
                        <div class="version">
                            <span class="label">
                                <xsl:text>Version:</xsl:text>
                            </span>
                            <span>
                                <xsl:value-of select="$fieldinfo/*/@VersionIndicator"/>
                            </span>
                        </div>
                        <xsl:variable name="fdoc"
                            select="normalize-space($fieldinfo/*[1]/@FudRelatedDocument/.)"/>
                        <xsl:if test="not($fdoc = '') and not($fdoc = ' ') and not($fdoc = 'NONE')">
                            <div class="txt">
                                <span class="label">
                                    <xsl:text>Related Document:</xsl:text>
                                </span>
                                <span>
                                    <xsl:value-of select="."/>
                                </span>
                            </div>
                        </xsl:if>
                        <xsl:apply-templates
                            select="$fieldinfo/*/@FudRelatedDocument[not(.='NONE')][not(.='')]"/>
                    </div>
                </xsl:if>
                <div class="fieldseq">
                    <div class="label">Fields:</div>
                    <xsl:apply-templates select="xsd:sequence/xsd:element" mode="compdef"/>
                </div>
            </xsl:if>
            <xsl:if test="$makeforms='true'">
                <div class="frm">
                    <div class="desc">
                        <div class="txt">
                            <b>
                                <xsl:value-of select="$fieldinfo/*/@FudName"/>
                            </b>
                            <xsl:if test="parent::xsd:schema and exists(xsd:annotation/xsd:appinfo)">
                                <span class="txt">
                                    <b>
                                        <xsl:text>: </xsl:text>
                                    </b>
                                    <i>
                                        <xsl:value-of
                                            select="normalize-space(xsd:annotation/xsd:documentation)"
                                        />
                                    </i>
                                </span>
                            </xsl:if>
                        </div>
                    </div>
                    <div class="frmfldseq">
                        <xsl:apply-templates select="xsd:sequence/xsd:element" mode="compform"/>
                    </div>
                </div>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="xsd:element" mode="compdef">
        <xsl:variable name="fldmatch">
            <xsl:choose>
                <xsl:when test="@ref">
                    <xsl:value-of select="concat(@ref,'SimpleType')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@type"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <div class="fieldlisting">
            <xsl:copy-of select="$simpleTypesRpt//div[@id=$fldmatch]"/>
        </div>
    </xsl:template>

    <xsl:template match="xsd:element" mode="compform">
        <xsl:variable name="fldmatch">
            <xsl:choose>
                <xsl:when test="@ref">
                    <xsl:value-of select="concat(@ref,'SimpleType')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@type"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select="$simpleTypesRpt//div[@id=$fldmatch]//div[@class='frm'][1]"/>
    </xsl:template>

    <xsl:template match="@*"/>
    <xsl:template match="text()"/>

    <xsl:template name="makeFormField">
        <xsl:param name="minlen"/>
        <xsl:param name="maxlen"/>
        <xsl:variable name="regex">
            <xsl:value-of select="xsd:restriction/xsd:pattern/@value"/>
        </xsl:variable>
        <xsl:variable name="rows">
            <xsl:choose>
                <xsl:when test="not($maxlen)">
                    <xsl:value-of select="1"/>
                </xsl:when>
                <xsl:when test="$maxlen=90">
                    <xsl:value-of select="3"/>
                </xsl:when>
                <xsl:when test="$maxlen=30">
                    <xsl:value-of select="1"/>
                </xsl:when>
                <xsl:when test="number(floor($maxlen div 30)+1)&lt;1">
                    <xsl:value-of select="1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="floor($maxlen div 30)+1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
       <xsl:variable name="cols"></xsl:variable>
        <xsl:choose>
            <xsl:when test="@name='FreeTextFieldSimpleType'">
                <xsl:call-template name="makeFreeTextInput"/>
                <input pattern="{$regex}" style="display:none;"/>
            </xsl:when>
            <xsl:when test="not(exists(xsd:restriction/xsd:enumeration))">
                <xsl:call-template name="makeOverlay">
                    <xsl:with-param name="rows" select="$rows"/>
                    <xsl:with-param name="min" select="$minlen"/>
                    <xsl:with-param name="max" select="$maxlen"/>
                </xsl:call-template>
                <input pattern="{$regex}" style="display:none;"/>
                <textarea cols="29" rows="{$rows}" maxlength="{$maxlen}" spellcheck="false"/>
            </xsl:when>
            <xsl:otherwise>
                <div class="seldiv">
                    <input size="{$maxlen}" spellcheck="false"/>
                    <select>
                        <option value=" "/>
                        <xsl:apply-templates select="xsd:restriction/xsd:enumeration" mode="sel"/>
                    </select>
                </div>
                <div class="selecttxt" style="padding-left:{$maxlen+7}ch;"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="makeOverlay">
        <xsl:param name="rows"/>
        <xsl:param name="min"/>
        <xsl:param name="max"/>
        <xsl:variable name="rowchar30" select="'______________________________'"/>
        <div class="overlay">
            <xsl:choose>
                <xsl:when test="$max&lt;31">
                    <div class="entryline">
                        <xsl:choose>
                            <xsl:when test="$min>29">
                                <span class="reqchar">
                                    <xsl:value-of select="$rowchar30"/>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="reqchar">
                                    <xsl:value-of select="substring($rowchar30,1,$min)"/>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                        <span class="optchar">
                            <xsl:value-of select="substring($rowchar30,1,($max)-$min)"/>
                        </span>
                    </div>
                    <div class="regentryline"/>
                </xsl:when>
                <xsl:when test="$max>30 and $max&lt;61">
                    <div class="entryline">
                        <xsl:choose>
                            <xsl:when test="$min>29">
                                <span class="reqchar">
                                    <xsl:value-of select="$rowchar30"/>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="reqchar">
                                    <xsl:value-of select="substring($rowchar30,1,$min)"/>
                                </span>
                                <span class="optchar">
                                    <xsl:value-of select="substring($rowchar30,1,30-$min)"/>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="regentryline"/>
                    <div class="entryline">
                        <xsl:choose>
                            <xsl:when test="$min>30 and $min&lt;60">
                                <span class="reqchar">
                                    <xsl:value-of select="substring($rowchar30,1,60-$min)"/>
                                </span>
                                <span class="optchar">
                                    <xsl:value-of select="substring($rowchar30,1,30-(60-$min))"/>
                                </span>
                            </xsl:when>
                            <xsl:when test="$min>60">
                                <span class="reqchar">
                                    <xsl:value-of select="$rowchar30"/>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="optchar">
                                    <xsl:value-of select="substring($rowchar30,1,($max)-30)"/>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="regentryline dn1row"/>
                </xsl:when>
                <xsl:when test="$max>60">
                    <div class="entryline">
                        <xsl:choose>
                            <xsl:when test="$min>29">
                                <span class="reqchar">
                                    <xsl:value-of select="$rowchar30"/>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="optchar">
                                    <xsl:value-of select="$rowchar30"/>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="regentryline"/>
                    <div class="entryline">
                        <xsl:choose>
                            <xsl:when test="$min>30 and $min&lt;60">
                                <span class="reqchar">
                                    <xsl:value-of select="substring($rowchar30,1,($min)-30)"/>
                                </span>
                                <span class="optchar">
                                    <xsl:value-of select="substring($rowchar30,1,30-(($min)-30))"/>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="optchar">
                                    <xsl:value-of select="$rowchar30"/>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="regentryline dn1row"/>
                    <div class="entryline">
                        <xsl:choose>
                            <xsl:when test="$min>60">
                                <span class="reqchar">
                                    <xsl:value-of select="substring($rowchar30,1,($min)-60)"/>
                                </span>
                                <span class="optchar">
                                    <xsl:value-of
                                        select="substring($rowchar30,1,($max)-60-($min)-60)"/>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="optchar">
                                    <xsl:value-of select="substring($rowchar30,1,($max)-60)"/>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="regentryline dn2row"/>
                </xsl:when>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template match="xsd:enumeration" mode="sel">
        <option value="{@value}">
            <xsl:value-of select="@value"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="xsd:annotation/xsd:appinfo/*:Enum/@DataItem"/>
        </option>
    </xsl:template>

    <xsl:template match="*[@name='FreeTextBaseSimpleType']"/>

    <xsl:template name="makeFreeTextInput">
        <textarea rows="2" class="freetext"/>
    </xsl:template>

</xsl:stylesheet>
