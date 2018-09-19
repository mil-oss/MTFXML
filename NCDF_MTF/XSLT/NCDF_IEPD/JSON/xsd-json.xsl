<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="text" indent="yes"/>

    <!--
        This XSL Generates a JSON Representation of a W3C XML Schema
        for use by JSON aware frameworks.
        
        To run the XSL ensure that the xsdpath and xsdjson paths are correct
        and configure the XSL processor to use the 'main' template.
    -->

    <!-- 
    input:  /iepd/xml/xsd/iep.xsd
    output: /iepd/json/iep_xsd.json
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
        <xsl:apply-templates select="xs:schema/*"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="xs:simpleType">
        <xsl:value-of select="concat($q, @name, $q, $c, $lb)"/>
        <xsl:value-of select="concat($q, 'xsdnode', $q, $c, $q, substring-after(name(), ':'), $q)"/>
        <xsl:value-of select="$cm"/>
        <xsl:value-of select="concat($q, 'name', $q, $c, $q, @name, $q)"/>
        <xsl:value-of select="$cm"/>
        <xsl:variable name="doc">
            <xsl:call-template name="escape-bs-string">
                <xsl:with-param name="s" select="xs:annotation/xs:documentation"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat($q, 'documentation', $q, $c, $q, normalize-space($doc), $q)"/>
        <xsl:if test="xs:restriction/@base">
            <xsl:value-of select="$cm"/>
            <xsl:apply-templates select="xs:restriction/@base" mode="tojson"/>
        </xsl:if>
        <xsl:apply-templates select="xs:annotation/xs:appinfo" mode="tojson"/>
        <xsl:if test="xs:restriction/xs:enumeration">
            <xsl:value-of select="$cm"/>
            <xsl:value-of select="concat($q, 'enumerations', $q, $c, $lb)"/>
            <xsl:for-each select="xs:restriction/xs:enumeration">
                <xsl:value-of select="concat($q, @value, $q, $c, $lb)"/>
                <xsl:value-of select="concat($q, 'value', $q, $c, $q, @value, $q)"/>
                <xsl:if test="@dataitem">
                    <xsl:value-of select="concat($cm, $q, 'dataitem', $q, $c, $q, @dataitem, $q)"/>
                </xsl:if>
                <xsl:if test="xs:annotation/xs:documentation">
                    <xsl:variable name="edoc">
                        <xsl:call-template name="escape-bs-string">
                            <xsl:with-param name="s" select="xs:annotation/xs:documentation"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="concat($cm, $q, 'documentation', $q, $c, $q, normalize-space($edoc), $q)"/>
                </xsl:if>
                <xsl:value-of select="$rb"/>
                <xsl:if test="following-sibling::xs:enumeration">
                    <xsl:value-of select="$cm"/>
                </xsl:if>
            </xsl:for-each>
            <xsl:value-of select="$rb"/>
        </xsl:if>
        <xsl:if test="xs:restriction/*[@value][not(name() = 'xs:enumeration')]">
            <xsl:value-of select="$cm"/>
            <xsl:apply-templates select="xs:restriction/*[@value][not(name() = 'xs:enumeration')]" mode="tojson"/>
        </xsl:if>
        <xsl:value-of select="$rb"/>
        <xsl:if test="following-sibling::xs:*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xs:complexType">
        <xsl:value-of select="concat($q, @name, $q, $c, $lb)"/>
        <xsl:value-of select="concat($q, 'xsdnode', $q, $c, $q, substring-after(name(), ':'), $q)"/>
        <xsl:value-of select="$cm"/>
        <xsl:value-of select="concat($q, 'name', $q, $c, $q, @name, $q)"/>
        <xsl:value-of select="$cm"/>
        <xsl:variable name="doc">
            <xsl:call-template name="escape-bs-string">
                <xsl:with-param name="s" select="xs:annotation/xs:documentation"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat($q, 'documentation', $q, $c, $q, normalize-space($doc), $q)"/>
        <xsl:if test="xs:restriction/@base">
            <xsl:value-of select="$cm"/>
            <xsl:apply-templates select="xs:restriction/@base" mode="tojson"/>
        </xsl:if>
        <xsl:apply-templates select="xs:annotation/xs:appinfo" mode="tojson"/>
        <xsl:apply-templates select="xs:simpleContent/xs:extension/@base" mode="tojson"/>
        <xsl:apply-templates select="xs:simpleContent/xs:restriction/@base" mode="tojson"/>
        <xsl:if test="./*">
            <xsl:apply-templates select="*"/>
        </xsl:if>
        <xsl:value-of select="$rb"/>
        <xsl:if test="following-sibling::xs:*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xs:element">
        <xsl:value-of select="concat($q, @name, @ref, $q, $c, $lb)"/>
        <xsl:value-of select="concat($q, 'xsdnode', $q, $c, $q, substring-after(name(), ':'), $q, $cm)"/>
        <xsl:if test="not(@name) and not(@ref)">
            <xsl:value-of select="concat($q, 'name', $q, $c, $q, @name, $q)"/>
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:variable name="atts">
            <xsl:for-each select="@*">
                <json str="{concat($q, name(), $q, $c, $q, ., $q)}"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="exsl:node-set($atts)/*">
            <xsl:value-of select="@str"/>
            <xsl:if test="following-sibling::json">
                <xsl:value-of select="$cm"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="xs:annotation/xs:documentation">
            <xsl:value-of select="$cm"/>
            <xsl:variable name="doc">
                <xsl:call-template name="escape-bs-string">
                    <xsl:with-param name="s" select="xs:annotation/xs:documentation"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="concat($q, 'documentation', $q, $c, $q, normalize-space($doc), $q)"/>
        </xsl:if>
        <xsl:if test="xs:annotation/xs:appinfo">
            <xsl:apply-templates select="xs:annotation/xs:appinfo" mode="tojson"/>
        </xsl:if>
        <xsl:value-of select="$rb"/>
        <xsl:if test="following-sibling::xs:*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xs:*">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="xs:sequence">
        <xsl:value-of select="concat($q, 'sequence', $q, $c, $lb)"/>
        <xsl:apply-templates select="*"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="xs:choice">
        <xsl:value-of select="concat($q, 'choice', $q, $c, $lb)"/>
        <xsl:value-of select="concat($q, 'xsdnode', $q, $c, $q, 'choice', $q, $cm)"/>
        <xsl:apply-templates select="*"/>
        <xsl:value-of select="$rb"/>
        <xsl:if test="following-sibling::xs:*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@base" mode="tojson">
        <xsl:choose>
            <xsl:when test="contains(., ':')">
                <xsl:value-of select="concat($q, 'datatype', $q, $c, $q, substring-after(., ':'), $q)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($q, 'datatype', $q, $c, $q, ., $q)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xs:restriction/*[@value]" mode="tojson">
        <xsl:variable name="n" select="substring-after(name(), ':')"/>
        <xsl:choose>
            <xsl:when test="$n = 'pattern'">
                <xsl:variable name="regex">
                    <xsl:call-template name="escape-bs-string">
                        <xsl:with-param name="s" select="normalize-space(@value)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($q, 'pattern', $q, $c, $q, $regex, $q)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($q, $n, $q, $c, $q, @value, $q)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="following-sibling::xs:*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xs:appinfo" mode="tojson">
        <xsl:value-of select="concat($cm, $q, 'appinfo', $q, $c, $lb)"/>
        <xsl:variable name="p" select="position()"/>
        <xsl:for-each select="*">
            <xsl:variable name="inc">
                <xsl:if test="parent::xs:appinfo/preceding-sibling::xs:appinfo">
                    <xsl:value-of select="$p"/>
                </xsl:if>
            </xsl:variable>
            <xsl:value-of select="concat($q, name(), $inc, $q, $c, $lb)"/>
            <xsl:variable name="appatts">
                <xsl:for-each select="@*">
                    <xsl:variable name="txt">
                        <xsl:choose>
                            <xsl:when test="name() = 'comment'">
                                <xsl:call-template name="escape-bs-string">
                                    <xsl:with-param name="s" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <json str="{concat($q, name(), $q, $c, $q, $txt, $q)}"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each select="exsl:node-set($appatts)/*">
                <xsl:value-of select="@str"/>
                <xsl:if test="following-sibling::json">
                    <xsl:value-of select="$cm"/>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="name() = 'Choice'">
                <xsl:for-each select="*">
                    <xsl:value-of select="concat($q, @name, $inc, $q, $c, $lb)"/>
                    <xsl:variable name="atts">
                        <xsl:for-each select="@*">
                            <json str="{concat($q, name(), $q, $c, $q, ., $q)}"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:for-each select="$atts/*">
                        <xsl:value-of select="@str"/>
                        <xsl:if test="following-sibling::json">
                            <xsl:value-of select="$cm"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:value-of select="$rb"/>
                    <xsl:if test="following-sibling::*[@name]">
                        <xsl:value-of select="$cm"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="following-sibling::xs:*">
                <xsl:value-of select="$cm"/>
            </xsl:if>
            <xsl:value-of select="$rb"/>
        </xsl:for-each>
        <xsl:value-of select="$rb"/>
        <xsl:if test="parent::xs:annotation/following-sibling::*[not(@base)]">
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
