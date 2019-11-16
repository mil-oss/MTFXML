<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="../USMTF_NIEM/USMTF_Utility.xsl"/>

    <xsl:variable name="fields_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')"/>

    <xsl:variable name="codelist_changes" select="document('../../XSD/Normalized/CodeListChanges.xml')"/>

    <xsl:variable name="codelistout" select="'../../XSD/Normalized/CodeList.xml'"/>

    <xsl:variable name="enumerations_xsd" select="$fields_xsd/xsd:schema//xsd:simpleType[xsd:restriction[@base = 'xsd:string'][xsd:enumeration]]"/>
    <!--Output-->
    <xsl:variable name="enumerationsoutdoc" select="'../../XSD/Normalized/CodeLists.xsd'"/>

    <xsl:variable name="codelists">
        <xsl:for-each select="$enumerations_xsd">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="elname" select="substring(@name, 0, string-length(@name) - 3)"/>
            <xsl:variable name="changeto" select="$codelist_changes/CodeListTypeChanges/CodeList[@name = $n]/@changeto"/>
            <xsl:variable name="stype">
                <xsl:choose>
                    <xsl:when test="$codelist_changes/CodeListTypeChanges/CodeList/@name = $n">
                        <xsl:value-of select="concat(substring($changeto, 0, string-length($changeto) - 3), 'CodeSimpleType')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($elname, 'CodeSimpleType')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ctype">
                <xsl:choose>
                    <xsl:when test="$codelist_changes/CodeListTypeChanges/CodeList/@name = $n">
                        <xsl:value-of select="concat(substring($changeto, 0, string-length($changeto) - 3), 'CodeType')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($elname, 'CodeType')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="eldoc">
                <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
            </xsl:variable>
            <xsl:variable name="typedoc">
                <xsl:choose>
                    <xsl:when test="$codelist_changes/CodeListTypeChanges/CodeList[@name = $n]">
                        <xsl:value-of select="$codelist_changes/CodeListTypeChanges/CodeList[@name = $n]/@doc"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$eldoc"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="appinfo">
                <xsl:apply-templates select="xsd:annotation/xsd:appinfo"/>
            </xsl:variable>
            <CodeList name="{@name}" elname="{$elname}" stype="{$stype}" ctype="{$ctype}">
                <xsl:copy-of select="$codelist_changes/CodeListTypeChanges/CodeList[@name = $n]/@changeto"/>
                <eldoc>
                    <xsl:value-of select="$eldoc"/>
                </eldoc>
                <typedoc>
                    <xsl:value-of select="$typedoc"/>
                </typedoc>
                <appinfo>
                    <xsl:copy-of select="$appinfo/*/*" copy-namespaces="no"/>
                </appinfo>
                <Codes>
                    <xsl:for-each select="xsd:restriction/xsd:enumeration">
                        <xsl:sort select="@value"/>
                        <Code value="{@value}" dataItem="{xsd:annotation/xsd:appinfo/*:DataItem}" doc="{normalize-space(xsd:annotation/xsd:documentation/text())}"/>
                    </xsl:for-each>
                </Codes>
            </CodeList>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="normcodelisttypes">
        <xsl:for-each select="$codelist_changes/CodeListTypeChanges/CodeList">
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="ch" select="@changeto"/>
            <xsl:if test="not(preceding-sibling::CodeList[1]/@changeto = $ch)">
                <xsl:variable name="codes" select="$codelists/CodeList[@name = $n][1]/Codes"/>
                <xsl:variable name="stype" select="concat(substring($ch, 0, string-length($ch) - 3), 'CodeSimpleType')"/>
                <xsl:variable name="ctype" select="concat(substring($ch, 0, string-length($ch) - 3), 'CodeType')"/>
                <xsl:variable name="el" select="concat(substring($n, 0, string-length($n) - 3), 'Code')"/>
                <xsd:simpleType name="{$stype}">
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="@doc"/>
                        </xsd:documentation>
                    </xsd:annotation>
                    <xsd:restriction base="xsd:string">
                        <xsl:for-each select="$codes/Code">
                            <xsd:enumeration value="{@value}">
                                <xsd:annotation>
                                    <xsd:documentation>
                                        <xsl:value-of select="@doc"/>
                                    </xsd:documentation>
                                    <xsd:appinfo>
                                        <Code dataItem="{@dataItem}"/>
                                    </xsd:appinfo>
                                </xsd:annotation>
                            </xsd:enumeration>
                        </xsl:for-each>
                    </xsd:restriction>
                </xsd:simpleType>
                <xsd:complexType name="{$ctype}">
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="@doc"/>
                        </xsd:documentation>
                    </xsd:annotation>
                    <xsd:simpleContent>
                        <xsd:extension base="{$stype}">
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                            <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                        </xsd:extension>
                    </xsd:simpleContent>
                </xsd:complexType>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="codelisttypes">
        <xsl:for-each select="$codelists/*">
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="codes" select="Codes"/>
            <xsl:choose>
                <!-- If codelist has normalized type, create simpleType and complexType only-->
                <xsl:when test="@changeto">
                    <xsd:simpleType name="{@stype}">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="typedoc"/>
                            </xsd:documentation>
                        </xsd:annotation>
                        <xsd:restriction base="xsd:string">
                            <xsl:for-each select="$codes/Code">
                                <xsd:enumeration value="{@value}">
                                    <xsd:annotation>
                                        <xsd:documentation>
                                            <xsl:value-of select="@doc"/>
                                        </xsd:documentation>
                                        <xsd:appinfo>
                                            <Code dataItem="{@dataItem}"/>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                </xsd:enumeration>
                            </xsl:for-each>
                        </xsd:restriction>
                    </xsd:simpleType>
                    <xsd:complexType name="{@ctype}">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="typedoc"/>
                            </xsd:documentation>
                        </xsd:annotation>
                        <xsd:simpleContent>
                            <xsd:extension base="{@stype}">
                                <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                            </xsd:extension>
                        </xsd:simpleContent>
                    </xsd:complexType>
                </xsl:when>
                <!-- Otherwise, create simpleType if not already in normalized types,complexType-->
                <xsl:otherwise>
                    <xsl:if test="not($normcodelisttypes/xsd:simpleType[@name = @stype])">
                        <xsd:simpleType name="{@stype}">
                            <xsd:annotation>
                                <xsd:documentation>
                                    <xsl:value-of select="typedoc"/>
                                </xsd:documentation>
                            </xsd:annotation>
                            <xsd:restriction base="xsd:string">
                                <xsl:for-each select="$codes/Code">
                                    <xsd:enumeration value="{@value}">
                                        <xsd:annotation>
                                            <xsd:documentation>
                                                <xsl:value-of select="@doc"/>
                                            </xsd:documentation>
                                            <xsd:appinfo>
                                                <Code dataItem="{@dataItem}"/>
                                            </xsd:appinfo>
                                        </xsd:annotation>
                                    </xsd:enumeration>
                                </xsl:for-each>
                            </xsd:restriction>
                        </xsd:simpleType>
                    </xsl:if>
                    <xsl:if test="not($normcodelisttypes/xsd:complexType[@name = @ctype])">
                        <xsd:complexType name="{@ctype}">
                            <xsd:annotation>
                                <xsd:documentation>
                                    <xsl:value-of select="typedoc"/>
                                </xsd:documentation>
                            </xsd:annotation>
                            <xsd:simpleContent>
                                <xsd:extension base="{@stype}">
                                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                    <xsd:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                                </xsd:extension>
                            </xsd:simpleContent>
                        </xsd:complexType>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsd:element name="{@elname}" type="{@ctype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="eldoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:copy-of select="appinfo/*"/>
                    </xsd:appinfo>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="codelistxsd">
        <!--<xsl:for-each select="$normcodelisttypes/*">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>-->
        <xsl:for-each select="$codelisttypes/xsd:simpleType">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$codelisttypes/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="$codelisttypes/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="{$enumerationsoutdoc}">
            <xsd:schema xmlns="urn:int:nato:ncdf:mtf:niem" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/3.0/" targetNamespace="urn:int:nato:ncdf:mtf:niem"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/3.0/" schemaLocation="structures.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>Code Lists for Message Text Format Messages</xsd:documentation>
                </xsd:annotation>
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
                <xsl:for-each select="$codelistxsd/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$codelistout}">
            <CodeLists>
                <xsl:copy-of select="$codelists"/>
            </CodeLists>
        </xsl:result-document>
    </xsl:template>


</xsl:stylesheet>
