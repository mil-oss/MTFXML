<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="all_field_map" select="document('../../XSD/NCDF_MTF_REF/Maps/NCDF_MTF_Fieldmaps.xml')/*"/>
    <xsl:variable name="all_composite_map" select="document('../../XSD/NCDF_MTF_REF/Maps/NCDF_MTF_Compositemaps.xml')/*"/>
    <xsl:variable name="all_set_map" select="document('../../XSD/NCDF_MTF_REF/Maps/NCDF_MTF_Setmaps.xml')/*"/>
    <xsl:variable name="all_segment_map" select="document('../../XSD/NCDF_MTF_REF/Maps/NCDF_MTF_Segmntmaps.xml')/*"/>
    <xsl:variable name="all_message_map" select="document('../../XSD/NCDF_MTF_REF/Maps/NCDF_MTF_Msgsmaps.xml')/*"/>

    <xsl:variable name="NCDF_Changes_Rpt" select="'../../XSD/NCDF_MTF_REF/Maps/NCDF_Element_Changes.xml'"/>

    <xsl:template name="main">
        <xsl:variable name="allchanges">
            <xsl:apply-templates select="$all_field_map//*[@ncdfelementname]" mode="testchange"/>
            <xsl:apply-templates select="$all_composite_map//*[@ncdfelementname]" mode="testchange"/>
            <xsl:apply-templates select="$all_set_map//*[@ncdfelementname]" mode="testchange"/>
            <xsl:apply-templates select="$all_segment_map//*[@ncdfelementname]" mode="testchange"/>
            <xsl:apply-templates select="$all_message_map//*[@ncdfelementname]" mode="testchange"/>
        </xsl:variable>
        <xsl:result-document href="{$NCDF_Changes_Rpt}">
            <NCDF_Element_Changes>
              <xsl:for-each select="$allchanges/*">
                  <xsl:sort select="@mtname"/>
                  <xsl:copy-of select="."/>
              </xsl:for-each>
            </NCDF_Element_Changes>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*" mode="testchange">
        <xsl:variable name="mtfname">
            <xsl:choose>
                <xsl:when test="@mtfname">
                    <xsl:value-of select="@mtfname"/>
                </xsl:when>
                <xsl:when test="ends-with(@mtftype, 'Type')">
                    <xsl:value-of select="substring(@mtftype, 0, string-length(@mtftype) - 3)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ncdfname" select="@ncdfelementname"/>
        <xsl:variable name="id" select="@identifier"/>
        <!--<Element mtfname="{@mtfname}" ncdfname="{@ncdfelemntname}"/>-->
        <xsl:choose>
            <xsl:when test="$mtfname = $ncdfname"/>
            <xsl:otherwise>
                <Element mtfname="{$mtfname}" ncdfname="{$ncdfname}">
                    <xsl:apply-templates select="@*"/>
                </Element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:choose>
            <xsl:when test="name()='identifier'">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="name()='parentname'">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="name()='ffirn'">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="name()='fud'">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="name()='seq'">
                <xsl:copy-of select="."/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
   

</xsl:stylesheet>
