<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="text"/>
    
    <xsl:param name="mtfmsgs" select="document('../../MTFXML/NATO_MTF/XSD/APP-11C-GoE/natomtf_goe_messages.xsd')"/>
    <xsl:param name="mtfsets" select="document('../../MTFXML/NATO_MTF/XSD/APP-11C-GoE/natomtf_goe_sets.xsd')"/>
    <xsl:param name="mtfcomposites" select="document('../../MTFXML/NATO_MTF/XSD/APP-11C-GoE/natomtf_goe_composites.xsd')"/>
    <xsl:param name="mtffields" select="document('../../MTFXML/NATO_MTF/XSD/APP-11C-GoE/natomtf_goe_fields.xsd')"/>
    
    <xsl:param name="mtfinstance" select="document('../xml/instance1.xml')"/>
    
    <xsl:variable name="mtfid" select="$mtfinstance//MessageIdentifier/MessageTextFormatIdentifier/text()"/>
    <xsl:variable name="msgschema" select="$mtfmsgs/xsd:schema/xsd:complexType[xsd:attribute[@name='mtfid'][@fixed=$mtfid]]"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="$mtfinstance/*/*" mode="sets"/>
    </xsl:template>
    
    <xsl:template match="*" mode="sets">
        <xsl:variable name="n">
            <xsl:choose>
                <xsl:when test="contains(name(),':')">
                    <xsl:value-of select="substring-after(name(),':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="settype" select="$mtfsets/xsd:schema/xsd:element[@name=$n]/@type"/>
        <xsl:variable name="set" select="$mtfsets/xsd:schema/*[@name=$settype]"/>
        <xsl:choose>
            <xsl:when test="$set">
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$set/xsd:annotation/xsd:appinfo/*:SetFormat/@SetFormatIdentifier"/>
                <xsl:apply-templates select="*"/>
                <xsl:text>//&#10;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*" mode="sets"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[descendant::*]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="*[not(descendant::*)][text()]">
        <xsl:variable name="n">
            <xsl:choose>
                <xsl:when test="contains(name(),':')">
                    <xsl:value-of select="substring-after(name(),':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="xsdset" select="ancestor::*[contains(name(),':')][1]"/>
        <xsl:variable name="xsdfield" select="$xsdset/descendant::*[name()=$n or substring-after(name(),':')=$n]"/>
        <xsl:variable name="xsdsetname">
            
        </xsl:variable>
        
        <xsl:value-of select="$xsdfield"/>
        <!--<xsl:if test="$xsdfield//*:FieldFormat/@FieldDescriptor">
            <xsl:value-of select="$xsdfield"/>
            <xsl:text>:</xsl:text>
        </xsl:if>-->
        <xsl:apply-templates select="text()" mode="content"/>
    </xsl:template>    
    <xsl:template match="text()" mode="content">
        <xsl:text>/</xsl:text>
        <xsl:choose>
            <xsl:when test=".=' ' or .=''">
                <xsl:text>-</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>    
    <xsl:template match="text()"/>
    <xsl:template match="@*"/>
    <xsl:template name="getname">
        <xsl:param name="nstr"/>
        <xsl:choose>
            <xsl:when test="contains($nstr,':')">
                <xsl:value-of select="substring-after($nstr,':')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$nstr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>