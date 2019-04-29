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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:include href="xsd-json.xsl"/>

    <xsl:variable name="msglist" select="'../../XSD/NIEM_MTF/SepMsgs/msgmap.xml'"/>
    <xsl:variable name="refsrc" select="'../../XSD/NIEM_MTF/'"/>
    <xsl:variable name="iepsrc" select="'../../XSD/IEPD/xml/xsd/'"/>
    <xsl:variable name="tgtdir" select="'../../XSD/IEPD/json/'"/>

    <xsl:template name="main">
        <xsl:result-document href="{$tgtdir}/usmtf-refxsd.json">
            <xsl:value-of select="$lb"/>
            <xsl:apply-templates select="document(concat($refsrc, 'NIEM_MTF.xsd'))/xs:schema/*"/>
            <xsl:value-of select="$rb"/>
        </xsl:result-document>
        <xsl:result-document href="{$tgtdir}/usmtf-iepxsd.json">
            <xsl:value-of select="$lb"/>
            <xsl:apply-templates select="document(concat($iepsrc, 'ext/USMTF-iep.xsd'))/xs:schema/*"/>
            <xsl:value-of select="$rb"/>
        </xsl:result-document>
        <xsl:for-each select="document($msglist)/*/Message">
            <xsl:variable name="mid" select="translate(@mtfid, ' .', '')"/>
            <xsl:result-document href="{$tgtdir}/refxsdjson/{concat($mid,'-ref.json')}">
                <xsl:value-of select="$lb"/>
                <xsl:apply-templates select="document(concat($refsrc, 'SepMsgs/xsd/',$mid, '-Ref.xsd'))/xs:schema/*"/>
                <xsl:value-of select="$rb"/>
            </xsl:result-document>
            <xsl:result-document href="{$tgtdir}/iepxsdjson/{concat($mid,'-iep.json')}">
                <xsl:value-of select="$lb"/>
                <xsl:apply-templates select="document(concat($iepsrc, $mid, '-iep.xsd'))/xs:schema/*"/>
                <xsl:value-of select="$rb"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
