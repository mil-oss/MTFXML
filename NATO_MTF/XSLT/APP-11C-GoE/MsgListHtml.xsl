<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="html" indent="yes"/>


    <xsl:param name="Msgs" select="document('../../XSD/APP-11C-GoE/natomtf_goe_messages.xsd')"/>

    <xsl:template match="/">
        <div id="sidebar" class="ui-layout-west hidden">
            <h3 class="ctrhdr">NATO MTF MESSAGES</h3>
            <div id="fieldtree" class="divcol">
                <h3>Messages</h3>
                <div id="msglinks" class="scrollcol">
                    <xsl:apply-templates select="$Msgs/xsd:schema/xsd:complexType" mode="msg">
                        <xsl:sort select="@name"/>
                    </xsl:apply-templates>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:complexType" mode="msg">
        <xsl:variable name="mid" select="xsd:attribute[@name='mtfid']/@fixed"/>
        <p id="{translate($mid,' :.','')}">
            <span>
                <xsl:value-of select="xsd:annotation[1]/xsd:appinfo[1]/*:MsgInfo[1]/@MtfName"/>
            </span>
        </p>
    </xsl:template>
    
</xsl:stylesheet>
