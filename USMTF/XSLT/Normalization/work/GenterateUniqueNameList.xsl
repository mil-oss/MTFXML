<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" xml:lang="en-US" version="2.0">
    
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="mtf_fields_xsd" select="document('../RegEx/FindRegExFieldsAndProposeNewNamesOut.xml')"/>
    <xsl:variable name="NEWLINE" select="'&#10;'"/>
    <xsl:variable name="BLANKSPACE" select="'                         '"/>
    
   <xsl:template match="/">
       <xsl:result-document href="../RegEx/MTFUniqueNamesListOut.xml">
         <MTFUniqueNames>
             <xsl:value-of select="$NEWLINE"/>
             <xsl:apply-templates select="$mtf_fields_xsd/node()"/>
         </MTFUniqueNames>
       </xsl:result-document>
   </xsl:template>
    
   <xsl:template match="TYPES/Regex/RegexType[@occurrence=1]">
       <MTFSimpleType>
        <originalName><xsl:value-of select="SType/@name"/></originalName>
        <regex><xsl:value-of select="@regex"/></regex>
           <proposedName><xsl:value-of select="@ProposedName"/></proposedName>
       </MTFSimpleType>
    </xsl:template>
    
    <xsl:template match="@*"/>
    <xsl:template match="text()"/>
</xsl:stylesheet>
