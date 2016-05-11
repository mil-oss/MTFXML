<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">

    <!-- ************ Identity Transform ***********-->
    <!-- This will allow application of any templates without mode qualifier -->
    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="replace(., '&#34;', '')"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@name">
        <xsl:attribute name="name">
            <xsl:apply-templates select="." mode="txt"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@type">
        <xsl:attribute name="type">
            <xsl:apply-templates select="." mode="txt"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(translate(., '&#34;&#xA;', ''))"/>
    </xsl:template>

    <!-- ************** Copy ***************-->
    <!-- This will NOT allow application of templates that don't use mode="copy" -->
    <xsl:template match="*" mode="copy">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="copy">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="replace(., '&#34;', '')"/>
        </xsl:copy>
    </xsl:template>

    <!-- ************ ELEMENT TO ATTRIBUTE ***********-->
    <xsl:template match="*" mode="attr">
        <xsl:variable name="nm" select="name()"/>
        <xsl:variable name="apos">
            <xsl:text>&apos;</xsl:text>
        </xsl:variable>
        <xsl:variable name="quot">
            <xsl:text>&quot;</xsl:text>
        </xsl:variable>
        <xsl:variable name="attrname">
            <xsl:choose>
                <xsl:when test="$AttrNameChanges/*[@from = $nm]">
                    <xsl:value-of select="normalize-space($AttrNameChanges/*[@from = $nm]/@to)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="txt">
            <xsl:value-of select="replace(normalize-space(.), $quot, $apos)"/>
        </xsl:variable>
        <xsl:if test="string-length($txt) &gt; 0">
            <xsl:attribute name="{$attrname}">
                <xsl:value-of select="$txt"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <!-- **************** NAME CHANGES ***************-->
    <xsl:variable name="AttrNameChanges">
        <Change from="AlphabeticIdentifier" to="identifier"/>
        <Change from="ColumnName" to="column"/>
        <Change from="ColumnHeader" to="column"/>
        <Change from="Justification" to="justification"/>
        <Change from="DataItem" to="dataItem"/>
        <Change from="FieldFormatDefinition" to="definition"/>
        <Change from="FieldDescriptor" to="name"/>
        <Change from="FieldFormatName" to="name"/>
        <Change from="FieldFormatPositionConcept" to="concept"/>
        <Change from="FieldFormatPositionName" to="positionName"/>
        <Change from="FieldFormatRemark" to="remark"/>
        <Change from="FudExplanation" to="explanation"/>
        <Change from="FudName" to="name"/>
        <Change from="SetFormatIdentifier" to="setid"/>
        <Change from="SetFormatName" to="name"/>
        <Change from="SetFormatNote" to="note"/>
        <Change from="SetFormatPositionConcept" to="concept"/>
        <Change from="SetFormatPositionName" to="positionName"/>
        <Change from="SetFormatRemark" to="remark"/>
        <Change from="SetFormatSponsor" to="sponsor"/>
        <Change from="SegmentStructureName" to="name"/>
        <Change from="SegmentStructureConcept" to="concept"/>
        <Change from="SegmentStructureUseDescription" to="usage"/>
        <Change from="SetFormatPositionUseDescription" to="usage"/>
        <Change from="SetFormatPositionNumber" to="position"/>
        <Change from="MtfName" to="name"/>
        <Change from="MtfIdentifier" to="identifier"/>
        <Change from="MtfSponsor" to="sponsor"/>
        <Change from="MtfPurpose" to="purpose"/>
        <Change from="MtfNote" to="note"/>
        <Change from="VersionIndicator" to="version"/>
    </xsl:variable>

    <!-- *************** NODE NAME CHANGES ****************-->
    <xsl:template match="@name" mode="fromtype">
        <xsl:variable name="nm" select="."/>
        <xsl:value-of select="translate(substring($nm, 0, string-length($nm) - 3), '-.', '')"/>
    </xsl:template>
    <xsl:template match="@name" mode="txt">
        <xsl:variable name="refName">
            <xsl:value-of select="substring-before(., '_')"/>
        </xsl:variable>
        <xsl:variable name="n">
            <xsl:choose>
                <xsl:when test="string-length($refName)&gt;0">
                    <xsl:value-of select="$refName"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="t">
            <xsl:choose>
                <xsl:when test="starts-with($n, 'f:')">
                    <xsl:value-of select="substring-after($n, 'f:')"/>
                </xsl:when>
                <xsl:when test="starts-with($n, 'c:')">
                    <xsl:value-of select="substring-after($n, 'c:')"/>
                </xsl:when>
                <xsl:when test="starts-with($n, 's:')">
                    <xsl:value-of select="substring-after($n, 's:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$n"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$t = $NodeNameChanges/*/@from">
                <xsl:value-of select="$NodeNameChanges/*[@from = $t]/@to"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$t"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@type" mode="txt">
        <xsl:variable name="t">
            <xsl:choose>
                <xsl:when test="starts-with(., 'f:')">
                    <xsl:value-of select="substring-after(., 'f:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$t = $NodeNameChanges/*/@from">
                <xsl:value-of select="$NodeNameChanges/*[@from = $t]/@to"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$t"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@base" mode="txt">
        <xsl:variable name="t">
            <xsl:choose>
                <xsl:when test="starts-with(., 'f:')">
                    <xsl:value-of select="substring-after(., 'f:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$t = $NodeNameChanges/*/@from">
                <xsl:value-of select="$NodeNameChanges/*[@from = $t]/@to"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$t"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@name[. = $NodeNameChanges/*/@from]" mode="txt">
        <xsl:variable name="nm" select="."/>
        <xsl:value-of select="$NodeNameChanges/*[@from = $nm]/@to"/>
    </xsl:template>
    <xsl:template match="@type[. = $NodeNameChanges/*/@from]" mode="txt">
        <xsl:variable name="nm" select="."/>
        <xsl:value-of select="$NodeNameChanges/*[@from = $nm]/@to"/>
    </xsl:template>
    <xsl:template match="@name[. = $NodeNameChanges/*/@from]" mode="fromtype">
        <xsl:variable name="nm" select="."/>
        <xsl:variable name="newname">
            <xsl:value-of select="$NodeNameChanges/*[@from = $nm]/@to"/>
        </xsl:variable>
        <xsl:value-of select="substring($newname, 0, string-length($newname) - 3)"/>
    </xsl:template>
    <xsl:template match="@name[. = $NodeNameChanges/*/@from]">
        <xsl:variable name="nm" select="."/>
        <xsl:attribute name="name">
            <xsl:value-of select="$NodeNameChanges/*[@from = $nm]/@to"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@name[. = $NodeNameChanges/*/@from]" mode="copy">
        <xsl:variable name="nm" select="."/>
        <xsl:attribute name="name">
            <xsl:value-of select="$NodeNameChanges/*[@from = $nm]/@to"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@type[. = $NodeNameChanges/*/@from]">
        <xsl:variable name="nm" select="."/>
        <xsl:attribute name="type">
            <xsl:value-of select="$NodeNameChanges/*[@from = $nm]/@to"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@type[. = $NodeNameChanges/*/@from]" mode="copy">
        <xsl:variable name="nm" select="."/>
        <xsl:attribute name="type">
            <xsl:value-of select="$NodeNameChanges/*[@from = $nm]/@to"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@base[. = $NodeNameChanges/*/@from]">
        <xsl:variable name="nm" select="."/>
        <xsl:attribute name="base">
            <xsl:value-of select="$NodeNameChanges/*[@from = $nm]/@to"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@base[. = $NodeNameChanges/*/@from]" mode="copy">
        <xsl:variable name="nm" select="."/>
        <xsl:attribute name="base">
            <xsl:value-of select="$NodeNameChanges/*[@from = $nm]/@to"/>
        </xsl:attribute>
    </xsl:template>

    <!-- ***************** NODE NAME CHANGES *****************-->

    <xsl:variable name="NodeNameChanges">
        <Change from="_100000MeterSquareColumn" to="HundredKMSquareColumn"/>
        <Change from="_100000MeterSquareColumnType" to="HundredKMSquareColumnType"/>
        <Change from="_100000MeterSquareRow" to="HundredKMSquareRow"/>
        <Change from="_100000MeterSquareRowType" to="HundredKMSquareRowType"/>
        <Change from="_5UnitComments" to="FiveUnitComments"/>
        <Change from="_5UnitCommentsType" to="FiveUnitCommentsType"/>
        <Change from="_9UnitComments" to="NineUnitComments"/>
        <Change from="_9UnitCommentsType" to="NineUnitCommentsType"/>
        <Change from="_2DigitYearType" to="TwoDigitYearType"/>
        <Change from="_2DigitYear" to="TwoDigitYear"/>
        <Change from="_4WDispositionGridParametersType" to="FourWhiskeyDispositionGridParametersType"/>
        <Change from="_4WDispositionGridParameters" to="FourWhiskeyDispositionGridParameters"/>
        <Change from="_4WGridSegmentType" to="FourWhiskeySegmentType"/>
        <Change from="_4WGridSegmentType" to="FourWhiskeySegment"/>
        <Change from="_4WGridColumn" to="FourWhiskeyGridColumnType"/>
        <Change from="_4WGridColumn" to="FourWhiskeyGridColumn"/>
        <Change from="_4WGridRow" to="FourWhiskeyGridRowType"/>
        <Change from="_4WGridRow" to="FourWhiskeyGridRow"/>
        <Change from="_4WGridSquareType" to="FourWhiskeyGridSquareType"/>
        <Change from="_4WGridSquareType" to="FourWhiskeyGridSquare"/>
        <Change from="_4WLaneAlphabeticType" to="FourWhiskeyLaneAlphabeticType"/>
        <Change from="_4WLaneAlphabeticType" to="FourWhiskeyLaneAlphabetic"/>
        <Change from="_4WLaneNumeric" to="FourWhiskeyLaneNumericType"/>
        <Change from="_4WLaneNumericType" to="FourWhiskeyLaneNumeric"/>
        <Change from="_4WGridPoint" to="FourWhiskeyGridPoint"/>
        <Change from="_4WGridPointType" to="FourWhiskeyGridPointType"/>
    </xsl:variable>
    <xsl:template name="nodoc">
        <xsd:annotation>
            <xsd:documentation>Data definition required</xsd:documentation>
        </xsd:annotation>
    </xsl:template>

    <!-- ***************** FILTERS *****************-->
    <xsl:template match="*[@name = 'BlankSpaceCharacterType']"/>
    <!--- Remove Pattern from type containing base of xsd:integer -->
    <xsl:template match="xsd:pattern[parent::xsd:restriction/@base = 'xsd:integer']"/>
    <!--- Remove Pattern from type containing base of xsd:decimal -->
    <xsl:template match="xsd:pattern[parent::xsd:restriction/@base = 'xsd:decimal']"/>
    <!--- Remove Pattern from enumerations -->
    <xsl:template match="xsd:restriction/xsd:pattern[exists(parent::xsd:restriction/xsd:enumeration)]"/>
    <xsl:template match="xsd:schema/xsd:element/@minOccurs"/>
    <xsl:template match="xsd:schema/xsd:element/@maxOccurs"/>
    <xsl:template match="xsd:schema/xsd:element/@nillable"/>

    <!-- ***************** FIELDS *****************-->
    <xsl:template match="*:DataCode" mode="attr"/>
    <xsl:template match="*:DataItem"/>
    <xsl:template match="*:DataItemSponsor" mode="attr"/>
    <xsl:template match="*:DataItemSequenceNumber" mode="attr"/>
    <xsl:template match="*:DataType"/>
    <xsl:template match="*:DataType" mode="attr"/>
    <xsl:template match="*:EntryType"/>
    <xsl:template match="*:EntryType" mode="attr"/>
    <xsl:template match="*:Explanation"/>
    <xsl:template match="*:Explanation" mode="attr"/>
    <xsl:template match="*:ffirnFudn" mode="attr"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber" mode="attr"/>
    <xsl:template match="*:FudExplanation"/>
    <xsl:template match="*:FudNumber"/>
    <xsl:template match="*:FudNumber" mode="attr"/>
    <xsl:template match="*:FudRelatedDocument"/>
    <xsl:template match="*:FudRelatedDocument" mode="attr"/>
    <xsl:template match="*:FudSponsor"/>
    <xsl:template match="*:FudSponsor" mode="attr"/>
    <xsl:template match="*:LengthLimitation"/>
    <xsl:template match="*:LengthLimitation" mode="attr"/>
    <xsl:template match="*:LengthVariable"/>
    <xsl:template match="*:LengthVariable" mode="attr"/>
    <xsl:template match="*:MinimumInclusiveValue"/>
    <xsl:template match="*:MinimumInclusiveValue" mode="attr"/>
    <xsl:template match="*:MaximumInclusiveValue"/>
    <xsl:template match="*:MaximumInclusiveValue" mode="attr"/>
    <xsl:template match="*:MinimumLength"/>
    <xsl:template match="*:MinimumLength" mode="attr"/>
    <xsl:template match="*:MaximumLength" mode="attr"/>
    <xsl:template match="*:MtfRegularExpression" mode="attr"/>
    <xsl:template match="*:Type"/>
    <xsl:template match="*:Type" mode="attr"/>
    <xsl:template match="*:UnitOfMeasure"/>
    <xsl:template match="*:UnitOfMeasure" mode="attr"/>
    <xsl:template match="*:VersionIndicator"/>

    <!-- ***************** SETS *****************-->
    <xsl:template match="*:FieldFormatPositionNumber" mode="attr"/>
    <xsl:template match="*:OccurrenceCategory" mode="attr"/>
    <xsl:template match="*:SetFormatExample" mode="attr"/>
    <xsl:template match="*:SetFormatRelatedDocuments" mode="attr"/>
    <xsl:template match="*:RepeatabilityForGroupOfFields" mode="attr"/>
    <xsl:template match="*:SetFormatDescription" mode="attr"/>
    <xsl:template match="*:FieldFormatRelatedDocument" mode="attr"/>
    <xsl:template match="*:GroupOfFieldsIndicator" mode="attr"/>
    <xsl:template match="*:ColumnarIndicator" mode="attr"/>
    <xsl:template match="*:AssignedFfirnFudUseDescription" mode="attr"/>
    <xsl:template match="*:Repeatability" mode="attr"/>
    <xsl:template match="xsd:attributeGroup"/>
    <xsl:template match="xsd:attribute[@name = 'ffSeq']"/>
    <xsl:template match="xsd:attribute[@name = 'ffirnFudn']"/>
    <xsl:template match="xsd:attribute[@name = 'setid']"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:integer']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:string']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:decimal']/xsd:annotation"/>

    <!-- ***************** MSGS *****************-->
    <xsl:template match="*:MtfIndexReferenceNumber" mode="attr"/>
<!--    <xsl:template match="*:InitialSetFormatPosition" mode="attr"/>
    <xsl:template match="*:SegmentStructureName" mode="attr"/>
    <xsl:template match="*:SegmentStructureConcept" mode="attr"/>
    <xsl:template match="*:SegmentStructureUseDescription" mode="attr"/>
    <xsl:template match="*:SetFormatPositionUseDescription" mode="attr"/>
    <xsl:template match="*:SetFormatPositionName" mode="attr"/>
    <xsl:template match="*:SetFormatPositionNumber" mode="attr"/>
    <xsl:template match="*:SetFormatPositionConcept" mode="attr"/>
    <xsl:template match="*:MtfName" mode="attr"/>
    <xsl:template match="*:MtfIdentifier" mode="attr"/>
    <xsl:template match="*:MtfSponsor" mode="attr"/>
    <xsl:template match="*:MtfPurpose" mode="attr"/>
    <xsl:template match="*:VersionIndicator" mode="attr"/>
    <xsl:template match="*:MtfNote" mode="attr"/>        
    <xsl:template match="*:MtfRelatedDocument" mode="attr"/>
    <xsl:template match="*:Repeatability" mode="attr"/>
    <xsl:template match="*:MtfIndexReferenceNumber" mode="attr"/>-->
    
    <!-- ***************** Data Definitions *****************-->
    <xsl:template match="xsd:annotation">
        <xsl:param name="nm"/>
        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="string-length($nm) &gt; 0">
                    <xsl:value-of select="$nm"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="ancestor::*[@name][1]/@name" mode="txt"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="xsd:documentation">
                    <xsl:apply-templates select="xsd:documentation">
                        <xsl:with-param name="nm" select="$name"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsd:documentation>
                        <xsl:choose>
                            <xsl:when test="string-length(xsd:appinfo[1]/*:FudExplanation/text()) &gt; 0">
                                <xsl:value-of select="xsd:appinfo/*:FudExplanation"/>
                            </xsl:when>
                            <xsl:when test="string-length(xsd:appinfo[1]/*:FudName/text()) &gt; 0">
                                <xsl:value-of select="xsd:appinfo/*:FudName"/>
                            </xsl:when>
                            <xsl:when test="xsd:appinfo/*:Field/@explanation">
                                <xsl:value-of select="xsd:appinfo/*:Field/@explanation"/>
                            </xsl:when>
                            <xsl:when test="xsd:appinfo/*:Field/@name">
                                <xsl:value-of select="xsd:appinfo/*:Field/@name"/>
                            </xsl:when>
                            <xsl:when test="string-length(xsd:appinfo[1]/*:SetFormatDescription/text()) &gt; 0">
                                <xsl:value-of select="xsd:appinfo/*:SetFormatDescription"/>
                            </xsl:when>
                            <xsl:when test="string-length(xsd:appinfo[1]/*:SetFormatRemark/text()) &gt; 0">
                                <xsl:value-of select="xsd:appinfo/*:SetFormatRemark"/>
                            </xsl:when>
                            <xsl:when test="string-length(xsd:appinfo[1]/*:SetFormatName/text()) &gt; 0">
                                <xsl:value-of select="xsd:appinfo/*:SetFormatName"/>
                            </xsl:when>
                            <xsl:when test="string-length(xsd:appinfo[1]/*:SetFormatIdentifier/text()) &gt; 0">
                                <xsl:value-of select="xsd:appinfo/*:SetFormatIdentifier"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="breakIntoWords">
                                    <xsl:with-param name="string">
                                        <xsl:value-of select="$name"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsd:documentation>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="xsd:appinfo"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xsd:documentation">
        <xsl:param name="nm"/>
        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="string-length($nm) &gt; 0">
                    <xsl:value-of select="$nm"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="ancestor::*[@name][1]/@name" mode="txt"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="text() and not(text() = 'Data definition required')">
                    <xsl:apply-templates select="text()"/>
                </xsl:when>
                <xsl:when test="parent::xsd:annotation/xsd:appinfo/*:FudExplanation">
                    <xsl:value-of select="normalize-space(xsd:appinfo[1]/*:FudExplanation)"/>
                </xsl:when>
                <xsl:when test="parent::xsd:annotation/xsd:appinfo/*:FudName">
                    <xsl:value-of select="normalize-space(xsd:appinfo[1]/*:FudName)"/>
                </xsl:when>
                <xsl:when test="parent::xsd:annotation/xsd:appinfo/*:Field/@explanation">
                    <xsl:value-of select="parent::*/xsd:appinfo/*:Field/@explanation"/>
                </xsl:when>
                <xsl:when test="parent::xsd:annotation/xsd:appinfo/*:Field/@name">
                    <xsl:value-of select="parent::*/xsd:appinfo/*:Field/@name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="breakIntoWords">
                        <xsl:with-param name="string">
                            <xsl:value-of select="$name"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Field')]]">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="not(*:Field)">
                    <xsl:element name="Field" xmlns="urn:int:nato:mtf:app-11(c):goe:sets">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"> </xsl:apply-templates>
                        <xsl:apply-templates select="ancestor::xsd:element[1]/xsd:complexType/*/xsd:extension/xsd:annotation/xsd:appinfo/*" mode="attr"/> 
                        <xsl:apply-templates select="*:FieldFormatRelatedDocument" mode="docs"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="*:Field" copy-namespaces="no"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xsd:appinfo[child::*[starts-with(name(), 'Set')]]">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="not(*:Set)">
                    <xsl:element name="Set" xmlns="urn:int:nato:mtf:app-11(c):goe:sets">
                        <xsl:apply-templates select="*" mode="attr"/>
                        <xsl:apply-templates select="ancestor::xsd:element[1]/xsd:complexType/xsd:extension/xsd:annotation/xsd:appinfo/*" mode="attr"/>
                        <xsl:apply-templates select="*:SetFormatExample" mode="examples"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="*:Set" copy-namespaces="no"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*:FieldFormatRelatedDocument" mode="docs">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = 'NONE')">
            <xsl:if test="not(preceding-sibling::*:FieldFormatRelatedDocument)">
                <xsl:element name="Document" namespace="urn:int:nato:mtf:app-11(c):goe:sets">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:FieldFormatRelatedDocument">
                    <xsl:element name="Document" namespace="urn:int:nato:mtf:app-11(c):goe:sets">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*:SetFormatExample" mode="examples">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:if test="not(preceding-sibling::*:SetFormatExample)">
                <xsl:element name="Example" namespace="urn:int:nato:mtf:app-11(c):goe:sets">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:SetFormatExample">
                    <xsl:element name="Example" namespace="urn:int:nato:mtf:app-11(c):goe:sets">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- ***************** SPLIT CAMEL CASE *****************-->
    
    <xsl:template name="breakIntoWords">
        <xsl:param name="string" />
        <xsl:choose>
            <xsl:when test="string-length($string) &lt; 2">
                <xsl:value-of select="$string" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="breakIntoWordsHelper">
                    <xsl:with-param name="string" select="$string" />
                    <xsl:with-param name="token" select="substring($string, 1, 1)" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="breakIntoWordsHelper">
        <xsl:param name="string" select="''" />
        <xsl:param name="token" select="''" />
        <xsl:choose>
            <xsl:when test="string-length($string) = 0" />
            <xsl:when test="string-length($token) = 0" />
            <xsl:when test="string-length($string) = string-length($token)">
                <xsl:value-of select="$token" />
            </xsl:when>
            <xsl:when test="contains('ABCDEFGHIJKLMNOPQRSTUVWXYZ',substring($string, string-length($token) + 1, 1))">
                <xsl:value-of select="concat($token, ' ')" />
                <xsl:call-template name="breakIntoWordsHelper">
                    <xsl:with-param name="string" select="substring-after($string, $token)" />
                    <xsl:with-param name="token" select="substring($string, string-length($token), 1)" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="breakIntoWordsHelper">
                    <xsl:with-param name="string" select="$string" />
                    <xsl:with-param name="token" select="substring($string, 1, string-length($token) + 1)" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
