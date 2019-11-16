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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mtf="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs mtf" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="UsmtfData" select="document('../xsd/ext/usmtf/usmtf-ref.xsd')/xs:schema"/>
    <xsl:variable name="NatomtfData" select="document('../xsd/ext/natomtf/nato-ref.xsd')/xs:schema"/>


    <xsl:template name="main">
        <xsl:result-document href="./../instance/mtf-name-conflicts.xml">
            <US-NATO-MTF-Naming-Conflicts xmlns:xs="http://www.w3.org/2001/XMLSchema">
                <xsl:apply-templates select="$UsmtfData/*" mode="checkname"/>
            </US-NATO-MTF-Naming-Conflicts>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*" mode="checkname">
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="p" select="./xs:annotation/xs:appinfo/*/@positionName[1]"/>
        <xsl:choose>
            <xsl:when test="exists($NatomtfData/*[xs:annotation/xs:appinfo/*/@positionName = $p])">
                <Common name="{@name}" xmlnode="{name()}">
                    <USMTF name="{@name}" xmlnode="{name()}">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </USMTF>
                    <NATOMTF name="{@name}" xmlnode="{name()}">
                        <xsl:copy-of select="$NatomtfData/*[xs:annotation/xs:appinfo/*/@positionName = $p]" copy-namespaces="no"/>
                    </NATOMTF>
                </Common>
            </xsl:when>
           <xsl:when test="exists($NatomtfData/*[@name = $n])">
               <Common name="{@name}" xmlnode="{name()}">
                    <USMTF name="{@name}" xmlnode="{name()}">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </USMTF>
                    <NATOMTF name="{@name}" xmlnode="{name()}">
                        <xsl:copy-of select="$NatomtfData/*[@name = $n]" copy-namespaces="no"/>
                    </NATOMTF>
                </Common>
            </xsl:when>
           <!-- <xsl:otherwise>
                <AddNode name="{@name}" xmlnode="{name()}">
                    <NATOMTF name="{@name}" xmlnode="{name()}">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </NATOMTF>
                </AddNode>
            </xsl:otherwise>-->
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
