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
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">

    <xsl:variable name="msg" select="document('../XML/MTF_MESSAGES.xsd')"/>

    <xsl:template match="/">
        <xsl:result-document method="xml" href="../HTML/MSG/{.//@MtfIdentifier}.xsd">
        <html>
            <head>
                <title>USMTF MESSAGES</title>
                <link rel="stylesheet" href="css/schemaView.css"/>
            </head>
            <body>
                <table>
                    <tr class="ctr bld">
                        <td>Msg ID</td>
                        <td>Msg Name</td>
                        <td>Msg Decription</td>
                    </tr>
                <xsl:apply-templates select="$msg/xsd:schema/xsd:element"/>
                </table>
            </body>
        </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xsd:element">
        <xsl:variable name="nm">
            <xsl:value-of select="string(@name)"/>
        </xsl:variable>
        <xsl:variable name="typ">
            <xsl:value-of select="concat($nm,'Type')"/>
        </xsl:variable>
        <tr>
            <td>
                <a href="../HTML/MSG/{.//@MtfIdentifier}.xml" target="_blank"><xsl:value-of select=".//@MtfIdentifier"/></a>
            </td>
            <td>
                <xsl:value-of select=".//@MtfName"/>
            </td>
            <td>
                <xsl:value-of select=".//xsd:documentation"/>
            </td>
        </tr>
        <xsl:result-document method="xml" href="../HTML/MSG/{.//@MtfIdentifier}.xsd">
            <xsd:schema targetNamespace="urn:mtf:mil:6040b" xml:lang="en-US" xmlns="urn:mtf:mil:6040b"
                xmlns:s="urn:mtf:mil:6040b:set" xmlns:seg="urn:mtf:mil:6040b:segment"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ism="urn:us:gov:ic:ism:v2"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:ICISM="urn:us:gov:ic:ism:v2"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:mtf:mil:6040b:set" schemaLocation="../../XML/MTF_SETS.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:segment"
                    schemaLocation="../../XML/MTF_SEGMENTS.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2"
                    schemaLocation="../../References/Baseline_Schemas/IC-ISM-v2.xsd"/>
                <xsl:copy-of select="."/>
                <xsl:copy-of select="//xsd:schema/xsd:complexType[@name=$typ]"/>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
