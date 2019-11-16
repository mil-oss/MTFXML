<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:nf="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#NDRFunctions"
                xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>

   <!--PHASES-->


   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>

   <!--XSD TYPES FOR XSLT2-->


   <!--KEYS AND FUNCTIONS-->


   <!--DEFAULT RULES-->


   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="Rules for extension XML Schema documents"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/XSL/Transform" prefix="xsl"/>
         <svrl:ns-prefix-in-attribute-values uri="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#NDRFunctions"
                                             prefix="nf"/>
         <svrl:ns-prefix-in-attribute-values uri="http://release.niem.gov/niem/conformanceTargets/3.0/" prefix="ct"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
         <svrl:ns-prefix-in-attribute-values uri="http://release.niem.gov/niem/appinfo/4.0/" prefix="appinfo"/>
         <svrl:ns-prefix-in-attribute-values uri="http://release.niem.gov/niem/structures/4.0/" prefix="structures"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_4-4</xsl:attribute>
            <xsl:attribute name="name">Document element has attribute ct:conformanceTargets</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_4-6</xsl:attribute>
            <xsl:attribute name="name">Schema claims extension conformance target</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_7-4</xsl:attribute>
            <xsl:attribute name="name">Document element is xs:schema</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-1</xsl:attribute>
            <xsl:attribute name="name">No base type in the XML namespace</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-2</xsl:attribute>
            <xsl:attribute name="name">No base type of xs:ID</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-3</xsl:attribute>
            <xsl:attribute name="name">No base type of xs:IDREF</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-4</xsl:attribute>
            <xsl:attribute name="name">No base type of xs:IDREFS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-5</xsl:attribute>
            <xsl:attribute name="name">No base type of xs:anyType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-6</xsl:attribute>
            <xsl:attribute name="name">No base type of xs:anySimpleType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-7</xsl:attribute>
            <xsl:attribute name="name">No base type of xs:NOTATION</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-8</xsl:attribute>
            <xsl:attribute name="name">No base type of xs:ENTITY</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-9</xsl:attribute>
            <xsl:attribute name="name">No base type of xs:ENTITIES</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-10</xsl:attribute>
            <xsl:attribute name="name">Simple type definition is top-level</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-12</xsl:attribute>
            <xsl:attribute name="name">Simple type has data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-14</xsl:attribute>
            <xsl:attribute name="name">Enumeration has data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-15</xsl:attribute>
            <xsl:attribute name="name">No list item type of xs:ID</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-16</xsl:attribute>
            <xsl:attribute name="name">No list item type of xs:IDREF</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-17</xsl:attribute>
            <xsl:attribute name="name">No list item type of xs:anySimpleType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-18</xsl:attribute>
            <xsl:attribute name="name">No list item type of xs:ENTITY</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-19</xsl:attribute>
            <xsl:attribute name="name">No union member types of xs:ID</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-20</xsl:attribute>
            <xsl:attribute name="name">No union member types of xs:IDREF</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-21</xsl:attribute>
            <xsl:attribute name="name">No union member types of xs:IDREFS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-22</xsl:attribute>
            <xsl:attribute name="name">No union member types of xs:anySimpleType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-23</xsl:attribute>
            <xsl:attribute name="name">No union member types of xs:ENTITY</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-24</xsl:attribute>
            <xsl:attribute name="name">No union member types of xs:ENTITIES</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-25</xsl:attribute>
            <xsl:attribute name="name">Complex type definition is top-level</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-26</xsl:attribute>
            <xsl:attribute name="name">Complex type has data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-27</xsl:attribute>
            <xsl:attribute name="name">No mixed content on complex type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-28</xsl:attribute>
            <xsl:attribute name="name">No mixed content on complex content</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-29</xsl:attribute>
            <xsl:attribute name="name">Complex type content is explicitly simple or complex</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-31</xsl:attribute>
            <xsl:attribute name="name">Base type of complex type with complex content must have complex content</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-36</xsl:attribute>
            <xsl:attribute name="name">Element declaration is top-level</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-37</xsl:attribute>
            <xsl:attribute name="name">Element declaration has data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-38</xsl:attribute>
            <xsl:attribute name="name">Untyped element is abstract</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-39</xsl:attribute>
            <xsl:attribute name="name">Element of type xs:anySimpleType is abstract</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-40</xsl:attribute>
            <xsl:attribute name="name">Element type not in the XML Schema namespace</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-41</xsl:attribute>
            <xsl:attribute name="name">Element type not in the XML namespace</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-42</xsl:attribute>
            <xsl:attribute name="name">Element type is not simple type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-45</xsl:attribute>
            <xsl:attribute name="name">No element default value</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-46</xsl:attribute>
            <xsl:attribute name="name">No element fixed value</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-48</xsl:attribute>
            <xsl:attribute name="name">Attribute declaration is top-level</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-49</xsl:attribute>
            <xsl:attribute name="name">Attribute declaration has data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-50</xsl:attribute>
            <xsl:attribute name="name">Attribute declaration has type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-51</xsl:attribute>
            <xsl:attribute name="name">No attribute type of xs:ID</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-52</xsl:attribute>
            <xsl:attribute name="name">No attribute type of xs:IDREF</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-53</xsl:attribute>
            <xsl:attribute name="name">No attribute type of xs:IDREFS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-54</xsl:attribute>
            <xsl:attribute name="name">No attribute type of xs:ENTITY</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-55</xsl:attribute>
            <xsl:attribute name="name">No attribute type of xs:ENTITIES</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-56</xsl:attribute>
            <xsl:attribute name="name">No attribute type of xs:anySimpleType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-57</xsl:attribute>
            <xsl:attribute name="name">No attribute default values</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-58</xsl:attribute>
            <xsl:attribute name="name">No fixed values for optional attributes</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-59</xsl:attribute>
            <xsl:attribute name="name">No use of element xs:notation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-61</xsl:attribute>
            <xsl:attribute name="name">No xs:all</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M61"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-63</xsl:attribute>
            <xsl:attribute name="name">xs:sequence must be child of xs:extension
              or xs:restriction</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M62"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-65</xsl:attribute>
            <xsl:attribute name="name">xs:choice must be child of xs:sequence</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M63"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-66</xsl:attribute>
            <xsl:attribute name="name">Sequence has minimum cardinality 1</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M64"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-67</xsl:attribute>
            <xsl:attribute name="name">Sequence has maximum cardinality 1</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M65"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-68</xsl:attribute>
            <xsl:attribute name="name">Choice has minimum cardinality 1</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M66"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-69</xsl:attribute>
            <xsl:attribute name="name">Choice has maximum cardinality 1</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M67"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-72</xsl:attribute>
            <xsl:attribute name="name">No use of xs:unique</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M68"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-73</xsl:attribute>
            <xsl:attribute name="name">No use of xs:key</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M69"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-74</xsl:attribute>
            <xsl:attribute name="name">No use of xs:keyref</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M70"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-75</xsl:attribute>
            <xsl:attribute name="name">No use of xs:group</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M71"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-76</xsl:attribute>
            <xsl:attribute name="name">No definition of attribute groups</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M72"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-77</xsl:attribute>
            <xsl:attribute name="name">Comment is not recommended</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M73"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-78</xsl:attribute>
            <xsl:attribute name="name">Documentation element has no element children</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M74"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-79</xsl:attribute>
            <xsl:attribute name="name">xs:appinfo children are comments, elements, or whitespace</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M75"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-80</xsl:attribute>
            <xsl:attribute name="name">Appinfo child elements have namespaces</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M76"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-81</xsl:attribute>
            <xsl:attribute name="name">Appinfo descendants are not XML Schema elements</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M77"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-82</xsl:attribute>
            <xsl:attribute name="name">Schema has data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M78"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-83</xsl:attribute>
            <xsl:attribute name="name">Schema document defines target namespace</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M79"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-85</xsl:attribute>
            <xsl:attribute name="name">Schema has version</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M80"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-88</xsl:attribute>
            <xsl:attribute name="name">No use of xs:redefine</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M81"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-89</xsl:attribute>
            <xsl:attribute name="name">No use of xs:include</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M82"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-90</xsl:attribute>
            <xsl:attribute name="name">xs:import must have namespace</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M83"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-92</xsl:attribute>
            <xsl:attribute name="name">Namespace referenced by attribute type is imported</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M84"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-93</xsl:attribute>
            <xsl:attribute name="name">Namespace referenced by attribute base is imported</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M85"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-94</xsl:attribute>
            <xsl:attribute name="name">Namespace referenced by attribute itemType is imported</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M86"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-95</xsl:attribute>
            <xsl:attribute name="name">Namespaces referenced by attribute memberTypes is imported</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M87"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-96</xsl:attribute>
            <xsl:attribute name="name">Namespace referenced by attribute ref is imported</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M88"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_9-97</xsl:attribute>
            <xsl:attribute name="name">Namespace referenced by attribute substitutionGroup is imported</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M89"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-2</xsl:attribute>
            <xsl:attribute name="name">Object type with complex content is derived from structures:ObjectType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M90"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-3</xsl:attribute>
            <xsl:attribute name="name">RoleOf element type is an object type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M91"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-4</xsl:attribute>
            <xsl:attribute name="name">Only object type has RoleOf element</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M92"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-7</xsl:attribute>
            <xsl:attribute name="name">Import of external namespace has data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M93"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-9</xsl:attribute>
            <xsl:attribute name="name">Structure of external adapter type definition follows pattern</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M94"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-10</xsl:attribute>
            <xsl:attribute name="name">Element use from external adapter type defined by external schema documents</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M95"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-11</xsl:attribute>
            <xsl:attribute name="name">External adapter type not a base type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M96"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-14</xsl:attribute>
            <xsl:attribute name="name">External attribute use has data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M97"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-16</xsl:attribute>
            <xsl:attribute name="name">External element use has data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M98"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-17</xsl:attribute>
            <xsl:attribute name="name">Name of code type ends in "CodeType"</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M99"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-19</xsl:attribute>
            <xsl:attribute name="name">Element of code type has code representation term</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M100"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-20</xsl:attribute>
            <xsl:attribute name="name">Proxy type has designated structure</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M101"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-21</xsl:attribute>
            <xsl:attribute name="name">Association type derived from structures:AssociationType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M102"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-22</xsl:attribute>
            <xsl:attribute name="name">Association element type is an association type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M103"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-24</xsl:attribute>
            <xsl:attribute name="name">Augmentable type has at most one augmentation point element</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M104"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-25</xsl:attribute>
            <xsl:attribute name="name">Augmentation point element corresponds to its base type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M105"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-26</xsl:attribute>
            <xsl:attribute name="name">An augmentation point element has no type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M106"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-27</xsl:attribute>
            <xsl:attribute name="name">An augmentation point element has no substitution group</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M107"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-28</xsl:attribute>
            <xsl:attribute name="name">Augmentation point element is only referenced by its base type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M108"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-31</xsl:attribute>
            <xsl:attribute name="name">Augmentation point element use must be last element in its base type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M109"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-34</xsl:attribute>
            <xsl:attribute name="name">Schema component with name ending in "AugmentationType" is an augmentation type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M110"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-35</xsl:attribute>
            <xsl:attribute name="name">Type derived from structures:AugmentationType is an augmentation type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M111"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-36</xsl:attribute>
            <xsl:attribute name="name">Augmentation element type is an augmentation type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M112"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-39</xsl:attribute>
            <xsl:attribute name="name">Metadata types are derived from structures:MetadataType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M113"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-40</xsl:attribute>
            <xsl:attribute name="name">Metadata element declaration type is a metadata type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M114"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-42</xsl:attribute>
            <xsl:attribute name="name">Name of element that ends in "Representation" is abstract</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M115"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-45</xsl:attribute>
            <xsl:attribute name="name">Schema component names have only specific characters</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M116"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-48</xsl:attribute>
            <xsl:attribute name="name">Attribute name begins with lower case letter</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M117"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-49</xsl:attribute>
            <xsl:attribute name="name">Name of schema component other than attribute and proxy type begins with upper case letter</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M118"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-68</xsl:attribute>
            <xsl:attribute name="name">Deprecated annotates schema component</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M119"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-69</xsl:attribute>
            <xsl:attribute name="name">External import indicator annotates import</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M120"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-70</xsl:attribute>
            <xsl:attribute name="name">External adapter type indicator annotates complex type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M121"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-71</xsl:attribute>
            <xsl:attribute name="name">appinfo:appliesToTypes annotates metadata element</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M122"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-73</xsl:attribute>
            <xsl:attribute name="name">appinfo:appliesToElements annotates metadata element</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M123"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-75</xsl:attribute>
            <xsl:attribute name="name">appinfo:LocalTerm annotates schema</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M124"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-76</xsl:attribute>
            <xsl:attribute name="name">appinfo:LocalTerm has literal or definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M125"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-1</xsl:attribute>
            <xsl:attribute name="name">Name of type ends in "Type"</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M126"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-2</xsl:attribute>
            <xsl:attribute name="name">Base type definition defined by conformant schema</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M127"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-3</xsl:attribute>
            <xsl:attribute name="name">Name of simple type ends in "SimpleType"</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M128"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-5</xsl:attribute>
            <xsl:attribute name="name">List item type defined by conformant schemas</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M129"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-6</xsl:attribute>
            <xsl:attribute name="name">Union member types defined by conformant schemas</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M130"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-7</xsl:attribute>
            <xsl:attribute name="name">Name of a code simple type ends in "CodeSimpleType"</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M131"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-9</xsl:attribute>
            <xsl:attribute name="name">Attribute of code simple type has code representation term</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M132"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-10</xsl:attribute>
            <xsl:attribute name="name">Complex type with simple content has structures:SimpleObjectAttributeGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M133"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-11</xsl:attribute>
            <xsl:attribute name="name">Element type does not have a simple type name</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M134"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-12</xsl:attribute>
            <xsl:attribute name="name">Element type is from conformant namespace</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M135"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-13</xsl:attribute>
            <xsl:attribute name="name">Name of element that ends in "Abstract" is abstract</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M136"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-14</xsl:attribute>
            <xsl:attribute name="name">Name of element declaration with simple content has representation term</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M137"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-16</xsl:attribute>
            <xsl:attribute name="name">Element substitution group defined by conformant schema</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M138"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-17</xsl:attribute>
            <xsl:attribute name="name">Attribute type defined by conformant schema</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M139"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-18</xsl:attribute>
            <xsl:attribute name="name">Attribute name uses representation term</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M140"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-20</xsl:attribute>
            <xsl:attribute name="name">Element reference defined by conformant schema</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M141"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-21</xsl:attribute>
            <xsl:attribute name="name">Referenced attribute defined by conformant schemas</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M142"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-22</xsl:attribute>
            <xsl:attribute name="name">Schema uses only known attribute groups</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M143"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-29</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for augmentation point element data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M144"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-30</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for augmentation element data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M145"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-31</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for metadata element data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M146"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-32</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for association element data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M147"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-33</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for abstract element data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M148"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-34</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for date element or attribute data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M149"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-35</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for quantity element or attribute data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M150"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-36</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for picture element or attribute data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M151"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-37</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for indicator element or attribute data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M152"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-38</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for identification element or attribute data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M153"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-39</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for name element or attribute data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M154"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-40</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for element or attribute data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M155"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-41</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for association type data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M156"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-42</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for augmentation type data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M157"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-43</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for metadata type data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M158"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-44</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for complex type data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M159"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-45</xsl:attribute>
            <xsl:attribute name="name">Standard opening phrase for simple type data definition</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M160"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-50</xsl:attribute>
            <xsl:attribute name="name">Structures imported as conformant</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M161"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-51</xsl:attribute>
            <xsl:attribute name="name">XML namespace imported as conformant</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M162"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-53</xsl:attribute>
            <xsl:attribute name="name">Consistently marked namespace imports</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M163"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Rules for extension XML Schema documents</svrl:text>
   <xsl:include xmlns:sch="http://purl.oclc.org/dsdl/schematron" href="ndr-functions.xsl"/>

   <!--PATTERN rule_4-4Document element has attribute ct:conformanceTargets-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Document element has attribute ct:conformanceTargets</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[. is nf:get-document-element(.)                        or exists(@ct:conformanceTargets)]"
                 priority="1000"
                 mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[. is nf:get-document-element(.)                        or exists(@ct:conformanceTargets)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(. is nf:get-document-element(.)) = exists(@ct:conformanceTargets)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(. is nf:get-document-element(.)) = exists(@ct:conformanceTargets)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 4-4: The [document element] of the XML document, and only the [document element], MUST own an attribute {http://release.niem.gov/niem/conformanceTargets/3.0/}conformanceTargets.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

   <!--PATTERN rule_4-6Schema claims extension conformance target-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schema claims extension conformance target</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[. is nf:get-document-element(.)]"
                 priority="1000"
                 mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[. is nf:get-document-element(.)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 4-6: The document MUST have an effective conformance target identifier of http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>

   <!--PATTERN rule_7-4Document element is xs:schema-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Document element is xs:schema</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[. is nf:get-document-element(.)]"
                 priority="1000"
                 mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[. is nf:get-document-element(.)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::xs:schema"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="self::xs:schema">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 7-4: The [document element] of the [XML document] MUST have the name xs:schema.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>

   <!--PATTERN rule_9-1No base type in the XML namespace-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No base type in the XML namespace</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@base)]" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[exists(@base)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="namespace-uri-from-QName(resolve-QName(@base, .)) != xs:anyURI('http://www.w3.org/XML/1998/namespace')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="namespace-uri-from-QName(resolve-QName(@base, .)) != xs:anyURI('http://www.w3.org/XML/1998/namespace')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-1: A schema component must not have a base type definition with a {target namespace} that is the XML namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

   <!--PATTERN rule_9-2No base type of xs:ID-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No base type of xs:ID</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@base)]" priority="1000" mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[exists(@base)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@base, .) != xs:QName('xs:ID')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@base, .) != xs:QName('xs:ID')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-2: A schema component MUST NOT have an attribute {}base with a value of xs:ID.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN rule_9-3No base type of xs:IDREF-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No base type of xs:IDREF</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@base)]" priority="1000" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[exists(@base)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@base, .) != xs:QName('xs:IDREF')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@base, .) != xs:QName('xs:IDREF')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-3: A schema component MUST NOT have an attribute {}base with a value of xs:IDREF.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

   <!--PATTERN rule_9-4No base type of xs:IDREFS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No base type of xs:IDREFS</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@base)]" priority="1000" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[exists(@base)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@base, .) != xs:QName('xs:IDREFS')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@base, .) != xs:QName('xs:IDREFS')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-4: A schema component MUST NOT have an attribute {}base with a value of xs:IDREFS.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

   <!--PATTERN rule_9-5No base type of xs:anyType-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No base type of xs:anyType</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@base)]" priority="1000" mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[exists(@base)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@base, .) != xs:QName('xs:anyType')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@base, .) != xs:QName('xs:anyType')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-5: A schema component MUST NOT have an attribute {}base with a value of xs:anyType.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>

   <!--PATTERN rule_9-6No base type of xs:anySimpleType-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No base type of xs:anySimpleType</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@base)]" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[exists(@base)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@base, .) != xs:QName('xs:anySimpleType')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@base, .) != xs:QName('xs:anySimpleType')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-6: A schema component MUST NOT have an attribute {}base with a value of xs:anySimpleType.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>

   <!--PATTERN rule_9-7No base type of xs:NOTATION-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No base type of xs:NOTATION</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@base)]" priority="1000" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[exists(@base)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@base, .) != xs:QName('xs:NOTATION')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@base, .) != xs:QName('xs:NOTATION')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-7: A schema component MUST NOT have an attribute {}base with a value of xs:NOTATION.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>

   <!--PATTERN rule_9-8No base type of xs:ENTITY-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No base type of xs:ENTITY</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@base)]" priority="1000" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[exists(@base)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@base, .) != xs:QName('xs:ENTITY')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@base, .) != xs:QName('xs:ENTITY')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-8: A schema component MUST NOT have an attribute {}base with a value of xs:ENTITY.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>

   <!--PATTERN rule_9-9No base type of xs:ENTITIES-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No base type of xs:ENTITIES</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@base)]" priority="1000" mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[exists(@base)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@base, .) != xs:QName('xs:ENTITIES')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@base, .) != xs:QName('xs:ENTITIES')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-9: A schema component MUST NOT have an attribute {}base with a value of xs:ENTITIES.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

   <!--PATTERN rule_9-10Simple type definition is top-level-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Simple type definition is top-level</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:simpleType" priority="1000" mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:simpleType"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(parent::xs:schema)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(parent::xs:schema)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-10: A simple type definition MUST be top-level.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

   <!--PATTERN rule_9-12Simple type has data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Simple type has data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:simpleType" priority="1000" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:simpleType"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $definition in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $definition in xs:annotation/xs:documentation[1] satisfies string-length(normalize-space(string($definition))) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-12: A simple type MUST have a data definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

   <!--PATTERN rule_9-14Enumeration has data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Enumeration has data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:enumeration" priority="1000" mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:enumeration"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $definition in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $definition in xs:annotation/xs:documentation[1] satisfies string-length(normalize-space(string($definition))) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-14: An enumeration facet MUST have a data definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

   <!--PATTERN rule_9-15No list item type of xs:ID-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No list item type of xs:ID</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@itemType)]" priority="1000" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[exists(@itemType)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@itemType, .) != xs:QName('xs:ID')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@itemType, .) != xs:QName('xs:ID')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-15: A schema component MUST NOT have an attribute {}itemType with a value of xs:ID.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

   <!--PATTERN rule_9-16No list item type of xs:IDREF-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No list item type of xs:IDREF</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@itemType)]" priority="1000" mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[exists(@itemType)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@itemType, .) != xs:QName('xs:IDREF')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@itemType, .) != xs:QName('xs:IDREF')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-16: A schema component MUST NOT have an attribute {}itemType with a value of xs:IDREF.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>

   <!--PATTERN rule_9-17No list item type of xs:anySimpleType-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No list item type of xs:anySimpleType</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@itemType)]" priority="1000" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[exists(@itemType)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@itemType, .) != xs:QName('xs:anySimpleType')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@itemType, .) != xs:QName('xs:anySimpleType')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-17: A schema component MUST NOT have an attribute {}itemType with a value of xs:anySimpleType.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN rule_9-18No list item type of xs:ENTITY-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No list item type of xs:ENTITY</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@itemType)]" priority="1000" mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[exists(@itemType)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@itemType, .) != xs:QName('xs:ENTITY')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@itemType, .) != xs:QName('xs:ENTITY')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-18: A schema component MUST NOT have an attribute {}itemType with a value of xs:ENTITY.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

   <!--PATTERN rule_9-19No union member types of xs:ID-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No union member types of xs:ID</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@memberTypes)]" priority="1000" mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[exists(@memberTypes)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $type-qname                       in tokenize(normalize-space(@memberTypes), ' ')                       satisfies resolve-QName($type-qname, .) != xs:QName('xs:ID')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $type-qname in tokenize(normalize-space(@memberTypes), ' ') satisfies resolve-QName($type-qname, .) != xs:QName('xs:ID')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-19: A schema component MUST NOT have an attribute {}memberTypes that includes a value of xs:ID.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>

   <!--PATTERN rule_9-20No union member types of xs:IDREF-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No union member types of xs:IDREF</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@memberTypes)]" priority="1000" mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[exists(@memberTypes)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $type-qname                       in tokenize(normalize-space(@memberTypes), ' ')                       satisfies resolve-QName($type-qname, .) != xs:QName('xs:IDREF')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $type-qname in tokenize(normalize-space(@memberTypes), ' ') satisfies resolve-QName($type-qname, .) != xs:QName('xs:IDREF')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-20: A schema component MUST NOT have an attribute {}memberTypes that includes a value of xs:IDREF.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>

   <!--PATTERN rule_9-21No union member types of xs:IDREFS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No union member types of xs:IDREFS</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@memberTypes)]" priority="1000" mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[exists(@memberTypes)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $type-qname                       in tokenize(normalize-space(@memberTypes), ' ')                       satisfies resolve-QName($type-qname, .) != xs:QName('xs:IDREFS')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $type-qname in tokenize(normalize-space(@memberTypes), ' ') satisfies resolve-QName($type-qname, .) != xs:QName('xs:IDREFS')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-21: A schema component MUST NOT have an attribute {}memberTypes that includes a value of xs:IDREFS.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>

   <!--PATTERN rule_9-22No union member types of xs:anySimpleType-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No union member types of xs:anySimpleType</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@memberTypes)]" priority="1000" mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[exists(@memberTypes)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $type-qname                       in tokenize(normalize-space(@memberTypes), ' ')                       satisfies resolve-QName($type-qname, .) != xs:QName('xs:anySimpleType')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $type-qname in tokenize(normalize-space(@memberTypes), ' ') satisfies resolve-QName($type-qname, .) != xs:QName('xs:anySimpleType')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-22: A schema component MUST NOT have an attribute {}memberTypes that includes a value of xs:anySimpleType.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>

   <!--PATTERN rule_9-23No union member types of xs:ENTITY-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No union member types of xs:ENTITY</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@memberTypes)]" priority="1000" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[exists(@memberTypes)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $type-qname                       in tokenize(normalize-space(@memberTypes), ' ')                       satisfies resolve-QName($type-qname, .) != xs:QName('xs:ENTITY')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $type-qname in tokenize(normalize-space(@memberTypes), ' ') satisfies resolve-QName($type-qname, .) != xs:QName('xs:ENTITY')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-23: A schema component MUST NOT have an attribute {}memberTypes that includes a value of xs:ENTITY.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>

   <!--PATTERN rule_9-24No union member types of xs:ENTITIES-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No union member types of xs:ENTITIES</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@memberTypes)]" priority="1000" mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[exists(@memberTypes)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $type-qname                       in tokenize(normalize-space(@memberTypes), ' ')                       satisfies resolve-QName($type-qname, .) != xs:QName('xs:ENTITIES')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $type-qname in tokenize(normalize-space(@memberTypes), ' ') satisfies resolve-QName($type-qname, .) != xs:QName('xs:ENTITIES')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-24: A schema component MUST NOT have an attribute {}memberTypes that includes a value of xs:ENTITIES.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>

   <!--PATTERN rule_9-25Complex type definition is top-level-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Complex type definition is top-level</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType" priority="1000" mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:complexType"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(parent::xs:schema)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(parent::xs:schema)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-25: A complex type definition MUST be top-level.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>

   <!--PATTERN rule_9-26Complex type has data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Complex type has data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType" priority="1000" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:complexType"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $definition in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $definition in xs:annotation/xs:documentation[1] satisfies string-length(normalize-space(string($definition))) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-26: A complex type MUST have a data definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>

   <!--PATTERN rule_9-27No mixed content on complex type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No mixed content on complex type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType[exists(@mixed)]" priority="1000" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[exists(@mixed)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:boolean(@mixed) = false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="xs:boolean(@mixed) = false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-27: A complex type definition MUST NOT have mixed content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>

   <!--PATTERN rule_9-28No mixed content on complex content-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No mixed content on complex content</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexContent[exists(@mixed)]"
                 priority="1000"
                 mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexContent[exists(@mixed)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:boolean(@mixed) = false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="xs:boolean(@mixed) = false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-28: A complex type definition with complex content MUST NOT have mixed content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>

   <!--PATTERN rule_9-29Complex type content is explicitly simple or complex-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Complex type content is explicitly simple or complex</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType" priority="1000" mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:complexType"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(xs:simpleContent) or exists(xs:complexContent)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(xs:simpleContent) or exists(xs:complexContent)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-29: An element xs:complexType MUST have a child element xs:simpleContent or xs:complexContent.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>

   <!--PATTERN rule_9-31Base type of complex type with complex content must have complex content-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Base type of complex type with complex content must have complex content</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType/xs:complexContent/xs:*[                        (self::xs:extension or self::xs:restriction)                        and (some $base-qname in resolve-QName(@base, .) satisfies                               namespace-uri-from-QName($base-qname) = nf:get-target-namespace(.))]"
                 priority="1000"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType/xs:complexContent/xs:*[                        (self::xs:extension or self::xs:restriction)                        and (some $base-qname in resolve-QName(@base, .) satisfies                               namespace-uri-from-QName($base-qname) = nf:get-target-namespace(.))]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $base-type in nf:resolve-type(., resolve-QName(@base, .)) satisfies                         empty($base-type/self::xs:complexType/xs:simpleContent)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $base-type in nf:resolve-type(., resolve-QName(@base, .)) satisfies empty($base-type/self::xs:complexType/xs:simpleContent)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-31: The base type of complex type that has complex content MUST be a complex type with complex content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>

   <!--PATTERN rule_9-36Element declaration is top-level-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element declaration is top-level</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@name)]" priority="1000" mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(parent::xs:schema)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(parent::xs:schema)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-36: An element declaration MUST be top-level.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>

   <!--PATTERN rule_9-37Element declaration has data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element declaration has data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@name)]" priority="1000" mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $definition in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $definition in xs:annotation/xs:documentation[1] satisfies string-length(normalize-space(string($definition))) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-37: An element declaration MUST have a data definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>

   <!--PATTERN rule_9-38Untyped element is abstract-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Untyped element is abstract</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:schema/xs:element[empty(@type)]"
                 priority="1000"
                 mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:schema/xs:element[empty(@type)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(@abstract)                       and xs:boolean(@abstract) = true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(@abstract) and xs:boolean(@abstract) = true()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-38: A top-level element declaration that does not set the {type definition} property via the attribute "type" MUST have the {abstract} property with a value of "true".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>

   <!--PATTERN rule_9-39Element of type xs:anySimpleType is abstract-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element of type xs:anySimpleType is abstract</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@type)                                 and resolve-QName(@type, .) = xs:QName('xs:anySimpleType')]"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@type)                                 and resolve-QName(@type, .) = xs:QName('xs:anySimpleType')]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(@abstract)                       and xs:boolean(@abstract) = true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(@abstract) and xs:boolean(@abstract) = true()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-39: An element declaration that has a type xs:anySimpleType MUST have the {abstract} property with a value of "true".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>

   <!--PATTERN rule_9-40Element type not in the XML Schema namespace-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element type not in the XML Schema namespace</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@type)]" priority="1000" mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@type)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="for $type-qname in resolve-QName(@type, .) return                         $type-qname = xs:QName('xs:anySimpleType')                         or namespace-uri-from-QName($type-qname) != xs:anyURI('http://www.w3.org/2001/XMLSchema')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="for $type-qname in resolve-QName(@type, .) return $type-qname = xs:QName('xs:anySimpleType') or namespace-uri-from-QName($type-qname) != xs:anyURI('http://www.w3.org/2001/XMLSchema')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-40: An element type that is not xs:anySimpleType MUST NOT have a namespace name <namespace-uri-for-prefix xmlns="https://iead.ittl.gtri.org/wr24/doc/2011-09-30-2258"
                                            xmlns:sch="http://purl.oclc.org/dsdl/schematron">xs</namespace-uri-for-prefix>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

   <!--PATTERN rule_9-41Element type not in the XML namespace-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element type not in the XML namespace</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@type)]" priority="1000" mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@type)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="namespace-uri-from-QName(resolve-QName(@type, .)) != 'http://www.w3.org/XML/1998/namespace'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="namespace-uri-from-QName(resolve-QName(@type, .)) != 'http://www.w3.org/XML/1998/namespace'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-41: An element type MUST NOT have a namespace name that is in the XML namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>

   <!--PATTERN rule_9-42Element type is not simple type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element type is not simple type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[@type]" priority="1000" mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:element[@type]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $type-qname in resolve-QName(@type, .),                             $type-ns in namespace-uri-from-QName($type-qname),                             $type-local-name in local-name-from-QName($type-qname) satisfies (                         $type-qname = xs:QName('xs:anySimpleType')                         or (($type-ns = nf:get-target-namespace(.)                              or exists(nf:get-document-element(.)/xs:import[                                          xs:anyURI(@namespace) = $type-ns                                          and empty(@appinfo:externalImportIndicator)]))                             and not(ends-with($type-local-name, 'SimpleType'))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $type-qname in resolve-QName(@type, .), $type-ns in namespace-uri-from-QName($type-qname), $type-local-name in local-name-from-QName($type-qname) satisfies ( $type-qname = xs:QName('xs:anySimpleType') or (($type-ns = nf:get-target-namespace(.) or exists(nf:get-document-element(.)/xs:import[ xs:anyURI(@namespace) = $type-ns and empty(@appinfo:externalImportIndicator)])) and not(ends-with($type-local-name, 'SimpleType'))))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-42: An element type that is not xs:anySimpleType MUST NOT be a simple type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>

   <!--PATTERN rule_9-45No element default value-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No element default value</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element" priority="1000" mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:element"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(@default)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(@default)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-45: An element xs:element MUST NOT have an attribute {}default.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>

   <!--PATTERN rule_9-46No element fixed value-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No element fixed value</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element" priority="1000" mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:element"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(@fixed)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(@fixed)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-46: An element xs:element MUST NOT have an attribute {}fixed.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>

   <!--PATTERN rule_9-48Attribute declaration is top-level-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Attribute declaration is top-level</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@name)]" priority="1000" mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(parent::xs:schema)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(parent::xs:schema)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-48: An attribute declaration MUST be top-level.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>

   <!--PATTERN rule_9-49Attribute declaration has data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Attribute declaration has data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@name)]" priority="1000" mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $definition in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $definition in xs:annotation/xs:documentation[1] satisfies string-length(normalize-space(string($definition))) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-49: An attribute declaration MUST have a data definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>

   <!--PATTERN rule_9-50Attribute declaration has type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Attribute declaration has type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@name)]" priority="1000" mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(@type)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(@type)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-50: A top-level attribute declaration MUST have a type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>

   <!--PATTERN rule_9-51No attribute type of xs:ID-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No attribute type of xs:ID</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@type)]" priority="1000" mode="M52">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@type)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@type, .) != xs:QName('xs:ID')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@type, .) != xs:QName('xs:ID')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-51: A schema component MUST NOT have an attribute {}type with a value of xs:ID.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>

   <!--PATTERN rule_9-52No attribute type of xs:IDREF-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No attribute type of xs:IDREF</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@type)]" priority="1000" mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@type)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@type, .) != xs:QName('xs:IDREF')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@type, .) != xs:QName('xs:IDREF')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-52: A schema component MUST NOT have an attribute {}type with a value of xs:IDREF.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>

   <!--PATTERN rule_9-53No attribute type of xs:IDREFS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No attribute type of xs:IDREFS</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@type)]" priority="1000" mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@type)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@type, .) != xs:QName('xs:IDREFS')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@type, .) != xs:QName('xs:IDREFS')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-53: A schema component MUST NOT have an attribute {}type with a value of xs:IDREFS.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>

   <!--PATTERN rule_9-54No attribute type of xs:ENTITY-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No attribute type of xs:ENTITY</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@type)]" priority="1000" mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@type)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@type, .) != xs:QName('xs:ENTITY')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@type, .) != xs:QName('xs:ENTITY')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-54: A schema component MUST NOT have an attribute {}type with a value of xs:ENTITY.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>

   <!--PATTERN rule_9-55No attribute type of xs:ENTITIES-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No attribute type of xs:ENTITIES</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@type)]" priority="1000" mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@type)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@type, .) != xs:QName('xs:ENTITIES')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@type, .) != xs:QName('xs:ENTITIES')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-55: A schema component MUST NOT have an attribute {}type with a value of xs:ENTITIES.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>

   <!--PATTERN rule_9-56No attribute type of xs:anySimpleType-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No attribute type of xs:anySimpleType</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@type)]" priority="1000" mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@type)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="resolve-QName(@type, .) != xs:QName('xs:anySimpleType')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="resolve-QName(@type, .) != xs:QName('xs:anySimpleType')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-56: A schema component MUST NOT have an attribute {}type with a value of xs:anySimpleType.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

   <!--PATTERN rule_9-57No attribute default values-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No attribute default values</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute" priority="1000" mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:attribute"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(@default)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(@default)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-57: An element xs:attribute MUST NOT have an attribute {}default.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>

   <!--PATTERN rule_9-58No fixed values for optional attributes-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No fixed values for optional attributes</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@ref) and @use eq 'required']"
                 priority="1001"
                 mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@ref) and @use eq 'required']"/>

		    <!--REPORT warning-->
      <xsl:if test="false()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 9-58: This rule does not constrain attribute uses that are required</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="xs:attribute" priority="1000" mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:attribute"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(@fixed)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(@fixed)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-58: An element xs:attribute that is not a required attribute use MUST NOT have an attribute {}fixed.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>

   <!--PATTERN rule_9-59No use of element xs:notation-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No use of element xs:notation</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:notation" priority="1000" mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:notation"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-59: The schema MUST NOT contain the element xs:notation.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>

   <!--PATTERN rule_9-61No xs:all-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No xs:all</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:all" priority="1000" mode="M61">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:all"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-61: The schema MUST NOT contain the element xs:all</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>

   <!--PATTERN rule_9-63xs:sequence must be child of xs:extension
              or xs:restriction-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">xs:sequence must be child of xs:extension
              or xs:restriction</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:sequence" priority="1000" mode="M62">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:sequence"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(parent::xs:extension) or exists(parent::xs:restriction)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(parent::xs:extension) or exists(parent::xs:restriction)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-63: An element xs:sequence MUST be a child of element xs:extension or xs:restriction.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>

   <!--PATTERN rule_9-65xs:choice must be child of xs:sequence-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">xs:choice must be child of xs:sequence</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:choice" priority="1000" mode="M63">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:choice"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(parent::xs:sequence)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(parent::xs:sequence)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-65: An element xs:choice MUST be a child of element xs:sequence.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M63"/>
   <xsl:template match="@*|node()" priority="-2" mode="M63">
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>

   <!--PATTERN rule_9-66Sequence has minimum cardinality 1-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Sequence has minimum cardinality 1</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:sequence" priority="1000" mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:sequence"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(@minOccurs) or xs:integer(@minOccurs) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(@minOccurs) or xs:integer(@minOccurs) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-66: An element xs:sequence MUST either not have the attribute {}minOccurs, or that attribute MUST have a value of 1.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M64"/>
   <xsl:template match="@*|node()" priority="-2" mode="M64">
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>

   <!--PATTERN rule_9-67Sequence has maximum cardinality 1-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Sequence has maximum cardinality 1</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:sequence" priority="1000" mode="M65">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:sequence"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(@maxOccurs) or (@maxOccurs instance of xs:integer                                             and 1 = xs:integer(@maxOccurs))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(@maxOccurs) or (@maxOccurs instance of xs:integer and 1 = xs:integer(@maxOccurs))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-67: An element xs:sequence MUST either not have the attribute {}maxOccurs, or that attribute MUST have a value of 1.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M65"/>
   <xsl:template match="@*|node()" priority="-2" mode="M65">
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>

   <!--PATTERN rule_9-68Choice has minimum cardinality 1-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Choice has minimum cardinality 1</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:choice" priority="1000" mode="M66">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:choice"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(@minOccurs) or 1 = xs:integer(@minOccurs)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(@minOccurs) or 1 = xs:integer(@minOccurs)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-68: An element xs:choice MUST either not have the attribute {}minOccurs, or that attribute MUST have a value of 1.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M66"/>
   <xsl:template match="@*|node()" priority="-2" mode="M66">
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>

   <!--PATTERN rule_9-69Choice has maximum cardinality 1-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Choice has maximum cardinality 1</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:choice" priority="1000" mode="M67">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:choice"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(@maxOccurs) or (@maxOccurs instance of xs:integer                                             and 1 = xs:integer(@maxOccurs))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(@maxOccurs) or (@maxOccurs instance of xs:integer and 1 = xs:integer(@maxOccurs))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-69: An element xs:choice MUST either not have the attribute {}maxOccurs, or that attribute MUST have a value of 1.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M67"/>
   <xsl:template match="@*|node()" priority="-2" mode="M67">
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>

   <!--PATTERN rule_9-72No use of xs:unique-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No use of xs:unique</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:unique" priority="1000" mode="M68">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:unique"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-72: The schema MUST NOT contain the element xs:unique.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M68"/>
   <xsl:template match="@*|node()" priority="-2" mode="M68">
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>

   <!--PATTERN rule_9-73No use of xs:key-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No use of xs:key</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:key" priority="1000" mode="M69">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:key"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-73: The schema MUST NOT contain the element xs:key.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M69"/>
   <xsl:template match="@*|node()" priority="-2" mode="M69">
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>

   <!--PATTERN rule_9-74No use of xs:keyref-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No use of xs:keyref</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:keyref" priority="1000" mode="M70">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:keyref"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-74: The schema MUST NOT contain the element xs:keyref.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M70"/>
   <xsl:template match="@*|node()" priority="-2" mode="M70">
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>

   <!--PATTERN rule_9-75No use of xs:group-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No use of xs:group</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:group" priority="1000" mode="M71">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:group"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-75: The schema MUST NOT contain the element xs:group.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M71"/>
   <xsl:template match="@*|node()" priority="-2" mode="M71">
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>

   <!--PATTERN rule_9-76No definition of attribute groups-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No definition of attribute groups</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attributeGroup[@name]" priority="1000" mode="M72">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attributeGroup[@name]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-76: The schema MUST NOT contain an attribute group definition schema component.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M72"/>
   <xsl:template match="@*|node()" priority="-2" mode="M72">
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>

   <!--PATTERN rule_9-77Comment is not recommended-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Comment is not recommended</svrl:text>

	  <!--RULE -->
   <xsl:template match="node()[comment()]" priority="1000" mode="M73">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="node()[comment()]"/>

		    <!--REPORT warning-->
      <xsl:if test="true()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 9-77: An XML Comment is not an XML Schema annotation component; an XML comment SHOULD NOT appear in the schema.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M73"/>
   <xsl:template match="@*|node()" priority="-2" mode="M73">
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>

   <!--PATTERN rule_9-78Documentation element has no element children-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Documentation element has no element children</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:documentation/node()" priority="1000" mode="M74">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:documentation/node()"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::text() or self::comment()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="self::text() or self::comment()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-78: A child of element xs:documentation MUST be text or an XML comment.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M74"/>
   <xsl:template match="@*|node()" priority="-2" mode="M74">
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>

   <!--PATTERN rule_9-79xs:appinfo children are comments, elements, or whitespace-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">xs:appinfo children are comments, elements, or whitespace</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:appinfo/node()" priority="1000" mode="M75">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:appinfo/node()"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::comment()                       or self::element()                       or self::text()[string-length(normalize-space(.)) = 0]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="self::comment() or self::element() or self::text()[string-length(normalize-space(.)) = 0]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-79: A child of element xs:appinfo MUST be an element, a comment, or whitespace text.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M75"/>
   <xsl:template match="@*|node()" priority="-2" mode="M75">
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>

   <!--PATTERN rule_9-80Appinfo child elements have namespaces-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Appinfo child elements have namespaces</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:appinfo/*" priority="1000" mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:appinfo/*"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="namespace-uri() != xs:anyURI('')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="namespace-uri() != xs:anyURI('')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-80: An element that is a child of xs:appinfo MUST have a namespace name.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M76"/>
   <xsl:template match="@*|node()" priority="-2" mode="M76">
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>

   <!--PATTERN rule_9-81Appinfo descendants are not XML Schema elements-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Appinfo descendants are not XML Schema elements</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:appinfo//xs:*" priority="1000" mode="M77">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:appinfo//xs:*"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-81: An element with a namespace name of xs: MUST NOT have an ancestor element xs:appinfo.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M77"/>
   <xsl:template match="@*|node()" priority="-2" mode="M77">
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>

   <!--PATTERN rule_9-82Schema has data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schema has data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:schema" priority="1000" mode="M78">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:schema"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $definition in (xs:annotation/xs:documentation)[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $definition in (xs:annotation/xs:documentation)[1] satisfies string-length(normalize-space(string($definition))) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-82: An element xs:schema MUST have a data definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M78"/>
   <xsl:template match="@*|node()" priority="-2" mode="M78">
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>

   <!--PATTERN rule_9-83Schema document defines target namespace-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schema document defines target namespace</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:schema" priority="1000" mode="M79">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:schema"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(@targetNamespace)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(@targetNamespace)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-83: The schema MUST define a target namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M79"/>
   <xsl:template match="@*|node()" priority="-2" mode="M79">
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>

   <!--PATTERN rule_9-85Schema has version-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schema has version</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:schema" priority="1000" mode="M80">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:schema"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $version in @version satisfies                       string-length(normalize-space(@version)) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $version in @version satisfies string-length(normalize-space(@version)) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-85: An element xs:schema MUST have an attribute {}version that MUST NOT be empty.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M80"/>
   <xsl:template match="@*|node()" priority="-2" mode="M80">
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>

   <!--PATTERN rule_9-88No use of xs:redefine-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No use of xs:redefine</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:redefine" priority="1000" mode="M81">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:redefine"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-88: The schema MUST NOT contain the element xs:redefine.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M81"/>
   <xsl:template match="@*|node()" priority="-2" mode="M81">
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>

   <!--PATTERN rule_9-89No use of xs:include-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">No use of xs:include</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:include" priority="1000" mode="M82">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:include"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-89: The schema MUST NOT contain the element xs:include.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M82"/>
   <xsl:template match="@*|node()" priority="-2" mode="M82">
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>

   <!--PATTERN rule_9-90xs:import must have namespace-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">xs:import must have namespace</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:import" priority="1000" mode="M83">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:import"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(@namespace)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(@namespace)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-90: An element xs:import MUST have an attribute {}namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M83"/>
   <xsl:template match="@*|node()" priority="-2" mode="M83">
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>

   <!--PATTERN rule_9-92Namespace referenced by attribute type is imported-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Namespace referenced by attribute type is imported</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[@type]" priority="1000" mode="M84">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[@type]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $namespace in namespace-uri-from-QName(resolve-QName(@type, .)) satisfies (                         $namespace = nf:get-target-namespace(.)                         or $namespace = xs:anyURI('http://www.w3.org/2001/XMLSchema')                         or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $namespace in namespace-uri-from-QName(resolve-QName(@type, .)) satisfies ( $namespace = nf:get-target-namespace(.) or $namespace = xs:anyURI('http://www.w3.org/2001/XMLSchema') or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-92: The namespace of a type referenced by @type MUST be the target namespace, the XML Schema namespace, or be imported.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M84"/>
   <xsl:template match="@*|node()" priority="-2" mode="M84">
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>

   <!--PATTERN rule_9-93Namespace referenced by attribute base is imported-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Namespace referenced by attribute base is imported</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[@base]" priority="1000" mode="M85">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[@base]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $namespace in namespace-uri-from-QName(resolve-QName(@base, .)) satisfies (                         $namespace = nf:get-target-namespace(.)                         or $namespace = xs:anyURI('http://www.w3.org/2001/XMLSchema')                         or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $namespace in namespace-uri-from-QName(resolve-QName(@base, .)) satisfies ( $namespace = nf:get-target-namespace(.) or $namespace = xs:anyURI('http://www.w3.org/2001/XMLSchema') or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-93: The namespace of a type referenced by @base MUST be the target namespace, the XML Schema namespace, or be imported.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M85"/>
   <xsl:template match="@*|node()" priority="-2" mode="M85">
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>

   <!--PATTERN rule_9-94Namespace referenced by attribute itemType is imported-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Namespace referenced by attribute itemType is imported</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[@itemType]" priority="1000" mode="M86">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[@itemType]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $namespace in namespace-uri-from-QName(resolve-QName(@itemType, .)) satisfies (                         $namespace = nf:get-target-namespace(.)                         or $namespace = xs:anyURI('http://www.w3.org/2001/XMLSchema')                         or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $namespace in namespace-uri-from-QName(resolve-QName(@itemType, .)) satisfies ( $namespace = nf:get-target-namespace(.) or $namespace = xs:anyURI('http://www.w3.org/2001/XMLSchema') or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-94: The namespace of a type referenced by @itemType MUST be the target namespace, the XML Schema namespace, or be imported.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M86"/>
   <xsl:template match="@*|node()" priority="-2" mode="M86">
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>

   <!--PATTERN rule_9-95Namespaces referenced by attribute memberTypes is imported-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Namespaces referenced by attribute memberTypes is imported</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[@memberTypes]" priority="1000" mode="M87">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[@memberTypes]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $type in tokenize(normalize-space(@memberTypes), ' '),                             $namespace in namespace-uri-from-QName(resolve-QName($type, .)) satisfies (                         $namespace = nf:get-target-namespace(.)                         or $namespace = xs:anyURI('http://www.w3.org/2001/XMLSchema')                         or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $type in tokenize(normalize-space(@memberTypes), ' '), $namespace in namespace-uri-from-QName(resolve-QName($type, .)) satisfies ( $namespace = nf:get-target-namespace(.) or $namespace = xs:anyURI('http://www.w3.org/2001/XMLSchema') or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-95: The namespace of a type referenced by @memberTypes MUST be the target namespace, the XML Schema namespace, or be imported.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M87"/>
   <xsl:template match="@*|node()" priority="-2" mode="M87">
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>

   <!--PATTERN rule_9-96Namespace referenced by attribute ref is imported-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Namespace referenced by attribute ref is imported</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[@ref]" priority="1000" mode="M88">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[@ref]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $namespace in namespace-uri-from-QName(resolve-QName(@ref, .)) satisfies                         $namespace = nf:get-target-namespace(.)                         or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $namespace in namespace-uri-from-QName(resolve-QName(@ref, .)) satisfies $namespace = nf:get-target-namespace(.) or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-96: The namespace of a component referenced by @ref MUST be the target namespace or be imported.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M88"/>
   <xsl:template match="@*|node()" priority="-2" mode="M88">
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>

   <!--PATTERN rule_9-97Namespace referenced by attribute substitutionGroup is imported-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Namespace referenced by attribute substitutionGroup is imported</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[@substitutionGroup]" priority="1000" mode="M89">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[@substitutionGroup]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $namespace in namespace-uri-from-QName(resolve-QName(@substitutionGroup, .)) satisfies                         $namespace = nf:get-target-namespace(.)                         or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $namespace in namespace-uri-from-QName(resolve-QName(@substitutionGroup, .)) satisfies $namespace = nf:get-target-namespace(.) or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-97: The namespace of a component referenced by @substitutionGroup MUST be the target namespace or be imported.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M89"/>
   <xsl:template match="@*|node()" priority="-2" mode="M89">
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>

   <!--PATTERN rule_10-2Object type with complex content is derived from structures:ObjectType-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Object type with complex content is derived from structures:ObjectType</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType[exists(xs:complexContent)                                     and not(ends-with(@name, 'AssociationType')                                         or ends-with(@name, 'MetadataType')                                         or ends-with(@name, 'AugmentationType'))]"
                 priority="1000"
                 mode="M90">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[exists(xs:complexContent)                                     and not(ends-with(@name, 'AssociationType')                                         or ends-with(@name, 'MetadataType')                                         or ends-with(@name, 'AugmentationType'))]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="         every $derivation-method in (xs:complexContent/xs:extension, xs:complexContent/xs:restriction),               $base in $derivation-method/@base,               $base-qname in resolve-QName($base, $derivation-method),               $base-local-name in local-name-from-QName($base-qname) satisfies (           $base-qname = xs:QName('structures:ObjectType')           or not(ends-with($base-local-name, 'AssociationType')                  or ends-with($base-local-name, 'MetadataType')                  or ends-with($base-local-name, 'AugmentationType')))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $derivation-method in (xs:complexContent/xs:extension, xs:complexContent/xs:restriction), $base in $derivation-method/@base, $base-qname in resolve-QName($base, $derivation-method), $base-local-name in local-name-from-QName($base-qname) satisfies ( $base-qname = xs:QName('structures:ObjectType') or not(ends-with($base-local-name, 'AssociationType') or ends-with($base-local-name, 'MetadataType') or ends-with($base-local-name, 'AugmentationType')))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-2: An object type with complex content MUST be derived from structures:ObjectType or from another object type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M90"/>
   <xsl:template match="@*|node()" priority="-2" mode="M90">
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>

   <!--PATTERN rule_10-3RoleOf element type is an object type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">RoleOf element type is an object type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[@name[starts-with(., 'RoleOf')]]"
                 priority="1000"
                 mode="M91">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[@name[starts-with(., 'RoleOf')]]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $type in @type,                             $type-local-name in local-name-from-QName(resolve-QName($type, .)) satisfies                         not(ends-with($type-local-name, 'AssociationType')                             or ends-with($type-local-name, 'MetadataType')                             or ends-with($type-local-name, 'AugmentationType'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $type in @type, $type-local-name in local-name-from-QName(resolve-QName($type, .)) satisfies not(ends-with($type-local-name, 'AssociationType') or ends-with($type-local-name, 'MetadataType') or ends-with($type-local-name, 'AugmentationType'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-3: The type definition of a RoleOf element MUST be an object type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M91"/>
   <xsl:template match="@*|node()" priority="-2" mode="M91">
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>

   <!--PATTERN rule_10-4Only object type has RoleOf element-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Only object type has RoleOf element</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType[       empty(@appinfo:externalAdapterTypeIndicator)       and exists(descendant::xs:element[             exists(@ref[               starts-with(local-name-from-QName(resolve-QName(., ..)), 'RoleOf')])])]"
                 priority="1000"
                 mode="M92">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[       empty(@appinfo:externalAdapterTypeIndicator)       and exists(descendant::xs:element[             exists(@ref[               starts-with(local-name-from-QName(resolve-QName(., ..)), 'RoleOf')])])]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(ends-with(@name, 'AssociationType')                           or ends-with(@name, 'MetadataType')                           or ends-with(@name, 'AugmentationType'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(ends-with(@name, 'AssociationType') or ends-with(@name, 'MetadataType') or ends-with(@name, 'AugmentationType'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-4: A complex type that includes a RoleOf element in its content model MUST be an object type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M92"/>
   <xsl:template match="@*|node()" priority="-2" mode="M92">
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>

   <!--PATTERN rule_10-7Import of external namespace has data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Import of external namespace has data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:import[@appinfo:externalImportIndicator]"
                 priority="1000"
                 mode="M93">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:import[@appinfo:externalImportIndicator]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $definition in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $definition in xs:annotation/xs:documentation[1] satisfies string-length(normalize-space(string($definition))) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-7: An element xs:import that is annotated as importing an external schema document MUST be a documented component.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M93"/>
   <xsl:template match="@*|node()" priority="-2" mode="M93">
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>

   <!--PATTERN rule_10-9Structure of external adapter type definition follows pattern-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Structure of external adapter type definition follows pattern</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType[@appinfo:externalAdapterTypeIndicator]"
                 priority="1000"
                 mode="M94">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[@appinfo:externalAdapterTypeIndicator]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:complexContent/xs:extension[                         resolve-QName(@base, .) = xs:QName('structures:ObjectType')                       ]/xs:sequence"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="xs:complexContent/xs:extension[ resolve-QName(@base, .) = xs:QName('structures:ObjectType') ]/xs:sequence">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-9: An external adapter type definition MUST be a complex type definition with complex content that extends structures:ObjectType, and that uses xs:sequence as its top-level compositor.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M94"/>
   <xsl:template match="@*|node()" priority="-2" mode="M94">
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>

   <!--PATTERN rule_10-10Element use from external adapter type defined by external schema documents-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element use from external adapter type defined by external schema documents</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[@ref                                 and exists(ancestor::xs:complexType[exists(@appinfo:externalAdapterTypeIndicator)])]"
                 priority="1000"
                 mode="M95">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[@ref                                 and exists(ancestor::xs:complexType[exists(@appinfo:externalAdapterTypeIndicator)])]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $ref-namespace in namespace-uri-from-QName(resolve-QName(@ref, .)) satisfies                         nf:get-document-element(.)/xs:import[                           $ref-namespace = xs:anyURI(@namespace)                           and @appinfo:externalImportIndicator]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $ref-namespace in namespace-uri-from-QName(resolve-QName(@ref, .)) satisfies nf:get-document-element(.)/xs:import[ $ref-namespace = xs:anyURI(@namespace) and @appinfo:externalImportIndicator]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-10: An element reference that appears within an external adapter type MUST have a target namespace that is imported as external.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M95"/>
   <xsl:template match="@*|node()" priority="-2" mode="M95">
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>

   <!--PATTERN rule_10-11External adapter type not a base type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">External adapter type not a base type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[(self::xs:extension or self::xs:restriction)                           and (some $base-qname in resolve-QName(@base, .),                                     $base-namespace in namespace-uri-from-QName($base-qname) satisfies                                  nf:get-target-namespace(.) = $base-namespace)]"
                 priority="1000"
                 mode="M96">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[(self::xs:extension or self::xs:restriction)                           and (some $base-qname in resolve-QName(@base, .),                                     $base-namespace in namespace-uri-from-QName($base-qname) satisfies                                  nf:get-target-namespace(.) = $base-namespace)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="nf:resolve-type(., resolve-QName(@base, .))[                         empty(@appinfo:externalAdapterTypeIndicator)]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="nf:resolve-type(., resolve-QName(@base, .))[ empty(@appinfo:externalAdapterTypeIndicator)]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-11: An external adapter type definition MUST NOT be a base type definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M96"/>
   <xsl:template match="@*|node()" priority="-2" mode="M96">
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>

   <!--PATTERN rule_10-14External attribute use has data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">External attribute use has data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[some $ref-namespace in namespace-uri-from-QName(resolve-QName(@ref, .)),                                        $import in ancestor::xs:schema[1]/xs:import satisfies (                                     xs:anyURI($import/@namespace) = $ref-namespace                                     and exists(@appinfo:externalImportIndicator))]"
                 priority="1000"
                 mode="M97">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[some $ref-namespace in namespace-uri-from-QName(resolve-QName(@ref, .)),                                        $import in ancestor::xs:schema[1]/xs:import satisfies (                                     xs:anyURI($import/@namespace) = $ref-namespace                                     and exists(@appinfo:externalImportIndicator))]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $documentation in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($documentation))) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $documentation in xs:annotation/xs:documentation[1] satisfies string-length(normalize-space(string($documentation))) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-14: An external attribute use MUST be a documented component with a non-empty data definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M97"/>
   <xsl:template match="@*|node()" priority="-2" mode="M97">
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>

   <!--PATTERN rule_10-16External element use has data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">External element use has data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[       some $ref-namespace in namespace-uri-from-QName(resolve-QName(@ref, .)) satisfies         nf:get-document-element(.)/self::xs:schema//xs:import[           xs:anyURI(@namespace) = $ref-namespace           and @appinfo:externalImportIndicator]]"
                 priority="1000"
                 mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[       some $ref-namespace in namespace-uri-from-QName(resolve-QName(@ref, .)) satisfies         nf:get-document-element(.)/self::xs:schema//xs:import[           xs:anyURI(@namespace) = $ref-namespace           and @appinfo:externalImportIndicator]]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $documentation in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($documentation))) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $documentation in xs:annotation/xs:documentation[1] satisfies string-length(normalize-space(string($documentation))) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-16: An external attribute use MUST be a documented component with a non-empty data definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M98"/>
   <xsl:template match="@*|node()" priority="-2" mode="M98">
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>

   <!--PATTERN rule_10-17Name of code type ends in "CodeType"-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Name of code type ends in "CodeType"</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType[exists(xs:simpleContent[                        exists(xs:*[local-name() = ('extension', 'restriction')                                    and (ends-with(@base, 'CodeSimpleType')                                    or ends-with(@base, 'CodeType'))])])]"
                 priority="1000"
                 mode="M99">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[exists(xs:simpleContent[                        exists(xs:*[local-name() = ('extension', 'restriction')                                    and (ends-with(@base, 'CodeSimpleType')                                    or ends-with(@base, 'CodeType'))])])]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(ends-with(@name, 'CodeType'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(ends-with(@name, 'CodeType'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 10-17: A complex type definition with a {base type definition} of a code type or code simple type SHOULD have a {name} that ends in 'CodeType'.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M99"/>
   <xsl:template match="@*|node()" priority="-2" mode="M99">
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>

   <!--PATTERN rule_10-19Element of code type has code representation term-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element of code type has code representation term</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@name) and exists(@type) and ends-with(@type, 'CodeType')]"
                 priority="1000"
                 mode="M100">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@name) and exists(@type) and ends-with(@type, 'CodeType')]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(ends-with(@name, 'Code'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(ends-with(@name, 'Code'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 10-19: An element with a type that is a code type SHOULD have a name with representation term "Code"</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M100"/>
   <xsl:template match="@*|node()" priority="-2" mode="M100">
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>

   <!--PATTERN rule_10-20Proxy type has designated structure-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Proxy type has designated structure</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType[some $name in @name,                                     $extension in xs:simpleContent/xs:extension,                                     $base-qname in resolve-QName($extension/@base, $extension) satisfies                                     $base-qname = QName('http://www.w3.org/2001/XMLSchema', $name)]"
                 priority="1000"
                 mode="M101">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[some $name in @name,                                     $extension in xs:simpleContent/xs:extension,                                     $base-qname in resolve-QName($extension/@base, $extension) satisfies                                     $base-qname = QName('http://www.w3.org/2001/XMLSchema', $name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:simpleContent[                         xs:extension[                           empty(xs:attribute)                           and count(xs:attributeGroup) = 1                           and xs:attributeGroup[                                 resolve-QName(@ref, .) = xs:QName('structures:SimpleObjectAttributeGroup')]]]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="xs:simpleContent[ xs:extension[ empty(xs:attribute) and count(xs:attributeGroup) = 1 and xs:attributeGroup[ resolve-QName(@ref, .) = xs:QName('structures:SimpleObjectAttributeGroup')]]]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-20: A proxy type MUST have the designated structure. It MUST use xs:extension. It MUST NOT use xs:attribute. It MUST include exactly one xs:attributeGroup reference, which must be to structures:SimpleObjectAttributeGroup.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M101"/>
   <xsl:template match="@*|node()" priority="-2" mode="M101">
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>

   <!--PATTERN rule_10-21Association type derived from structures:AssociationType-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Association type derived from structures:AssociationType</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType" priority="1000" mode="M102">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:complexType"/>
      <xsl:variable name="is-association-type"
                    select="exists(@name[ends-with(., 'AssociationType')])"/>
      <xsl:variable name="has-association-base-type"
                    select="       exists(xs:complexContent[         exists(xs:*[local-name() = ('extension', 'restriction')                     and exists(@base[ends-with(., 'AssociationType')])])])"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$is-association-type = $has-association-base-type"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$is-association-type = $has-association-base-type">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-21: A type MUST have an association type name if and only if it is derived from an association type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M102"/>
   <xsl:template match="@*|node()" priority="-2" mode="M102">
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>

   <!--PATTERN rule_10-22Association element type is an association type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Association element type is an association type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@name)]" priority="1000" mode="M103">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(@type[ends-with(., 'AssociationType')])                       = exists(@name[ends-with(., 'Association')])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(@type[ends-with(., 'AssociationType')]) = exists(@name[ends-with(., 'Association')])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-22: An element MUST have a name that ends in 'Association' if and only if it has a type that is an association type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M103"/>
   <xsl:template match="@*|node()" priority="-2" mode="M103">
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>

   <!--PATTERN rule_10-24Augmentable type has at most one augmentation point element-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Augmentable type has at most one augmentation point element</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType[                        @name[not(ends-with(., 'MetadataType'))                              and not(ends-with(., 'AugmentationType'))]                        and empty(@appinfo:externalAdapterTypeIndicator)                        and xs:complexContent]"
                 priority="1000"
                 mode="M104">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[                        @name[not(ends-with(., 'MetadataType'))                              and not(ends-with(., 'AugmentationType'))]                        and empty(@appinfo:externalAdapterTypeIndicator)                        and xs:complexContent]"/>
      <xsl:variable name="augmentation-point-qname"
                    select="QName(string(nf:get-target-namespace(.)),                           replace(./@name, 'Type$', 'AugmentationPoint'))"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(xs:complexContent/xs:extension/xs:sequence/xs:element[                               @ref[resolve-QName(., ..) = $augmentation-point-qname]]) le 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(xs:complexContent/xs:extension/xs:sequence/xs:element[ @ref[resolve-QName(., ..) = $augmentation-point-qname]]) le 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-24: An augmentable type MUST contain no more than one element use of its corresponding augmentation point element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M104"/>
   <xsl:template match="@*|node()" priority="-2" mode="M104">
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>

   <!--PATTERN rule_10-25Augmentation point element corresponds to its base type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Augmentation point element corresponds to its base type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@name[                                  matches(., 'AugmentationPoint$')])]"
                 priority="1000"
                 mode="M105">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@name[                                  matches(., 'AugmentationPoint$')])]"/>
      <xsl:variable name="element-name" select="@name"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(                         parent::xs:schema/xs:complexType[                           @name = replace($element-name, 'AugmentationPoint$', 'Type')                           and exists(@name[                                   not(ends-with(., 'MetadataType'))                                   and not(ends-with(., 'AugmentationType'))])                                 and empty(@appinfo:externalAdapterTypeIndicator)                                 and exists(child::xs:complexContent)])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists( parent::xs:schema/xs:complexType[ @name = replace($element-name, 'AugmentationPoint$', 'Type') and exists(@name[ not(ends-with(., 'MetadataType')) and not(ends-with(., 'AugmentationType'))]) and empty(@appinfo:externalAdapterTypeIndicator) and exists(child::xs:complexContent)])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-25: A schema document containing an element declaration for an augmentation point element MUST also contain a type definition for its base type, a corresponding augmentable type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M105"/>
   <xsl:template match="@*|node()" priority="-2" mode="M105">
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>

   <!--PATTERN rule_10-26An augmentation point element has no type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">An augmentation point element has no type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@name[                                  matches(., 'AugmentationPoint$')])]"
                 priority="1000"
                 mode="M106">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@name[                                  matches(., 'AugmentationPoint$')])]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(@type)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(@type)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-26: An augmentation point element MUST have no type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M106"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M106"/>
   <xsl:template match="@*|node()" priority="-2" mode="M106">
      <xsl:apply-templates select="*" mode="M106"/>
   </xsl:template>

   <!--PATTERN rule_10-27An augmentation point element has no substitution group-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">An augmentation point element has no substitution group</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@name[                                  matches(., 'AugmentationPoint$')])]"
                 priority="1000"
                 mode="M107">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@name[                                  matches(., 'AugmentationPoint$')])]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(@substitutionGroup)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(@substitutionGroup)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-27: An augmentation point element MUST have no substitution group.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M107"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M107"/>
   <xsl:template match="@*|node()" priority="-2" mode="M107">
      <xsl:apply-templates select="*" mode="M107"/>
   </xsl:template>

   <!--PATTERN rule_10-28Augmentation point element is only referenced by its base type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Augmentation point element is only referenced by its base type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType//xs:element[exists(@ref[                        matches(local-name-from-QName(resolve-QName(., ..)), 'AugmentationPoint$')]) ]"
                 priority="1000"
                 mode="M108">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType//xs:element[exists(@ref[                        matches(local-name-from-QName(resolve-QName(., ..)), 'AugmentationPoint$')]) ]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="QName(string(nf:get-target-namespace(ancestor::xs:complexType[1])), ancestor::xs:complexType[1]/@name)                       = QName(string(namespace-uri-from-QName(resolve-QName(@ref, .))),                           replace(local-name-from-QName(resolve-QName(@ref, .)), 'AugmentationPoint$', 'Type'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="QName(string(nf:get-target-namespace(ancestor::xs:complexType[1])), ancestor::xs:complexType[1]/@name) = QName(string(namespace-uri-from-QName(resolve-QName(@ref, .))), replace(local-name-from-QName(resolve-QName(@ref, .)), 'AugmentationPoint$', 'Type'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-28: An augmentation point element MUST only be referenced by its base type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M108"/>
   <xsl:template match="@*|node()" priority="-2" mode="M108">
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>

   <!--PATTERN rule_10-31Augmentation point element use must be last element in its base type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Augmentation point element use must be last element in its base type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType//xs:element[exists(@ref[                            matches(local-name-from-QName(resolve-QName(., ..)), 'AugmentationPoint$')]) ]"
                 priority="1000"
                 mode="M109">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType//xs:element[exists(@ref[                            matches(local-name-from-QName(resolve-QName(., ..)), 'AugmentationPoint$')]) ]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(following-sibling::*)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(following-sibling::*)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-31: An augmentation point element particle MUST be the last element occurrence in its content model.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M109"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M109"/>
   <xsl:template match="@*|node()" priority="-2" mode="M109">
      <xsl:apply-templates select="*" mode="M109"/>
   </xsl:template>

   <!--PATTERN rule_10-34Schema component with name ending in "AugmentationType" is an augmentation type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schema component with name ending in "AugmentationType" is an augmentation type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[ends-with(@name, 'AugmentationType')]"
                 priority="1000"
                 mode="M110">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[ends-with(@name, 'AugmentationType')]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::xs:complexType/xs:complexContent/xs:*[                         (self::xs:extension or self::xs:restriction)                         and ends-with(@base, 'AugmentationType')]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="self::xs:complexType/xs:complexContent/xs:*[ (self::xs:extension or self::xs:restriction) and ends-with(@base, 'AugmentationType')]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-34: An augmentation type definition schema component with {name} ending in 'AugmentationType' MUST be an augmentation type definition that is a complex type definition with complex content that extends or restricts an augmentation type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M110"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M110"/>
   <xsl:template match="@*|node()" priority="-2" mode="M110">
      <xsl:apply-templates select="*" mode="M110"/>
   </xsl:template>

   <!--PATTERN rule_10-35Type derived from structures:AugmentationType is an augmentation type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Type derived from structures:AugmentationType is an augmentation type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[(self::xs:restriction or self::xs:extension)                           and ends-with(@base, 'AugmentationType')]"
                 priority="1000"
                 mode="M111">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[(self::xs:restriction or self::xs:extension)                           and ends-with(@base, 'AugmentationType')]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::xs:complexType[ends-with(@name, 'AugmentationType')]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ancestor::xs:complexType[ends-with(@name, 'AugmentationType')]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-35: A type definition derived from an augmentation type MUST be an augmentation type definition</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M111"/>
   <xsl:template match="@*|node()" priority="-2" mode="M111">
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>

   <!--PATTERN rule_10-36Augmentation element type is an augmentation type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Augmentation element type is an augmentation type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@name)]" priority="1000" mode="M112">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(@type[ends-with(., 'AugmentationType')])                       = exists(@name[ends-with(., 'Augmentation')])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(@type[ends-with(., 'AugmentationType')]) = exists(@name[ends-with(., 'Augmentation')])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-36: An element declaration MUST have a name that ends in "Augmentation" if and only if it has a type that is an augmentation type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M112"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M112"/>
   <xsl:template match="@*|node()" priority="-2" mode="M112">
      <xsl:apply-templates select="*" mode="M112"/>
   </xsl:template>

   <!--PATTERN rule_10-39Metadata types are derived from structures:MetadataType-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata types are derived from structures:MetadataType</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType" priority="1000" mode="M113">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:complexType"/>
      <xsl:variable name="is-metadata-type"
                    select="exists(@name[ends-with(., 'MetadataType')])"/>
      <xsl:variable name="has-metadata-base-type"
                    select="exists(xs:complexContent[         exists(xs:*[local-name() = ('extension', 'restriction')                     and exists(@base[ends-with(., 'MetadataType')])])])"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$is-metadata-type = $has-metadata-base-type"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$is-metadata-type = $has-metadata-base-type">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-39: A type MUST be a metadata type if and only if it is derived from a metadata type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M113"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M113"/>
   <xsl:template match="@*|node()" priority="-2" mode="M113">
      <xsl:apply-templates select="*" mode="M113"/>
   </xsl:template>

   <!--PATTERN rule_10-40Metadata element declaration type is a metadata type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata element declaration type is a metadata type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@name)]" priority="1000" mode="M114">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(@type[ends-with(., 'MetadataType')])                       = exists(@name[ends-with(., 'Metadata')])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(@type[ends-with(., 'MetadataType')]) = exists(@name[ends-with(., 'Metadata')])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-40: An element MUST have a name that ends in 'Metadata' if and only if it has a type that is a metadata type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M114"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M114"/>
   <xsl:template match="@*|node()" priority="-2" mode="M114">
      <xsl:apply-templates select="*" mode="M114"/>
   </xsl:template>

   <!--PATTERN rule_10-42Name of element that ends in "Representation" is abstract-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Name of element that ends in "Representation" is abstract</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[@name[ends-with(., 'Representation')]]"
                 priority="1000"
                 mode="M115">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[@name[ends-with(., 'Representation')]]"/>

		    <!--REPORT warning-->
      <xsl:if test="empty(@abstract) or xs:boolean(@abstract) = false()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="empty(@abstract) or xs:boolean(@abstract) = false()">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 10-42: An element declaration with a name that ends in 'Representation' SHOULD have the {abstract} property with a value of "true".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M115"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M115"/>
   <xsl:template match="@*|node()" priority="-2" mode="M115">
      <xsl:apply-templates select="*" mode="M115"/>
   </xsl:template>

   <!--PATTERN rule_10-45Schema component names have only specific characters-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schema component names have only specific characters</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@name)]" priority="1000" mode="M116">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[exists(@name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(@name, '^[A-Za-z0-9\-_\.]*$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(@name, '^[A-Za-z0-9\-_\.]*$')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-45: The name of an XML Schema component defined by the schema must be composed of only the characters uppercase 'A' through 'Z', lowercase 'a' through 'z', numbers '0' through '9', underscore, hyphen, and period.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M116"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M116"/>
   <xsl:template match="@*|node()" priority="-2" mode="M116">
      <xsl:apply-templates select="*" mode="M116"/>
   </xsl:template>

   <!--PATTERN rule_10-48Attribute name begins with lower case letter-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Attribute name begins with lower case letter</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@name)]" priority="1000" mode="M117">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(@name, '^[a-z]')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(@name, '^[a-z]')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-48: Within the schema, any attribute declaration MUST have a name that begins with a lowercase letter
      ('a'-'z').</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M117"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M117"/>
   <xsl:template match="@*|node()" priority="-2" mode="M117">
      <xsl:apply-templates select="*" mode="M117"/>
   </xsl:template>

   <!--PATTERN rule_10-49Name of schema component other than attribute and proxy type begins with upper case letter-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Name of schema component other than attribute and proxy type begins with upper case letter</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute" priority="1002" mode="M118">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:attribute"/>

		    <!--REPORT warning-->
      <xsl:if test="false()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 10-49: This rule does not apply to an attribute.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="xs:complexType[some $name in @name,                                     $extension in xs:simpleContent/xs:extension,                                     $base-qname in resolve-QName($extension/@base, $extension) satisfies                                     $base-qname = QName('http://www.w3.org/2001/XMLSchema', $name)]"
                 priority="1001"
                 mode="M118">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[some $name in @name,                                     $extension in xs:simpleContent/xs:extension,                                     $base-qname in resolve-QName($extension/@base, $extension) satisfies                                     $base-qname = QName('http://www.w3.org/2001/XMLSchema', $name)]"/>

		    <!--REPORT warning-->
      <xsl:if test="false()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 10-49: This rule does not apply to a proxy types.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@name)]" priority="1000" mode="M118">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[exists(@name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(@name, '^[A-Z]')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(@name, '^[A-Z]')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-49: Within the schema, an XML Schema component that is not an attribute declaration or proxy type MUST have a name that begins with an upper-case letter ('A'-'Z').</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M118"/>
   <xsl:template match="@*|node()" priority="-2" mode="M118">
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>

   <!--PATTERN rule_10-68Deprecated annotates schema component-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Deprecated annotates schema component</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[exists(@appinfo:deprecated)]" priority="1000" mode="M119">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[exists(@appinfo:deprecated)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="namespace-uri-from-QName(node-name(.)) = xs:anyURI('http://www.w3.org/2001/XMLSchema')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="namespace-uri-from-QName(node-name(.)) = xs:anyURI('http://www.w3.org/2001/XMLSchema')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-68: The attribute appinfo:deprecated MUST be owned by an element with a namespace name <namespace-uri-for-prefix xmlns="https://iead.ittl.gtri.org/wr24/doc/2011-09-30-2258"
                                            xmlns:sch="http://purl.oclc.org/dsdl/schematron">xs</namespace-uri-for-prefix>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M119"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M119"/>
   <xsl:template match="@*|node()" priority="-2" mode="M119">
      <xsl:apply-templates select="*" mode="M119"/>
   </xsl:template>

   <!--PATTERN rule_10-69External import indicator annotates import-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">External import indicator annotates import</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[exists(@appinfo:externalImportIndicator)]"
                 priority="1000"
                 mode="M120">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[exists(@appinfo:externalImportIndicator)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(self::xs:import)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(self::xs:import)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-69: The attribute {http://release.niem.gov/niem/appinfo/4.0/}externalImportIndicator MUST be owned by an element xs:import.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M120"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M120"/>
   <xsl:template match="@*|node()" priority="-2" mode="M120">
      <xsl:apply-templates select="*" mode="M120"/>
   </xsl:template>

   <!--PATTERN rule_10-70External adapter type indicator annotates complex type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">External adapter type indicator annotates complex type</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[exists(@appinfo:externalAdapterTypeIndicator)]"
                 priority="1000"
                 mode="M121">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[exists(@appinfo:externalAdapterTypeIndicator)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(self::xs:complexType)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(self::xs:complexType)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-70: The attribute appinfo:externalAdapterTypeIndicator MUST be owned by an element xs:complexType.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M121"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M121"/>
   <xsl:template match="@*|node()" priority="-2" mode="M121">
      <xsl:apply-templates select="*" mode="M121"/>
   </xsl:template>

   <!--PATTERN rule_10-71appinfo:appliesToTypes annotates metadata element-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">appinfo:appliesToTypes annotates metadata element</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[exists(@appinfo:appliesToTypes)]"
                 priority="1000"
                 mode="M122">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[exists(@appinfo:appliesToTypes)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(self::xs:element[exists(@name)                                and ends-with(@name, 'Metadata')])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(self::xs:element[exists(@name) and ends-with(@name, 'Metadata')])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-71: The attribute appinfo:appliesToTypes MUST be owned by a metadata element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M122"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M122"/>
   <xsl:template match="@*|node()" priority="-2" mode="M122">
      <xsl:apply-templates select="*" mode="M122"/>
   </xsl:template>

   <!--PATTERN rule_10-73appinfo:appliesToElements annotates metadata element-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">appinfo:appliesToElements annotates metadata element</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[exists(@appinfo:appliesToElements)]"
                 priority="1000"
                 mode="M123">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[exists(@appinfo:appliesToElements)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(self::xs:element[                           exists(@name)                           and ends-with(@name, 'Metadata')])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(self::xs:element[ exists(@name) and ends-with(@name, 'Metadata')])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-73: The attribute appinfo:appliesToElements MUST be owned by a metadata element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M123"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M123"/>
   <xsl:template match="@*|node()" priority="-2" mode="M123">
      <xsl:apply-templates select="*" mode="M123"/>
   </xsl:template>

   <!--PATTERN rule_10-75appinfo:LocalTerm annotates schema-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">appinfo:LocalTerm annotates schema</svrl:text>

	  <!--RULE -->
   <xsl:template match="appinfo:LocalTerm" priority="1000" mode="M124">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="appinfo:LocalTerm"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="parent::xs:appinfo[parent::xs:annotation[parent::xs:schema]]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="parent::xs:appinfo[parent::xs:annotation[parent::xs:schema]]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-75: The element appinfo:LocalTerm MUST be application information on an element xs:schema.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M124"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M124"/>
   <xsl:template match="@*|node()" priority="-2" mode="M124">
      <xsl:apply-templates select="*" mode="M124"/>
   </xsl:template>

   <!--PATTERN rule_10-76appinfo:LocalTerm has literal or definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">appinfo:LocalTerm has literal or definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="appinfo:LocalTerm" priority="1000" mode="M125">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="appinfo:LocalTerm"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(@literal) or exists(@definition)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(@literal) or exists(@definition)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-76: The element {http://release.niem.gov/niem/appinfo/4.0/}LocalTerm MUST have a literal or definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M125"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M125"/>
   <xsl:template match="@*|node()" priority="-2" mode="M125">
      <xsl:apply-templates select="*" mode="M125"/>
   </xsl:template>

   <!--PATTERN rule_11-1Name of type ends in "Type"-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Name of type ends in "Type"</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType[some $name in @name,                                     $extension in xs:simpleContent/xs:extension,                                     $base-qname in resolve-QName($extension/@base, $extension) satisfies                                     $base-qname = QName('http://www.w3.org/2001/XMLSchema', $name)]"
                 priority="1001"
                 mode="M126">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[some $name in @name,                                     $extension in xs:simpleContent/xs:extension,                                     $base-qname in resolve-QName($extension/@base, $extension) satisfies                                     $base-qname = QName('http://www.w3.org/2001/XMLSchema', $name)]"/>

		    <!--REPORT warning-->
      <xsl:if test="false()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-1: The name of a proxy type does not end in "Type".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M126"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="xs:*[(self::xs:simpleType or self::xs:complexType) and exists(@name)]"
                 priority="1000"
                 mode="M126">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[(self::xs:simpleType or self::xs:complexType) and exists(@name)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ends-with(@name, 'Type')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ends-with(@name, 'Type')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-1: A type definition schema component that does not define a proxy type MUST have a name that ends in "Type".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M126"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M126"/>
   <xsl:template match="@*|node()" priority="-2" mode="M126">
      <xsl:apply-templates select="*" mode="M126"/>
   </xsl:template>

   <!--PATTERN rule_11-2Base type definition defined by conformant schema-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Base type definition defined by conformant schema</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[exists(@base)]" priority="1000" mode="M127">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:*[exists(@base)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $base-namespace in namespace-uri-from-QName(resolve-QName(@base, .)) satisfies (                         $base-namespace = (nf:get-target-namespace(.), xs:anyURI('http://www.w3.org/2001/XMLSchema'))                         or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace)                                                                    and $base-namespace = xs:anyURI(@namespace)                                                                    and empty(@appinfo:externalImportIndicator)]))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $base-namespace in namespace-uri-from-QName(resolve-QName(@base, .)) satisfies ( $base-namespace = (nf:get-target-namespace(.), xs:anyURI('http://www.w3.org/2001/XMLSchema')) or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace) and $base-namespace = xs:anyURI(@namespace) and empty(@appinfo:externalImportIndicator)]))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-2: The {base type definition} of a type definition MUST have the target namespace or the XML Schema namespace or a namespace that is imported as conformant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M127"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M127"/>
   <xsl:template match="@*|node()" priority="-2" mode="M127">
      <xsl:apply-templates select="*" mode="M127"/>
   </xsl:template>

   <!--PATTERN rule_11-3Name of simple type ends in "SimpleType"-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Name of simple type ends in "SimpleType"</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:simpleType[@name]" priority="1000" mode="M128">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:simpleType[@name]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ends-with(@name, 'SimpleType')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ends-with(@name, 'SimpleType')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-3: A simple type definition schema component MUST have a name that ends in "SimpleType".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M128"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M128"/>
   <xsl:template match="@*|node()" priority="-2" mode="M128">
      <xsl:apply-templates select="*" mode="M128"/>
   </xsl:template>

   <!--PATTERN rule_11-5List item type defined by conformant schemas-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">List item type defined by conformant schemas</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:list[exists(@itemType)]" priority="1000" mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:list[exists(@itemType)]"/>
      <xsl:variable name="namespace"
                    select="namespace-uri-from-QName(resolve-QName(@itemType, .))"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$namespace = (nf:get-target-namespace(.), xs:anyURI('http://www.w3.org/2001/XMLSchema'))                       or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace)                                     and $namespace = xs:anyURI(@namespace)                                     and empty(@appinfo:externalImportIndicator)])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$namespace = (nf:get-target-namespace(.), xs:anyURI('http://www.w3.org/2001/XMLSchema')) or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace) and $namespace = xs:anyURI(@namespace) and empty(@appinfo:externalImportIndicator)])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-5: The item type of a list simple type definition MUST have a target namespace equal to the target namespace of the XML Schema document within which it is defined, or a namespace that is imported as conformant by the schema document within which it is defined.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M129"/>
   <xsl:template match="@*|node()" priority="-2" mode="M129">
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>

   <!--PATTERN rule_11-6Union member types defined by conformant schemas-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Union member types defined by conformant schemas</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:union[exists(@memberTypes)]" priority="1000" mode="M130">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:union[exists(@memberTypes)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $qname in tokenize(normalize-space(@memberTypes), ' '),                             $namespace in namespace-uri-from-QName(resolve-QName($qname, .))                       satisfies ($namespace = nf:get-target-namespace(.)                                  or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace)                                            and $namespace = xs:anyURI(@namespace)                                            and empty(@appinfo:externalImportIndicator)]))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $qname in tokenize(normalize-space(@memberTypes), ' '), $namespace in namespace-uri-from-QName(resolve-QName($qname, .)) satisfies ($namespace = nf:get-target-namespace(.) or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace) and $namespace = xs:anyURI(@namespace) and empty(@appinfo:externalImportIndicator)]))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-6: Every member type of a union simple type definition MUST have a target namespace that is equal to either the target namespace of the XML Schema document within which it is defined or a namespace that is imported as conformant by the schema document within which it is defined.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M130"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M130"/>
   <xsl:template match="@*|node()" priority="-2" mode="M130">
      <xsl:apply-templates select="*" mode="M130"/>
   </xsl:template>

   <!--PATTERN rule_11-7Name of a code simple type ends in "CodeSimpleType"-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Name of a code simple type ends in "CodeSimpleType"</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:simpleType[exists(@name)       and (xs:restriction/xs:enumeration            or xs:restriction[ends-with(local-name-from-QName(resolve-QName(@base, .)), 'CodeSimpleType')])]"
                 priority="1000"
                 mode="M131">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:simpleType[exists(@name)       and (xs:restriction/xs:enumeration            or xs:restriction[ends-with(local-name-from-QName(resolve-QName(@base, .)), 'CodeSimpleType')])]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(ends-with(@name, 'CodeSimpleType'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(ends-with(@name, 'CodeSimpleType'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-7: A simple type definition schema component that has an enumeration facet or that is derived from a code simple type SHOULD have a name that ends in "CodeSimpleType".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M131"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M131"/>
   <xsl:template match="@*|node()" priority="-2" mode="M131">
      <xsl:apply-templates select="*" mode="M131"/>
   </xsl:template>

   <!--PATTERN rule_11-9Attribute of code simple type has code representation term-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Attribute of code simple type has code representation term</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@name) and exists(@type) and ends-with(@type, 'CodeSimpleType')]"
                 priority="1000"
                 mode="M132">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@name) and exists(@type) and ends-with(@type, 'CodeSimpleType')]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(ends-with(@name, 'Code'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(ends-with(@name, 'Code'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-9: An attribute with a type that is a code simple type SHOULD have a name with representation term "Code"</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M132"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M132"/>
   <xsl:template match="@*|node()" priority="-2" mode="M132">
      <xsl:apply-templates select="*" mode="M132"/>
   </xsl:template>

   <!--PATTERN rule_11-10Complex type with simple content has structures:SimpleObjectAttributeGroup-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Complex type with simple content has structures:SimpleObjectAttributeGroup</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:simpleContent/xs:extension[       some $base-qname in resolve-QName(@base, .) satisfies         namespace-uri-from-QName($base-qname) = xs:anyURI('http://www.w3.org/2001/XMLSchema')         or ends-with(local-name-from-QName($base-qname), 'SimpleType')]"
                 priority="1000"
                 mode="M133">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:simpleContent/xs:extension[       some $base-qname in resolve-QName(@base, .) satisfies         namespace-uri-from-QName($base-qname) = xs:anyURI('http://www.w3.org/2001/XMLSchema')         or ends-with(local-name-from-QName($base-qname), 'SimpleType')]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:attributeGroup[                         resolve-QName(@ref, .) = xs:QName('structures:SimpleObjectAttributeGroup')]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="xs:attributeGroup[ resolve-QName(@ref, .) = xs:QName('structures:SimpleObjectAttributeGroup')]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-10: A complex type definition with simple content schema component with a derivation method of extension that has a base type definition that is a simple type MUST incorporate the attribute group {http://release.niem.gov/niem/structures/4.0/}SimpleObjectAttributeGroup.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M133"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M133"/>
   <xsl:template match="@*|node()" priority="-2" mode="M133">
      <xsl:apply-templates select="*" mode="M133"/>
   </xsl:template>

   <!--PATTERN rule_11-11Element type does not have a simple type name-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element type does not have a simple type name</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@type)]" priority="1000" mode="M134">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@type)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(ends-with(@type, 'SimpleType'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(ends-with(@type, 'SimpleType'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-11: The {type definition} of an element declaration MUST NOT have a {name} that ends in 'SimpleType'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M134"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M134"/>
   <xsl:template match="@*|node()" priority="-2" mode="M134">
      <xsl:apply-templates select="*" mode="M134"/>
   </xsl:template>

   <!--PATTERN rule_11-12Element type is from conformant namespace-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element type is from conformant namespace</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@type)]" priority="1000" mode="M135">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@type)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="for $type-qname in resolve-QName(@type, .),                           $type-namespace in namespace-uri-from-QName($type-qname) return                         $type-namespace = nf:get-target-namespace(.)                         or exists(nf:get-document-element(.)/xs:import[                                     xs:anyURI(@namespace) = $type-namespace                                     and empty(@appinfo:externalImportIndicator)])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="for $type-qname in resolve-QName(@type, .), $type-namespace in namespace-uri-from-QName($type-qname) return $type-namespace = nf:get-target-namespace(.) or exists(nf:get-document-element(.)/xs:import[ xs:anyURI(@namespace) = $type-namespace and empty(@appinfo:externalImportIndicator)])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-12: The {type definition} of an element declaration MUST have a {target namespace} that is the target namespace, or one that is imported as conformant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M135"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M135"/>
   <xsl:template match="@*|node()" priority="-2" mode="M135">
      <xsl:apply-templates select="*" mode="M135"/>
   </xsl:template>

   <!--PATTERN rule_11-13Name of element that ends in "Abstract" is abstract-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Name of element that ends in "Abstract" is abstract</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[@name]" priority="1000" mode="M136">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:element[@name]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(exists(@abstract[xs:boolean(.) = true()])                   eq (ends-with(@name, 'Abstract')                       or ends-with(@name, 'AugmentationPoint')                       or ends-with(@name, 'Representation')))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(exists(@abstract[xs:boolean(.) = true()]) eq (ends-with(@name, 'Abstract') or ends-with(@name, 'AugmentationPoint') or ends-with(@name, 'Representation')))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-13: An element declaration SHOULD have a name that ends in 'Abstract', 'AugmentationPoint', or 'Representation' if and only if it has the {abstract} property with a value of "true".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M136"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M136"/>
   <xsl:template match="@*|node()" priority="-2" mode="M136">
      <xsl:apply-templates select="*" mode="M136"/>
   </xsl:template>

   <!--PATTERN rule_11-14Name of element declaration with simple content has representation term-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Name of element declaration with simple content has representation term</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[@name and @type                                 and (some $type-qname in resolve-QName(@type, .) satisfies (                                        nf:get-target-namespace(.) = namespace-uri-from-QName($type-qname)                                        and nf:resolve-type(., $type-qname)/xs:simpleContent))]"
                 priority="1000"
                 mode="M137">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[@name and @type                                 and (some $type-qname in resolve-QName(@type, .) satisfies (                                        nf:get-target-namespace(.) = namespace-uri-from-QName($type-qname)                                        and nf:resolve-type(., $type-qname)/xs:simpleContent))]"/>

		    <!--REPORT warning-->
      <xsl:if test="every $representation-term               in ('Amount', 'BinaryObject', 'Graphic', 'Picture', 'Sound', 'Video', 'Code', 'DateTime', 'Date', 'Time', 'Duration', 'ID', 'URI', 'Indicator', 'Measure', 'Numeric', 'Value', 'Rate', 'Percent', 'Quantity', 'Text', 'Name', 'List')               satisfies not(ends-with(@name, $representation-term))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="every $representation-term in ('Amount', 'BinaryObject', 'Graphic', 'Picture', 'Sound', 'Video', 'Code', 'DateTime', 'Date', 'Time', 'Duration', 'ID', 'URI', 'Indicator', 'Measure', 'Numeric', 'Value', 'Rate', 'Percent', 'Quantity', 'Text', 'Name', 'List') satisfies not(ends-with(@name, $representation-term))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-14: The name of an element declaration that is of simple content SHOULD use a representation term.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M137"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M137"/>
   <xsl:template match="@*|node()" priority="-2" mode="M137">
      <xsl:apply-templates select="*" mode="M137"/>
   </xsl:template>

   <!--PATTERN rule_11-16Element substitution group defined by conformant schema-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element substitution group defined by conformant schema</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(@substitutionGroup)]"
                 priority="1000"
                 mode="M138">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(@substitutionGroup)]"/>
      <xsl:variable name="namespace"
                    select="namespace-uri-from-QName(resolve-QName(@substitutionGroup, .))"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$namespace = nf:get-target-namespace(.)                       or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace)                                     and $namespace = xs:anyURI(@namespace)                                     and empty(@appinfo:externalImportIndicator)])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$namespace = nf:get-target-namespace(.) or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace) and $namespace = xs:anyURI(@namespace) and empty(@appinfo:externalImportIndicator)])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-16: An element substitution group MUST have either the target namespace or a namespace that is imported as conformant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M138"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M138"/>
   <xsl:template match="@*|node()" priority="-2" mode="M138">
      <xsl:apply-templates select="*" mode="M138"/>
   </xsl:template>

   <!--PATTERN rule_11-17Attribute type defined by conformant schema-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Attribute type defined by conformant schema</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@type)]" priority="1000" mode="M139">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@type)]"/>
      <xsl:variable name="namespace"
                    select="namespace-uri-from-QName(resolve-QName(@type, .))"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$namespace = (nf:get-target-namespace(.), xs:anyURI('http://www.w3.org/2001/XMLSchema'))                       or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace)                                     and $namespace = xs:anyURI(@namespace)                                     and empty(@appinfo:externalImportIndicator)])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$namespace = (nf:get-target-namespace(.), xs:anyURI('http://www.w3.org/2001/XMLSchema')) or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace) and $namespace = xs:anyURI(@namespace) and empty(@appinfo:externalImportIndicator)])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-17: The type of an attribute declaration MUST have the target namespace or the XML Schema namespace or a namespace that is imported as conformant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M139"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M139"/>
   <xsl:template match="@*|node()" priority="-2" mode="M139">
      <xsl:apply-templates select="*" mode="M139"/>
   </xsl:template>

   <!--PATTERN rule_11-18Attribute name uses representation term-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Attribute name uses representation term</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[exists(@name)]" priority="1000" mode="M140">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attribute[exists(@name)]"/>

		    <!--REPORT warning-->
      <xsl:if test="every $representation-term               in ('Amount', 'BinaryObject', 'Graphic', 'Picture', 'Sound', 'Video', 'Code', 'DateTime', 'Date', 'Time', 'Duration', 'ID', 'URI', 'Indicator', 'Measure', 'Numeric', 'Value', 'Rate', 'Percent', 'Quantity', 'Text', 'Name', 'List')               satisfies not(ends-with(@name, $representation-term))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="every $representation-term in ('Amount', 'BinaryObject', 'Graphic', 'Picture', 'Sound', 'Video', 'Code', 'DateTime', 'Date', 'Time', 'Duration', 'ID', 'URI', 'Indicator', 'Measure', 'Numeric', 'Value', 'Rate', 'Percent', 'Quantity', 'Text', 'Name', 'List') satisfies not(ends-with(@name, $representation-term))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-18: An attribute name SHOULD end with a representation term.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M140"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M140"/>
   <xsl:template match="@*|node()" priority="-2" mode="M140">
      <xsl:apply-templates select="*" mode="M140"/>
   </xsl:template>

   <!--PATTERN rule_11-20Element reference defined by conformant schema-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Element reference defined by conformant schema</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[exists(ancestor::xs:complexType[empty(@appinfo:externalAdapterTypeIndicator)]) and @ref]"
                 priority="1000"
                 mode="M141">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[exists(ancestor::xs:complexType[empty(@appinfo:externalAdapterTypeIndicator)]) and @ref]"/>
      <xsl:variable name="namespace"
                    select="namespace-uri-from-QName(resolve-QName(@ref, .))"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$namespace = nf:get-target-namespace(.)                       or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace)                                     and $namespace = xs:anyURI(@namespace)                                     and empty(@appinfo:externalImportIndicator)])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$namespace = nf:get-target-namespace(.) or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace) and $namespace = xs:anyURI(@namespace) and empty(@appinfo:externalImportIndicator)])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-20: An element reference MUST be to a component that has a namespace that is either the target namespace of the schema document in which it appears, or which is imported as conformant by that schema document.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M141"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M141"/>
   <xsl:template match="@*|node()" priority="-2" mode="M141">
      <xsl:apply-templates select="*" mode="M141"/>
   </xsl:template>

   <!--PATTERN rule_11-21Referenced attribute defined by conformant schemas-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Referenced attribute defined by conformant schemas</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attribute[@ref]" priority="1000" mode="M142">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:attribute[@ref]"/>
      <xsl:variable name="namespace"
                    select="namespace-uri-from-QName(resolve-QName(@ref, .))"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $namespace in namespace-uri-from-QName(resolve-QName(@ref, .)) satisfies (                         $namespace = nf:get-target-namespace(.)                         or ancestor::xs:schema[1]/xs:import[                              @namespace                              and $namespace = xs:anyURI(@namespace)                              and empty(@appinfo:externalImportIndicator)])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $namespace in namespace-uri-from-QName(resolve-QName(@ref, .)) satisfies ( $namespace = nf:get-target-namespace(.) or ancestor::xs:schema[1]/xs:import[ @namespace and $namespace = xs:anyURI(@namespace) and empty(@appinfo:externalImportIndicator)])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-21: An attribute {}ref MUST have the target namespace or a namespace that is imported as conformant.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M142"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M142"/>
   <xsl:template match="@*|node()" priority="-2" mode="M142">
      <xsl:apply-templates select="*" mode="M142"/>
   </xsl:template>

   <!--PATTERN rule_11-22Schema uses only known attribute groups-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schema uses only known attribute groups</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:attributeGroup[@ref]" priority="1000" mode="M143">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:attributeGroup[@ref]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $ref in resolve-QName(@ref, .) satisfies (                         $ref = xs:QName('structures:SimpleObjectAttributeGroup')                         or namespace-uri-from-QName($ref) = (xs:anyURI('urn:us:gov:ic:ism'),                                                              xs:anyURI('urn:us:gov:ic:ntk')))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $ref in resolve-QName(@ref, .) satisfies ( $ref = xs:QName('structures:SimpleObjectAttributeGroup') or namespace-uri-from-QName($ref) = (xs:anyURI('urn:us:gov:ic:ism'), xs:anyURI('urn:us:gov:ic:ntk')))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-22: An attribute group reference MUST be structures:SimpleObjectAttributeGroup or have the IC-ISM or IC-NTK namespace.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M143"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M143"/>
   <xsl:template match="@*|node()" priority="-2" mode="M143">
      <xsl:apply-templates select="*" mode="M143"/>
   </xsl:template>

   <!--PATTERN rule_11-29Standard opening phrase for augmentation point element data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for augmentation point element data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[ends-with(@name, 'AugmentationPoint')]/xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M144">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[ends-with(@name, 'AugmentationPoint')]/xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(starts-with(lower-case(normalize-space(.)), 'an augmentation point '))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(starts-with(lower-case(normalize-space(.)), 'an augmentation point '))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-29: The data definition for an augmentation point element SHOULD begin with standard opening phrase "An augmentation point...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M144"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M144"/>
   <xsl:template match="@*|node()" priority="-2" mode="M144">
      <xsl:apply-templates select="*" mode="M144"/>
   </xsl:template>

   <!--PATTERN rule_11-30Standard opening phrase for augmentation element data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for augmentation element data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[ends-with(@name, 'Augmentation')]/xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M145">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[ends-with(@name, 'Augmentation')]/xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="every $phrase               in ('supplements ', 'additional information about ')               satisfies not(starts-with(lower-case(normalize-space(.)), $phrase))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="every $phrase in ('supplements ', 'additional information about ') satisfies not(starts-with(lower-case(normalize-space(.)), $phrase))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-30: The data definition for an augmentation element SHOULD begin with the standard opening phrase "Supplements..." or "Additional information about...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M145"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M145"/>
   <xsl:template match="@*|node()" priority="-2" mode="M145">
      <xsl:apply-templates select="*" mode="M145"/>
   </xsl:template>

   <!--PATTERN rule_11-31Standard opening phrase for metadata element data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for metadata element data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[ends-with(@name, 'Metadata')                                 and not(xs:boolean(@abstract) eq true())]/xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M146">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[ends-with(@name, 'Metadata')                                 and not(xs:boolean(@abstract) eq true())]/xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)), '(metadata about|information that further qualifies)'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '(metadata about|information that further qualifies)'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-31: The data definition for a metadata element SHOULD begin with the standard opening phrase "Metadata about..." or "Information that further qualifies...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M146"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M146"/>
   <xsl:template match="@*|node()" priority="-2" mode="M146">
      <xsl:apply-templates select="*" mode="M146"/>
   </xsl:template>

   <!--PATTERN rule_11-32Standard opening phrase for association element data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for association element data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[ends-with(@name, 'Association')                                 and not(xs:boolean(@abstract) eq true())]/xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M147">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[ends-with(@name, 'Association')                                 and not(xs:boolean(@abstract) eq true())]/xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? (relationship|association)'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? (relationship|association)'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-32: The data definition for an association element that is not abstract SHOULD begin with the standard opening phrase "An (optional adjectives) (relationship|association)...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M147"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M147"/>
   <xsl:template match="@*|node()" priority="-2" mode="M147">
      <xsl:apply-templates select="*" mode="M147"/>
   </xsl:template>

   <!--PATTERN rule_11-33Standard opening phrase for abstract element data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for abstract element data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[xs:boolean(@abstract) = true()                        and not(ends-with(@name, 'AugmentationPoint'))]/xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M148">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[xs:boolean(@abstract) = true()                        and not(ends-with(@name, 'AugmentationPoint'))]/xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(starts-with(lower-case(normalize-space(.)), 'a data concept'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(starts-with(lower-case(normalize-space(.)), 'a data concept'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-33: The data definition for an abstract element SHOULD begin with the standard opening phrase "A data concept...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M148"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M148"/>
   <xsl:template match="@*|node()" priority="-2" mode="M148">
      <xsl:apply-templates select="*" mode="M148"/>
   </xsl:template>

   <!--PATTERN rule_11-34Standard opening phrase for date element or attribute data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for date element or attribute data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[(self::xs:element or self::xs:attribute)                        and ends-with(@name, 'Date') and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M149">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[(self::xs:element or self::xs:attribute)                        and ends-with(@name, 'Date') and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? (date|month|year)'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? (date|month|year)'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-34: The data definition for an element or attribute with a date representation term SHOULD begin with the standard opening phrase "(A|An) (optional adjectives) (date|month|year)...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M149"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M149"/>
   <xsl:template match="@*|node()" priority="-2" mode="M149">
      <xsl:apply-templates select="*" mode="M149"/>
   </xsl:template>

   <!--PATTERN rule_11-35Standard opening phrase for quantity element or attribute data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for quantity element or attribute data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[(self::xs:element or self::xs:attribute)                        and ends-with(@name, 'Quantity') and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M150">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[(self::xs:element or self::xs:attribute)                        and ends-with(@name, 'Quantity') and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? (count|number)'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? (count|number)'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-35: The data definition for an element or attribute with a quantity representation term SHOULD begin with the standard opening phrase "An (optional adjectives) (count|number)...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M150"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M150"/>
   <xsl:template match="@*|node()" priority="-2" mode="M150">
      <xsl:apply-templates select="*" mode="M150"/>
   </xsl:template>

   <!--PATTERN rule_11-36Standard opening phrase for picture element or attribute data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for picture element or attribute data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[(self::xs:element or self::xs:attribute)                        and ends-with(@name, 'Picture') and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M151">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[(self::xs:element or self::xs:attribute)                        and ends-with(@name, 'Picture') and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? (image|picture|photograph)'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? (image|picture|photograph)'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-36: The data definition for an element or attribute with a picture representation term SHOULD begin with the standard opening phrase "An (optional adjectives) (image|picture|photograph)".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M151"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M151"/>
   <xsl:template match="@*|node()" priority="-2" mode="M151">
      <xsl:apply-templates select="*" mode="M151"/>
   </xsl:template>

   <!--PATTERN rule_11-37Standard opening phrase for indicator element or attribute data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for indicator element or attribute data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[(self::xs:element or self::xs:attribute)                        and ends-with(@name, 'Indicator') and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M152">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[(self::xs:element or self::xs:attribute)                        and ends-with(@name, 'Indicator') and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)), '^true if .*; false (otherwise|if)'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^true if .*; false (otherwise|if)'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-37: The data definition for an element or attribute with an indicator representation term SHOULD begin with the standard opening phrase "True if ...; false (otherwise|if)...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M152"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M152"/>
   <xsl:template match="@*|node()" priority="-2" mode="M152">
      <xsl:apply-templates select="*" mode="M152"/>
   </xsl:template>

   <!--PATTERN rule_11-38Standard opening phrase for identification element or attribute data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for identification element or attribute data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[(self::xs:element or self::xs:attribute)                        and ends-with(@name, 'Identification') and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M153">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[(self::xs:element or self::xs:attribute)                        and ends-with(@name, 'Identification') and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? identification'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? identification'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-38: The data definition for an element or attribute with an identification representation term SHOULD begin with the standard opening phrase "(A|An) (optional adjectives) identification...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M153"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M153"/>
   <xsl:template match="@*|node()" priority="-2" mode="M153">
      <xsl:apply-templates select="*" mode="M153"/>
   </xsl:template>

   <!--PATTERN rule_11-39Standard opening phrase for name element or attribute data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for name element or attribute data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[(self::xs:element or self::xs:attribute)                        and ends-with(@name, 'Name') and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M154">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[(self::xs:element or self::xs:attribute)                        and ends-with(@name, 'Name') and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)), '^(a|an)( .*)? name'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^(a|an)( .*)? name'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-39: The data definition for an element or attribute with a name representation term SHOULD begin with the standard opening phrase "(A|An) (optional adjectives) name...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M154"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M154"/>
   <xsl:template match="@*|node()" priority="-2" mode="M154">
      <xsl:apply-templates select="*" mode="M154"/>
   </xsl:template>

   <!--PATTERN rule_11-40Standard opening phrase for element or attribute data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for element or attribute data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[(self::xs:element or self::xs:attribute)                        and @name                        and not(ends-with(@name, 'Indicator'))                        and not(ends-with(@name, 'Augmentation'))                        and not(ends-with(@name, 'Metadata'))                        and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M155">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[(self::xs:element or self::xs:attribute)                        and @name                        and not(ends-with(@name, 'Indicator'))                        and not(ends-with(@name, 'Augmentation'))                        and not(ends-with(@name, 'Metadata'))                        and not(xs:boolean(@abstract) eq true())]                       /xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)), '^an? '))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^an? '))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-40: The data definition for an element or attribute declaration SHOULD begin with the standard opening phrase "(A|An)".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M155"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M155"/>
   <xsl:template match="@*|node()" priority="-2" mode="M155">
      <xsl:apply-templates select="*" mode="M155"/>
   </xsl:template>

   <!--PATTERN rule_11-41Standard opening phrase for association type data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for association type data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType[ends-with(@name, 'AssociationType')]/xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M156">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[ends-with(@name, 'AssociationType')]/xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)), '^a data type for (a relationship|an association)'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^a data type for (a relationship|an association)'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-41: The data definition for an association type SHOULD begin with the standard opening phrase "A data type for (a relationship|an association)...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M156"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M156"/>
   <xsl:template match="@*|node()" priority="-2" mode="M156">
      <xsl:apply-templates select="*" mode="M156"/>
   </xsl:template>

   <!--PATTERN rule_11-42Standard opening phrase for augmentation type data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for augmentation type data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType[ends-with(@name, 'AugmentationType')]/xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M157">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[ends-with(@name, 'AugmentationType')]/xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)),                           '^a data type (that supplements|for additional information about)'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^a data type (that supplements|for additional information about)'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-42: The data definition for an augmentation type SHOULD begin with the standard opening phrase "A data type (that supplements|for additional information about)...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M157"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M157"/>
   <xsl:template match="@*|node()" priority="-2" mode="M157">
      <xsl:apply-templates select="*" mode="M157"/>
   </xsl:template>

   <!--PATTERN rule_11-43Standard opening phrase for metadata type data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for metadata type data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType[ends-with(@name, 'MetadataType')]/xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M158">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[ends-with(@name, 'MetadataType')]/xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)),                           '^a data type for (metadata about|information that further qualifies)'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^a data type for (metadata about|information that further qualifies)'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-43: The data definition for a metadata type SHOULD begin with the standard opening phrase "A data type for (metadata about|information that further qualifies)...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M158"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M158"/>
   <xsl:template match="@*|node()" priority="-2" mode="M158">
      <xsl:apply-templates select="*" mode="M158"/>
   </xsl:template>

   <!--PATTERN rule_11-44Standard opening phrase for complex type data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for complex type data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType/xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M159">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType/xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)), '^a data type'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^a data type'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-44: The data definition for a complex type SHOULD begin with the standard opening phrase "A data type...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M159"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M159"/>
   <xsl:template match="@*|node()" priority="-2" mode="M159">
      <xsl:apply-templates select="*" mode="M159"/>
   </xsl:template>

   <!--PATTERN rule_11-45Standard opening phrase for simple type data definition-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Standard opening phrase for simple type data definition</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:simpleType/xs:annotation/xs:documentation[1]"
                 priority="1000"
                 mode="M160">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:simpleType/xs:annotation/xs:documentation[1]"/>

		    <!--REPORT warning-->
      <xsl:if test="not(matches(lower-case(normalize-space(.)), '^a data type'))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="not(matches(lower-case(normalize-space(.)), '^a data type'))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-45: The data definition for a simple type SHOULD begin with a standard opening phrase "A data type...".</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M160"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M160"/>
   <xsl:template match="@*|node()" priority="-2" mode="M160">
      <xsl:apply-templates select="*" mode="M160"/>
   </xsl:template>

   <!--PATTERN rule_11-50Structures imported as conformant-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Structures imported as conformant</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:import[exists(@namespace)                                and xs:anyURI(@namespace) = xs:anyURI('http://release.niem.gov/niem/structures/4.0/')]"
                 priority="1000"
                 mode="M161">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:import[exists(@namespace)                                and xs:anyURI(@namespace) = xs:anyURI('http://release.niem.gov/niem/structures/4.0/')]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(@appinfo:externalImportIndicator)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(@appinfo:externalImportIndicator)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-50: An import of the structures namespace MUST NOT be labeled as an external import.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M161"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M161"/>
   <xsl:template match="@*|node()" priority="-2" mode="M161">
      <xsl:apply-templates select="*" mode="M161"/>
   </xsl:template>

   <!--PATTERN rule_11-51XML namespace imported as conformant-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">XML namespace imported as conformant</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:import[exists(@namespace)                                and xs:anyURI(@namespace) = xs:anyURI('http://www.w3.org/XML/1998/namespace')]"
                 priority="1000"
                 mode="M162">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:import[exists(@namespace)                                and xs:anyURI(@namespace) = xs:anyURI('http://www.w3.org/XML/1998/namespace')]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(@appinfo:externalImportIndicator)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(@appinfo:externalImportIndicator)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-51: An import of the XML namespace MUST NOT be labeled as an external import.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M162"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M162"/>
   <xsl:template match="@*|node()" priority="-2" mode="M162">
      <xsl:apply-templates select="*" mode="M162"/>
   </xsl:template>

   <!--PATTERN rule_11-53Consistently marked namespace imports-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Consistently marked namespace imports</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:import" priority="1000" mode="M163">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="xs:import"/>
      <xsl:variable name="namespace" select="@namespace"/>
      <xsl:variable name="is-conformant" select="empty(@appinfo:externalImportIndicator)"/>
      <xsl:variable name="first"
                    select="exactly-one(parent::xs:schema/xs:import[@namespace = $namespace][1])"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". is $first                       or $is-conformant = empty($first/@appinfo:externalImportIndicator)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test=". is $first or $is-conformant = empty($first/@appinfo:externalImportIndicator)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-53: All xs:import elements that have the same namespace MUST have the same conformance marking via appinfo:externalImportIndicator.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M163"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M163"/>
   <xsl:template match="@*|node()" priority="-2" mode="M163">
      <xsl:apply-templates select="*" mode="M163"/>
   </xsl:template>
</xsl:stylesheet>
