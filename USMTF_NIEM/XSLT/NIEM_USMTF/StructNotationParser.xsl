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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="Analdir" select="'../../XSD/Analysis/Rules/'"/>

    <xsl:variable name="Mtfdir" select="'../../XSD/NIEM_MTF/schematron/'"/>

    <xsl:variable name="fixrules" select="document('../../XSD/Analysis/Rules/fixrules6040B.xml')/FixRules"/>

    <xsl:variable name="msgxsd" select="document('../../XSD/Baseline_Schema/Consolidated/messages.xsd')"/>
    <xsl:variable name="setxsd" select="document('../../XSD/Baseline_Schema/Consolidated/sets.xsd')"/>
    <xsl:variable name="msgmaps" select="document('../../XSD/NIEM_MTF/refxsd/maps/usmtf-msgsmaps.xml')/*"/>
    <xsl:variable name="segmaps" select="document('../../XSD/NIEM_MTF/refxsd/maps/usmtf-segmntmaps.xml')/*"/>
    <xsl:variable name="setmaps" select="document('../../XSD/NIEM_MTF/refxsd/maps/usmtf-setmaps.xml')/*"/>
    
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
    <xsl:variable name="ns" select="'mtf:'"/>

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

    <xsl:template name="extractrules">
        <xsl:result-document href="{concat($Analdir,'mtf-all-rules.xml')}">
            <xsl:copy-of select="$msgrules"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Analdir,'mtf-rules-6040BC.xml')}">
            <xsl:copy-of select="$rulepaths6040BC"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Analdir,'mtf-rules-6040B.sch')}">
            <xsl:copy-of select="$sch6040B"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Mtfdir,'usmtf-structural-relationships.sch')}">
            <xsl:copy-of select="$sch6040C"/>
        </xsl:result-document>
    </xsl:template>

    <xsl:variable name="rules">
        <xsl:for-each select="$msgxsd//xsd:element[xsd:annotation/xsd:appinfo/*:MtfIdentifier]">
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

    <xsl:variable name="rulenodes6040B">
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

    <xsl:variable name="rulenodes6040C">
        <MTFRules>
            <xsl:apply-templates select="$rulenodes6040B/MTFRules/*" mode="niemrule"/>
        </MTFRules>
    </xsl:variable>

    <xsl:variable name="rulepaths6040B">
        <MTFRules xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <xsl:apply-templates select="$rulenodes6040C/*/Rule" mode="xPaths6040B">
                <xsl:sort select="@msg"/>
            </xsl:apply-templates>
        </MTFRules>
    </xsl:variable>

    <xsl:template match="*" mode="xPaths6040B">
        <xsl:variable name="r" select="@txt"/>
        <xsl:variable name="m" select="@msg"/>
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:variable name="xpaths">
                <XPaths>
                    <xsl:apply-templates select="." mode="makemtfxpath">
                        <xsl:with-param name="type" select="'mtfname'"/>
                    </xsl:apply-templates>
                </XPaths>
            </xsl:variable>
            <xsl:copy-of select="$xpaths"/>
            <sch:rule context="{$xpaths/*/@context}">
                <sch:assert fpi="{@txt}" test="{$xpaths/*/@xpath}">
                    <xsl:value-of select="@expl"/>
                </sch:assert>
            </sch:rule>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*" mode="makemtfxpath">
        <xsl:param name="type"/>
        <xsl:variable name="rul" select="./@txt"/>
        <xsl:variable name="msg" select="./@msg"/>
        <xsl:variable name="fr" select="$fixrules/Rule[@rtxt = $rul]"/>
        <xsl:choose>
            <xsl:when test="$type = 'mtfname' and $fr/@mtfcontext">
                <xsl:attribute name="context">
                    <xsl:choose>
                        <xsl:when test="$fr/@mtfcontext = '/'">
                            <xsl:value-of select="concat($ns,$msg)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($ns,$msg, '/', $fr/@mtfcontext)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="xpath">
                    <xsl:value-of select="$fr/@mtfxpath"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$type = 'niemname' and $fr/@niemcontext">
                <xsl:attribute name="context">
                    <xsl:choose>
                        <xsl:when test="$fr/@niemcontext = '/'">
                            <xsl:value-of select="concat($ns,$msg)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($ns,$msg, '/', $fr/@niemcontext)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="xpath">
                    <xsl:value-of select="$fr/@niemxpath"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="Instr/@txt = 'A'">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr]">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field' or name() = 'Val'][preceding-sibling::Instr]">
                        <xsl:choose>
                            <xsl:when test="name() = 'Val'">
                                <xsl:value-of select="concat('=', @txt)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('/',$ns, @*[name() = $type])"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="aval">
                    <xsl:value-of select="substring-after($rightpath, '=')"/>
                </xsl:variable>
                <xsl:variable name="xpth" select="substring($leftpath, 2)"/>
                <xsl:variable name="lastel">
                    <xsl:call-template name="substring-after-last">
                        <xsl:with-param name="input" select="$xpth"/>
                        <xsl:with-param name="substr" select="'/'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="context" select="concat($ns,@msg, '/', substring-before($xpth, concat('/', $lastel)))"/>
                <xsl:attribute name="context" select="$context"/>
                <xsl:attribute name="xpath" select="concat($lastel, ' = ', $a, $aval, $a)"/>
            </xsl:when>
            <xsl:when test="Instr/@txt = 'R' and Instr/@txt = 'EQ'">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr/@txt = 'R']">
                        <xsl:value-of select="concat($ns,@*[name() = $type])"/>
                        <xslText>/</xslText>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][preceding-sibling::Instr/@txt = 'R']">
                        <xsl:choose>
                            <xsl:when test="following-sibling::*[1]/@txt = 'EQ'">
                                <xsl:value-of select="concat($ns,@*[name() = $type])"/>
                                <xslText>=</xslText>
                                <xsl:value-of select="concat($a, following-sibling::Val[1]/@txt, $a)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($ns,@*[name() = $type])"/>
                                <xslText>/</xslText>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="ls" select="tokenize($leftpath, '/')"/>
                <xsl:variable name="rs" select="tokenize($rightpath, '/')"/>
                <xsl:variable name="context">
                    <xsl:for-each select="$ls">
                        <xsl:variable name="p" select="position()"/>
                        <xsl:if test=". = $rs[$p]">
                            <xsl:value-of select="."/>
                        </xsl:if>
                        <xsl:if test="$ls[$p + 1] = $rs[$p + 1]">
                            <xsl:text>/</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="contxt">
                    <xsl:choose>
                        <xsl:when test="$context = ''">
                            <xsl:value-of select="concat($ns,@msg)"/>
                        </xsl:when>
                        <xsl:when test="$context = '/'">
                            <xsl:value-of select="concat($ns,@msg)"/>
                        </xsl:when>
                        <xsl:when test="ends-with($context, '/')">
                            <xsl:value-of select="concat($ns,@msg, '/', substring($context, 0, string-length($context)))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($ns,@msg, '/', $context)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="val">
                    <xsl:value-of select="Val/@txt"/>
                </xsl:variable>
                <xsl:variable name="lpath">
                    <xsl:choose>
                        <xsl:when test="starts-with($leftpath, concat($contxt, '/'))">
                            <xsl:variable name="lpth" select="substring-after($leftpath, concat($contxt, '/'))"/>
                            <xsl:choose>
                                <xsl:when test="ends-with($lpth, '/')">
                                    <xsl:value-of select="substring($lpth, 0, string-length($lpth))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$lpth"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="ends-with($leftpath, '/')">
                            <xsl:value-of select="substring($leftpath, 0, string-length($leftpath))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$leftpath"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rpath">
                    <xsl:choose>
                        <xsl:when test="ends-with($rightpath, '/')">
                            <xsl:variable name="rpth" select="substring-after($rightpath, concat($contxt, '/'))"/>
                            <xsl:value-of select="substring($rpth, 0, string-length($rpth))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring-after($rightpath, concat($contxt, '/'))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rval">
                    <xsl:value-of select="Val/@txt"/>
                </xsl:variable>
                <xsl:variable name="xpth">
                    <xsl:choose>
                        <xsl:when test="contains($val, '|')">
                            <xsl:variable name="rpth" select="substring-before($rightpath, '=')"/>
                            <xsl:value-of select="concat($lpath, ' and contains(', $a, $val, $a, ',', $rpth, ')')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($lpath, ' and ', $rightpath)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="context" select="$contxt"/>
                <xsl:attribute name="xpath" select="$xpth"/>
                <xsl:copy-of select="@expl"/>
            </xsl:when>
            <xsl:when test="Instr/@txt = 'RP' and Instr/@txt = 'EQ'">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr/@txt = 'RP']">
                        <xsl:value-of select="concat($ns,@*[name() = $type])"/>
                        <xslText>/</xslText>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][preceding-sibling::Instr/@txt = 'RP']">
                        <xsl:choose>
                            <xsl:when test="following-sibling::*[1]/@txt = 'EQ'">
                                <xsl:value-of select="concat($ns,@*[name() = $type])"/>
                                <xslText>=</xslText>
                                <xsl:value-of select="concat($a, following-sibling::Val[1]/@txt, $a)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($ns,@*[name() = $type])"/>
                                <xslText>/</xslText>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="ls" select="tokenize($leftpath, '/')"/>
                <xsl:variable name="rs" select="tokenize($rightpath, '/')"/>
                <xsl:variable name="context">
                    <xsl:for-each select="$ls">
                        <xsl:variable name="p" select="position()"/>
                        <xsl:if test=". = $rs[$p]">
                            <xsl:value-of select="."/>
                        </xsl:if>
                        <xsl:if test="$ls[$p + 1] = $rs[$p + 1]">
                            <xsl:text>/</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="contxt">
                    <xsl:choose>
                        <xsl:when test="$context = ''">
                            <xsl:value-of select="concat($ns,@msg)"/>
                        </xsl:when>
                        <xsl:when test="$context = '/'">
                            <xsl:value-of select="concat($ns,@msg)"/>
                        </xsl:when>
                        <xsl:when test="ends-with($context, '/')">
                            <xsl:value-of select="concat($ns,@msg, '/', substring($context, 0, string-length($context)))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($ns,@msg, '/', $context)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="val">
                    <xsl:value-of select="Val/@txt"/>
                </xsl:variable>
                <xsl:variable name="lpath">
                    <xsl:choose>
                        <xsl:when test="starts-with($leftpath, concat($contxt, '/'))">
                            <xsl:variable name="lpth" select="substring-after($leftpath, concat($contxt, '/'))"/>
                            <xsl:choose>
                                <xsl:when test="ends-with($lpth, '/')">
                                    <xsl:value-of select="substring($lpth, 0, string-length($lpth))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$lpth"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="ends-with($leftpath, '/')">
                            <xsl:value-of select="substring($leftpath, 0, string-length($leftpath))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$leftpath"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rpath">
                    <xsl:choose>
                        <xsl:when test="ends-with($rightpath, '/')">
                            <xsl:variable name="rpth" select="substring-after($rightpath, concat($contxt, '/'))"/>
                            <xsl:value-of select="substring($rpth, 0, string-length($rpth))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring-after($rightpath, concat($contxt, '/'))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rval">
                    <xsl:value-of select="Val/@txt"/>
                </xsl:variable>
                <xsl:variable name="xpth">
                    <xsl:choose>
                        <xsl:when test="contains($val, '|')">
                            <xsl:variable name="rpth" select="substring-before($rightpath, '=')"/>
                            <xsl:value-of select="concat($lpath, ' and contains(', $a, $val, $a, ',', $rpth, ')')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($lpath, ' and ', $rightpath, ' or not(', $lpath, ')')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="context" select="replace($contxt, '//', '/')"/>
                <xsl:attribute name="xpath" select="$xpth"/>
                <xsl:copy-of select="@expl"/>
            </xsl:when>
            <xsl:when test="Instr/@txt = 'RP' and Instr/@txt = '='">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr/@txt = 'RP']">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][preceding-sibling::Instr/@txt = 'RP'][following-sibling::Instr/@txt = '=']">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rval">
                    <xsl:value-of select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][preceding-sibling::Instr/@txt = '=']/@*[name() = $type]"/>
                </xsl:variable>
                <xsl:variable name="ls" select="tokenize($leftpath, '/')"/>
                <xsl:variable name="rs" select="tokenize($rightpath, '/')"/>
                <xsl:variable name="contxt">
                    <xsl:for-each select="$ls">
                        <xsl:variable name="p" select="position()"/>
                        <xsl:if test=". = $rs[$p]">
                            <xsl:value-of select="."/>
                        </xsl:if>
                        <xsl:if test="$ls[$p + 1] = $rs[$p + 1]">
                            <xsl:text>/</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="lpath" select="substring-after($leftpath, concat($contxt, '/'))"/>
                <xsl:variable name="rpath" select="substring-after($rightpath, concat($contxt, '/'))"/>
                <xsl:attribute name="context" select="concat($ns,@msg, $contxt)"/>
                <xsl:attribute name="xpath" select="concat($lpath, ' and ', $rpath, '/', $rval, ' or not(', $lpath, ')')"/>
                <xsl:copy-of select="@expl"/>
            </xsl:when>
            <xsl:when test="Instr/@txt = 'R'">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr/@txt = 'R']">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][preceding-sibling::Instr/@txt = 'R']">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="ls" select="tokenize($leftpath, '/')"/>
                <xsl:variable name="rs" select="tokenize($rightpath, '/')"/>
                <xsl:variable name="contxt">
                    <xsl:choose>
                        <xsl:when test="string-length($rightpath) &gt; 0">
                            <xsl:for-each select="$ls">
                                <xsl:variable name="p" select="position()"/>
                                <xsl:if test=". = $rs[$p]">
                                    <xsl:value-of select="."/>
                                </xsl:if>
                                <xsl:if test="$ls[$p + 1] = $rs[$p + 1]">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="substring-before-last">
                                <xsl:with-param name="input" select="$leftpath"/>
                                <xsl:with-param name="substr" select="'/'"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="lpath" select="substring-after($leftpath, concat($contxt, '/'))"/>
                <xsl:variable name="rpath" select="substring-after($rightpath, concat($contxt, '/'))"/>
                <xsl:variable name="xpth">
                    <xsl:choose>
                        <xsl:when test="contains(@txt, '!@')">
                            <xsl:value-of select="concat($lpath, ' and not(', $rpath, ')')"/>
                        </xsl:when>
                        <xsl:when test="string-length($rpath) = 0">
                            <xsl:value-of select="concat($lpath, ' ')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($lpath, ' and ', $rpath)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="context" select="concat($ns,@msg, $contxt)"/>
                <xsl:attribute name="xpath" select="$xpth"/>
                <xsl:copy-of select="@expl"/>
            </xsl:when>
            <xsl:when test="Instr/@txt = 'RP'">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr/@txt = 'RP']">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][preceding-sibling::Instr/@txt = 'RP']">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="ls" select="tokenize($leftpath, '/')"/>
                <xsl:variable name="rs" select="tokenize($rightpath, '/')"/>
                <xsl:variable name="contxt">
                    <xsl:choose>
                        <xsl:when test="string-length($rightpath) &gt; 0">
                            <xsl:for-each select="$ls">
                                <xsl:variable name="p" select="position()"/>
                                <xsl:if test=". = $rs[$p]">
                                    <xsl:value-of select="."/>
                                </xsl:if>
                                <xsl:if test="$ls[$p + 1] = $rs[$p + 1]">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="substring-before-last">
                                <xsl:with-param name="input" select="$leftpath"/>
                                <xsl:with-param name="substr" select="'/'"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="lpath" select="substring-after($leftpath, concat($contxt, '/'))"/>
                <xsl:variable name="rpath" select="substring-after($rightpath, concat($contxt, '/'))"/>
                <xsl:variable name="xpth">
                    <xsl:value-of select="concat($lpath, ' and ', $rpath, ' or not(', $lpath, ')')"/>
                </xsl:variable>
                <xsl:attribute name="context" select="concat($ns,@msg, $contxt)"/>
                <xsl:attribute name="xpath" select="$xpth"/>
            </xsl:when>
            <xsl:when test="Instr/@txt = 'P'">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr/@txt = 'P']">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field' or name() = 'Instr' or name() = 'Val'][preceding-sibling::Instr/@txt = 'P']">
                        <xsl:choose>
                            <xsl:when test="@txt = '|'">
                                <xsl:text>/or/</xsl:text>
                            </xsl:when>
                            <xsl:when test="@txt = '&amp;'">
                                <xsl:text>/and/</xsl:text>
                            </xsl:when>
                            <xsl:when test="@txt = 'EQ'">
                                <xsl:text>/EQ/</xsl:text>
                            </xsl:when>
                            <xsl:when test="@txt = '!EQ'">
                                <xsl:text>/!EQ/</xsl:text>
                            </xsl:when>
                            <xsl:when test="name() = 'Val'">
                                <xsl:value-of select="concat('/', @txt)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('/',$ns, @*[name() = $type])"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="ls" select="tokenize($leftpath, '/')"/>
                <xsl:variable name="rs" select="tokenize($rightpath, '/')"/>
                <xsl:variable name="contxt">
                    <xsl:choose>
                        <xsl:when test="string-length($rightpath) &gt; 0">
                            <xsl:for-each select="$ls">
                                <xsl:variable name="p" select="position()"/>
                                <xsl:if test=". = $rs[$p]">
                                    <xsl:value-of select="."/>
                                </xsl:if>
                                <xsl:if test="$ls[$p + 1] = $rs[$p + 1]">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="substring-before-last">
                                <xsl:with-param name="input" select="$leftpath"/>
                                <xsl:with-param name="substr" select="'/'"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="lpath" select="substring-after($leftpath, concat($contxt, '/'))"/>
                <xsl:variable name="rpath" select="substring-after($rightpath, concat($contxt, '/'))"/>
                <xsl:variable name="xpth">
                    <xsl:choose>
                        <xsl:when test="string-length($rpath) = 0">
                            <xsl:value-of select="concat('not(', $lpath, ')')"/>
                        </xsl:when>
                        <xsl:when test="Instr[@txt='&amp;']">
                            <xsl:variable name="rl" select="substring-after(substring-before($rightpath, '/and'), '/')"/>
                            <xsl:variable name="rr" select="substring-after($rightpath, 'and//')"/>
                            <xsl:value-of select="concat('not(', $lpath, ') and not(', $rl, ') and not(', $rr, ')')"/>
                        </xsl:when>
                        <xsl:when test="Instr[@txt='|']">
                            <xsl:variable name="rl" select="substring-after(substring-before($rightpath, '/or'), '/')"/>
                            <xsl:variable name="rr" select="substring-after($rightpath, 'or//')"/>
                            <xsl:value-of select="concat('not(', $lpath, ') and ', $rl, ' or ', $rr)"/>
                        </xsl:when>
                        <xsl:when test="Instr[@txt = 'EQ']">
                            <xsl:variable name="rl" select="substring-after(substring-before($rightpath, '/EQ'), '/')"/>
                            <xsl:variable name="ct" select="tokenize($contxt, '/')"/>
                            <xsl:variable name="rs" select="tokenize($rl, '/')"/>
                            <xsl:variable name="rrl">
                                <xsl:for-each select="$rs">
                                    <xsl:variable name="p" select="position()"/>
                                    <xsl:if test="$ct[$p] != $rs[$p]">
                                        <xsl:value-of select="."/>
                                    </xsl:if>
                                    <xsl:if test="$rs[$p + 1] and $ct[$p + 1] != $rs[$p + 1]">
                                        <xsl:text>/</xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:variable>
                            <xsl:variable name="rr" select="substring-after($rightpath, 'EQ//')"/>
                            <xsl:choose>
                                <xsl:when test="Val">
                                    <xsl:value-of select="concat('not(', $lpath, ') and ', $rrl, '=', $a, $rr, $a)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('not(', $lpath, ') and ', $rrl, '=', $rr)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="Instr[@txt = '!EQ']">
                            <xsl:variable name="rl" select="substring-after(substring-before($rightpath, '/!EQ'), '/')"/>
                            <xsl:variable name="ct" select="tokenize($contxt, '/')"/>
                            <xsl:variable name="rs" select="tokenize($rl, '/')"/>
                            <xsl:variable name="rrl">
                                <xsl:for-each select="$rs">
                                    <xsl:variable name="p" select="position()"/>
                                    <xsl:if test="$ct[$p] != $rs[$p]">
                                        <xsl:value-of select="."/>
                                    </xsl:if>
                                    <xsl:if test="$rs[$p + 1] and $ct[$p + 1] != $rs[$p + 1]">
                                        <xsl:text>/</xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:variable>
                            <xsl:variable name="rr" select="substring-after($rpath, '!EQ//')"/>
                            <xsl:choose>
                                <xsl:when test="Val">
                                    <xsl:value-of select="concat('not(', $lpath, ') and ', substring-before($rpath, '/!EQ//'), ' != ', $a, $rr, $a)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('not(', $lpath, ') and ', $rrl, ' != ', $rr)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="contains($rp, '@!')">
                                    <xsl:value-of select="concat('not(', $lpath, ')', ' and not(', $rpath, '))')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('not(', $lpath, ')', ' and ', $rpath)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="context" select="concat($ns,@msg, $contxt)"/>
                <xsl:attribute name="xpath" select="$xpth"/>
            </xsl:when>
            <xsl:when test="Instr/@txt = 'EQ'">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr/@txt = 'EQ']">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][preceding-sibling::Instr/@txt = 'EQ']">
                        <xsl:value-of select="concat('/',$ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="ls" select="tokenize($leftpath, '/')"/>
                <xsl:variable name="rs" select="tokenize($rightpath, '/')"/>
                <xsl:variable name="contxt">
                    <xsl:call-template name="substring-before-last">
                        <xsl:with-param name="input" select="$leftpath"/>
                        <xsl:with-param name="substr" select="'/'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="val">
                    <xsl:value-of select="Val/@txt"/>
                </xsl:variable>
                <xsl:variable name="lpath" select="substring-after($leftpath, concat($contxt, '/'))"/>
                <xsl:variable name="rpath" select="substring-after($rightpath, concat($contxt, '/'))"/>
                <xsl:variable name="xpth">
                    <xsl:choose>
                        <xsl:when test="string-length($rpath) = 0 and contains($val, '|')">
                            <xsl:value-of select="concat($lpath, '[.= ', $a, $val, $a, ']')"/>
                        </xsl:when>
                        <xsl:when test="string-length($rpath) = 0">
                            <xsl:value-of select="concat($lpath, ' = ', $a, $val, $a)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($lpath, ' = ', $rpath)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="context" select="concat($ns,@msg, $contxt)"/>
                <xsl:attribute name="xpath" select="$xpth"/>
            </xsl:when>
            <xsl:when test="Instr/@txt = '!EQ'">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr/@txt = '!EQ']">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][preceding-sibling::Instr/@txt = '!EQ']">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="ls" select="tokenize($leftpath, '/')"/>
                <xsl:variable name="rs" select="tokenize($rightpath, '/')"/>
                <xsl:variable name="contxt">
                    <xsl:call-template name="substring-before-last">
                        <xsl:with-param name="input" select="$leftpath"/>
                        <xsl:with-param name="substr" select="'/'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="val">
                    <xsl:value-of select="Val/@txt"/>
                </xsl:variable>
                <xsl:variable name="lpath" select="substring-after($leftpath, concat($contxt, '/'))"/>
                <xsl:variable name="rpath" select="substring-after($rightpath, concat($contxt, '/'))"/>
                <xsl:variable name="xpth">
                    <xsl:choose>
                        <xsl:when test="string-length($rpath) = 0 and contains($val, '|')">
                            <xsl:value-of select="concat($lpath, '[.= ', $a, $val, $a, ']')"/>
                        </xsl:when>
                        <xsl:when test="string-length($rpath) = 0">
                            <xsl:value-of select="concat($lpath, ' != ', $a, $val, $a)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($lpath, ' != ', $rpath)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="context" select="concat($ns,@msg, $contxt)"/>
                <xsl:attribute name="xpath" select="$xpth"/>
            </xsl:when>
            <xsl:when test="Field[contains(@txt, 'FF')]">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[@*[name() = $type]][following-sibling::Instr[@txt = '=']][not(preceding-sibling::Instr[@txt = '='])]">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="sel1">
                    <xsl:value-of select="Field[contains(@txt, 'FF')][1]/@*[name() = $type]"/>
                </xsl:variable>
                <xsl:variable name="sel2">
                    <xsl:value-of select="Field[contains(@txt, 'FF')][2]/@*[name() = $type]"/>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[@*[name() = $type]][preceding-sibling::Field[contains(@txt, 'FF')]][following-sibling::Instr/@txt = '=']">
                        <xsl:value-of select="concat('/', $ns,@*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="ls" select="tokenize($leftpath, '/')"/>
                <xsl:variable name="rs" select="tokenize($rightpath, '/')"/>
                <xsl:variable name="contxt">
                    <xsl:choose>
                        <xsl:when test="string-length($rightpath) &gt; 0">
                            <xsl:for-each select="$ls">
                                <xsl:variable name="p" select="position()"/>
                                <xsl:if test=". = $rs[$p]">
                                    <xsl:value-of select="."/>
                                </xsl:if>
                                <xsl:if test="$ls[$p + 1] = $rs[$p + 1]">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="substring-before-last">
                                <xsl:with-param name="input" select="$leftpath"/>
                                <xsl:with-param name="substr" select="'/'"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="lpath" select="concat(substring-after($leftpath, concat($contxt, '/')), '/', $sel1)"/>
                <xsl:variable name="rpath" select="concat(substring-after($rightpath, concat($contxt, '/')), '/', $sel2)"/>
                <xsl:variable name="xpth">
                    <xsl:value-of select="concat($lpath, ' and ', $rpath)"/>
                </xsl:variable>
                <xsl:attribute name="context" select="concat($ns,@msg, $contxt)"/>
                <xsl:attribute name="xpath" select="$xpth"/>
            </xsl:when>
            <xsl:when test="Instr[@txt = '@=']">
                <xsl:variable name="leftpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][following-sibling::Instr/@txt = '@=']">
                        <xsl:value-of select="concat('/', @*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="rightpath">
                    <xsl:for-each select="*[name() = 'Segment' or name() = 'Set' or name() = 'Field'][preceding-sibling::Instr/@txt = '@=']">
                        <xsl:value-of select="concat('/', @*[name() = $type])"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="ls" select="tokenize($leftpath, '/')"/>
                <xsl:variable name="rs" select="tokenize($rightpath, '/')"/>
                <xsl:variable name="contxt">
                    <xsl:choose>
                        <xsl:when test="string-length($rightpath) &gt; 0">
                            <xsl:for-each select="$ls">
                                <xsl:variable name="p" select="position()"/>
                                <xsl:if test=". = $rs[$p] and $ls[$p - 1] = $rs[$p - 1]">
                                    <xsl:value-of select="."/>
                                </xsl:if>
                                <xsl:if test=". = $rs[$p] and $ls[$p - 1] = $rs[$p - 1] and $ls[$p + 1] = $rs[$p + 1]">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="substring-before-last">
                                <xsl:with-param name="input" select="$leftpath"/>
                                <xsl:with-param name="substr" select="'/'"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="val">
                    <xsl:value-of select="Val/@txt"/>
                </xsl:variable>
                <xsl:variable name="lpath" select="substring-after($leftpath, concat($contxt, '/'))"/>
                <xsl:variable name="rpath" select="substring-after($rightpath, concat($contxt, '/'))"/>
                <xsl:variable name="xpth">
                    <xsl:choose>
                        <xsl:when test="string-length($rpath) = 0 and contains($val, '|')">
                            <xsl:value-of select="concat($lpath, '[.= ', $a, $val, $a, ']')"/>
                        </xsl:when>
                        <xsl:when test="string-length($rpath) = 0">
                            <xsl:value-of select="concat($lpath, ' = ', $a, $val, $a)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('count(', $lpath, ')=1 and ', $rpath)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="context" select="concat($ns,@msg, $contxt)"/>
                <xsl:attribute name="xpath" select="$xpth"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:variable name="rulepaths6040BC">
        <MTFRules xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <xsl:apply-templates select="$rulepaths6040B/*/Rule" mode="xPaths6040C">
                <xsl:sort select="@msg"/>
            </xsl:apply-templates>
        </MTFRules>
    </xsl:variable>

    <xsl:variable name="sch6040B">
        <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            queryBinding="xslt">
            <sch:ns uri="urn:mtf:mil:6040b:niem:mtf" prefix="mtf"/> 
            <sch:ns uri="urn:us:gov:ic:ism" prefix="ism"/> 
            <sch:title>Structural Relationship Rules for USMTF MIL STD 6040B</sch:title>
            <xsl:for-each select="$rulepaths6040BC/*/Rule">
                <xsl:sort select="@msg"/>
                <xsl:variable name="m" select="@msg"/>
                <xsl:if test="not(preceding-sibling::*[@msg = $m])">
                    <xsl:variable name="rules">
                        <xsl:copy-of select="XPaths6040C/sch:rule"/>
                        <xsl:for-each select="following-sibling::Rule[@msg = $m]">
                            <xsl:copy-of select="XPaths6040C/sch:rule" copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <sch:pattern id="{@msg}">
                        <sch:title>
                            <xsl:text>Structural Relationship Rules</xsl:text>
                        </sch:title>
                        <xsl:for-each select="$rules/*">
                            <xsl:variable name="c" select="@context"/>
                            <xsl:if test="not(preceding-sibling::sch:rule[@context = $c])">
                                <xsl:copy>
                                    <xsl:copy-of select="@context"/>
                                    <xsl:copy-of select="sch:assert"/>
                                    <xsl:for-each select="following-sibling::sch:rule[@context = $c]">
                                        <xsl:copy-of select="sch:assert"/>
                                    </xsl:for-each>
                                </xsl:copy>
                            </xsl:if>
                        </xsl:for-each>
                    </sch:pattern>
                </xsl:if>
            </xsl:for-each>
        </sch:schema>
    </xsl:variable>

    <xsl:template match="*" mode="xPaths6040C">
        <xsl:variable name="r" select="@txt"/>
        <xsl:variable name="m" select="@msg"/>
        <xsl:variable name="e" select="@expl"/>
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="*[not(name() = 'sch:rule')][not(name() = 'XPaths')]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <XPaths6040B>
                <xsl:copy-of select="XPaths/@context"/>
                <xsl:copy-of select="XPaths/@xpath"/>
                <sch:rule context="{XPaths/@context}">
                    <sch:assert fpi="{@txt}" test="{XPaths/@xpath}">
                        <xsl:value-of select="@expl"/>
                    </sch:assert>
                </sch:rule>
            </XPaths6040B>
            <xsl:variable name="xpaths">
                <XPaths6040C>
                    <xsl:apply-templates select="." mode="makemtfxpath">
                        <xsl:with-param name="type" select="'niemname'"/>
                    </xsl:apply-templates>
                </XPaths6040C>
            </xsl:variable>
            <xsl:for-each select="$xpaths/*">
                <xsl:copy>
                    <xsl:for-each select="@*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <sch:rule context="{@context}">
                        <sch:assert fpi="{$r}" test="{@xpath}">
                            <xsl:value-of select="$e"/>
                        </sch:assert>
                    </sch:rule>
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>

    <xsl:variable name="sch6040C">
        <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            queryBinding="xslt">
            <sch:ns uri="urn:mtf:mil:6040b:niem:mtf" prefix="mtf"/> 
            <sch:ns uri="urn:us:gov:ic:ism" prefix="ism"/> 
            <sch:title>Structural Relationship Rules for USMTF MIL STD 6040C</sch:title>
            <xsl:for-each select="$rulepaths6040BC/*/Rule">
                <xsl:sort select="@msg"/>
                <xsl:variable name="m" select="@msg"/>
                <xsl:if test="not(preceding-sibling::*[@msg = $m])">
                    <xsl:variable name="rules">
                        <xsl:copy-of select="XPaths6040C/sch:rule"/>
                        <xsl:for-each select="following-sibling::Rule[@msg = $m]">
                            <xsl:copy-of select="XPaths6040C/sch:rule" copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <sch:pattern id="{@msg}">
                        <sch:title>
                            <xsl:text>Structural Relationship Rules</xsl:text>
                        </sch:title>
                        <xsl:for-each select="$rules/*">
                            <xsl:variable name="c" select="@context"/>
                            <xsl:if test="not(preceding-sibling::sch:rule[@context = $c])">
                                <xsl:copy>
                                    <xsl:copy-of select="@context"/>
                                    <xsl:copy-of select="sch:assert"/>
                                    <xsl:for-each select="following-sibling::sch:rule[@context = $c]">
                                        <xsl:copy-of select="sch:assert"/>
                                    </xsl:for-each>
                                </xsl:copy>
                            </xsl:if>
                        </xsl:for-each>
                    </sch:pattern>
                </xsl:if>
            </xsl:for-each>
        </sch:schema>
    </xsl:variable>

    <xsl:template match="@txt" mode="parse">
        <xsl:param name="msg"/>
        <xsl:variable name="alltxt" select="."/>
        <xsl:variable name="mnode" select="$msgxsd/*/*[@name = $msg]"/>
        <xsl:variable name="seq">
            <xsl:for-each select="tokenize(., ' ')">
                <xsl:variable name="t" select="translate(., '()', '')"/>
                <xsl:choose>
                    <xsl:when
                        test="$t = 'A' or $t = 'R' or $t = 'RP' or $t = 'P' or $t = 'EQ' or $t = '!EQ' or $t = '!EQ' or $t = '@=' or $t = '=' or $t = '|' or $t = '&amp;' or $t = '&gt;' or $t = '&lt;'">
                        <Instr txt="{$t}"/>
                        <xsl:choose>
                            <xsl:when test="$t = 'A'">
                                <Val txt="{translate(substring-after($alltxt,' A '),'/','')}"/>
                            </xsl:when>
                            <xsl:when test="$t = 'EQ'">
                                <xsl:variable name="e" select="substring-after($alltxt, ' EQ ')"/>
                                <xsl:choose>
                                    <xsl:when test="contains($e, ' EQ ')">
                                        <xsl:apply-templates select="substring-before($e, ' EQ ')" mode="parse">
                                            <xsl:with-param name="msg" select="$msg"/>
                                        </xsl:apply-templates>
                                        <Instr txt="EQ"/>
                                        <xsl:choose>
                                            <xsl:when test="contains(substring-before($e, ' EQ '), '/')">
                                                <Val txt="{translate(substring-before($e, ' EQ '),'/)','')}"/>
                                            </xsl:when>
                                            <xsl:when test="contains(substring-after($e, ' EQ '), '/')">
                                                <Val txt="{translate(substring-after($e, ' EQ '),'/)','')}"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="substring-after($e, ' EQ ')" mode="parse">
                                                    <xsl:with-param name="msg" select="$msg"/>
                                                </xsl:apply-templates>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="contains($e, '/') and contains($e, '|') and contains($e, '[')">
                                        <xsl:apply-templates select="substring-after($e, '|')" mode="parse">
                                            <xsl:with-param name="msg" select="$msg"/>
                                        </xsl:apply-templates>
                                    </xsl:when>
                                    <xsl:when test="contains($e, '/') and contains($e, '|')">
                                        <Val txt="{translate($e,'/)','')}"/>
                                    </xsl:when>
                                    <xsl:when test="contains($e, '/')">
                                        <Val txt="{translate($e,'/)','')}"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="substring-after($alltxt, ' EQ ')" mode="parse">
                                            <xsl:with-param name="msg" select="$msg"/>
                                        </xsl:apply-templates>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="$t = '!EQ'">
                                <xsl:variable name="e" select="substring-after($alltxt, ' !EQ ')"/>
                                <xsl:choose>
                                    <xsl:when test="contains($e, ' EQ ')">
                                        <xsl:apply-templates select="substring-before($e, ' EQ ')" mode="parse">
                                            <xsl:with-param name="msg" select="$msg"/>
                                        </xsl:apply-templates>
                                        <Instr txt="EQ"/>
                                        <xsl:choose>
                                            <xsl:when test="contains(substring-after($e, ' EQ '), '/')">
                                                <Val txt="{translate(substring-after($e, ' EQ '),'/)','')}"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="substring-after($e, ' EQ ')" mode="parse">
                                                    <xsl:with-param name="msg" select="$msg"/>
                                                </xsl:apply-templates>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="contains($e, '/') and contains($e, '|') and contains($e, '[')">
                                        <xsl:apply-templates select="substring-after($e, '|')" mode="parse">
                                            <xsl:with-param name="msg" select="$msg"/>
                                        </xsl:apply-templates>
                                    </xsl:when>
                                    <xsl:when test="contains($e, '/') and contains($e, '|')">
                                        <Val txt="{translate($e,'/)','')}"/>
                                    </xsl:when>
                                    <xsl:when test="contains($e, '/')">
                                        <Val txt="{translate($e,'/)','')}"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="substring-after($alltxt, ' !EQ ')" mode="parse">
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
                            <xsl:when test="$t = '&gt;'">
                                <Val txt="{translate(substring-after($alltxt, '&gt;'),' )','')}"/>
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
        <xsl:variable name="mtft">
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
            <xsl:when test="@txt = 'FG'">
                <xsl:variable name="st" select="preceding-sibling::Set/@txt"/>
                <xsl:copy>
                    <xsl:copy-of select="@txt"/>
                    <xsl:attribute name="mtfname">
                        <xsl:text>GroupOfFields</xsl:text>
                    </xsl:attribute>
                </xsl:copy>
                <xsl:apply-templates select="following-sibling::Field[1]" mode="getName">
                    <xsl:with-param name="parent" select="$parent"/>
                    <xsl:with-param name="msg" select="$msg"/>
                </xsl:apply-templates>
            </xsl:when>
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
                    <xsl:variable name="mtfn">
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
                                <xsl:value-of select="$setxsd/*/*[@name = $mtft]//*:element[*:annotation/*:appinfo/*:FieldFormatPositionNumber = $t]/@name"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="mtfname">
                        <xsl:value-of select="$mtfn"/>
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
            <xsl:when test="matches($txt, 'NFS[0-9][0-9]?')">
                <Field txt="{translate($txt,'NFS','')}"/>
            </xsl:when>
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
                <Field txt="FG"/>
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

    <xsl:template match="*" mode="sidentity">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="sidentity"/>
            <xsl:apply-templates select="text()" mode="sidentity"/>
            <xsl:apply-templates select="*" mode="sidentity"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="sidentity">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

    <!-- NIEM NAMES-->
    <xsl:template match="*" mode="niemrule">
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="*">
                <xsl:choose>
                    <xsl:when test="@mtfname">
                        <xsl:apply-templates select="." mode="addniemname"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*" mode="addniemname">
        <xsl:copy>
            <xsl:copy-of select="@txt"/>
            <xsl:copy-of select="@mtfname"/>
            <xsl:variable name="pname">
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[1][@mtfname]">
                        <xsl:value-of select="preceding-sibling::*[1][@mtfname]/@mtfname"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="parent::Rule/@msg"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!--<xsl:attribute name="parentname" select="$pname"/>-->
            <xsl:variable name="niemname">
                <xsl:call-template name="niemchg">
                    <xsl:with-param name="mname" select="@mtfname"/>
                    <xsl:with-param name="pname" select="$pname"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="niemname">
                <xsl:choose>
                    <xsl:when test="contains($niemname, ' ')">
                        <xsl:value-of select="substring-before($niemname, ' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$niemname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    <xsl:template name="niemchg">
        <xsl:param name="mname"/>
        <xsl:param name="pname"/>
        <xsl:choose>
            <xsl:when test="$setmaps//*[@name = $mname][Element/@setname = $pname]">
                <xsl:value-of select="$setmaps//*[@name = $mname][Element/@setname = $pname][1]/@niemname"/>
            </xsl:when>
            <xsl:when test="$setmaps//*[@mtfname = $mname][@setname = $pname]">
                <xsl:value-of select="$setmaps//*[@mtfname = $mname][@setname = $pname][1]/@niemelementname"/>
            </xsl:when>
            <xsl:when test="$segmaps//*[@mtfname = $mname][@segmentname = $pname]">
                <xsl:value-of select="$segmaps//*[@mtfname = $mname][@segmentname = $pname][1]/@niemelementname"/>
            </xsl:when>
            <xsl:when test="$msgmaps//*[@mtfname = $mname][@messagename = $pname]">
                <xsl:value-of select="$msgmaps//*[@mtfname = $mname][@messagename = $pname][1]/@niemelementname"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$mname"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
