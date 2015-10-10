<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/GoE_Schemas/GoE_fields.xsd')"/>
    <xsl:variable name="goe_strTypes_xsd" select="document('NormalizedSimpleTypes.xml')"/>
    
    <xsl:variable name="elements" select="count($goe_fields_xsd/xsd:schema/xsd:element)"/>
    <xsl:variable name="stypes" select="count($goe_fields_xsd/xsd:schema/xsd:simpleType)"/>
    <xsl:variable name="ctypes" select="count($goe_fields_xsd/xsd:schema/xsd:complexType)"/>
    <xsl:variable name="str_stypes" select="count($goe_fields_xsd/*/xsd:simpleType[xsd:restriction/xsd:pattern])"/>
    <xsl:variable name="int_stypes" select="count($goe_fields_xsd/*/xsd:simpleType[xsd:restriction/@base='xsd:integer'])"/>
    <xsl:variable name="dec_stypes" select="count($goe_fields_xsd/*/xsd:simpleType[xsd:restriction/@base='xsd:decimal'])"/>

    <xsl:template match="/">
        <div>
            <div>
                <xsl:text>TOTAL FIELDS: </xsl:text>
                <xsl:value-of select="$elements"/>
            </div>
            <div>
                <xsl:text>TOTAL SIMPLE TYPES: </xsl:text>
                <xsl:value-of select="$stypes"/>
            </div>
            <div>
                <xsl:text>TOTAL COMPLEX TYPES: </xsl:text>
                <xsl:value-of select="$ctypes"/>
            </div>
            <div>
                <xsl:text>XSD:STRING FIELD TYPES: </xsl:text>
                <xsl:value-of select="$str_stypes"/>
            </div>
            <div>
                <xsl:text>XSD:INTEGER FIELD TYPES: </xsl:text>
                <xsl:value-of
                    select="$int_stypes"/>
            </div>
            <div>
                <xsl:text>XSD:DECIMAL FIELD  TYPES: </xsl:text>
                <xsl:value-of
                    select="$dec_stypes"/>
            </div>
        </div>
        <xsl:apply-templates select="$goe_fields_xsd/*/xsd:simpleType[xsd:restriction/@base='xsd:integer']"/>
    </xsl:template>
    
    <xsl:template match="xsd:simpleType">
        <div>Name:<span><xsl:value-of select="@name"/></span></div>
        <div>minInclusive:<span><xsl:value-of select="xsd:restriction/xsd:minInclusive/@value"/></span></div>
        <div>maxInclusive:<span><xsl:value-of select="xsd:restriction/xsd:maxInclusive/@value"/></span></div>
    </xsl:template>

</xsl:stylesheet>
