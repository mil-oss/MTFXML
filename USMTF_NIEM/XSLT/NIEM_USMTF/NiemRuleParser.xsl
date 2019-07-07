<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2019 JD NEUSHUL
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:sch="http://purl.oclc.org/dsdl/schematron" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="Outdir" select="'../../XSD/Analysis/Rules/'"/>

    <xsl:variable name="fixrules" select="document('../../XSD/Analysis/Rules/fixrules.xml')/FixRules"/>

    <xsl:variable name="messages_xsd" select="document('../../XSD/Baseline_Schema/messages.xsd')"/>

    <xsl:variable name="msgxsd" select="document('../../XSD/Baseline_Schema/messages.xsd')"/>
    <xsl:variable name="setxsd" select="document('../../XSD/Baseline_Schema/sets.xsd')"/>
    <xsl:variable name="compxsd" select="document('../../XSD/Baseline_Schema/composites.xsd')"/>

    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="a" select='"&apos;"'/>
    <xsl:variable name="lb" select='"["'/>
    <xsl:variable name="rb" select='"]"'/>
    <xsl:variable name="cr">
        <xsl:text>&#10;</xsl:text>
    </xsl:variable>
    <xsl:variable name="slashend">
        <xsl:text>/)</xsl:text>
    </xsl:variable>
    <xsl:variable name="rp">
        <xsl:text>)</xsl:text>
    </xsl:variable>

    <xsl:variable name="ffisel">
        <!--<List>-->
        <field sel="FF3-4" name="StandardAirRequestNumber"/>
        <field sel="FF956-14" name="NumberOfDmpisPassed"/>
        <field sel="FF679-4" name="OriginalClassificationAuthority"/>
        <field sel="FF956-2" name="NumberOfTargetsDescribed"/>
        <field sel="FF673-1" name="ReferenceNumber"/>
        <field sel="FF110-1" name="RadioFrequency"/>
        <field sel="FF652-1" name="FrequencyOfEmission"/>
        <field sel="FF1528-3" name="UpperFrequencyInPulsesPerSecond"/>
        <field sel="FF1528-2" name="LowerFrequencyInPulsesPerSecond"/>
        <field sel="FF1426-4" name="ControlPositionType"/>
        <field sel="FF343-1" name="Utm1MeterNorthing"/>
        <field sel="FF342-1" name="Utm1MeterEasting"/>
        <field sel="FF658-2" name="Utm1MeterHigherOrderNorthing7Character"/>
        <field sel="FF658-3" name="Utm1MeterHigherOrderNorthing8Character"/>
        <field sel="FF657-2" name="Utm1MeterHigherOrderEasting"/>
        <field sel="FF1023-1" name="MgrsUtmGridZoneAnd100KmSquare"/>
        <field sel="FF687-1" name="EarthHemisphereAndGridZoneDesignator"/>
        <field sel="FF927-2" name="TypeOfNbcReport"/>
        <field sel="FF927-2." name="TypeOfNbcReport"/>
        <field sel="FF2309-10" name="NoFixIndicator"/>
        <field sel="FF1430-4" name="NationalStockNumber"/>
        <field sel="FF1431-3" name="DepartmentOfDefenseIdentificationCode"/>
        <field sel="FF9-1" name="PersonnelReportingClassification"/>
        <field sel="FF487-156" name="EquipmentLineItemNumber"/>
        <field sel="FF1360-1" name="LineItemNumber"/>
        <field sel="FF859-7" name="WaterDepthInFeet"/>
        <field sel="FF860-7" name="WaterDepthInMeters"/>
        <field sel="FF921-1" name="WaterTemperatureFahrenheit"/>
        <field sel="FF256-5" name="WaterTemperatureCelsius"/>
        <field sel="FF487-406" name="SpeedOfSoundInWaterFeetPerSecond"/>
        <field sel="FF487-407" name="SpeedOfSoundInWaterMetersPerSecond"/>
        <field sel="FF513-1" name="AircraftTypeAndModel"/>
        <field sel="FF469-1" name="GeographicLocationLatLongMinutes"/>
        <field sel="FF2408-1" name="AreaTargetIdentifier"/>
        <field sel="FF217-1" name="PositionOfMetStation"/>
        <field sel="FF500-12" name="NameOfArea"/>
        <field sel="FF2204-10" name="OrdnanceWeaponTypeAirToSurface"/>
        <field sel="FF2204-8" name="OrdnanceWeaponTypeAirToAir"/>
        <field sel="FF10-1" name="BasicEncyclopediaNumber"/>
        <field sel="FF10-2" name="FieldInitiatedBasicEncyclopediaNumber"/>
        <field sel="FF10-3" name="BasicEncyclopediaNumberSuspectInstallation"/>
        <field sel="FF2151-4" name="CodeName"/>
        <field sel="FF493-10" name="RightRadialLineOrientationInDegrees"/>
        <field sel="FF493-9" name="LeftRadialLineOrientationInDegrees"/>
        <field sel="FF912-10" name="RightRadialLineOrientationInMils"/>
        <field sel="FF912-9" name="LeftRadialLineOrientationInMils"/>
        <field sel="FF2204-3" name="SurfaceShipGunnerySystem"/>
        <field sel="FF557-1" name="DataRateOfACommunicationsSatelliteAccess"/>
        <field sel="FF195-11" name="PointGeometry"/>
        <field sel="FF195-12" name="BoundaryLineGeometry"/>
        <field sel="FF195-13" name="ClosedLineGeometry"/>
        <field sel="FF195-14" name="DirectedLineGeometry"/>
        <field sel="FF195-15" name="UnclosedLineGeometry"/>
        <field sel="FF195-16" name="CircleGeometry"/>
        <field sel="FF195-17" name="AvenueOfApproachGeometry"/>
        <field sel="FF195-18" name="AirDefenseGeometry"/>
        <field sel="FF195-19" name="MultiDimensionalGeometry"/>
        <field sel="FF598-1" name="LocationMgrsUtmAbbreviated100Meter"/>
        <field sel="FF168-1" name="PersonnelClassification"/>
        <field sel="FF1062-1" name="SonobuoyType"/>
        <field sel="FF393-1" name="Other"/>
        <field sel="FF927-3." name="TypeOfCbrnWeatherReport"/>
        <!--</List>-->
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="{concat($Outdir,'mtf-all-rules.xml')}">
            <xsl:copy-of select="$msgrules"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'mtf-rules.xml')}">
            <xsl:copy-of select="$rulenodes"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'mtf-rule-paths.sch')}">
            <xsl:copy-of select="$rulepaths"/>
        </xsl:result-document>
    </xsl:template>

    <xsl:variable name="rules">
        <xsl:for-each select="$messages_xsd//xsd:element[xsd:annotation/xsd:appinfo/*:MtfIdentifier]">
            <!--<Message name="{@name}">-->
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*" mode="makerule"/>
            <!--</Message>-->
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="msgrules">
        <MessageRules>
            <xsl:for-each select="$rules">
                <xsl:sort select="Rule/@msg"/>
                <xsl:sort select="Rule/@txt"/>
                <xsl:copy-of select="." copy-namespaces="no"/>
            </xsl:for-each>
        </MessageRules>
    </xsl:variable>

    <xsl:variable name="mtfrules">
        <MTFRules>
            <xsl:for-each select="$msgrules/MessageRules//Rule">
                <xsl:copy>
                    <xsl:copy-of select="parent::MtfStructuralRelationship/@msg"/>
                    <xsl:copy-of select="@txt"/>
                    <xsl:attribute name="expl">
                        <xsl:value-of select="normalize-space(parent::MtfStructuralRelationship/Explanation)"/>
                    </xsl:attribute>
                </xsl:copy>
            </xsl:for-each>
        </MTFRules>
    </xsl:variable>

    <xsl:variable name="rulenodes">
        <MTFRules>
            <xsl:for-each select="$mtfrules/MTFRules/Rule">
                <xsl:copy>
                    <xsl:copy-of select="@msg"/>
                    <xsl:copy-of select="@txt"/>
                    <xsl:copy-of select="@expl"/>
                    <xsl:apply-templates select="@txt" mode="parse">
                        <xsl:with-param name="msg" select="@msg"/>
                    </xsl:apply-templates>
                </xsl:copy>
            </xsl:for-each>
        </MTFRules>
    </xsl:variable>

    <xsl:variable name="rulepaths">
        <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
            <sch:title>Structural Relationship Rules for USMTF</sch:title>
            <xsl:for-each select="$rulenodes/*/Rule">
                <xsl:sort select="@msg"/>
                <xsl:variable name="m" select="@msg"/>
                <xsl:if test="not(preceding-sibling::*[@msg = $m])">
                    <sch:pattern id="{concat(@msg,'-Rules')}">
                        <sch:title>
                            <xsl:value-of select="concat(@msg, ' Structural Relationship Rules')"/>
                        </sch:title>
                        <xsl:apply-templates select="." mode="xPaths"/>
                        <xsl:apply-templates select="following-sibling::*[@msg = $m]" mode="xPaths"/>
                    </sch:pattern>
                </xsl:if>
            </xsl:for-each>
        </sch:schema>
    </xsl:variable>

    <xsl:template match="*" mode="xPaths">
        <xsl:variable name="val" select="Val/@txt"/>
        <xsl:choose>
            <xsl:when test="Instr/@txt = 'A'">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr]">
                        <xsl:value-of select="concat('/', @mtfname)"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][preceding-sibling::Instr]">
                        <xsl:value-of select="concat('/', @mtfname)"/>
                    </xsl:for-each>
                </xsl:variable>
                <sch:rule context="{@msg}" fpi="{@txt}">
                    <sch:assert test="{concat(substring($leftpath,2), ' = ', $a,$val,$a)}">
                        <xsl:value-of select="@expl"/>
                    </sch:assert>
                </sch:rule>
                <!--</Rule>-->
            </xsl:when>
            <xsl:when test="Instr/@txt = 'R' and Instr/@txt = 'EQ' and not(Instr/@txt = '|')">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr/@txt = 'R']">
                        <xsl:value-of select="concat('/', @mtfname)"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][preceding-sibling::Instr/@txt = 'R']">
                        <xsl:value-of select="concat('/', @mtfname)"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="c">
                    <xsl:for-each select="./*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr]">
                        <xsl:variable name="m" select="@mtfname"/>
                        <xsl:if test="following-sibling::*[@mtfname = $m]">
                            <xsl:value-of select="concat('/', @mtfname)"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <sch:rule context="{@msg}" fpi="{@txt}">
                    <sch:assert test="{concat('exists(',$leftpath,')', ' and ',$rightpath,' = ',$a,$val,$a)}">
                        <xsl:value-of select="@expl"/>
                    </sch:assert>
                </sch:rule>
                <!--</Rule>-->
            </xsl:when>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="@txt" mode="parse">
        <xsl:param name="msg"/>
        <xsl:variable name="alltxt" select="."/>
        <xsl:variable name="mnode" select="$msgxsd/*/*[@name = $msg]"/>
        <xsl:variable name="seq">
            <xsl:for-each select="tokenize(., ' ')">
                <xsl:variable name="t" select="translate(., '()@', '')"/>
                <xsl:choose>
                    <xsl:when test="$t = 'A' or $t = 'R' or $t = 'RP' or $t = 'P' or $t = 'EQ' or $t = '=' or $t = '|' or $t = '&amp;' or $t = '&gt;' or $t = '&lt;'">
                        <Instr txt="{$t}"/>
                        <xsl:choose>
                            <xsl:when test="$t = 'A'">
                                <Val txt="{translate(substring-after($alltxt,' A '),'/','')}"/>
                            </xsl:when>
                            <xsl:when test="$t = 'EQ'">
                                <xsl:variable name="e" select="substring-after($alltxt, ' EQ ')"/>
                                <xsl:choose>
                                    <xsl:when test="contains($e, '/') and contains($e, '|') and contains($e, '[')">
                                        <Val txt="{translate(substring-before($e,'|'),'()/','')}"/>
                                        <xsl:apply-templates select="substring-after($e, '|')" mode="parse">
                                            <xsl:with-param name="msg" select="$msg"/>
                                        </xsl:apply-templates>
                                    </xsl:when>
                                    <xsl:when test="contains($e, '/')">
                                        <Val txt="{translate($e,'()/','')}"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="substring-after($alltxt, ' EQ ')" mode="parse">
                                            <xsl:with-param name="msg" select="$msg"/>
                                        </xsl:apply-templates>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="$t = 'R'">
                                <xsl:apply-templates select="substring-after($alltxt, ' R ')" mode="parse">
                                    <xsl:with-param name="msg" select="$msg"/>
                                </xsl:apply-templates>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="starts-with($t, '/')"/>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains($t, ',')">
                                <xsl:for-each select="tokenize($t, ',')">
                                    <xsl:call-template name="match">
                                        <xsl:with-param name="txt" select="."/>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="match">
                                    <xsl:with-param name="txt" select="$t"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <!--<parsed>
            <xsl:for-each select="$seq/*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </parsed>-->
        <xsl:apply-templates select="$seq/*[1]" mode="getName">
            <xsl:with-param name="parent" select="$mnode"/>
            <xsl:with-param name="msg" select="$msg"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*" mode="getName">
        <xsl:param name="parent"/>
        <xsl:param name="msg"/>
        <xsl:variable name="b" select="$parent/*/*/*/@base"/>
        <xsl:variable name="typ">
            <xsl:choose>
                <xsl:when test="contains($b, ':')">
                    <xsl:value-of select="substring-after($b, ':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$b"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="name() = 'Val'">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="name() = 'Instr'">
                <xsl:copy-of select="."/>
                <xsl:apply-templates select="following-sibling::*[1]" mode="getName">
                    <xsl:with-param name="parent" select="$msgxsd/*/*[@name = $msg]"/>
                    <xsl:with-param name="msg" select="$msg"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:when test="Set">
                <xsl:variable name="tt" select="@txt"/>
                <xsl:variable name="segnode" select="$parent/*//*:element[*:annotation/*:appinfo/*:InitialSetFormatPosition = $tt]"/>
                <xsl:copy>
                    <xsl:copy-of select="@txt"/>
                    <xsl:attribute name="mtfname">
                        <xsl:value-of select="$segnode/@name"/>
                    </xsl:attribute>
                    <xsl:for-each select="*">
                        <xsl:variable name="ttt" select="@txt"/>
                        <xsl:copy>
                            <xsl:copy-of select="@txt"/>
                            <xsl:attribute name="mtfname">
                                <xsl:value-of select="$segnode/*//*:element[*:annotation/*:appinfo/*:SetFormatPositionNumber = $ttt]/@name"/>
                            </xsl:attribute>
                        </xsl:copy>
                    </xsl:for-each>
                </xsl:copy>
                <xsl:apply-templates select="following-sibling::*[1]" mode="getName">
                    <xsl:with-param name="msg" select="$msg"/>
                    <xsl:with-param name="parent" select="$segnode"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="t" select="@txt"/>
                <xsl:variable name="segnode" select="$parent//*:element[*:annotation/*:appinfo/*:InitialSetFormatPosition = $t]"/>
                <xsl:variable name="setnode" select="$parent//*:element[*:annotation/*:appinfo/*:SetFormatPositionNumber = $t]"/>
                <xsl:copy>
                    <xsl:copy-of select="@txt"/>
                    <xsl:attribute name="mtfname">
                        <xsl:choose>
                            <xsl:when test="name() = 'Segment'">
                                <xsl:value-of select="$segnode/@name"/>
                            </xsl:when>
                            <xsl:when test="name() = 'Set'">
                                <xsl:value-of select="$setnode/@name"/>
                            </xsl:when>
                            <xsl:when test="name() = 'Field' and $ffisel//*[@sel = $t]">
                                <xsl:value-of select="$ffisel//*[@sel = $t]/@name"/>
                            </xsl:when>
                            <xsl:when test="name() = 'Field'">
                                <xsl:value-of select="$setxsd/*/*[@name = $typ]//*:element[*:annotation/*:appinfo/*:FieldFormatPositionNumber = $t]/@name"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:copy>
                <xsl:choose>
                    <xsl:when test="name() = 'Field'">
                        <xsl:apply-templates select="following-sibling::*[1]" mode="getName">
                            <xsl:with-param name="parent" select="$msgxsd/*/*[@name = $msg]"/>
                            <xsl:with-param name="msg" select="$msg"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="name() = 'Segment'">
                        <xsl:apply-templates select="following-sibling::*[1]" mode="getName">
                            <xsl:with-param name="parent" select="$segnode"/>
                            <xsl:with-param name="msg" select="$msg"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="name() = 'Set'">
                        <xsl:apply-templates select="following-sibling::*[1]" mode="getName">
                            <xsl:with-param name="parent" select="$setnode"/>
                            <xsl:with-param name="msg" select="$msg"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="following-sibling::*[1]" mode="getName">
                            <xsl:with-param name="parent" select="$msgxsd/*/*[@name = $msg]"/>
                            <xsl:with-param name="msg" select="$msg"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="match">
        <xsl:param name="txt"/>
        <xsl:choose>
            <xsl:when test="matches($txt, 'FF[0-9][0-9]?[0-9]?[0-9]?-[0-9]')">
                <Field txt="{$txt}"/>
            </xsl:when>
            <xsl:when test="matches($txt, 'F\[[0-9][0-9]?[0-9]?\]F[0-9][0-9]?')">
                <Set txt="{substring-before(translate(substring-after($txt,'F'),'[]',''),'F')}"/>
                <Field txt="{substring-after(translate(substring-after($txt,'F'),'[]',''),'F')}"/>
            </xsl:when>
            <xsl:when test="matches($txt, '[A-Z]?\[[0-9][0-9]?[0-9]?\]FS[0-9][0-9]?')">
                <Set txt="{substring-before(translate($txt,'ABCDENZ[]',''),'F')}"/>
                <Field txt="{substring-after(translate($txt,'ABCDEZ[]',''),'FS')}"/>
            </xsl:when>
            <xsl:when test="matches($txt, '[A-Z]?\[[0-9][0-9]?[0-9]?\]F[0-9][0-9]?')">
                <Set txt="{substring-before(translate($txt,'ABCDENZ[]',''),'F')}"/>
                <Field txt="{substring-after(translate($txt,'ABCDEZ[]',''),'F')}"/>
            </xsl:when>
            <xsl:when test="matches($txt, '[A-Z]?\[[0-9][0-9]?[0-9]?S\]')">
                <Segment txt="{translate($txt,'ABCDEFRZ[S]','')}"/>
            </xsl:when>
            <xsl:when test="matches($txt, '[A-Z]?\[[0-9][0-9]?[0-9]?\]FG')">
                <Set txt="{translate($txt,'[]ABCDESNZFG','')}"/>
            </xsl:when>
            <xsl:when test="matches($txt, '[A-Z]?\[[0-9][0-9]?[0-9]?\]')">
                <Set txt="{translate($txt,'ABCDEFSNZ[]','')}"/>
            </xsl:when>
            <xsl:when test="matches($txt, '[A-Z]?F[0-9][0-9]?[0-9]?')">
                <Field txt="{replace(substring-after($txt,'F'),'F','')}"/>
            </xsl:when>
            <xsl:when test="matches($txt, '[A-Z]?\[[0-9][0-9]?..[0-9][0-9]?S\]')">
                <xsl:variable name="s" select="number(substring-before(substring-after($txt, '['), '..'))"/>
                <xsl:variable name="e" select="number(substring-before(substring-after($txt, '..'), 'S]'))"/>
                <Segment txt="{$s}">
                    <Set txt="{$s}"/>
                    <xsl:if test="$s + 1 &lt; $e">
                        <Set txt="{$s+1}"/>
                    </xsl:if>
                    <xsl:if test="$s + 2 &lt; $e">
                        <Set txt="{$s+2}"/>
                    </xsl:if>
                    <xsl:if test="$s + 3 &lt; $e">
                        <Set txt="{$s+3}"/>
                    </xsl:if>
                    <xsl:if test="$s + 4 &lt; $e">
                        <Set txt="{$s+4}"/>
                    </xsl:if>
                    <Set txt="{$e}"/>
                </Segment>
            </xsl:when>

        </xsl:choose>

    </xsl:template>

    <!--// -\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\- ///-->


    <xsl:template match="*:MtfStructuralRelationship" mode="makerule">
        <xsl:variable name="msgname" select="ancestor::*[@name][1]/@name" exclude-result-prefixes="#all"/>
        <MtfStructuralRelationship msg="{$msgname}">
            <xsl:apply-templates select="*" mode="makerule"/>
        </MtfStructuralRelationship>
    </xsl:template>
    <xsl:template name="convertXpath">
        <xsl:param name="xp"/>
        <xsl:param name="msgname"/>
        <xsl:for-each select="tokenize($xp, '/')">
            <xsl:variable name="s" select="string(.)"/>
            <xsl:choose>
                <xsl:when test=". = ' '"/>
                <xsl:otherwise>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="*:MtfStructuralRelationshipRule" mode="makerule">
        <Rule txt="{normalize-space(text())}"/>
    </xsl:template>
    <xsl:template match="*:MtfStructuralRelationshipExplanation" mode="makerule">
        <Explanation>
            <xsl:apply-templates select="text()" mode="makerule"/>
        </Explanation>
    </xsl:template>
    <xsl:template match="*:MtfStructuralRelationshipXsnRule" mode="makerule">
        <XsnRule>
            <xsl:apply-templates select="text()" mode="makerule"/>
        </XsnRule>
    </xsl:template>
    <xsl:template match="*:MtfStructuralRelationshipXmlSnRule" mode="makerule">
        <XmlSnRule>
            <xsl:copy-of select="@number"/>
            <xsl:for-each select="*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </XmlSnRule>
    </xsl:template>
    <xsl:template match="*:IndividualSetSegment" mode="makerule">
        <xsl:attribute name="individualSetSegment">
            <xsl:apply-templates select="text()" mode="makerule"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*:SubscriptNotThis" mode="makerule">
        <xsl:attribute name="subscriptNotThis">
            <xsl:apply-templates select="text()" mode="makerule"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*:Set" mode="makerule">
        <xsl:attribute name="set">
            <xsl:apply-templates select="text()" mode="makerule"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*:Segment" mode="makerule">
        <xsl:attribute name="set">
            <xsl:apply-templates select="text()" mode="makerule"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*:Field" mode="makerule">
        <xsl:attribute name="field">
            <xsl:apply-templates select="text()" mode="makerule"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*:Assign" mode="makerule">
        <xsl:attribute name="assign">
            <xsl:apply-templates select="text()" mode="makerule"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*:LiteralNoWildcard" mode="makerule">
        <xsl:attribute name="literalNoWildcard">
            <xsl:apply-templates select="text()" mode="makerule"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*" mode="makerule">
        <xsl:apply-templates select="*" mode="makerule"/>
    </xsl:template>
    <xsl:template match="text()" mode="makerule">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template name="substring-before-last">
        <xsl:param name="input"/>
        <xsl:param name="substr"/>
        <xsl:if test="$substr and contains($input, $substr)">
            <xsl:variable name="temp" select="substring-after($input, $substr)"/>
            <xsl:value-of select="substring-before($input, $substr)"/>
            <xsl:if test="contains($temp, $substr)">
                <xsl:value-of select="$substr"/>
                <xsl:call-template name="substring-before-last">
                    <xsl:with-param name="input" select="$temp"/>
                    <xsl:with-param name="substr" select="$substr"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="substring-after-last">
        <xsl:param name="input"/>
        <xsl:param name="substr"/>

        <!-- Extract the string which comes after the first occurence -->
        <xsl:variable name="temp" select="substring-after($input, $substr)"/>

        <xsl:choose>
            <!-- If it still contains the search string the recursively process -->
            <xsl:when test="$substr and contains($temp, $substr)">
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="input" select="$temp"/>
                    <xsl:with-param name="substr" select="$substr"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$temp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="identity">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="identity"/>
            <xsl:apply-templates select="text()" mode="identity"/>
            <xsl:apply-templates select="*" mode="identity"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="identity">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

</xsl:stylesheet>
