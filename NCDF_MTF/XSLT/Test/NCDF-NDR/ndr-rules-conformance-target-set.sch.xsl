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
                              title="Rules XML Schema document sets"
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
            <xsl:attribute name="id">rule_9-32</xsl:attribute>
            <xsl:attribute name="name">Base type of complex type with complex content must have complex content</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-12</xsl:attribute>
            <xsl:attribute name="name">External adapter type not a base type</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-72</xsl:attribute>
            <xsl:attribute name="name">appinfo:appliesToTypes references types</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_10-74</xsl:attribute>
            <xsl:attribute name="name">appinfo:appliesToElements references elements</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-15</xsl:attribute>
            <xsl:attribute name="name">Name of element declaration with simple content has representation term</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-48</xsl:attribute>
            <xsl:attribute name="name">Reference schema document imports reference schema document</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-49</xsl:attribute>
            <xsl:attribute name="name">Extension schema document imports reference or extension schema document</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule_11-52</xsl:attribute>
            <xsl:attribute name="name">Each namespace may have only a single root schema in a schema set</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Rules XML Schema document sets</svrl:text>
   <xsl:include xmlns:sch="http://purl.oclc.org/dsdl/schematron" href="ndr-functions.xsl"/>

   <!--PATTERN rule_9-32Base type of complex type with complex content must have complex content-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Base type of complex type with complex content must have complex content</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:complexType[         nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))         or nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument'))       ]/xs:complexContent"
                 priority="1000"
                 mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:complexType[         nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))         or nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument'))       ]/xs:complexContent"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $derivation in xs:*[self::xs:extension or self::xs:restriction],                            $base-qname in resolve-QName($derivation/@base, $derivation),                            $base-type in nf:resolve-type($derivation, $base-qname) satisfies                          empty($base-type/self::xs:complexType/xs:simpleContent)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $derivation in xs:*[self::xs:extension or self::xs:restriction], $base-qname in resolve-QName($derivation/@base, $derivation), $base-type in nf:resolve-type($derivation, $base-qname) satisfies empty($base-type/self::xs:complexType/xs:simpleContent)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 9-32: The base type of complex type that has complex content MUST have complex content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

   <!--PATTERN rule_10-12External adapter type not a base type-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">External adapter type not a base type</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:*[(self::xs:extension or self::xs:restriction)                           and (nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))                                or nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument')))                           and (some $base-qname in resolve-QName(@base, .),                                     $base-namespace in namespace-uri-from-QName($base-qname) satisfies                                  not($base-namespace = (nf:get-target-namespace(.), xs:anyURI('http://www.w3.org/2001/XMLSchema'))))]"
                 priority="1000"
                 mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:*[(self::xs:extension or self::xs:restriction)                           and (nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))                                or nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument')))                           and (some $base-qname in resolve-QName(@base, .),                                     $base-namespace in namespace-uri-from-QName($base-qname) satisfies                                  not($base-namespace = (nf:get-target-namespace(.), xs:anyURI('http://www.w3.org/2001/XMLSchema'))))]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="nf:resolve-type(., resolve-QName(@base, .))[                         empty(@appinfo:externalAdapterTypeIndicator)]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="nf:resolve-type(., resolve-QName(@base, .))[ empty(@appinfo:externalAdapterTypeIndicator)]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-12: An external adapter type definition MUST NOT be a base type definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>

   <!--PATTERN rule_10-72appinfo:appliesToTypes references types-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">appinfo:appliesToTypes references types</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[exists(@appinfo:appliesToTypes)]"
                 priority="1000"
                 mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[exists(@appinfo:appliesToTypes)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $item in tokenize(normalize-space(@appinfo:appliesToTypes), ' ') satisfies                         exists(nf:resolve-type(., resolve-QName($item, .)))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $item in tokenize(normalize-space(@appinfo:appliesToTypes), ' ') satisfies exists(nf:resolve-type(., resolve-QName($item, .)))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-72: Every item in @appinfo:appliesToTypes MUST resolve to a type.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>

   <!--PATTERN rule_10-74appinfo:appliesToElements references elements-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">appinfo:appliesToElements references elements</svrl:text>

	  <!--RULE -->
   <xsl:template match="*[exists(@appinfo:appliesToElements)]"
                 priority="1000"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[exists(@appinfo:appliesToElements)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $item in tokenize(normalize-space(@appinfo:appliesToElements), ' ') satisfies                         count(nf:resolve-element(., resolve-QName($item, .))) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $item in tokenize(normalize-space(@appinfo:appliesToElements), ' ') satisfies count(nf:resolve-element(., resolve-QName($item, .))) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 10-74: Every item in @appinfo:appliesToElements MUST resolve to an element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

   <!--PATTERN rule_11-15Name of element declaration with simple content has representation term-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Name of element declaration with simple content has representation term</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:element[@name and @type        and (nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))             or nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument')))        and (some $type-qname in resolve-QName(@type, .) satisfies (               nf:get-target-namespace(.) != namespace-uri-from-QName($type-qname)               and nf:resolve-type(., $type-qname)/xs:simpleContent))]"
                 priority="1000"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:element[@name and @type        and (nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))             or nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument')))        and (some $type-qname in resolve-QName(@type, .) satisfies (               nf:get-target-namespace(.) != namespace-uri-from-QName($type-qname)               and nf:resolve-type(., $type-qname)/xs:simpleContent))]"/>

		    <!--REPORT warning-->
      <xsl:if test="every $representation-term               in ('Amount', 'BinaryObject', 'Graphic', 'Picture', 'Sound', 'Video', 'Code', 'DateTime', 'Date', 'Time', 'Duration', 'ID', 'URI', 'Indicator', 'Measure', 'Numeric', 'Value', 'Rate', 'Percent', 'Quantity', 'Text', 'Name', 'List')               satisfies not(ends-with(@name, $representation-term))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="every $representation-term in ('Amount', 'BinaryObject', 'Graphic', 'Picture', 'Sound', 'Video', 'Code', 'DateTime', 'Date', 'Time', 'Duration', 'ID', 'URI', 'Indicator', 'Measure', 'Numeric', 'Value', 'Rate', 'Percent', 'Quantity', 'Text', 'Name', 'List') satisfies not(ends-with(@name, $representation-term))">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Rule 11-15: the name of an element declaration that is of simple content SHOULD use a representation term.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN rule_11-48Reference schema document imports reference schema document-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Reference schema document imports reference schema document</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:import[                          nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))                          and exists(@namespace)                          and empty(@appinfo:externalImportIndicator)                          and not(xs:anyURI(@namespace) = (xs:anyURI('http://release.niem.gov/niem/structures/4.0/'),                                                           xs:anyURI('http://www.w3.org/XML/1998/namespace')))]"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:import[                          nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))                          and exists(@namespace)                          and empty(@appinfo:externalImportIndicator)                          and not(xs:anyURI(@namespace) = (xs:anyURI('http://release.niem.gov/niem/structures/4.0/'),                                                           xs:anyURI('http://www.w3.org/XML/1998/namespace')))]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $schema in nf:resolve-namespace(., @namespace) satisfies                         nf:has-effective-conformance-target-identifier($schema, xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $schema in nf:resolve-namespace(., @namespace) satisfies nf:has-effective-conformance-target-identifier($schema, xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-48: A namespace imported as conformant from a reference schema document MUST identify a namespace defined by a reference schema document.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

   <!--PATTERN rule_11-49Extension schema document imports reference or extension schema document-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Extension schema document imports reference or extension schema document</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:import[                          nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument'))                          and exists(@namespace)                          and empty(@appinfo:externalImportIndicator)                          and not(xs:anyURI(@namespace) = (xs:anyURI('http://release.niem.gov/niem/structures/4.0/'),                                                           xs:anyURI('http://www.w3.org/XML/1998/namespace')))]"
                 priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:import[                          nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument'))                          and exists(@namespace)                          and empty(@appinfo:externalImportIndicator)                          and not(xs:anyURI(@namespace) = (xs:anyURI('http://release.niem.gov/niem/structures/4.0/'),                                                           xs:anyURI('http://www.w3.org/XML/1998/namespace')))]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="some $schema in nf:resolve-namespace(., @namespace) satisfies (                         nf:has-effective-conformance-target-identifier($schema, xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))                         or nf:has-effective-conformance-target-identifier($schema, xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument')))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="some $schema in nf:resolve-namespace(., @namespace) satisfies ( nf:has-effective-conformance-target-identifier($schema, xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument')) or nf:has-effective-conformance-target-identifier($schema, xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument')))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-49: A namespace imported as conformant from an extension schema document MUST identify a namespace defined by a reference schema document or an extension schema document.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

   <!--PATTERN rule_11-52Each namespace may have only a single root schema in a schema set-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Each namespace may have only a single root schema in a schema set</svrl:text>

	  <!--RULE -->
   <xsl:template match="xs:schema[exists(@targetNamespace)                                and (some $element                                    in nf:resolve-namespace(., xs:anyURI(@targetNamespace))                                    satisfies $element is .)]"
                 priority="1000"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="xs:schema[exists(@targetNamespace)                                and (some $element                                    in nf:resolve-namespace(., xs:anyURI(@targetNamespace))                                    satisfies $element is .)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(nf:resolve-namespace(., xs:anyURI(@targetNamespace))) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(nf:resolve-namespace(., xs:anyURI(@targetNamespace))) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Rule 11-52: A namespace may appear as a root schema in a schema set only once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
</xsl:stylesheet>
