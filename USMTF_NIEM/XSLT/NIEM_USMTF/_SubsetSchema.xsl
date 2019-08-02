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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="allmtf" select="document('../../XSD/NIEM_MTF/refxsd/usmtf-ref.xsd')/*:schema"/>
    <xsl:variable name="outDir" select="'../../XSD/NIEM_MTF/subsetxsd/'"/>

    <!--<xsl:variable name="allnodes" select="document('../../XSD/NIEM_MTF/Maps/NIEM_MTF_AllMaps.xsd')/*"/>-->

    <xsl:variable name="allnodes">
        <xsl:apply-templates select="$allmtf/*" mode="map"/>
    </xsl:variable>

    <xsl:variable name="messagenodes">
        <xsl:apply-templates select="$allnodes/*[@name][@name][@type][@mtfid]" mode="msglist"/>
    </xsl:variable>

    <xsl:template match="*" mode="msglist">
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:variable name="m" select="@mtfid"/>
        <xsl:variable name="mnodes">
            <xsl:apply-templates select="$allnodes/*[@name = $n]/*" mode="list">
                <xsl:with-param name="nlist">
                    <node/>
                </xsl:with-param>
            </xsl:apply-templates>
            <xsl:apply-templates select="$allnodes/*[@name = $t]/*" mode="list">
                <xsl:with-param name="nlist">
                    <node/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="nlist">
            <xsl:copy>
                <xsl:copy-of select="@name"/>
                <xsl:copy-of select="@mtfid"/>
                <xsl:copy-of select="@type"/>
            </xsl:copy>
            <xsl:copy-of select="$allnodes/*[@name = $t][1]"/>
            <xsl:for-each select="distinct-values($mnodes/*/@name)">
                <xsl:variable name="n" select="."/>
                <xsl:copy-of select="$allnodes/*[@name = $n][1]"/>
            </xsl:for-each>
            <xsl:if test="@mtfid = 'ATO' or @mtfid = 'AIRSUPREQ'">
                <xsl:copy-of select="$allnodes/*[@name = 'EmitterTypeAbstract']"/>
            </xsl:if>
        </xsl:variable>
        <Message mtfid="{@mtfid}">
            <xsl:copy-of select="$nlist/element[@mtfid = $m]"/>
            <xsl:copy-of select="$nlist/complexType[@name = $t]"/>
            <xsl:for-each select="$nlist/simpleType">
                <xsl:sort select="@name"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="$nlist/complexType[not(@name = $t)]">
                <xsl:sort select="@name"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="$nlist/element[not(@name = $n)]">
                <xsl:sort select="@name"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </Message>
    </xsl:template>

    <xsl:template match="*" mode="list">
        <xsl:param name="nlist"/>
        <xsl:variable name="n" select="@ref | @name"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:variable name="s" select="@substitutionGroup"/>
        <xsl:if test="@type">
            <!--<node name="{$t}" type="{name()}"/>-->
            <xsl:element name="{replace(name(),'xs:','')}">
                <xsl:attribute name="name">
                    <xsl:value-of select="$t"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:element name="{replace(name(),'xs:','')}">
            <xsl:attribute name="name">
                <xsl:value-of select="$n"/>
            </xsl:attribute>
            <xsl:copy-of select="@type"/>
        </xsl:element>
        <xsl:if test="not($nlist/*[@name = $n])">
            <xsl:apply-templates select="$allnodes/*[@name = $n]/*" mode="list">
                <xsl:with-param name="nlist">
                    <xsl:copy-of select="$nlist"/>
                    <node name="{$n}"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="not($nlist/*[@name = $t])">
            <xsl:apply-templates select="$allnodes/*[@name = $t]/*" mode="list">
                <xsl:with-param name="nlist">
                    <xsl:copy-of select="$nlist"/>
                    <node name="{$t}"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <xsl:variable name="ref-xsd-template">
        <xs:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/" xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
            xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/" xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:inf="urn:mtf:mil:6040b:appinfo"
            xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:ism="urn:us:gov:ic:ism" xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:mtf:mil:6040b:niem:mtf"
            ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="qualified"
            attributeFormDefault="qualified" version="1.0">
            <xs:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../ext/niem/utility/structures/4.0/structures.xsd"/>
            <xs:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../ext/niem/localTerminology.xsd"/>
            <xs:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../ext/niem/utility/appinfo/4.0/appinfo.xsd"/>
            <xs:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../ext/niem/mtfappinfo.xsd"/>
        </xs:schema>
    </xsl:variable>

    <xsl:template name="subsetmain">
        <xsl:result-document href="{concat($outDir,'/lists/allmapsave.xml')}">
            <nodes>
                <xsl:copy-of select="$allnodes" copy-namespaces="no"/>
            </nodes>
        </xsl:result-document>
        <xsl:result-document href="{concat($outDir,'/msgmap.xml')}">
            <Messages>
                <xsl:for-each select="$messagenodes/*">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </Messages>
        </xsl:result-document>
        <xsl:for-each select="$messagenodes/*">
            <xsl:variable name="msg" select="."/>
            <xsl:variable name="msgname" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:variable name="mid" select="lower-case(translate(@mtfid, ' .()', ''))"/>
            <xsl:result-document href="{concat($outDir,'/lists/',$mid,'-list.xml')}">
                <xsl:copy-of select="." copy-namespaces="no"/>
            </xsl:result-document>
            <xsl:result-document href="{concat($outDir,$mid,'-ref.xsd')}">
                <xsl:for-each select="$ref-xsd-template/*">
                    <xsl:copy>
                        <xsl:apply-templates select="@*" mode="identity"/>
                        <xsl:apply-templates select="*" mode="identity"/>
                        <xsl:apply-templates select="$allmtf/*[@name = $msg/element[1]/@name]/*:annotation" mode="identity"/>
                        <xsl:for-each select="$allmtf/*[@name = $msg/element[1]/@name]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*" mode="identity"/>
                                <xs:annotation>
                                    <xsl:copy-of select="xs:annotation/xs:documentation"/>
                                    <xs:appinfo>
                                        <xsl:copy-of select="xs:annotation/xs:appinfo/*:Msg"/>
                                    </xs:appinfo>
                                </xs:annotation>
                            </xsl:copy>
                        </xsl:for-each>
                        <xsl:for-each select="$msg/*[not(@name = $msg/element[1]/@name)]">
                            <xsl:variable name="nn" select="@name"/>
                            <xsl:copy-of select="$allmtf/*[@name = $nn]"/>
                        </xsl:for-each>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="subsetXSD">
        <xsl:param name="msgid"/>
        <xsl:for-each select="$messagenodes/*[@mtfid = $msgid]">
            <xsl:variable name="msg" select="."/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:variable name="mid" select="lower-case(translate(@mtfid, ' .()', ''))"/>
            <xsl:for-each select="$ref-xsd-template/*">
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="identity"/>
                    <xsl:apply-templates select="*" mode="identity"/>
                    <xsl:apply-templates select="$allmtf/*[@name = $msg/element[1]/@name]/*:annotation" mode="identity"/>
                    <xsl:for-each select="$msg/*">
                        <xsl:variable name="nn" select="@name"/>
                        <xsl:copy-of select="$allmtf/*[@name = $nn]"/>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="subsetXSDout">
        <xsl:param name="msgid"/>
        <xsl:for-each select="$messagenodes/*[@mtfid = $msgid]">
            <xsl:variable name="msg" select="."/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:variable name="mid" select="lower-case(translate(@mtfid, ' .()', ''))"/>
            <xsl:result-document href="{concat($outDir,'/lists/',$mid,'-list.xml')}">
                <xsl:copy-of select="." copy-namespaces="no"/>
            </xsl:result-document>
            <xsl:result-document href="{concat($outDir,'/xsd/',$mid,'-ref.xsd')}">
                <xsl:for-each select="$ref-xsd-template/*">
                    <xsl:copy>
                        <xsl:apply-templates select="@*" mode="identity"/>
                        <xsl:apply-templates select="*" mode="identity"/>
                        <xsl:apply-templates select="$allmtf/*[@name = $msg/element[1]/@name]/*:annotation" mode="identity"/>
                        <xsl:for-each select="$msg/*">
                            <xsl:variable name="nn" select="@name"/>
                            <xsl:copy-of select="$allmtf/*[@name = $nn]"/>
                        </xsl:for-each>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <!--*****************************************************-->

    <xsl:template match="*" mode="map">
        <xsl:apply-templates select="*" mode="map"/>
    </xsl:template>

    <xsl:template match="*:annotation" mode="map"/>

    <xsl:template match="*[@ref]" mode="map">
        <xsl:variable name="r" select="@ref"/>
        <xsl:choose>
            <xsl:when test="@* = 'structures:SimpleObjectAttributeGroup'">
                <xsl:apply-templates select="*" mode="map"/>
            </xsl:when>
            <xsl:when test="@* = 'structures:ObjectType'">
                <xsl:apply-templates select="*" mode="map"/>
            </xsl:when>
            <xsl:when test="$r='TargetTypeAbstract'">
                <xsl:apply-templates select="$allmtf/*[@name = $r]" mode="map"/>
                <xsl:apply-templates select="$allmtf/*[@substitutionGroup = $r]" mode="map"/>
            </xsl:when>
            <xsl:when test="ends-with(@ref, 'Abstract')">
                <xsl:apply-templates select="$allmtf/*[@name = $r]" mode="map"/>
                <xsl:apply-templates select="$allmtf/*[@substitutionGroup = $r]" mode="map"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{replace(name(),'xs:','')}">
                    <xsl:copy-of select="@ref"/>
                    <xsl:copy-of select="$allmtf/*[@name = $r]/@type"/>
                    <xsl:copy-of select="*:annotation/*:appinfo/*/@mtfid"/>
                    <xsl:apply-templates select="*" mode="map"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[@name | @base | @type | @substitutionGroup]" mode="map">
        <xsl:choose>
            <xsl:when test="@* = 'xs:string'"/>
            <xsl:when test="@* = 'xs:integer'"/>
            <xsl:when test="@* = 'structures:SimpleObjectAttributeGroup'">
                <xsl:apply-templates select="*" mode="map"/>
            </xsl:when>
            <xsl:when test="@* = 'structures:ObjectType'">
                <xsl:apply-templates select="*" mode="map"/>
            </xsl:when>
            <xsl:when test="@* = 'SetBaseType'">
                <complexType name="SetBaseType"/>
                <xsl:apply-templates select="$allmtf/*[@name = 'SetBaseType']/*" mode="map"/>
                <xsl:apply-templates select="*" mode="map"/>
            </xsl:when>
            <xsl:when test="@name">
                <xsl:element name="{replace(name(),'xs:','')}">
                    <xsl:copy-of select="@name"/>
                    <xsl:copy-of select="@type"/>
                    <xsl:copy-of select="*:annotation/*:appinfo/*/@mtfid"/>
                    <xsl:apply-templates select="*" mode="map"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@base | @type">
                <xsl:element name="{replace(name(),'xs:','')}">
                    <xsl:attribute name="name">
                        <xsl:value-of select="@base | @type"/>
                    </xsl:attribute>
                    <xsl:copy-of select="*:annotation/*:appinfo/*/@mtfid"/>
                    <xsl:apply-templates select="*" mode="map"/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="@substitutionGroup">
            <element name="{@substitutionGroup}">
                <xsl:apply-templates select="*" mode="map"/>
            </element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@*" mode="map">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="text()" mode="map"/>

    <xsl:template name="iterateNode">
        <xsl:param name="node"/>
        <xsl:param name="nodelist"/>
        <xsl:variable name="nm" select="$node/@name"/>
        <node name="{$nm}"/>
        <xsl:for-each select="distinct-values($node//@*[name() = 'ref' or name() = 'type' or name() = 'base' or name() = 'substitutionGroup' or name() = 'abstract'][not(. = $node/@name)])">
            <xsl:variable name="n" select="."/>
            <xsl:choose>
                <xsl:when test="$node/*:annotation/*:appinfo/*:Choice">
                    <xsl:variable name="s" select="$node/@name"/>
                    <node name="{$s}"/>
                    <xsl:for-each select="$allmtf/*[@substitutionGroup = $s]">
                        <xsl:call-template name="iterateNode">
                            <xsl:with-param name="node" select="."/>
                            <xsl:with-param name="nodelist">
                                <xsl:copy-of select="$nodelist"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="not($nodelist/*[@name = $n])">
                        <xsl:call-template name="iterateNode">
                            <xsl:with-param name="node" select="$allmtf/*[@name = $n]"/>
                            <xsl:with-param name="nodelist">
                                <xsl:copy-of select="$nodelist"/>
                                <node name="{$n}"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*" mode="identity">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="identity"/>
            <xsl:apply-templates select="text()" mode="identity"/>
            <xsl:apply-templates select="*" mode="identity"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="identity">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

    <xsl:template match="text()" mode="identity">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

</xsl:stylesheet>
