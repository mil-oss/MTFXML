<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/Baseline_Schemas/fields.xsd')"/>
    <xsl:variable name="enum_fields_xsd" select="document('EnumTypes.xml')"/>
    <xsl:variable name="outdoc" select="'MultiEnumTypesAll.xml'"/>
    <xsl:variable name="enumtypes">
        <xsl:apply-templates
            select="$enum_fields_xsd/*/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:enumeration]"
            mode="enum"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="{$outdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:fields" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsl:for-each select="$enum_fields_xsd/EnumTypes/EnumType[Enums[not(count(Enum) = 1)]]">
                    <xsl:variable name="n" select="@name"/>
                    <xsd:simpleType name="{@name}">
                    <xsd:annotation>
                        <xsd:appinfo>
                            <Occurrence qty="{@count}"/>
                        </xsd:appinfo>
                    </xsd:annotation>
                        <xsl:apply-templates
                        select="$goe_fields_xsd//xsd:simpleType[@name = $n]/xsd:restriction"/>
                    </xsd:simpleType>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
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
