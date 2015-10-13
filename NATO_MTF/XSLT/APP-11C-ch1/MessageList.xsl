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
    <xsl:variable name="MsgFile" select="document('../../XSD/APP-11C-ch1/Messages/fields.xsd')"/>
    <xsl:variable name="MsgList" select="$MsgFile//*[@name='MessageTextFormatIdentifierType']"/>
    <xsl:variable name="MsgPath" select="'../../XSD/APP-11C-ch1/Messages/'"/>
    <xsl:variable name="MsgListPath" select="'../../XSD/Normalized/MessageList.xml'"/>


    <xsl:template match="/">
        <xsl:variable name="list">
            <NatoMsgs>
                <xsl:apply-templates select="$MsgList/*//*:enumeration" mode="msglist"/>
            </NatoMsgs>
        </xsl:variable>
        <xsl:result-document href="{$MsgListPath}">
            <xsl:apply-templates select="$list/NatoMsgs" mode="details">
                <xsl:sort select="@name"/>
            </xsl:apply-templates>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*:enumeration" mode="msglist">
        <xsl:variable name="pth" select="concat($MsgPath,lower-case(@value),'/messages.xsd')"/>
        <xsl:if test="doc-available($pth)">
            <xsl:element name="Msg">
                <xsl:attribute name="name">
                    <xsl:value-of select="@value"/>
                </xsl:attribute>
                <xsl:attribute name="desc">
                    <xsl:value-of select="*//*:DataItem"/>
                </xsl:attribute>
                <xsl:attribute name="path">
                    <xsl:value-of select="concat($MsgPath,lower-case(@value))"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="NatoMsgs" mode="details">
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
