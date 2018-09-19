<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="dirpath" select="'../../XSD/Baseline_Schema/'"/>
    <xsl:variable name="Messages" select="document(concat($dirpath, 'messages.xsd'))"/>
    <xsl:variable name="Sets" select="document(concat($dirpath, 'sets.xsd'))"/>
    <xsl:variable name="Composites" select="document(concat($dirpath, 'composites.xsd'))"/>
    <xsl:variable name="Fields" select="document(concat($dirpath, 'fields.xsd'))"/>
    <xsl:variable name="OutDir" select="concat($dirpath, 'SepMsg/')"/>
    <xsl:variable name="iterations" select="3"/>
    <xsl:template name="main">
        <xsl:for-each select="$Messages/xsd:schema/xsd:element[xsd:annotation/xsd:appinfo/*:MtfName]">
            <xsl:call-template name="ExtractMessageSchema">
                <xsl:with-param name="message" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <!--*****************************************************-->
    <xsl:template name="ExtractMessageSchema">
        <xsl:param name="message"/>
        <xsl:variable name="msgid" select="$message/xsd:annotation/xsd:appinfo/*:MtfIdentifier"/>
        <xsl:variable name="mid" select="translate($msgid, ' .:()', '')"/>
        <!--MESSAGE-->
        <xsl:result-document href="{$OutDir}/{$mid}/{concat($mid,'_message.xsd')}">
            <xsd:schema targetNamespace="urn:int:nato:ncdf:mtf" xml:lang="en-US" xmlns="urn:int:nato:ncdf:mtf" xmlns:s="urn:int:nato:ncdf:mtf:set" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:ICISM="urn:us:gov:ic:ism:v2" elementFormDefault="unqualified"
                attributeFormDefault="unqualified">
                <xsd:import namespace="urn:int:nato:ncdf:mtf:set" schemaLocation="{concat($mid,'_sets.xsd')}"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="../IC-ISM-v2.xsd"/>
                <xsd:annotation>
                    <xsd:appinfo>
                        <ddms:security ICISM:classification="U" ICISM:ownerProducer="USA" ICISM:nonICmarkings="DIST_STMT_C"/>
                    </xsd:appinfo>
                    <xsd:appinfo>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use. Other requests for this
                        document shall be referred to Defense Information Systems Agency Interoperability Directorate. WARNING - This document contains technical data whose export is restricted by the
                        Arms Export Control Act (Title 22, U.S.C., Sec. 2751) or the Export Administration Act of 1979, as amended, Title 50, U.S.C., App. 2401. Violations of these export laws are
                        subject to severe criminal penalties. Disseminate in accordance with provisions of DOD Directive 5230.25.</xsd:appinfo>
                </xsd:annotation>
                <xsl:copy-of select="$message"/>
            </xsd:schema>
        </xsl:result-document>
        <!--Omit segments if no content-->
        <!-- SETS-->
        <xsl:variable name="msgsetnodes">
            <xsl:for-each select="$message//@*[starts-with(., 's:')]">
                <xsl:variable name="n" select="substring-after(., 's:')"/>
                <xsl:copy-of select="$Sets/xsd:schema/xsd:complexType[@name = $n]"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="setnodes">
            <xsl:for-each select="$msgsetnodes//@*[name() = 'base' or name() = 'type']">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="data" select="$Sets/xsd:schema"/>
                    <xsl:with-param name="iteration" select="2"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:copy-of select="$msgsetnodes"/>
        </xsl:variable>
        <xsl:result-document href="{$OutDir}/{$mid}/{concat($mid,'_sets.xsd')}">
            <xsd:schema targetNamespace="urn:int:nato:ncdf:mtf:set" xml:lang="en-US" xmlns="urn:int:nato:ncdf:mtf:set" xmlns:c="urn:int:nato:ncdf:mtf:composite" xmlns:f="urn:int:nato:ncdf:mtf:elemental"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:ICISM="urn:us:gov:ic:ism:v2"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:int:nato:ncdf:mtf:composite" schemaLocation="{concat($mid,'_composites.xsd')}"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:elemental" schemaLocation="{concat($mid,'_fields.xsd')}"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="../IC-ISM-v2.xsd"/>
                <xsd:annotation>
                    <xsd:appinfo>
                        <ddms:security ICISM:classification="U" ICISM:ownerProducer="USA" ICISM:nonICmarkings="DIST_STMT_C"/>
                    </xsd:appinfo>
                    <xsd:appinfo>DISTRIBUTION STATEMENT C. Distribution authorized to U.S. Government Agencies and their contractors only for administrative or operational use. Other requests for this
                        document shall be referred to Defense Information Systems Agency Interoperability Directorate. WARNING - This document contains technical data whose export is restricted by the
                        Arms Export Control Act (Title 22, U.S.C., Sec. 2751) or the Export Administration Act of 1979, as amended, Title 50, U.S.C., App. 2401. Violations of these export laws are
                        subject to severe criminal penalties. Disseminate in accordance with provisions of DOD Directive 5230.25.</xsd:appinfo>
                </xsd:annotation>
                <xsl:for-each select="$setnodes/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:complexType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <!-- COMPOSITES-->
        <xsl:variable name="msgcompositenodes">
            <xsl:for-each select="$message//@*[starts-with(., 'c:')]">
                <xsl:variable name="m" select="substring-after(., 'c:')"/>
                <xsl:copy-of select="$Composites/xsd:schema/*[@name = $m]"/>
            </xsl:for-each>
            <xsl:for-each select="$setnodes//@*[starts-with(., 'c:')]">
                <xsl:variable name="s" select="substring-after(., 'c:')"/>
                <xsl:copy-of select="$Composites/xsd:schema/*[@name = $s]"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="compositenodes">
            <xsl:for-each select="$msgcompositenodes//@*[name() = 'base' or name() = 'type']">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="data" select="$Composites/xsd:schema"/>
                    <xsl:with-param name="iteration" select="2"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:copy-of select="$msgcompositenodes"/>
        </xsl:variable>
        <xsl:result-document href="{$OutDir}/{$mid}/{concat($mid,'_composites.xsd')}">
            <xsd:schema targetNamespace="urn:int:nato:ncdf:mtf:composite" xml:lang="en-US" xmlns="urn:int:nato:ncdf:mtf:composite" xmlns:f="urn:int:nato:ncdf:mtf:elemental"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:int:nato:ncdf:mtf:elemental" schemaLocation="{concat($mid,'_fields.xsd')}"/>
                <xsl:for-each select="$compositenodes/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:complexType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <!-- FIELDS-->
        <xsl:variable name="msgfieldnodes">
            <xsl:for-each select="$message//@*[starts-with(., 'f:')]">
                <xsl:variable name="m" select="substring-after(., 'f:')"/>
                <xsl:copy-of select="$Fields/xsd:schema/*[@name = $m]"/>
            </xsl:for-each>
            <xsl:for-each select="$setnodes//@*[starts-with(., 'f:')]">
                <xsl:variable name="s" select="substring-after(., 'f:')"/>
                <xsl:copy-of select="$Fields/xsd:schema/*[@name = $s]"/>
            </xsl:for-each>
            <xsl:for-each select="$compositenodes//@*[starts-with(., 'f:')]">
                <xsl:variable name="c" select="substring-after(., 'f:')"/>
                <xsl:copy-of select="$Fields/xsd:schema/*[@name = $c]"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="fieldnodes">
            <xsl:for-each select="$msgfieldnodes//@*[name() = 'base' or name() = 'type']">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="data" select="$Fields/xsd:schema"/>
                    <xsl:with-param name="iteration" select="2"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:copy-of select="$msgfieldnodes"/>
        </xsl:variable>
        <xsl:result-document href="{$OutDir}/{$mid}/{concat($mid,'_fields.xsd')}">
            <xsd:schema targetNamespace="urn:int:nato:ncdf:mtf:elemental" xml:lang="en-US" xmlns="urn:int:nato:ncdf:mtf:elemental" xmlns:xsd="http://www.w3.org/2001/XMLSchema" elementFormDefault="unqualified"
                attributeFormDefault="unqualified">
                <xsd:import namespace="http://www.w3.org/XML/1998/namespace" schemaLocation="http://www.w3.org/2001/xml.xsd"/>
                <xsl:for-each select="$fieldnodes/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:complexType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$fieldnodes/xsd:simpleType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:simpleType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>
    <!--*****************************************************-->
    <xsl:template name="iterateNode">
        <xsl:param name="data"/>
        <xsl:param name="prefix"/>
        <xsl:param name="node"/>
        <xsl:param name="iteration"/>
        <xsl:variable name="nde">
            <xsl:choose>
                <xsl:when test="$prefix and starts-with($node, $prefix)">
                    <xsl:copy-of select="$data/*[@name = substring-after($node, ':')]" copy-namespaces="no"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$data/*[@name = $node]" copy-namespaces="no"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select="$nde"/>
        <xsl:if test="number($iteration) &gt; 0">
            <xsl:for-each select="$nde//@*[name() = 'ref' or name() = 'type' or name() = 'base'][not(. = $node/@name)]">
                <xsl:variable name="n">
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$data"/>
                    <xsl:with-param name="node" select="$n"/>
                    <xsl:with-param name="iteration" select="number($iteration - 1)"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
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
