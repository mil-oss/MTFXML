<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="text" indent="yes"/>

    <xsl:variable name="basepath" select="'../../XSD/NIEM_MTF/'"/>
    <!--<xsl:variable name="basepath" select="'../../XSD/NIEM_MTF_1_NS/'"/>
    <xsl:variable name="basepath" select="'../../XSD/NIEM_MTF_1_NS_NIEM/'"/>-->


    <xsl:variable name="fldschema" select="document(concat($basepath, 'NIEM_MTF_Fields.xsd'))/xsd:schema"/>
    <xsl:variable name="compschema" select="document(concat($basepath, 'NIEM_MTF_Composites.xsd'))/xsd:schema"/>
    <xsl:variable name="segschema" select="document(concat($basepath, 'NIEM_MTF_Segments.xsd'))/xsd:schema"/>
    <xsl:variable name="setschema" select="document(concat($basepath, 'NIEM_MTF_Sets.xsd'))/xsd:schema"/>
    <xsl:variable name="msgschema" select="document(concat($basepath, 'NIEM_MTF_Messages.xsd'))/xsd:schema"/>


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
            <xsl:value-of select="concat($q, 'Fields', $q, $c, $lb)"/>
            <xsl:call-template name="makeJson">
                <xsl:with-param name="xsdnode" select="$fldschema"/>
            </xsl:call-template>
            <xsl:value-of select="$rb"/>
            <xsl:value-of select="$rb"/>
        </xsl:result-document>
        <xsl:result-document href="{$compmapjson}">
            <xsl:value-of select="$lb"/>
            <xsl:call-template name="makeJson">
                <xsl:with-param name="xsdnode" select="$compschema"/>
            </xsl:call-template>
            <xsl:value-of select="$rb"/>
        </xsl:result-document>
        <xsl:result-document href="{$segmapjson}">
            <xsl:value-of select="$lb"/>
            <xsl:call-template name="makeJson">
                <xsl:with-param name="xsdnode" select="$segschema"/>
            </xsl:call-template>
            <xsl:value-of select="$rb"/>
        </xsl:result-document>
        <xsl:result-document href="{$setmapjson}">
            <xsl:value-of select="$lb"/>
            <xsl:call-template name="makeJson">
                <xsl:with-param name="xsdnode" select="$setschema"/>
            </xsl:call-template>
            <xsl:value-of select="$rb"/>
        </xsl:result-document>
        <xsl:result-document href="{$msgmapjson}">
            <xsl:value-of select="$lb"/>
            <xsl:call-template name="makeJson">
                <xsl:with-param name="xsdnode" select="$msgschema"/>
            </xsl:call-template>
            <xsl:value-of select="$rb"/>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="makeJson">
        <xsl:param name="xsdnode"/>
        <xsl:for-each select="$xsdnode/xsd:complexType[@name]">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="position() &gt; 1">
                <xsl:value-of select="$cm"/>
            </xsl:if>
            <xsl:value-of select="concat($q, $n, $q, $c, $lb)"/>
            <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="map"/>
            <xsl:value-of select="$cm"/>
            <xsl:apply-templates select="xsd:annotation/xsd:appinfo" mode="map"/>
            <xsl:value-of select="$cm"/>
            <xsl:apply-templates select="*[not(name() = 'xsd:annotation')]" mode="map"/>
            <xsl:value-of select="$rb"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*" mode="map">
        <xsl:apply-templates select="*" mode="map"/>
    </xsl:template>
    <xsl:template match="xsd:documentation" mode="map">
        <xsl:apply-templates select="." mode="makejson"/>
    </xsl:template>
    <xsl:template match="xsd:appinfo" mode="map">
        <xsl:apply-templates select="*" mode="map"/>
    </xsl:template>
    <xsl:template match="xsd:appinfo/*" mode="map">
        <xsl:variable name="n" select="substring-after(name(), ':')"/>
        <xsl:variable name="atts">
            <xsl:for-each select="@*">
                <xsl:element name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="concat($q, $n, $q, $c, $lb)"/>
        <xsl:apply-templates select="$atts" mode="makejson"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>
    <xsl:template match="xsd:sequence" mode="map">
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:value-of select="concat($q, 'Sequence', $q, $c, $lb)"/>
        <xsl:apply-templates select="*" mode="map"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>
    <xsl:template match="element[@ref][xsd:annotation/xsd:appinfo]" mode="map">
        <xsl:variable name="atts">
            <xsl:for-each select="@*">
                <xsl:element name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="concat($q, @ref, $q, $c, $lb)"/>
        <xsl:apply-templates select="$atts" mode="makejson"/>
        <xsl:value-of select="$cm"/>
        <xsl:apply-templates select="xsd:annotation/xsd:documentation" mode="map"/>
        <xsl:value-of select="$cm"/>
        <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*" mode="map"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="text()" mode="map"/>
    <xsl:template match="*" mode="makejson">
        <xsl:variable name="n">
            <xsl:choose>
                <xsl:when test="contains(name(), ':')">
                    <xsl:value-of select="substring-after(name(), ':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($q, $n, $q, $c, $q, ., $q)"/>
        <xsl:if test="following-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match="xsd:choice">
        <xsl:value-of select="$cm"/>
        <xsl:value-of select="concat($q, @name, $q, $c, $lb)"/>
        <xsl:apply-templates select="*"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>



    <xsl:template match="Codes">
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="Code">
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:variable name="fi">
            <xsl:call-template name="escape-quot-string">
                <xsl:with-param name="s" select="@dataItem"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="fd">
            <xsl:call-template name="escape-quot-string">
                <xsl:with-param name="s" select="@doc"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat($q, position(), $q, $c, $lb)"/>
        <xsl:value-of select="concat($q, 'value', $q, $c, $q, @value, $q)"/>
        <xsl:value-of select="concat($cm, $q, 'dataitem', $q, $c, $q, $fi, $q)"/>
        <xsl:value-of select="concat($cm, $q, 'doc', $q, $c, $q, $fd, $q)"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="Sequence[@name = 'GroupOfFields']">
        <xsl:if test="preceding-sibling::*">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:value-of select="concat($q, @name, $q, $c, $lb)"/>
        <xsl:apply-templates select="*"/>
        <xsl:value-of select="$rb"/>
    </xsl:template>

    <xsl:template match="Ref | Element">
        <xsl:variable name="atts">
            <xsl:for-each select="@*">
                <xsl:variable name="n"/>
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
            <xsl:choose>
                <xsl:when test="@niemelementname">
                    <xsl:value-of select="@niemelementname"/>
                </xsl:when>
                <xsl:when test="@substgrpname">
                    <xsl:value-of select="@substgrpname"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="preceding-sibling::*[name()]">
            <xsl:value-of select="$cm"/>
        </xsl:if>
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
        <!-- <xsl:if test="following-sibling::*[name()]">
            <xsl:value-of select="$cm"/>
        </xsl:if>-->
    </xsl:template>

    <xsl:template match="appinfo">
        <xsl:if test="*">
            <xsl:value-of select="concat($cm, $q, name(), $q, $c, $lb)"/>
            <xsl:apply-templates select="*" mode="doc"/>
            <xsl:value-of select="$rb"/>
            <!-- <xsl:choose>
            <xsl:when test="count(*)=1">
                <xsl:apply-templates select="*" mode="doc"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*[1]" mode="doc"/>
               <!-\- <xsl:for-each select="*">
                    <xsl:value-of select="concat($q, position(), $q, $c,$lb)"/>
                    <xsl:apply-templates select="." mode="doc"/>
                </xsl:for-each> -\->
            </xsl:otherwise>
        </xsl:choose>-->
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:Field" mode="doc">
        <xsl:value-of select="concat($q, 'Field', $q, $c, $lb)"/>
        <xsl:apply-templates select="@name" mode="att">
            <xsl:with-param name="txtname" select="'fieldNametxt'"/>
        </xsl:apply-templates>
        <xsl:if test="@name and @positionName">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:apply-templates select="@positionName" mode="att">
            <xsl:with-param name="txtname" select="'fieldPositionName'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@explanation" mode="att">
            <xsl:with-param name="txtname" select="'fieldExplanation'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@version" mode="att">
            <xsl:with-param name="txtname" select="'fieldVersion'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@identifier" mode="att">
            <xsl:with-param name="txtname" select="'fieldIdentifier'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@definition" mode="att">
            <xsl:with-param name="txtname" select="'fieldDefinition'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@concept" mode="att">
            <xsl:with-param name="txtname" select="'fieldConcept'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@remark" mode="att">
            <xsl:with-param name="txtname" select="'fieldRemark'"/>
        </xsl:apply-templates>
        <xsl:value-of select="$rb"/>
        <xsl:if test="following-sibling::*:Field">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:Composite" mode="doc">
        <xsl:choose>
            <xsl:when test="count(parent::*/*:Composite) &gt; 1">
                <xsl:value-of select="concat($q, 'Composite', position(), $q, $c, $lb)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($q, 'Composite', $q, $c, $lb)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="@typename" mode="att">
            <xsl:with-param name="txtname" select="'compNametxt'"/>
        </xsl:apply-templates>
        <xsl:if test="@typename and @explanation">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:apply-templates select="@explanation" mode="att">
            <xsl:with-param name="txtname" select="'compExplanation'"/>
        </xsl:apply-templates>
        <xsl:if test="@typename or @explanation">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:apply-templates select="@definition" mode="att">
            <xsl:with-param name="txtname" select="'compDefinition'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@identifier" mode="att">
            <xsl:with-param name="txtname" select="'compIdentifier'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@remark" mode="att">
            <xsl:with-param name="txtname" select="'compRemark'"/>
        </xsl:apply-templates>
        <xsl:if test="@definition or @identifier or @remark">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:apply-templates select="@version" mode="att">
            <xsl:with-param name="txtname" select="'compVersion'"/>
        </xsl:apply-templates>
        <xsl:value-of select="$rb"/>
        <xsl:if test="following-sibling::*:Composite">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:Set" mode="doc">
        <xsl:value-of select="concat($q, 'Set', $q, $c, $lb)"/>
        <xsl:apply-templates select="@setname" mode="att">
            <xsl:with-param name="txtname" select="'setNametxt'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@positionName" mode="att">
            <xsl:with-param name="txtname" select="'setPositionName'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@setid" mode="att">
            <xsl:with-param name="txtname" select="'setId'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@version" mode="att">
            <xsl:with-param name="txtname" select="'setVersion'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@position" mode="att">
            <xsl:with-param name="txtname" select="'setPosition'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@concept" mode="att">
            <xsl:with-param name="txtname" select="'setConcept'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@usage" mode="att">
            <xsl:with-param name="txtname" select="'setUsage'"/>
        </xsl:apply-templates>
        <xsl:value-of select="$rb"/>
        <xsl:if test="following-sibling::*:Set">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:Segment" mode="doc">
        <xsl:value-of select="concat($q, 'Segment', $q, $c, $lb)"/>
        <xsl:apply-templates select="@name" mode="att">
            <xsl:with-param name="txtname" select="'segmentNametxt'"/>
        </xsl:apply-templates>
        <xsl:if test="@name and @usage">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:apply-templates select="@usage" mode="att">
            <xsl:with-param name="txtname" select="'segmentUsage'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@version" mode="att">
            <xsl:with-param name="txtname" select="'segmentInitialPosition'"/>
        </xsl:apply-templates>
        <xsl:value-of select="$rb"/>
        <xsl:if test="following-sibling::*:Segment">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*:Msg" mode="doc">
        <xsl:value-of select="concat($q, 'Msg', $q, $c, $lb)"/>
        <xsl:apply-templates select="@mtfname" mode="att">
            <xsl:with-param name="txtname" select="'msgNametxt'"/>
        </xsl:apply-templates>
        <xsl:if test="@mtfname and @mtfid">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:apply-templates select="@mtfid" mode="att">
            <xsl:with-param name="txtname" select="'mtfId'"/>
        </xsl:apply-templates>
        <xsl:if test="@mtfname or @mtfid">
            <xsl:value-of select="$cm"/>
        </xsl:if>
        <xsl:apply-templates select="@purpose" mode="att">
            <xsl:with-param name="txtname" select="'msgPurpose'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@MtfRemark" mode="att">
            <xsl:with-param name="txtname" select="'msgRemark'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@note" mode="att">
            <xsl:with-param name="txtname" select="'msgNote'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@version" mode="att">
            <xsl:with-param name="txtname" select="'msgVersion'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="@sponsor" mode="att">
            <xsl:with-param name="txtname" select="'msgSponsor'"/>
        </xsl:apply-templates>
        <xsl:value-of select="$rb"/>
        <xsl:if test="following-sibling::*:Msg">
            <xsl:value-of select="$cm"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@*" mode="att">
        <xsl:param name="txtname"/>
        <xsl:variable name="val">
            <xsl:choose>
                <xsl:when
                    test="
                        ends-with($txtname, 'Purpose') or
                        ends-with($txtname, 'Remark') or
                        ends-with($txtname, 'Note') or
                        ends-with($txtname, 'Usage') or
                        ends-with($txtname, 'Concept') or
                        ends-with($txtname, 'Definition') or
                        ends-with($txtname, 'Explanation')
                        ">
                    <xsl:call-template name="escape-quot-string">
                        <xsl:with-param name="s" select="."/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="ends-with($txtname, 'Nametxt')">
                <xsl:value-of select="concat($q, $txtname, $q, $c, $q, $val, $q)"/>
            </xsl:when>
            <xsl:when test="ends-with($txtname, 'Name')">
                <xsl:value-of select="concat($q, $txtname, $q, $c, $q, $val, $q)"/>
            </xsl:when>
            <xsl:when test="$txtname = 'compExplanation'">
                <xsl:value-of select="concat($q, $txtname, $q, $c, $q, $val, $q)"/>
            </xsl:when>
            <xsl:when test="$txtname = 'compDefinition'">
                <xsl:value-of select="concat($q, $txtname, $q, $c, $q, $val, $q)"/>
            </xsl:when>
            <xsl:when test="$txtname = 'segmentUsage'">
                <xsl:value-of select="concat($q, $txtname, $q, $c, $q, $val, $q)"/>
            </xsl:when>
            <xsl:when test="$txtname = 'mtfId'">
                <xsl:value-of select="concat($q, $txtname, $q, $c, $q, $val, $q)"/>
            </xsl:when>
            <xsl:when test="$txtname = 'msgPurpose'">
                <xsl:value-of select="concat($q, $txtname, $q, $c, $q, $val, $q)"/>
            </xsl:when>
            <xsl:when test="$txtname = 'compVersion'">
                <xsl:value-of select="concat($q, $txtname, $q, $c, $q, $val, $q)"/>
            </xsl:when>
            <xsl:when test="name() = 'typename'">
                <xsl:value-of select="concat($q, $txtname, $q, $c, $q, $val, $q)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($cm, $q, $txtname, $q, $c, $q, $val, $q)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

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
