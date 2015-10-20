<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsd"
    version="2.0">
    
    <xsl:template name="FieldFrm">
        <xsl:param name="fieldNode"/>
        <xsl:variable name="fieldInfo" select="$fieldNode/xsd:annotation/xsd:appinfo/*:Field"/>
        <xsl:variable name="doc">
            <xsl:choose>
                <xsl:when
                    test="string-length(normalize-space(xsd:annotation/xsd:documentation/text()))&gt;0">
                    <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation/text())"
                    />
                </xsl:when>
                <xsl:when
                    test="string-length(normalize-space(xsd:restriction/xsd:annotation/xsd:documentation/text()))&gt;0">
                    <xsl:value-of
                        select="normalize-space(xsd:restriction/xsd:annotation/xsd:documentation/text())"
                    />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="minlen">
            <xsl:choose>
                <xsl:when test="exists(xsd:restriction/xsd:length)">
                    <xsl:value-of select="xsd:restriction/xsd:length/@value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="exists(xsd:restriction/xsd:minLength)">
                            <xsl:value-of select="xsd:restriction/xsd:minLength/@value"/>
                        </xsl:when>
                        <xsl:when test="exists(xsd:restriction/xsd:minInclusive)">
                            <xsl:value-of
                                select="string-length(xsd:restriction/xsd:minInclusive/@value)"/>
                        </xsl:when>
                        <xsl:when test="exists($fieldInfo/*/@MinimumLength)">
                            <xsl:value-of select="$fieldInfo/*/@MinimumLength"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="maxlen">
            <xsl:choose>
                <xsl:when test="exists(*//xsd:length)">
                    <xsl:value-of select="*//xsd:length/@value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="number($fieldInfo/*/@MaximumLength)=-1">
                            <xsl:text>Unlimited</xsl:text>
                        </xsl:when>
                        <xsl:when test="exists(*//xsd:maxLength)">
                            <xsl:value-of select="*//xsd:maxLength/@value"/>
                        </xsl:when>
                        <xsl:when test="exists(*//xsd:maxInclusive)">
                            <xsl:value-of select="string-length(*//xsd:maxInclusive/@value)"/>
                        </xsl:when>
                        <xsl:when test="exists($fieldInfo/*/@MaximumLength)">
                            <xsl:value-of select="$fieldInfo/*/@MaximumLength"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$minlen"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="regx">
            <xsl:value-of select="xsd:restriction/xsd:pattern/@value" disable-output-escaping="no"/>
        </xsl:variable>
        <xsl:variable name="values">
            <div class="values">
                <span class="label">
                    <xsl:text>Values: </xsl:text>
                </span>
                <span class="minval">
                    <xsl:value-of select="xsd:restriction/xsd:minInclusive/@value"/>
                </span>
                <span> - </span>
                <span class="maxval">
                    <xsl:value-of select="xsd:restriction/xsd:maxInclusive/@value"/>
                </span>
            </div>
        </xsl:variable>
        <div class="field">
            <div class="frm">
                <div class="desc">
                    <div class="name">
                        <xsl:value-of select="$fieldInfo/*/@FudName"/>
                    </div>
                    <div class="doc">
                        <xsl:value-of select="$doc"/>
                    </div>
                </div>
                <div class="seq">
                    <div class="frmfld">
                    </div>
                </div>
            </div>      
        </div>
    </xsl:template>
    
</xsl:stylesheet>