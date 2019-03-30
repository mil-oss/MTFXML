<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/"
    xmlns:inf="urn:mtf:mil:6040b:appinfo" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/" xmlns:ism="urn:us:gov:ic:ism" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
    exclude-result-prefixes="xs" version="2.0">

    <!-- ************ Identity Transform ***********-->
    <!-- This will allow application of any templates without mode qualifier -->
    <!--<xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>-->
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
    <xsl:template match="@base">
        <xsl:attribute name="base">
            <xsl:apply-templates select="." mode="txt"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(translate(., '&#34;&#xA;', ''))"/>
    </xsl:template>

    <!-- ************** Copy ***************-->
    <!-- This will NOT allow application of templates that don't use mode="copy" -->
    <xsl:template match="*" mode="copy">
        <xsl:copy inherit-namespaces="yes">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="copy">
        <xsl:copy inherit-namespaces="yes">
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
                    <xsl:value-of select="$nm"/>
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
        <!-- <Change from="FieldFormatName" to="fieldname"/>-->
        <Change from="FieldDescriptor" to="fieldid"/>
        <Change from="FieldFormatPositionConcept" to="concept"/>
        <Change from="FieldFormatPositionName" to="positionName"/>
        <Change from="FieldFormatRemark" to="remark"/>
        <Change from="FieldFormatSponsor" to="sponsor"/>
        <Change from="FudExplanation" to="explanation"/>
        <Change from="FudName" to="name"/>
        <Change from="InitialSetFormatPosition" to="initialPosition"/>
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
        <Change from="MtfIdentifier" to="mtfid"/>
        <Change from="MtfSponsor" to="sponsor"/>
        <Change from="MtfPurpose" to="purpose"/>
        <Change from="MtfNote" to="note"/>
        <Change from="VersionIndicator" to="version"/>
        <Change from="AssignedFfirnFudUseDescription" to="usage"/>
    </xsl:variable>

    <!-- *************** NODE NAME CHANGES ****************-->
    <xsl:template match="@name" mode="fromtype">
        <xsl:variable name="n">
            <xsl:apply-templates select="." mode="txt"/>
        </xsl:variable>
        <xsl:value-of select="translate(substring($n, 0, string-length($n) - 3), '-.', '')"/>
    </xsl:template>
    <xsl:template match="@type" mode="fromtype">
        <xsl:variable name="n">
            <xsl:apply-templates select="." mode="txt"/>
        </xsl:variable>
        <xsl:value-of select="translate(substring($n, 0, string-length($n) - 3), '-.', '')"/>
    </xsl:template>
    <xsl:template match="@name" mode="txt">
        <xsl:variable name="refName">
            <xsl:value-of select="substring-before(., '_')"/>
        </xsl:variable>
        <xsl:variable name="n">
            <xsl:choose>
                <xsl:when test="string-length($refName) &gt; 0">
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
            <xsl:when test="$t = $NodeNameChanges/Change/@from">
                <xsl:value-of select="$NodeNameChanges/Change[@from = $t]/@to"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$t"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@type" mode="txt">
        <xsl:variable name="refName">
            <xsl:value-of select="substring-before(., '_')"/>
        </xsl:variable>
        <xsl:variable name="n">
            <xsl:choose>
                <xsl:when test="string-length($refName) &gt; 0">
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
    <xsl:template match="@base" mode="txt">
        <xsl:variable name="t">
            <xsl:choose>
                <xsl:when test="starts-with(., 'f:')">
                    <xsl:value-of select="substring-after(., 'f:')"/>
                </xsl:when>
                <xsl:when test="starts-with(., 'c:')">
                    <xsl:value-of select="substring-after(., 'c:')"/>
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
        <Change from="BlankSpaceCharacter" to="BlankSpace"/>
        <Change from="BlankSpaceCharacterBaseType" to="BlankSpaceType"/>
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
        <Change from="_4WGridSegment" to="FourWhiskeySegment"/>
        <Change from="_4WGridColumnType" to="FourWhiskeyGridColumnType"/>
        <Change from="_4WGridColumn" to="FourWhiskeyGridColumn"/>
        <Change from="_4WGridColumn_1" to="FourWhiskeyGridColumn"/>
        <Change from="_4WGridColumn_2" to="FourWhiskeyGridColumn"/>
        <Change from="_4WGridRowType" to="FourWhiskeyGridRowType"/>
        <Change from="_4WGridRow" to="FourWhiskeyGridRow"/>
        <Change from="_4WGridRow_1" to="FourWhiskeyGridRow"/>
        <Change from="_4WGridRow_2" to="FourWhiskeyGridRow"/>
        <Change from="_4WGridSquareType" to="FourWhiskeyGridSquareType"/>
        <Change from="_4WGridSquare" to="FourWhiskeyGridSquare"/>
        <Change from="_4WLaneAlphabeticType" to="FourWhiskeyLaneAlphabeticType"/>
        <Change from="_4WLaneAlphabetic" to="FourWhiskeyLaneAlphabetic"/>
        <Change from="_4WLaneNumericType" to="FourWhiskeyLaneNumericType"/>
        <Change from="_4WLaneNumeric" to="FourWhiskeyLaneNumeric"/>
        <Change from="_4WGridAssignmentType" to="FourWhiskeyGridAssignmentType"/>
        <Change from="_4WGridAssignment" to="FourWhiskeyGridAssignment"/>
        <Change from="_4WDispositionGridDetails" to="FourWhiskeyDispositionGridDetails"/>
        <Change from="_4WDispositionGridDetailsType" to="FourWhiskeyDispositionGridDetailsType"/>
        <Change from="_4WDispositionPosition" to="FourWhiskeyDispositionPosition"/>
        <Change from="_4WDispositionPositionType" to="FourWhiskeyDispositionPositionType"/>
        <Change from="_4WGridPoint" to="FourWhiskeyGridPoint"/>
        <Change from="_4WGridPointType" to="FourWhiskeyGridPointType"/>
    </xsl:variable>

    <!-- ***************** FILTERS *****************-->
    <xsl:template match="*[@name = 'BlankSpaceCharacterType']">
        <FUCK/>
    </xsl:template>
    <!--- Remove Pattern from type containing base of *:integer -->
    <xsl:template match="*:pattern[parent::*:restriction/@base = '*:integer']"/>
    <!--- Remove Pattern from type containing base of *:decimal -->
    <xsl:template match="*:pattern[parent::*:restriction/@base = '*:decimal']"/>
    <!--- Remove Pattern from enumerations -->
    <xsl:template match="*:restriction/*:pattern[exists(parent::*:restriction/*:enumeration)]"/>
    <xsl:template match="*:schema/*:element/@minOccurs"/>
    <xsl:template match="*:schema/*:element/@maxOccurs"/>
    <xsl:template match="*:schema/*:element/@nillable"/>

    <!-- ***************** FIELDS *****************-->
    <xsl:template match="*:DataCode" mode="attr"/>
    <xsl:template match="*:DataItem"/>
    <xsl:template match="*:DataItemSponsor" mode="attr"/>
    <xsl:template match="*:DataItemSequenceNumber" mode="attr"/>
    <xsl:template match="*:DataType"/>
    <xsl:template match="*:DataType" mode="attr"/>
    <xsl:template match="*:ElementalFfirnFudnSequence" mode="attr"/>
    <xsl:template match="*:EntryType"/>
    <xsl:template match="*:EntryType" mode="attr"/>
    <xsl:template match="*:Explanation"/>
    <xsl:template match="*:Explanation" mode="attr"/>
    <xsl:template match="*:ffirnFudn" mode="attr"/>
    <xsl:template match="*:FieldFormatName"/>
    <xsl:template match="*:FieldFormatName" mode="attr"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber" mode="attr"/>
    <xsl:template match="*:FieldFormatRelatedDocuments" mode="attr"/>
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
    <xsl:template match="*:MtfRelatedDocument" mode="attr"/>
    <xsl:template match="*:VersionIndicator"/>

    <!-- ***************** SETS *****************-->
    <xsl:template match="*:FieldFormatPositionNumber" mode="attr"/>
    <xsl:template match="*:FieldFormatStructure" mode="attr"/>
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
    <xsl:template match="*:attributeGroup"/>
    <xsl:template match="*:attribute[@name = 'ffSeq']"/>
    <xsl:template match="*:attribute[@name = 'ffirnFudn']"/>
    <xsl:template match="*:attribute[@name = 'setid']"/>
    <xsl:template match="*:restriction[@base = '*:integer']/*:annotation"/>
    <xsl:template match="*:restriction[@base = '*:string']/*:annotation"/>
    <xsl:template match="*:restriction[@base = '*:decimal']/*:annotation"/>
    <!-- ***************** SEGMENTS *****************-->
    <xsl:template match="*:AlternativeType" mode="attr"/>
    <!-- ***************** MSGS *****************-->
    <xsl:template match="*:MtfIndexReferenceNumber" mode="attr"/>
    <xsl:template match="*:MtfStructuralRelationship" mode="attr"/>
    <xsl:template match="*:MtfStructuralRelationshipExplanation" mode="attr"/>

    <!-- ***************** Data Definitions *****************-->
    <xsl:template match="*:annotation">
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
        <xs:annotation>
            <xsl:choose>
                <xsl:when test="*:documentation">
                    <xsl:apply-templates select="*:documentation">
                        <xsl:with-param name="nm" select="$name"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="doctxt">
                        <xsl:choose>
                            <xsl:when test="ancestor::*:enumeration">
                                <xsl:value-of select="normalize-space(parent::*:annotation/*:appinfo/*:DataItem/text())"/>
                            </xsl:when>
                            <xsl:when test="parent::*:annotation/*:appinfo/*:FieldFormatDefinition">
                                <xsl:value-of select="normalize-space(*:appinfo[1]/*:FieldFormatDefinition)"/>
                            </xsl:when>
                            <xsl:when test="parent::*:annotation/*:appinfo/*:FieldFormatPositionConcept">
                                <xsl:value-of select="normalize-space(*:appinfo[1]/*:FieldFormatPositionConcept)"/>
                            </xsl:when>
                            <xsl:when test="string-length(*:appinfo[1]/*:FudExplanation/text()) &gt; 0">
                                <xsl:value-of select="*:appinfo/*:FudExplanation"/>
                            </xsl:when>
                            <xsl:when test="string-length(*:appinfo[1]/*:FudName/text()) &gt; 0">
                                <xsl:value-of select="*:appinfo/*:FudName"/>
                            </xsl:when>
                            <xsl:when test="*:appinfo/*:Field/@explanation">
                                <xsl:value-of select="*:appinfo/*:Field/@explanation"/>
                            </xsl:when>
                            <xsl:when test="*:appinfo/*:Field/@name">
                                <xsl:value-of select="*:appinfo/*:Field/@name"/>
                            </xsl:when>
                            <xsl:when test="string-length(*:appinfo[1]/*:SetFormatDescription/text()) &gt; 0">
                                <xsl:value-of select="*:appinfo/*:SetFormatDescription"/>
                            </xsl:when>
                            <!--<xsl:when test="string-length(*:appinfo[1]/*:SetFormatRemark/text()) &gt; 0">
                                <xsl:value-of select="*:appinfo/*:SetFormatRemark"/>
                            </xsl:when>-->
                            <xsl:when test="string-length(*:appinfo[1]/*:SetFormatName/text()) &gt; 0">
                                <xsl:value-of select="*:appinfo/*:SetFormatName"/>
                            </xsl:when>
                            <xsl:when test="string-length(*:appinfo[1]/*:SetFormatIdentifier/text()) &gt; 0">
                                <xsl:value-of select="*:appinfo/*:SetFormatIdentifier"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="breakIntoWords">
                                    <xsl:with-param name="string">
                                        <xsl:value-of select="$name"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA" ism:noticeType="DoD-Dist-A">
                        <xsl:choose>
                            <xsl:when test="starts-with($doctxt, 'A data type for')">
                                <xsl:value-of select="."/>
                            </xsl:when>
                            <xsl:when test="ends-with($doctxt, 'Simple Type')">
                                <xsl:value-of select="concat('A data type for ', lower-case(substring-before($doctxt, 'Simple Type')))"/>
                            </xsl:when>
                            <xsl:when test="ends-with($doctxt, 'Type')">
                                <xsl:value-of select="concat('A data type for ', lower-case(substring-before($doctxt, 'Type')))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('A data type for ', lower-case($doctxt))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xs:documentation>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="*:appinfo"/>
        </xs:annotation>
    </xsl:template>

    <xsl:template match="*:annotation" mode="doc">
        <xs:annotation>
            <xsl:apply-templates select="*:documentation"/>
        </xs:annotation>
    </xsl:template>

    <xsl:template match="*:documentation">
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
        <xsl:variable name="doctxt">
            <xsl:choose>
                <xsl:when test="text() and not(text() = 'Data definition required')">
                    <xsl:apply-templates select="text()"/>
                </xsl:when>
                <xsl:when test="ancestor::*:enumeration">
                    <xsl:value-of select="normalize-space(parent::*:annotation/*:appinfo/*:DataItem/text())"/>
                </xsl:when>
                <xsl:when test="parent::*:annotation/*:appinfo/*:FieldFormatDefinition">
                    <xsl:value-of select="normalize-space(*:appinfo[1]/*:FieldFormatDefinition)"/>
                </xsl:when>
                <xsl:when test="parent::*:annotation/*:appinfo/*:FieldFormatPositionConcept">
                    <xsl:value-of select="normalize-space(*:appinfo[1]/*:FieldFormatPositionConcept)"/>
                </xsl:when>
                <xsl:when test="parent::*:annotation/*:appinfo/*:FudExplanation">
                    <xsl:value-of select="normalize-space(*:appinfo[1]/*:FudExplanation)"/>
                </xsl:when>
                <xsl:when test="parent::*:annotation/*:appinfo/*:FudName">
                    <xsl:value-of select="normalize-space(*:appinfo[1]/*:FudName)"/>
                </xsl:when>
                <xsl:when test="parent::*:annotation/*:appinfo/*:Field/@explanation">
                    <xsl:value-of select="parent::*/*:appinfo/*:Field/@explanation"/>
                </xsl:when>
                <xsl:when test="parent::*:annotation/*:appinfo/*:Field/@name">
                    <xsl:value-of select="parent::*/*:appinfo/*:Field/@name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="breakIntoWords">
                        <xsl:with-param name="string">
                            <xsl:value-of select="$name"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xs:documentation ism:classification="U" ism:ownerProducer="USA" ism:noticeType="DoD-Dist-A">
            <xsl:choose>
                <xsl:when test="starts-with($doctxt, 'A data type for')">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:when test="ends-with($doctxt, 'Simple Type')">
                    <xsl:value-of select="concat('A data type for ', lower-case(substring-before($doctxt, 'Simple Type')))"/>
                </xsl:when>
                <xsl:when test="ends-with($doctxt, 'Type')">
                    <xsl:value-of select="concat('A data type for ', lower-case(substring-before($doctxt, 'Type')))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('A data type for ', concat(lower-case(substring($doctxt, 1, 1)), substring($doctxt, 2)))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xs:documentation>
    </xsl:template>

    <xsl:template match="*:appinfo">
        <xsl:param name="appattr"/>
        <xs:appinfo>
            <xsl:choose>
                <xsl:when test="*:Enum">
                    <xsl:copy-of select="*:Enum"/>
                </xsl:when>
                <xsl:when test="*:Field">
                    <xsl:copy-of select="*:Field"/>
                </xsl:when>
                <xsl:when test="*:Composite">
                    <xsl:copy-of select="*:Composite"/>
                </xsl:when>
                <xsl:when test="*:Set">
                    <xsl:copy-of select="*:Set"/>
                </xsl:when>
                <xsl:when test="*:Segment">
                    <xsl:copy-of select="*:Segment"/>
                </xsl:when>
                <xsl:when test="*:Segment">
                    <xsl:copy-of select="*:Segment"/>
                </xsl:when>
                <xsl:when test="*:Msg">
                    <xsl:copy-of select="*:Msg"/>
                </xsl:when>
                <xsl:when test="child::*[starts-with(name(), 'Field')] and starts-with(ancestor::*:element[1]/*:complexType/*/*:extension/@base, 'c:')">
                    <xsl:element name="inf:Composite">
                        <!--<xsl:apply-templates select="@*[not(name()='name')]"/>-->
                        <xsl:apply-templates select="*" mode="attr"/>
                        <xsl:apply-templates select="ancestor::*:element[1]/*:complexType/*/*:extension/*:annotation/*:appinfo/*" mode="attr"/>
                        <xsl:if test="$appattr">
                            <xsl:apply-templates select="$appattr" mode="addattr"/>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="$appattr and $appattr/@dist = 'C'">
                                <xsl:attribute name="dist">
                                    <xsl:text>C</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="diststatement">
                                    <xsl:text>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use.</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="dist">
                                    <xsl:text>A</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="diststatement">
                                    <xsl:text>DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.</xsl:text>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates select="*:FieldFormatRelatedDocument" mode="docs"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="child::*[starts-with(name(), 'Field')]">
                    <xsl:element name="inf:Field">
                        <xsl:apply-templates select="*" mode="attr"/>
                        <xsl:apply-templates select="ancestor::*:element[1]/*:complexType/*/*:extension/*:annotation/*:appinfo/*" mode="attr"/>
                        <xsl:if test="$appattr">
                            <xsl:apply-templates select="$appattr" mode="addattr"/>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="$appattr and $appattr/@dist = 'C'">
                                <xsl:attribute name="dist">
                                    <xsl:text>C</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="diststatement">
                                    <xsl:text>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use.</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="dist">
                                    <xsl:text>A</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="diststatement">
                                    <xsl:text>DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.</xsl:text>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates select="*:FieldFormatRelatedDocument" mode="docs"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="child::*[starts-with(name(), 'Set')]">
                    <xsl:element name="inf:Set">
                        <xsl:apply-templates select="*" mode="attr"/>
                        <xsl:apply-templates select="ancestor::*:element[1]/*:complexType/*:extension/*:annotation/*:appinfo/*" mode="attr"/>
                        <xsl:if test="$appattr">
                            <xsl:apply-templates select="$appattr" mode="addattr"/>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="$appattr and $appattr/@dist = 'C'">
                                <xsl:attribute name="dist">
                                    <xsl:text>C</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="diststatement">
                                    <xsl:text>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use.</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="dist">
                                    <xsl:text>A</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="diststatement">
                                    <xsl:text>DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.</xsl:text>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates select="*:SetFormatExample" mode="examples"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="child::*[starts-with(name(), 'Segment')]">
                    <xsl:element name="inf:Segment">
                        <xsl:apply-templates select="*" mode="attr"/>
                        <xsl:apply-templates select="ancestor::*:element[1]/*:complexType/*:extension/*:annotation/*:appinfo/*" mode="attr"/>
                        <xsl:if test="$appattr">
                            <xsl:apply-templates select="$appattr" mode="addattr"/>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="$appattr and $appattr/@dist = 'C'">
                                <xsl:attribute name="dist">
                                    <xsl:text>C</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="diststatement">
                                    <xsl:text>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use.</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="dist">
                                    <xsl:text>A</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="diststatement">
                                    <xsl:text>DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.</xsl:text>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="child::*[starts-with(name(), 'Mtf')]">
                    <xsl:element name="inf:Msg">
                        <xsl:apply-templates select="*" mode="attr"/>
                        <xsl:apply-templates select="ancestor::*:element[1]/*:complexType/*:extension/*:annotation/*:appinfo/*" mode="attr"/>
                        <xsl:if test="$appattr">
                            <xsl:apply-templates select="$appattr" mode="addattr"/>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="$appattr and $appattr/@dist = 'C'">
                                <xsl:attribute name="dist">
                                    <xsl:text>C</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="diststatement">
                                    <xsl:text>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use.</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="dist">
                                    <xsl:text>A</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="diststatement">
                                    <xsl:text>DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.</xsl:text>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:when>
            </xsl:choose>
        </xs:appinfo>
    </xsl:template>

    <xsl:template match="*" mode="addattr">
        <xsl:copy-of select="@version" copy-namespaces="no"/>
        <xsl:copy-of select="@versiondate" copy-namespaces="no"/>
        <xsl:copy-of select="@fud" copy-namespaces="no"/>
        <xsl:copy-of select="@ffirn" copy-namespaces="no"/>
        <xsl:copy-of select="@dist" copy-namespaces="no"/>
        <xsl:apply-templates select="@abbrev" mode="hascontent"/>
        <xsl:apply-templates select="@reldoc" mode="hascontent"/>
        <xsl:apply-templates select="@remarks" mode="hascontent"/>
    </xsl:template>

    <xsl:template match="@*" mode="hascontent">
        <xsl:if test=". != '.' and . != ''">
            <xsl:copy-of select="."/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:appinfo[child::*[starts-with(name(), 'Elemental')]]"/>

    <xsl:template match="*:enumeration/*:annotation">
        <xs:annotation>
            <xsl:element name="documentation" ism:classification="U" ism:ownerProducer="USA" ism:noticeType="DoD-Dist-A">
                <xsl:value-of select="normalize-space(*:appinfo/*:DataItem/text())"/>
            </xsl:element>
            <xsl:apply-templates select="*:appinfo"/>
        </xs:annotation>
    </xsl:template>

    <xsl:template match="*:enumeration/*:annotation/*:appinfo">
        <xs:appinfo>
            <xsl:element name="inf:Code">
                <xsl:apply-templates select="*" mode="attr"/>
            </xsl:element>
        </xs:appinfo>
    </xsl:template>

    <xsl:template match="*:FieldFormatRelatedDocument" mode="docs">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '') and not(normalize-space(text()) = 'NONE')">
            <xsl:if test="not(preceding-sibling::*:FieldFormatRelatedDocument)">
                <xsl:element name="inf:Document" inherit-namespaces="yes">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:FieldFormatRelatedDocument">
                    <xsl:element name="inf:Document" inherit-namespaces="yes">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:SetFormatExample" mode="examples">
        <xsl:if test="not(normalize-space(text()) = ' ') and not(*) and not(normalize-space(text()) = '')">
            <xsl:if test="not(preceding-sibling::*:SetFormatExample)">
                <xsl:element name="inf:Example" inherit-namespaces="yes">
                    <xsl:value-of select="normalize-space(text())"/>
                </xsl:element>
                <xsl:for-each select="following-sibling::*:SetFormatExample">
                    <xsl:element name="inf:Example" inherit-namespaces="yes">
                        <xsl:value-of select="normalize-space(text())"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- ***************** SPLIT CAMEL CASE *****************-->

    <xsl:template name="CamelCase">
        <xsl:param name="text"/>
        <xsl:variable name="t" select="translate($text, ',/()-', '')"/>
        <xsl:choose>
            <xsl:when test="contains($t, ' ')">
                <xsl:call-template name="CamelCaseWord">
                    <xsl:with-param name="text" select="substring-before($t, ' ')"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="CamelCase">
                    <xsl:with-param name="text" select="substring-after($t, ' ')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="CamelCaseWord">
                    <xsl:with-param name="text" select="$t"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="CamelCaseWord">
        <xsl:param name="text"/>
        <xsl:value-of select="translate(substring($text, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        <xsl:value-of select="translate(substring($text, 2, string-length($text) - 1), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
    </xsl:template>

    <xsl:template name="breakIntoWords">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="string-length($string) &lt; 2">
                <xsl:value-of select="$string"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="breakIntoWordsHelper">
                    <xsl:with-param name="string" select="$string"/>
                    <xsl:with-param name="token" select="substring($string, 1, 1)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="breakIntoWordsHelper">
        <xsl:param name="string" select="''"/>
        <xsl:param name="token" select="''"/>
        <xsl:choose>
            <xsl:when test="string-length($string) = 0"/>
            <xsl:when test="string-length($token) = 0"/>
            <xsl:when test="string-length($string) = string-length($token)">
                <xsl:value-of select="$token"/>
            </xsl:when>
            <xsl:when test="contains('ABCDEFGHIJKLMNOPQRSTUVWXYZ', substring($string, string-length($token) + 1, 1))">
                <xsl:value-of select="concat($token, ' ')"/>
                <xsl:call-template name="breakIntoWordsHelper">
                    <xsl:with-param name="string" select="substring-after($string, $token)"/>
                    <xsl:with-param name="token" select="substring($string, string-length($token), 1)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="breakIntoWordsHelper">
                    <xsl:with-param name="string" select="$string"/>
                    <xsl:with-param name="token" select="substring($string, 1, string-length($token) + 1)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="codeSimpleTypeName">
        <xsl:param name="ntext"/>
        <xsl:choose>
            <xsl:when test="ends-with($ntext, 'CodeType')">
                <xsl:value-of select="concat(substring($ntext, 0, string-length($ntext) - 3), 'SimpleType')"/>
            </xsl:when>
            <xsl:when test="ends-with($ntext, 'Code')">
                <xsl:value-of select="replace($ntext, 'Code', 'ValueCodeSimpleType')"/>
            </xsl:when>
            <xsl:when test="ends-with($ntext, 'TypeType')">
                <xsl:value-of select="concat(substring($ntext, 0, string-length($ntext) - 3), 'CodeSimpleType')"/>
            </xsl:when>
            <xsl:when test="ends-with($ntext, 'Type')">
                <xsl:value-of select="concat($ntext, 'CodeSimpleType')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($ntext, 'CodeSimpleType')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="codeTypeName">
        <xsl:param name="ntext"/>
        <xsl:choose>
            <xsl:when test="ends-with($ntext, 'CodeType')">
                <xsl:value-of select="concat(substring($ntext, 0, string-length($ntext) - 3), 'SimpleType')"/>
            </xsl:when>
            <xsl:when test="ends-with($ntext, 'Code')">
                <xsl:value-of select="concat($ntext, 'SimpleType')"/>
            </xsl:when>
            <xsl:when test="ends-with($ntext, 'Type')">
                <xsl:value-of select="concat(substring($ntext, 0, string-length($ntext) - 3), 'CodeSimpleType')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- *********** NIEM Representation Terms **************-->

    <xsl:variable name="neimterms">
        <NIEMTerms>
            <Term txt="Amount"/>
            <Term txt="BinaryObject"/>
            <Term txt="Graphic"/>
            <Term txt="Picture"/>
            <Term txt="Sound"/>
            <Term txt="Video"/>
            <Term txt="Code"/>
            <Term txt="DateTime"/>
            <Term txt="Date"/>
            <Term txt="Time"/>
            <Term txt="Duration"/>
            <Term txt="ID"/>
            <Term txt="URI"/>
            <Term txt="Indicator"/>
            <Term txt="Measure"/>
            <Term txt="Numeric"/>
            <Term txt="Value"/>
            <Term txt="Rate"/>
            <Term txt="Percent"/>
            <Term txt="Quantity"/>
            <Term txt="Text"/>
            <Term txt="Name"/>
            <Term txt="List"/>
        </NIEMTerms>
    </xsl:variable>

    <xsl:template name="niemTerm">
        <xsl:param name="str"/>
        <xsl:for-each select="$neimterms/NIEMTerms/Term">
            <xsl:if test="ends-with($str, @txt)">
                <NIEMTerm txt="{@txt}"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:variable name="niemschemadoc">
        <xs:appinfo>
            <term:LocalTerm term="Email" literal="Electronic Mail"/>
            <term:LocalTerm term="ICAO" literal="International Civil Aviation Organization"/>
            <term:LocalTerm term="ID" literal="Identifier"/>
            <term:LocalTerm term="Lat" literal="Latitude"/>
            <term:LocalTerm term="Long" literal="Longitude"/>
            <term:LocalTerm term="MGRS" literal="Military Grid Reference System"/>
            <term:LocalTerm term="NICS" literal="NATO Integrated Communications System"/>
            <term:LocalTerm term="SIC" literal="Subject Identifier Code"/>
            <term:LocalTerm term="UTM" literal="Universal Transverse Mercator"/>
            <ddms:security ism:classification="U" ism:ownerProducer="USA" ism:nonICmarkings="DIST_STMT_C"/>
            <Distro
                statement="DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use. Other requests for this document shall be referred to Defense Information Systems Agency Interoperability Directorate. WARNING - This document contains technical data whose export is restricted by the Arms Export Control Act (Title 22, U.S.C., Sec. 2751) or the Export Administration Act of 1979, as amended, Title 50, U.S.C., App. 2401. Violations of these export laws are subject to severe criminal penalties.  Disseminate in accordance with provisions of DOD Directive 5230.25."
            />
        </xs:appinfo>
    </xsl:variable>

    <!-- ***************** ********** *****************-->

    <xsl:template name="removeStrings">
        <xsl:param name="targetStr"/>
        <xsl:param name="strings"/>
        <xsl:variable name="str">
            <xsl:choose>
                <xsl:when test="contains($strings, ',')">
                    <xsl:value-of select="normalize-space(substring-before($strings, ','))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$strings"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string-length($str) &gt; 0">
                <xsl:call-template name="removeStrings">
                    <xsl:with-param name="targetStr" select="replace($targetStr, $str, '')"/>
                    <xsl:with-param name="strings" select="substring-after($strings, ',')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$targetStr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ***************** ********** *****************-->

    <xsl:template match="@*" mode="appinfoatts">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="@dist" mode="appinfoatts"/>

    <xsl:template match="@diststatement" mode="appinfoatts">
        <xsl:attribute name="dist">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="*" mode="normlize">
        <xsl:value-of select="normalize-space(translate(., '&#34;&#xA;', ''))"/>
    </xsl:template>

</xsl:stylesheet>
