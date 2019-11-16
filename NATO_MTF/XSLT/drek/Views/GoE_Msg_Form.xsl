<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xhtml" include-content-type="no" omit-xml-declaration="yes" indent="yes"/>

    <xsl:variable name="GoEMsgs" select="document('../../XSD/APP-11C-GoE/natomtf_goe_messages.xsd')"/>

    <xsl:template match="/">
        <xsl:call-template name="makeAllForms"/>
     <!--   <xsl:call-template name="makeMsgForm">
            <xsl:with-param name="msgSchema" select="document('../../IEPD/ATO/ATO_msg.xsd')"/>
            <xsl:with-param name="setsSchema" select="document('../../IEPD/ATO/ATO_sets.xsd')"/>
            <xsl:with-param name="compositesSchema"
                select="document('../../IEPD/ATO/ATO_composites.xsd')"/>
            <xsl:with-param name="fieldsSchema" select="document('../../IEPD/ATO/ATO_fields.xsd')"/>
        </xsl:call-template>-->
    </xsl:template>

    <xsl:template name="makeAllForms">
        <xsl:for-each select="$GoEMsgs/xsd:schema/xsd:complexType">
            <xsl:variable name="msgname" select="xsd:attribute[@name='mtfid']/@fixed"/>
            <xsl:variable name="mid" select="translate($msgname,' .:','')"/>
            <xsl:variable name="mLink" select="concat('../../IEPD/',$mid,'/',$mid,'_msg.xsd')"/>
            <xsl:variable name="sLink" select="concat('../../IEPD/',$mid,'/',$mid,'_sets.xsd')"/>
            <xsl:variable name="cLink"
                select="concat('../../IEPD/',$mid,'/',$mid,'_composites.xsd')"/>
            <xsl:variable name="fLink" select="concat('../../IEPD/',$mid,'/',$mid,'_fields.xsd')"/>
            <xsl:call-template name="makeMsgForm">
                <xsl:with-param name="msgSchema" select="document($mLink)"/>
                <xsl:with-param name="setsSchema" select="document($sLink)"/>
                <xsl:with-param name="compositesSchema" select="document($cLink)"/>
                <xsl:with-param name="fieldsSchema" select="document($fLink)"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="makeMsgForm">
        <xsl:param name="msgSchema"/>
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:variable name="sTypes">
            <xsl:for-each select="$fieldsSchema/xsd:schema/xsd:simpleType">
                <div class="field" id="{@name}">
                   <xsl:apply-templates select="." mode="field"/>
                </div>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="cTypes">
            <xsl:for-each select="$compositesSchema/xsd:schema/xsd:complexType">
                <div class="field" id="{@name}">
                    <div class="doc">
                        <xsl:apply-templates select="." mode="field">
                            <xsl:with-param name="sTypes" select="$sTypes"/>
                        </xsl:apply-templates>
                    </div>
                </div>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="fieldfrms">
            <xsl:copy-of select="$sTypes"/>
            <xsl:copy-of select="$cTypes"/>
        </xsl:variable>
        <xsl:variable name="msgname"
            select="$msgSchema/xsd:schema/xsd:complexType/xsd:attribute[@name='mtfid']/@fixed"/>
        <xsl:variable name="mid" select="translate($msgname,' .:','')"/>
        <xsl:result-document href="{concat('../../IEPD/',$mid,'/',$mid,'_Form.html')}">
            <html>
                <head>
                    <meta charset="UTF-8"/>
                    <title>NATO MTF MESSAGE: <xsl:value-of
                            select="$msgSchema/xsd:schema/xsd:complexType/@name"/></title>
                    <link rel="stylesheet" type="text/css" href="../../HTML/css/mtf_fields.css"/>
                </head>
                <body>
                    <div class="message" id="{$msgSchema/xsd:schema/xsd:complexType/@name}">
                        <xsl:apply-templates select="$msgSchema/xsd:schema/xsd:complexType/*"
                            mode="msg">
                            <xsl:with-param name="setsSchema" select="$setsSchema"/>
                            <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                            <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                            <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
                        </xsl:apply-templates>
                        <!--<xsl:copy-of select="$fieldfrms"/>-->
                    </div>
                    <script type="text/javascript" src="../../HTML/js/lib/jquery/jquery-2.1.1.min.js"/>
                    <script type="text/javascript" src="../../HTML/js/mtf_form.js"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <!--*************************** MESSAGES ************************-->
    <!--*************************************************************-->

    <xsl:template match="xsd:schema/xsd:complexType/xsd:sequence" mode="msg">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <div class="msgseq">
            <xsl:apply-templates select="*" mode="msg">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="xsd:sequence" mode="msg">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <div class="seq">
            <xsl:apply-templates select="*" mode="msg">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="xsd:choice" mode="msg">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <xsl:variable name="border">
            <xsl:if test="@minOccurs!=1">
                <xsl:text>optchceborder</xsl:text>
            </xsl:if>
        </xsl:variable>
        <div class="choicediv {$border}">
            <div class="desc">
                <div class="name">
                    <xsl:text>CHOICE: </xsl:text>
                </div>
            </div>
            <div class="usage">
                <div class="occur">
                    <b>
                        <xsl:text>Occurrence: </xsl:text>
                    </b>
                    <xsl:value-of select="xsd:annotation/xsd:appinfo/*:AltInfo/@AlternativeType"/>
                </div>
                <div class="repeat">
                    <b>
                        <xsl:text>Repeatability: </xsl:text>
                    </b>
                    <xsl:value-of select="@maxOccurs"/>
                </div>
            </div>
            <xsl:apply-templates select="*" mode="msg">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="xsd:element[@ref]" mode="msg">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <xsl:variable name="settag" select="substring-after(@ref,'set:')"/>
        <xsl:variable name="settype"
            select="$setsSchema/xsd:schema/xsd:element[@name=$settag]/@type"/>
        <xsl:variable name="border">
            <xsl:if test="@minOccurs!=1">
                <xsl:text>optsetborder</xsl:text>
            </xsl:if>
        </xsl:variable>
        <div class="set {$border}" id="{$settag}">
            <xsl:apply-templates select="*" mode="msg">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="$setsSchema/xsd:schema/xsd:complexType[@name=$settype]"
                mode="info">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="xsd:element[@name]" mode="msg">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <xsl:variable name="settype">
            <xsl:value-of
                select="substring-after(xsd:complexType/xsd:complexContent/xsd:extension/@base,'set:')"
            />
        </xsl:variable>
        <xsl:variable name="border">
            <xsl:if test="@minOccurs!=1">
                <xsl:text>optsetborder</xsl:text>
            </xsl:if>
        </xsl:variable>
        <div class="set {$border}" style="border:thin green dashed" id="{@name}">
            <xsl:apply-templates select="*" mode="msg">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="$setsSchema/xsd:schema/xsd:complexType[@name=$settype]"
                mode="info">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element[@name]" mode="msg"/>

    <xsl:template match="*:MsgInfo" mode="msg">
        <xsl:variable name="m" select="*"/>
        <div class="msgheader">
            <div class="desc">
                <div class="name">
                    <b>
                        <xsl:text>Message: </xsl:text>
                        <xsl:value-of select="@MtfName"/>
                    </b>
                    <div class="txt">
                        <b>
                            <xsl:text>Identifier: </xsl:text>
                            <xsl:value-of select="@MtfIdentifier"/>
                        </b>
                    </div>
                    <div class="txt">
                        <b>
                            <xsl:text>Description: </xsl:text>
                        </b>
                        <xsl:value-of select="@MtfPurpose"/>
                    </div>
                </div>
            </div>
            <div class="info">
                <div class="txt">
                    <b>
                        <xsl:text>Related Documents:</xsl:text>
                    </b>
                    <xsl:value-of select="@MtfRelatedDocument"/>
                </div>
                <div class="txt">
                    <b>
                        <xsl:text>Version:</xsl:text>
                    </b>
                    <span>
                        <xsl:value-of select="@VersionIndicator"/>
                    </span>
                </div>
                <div class="txt">
                    <b>
                        <xsl:text>Sponsor:</xsl:text>
                    </b>
                    <xsl:value-of select="@MtfSponsor"/>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="*:SetFormat" mode="msg">
        <div class="desc">
            <div class="name">
                <b>
                    <xsl:if test="@SetFormatPositionNumber">
                        <div class="no">
                            <xsl:value-of select="@SetFormatPositionNumber"/>
                            <xsl:text>. </xsl:text>
                        </div>
                    </xsl:if>
                    <xsl:value-of select="concat(@SetFormatPositionName,' SET')"/>
                </b>
            </div>
            <xsl:if test="@SetFormatPositionUseDescription">
                <div class="txt">
                    <b>
                        <xsl:text>Description: </xsl:text>
                    </b>
                    <xsl:value-of select="@SetFormatPositionUseDescription"/>
                </div>
            </xsl:if>
        </div>
        <div class="usage">
            <div class="occur">
                <b>
                    <xsl:text>Occurrence: </xsl:text>
                </b>
                <xsl:value-of select="@OccurrenceCategory"/>
            </div>
            <div class="repeat">
                <b>
                    <xsl:text>Repeatability: </xsl:text>
                </b>
                <xsl:value-of select="@Repeatability"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="*:SegmentStructure" mode="msg">
        <div class="desc">
            <div class="name">
                <b>
                    <xsl:value-of select="@SegmentStructureName"/>
                </b>
            </div>
            <xsl:if test="@SegmentStructureConcept">
                <div class="txt">
                    <b>
                        <xsl:text>Concept: </xsl:text>
                    </b>
                    <xsl:value-of select="@SegmentStructureConcept"/>
                </div>
            </xsl:if>
            <xsl:if test="@SegmentStructureUseDescription">
                <div class="txt">
                    <b>
                        <xsl:text>Description: </xsl:text>
                    </b>
                    <xsl:value-of select="@SegmentStructureUseDescription"/>
                </div>
            </xsl:if>
            <xsl:if test="@VersionIndicator">
                <div class="txt">
                    <b>
                        <xsl:text>Version: </xsl:text>
                    </b>
                    <xsl:value-of select="@VersionIndicator"/>
                </div>
            </xsl:if>
        </div>
        <div class="usage">
            <div class="occur">
                <b>
                    <xsl:text>Occurrence: </xsl:text>
                </b>
                <xsl:value-of select="@OccurrenceCategory"/>
            </div>
            <div class="repeat">
                <b>
                    <xsl:text>Repeatability: </xsl:text>
                </b>
                <xsl:value-of select="@Repeatability"/>
            </div>
        </div>
    </xsl:template>

    <xsd:template match="@*" mode="msg"/>

    <xsd:template match="*" mode="msg">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <xsl:apply-templates select="*" mode="msg">
            <xsl:with-param name="setsSchema" select="$setsSchema"/>
            <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
            <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
            <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
        </xsl:apply-templates>
    </xsd:template>

    <xsl:template match="text()" mode="msg"/>

    <!--**************************** SETS ***************************-->
    <!--*************************************************************-->

    <xsl:template match="xsd:complexType" mode="info">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <xsl:variable name="setinfo" select="xsd:annotation/xsd:appinfo"/>
        <div id="{@name}" class="set">
