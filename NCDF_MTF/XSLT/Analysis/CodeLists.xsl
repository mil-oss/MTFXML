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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>


    <xsl:variable name="fields_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')"/>

    <xsl:variable name="enumerations_xsd" select="$fields_xsd/xsd:schema//xsd:simpleType[xsd:restriction[@base = 'xsd:string'][xsd:enumeration]]"/>

    <xsl:variable name="codelists">
        <xsl:for-each select="$enumerations_xsd">
            <xsl:sort select="@name"/>
            <CodeList name="{@name}">
                <Codes>
                    <xsl:for-each select="xsd:restriction/xsd:enumeration">
                        <xsl:sort select="@value"/>
                        <Code value="{@value}" dataItem="{xsd:annotation/xsd:appinfo/*:DataItem}" doc="{normalize-space(xsd:annotation/xsd:documentation/text())}"/>
                    </xsl:for-each>
                </Codes>
            </CodeList>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="normcodelists">
        <xsl:for-each select="$enumerations_xsd">
            <xsl:sort select="@name"/>
            <xsl:variable name="normcodes">
                <Codes>
                    <xsl:for-each select="xsd:restriction/xsd:enumeration">
                        <xsl:sort select="@value"/>
                        <Code value="{@value}" dataItem="{xsd:annotation/xsd:appinfo/*:DataItem}" doc="{normalize-space(xsd:annotation/xsd:documentation/text())}"/>
                    </xsl:for-each>
                </Codes>
            </xsl:variable>
            <CodeList name="{@name}">
                <xsl:copy-of select="$normcodes"/>
                <UsedBy>
                    <xsl:for-each select="$codelists/*">
                        <xsl:if test="deep-equal(Codes, $normcodes/Codes)">
                            <xsl:copy>
                                <xsl:copy-of select="@name"/>
                            </xsl:copy>
                        </xsl:if>
                    </xsl:for-each>
                </UsedBy>
            </CodeList>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="multipleuses">
        <xsl:for-each select="$normcodelists/*">
            <xsl:sort select="count(*:UsedBy/CodeList)"/>
            <xsl:if test="count(*:UsedBy/CodeList) &gt; 1">
                <xsl:copy>
                    <xsl:attribute name="count" select="count(*:UsedBy/CodeList)"/>
                    <xsl:copy-of select="@name"/>
                    <xsl:copy-of select="*:Codes"/>
                    <xsl:copy-of select="*:UsedBy"/>
                </xsl:copy>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="singlecodes">
        <xsl:for-each select="$normcodelists/*">
            <xsl:if test="count(*:UsedBy/CodeList)&gt;1 and count(*:Codes/Code) = 1">
                <xsl:copy>
                    <xsl:attribute name="count" select="count(*:UsedBy/CodeList)"/>
                    <xsl:copy-of select="@name"/>
                    <xsl:copy-of select="*:Codes"/>
                    <xsl:copy-of select="*:UsedBy"/>
                </xsl:copy>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="CLists">
        <CodeLists>
            <USMTF count="{count($enumerations_xsd)}">
                <!--<xsl:copy-of select="$codelists"/>-->
                <xsl:copy-of select="$normcodelists"/>
            </USMTF>
            <MultipleUses count="{count($multipleuses/*)}">
                <xsl:copy-of select="$multipleuses"/>
            </MultipleUses>
            <SingleCodes count="{count($singlecodes/*)}">
                <xsl:copy-of select="$singlecodes"/>
            </SingleCodes>
        </CodeLists>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="../../XSD/Analysis/CodeLists.xml">
            <xsl:copy-of select="$CLists"/>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
