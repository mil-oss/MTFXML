<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="niem_sets_map" select="document('../../XSD/NIEM_MTF/NIEM_MTF_SetMaps.xml')/*"/>
    
    <xsl:variable name="subgrps_edit" select="document('../../XSD/Refactor_Changes/SubstitutionGroupChanges.xml')"/>

    <xsl:variable name="subgrps_out" select="'../../XSD/Analysis/SubstitutionGroups.xml'"/>

    <xsl:variable name="sGrps">
        <xsl:for-each select="$niem_sets_map//Element[Choice]">
            <xsl:sort select="@mtfname"/>
            <xsl:variable name="n" select="@mtfname"/>
            <xsl:variable name="s">
                <xsl:value-of select="ancestor::Set[1]/@mtfname"/>
            </xsl:variable>
            <Choice>
                <xsl:copy-of select="@mtfname"/>
                <xsl:copy-of select="$subgrps_edit/*/Choice[@mtfname=$n][@setname=$s]/@niemname"/>
                <xsl:attribute name="setname">
                    <xsl:value-of select="$s"/>
                </xsl:attribute>
                <xsl:copy-of select="appinfo/*/@positionName"/>
                <xsl:copy-of select="appinfo/*/@concept"/>
                <xsl:copy-of select="appinfo/*/@column"/>
                <xsl:copy-of select="appinfo/*/@justification"/>
                <xsl:copy-of select="appinfo/*/@identifier"/>
                <xsl:for-each select="Choice/Element">
                    <xsl:sort select="@mtfname"/>
                    <Element>
                        <xsl:copy-of select="@mtfname"/>
                        <xsl:copy-of select="@mtftype"/>
                    </Element>
                </xsl:for-each>
            </Choice>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="{$subgrps_out}">
            <SubstitionGroups>
                <xsl:for-each select="$sGrps/*">
                    <xsl:sort select="@mtfname"/>
                    <xsl:sort select="Element[1]/@mtfname"/>
                    <xsl:sort select="@mtftype"/>
                    <xsl:sort select="@concept"/>
                    <xsl:variable name="n" select="@mtfname"/>
                    <xsl:if test="count($sGrps/*[@mtfname = $n]) &gt; 1">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </SubstitionGroups>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