<!--            <div class="desc">
                <xsl:apply-templates select="$setinfo/*/@SetFormatName[not(.=' ')][not(.='')]"
                    mode="set"> </xsl:apply-templates>
                <xsl:apply-templates
                    select="xsd:annotation/xsd:documentation[not(text()=' ')][not(text()='')]"
                    mode="set"/>
                <xsl:apply-templates select="$setinfo/*/@SetFormatIdentifier[not(.=' ')][not(.='')]"
                    mode="set"/>
                <xsl:apply-templates select="$setinfo/*/@SetFormatNote[not(.=' ')][not(.='')]"
                    mode="set"/>
                <xsl:apply-templates select="$setinfo/*/@SetFormatRemark[not(.=' ')][not(.='')]"
                    mode="set"/>
                <xsl:apply-templates select="$setinfo/*/@SetFormatExample[not(.=' ')][not(.='')]"
                    mode="set"/>
            </div>-->
<!--            <div class="info">
                <xsl:apply-templates
                    select="$setinfo/*/@SetFormatRelatedDocument[not(.=' ')][not(.='')][not(.='NONE')]"
                    mode="set"/>
                <xsl:apply-templates select="$setinfo/*/@VersionIndicator[not(.=' ')][not(.='')]"
                    mode="set"/>
                <xsl:apply-templates select="$setinfo/*/@SetFormatSponsor[not(.=' ')][not(.='')]"
                    mode="set"/>
            </div>-->
            <xsl:apply-templates select="*" mode="info">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="xsd:complexContent" mode="info">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <xsl:apply-templates select="*" mode="info">
            <xsl:with-param name="setsSchema" select="$setsSchema"/>
            <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
            <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
            <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsd:template match="xsd:extension" mode="info">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <xsl:variable name="basetype">
            <xsl:value-of select="substring-after(@base,'field:')"/>
        </xsl:variable>
        <xsl:variable name="ffname">
            <xsl:apply-templates select="$finfo/*/@FieldFormatPositionName[not(.=' ')][not(.='')]"
                mode="fieldname"/>
        </xsl:variable>
        <xsl:apply-templates select="*" mode="info">
            <xsl:with-param name="setsSchema" select="$setsSchema"/>
            <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
            <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
            <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
        </xsl:apply-templates>
    </xsd:template>

    <xsl:template match="xsd:choice" mode="info">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <div class="choicediv">
            <div class="name">
                <span>
                    <xsl:text>CHOICE:</xsl:text>
                </span>
            </div>
            <xsl:apply-templates select="*" mode="info">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="xsd:sequence" mode="info">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <div class="fieldseq">
            <div class="desc">
                <b>SEQUENCE</b>
                <p/>
            </div>
            <div class="usage">
                <div class="occur">
                    <b>
                        <xsl:text>Occurrence: </xsl:text>
                    </b>
                    <xsl:value-of select="@minOccurs"/>
                </div>
                <div class="repeat">
                    <b>
                        <xsl:text>Repeatability: </xsl:text>
                    </b>
                    <xsl:value-of select="@maxOccurs"/>
                </div>
            </div>
            <xsl:apply-templates select="xsd:element" mode="info">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="xsd:element" mode="info">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <xsl:variable name="fmatch">
            <xsl:call-template name="getFieldMatch">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="elementNode" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="typename">
            <xsl:value-of select="$fieldsSchema/xsd:schema/xsd:element[@name=$fmatch]/@type"/>
          <!--  <xsl:choose>
                <xsl:when test="not(ends-with($fmatch,'Type'))">
                    <xsl:value-of select="$fieldsSchema/xsd:schema/xsd:element[@name=$fmatch]/@type"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$fmatch"/>
                </xsl:otherwise>
            </xsl:choose>-->
        </xsl:variable>
        <xsl:variable name="fieldinfo">
            <xsl:copy-of
                select="$fieldsSchema/xsd:schema/xsd:simpleType/xsd:annotation/xsd:appinfo/*:Field"
            />
        </xsl:variable>
        <xsl:variable name="finfo" select="xsd:annotation/xsd:appinfo"/>
        <div class="field">
            <div class="desc">
                <xsl:apply-templates
                    select="$finfo/*/@FieldFormatPositionNumber[not(.=' ')][not(.='')]" mode="set"/>
                <!--           <xsl:apply-templates
                    select="$fieldinfo/*/@FieldFormatPositionNumber[not(.=' ')][not(.='')]"
                    mode="set"/>-->
                <!--            <xsl:apply-templates select="$finfo/*/@AlphabeticIdentifier[not(.=' ')][not(.='')]"
                    mode="set"/> -->
                <xsl:apply-templates
                    select="$finfo/*/@FieldFormatPositionName[not(.=' ')][not(.='')]" mode="set"/>
                <xsl:apply-templates select="$finfo/*/@FieldDescriptor[not(.=' ')][not(.='')]"
                    mode="set"/>
                <xsl:apply-templates
                    select="$finfo/*/@FieldFormatPositionConcept[not(.=' ')][not(.='')]" mode="set"/>
                <!--                <xsl:apply-templates
                    select="$finfo/*/@AssignedFfirnFudUseDescription[not(.=' ')][not(.='')]"
                    mode="set"/>-->
            </div>
            <xsl:call-template name="getInfo">
                <xsl:with-param name="elem" select="."/>
            </xsl:call-template>
            <!--<xsl:value-of select="$fmatch"/>-->
            <xsl:copy-of select="$fieldfrms//div[@id=$typename][1]"/>
            <!--<xsl:call-template name="makeFieldForm">
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldname">
                    <xsl:value-of select="$fmatch"/>
                </xsl:with-param>
                <xsl:with-param name="usage">
                    <xsl:apply-templates
                        select="$finfo/*/@AssignedFfirnFudUseDescription[not(.=' ')][not(.='')]"
                        mode="set"/>
                    <xsl:apply-templates select="$finfo/*/@FieldDescriptor[not(.=' ')][not(.='')]"
                        mode="set"/>
                </xsl:with-param>
                <xsl:with-param name="fieldinfo">
                    <xsl:apply-templates
                        select="$finfo/*/@FieldFormatPositionName[not(.=' ')][not(.='')]"
                        mode="fieldname"/>
                </xsl:with-param>
            </xsl:call-template>-->
            <div class="desc">
                <xsl:apply-templates
                    select="$finfo/*/@AssignedFfirnFudUseDescription[not(.=' ')][not(.='')]"
                    mode="set"/>
            </div>
            <xsl:apply-templates select="*" mode="info">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="xsd:element[@name][@type]" mode="info">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:copy-of select="$fieldfrms//div[@id=$t][1]"/>
        <xsl:apply-templates select="$setsSchema/xsd:schema/xsd:complexType[@name=$t]" mode="info">
            <xsl:with-param name="setsSchema" select="$setsSchema"/>
            <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
            <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
            <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="xsd:element[xsd:complexType/xsd:complexContent/xsd:extension/@base]" mode="info">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <xsl:variable name="n" select="substring-after(xsd:complexType/xsd:complexContent/xsd:extension/@base,'comp:')"/>
        <xsl:variable name="finfo" select="xsd:annotation/xsd:appinfo"/>
        <div class="field" id="{$n}">
            <div class="desc">
                <xsl:apply-templates
                    select="$finfo/*/@FieldFormatPositionNumber[not(.=' ')][not(.='')]" mode="set"/>
                <xsl:apply-templates
                    select="$finfo/*/@FieldFormatPositionName[not(.=' ')][not(.='')]" mode="set"/>
                <xsl:apply-templates
                    select="$finfo/*/@FieldFormatPositionConcept[not(.=' ')][not(.='')]" mode="set"/>
                <xsl:apply-templates
                    select="$finfo/*/@AssignedFfirnFudUseDescription[not(.=' ')][not(.='')]"
                    mode="set"/>
            </div>
            <xsl:call-template name="getInfo">
                <xsl:with-param name="elem" select="."/>
            </xsl:call-template>
            <xsl:copy-of select="$fieldfrms//div[@id=$n][1]"/>
            <xsl:apply-templates mode="info">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="xsd:element[xsd:complexType/xsd:simpleContent/xsd:extension/@base]" mode="info">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <xsl:variable name="n" select="substring-after(xsd:complexType/xsd:simpleContent/xsd:extension/@base,'field:')"/>
        <xsl:variable name="finfo" select="xsd:annotation/xsd:appinfo"/>
        <div class="field" id="{$n}">
            <div class="desc">
                <xsl:apply-templates
                    select="$finfo/*/@FieldFormatPositionNumber[not(.=' ')][not(.='')]" mode="set"/>
                <xsl:apply-templates
                    select="$finfo/*/@FieldFormatPositionName[not(.=' ')][not(.='')]" mode="set"/>
                <xsl:apply-templates
                    select="$finfo/*/@FieldFormatPositionConcept[not(.=' ')][not(.='')]" mode="set"/>
                <xsl:apply-templates
                    select="$finfo/*/@AssignedFfirnFudUseDescription[not(.=' ')][not(.='')]"
                    mode="set"/>
            </div>
            <xsl:call-template name="getInfo">
                <xsl:with-param name="elem" select="."/>
            </xsl:call-template>
            <xsl:copy-of select="$fieldfrms//div[@id=$n][1]"/>
            <xsl:apply-templates mode="info">
                <xsl:with-param name="setsSchema" select="$setsSchema"/>
                <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
                <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
                <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>


    <xsl:template name="getFieldMatch">
        <xsl:param name="setsSchema"/>
        <xsl:param name="elementNode"/>
        <xsl:variable name="stype">
            <xsl:value-of
                select="substring-after(concat($elementNode/*/@ref,'SimpleType'),'field:')"/>
        </xsl:variable>
        <xsl:variable name="ctype">
            <xsl:value-of select="substring-after(concat($elementNode/*/@ref,'Type'),'field:')"/>
        </xsl:variable>
        <xsl:variable name="btype">
            <xsl:value-of select="$elementNode//xsd:extension/@base"/>
        </xsl:variable>
        <xsl:variable name="fid">
            <xsl:choose>
                <xsl:when test="$elementNode/@ref='field:FreeText'">
                    <xsl:text>FreeTextBaseSimpleType</xsl:text>
                </xsl:when>
                <xsl:when test="$elementNode/@ref[starts-with(.,'field:')]">
                    <xsl:value-of select="substring-after(@ref,'field:')"/>
                </xsl:when>
                <xsl:when test="$elementNode//xsd:extension/@base">
                    <xsl:choose>
                        <xsl:when test="starts-with($btype,'field:')">
                            <xsl:value-of select="substring-after($btype,'field:')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$btype"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$elementNode/@name='TextIndicator'">
                    <xsl:text>GentextTextIndicatorSimpleType</xsl:text>
                </xsl:when>
                <xsl:when test="exists($elementNode/@name)">
                    <xsl:value-of select="$elementNode/@name"/>
                </xsl:when>
                <xsl:when test="exists($setsSchema/xsd:schema/xsd:simpleType[@id=$stype])">
                    <xsl:value-of select="$stype"/>
                </xsl:when>
                <xsl:when test="exists($setsSchema/xsd:schema/xsd:complexType[@id=$ctype])">
                    <xsl:value-of select="$ctype"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$ctype"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$fid"/>
    </xsl:template>

    <xsl:template name="getInfo">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="elem"/>
        <div class="usage">
            <div class="occur">
                <b>
                    <xsl:text>Occurrence: </xsl:text>
                </b>
                <xsl:choose>
                    <xsl:when test="$elem/@nillable='true'">
                        <span class="txt">
                            <xsl:text>Required, Nillable</xsl:text>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$elem/@minOccurs"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <div class="repeat">
                <b>
                    <xsl:text>Repeatability: </xsl:text>
                </b>
                <xsl:value-of select="$elem/@minOccurs"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="xsd:complexType[not(@name)]" mode="info">
        <xsl:param name="setsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="fieldfrms"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:apply-templates mode="info">
            <xsl:with-param name="setsSchema" select="$setsSchema"/>
            <xsl:with-param name="compositesSchema" select="$compositesSchema"/>
            <xsl:with-param name="fieldsSchema" select="$fieldsSchema"/>
            <xsl:with-param name="fieldfrms" select="$fieldfrms"/>
        </xsl:apply-templates>
        <xsl:copy-of select="$fieldfrms//div[@id=$t][1]"/>
    </xsl:template>


    <!--*************************** FIELDS **************************-->
    <!--*************************************************************-->

