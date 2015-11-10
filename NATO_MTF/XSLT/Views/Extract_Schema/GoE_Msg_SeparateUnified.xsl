<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="Msgs" select="document('../../../XSD/APP-11C-GoE/natomtf_goe_messages.xsd')"/>
    <xsl:variable name="Segments" select="document('../../../XSD/APP-11C-GoE/natomtf_goe_segments.xsd')"/>
    <xsl:variable name="Sets" select="document('../../../XSD/APP-11C-GoE/natomtf_goe_sets.xsd')"/>
    <xsl:variable name="Fields" select="document('../../../XSD/APP-11C-GoE/natomtf_goe_fields.xsd')"/>
    <xsl:variable name="MsgId" select="'ACSAMSTAT'"/>
    <xsl:variable name="OutDir" select="'../../../XSD/APP-11C-GoE/SeparateMessagesUnified/'"/>
    <xsl:template name="ExtractAllMessageSchemaUnified">
        <xsl:param name="outdir" select="$OutDir"/>
        <xsl:for-each select="$Msgs/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*:Msg/@identifier]">
            <xsl:call-template name="ExtractMessageSchemaUnified">
                <xsl:with-param name="msgident" select="./xsd:annotation/xsd:appinfo/*:Msg/@identifier"/>
                <xsl:with-param name="outdir" select="$outdir"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <!--*****************************************************-->
    <xsl:template name="ExtractMessageSchemaUnified">
        <xsl:param name="msgident" select="$MsgId"/>
        <xsl:param name="outdir" select="$OutDir"/>
        <xsl:for-each select="$Msgs/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*:Msg/@identifier = $msgident]">
            <xsl:variable name="elname" select="@name"/>
            <xsl:variable name="msgname" select="xsd:attribute[@name = 'mtfid']/@fixed"/>
            <xsl:variable name="mid" select="translate($msgname, ' .:', '')"/>
            <xsl:variable name="message">
                <xsl:copy-of select="."/>
                <xsl:copy-of select="$Msgs/xsd:schema/xsd:element[@type = $elname]"/>
            </xsl:variable>
            <xsl:variable name="segments">
                <!--List of all segments in message at any level - may be duplicates-->
                <xsl:variable name="seglist">
                    <xsl:for-each select="$message//@*[starts-with(., 'seg:')]">
                        <xsl:call-template name="getSegments">
                            <xsl:with-param name="segName" select="substring-after(., 'seg:')"/>
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
                    <xsl:variable name="n" select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="sets">
                <!--List of all sets in message at any level - will be duplicates-->
                <xsl:variable name="setlist">
                    <xsl:for-each select="$message//@*[starts-with(., 'set:')]">
                        <xsl:call-template name="getSets">
                            <xsl:with-param name="setName" select="substring-after(., 'set:')"/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:for-each select="$segments//@*[starts-with(., 'set:')]">
                        <xsl:call-template name="getSets">
                            <xsl:with-param name="setName" select="substring-after(., 'set:')"/>
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
                <xsl:for-each select="$setnodelist/xsd:complexType">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$setnodelist/xsd:element">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="fields">
                <xsl:variable name="fieldlist">
                    <xsl:for-each select="$message//@*[starts-with(., 'field:')]">
                        <xsl:call-template name="getFields">
                            <xsl:with-param name="fieldName" select="substring-after(., 'field:')"/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:for-each select="$segments//@*[starts-with(., 'field:')]">
                        <xsl:call-template name="getFields">
                            <xsl:with-param name="fieldName" select="substring-after(., 'field:')"/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:for-each select="$sets//@*[starts-with(., 'field:')]">
                        <xsl:call-template name="getFields">
                            <xsl:with-param name="fieldName" select="substring-after(., 'field:')"/>
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
                <xsl:for-each select="$fnodelist/xsd:element">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:result-document href="{$outdir}/{concat($mid,'.xsd')}">
                <xsd:schema xmlns="urn:int:nato:mtf:app-11(c):goe:mtf" 
                    xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                    xml:lang="en-GB" 
                    targetNamespace="urn:int:nato:mtf:app-11(c):goe:mtf"
                    elementFormDefault="unqualified" 
                    attributeFormDefault="unqualified">
                    <xsl:apply-templates select="$message/*" mode="copy"/>
                    <!--Omit segments if no content-->
                    <xsl:if test="$segments//xsd:complexType">
                        <xsl:text>&#10;</xsl:text>
                        <xsl:comment> ************** SEGMENTS **************</xsl:comment>
                        <xsl:text>&#10;</xsl:text>
                        <xsl:apply-templates select="$segments/*" mode="copy"/>
                    </xsl:if>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:comment> ************** SETS **************</xsl:comment>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:apply-templates select="$sets/*" mode="copy"/>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:comment> ************** FIELDS **************</xsl:comment>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:apply-templates select="$fields/*" mode="copy"/>
                </xsd:schema>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <!--*****************************************************-->
    <!--Return Global Segment name and any locally referenced segments-->
    <xsl:template name="getSegments">
        <xsl:param name="segName"/>
        <seg name="{$segName}"/>
        <xsl:variable name="seg" select="$Segments/xsd:schema/*[@name = $segName]"/>
        <xsl:for-each select="$seg//@*[name() = 'ref' or name() = 'type' or name() = 'base'][not(contains(., ':'))][not(. = $segName)]">
            <xsl:call-template name="getSegments">
                <xsl:with-param name="segName" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <!--Return Global Set name and any locally referenced segments-->
    <xsl:template name="getSets">
        <xsl:param name="setName"/>
        <set name="{$setName}"/>
        <xsl:variable name="set" select="$Sets/xsd:schema/*[@name = $setName]"/>
        <xsl:for-each select="$set//@*[name() = 'ref' or name() = 'type' or name() = 'base'][not(contains(., ':'))][not(. = $setName)]">
            <xsl:call-template name="getSets">
                <xsl:with-param name="setName" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <!--Return Global Set name and any locally referenced segments-->
    <xsl:template name="getFields">
        <xsl:param name="fieldName"/>
        <field name="{$fieldName}"/>
        <xsl:variable name="field" select="$Fields/xsd:schema/*[@name = $fieldName]"/>
        <xsl:for-each select="$field//@*[name() = 'ref' or name() = 'type' or name() = 'base'][not(contains(., ':'))][not(. = $fieldName)]">
            <xsl:call-template name="getFields">
                <xsl:with-param name="fieldName" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="xsd:pattern" mode="copy">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    <xsl:template match="*:Set" mode="copy">
        <xsl:element name="Set" namespace="urn:int:nato:mtf:app-11(c):goe:mtf">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:Field" mode="copy">
        <xsl:element name="Field" namespace="urn:int:nato:mtf:app-11(c):goe:mtf">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:Segment" mode="copy">
        <xsl:element name="Segment" namespace="urn:int:nato:mtf:app-11(c):goe:mtf">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:Enum" mode="copy">
        <xsl:element name="Enum" namespace="urn:int:nato:mtf:app-11(c):goe:mtf">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:Example" mode="copy">
        <xsl:element name="Example" namespace="urn:int:nato:mtf:app-11(c):goe:mtf">
            <xsl:apply-templates select="text()" mode="copy"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*:Document" mode="copy">
        <xsl:element name="Document" namespace="urn:int:nato:mtf:app-11(c):goe:mtf">
            <xsl:apply-templates select="text()" mode="copy"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*" mode="copy">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="text()" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="copy">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="@*[contains(., ':')][not(starts-with(., 'ism:'))][not(starts-with(., 'xsd:'))]" mode="copy">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="substring-after(., ':')"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="text()" mode="copy">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    <xsl:template match="text()"/>
</xsl:stylesheet>
