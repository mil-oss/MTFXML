<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
   <xsl:template match="@*|node()">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="@xsi:type">
      <xsl:attribute name="OrigType"><xsl:value-of select="."/></xsl:attribute>
   </xsl:template>
   <xsl:template match="//*[@BusinessID]/*/*[@BusinessID]/*"/>
   <xsl:template match="*/*[@BusinessID]/*[@Pattern = 'Relation_Entity' ]">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="*/*[@BusinessID]/*[@Pattern = 'TInter_Relation' ]">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   <!-- BEGIN - Write out specific Entity elements -->
   <xsl:template match="//*[@BusinessID]/*/*[@BusinessID]/Name">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="//*[@BusinessID]/*/*[@BusinessID]/Effective_Start_Date">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="//*[@BusinessID]/*/*[@BusinessID]/Effective_End_Date">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="//*[@BusinessID]/*/*[@BusinessID]/Available_Start_Date">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="//*[@BusinessID]/*/*[@BusinessID]/Available_End_Date">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="//*[@BusinessID]/*/*[@BusinessID]/TChild_Group_Cardinality_Rule">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   <!-- END - Write out specific Entity elements -->
</xsl:stylesheet>
