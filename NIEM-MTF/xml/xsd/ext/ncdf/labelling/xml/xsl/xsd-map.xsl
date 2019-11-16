<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xs">
    <xsl:output method="xml" indent="yes"/>

    <xsl:include href="./configs.xsl"/>

    <xsl:variable name="xsdmap">
        <xsl:apply-templates select="$inputxsd/*:element[@name = $RootEl]" mode="map"/>
        <xsl:apply-templates select="$inputxsd/*[not(@name = $RootEl)]" mode="map"/>
    </xsl:variable>

    <xsl:template name="mapmain">
        <xsl:result-document href="{$outputmap}">
            <XSDMAP>
                <xsl:copy-of select="$xsdmap"/>
            </XSDMAP>
        </xsl:result-document>
    </xsl:template>


    <xsl:template match="*:element[@name]" mode="map">
        <xsl:variable name="origname" select="@name"/>
        <xsl:variable name="origtype">
            <xsl:choose>
                <xsl:when test="contains(@type, ':')">
                    <xsl:value-of select="substring-after(@type, ':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(@type, ':')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="parent">
            <xsl:choose>
                <xsl:when test="ancestor::*[@name][1]/@name">
                    <xsl:value-of select="ancestor::*[@name][1]/@name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>root</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="origdoc">
            <xsl:value-of select="normalize-space(*:annotation/*:documentation)"/>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <appinf>
                <xsl:apply-templates select="*:annotation/*:appinfo/*" mode="appinf"/>
            </appinf>
        </xsl:variable>
        <xsl:variable name="niemname">
            <xsl:apply-templates select="." mode="niemname">
                <xsl:with-param name="changeitem" select="$changes/Element[@origname = $origname][@parent = $parent]"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="niemtype">
            <xsl:choose>
                <xsl:when test="$changes/ComplexType[@origname = $origtype]">
                    <xsl:apply-templates select="." mode="niemtype">
                        <xsl:with-param name="changeitem" select="$changes/ComplexType[@origname = $origtype]"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="$parent">
                    <xsl:apply-templates select="." mode="niemtype">
                        <xsl:with-param name="changeitem" select="$changes/Element[@origname = $origname][@parent = $parent]"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="niemtype">
                        <xsl:with-param name="changeitem" select="$changes/Element[@origname = $origname]"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemdoc">
            <xsl:choose>
                <xsl:when test="$parent">
                    <xsl:apply-templates select="." mode="niemelementdoc">
                        <xsl:with-param name="changeitem" select="$changes/Element[@origname = $origname][@parent = $parent]"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="niemelementdoc">
                        <xsl:with-param name="changeitem" select="$changes/Element[@origname = $origname]"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Element origname="{$origname}" origtype="{$origtype}" parent="{$parent}" origdoc="{$origdoc}" niemname="{$niemname}" niemtype="{$niemtype}" niemdoc="{$niemdoc}">
            <xsl:copy-of select="@minOccurs"/>
            <xsl:copy-of select="@maxOccurs"/>
            <xsl:copy-of select="@minLength"/>
            <xsl:copy-of select="@maxLength"/>
            <xsl:if test="$appinfo">
                <xsl:copy-of select="$appinfo"/>
            </xsl:if>
            <xsl:apply-templates select="*" mode="map"/>
        </Element>
    </xsl:template>
    
    <xsl:template match="*:element[@ref]" mode="map">
        <xsl:variable name="origname" select="@ref"/>
        <xsl:variable name="origtype" select="$inputxsd/*/*[@name=$origname]/@type"/>
        <xsl:variable name="parent">
            <xsl:choose>
                <xsl:when test="ancestor::*[@name][1]/@name">
                    <xsl:value-of select="ancestor::*[@name][1]/@name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>root</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="origdoc">
            <xsl:value-of select="normalize-space(*:annotation/*:documentation)"/>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <appinf>
                <xsl:apply-templates select="*:annotation/*:appinfo/*" mode="appinf"/>
            </appinf>
        </xsl:variable>
        <xsl:variable name="niemname">
            <xsl:apply-templates select="." mode="niemname">
                <xsl:with-param name="changeitem" select="$changes/Element[@origname = $origname][@parent = $parent]"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="niemtype">
            <xsl:choose>
                <xsl:when test="$changes/ComplexType[@origname = $niemname]">
                    <xsl:apply-templates select="$origtype" mode="niemname">
                        <xsl:with-param name="changeitem" select="$changes/ComplexType[@origname = $origtype]"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="$parent">
                    <xsl:apply-templates select="." mode="niemname">
                        <xsl:with-param name="changeitem" select="$changes/Element[@origname = $origname][@parent = $parent]"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="niemname">
                        <xsl:with-param name="changeitem" select="$changes/Element[@origname = $origname]"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="niemdoc">
            <xsl:choose>
                <xsl:when test="$parent">
                    <xsl:apply-templates select="." mode="niemelementdoc">
                        <xsl:with-param name="changeitem" select="$changes/Element[@origname = $origname][@parent = $parent]"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="niemelementdoc">
                        <xsl:with-param name="changeitem" select="$changes/Element[@origname = $origname]"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Element origname="{$origname}" origtype="{$origtype}" parent="{$parent}" origdoc="{$origdoc}" niemname="{$niemname}" niemtype="{$niemtype}" niemdoc="{$niemdoc}">
            <xsl:copy-of select="@minOccurs"/>
            <xsl:copy-of select="@maxOccurs"/>
            <xsl:if test="$appinfo">
                <xsl:copy-of select="$appinfo"/>
            </xsl:if>
            <xsl:apply-templates select="*" mode="map"/>
        </Element>
    </xsl:template>

    <xsl:template match="*:complexType[@name]" mode="map">
        <xsl:variable name="origname" select="@name"/>
        <xsl:variable name="origbase" select="./*/*/@base"/>
        <xsl:variable name="origdoc">
            <xsl:value-of select="normalize-space(*:annotation/*:documentation)"/>
        </xsl:variable>
        <xsl:variable name="niemname">
            <xsl:apply-templates select="." mode="niemname">
                <xsl:with-param name="changeitem" select="$changes/ComplexType[@origname = $origname]"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="niembase">
            <xsl:apply-templates select="." mode="niemtype">
                <xsl:with-param name="changeitem" select="$changes/*[@origname = $origbase]"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <appinf>
                <xsl:apply-templates select="*:annotation/*:appinfo/*" mode="appinf"/>
            </appinf>
        </xsl:variable>
        <xsl:variable name="niemdoc">
            <xsl:apply-templates select="." mode="niemtypedoc">
                <xsl:with-param name="changeitem" select="$changes/ComplexType[@origname = $origname]"/>
            </xsl:apply-templates>
        </xsl:variable>
        <ComplexType origname="{$origname}" origbase="{$origbase}" origdoc="{$origdoc}" niemname="{$niemname}" niembase="{$niembase}" niemdoc="{$niemdoc}">
            <xsl:copy-of select="@minOccurs"/>
            <xsl:copy-of select="@maxOccurs"/>
            <xsl:if test="$appinfo">
                <xsl:copy-of select="$appinfo"/>
            </xsl:if>
            <xsl:apply-templates select="*" mode="map"/>
        </ComplexType>
    </xsl:template>

    <xsl:template match="*:complexType" mode="map">
        <xsl:apply-templates select="*" mode="map"/>
    </xsl:template>

    <xsl:template match="*:simpleType[@name]" mode="map">
        <xsl:variable name="origname" select="@name"/>
        <xsl:variable name="origbase" select="./*/*/@base"/>
        <xsl:variable name="origdoc">
            <xsl:value-of select="normalize-space(*:annotation/*:documentation)"/>
        </xsl:variable>
        <xsl:variable name="niemname">
            <xsl:apply-templates select="." mode="niemname">
                <xsl:with-param name="changeitem" select="$changes/SimpleType[@origname = $origname]"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="niembase">
            <xsl:apply-templates select="." mode="niemtype">
                <xsl:with-param name="changeitem" select="$changes/SimpleType[@origname = $origname]"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="appinfo">
            <appinf>
                <xsl:apply-templates select="*:annotation/*:appinfo/*" mode="appinf"/>
            </appinf>
        </xsl:variable>
        <xsl:variable name="niemdoc">
            <xsl:apply-templates select="." mode="niemtypedoc">
                <xsl:with-param name="changeitem" select="$changes/SimpleType[@origname = $origname]"/>
            </xsl:apply-templates>
        </xsl:variable>
        <SimpleType origname="{$origname}" origbase="{$origbase}" origdoc="{$origdoc}" niemname="{$niemname}" niembase="{$niembase}" niemdoc="{$niemdoc}">
            <xsl:if test="$appinfo">
                <xsl:copy-of select="$appinfo"/>
            </xsl:if>
            <xsl:apply-templates select="*" mode="map"/>
        </SimpleType>
    </xsl:template>

    <xsl:template match="*:simpleType" mode="map">
        <xsl:apply-templates select="*" mode="map"/>
    </xsl:template>

    <xsl:template match="*:sequence" mode="map">
        <Sequence>
            <xsl:copy-of select="@minOccurs"/>
            <xsl:copy-of select="@maxOccurs"/>
            <xsl:apply-templates select="*" mode="map"/>
        </Sequence>
    </xsl:template>

    <xsl:template match="*:choice" mode="map">
        <xsl:variable name="firstel" select="*:element[1]/@name"/>
        <xsl:variable name="changeitem" select="$changes/Choice[@firstel = $firstel]"/>
        <xsl:variable name="sgname">
            <xsl:choose>
                <xsl:when test="$changeitem/@substgroupname">
                    <xsl:value-of select="$changeitem/@substgroupname"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(*:element[1]/@niemname, 'Abstract')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Choice substitutionGroup="{$sgname}">
            <xsl:apply-templates select="*" mode="map"/>
        </Choice>
    </xsl:template>

    <xsl:template match="*:attribute" mode="map">
        <xsl:variable name="origname" select="@name"/>
        <xsl:variable name="origtype">
            <xsl:choose>
                <xsl:when test="contains(@type, 'xs:')">
                    <xsl:value-of select="@type"/>
                </xsl:when>
                <xsl:when test="contains(@type, ':')">
                    <xsl:value-of select="substring-after(@type, ':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(@type, ':')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="origdoc">
            <xsl:value-of select="normalize-space(*:annotation/*:documentation)"/>
        </xsl:variable>
        <xsl:variable name="niemname">
            <xsl:apply-templates select="." mode="niemname">
                <xsl:with-param name="changeitem" select="$changes/Attribute[@origname = $origname][@origtype = $origtype]"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="niemtype">
            <xsl:apply-templates select="." mode="niemattributetype">
                <xsl:with-param name="changeitem" select="$changes/Attribute[@origname = $origname][@origtype = $origtype]"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="niemdoc">
            <xsl:apply-templates select="." mode="niemattributedoc">
                <xsl:with-param name="changeitem" select="$changes/Attribute[@origname = $origname][@origtype = $origtype]"/>
            </xsl:apply-templates>
        </xsl:variable>
        <Attribute origname="{$origname}" origtype="{$origtype}" origdoc="{$origdoc}" niemname="{$niemname}" niemtype="{$niemtype}" niemdoc="{$niemdoc}">
            <xsl:copy-of select="@minOccurs"/>
            <xsl:copy-of select="@maxOccurs"/>
            <xsl:copy-of select="@use"/>
            <xsl:apply-templates select="*" mode="map"/>
        </Attribute>
    </xsl:template>

    <xsl:template match="*:anyAttribute" mode="map">
        <AnyAttribute/>
    </xsl:template>

    <xsl:template match="*:restriction" mode="map">
        <xsl:apply-templates select="*" mode="map"/>
    </xsl:template>

    <xsl:template match="*:enumeration" mode="map">
        <xsl:variable name="d">
            <xsl:choose>
                <xsl:when test="*:annotation/*:documentation/text()">
                    <xsl:value-of select="normalize-space(*:annotation/*:documentation/text())"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Enumeration value="{@value}" doc="{$d}"/>
    </xsl:template>

    <xsl:template match="*:pattern" mode="map">
        <Pattern value="{@value}"/>
    </xsl:template>
    
    <xsl:template match="*:minOccurs | *:maxOccurs | *:minLength | *:maxLength" mode="map">
        <xsl:element name="{name()}">
            <xsl:copy-of select="@value" copy-namespaces="no"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*:annotation" mode="map"/>

    <xsl:template match="text()" mode="map"/>

    <xsl:template match="*" mode="niemname">
        <xsl:param name="changeitem"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:variable name="n">
            <xsl:apply-templates select="@name | @ref" mode="basename"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$changeitem/@niemname">
                <xsl:value-of select="$changeitem/@niemname"/>
            </xsl:when>
            <xsl:when test="contains(name(), 'element')">
                <xsl:variable name="nn">
                    <xsl:call-template name="uppercase">
                        <xsl:with-param name="txt" select="$n"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains($t, 'string')">
                        <xsl:value-of select="concat($nn, 'Text')"/>
                    </xsl:when>
                    <xsl:when test="contains($t, 'normalizedString')">
                        <xsl:value-of select="concat($nn, 'Text')"/>
                    </xsl:when>
                    <xsl:when test="contains($t, 'URI')">
                        <xsl:value-of select="concat(replace($nn, 'Url', ''), 'URI')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$nn"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains(name(), 'attribute')">
                <xsl:value-of select="$n"/>
            </xsl:when>
            <xsl:when test="contains(name(), 'simpleType')">
                <xsl:choose>
                    <xsl:when test="ends-with($n, 'Type')">
                        <xsl:variable name="tn">
                            <xsl:call-template name="uppercase">
                                <xsl:with-param name="txt" select="substring($n, 0, string-length($n) - 3)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat($tn, 'SimpleType')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="ttn">
                            <xsl:call-template name="uppercase">
                                <xsl:with-param name="txt" select="$n"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat($ttn, 'SimpleType')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains(name(), 'complexType')">
                <xsl:choose>
                    <xsl:when test="ends-with(@name, 'Type')">
                        <xsl:call-template name="uppercase">
                            <xsl:with-param name="txt" select="@name"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="ttn">
                            <xsl:call-template name="uppercase">
                                <xsl:with-param name="txt" select="@name"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat($ttn, 'Type')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@*" mode="basename">
        <xsl:choose>
            <xsl:when test="contains(., 'xs:')">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:when test="contains(., ':')">
                <xsl:value-of select="substring-after(., ':')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="niemtype">
        <xsl:param name="changeitem"/>
        <xsl:variable name="t">
            <xsl:choose>
                <xsl:when test="@type">
                    <xsl:apply-templates select="@type" mode="basename"/>
                </xsl:when>
                <xsl:when test="./*/@base">
                    <xsl:apply-templates select="./*/@base" mode="basename"/>
                </xsl:when>
                <xsl:when test="./*/*/@base">
                    <xsl:apply-templates select="./*/*/@base" mode="basename"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$changeitem/@niembase">
                <xsl:value-of select="$changeitem/@niembase"/>
            </xsl:when>
            <xsl:when test="$changeitem/@niemtype">
                <xsl:value-of select="$changeitem/@niemtype"/>
            </xsl:when>
            <xsl:when test="$changeitem/@niemname">
                <xsl:value-of select="$changeitem/@niemname"/>
            </xsl:when>
            <xsl:when test="not($t)">
                <xsl:text>structures:ObjectType</xsl:text>
            </xsl:when>
            <xsl:when test="$t = 'xs:ID' and name() = 'xs:simpleType'">
                <xsl:text>xs:string</xsl:text>
            </xsl:when>
            <xsl:when test="$t = 'xs:ID'">
                <xsl:text>StringType</xsl:text>
            </xsl:when>
            <xsl:when test="$t = 'xs:string' and name() = 'xs:simpleType'">
                <xsl:text>xs:string</xsl:text>
            </xsl:when>
            <xsl:when test="$t = 'xs:string'">
                <xsl:text>StringType</xsl:text>
            </xsl:when>
            <xsl:when test="$t = 'xs:dateTime' and name() = 'xs:simpleType'">
                <xsl:text>xs:dateTime</xsl:text>
            </xsl:when>
            <xsl:when test="$t = 'xs:dateTime'">
                <xsl:text>DateTimeType</xsl:text>
            </xsl:when>
            <xsl:when test="$t = 'xs:token' and name() = 'xs:simpleType'">
                <xsl:text>xs:token</xsl:text>
            </xsl:when>
            <xsl:when test="$t = 'xs:token'">
                <xsl:text>TokenType</xsl:text>
            </xsl:when>
           
            <xsl:when test="$t = 'xs:normalizedString'">
                <xsl:text>NormalizedStringType</xsl:text>
            </xsl:when>
            <xsl:when test="$t = 'xs:anyURI'">
                <xsl:text>AnyURIType</xsl:text>
            </xsl:when>
            <xsl:when test="$t = 'xs:boolean'">
                <xsl:text>BooleanType</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="ends-with($t, 'Type')">
                        <xsl:variable name="tn">
                            <xsl:call-template name="uppercase">
                                <xsl:with-param name="txt" select="substring($t, 0, string-length($t) - 3)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="contains(name(),'simpleType')">
                                <xsl:value-of select="concat($tn, 'SimpleType')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($tn, 'Type')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="ttn">
                            <xsl:call-template name="uppercase">
                                <xsl:with-param name="txt" select="$t"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$ttn=''">
                                <xsl:text>structures:ObjectType</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($ttn, 'Type')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="niemattributetype">
        <xsl:param name="changeitem"/>
        <xsl:choose>
            <xsl:when test="$changeitem/@niemtype">
                <xsl:value-of select="$changeitem/@niemtype"/>
            </xsl:when>
            <xsl:when test="@type | ./*/*/@base = 'xs:ID'">
                <xsl:text>StringSimpleType</xsl:text>
            </xsl:when>
            <xsl:when test="@type | ./*/*/@base = 'xs:string'">
                <xsl:text>StringSimpleType</xsl:text>
            </xsl:when>
            <xsl:when test="@type | ./*/*/@base = 'xs:integer'">
                <xsl:text>IntegerSimpleType</xsl:text>
            </xsl:when>
            <xsl:when test="@type | ./*/*/@base = 'xs:dateTime'">
                <xsl:text>DateTimeSimpleType</xsl:text>
            </xsl:when>
            <xsl:when test="@type | ./*/*/@base = 'xs:normalizedString'">
                <xsl:text>NormalizedStringSimpleType</xsl:text>
            </xsl:when>
            <xsl:when test="@type | ./*/*/@base = 'xs:anyURI'">
                <xsl:text>AnyURISimpleType</xsl:text>
            </xsl:when>
            <xsl:when test="@type | ./*/*/@base = 'xs:boolean'">
                <xsl:text>BooleanSimpleType</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="ends-with(@type | ./*/*/@base, 'Type')">
                        <xsl:variable name="tn">
                            <xsl:call-template name="uppercase">
                                <xsl:with-param name="txt" select="substring(replace(@type | ./*/*/@base, 'bom:', ''), 0, string-length(replace(@type | ./*/*/@base, 'bom:', '')) - 3)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat($tn, 'SimpleType')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="ttn">
                            <xsl:call-template name="uppercase">
                                <xsl:with-param name="txt" select="replace(@type | ./*/*/@base, 'bom:', '')"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat($ttn, 'SimpleType')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="niemtypedoc">
        <xsl:param name="changeitem"/>
        <xsl:choose>
            <xsl:when test="$changeitem/@niemtypedoc">
                <xsl:value-of select="$changeitem/@niemtypedoc"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="doctxt">
                    <xsl:choose>
                        <xsl:when test="string-length(normalize-space(*:annotation/*:documentation))!=0">
                            <xsl:call-template name="lowercase">
                                <xsl:with-param name="txt" select="normalize-space(*:annotation/*:documentation)"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="breakIntoWords">
                                <xsl:with-param name="string" select="@name"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="normalize-space(concat('A data type for ', $doctxt))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="niemelementdoc">
        <xsl:param name="changeitem"/>
        <xsl:choose>
            <xsl:when test="$changeitem/@niemelementdoc">
                <xsl:value-of select="$changeitem/@niemelementdoc"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="doctxt">
                    <xsl:choose>
                        <xsl:when test="string-length(normalize-space(*:annotation/*:documentation))!=0">
                            <xsl:call-template name="lowercase">
                                <xsl:with-param name="txt" select="normalize-space(*:annotation/*:documentation)"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="breakIntoWords">
                                <xsl:with-param name="string">
                                    <xsl:apply-templates select="@name | @ref" mode="basename"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="normalize-space(concat('A data item for ', $doctxt))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="niemattributedoc">
        <xsl:param name="changeitem"/>
        <xsl:choose>
            <xsl:when test="$changeitem/@niemattributedoc">
                <xsl:value-of select="$changeitem/@niemattributedoc"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="doctxt">
                    <xsl:choose>
                        <xsl:when test="string-length(normalize-space(*:annotation/*:documentation))!=0">
                            <xsl:call-template name="lowercase">
                                <xsl:with-param name="txt" select="normalize-space(*:annotation/*:documentation)"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="breakIntoWords">
                                <xsl:with-param name="string" select="@name"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="normalize-space(concat('A data item for ', $doctxt))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="CamelCase">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text, ' ')">
                <xsl:call-template name="CamelCaseWord">
                    <xsl:with-param name="text" select="substring-before($text, ' ')"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="CamelCase">
                    <xsl:with-param name="text" select="substring-after($text, ' ')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="CamelCaseWord">
                    <xsl:with-param name="text" select="$text"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="CamelCaseWord">
        <xsl:param name="text"/>
        <xsl:value-of select="translate(substring($text, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        <xsl:value-of select="translate(substring($text, 2, string-length($text) - 1), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
    </xsl:template>
    
    <xsl:template name="breakIntoWords">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="contains($string,'ID')">
                <xsl:value-of select="concat('ID ',substring-after($string,'ID'))"/>
            </xsl:when>
            <xsl:when test="contains($string,'URI')">
                <xsl:value-of select="concat('URI ',substring-after($string,'URI'))"/>
            </xsl:when>
            <xsl:when test="string-length($string) &lt; 2">
                <xsl:value-of select="$string"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="breakIntoWordsHelper">
                    <xsl:with-param name="string" select="$string"/>
                    <xsl:with-param name="token" select="substring($string, 1, 1)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="breakIntoWordsHelper">
        <xsl:param name="string" select="''"/>
        <xsl:param name="token" select="''"/>
        <xsl:choose>
            <xsl:when test="string-length($string) = 0"/>
            <xsl:when test="string-length($token) = 0"/>
            <xsl:when test="string-length($string) = string-length($token)">
                <xsl:value-of select="$token"/>
            </xsl:when>
            <xsl:when test="contains('ABCDEFGHIJKLMNOPQRSTUVWXYZ', substring($string, string-length($token) + 1, 1))">
                <xsl:value-of select="concat($token, ' ')"/>
                <xsl:call-template name="breakIntoWordsHelper">
                    <xsl:with-param name="string" select="substring-after($string, $token)"/>
                    <xsl:with-param name="token" select="substring($string, string-length($token), 1)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="breakIntoWordsHelper">
                    <xsl:with-param name="string" select="$string"/>
                    <xsl:with-param name="token" select="substring($string, 1, string-length($token) + 1)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="uppercase">
        <xsl:param name="txt"/>
        <xsl:value-of select="translate(substring($txt, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        <xsl:value-of select="substring($txt, 2, string-length($txt) - 1)"/>
    </xsl:template>

    <xsl:template name="lowercase">
        <xsl:param name="txt"/>
        <xsl:value-of select="translate($txt, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
    </xsl:template>

</xsl:stylesheet>
