<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="allmtf" select="document('../../XSD/NIEM_MTF/NIEM_MTF_REF.xsd')/*:schema"/>
    <xsl:variable name="outDir" select="'../../XSD/NIEM_MTF/SepMsgs/'"/>

    <!--<xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="lt" select="'&lt;'"/>
    <xsl:variable name="gt" select="'&gt;'"/>-->

    <xsl:variable name="nodeiteration" select="20"/>
    <xsl:variable name="subgrpiteration" select="20"/>

    <xsl:template name="sepmain">
        <xsl:for-each
            select="$allmtf/*:element[*:annotation/*:appinfo/*:Msg[@mtfid = 'SUBDANGER']]">
            <xsl:call-template name="ExtractMessageSchema">
                <xsl:with-param name="message" select="."/>
                <xsl:with-param name="outdir" select="$outDir"/>
                <!--<xsl:with-param name="allMTF" select="$allmtf"/>-->
            </xsl:call-template>
        </xsl:for-each>
       <!-- <xsl:for-each
            select="$allmtf/*:element[*:annotation/*:appinfo/*:Msg[@mtfid = 'OPTASK AAW']]">
            <xsl:call-template name="ExtractMessageSchema">
                <xsl:with-param name="message" select="."/>
                <xsl:with-param name="outdir" select="$outDir"/>
                <!-\-<xsl:with-param name="allMTF" select="$allmtf"/>-\->
            </xsl:call-template>
        </xsl:for-each>-->
    </xsl:template>
    <!--*****************************************************-->
    <xsl:template name="ExtractMessageSchema">
        <xsl:param name="message"/>
        <xsl:param name="outdir"/>
        <!--<xsl:param name="allMTF"/>-->
        <xsl:variable name="msgid" select="$allmtf/*[@name = $message/@type]/*:annotation/*:appinfo/*:Msg/@mtfid"/>
        <xsl:variable name="mid" select="translate($msgid, ' .:()', '')"/>
        <xsl:variable name="msgnodes">
            <xsl:for-each
                select="$allmtf/*:complexType[@name = $message/@type]//xs:*[@ref | @base | @type]">
                <xsl:variable name="n" select="@ref | @base | @type"/>
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="node" select="$allmtf/xs:*[@name = $n]"/>
                    <xsl:with-param name="iteration" select="$nodeiteration"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="subgrps">
            <xsl:for-each
                select="$msgnodes/*:element[@abstract = 'true'][*:annotation/*:appinfo/*:Choice]">
                <xsl:variable name="n" select="@name"/>
                <xsl:call-template name="iterateNode">
                    <xsl:with-param name="node" select="$allmtf/*[@substitutionGroup = $n]"/>
                    <xsl:with-param name="iteration" select="$subgrpiteration"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="all">
            <xsl:copy-of select="$msgnodes"/>
            <xsl:copy-of select="$subgrps"/>
        </xsl:variable>
        
        <xsl:variable name="schtron">
            <xsl:value-of
                select="concat('&lt;', '?xml-model', ' href=', '&quot;', '../../../Baseline_Schema/MTF_Schema_Tests/', $mid, '.sch', '&quot;', ' type=', '&quot;', 'application/xml', '&quot;', ' schematypens=', '&quot;', 'http://purl.oclc.org/dsdl/schematron', '&quot;', '?', '&gt;')"
            />
        </xsl:variable>
        <xsl:result-document href="{$outdir}/{concat($mid,'-REF.xsd')}">
            <!--<xsl:text>&#10;</xsl:text>
            <xsl:value-of select="$schtron" disable-output-escaping="yes"/>
            <xsl:text>&#10;</xsl:text>-->
            <xs:schema xmlns="urn:mtf:mil:6040b:niem:mtf"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ism="urn:us:gov:ic:ism"
                xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
                xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/"
                xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument"
                xml:lang="en-US" elementFormDefault="unqualified" attributeFormDefault="unqualified"
                version="1.0">
                <xs:import namespace="urn:us:gov:ic:ism" schemaLocation="./ext/ic-xml/ic-ism.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/structures/4.0/"
                    schemaLocation="./ext/niem/utility/structures/4.0/structures.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/localTerminology/3.0/"
                    schemaLocation="./ext/localTerminology.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/appinfo/4.0/"
                    schemaLocation="./ext/niem/appinfo/4.0/appinfo.xsd"/>
                <xs:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="./ext/mtfappinfo.xsd"/>
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of
                            select="concat($message/*:annotation/*:appinfo/*:Msg/@mtfname, ' MESSAGE SCHEMA')"
                        />
                    </xs:documentation>
                    <xs:appinfo>
                        <mtfappinfo:Msg mtfname="{$message/*:annotation/*:appinfo/*:Msg/@mtfname}"
                            mtfid="{$msgid}"/>
                    </xs:appinfo>
                </xs:annotation>
                <xsl:copy-of select="$message"/>
                <xsl:copy-of select="$allmtf/*:complexType[@name = $message/@type]"/>
                <xsl:for-each select="$all/*:complexType[not(@name = $message/@type)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::*:complexType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all/*:simpleType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::*:simpleType[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all/*:element[not(@name = $message/@name)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::*:element[@name = $n]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xs:schema>
        </xsl:result-document>
    </xsl:template>
    <!--<xsl:template name="iterateNode">
        <xsl:param name="node"/>
        <xsl:param name="iteration"/>
        <xsl:param name="nodelist"/>
        <!-\-<xsl:param name="allMTF"/>-\->
        <xsl:copy-of select="$node"/>
        <xsl:if test="$iteration &gt; 0">
            <xsl:for-each
                select="$node//@*[name() = 'ref' or name() = 'type' or name() = 'base' or name() = 'substitutionGroup' or name() = 'abstract'][not(. = $node/@name)]">
                <xsl:variable name="n">
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:if test="$n = 'Remarks' or not(contains($nodelist, concat($n, ',')))">
                    <xsl:choose>
                        <xsl:when test="$n = 'abstract' and $node/*:annotation/*:appinfo/*:Choice">
                            <xsl:variable name="s" select="$node/@name"/>
                            <xsl:for-each select="$allmtf/xs:element[@substitutionGroup = $s]">
                                <xsl:call-template name="iterateNode">
                                    <xsl:with-param name="node" select="."/>
                                    <xsl:with-param name="iteration" select="number($iteration - 1)"/>
                                    <xsl:with-param name="nodelist" select="concat($nodelist, $n, ',')"/>
                                   <!-\- <xsl:with-param name="allMTF" select="$allMTF"/>-\->
                                </xsl:call-template>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="iterateNode">
                                <xsl:with-param name="node" select="$allmtf/xs:*[@name = $n]"/>
                                <xsl:with-param name="iteration" select="number($iteration - 1)"/>
                                <xsl:with-param name="nodelist" select="concat($nodelist, $n, ',')"/>
                                <!-\-<xsl:with-param name="allMTF" select="$allMTF"/>-\->
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
-->
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
                    <xsl:when test="$n = 'abstract' and $node/*:annotation/*:appinfo/*:Choice">
                        <xsl:variable name="s" select="$node/@name"/>
                        <xsl:for-each select="$allmtf/*[@substitutionGroup = $s]">
                            <xsl:call-template name="iterateNode">
                                <xsl:with-param name="node" select="."/>
                                <xsl:with-param name="iteration" select="number($iteration - 1)"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="iterateNode">
                            <xsl:with-param name="node" select="$allmtf/*[@name = $n]"/>
                            <xsl:with-param name="iteration" select="number($iteration - 1)"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
