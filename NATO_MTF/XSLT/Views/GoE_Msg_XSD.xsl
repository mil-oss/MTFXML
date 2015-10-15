<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <!--<xsl:param name="Msgs" select="'../../XSD/APP-11C-GoE/natomtf_goe_messages.xsd'"/>
    <xsl:param name="Sets" select="'../../XSD/APP-11C-GoE/natomtf_goe_sets.xsd'"/>
    <xsl:param name="Composites" select="'../../XSD/APP-11C-GoE/natomtf_goe_composites.xsd'"/>
    <xsl:param name="Fields" select="'../../XSD/APP-11C-GoE/natomtf_goe_fields.xsd'"/>-->

    <xsl:param name="Msgs"/>
    <xsl:param name="Sets"/>
    <xsl:param name="Composites"/>
    <xsl:param name="Fields"/>
    <xsl:param name="msgtype"/>
    
<!--    <xsl:param name="msgtype"/>
    <xsl:param name="message"/>
    <xsl:param name="sets"/>
    <xsl:param name="composites"/>-->
      
<!--    <xsl:template name="getMsg">
        <xsl:variable name="msg" select="$Msgs/xsd:schema/xsd:complexType[@name=$msgtype]"/>
        <xsl:variable name="mid" select="replace($msg/xsd:attribute[@name='mtfid']/@fixed,' ','_')"/>
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
            <xsl:copy-of select="$Msgs/xsd:schema/xsd:complexType[@name=$msgtype]"/>
            <xsl:copy-of
                select="$Msgs/xsd:schema/xsd:element[@name=substring-before($msgtype,'Type')]"
            />
        </xsd:schema>
    </xsl:template>-->
    
<!--    <xsl:template name="getSets">
        <xsl:variable name="mid" select="replace($message/xsd:schema/xsd:complexType/xsd:attribute[@name='mtfid']/@fixed,' ','_')"/>
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
            <xsl:copy-of select="$Sets/xsd:schema/xsd:complexType[@name='SetBaseType']"/>
            <xsl:copy-of select="$Sets/xsd:schema/xsd:complexType[@name='AmplificationType']"/>
            <xsl:copy-of select="$Sets/xsd:schema/xsd:complexType[@name='NarrativeType']"/>
            <!-\-List of all sets in message at any level - will be duplicates-\->
            <xsl:variable name="setlist">
                <xsl:for-each
                    select="$message//*[starts-with(@ref,'set:') or starts-with(@base,'set:')]">
                    <xsl:element name="set">
                        <xsl:attribute name="name">
                            <xsl:value-of select="substring-after(@ref,'set:')"/>
                            <xsl:value-of select="substring-after(@base,'set:')"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="nodes">
                <xsl:for-each select="$setlist/*">
                    <xsl:variable name="nm" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*[@name=$nm])">
                        <xsl:copy-of select="$Sets/xsd:schema/xsd:element[@name=$nm]"/>
                        <xsl:copy-of select="$Sets/xsd:schema/xsd:complexType[@name=$nm]"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="cmplxTypes">
                <xsl:for-each select="$nodes/xsd:element">
                    <xsl:variable name="tp" select="@type"/>
                    <xsl:copy-of select="$Sets/xsd:schema/xsd:complexType[@name=$tp]"/>
                </xsl:for-each>
                <xsl:for-each select="$nodes/xsd:complexType">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:for-each select="$cmplxTypes/*">
                <xsl:sort select="@name"/>
                <xsl:variable name="nm" select="@name"/>
                <xsl:if test="not(preceding-sibling::*[@name=$nm])">
                    <xsl:copy-of select="."/>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$nodes/xsd:element">
                <xsl:sort select="@name"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsd:schema>
    </xsl:template>-->
    
    <xsl:template name="getComposites">
        
    </xsl:template>
    
<!--    <xsl:template match="/">
        <xsl:call-template name="makeXSD">
            <xsl:with-param name="msgtype" select="$msgtype"/>
        </xsl:call-template>
        <!-\-<xsl:call-template name="makeAll"/>-\->
    </xsl:template>-->

