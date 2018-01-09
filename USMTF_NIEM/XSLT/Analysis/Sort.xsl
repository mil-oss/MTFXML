<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="xmldoc" select="document('../../XSD/NIEM_MTF_1_NS/Refactor_Changes/CompositeChanges.xml')"/>
    
    <!--Output-->
    <xsl:variable name="sorted_out" select="'../../XSD/NIEM_MTF_1_NS/Refactor_Changes/CompositeChanges-Sort.xml'"/>

    <xsl:template name="main">
        <xsl:result-document href="{$sorted_out}">
            <CompositeTypeChanges>
                <xsl:for-each select="$xmldoc/*/*">
                    <xsl:sort select="@name"/>
                    <xsl:element name="Composite">
                        <xsl:apply-templates select="@*"/>
                    </xsl:element>
                </xsl:for-each>
            </CompositeTypeChanges>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="@count"/>
    
    <xsl:template match="@changedocto">
        <xsl:attribute name="doc" select="."/>
    </xsl:template>

</xsl:stylesheet>
