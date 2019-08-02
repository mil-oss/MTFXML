<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="fixrules6040B"
        select="document('../../XSD/Analysis/Rules/fixrules6040B.xml')/FixRules"/>

    <xsl:variable name="mtfrules6040C"
        select="document('../../XSD/Analysis/Rules/mtf-rules-6040C.xml')/MTFRules"/>

    <xsl:variable name="fixrules6040C">
        <xsl:apply-templates select="$fixrules6040B/*" mode="convert"/>
    </xsl:variable>

    <xsl:variable name="fixrules6040C-Out" select="'../../XSD/Analysis/Rules/fixrules6040C.xml'"/>

    <xsl:variable name="msgmaps"
        select="document('../../XSD/NIEM_MTF/refxsd/maps/usmtf-msgsmaps.xml')/*"/>
    <xsl:variable name="segmaps"
        select="document('../../XSD/NIEM_MTF/refxsd/maps/usmtf-segmntmaps.xml')/*"/>
    <xsl:variable name="setmaps"
        select="document('../../XSD/NIEM_MTF/refxsd/maps/usmtf-setmaps.xml')/*"/>

    <xsl:variable name="a" select='"&apos;"'/>

    <xsl:template name="main">
        <xsl:result-document href="{$fixrules6040C-Out}">
            <FixRules xmlns:sch="http://purl.oclc.org/dsdl/schematron">
                <xsl:copy-of select="$fixrules6040C"/>
            </FixRules>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*" mode="convert">
        <xsl:variable name="r" select="@rtxt"/>
        <xsl:variable name="c" select="@context"/>
        <!--<xsl:if test="not(@niempath)">-->
        <xsl:variable name="namelist">
            <xsl:for-each select="$mtfrules6040C/Rule[@txt = $r]/*[@mtfname]">
                <Element mtfname="{@mtfname}" niemname="{@niemname}"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="niemcontxt">
            <xsl:variable name="c" select="@context"/>
            <xsl:choose>
                <xsl:when test="contains($c, '/')">
                    <xsl:call-template name="niempath">
                        <xsl:with-param name="pth" select="$c"/>
                        <xsl:with-param name="namelist" select="$namelist"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$namelist/*[@mtfname = $c]">
                    <xsl:value-of select="$namelist/*[@mtfname = $c][1]/@niemname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$c"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemxpath">
            <xsl:variable name="p" select="@xpath"/>
            <xsl:for-each select="tokenize(@xpath, ' ')">
                <xsl:variable name="s" select="normalize-space(.)"/>
                <xsl:choose>
                    <xsl:when test="$namelist/*[@mtfname = $s]">
                        <xsl:value-of select="$namelist/*[@mtfname = $s][1]/@niemname"/>
                    </xsl:when>
                    <xsl:when test="starts-with($s, 'count(')">
                        <xsl:variable name="en"
                            select="substring-before(substring-after($s, 'count('), ')')"/>
                        <xsl:choose>
                            <xsl:when test="contains($en, '/')">
                                <xsl:call-template name="niempath">
                                    <xsl:with-param name="pth" select="$en"/>
                                    <xsl:with-param name="namelist" select="$namelist"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$namelist/*[@mtfname = $en]">
                                        <xsl:value-of
                                            select="concat('count(', $namelist/*[@mtfname = $en][1]/@niemname, ')')"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('count(', $en, ')')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="starts-with($s, 'not(')">
                        <xsl:variable name="en"
                            select="substring-before(substring-after($s, 'not('), ')')"/>
                        <xsl:text>not(</xsl:text>
                        <xsl:choose>
                            <xsl:when test="contains($en, '/')">
                                <xsl:call-template name="niempath">
                                    <xsl:with-param name="pth" select="$en"/>
                                    <xsl:with-param name="namelist" select="$namelist"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$namelist/*[@mtfname = $en]">
                                        <xsl:value-of
                                            select="$namelist/*[@mtfname = $en][1]/@niemname"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$en"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>)</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains($s, '/')">
                        <xsl:call-template name="niempath">
                            <xsl:with-param name="pth" select="$s"/>
                            <xsl:with-param name="namelist" select="$namelist"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="starts-with($s, $a)">
                        <xsl:value-of select="$s"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(' ', $s, ' ')"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="m" select="@msg"/>
        <xsl:copy>
            <xsl:copy-of select="@msg"/>
            <xsl:copy-of select="@context"/>
            <xsl:copy-of select="@rtxt"/>
            <xsl:copy-of select="@xpath"/>
            <xsl:attribute name="niemcontext">
                <xsl:value-of select="$niemcontxt"/>
            </xsl:attribute>
            <xsl:attribute name="niemxpath">
                <xsl:value-of select="normalize-space($niemxpath)"/>
            </xsl:attribute>
            <xsl:copy-of select="$mtfrules6040C/Rule[@msg = $m][@txt = $r]"/>
        </xsl:copy>
        <!--</xsl:if>-->
    </xsl:template>

    <xsl:template name="niempath">
        <xsl:param name="pth"/>
        <xsl:param name="namelist"/>
        <xsl:for-each select="tokenize($pth, '/')">
            <xsl:variable name="e" select="."/>
            <xsl:if test="position() != 1">
                <xsl:text>/</xsl:text>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$namelist/*[@mtfname = $e]">
                    <xsl:value-of select="$namelist/*[@mtfname = $e][1]/@niemname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$e"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*" mode="addniemname">
        <xsl:copy>
            <xsl:copy-of select="@mtfname"/>
            <xsl:variable name="pname">
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[@mtfname]">
                        <xsl:value-of select="preceding-sibling::*[@mtfname][1]/@mtfname"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="parent::Rule/@msg"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!--<xsl:attribute name="parentname" select="$pname"/>-->
            <xsl:attribute name="niemname">
                <xsl:call-template name="niemchg">
                    <xsl:with-param name="mname" select="@mtfname"/>
                    <xsl:with-param name="pname" select="$pname"/>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    <xsl:template name="niemchg">
        <xsl:param name="mname"/>
        <xsl:param name="pname"/>
        <xsl:choose>
            <xsl:when test="$msgmaps//Element[@mtfname = $mname][@messagename = $pname]">
                <xsl:value-of
                    select="$msgmaps//Element[@mtfname = $mname][@messagename = $pname]/@niemelementname"
                />
            </xsl:when>
            <xsl:when test="$segmaps//Element[@mtfname = $mname][@segmentname = $pname]">
                <xsl:value-of
                    select="$segmaps//Element[@mtfname = $mname][@segmentname = $pname]/@niemelementname"
                />
            </xsl:when>
            <xsl:when test="$setmaps//Element[@mtfname = $mname][@setname = $pname]">
                <xsl:value-of
                    select="$setmaps//Element[@mtfname = $mname][@setname = $pname]/@niemelementname"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$mname"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
