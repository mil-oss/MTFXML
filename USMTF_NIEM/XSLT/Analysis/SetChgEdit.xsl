<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="xmldoc" select="document('../../XSD/Refactor_Changes/SetChanges.xml')"/>

    <!--Output-->
    <xsl:variable name="sorted_out" select="'../../XSD/Refactor_Changes/SetChangesEdit.xml'"/>

    <xsl:template name="main">
        <xsl:result-document href="{$sorted_out}">
            <xsl:for-each select="$xmldoc/*">
                <xsl:copy>
                    <xsl:apply-templates select="*"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*">
        <xsl:copy-of select="."/>
    </xsl:template>


    <xsl:template match="Set">
        <xsl:variable name="ctname">
            <xsl:choose>
                <xsl:when test="ends-with(@niemcomplextype, 'SetType')">
                    <xsl:value-of select="@niemcomplextype"/>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:value-of select="concat(substring(@niemcomplextype, 0, string-length(@niemcomplextype) - 3), 'SetType')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy>            
            <xsl:apply-templates select="@*" mode="identity"/>
            <xsl:attribute name="niemcomplextype">
                <xsl:value-of select="$ctname"/>
            </xsl:attribute>
            <xsl:if test="not(@niemelementname)">
                <xsl:attribute name="niemelementname">
                    <xsl:value-of select="substring($ctname, 0, string-length($ctname) - 3)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@niemelementname='Set'">
                    <xsl:attribute name="niemelementname">
                        <xsl:value-of select="substring($ctname, 0, string-length($ctname) - 3)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="ends-with(@niemelementname, 'Set')">
                    <xsl:copy-of select="@niemelementname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="niemelementname">
                        <xsl:value-of select="concat(@niemelementname, 'Set')"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*" mode="identity">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="identity"/>
            <xsl:apply-templates select="text()" mode="identity"/>
            <xsl:apply-templates select="*" mode="identity"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="identity">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

    <xsl:template match="text()" mode="identity">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>



    <xsl:template match="@*">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="@count"/>

    <xsl:template match="@changedocto">
        <xsl:attribute name="doc" select="."/>
    </xsl:template>

</xsl:stylesheet>
