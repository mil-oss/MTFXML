<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <xsl:result-document href="{'NormalizedSimpleTypes.xsd'}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:fields" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsl:comment>**** STRINGS ****</xsl:comment>
                <xsl:apply-templates
                    select="document('../../XSLT/Fields/NormalizedSimpleTypes.xsd')/xsd:schema/xsd:simpleType[xsd:restriction/@base = 'xsd:string'][not(xsd:restriction/xsd:enumeration)]">
                    <xsl:sort select="@name"/>
                </xsl:apply-templates>
                <xsl:comment>**** ENUMERATONS ****</xsl:comment>
                <xsl:apply-templates
                    select="document('../../XSLT/Fields/NormalizedSimpleTypes.xsd')/xsd:schema/xsd:simpleType[xsd:restriction/@base = 'xsd:string'][xsd:restriction/xsd:enumeration]">
                    <xsl:sort select="@name"/>
                </xsl:apply-templates>
                <xsl:comment>**** INTEGERS ****</xsl:comment>
                <xsl:apply-templates
                    select="document('../../XSLT/Fields/NormalizedSimpleTypes.xsd')/xsd:schema/xsd:simpleType[xsd:restriction/@base = 'xsd:integer']">
                    <xsl:sort select="@name"/>
                </xsl:apply-templates>
                <xsl:comment>**** DECIMALS ****</xsl:comment>
                <xsl:apply-templates
                    select="document('../../XSLT/Fields/NormalizedSimpleTypes.xsd')/xsd:schema/xsd:simpleType[xsd:restriction/@base = 'xsd:decimal']">
                    <xsl:sort select="@name"/>
                </xsl:apply-templates>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
            <xsl:apply-templates select="text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
</xsl:stylesheet>
