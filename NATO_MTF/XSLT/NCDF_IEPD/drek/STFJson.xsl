<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:stf="urn:nato:stf:annotations" xmlns:dfdl="http://www.ogf.org/dfdl/dfdl-1.0/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ded="urn:nato:tdl:link16ed6:ded:dfdl" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="text" indent="yes"/>

    <!--
    Document   : STF_Json.xsl
    Created    : December, 2016
    Author     : JD Neushul, james@neushul.net
    Description:
    
    This XSLT is a Utilty included by XSLT which generate JSON from STF 3.0 SML Schema
    for use in implmentation of JAvascript enabled Message and Documentation Viewers.
    
    It is used by STF_MTF_All_Json.xsl, STF_MTF_Consolidated_Json.xsl,STF_FFI_Json.xsl,
    and STF_Link16JsonMsgs.xsl, 
    -->


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

    <xsl:template match="*:restriction[*:enumeration]">
        <xsl:value-of select="concat($q, 'Enumerations', $q, $c, $lb)"/>
        <xsl:for-each select="*:enumeration">
            <xsl:variable name="lbl" select="position()"/>
            <xsl:value-of select="concat($q, $lbl, $q, $c, $lb)"/>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="*:annotation/*:appinfo/*">
                <xsl:value-of select="$cm"/>
                <xsl:apply-templates select="*:annotation/*:appinfo/*"/>
            </xsl:if>
            <xsl:value-of select="$rb"/>
            <xsl:if test="following-sibling::*:enumeration">
                <xsl:value-of select="$cm"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="*:appinfo" mode="stfenum">
        <xsl:value-of select="concat($q, 'Enumerations', $q, $c, $lb)"/>
        <xsl:for-each select="stf:enumeration">
            <xsl:if test="preceding-sibling::*:enumeration">
                <xsl:value-of select="$cm"/>
            </xsl:if>
            <xsl:variable name="pos" select="position()"/>
            <xsl:variable name="attribs">
                <xsl:for-each select="@*">
                    <att name="{name()}" value="{.}"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="concat($q, $pos, $q, $c, $lb)"/>
            <xsl:for-each select="$attribs/*">
                <xsl:if test="preceding-sibling::*">
                    <xsl:value-of select="$cm"/>
                </xsl:if>
                <xsl:value-of select="concat($q, @name, $q, $c, $q, @value, $q)"/>
            </xsl:for-each>
            <xsl:if test="*">
                <xsl:value-of select="$cm"/>
                <xsl:apply-templates select="*"/>
            </xsl:if>
            <xsl:value-of select="$rb"/>
        </xsl:for-each>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:value-of select="concat($q, name(), $q, $c, $q, ., $q)"/>
    </xsl:template>

    <xsl:template match="*:appinfo">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*:appinfo">
                <xsl:value-of select="concat($cm, $q, 'appinfo_', count(preceding-sibling::*:appinfo), $q, $c, $lb)"/>
                <xsl:apply-templates select="*"/>
                <xsl:value-of select="$rb"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($q, 'appinfo', $q, $c, $lb)"/>
                <xsl:apply-templates select="*"/>
                <xsl:value-of select="$rb"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="following-sibling::*:element">
                <xsl:value-of select="$cm"/>
            </xsl:when>
            <xsl:when test="following-sibling::*:sequence">
                <xsl:value-of select="$cm"/>
            </xsl:when>
            <xsl:when test="following-sibling::*:choice">
                <xsl:value-of select="$cm"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*:complexContent">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*:element">
                <xsl:value-of select="$cm"/>
            </xsl:when>
            <xsl:when test="preceding-sibling::*:sequence">
                <xsl:value-of select="$cm"/>
            </xsl:when>
            <xsl:when test="preceding-sibling::*:choice">
                <xsl:value-of select="$cm"/>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="*:extension">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="*:sequence">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*:element">
                <xsl:value-of select="$cm"/>
            </xsl:when>
            <xsl:when test="preceding-sibling::*:sequence">
                <xsl:value-of select="$cm"/>
            </xsl:when>
            <xsl:when test="preceding-sibling::*:choice">
                <xsl:value-of select="$cm"/>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="*:choice/*:sequence[xs:annotation/xs:appinfo/dfdl:discriminator]">
        <xsl:variable name="pos" select="position()"/>
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:value-of select="concat($q,$pos,$q,$c,$lb)"/>
        <xsl:apply-templates select="xs:annotation/xs:appinfo"/>
        <xsl:value-of select="$cm"/>
        <xsl:for-each select="*:element">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="*:choice/*:element[xs:annotation/xs:appinfo/dfdl:discriminator]">
        <xsl:variable name="pos" select="position()"/>
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:variable name="n" select="substring-after(@ref,':')"/>
        <xsl:value-of select="concat($q,$pos,$q,$c,$lb,$q,$n,$q,$c,$lb)"/>
        <xsl:apply-templates select="xs:annotation/xs:appinfo"/>
        <xsl:value-of select="$rb"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>
    
    <xsl:template match="*:choice[*[xs:annotation/xs:appinfo/dfdl:discriminator]]/*:element[not(xs:annotation)]">
        <xsl:variable name="pos" select="position()"/>
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:variable name="n" select="substring-after(@ref,':')"/>
        <xsl:value-of select="concat($q,$pos,$q,$c,$lb,$q,$n,$q,$c,$lb,$rb)"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="*:discriminator">
        <xsl:value-of select="concat($q, 'discriminator', $q, $c, $q, normalize-space(translate(., '{}', '')), $q)"/>
    </xsl:template>

    <xsl:template match="*:choice">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*:element">
                <xsl:value-of select="$cm"/>
            </xsl:when>
            <xsl:when test="preceding-sibling::*:sequence">
                <xsl:value-of select="$cm"/>
            </xsl:when>
            <xsl:when test="preceding-sibling::*:choice">
                <xsl:value-of select="$cm"/>
            </xsl:when>
        </xsl:choose>
        <xsl:variable name="dupkey">
            <xsl:if test="preceding-sibling::*:choice">
                <xsl:value-of select="concat('_', count(preceding-sibling::*:choice))"/>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="concat($q, 'Choice', $dupkey, $q, $c, $lb)"/>
        <xsl:apply-templates select="*:sequence | *:choice | *:element"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="*:element">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*:element">
                <xsl:value-of select="$cm"/>
            </xsl:when>
            <xsl:when test="preceding-sibling::*:sequence">
                <xsl:value-of select="$cm"/>
            </xsl:when>
            <xsl:when test="preceding-sibling::*:choice">
                <xsl:value-of select="$cm"/>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="@ref">
                <xsl:variable name="pos" select="position()"/>
                <xsl:variable name="n" select="@ref"/>
                <xsl:variable name="nm">
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::*[@ref = $n]">
                            <xsl:value-of select="concat(substring-after($n, ':'), '#', count(preceding-sibling::*[@ref = $n]))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring-after($n, ':')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat($q, $nm, $q, $c, $lb)"/>
                <xsl:if test="*:annotation/*:appinfo">
                    <xsl:apply-templates select="*:annotation/*:appinfo"/>
                </xsl:if>
                <xsl:apply-templates select="@dfdl:inputValueCalc"/>
                <xsl:value-of select="$rb"/>
            </xsl:when>
            <xsl:when test="*:complexType/*:sequence">
                <xsl:variable name="n" select="@name"/>
                <xsl:value-of select="concat($q, $n, $q, $c, $lb)"/>
                <xsl:if test="*:annotation/*:appinfo">
                    <xsl:apply-templates select="*:annotation/*:appinfo"/>
                    <xsl:value-of select="$cm"/>
                </xsl:if>
                <xsl:apply-templates select="*:complexType/*:sequence"/>
                <xsl:value-of select="$rb"/>
            </xsl:when>
            <xsl:when test="*:complexType/*:choice">
                <xsl:variable name="n" select="@name"/>
                <xsl:value-of select="concat($q, $n, $q, $c)"/>
                <xsl:if test="*:annotation/*:appinfo">
                    <xsl:value-of select="$lb"/>
                    <xsl:apply-templates select="*:annotation/*:appinfo"/>
                    <xsl:value-of select="$cm"/>
                </xsl:if>
                <xsl:apply-templates select="*:complexType/*:choice"/>
                <xsl:value-of select="$rb"/>
            </xsl:when>
            <xsl:when test="@type">
                <xsl:variable name="n" select="@name"/>
                <xsl:variable name="t">
                    <xsl:choose>
                        <xsl:when test="contains(@type, ':')">
                            <xsl:value-of select="substring-after(@type, ':')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@type"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat($q, $n, $q, $c, $lb)"/>
                <xsl:text>"appinfo":{</xsl:text>
                <xsl:value-of select="concat($q, 'Type', $q, $c, $q, $t, $q)"/>
                <xsl:if test="*:annotation/*:appinfo">
                    <xsl:value-of select="$cm"/>
                    <xsl:apply-templates select="*:annotation/*:appinfo/*"/>
                </xsl:if>
                <xsl:value-of select="$rb"/>
                <xsl:value-of select="$rb"/>
            </xsl:when>
            <xsl:when test="*:complexType/*/*:extension/@base">
                <xsl:variable name="b" select="*:complexType/*/*:extension/@base"/>
                <xsl:variable name="n" select="@name"/>
                <xsl:variable name="t">
                    <xsl:choose>
                        <xsl:when test="contains($b, ':')">
                            <xsl:value-of select="substring-after($b, ':')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$b"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat($q, $n, $q, $c, $lb)"/>
                <xsl:text>"appinfo":{</xsl:text>
                <xsl:value-of select="concat($q, 'Type', $q, $c, $q, $t, $q)"/>
                <xsl:if test="*:annotation/*:appinfo">
                    <xsl:value-of select="$cm"/>
                    <xsl:apply-templates select="*:annotation/*:appinfo/*"/>
                    <xsl:if test="*:complexType/*/*:extension/*:annotation/*:appinfo/*">
                        <xsl:value-of select="$cm"/>
                        <xsl:apply-templates select="*:complexType/*/*:extension/*:annotation/*:appinfo/*"/>
                    </xsl:if>
                    <!--MTF Specific .. add ID attributes from ffirnFudn attribute-->
                    <xsl:if test="*:complexType/*/*:extension/*:attribute[@name='ffirnFudn']">
                        <xsl:variable name="fifud" select="*:complexType/*/*:extension/*:attribute[@name='ffirnFudn']/@fixed"/>
                        <xsl:variable name="ffirn" select="substring-before(substring-after($fifud,'FF'),'-')"/>
                        <xsl:variable name="fud" select="substring-after($fifud,'-')"/>
                        <xsl:value-of select="concat($cm,$q, 'ID', $q, $c, $lb, $q,'FFIRN',$q,$c,$q,$ffirn,$q,$cm,$q,'FUD',$q,$c,$q,$fud,$q,$rb)"/>
                        <!--<xsl:value-of select="concat($cm,$q,'FIRNFUD',$q,$c,$q,*:complexType/*/*:extension/*:attribute[@name='ffirnFudn']/@fixed,$q)"/>-->
                    </xsl:if>
                    <xsl:value-of select="$rb"/>
                </xsl:if>
                <xsl:value-of select="$rb"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*:ID[*:CoiSpecific[@name = 'FUD']]">
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:value-of select="concat($q, 'ID', $q, $c, $lb)"/>
        <xsl:apply-templates select="*"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="stf:ID[ded:Dui]">
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:value-of select="concat($q, 'ID', $q, $c, $lb)"/>
        <xsl:call-template name="makeJsonFld">
            <xsl:with-param name="node" select="ded:Dfi"/>
        </xsl:call-template>
        <xsl:call-template name="makeJsonFld">
            <xsl:with-param name="node" select="ded:Dui"/>
        </xsl:call-template>
        <xsl:value-of select="$rb"/>
    </xsl:template>
    
    <xsl:template match="stf:ID[not(ded:Dui)][ded:Dfi]">
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:value-of select="concat($q, 'ID', $q, $c, $lb)"/>
        <xsl:call-template name="makeJsonFld">
            <xsl:with-param name="node" select="ded:Dfi"/>
        </xsl:call-template>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="stf:CoiSpecificSet">
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:variable name="n" select="@name"/>
        <xsl:choose>
            <xsl:when test="preceding-sibling::stf:CoiSpecificSet[@name = $n]">
                <xsl:variable name="cnt" select="count(preceding-sibling::stf:CoiSpecificSet[@name = $n])"/>
                <xsl:value-of select="concat($q, replace(@name, ' ', ''), '_', $cnt, $q, $c, $lb)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($q, replace(@name, ' ', ''), $q, $c, $lb)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="*"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="stf:CoiSpecific">
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="val">
            <xsl:call-template name="escape-bs-string">
                <xsl:with-param name="s" select="normalize-space(.)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="preceding-sibling::stf:CoiSpecific[@name = $n]">
                <xsl:variable name="cnt" select="count(preceding-sibling::stf:CoiSpecific[@name = $n])"/>
                <xsl:choose>
                    <xsl:when test="child::*">
                        <xsl:value-of select="concat($q, replace(@name, ' ', ''), '_', $cnt, $q, $c, $lb)"/>
                        <xsl:apply-templates select="*"/>
                        <xsl:value-of select="$rb"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($q, replace(@name, ' ', ''), '_', $cnt, $q, $c, $q, $val, $q)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="child::*">
                        <xsl:value-of select="concat($q, replace(@name, ' ', ''), $q, $c, $lb)"/>
                        <xsl:apply-templates select="*"/>
                        <xsl:value-of select="$rb"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($q, replace(@name, ' ', ''), $q, $c, $q, $val, $q)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*:minInclusive | *:maxInclusive">
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:call-template name="makeJsonFld">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="stf:*">
        <xsl:call-template name="makeJsonFld">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="makeJsonFld">
        <xsl:param name="node"/>
        <xsl:variable name="n" select="$node/name()"/>
        <xsl:variable name="cnt">
            <xsl:if test="preceding-sibling::*[name() = $n]">
                <xsl:value-of select="concat('_', count(preceding-sibling::*[name() = $n]))"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="val">
            <xsl:choose>
                <xsl:when test="$node/@*">
                    <xsl:value-of select="$node/@*"/>
                </xsl:when>
                <xsl:when test="$node = '\'">
                    <xsl:text>'\'</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="escape-bs-string">
                        <xsl:with-param name="s" select="normalize-space($node)"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$node/preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:value-of select="concat($q, substring-after($node/name(), ':'), $cnt, $q, $c, $q, $val, $q)"/>
    </xsl:template>

    <xsl:template match="@dfdl:hiddenGroupRef">
        <xsl:value-of select="concat($q, 'hiddenGroupRef', $q, $c, $q, ., $q)"/>
    </xsl:template>

    <xsl:template match="@dfdl:inputValueCalc">
        <xsl:value-of select="concat($q, 'inputValueCalc', $q, $c, $q, ., $q)"/>
    </xsl:template>

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
