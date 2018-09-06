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
    <xsl:include href="NcdfMap.xsl"/>

    <!--Inputs-->
    <!--MTF XML Baseline Composites Schema-->
    <xsl:variable name="fields_xsd" select="document('../../XSD/APP-11C-ch1/Consolidated/fields.xsd')"/>
    <!--Outputs-->
    <xsl:variable name="fieldoutputdoc" select="'../../NCDF_MTF/NCDF_MTF_Fields.xsd'"/>
    <xsl:variable name="fieldmapoutputdoc" select="'../../NCDF_MTF/Maps/NCDF_MTF_Fieldmaps.xml'"/>
    <xsl:variable name="fieldsxsd">
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
        <!--<xsl:for-each select="$stringsxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:element/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>-->
        <xsl:for-each select="$numericsxsd/xsd:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$numericsxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <!--<xsl:for-each select="$numericsxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>-->
        <xsl:for-each select="$codelistxsd/xsd:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$codelistxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <!--<xsl:for-each select="$codelistxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>-->
        <xsl:for-each select="$all_field_elements_map/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:choose>
                <xsl:when test="@ncdftype">
                    <xsl:variable name="n" select="@ncdfelementname"/>
                    <xsl:variable name="t" select="@ncdftype"/>
                    <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                        <xsd:element name="{@ncdfelementname}">
                            <xsl:if test="@ncdftype">
                                <xsl:attribute name="type">
                                    <xsl:value-of select="@ncdftype"/>
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
                            <xsd:annotation>
                                <xsd:documentation>
                                    <xsl:value-of select="@ncdfelementdoc"/>
                                </xsd:documentation>
                                <xsd:appinfo>
                                    <xsl:for-each select="appinfo/*">
                                        <xsl:copy-of select="." copy-namespaces="no"/>
                                    </xsl:for-each>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="name() = 'Choice'">
                    <xsd:element name="{@substgrpname}">
                        <xsl:attribute name="abstract">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xsd:documentation>
                            <xsd:appinfo>
                                <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                    <xsl:for-each select="Element">
                                        <xsl:sort select="@ncdfelementname"/>
                                        <mtfappinfo:Element name="{@ncdfelementname}" type="{@ncdftype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_fields_xsd">
        <xsl:for-each select="$fieldsxsd/xsd:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:element/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_fields_map">
        <xsl:for-each select="$all_field_elements_map/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:if test="string-length(@ncdftype) &gt; 0 and name() = 'Field'">
                <xsl:variable name="n" select="@ncdfelementname"/>
                <xsl:variable name="t" select="@ncdftype"/>
                <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$all_field_elements_map/*">
            <xsl:sort select="@ncdfelementname"/>
            <xsl:if test="string-length(@ncdftype) &gt; 0 and name() = 'Element'">
                <xsl:variable name="n" select="@ncdfelementname"/>
                <xsl:variable name="t" select="@ncdftype"/>
                <xsl:if test="count(preceding-sibling::*[@ncdfelementname = $n][@ncdftype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--    OUTPUT RESULT-->
    <xsl:template name="main">
        <xsl:result-document href="{$fieldoutputdoc}">
            <xsl:copy-of select="$stringsxsd"/>
            <!--<xsd:schema xmlns="urn:mtf:mil:6040b:ncdf:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.ncdf.gov/ncdf/conformanceTargets/3.0/"
                xmlns:structures="http://release.ncdf.gov/ncdf/structures/4.0/" xmlns:term="http://release.ncdf.gov/ncdf/localTerminology/3.0/"
                xmlns:appinfo="http://release.ncdf.gov/ncdf/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:ncdf:mtf" ct:conformanceTargets="http://reference.ncdf.gov/ncdf/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/structures/4.0/" schemaLocation="../NCDF/structures.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/localTerminology/3.0/" schemaLocation="../NCDF/localTerminology.xsd"/>
                <xsd:import namespace="http://release.ncdf.gov/ncdf/appinfo/4.0/" schemaLocation="../NCDF/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NCDF/mtfappinfo.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Fields for MTF Messages</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:copy-of select="$mtf_fields_xsd" copy-namespaces="no"/>
            </xsd:schema>
        -->
        </xsl:result-document>
        <xsl:result-document href="{$fieldmapoutputdoc}">
            <Fields>
                <xsl:copy-of select="$mtf_fields_map"/>
            </Fields>
        </xsl:result-document>s
    </xsl:template>

    <xsl:template name="fld_nodes">
        <xsd:annotation>
            <xsd:documentation>
                <xsl:text>Fields for MTF Messages</xsl:text>
            </xsd:documentation>
        </xsd:annotation>
        <xsl:for-each select="$fieldsxsd/xsd:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:element/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>