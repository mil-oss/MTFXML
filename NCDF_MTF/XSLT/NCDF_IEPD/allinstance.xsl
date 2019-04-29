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
    <xsl:include href="xml-instance.xsl"/>

    <xsl:variable name="msglist" select="'../../XSD/NCDF_MTF/MsgList.xml'"/>

    <xsl:variable name="tgtdir" select="'../../XSD/IEPD/xml/instance/'"/>

    <xsl:template name="main">
        <xsl:for-each select="document($msglist)/*/Msg">
            <xsl:variable name="mid" select="translate(@id, ' .', '')"/>
            <xsl:result-document href="{$tgtdir}/{concat($mid,'-instance.xml')}">
                <xsl:apply-templates select="document(concat($iepsrc, $mid, '-iep.xsd'))/xs:schema/xs:element[1]" mode="root">
                    <xsl:with-param name="xsdv" select="concat('../xsd/', $mid, '-iep.xsd')"/>
                </xsl:apply-templates>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
