<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2019 JD NEUSHUL
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="text" indent="yes"/>

    <!--
        This XSL Generates a JSON Representation of an instance
        for use by JSON aware frameworks.
        
        To run the XSL ensure that the xsdpath and xsdjson paths are correct
        and configure the XSL processor to use the 'main' template.
    -->
    
    <!-- 
    input:  /iepd/xml/instance/test_instance.xml
    output: /iepd/json/test_instance.json
    
    input:  /iepd/xml/instance/test_instance-ism.xml
    output: /iepd/json/test_instance-ism.json
   -->



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

    <xsl:template match="/">
        <xsl:call-template name="main"/>
    </xsl:template>


    <xsl:template name="main">
        <xsl:value-of select="$lb"/>
        <xsl:apply-templates select="*"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>


    <xsl:template match="*">
        <xsl:variable name="n" select="name()"/>
        <xsl:variable name="suf">
            <xsl:if test="preceding-sibling::*[name() = $n]">
                <xsl:value-of select="count(preceding-sibling::*[name() = $n])"/>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="*">
                <xsl:value-of select="concat($q, name(), $suf, $q, $c, $lb)"/>
                <xsl:value-of select="concat($q, 'name', $q, $c, $q, name(), $q, $cm)"/>
                <xsl:if test="@*">
                    <xsl:variable name="atts">
                        <xsl:for-each select="@*">
                            <xsl:variable name="av">
                                <xsl:call-template name="escape-bs-string">
                                    <xsl:with-param name="s" select="normalize-space(.)"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <json str="{concat($q, name(), $q, $c, $q, $av, $q)}"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="concat($q, 'attributes', $q, $c, $lb)"/>
                    <xsl:for-each select="exsl:node-set($atts)/*">
                        <xsl:value-of select="@str"/>
                        <xsl:if test="following-sibling::json">
                            <xsl:value-of select="$cm"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:value-of select="$rb"/>
                    <xsl:if test="*">
                        <xsl:value-of select="$cm"/>
                    </xsl:if>
                </xsl:if>
                <xsl:apply-templates select="*"/>
                <xsl:value-of select="$rb"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="val">
                    <xsl:call-template name="escape-bs-string">
                        <xsl:with-param name="s" select="normalize-space(.)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($q, name(), $suf, $q, $c, $lb)"/>
                <xsl:value-of select="concat($q, 'name', $q, $c, $q, name(), $q, $cm)"/>
                <xsl:value-of select="concat($q, 'value', $q, $c, $q, $val, $q)"/>
                <xsl:if test="@*">
                    <xsl:variable name="atts">
                        <xsl:for-each select="@*">
                            <xsl:variable name="v">
                                <xsl:call-template name="escape-bs-string">
                                    <xsl:with-param name="s" select="normalize-space(.)"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <json str="{concat($q, name(), $q, $c, $q, $v, $q)}"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="concat($cm, $q, 'attributes', $q, $c, $lb)"/>
                    <xsl:for-each select="exsl:node-set($atts)/*">
                        <xsl:value-of select="@str"/>
                        <xsl:if test="following-sibling::json">
                            <xsl:value-of select="$cm"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:value-of select="$rb"/>
                </xsl:if>
                <xsl:value-of select="$rb"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="following-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <!--REGEX ESCAPING FOR JSON-->
    <!-- Escape the backslash (\) before everything else. -->
    <xsl:template name="escape-bs-string">
        <xsl:param name="s"/>
        <xsl:choose>
            <xsl:when test="contains($s, '\')">
                <xsl:call-template name="escape-quot-string">
                    <xsl:with-param name="s" select="concat(substring-before($s, '\'), '\\')"/>
                </xsl:call-template>
                <xsl:call-template name="escape-bs-string">
                    <xsl:with-param name="s" select="substring-after($s, '\')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="escape-quot-string">
                    <xsl:with-param name="s" select="$s"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Escape the double quote ("). -->
    <xsl:template name="escape-quot-string">
        <xsl:param name="s"/>
        <xsl:choose>
            <xsl:when test="contains($s, '&quot;')">
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="concat(substring-before($s, '&quot;'), '\&quot;')"/>
                </xsl:call-template>
                <xsl:call-template name="escape-quot-string">
                    <xsl:with-param name="s" select="substring-after($s, '&quot;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="$s"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Replace tab, line feed and/or carriage return by its matching escape code. Can't escape backslash
		   or double quote here, because they don't replace characters (&#x0; becomes \t), but they prefix
		   characters (\ becomes \\). Besides, backslash should be seperate anyway, because it should be
		   processed first. This function can't do that. -->
    <xsl:template name="encode-string">
        <xsl:param name="s"/>
        <xsl:choose>
            <!-- tab -->
            <xsl:when test="contains($s, '&#x9;')">
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="concat(substring-before($s, '&#x9;'), '\t', substring-after($s, '&#x9;'))"/>
                </xsl:call-template>
            </xsl:when>
            <!-- line feed -->
            <xsl:when test="contains($s, '&#xA;')">
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="concat(substring-before($s, '&#xA;'), '\n', substring-after($s, '&#xA;'))"/>
                </xsl:call-template>
            </xsl:when>
            <!-- carriage return -->
            <xsl:when test="contains($s, '&#xD;')">
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="concat(substring-before($s, '&#xD;'), '\r', substring-after($s, '&#xD;'))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$s"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
