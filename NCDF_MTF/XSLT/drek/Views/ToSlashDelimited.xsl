<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:variable name="MsgSchema" select="document('ACO/messages.xsd')"/>
    <xsl:variable name="SetSchema" select="document('ACO/sets.xsd')"/>
    <xsl:variable name="FieldSchema" select="document('ACO/fields.xsd')"/>
    <xsl:variable name="CompositeSchema" select="document('ACO/composites.xsd')"/>
    <xsl:variable name="MsgInstance" select="document('ACO_TEST_2.xml')"/>

    <xsl:template match="/">
        <xsl:apply-templates select="$MsgSchema/xsd:schema/xsd:element[1]"/>
    </xsl:template>

    <xsl:template match="xsd:annotation"/>  
    <xsl:template match="@*"/>
    <xsl:template match="text()"/>
    
    <xsl:template match="@minOccurs">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="@maxOccurs">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="xsd:element">
        <xsl:element name="{@name}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xsd:element[@type]">
        <xsl:variable name="type" select="@type"/>
        <xsl:element name="{@name}">
            <xsl:apply-templates select="./ancestor::xsd:schema//xsd:*[@name=$type]/*"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xsd:complexType">
            <xsl:apply-templates select="*"/>     
    </xsl:template>

    <xsl:template match="xsd:choice">
        <xsl:element name="choice">
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:sequence">
        <xsl:element name="sequence">
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xsd:restriction[child::xsd:enumeration]">
        <xsl:element name="select">
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xsd:enumeration">
        <xsl:element name="enumeration">
            <xsl:attribute name="value" select="@value"/>
        </xsl:element>
    </xsl:template>
    


    <xsl:template match="xsd:*">
        <xsl:apply-templates/> 
    </xsl:template>
    
    <xsl:template match="xsd:extension">
        <xsl:variable name="base" select="@base"/>
        <xsl:apply-templates select="./ancestor::xsd:schema//xsd:*[@name=$base]"/>
    </xsl:template>

    <xsl:template match="xsd:extension[starts-with(@base,'s:')]">
        <xsl:variable name="base" select="substring-after(@base,':')"/>
        <xsl:apply-templates select="$SetSchema//xsd:*[@name=$base]"/>
    </xsl:template>

    <xsl:template match="xsd:extension[starts-with(@base,'c:')]">
        <xsl:variable name="base" select="substring-after(@base,':')"/>
        <xsl:apply-templates select="$CompositeSchema//xsd:*[@name=$base]"/>
    </xsl:template>

    <xsl:template match="xsd:extension[starts-with(@base,'f:')]">
        <xsl:variable name="base" select="substring-after(@base,':')"/>
        <xsl:apply-templates select="$FieldSchema//xsd:*[@name=$base]"/>
    </xsl:template>

</xsl:stylesheet>
