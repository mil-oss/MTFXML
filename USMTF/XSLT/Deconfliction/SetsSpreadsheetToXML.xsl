<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!--This transform extracts usable XML from MS EXCEL documents saved as XML-->
    <xsl:variable name="sourceDoc" select="document('../../XSD/Deconflicted/M201503C0VF-SetDeconfliction.xml')"/>
    <xsl:variable name="sets" select="document('../../XSD/Baseline_Schema/sets.xsd')"/>
    <xsl:variable name="outputDoc" select="'../../XSD/Deconflicted/Set_Name_Changes.xml'"/>
    <!-- Attribute names from first row-->
    <xsl:variable name="attributes">
        <ATTS>
            <xsl:for-each select="$sourceDoc//*:Table/*:Row[1]/*:Cell">
                <xsl:variable name="datatext">
                    <xsl:apply-templates select="*:Data/text()[1]"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains($datatext, '(')">
                        <ATT name="{substring-before(translate($datatext,' :/_',''),'(')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <ATT name="{translate($datatext,' :/_','')}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ATTS>
    </xsl:variable>
    <!-- Extract Element names from Baselines sets with SetID attribute-->
    <!-- ******************* -->
    <xsl:variable name="mtf_set_elements">
        <SetElements>
            <xsl:apply-templates select="$sets/xsd:schema/xsd:complexType" mode="topel">
                <xsl:sort select="@name" data-type="text"/>
            </xsl:apply-templates>
        </SetElements>
    </xsl:variable>
    <!--Baseline Message Element Names-->
    <xsl:template match="xsd:complexType[substring-before(@name, 'Type')]" mode="topel">
        <xsl:element name="{substring-before(@name,'Type')}">
            <xsl:attribute name="SetId">
                <xsl:value-of select="*:annotation/*:appinfo/*:SetFormatIdentifier/text()"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text()" mode="topel"/>
    <!-- ******************* -->
    <!-- Pull Set changes from spreadsheet and put in extracted Elements names-->
    <!-- ******************* -->
    <xsl:variable name="new_set_elements">
        <xsl:apply-templates select="$sourceDoc//*:Table"/>
    </xsl:variable>
    <xsl:template name="main">
        <xsl:result-document href="{$outputDoc}">
            <!--<xsl:copy-of select="$attributes"/>-->
            <USMTF_Sets>
                <xsl:attribute name="count">
                    <xsl:value-of select="count($new_set_elements/*)"/>
                </xsl:attribute>
                <xsl:for-each select="$new_set_elements/*">
                    <!--                    <xsl:variable name="n" select="@ElementName"/>
                    <xsl:if test="not(preceding-sibling::*/@ElementName=$n)">-->
                    <xsl:copy-of select="."/>
                    <!--</xsl:if>-->
                </xsl:for-each>
            </USMTF_Sets>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="*:Table">
        <xsl:apply-templates select="*:Row[*:Cell/*:Data]"/>
        <!--        <!-\-NO CHANGES FILTER-\->
            <xsl:apply-templates select="*:Row[*:Cell/*:Data][not(contains(*:Cell[7]/*:Data/text()[1],'No changes required'))]"/>  -->
    </xsl:template>
    <xsl:template match="*:Row[1]"/>
    <xsl:template match="*:Row">
        <xsl:variable name="setid">
            <xsl:value-of select="*:Cell[8]/*:Data/text()"/>
        </xsl:variable>
        <xsl:variable name="Elname">
            <xsl:value-of select="$mtf_set_elements/SetElements/*[@SetId = $setid][1]/name()"/>
        </xsl:variable>
        <xsl:if test="string-length($Elname) > 0">
            <xsl:element name="Set">
                <xsl:attribute name="ElementName">
                    <xsl:value-of select="$Elname"/>
                </xsl:attribute>
                <xsl:apply-templates select="*:Cell[1]"/>
                <!-- <xsl:attribute name="SetId">
                    <xsl:value-of select="$setid"/>
                </xsl:attribute>
                <xsl:attribute name="ProposedSetFormatPositionConceptChanges">
                    <xsl:value-of select="*:Cell[6]/*:Data/text()"/>
                </xsl:attribute>
                <xsl:attribute name="SETNAMESHORT">
                    <xsl:value-of select="*:Cell[8]/*:Data/text()"/>
                </xsl:attribute>
                <xsl:attribute name="SETNAMELONG">
                    <xsl:value-of select="*:Cell[9]/*:Data/text()"/>
                </xsl:attribute>
                <xsl:attribute name="ProposedSetFormatPositionName">
                    <xsl:apply-templates select="*:Cell[15]/*:Data/text()"/>
                </xsl:attribute>
                <xsl:attribute name="ProposedSetFormatName">
                    <xsl:apply-templates select="*:Cell[16]/*:Data/text()"/>
                </xsl:attribute>
                <xsl:attribute name="ProposedSetFormatDescription">
                    <xsl:apply-templates select="*:Cell[17]/*:Data/text()"/>
                </xsl:attribute>-->
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*:Cell">
        <xsl:param name="offset"/>
        <xsl:variable name="pos" select="position()"/>
        <xsl:variable name="offset" select="preceding-sibling::*:Cell[@*:Index]/position()"/>
        <xsl:variable name="offsetval">
            <xsl:value-of select="preceding-sibling::*:Cell[@*:Index][1]/@*:Index"/>
        </xsl:variable>
        <xsl:variable name="adjpos">
            <xsl:choose>
                <xsl:when test="$offset">
                    <xsl:value-of select="$pos + $offsetval"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$pos"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="{$attributes//ATT[$pos]/@name}">
            <xsl:apply-templates select="*:Data/text()"/>
            <xsl:value-of select="$offset"/> - <xsl:value-of select="$offsetval"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(replace(., '&#34;', ''))"/>
    </xsl:template>
</xsl:stylesheet>
