<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:variable name="enumtypecontent" select="document('enumcontent.xml')//*:document-content/*:body[1]/*:spreadsheet[1]/*:table[1]"/>
    <xsl:variable name="enumcontent" select="document('enumcontent.xml')//*:document-content/*:body[1]/*:spreadsheet[1]/*:table[2]"/>
    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="a" select='"&apos;"'/>

    <xsl:template name="main">
        <xsl:result-document href="../../XSD/Refactor_Changes/M201804C0IF-EnumerationSimpleTypes.xml">
            <EnumerationTypes>
                <xsl:apply-templates select="$enumtypecontent/*:table-row[position() &gt; 1]" mode="makeenumtypes"/>
            </EnumerationTypes>
        </xsl:result-document>
        <xsl:result-document href="../../XSD/Refactor_Changes/M201804C0IF-Enumerations.xml">
            <Enumerations>
                <xsl:apply-templates select="$enumcontent/*:table-row[position() &gt; 1]" mode="makeenums"/>
            </Enumerations>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="*:table-row" mode="makeenumtypes">
        <EnumerationType niemname="{translate(*:table-cell[2]/*:p,'/,()','')}" ffirn="{*:table-cell[3]/*:p}" fud="{*:table-cell[4]/*:p}" fudname="{*:table-cell[5]/*:p}" fudexp="{*:table-cell[6]/*:p}"
            name="{*:table-cell[7]/*:p}" comment="{*:table-cell[8]/*:p}" doc="{*:table-cell[9]/*:p}" dist="{*:table-cell[10]/*:p}" abrev="{*:table-cell[11]/*:p}" reldoc="{*:table-cell[12]/*:p}"
            version="{*:table-cell[14]/*:p}" versiondate="{*:table-cell[15]/*:p}" remarks="{*:table-cell[16]/*:p}"/>
    </xsl:template>

    <xsl:template match="*:table-row" mode="makeenums">
        <Enumeration niemtype="{replace(*:table-cell[1]/*:p,',','')}" ffirn="{*:table-cell[2]/*:p}" fud="{*:table-cell[3]/*:p}" typename="{*:table-cell[4]/*:p}" seq="{*:table-cell[5]/*:p}"
            datacode="{*:table-cell[6]/*:p}" doc="{normalize-space(replace(*:table-cell[7]/*:p,$q,$a))}" comment="{*:table-cell[8]/*:p}"/>
    </xsl:template>

</xsl:stylesheet>
