<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/Baseline_Schemas/fields.xsd')"/>
    <xsl:variable name="allenums" select="'EnumTypes.xml'"/>
    <xsl:variable name="uniquenumdoc" select="'UniqueEnumTypesAll.xml'"/>
    <xsl:variable name="singleuenumdoc" select="'SingleEnumTypesAll.xml'"/>
    <xsl:variable name="multienum" select="'MultiEnumTypesAll.xml'"/>

    <xsl:variable name="enumtypes">
        <xsl:apply-templates
            select="$goe_fields_xsd/*/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:enumeration]"
            mode="enum"/>
    </xsl:variable>

    <xsl:variable name="enum_fields_xsd">
        <EnumTypes>
            <xsl:for-each select="$enumtypes/*">
                <xsl:sort select="@count" data-type="number" order="descending"/>
                <xsl:variable name="nm" select="@name"/>
                <xsl:if test="not(preceding-sibling::EnumType/Match/@name = $nm)">
                    <xsl:copy-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </EnumTypes>
    </xsl:variable>


    <xsl:template match="/">
        <xsl:result-document href="{$allenums}">
            <xsl:copy-of select="$enum_fields_xsd"/>
        </xsl:result-document>
        <xsl:result-document href="{$uniquenumdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:fields" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsl:for-each select="$enum_fields_xsd/EnumTypes/EnumType[Enums[count(EnumEl) = 1]]">
                    <xsl:variable name="n" select="@name"/>
                    <xsd:simpleType name="{@name}">
                        <xsl:apply-templates
                            select="$goe_fields_xsd//xsd:simpleType[@name = $n]/xsd:restriction"/>
                    </xsd:simpleType>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$singleuenumdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:fields" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsl:for-each
                    select="$enum_fields_xsd/EnumTypes/EnumType[count(xsd:restriction/xsd:enumeration)=1]">
                    <xsl:variable name="r" select="xsd:restriction"/>
                    <xsl:if test="not(deep-equal($r, preceding-sibling::*/xsd:restriction))">
                        <xsl:apply-templates select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$multienum}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:fields" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsl:for-each
                    select="$enum_fields_xsd/EnumTypes/EnumType[Enums[not(count(EnumEl) = 1)]]">
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::EnumType/Enums/EnumEl/@name=$n)">
                        <xsl:apply-templates select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <!--Check for simple types with eqivalent enumerations-->
    <xsl:template match="xsd:simpleType" mode="enum">
        <xsl:variable name="r">
            <xsl:copy-of select="xsd:restriction"/>
        </xsl:variable>
        <xsl:variable name="matches">
            <Enums>
                <xsl:call-template name="CompareAll">
                    <xsl:with-param name="restr" select="$r"/>
                </xsl:call-template>
            </Enums>
        </xsl:variable>
        <EnumType name="{@name}" count="{count($matches/Enums/*)}">
            <xsl:copy-of select="$r"/>
            <xsl:copy-of select="$matches"/>
        </EnumType>
    </xsl:template>

    <xsl:template name="CompareAll">
        <xsl:param name="restr"/>
        <xsl:for-each
            select="$goe_fields_xsd/*/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:enumeration]">
            <xsl:variable name="comprestr">
                <xsl:copy-of select="xsd:restriction"/>
            </xsl:variable>
            <xsl:if test="deep-equal($restr, $comprestr)">
                <EnumEl name="{@name}"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:copy-of select="normalize-space(.)"/>
    </xsl:template>
    <xsl:template match="*:EntryType"/>
    <xsl:template match="*:DataType"/>
    <xsl:template match="*:DataItemSequenceNumber"/>
    <xsl:template match="*:DataItemSponsor"/>

</xsl:stylesheet>
