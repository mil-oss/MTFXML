<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <!--********************** JSON ********************-->
    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="a" select='"&apos;"'/>
    <xsl:variable name="bsl" select="'\'"/>
    <xsl:variable name="ebsl" select="'\\'"/>
    <xsl:variable name="c" select="':'"/>
    <xsl:variable name="lb" select="'{'"/>
    <xsl:variable name="rb" select="'}'"/>
    <xsl:variable name="lbr" select="'['"/>
    <xsl:variable name="rbr" select="']'"/>
    <xsl:variable name="cm" select="','"/>
    <!--*************************************************-->

    <xsl:template name="toJson">
        <xsl:param name="xdoc"/>
        <xsl:variable name="n" select="$xdoc/*/name()"/>
        <xsl:value-of select="$lb"/>
        <xsl:value-of select="concat($q, $n, $q, $c, $lb)"/>
        <xsl:for-each select="$xdoc/*/*">
            <xsl:variable name="n" select="name()"/>
            <xsl:variable name="atts">
                <xsl:for-each select="@*">
                    <xsl:element name="{name()}">
                        <xsl:value-of select="normalize-space(replace(., $q, $a))"/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="jname">
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[name() = $n]">
                        <xsl:value-of select="position()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="name()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="concat($q, $jname, $q, $c, $lb)"/>
            <xsl:for-each select="$atts/*">
                <xsl:variable name="v">
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:variable>
                <xsl:value-of select="concat($q, name(), $q, $c, $q, $v, $q)"/>
                <xsl:if test="following-sibling::*[name()]">
                    <xsl:value-of select="$cm"/>
                </xsl:if>
            </xsl:for-each>
            <xsl:apply-templates select="*" mode="json"/>
            <xsl:value-of select="$rb"/>
            <xsl:if test="following-sibling::*[name()]">
                <xsl:value-of select="$cm"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="$rb"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="*" mode="json">
        <xsl:variable name="atts">
            <xsl:for-each select="@*">
                <xsl:element name="{name()}">
                    <xsl:value-of select="normalize-space(replace(., $q, $a))"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="n" select="name()"/>
        <xsl:variable name="jname">
            <xsl:choose>
                <xsl:when test="@name">
                    <xsl:value-of select="@name"/>
                </xsl:when>
                <xsl:when test="following-sibling::*[name() = $n]">
                    <xsl:value-of select="position()"/>
                </xsl:when>
                <xsl:when test="preceding-sibling::*[name() = $n]">
                    <xsl:value-of select="position()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($q, $jname, $q, $c, $lb)"/>
        <xsl:for-each select="$atts/*">
            <xsl:variable name="v">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:variable>
            <xsl:value-of select="concat($q, name(), $q, $c, $q, $v, $q)"/>
            <xsl:if test="following-sibling::*[name()]">
                <xsl:value-of select="$cm"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:apply-templates select="*" mode="json"/>
        <xsl:value-of select="$rb"/>
        <xsl:if test="following-sibling::*[name()]">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
