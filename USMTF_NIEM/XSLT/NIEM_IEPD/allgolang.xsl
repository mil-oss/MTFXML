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
    
    <xsl:include href="go-gen-test.xsl"/>

    <xsl:variable name="project" select="'usmtfxml'"/>
    <xsl:variable name="msglistdoc" select="'../../XSD/NIEM_MTF/SepMsgs/msgmap.xml'"/>
    <xsl:variable name="iepsrc" select="'../../XSD/IEPD/xml/xsd/'"/>
    <xsl:variable name="tgtdir" select="'../../XSD/IEPD/src/mtfmsg/'"/>
    <xsl:variable name="testdata" select="'../../XSD/IEPD/xml/instance/common/mtf-testdata.xml'"/>
    <xsl:variable name="testpath" select="'../../XSD/IEPD/xml/instance/test/'"/>
    
    <xsl:variable name="msglist">
        <xsl:for-each select="document($msglistdoc)/*/*[@mtfid]">
            <xsl:variable name="mid" select="translate(@mtfid, ' .', '')"/>
            <xsl:variable name="lmid" select="lower-case($mid)"/>
            <msg mid="{$mid}" lcmid="{$lmid}"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:for-each select="$msglist/*">
            <xsl:variable name="iepdoc" select="document(concat($iepsrc, @mid, '-iep.xsd'))"/>
            
            <xsl:result-document href="{$tgtdir}/{concat(@lcmid,'/',@lcmid,'.go')}">
                
                <xsl:apply-templates select="$iepdoc/xs:schema/xs:element[1]" mode="gogen">
                    <xsl:with-param name="pckg" select="@lcmid"/>
                </xsl:apply-templates>

            </xsl:result-document>
            <xsl:result-document href="{$tgtdir}/{concat(@lcmid,'/',@lcmid,'_test.go')}">
                
                <xsl:apply-templates select="$iepdoc/xs:schema/xs:element[1]" mode="gotestgen">
                    <xsl:with-param name="pckg" select="@lcmid"/>
                </xsl:apply-templates>
                
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="*" mode="gogen">
        <xsl:param name="pckg"/>
        <xsl:variable name="rootname" select="@name"/>
        <xsl:value-of select="concat('package ',$pckg, $cr, $cr)"/>
        <xsl:value-of select="concat('import ', $qt, 'encoding/xml', $qt, $cr, $cr)"/>
        <xsl:apply-templates select="//xs:schema/xs:element[@name = $rootname]" mode="func">
            <xsl:with-param name="rootname" select="$rootname"/>
            <xsl:with-param name="pckgname" select="$pckg"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="//xs:schema/xs:element[@name = $rootname]">
            <xsl:with-param name="rootname" select="$rootname"/>
            <xsl:with-param name="pckgname" select="$pckg"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="//xs:schema/xs:element[not(@name = $rootname)]">
            <xsl:with-param name="rootname" select="$rootname"/>
            <xsl:with-param name="pckgname" select="$pckg"/>
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="//xs:schema/xs:attributeGroup">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="//xs:schema/xs:attribute">
            <xsl:with-param name="rootname" select="$rootname"/>
            <xsl:with-param name="pckgname" select="$pckg"/>
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="*" mode="gotestgen">
        <xsl:param name="pckg"/>
        <xsl:call-template name="maketests">
            <xsl:with-param name="pckgname" select="$pckg"/>
            <xsl:with-param name="testdata" select="document($testdata)"/>
            <xsl:with-param name="testpath" select="concat($testpath,$pckg,'-instance.xml')"/>
            <xsl:with-param name="testurl" select="concat('https://',$project,'.specchain.org/',$pckg,'/file/instancexml')"/>
        </xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>
 