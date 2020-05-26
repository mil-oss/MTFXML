<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="xmldoc" select="document('../../XSD/NIEM_MTF/NIEM_MTF.xsd')"/>
    
    <xsl:variable name="regex_list_edit" select="document('../../XSD/Analysis/MTFTests/regex_list-edit.xml')"/>
    <!--Output-->
    <xsl:variable name="regex_list" select="'../../XSD/Analysis/MTFTests/regex_list.xml'"/>

    <xsl:variable name="all_regex">
        <xsl:for-each select="$xmldoc//xs:pattern">
            <xsl:sort select="@value"/>
            <xsl:variable name="v" select="@value"/>
            <regex pattern="{@value}">
                <xsl:if test="parent::*/xs:minLength">
                    <xsl:attribute name="minlength">
                        <xsl:value-of select="parent::*/xs:minLength/@value"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="parent::*/xs:maxLength">
                    <xsl:attribute name="maxlength">
                        <xsl:value-of select="parent::*/xs:maxLength/@value"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="parent::*/xs:length">
                    <xsl:attribute name="length">
                        <xsl:value-of select="parent::*/xs:length/@value"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$regex_list_edit/*/*[@pattern=$v][1]"/>
            </regex>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="{$regex_list}">
            <RegexList>
                <xsl:for-each select="$all_regex/*">
                    <xsl:sort select="@pattern"/>
                    <xsl:variable name="v" select="@pattern"/>
                    <xsl:variable name="m" select="@maxlength | @length"/>
                    <xsl:if test="count(preceding-sibling::*[@pattern = $v]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </RegexList>
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
