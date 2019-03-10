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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="strings_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/fields.xsd')/*:schema/*:simpleType[*:restriction[@base = 'xs:string']/*:pattern]"/>

    <!--Test Output-->
    <xsl:variable name="xsdstroutputdoc" select="'../../XSD/Analysis/Normalized/Strings.xsd'"/>
    <xsl:variable name="stringsout" select="'../../XSD/Test/MTF_XML_Maps/NCDF_Strings.xml'"/>
    <xsl:variable name="sfld_changes" select="document('../../XSD/Refactor_Changes/FieldChanges.xml')/FieldChanges"/>

    <xsl:variable name="strings">
        <xsl:apply-templates select="$strings_xsd" mode="maptype">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="stringsxsd">
        <xsl:for-each select="$strings/*">
            <xsl:sort select="@ncdfsimpletype"/>
            <xs:simpleType name="{@ncdfsimpletype}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@ncdftypedoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xs:appinfo>
                </xs:annotation>
                <xs:restriction base="{@base}">
                    <xs:pattern value="{@ncdfpattern}"/>
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
            <xs:complexType name="{@ncdftype}">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@ncdftypedoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xs:appinfo>
                </xs:annotation>
                <xs:simpleContent>
                    <xs:extension base="{@ncdfsimpletype}">
                        <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                    </xs:extension>
                </xs:simpleContent>
            </xs:complexType>
            <!--<xs:element name="{@ncdfelementname}" type="{@ncdftype}" nillable="true">
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="@ncdfelementdoc"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xs:appinfo>
                </xs:annotation>
            </xs:element>-->
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

    <xsl:template match="xs:simpleType" mode="maptype">
        <xsl:param name="mtfsimpletype"/>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="change" select="$sfld_changes/*[@name = $mtfname]"/>
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="fromtype"/>
        </xsl:variable>
        <xsl:variable name="ncdfelementnamevar">
            <xsl:choose>
                <xsl:when test="$change/@ncdfelementname">
                    <xsl:value-of select="$change/@ncdfelementname"/>
                </xsl:when>
                <xsl:when test="$n = 'FreeTextSimple'">
                    <xsl:text>FreeText</xsl:text>
                </xsl:when>
                <xsl:when test="$n = 'FreeText'">
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
        <xsl:variable name="ncdftypename">
            <xsl:choose>
                <xsl:when test="$change/@ncdfelementname">
                    <xsl:value-of select="$change/@ncdfelementname"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Code')">
                    <xsl:value-of select="replace($n, 'Code', 'Text')"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Code')">
                    <xsl:value-of select="replace($n, 'Code', 'Text')"/>
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
        <xsl:variable name="ncdfpattern">
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
        <xsl:variable name="ncdfsimpletype" select="concat($ncdftypename, 'SimpleType')"/>
        <xsl:variable name="ncdfcomplextype" select="concat($ncdftypename, 'Type')"/>
        <xsl:variable name="mtfdoc">
            <xsl:choose>
                <xsl:when test="*:annotation/*:documentation">
                    <xsl:apply-templates select="*:annotation/*:documentation"/>
                </xsl:when>
                <xsl:when test="$change/@ncdftypedoc">
                    <xsl:value-of select="$change/@ncdftypedoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*:annotation"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdftypedocvar">
            <xsl:choose>
                <xsl:when test="$change/@ncdftypedoc">
                    <xsl:value-of select="$change/@ncdftypedoc"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('A data type for ',lower-case($mtfdoc))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfelementdoc">
            <xsl:choose>
                <xsl:when test="$change/@ncdftypedoc">
                    <xsl:value-of select="replace($change/@ncdftypedoc, 'A data type', 'A data item')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace($ncdftypedocvar, 'A data type', 'A data item')"/>
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
        <xsl:variable name="appinfovar">
            <xsl:apply-templates select="*:annotation/*:appinfo"/>
        </xsl:variable>
        <Field ncdfelementname="{$ncdfelementnamevar}" ncdfsimpletype="{$ncdfsimpletype}" ncdftype="{$ncdfcomplextype}" base="xs:string" pattern="{$pattern}" ncdfpattern="{$ncdfpattern}"
            ncdfelementdoc="{$ncdfelementdoc}" ncdftypedoc="{$ncdftypedocvar}" mtftype="{@name}" mtfdoc="{$mtfdoc}">
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
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="ffirn" select="*:annotation/*:appinfo/*:FieldFormatIndexReferenceNumber"/>
                    <xsl:attribute name="fud" select="*:annotation/*:appinfo/*:FudNumber"/>
                </xsl:otherwise>
            </xsl:choose>
            <appinf>
                <xsl:for-each select="$appinfovar/*">
                    <xsl:copy-of select="./mtfappinfo:Field" copy-namespaces="no"/>
                </xsl:for-each>
            </appinf>
        </Field>
    </xsl:template>
    <!-- _______________________________________________________ -->

</xsl:stylesheet>
