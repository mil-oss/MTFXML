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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="xmldoc" select="document('../../XSD/NIEM_MTF_1_NS/Refactor_Changes/CompositeChanges.xml')"/>
    
    <!--Output-->
    <xsl:variable name="sorted_out" select="'../../XSD/NIEM_MTF_1_NS/Refactor_Changes/CompositeChanges-Sort.xml'"/>

    <xsl:template name="main">
        <xsl:result-document href="{$sorted_out}">
            <CompositeTypeChanges>
                <xsl:for-each select="$xmldoc/*/*">
                    <xsl:sort select="@name"/>
                    <xsl:element name="Composite">
                        <xsl:apply-templates select="@*"/>
                    </xsl:element>
                </xsl:for-each>
            </CompositeTypeChanges>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="@count"/>
    
    <xsl:template match="@changedocto">
        <xsl:attribute name="doc" select="."/>
    </xsl:template>

</xsl:stylesheet>
