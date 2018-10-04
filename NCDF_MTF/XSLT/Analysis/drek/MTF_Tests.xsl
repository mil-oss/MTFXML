<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="dirpath" select="'../../XSD/Baseline_Schema/'"/>
    <xsl:variable name="outdir" select="'../../XSD/Analysis/MTFTests/'"/>
    <xsl:include href="GetPath.xsl"/>

    <!--Baseline XML Schema documents-->
    <xsl:variable name="baseline_msgs_xsd" select="document(concat($dirpath, 'messages.xsd'))"/>
    <xsl:variable name="baseline_sets_xsd" select="document(concat($dirpath, 'sets.xsd'))"/>
    <xsl:variable name="baseline_composites_xsd" select="document(concat($dirpath, 'composites.xsd'))"/>
    <xsl:variable name="baseline_fields_xsd" select="document(concat($dirpath, 'fields.xsd'))"/>

    <xsl:variable name="apos" select='"&apos;"'/>
    <xsl:variable name="apos2" select='"&apos;&apos;"'/>
    <xsl:variable name="q">
        <xsl:text>'</xsl:text>
    </xsl:variable>
    <xsl:variable name="lt" select="'&lt;'"/>
    <xsl:variable name="gt" select="'&gt;'"/>
    <xsl:variable name="lb">
        <xsl:text>[</xsl:text>
    </xsl:variable>
    <xsl:variable name="rb">
        <xsl:text>]</xsl:text>
    </xsl:variable>


    <xsl:template name="main">
        <xsl:variable name="MsgTests">
            <xsl:call-template name="getTests">
                <xsl:with-param name="xsd" select="$baseline_msgs_xsd/xsd:schema"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="SetTests">
            <xsl:call-template name="getTests">
                <xsl:with-param name="xsd" select="$baseline_sets_xsd/xsd:schema"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="CompTests">
            <xsl:call-template name="getTests">
                <xsl:with-param name="xsd" select="$baseline_composites_xsd/xsd:schema"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="FieldTests">
            <xsl:call-template name="getTests">
                <xsl:with-param name="xsd" select="$baseline_fields_xsd/xsd:schema"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:result-document href="{concat($outdir,'MsgTests.xml')}">
            <MtfMessageTests>
                <xsl:copy-of select="$MsgTests/*"/>
            </MtfMessageTests>
        </xsl:result-document>
        <xsl:result-document href="{concat($outdir,'SetTests.xml')}">
            <MtfSetTests>
                <xsl:copy-of select="$SetTests/*"/>
            </MtfSetTests>
        </xsl:result-document>
        <xsl:result-document href="{concat($outdir,'CompositeTests.xml')}">
            <MtfCompositeTests>
                <xsl:copy-of select="$CompTests/*"/>
            </MtfCompositeTests>
        </xsl:result-document>
        <xsl:result-document href="{concat($outdir,'FieldTests.xml')}">
            <MtfFieldTests>
                <xsl:copy-of select="$FieldTests"/>
            </MtfFieldTests>
        </xsl:result-document>
        <xsl:variable name="MsgTestsSch">
            <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
                <sch:pattern id="Messages">
                    <sch:rule context="/xsd:schema/*[//*:Msg]">
                        <xsl:for-each select="$MsgTests/*">
                            <xsl:variable name="val" select="@value"/>
                            <xsl:variable name="valn" select="@valname"/>
                            <xsl:if test="string-length($val) &gt; 0">
                                <sch:report test="{concat('@',$valn,'=',$q,$val,$q)}">
                                    <xsl:value-of select="concat('Path Not Found: ', $val)"/>
                                </sch:report>
                            </xsl:if>
                        </xsl:for-each>
                    </sch:rule>
                </sch:pattern>
            </sch:schema>
        </xsl:variable>
        <xsl:variable name="SetTestsSch">
            <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
                <sch:pattern id="Sets">
                    <sch:rule context="/xsd:schema/*[//*:Set]">
                        <xsl:for-each select="$SetTests/*">
                            <xsl:variable name="val" select="@value"/>
                            <xsl:variable name="valn" select="@valname"/>
                            <xsl:if test="string-length($val) &gt; 0">
                                <sch:report test="{concat('@',$valn,'=',$q,$val,$q)}">
                                    <xsl:value-of select="concat('Path Not Found: ', $val)"/>
                                </sch:report>
                            </xsl:if>
                        </xsl:for-each>
                    </sch:rule>
                </sch:pattern>
            </sch:schema>
        </xsl:variable>
        <xsl:variable name="CompTestsSch">
            <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
                <sch:pattern id="Composites">
                    <sch:rule context="/xsd:schema/*[//*:Composite]">
                        <xsl:for-each select="$CompTests/*">
                            <xsl:variable name="val" select="@value"/>
                            <xsl:variable name="valn" select="@valname"/>
                            <xsl:if test="string-length($val) &gt; 0">
                                <sch:report test="{concat('@',$valn,'=',$q,$val,$q)}">
                                    <xsl:value-of select="concat('Path Not Found: ', $val)"/>
                                </sch:report>
                            </xsl:if>
                        </xsl:for-each>
                    </sch:rule>
                </sch:pattern>
            </sch:schema>
        </xsl:variable>
        <xsl:variable name="FieldTestsSch">
            <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
                <sch:pattern id="Fields">
                    <sch:rule context="/xsd:schema/*[//*:Field]">
                        <xsl:for-each select="$FieldTests/*">
                            <xsl:variable name="val" select="@value"/>
                            <xsl:variable name="valn" select="@valname"/>
                            <xsl:if test="string-length($val) &gt; 0">
                                <sch:report test="{concat('@',$valn,'=',$q,$val,$q)}">
                                    <xsl:value-of select="concat('Path Not Found: ', $val)"/>
                                </sch:report>
                            </xsl:if>
                        </xsl:for-each>
                    </sch:rule>
                </sch:pattern>
            </sch:schema>
        </xsl:variable>
        <xsl:result-document href="{concat($outdir,'MtfTestsSch.sch')}">
            <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
                <xsl:copy-of select="$MsgTestsSch/*:schema/*:pattern"/>
                <xsl:copy-of select="$SetTestsSch/*:schema/*:pattern"/>
                <xsl:copy-of select="$CompTestsSch/*:schema/*:pattern"/>
                <xsl:copy-of select="$FieldTestsSch/*:schema/*:pattern"/>
            </sch:schema>
        </xsl:result-document>
        <xsl:result-document href="{concat($outdir,'SetTestsSch.sch')}">
            <xsl:copy-of select="$SetTestsSch/*"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($outdir,'CompositeTestsSch.sch')}">
            <xsl:copy-of select="$CompTestsSch/*"/>
        </xsl:result-document>
        <xsl:result-document href="{concat($outdir,'FieldTestsSch.sch')}">
            <xsl:copy-of select="$FieldTestsSch/*:schema/*:pattern"/>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="getTests">
        <xsl:param name="xsd"/>
        <xsl:variable name="rslt">
            <xsl:apply-templates select="$xsd" mode="testpaths"/>
        </xsl:variable>
        <xsl:for-each select="$rslt/*">
            <xsl:sort select="@test"/>
            <xsl:variable name="t" select="@test"/>
            <xsl:if test="count(preceding-sibling::Test[@test = $t]) = 0">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*" mode="testpaths">
        <xsl:apply-templates select="*" mode="testpaths"/>
    </xsl:template>

    <xsl:template
        match="
            *[xsd:annotation/xsd:appinfo[
            *:MtfName |
            *:MtfIdentifier |
            *:MtfSponsor |
            *:SetFormatName |
            *:SetFormatPositionName |
            *:SetFormatIdentifier |
            *:FieldFormatPositionName |
            *:FudName |
            *:VersionIndicator
            ]]"
        mode="testpaths">
        <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*" mode="maketestpaths">
            <xsl:with-param name="mtfpath">
                <xsl:call-template name="getPath">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="*" mode="testpaths"/>
    </xsl:template>


    <!--    <xsl:template match="*[/*/xsd:minLength]" mode="testpaths"/>
    <xsl:template match="*[/*/xsd:maxLength]" mode="testpaths"/>
    <xsl:template match="*[/*/xsd:pattern]" mode="testpaths"/>
    <xsl:template match="xsd:enumeration" mode="testpaths"/>
    <xsl:template match="*[//@ffSeq]" mode="testpaths"/>
    <xsl:template match="*[//@setSeq]" mode="testpaths"/>
    <xsl:template match="*[@minOccurs | @maxOccurs]" mode="testpaths"/>-->

    <xsl:template
        match="
            *:MtfName |
            *:MtfIdentifier |
            *:MtfSponsor |
            *:SetFormatName |
            *:SetFormatPositionName |
            *:SetFormatIdentifier |
            *:FieldFormatPositionName |
            *:FudName |
            *:VersionIndicator
            "
        mode="maketestpaths">
        <xsl:param name="mtfpath"/>
        <xsl:variable name="attmatch">
            <xsl:choose>
                <xsl:when test="name() = 'MtfName'">
                    <xsl:text>name</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'MtfIdentifier'">
                    <xsl:text>identifier</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'MtfSponsor'">
                    <xsl:text>sponsor</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'SetFormatName'">
                    <xsl:text>name</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'SetFormatPositionName'">
                    <xsl:text>name</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'SetFormatIdentifier'">
                    <xsl:text>setid</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'FieldFormatName'">
                    <xsl:text>name</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'FieldFormatPositionName'">
                    <xsl:text>name</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'FudName'">
                    <xsl:text>name</xsl:text>
                </xsl:when>
                <xsl:when test="name() = 'VersionIndicator'">
                    <xsl:text>version</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="makePath">
            <xsl:with-param name="valname" select="$attmatch"/>
            <xsl:with-param name="mtfpath" select="$mtfpath"/>
            <xsl:with-param name="predpath" select="concat('[xsd:annotation/xsd:appinfo/', name(), '=')"/>
            <xsl:with-param name="val" select="replace(text(), $apos, $apos2)"/>
        </xsl:call-template>
    </xsl:template>

    <!--  <xsl:template match="xsd:sequence/xsd:element[@ref]" mode="testpaths">
        <xsl:variable name="p">
            <xsl:call-template name="getPath">
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <Test name="Element" mtfpath="{$p}" position="{position()}"/>
    </xsl:template>
-->
    <xsl:template match="xsd:choice" mode="testpaths">
        <xsl:variable name="p">
            <xsl:call-template name="getPath">
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <Test name="Choice|SubstitutionGroup" mtfpath="{$p}"/>
    </xsl:template>

    <xsl:template name="makePath">
        <xsl:param name="valname"/>
        <xsl:param name="mtfpath"/>
        <xsl:param name="predpath"/>
        <xsl:param name="val"/>
        <xsl:variable name="testpath" select="concat('/xsd:schema/*//*[@', $valname, '=', $q, $val, $q, ']')"/>
        <Test value="{$val}" valname="{$valname}" mtfpath="{concat($mtfpath,$predpath,$q,$val,$q,$rb)}" testpath="{$testpath}"/>
    </xsl:template>

    <xsl:template match="*" mode="maketestpaths"/>
</xsl:stylesheet>
