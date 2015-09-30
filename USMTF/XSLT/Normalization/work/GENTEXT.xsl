<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsd"
    version="2.0">
    
   <xsl:template match="xsd:element[matches(@name,'\w_([0-9]{1,2})$')]" mode="ctype">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="name">
                <xsl:value-of select="substring-before(@name,'_')"/>
            </xsl:attribute>
            <xsl:attribute name="numbered_name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[not(name()='name')]" mode="ctype"/>
            <xsl:apply-templates select="*" mode="ctype"/>
        </xsl:copy>
    </xsl:template>
    
       <xsl:template match="xsd:extension[@base='s:GeneralTextType']" mode="ctype">
        <xsl:variable name="apos">&#34;</xsl:variable>
        <xsl:variable name="quot">"</xsl:variable>
        <xsl:variable name="per">.</xsl:variable>
        <xsl:variable name="UseDesc">
            <xsl:value-of select="upper-case(*/ancestor::xsd:element[1]/xsd:annotation/xsd:appinfo/*:SetFormatPositionUseDescription)"/>
        </xsl:variable>
        <xsl:variable name="TextInd">
            <xsl:choose>
                <xsl:when test="contains($UseDesc,$per)">
                    <xsl:value-of select="normalize-space(substring-before(substring-after($UseDesc,'MUST EQUAL'),$per))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(substring-after($UseDesc,'MUST EQUAL'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="xsd:restriction">
            <xsl:attribute name="base">
                <xsl:text>set:GeneralTextType</xsl:text>
            </xsl:attribute>
            <xsl:element name="xsd:sequence">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="ref">
                        <xsl:text>field:GentextTextIndicator</xsl:text></xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:text>field:GentextTextIndicatorSimpleType</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="fixed">
                        <xsl:value-of select="replace($TextInd,$apos,'')"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="xsd:attribute" mode="ctype"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>