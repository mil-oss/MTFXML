<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="xsdpath" select="'../../../XSD/NIEM_IEPD/MILSTD_MTF/MILSTD_MTF.xsd'"/>
    <xsl:variable name="MILSTDMTF" select="document($xsdpath)/xs:schema"/>
    <xsl:variable name="OutDir" select="'../../../XSD/NIEM_IEPD/MILSTD_MTF/SepMsgs/'"/>

    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="lt" select="'&lt;'"/>
    <xsl:variable name="gt" select="'&gt;'"/>

    <xsl:template name="iepdmain">
        <xsl:for-each select="$MILSTDMTF/xs:element[xs:annotation/xs:appinfo/*:Msg]">
            <xsl:call-template name="ExtractMessageSchema">
                <xsl:with-param name="message" select="."/>
                <xsl:with-param name="outdir" select="$OutDir"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <!--*****************************************************-->
    
    <xsl:template name="ExtractMessageSchema">
        <xsl:param name="message"/>
        <xsl:param name="outdir"/>
        <xsl:variable name="msgid" select="$MILSTDMTF/*[@name = $message/@type]/xs:annotation/xs:appinfo/*:Msg/@mtfid"/>
        <xsl:variable name="mid" select="translate($msgid, ' .:()', '')"/>
        <!--<xsl:variable name="schtron">
            <xsl:value-of
                select="concat($lt, '?xml-model', ' href=', $q, '../../../Baseline_Schema/MTF_Schema_Tests/', $mid, '.sch', $q, ' type=', $q, 'application/xml', $q, ' schematypens=', $q, 'http://purl.oclc.org/dsdl/schematron', $q, '?', $gt)"
            />
        </xsl:variable>-->
        <xsl:result-document href="{$outdir}/{concat($mid,'.xsd')}">
            <!--<xsl:text>&#10;</xsl:text>
            <xsl:value-of select="$schtron" disable-output-escaping="yes"/>
            <xsl:text>&#10;</xsl:text>-->
            <xs:schema xmlns="urn:mtf:mil:6040b:niem:mtf" 
                xmlns:ism="urn:us:gov:ic:ism"
                xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                targetNamespace="urn:mtf:mil:6040b:niem:mtf"
               attributeFormDefault="unqualified" version="1.0">
                <xs:import namespace="urn:us:gov:ic:ism" schemaLocation="../ext/ic-xml/ic-icm.xsd"/>
                <xs:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../mtfappinfo.xsd"/>
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="concat($message/xs:annotation/xs:appinfo/*:Msg/@mtfname, ' MESSAGE SCHEMA')"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <mtfappinfo:Msg mtfname="{$message/xs:annotation/xs:appinfo/*:Msg/@mtfname}" mtfid="{$msgid}"/>
                    </xs:appinfo>
                </xs:annotation>
                <xsl:copy-of select="$message"/>
                <xsl:copy-of select="$MILSTDMTF/xs:complexType[@name = $message/@type]"/>
                <xsl:variable name="all">
                    <xsl:for-each select="$MILSTDMTF/*[@name = $message/@type]//*[@ref | @base | @type]">
                        <xsl:variable name="n" select="@ref | @base | @type"/>
                        <xsl:call-template name="iterateNode">
                            <xsl:with-param name="node" select="$MILSTDMTF/*[@name = $n]"/>
                            <xsl:with-param name="iteration" select="18"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:for-each select="$all/xs:complexType[not(@name = $message/@type)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xs:complexType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all/xs:simpleType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xs:simpleType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all/xs:element[not(@name = $message/@name)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xs:element[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xs:schema>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="iterateNode">
        <xsl:param name="node"/>
        <xsl:param name="iteration"/>
        <xsl:copy-of select="$node"/>
        <xsl:if test="$iteration &gt; 0">
            <xsl:for-each select="$node//@*[name() = 'ref' or name() = 'type' or name() = 'base'][not(. = $node/@name)]">
                <xsl:variable name="n">
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="node" select="$MILSTDMTF/*[@name = $n]"/>
                    <xsl:with-param name="iteration" select="number($iteration - 1)"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
