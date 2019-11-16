<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="text" indent="yes"/>
    <!--
        This XSL Generates a JSON Representation of the SEVA Implementation
        Schema for use by JSON aware frameworks.
        
        To run the XSL ensure that the sevaNiemXsd and sevaJson paths are correct
        and configure the XSL processor to use the 'main' template.
    -->
    <xsl:variable name="xsd" select="document('../../../XSD/NIEM_IEPD/MILSTD_MTF/SepMsgs/ABSTAT.xsd')"/>
    <xsl:variable name="json" select="'../../../XSD/NIEM_IEPD/JSON/ABSTAT.json'"/>

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

    <xsl:template name="main">
        <xsl:result-document href="{$json}">
            <xsl:value-of select="$lb"/>
            <xsl:apply-templates select="$xsd/*:schema/*:complexType[@name = 'AirBaseStatusReportType']">
                <xsl:with-param name="el" select="'AirBaseStatusReport'"/>
            </xsl:apply-templates>
            <!--<xsl:value-of select="$rb"/>-->
        </xsl:result-document>
    </xsl:template>

    <!--    <xsl:template match="/">
        <xsl:value-of select="$lb"/>
            <xsl:apply-templates select="*:schema/*:complexType[@name = 'SoftwareEvidenceArchiveType']">
                <xsl:with-param name="el" select="'SoftwareEvidenceArchive'"/>
            </xsl:apply-templates>
            <xsl:value-of select="$rb"/>
    </xsl:template>-->

    <xsl:template match="*:complexType">
        <xsl:param name="el"/>
        <xsl:param name="elnode"/>
        <xsl:param name="pos"/>
        <xsl:variable name="e" select="ancestor::*:schema/*:element[@name = $el]"/>
        <xsl:variable name="doc">
            <xsl:call-template name="escape-quot-string">
                <xsl:with-param name="s" select="normalize-space($e/*:annotation/*:documentation)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="n" select="$e/@name"/>
        <xsl:choose>
            <xsl:when test="string-length(string($pos))&gt;0">
                <xsl:value-of select="concat($q, $pos, $q, $c, $lb)"/>
            </xsl:when>
            <xsl:otherwise>
                <!--<xsl:value-of select="concat($q, $n, $q, $c, $lb)"/>-->
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="concat($q, 'name', $q, $c, $q, $n, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'documentation', $q, $c, $q, $doc, $q)"/>
        <xsl:if test="$elnode">
            <xsl:if test="$elnode/@minOccurs">
                <xsl:value-of select="concat($cm, $q, 'minOccurs', $q, $c, $q, $elnode/@minOccurs, $q)"/>
            </xsl:if>
            <xsl:if test="$elnode/@maxOccurs">
                <xsl:value-of select="concat($cm, $q, 'maxOccurs', $q, $c, $q, $elnode/@maxOccurs, $q)"/>
            </xsl:if>
        </xsl:if>
        <xsl:if test="*:simpleContent/*:extension/@base">
            <xsl:variable name="b" select="*:simpleContent/*:extension/@base"/>
            <xsl:variable name="styp" select="ancestor::*:schema/*:simpleType[@name = $b]"/>
            <xsl:if test="$b = '*:float'">
                <xsl:value-of select="concat($cm, $q, 'datatype', $q, $c, $q, substring-after($b, ':'), $q)"/>
            </xsl:if>
            <xsl:if test="$styp/*:restriction/*:enumeration">
                <xsl:value-of select="concat($cm, $q, 'Enumerations', $q, $c, $lb)"/>
                <xsl:for-each select="$styp/*:restriction/*:enumeration">
                    <xsl:variable name="p" select="count(preceding-sibling::*:enumeration)"/>
                    <xsl:variable name="edoc">
                        <xsl:call-template name="escape-quot-string">
                            <xsl:with-param name="s" select="normalize-space(*:annotation/*:documentation)"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="concat($q, $p, $q, $c, $lb, $q, 'value', $q,$c,$q, @value, $q,$cm,$q,'documentation', $q,$c,$q, $edoc, $q,$rb)"/>
                    <xsl:if test="following-sibling::*:enumeration">
                        <xsl:value-of select="$cm"/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:value-of select="$rb"/>
            </xsl:if>
            <xsl:if test="$styp/*:restriction/*:pattern">
                <xsl:variable name="regex">
                    <xsl:call-template name="escape-bs-string">
                        <xsl:with-param name="s" select="normalize-space($styp/*:restriction/*:pattern/@value)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($cm, $q, 'datatype', $q, $c, $q, substring-after($styp/*:restriction/@base, ':'), $q)"/>
                <xsl:value-of select="concat($cm, $q, 'regex', $q, $c, $q, $regex, $q)"/>
            </xsl:if>
        </xsl:if>
        <xsl:if test=".//*:element">
            <xsl:value-of select="$cm"/>
            <xsl:apply-templates select="*" mode="ref"/>
        </xsl:if>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="*:element[@name]" mode="ref">
        <xsl:param name="elnode"/>
        <xsl:param name="pos"/>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:apply-templates select="ancestor::*:schema/*[@name = $t]">
            <xsl:with-param name="el" select="$n"/>
            <xsl:with-param name="elnode" select="$elnode"/>
            <xsl:with-param name="pos" select="$pos"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*:element[@ref]" mode="ref">
        <xsl:variable name="p" select="count(preceding-sibling::*:element)"/>
        <xsl:variable name="r" select="@ref"/>
        <xsl:apply-templates select="ancestor::*:schema/*:element[@name = $r]" mode="ref">
            <xsl:with-param name="pos" select="$p"/>
            <xsl:with-param name="elnode" select="."/>
        </xsl:apply-templates>
        <xsl:if test="following-sibling::*:element">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:choice" mode="ref">
        <xsl:value-of select="concat($q, 'Choice', $q, $c, $lb)"/>
        <xsl:if test="@minOccurs">
            <xsl:value-of select="concat($q, 'minOccurs', $q, $c, $q,@minOccurs, $q)"/>
        </xsl:if>
        <xsl:if test="@maxOccurs">
            <xsl:value-of select="concat($cm, $q, 'maxOccurs', $q, $c, $q, @maxOccurs, $q,$cm)"/>
        </xsl:if>
        <xsl:apply-templates select="*" mode="ref"/>
        <xsl:value-of select="$rb"/>
        <xsl:if test="following-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="ref">
        <xsl:apply-templates select="*" mode="ref"/>
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
