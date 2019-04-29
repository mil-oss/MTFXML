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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ism="urn:us:gov:ic:ism" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:inf="urn:mtf:mil:6040b:appinfo"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- <xsl:include href="USMTF_Utility.xsl"/>-->

    <xsl:variable name="strings_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')/*:schema/*:simpleType[*:restriction[@base = 'xsd:string']/*:pattern]"/>

    <!--Test Output-->
    <xsl:variable name="xsdstroutputdoc" select="'../../XSD/Analysis/Normalized/Strings.xsd'"/>
    <xsl:variable name="stringsout" select="'../../XSD/Analysis/Maps/Strings.xml'"/>
    <xsl:variable name="sfld_changes" select="document('../../XSD/Refactor_Changes/FieldChanges.xml')/FieldChanges"/>

    <xsl:variable name="strings">
        <xsl:apply-templates select="$strings_xsd" mode="maptype">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="Version" select="'C.0.01.00'"/>
    <xsl:variable name="Date" select="'October 2018'"/>
    <xsl:variable name="Remark" select="'Created by ICP M2018-02.'"/>
    <xsl:variable name="DistStmnt" select="'DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.'"/>

    <xsl:variable name="stringsxsd">
        <xsl:for-each select="$strings/*">
            <xsl:sort select="@niemsimpletype"/>
            <xsl:variable name="DodDist">
                <xsl:choose>
                    <xsl:when test="info/*[1]/@doddist">
                        <xsl:value-of select="info/*[1]/@doddist"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>DoD-Dist-A</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xs:simpleType name="{@niemsimpletype}">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA" ism:noticeType="{info/*/@doddist}">
                        <xsl:value-of select="@niemtypedoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:for-each select="info/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xs:appinfo>
                </xs:annotation>
                <xs:restriction base="{@base}">
                    <xs:pattern value="{@niempattern}"/>
                    <xsl:if test="@length">
                        <xs:length value="{@length}"/>
                    </xsl:if>
                    <xsl:if test="@minLength">
                        <xs:minLength value="{@minLength}"/>
                    </xsl:if>
                    <xsl:if test="@maxLength">
                        <xs:maxLength value="{@maxLength}"/>
                    </xsl:if>
                </xs:restriction>
            </xs:simpleType>
            <xs:complexType name="{@niemtype}">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA" ism:noticeType="{info/*/@doddist}">
                        <xsl:value-of select="@niemtypedoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:for-each select="info/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xs:appinfo>
                </xs:annotation>
                <xs:simpleContent>
                    <xs:extension base="{@niemsimpletype}">
                        <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                    </xs:extension>
                </xs:simpleContent>
            </xs:complexType>
            <xs:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA" ism:noticeType="{$DodDist}">
                        <xsl:value-of select="@niemelementdoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:for-each select="info/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xs:appinfo>
                </xs:annotation>
            </xs:element>
        </xsl:for-each>
    </xsl:variable>

    <!--Remove min and max length qualifiers in RegEx for matching with normaized types-->
    <xsl:template name="patternValue">
        <xsl:param name="pattern"/>
        <!--TEST FOR MIN MAX IN REGEX-->
        <xsl:choose>
            <!--If Ends with max min strip off-->
            <xsl:when test="ends-with($pattern, '}')">
                <xsl:choose>
                    <xsl:when test="starts-with(substring($pattern, string-length($pattern) - 6), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 6)"/>
                    </xsl:when>
                    <xsl:when test="starts-with(substring($pattern, string-length($pattern) - 5), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 5)"/>
                    </xsl:when>
                    <xsl:when test="starts-with(substring($pattern, string-length($pattern) - 4), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 4)"/>
                    </xsl:when>
                    <xsl:when test="starts-with(substring($pattern, string-length($pattern) - 3), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 3)"/>
                    </xsl:when>
                    <xsl:when test="starts-with(substring($pattern, string-length($pattern) - 2), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 2)"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$pattern"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*:simpleType" mode="maptype">
        <xsl:param name="mtfsimpletype"/>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="change" select="$sfld_changes/String[@name = $mtfname]"/>
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="fromtype"/>
        </xsl:variable>
        <xsl:variable name="niemelementnamevar">
            <xsl:choose>
                <xsl:when test="$change/@niemelementname">
                    <xsl:value-of select="$change/@niemelementname"/>
                </xsl:when>
                <xsl:when test="$n = 'FreeTextSimple'">
                    <xsl:text>FreeText</xsl:text>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Text')">
                    <xsl:value-of select="$n"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($n, 'Text')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemtypename">
            <xsl:choose>
                <xsl:when test="$change/@niemtype">
                    <xsl:value-of select="$change/@niemtype"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Code')">
                    <xsl:value-of select="replace($n, 'Code', 'Text')"/>
                </xsl:when>
                <xsl:when test="starts-with($n, 'Gentext')">
                    <xsl:value-of select="$n"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Indicator')">
                    <xsl:value-of select="replace($n, 'Indicator', 'Text')"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Number')">
                    <xsl:value-of select="replace($n, 'Number', 'Text')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($n, 'Text')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="pattern" select="*:restriction/*:pattern/@value"/>
        <xsl:variable name="patternvalue">
            <!-- Remove length qualifiers-->
            <xsl:call-template name="patternValue">
                <xsl:with-param name="pattern">
                    <xsl:value-of select="$pattern"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="niempattern">
            <xsl:choose>
                <xsl:when test="ends-with($patternvalue, '}')">
                    <xsl:value-of select="$patternvalue"/>
                </xsl:when>
                <xsl:when test="ends-with($patternvalue, '*')">
                    <xsl:value-of select="$patternvalue"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($patternvalue, '+')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemsimpletype" select="concat($niemtypename, 'SimpleType')"/>
        <xsl:variable name="niemcomplextype" select="concat($niemtypename, 'Type')"/>
        <xsl:variable name="mtfdoc">
            <xsl:choose>
                <xsl:when test="$change/@niemtypedoc">
                    <xsl:value-of select="$change/@niemtypedoc"/>
                </xsl:when>
                <xsl:when test="*:annotation/*:documentation">
                    <xsl:apply-templates select="*:annotation/*:documentation"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemtypedocvar">
            <xsl:choose>
                <xsl:when test="$change/@niemtypedoc">
                    <xsl:value-of select="$change/@niemtypedoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mtfdoc"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemelementdoc">
            <xsl:choose>
                <xsl:when test="$change/@niemtypedoc">
                    <xsl:value-of select="replace($change/@niemtypedoc, 'A data type', 'A data item')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($mtfdoc, 'A data type', 'A data item')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="minlength">
            <xsl:value-of select="*:restriction/*:minLength/@value"/>
        </xsl:variable>
        <xsl:variable name="maxlength">
            <xsl:value-of select="*:restriction/*:maxLength/@value"/>
        </xsl:variable>
        <xsl:variable name="lengthvar">
            <xsl:value-of select="*:restriction/*:length/@value"/>
        </xsl:variable>
        <xsl:variable name="fappinfo">
            <xsl:apply-templates select="*:annotation/*:appinfo"/>
        </xsl:variable>
        <xsl:variable name="ffirn" select="xs:annotation/xs:appinfo/*:FieldFormatIndexReferenceNumber"/>
        <xsl:variable name="fud" select="xs:annotation/xs:appinfo/*:FudNumber"/>
        <xsl:variable name="DodDist">
            <xsl:choose>
                <xsl:when test="info/*[1]/@doddist">
                    <xsl:value-of select="info/*[1]/@doddist"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>DoD-Dist-A</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Field niemelementname="{$niemelementnamevar}" niemsimpletype="{$niemsimpletype}" niemtype="{$niemcomplextype}" base="xs:string" pattern="{$pattern}" niempattern="{$niempattern}"
            niemelementdoc="{$niemelementdoc}" niemtypedoc="{$niemtypedocvar}" mtftype="{@name}" mtfdoc="{$mtfdoc}">
            <xsl:if test="string-length($lengthvar) &gt; 0">
                <xsl:attribute name="length" select="$lengthvar"/>
            </xsl:if>
            <xsl:if test="string-length($minlength) &gt; 0">
                <xsl:attribute name="minLength" select="$minlength"/>
            </xsl:if>
            <xsl:if test="string-length($maxlength) &gt; 0">
                <xsl:attribute name="maxLength" select="$maxlength"/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@name = 'FreeTextBaseType'">
                    <xsl:attribute name="ffirn">
                        <xsl:text>6</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="fud">
                        <xsl:text>1</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="doddist">
                        <xsl:value-of select="$DodDist"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="ffirn" select="*:annotation/*:appinfo/*:FieldFormatIndexReferenceNumber"/>
                    <xsl:attribute name="fud" select="*:annotation/*:appinfo/*:FudNumber"/>
                </xsl:otherwise>
            </xsl:choose>
            <info>
                <inf:Field>
                    <xsl:for-each select="$fappinfo/*/*">
                        <xsl:for-each select="@*">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:attribute name="ffirn">
                        <xsl:value-of select="$ffirn"/>
                    </xsl:attribute>
                    <xsl:attribute name="fud">
                        <xsl:value-of select="$fud"/>
                    </xsl:attribute>
                    <xsl:attribute name="version">
                        <xsl:value-of select="$Version"/>
                    </xsl:attribute>
                    <xsl:attribute name="date">
                        <xsl:value-of select="$Date"/>
                    </xsl:attribute>
                    <xsl:attribute name="remark">
                        <xsl:value-of select="$Remark"/>
                    </xsl:attribute>
                    <xsl:attribute name="doddist">
                        <xsl:value-of select="$DodDist"/>
                    </xsl:attribute>
                    <!-- <xsl:attribute name="diststatement">
                            <xsl:value-of select="$DistStmnt"/>
                        </xsl:attribute>-->
                </inf:Field>
            </info>
        </Field>
    </xsl:template>
    <!-- _______________________________________________________ -->
    <!--    OUTPUT RESULT-->
    <xsl:template name="strings">
        <xsl:result-document href="{$xsdstroutputdoc}">
            <xs:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:inf="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf" ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xs:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="ext/niem/utility/structures/4.0/structures.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="./localTerminology.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="ext/niem/utility/appinfo/4.0/appinfo.xsd"/>
                <xs:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="./mtfappinfo.xsd"/>
                <xs:annotation>
                    <xs:documentation ism:classification="U" ism:ownerProducer="USA" ism:noticeType="DoD-Dist-A">
                        <xsl:text>Fields for MTF Messages</xsl:text>
                    </xs:documentation>
                </xs:annotation>
                <xsl:for-each select="$stringsxsd/*:simpleType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*:simpleType/@name = $n)">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$stringsxsd/*:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$stringsxsd/*:element">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*:element/@name = $n)">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xs:schema>
        </xsl:result-document>
        <xsl:result-document href="{$stringsout}">
            <Strings>
                <xsl:for-each select="$strings/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </Strings>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
