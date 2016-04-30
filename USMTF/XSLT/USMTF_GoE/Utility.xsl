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
        <Change from="VersionIndicator" to="version"/>
        <Change from="SegmentStructureName" to="name"/>
        <Change from="SegmentStructureConcept" to="concept"/>
        <Change from="SegmentStructureUseDescription" to="usage"/>
        <Change from="SetFormatPositionUseDescription" to="usage"/>
        <Change from="SetFormatPositionName" to="positionName"/>
        <Change from="SetFormatPositionNumber" to="position"/>
        <Change from="SetFormatPositionConcept" to="concept"/>
        <Change from="MtfName" to="name"/>
        <Change from="MtfIdentifier" to="identifier"/>
        <Change from="MtfSponsor" to="sponsor"/>
        <Change from="MtfPurpose" to="purpose"/>
        <Change from="MtfNote" to="note"/>
        <Change from="MtfSponsor" to="sponsor"/>
    </xsl:variable>

    <!-- *************** NODE NAME CHANGES ****************-->
    <xsl:template match="@name" mode="fromtype">
        <xsl:variable name="nm" select="."/>
        <xsl:value-of select="translate(substring($nm, 0, string-length($nm) - 3), '-.', '')"/>
    </xsl:template>
    <xsl:template match="@name" mode="txt">
        <xsl:variable name="t">
            <xsl:choose>
                <xsl:when test="starts-with(., 'f:')">
                    <xsl:value-of select="substring-after(., 'f:')"/>
                </xsl:when>
                <xsl:when test="starts-with(., 's:')">
                    <xsl:value-of select="substring-after(., 's:')"/>
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
    <xsl:template match="xsd:attributeGroup"/>
    <xsl:template match="xsd:attribute[@name = 'ffSeq']"/>
    <xsl:template match="xsd:attribute[@name = 'ffirnFudn']"/>
    <xsl:template match="xsd:attribute[@name = 'setid']"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:integer']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:string']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:decimal']/xsd:annotation"/>

    <!-- ***************** MSGS *****************-->
    <xsl:template match="*:InitialSetFormatPosition" mode="attr"/>
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
    <xsl:template match="*:MtfIndexReferenceNumber" mode="attr"/>
</xsl:stylesheet>
