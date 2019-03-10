<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2017 JD NEUSHUL
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sch="http://purl.oclc.org/dsdl/schematron" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="Outdir" select="'../../XSD/Rules/'"/>

    <xsl:variable name="messages_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/messages.xsd')"/>

    <xsl:variable name="msgmap_xsd" select="document('../../XSD/NCDF_MTF/Maps/NCDF_MTF_Msgsmaps.xml')"/>
    <xsl:variable name="setmap_xsd" select="document('../../XSD/NCDF_MTF/Maps/NCDF_MTF_Setmaps.xml')"/>
    <xsl:variable name="segmap_xsd" select="document('../../XSD/NCDF_MTF/Maps/NCDF_MTF_Segmntmaps.xml')"/>
    <xsl:variable name="compmap_xsd" select="document('../../XSD/NCDF_MTF/Maps/NCDF_MTF_Compositemaps.xml')"/>
    <xsl:variable name="fldmap_xsd" select="document('../../XSD/NCDF_MTF/Maps/NCDF_MTF_Fieldmaps.xml')"/>

    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="a" select='"&apos;"'/>
    <xsl:variable name="lb" select='"["'/>
    <xsl:variable name="rb" select='"]"'/>


    <xsl:variable name="changenames">
        <Changenames>
            <xsl:for-each select="$msgmap_xsd//Element">
                <xsl:variable name="m" select="@mtfname"/>
                <xsl:variable name="n" select="@ncdfelementname"/>
                <xsl:if test="string($m) != string($n)">
                    <Change mtfname="{$m}" newname="{$n}"/>
                </xsl:if>
            </xsl:for-each>
        </Changenames>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="{concat($Outdir,'NATO-MTF-Rules.xml')}">
            <MessageRules>
                <xsl:copy-of select="$rules" copy-namespaces="no"/>
            </MessageRules>
        </xsl:result-document>
    </xsl:template>

    <xsl:variable name="rules">
        <xsl:for-each select="$messages_xsd/xs:schema/xs:element[xs:annotation/xs:appinfo/MtfIdentifier]">
            <xsl:sort select="@name"/>
            <!--<Message name="{@name}">-->
            <xsl:apply-templates select="xs:annotation/xs:appinfo/*" mode="makerule"/>
            <!--</Message>-->
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="*:MtfStructuralRelationship" mode="makerule">
        <MtfStructuralRelationship msg="{ancestor::*[@name][1]/@name}">
            <xsl:variable name="Rules">
                <xsl:apply-templates select="*" mode="makerule"/>
            </xsl:variable>
            <xsl:variable name="Exp" select="*:MtfStructuralRelationshipExplanation"/>
            <xsl:choose>
                <xsl:when test="contains($Exp, 'IS ASSIGNED THE VALUE') and contains($Exp, 'EVERY OCCURRENCE')">
                    <xsl:apply-templates select="." mode="EveryOccurrenceIsAssigned"/>
                    <xsl:apply-templates select="*" mode="makerule"/>
                </xsl:when>
                <xsl:when test="contains($Exp, 'IS ASSIGNED THE VALUE')">
                    <xsl:apply-templates select="." mode="IsAssigned"/>
                    <xsl:apply-templates select="*" mode="makerule"/>
                </xsl:when>
                <xsl:when test="contains($Exp, 'IS REQUIRED IF') and contains($Exp, 'EVERY OCCURRENCE')">
                    <xsl:apply-templates select="." mode="EveryOccurrenceIsRequiredIf"/>
                    <xsl:apply-templates select="*" mode="makerule"/>
                </xsl:when>
                <xsl:when test="contains($Exp, 'IS REQUIRED IF') and contains($Exp, 'USES ALTERNATIVE FF')">
                    <xsl:apply-templates select="." mode="IsRequiredIfUsesAlternative"/>
                    <xsl:apply-templates select="*" mode="makerule"/>
                </xsl:when>
                <xsl:when test="contains($Exp, 'IS REQUIRED IF')">
                    <xsl:apply-templates select="." mode="IsRequiredIf"/>
                    <xsl:apply-templates select="*" mode="makerule"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*" mode="makerule"/>
                </xsl:otherwise>
            </xsl:choose>
        </MtfStructuralRelationship>
    </xsl:template>

    <xsl:template match="*" mode="IsRequiredIfUsesAlternative">
        <xsl:variable name="val0" select="replace(substring-after(*:MtfStructuralRelationshipExplanation, 'IS ASSIGNED THE VALUE '), $q, '')"/>
        <xsl:variable name="val" select="translate($val0, './', '')"/>
        <xsl:variable name="err" select="replace(*:MtfStructuralRelationshipExplanation, 'IS ASSIGNED', 'MUST BE ASSIGNED THE VALUE')"/>
        <xsl:variable name="newxp">
            <xsl:call-template name="convertXpath">
                <xsl:with-param name="xp" select="substring-before(substring-after(*:MtfStructuralRelationshipXsnRule, 'string('), ')')"/>
            </xsl:call-template>
        </xsl:variable>
        <SchRule xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:pattern>
                <sch:title>
                    <xsl:value-of select="*:MtfStructuralRelationshipExplanation"/>
                </sch:title>
                <sch:rule context="{$newxp}">
                    <sch:assert test="{concat($newxp,' = ', $a,$val,$a)}">
                        <xsl:value-of select="$err"/>
                    </sch:assert>
                </sch:rule>
            </sch:pattern>
        </SchRule>
    </xsl:template>

    <xsl:template match="*" mode="IsRequiredIf">
        <!-- <xsl:variable name="val0" select="substring-before(substring-after(*:MtfStructuralRelationshipExplanation, '/'),'/')"/>-->
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
        
        <xsl:variable name="context" select="substring-before(substring-after($existsxpath, '/'),'/')"/>
        
        <xsl:variable name="target" select="substring-before(substring-after($existsxpath, $context),'[')"/>

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

        <SchRule xmlns:sch="http://purl.oclc.org/dsdl/schematron">
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
        </SchRule>
    </xsl:template>

    <xsl:template match="*" mode="EveryOccurrenceIsRequiredIf">
        <xsl:variable name="val0" select="replace(substring-after(*:MtfStructuralRelationshipExplanation, 'IS ASSIGNED THE VALUE '), $q, '')"/>
        <xsl:variable name="val" select="translate($val0, './', '')"/>
        <xsl:variable name="err" select="replace(*:MtfStructuralRelationshipExplanation, 'IS ASSIGNED', 'MUST BE ASSIGNED THE VALUE')"/>
        <xsl:variable name="newxp">
            <xsl:call-template name="convertXpath">
                <xsl:with-param name="xp" select="substring-before(substring-after(*:MtfStructuralRelationshipXsnRule, 'string('), ')')"/>
            </xsl:call-template>
        </xsl:variable>
        <SchRule xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:pattern>
                <sch:title>
                    <xsl:value-of select="*:MtfStructuralRelationshipExplanation"/>
                </sch:title>
                <sch:rule context="{$newxp}">
                    <sch:assert test="{concat($newxp,' = ', $a,$val,$a)}">
                        <xsl:value-of select="$err"/>
                    </sch:assert>
                </sch:rule>
            </sch:pattern>
        </SchRule>
    </xsl:template>

    <xsl:template match="*" mode="IsAssigned">
        <xsl:variable name="val0" select="replace(substring-after(*:MtfStructuralRelationshipExplanation, 'IS ASSIGNED THE VALUE '), $q, '')"/>
        <xsl:variable name="val" select="translate($val0, './', '')"/>
        <xsl:variable name="err" select="replace(*:MtfStructuralRelationshipExplanation, 'IS ASSIGNED', 'MUST BE ASSIGNED THE VALUE')"/>
        <xsl:variable name="fullxpath">
            <xsl:call-template name="convertXpath">
                <xsl:with-param name="xp" select="substring-before(substring-after(*:MtfStructuralRelationshipXsnRule, 'string('), ')')"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="context" select="substring-before(substring-after($fullxpath, '/'), '/')"/>
        <xsl:variable name="targetxpath" select="substring-after($fullxpath, $context)"/>
        <SchRule xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:pattern>
                <sch:title>
                    <xsl:value-of select="*:MtfStructuralRelationshipExplanation"/>
                </sch:title>
                <sch:rule context="{$context}">
                    <sch:assert test="{concat($targetxpath,' = ', $a,$val,$a)}">
                        <xsl:value-of select="$err"/>
                    </sch:assert>
                </sch:rule>
            </sch:pattern>
        </SchRule>
    </xsl:template>

    <xsl:template match="*" mode="EveryOccurrenceIsAssigned">
        <xsl:variable name="val0" select="replace(substring-after(*:MtfStructuralRelationshipExplanation, 'IS ASSIGNED THE VALUE '), $q, '')"/>
        <xsl:variable name="val" select="translate($val0, './', '')"/>
        <xsl:variable name="err" select="replace(*:MtfStructuralRelationshipExplanation, 'IS ASSIGNED', 'MUST BE ASSIGNED THE VALUE')"/>
        <xsl:variable name="fullxpath">
            <xsl:call-template name="convertXpath">
                <xsl:with-param name="xp" select="substring-before(substring-after(*:MtfStructuralRelationshipXsnRule, 'string( '), ')')"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="valuexpath" select="substring-after($fullxpath, ']/')"/>
        <xsl:variable name="context" select="substring-before(substring-after($fullxpath, '//'), '/')"/>
        <xsl:variable name="occursxpath" select="substring-before(substring-after($fullxpath, $context), '[')"/>
        <SchRule xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:pattern>
                <sch:title>
                    <xsl:value-of select="*:MtfStructuralRelationshipExplanation"/>
                </sch:title>
                <sch:rule context="{$context}">
                    <sch:assert test="{concat('/',$occursxpath,'/',$valuexpath,' = ', $a,$val,$a)}">
                        <xsl:value-of select="$err"/>
                    </sch:assert>
                </sch:rule>
            </sch:pattern>
        </SchRule>
    </xsl:template>

    <xsl:template name="convertXpath">
        <xsl:param name="xp"/>
        <xsl:for-each select="tokenize($xp, '/')">
            <xsl:choose>
                <xsl:when test="$changenames/*/Change[@mtfname = .]">
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="$changenames/*/Change[@mtfname = .][1]/@newname"/>
                </xsl:when>
                <xsl:when test=". = ' '"/>
                <xsl:otherwise>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*:MtfStructuralRelationshipRule" mode="makerule">
        <Rule>
            <xsl:apply-templates select="text()" mode="makerule"/>
        </Rule>
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
        <!-- <XmlSnRule>
            <xsl:copy-of select="@number"/>
            <xsl:for-each select="*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </XmlSnRule>-->
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
