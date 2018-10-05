<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="dirpath" select="'../../XSD/NIEM_MTF/'"/>
    <xsl:variable name="ALLMTF" select="document(concat($dirpath, 'NIEM_MTF.xsd'))/xsd:schema"/>
    <xsl:variable name="OutDir" select="'../../XSD/NIEM_MTF/SepMsgs/'"/>

    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="lt" select="'&lt;'"/>
    <xsl:variable name="gt" select="'&gt;'"/>

    <xsl:template name="main">
        <xsl:for-each select="$ALLMTF/xsd:element[xsd:annotation/xsd:appinfo/*:Msg]">
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
        <xsl:variable name="msgid" select="$ALLMTF/*[@name = $message/@type]/xsd:annotation/xsd:appinfo/*:Msg/@mtfid"/>
        <xsl:variable name="mid" select="translate($msgid, ' .:()', '')"/>
        <xsl:variable name="schtron">
            <xsl:value-of
                select="concat($lt, '?xml-model', ' href=', $q, '../../../Baseline_Schema/MTF_Schema_Tests/', $mid, '.sch', $q, ' type=', $q, 'application/xml', $q, ' schematypens=', $q, 'http://purl.oclc.org/dsdl/schematron', $q, '?', $gt)"
            />
        </xsl:variable>
        <xsl:result-document href="{$outdir}/{concat($mid,'.xsd')}">
            <!--<xsl:text>&#10;</xsl:text>
            <xsl:value-of select="$schtron" disable-output-escaping="yes"/>
            <xsl:text>&#10;</xsl:text>-->
            <xsd:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:mtf:mil:6040b:niem:mtf"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="../IC-ISM.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../../NIEM/mtfappinfo.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat($message/xsd:annotation/xsd:appinfo/*:Msg/@mtfname, ' MESSAGE SCHEMA')"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <mtfappinfo:Msg mtfname="{$message/xsd:annotation/xsd:appinfo/*:Msg/@mtfname}" mtfid="{$msgid}"/>
                    </xsd:appinfo>
                </xsd:annotation>
                <xsl:copy-of select="$message"/>
                <xsl:copy-of select="$ALLMTF/xsd:complexType[@name = $message/@type]"/>
                <xsl:variable name="msgnodes">
                    <xsl:for-each select="$ALLMTF/*[@name = $message/@type]//*[@ref | @base | @type]">
                        <xsl:variable name="n" select="@ref | @base | @type"/>
                        <xsl:call-template name="iterateNode">
                            <xsl:with-param name="node" select="$ALLMTF/*[@name = $n]"/>
                            <xsl:with-param name="iteration" select="6"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="subgrps">
                    <xsl:for-each select="$msgnodes/xsd:element[@abstract='true'][xsd:annotation/xsd:appinfo/*:Choice]">
                        <xsl:variable name="n" select="@name"/>
                        <xsl:call-template name="iterateNode">
                            <xsl:with-param name="node" select="$ALLMTF/*[@substitutionGroup = $n]"/>
                            <xsl:with-param name="iteration" select="4"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="all">
                    <xsl:copy-of select="$msgnodes"/>
                    <xsl:copy-of select="$subgrps"/>
                </xsl:variable>
                <xsl:for-each select="$all/xsd:complexType[not(@name = $message/@type)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:complexType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all/xsd:simpleType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:simpleType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all/xsd:element[not(@name = $message/@name)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xsd:element[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="iterateNode">
        <xsl:param name="node"/>
        <xsl:param name="iteration"/>
        <xsl:copy-of select="$node"/>
        <xsl:if test="$iteration &gt; 0">
            <xsl:for-each select="$node//@*[name() = 'ref' or name() = 'type' or name() = 'base' or name() = 'substitutionGroup' or name() = 'abstract'][not(. = $node/@name)]">
                <xsl:variable name="n">
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$n='abstract' and $node/xsd:annotation/xsd:appinfo/*:Choice">
                        <xsl:variable name="s" select="$node/@name"/>
                        <xsl:for-each select="$ALLMTF/*[@substitutionGroup = $s]">
                            <xsl:call-template name="iterateNode">
                                <xsl:with-param name="node" select="."/>
                                <xsl:with-param name="iteration" select="number($iteration - 1)"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="iterateNode">
                            <xsl:with-param name="node" select="$ALLMTF/*[@name = $n]"/>
                            <xsl:with-param name="iteration" select="number($iteration - 1)"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
