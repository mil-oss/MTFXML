<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="Msgs" select="document('../../XSD/GoE_Schema/GoE_messages.xsd')"/>
    <xsl:variable name="Segments" select="document('../../XSD/GoE_Schema/GoE_segments.xsd')"/>
    <xsl:variable name="Sets" select="document('../../XSD/GoE_Schema/GoE_sets.xsd')"/>
    <xsl:variable name="Fields" select="document('../../XSD/GoE_Schema/GoE_fields.xsd')"/>
    <xsl:variable name="MsgId" select="'ACO'"/>
    <xsl:template name="ExtractMessageSchemas">
        <xsl:param name="msgident" select="$MsgId"/>
        <xsl:for-each select="$Msgs/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*:Msg/@identifier = $msgident]">
            <xsl:variable name="elname" select="@name"/>
            <xsl:variable name="msgname" select="xsd:attribute[@name = 'mtfid']/@fixed"/>
            <xsl:variable name="mid" select="translate($msgname, ' .:', '')"/>
            <xsl:variable name="message">
                <xsl:copy-of select="."/>
                <xsl:copy-of select="$Msgs/xsd:schema/xsd:element[@type = $elname]"/>
            </xsl:variable>
            <xsl:variable name="segments">
                <!--List of all segments in message at any level - may be duplicates-->
                <xsl:variable name="seglist">
                    <xsl:apply-templates select="$message//*[starts-with(@ref, 'seg:') or starts-with(@base, 'seg:') or starts-with(@type, 'seg:')]" mode="seg"/>
                </xsl:variable>
                <xsl:copy-of select="$seglist"/>
                <xsl:for-each select="$seglist/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::xsd:complexType[@name = $n])">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$seglist/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::xsd:element[@name = $n])">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="sets">
                <!--List of all sets in message at any level - will be duplicates-->
                <xsl:variable name="setlist">
                    <xsl:apply-templates select="$message//*[starts-with(@ref, 'set:') or starts-with(@base, 'set:') or starts-with(@type, 'set:')]" mode="names"/>
                    <xsl:for-each select="$message//*[starts-with(@ref, 'set:') or starts-with(@base, 'set:')]">
                        <xsl:variable name="n">
                            <xsl:value-of select="substring-after(@ref, 'set:')"/>
                            <xsl:value-of select="substring-after(@base, 'set:')"/>
                        </xsl:variable>
                        <xsl:apply-templates select="$message//*[starts-with(@ref, 'set:') or starts-with(@base, 'set:') or starts-with(@type, 'set:')]" mode="names"/>
                        <xsl:apply-templates select="$Sets/xsd:schema/*[@name = $n]" mode="names"/>
                        <xsl:apply-templates select="$Sets/xsd:schema/*[@name = $n]//*[@ref][not(contains(@ref,':'))]" mode="names"/>
                        <xsl:apply-templates select="$Sets/xsd:schema/*[@name = $n]//*[@base][not(contains(@base,':'))]" mode="names"/>
                        <xsl:apply-templates select="$Sets/xsd:schema/*[@name = $n]//*[@type][not(contains(@type,':'))]" mode="names"/>
                    </xsl:for-each>
                    <xsl:for-each select="$segments//*[starts-with(@ref, 'set:') or starts-with(@base, 'set:')]">
                        <xsl:variable name="n">
                            <xsl:value-of select="substring-after(@ref, 'set:')"/>
                            <xsl:value-of select="substring-after(@base, 'set:')"/>
                        </xsl:variable>
                        <xsl:apply-templates select="$Sets/xsd:schema/*[@name = $n]" mode="names"/>
                        <xsl:apply-templates select="$Sets/xsd:schema/*[@name = $n]//*[@ref][not(contains(@ref,':'))]" mode="names"/>
                        <xsl:apply-templates select="$Sets/xsd:schema/*[@name = $n]//*[@base][not(contains(@base,':'))]" mode="names"/>
                        <xsl:apply-templates select="$Sets/xsd:schema/*[@name = $n]//*[@type][not(contains(@type,':'))]" mode="names"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:copy-of select="$setlist"/>
                <xsl:variable name="nodelist">
                    <xsl:for-each select="$setlist/*">
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="not(preceding-sibling::*/@name = $n)">
                            <xsl:copy-of select="$Sets/xsd:schema/*[@name = $n]"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:for-each select="$nodelist/xsd:complexType">
                        <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$nodelist/xsd:element">
                        <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="fields">
                <xsl:variable name="msgfieldrefs">
                    <xsl:apply-templates
                        select="$message//*[starts-with(@ref, 'field:') or starts-with(@base, 'field:') or starts-with(@type, 'field:')]" mode="fld"/>
                    <xsl:apply-templates
                        select="$segments//*[starts-with(@ref, 'field:') or starts-with(@base, 'field:') or starts-with(@type, 'field:')]" mode="fld"/>
                    <xsl:apply-templates
                        select="$sets//*[starts-with(@ref, 'field:') or starts-with(@base, 'field:') or starts-with(@type, 'field:')]" mode="fld"/>
                </xsl:variable>
                <xsl:variable name="fieldnodes">
                    <xsl:for-each select="$msgfieldrefs/*">
                        <xsl:variable name="n" select="@name"/>
                        <xsl:if test="not(preceding-sibling::*/@name = $n)">
                            <xsl:copy-of select="$Fields/xsd:schema/*[@name = $n]"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="fieldrefs">
                    <xsl:for-each select="$fieldnodes//*">
                        <xsl:variable name="r" select="@ref"/>
                        <xsl:variable name="b" select="@base"/>
                        <xsl:variable name="t" select="@type"/>
                        <xsl:apply-templates select="$Fields/xsd:schema/*[@name = $r]" mode="fields"/>
                        <xsl:apply-templates select="$Fields/xsd:schema/*[@name = $b]" mode="fields"/>
                        <xsl:apply-templates select="$Fields/xsd:schema/*[@name = $t]" mode="fields"/>
                    </xsl:for-each>
                    <xsl:copy-of select="$fieldnodes"/>
                </xsl:variable>
                <xsl:for-each select="$fieldrefs/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="$fieldrefs/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="n" select="@name"/>
                    <xsl:if test="not(preceding-sibling::xsd:element/@name = $n)">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:result-document href="../../XSD/Messages/{$mid}/{concat($mid,'_message.xsd')}">
                <xsl:for-each select="$Msgs/xsd:schema">
                    <xsl:copy copy-namespaces="yes">
                        <xsl:apply-templates select="@*" mode="copy"/>
                        <xsl:apply-templates select="xsd:import" mode="copy"/>
                        <xsl:copy-of select="$message"/>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:result-document>
            <xsl:result-document href="../../XSD/Messages/{$mid}/{concat($mid,'_segments.xsd')}">
                <xsl:for-each select="$Segments/xsd:schema[1]">
                    <xsl:copy copy-namespaces="yes">
                        <xsl:apply-templates select="@*" mode="copy"/>
                        <xsl:apply-templates select="xsd:import" mode="copy"/>
                        <xsl:copy-of select="$segments"/>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:result-document>
            <xsl:result-document href="../../XSD/Messages/{$mid}/{concat($mid,'_sets.xsd')}">
                <xsl:for-each select="$Sets/xsd:schema[1]">
                    <xsl:copy copy-namespaces="yes">
                        <xsl:apply-templates select="@*" mode="copy"/>
                        <xsl:apply-templates select="xsd:import" mode="copy"/>
                        <xsl:copy-of select="$sets"/>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:result-document>
            <xsl:result-document href="../../XSD/Messages/{$mid}/{concat($mid,'_fields.xsd')}">
                <xsl:for-each select="$Fields/xsd:schema[1]">
                    <xsl:copy copy-namespaces="yes">
                        <xsl:apply-templates select="@*" mode="copy"/>
                        <xsl:apply-templates select="xsd:import" mode="copy"/>
                        <xsl:copy-of select="$fields"/>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template match="*" mode="getrefs">
        <xsl:copy-of select="."/>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="r" select="@ref"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:variable name="b" select=".//@base"/>
        <xsl:apply-templates select="//xsd:schema/xsd:complexType[@name=$t or @name=$b]" mode="getrefs"/>
        <xsl:apply-templates select="//xsd:schema/xsd:element[@name=$r or @type=$t or @type=$b][not(@name=$n)]" mode="getrefs"/>
    </xsl:template>
    
    <xsl:template match="xsd:complexType" mode="segments">
        <xsl:variable name="n" select="@name"/>
        <xsl:copy-of select="."/>
        <xsl:copy-of select="$Segments/xsd:schema/xsd:element[@type = $n]"/>
    </xsl:template>
    <xsl:template match="xsd:element[@name]" mode="sets">
        <xsl:copy-of select="."/>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:apply-templates select=".//xsd:element[@name][not(@type = $t)]" mode="sets"/>
        <xsl:apply-templates select="$Sets/xsd:schema/xsd:complexType[@name = $t]" mode="sets"/>
    </xsl:template>
    <xsl:template match="xsd:complexType" mode="sets">
        <xsl:variable name="n" select="@name"/>
        <xsl:copy-of select="."/>
        <xsl:copy-of select="$Sets/xsd:schema/xsd:element[@type = $n]"/>
    </xsl:template>
    <xsl:template match="xsd:element[@name]" mode="fields">
        <xsl:copy-of select="."/>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="t" select="@type"/>
        <xsl:variable name="b" select=".//@base"/>
        <xsl:apply-templates select=".//xsd:element[@name][not(@type = $t)]" mode="fields"/>
        <xsl:apply-templates select="$Fields/xsd:schema/xsd:complexType[@name = $t]" mode="fields"/>
        <xsl:apply-templates select="$Fields/xsd:schema/xsd:complexType[@name = $b]" mode="fields"/>
    </xsl:template>
    <xsl:template match="xsd:complexType" mode="fields">
        <xsl:variable name="n" select="@name"/>
        <xsl:copy-of select="."/>
        <xsl:copy-of select="$Fields/xsd:schema/xsd:element[@type = $n]"/>
    </xsl:template>
    
    <xsl:template match="*" mode="seg">
        <xsl:variable name="r" select="substring-after(@ref,'comp:')"/>
        <xsl:variable name="b" select="substring-after(@base,'comp:')"/>
        <xsl:variable name="t" select="substring-after(@type,'comp:')"/>
        <field name="{$r}"/>
        <field name="{$b}"/>
        <field name="{$t}"/>
        <field name="{$Segments/xsd:schema/xsd:element[@name=$r]/@type}"/>
        <field name="{$Segments/xsd:schema/xsd:element[@type=$t]/@name}"/>
        <field name="{$Segments/xsd:schema/xsd:element[@type=$b]/@name}"/>
    </xsl:template>
    
    
    <xsl:template match="*" mode="set">
        <xsl:variable name="r" select="substring-after(@ref,'comp:')"/>
        <xsl:variable name="b" select="substring-after(@base,'comp:')"/>
        <xsl:variable name="t" select="substring-after(@type,'comp:')"/>
        <field name="{$r}"/>
        <field name="{$b}"/>
        <field name="{$t}"/>
        <field name="{$Sets/xsd:schema/xsd:element[@name=$r]/@type}"/>
        <field name="{$Sets/xsd:schema/xsd:element[@type=$t]/@name}"/>
        <field name="{$Sets/xsd:schema/xsd:element[@type=$b]/@name}"/>
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
    
    <xsl:template match="*" mode="fld">
        <xsl:variable name="r" select="substring-after(@ref, 'field:')"/>
        <xsl:variable name="b" select="substring-after(@base, 'field:')"/>
        <xsl:variable name="t" select="substring-after(@type, 'field:')"/>
        <field name="{$r}"/>
        <field name="{$b}"/>
        <field name="{$t}"/>
        <field name="{$Fields/xsd:schema/xsd:element[@name=$r]/@type}"/>
        <field name="{$Fields/xsd:schema/xsd:element[@type=$t]/@name}"/>
        <field name="{$Fields/xsd:schema/xsd:element[@type=$b]/@name}"/>
    </xsl:template>
    <xsl:template match="*" mode="copy">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="copy"/>
            <xsl:apply-templates select="text()" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@schemaLocation" mode="copy">
        <xsl:choose>
            <xsl:when test=". = 'IC-ISM-v2.xsd'">
                <xsl:attribute name="schemaLocation">
                    <xsl:value-of select="concat('../', .)"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="schemaLocation">
                    <xsl:value-of select="concat($MsgId, '_', substring-after(., '_'))"/>
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
