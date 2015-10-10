<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/Baseline_Schemas/fields.xsd')"/>
    <xsl:variable name="goe_strTypes_xsd" select="document('NormalizedSimpleTypes.xml')"/>
    <xsl:variable name="outdoc" select="'StrTypes.xml'"/>
    
    <xsl:variable name="strtypes">
        <xsl:apply-templates
            select="$goe_fields_xsd/*/xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern]" mode="rgx">
            <xsl:sort select="xsd:restriction/xsd:pattern/@value"/>
        </xsl:apply-templates>
    </xsl:variable>
    
    <xsl:variable name="strgroup">
        <xsl:for-each select="$strtypes/*">
            <xsl:variable name="rgx">
                <xsl:value-of select="@regex"/>
            </xsl:variable>
            <xsl:if test="not($rgx=preceding-sibling::*/@regex)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="strcnt">
        <xsl:for-each select="$strgroup/*">
            <xsl:variable name="rgx" select="@regex"/>
            <xsl:element name="StrRgx">
                <xsl:attribute name="type">
                    <xsl:value-of select="$goe_strTypes_xsd/xsd:schema/xsd:simpleType[xsd:restriction/xsd:pattern/@value=$rgx]/@name"/>
                </xsl:attribute>
                <xsl:attribute name="rgxcount">
                    <xsl:value-of select="count($strtypes/*[@regex=$rgx])"/>
                </xsl:attribute>
                <xsl:for-each select="$strtypes/*[@regex=$rgx]">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:element>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="rgxrpt">
        <xsl:for-each select="$strcnt/*">
            <xsl:sort select="@rgxcount" order="descending" data-type="number"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:result-document href="{$outdoc}">
            <RegXFields>
                <xsl:for-each select="$rgxrpt/*">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </RegXFields>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xsd:simpleType" mode="rgx">
        <xsl:variable name="regx">
            <xsl:call-template name="patternValue">
                <xsl:with-param name="pattern">
                    <xsl:value-of select="xsd:restriction/xsd:pattern/@value"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:element name="StrField">
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="regex">
                <xsl:value-of select="$regx"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template name="patternValue">
        <xsl:param name="pattern"/>
        <!--TEST FOR MIN MAX IN REGEX-->
        <xsl:choose>
            <!--If Ends with max min strip off-->
            <xsl:when test="$goe_strTypes_xsd/xsd:schema/xsd:simpleType/xsd:restriction/xsd:pattern/@value = $pattern">
                <xsl:value-of select="$pattern"/>
            </xsl:when>
            <xsl:when test="ends-with($pattern, '}')">
                <xsl:choose>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 6), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 6)"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 5), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 5)"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 4), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 4)"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 3), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 3)"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 2), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 2)"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$pattern"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



</xsl:stylesheet>
