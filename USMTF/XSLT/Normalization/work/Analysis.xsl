<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsd"
    version="2.0">
     <xsl:output method="xml" indent="yes"/>
    
    <!--  This XSLT provides basic alnalysis for comparison against refactored products-->
    
    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="mtf_fields" select="document('../../XSD/Baseline_Schema/fields.xsd')"/>
    
    <xsl:template match="/">
        <Fields>
            <BaselineSimpleTypes>
                <xsl:attribute name="StringFieldsCount">
                    <xsl:value-of select="count($mtf_fields/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern])"/>
                </xsl:attribute>
                <xsl:attribute name="EnumeratedFieldsCount">
                    <xsl:value-of select="count($mtf_fields/xsd:schema/xsd:simpleType[xsd:restriction/xsd:enumeration])"/>
                </xsl:attribute>
                <xsl:attribute name="DecimalFieldsCount">
                    <xsl:value-of select="count($mtf_fields/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:decimal']])"/>
                </xsl:attribute>
                <xsl:attribute name="IntegerFieldsCount">
                    <xsl:value-of select="count($mtf_fields/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:integer']])"/>
                </xsl:attribute>
            </BaselineSimpleTypes>
        </Fields>
    </xsl:template>
    
</xsl:stylesheet>