<!--    <xsl:template name="makeFieldForm">
        <xsl:param name="fieldsSchema"/>
        <xsl:param name="compositesSchema"/>
        <xsl:param name="fieldname"/>
        <xsl:param name="usage"/>
        <xsl:param name="fieldinfo"/>
        <xsl:variable name="typename">
            <xsl:choose>
                <xsl:when test="not(ends-with($fieldname,'Type'))">
                    <xsl:value-of
                        select="$fieldsSchema/xsd:schema/xsd:element[@name=$fieldname]/@type"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$fieldname"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <div class="doc">
            <xsl:apply-templates select="$fieldsSchema/xsd:schema/*[@name=$typename]" mode="field">
                <xsl:with-param name="usage" select="$usage"/>
                <xsl:with-param name="fielduse" select="$fieldinfo"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>-->

    <xsl:template match="*" mode="field">
        <xsl:apply-templates select="@*" mode="field"/>
        <xsl:apply-templates select="*" mode="field"/>
    </xsl:template>

    <xsl:template match="xsd:simpleType" mode="field">
        <xsl:param name="usage"/>
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
        <div class="field">
           <!-- <div class="desc">
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
                        <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/>
                    </div>
                </xsl:if>
            </div>-->
<!--            <div class="info">
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
            </div>-->
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
                    <xsl:value-of select="substring-after($usage,'Usage:')"/>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="xsd:restriction " mode="field">
        <xsl:param name="sTypes"/>
        <div>
            <xsl:apply-templates select="*" mode="field">
                <xsl:with-param name="sTypes" select="$sTypes"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="xsd:enumeration" mode="field">
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

    <xsl:template match="xsd:complexType" mode="field">
        <xsl:param name="sTypes"/>
        <xsl:param name="fielduse"/>
        <xsl:variable name="fieldinfo">
            <xsl:choose>
                <xsl:when test="count(xsd:annotation/xsd:appinfo)=1">
                    <xsl:copy-of select="xsd:annotation/xsd:appinfo/*:Field"/>
                </xsl:when>
                <xsl:when test="string-length($fielduse)&gt;0">
                    <xsl:copy-of select="xsd:annotation/xsd:appinfo/*:Field[@FudName=$fielduse]"/>
                </xsl:when>
            </xsl:choose>
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
                                        select="normalize-space(xsd:annotation/xsd:documentation)"/>
                                </i>
                            </span>
                        </xsl:if>
                    </div>
                </div>
                <div class="frmfldseq">
                    <xsl:apply-templates select="xsd:sequence/xsd:element" mode="compform">
                        <xsl:with-param name="sTypes" select="$sTypes"/>
                    </xsl:apply-templates>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="xsd:complexType[count(xsd:annotation/xsd:appinfo)&gt;1]" mode="field">
        <xsl:param name="sTypes"/>
        <xsl:variable name="fieldinfo">
            <xsl:copy-of select="xsd:annotation/xsd:appinfo[1]/*:Field"/>
        </xsl:variable>
        <div id="{@name}" class="field">
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
                                        select="normalize-space(xsd:annotation/xsd:documentation)"/>
                                </i>
                            </span>
                        </xsl:if>
                    </div>
                </div>
                <div class="frmfldseq">
                    <xsl:apply-templates select="xsd:sequence/xsd:element" mode="compform">
                        <xsl:with-param name="sTypes" select="$sTypes"/>
                    </xsl:apply-templates>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="xsd:element" mode="compform">
        <xsl:param name="sTypes"/>
        <xsl:variable name="fldmatch">
            <xsl:choose>
                <xsl:when test="@ref">
                    <xsl:value-of select="substring-after(concat(@ref,'SimpleType'),'field:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(@type,'field:')"/>"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select="$sTypes//div[@id=$fldmatch][1]//div[@class='frm']"/>
    </xsl:template>

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
        <xsl:variable name="cols"/>
        <xsl:choose>
            <xsl:when test="@name='FreeText'">
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

    <xsl:template match="xsd:element[@ref='FreeTextBaseSimpleType']" mode="field">
        <div class="field">
            <div class="desc">
                <div class="name">
                    <b>Field: FREE TEXT FIELD</b>
                </div>
                <div class="txt">
                    <b>Description: </b>THE FREE TEXT INFORMATION EXPRESSED IN NATURAL LANGUAGE. THE
                    FIELD FORMAT LENGTH IS ARTIFICIAL SYMBOLOGY REPRESENTING AN UNRESTRICTED LENGTH
                    FIELD, I.E., THERE IS NO LIMITATION ON THE NUMBER OF CHARACTERS TO BE ENTERED IN
                    THE FIELD. </div>
            </div>
            <div class="frm">
                <xsl:call-template name="makeFreeTextInput"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="makeFreeTextInput">
        <textarea rows="2" class="freetext"/>
    </xsl:template>

    <!--*************************************************************-->
    <!--*************************************************************-->

    <xsl:template match="@*" mode="field"/>
    <xsl:template match="text()" mode="field"/>
    <xsl:template match="@VersionIndicator" mode="field">
        <div class="txt">
            <span class="label">
                <xsl:text>Version:</xsl:text>
            </span>
            <span>
                <xsl:value-of select="."/>
            </span>
        </div>
    </xsl:template>
    <xsl:template match="@FudRelatedDocument" mode="field">
        <div class="txt">
            <span class="label">
                <xsl:text>Related Document:</xsl:text>
            </span>
            <span>
                <xsl:value-of select="."/>
            </span>
        </div>
    </xsl:template>
    <xsl:template match="@SetFormatName">
        <div class="name">
            <b>
                <span>SET: </span>
                <xsl:value-of select="."/>
            </b>
        </div>
    </xsl:template>
    <xsl:template match="xsd:annotation/xsd:documentation" mode="set">
        <div class="txt">
            <b>
                <xsl:text>Description: </xsl:text>
            </b>
            <xsl:value-of select="normalize-space(.)"/>
        </div>
    </xsl:template>
    <xsl:template match="@SetFormatIdentifier" mode="set">
        <div class="txt">
            <b>
                <xsl:text>Identifier: </xsl:text>
                <xsl:value-of select="."/>
            </b>
        </div>
    </xsl:template>
    <xsl:template match="@SetFormatNote" mode="set">
        <div class="txt">
            <b>
                <xsl:text>Note:</xsl:text>
            </b>
            <xsl:value-of select="normalize-space(.)"/>
        </div>
    </xsl:template>
    <xsl:template match="@SetFormatRemark" mode="set">
        <div class="txt">
            <b>
                <xsl:text>Remark:</xsl:text>
            </b>
            <xsl:value-of select="normalize-space(.)"/>
        </div>
    </xsl:template>
    <xsl:template match="@SetFormatExample" mode="set">
        <div class="txt">
            <b>
                <xsl:text>Example:</xsl:text>
            </b>
            <xsl:value-of select="normalize-space(.)"/>
        </div>
    </xsl:template>
    <xsl:template match="@SetFormatRelatedDocument" mode="set">
        <div class="txt">
            <b>
                <xsl:text>Related Documents:</xsl:text>
            </b>
            <xsl:value-of select="normalize-space(.)"/>
        </div>
    </xsl:template>
    <xsl:template match="@VersionIndicator" mode="set">
        <div class="txt">
            <b>
                <xsl:text>Version:</xsl:text>
            </b>
            <xsl:value-of select="normalize-space(.)"/>
        </div>
    </xsl:template>
    <xsl:template match="@SetFormatSponsor" mode="set">
        <div class="txt">
            <b>
                <xsl:text>Sponsor:</xsl:text>
            </b>
            <xsl:value-of select="normalize-space(.)"/>
        </div>
    </xsl:template>
    <xsl:template match="@FieldDescriptor" mode="set">
        <span class="name">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <xsl:template match="@FudName" mode="set">
        <div class="name">
            <b>
                <xsl:text>Field: </xsl:text>
                <xsl:value-of select="."/>
            </b>
        </div>
    </xsl:template>
    <xsl:template match="@FieldFormatName" mode="set">
        <span class="name">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <xsl:template match="@FieldFormatPositionName" mode="set">
        <span class="name">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <xsl:template match="@FieldFormatPositionName" mode="fieldname">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="@FieldFormatPositionNumber" mode="set">
        <b>
            <xsl:value-of select="."/>
            <xsl:text>.</xsl:text>
        </b>
    </xsl:template>
    <xsl:template match="@AlphabeticIdentifier" mode="set">
        <div>
            <xsl:text>Alphabetic Identifier: </xsl:text>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="@FieldFormatPositionConcept" mode="set">
        <div class="txt">
            <b>Description: </b>
            <span>
                <xsl:value-of select="."/>
            </span>
        </div>
    </xsl:template>
    <xsl:template match="@AssignedFfirnFudUseDescription" mode="set">
        <div class="txt">
            <b>Usage: </b>
            <span>
                <xsl:value-of select="."/>
            </span>
        </div>
    </xsl:template>
    <xsl:template match="xsd:annotation/xsd:documentation" mode="set">
        <i>
            <xsl:value-of select="."/>
        </i>
    </xsl:template>
    <xsl:template match="*"/>
    <xsl:template match="@*" mode="set"/>
    <xsl:template match="text()" mode="info"/>
    <xsl:template match="text()" mode="form"/>
    <xsl:template match="text()" mode="set"/>
    <xsl:template match="xsd:schema/xsd:element"/>
</xsl:stylesheet>
