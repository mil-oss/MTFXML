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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!--<xsl:include href="../USMTF_NIEM/USMTF_Utility.xsl"/>-->

    <xsl:variable name="strings_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern]"/>
    <xsl:variable name="string_changes" select="document('../../XSD/Refactor_Changes/StringChanges.xml')"/>

    <!--Output-->
    <xsl:variable name="xsdstroutputdoc" select="'../../XSD/Normalized/Strings.xsd'"/>
    <xsl:variable name="stringsout" select="'../../XSD/Test/MTF_XML_Maps/NIEM_Strings.xml'"/>

    <xsl:variable name="strings">
        <xsl:apply-templates select="$strings_xsd" mode="maptype">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="stringsxsd">
        <xsl:for-each select="$strings/String">
            <xsl:sort select="@niemsimpletype"/>
            <xsd:simpleType name="{@niemsimpletype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                </xsd:annotation>
                <xsd:restriction base="{@base}">
                    <xsd:pattern value="{@niempattern}"/>
                    <xsl:if test="@length">
                        <xsd:length value="{@length}"/>
                    </xsl:if>
                    <xsl:if test="@minLength">
                        <xsd:minLength value="{@minLength}"/>
                    </xsl:if>
                    <xsl:if test="@maxLength">
                        <xsd:maxLength value="{@maxLength}"/>
                    </xsl:if>
                </xsd:restriction>
            </xsd:simpleType>
            <xsd:complexType name="{@niemcomplextype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                </xsd:annotation>
                <xsd:simpleContent>
                    <xsd:extension base="{@niemsimpletype}">
                        <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                    </xsd:extension>
                </xsd:simpleContent>
            </xsd:complexType>
            <xsd:element name="{@niemelementname}" type="{@niemcomplextype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemelementdoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                </xsd:annotation>
            </xsd:element>
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

    <xsl:template match="xsd:simpleType" mode="maptype">
        <xsl:param name="mtfsimpletype"/>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="change" select="$string_changes/StringTypeChanges/String[@name = $mtfname]"/>
        <xsl:variable name="n">
            <xsl:apply-templates select="@name" mode="fromtype"/>
        </xsl:variable>
        <xsl:variable name="niemelementnamevar">
            <xsl:choose>
                <xsl:when test="$change/@niemelementname">
                    <xsl:value-of select="$change/@niemelementname"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Code')">
                    <xsl:value-of select="replace($n, 'Code', 'Text')"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Indicator')">
                    <xsl:value-of select="replace($n, 'Indicator', 'Text')"/>
                </xsl:when>
                <xsl:when test="ends-with($n, 'Number')">
                    <xsl:value-of select="replace($n, 'Number', 'Numeric')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($n, 'Text')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="pattern" select="xsd:restriction/xsd:pattern/@value"/>
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
        <xsl:variable name="niemsimpletype" select="concat($niemelementnamevar, 'SimpleType')"/>
        <xsl:variable name="niemcomplextype">
            <xsl:value-of select="concat($niemelementnamevar, 'Type')"/>
        </xsl:variable>
        <xsl:variable name="mtfdoc">
            <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
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
            <xsl:value-of select="xsd:restriction/xsd:minLength/@value"/>
        </xsl:variable>
        <xsl:variable name="maxlength">
            <xsl:value-of select="xsd:restriction/xsd:maxLength/@value"/>
        </xsl:variable>
        <xsl:variable name="lengthvar">
            <xsl:value-of select="xsd:restriction/xsd:length/@value"/>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo"/>
        </xsl:variable>
        <String mtfname="{@name}" niemsimpletype="{$niemsimpletype}" niemcomplextype="{$niemcomplextype}" niemelementname="{$niemelementnamevar}" base="xsd:string" pattern="{$pattern}"
            niempattern="{$niempattern}" niemelementdoc="{$niemelementdoc}" mtfdoc="{$mtfdoc}" niemtypedoc="{$niemtypedocvar}">
            <xsl:if test="string-length($lengthvar) &gt; 0">
                <xsl:attribute name="length" select="$lengthvar"/>
            </xsl:if>
            <xsl:if test="string-length($minlength) &gt; 0">
                <xsl:attribute name="minLength" select="$minlength"/>
            </xsl:if>
            <xsl:if test="string-length($maxlength) &gt; 0">
                <xsl:attribute name="maxLength" select="$maxlength"/>
            </xsl:if>
            <xsl:attribute name="ffirn" select="xsd:annotation/xsd:appinfo/*:FieldFormatIndexReferenceNumber"/>
            <xsl:attribute name="fud" select="xsd:annotation/xsd:appinfo/*:FudNumber"/>
            <appinfo>
            <xsl:for-each select="$appinfovar/*">
               <xsl:copy-of select="./mtfappinfo:Field" copy-namespaces="no"/>
            </xsl:for-each>
            </appinfo>
        </String>
    </xsl:template>
    <!-- _______________________________________________________ -->
    <!--    OUTPUT RESULT-->
    <!--<xsl:template name="main">
        <xsl:result-document href="{$xsdoutputdoc}">
            <xsl:call-template name="NIEMReferenceSchema">
                <xsl:with-param name="schemadoc">
                    <xsl:text>String fields for MTF Messages</xsl:text>
                </xsl:with-param>
                <xsl:with-param name="content">
                    <xsl:for-each select="$stringsxsd/xsd:simpleType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="not(preceding-sibling::xsd:simpleType/@name = $n)">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$stringsxsd/xsd:complexType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$stringsxsd/xsd:element">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="not(preceding-sibling::xsd:element/@name = $n)">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:result-document>
        <xsl:result-document href="{$stringsout}">
            <Strings>
                <xsl:for-each select="$strings">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </Strings>
        </xsl:result-document>
    </xsl:template>-->
</xsl:stylesheet>
