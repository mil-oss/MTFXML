<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="dirpath" select="'../../XSD/NIEM_MTF_1_NS/'"/>
    <xsl:variable name="Messages" select="document(concat($dirpath, 'NIEM_MTF_Messages.xsd'))/*"/>
    <xsl:variable name="Segments" select="document(concat($dirpath, 'NIEM_MTF_Segments.xsd'))/*"/>
    <xsl:variable name="Sets" select="document(concat($dirpath, 'NIEM_MTF_Sets.xsd'))/*"/>
    <xsl:variable name="Composites" select="document(concat($dirpath, 'NIEM_MTF_Composites.xsd'))/*"/>
    <xsl:variable name="Fields" select="document(concat($dirpath, 'NIEM_MTF_Fields.xsd'))/*"/>
    <xsl:variable name="OutDir" select="'../../XSD/NIEM_MTF_1_NS/SeparateMessages/'"/>
    <xsl:variable name="iterations" select="5"/>
    <xsl:template name="main">
        <xsl:param name="outdir" select="$OutDir"/>
        <!--<xsl:for-each select="$Messages/xsd:element[xsd:annotation/xsd:appinfo/*:Msg][@name='AirliftRequest']">-->
        <xsl:for-each select="$Messages/xsd:element[xsd:annotation/xsd:appinfo/*:Msg]">
            <xsl:call-template name="ExtractMessageSchema">
                <xsl:with-param name="message" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <!--*****************************************************-->
    <xsl:template name="ExtractMessageSchema">
        <xsl:param name="message"/>
        <xsl:variable name="messagetype" select="$Messages/xsd:complexType[@name = $message/@type]"/>
        <xsl:variable name="msgid" select="$messagetype/xsd:annotation/xsd:appinfo/*:Msg/@mtfid"/>
        <xsl:variable name="mid" select="translate($msgid, ' .:()', '')"/>
        <!--MESSAGE-->
        <xsl:variable name="messagenodes">
            <xsl:for-each select="$messagetype//@*[name() = 'ref' or name() = 'type' or name() = 'base' or name() = 'substitutionGroup']">
                <xsl:variable name="n" select="."/>
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$Messages"/>
                    <xsl:with-param name="node" select="$n"/>
                    <xsl:with-param name="iteration" select="$iterations"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        <xsl:result-document href="{$OutDir}/{$mid}/{concat($mid,'_message.xsd')}">
            <xsd:schema xmlns="urn:int:nato:ncdf:mtf:niem:mtf" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                xmlns:s="urn:int:nato:ncdf:mtf:niem:mtf:sets" xmlns:sg="urn:int:nato:ncdf:mtf:niem:mtf:segments" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:int:nato:ncdf:mtf:niem:mtf:messages" ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#ReferenceSchemaDocument"
                xml:lang="en-US" elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="../../IC-ISM.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../../../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../../../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../../../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:appinfo" schemaLocation="../../../NIEM/mtfappinfo.xsd"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:mtf:sets" schemaLocation="{concat($mid,'_sets.xsd')}"/>
                <xsl:if test="count($messagenodes//@*[starts-with(., 'sg:')]) &gt; 0">
                    <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:mtf:segments" schemaLocation="{concat($mid,'_segments.xsd')}"/>
                </xsl:if>
                <xsl:if test="count($messagenodes//@*[starts-with(., 'f:')]) &gt; 0">
                    <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:mtf:fields" schemaLocation="{concat($mid,'_fields.xsd')}"/>
                </xsl:if>
                <xsl:if test="count($messagenodes//@*[starts-with(., 'c:')]) &gt; 0">
                    <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:mtf:composites" schemaLocation="{concat($mid,'_composites.xsd')}"/>
                </xsl:if>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat($message/xsd:annotation/xsd:appinfo/*:Msg/@name, ' MESSAGE SCHEMA')"/>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:copy-of select="$message"/>
                <xsl:copy-of select="$messagetype"/>
                <xsl:for-each select="$messagenodes/xsd:complexType[not(@name = $message/@type)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:complexType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$messagenodes/xsd:element[not(@name = $message/@name)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:element[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <!--SEGMENTS-->
        <xsl:variable name="segmentnodes">
            <xsl:for-each select="$messagenodes//@*[name() = 'ref' or name() = 'type' or name() = 'base' or name() = 'substitutionGroup']">
                <xsl:variable name="n" select="."/>
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$Segments"/>
                    <xsl:with-param name="prefix" select="'sg:'"/>
                    <xsl:with-param name="node" select="$n"/>
                    <xsl:with-param name="iteration" select="12"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        <!--Omit segments if no content-->
        <xsl:if test="count($messagenodes//@*[starts-with(., 'sg:')]) &gt; 0">
            <xsl:result-document href="{$OutDir}/{$mid}/{concat($mid,'_segments.xsd')}">
                <xsd:schema xmlns="urn:int:nato:ncdf:mtf:niem:mtf:segments" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/4.0/"
                    xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                    xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                    xmlns:s="urn:int:nato:ncdf:mtf:niem:mtf:sets" xmlns:xsd="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:int:nato:ncdf:mtf:niem:mtf:segments"
                    ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
                    attributeFormDefault="unqualified" version="1.0">
                    <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="../../IC-ISM.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../../../NIEM/structures.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../../../NIEM/localTerminology.xsd"/>
                    <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../../../NIEM/appinfo.xsd"/>
                    <xsd:import namespace="urn:int:nato:ncdf:mtf:appinfo" schemaLocation="../../../NIEM/mtfappinfo.xsd"/>
                    <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:mtf:sets" schemaLocation="{concat($mid,'_sets.xsd')}"/>
                    <xsl:if test="count($segmentnodes//@*[starts-with(., 'c:')]) &gt; 0">
                        <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:mtf:composites" schemaLocation="{concat($mid,'_composites.xsd')}"/>
                    </xsl:if>
                    <xsl:if test="count($segmentnodes//@*[starts-with(., 'f:')]) &gt; 0">
                        <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:mtf:fields" schemaLocation="{concat($mid,'_fields.xsd')}"/>
                    </xsl:if>
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="concat($message/xsd:annotation/xsd:appinfo/*:Msg/@name, ' SEGMENTS SCHEMA')"/>
                        </xsd:documentation>
                    </xsd:annotation>
                    <xsl:for-each select="$segmentnodes/xsd:complexType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="count(preceding-sibling::xsd:complexType[@name = $n]) = 0">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$segmentnodes/xsd:element">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="count(preceding-sibling::xsd:element[@name = $n]) = 0">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                </xsd:schema>
            </xsl:result-document>
        </xsl:if>
        <!-- SETS-->
        <xsl:variable name="setnodes">
            <xsl:for-each select="$messagenodes//@*[name() = 'ref' or name() = 'type' or name() = 'base' or name() = 'substitutionGroup']">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$Sets"/>
                    <xsl:with-param name="prefix" select="'s:'"/>
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="iteration" select="$iterations"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$segmentnodes//@*[name() = 'ref' or name() = 'type' or name() = 'base' or name() = 'substitutionGroup']">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$Sets"/>
                    <xsl:with-param name="prefix" select="'s:'"/>
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="iteration" select="$iterations"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        <xsl:result-document href="{$OutDir}/{$mid}/{concat($mid,'_sets.xsd')}">
            <xsd:schema xmlns="urn:int:nato:ncdf:mtf:niem:mtf:sets" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/4.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                xmlns:f="urn:int:nato:ncdf:mtf:niem:mtf:fields" xmlns:c="urn:int:nato:ncdf:mtf:niem:mtf:composites" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:int:nato:ncdf:mtf:niem:mtf:sets" ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#ReferenceSchemaDocument"
                xml:lang="en-US" elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="../../IC-ISM.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../../../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../../../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../../../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:appinfo" schemaLocation="../../../NIEM/mtfappinfo.xsd"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:mtf:composites" schemaLocation="{concat($mid,'_composites.xsd')}"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:mtf:fields" schemaLocation="{concat($mid,'_fields.xsd')}"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat($message/xsd:annotation/xsd:appinfo/*:Msg/@name, ' SETS SCHEMA')"/>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:for-each select="$setnodes/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:complexType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$setnodes/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:element[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <!-- COMPOSITES-->
        <xsl:variable name="compositenodes">
            <xsl:for-each select="$messagenodes//@*[starts-with(., 'c:')]">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$Composites"/>
                    <xsl:with-param name="prefix" select="'c:'"/>
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="iteration" select="$iterations"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$segmentnodes//@*[starts-with(., 'c:')]">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$Composites"/>
                    <xsl:with-param name="prefix" select="'c:'"/>
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="iteration" select="$iterations"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$setnodes//@*[starts-with(., 'c:')]">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$Composites"/>
                    <xsl:with-param name="prefix" select="'c:'"/>
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="iteration" select="$iterations"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        <xsl:result-document href="{$OutDir}/{$mid}/{concat($mid,'_composites.xsd')}">
            <xsd:schema xmlns="urn:int:nato:ncdf:mtf:niem:mtf:composites" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                xmlns:f="urn:int:nato:ncdf:mtf:niem:mtf:fields" xmlns:xsd="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:int:nato:ncdf:mtf:niem:mtf:composites"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="../../IC-ISM.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../../../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../../../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../../../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:appinfo" schemaLocation="../../../NIEM/mtfappinfo.xsd"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:mtf:fields" schemaLocation="{concat($mid,'_fields.xsd')}"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat($message/xsd:annotation/xsd:appinfo/*:Msg/@name, ' COMPOSITES SCHEMA')"/>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:for-each select="$compositenodes/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:complexType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$compositenodes/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:element[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <!-- FIELDS-->
        <xsl:variable name="fieldnodes">
            <xsl:for-each select="$messagenodes//@*[starts-with(., 'f:')]">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$Fields"/>
                    <xsl:with-param name="prefix" select="'f:'"/>
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="iteration" select="$iterations"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$segmentnodes//@*[starts-with(., 'f:')]">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$Fields"/>
                    <xsl:with-param name="prefix" select="'f:'"/>
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="iteration" select="$iterations"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$setnodes//@*[starts-with(., 'f:')]">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$Fields"/>
                    <xsl:with-param name="prefix" select="'f:'"/>
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="iteration" select="$iterations"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$compositenodes//@*[starts-with(., 'f:')]">
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="data" select="$Fields"/>
                    <xsl:with-param name="prefix" select="'f:'"/>
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="iteration" select="$iterations"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        <xsl:result-document href="{$OutDir}/{$mid}/{concat($mid,'_fields.xsd')}">
            <xsd:schema xmlns="urn:int:nato:ncdf:mtf:niem:mtf:fields" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:int:nato:ncdf:mtf:niem:mtf:fields"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="../../IC-ISM.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../../../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../../../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../../../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:appinfo" schemaLocation="../../../NIEM/mtfappinfo.xsd"/>
                <xsd:import namespace="urn:int:nato:ncdf:mtf:niem:mtf:composites" schemaLocation="{concat($mid,'_composites.xsd')}"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat($message/xsd:annotation/xsd:appinfo/*:Msg/@name, ' FIELDS SCHEMA')"/>
                    </xsd:documentation>
                </xsd:annotation>
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
                <xsl:for-each select="$fieldnodes/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:element[@name = $n]) = 0">
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
        <xsl:if test="$iteration &gt; 0">
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
