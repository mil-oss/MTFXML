<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="codelist_changes" select="document('../../XSD/Refactor_Changes/CodeListChanges.xml')"/>
    
    <!--Output-->
    <xsl:variable name="codelist_out" select="'../../XSD/Analysis/CodeListChangesSort.xml'"/>

    <xsl:template name="main">
        <xsl:result-document href="{$codelist_out}">
            <CodeListTypeChanges>
                <xsl:for-each select="$codelist_changes/CodeListTypeChanges/CodeList">
                    <xsl:sort select="@name"/>
                    <xsl:copy>
                        <xsl:apply-templates select="@*"/>
                    </xsl:copy>
                </xsl:for-each>
            </CodeListTypeChanges>
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
