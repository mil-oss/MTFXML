<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2019 JD NEUSHUL
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ism="urn:us:gov:ic:ism" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="text"/>

    <xsl:variable name="msglistdoc" select="'../../XSD/NIEM_MTF/SepMsgs/msgmap.xml'"/>

    <xsl:variable name="tgtdir" select="'../../XSD/IEPD/configs/'"/>

    <xsl:variable name="project" select="'USMTF'"/>
    <xsl:variable name="name" select="'usmtf'"/>
    <xsl:variable name="title" select="concat($project, '-XML Information Exchange Package (IEP)')"/>
    <xsl:variable name="host" select="concat('https://', $name, '.specchain.org/')"/>
    <xsl:variable name="port" select="'8080'"/>
    <xsl:variable name="dbloc" select="concat('tmp/', $name, '-xml/db/', $name, '-xml.db')"/>
    <xsl:variable name="configfile" select="concat('config/', $name, '-xml-cfg.json')"/>
    <xsl:variable name="reflink" select="concat('https://', $name, '.specchain.org/', $name, '-xml/file/refxsd')"/>
    <xsl:variable name="testlink" select="concat('https://', $name, '.specchain.org/', $name, '-xml/file/testdataxml')"/>
    <xsl:variable name="configurl" select="concat('https://', $name, '.specchain.org/config')"/>
    <xsl:variable name="tempdir" select="'tmp/'"/>
    <xsl:variable name="temppath" select="concat('tmp/', $name, '-xml/')"/>

    <xsl:variable name="msglist">
        <xsl:for-each select="document($msglistdoc)/*/*[@mtfid]">
            <xsl:variable name="mid" select="translate(@mtfid, ' .', '')"/>
            <xsl:variable name="lmid" select="lower-case($mid)"/>
            <msg mid="{$mid}" lcmid="{$lmid}"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template name="prjcfg">
        <xsl:value-of select="$lb"/>
        <xsl:value-of select="concat($q, 'project', $q, ':', $q, $project, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'title', $q, ':', $q, $title, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'host', $q, ':', $q, $host, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'port', $q, ':', $q, $port, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'dbloc', $q, ':', $q, $title, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'configfile', $q, ':', $q, $configfile, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'reflink', $q, ':', $q, $reflink, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'testlink', $q, ':', $q, $testlink, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'configurl', $q, ':', $q, $configurl, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'tempdir', $q, ':', $q, $tempdir, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'temppath', $q, ':', $q, $temppath, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'resources', $q, ':', $lbr)"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'refxsd'"/>
            <xsl:with-param name="filename" select="concat($name, '-niem-ref.xsd')"/>
            <xsl:with-param name="src" select="concat('xml/xsd/', $name, '-niem-ref.xsd')"/>
            <xsl:with-param name="path" select="concat('xml/xsd/', $name, '-niem-ref.xsd')"/>
            <xsl:with-param name="description" select="concat('NIEM Conformant Reference XML Schema for ', $project, '-XML data')"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'refxsdjson'"/>
            <xsl:with-param name="filename" select="concat($name, '-niem-ref-xsd.json')"/>
            <xsl:with-param name="src" select="concat('json/', $name, '-niem-ref-xsd.json')"/>
            <xsl:with-param name="path" select="concat('json/', $name, '-niem-ref-xsd.json')"/>
            <xsl:with-param name="description" select="concat('JSON Representation of Reference XML Schema for ', $project, '-XML data')"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'testdataxml'"/>
            <xsl:with-param name="filename" select="concat($name, '-xml-test-data.xml')"/>
            <xsl:with-param name="src" select="concat('xml/instance/', $name, '-testdata.xml')"/>
            <xsl:with-param name="path" select="concat('xml/instance/', $name, '-testdata.xml')"/>
            <xsl:with-param name="description" select="concat('Test values for all ', $project, '-XML data items')"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'dochtml'"/>
            <xsl:with-param name="filename" select="concat($name, '-ref.html')"/>
            <xsl:with-param name="src" select="concat('xml/instance/', $name, '-ref.html')"/>
            <xsl:with-param name="path" select="concat('xml/instance/', $name, '-ref.html')"/>
            <xsl:with-param name="description" select="'Autogenerated documentation'"/>
        </xsl:call-template>
        <xsl:value-of select="$rbr"/>
        <xsl:value-of select="$cm"/>
        <xsl:value-of select="concat($q, 'implementations', $q, ':', $lbr)"/>
        <xsl:for-each select="$msglist/*">
            <xsl:call-template name="implementationlisting">
                <xsl:with-param name="ititle" select="@mid"/>
                <xsl:with-param name="iname" select="concat(@lcmid, '-iep')"/>
                <xsl:with-param name="isrc" select="concat('config/', @lcmid, '-cfg.json')"/>
                <xsl:with-param name="isrcurl" select="concat('https://', $name, '.specchain.org/', @lcmid, '/file/config')"/>
                <xsl:with-param name="ipath" select="concat('config/', @lcmid, '-cfg.json')"/>
                <xsl:with-param name="idescription" select="concat(@mid, ' XML Information Exchange Package')"/>
            </xsl:call-template>
            <xsl:if test="following-sibling::*">
                <xsl:value-of select="$cm"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="$rbr"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template name="resourcelisting">
        <xsl:param name="rname"/>
        <xsl:param name="filename"/>
        <xsl:param name="src"/>
        <xsl:param name="path"/>
        <xsl:param name="description"/>
        <xsl:value-of select="$lb"/>
        <xsl:value-of select="concat($q, 'name', $q, ':', $q, $rname, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'filename', $q, ':', $q, $filename, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'src', $q, ':', $q, $src, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'path', $q, ':', $q, $path, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'description', $q, ':', $q, $description, $q)"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>
    
    <xsl:template name="directorylisting">
        <xsl:param name="rname"/>
        <xsl:param name="src"/>
        <xsl:param name="path"/>
        <xsl:value-of select="$lb"/>
        <xsl:value-of select="concat($q, 'name', $q, ':', $q, $rname, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'src', $q, ':', $q, $src, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'path', $q, ':', $q, $path, $q)"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template name="implementationlisting">
        <xsl:param name="ititle"/>
        <xsl:param name="iname"/>
        <xsl:param name="isrc"/>
        <xsl:param name="isrcurl"/>
        <xsl:param name="ipath"/>
        <xsl:param name="idescription"/>
        <xsl:value-of select="$lb"/>
        <xsl:value-of select="concat($q, 'title', $q, ':', $q, $ititle, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'name', $q, ':', $q, $iname, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'src', $q, ':', $q, $isrc, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'srcurl', $q, ':', $q, $isrcurl, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'path', $q, ':', $q, $ipath, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'description', $q, ':', $q, $idescription, $q)"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template name="implementationconfig">
        <xsl:param name="cproject"/>
        <xsl:param name="ctitle"/>
        <xsl:param name="cconfigfile"/>
        <xsl:param name="creflink"/>
        <xsl:param name="ctestlink"/>
        <xsl:param name="chost"/>
        <xsl:param name="cport"/>
        <xsl:param name="cdbloc"/>
        <xsl:param name="ctempdir"/>
        <xsl:param name="ctemppath"/>
        <xsl:value-of select="$lb"/>
        <xsl:value-of select="concat($q, 'project', $q, ':', $q, $cproject, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'title', $q, ':', $q, $ctitle, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'configfile', $q, ':', $q, $cconfigfile, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'reflink', $q, ':', $q, $creflink, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'testlink', $q, ':', $q, $ctestlink, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'host', $q, ':', $q, $chost, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'port', $q, ':', $q, $cport, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'dbloc', $q, ':', $q, $cdbloc, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'tempdir', $q, ':', $q, $ctempdir, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'temppath', $q, ':', $q, $ctemppath, $q, $cm)"/>
        <xsl:value-of select="concat($q, 'resources', $q, ':', $lbr)"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'config'"/>
            <xsl:with-param name="filename" select="concat(@lcmid, '-cfg.json')"/>
            <xsl:with-param name="src" select="concat('config/', @lcmid, '-cfg.json')"/>
            <xsl:with-param name="path" select="concat('config/', @lcmid, '-cfg.json')"/>
            <xsl:with-param name="description" select="concat(@mid, ' XML IEP Configuration Information')"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'refxsd'"/>
            <xsl:with-param name="filename" select="concat($name, '-niem-ref.xsd')"/>
            <xsl:with-param name="src" select="concat('xml/xsd/', $name, '-niem-ref.xsd')"/>
            <xsl:with-param name="path" select="concat('xml/xsd/ext/', $name, '-niem-ref.xsd')"/>
            <xsl:with-param name="description" select="concat('XML Schema for ', $title, ' information exchange')"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'iepxsd'"/>
            <xsl:with-param name="filename" select="concat(@lcmid, '-iep.xsd')"/>
            <xsl:with-param name="src" select="concat('iepd/', @lcmid, '/xml/xsd/', @lcmid, '-iep.xsd')"/>
            <xsl:with-param name="path" select="concat('xml/xsd/', @lcmid, '-iep.xsd')"/>
            <xsl:with-param name="description" select="concat('XML Schema for ', @mid, ' information exchange')"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'xmlschemaxsd'"/>
            <xsl:with-param name="filename" select="'xml/xsd/ext/w3c/XMLSchema.xsd'"/>
            <xsl:with-param name="src" select="'xml/xsd/ext/w3c/XMLSchema.xsd'"/>
            <xsl:with-param name="path" select="concat('config/', @lcmid, '-cfg.json')"/>
            <xsl:with-param name="description" select="'W3C XML Schema for XSD validation'"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'xsltxsd'"/>
            <xsl:with-param name="filename" select="'xslt.xsd'"/>
            <xsl:with-param name="src" select="'xml/xsd/ext/w3c/xslt.xsd'"/>
            <xsl:with-param name="path" select="'xml/xsd/ext/w3c/xslt.xsd'"/>
            <xsl:with-param name="description" select="'W3C XML Schema for XSD validation'"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'iepxsdxsl'"/>
            <xsl:with-param name="filename" select="concat(@lcmid, '-iep.xsl')"/>
            <xsl:with-param name="src" select="concat('iepd/ic-boe/xml/xsl/', @lcmid, '-iep.xsl')"/>
            <xsl:with-param name="path" select="concat('xml/xsl/', @lcmid, '-iep.xsl')"/>
            <xsl:with-param name="description" select="concat('XSLT to generate the ', @mid, ' Implementation Schema')"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'instancexsl'"/>
            <xsl:with-param name="filename" select="concat(@lcmid, '-instance.xsl')"/>
            <xsl:with-param name="src" select="concat('iepd/ic-boe/xml/xsl/', @lcmid, '-instance.xsl')"/>
            <xsl:with-param name="path" select="concat('xml/xsl/', @lcmid, '-instance.xsl')"/>
            <xsl:with-param name="description" select="concat('XSLT to generate an ', @mid, ' instance using test values')"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'gogenxsdxsl'"/>
            <xsl:with-param name="filename" select="concat(@lcmid, '-go-gen.xsl')"/>
            <xsl:with-param name="src" select="concat('iepd/', @lcmid, '/xml/xsl/', @lcmid, '-go-gen.xsl')"/>
            <xsl:with-param name="path" select="concat('xml/xsl/', @lcmid, '-go-gen.xsl')"/>
            <xsl:with-param name="description" select="concat('XSLT to generate a GOLANG Struct for', @mid, ' information')"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'gotestgenxsl'"/>
            <xsl:with-param name="filename" select="concat(@lcmid, '-go-test-gen.xsl')"/>
            <xsl:with-param name="src" select="concat('iepd/', @lcmid, '/xml/xsl/', @lcmid, '-go-test-gen.xsl')"/>
            <xsl:with-param name="path" select="concat('xml/xsl/', @lcmid, '-go-test-gen.xsl')"/>
            <xsl:with-param name="description" select="concat('XSLT to generate GOLANG Unit Tests for ', @mid, ' information using test data')"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'xsdjsonxsl'"/>
            <xsl:with-param name="filename" select="'xsd-json.xsl'"/>
            <xsl:with-param name="src" select="'xml/xsl/xsd-json.xsl'"/>
            <xsl:with-param name="path" select="'xml/xsl/common/xsd-json.xsl'"/>
            <xsl:with-param name="description" select="'Common XSLT utility for generating a JSON representation of an XML Schema'"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'xmljsonxsl'"/>
            <xsl:with-param name="filename" select="'xml-json.xsl'"/>
            <xsl:with-param name="src" select="'xml/xsl/xml-json.xsl'"/>
            <xsl:with-param name="path" select="'xml/xsl/common/xml-json.xsl'"/>
            <xsl:with-param name="description" select="'Common XSLT utility for generating a JSON representation of an XML Instance'"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'gendocxsl'"/>
            <xsl:with-param name="filename" select="'docgen.xsl'"/>
            <xsl:with-param name="src" select="'xml/xsl/docgen.xsl'"/>
            <xsl:with-param name="path" select="'xml/xsl/common/docgen.xsl'"/>
            <xsl:with-param name="description" select="'XSLT to generate Documentation from XML Schema'"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'dochtml'"/>
            <xsl:with-param name="filename" select="concat(@lcmid, '-documentation.html')"/>
            <xsl:with-param name="src" select="concat('iepd/', @lcmid, '/xml/instance/', @lcmid, '-documentation.html')"/>
            <xsl:with-param name="path" select="concat('xml/instance/', @lcmid, '-documentation.html')"/>
            <xsl:with-param name="description" select="'Autogenerated documentation'"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="resourcelisting">
            <xsl:with-param name="rname" select="'zipiepd'"/>
            <xsl:with-param name="filename" select="concat(@lcmid, '-iepd.zip')"/>
            <xsl:with-param name="src" select="''"/>
            <xsl:with-param name="path" select="concat(@lcmid, '-iepd.zip')"/>
            <xsl:with-param name="description" select="'Zipped archive of all Resources'"/>
        </xsl:call-template>
        <xsl:value-of select="$rbr"/>
        <xsl:value-of select="$cm"/>
        <xsl:value-of select="concat($q, 'directories', $q, ':', $lbr)"/>
        <xsl:call-template name="directorylisting">
            <xsl:with-param name="rname" select="'niem'"/>
            <xsl:with-param name="src" select="'xml/xsd/ext/niem'"/>
            <xsl:with-param name="path" select="'xml/xsd/ext/niem'"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="directorylisting">
            <xsl:with-param name="rname" select="'ic-xsd'"/>
            <xsl:with-param name="src" select="'xml/xsd/ext/ic-xsd'"/>
            <xsl:with-param name="path" select="'xml/xsd/ext/ic-xsd'"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="directorylisting">
            <xsl:with-param name="rname" select="'w3c'"/>
            <xsl:with-param name="src" select="'xml/xsd/ext/w3c'"/>
            <xsl:with-param name="path" select="'xml/xsd/ext/w3c'"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="directorylisting">
            <xsl:with-param name="rname" select="'gostruct'"/>
            <xsl:with-param name="src" select="'src/icboe'"/>
            <xsl:with-param name="path" select="'src/icboe'"/>
        </xsl:call-template>
        <xsl:value-of select="$cm"/>
        <xsl:call-template name="directorylisting">
            <xsl:with-param name="rname" select="'gocode'"/>
            <xsl:with-param name="src" select="'src/xsdprov'"/>
            <xsl:with-param name="path" select="'src/xsdprov'"/>
        </xsl:call-template>
        <xsl:value-of select="$rbr"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="*" mode="implementationcfg">
        <xsl:result-document href="{$tgtdir}/{concat('msgcfgs/',@lcmid,'-config.json')}">
            <xsl:call-template name="implementationconfig">
                <xsl:with-param name="cproject" select="@lcmid"/>
                <xsl:with-param name="ctitle" select="concat(@mid,' XML Information Exchange Package Definition')"/>
                <xsl:with-param name="cconfigfile" select="concat(@lcmid,'-cfg.json')"/>
                <xsl:with-param name="creflink" select="concat('https://', @lcmid, '.specchain.org/', @lcmid, '-xml/file/refxsd')"/>
                <xsl:with-param name="ctestlink" select="concat('https://', @lcmid, '.specchain.org/', @lcmid, '-xml/file/testdataxml')"/>
                <xsl:with-param name="chost" select="concat('https://', $name, '.specchain.org/',@lcmid)"/>
                <xsl:with-param name="cport" select="'8080'"/>
                <xsl:with-param name="cdbloc" select="concat('tmp/', @lcmid, '-xml/db/', @lcmid, '-xml.db')"/>
                <xsl:with-param name="ctempdir" select="'tmp/'"/>
                <xsl:with-param name="ctemppath" select="concat('tmp/', @lcmid, '-xml/')"/>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="main">
        <xsl:result-document href="{$tgtdir}/{concat($name,'-config.json')}">
            <xsl:call-template name="prjcfg"/>
        </xsl:result-document>
        <xsl:apply-templates select="$msglist/*" mode="implementationcfg"/>
    </xsl:template>

    <!--********************** JSON ********************-->
    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="a" select='"&apos;"'/>
    <xsl:variable name="bsl" select="'\'"/>
    <xsl:variable name="ebsl" select="'\\'"/>
    <xsl:variable name="c" select="':'"/>
    <xsl:variable name="lb" select="'{'"/>
    <xsl:variable name="rb" select="'}'"/>
    <xsl:variable name="lbr" select="'['"/>
    <xsl:variable name="rbr" select="']'"/>
    <xsl:variable name="cm" select="','"/>
    <!--*************************************************-->

</xsl:stylesheet>
