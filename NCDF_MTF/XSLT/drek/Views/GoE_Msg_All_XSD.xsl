<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="GoEMsgs" select="document('../../XSD/APP-11C-GoE/natomtf_goe_messages.xsd')"/>
    <xsl:param name="GoESets" select="document('../../XSD/APP-11C-GoE/natomtf_goe_sets.xsd')"/>
    <xsl:param name="GoEComposites"
        select="document('../../XSD/APP-11C-GoE/natomtf_goe_composites.xsd')"/>
    <xsl:param name="GoEFields" select="document('../../XSD/APP-11C-GoE/natomtf_goe_fields.xsd')"/>

    <xsl:param name="MsgTag"/>

    <xsl:template match="/">
        <xsl:for-each select="$GoEMsgs/xsd:schema/xsd:complexType">
            <xsl:variable name="elname" select="@name"/>
            <xsl:variable name="msgname" select="xsd:attribute[@name='mtfid']/@fixed"/>
            <xsl:variable name="mid" select="translate($msgname,' .:','')"/>
            <xsl:variable name="message">
                <xsd:schema xmlns="urn:int:nato:mtf:app-11(c):goe:msg"
                    xmlns:set="urn:int:nato:mtf:app-11(c):goe:sets"
                    xmlns:comp="urn:int:nato:mtf:app-11(c):goe:composites"
                    xmlns:field="urn:int:nato:mtf:app-11(c):goe:fields"
                    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                    targetNamespace="urn:int:nato:mtf:app-11(c):goe:msg" xml:lang="en-GB"
                    elementFormDefault="unqualified" attributeFormDefault="unqualified">
                    <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:fields"
                        schemaLocation="{concat($mid,'_fields.xsd')}"/>
                    <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:composites"
                        schemaLocation="{concat($mid,'_composites.xsd')}"/>
                    <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:sets"
                        schemaLocation="{concat($mid,'_sets.xsd')}"/>
                    <xsl:copy-of select="."/>
                    <xsl:copy-of select="$GoEMsgs/xsd:schema/xsd:element[@type=$elname]"/>
                </xsd:schema>
            </xsl:variable>
            <xsl:variable name="sets">
                <xsd:schema xmlns="urn:int:nato:mtf:app-11(c):goe:sets"
                    xmlns:comp="urn:int:nato:mtf:app-11(c):goe:composites"
                    xmlns:field="urn:int:nato:mtf:app-11(c):goe:fields"
                    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                    targetNamespace="urn:int:nato:mtf:app-11(c):goe:sets" xml:lang="en-GB"
                    elementFormDefault="unqualified" attributeFormDefault="unqualified">
                    <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:fields"
                        schemaLocation="{concat($mid,'_fields.xsd')}"/>
                    <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:composites"
                        schemaLocation="{concat($mid,'_composites.xsd')}"/>
                    <!--List of all sets in message at any level - will be duplicates-->
                    <xsl:variable name="setlist">
                        <xsl:for-each
                            select="$message//*[starts-with(@ref,'set:') or starts-with(@base,'set:')]">
                            <xsl:variable name="n">
                                <xsl:value-of select="substring-after(@ref,'set:')"/>
                                <xsl:value-of select="substring-after(@base,'set:')"/>
                            </xsl:variable>
                            <xsl:apply-templates select="$GoESets/xsd:schema/*[@name=$n]" mode="sets"/>
                        </xsl:for-each>
                        <xsl:copy-of
                            select="$GoESets/xsd:schema/xsd:complexType[@name='SetBaseType']"/>
                        <xsl:copy-of
                            select="$GoESets/xsd:schema/xsd:complexType[@name='AmplificationType']"/>
                        <xsl:copy-of
                            select="$GoESets/xsd:schema/xsd:complexType[@name='NarrativeType']"/>
                    </xsl:variable>
                    <xsl:for-each select="$setlist/xsd:complexType">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="not(preceding-sibling::xsd:complexType[@name=$n])">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$setlist/xsd:element">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="not(preceding-sibling::xsd:element[@name=$n])">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                </xsd:schema>
            </xsl:variable>
            <xsl:variable name="composites">
                <xsd:schema xmlns="urn:int:nato:mtf:app-11(c):goe:composites"
                    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                    xmlns:field="urn:int:nato:mtf:app-11(c):goe:fields"
                    targetNamespace="urn:int:nato:mtf:app-11(c):goe:composites" xml:lang="en-GB"
                    elementFormDefault="unqualified" attributeFormDefault="unqualified">
                    <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:fields"
                        schemaLocation="{concat($mid,'_fields.xsd')}"/>
                    <xsd:import namespace="http://www.w3.org/XML/1998/namespace"/>
                    <xsl:variable name="msgcomprefs">
                        <xsl:apply-templates
                            select="$message//*[starts-with(@ref,'comp:') or starts-with(@base,'comp:') or starts-with(@type,'comp:')]"
                            mode="compfld"/>
                        <xsl:apply-templates
                            select="$sets//*[starts-with(@ref,'comp:') or starts-with(@base,'comp:') or starts-with(@type,'comp:')]"
                            mode="compfld"/>
                    </xsl:variable>
                    <xsl:variable name="compnodes">
                        <xsl:for-each select="$msgcomprefs/*">
                            <xsl:variable name="n" select="@name"/>
                            <xsl:if test="not(preceding-sibling::*/@name=$n)">
                                <xsl:copy-of select="$GoEComposites/xsd:schema/*[@name=$n]"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:for-each select="$compnodes/xsd:complexType">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:for-each select="$compnodes/xsd:simpleType">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:for-each select="$compnodes/xsd:element">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsd:schema>
            </xsl:variable>
            <xsl:variable name="fields">
                <xsd:schema xmlns="urn:int:nato:mtf:app-11(c):goe:fields"
                    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                    targetNamespace="urn:int:nato:mtf:app-11(c):goe:fields" xml:lang="en-GB"
                    elementFormDefault="unqualified" attributeFormDefault="unqualified">
                    <xsd:import namespace="http://www.w3.org/XML/1998/namespace"
                        schemaLocation="http://www.w3.org/2001/xml.xsd"/>
                    <xsl:variable name="msgfieldrefs">
                        <xsl:apply-templates
                            select="$message//*[starts-with(@ref,'field:') or starts-with(@base,'field:') or starts-with(@type,'field:')]"
                            mode="fld"/>
                        <xsl:apply-templates
                            select="$sets//*[starts-with(@ref,'field:') or starts-with(@base,'field:') or starts-with(@type,'field:')]"
                            mode="fld"/>
                        <xsl:apply-templates
                            select="$composites//*[starts-with(@ref,'field:') or starts-with(@base,'field:') or starts-with(@type,'field:')]"
                            mode="fld"/>
                    </xsl:variable>
                    <!--<xsl:copy-of select="$msgfieldrefs"/>-->
                    <xsl:variable name="fieldnodes">
                        <xsl:for-each select="$msgfieldrefs/*">
                            <xsl:variable name="n" select="@name"/>
                            <xsl:if test="not(preceding-sibling::*/@name=$n)">
                                <xsl:copy-of select="$GoEFields/xsd:schema/*[@name=$n]"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:for-each select="$fieldnodes/xsd:complexType">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:for-each select="$fieldnodes/xsd:simpleType">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:for-each select="$fieldnodes/xsd:element">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsd:schema>
            </xsl:variable>
            <xsl:result-document href="../../IEPD/{$mid}/{$mid}_msg.xsd">
                <xsl:copy-of select="$message"/>
            </xsl:result-document>
            <xsl:result-document href="../../IEPD/{$mid}/{$mid}_sets.xsd">
                <xsl:copy-of select="$sets"/>
            </xsl:result-document>
            <xsl:result-document href="../../IEPD/{$mid}/{$mid}_composites.xsd">
                <xsl:copy-of select="$composites"/>
            </xsl:result-document>
            <xsl:result-document href="../../IEPD/{$mid}/{$mid}_fields.xsd">
                <xsl:copy-of select="$fields"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="xsd:element[@name]" mode="sets">
        <xsl:param name="parentType"/>
        <xsl:copy-of select="."/>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:apply-templates select=".//xsd:element[@name][not(@type=$t)]" mode="sets"/>
        <xsl:apply-templates select="$GoESets/xsd:schema/xsd:complexType[@name=$t][not(@name='SetBase')][not(@name=$parentType)]" mode="sets"/>
    </xsl:template>

    <xsl:template match="xsd:complexType" mode="sets">
        <xsl:variable name="n" select="@name"/>
        <xsl:copy-of select="."/>
        <xsl:copy-of select="$GoESets/xsd:schema/xsd:element[@type=$n]"/>
    </xsl:template>

    <xsl:template match="*" mode="compfld">
        <xsl:variable name="r" select="substring-after(@ref,'comp:')"/>
        <xsl:variable name="b" select="substring-after(@base,'comp:')"/>
        <xsl:variable name="t" select="substring-after(@type,'comp:')"/>
        <field name="{$r}"/>
        <field name="{$b}"/>
        <field name="{$t}"/>
        <field name="{$GoEComposites/xsd:schema/xsd:element[@name=$r]/@type}"/>
        <field name="{$GoEComposites/xsd:schema/xsd:element[@type=$t]/@name}"/>
        <field name="{$GoEComposites/xsd:schema/xsd:element[@type=$b]/@name}"/>
    </xsl:template>

    <xsl:template match="*" mode="fld">
        <xsl:variable name="r" select="substring-after(@ref,'field:')"/>
        <xsl:variable name="b" select="substring-after(@base,'field:')"/>
        <xsl:variable name="t" select="substring-after(@type,'field:')"/>
        <field name="{$r}"/>
        <field name="{$b}"/>
        <field name="{$t}"/>
        <field name="{$GoEFields/xsd:schema/xsd:element[@name=$r]/@type}"/>
        <field name="{$GoEFields/xsd:schema/xsd:element[@type=$t]/@name}"/>
        <field name="{$GoEFields/xsd:schema/xsd:element[@type=$b]/@name}"/>
    </xsl:template>

</xsl:stylesheet>
