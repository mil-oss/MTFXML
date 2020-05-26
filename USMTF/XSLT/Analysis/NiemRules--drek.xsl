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


    <xsl:variable name="messages_xsd" select="document('../../XSD/Baseline_Schema/messages.xsd')"/>

    <xsl:variable name="msgmap_xsd" select="document('../../XSD/NIEM_MTF/refxsd/maps/niem-mtf-msgsmaps.xml')"/>
    <xsl:variable name="setmap_xsd" select="document('../../XSD/NIEM_MTF/refxsd/maps/niem-mtf-setmaps.xml')"/>
    <xsl:variable name="segmap_xsd" select="document('../../XSD/NIEM_MTF/refxsd/maps/niem-mtf-segmntmaps.xml')"/>

    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="a" select='"&apos;"'/>
    <xsl:variable name="lb" select='"["'/>
    <xsl:variable name="rb" select='"]"'/>
    <xsl:variable name="cr">
        <xsl:text>&#10;</xsl:text>
    </xsl:variable>

    <xsl:variable name="changenames">
        <xsl:for-each select="$msgmap_xsd//Element">
            <xsl:variable name="m" select="@mtfname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsl:variable name="p" select="ancestor::Message/@mtfname"/>
            <xsl:if test="string($m) != string($n)">
                <Change mtfname="{$m}" parent="{$p}" newname="{$n}"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="rulexpaths">
        <Rules>
            <xsl:for-each select="$rules//Rule">
                <xsl:variable name="m" select="parent::*/@msg"/>
                <Rule msg="{$m}" txt="{@txt}">
                    <xsl:attribute name="xpath">
                        <xsl:choose>
                            <xsl:when test="@txt = '[4],AF3 R ([4],AF2 EQ /CHT/ | /DOC/)'">
                                <xsl:value-of
                                    select="concat('exists(ReferenceSet/CommunicationMessageTextFormatIdentifierText) and ReferenceSet/TypeCommunicationCode=', $a, 'CHT', $a, '|', $a, 'DOC', $a)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="makePath">
                                    <xsl:with-param name="root" select="$m"/>
                                    <xsl:with-param name="rstr" select="@txt"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </Rule>
            </xsl:for-each>
        </Rules>
    </xsl:variable>

    <xsl:template name="main">

        <xsl:result-document href="{concat($Outdir,'USMTF_Rules.xml')}">
            <MessageRules>
                <xsl:for-each select="$rules">
                    <xsl:sort select="Rule/@txt"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </MessageRules>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'ChangeNames.xml')}">
            <Changenames>
                <xsl:copy-of select="$changenames" copy-namespaces="no"/>
            </Changenames>
        </xsl:result-document>
        <xsl:result-document href="{concat($Outdir,'Rules.xml')}">
            <Rules>
                <xsl:for-each select="$rulexpaths/Rules/Rule[not(@txt = '[4],AF3 R ([4],AF2 EQ /CHT/ | /DOC/)')]">
                    <xsl:sort select="@txt"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </Rules>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="makePath">
        <xsl:param name="root"/>
        <xsl:param name="rstr"/>
        <!--<xsl:value-of select="concat($root, '/')"/>-->
        <xsl:choose>
            <xsl:when test="contains($rstr, ' A ')">
                <xsl:variable name="testpath" select="substring-before($rstr, ' A ')"/>
                <xsl:variable name="testreq" select="replace(substring-after($rstr, ' A '), '/', '')"/>
                <xsl:choose>
                    <xsl:when test="contains($rstr, ',')">
                        <xsl:call-template name="nodeNames">
                            <xsl:with-param name="root" select="$root"/>
                            <xsl:with-param name="nlist">
                                <xsl:for-each select="tokenize($testpath, ',')">
                                    <node txt="{string(.)}"/>
                                </xsl:for-each>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>/</xsl:text>
                        <xsl:call-template name="nodeName">
                            <xsl:with-param name="root" select="$root"/>
                            <xsl:with-param name="rulestr" select="$testpath"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="concat('=', $a, $testreq, $a)"/>
            </xsl:when>
            <xsl:when test="contains($rstr, ' P ')">
                <xsl:variable name="testpath" select="replace(normalize-space(substring-before($rstr, ' P ')),',Z','')"/>
                <xsl:variable name="testreq" select="normalize-space(substring-before(substring-after($rstr, ' P ('), ')'))"/>
                <xsl:variable name="t">
                    <xsl:choose>
                        <xsl:when test="contains($testpath, ',')">
                            <xsl:call-template name="nodeNames">
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="nlist">
                                    <xsl:for-each select="tokenize($testpath, ',')">
                                        <node txt="{string(.)}"/>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nodeName">
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="rulestr" select="$testpath"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="r">
                    <xsl:choose>
                        <xsl:when test="contains($testreq, ',')">
                            <xsl:call-template name="nodeNames">
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="nlist">
                                    <xsl:for-each select="tokenize($testreq, ',')">
                                        <xsl:choose>
                                            <xsl:when test="contains(.,'..')">
                                                <node txt="{substring-before(substring-after(.,'..'),']')}"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <node txt="{string(.)}"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nodeName">
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="rulestr" select="$testreq"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat('exists(', $t, ') and not(exists(', $r, ')')"/>
            </xsl:when>
            <xsl:when test="contains($rstr, ' RP ')">
                <xsl:variable name="testpath" select="substring-before($rstr, ' RP ')"/>
                <xsl:variable name="testreq" select="substring-before(substring-after($rstr, ' RP ('), ' ')"/>
                <xsl:variable name="t">
                    <xsl:choose>
                        <xsl:when test="contains($testpath, ',')">
                            <xsl:call-template name="nodeNames">
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="nlist">
                                    <xsl:for-each select="tokenize($testpath, ',')">
                                        <node txt="{string(.)}"/>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nodeName">
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="rulestr" select="$testpath"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="r">
                    <xsl:choose>
                        <xsl:when test="contains($testreq, ',')">
                            <xsl:call-template name="nodeNames">
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="nlist">
                                    <xsl:for-each select="tokenize($testreq, ',')">
                                        <node txt="{string(.)}"/>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nodeName">
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="rulestr" select="$testreq"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--<xsl:value-of select="concat('=', replace(substring-after($rstr, 'EQ'), '/', $a))"/>-->
                </xsl:variable>
                <xsl:value-of select="concat('exists(', $t, ') and ', $r, ' or not(exists(', $t, ')')"/>
            </xsl:when>
            <xsl:when test="contains($rstr, ' R ')">
                <xsl:variable name="testpath" select="normalize-space(substring-before($rstr, ' R '))"/>
                <xsl:variable name="testreq" select="normalize-space(substring-before(substring-after($rstr, ' R ('), ')'))"/>
                <xsl:variable name="t">
                    <xsl:choose>
                        <xsl:when test="contains($testpath, ',')">
                            <xsl:call-template name="nodeNames">
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="nlist">
                                    <xsl:for-each select="tokenize($testpath, ',')">
                                        <node txt="{string(.)}"/>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nodeName">
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="rulestr" select="$testpath"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="r">
                    <xsl:choose>
                        <xsl:when test="contains($testreq, ',')">
                            <xsl:call-template name="nodeNames">
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="nlist">
                                    <xsl:for-each select="tokenize(substring-before($testreq, 'EQ'), ',')">
                                        <node txt="{string(.)}"/>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nodeName">
                                <xsl:with-param name="root" select="$root"/>
                                <xsl:with-param name="rulestr" select="substring-before($testreq, 'EQ')"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="concat('=', replace(substring-after($testreq, 'EQ'), '/', $a))"/>
                </xsl:variable>
                <xsl:value-of select="concat('exists(', $t, ') and ', $r, ' or not(exists(', $t, ')')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="nodeNames">
        <xsl:param name="root"/>
        <xsl:param name="nlist"/>
        <xsl:variable name="n">
            <xsl:call-template name="nodeName">
                <xsl:with-param name="root" select="$root"/>
                <xsl:with-param name="rulestr" select="$nlist/*[1]/@txt"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$n"/>
        <xsl:text>/</xsl:text>
        <xsl:if test="$nlist/*[2]/@txt">
            <xsl:call-template name="nodeNames">
                <xsl:with-param name="root">
                    <xsl:value-of select="$n"/>
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
        <xsl:param name="root"/>
        <xsl:param name="rulestr"/>
        <xsl:variable name="nmbr" select="translate($rulestr, 'ABCDEZ[] ()!@', '')"/>
        <xsl:choose>
            <xsl:when test="contains($nmbr, 'S')">
                <xsl:value-of select="$msgmap_xsd/*/Message[@mtfname = $root]/*/Element[info/*/@initialPosition = substring-before($nmbr, 'S')]/@niemelementname"/>
                <xsl:value-of select="$segmap_xsd/*/Segment[@niemelementname = $root]/*/Element[info/*/@initialPosition = substring-before($nmbr, 'S')]/@niemelementname"/>
            </xsl:when>
            <xsl:when test="contains($nmbr, 'FG')">
                <xsl:value-of select="$msgmap_xsd/*/Message[@mtfname = $root]/*//Element[@setseq = substring-before($nmbr, 'FG')]/@niemelementname"/>
                <xsl:value-of select="$segmap_xsd/*/Segment[@niemelementname = $root]/*//Element[@setseq = substring-before($nmbr, 'FG')]/@niemelementname"/>
            </xsl:when>
            <xsl:when test="contains($rulestr, ']F')">
                <xsl:variable name="setno" select="substring-before($nmbr, 'F')"/>
                <xsl:variable name="fldno" select="substring-after($nmbr, 'F')"/>
                <xsl:variable name="n">
                    <xsl:value-of select="$msgmap_xsd/*/Message[@mtfname = $root]/*/Element[@setseq = $setno]/@niemelementname[1]"/>
                    <xsl:value-of select="$segmap_xsd/*/Segment[@niemelementname = $root]/*//Element[@setseq = $setno]/@niemelementname[1]"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$n != ''">
                        <xsl:value-of select="$n"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('*[', $setno, ']')"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>/</xsl:text>
                <xsl:choose>
                    <xsl:when test="ends-with($n, 'HeadingInformation')">
                        <xsl:value-of select="'HeadingInformationText'"/>
                    </xsl:when>
                    <xsl:when test="ends-with($n, 'GeneralText')">
                        <xsl:value-of select="concat($n, 'SubjectText')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="f" select="$setmap_xsd/*/*[@niemelementname = $n]/*//Element[@seq = $fldno]"/>
                        <xsl:choose>
                            <xsl:when test="$f/Choice">
                                <xsl:text>[</xsl:text>
                                <xsl:for-each select="$f/Choice/Element">
                                    <xsl:value-of select="@niemelementname"/>
                                    <xsl:if test="following-sibling::Element">
                                        <xsl:text> | </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:text>]</xsl:text>
                            </xsl:when>
                            <xsl:when test="$f/@niemelementname">
                                <xsl:value-of select="$f/@niemelementname"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('*[', $fldno, ']')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:when>
            <xsl:when test="contains($nmbr, 'F')">
                <xsl:variable name="f" select="$setmap_xsd/*/Set[@niemelementname = $root]/*//Element[@seq = substring-after($nmbr, 'F')]"/>
                <xsl:choose>
                    <xsl:when test="$f/Choice">
                        <xsl:text>[</xsl:text>
                        <xsl:for-each select="$f/Choice/Element">
                            <xsl:value-of select="@niemelementname"/>
                            <xsl:if test="following-sibling::Element">
                                <xsl:text> | </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:text>]</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$f/@niemelementname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$segmap_xsd/*/Segment[@niemelementname = $root]/*//Element[@setseq = $nmbr]/@niemelementname">
                <xsl:value-of select="$segmap_xsd/*/Segment[@niemelementname = $root]/*//Element[@setseq = $nmbr]/@niemelementname"/>
            </xsl:when>
            <xsl:when test="$setmap_xsd/*/Set[@niemelementname = $root]/*//Element[@seq = $nmbr]/@niemelementname">
                <xsl:value-of select="$setmap_xsd/*/Set[@niemelementname = $root]/*//Element[@seq = $nmbr]/@niemelementname"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$nmbr"/>
                <xsl:value-of select="$rulestr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:variable name="rules">
        <xsl:for-each select="$messages_xsd//xsd:element[xsd:annotation/xsd:appinfo/*:MtfIdentifier]">
            <!--<Message name="{@name}">-->
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*" mode="makerule"/>
            <!--</Message>-->
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="*:MtfStructuralRelationship" mode="makerule">
        <xsl:variable name="msgname" select="ancestor::*[@name][1]/@name" exclude-result-prefixes="#all"/>
        <MtfStructuralRelationship msg="{$msgname}">
            <xsl:apply-templates select="*" mode="makerule"/>
        </MtfStructuralRelationship>
    </xsl:template>
    <xsl:template match="*" mode="IsAssigned">
        <xsl:param name="msgname"/>
        <xsl:variable name="Exp" select="*:MtfStructuralRelationshipExplanation"/>
        <xsl:variable name="Xsn" select="normalize-space(*:MtfStructuralRelationshipXsnRule)"/>
        <xsl:variable name="val0" select="replace(substring-after($Exp, 'is assigned the value '), $q, '')"/>
        <xsl:variable name="val" select="translate($val0, './', '')"/>
        <xsl:variable name="err" select="replace($Exp, 'is assigned', 'MUST BE ASSIGNED the value')"/>
        <xsl:variable name="fullxpath">
            <xsl:call-template name="convertXpath">
                <xsl:with-param name="xp" select="replace(normalize-space(substring-before(substring-after($Xsn, 'string('), ')')), '/\*:', '/')"/>
                <xsl:with-param name="msgname" select="$msgname"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="context" select="substring-before(substring-after($fullxpath, '//'), '/')"/>
        <xsl:variable name="targetxpath" select="substring-after($fullxpath, $context)"/>
        <SchematronRule xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:pattern>
                <sch:title>
                    <xsl:value-of select="$Exp"/>
                </sch:title>
                <sch:rule context="{$context}">
                    <sch:assert test="{concat($targetxpath,' = ', $a,$val,$a)}">
                        <xsl:value-of select="$err"/>
                    </sch:assert>
                </sch:rule>
            </sch:pattern>
        </SchematronRule>
    </xsl:template>

    <xsl:template match="*" mode="EveryOccurrenceRequiredIfLexEq">
        <xsl:param name="msgname"/>
        <xsl:param name="rule"/>
        <xsl:variable name="Exp" select="*:MtfStructuralRelationshipExplanation"/>
        <xsl:variable name="val0" select="replace(substring-after($Exp, 'lexicographically equals '), $q, $a)"/>
        <xsl:variable name="val" select="normalize-space(replace($val0, '.', ''))"/>
        <xsl:variable name="err" select="replace($Exp, 'is required if', 'IS REQUIRED IF ')"/>
        <xsl:variable name="set" select="substring-before(substring-after($Exp, 'Set '), ')')"/>
        <xsl:variable name="setnode" select="$msgmap_xsd//Message[@mtfname = $msgname]/Sequence/Element[$set]"/>
        <SchematronRule xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:pattern>
                <sch:title>
                    <xsl:value-of select="$Exp"/>
                </sch:title>
                <sch:rule context="{$msgname}">
                    <!-- <sch:assert test="{concat($newxp,' = ', $a,$val,$a)}">
                        <xsl:value-of select="$err"/>
                    </sch:assert>-->
                </sch:rule>
            </sch:pattern>
        </SchematronRule>
    </xsl:template>

    <xsl:template match="*:MtfStructuralRelationshipRule" mode="parseRule">
        <xsl:param name="msgname"/>
        <xsl:param name="Exp"/>
        <xsl:variable name="r" select="text()"/>
        <xsl:variable name="set" select="substring-after(substring-before($r, ']'), '[')"/>
        <xsl:variable name="field1" select="substring-before(substring-after($r, 'F'), ' ')"/>
        <xsl:variable name="setnode" select="$msgmap_xsd//Message[@mtfname = $msgname]/Sequence/Element[$set]"/>
        <xsl:variable name="fieldnode" select="$setmap_xsd//Set[@mtfname = $setnode/@mtfname]/Sequence/Element[$field1]"/>
        <xsl:variable name="assigned" select="substring-before(substring-after($r, 'F'), ' ')"/>
        <SchematronRule xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:pattern>
                <sch:title>
                    <xsl:value-of select="$Exp"/>
                </sch:title>
                <sch:rule context="{$msgname}">
                    <!--sch:assert test="{concat($targetxpath,' = ', $a,$val,$a)}">
                        <xsl:value-of select="$err"/>
                    </sch:assert>-->
                </sch:rule>
            </sch:pattern>
        </SchematronRule>
    </xsl:template>

    <xsl:template match="*" mode="IsRequiredIfUsesAlternative">
        <xsl:variable name="Exp" select="*:MtfStructuralRelationshipExplanation"/>
        <xsl:variable name="val0" select="replace(substring-after($Exp, 'is assigned the value '), $q, '')"/>
        <xsl:variable name="val" select="translate($val0, './', '')"/>
        <xsl:variable name="err" select="replace($Exp, 'is assigned', 'MUST BE ASSIGNED THE VALUE')"/>
        <xsl:variable name="newxp">
            <xsl:call-template name="convertXpath">
                <xsl:with-param name="xp" select="substring-before(substring-after($Exp, 'string('), ')')"/>
            </xsl:call-template>
        </xsl:variable>
        <SchematronRule xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:pattern>
                <sch:title>
                    <xsl:value-of select="$Exp"/>
                </sch:title>
                <sch:rule context="{$newxp}">
                    <sch:assert test="{concat($newxp,' = ', $a, substring-after($Exp, 'is assigned the value '),$a)}">
                        <xsl:value-of select="$err"/>
                    </sch:assert>
                </sch:rule>
            </sch:pattern>
        </SchematronRule>
    </xsl:template>

    <xsl:template match="*" mode="IsRequiredIf">
        <xsl:variable name="Exp" select="*:MtfStructuralRelationshipExplanation"/>
        <xsl:variable name="val">
            <xsl:choose>
                <xsl:when test="contains(*:MtfStructuralRelationshipExplanation, ', OTHERWISE IT IS PROHIBITED')">
                    <xsl:value-of select="translate(substring-before(substring-after(*:MtfStructuralRelationshipExplanation, 'EQUALS '), ','), './', '')"/>
                </xsl:when>
                <xsl:when test="contains(*:MtfStructuralRelationshipExplanation, ' OR ')">
                    <xsl:value-of select="translate(substring-before(substring-after(*:MtfStructuralRelationshipExplanation, 'EQUALS '), '.'), './', '')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(substring-before(substring-after(*:MtfStructuralRelationshipExplanation, 'EQUALS '), '.'), './', '')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="err" select="*:MtfStructuralRelationshipExplanation"/>
        <xsl:variable name="existsxpath">
            <xsl:call-template name="convertXpath">
                <xsl:with-param name="xp" select="substring-before(substring-after(*:MtfStructuralRelationshipXsnRule, 'exists('), ')')"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="context" select="substring-before(substring-after($existsxpath, '/'), '/')"/>
        <xsl:variable name="target" select="substring-before(substring-after($existsxpath, $context), '[')"/>
        <xsl:variable name="reqnode" select="substring-before(substring-after(*:MtfStructuralRelationshipXsnRule, '$A]/'), ')')"/>
        <xsl:variable name="valtests">
            <xsl:choose>
                <xsl:when test="contains($val, 'OR')">
                    <xsl:for-each select="tokenize($val, ' OR ')">
                        <xsl:text> or </xsl:text>
                        <xsl:value-of select="concat($target, '/', $reqnode, ' = ', $a, ., $a)"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> or </xsl:text>
                    <xsl:value-of select="concat($target, '/', $existsxpath, ' = ', $a, $val, $a)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <SchematronRule xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:pattern>
                <sch:title>
                    <xsl:value-of select="*:MtfStructuralRelationshipExplanation"/>
                </sch:title>
                <sch:rule context="{$context}">
                    <sch:assert test="{concat('exists(', $target, ')',' and ',substring-after($valtests,' or '))}">
                        <xsl:value-of select="$err"/>
                    </sch:assert>
                </sch:rule>
            </sch:pattern>
        </SchematronRule>
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
</xsl:stylesheet>