<!--    <xsl:template name="makeAll">
        <xsl:for-each select="$Msgs/xsd:schema/xsd:complexType">
            <xsl:variable name="mid" select="replace(xsd:attribute[@name='mtfid']/@fixed,' ','_')"/>
            <xsl:variable name="msgXSD">
                <xsl:call-template name="makeXSD">
                    <xsl:with-param name="msgtype" select="@name"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:result-document href="{concat('../../IEPD/',$mid,'/',$mid,'_msg.xsd')}">
                <xsl:copy-of select="$msgXSD/msgxsd/message/*"/>
            </xsl:result-document>
            <xsl:result-document href="{concat('../../IEPD/',$mid,'/',$mid,'_sets.xsd')}">
                <xsl:copy-of select="$msgXSD/msgxsd/sets/*"/>
            </xsl:result-document>
            <xsl:result-document href="{concat('../../IEPD/',$mid,'/',$mid,'_composites.xsd')}">
                <xsl:copy-of select="$msgXSD/msgxsd/composites/*"/>
            </xsl:result-document>
            <xsl:result-document href="{concat('../../IEPD/',$mid,'/',$mid,'_fields.xsd')}">
                <xsl:copy-of select="$msgXSD/msgxsd/fields/*"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>-->

    <xsl:template name="makeXSD">
        <xsl:variable name="msg" select="$Msgs/xsd:schema/xsd:complexType[@name=$msgtype]"/>
        <xsl:variable name="mid" select="replace($msg/xsd:attribute[@name='mtfid']/@fixed,' ','_')"/>
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
                <xsl:copy-of select="$Msgs/xsd:schema/xsd:complexType[@name=$msgtype]"/>
                <xsl:copy-of
                    select="$Msgs/xsd:schema/xsd:element[@name=substring-before($msgtype,'Type')]"
                />
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
                <xsl:copy-of select="$Sets/xsd:schema/xsd:complexType[@name='SetBaseType']"/>
                <xsl:copy-of select="$Sets/xsd:schema/xsd:complexType[@name='AmplificationType']"/>
                <xsl:copy-of select="$Sets/xsd:schema/xsd:complexType[@name='NarrativeType']"/>
                <!--List of all sets in message at any level - will be duplicates-->
                <xsl:variable name="setlist">
                    <xsl:for-each
                        select="$message//*[starts-with(@ref,'set:') or starts-with(@base,'set:')]">
                        <xsl:element name="set">
                            <xsl:attribute name="name">
                                <xsl:value-of select="substring-after(@ref,'set:')"/>
                                <xsl:value-of select="substring-after(@base,'set:')"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="nodes">
                    <xsl:for-each select="$setlist/*">
                        <xsl:variable name="nm" select="@name"/>
                        <xsl:if test="not(preceding-sibling::*[@name=$nm])">
                            <xsl:copy-of select="$Sets/xsd:schema/xsd:element[@name=$nm]"/>
                            <xsl:copy-of select="$Sets/xsd:schema/xsd:complexType[@name=$nm]"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="cmplxTypes">
                    <xsl:for-each select="$nodes/xsd:element">
                        <xsl:variable name="tp" select="@type"/>
                        <xsl:copy-of select="$Sets/xsd:schema/xsd:complexType[@name=$tp]"/>
                    </xsl:for-each>
                    <xsl:for-each select="$nodes/xsd:complexType">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:for-each select="$cmplxTypes/*">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="nm" select="@name"/>
                    <xsl:if test="not(preceding-sibling::*[@name=$nm])">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$nodes/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
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
                            <xsl:copy-of select="$Composites/xsd:schema/*[@name=$n]"/>
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
                            <xsl:copy-of select="$Fields/xsd:schema/*[@name=$n]"/>
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
        <msgxsd>
            <message>
                <xsl:copy-of select="$message"/>
            </message>
            <sets>
                <xsl:copy-of select="$sets"/>
            </sets>
            <composites>
                <xsl:copy-of select="$composites"/>
            </composites>
            <fields>
                <xsl:copy-of select="$fields"/>
            </fields>
        </msgxsd>
    </xsl:template>

    <xsl:template match="*" mode="compfld">
        <xsl:variable name="r" select="substring-after(@ref,'comp:')"/>
        <xsl:variable name="b" select="substring-after(@base,'comp:')"/>
        <xsl:variable name="t" select="substring-after(@type,'comp:')"/>
        <field name="{$r}"/>
        <field name="{$b}"/>
        <field name="{$t}"/>
        <field name="{$Composites/xsd:schema/xsd:element[@name=$r]/@type}"/>
        <field name="{$Composites/xsd:schema/xsd:element[@type=$t]/@name}"/>
        <field name="{$Composites/xsd:schema/xsd:element[@type=$b]/@name}"/>
    </xsl:template>

    <xsl:template match="*" mode="fld">
        <xsl:variable name="r" select="substring-after(@ref,'field:')"/>
        <xsl:variable name="b" select="substring-after(@base,'field:')"/>
        <xsl:variable name="t" select="substring-after(@type,'field:')"/>
        <field name="{$r}"/>
        <field name="{$b}"/>
        <field name="{$t}"/>
        <field name="{$Fields/xsd:schema/xsd:element[@name=$r]/@type}"/>
        <field name="{$Fields/xsd:schema/xsd:element[@type=$t]/@name}"/>
        <field name="{$Fields/xsd:schema/xsd:element[@type=$b]/@name}"/>
    </xsl:template>

</xsl:stylesheet>
