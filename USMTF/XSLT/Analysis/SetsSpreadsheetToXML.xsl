<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <!--This transform extracts usable XML from MS EXCEL documents saved as XML-->
    <xsl:variable name="sourceDoc" select="document('../../XSD/Deconflicted/M201503C0VFSetDeconfliction.xml')"/>
    <xsl:variable name="sets" select="document('../../XSD/Baseline_Schema/sets.xsd')"/>
    <xsl:variable name="outputDoc" select="'../../XSD/Deconflicted/Set_Name_Changes.xml'"/>
    <!-- Attribute names from first row-->
    <xsl:variable name="attributes">
        <ATTS>
            <xsl:for-each select="$sourceDoc//*:table/*:table-row[1]/*:table-cell[*:p]">
                <xsl:variable name="datatext">
                    <xsl:apply-templates select="*:p/text()[1]"/>
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
        <xsl:apply-templates select="$sourceDoc//*:table"/>
    </xsl:variable>
    <xsl:template name="main">
        <xsl:result-document href="{$outputDoc}">
            <!--<xsl:copy-of select="$attributes"/>-->
            <USMTF_Sets>
                <xsl:attribute name="count">
                    <xsl:value-of select="count($new_set_elements/*)"/>
                </xsl:attribute>
                <xsl:for-each select="$new_set_elements/*">
                    <!--<xsl:variable name="n" select="@ElementName"/>
                    <xsl:if test="not(preceding-sibling::*/@ElementName=$n)">-->
                    <xsl:copy-of select="."/>
                    <!--</xsl:if>-->
                </xsl:for-each>
            </USMTF_Sets>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="*:table">
        <xsl:apply-templates select="*:table-row[*:table-cell/*:p]"/>
        <!--        <!-\-NO CHANGES FILTER-\->
            <xsl:apply-templates select="*:table-row[*:table-cell/*:p][not(contains(*:table-cell[7]/*:p/text()[1],'No changes required'))]"/>  -->
    </xsl:template>
    <xsl:template match="*:table-row[1]"/>
    <xsl:template match="*:table-row">
        <xsl:variable name="setid">
            <xsl:value-of select="*:table-cell[8]/*:p/text()"/>
        </xsl:variable>
        <xsl:variable name="Elname">
            <xsl:value-of select="$mtf_set_elements/SetElements/*[@SetId = $setid][1]/name()"/>
        </xsl:variable>
        <xsl:if test="string-length($Elname) > 0">
            <xsl:element name="Set">
                <xsl:attribute name="ElementName">
                    <xsl:value-of select="$Elname"/>
                </xsl:attribute>
                <xsl:apply-templates select="*:table-cell[1]">
                    <xsl:with-param name="pos" select="1"/>
                </xsl:apply-templates>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <!--    <xsl:template match="*:table-cell">
        <xsl:variable name="pos" select="position()"/>
          
        <xsl:attribute name="{concat('cell',$pos)}">
            <xsl:value-of select="$attributes//ATT[number($pos)]/@name"/> ...<xsl:apply-templates select="*:p/text()"/> .... <xsl:value-of select="$pos"/>
        </xsl:attribute>

    </xsl:template>-->
    <xsl:template match="*:table-cell">
        <xsl:param name="pos"/>
        <xsl:variable name="adjpos">
            <xsl:choose>
                <xsl:when test="./@*:number-columns-repeated">
                    <xsl:value-of select="number(@*:number-columns-repeated)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
       <xsl:choose>
           <xsl:when test="./@*:number-columns-repeated">
               <xsl:if test="*:p">
                   <xsl:call-template name="reptVal">
                       <xsl:with-param name="pos">
                           <xsl:value-of select="$pos"/>
                       </xsl:with-param>
                       <xsl:with-param name="rpt">
                           <xsl:value-of select="./@*:number-columns-repeated"/>
                       </xsl:with-param>
                       <xsl:with-param name="val">
                           <xsl:apply-templates select="*:p"/>
                       </xsl:with-param>
                   </xsl:call-template>
               </xsl:if>
               <xsl:if test="following-sibling::*:table-cell[*:p]">
                   <xsl:apply-templates select="following-sibling::*:table-cell[1]">
                       <xsl:with-param name="pos">
                           <xsl:value-of select="number($pos) + number($adjpos)"/>
                       </xsl:with-param>
                   </xsl:apply-templates>
               </xsl:if>  
           </xsl:when>
           <xsl:otherwise>
               <xsl:attribute name="{$attributes//ATT[number($pos)]/@name}">
                   <xsl:apply-templates select="*:p"/>
               </xsl:attribute>
               <xsl:if test="following-sibling::*:table-cell[*:p]">
                   <xsl:apply-templates select="following-sibling::*:table-cell[1]">
                       <xsl:with-param name="pos">
                           <xsl:value-of select="number($pos) + number($adjpos)"/>
                       </xsl:with-param>
                   </xsl:apply-templates>
               </xsl:if>
           </xsl:otherwise>
       </xsl:choose>    
    </xsl:template>
    <xsl:template name="reptVal">
        <xsl:param name="pos"/>
        <xsl:param name="rpt"/>
        <xsl:param name="val"/>
        <xsl:attribute name="{$attributes//ATT[number($pos)]/@name}">
            <xsl:value-of select="$val"/>
        </xsl:attribute>
        <xsl:variable name="cnt">
            <xsl:value-of select="number($rpt)-1"/>
        </xsl:variable>
        <xsl:if test="$cnt &gt;0">
            <xsl:call-template name="reptVal">
                <xsl:with-param name="pos">
                    <xsl:value-of select="number($pos)+1"/>
                </xsl:with-param>
                <xsl:with-param name="rpt">
                    <xsl:value-of select="$cnt"/>
                </xsl:with-param>
                <xsl:with-param name="val">
                    <xsl:value-of select="$val"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*:p">
        <xsl:value-of select="normalize-space(replace(text(), '&#34;', ''))"/>
    </xsl:template>
</xsl:stylesheet>
