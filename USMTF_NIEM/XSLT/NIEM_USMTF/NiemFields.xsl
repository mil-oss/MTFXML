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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" version="2.0">
    <xsl:output method="xml"  indent="yes" xmlns="http://www.w3.org/2001/XMLSchema"/>
    <xsl:include href="NiemMap.xsl"/>

    <!--Inputs-->
    <!--MTF XML Baseline Composites Schema-->
    <xsl:variable name="fields_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')"/>
    <!--Outputs-->
    <xsl:variable name="fieldoutputdoc" select="concat($srcdir, 'NIEM_MTF/NIEM_MTF_Fields.xsd')"/>
    <xsl:variable name="fieldmapoutputdoc" select="concat($srcdir, 'NIEM_MTF/Maps/NIEM_MTF_Fieldmaps.xml')"/>
    <xsl:variable name="fieldsxsd">
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
        <!--<xsl:for-each select="$stringsxsd/*:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:element/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>-->
        <xsl:for-each select="$numericsxsd/*:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$numericsxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <!--<xsl:for-each select="$numericsxsd/*:element">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>-->
        <xsl:for-each select="$codelistxsd/*:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$codelistxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <!--<xsl:for-each select="$codelistxsd/*:element">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>-->
        <xsl:for-each select="$all_field_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:choose>
                <xsl:when test="@niemtype">
                    <xsl:variable name="n" select="@niemelementname"/>
                    <xsl:variable name="t" select="@niemtype"/>
                    <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                        <xs:element name="{@niemelementname}">
                            <xsl:if test="@niemtype">
                                <xsl:attribute name="type">
                                    <xsl:value-of select="@niemtype"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@substgrpname">
                                <xsl:attribute name="abstract">
                                    <xsl:text>true</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@substitutiongroup">
                                <xsl:attribute name="substitutionGroup">
                                    <xsl:value-of select="@substitutiongroup"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="not(@substgrpname)">
                                <xsl:attribute name="nillable">
                                    <xsl:text>true</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xs:annotation>
                                <xs:documentation>
                                    <xsl:value-of select="@niemelementdoc"/>
                                </xs:documentation>
                                <xs:appinfo>
                                    <xsl:for-each select="appinfo/*">
                                        <xsl:copy-of select="." copy-namespaces="no"/>
                                    </xsl:for-each>
                                </xs:appinfo>
                            </xs:annotation>
                        </xs:element>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="name() = 'Choice'">
                    <xs:element name="{@substgrpname}">
                        <xsl:attribute name="abstract">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xs:annotation>
                            <xs:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xs:documentation>
                            <xs:appinfo>
                                <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                    <xsl:for-each select="Element">
                                        <xsl:sort select="@niemelementname"/>
                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xs:appinfo>
                        </xs:annotation>
                    </xs:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_fields_xsd">
        <xsl:for-each select="$fieldsxsd/*:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/*:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:element/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_fields_map">
        <xsl:for-each select="$all_field_elements_map/*[string-length(@niemtype) &gt; 0 and name() = 'Field']">
            <xsl:sort select="@niemelementname"/>
                <xsl:variable name="n" select="@niemelementname"/>
                <xsl:variable name="t" select="@niemtype"/>
                <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$all_field_elements_map/*[string-length(@niemtype) &gt; 0 and name() = 'Element']">
            <xsl:sort select="@niemelementname"/>
                <xsl:variable name="n" select="@niemelementname"/>
                <xsl:variable name="t" select="@niemtype"/>
                <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--    OUTPUT RESULT-->
    <xsl:template name="main">
        <xsl:result-document href="{$fieldoutputdoc}">
            <xs:schema xmlns="urn:mtf:mil:6040b:niem:mtf"
                xmlns:ism="urn:us:gov:ic:ism"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
                xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/"
                xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument"
                xml:lang="en-US"
                elementFormDefault="unqualified"
                attributeFormDefault="unqualified"
                version="1.0">
                <xs:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/structures/4.0/"
                    schemaLocation="ext/niem/utility/structures/4.0/structures.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="./localTerminology.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="ext/niem/utility/appinfo/4.0/appinfo.xsd"/>
                <xs:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="./mtfappinfo.xsd"/>
                <xs:annotation>
                    <xs:documentation>
                        <xsl:text>Fields for MTF Messages</xsl:text>
                    </xs:documentation>
                </xs:annotation>
                <xsl:copy-of select="$mtf_fields_xsd" copy-namespaces="no"/>
            </xs:schema>
        </xsl:result-document>
        <xsl:result-document href="{$fieldmapoutputdoc}">
            <Fields>
                <!--<xsl:copy-of select="$mtf_fields_map"/>-->
                <xsl:copy-of select="$all_field_elements_map"/>
            </Fields>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="fld_nodes">
        <xs:annotation>
            <xs:documentation>
                <xsl:text>Fields for MTF Messages</xsl:text>
            </xs:documentation>
        </xs:annotation>
        <xsl:for-each select="$fieldsxsd/*:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/*:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/*:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::*:element/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
