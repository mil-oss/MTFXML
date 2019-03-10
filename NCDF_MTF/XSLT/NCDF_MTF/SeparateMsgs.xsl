<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="dirpath" select="'../../XSD/NCDF_MTF/'"/>
    <xsl:variable name="ALLMTF" select="document(concat($dirpath, 'NCDF_MTF.xsd'))/xs:schema"/>

    <xsl:variable name="OutDir" select="'../../XSD/NCDF_MTF/SepMsgs/'"/>

    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="ltt" select="'&lt;'"/>
    <xsl:variable name="gtt" select="'&gt;'"/>
    <xsl:variable name="cmt" select="','"/>

    <xsl:template name="mainsepmsgs">
        <!--RENAME / COPY-->
        <!--<xsl:for-each select="$ALLMTF/xs:element[xs:annotation/xs:appinfo/*:Msg]">
            <xsl:sort select="xs:annotation/xs:appinfo/*:Msg/@mtfid"/>
            <xsl:variable name="mid" select="translate(xs:annotation/xs:appinfo/*:Msg/@mtfid,' .','')"/>
            <xsl:variable name="indoc" select="document(concat($OutDir,'/',$mid,'.xsd'))"/> 
            <xsl:result-document href="{$CopyDir}/{concat($mid,'_REF.xsd')}">
                <xsl:copy-of select="$indoc"/>
            </xsl:result-document>
        </xsl:for-each>-->
        <xsl:result-document href="{concat($dirpath,'/MsgList.xml')}">
            <NATO-MTF>
                <xsl:for-each select="$ALLMTF/xs:element[xs:annotation/xs:appinfo/*:Msg]">
                    <xsl:sort select="xs:annotation/xs:appinfo/*:Msg/@mtfid"/>
                    <Msg id="{translate(xs:annotation/xs:appinfo/*:Msg/@mtfid,' .','')}"/>
                </xsl:for-each>
            </NATO-MTF>
        </xsl:result-document>
        <xsl:for-each select="$ALLMTF/xs:element[xs:annotation/xs:appinfo/*:Msg/@mtfid]">
            <xsl:sort select="xs:annotation/xs:appinfo/*:Msg/@mtfid"/>
            <xsl:variable name="mid" select="translate(xs:annotation/xs:appinfo/*:Msg/@mtfid, ' .', '')"/>
            <xsl:if test="not(document(concat($OutDir, $mid, '.xsd')))">
                <xsl:call-template name="ExtractMessageSchema">
                    <xsl:with-param name="message" select="."/>
                    <xsl:with-param name="outdir" select="$OutDir"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!--*****************************************************-->

    <xsl:template name="ExtractMessageSchema">
        <xsl:param name="message"/>
        <xsl:param name="outdir"/>
        <xsl:variable name="msgid" select="$ALLMTF/*[@name = $message/@type]/xs:annotation/xs:appinfo/*:Msg/@mtfid"/>
        <xsl:variable name="mid" select="translate($msgid, ' .:()', '')"/>
        <xsl:variable name="schtron">
            <xsl:value-of
                select="concat($ltt, '?xml-model', ' href=', $q, '../../../APP-11C-ch1/Consolidated/MTF_Schema_Tests/', $mid, '.sch', $q, ' type=', $q, 'application/xml', $q, ' schematypens=', $q, 'http://purl.oclc.org/dsdl/schematron', $q, '?', $gtt)"
            />
        </xsl:variable>
        <xsl:result-document href="{$outdir}/{concat($mid,'.xsd')}">
            <!--<xsl:text>&#10;</xsl:text>
            <xsl:value-of select="$schtron" disable-output-escaping="yes"/>
            <xsl:text>&#10;</xsl:text>-->
            <xs:schema xmlns="urn:int:nato:ncdf:mtf" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:int:nato:ncdf:mtf" ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xs:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../ncdf/utility/structures/4.0/structures.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../ncdf/localTerminology.xsd"/>
                <xs:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../ncdf/utility/appinfo/4.0/appinfo.xsd"/>
                <xs:import namespace="urn:int:nato:ncdf:mtf:appinfo" schemaLocation="../ncdf/mtfappinfo.xsd"/>
                <xs:annotation>
                    <xs:documentation>
                        <xsl:value-of select="concat($message/xs:annotation/xs:appinfo/*:Msg/@mtfname, ' MESSAGE SCHEMA')"/>
                    </xs:documentation>
                    <xs:appinfo>
                        <mtfappinfo:Msg mtfname="{$message/xs:annotation/xs:appinfo/*:Msg/@mtfname}" mtfid="{$msgid}"/>
                    </xs:appinfo>
                </xs:annotation>
                <xsl:copy-of select="$message"/>
                <xsl:copy-of select="$ALLMTF/xs:complexType[@name = $message/@type]"/>
                <xsl:variable name="msgnodes">
                    <xsl:for-each select="$ALLMTF/*[@name = $message/@type]//*[@ref | @base | @type]">
                        <xsl:variable name="n" select="@ref | @base | @type"/>
                        <xsl:apply-templates select="$ALLMTF/*[@name = $n]" mode="iterateNode">
                            <xsl:with-param name="namelist">
                                <node name="{$n}"/>
                            </xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="subgrps">
                    <xsl:for-each select="$msgnodes/xs:element[@abstract = 'true'][xs:annotation/xs:appinfo/*:Choice]">
                        <xsl:variable name="n" select="@name"/>
                        <xsl:apply-templates select="$ALLMTF/*[@substitutionGroup = $n]" mode="iterateNode">
                            <xsl:with-param name="namelist">
                                <node name="{$n}"/>
                            </xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="all">
                    <xsl:copy-of select="$msgnodes"/>
                    <xsl:copy-of select="$subgrps"/>
                </xsl:variable>
                <xsl:for-each select="$all/xs:complexType[not(@name = $message/@type)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xs:complexType[@name = $n]) = 0">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all/xs:simpleType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xs:simpleType[@name = $n]) = 0">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$all/xs:element[not(@name = $message/@name)]">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="count(preceding-sibling::xs:element[@name = $n]) = 0">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:if>
                </xsl:for-each>
            </xs:schema>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*" mode="iterateNode">
        <xsl:param name="namelist"/>
        <xsl:variable name="node" select="."/>
        <xsl:copy-of select="$node" copy-namespaces="no"/>
        <xsl:for-each select="$node//@*[name() = 'ref' or name() = 'type' or name() = 'base' or name() = 'substitutionGroup' or name() = 'abstract'][not(. = $node/@name)]">
            <xsl:variable name="n">
                <xsl:value-of select="."/>
            </xsl:variable>
            <xsl:if test="not($namelist/node[@name = $n])">
                <xsl:apply-templates select="$ALLMTF/*[@name = $n]" mode="iterateNode">
                    <xsl:with-param name="namelist">
                        <xsl:copy-of select="$namelist"/>
                        <node name="{$n}"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*" mode="identity">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="identity"/>
            <xsl:apply-templates select="text()" mode="identity"/>
            <xsl:apply-templates select="*" mode="identity"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="identity">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

    <xsl:template match="text()" mode="identity">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>


</xsl:stylesheet>
