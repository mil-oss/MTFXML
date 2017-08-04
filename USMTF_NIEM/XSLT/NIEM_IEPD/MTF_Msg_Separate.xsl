<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="dirpath" select="'../../XSD/NIEM_MTF/'"/>
    <xsl:variable name="Messages" select="document(concat($dirpath, 'NIEM_MTF_Messages.xsd'))"/>
    <xsl:variable name="Segments" select="document(concat($dirpath, 'NIEM_MTF_Segments.xsd'))"/>
    <xsl:variable name="Sets" select="document(concat($dirpath, 'NIEM_MTF_Sets.xsd'))"/>
    <xsl:variable name="Composites" select="document(concat($dirpath, 'NIEM_MTF_Composites.xsd'))"/>
    <xsl:variable name="Fields" select="document(concat($dirpath, 'NIEM_MTF_Fields.xsd'))"/>
    <xsl:variable name="MsgId" select="'ACSAMSTAT'"/>
    <xsl:variable name="OutDir" select="'../../XSD/NIEM_IEPD/SeparateMessages/'"/>
    <xsl:template name="main">
        <xsl:param name="outdir" select="$OutDir"/>
        <xsl:for-each select="$Messages/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*:Msg[@identifier='ACMREQ']]">
            <xsl:call-template name="ExtractMessageSchema">
                <xsl:with-param name="msg" select="."/>
                <xsl:with-param name="outdir" select="$outdir"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <!--*****************************************************-->
    <xsl:template name="ExtractMessageSchema">
        <xsl:param name="msg"/>
        <xsl:param name="outdir" select="$OutDir"/>
        <xsl:variable name="elname" select="$msg/@name"/>
        <xsl:variable name="msgname" select="$msg/xsd:annotation/xsd:appinfo/*:Msg/@identifier"/>
        <xsl:variable name="mid" select="translate($msgname, ' .:', '')"/>
        <xsl:variable name="msgel" select="$Messages/xsd:schema/xsd:element[@type = $elname]"/>
        <!--MESSAGE-->
        <xsl:variable name="message">
            <xsl:variable name="msglist">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$Messages"/>
                    <xsl:with-param name="nodeName" select="$elname"/>
                    <xsl:with-param name="iteration" select="0"/>
                </xsl:call-template>
            </xsl:variable>
            <!--<xsl:copy-of select="$msglist"/>-->
            <xsl:variable name="msgnodelist">
                <xsl:for-each select="$msglist/*">
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*/@name = $n)">
                        <xsl:copy-of select="$Messages/xsd:schema/*[@name = $n]"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each select="$msgnodelist/xsd:complexType">
                <xsl:sort select="@name"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="$msgnodelist/xsd:element">
                <xsl:sort select="@name"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:result-document href="{$outdir}/{$mid}/{concat($mid,'_message.xsd')}">
            <xsl:for-each select="$Messages/xsd:schema">
                <xsl:copy copy-namespaces="yes">
                    <xsl:apply-templates select="@*" mode="copy"/>
                    <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="../../IC-ISM-v2.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/structures/3.0/" schemaLocation="../../../NIEM/structures.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../../../NIEM/localTerminology.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/appinfo/3.0/" schemaLocation="../../../NIEM/appinfo.xsd"/>
                    <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../../../NIEM/mtfappinfo.xsd"/>
                    <xsd:import namespace="urn:mtf:mil:6040b:niem:mtf:sets" schemaLocation="{concat($mid,'_sets.xsd')}"/>
                    <xsl:if test="count($message//@*[starts-with(., 'sg:')])&gt;0">
                        <xsd:import namespace="urn:mtf:mil:6040b:niem:mtf:segments" schemaLocation="{concat($mid,'_segments.xsd')}"/>
                    </xsl:if>
                    <xsl:if test="count($message//@*[starts-with(., 'f:')])&gt;0">
                        <xsd:import namespace="urn:mtf:mil:6040b:niem:mtf:fields" schemaLocation="{concat($mid,'_fields.xsd')}"/>
                    </xsl:if>
                    <xsl:if test="count($message//@*[starts-with(., 'c:')])&gt;0">
                        <xsd:import namespace="urn:mtf:mil:6040b:niem:mtf:composites" schemaLocation="{concat($mid,'_composites.xsd')}"/>
                    </xsl:if>
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="concat($msg/xsd:annotation/xsd:appinfo/*:Msg/@name,' MESSAGE SCHEMA')"/>
                        </xsd:documentation>
                    </xsd:annotation>
                    <xsl:copy-of select="$message"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <!--SEGMENTS-->
        <xsl:variable name="segments">
            <xsl:variable name="seglist">
                <xsl:for-each select="$message//@*[starts-with(., 'sg:')]">
                    <node type="name" name="{substring-after(.,'sg:')}"/>
                    <xsl:call-template name="iterateNode">
                        <xsl:with-param name="data" select="$Segments"/>
                        <xsl:with-param name="nodeName" select="substring-after(., 'sg:')"/>
                        <xsl:with-param name="iteration" select="0"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="segnodelist">
                <xsl:for-each select="$seglist/*">
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*/@name = $n)">
                        <xsl:copy-of select="$Segments/xsd:schema/*[@name = $n]"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <!--<xsl:copy-of select="$seglist"/>-->
            <xsl:for-each select="$segnodelist/xsd:complexType">
                <xsl:sort select="@name"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="$segnodelist/xsd:element">
                <xsl:sort select="@name"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <!--<xsl:for-each select=".//*[@type]">
                <xsl:variable name="t" select="@type"/>
                <xsl:copy-of select="$Segments/xsd:schema/*[@name = $t]"/>
            </xsl:for-each>
            <xsl:for-each select=".//*[@ref]">
                <xsl:variable name="r" select="@ref"/>
                <xsl:copy-of select="$Segments/xsd:schema/*[@name = $r]"/>
            </xsl:for-each>-->
        </xsl:variable>
        <!--Omit segments if no content-->
        <xsl:if test="count($message//@*[starts-with(., 'sg:')])&gt;0">
            <xsl:result-document href="{$outdir}/{$mid}/{concat($mid,'_segments.xsd')}">
                <xsl:for-each select="$Segments/xsd:schema[1]">
                    <xsl:copy copy-namespaces="yes">
                        <xsl:apply-templates select="@*" mode="copy"/>
                        <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="../../IC-ISM-v2.xsd"/>
                        <xsd:import namespace="http://release.niem.gov/niem/structures/3.0/" schemaLocation="../../../NIEM/structures.xsd"/>
                        <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../../../NIEM/localTerminology.xsd"/>
                        <xsd:import namespace="http://release.niem.gov/niem/appinfo/3.0/" schemaLocation="../../../NIEM/appinfo.xsd"/>
                        <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../../../NIEM/mtfappinfo.xsd"/>
                        <xsd:import namespace="urn:mtf:mil:6040b:niem:mtf:sets" schemaLocation="{concat($mid,'_sets.xsd')}"/>
                        <xsl:if test="count($Segments//@*[starts-with(., 'c:')])&gt;0">
                            <xsd:import namespace="urn:mtf:mil:6040b:niem:mtf:composites" schemaLocation="{concat($mid,'_composites.xsd')}"/>
                        </xsl:if>
                        <xsl:if test="count($Segments//@*[starts-with(., 'f:')])&gt;0">
                            <xsd:import namespace="urn:mtf:mil:6040b:niem:mtf:fields" schemaLocation="{concat($mid,'_fields.xsd')}"/>
                        </xsl:if>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="concat($msg/xsd:annotation/xsd:appinfo/*:Msg/@name,' SEGMENTS SCHEMA')"/>
                            </xsd:documentation>
                        </xsd:annotation>
                        <xsl:copy-of select="$segments"/>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:result-document>
        </xsl:if>
        <!-- SETS-->
        <xsl:variable name="sets">
            <xsl:variable name="setlist">
                <xsl:for-each select="$message//@*[starts-with(., 's:')]">
                    <node type="name" name="{substring-after(.,'s:')}"/>
                    <xsl:call-template name="iterateNode">
                        <xsl:with-param name="data" select="$Sets"/>
                        <xsl:with-param name="nodeName" select="substring-after(., 's:')"/>
                        <xsl:with-param name="iteration" select="0"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="$segments//@*[starts-with(., 's:')]">
                    <node type="name" name="{substring-after(.,'s:')}"/>
                    <xsl:call-template name="iterateNode">
                        <xsl:with-param name="data" select="$Sets"/>
                        <xsl:with-param name="nodeName" select="substring-after(., 's:')"/>
                        <xsl:with-param name="iteration" select="0"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:variable>
            <!--<xsl:copy-of select="$setlist"/>-->
            <xsl:variable name="setnodelist">
                <xsl:for-each select="$setlist/*">
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*/@name = $n)">
                        <xsl:copy-of select="$Sets/xsd:schema/*[@name = $n]"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <!--<xsl:copy-of select="$Sets/xsd:schema/xsd:complexType[@name = 'SetBaseType']"/>-->
            <xsl:for-each select="$setnodelist/xsd:complexType">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="$setnodelist/xsd:element">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:result-document href="{$outdir}/{$mid}/{concat($mid,'_sets.xsd')}">
            <xsl:for-each select="$Sets/xsd:schema[1]">
                <xsl:copy copy-namespaces="yes">
                    <xsl:apply-templates select="@*" mode="copy"/>
                    <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="../../IC-ISM-v2.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/structures/3.0/" schemaLocation="../../../NIEM/structures.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../../../NIEM/localTerminology.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/appinfo/3.0/" schemaLocation="../../../NIEM/appinfo.xsd"/>
                    <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../../../NIEM/mtfappinfo.xsd"/>
                    <xsd:import namespace="urn:mtf:mil:6040b:niem:mtf:composites" schemaLocation="{concat($mid,'_composites.xsd')}"/>
                    <xsd:import namespace="urn:mtf:mil:6040b:niem:mtf:fields" schemaLocation="{concat($mid,'_fields.xsd')}"/>
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="concat($msg/xsd:annotation/xsd:appinfo/*:Msg/@name,' SETS SCHEMA')"/>
                        </xsd:documentation>
                    </xsd:annotation>
                    <xsl:copy-of select="$sets"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <!-- COMPOSITES-->
        <xsl:variable name="composites">
            <xsl:variable name="complist">
                <xsl:for-each select="$message//@*[starts-with(., 'c:')]">
                    <node type="name" name="{substring-after(.,'c:')}"/>
                    <xsl:call-template name="iterateNode">
                        <xsl:with-param name="data" select="$Composites"/>
                        <xsl:with-param name="nodeName" select="substring-after(., 'c:')"/>
                        <xsl:with-param name="iteration" select="0"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="$segments//@*[starts-with(., 'c:')]">
                    <node type="name" name="{substring-after(.,'c:')}"/>
                    <xsl:call-template name="iterateNode">
                        <xsl:with-param name="data" select="$Composites"/>
                        <xsl:with-param name="nodeName" select="substring-after(., 'c:')"/>
                        <xsl:with-param name="iteration" select="0"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="$sets//@*[starts-with(., 'c:')]">
                    <xsl:call-template name="iterateNode">
                        <xsl:with-param name="data" select="$Composites"/>
                        <xsl:with-param name="nodeName" select="substring-after(., 'c:')"/>
                        <xsl:with-param name="iteration" select="0"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:variable>
            <!--<xsl:copy-of select="$complist"/>-->
            <xsl:variable name="cnodelist">
                <xsl:for-each select="$complist/*">
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*/@name = $n)">
                        <xsl:copy-of select="$Composites/xsd:schema/*[@name = $n]"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each select="$cnodelist/xsd:complexType">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="$cnodelist/xsd:element">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:result-document href="{$outdir}/{$mid}/{concat($mid,'_composites.xsd')}">
            <xsl:for-each select="$Composites/xsd:schema[1]">
                <xsl:copy copy-namespaces="yes">
                    <xsl:apply-templates select="@*" mode="copy"/>
                    <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="../../IC-ISM-v2.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/structures/3.0/" schemaLocation="../../../NIEM/structures.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../../../NIEM/localTerminology.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/appinfo/3.0/" schemaLocation="../../../NIEM/appinfo.xsd"/>
                    <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../../../NIEM/mtfappinfo.xsd"/>
                    <xsd:import namespace="urn:mtf:mil:6040b:niem:mtf:fields" schemaLocation="{concat($mid,'_fields.xsd')}"/>
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="concat($msg/xsd:annotation/xsd:appinfo/*:Msg/@name,' COMPOSITES SCHEMA')"/>
                        </xsd:documentation>
                    </xsd:annotation>
                    <xsl:copy-of select="$composites"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
        <!-- FIELDS-->
        <xsl:variable name="fields">
            <xsl:variable name="fieldlist">
                <xsl:for-each select="$segments//@*[starts-with(., 'f:')]">
                    <node type="name" name="{substring-after(.,'f:')}"/>
                    <xsl:call-template name="iterateNode">
                        <xsl:with-param name="data" select="$Fields"/>
                        <xsl:with-param name="nodeName" select="substring-after(., 'f:')"/>
                        <xsl:with-param name="iteration" select="0"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="$sets//@*[starts-with(., 'f:')]">
                    <node type="name" name="{substring-after(.,'f:')}"/>
                    <xsl:call-template name="iterateNode">
                        <xsl:with-param name="data" select="$Fields"/>
                        <xsl:with-param name="nodeName" select="substring-after(., 'f:')"/>
                        <xsl:with-param name="iteration" select="0"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="$composites//@*[starts-with(., 'f:')]">
                    <node type="name" name="{substring-after(.,'f:')}"/>
                    <xsl:call-template name="iterateNode">
                        <xsl:with-param name="data" select="$Fields"/>
                        <xsl:with-param name="nodeName" select="substring-after(., 'f:')"/>
                        <xsl:with-param name="iteration" select="0"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:variable>
            <!--<xsl:copy-of select="$fieldlist"/>-->
            <xsl:variable name="fnodelist">
                <xsl:for-each select="$fieldlist/*">
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*/@name = $n)">
                        <xsl:copy-of select="$Fields/xsd:schema/*[@name = $n]"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each select="$fnodelist/xsd:complexType">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="$fnodelist/xsd:simpleType">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <xsl:for-each select="$fnodelist/xsd:element">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:result-document href="{$outdir}/{$mid}/{concat($mid,'_fields.xsd')}">
            <xsl:for-each select="$Fields/xsd:schema[1]">
                <xsl:copy copy-namespaces="yes">
                    <xsl:apply-templates select="@*" mode="copy"/>
                    <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="../../IC-ISM-v2.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/structures/3.0/" schemaLocation="../../../NIEM/structures.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../../../NIEM/localTerminology.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/appinfo/3.0/" schemaLocation="../../../NIEM/appinfo.xsd"/>
                    <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../../../NIEM/mtfappinfo.xsd"/>
                    <xsd:import namespace="urn:mtf:mil:6040b:niem:mtf:composites" schemaLocation="{concat($mid,'_composites.xsd')}"/>
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="concat($msg/xsd:annotation/xsd:appinfo/*:Msg/@name,' FIELDS SCHEMA')"/>
                        </xsd:documentation>
                    </xsd:annotation>
                    <xsl:copy-of select="$fields"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>
    <!--*****************************************************-->
    <xsl:template name="iterateNode">
        <xsl:param name="data"/>
        <xsl:param name="nodeName"/>
        <xsl:param name="iteration"/>
        <xsl:variable name="itnode">
            <xsl:copy-of select="$data/xsd:schema/*[@name = $nodeName]"/>
        </xsl:variable>
        <itnode type="{name()}" iteration="{$iteration}">
            <xsl:attribute name="name">
                <xsl:value-of select="$nodeName"/>
            </xsl:attribute>
        </itnode>
        <xsl:for-each select="$itnode//@*[name() = 'ref' or name() = 'type' or name() = 'base'][not(contains(., ':'))][not(. = $nodeName)]">
            <node type="{name()}">
                <xsl:attribute name="name">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </node>
            <xsl:if test="$iteration &lt; 10">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$data"/>
                    <xsl:with-param name="nodeName" select="."/>
                    <xsl:with-param name="iteration" select="number($iteration + 1)"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="*" mode="copy">
        <xsl:param name="msgid"/>
        <xsl:param name="incseg"/>
        <xsl:choose>
            <!--don't add segments xsd if no segments.-->
            <xsl:when test="ends-with(@namespace, 'segments') and not($incseg)"/>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*" mode="copy">
                        <xsl:with-param name="msgid" select="$msgid"/>
                        <xsl:with-param name="incseg" select="$incseg"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="text()" mode="copy"/>
                    <xsl:apply-templates select="*" mode="copy">
                        <xsl:with-param name="msgid" select="$msgid"/>
                        <xsl:with-param name="incseg" select="$incseg"/>
                    </xsl:apply-templates>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@schemaLocation" mode="copy">
        <xsl:param name="msgid"/>
        <xsl:param name="incseg"/>
        <xsl:choose>
            <xsl:when test=". = 'IC-ISM-v2.xsd'">
                <xsl:attribute name="schemaLocation">
                    <xsl:value-of select="concat('../', .)"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="schemaLocation">
                    <xsl:value-of select="concat($msgid, '_', substring-after(., '_'))"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@*" mode="copy">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="text()" mode="copy">
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="text()"/>
</xsl:stylesheet>
