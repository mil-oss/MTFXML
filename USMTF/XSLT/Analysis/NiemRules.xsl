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

    <xsl:variable name="msgmap_xsd" select="document('../../XSD/NIEM_MTF/refxsd/maps/usmtf-msgsmaps.xml')"/>
    <xsl:variable name="setmap_xsd" select="document('../../XSD/NIEM_MTF/refxsd/maps/usmtf-setmaps.xml')"/>
    <xsl:variable name="segmap_xsd" select="document('../../XSD/NIEM_MTF/refxsd/maps/usmtf-segmntmaps.xml')"/>

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
        <List>
            <f sel="FF3-4" name="MissionRequestNumberStandardAirRequestNumberText"/>
            <f sel="FF956-14" name="NumberOfTargetsDescribedOrDmpisPassedNumberOfDmpisPassedNumeric"/>
            <f sel="FF679-4" name="SourceForClassificationOriginalClassificationAuthorityText"/>
            <f sel="FF956-2" name="NumberOfTargetsDescribedOrDmpisPassedNumberOfTargetsDescribedNumeric"/>
            <f sel="FF673-1" name="ReferenceNumberReferenceNumberText"/>
            <f sel="FF110-1" name="SecondaryRadioFrequencyText"/>
            <f sel="FF652-1" name="OfEaFrequencyOfEmission"/>
            <f sel="FF1528-3" name="EwUpperFrequencyUpperFrequencyInPulsesPerSecondNumeric"/>
            <f sel="FF1528-2" name="EwLowerFrequencyLowerFrequencyInPulsesPerSecondNumeric"/>
            <f sel="FF1426-4" name="TypeOfUnitAssetControlPositionTypeCode"/>
            <f sel="FF343-1" name="FirstPointNorthingUtm1MeterNumeric"/>
            <f sel="FF342-1" name="LocationEastingUtm1MeterNumeric"/>
            <f sel="FF658-2" name="LocationNorthingUtm1MeterHigherOrder7CharacterNumeric"/>
            <f sel="FF657-2" name="SecondPointEastingUtm1MeterHigherOrderNumeric"/>
            <f sel="FF1023-1" name="GridZoneMgrsUtmAnd100KmSquare"/>
            <f sel="FF687-1" name="UtmGridZoneDesignatorNumeric"/>
            <f sel="FF927-2" name="CbrnReportTypeOfCbrnReportCode"/>
            <f sel="FF2309-10" name="GroundLocationNoFixCode"/>
            <f sel="FF1430-4" name="PartIdentificationNumberNationalStockNumberText"/>
            <f sel="FF1431-3" name="ReportedOrdnanceTypeDepartmentOfDefenseIdentificationCodeText"/>
            <f sel="FF9-1" name="ResourcePersonnelReportingClassification"/>
            <f sel="FF487-156" name="ResourceIdentificationEquipmentLineItemNumberText"/>
            <f sel="FF1360-1" name="ResourceDataIdentificationLineItemNumber"/>
        </List>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="{concat($Outdir,'USMTF_Rules.xml')}">
            <xsl:copy-of select="$msgrules"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'ChangeNames.xml')}">
            <Changenames>
                <xsl:copy-of select="$changenames" copy-namespaces="no"/>
            </Changenames>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'Rules.xml')}">
            <Rules>
                <xsl:for-each select="$rulexpaths/Rules/Rule">
                    <xsl:sort select="@msg"/>
                    <xsl:sort select="@txt"/>
                    <xsl:variable name="m" select="@msg"/>
                    <xsl:variable name="t" select="@txt"/>
                    <!--<xsl:choose>
                        <xsl:when test="$donerules/Rule[@msg = $m][@txt = $t]">
                            <xsl:copy-of select="$donerules/Rule[@msg = $m][@txt = $t]"/>
                        </xsl:when>
                        <xsl:otherwise>-->
                    <xsl:copy-of select="."/>
                    <!--</xsl:otherwise>
                    </xsl:choose>-->
                </xsl:for-each>
            </Rules>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'USMTFSchematron.sch')}">
            <xsl:copy-of select="$schtronrules"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'USMTF_Rules_Sch.xml')}">
            <MessageRules>
                <xsl:for-each select="$msgrules/*/*">
                    <xsl:copy>
                        <xsl:apply-templates select="@*" mode="identity"/>
                        <xsl:variable name="m" select="@msg"/>
                        <xsl:copy-of select="$schtronrules/*//sch:rule[@context = $m]"/>
                    </xsl:copy>
                </xsl:for-each>
            </MessageRules>
        </xsl:result-document>
    </xsl:template>

    <xsl:variable name="rules">
        <xsl:for-each select="$messages_xsd//xsd:element[xsd:annotation/xsd:appinfo/*:MtfIdentifier]">
            <!--<Message name="{@name}">-->
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*" mode="makerule"/>
            <!--</Message>-->
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="rulexpaths">
        <Rules>
            <xsl:for-each select="$rules//Rule">
                <xsl:variable name="t" select="@txt"/>
                <xsl:variable name="m" select="parent::*/@msg"/>
                <!--<xsl:variable name="xsnrule">
                    <xsl:value-of select="parent::*/XsnRule"/>
                </xsl:variable>-->
                <!--<Rule msg="{$m}" txt="{@txt}"  xsnrule="{$xsnrule}">-->
                <Rule msg="{$m}" txt="{@txt}">
                    <xsl:call-template name="makePath">
                        <xsl:with-param name="parent" select="$m"/>
                        <xsl:with-param name="txt" select="@txt"/>
                    </xsl:call-template>
                </Rule>
            </xsl:for-each>
        </Rules>
    </xsl:variable>

    <xsl:variable name="schtronrules">
        <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
            <sch:title>Structural Relationship Rules for USMTF</sch:title>
            <xsl:for-each select="$rulexpaths/*/Rule">
                <xsl:sort select="@msg"/>
                <xsl:variable name="m" select="@msg"/>
                <xsl:if test="not(preceding-sibling::*[@msg = $m])">
                    <xsl:variable name="c">
                        <xsl:choose>
                            <xsl:when test="@context = ''">
                                <xsl:value-of select="@msg"/>
                            </xsl:when>
                            <xsl:when test="ends-with(@context, '/')">
                                <xsl:value-of select="concat(@msg, '/', substring(@context, 0, string-length(@context)))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(@msg, '/', @context)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <sch:pattern id="{concat(@msg,'-Rules')}">
                        <sch:title>
                            <xsl:value-of select="concat(@msg, ' Structural Relationship Rules')"/>
                        </sch:title>
                        <sch:rule context="{$c}" fpi="{@txt}">
                            <sch:assert test="{@xpath}">
                                <xsl:value-of select="@responsetxt"/>
                            </sch:assert>
                        </sch:rule>
                        <xsl:for-each select="following-sibling::*[@msg = $m]">
                            <xsl:variable name="c">
                                <xsl:choose>
                                    <xsl:when test="@context = ''">
                                        <xsl:value-of select="@msg"/>
                                    </xsl:when>
                                    <xsl:when test="ends-with(@context, '/')">
                                        <xsl:value-of select="concat(@msg, '/', substring(@context, 0, string-length(@context)))"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat(@msg, '/', @context)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <sch:rule context="{$c}" fpi="{@txt}">
                                <sch:assert test="{@xpath}">
                                    <xsl:value-of select="@responsetxt"/>
                                </sch:assert>
                            </sch:rule>
                        </xsl:for-each>
                    </sch:pattern>
                </xsl:if>
            </xsl:for-each>
        </sch:schema>
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

    <xsl:template name="makePath">
        <xsl:param name="parent"/>
        <xsl:param name="txt"/>
        <xsl:variable name="rstr" select="$txt"/>
        <!--<xsl:value-of select="concat($parent, '/')"/>-->
        <xsl:variable name="nodes">
            <xsl:for-each select="tokenize($rstr, ',')">
                <!--<xsl:variable name="vals">-->
                <xsl:choose>
                    <xsl:when test="contains(., 'AFG')"/>
                    <xsl:when test="contains(., ' ')">
                        <xsl:for-each select="tokenize(., ' ')">
                            <xsl:variable name="vs" select="translate(., '()', '')"/>
                            <xsl:call-template name="makenode">
                                <xsl:with-param name="v" select="$vs"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="v">
                            <xsl:choose>
                                <xsl:when test="contains(., ' ')">
                                    <xsl:value-of select="substring-before(., ' ')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="translate(., '()', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:call-template name="makenode">
                            <xsl:with-param name="v" select="$v"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <!--</xsl:variable>-->
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="msgname" select="$msgmap_xsd/Messages/Message[@mtfname = $parent]/@mtfname"/>
        <xsl:variable name="namednodes">
            <xsl:call-template name="nodeNames">
                <xsl:with-param name="msg" select="$msgname"/>
                <xsl:with-param name="parent" select="$msgname"/>
                <xsl:with-param name="nlist" select="$nodes"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="left" select="$namednodes/*[following-sibling::n[@rel][1]]"/>
        <xsl:variable name="right" select="$namednodes/*[preceding-sibling::n[@rel][1]]"/>
        <xsl:variable name="context">
            <xsl:choose>
                <xsl:when test="$fixrules/Rule[@msg = $parent][@rtxt = $txt]/@context">
                    <xsl:value-of select="$fixrules/Rule[@msg = $parent][@rtxt = $txt]/@context"/>
                </xsl:when>
                <xsl:when test="$namednodes/*[@rel = 'A']">
                    <xsl:for-each select="$left[not(@field)][not(@rel)]">
                        <xsl:value-of select="@nodename"/>
                        <xsl:text>/</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$namednodes/*[@rel = 'RP']">
                    <xsl:for-each select="$left">
                        <xsl:variable name="n" select="@nodename"/>
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:if test="$right[$pos]/@nodename = $n">
                            <xsl:value-of select="@nodename"/>
                            <xsl:text>/</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$namednodes/*[@rel = '=']">
                    <xsl:for-each select="$left[following-sibling::n[@rel][1]]">
                        <xsl:choose>
                            <xsl:when test="@rel"/>
                            <xsl:when test="preceding-sibling::n[@rel = '=']"/>
                            <xsl:when test="contains(@nodename, '|')"/>
                            <!--<xsl:when test="starts-with(@v,'FF')">
                                <xsl:value-of select="@nodename"/>
                                <xsl:text>/</xsl:text>
                            </xsl:when>-->
                            <xsl:otherwise>
                                <xsl:value-of select="@nodename"/>
                                <xsl:text>/</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="$left[not(@field)]">
                        <xsl:variable name="n" select="@nodename"/>
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:if test="$right[$pos]/@nodename = $n">
                            <xsl:value-of select="@nodename"/>
                            <xsl:text>/</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="context">
            <xsl:choose>
                <xsl:when test="ends-with($context, '/*')">
                    <xsl:value-of select="substring($context, 0, string-length($context)-1)"/>
                </xsl:when>
                <xsl:when test="ends-with($context, '/')">
                    <xsl:value-of select="substring($context, 0, string-length($context))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$context"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:variable name="xpath">
            <xsl:choose>
                <xsl:when test="$fixrules/Rule[@msg = $parent][@rtxt = $txt]/@xpath">
                    <xsl:value-of select="$fixrules/Rule[@msg = $parent][@rtxt = $txt]/@xpath"/>
                </xsl:when>
                <xsl:when test="$namednodes/*[@rel = 'A']">
                    <xsl:variable name="left" select="$namednodes/*[following-sibling::n[@rel = 'A']]"/>
                    <xsl:variable name="right" select="$namednodes/*[preceding-sibling::n[@rel = 'A']]"/>
                    <xsl:variable name="path">
                        <xsl:for-each select="$left">
                            <xsl:variable name="nn" select="@nodename"/>
                            <xsl:if test="not(contains($context, concat($nn, '/')))">
                                <xsl:value-of select="$nn"/>
                                <xsl:if test="not(@field) and not(@rel)">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:text>=</xsl:text>
                        <xsl:for-each select="$right">
                            <xsl:variable name="r" select="@rel"/>
                            <xsl:variable name="nn" select="@nodename"/>
                            <xsl:choose>
                                <xsl:when test="@rel">
                                    <xsl:value-of select="concat(@rel, ' ')"/>
                                </xsl:when>
                                <xsl:when test="not(contains($context, concat($nn, '/')))">
                                    <xsl:value-of select="$nn"/>
                                    <xsl:if test="not(@field) and not(@rel)">
                                        <xsl:text>/</xsl:text>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="normalize-space($path)"/>
                </xsl:when>
                <xsl:when test="$namednodes/*[@rel = 'RP']">
                    <xsl:variable name="left" select="$namednodes/*[following-sibling::n[@rel = 'RP']]"/>
                    <xsl:variable name="right" select="$namednodes/*[preceding-sibling::n[@rel = 'RP']]"/>
                    <xsl:variable name="e">
                        <xsl:for-each select="$left">
                            <xsl:variable name="nn" select="@nodename"/>
                            <xsl:if test="not(contains($context, concat($nn, '/')))">
                                <xsl:value-of select="$nn"/>
                                <xsl:if test="not(@rel) and following-sibling::n[not(@rel)]">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="exsts">
                        <xsl:choose>
                            <xsl:when test="ends-with($e, '/')">
                                <xsl:value-of select="substring($e, 0, string-length($e))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$e"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="fsel" select="$right[starts-with(@v, 'FF')][1]/@nodename"/>
                    <xsl:variable name="re">
                        <xsl:for-each select="$right">
                            <xsl:variable name="r" select="@rel"/>
                            <xsl:variable name="nn" select="@nodename"/>
                            <xsl:choose>
                                <xsl:when test="$right[@rel = '=']">
                                    <xsl:variable name="path">
                                        <xsl:value-of select="$fsel"/>
                                    </xsl:variable>
                                    <xsl:value-of select="normalize-space($path)"/>
                                </xsl:when>
                                <xsl:when test="@rel = '!EQ'">
                                    <xsl:text>!=</xsl:text>
                                </xsl:when>
                                <xsl:when test="@rel = 'EQ'">
                                    <xsl:text>=</xsl:text>
                                </xsl:when>
                                <xsl:when test="@rel = '!@'"/>
                                <xsl:when test="@rel = '@'"/>
                                <xsl:when test="@rel">
                                    <xsl:value-of select="concat(@rel, ' ')"/>
                                </xsl:when>
                                <!--<xsl:when test="contains($nn, 'P')"/>-->
                                <xsl:when test="not(contains($context, concat($nn, '/')))">
                                    <xsl:value-of select="$nn"/>
                                    <xsl:if test="not(@field) and not(@rel)">
                                        <xsl:text>/</xsl:text>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="rexsts">
                        <xsl:choose>
                            <xsl:when test="contains($txt, 'RP ([3]F10 EQ /CONFIDENTIAL/ |')">
                                <xsl:text>MessageIdentifierSet/MessageSecurityClassification/MessageSecurityClassificationExtendedCode ='CONFIDENTIAL' | 'SECRET' | 'TOP SECRET' | 'RESTRICTED' | 'NATO RESTRICTED' | 'NATO CONFIDENTIAL' | 'NATO SECRET' | 'NATO SECRET-SAVATE' | 'NATO SECRET-AVICULA' | 'COSMIC TOP SECRET' | 'COSMIC TOP SECRET-BOHEMIA' | 'COSMIC TOP SECRET-BALK' | 'COSMIC TOP SECRET ATOMAL' | 'NATO SECRET ATOMAL' | 'NATO CONFIDENTIAL ATOMAL'</xsl:text>
                            </xsl:when>
                            <xsl:when test="ends-with($re, '/')">
                                <xsl:text>exists(</xsl:text>
                                <xsl:value-of select="substring($re, 0, string-length($re))"/>
                                <xsl:text>) </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$re"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="path">
                        <xsl:text>exists(</xsl:text>
                        <xsl:value-of select="$exsts"/>
                        <xsl:text>)</xsl:text>
                        <xsl:choose>
                            <xsl:when test="not(contains($rexsts, '*'))">
                                <xsl:text> and exists(</xsl:text>
                                <xsl:value-of select="$rexsts"/>
                                <xsl:text>)</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text> and </xsl:text>
                                <xsl:value-of select="$rexsts"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="contains($path, '*')">
                            <xsl:value-of select="substring-before($path, ' and ')"/>
                            <xsl:text> and substring(</xsl:text>
                            <xsl:value-of select="substring-before(substring-after($path, ' and '), '=')"/>
                            <xsl:text>,1,1)=</xsl:text>
                            <xsl:value-of select="translate(substring-after($path, '='), '*', '')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space($path)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$namednodes/*[@rel = 'P']">
                    <xsl:variable name="left" select="$namednodes/*[following-sibling::n[@rel = 'P']]"/>
                    <xsl:variable name="right" select="$namednodes/*[preceding-sibling::n[@rel = 'P']]"/>
                    <xsl:variable name="e">
                        <xsl:for-each select="$left">
                            <xsl:variable name="nn" select="@nodename"/>
                            <xsl:if test="not(contains($context, concat($nn, '/')))">
                                <xsl:value-of select="$nn"/>
                                <xsl:if test="not(@rel) and following-sibling::n[not(@rel)]">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="exsts">
                        <xsl:choose>
                            <xsl:when test="ends-with($e, '/')">
                                <xsl:value-of select="substring($e, 0, string-length($e))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$e"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="re">
                        <xsl:for-each select="$right">
                            <xsl:variable name="r" select="@rel"/>
                            <xsl:variable name="nn" select="@nodename"/>
                            <xsl:choose>
                                <xsl:when test="@rel = '!EQ'">
                                    <xsl:text>=</xsl:text>
                                </xsl:when>
                                <xsl:when test="@rel = 'EQ'">
                                    <xsl:text>!=</xsl:text>
                                </xsl:when>
                                <xsl:when test="@rel = '!@'"/>
                                <xsl:when test="@rel = '@'"/>
                                <xsl:when test="@rel">
                                    <xsl:value-of select="concat(@rel, ' ')"/>
                                </xsl:when>
                                <!--<xsl:when test="contains($nn, 'P')"/>-->
                                <xsl:when test="not(contains($context, concat($nn, '/')))">
                                    <xsl:value-of select="$nn"/>
                                    <xsl:if test="not(@field) and not(@rel)">
                                        <xsl:text>/</xsl:text>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="rexsts">
                        <xsl:choose>
                            <xsl:when test="ends-with($re, '/')">
                                <xsl:value-of select="substring($re, 0, string-length($re))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$re"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="path">
                        <xsl:text>exists(</xsl:text>
                        <xsl:value-of select="$exsts"/>
                        <xsl:text>) and not(exists(</xsl:text>
                        <xsl:value-of select="$rexsts"/>
                        <xsl:text>))</xsl:text>
                    </xsl:variable>
                    <xsl:value-of select="normalize-space($path)"/>
                </xsl:when>
                <xsl:when test="$namednodes/*[@rel = 'R']">
                    <xsl:variable name="left" select="$namednodes/*[following-sibling::n[@rel = 'R']]"/>
                    <xsl:variable name="right" select="$namednodes/*[preceding-sibling::n[@rel = 'R']]"/>
                    <xsl:variable name="e">
                        <xsl:for-each select="$left">
                            <xsl:variable name="nn" select="@nodename"/>
                            <xsl:if test="not(contains($context, concat($nn, '/')))">
                                <xsl:value-of select="$nn"/>
                                <xsl:if test="not(@rel) and following-sibling::n[not(@rel)]">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="exsts">
                        <xsl:choose>
                            <xsl:when test="ends-with($e, '/')">
                                <xsl:value-of select="substring($e, 0, string-length($e))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$e"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="re">
                        <xsl:for-each select="$right">
                            <xsl:variable name="r" select="@rel"/>
                            <xsl:variable name="nn" select="@nodename"/>
                            <xsl:choose>
                                <xsl:when test="@rel = '!EQ'">
                                    <xsl:text>!=</xsl:text>
                                </xsl:when>
                                <xsl:when test="@rel = 'EQ'">
                                    <xsl:text>=</xsl:text>
                                </xsl:when>
                                <xsl:when test="@rel = '!@'"/>
                                <xsl:when test="@rel = '@'"/>
                                <xsl:when test="@rel">
                                    <xsl:value-of select="concat(@rel, ' ')"/>
                                </xsl:when>
                                <!--<xsl:when test="contains($nn, 'P')"/>-->
                                <xsl:when test="not(contains($context, concat($nn, '/')))">
                                    <xsl:value-of select="$nn"/>
                                    <xsl:if test="not(@field) and not(@rel)">
                                        <xsl:text>/</xsl:text>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="rexsts">
                        <xsl:choose>
                            <xsl:when test="ends-with($re, '/')">
                                <xsl:value-of select="substring($re, 0, string-length($re))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$re"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="path">
                        <xsl:text>exists(</xsl:text>
                        <xsl:value-of select="$exsts"/>
                        <xsl:text>)</xsl:text>
                        <xsl:if test="not(contains($rexsts, '*'))">
                            <xsl:text> and exists(</xsl:text>
                            <xsl:value-of select="$rexsts"/>
                            <xsl:text>)</xsl:text>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="contains($path, '*')">
                            <xsl:value-of select="substring-before($path, ' and ')"/>
                            <xsl:text>substring(</xsl:text>
                            <xsl:value-of select="substring-before(substring-after($path, ' and '), '*')"/>
                            <xsl:text>,1,1)=</xsl:text>
                            <xsl:value-of select="translate(substring-after($path, '='), '*', '')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space($path)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$namednodes/*[@rel = 'EQ']">
                    <xsl:variable name="left" select="$namednodes/*[following-sibling::n[@rel = 'EQ']]"/>
                    <xsl:variable name="right" select="$namednodes/*[preceding-sibling::n[@rel = 'EQ']]"/>
                    <xsl:variable name="path">
                        <xsl:for-each select="$left">
                            <xsl:variable name="nn" select="@nodename"/>
                            <xsl:if test="not(contains($context, concat($nn, '/')))">
                                <xsl:value-of select="$nn"/>
                                <xsl:if test="not(@field) and not(@rel)">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:text>=</xsl:text>
                        <xsl:for-each select="$right">
                            <xsl:variable name="r" select="@rel"/>
                            <xsl:variable name="nn" select="@nodename"/>
                            <xsl:choose>
                                <xsl:when test="@rel">
                                    <xsl:value-of select="concat(@rel, ' ')"/>
                                </xsl:when>
                                <xsl:when test="not(contains($context, concat($nn, '/')))">
                                    <xsl:value-of select="$nn"/>
                                    <xsl:if test="not(@field) and not(@rel)">
                                        <xsl:text>/</xsl:text>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="translate(normalize-space($path), '!@', '')"/>
                </xsl:when>
                <xsl:when test="$namednodes/*[@rel = '!EQ']">
                    <xsl:variable name="left" select="$namednodes/*[following-sibling::n[@rel = '!EQ']]"/>
                    <xsl:variable name="right" select="$namednodes/*[preceding-sibling::n[@rel = '!EQ']]"/>
                    <xsl:variable name="path">
                        <xsl:for-each select="$left">
                            <xsl:variable name="nn" select="@nodename"/>
                            <xsl:if test="not(contains($context, concat($nn, '/')))">
                                <xsl:value-of select="$nn"/>
                                <xsl:if test="not(@field) and not(@rel)">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:text>!=</xsl:text>
                        <xsl:for-each select="$right">
                            <xsl:variable name="r" select="@rel"/>
                            <xsl:variable name="nn" select="@nodename"/>
                            <xsl:choose>
                                <xsl:when test="@rel">
                                    <xsl:value-of select="concat(@rel, ' ')"/>
                                </xsl:when>
                                <xsl:when test="not(contains($context, concat($nn, '/')))">
                                    <xsl:value-of select="$nn"/>
                                    <xsl:if test="not(@field) and not(@rel)">
                                        <xsl:text>/</xsl:text>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="translate(normalize-space($path), '!@', '')"/>
                </xsl:when>
                <xsl:when test="$namednodes/*[@rel = '=']">
                    <xsl:variable name="leftsel" select="$namednodes/*[starts-with(@v, 'FF')][1]/@nodename"/>
                    <xsl:variable name="rightsel" select="$namednodes/*[starts-with(@v, 'FF')][2]/@nodename"/>
                    <xsl:variable name="path">
                        <xsl:text>exists(</xsl:text>
                        <xsl:value-of select="$leftsel"/>
                        <xsl:text>) and exists(</xsl:text>
                        <xsl:value-of select="$rightsel"/>
                        <xsl:text>)</xsl:text>
                    </xsl:variable>
                    <xsl:value-of select="normalize-space($path)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="xpath">
            <!--<xsl:choose>
                <xsl:when test="$donerules/Rule[@msg = $parent][@txt = $txt]/@xpath">
                    <xsl:copy-of select="$donerules/Rule[@msg = $parent][@txt = $txt]/@xpath"/>
                </xsl:when>
                <xsl:otherwise>-->
            <xsl:value-of select="normalize-space($xpath)"/>
            <!--</xsl:otherwise>
            </xsl:choose>-->
        </xsl:attribute>
        <xsl:attribute name="responsetxt">
            <xsl:value-of select="normalize-space(replace(parent::*/Explanation, '&#34;', $a))"/>
        </xsl:attribute>
        <xsl:copy-of select="$namednodes"/>
    </xsl:template>

    <xsl:template name="makenode">
        <xsl:param name="v"/>
        <xsl:element name="n">
            <xsl:choose>
                <xsl:when test="contains($v, 'S]')">
                    <xsl:attribute name="v" select="$v"/>
                    <xsl:attribute name="segment">
                        <xsl:value-of select="translate(., '(ABCDEZLN[S]', '')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="contains($v, ']FG')">
                    <xsl:attribute name="v" select="$v"/>
                    <xsl:attribute name="set">
                        <xsl:value-of select="replace(translate($v, '(ABCDEZLN[] ', ''), 'FG', '')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="contains($v, ']F')">
                    <xsl:attribute name="v" select="$v"/>
                    <xsl:attribute name="set">
                        <xsl:value-of select="substring-before(translate($v, '(ABCDEZLN[]', ''), 'F')"/>
                    </xsl:attribute>
                    <xsl:attribute name="field">
                        <xsl:value-of select="number(substring-after($v, ']F'))"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="contains($v, ']')">
                    <xsl:attribute name="v" select="$v"/>
                    <xsl:attribute name="set">
                        <xsl:value-of select="replace(translate($v, '(ABCDEZLN[] ', ''), 'FG', '')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="$ffisel/*/*[@sel = $v]">
                    <xsl:attribute name="v" select="$v"/>
                    <xsl:attribute name="field">
                        <xsl:value-of select="$ffisel/*/*[@sel = $v]/@name"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="contains($v, 'F') and string-length($v) &lt; 5">
                    <xsl:attribute name="v" select="$v"/>
                    <xsl:attribute name="field">
                        <xsl:value-of select="substring-after(replace($v, 'FF', 'F'), 'F')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="rel">
                        <xsl:value-of select="translate($v, '/', $a)"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <!--// -\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\- ///-->

    <xsl:template name="commonContext">
        <xsl:param name="path1"/>
        <xsl:param name="path2"/>
        <xsl:variable name="t1">
            <xsl:for-each select="tokenize($path1, '/')">
                <n name="{string(.)}"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="t2">
            <xsl:for-each select="tokenize($path2, '/')">
                <n name="{string(.)}"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$t1/*">
            <xsl:variable name="p" select="position()"/>
            <xsl:choose>
                <xsl:when test="@name = $t2/*[$p]/@name">
                    <xsl:value-of select="concat(@name, '/')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="nodeNames">
        <xsl:param name="msg"/>
        <xsl:param name="parent"/>
        <xsl:param name="nlist"/>
        <xsl:variable name="nodename">
            <xsl:call-template name="nodeName">
                <xsl:with-param name="parent" select="replace($parent, '/', '')"/>
                <xsl:with-param name="segno" select="$nlist/*[1]/@segment"/>
                <xsl:with-param name="setno" select="$nlist/*[1]/@set"/>
                <xsl:with-param name="fieldno" select="$nlist/*[1]/@field"/>
                <xsl:with-param name="rel" select="$nlist/*[1]/@rel"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:for-each select="$nlist/*[1]">
            <xsl:copy>
                <xsl:choose>
                    <xsl:when test="contains($nodename, '/')">
                        <xsl:apply-templates select="@*[not(name() = 'field')]" mode="identity"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="@*" mode="identity"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="not(@rel)">
                    <xsl:attribute name="parent">
                        <xsl:value-of select="$parent"/>
                    </xsl:attribute>
                    <xsl:attribute name="nodename">
                        <xsl:choose>
                            <xsl:when test="contains($nodename, '/')">
                                <xsl:value-of select="substring-before($nodename, '/')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$nodename"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:if>
            </xsl:copy>
            <xsl:if test="contains($nodename, '/')">
                <n field="{@field}" parent="{substring-before($nodename,'/')}" nodename="{substring-after($nodename,'/')}"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="$nlist/*[2]">
            <xsl:call-template name="nodeNames">
                <xsl:with-param name="msg" select="$msg"/>
                <xsl:with-param name="parent">
                    <xsl:choose>
                        <xsl:when test="string-length($nodename) &gt; 0">
                            <xsl:value-of select="$nodename"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$msg"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="nlist">
                    <xsl:for-each select="$nlist/*[position() &gt; 1]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="nodeName">
        <xsl:param name="parent"/>
        <xsl:param name="segno"/>
        <xsl:param name="setno"/>
        <xsl:param name="fieldno"/>
        <xsl:param name="rel"/>
        <xsl:choose>
            <xsl:when test="$rel">
                <xsl:value-of select="@rel"/>
            </xsl:when>
            <xsl:when test="$segno">
                <xsl:call-template name="parseSegment">
                    <xsl:with-param name="parent" select="$parent"/>
                    <xsl:with-param name="segno" select="$segno"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$setno and $fieldno">
                <xsl:call-template name="parseSetField">
                    <xsl:with-param name="parent" select="$parent"/>
                    <xsl:with-param name="fldno" select="$fieldno"/>
                    <xsl:with-param name="setno" select="$setno"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$setno">
                <xsl:call-template name="parseSet">
                    <xsl:with-param name="parent" select="$parent"/>
                    <xsl:with-param name="setno" select="$setno"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$fieldno">
                <xsl:call-template name="parseField">
                    <xsl:with-param name="parent" select="$parent"/>
                    <xsl:with-param name="fldno" select="$fieldno"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="parseSegment">
        <xsl:param name="parent"/>
        <xsl:param name="segno"/>
        <xsl:choose>
            <xsl:when test="contains($segno, '..')">
                <!--<xsl:choose>
                    <xsl:when test="$msgmap_xsd/Messages/Message[@mtfname = $parent]/*/Element[info/*/@initialPosition = substring-before($segno, '..')]/@niemelementname">
                        <xsl:value-of select="$msgmap_xsd/Messages/Message[@mtfname = $parent]/*/Element[info/*/@initialPosition = substring-before($segno, '..')][1]/@niemelementname"/>
                    </xsl:when>
                    <xsl:when test="$segmap_xsd/Segments/Segment[@niemelementname = $parent]/*/Element[info/*/@initialPosition = substring-before($segno, '..')]/@niemelementname">
                        <xsl:value-of select="$segmap_xsd/Segments/Segment[@niemelementname = $parent]/*/Element[info/*/@initialPosition = substring-before($segno, '..')][1]/@niemelementname"/>
                        <xsl:value-of select="$segmap_xsd/Segments/Segment[@niemelementname = $parent]/*/Element[info/*/@initialPosition = substring-before($segno, '..')][1]/@niemelementname"/>
                    </xsl:when>
                </xsl:choose>-->
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$msgmap_xsd/Messages/Message[@mtfname = $parent]/*/Element[info/*/@initialPosition = $segno]/@mtfname">
                        <xsl:value-of select="$msgmap_xsd/Messages/Message[@mtfname = $parent]/*/Element[info/*/@initialPosition = $segno][1]/@niemelementname"/>
                    </xsl:when>
                    <xsl:when test="$segmap_xsd/Segments/Segment[@niemelementname = $parent]/*/Element[info/*/@initialPosition = $segno]/@mtfname">
                        <xsl:value-of select="$segmap_xsd/Segments/Segment[@niemelementname = $parent]/*/Element[info/*/@initialPosition = $segno][1]/@niemelementname"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="parseSet">
        <xsl:param name="parent"/>
        <xsl:param name="setno"/>
        <set>
            <xsl:choose>
                <xsl:when test="$msgmap_xsd/Messages/Message[@mtfname = $parent]/Sequence/Element[@setseq = $setno]/@niemelementname">
                    <xsl:value-of select="$msgmap_xsd/Messages/Message[@mtfname = $parent][1]/Sequence/Element[@setseq = $setno][1]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$segmap_xsd/Segments/Segment[@niemelementname = $parent]/Sequence/Element[@setseq = $setno]/@niemelementname">
                    <xsl:value-of select="$segmap_xsd/Segments/Segment[@niemelementname = $parent][1]/Sequence/Element[@setseq = $setno][1]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$msgmap_xsd/Messages/Message[@mtfname = $parent]//Element[@setseq = $setno]/@niemelementname">
                    <xsl:value-of select="$msgmap_xsd/Messages/Message[@mtfname = $parent][1]//Element[@setseq = $setno][1]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$segmap_xsd/Segments/Segment[@niemelementname = $parent]//Element[@setseq = $setno]/@niemelementname">
                    <xsl:value-of select="$segmap_xsd/Segments/Segment[@niemelementname = $parent][1]//Element[@setseq = $setno][1]/@niemelementname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($parent, ' .. ', $setno)"/>
                </xsl:otherwise>
            </xsl:choose>
        </set>
    </xsl:template>
    <xsl:template name="parseSetField">
        <xsl:param name="parent"/>
        <xsl:param name="setno"/>
        <xsl:param name="fldno"/>
        <xsl:variable name="n">
            <xsl:choose>
                <xsl:when test="$msgmap_xsd/Messages/Message[@mtfname = $parent]/Sequence/Element[@setseq = $setno]/@niemelementname">
                    <xsl:value-of select="$msgmap_xsd/Messages/Message[@mtfname = $parent][1]/Sequence/Element[@setseq = $setno][1]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$segmap_xsd/Segments/Segment[@niemelementname = $parent]/Sequence/Element[@setseq = $setno]/@niemelementname">
                    <xsl:value-of select="$segmap_xsd/Segments/Segment[@niemelementname = $parent][1]/Sequence/Element[@setseq = $setno][1]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$setmap_xsd/Sets/Set[@niemelementname = $parent]/Sequence/Element[@setseq = $setno]/@niemelementname">
                    <xsl:value-of select="$setmap_xsd/Sets/Set[@niemelementname = $parent][1]/Sequence/Element[@seq = $setno][1]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$msgmap_xsd/Messages/Message[@mtfname = $parent]//Element[@setseq = $setno]/@niemelementname">
                    <xsl:value-of select="$msgmap_xsd/Messages/Message[@mtfname = $parent][1]//Element[@setseq = $setno][1]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$segmap_xsd/Segments/Segment[@niemelementname = $parent]//Element[@setseq = $setno]/@niemelementname">
                    <xsl:value-of select="$segmap_xsd/Segments/Segment[@niemelementname = $parent][1]//Element[@setseq = $setno][1]/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$setmap_xsd/Sets/Set[@niemelementname = $parent]//Element[@setseq = $setno]/@niemelementname">
                    <xsl:value-of select="$setmap_xsd/Sets/Set[@niemelementname = $parent][1]//Element[@seq = $setno][1]/@niemelementname"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$n != ''">
                <xsl:value-of select="$n"/>
                <xsl:text>/</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('[', $setno, ']')"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="ends-with($n, 'HeadingInformation')">
                <xsl:text>HeadingInformationText</xsl:text>
            </xsl:when>
            <xsl:when test="ends-with($n, 'GeneralText')">
                <xsl:text>SubjectText</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="f" select="$setmap_xsd/Sets/Set[@niemelementname = $n]/*/Element[@seq = $fldno]"/>
                <xsl:choose>
                    <xsl:when test="$f/Choice">
                        <xsl:for-each select="$f/Choice/Element">
                            <xsl:value-of select="@niemelementname"/>
                            <xsl:if test="following-sibling::Element">
                                <xsl:text> | </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="$f/@niemelementname">
                        <xsl:value-of select="$f/@niemelementname"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('[', $fldno, ']')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="parseField">
        <xsl:param name="parent"/>
        <xsl:param name="fldno"/>
        <xsl:choose>
            <xsl:when test="$setmap_xsd/Sets/Set[@niemelementname = $parent]/*/Element[@seq = number($fldno)]/Choice">
                <xsl:for-each select="$setmap_xsd/Sets/Set[@niemelementname = $parent]/*/Element[@seq = number($fldno)]/Choice/Element">
                    <xsl:value-of select="@niemelementname"/>
                    <xsl:if test="following-sibling::Element">
                        <xsl:text> | </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$setmap_xsd/Sets/Set[@niemelementname = $parent]/*/Element[@seq = number($fldno)]/@niemelementname">
                <xsl:value-of select="$setmap_xsd/Sets/Set[@niemelementname = $parent]/*/Element[@seq = number($fldno)]/@niemelementname"/>
            </xsl:when>
            <xsl:when test="$setmap_xsd/Sets/Set[@niemelementname = $parent]//Element[@seq = number($fldno)]/@niemelementname">
                <xsl:value-of select="$setmap_xsd/Sets/Set[@niemelementname = $parent]//Element[@seq = number($fldno)]/@niemelementname"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$parent"/>
                <xsl:value-of select="$fldno"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:variable name="changenames">
        <xsl:for-each select="$msgmap_xsd//Element">
            <xsl:variable name="m" select="@mtfname"/>
            <xsl:variable name="n" select="@mtfname"/>
            <xsl:variable name="p" select="ancestor::Message/@mtfname"/>
            <xsl:if test="string($m) != string($n)">
                <Change mtfname="{$m}" parent="{$p}" newname="{$n}"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

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
                <xsl:when test="$changenames/Change[@mtfname = $s][@parent = $msgname]">
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="$changenames/Change[@mtfname = $s][@parent = $msgname]/@newname"/>
                </xsl:when>
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
