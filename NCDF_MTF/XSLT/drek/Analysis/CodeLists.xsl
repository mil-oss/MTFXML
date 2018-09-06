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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
    xmlns:ism="urn:us:gov:ic:ism:v2" xmlns:appinfo="http://release.niem.gov/niem/appinfo/3.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
    exclude-result-prefixes="" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:include href="../NATO-MTFXML/NATOMTF_Utility.xsl"/>

    <xsl:variable name="fields_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/fields.xsd')"/>

    <xsl:variable name="enumerations_xsd" select="$fields_xsd/xsd:schema//xsd:simpleType[xsd:restriction[@base = 'xsd:string'][xsd:enumeration]]"/>

    <xsl:variable name="codelists">
        <xsl:for-each select="$enumerations_xsd">
            <xsl:sort select="@name"/>
            <xsl:variable name="annot">
                <xsl:apply-templates select="xsd:annotation"/>
            </xsl:variable>
            <CodeList name="{@name}">
                <xsl:copy-of select="$annot"/>
                <Codes>
                    <xsl:for-each select="xsd:restriction/xsd:enumeration">
                        <xsl:sort select="@value"/>
                        <xsl:variable name="codeannot">
                            <xsl:apply-templates select="xsd:annotation"/>
                        </xsl:variable>
                        <Code value="{@value}" dataItem="{xsd:annotation/xsd:appinfo/*:DataItem}">
                            <!--<xsl:copy-of select="$codeannot"/>-->
                            <xsl:attribute name="doc">
                                <xsl:value-of select="$codeannot/xsd:annotation/xsd:documentation"/>
                            </xsl:attribute>
                        </Code>
                    </xsl:for-each>
                </Codes>
            </CodeList>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="normcodelists">
        <xsl:for-each select="$codelists/*">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="normcodes">
                <xsl:copy-of select="Codes"/>
            </xsl:variable>
            <CodeList name="{@name}" count="{@count}">
                <xsl:attribute name="doc">
                    <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/>
                </xsl:attribute>
                <xsl:copy-of select="$normcodes"/>
                <UsedBy>
                    <xsl:for-each select="$codelists/*">
                        <xsl:if test="deep-equal(Codes, $normcodes/Codes)">
                            <xsl:copy>
                                <xsl:copy-of select="@name"/>
                                <xsl:attribute name="doc">
                                    <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/>
                                </xsl:attribute>
                                <xsl:attribute name="changeto">
                                    <xsl:value-of select="$n"/>
                                </xsl:attribute>
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
                    <xsl:copy-of select="@doc"/>
                    <xsl:attribute name="changeto">
                        <xsl:value-of select="@name"/>
                    </xsl:attribute>
                    <xsl:copy-of select="*:Codes"/>
                    <xsl:copy-of select="*:UsedBy"/>
                </xsl:copy>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="multipleuselist">
        <xsl:for-each select="$multipleuses//CodeList">
            <xsl:copy>
                <xsl:copy-of select="@changeto"/>
                <xsl:copy-of select="@name"/>
                <xsl:copy-of select="@doc"/>
                <xsl:if test="@name=@changeto">
                    <xsl:copy-of select="@count"/>
                    <xsl:copy-of select="Codes"/>
                </xsl:if>
            </xsl:copy>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="singlecodes">
        <xsl:for-each select="$normcodelists/*">
            <xsl:if test="count(*:UsedBy/CodeList) &gt; 1 and count(*:Codes/Code) = 1">
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
            <NATOMTF count="{count($enumerations_xsd)}">
                <!--<xsl:copy-of select="$codelists"/>-->
                <xsl:copy-of select="$normcodelists"/>
            </NATOMTF>
            <MultipleUses count="{count($multipleuses/*)}">
                <xsl:copy-of select="$multipleuses"/>
            </MultipleUses>
            <SingleCodes count="{count($singlecodes/*)}">
                <xsl:copy-of select="$singlecodes"/>
            </SingleCodes>
        </CodeLists>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="../../XSD/Analysis/Nato_CodeLists.xml">
            <xsl:copy-of select="$CLists"/>
        </xsl:result-document>
        <xsl:result-document href="../../XSD/Analysis/Nato_CodeList_Changes.xml">
            <CodeListChanges>
                <xsl:for-each select="$multipleuselist/*">
                    <xsl:sort select="@changeto"/>
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                        <xsl:if test="@count">
                        <xsl:copy-of select="."/>
                        </xsl:if>
                </xsl:for-each>
            </CodeListChanges>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
