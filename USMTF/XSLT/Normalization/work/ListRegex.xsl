<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="inputdoc" select="document('../Baseline_Schemas/fields.xsd')"/>
    
    <xsl:template match="/">
        <xsl:result-document href="RegexList.xml">
        <SimpleTypes>
        <xsl:apply-templates select="$inputdoc//xsd:simpleType">
            <xsl:sort select="xsd:pattern"/>
        </xsl:apply-templates>
        </SimpleTypes>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="xsd:simpleType">
        <Field>
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="regex">
                <xsl:value-of select="*//xsd:pattern/@value"/>
            </xsl:attribute>
        </Field>
    </xsl:template>
    
</xsl:stylesheet>