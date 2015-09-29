<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="normalizedsimpletypes" select="document('../Fields/NormalizedSimpleTypes.xsd')"/>
    
    <xsl:variable name="stringtypes">
        <xsl:for-each
            select="$normalizedsimpletypes/*/*[xsd:restriction[@base = 'xsd:string']][not(xsd:restriction/xsd:enumeration)]">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="document('Normalized_Fields.xsd')/*/xsd:element">
            <xsl:variable name="nm">
                <xsl:value-of select="concat(@name,'SimpleType')"/>
            </xsl:variable>
            <xsl:variable name="bs">
                <xsl:value-of select="xsd:simpleType/xsd:restriction/@base"/>
            </xsl:variable>               
            <xsl:if test="$bs=$nm">
                <xsd:simpleType name="{$nm}">
                    <xsl:apply-templates select="xsd:simpleType/xsd:restriction/xsd:annotation"/>
                    <xsd:restriction base="xsd:string">
                        <xsl:for-each select="xsd:simpleType/xsd:restriction/*[not(xsd:annotation)]">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </xsd:restriction>
                </xsd:simpleType>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:result-document href="{'NormalizedRegexTypes.xsd'}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:fields" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsl:for-each select="$stringtypes/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="xsd:appinfo"/>
    
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
    
 
</xsl:stylesheet>