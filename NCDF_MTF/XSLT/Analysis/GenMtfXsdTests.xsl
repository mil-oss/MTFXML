<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" exclude-result-prefixes="xsd mtfappinfo" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="baselinepath" select="'../../XSD/Baseline_Schema/SepMsg/_Maps/'"/>
    <xsl:variable name="baseline_msgs_xsd" select="document('../../XSD/Baseline_Schema/messages.xsd')"/>

    <xsl:variable name="outdir" select="'../../XSD/Baseline_Schema/MTF_Schema_Tests/'"/>

    <xsl:variable name="apos" select='"&apos;"'/>
    <xsl:variable name="apos2" select='"&apos;&apos;"'/>

    <xsl:template name="main">
        <xsl:call-template name="MessageTests"/>
    </xsl:template>

    <xsl:variable name="AllMessageTests">
        <xsl:for-each select="$baseline_msgs_xsd/xsd:schema/xsd:element[xsd:annotation/xsd:appinfo/*:MtfName]">
            <xsl:variable name="msgid" select="./xsd:annotation/xsd:appinfo/*:MtfIdentifier"/>
            <xsl:variable name="mid" select="translate($msgid, ' .:()', '')"/>
            <xsl:variable name="mtfname">
                <xsl:value-of select="xsd:annotation/xsd:appinfo/*:MtfName"/>
            </xsl:variable>
            <xsl:variable name="msgidentifier" select="concat('xsd:annotation/xsd:appinfo/*:Msg/@identifier=', $apos, $msgid, $apos)"/>
            <xsl:variable name="baselinemsgmap" select="document(concat($baselinepath, $mid, '_BaselineMap.xml'))"/>
            <xsl:variable name="msgTests">
                <xsl:apply-templates select="$baselinemsgmap/*/Message"/>
                <xsl:apply-templates select="$baselinemsgmap/*/Sets/Set"/>
                <xsl:apply-templates select="$baselinemsgmap/*/Composites/Composite"/>
                <xsl:apply-templates select="$baselinemsgmap/*/Fields/Field"/>
            </xsl:variable>
            <xsl:variable name="msgTestsFltr">
                <xsl:for-each select="$msgTests/*[contains(@context, '*:Msg')]">
                    <xsl:sort select="@context"/>
                    <xsl:variable name="c" select="@context"/>
                    <xsl:if test="count(preceding-sibling::*[@context = $c]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$msgTests/*[contains(@context, '*:Segment')]">
                    <xsl:sort select="@context"/>
                    <xsl:variable name="c" select="@context"/>
                    <xsl:if test="count(preceding-sibling::*[@context = $c]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$msgTests/*[contains(@context, '*:Set')]">
                    <xsl:sort select="@context"/>
                    <xsl:variable name="c" select="@context"/>
                    <xsl:if test="count(preceding-sibling::*[@context = $c]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$msgTests/*[contains(@context, '*:Composite')]">
                    <xsl:sort select="@context"/>
                    <xsl:variable name="c" select="@context"/>
                    <xsl:if test="count(preceding-sibling::*[@context = $c]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$msgTests/*[contains(@context, '*:Field')]">
                    <xsl:sort select="@context"/>
                    <xsl:variable name="c" select="@context"/>
                    <xsl:if test="count(preceding-sibling::*[@context = $c]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <sch:pattern id="{$mid}">
                <sch:rule context="xsd:schema">
                    <sch:assert test="{$msgidentifier}">Schema Mis-Match</sch:assert>
                    <xsl:for-each select="$msgTests/*[contains(@context, '*:Msg')]">
                        <sch:assert test="{substring-after(@context,'xsd:schema/')}">
                            <xsl:value-of select="concat('Missing Node: ', @context)"/>
                        </sch:assert>
                    </xsl:for-each>
                    <xsl:for-each select="$msgTests/*[contains(@context, '*:Segment')]">
                        <sch:assert test="{substring-after(@context,'xsd:schema/')}">
                            <xsl:value-of select="concat('Missing Node: ', @context)"/>
                        </sch:assert>
                    </xsl:for-each>
                    <xsl:for-each select="$msgTests/*[contains(@context, '*:Set')]">
                        <sch:assert test="{substring-after(@context,'xsd:schema/')}">
                            <xsl:value-of select="concat('Missing Node: ', @context)"/>
                        </sch:assert>
                    </xsl:for-each>
                    <xsl:for-each select="$msgTests/*[contains(@context, '*:Composite')]">
                        <sch:assert test="{substring-after(@context,'xsd:schema/')}">
                            <xsl:value-of select="concat('Missing Node: ', @context)"/>
                        </sch:assert>
                    </xsl:for-each>
                    <xsl:for-each select="$msgTests/*[contains(@context, '*:Field')]">
                        <sch:assert test="{substring-after(@context,'xsd:schema/')}">
                            <xsl:value-of select="concat('Missing Node: ', @context)"/>
                        </sch:assert>
                    </xsl:for-each>
                </sch:rule>
                <xsl:for-each select="$msgTestsFltr/*[contains(@context, '*:Msg')]">
                    <xsl:sort select="@context"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$msgTestsFltr/*[contains(@context, '*:Segment')]">
                    <xsl:sort select="@context"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$msgTestsFltr/*[contains(@context, '*:Set')]">
                    <xsl:sort select="@context"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$msgTestsFltr/*[contains(@context, '*:Composite')]">
                    <xsl:sort select="@context"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$msgTestsFltr/*[contains(@context, '*:Field')]">
                    <xsl:sort select="@context"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </sch:pattern>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template name="MessageTests">
        <xsl:for-each select="$AllMessageTests/*">
            <xsl:result-document href="{concat($outdir,@id,'.sch')}">
                <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </sch:schema>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*[appinfo/*:Msg]">
        <xsl:if test="appinfo/*:Msg/@mtfid">
            <sch:rule context="{@path}">
                <sch:assert test="exists(.)">
                    <xsl:value-of select="concat('Missing Node: ', @path)"/>
                </sch:assert>
                <xsl:apply-templates select="@*" mode="nodeschrule"/>
                <xsl:apply-templates select="appinfo/*:Msg/@*" mode="infoschrule">
                    <xsl:with-param name="attpath" select="'/*:Msg/@'"/>
                </xsl:apply-templates>
            </sch:rule>
            <xsl:apply-templates select="*"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[appinfo/*:Segment]">
        <xsl:variable name="segpath">
            <xsl:call-template name="testPath">
                <xsl:with-param name="p" select="@path"/>
            </xsl:call-template>
        </xsl:variable>
        <sch:rule context="{$segpath}">
            <sch:assert test="exists(.)">
                <xsl:value-of select="concat('Missing Node: ', $segpath)"/>
            </sch:assert>
            <xsl:apply-templates select="@*" mode="nodeschrule"/>
            <xsl:apply-templates select="appinfo/*:Segment/@*" mode="infoschrule">
                <xsl:with-param name="attpath" select="'/*:Segment/@'"/>
            </xsl:apply-templates>
        </sch:rule>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="*[appinfo/*:Set]">
        <xsl:variable name="setpath">
            <xsl:call-template name="testPath">
                <xsl:with-param name="p" select="@path"/>
            </xsl:call-template>
        </xsl:variable>
        <sch:rule context="{$setpath}">
            <xsl:apply-templates select="@*" mode="nodeschrule"/>
            <xsl:apply-templates select="appinfo/*:Set/@*" mode="infoschrule">
                <xsl:with-param name="attpath" select="'/*:Set/@'"/>
            </xsl:apply-templates>
        </sch:rule>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="*[appinfo/Composite]">
        <xsl:variable name="cpath">
            <xsl:call-template name="testPath">
                <xsl:with-param name="p" select="@path"/>
            </xsl:call-template>
        </xsl:variable>
        <sch:rule context="{$cpath}">
            <xsl:apply-templates select="@*" mode="nodeschrule"/>
            <xsl:apply-templates select="appinfo/Composite/@*" mode="infoschrule">
                <xsl:with-param name="attpath" select="'/*:Composite/@'"/>
            </xsl:apply-templates>
        </sch:rule>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="*[appinfo/Field]">
        <xsl:variable name="fpath">
            <xsl:call-template name="testPath">
                <xsl:with-param name="p" select="@path"/>
            </xsl:call-template>
        </xsl:variable>
        <sch:rule context="{$fpath}">
            <xsl:apply-templates select="@*" mode="nodeschrule"/>
            <xsl:apply-templates select="appinfo/Field/@*" mode="infoschrule">
                <xsl:with-param name="attpath" select="'/*:Field/@'"/>
            </xsl:apply-templates>
        </sch:rule>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="Element">
        <xsl:variable name="annot" select="appinfo/*/@name"/>
        <xsl:variable name="elpath">
            <xsl:call-template name="testPath">
                <xsl:with-param name="p" select="@path"/>
            </xsl:call-template>
        </xsl:variable>
        <sch:rule context="{$elpath}">
            <sch:assert test="exists(.)">
                <xsl:value-of select="concat('Missing Node: ', $elpath)"/>
            </sch:assert>
            <xsl:apply-templates select="@*" mode="nodeschrule"/>
            <xsl:apply-templates select="appinfo/Field/@*" mode="infoschrule">
                <xsl:with-param name="attpath" select="concat('appinfo/', '*', $annot, '/@')"/>
            </xsl:apply-templates>
        </sch:rule>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="Sequence">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="Choice">
        <xsl:variable name="chpath">
            <xsl:call-template name="testPath">
                <xsl:with-param name="p" select="@path"/>
            </xsl:call-template>
        </xsl:variable>
        <sch:rule context="{$chpath}">
            <sch:assert test="@substitutionGroup">
                <xsl:value-of select="concat('Missing Choice/SubGroup ', $chpath)"/>
            </sch:assert>
            <xsl:apply-templates select="@*" mode="nodeschrule"/>
        </sch:rule>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template name="testPath">
        <xsl:param name="p"/>
        <xsl:variable name="tpth">
        <xsl:value-of select="translate(@path,'xsd:appinfo xsd:extension xsd:complexContent xsd:simpleContent','*')"/>
        </xsl:variable>
            <xsl:choose>
                <xsl:when test="starts-with($tpth, 'xsd:schema/xsd:element')">
                    <xsl:value-of select="replace($tpth, 'xsd:schema/xsd:element', 'xsd:schema/xsd:complexType')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$tpth"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@*" mode="nodeschrule">
        <xsl:if test=".">
            <xsl:variable name="n" select="concat($apos, replace(., $apos, ''), $apos)"/>
            <xsl:variable name="pathtest" select="concat('/@', name(), '=', $n)"/>
            <sch:assert test="{$pathtest}">
                <xsl:value-of select="concat(name(), ' Mis-Match')"/>
            </sch:assert>
            <!--<xsl:element name="sch:assert">
                <xsl:attribute name="test" select="$pathtest"/>
                <xsl:value-of select="concat(name(), ' Mis-Match')"/>
            </xsl:element>-->
        </xsl:if>
    </xsl:template>
    <xsl:template match="@mtfdoc" mode="nodeschrule"/>
    <xsl:template match="@minLength | @maxLength | @minInclusive | @maxInclusive" mode="nodeschrule">
        <xsl:param name="attpath"/>
        <xsl:if test=".">
            <xsl:variable name="n" select="number(.)"/>
            <xsl:variable name="pathtest" select="concat('xsd:restriction/xsd:', $attpath, name(), '/@value=', $n)"/>
            <xsl:element name="sch:assert">
                <xsl:attribute name="test" select="$pathtest"/>
                <xsl:value-of select="concat(name(), ' Mis-Match')"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@minOccurs | @maxOccurs" mode="nodeschrule">
        <xsl:param name="attpath"/>
        <xsl:if test=". and contains($attpath, 'xsd:sequence')">
            <xsl:variable name="n" select="number(.)"/>
            <xsl:variable name="pathtest" select="concat('/@', $attpath, name(), '=', $n)"/>
            <xsl:element name="sch:assert">
                <xsl:attribute name="test" select="$pathtest"/>
                <xsl:value-of select="concat(name(), ' Mis-Match')"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@position | @seq" mode="infoschrule">
        <xsl:param name="attpath"/>
        <xsl:if test=".">
            <xsl:variable name="n" select="."/>
            <xsl:variable name="pathtest" select="concat('xsd:annotation/', $attpath, name(), '=', $n)"/>
            <xsl:element name="sch:assert">
                <xsl:attribute name="test" select="$pathtest"/>
                <xsl:value-of select="concat(name(), ' Mis-Match')"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="@*" mode="infoschrule">
        <xsl:param name="attpath"/>
        <xsl:if test=".">
            <xsl:variable name="n">
                <xsl:value-of select="concat($apos, replace(., $apos, $apos2), $apos)"/>
            </xsl:variable>
            <xsl:variable name="pathtest" select="concat('xsd:annotation/', $attpath, name(), '=', $n)"/>
            <xsl:element name="sch:assert">
                <xsl:attribute name="test" select="$pathtest"/>
                <xsl:value-of select="concat(name(), ' Mis-Match')"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@mtfdoc" mode="infoschrule"/>
    <xsl:template match="@identifier" mode="#all"/>
    <xsl:template match="@length" mode="#all"/>
    <xsl:template match="@mtftype" mode="#all"/>
    <xsl:template match="@mtfname" mode="#all"/>
    <xsl:template match="@mtfid" mode="#all"/>
    <xsl:template match="@base" mode="#all"/>
    <xsl:template match="@ffirn" mode="#all"/>
    <xsl:template match="@fud" mode="#all"/>
    <xsl:template match="@path" mode="#all"/>
    <xsl:template match="@pattern" mode="#all"/>
    <xsl:template match="@explanation" mode="#all"/>
    <xsl:template match="text()"/>
</xsl:stylesheet>
