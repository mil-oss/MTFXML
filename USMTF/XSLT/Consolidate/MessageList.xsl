<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2015 JD NEUSHUL
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="Msgs" select="document('../../XSD/Baseline_Schema/msglist.xml')"/>
    <xsl:variable name="MsgPath" select="'../../XSD/Baseline_Schema/Messages/'"/>
    <xsl:variable name="MsgListPath" select="'../../XSD/Baseline_Schema/Consolidated/MessageList.xml'"/>


    <xsl:template name="main">
        <xsl:variable name="list">
            <MtfMsgs>
                <xsl:apply-templates select="$Msgs/Messages/Msg" mode="msglist"/>
            </MtfMsgs>
        </xsl:variable>
        <xsl:result-document href="{$MsgListPath}">
            <xsl:apply-templates select="$list/MtfMsgs" mode="details">
                <xsl:sort select="@name"/>
            </xsl:apply-templates>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="Msg" mode="msglist">
        <xsl:variable name="msgid" select="lower-case(@mtfid)"/>
        <xsl:variable name="pth" select="concat($MsgPath,$msgid,'/messages.xsd')"/>
        <xsl:if test="doc-available($pth)">
            <xsl:element name="Msg">
                <xsl:attribute name="name">
                    <xsl:value-of select="$msgid"/>
                </xsl:attribute>
                <xsl:attribute name="desc">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <xsl:attribute name="path">
                    <xsl:value-of select="concat($MsgPath,lower-case($msgid))"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="MtfMsgs" mode="details">
        <xsl:copy>
            <xsl:attribute name="count">
                <xsl:value-of select="count(Msg)"/>
            </xsl:attribute>
            <xsl:apply-templates select="Msg" mode="details">
                <xsl:sort select="@name"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="Msg" mode="details">
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>
