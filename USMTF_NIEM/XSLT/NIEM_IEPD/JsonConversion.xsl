<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="text" indent="yes"/>

    <xsl:variable name="schemaMaps">
        <xsl:copy-of select="document('../../XSD/NIEM_MTF/NIEM_MTF_Fieldmaps.xml')/Fields"/>
        <xsl:copy-of select="document('../../XSD/NIEM_MTF/NIEM_MTF_Compositemaps.xml')/Composites"/>
        <xsl:copy-of select="document('../../XSD/NIEM_MTF/NIEM_MTF_Segmentmaps.xml')/Segments"/>
        <xsl:copy-of select="document('../../XSD/NIEM_MTF/NIEM_MTF_Setmaps.xml')/Sets"/>
        <xsl:copy-of select="document('../../XSD/NIEM_MTF/NIEM_MTF_Messagemaps.xml')/Messages"/>
    </xsl:variable>

    <xsl:variable name="fieldmapjson" select="'../../XSD/NIEM_IEPD/Conversion/JSON/fieldmap.json'"/>
    <xsl:variable name="compmapjson" select="'../../XSD/NIEM_IEPD/Conversion/JSON/compmap.json'"/>
    <xsl:variable name="segmapjson" select="'../../XSD/NIEM_IEPD/Conversion/JSON/segmap.json'"/>
    <xsl:variable name="setmapjson" select="'../../XSD/NIEM_IEPD/Conversion/JSON/setmap.json'"/>
    <xsl:variable name="msgmapjson" select="'../../XSD/NIEM_IEPD/Conversion/JSON/msgmap.json'"/>

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

    <xsl:template name="main">
        <xsl:result-document href="{$fieldmapjson}">
            <xsl:value-of select="$lb"/>
            <xsl:call-template name="makeJson">
                <xsl:with-param name="schemaMap" select="$schemaMaps/Fields"/>
            </xsl:call-template>
            <xsl:value-of select="$rb"/>
        </xsl:result-document>
        <xsl:result-document href="{$compmapjson}">
            <xsl:value-of select="$lb"/>
            <xsl:call-template name="makeJson">
                <xsl:with-param name="schemaMap" select="$schemaMaps/Composites"/>
            </xsl:call-template>
            <xsl:value-of select="$rb"/>
        </xsl:result-document>
        <xsl:result-document href="{$segmapjson}">
            <xsl:value-of select="$lb"/>
            <xsl:call-template name="makeJson">
                <xsl:with-param name="schemaMap" select="$schemaMaps/Segments"/>
            </xsl:call-template>
            <xsl:value-of select="$rb"/>
        </xsl:result-document>
        <xsl:result-document href="{$setmapjson}">
            <xsl:value-of select="$lb"/>
            <xsl:call-template name="makeJson">
                <xsl:with-param name="schemaMap" select="$schemaMaps/Sets"/>
            </xsl:call-template>
            <xsl:value-of select="$rb"/>
        </xsl:result-document>
        <xsl:result-document href="{$msgmapjson}">
            <xsl:value-of select="$lb"/>
            <xsl:call-template name="makeJson">
                <xsl:with-param name="schemaMap" select="$schemaMaps/Messages"/>
            </xsl:call-template>
            <xsl:value-of select="$rb"/>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="makeJson">
        <xsl:param name="schemaMap"/>
        <xsl:variable name="n" select="$schemaMap/name()"/>
        <xsl:value-of select="concat($q, $n, $q, $c, $lb)"/>
        <xsl:for-each select="$schemaMap/*">
            <xsl:variable name="atts">
                <xsl:for-each select="@*">
                    <xsl:element name="{name()}">
                        <xsl:choose>
                            <xsl:when test="name() = 'pattern' or name() = 'niempattern'">
                                <xsl:call-template name="escape-bs-string">
                                    <xsl:with-param name="s" select="normalize-space(.)"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(replace(., $q, $a))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="jname">
                <xsl:value-of select="position()"/>
            </xsl:variable>
            <xsl:value-of select="concat($q, $jname, $q, $c, $lb)"/>
            <xsl:for-each select="$atts/*">
                <xsl:variable name="v">
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:variable>
                <xsl:value-of select="concat($q, name(), $q, $c, $q, $v, $q)"/>
                <xsl:if test="following-sibling::*[name()]">
                    <xsl:value-of select="$cm"/>
                </xsl:if>
            </xsl:for-each>
            <xsl:apply-templates select="*"/>
            <xsl:value-of select="$rb"/>
            <xsl:if test="following-sibling::*[name()]">
                <xsl:value-of select="$cm"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="$rb"/>
    </xsl:template>
    
    <xsl:template match="Choice">
        <xsl:value-of select="$cm"/>
        <xsl:value-of select="concat($q, @name, $q, $c, $lb)"/>
        <xsl:apply-templates select="*"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="Sequence">
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    
    <xsl:template match="Ref | Element">
        <xsl:variable name="atts">
            <xsl:for-each select="@*">
                <xsl:element name="{name()}">
                    <xsl:choose>
                        <xsl:when test="name() = 'pattern' or name() = 'niempattern'">
                            <xsl:call-template name="escape-bs-string">
                                <xsl:with-param name="s" select="normalize-space(.)"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(replace(., $q, $a))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="jname">
            <xsl:value-of select="position()"/>
        </xsl:variable>
        <xsl:value-of select="concat($q, $jname, $q, $c, $lb)"/>
        <xsl:for-each select="$atts/*">
            <xsl:variable name="v">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:variable>
            <xsl:value-of select="concat($q, name(), $q, $c, $q, $v, $q)"/>
            <xsl:if test="following-sibling::*[name()]">
                <xsl:value-of select="$cm"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:apply-templates select="*"/>
        <xsl:value-of select="$rb"/>
        <xsl:if test="following-sibling::*[name()]">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="appinfo"/>
    
    <xsl:template match="typeappinfo"/>
    
    <!-- Escape the backslash (\) before everything else. -->
    <xsl:template name="escape-bs-string">
        <xsl:param name="s"/>
        <xsl:choose>
            <xsl:when test="contains($s, '\')">
                <xsl:call-template name="escape-quot-string">
                    <xsl:with-param name="s" select="concat(substring-before($s, '\'), '\\')"/>
                </xsl:call-template>
                <xsl:call-template name="escape-bs-string">
                    <xsl:with-param name="s" select="substring-after($s, '\')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="escape-quot-string">
                    <xsl:with-param name="s" select="$s"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Escape the double quote ("). -->
    <xsl:template name="escape-quot-string">
        <xsl:param name="s"/>
        <xsl:choose>
            <xsl:when test="contains($s, '&quot;')">
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="concat(substring-before($s, '&quot;'), '\&quot;')"/>
                </xsl:call-template>
                <xsl:call-template name="escape-quot-string">
                    <xsl:with-param name="s" select="substring-after($s, '&quot;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="$s"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Replace tab, line feed and/or carriage return by its matching escape code. Can't escape backslash
		   or double quote here, because they don't replace characters (&#x0; becomes \t), but they prefix
		   characters (\ becomes \\). Besides, backslash should be seperate anyway, because it should be
		   processed first. This function can't do that. -->
    <xsl:template name="encode-string">
        <xsl:param name="s"/>
        <xsl:choose>
            <!-- tab -->
            <xsl:when test="contains($s, '&#x9;')">
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="concat(substring-before($s, '&#x9;'), '\t', substring-after($s, '&#x9;'))"/>
                </xsl:call-template>
            </xsl:when>
            <!-- line feed -->
            <xsl:when test="contains($s, '&#xA;')">
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="concat(substring-before($s, '&#xA;'), '\n', substring-after($s, '&#xA;'))"/>
                </xsl:call-template>
            </xsl:when>
            <!-- carriage return -->
            <xsl:when test="contains($s, '&#xD;')">
                <xsl:call-template name="encode-string">
                    <xsl:with-param name="s" select="concat(substring-before($s, '&#xD;'), '\r', substring-after($s, '&#xD;'))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$s"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
