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
    
    <xsl:variable name="MsgList" select="document('../../XML/MessageList.xml')"/>
    <xsl:variable name="ConsolidatedMessagesPath" select="'../../XSD/APP-11C-ch1/Consolidated/messages.xsd'"/>

    <xsl:template match="/">
        <xsl:result-document method="xml" href="{$ConsolidatedMessagesPath}">
                <xsd:schema targetNamespace="urn:int:nato:mtf:app-11(c):change01:msgs" 
                    xml:lang="en-GB"
                    elementFormDefault="unqualified" 
                    attributeFormDefault="unqualified" 
                    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                    xmlns="urn:int:nato:mtf:app-11(c):change01:msgs" 
                    xmlns:s="urn:int:nato:mtf:app-11(c):change01:sets">
                    <xsd:import namespace="urn:int:nato:mtf:app-11(c):change01:sets" schemaLocation="sets.xsd" />
                <xsl:apply-templates select="$MsgList//Msg" mode="makemsgschema"/>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>


    <xsl:template match="Msg" mode="makemsgschema">
        <xsl:if test="doc-available(concat(@path,'/messages.xsd'))">
            <xsl:copy-of select="document(concat(@path,'/messages.xsd'))/xsd:schema/xsd:element"
                copy-namespaces="no"/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
