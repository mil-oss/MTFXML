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

    <xsl:variable name="maxdepth" select="30"/>

    <xsl:variable name="CixsData" select="document('../xsd/cixs-ref.xsd')/xs:schema"/>

    <xsl:variable name="UsmtfData" select="document('../../../../NIEM_MTF/refxsd/usmtf-ref.xsd')/xs:schema"/>

    <xsl:template name="main">
        <xsl:result-document href="./../instance/mtf-name-conflicts.xml">
            <MTF-CIXS-Naming-Conflicts xmlns:xs="http://www.w3.org/2001/XMLSchema">
                <xsl:apply-templates select="$CixsData/*" mode="checkname"/>
            </MTF-CIXS-Naming-Conflicts>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*" mode="checkname">
        <xsl:variable name="n" select="@name"/>
        <xsl:choose>
            <xsl:when test="exists($UsmtfData/*[@name = $n])">
                <Conflict name="{@name}" xmlnode="{name()}">
                    <CIXS name="{@name}" xmlnode="{name()}">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </CIXS>
                    <USMTF name="{@name}" xmlnode="{name()}">
                        <xsl:copy-of select="$UsmtfData/*[@name = $n]"  copy-namespaces="no"/>
                    </USMTF>
                </Conflict>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
