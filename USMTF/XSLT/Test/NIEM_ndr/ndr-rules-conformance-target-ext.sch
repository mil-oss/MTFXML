<?xml version="1.0" encoding="US-ASCII" standalone="yes"?><sch:schema xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"><sch:title>Rules for extension XML Schema documents</sch:title><xsl:include href="ndr-functions.xsl"/>
<sch:ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
<sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
<sch:ns prefix="nf" uri="http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#NDRFunctions"/>
<sch:ns prefix="ct" uri="http://release.niem.gov/niem/conformanceTargets/3.0/"/>
<sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
<sch:ns prefix="appinfo" uri="http://release.niem.gov/niem/appinfo/3.0/"/>
<sch:ns prefix="structures" uri="http://release.niem.gov/niem/structures/3.0/"/>
<sch:ns prefix="term" uri="http://release.niem.gov/niem/localTerminology/3.0/"/>
      
<sch:pattern id="rule_4-3"><sch:title>Schema is CTAS-conformant</sch:title>
  <sch:rule context="*[. is nf:get-document-element(.)]">
    <sch:report test="true()">Rule 4-3: The document MUST be a conformant document as defined by the NIEM Conformance Targets Attribute Specification.</sch:report>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_4-4"><sch:title>Document element has attribute ct:conformanceTargets</sch:title>
  <sch:rule context="*[. is nf:get-document-element(.)                        or exists(@ct:conformanceTargets)]">
    <sch:assert test="(. is nf:get-document-element(.)) = exists(@ct:conformanceTargets)">Rule 4-4: The [document element] of the XML document, and only the [document element], MUST own an attribute {http://release.niem.gov/niem/conformanceTargets/3.0/}conformanceTargets.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_4-6"><sch:title>Schema claims extension conformance target</sch:title>
  <sch:rule context="*[. is nf:get-document-element(.)]">
    <sch:assert test="nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#ExtensionSchemaDocument'))">Rule 4-6: The document MUST have an effective conformance target identifier of http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#ExtensionSchemaDocument.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_7-1"><sch:title>Document is an XML document</sch:title>
  <sch:rule context="*[. is nf:get-document-element(.)]">
    <sch:report test="true()">Rule 7-1: The document MUST be an XML document.</sch:report>
  </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_7-2"><sch:title>Document uses XML namespaces properly</sch:title>
  <sch:rule context="*[. is nf:get-document-element(.)]">
    <sch:report test="true()">Rule 7-2: The document MUST be namespace-well-formed and namespace-valid.</sch:report>
  </sch:rule>
</sch:pattern>
        
<sch:pattern id="rule_7-3"><sch:title>Document is a schema document</sch:title>
  <sch:rule context="*[. is nf:get-document-element(.)]">
    <sch:report test="true()">Rule 7-3: The document MUST be a schema document.</sch:report>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_7-4"><sch:title>Document element is xs:schema</sch:title>
  <sch:rule context="*[. is nf:get-document-element(.)]">
    <sch:assert test="self::xs:schema">Rule 7-4: The [document element] of the XML document MUST have the name xs:schema.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-1"><sch:title>No base type in the XML namespace</sch:title>
  <sch:rule context="xs:*[exists(@base)]">
    <sch:assert test="namespace-uri-from-QName(resolve-QName(@base, .)) != xs:anyURI('http://www.w3.org/XML/1998/namespace')">Rule 9-1: A schema component must not have a base type definition with a {target namespace} that is the XML namespace.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-2"><sch:title>No base type of xs:ID</sch:title>
  <sch:rule context="xs:*[exists(@base)]">
    <sch:assert test="resolve-QName(@base, .) != xs:QName('xs:ID')">Rule 9-2: A schema component MUST NOT have an attribute {}base with a value of xs:ID.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-3"><sch:title>No base type of xs:IDREF</sch:title>
  <sch:rule context="xs:*[exists(@base)]">
    <sch:assert test="resolve-QName(@base, .) != xs:QName('xs:IDREF')">Rule 9-3: A schema component MUST NOT have an attribute {}base with a value of xs:IDREF.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-4"><sch:title>No base type of xs:IDREFS</sch:title>
  <sch:rule context="xs:*[exists(@base)]">
    <sch:assert test="resolve-QName(@base, .) != xs:QName('xs:IDREFS')">Rule 9-4: A schema component MUST NOT have an attribute {}base with a value of xs:IDREFS.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-5"><sch:title>No base type of xs:anyType</sch:title>
  <sch:rule context="xs:*[exists(@base)]">
    <sch:assert test="resolve-QName(@base, .) != xs:QName('xs:anyType')">Rule 9-5: A schema component MUST NOT have an attribute {}base with a value of xs:anyType.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-6"><sch:title>No base type of xs:anySimpleType</sch:title>
  <sch:rule context="xs:*[exists(@base)]">
    <sch:assert test="resolve-QName(@base, .) != xs:QName('xs:anySimpleType')">Rule 9-6: A schema component MUST NOT have an attribute {}base with a value of xs:anySimpleType.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-7"><sch:title>No base type of xs:NOTATION</sch:title>
  <sch:rule context="xs:*[exists(@base)]">
    <sch:assert test="resolve-QName(@base, .) != xs:QName('xs:NOTATION')">Rule 9-7: A schema component MUST NOT have an attribute {}base with a value of xs:NOTATION.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-8"><sch:title>No base type of xs:ENTITY</sch:title>
  <sch:rule context="xs:*[exists(@base)]">
    <sch:assert test="resolve-QName(@base, .) != xs:QName('xs:ENTITY')">Rule 9-8: A schema component MUST NOT have an attribute {}base with a value of xs:ENTITY.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-9"><sch:title>No base type of xs:ENTITIES</sch:title>
  <sch:rule context="xs:*[exists(@base)]">
    <sch:assert test="resolve-QName(@base, .) != xs:QName('xs:ENTITIES')">Rule 9-9: A schema component MUST NOT have an attribute {}base with a value of xs:ENTITIES.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-10"><sch:title>Simple type definition is top-level</sch:title>
  <sch:rule context="xs:simpleType">
    <sch:assert test="exists(parent::xs:schema)">Rule 9-10: A simple type definition MUST be top-level.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-12"><sch:title>Simple type has data definition</sch:title>
  <sch:rule context="xs:simpleType">
    <sch:assert test="some $definition in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0">Rule 9-12: A simple type MUST have a data definition.</sch:assert>
  </sch:rule>
</sch:pattern>
    
<sch:pattern id="rule_9-13"><sch:title>No list item type of xs:ID</sch:title>
  <sch:rule context="xs:*[exists(@itemType)]">
    <sch:assert test="resolve-QName(@itemType, .) != xs:QName('xs:ID')">Rule 9-13: A schema component MUST NOT have an attribute {}itemType with a value of xs:ID.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-14"><sch:title>No list item type of xs:IDREF</sch:title>
  <sch:rule context="xs:*[exists(@itemType)]">
    <sch:assert test="resolve-QName(@itemType, .) != xs:QName('xs:IDREF')">Rule 9-14: A schema component MUST NOT have an attribute {}itemType with a value of xs:IDREF.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-15"><sch:title>No list item type of xs:anySimpleType</sch:title>
  <sch:rule context="xs:*[exists(@itemType)]">
    <sch:assert test="resolve-QName(@itemType, .) != xs:QName('xs:anySimpleType')">Rule 9-15: A schema component MUST NOT have an attribute {}itemType with a value of xs:anySimpleType.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-16"><sch:title>No list item type of xs:ENTITY</sch:title>
  <sch:rule context="xs:*[exists(@itemType)]">
    <sch:assert test="resolve-QName(@itemType, .) != xs:QName('xs:ENTITY')">Rule 9-16: A schema component MUST NOT have an attribute {}itemType with a value of xs:ENTITY.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-17"><sch:title>No union member types of xs:ID</sch:title>
  <sch:rule context="xs:*[exists(@memberTypes)]">
    <sch:assert test="every $type-qname                       in tokenize(normalize-space(@memberTypes), ' ')                       satisfies resolve-QName($type-qname, .) != xs:QName('xs:ID')">Rule 9-17: A schema component MUST NOT have an attribute {}memberTypes that includes a value of xs:ID.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-18"><sch:title>No union member types of xs:IDREF</sch:title>
  <sch:rule context="xs:*[exists(@memberTypes)]">
    <sch:assert test="every $type-qname                       in tokenize(normalize-space(@memberTypes), ' ')                       satisfies resolve-QName($type-qname, .) != xs:QName('xs:IDREF')">Rule 9-18: A schema component MUST NOT have an attribute {}memberTypes that includes a value of xs:IDREF.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-19"><sch:title>No union member types of xs:IDREFS</sch:title>
  <sch:rule context="xs:*[exists(@memberTypes)]">
    <sch:assert test="every $type-qname                       in tokenize(normalize-space(@memberTypes), ' ')                       satisfies resolve-QName($type-qname, .) != xs:QName('xs:IDREFS')">Rule 9-19: A schema component MUST NOT have an attribute {}memberTypes that includes a value of xs:IDREFS.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-20"><sch:title>No union member types of xs:anySimpleType</sch:title>
  <sch:rule context="xs:*[exists(@memberTypes)]">
    <sch:assert test="every $type-qname                       in tokenize(normalize-space(@memberTypes), ' ')                       satisfies resolve-QName($type-qname, .) != xs:QName('xs:anySimpleType')">Rule 9-20: A schema component MUST NOT have an attribute {}memberTypes that includes a value of xs:anySimpleType.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-21"><sch:title>No union member types of xs:ENTITY</sch:title>
  <sch:rule context="xs:*[exists(@memberTypes)]">
    <sch:assert test="every $type-qname                       in tokenize(normalize-space(@memberTypes), ' ')                       satisfies resolve-QName($type-qname, .) != xs:QName('xs:ENTITY')">Rule 9-21: A schema component MUST NOT have an attribute {}memberTypes that includes a value of xs:ENTITY.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-22"><sch:title>No union member types of xs:ENTITIES</sch:title>
  <sch:rule context="xs:*[exists(@memberTypes)]">
    <sch:assert test="every $type-qname                       in tokenize(normalize-space(@memberTypes), ' ')                       satisfies resolve-QName($type-qname, .) != xs:QName('xs:ENTITIES')">Rule 9-22: A schema component MUST NOT have an attribute {}memberTypes that includes a value of xs:ENTITIES.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-23"><sch:title>Enumeration has data definition</sch:title>
  <sch:rule context="xs:enumeration">
    <sch:assert test="some $definition in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0">Rule 9-23: An enumeration facet MUST have a data definition.</sch:assert>
  </sch:rule>
</sch:pattern>
    
<sch:pattern id="rule_9-24"><sch:title>Complex type definitions is top-level</sch:title>
  <sch:rule context="xs:complexType">
    <sch:assert test="exists(parent::xs:schema)">Rule 9-24: A complex type definition MUST be top-level.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-25"><sch:title>Complex type has data definition</sch:title>
  <sch:rule context="xs:complexType">
    <sch:assert test="some $definition in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0">Rule 9-25: A complex type MUST have a data definition.</sch:assert>
  </sch:rule>
</sch:pattern>
    
<sch:pattern id="rule_9-26"><sch:title>No mixed content on complex type</sch:title>
  <sch:rule context="xs:complexType[exists(@mixed)]">
    <sch:assert test="xs:boolean(@mixed) = false()">Rule 9-26: A complex type definition MUST NOT have mixed content.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-27"><sch:title>No mixed content on complex content</sch:title>
  <sch:rule context="xs:complexContent[exists(@mixed)]">
    <sch:assert test="xs:boolean(@mixed) = false()">Rule 9-27: A complex type definition with complex content MUST NOT have mixed content.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-28"><sch:title>Complex type content is explicitly simple or complex</sch:title>
  <sch:rule context="xs:complexType">
    <sch:assert test="exists(xs:simpleContent) or exists(xs:complexContent)">Rule 9-28: An element xs:complexType MUST have a child element xs:simpleContent or xs:complexContent.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-30"><sch:title>Base type of complex type with complex content must have complex content</sch:title>
  <sch:rule context="xs:complexType/xs:complexContent/xs:*[                        (self::xs:extension or self::xs:restriction)                        and (some $base-qname in resolve-QName(@base, .) satisfies                               namespace-uri-from-QName($base-qname) = nf:get-target-namespace(.))]">
    <sch:assert test="some $base-type in nf:resolve-type(., resolve-QName(@base, .)) satisfies                         empty($base-type/self::xs:complexType/xs:simpleContent)">Rule 9-30: The base type of complex type that has complex content MUST be a complex type with complex content.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-35"><sch:title>Element declaration is top-level</sch:title>
  <sch:rule context="xs:element[exists(@name)]">
    <sch:assert test="exists(parent::xs:schema)">Rule 9-35: An element declaration MUST be top-level.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-36"><sch:title>Element declaration has data definition</sch:title>
  <sch:rule context="xs:element[exists(@name)]">
    <sch:assert test="some $definition in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0">Rule 9-36: An element declaration MUST have a data definition.</sch:assert>
  </sch:rule>
</sch:pattern>
    
<sch:pattern id="rule_9-37"><sch:title>Untyped element is abstract</sch:title>
  <sch:rule context="xs:schema/xs:element[empty(@type)]">
    <sch:assert test="exists(@abstract)                       and xs:boolean(@abstract) = true()">Rule 9-37: A top-level element declaration that does not set the {type definition} property via the attribute "type" MUST have the {abstract} property with a value of "true".</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-38"><sch:title>Element of type xs:anySimpleType is abstract</sch:title>
  <sch:rule context="xs:element[exists(@type)                                 and resolve-QName(@type, .) = xs:QName('xs:anySimpleType')]">
    <sch:assert test="exists(@abstract)                       and xs:boolean(@abstract) = true()">Rule 9-38: An element declaration that has a type xs:anySimpleType MUST have the {abstract} property with a value of "true".</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-39"><sch:title>Element type not in the XML Schema namespace</sch:title>
  <sch:rule context="xs:element[exists(@type)]">
    <sch:assert test="for $type-qname in resolve-QName(@type, .) return                         $type-qname = xs:QName('xs:anySimpleType')                         or namespace-uri-from-QName($type-qname) != xs:anyURI('http://www.w3.org/2001/XMLSchema')">Rule 9-39: An element type that is not xs:anySimpleType MUST NOT have a namespace name <namespace-uri-for-prefix xmlns="https://iead.ittl.gtri.org/wr24/doc/2011-09-30-2258">xs</namespace-uri-for-prefix>.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-40"><sch:title>Element type not in the XML namespace</sch:title>
  <sch:rule context="xs:element[exists(@type)]">
    <sch:assert test="namespace-uri-from-QName(resolve-QName(@type, .)) != 'http://www.w3.org/XML/1998/namespace'">Rule 9-40: An element type MUST NOT have a namespace name that is in the XML namespace.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-41"><sch:title>Element type is not simple type</sch:title>
  <sch:rule context="xs:element[@type]">
    <sch:assert test="every $type-qname in resolve-QName(@type, .),                             $type-ns in namespace-uri-from-QName($type-qname),                             $type-local-name in local-name-from-QName($type-qname) satisfies (                         $type-qname = xs:QName('xs:anySimpleType')                         or (($type-ns = nf:get-target-namespace(.)                              or exists(nf:get-document-element(.)/xs:import[                                          xs:anyURI(@namespace) = $type-ns                                          and empty(@appinfo:externalImportIndicator)]))                             and not(ends-with($type-local-name, 'SimpleType'))))">Rule 9-41: An element type that is not xs:anySimpleType MUST NOT be a simple type.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-44"><sch:title>No element default value</sch:title>
  <sch:rule context="xs:element">
    <sch:assert test="empty(@default)">Rule 9-44: An element xs:element MUST NOT have an attribute {}default.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-45"><sch:title>No element fixed value</sch:title>
  <sch:rule context="xs:element">
    <sch:assert test="empty(@fixed)">Rule 9-45: An element xs:element MUST NOT have an attribute {}fixed.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-47"><sch:title>Attribute declaration is top-level</sch:title>
  <sch:rule context="xs:attribute[exists(@name)]">
    <sch:assert test="exists(parent::xs:schema)">Rule 9-47: An attribute declaration MUST be top-level.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-48"><sch:title>Attribute declaration has data definition</sch:title>
  <sch:rule context="xs:attribute[exists(@name)]">
    <sch:assert test="some $definition in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0">Rule 9-48: An attribute declaration MUST have a data definition.</sch:assert>
  </sch:rule>
</sch:pattern>
    
<sch:pattern id="rule_9-49"><sch:title>Attribute declaration has type</sch:title>
  <sch:rule context="xs:attribute[exists(@name)]">
    <sch:assert test="exists(@type)">Rule 9-49: A top-level attribute declaration MUST have a type.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-50"><sch:title>No attribute type of xs:ID</sch:title>
  <sch:rule context="xs:attribute[exists(@type)]">
    <sch:assert test="resolve-QName(@type, .) != xs:QName('xs:ID')">Rule 9-50: A schema component MUST NOT have an attribute {}type with a value of xs:ID.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-51"><sch:title>No attribute type of xs:IDREF</sch:title>
  <sch:rule context="xs:attribute[exists(@type)]">
    <sch:assert test="resolve-QName(@type, .) != xs:QName('xs:IDREF')">Rule 9-51: A schema component MUST NOT have an attribute {}type with a value of xs:IDREF.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-52"><sch:title>No attribute type of xs:IDREFS</sch:title>
  <sch:rule context="xs:attribute[exists(@type)]">
    <sch:assert test="resolve-QName(@type, .) != xs:QName('xs:IDREFS')">Rule 9-52: A schema component MUST NOT have an attribute {}type with a value of xs:IDREFS.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-53"><sch:title>No attribute type of xs:ENTITY</sch:title>
  <sch:rule context="xs:attribute[exists(@type)]">
    <sch:assert test="resolve-QName(@type, .) != xs:QName('xs:ENTITY')">Rule 9-53: A schema component MUST NOT have an attribute {}type with a value of xs:ENTITY.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-54"><sch:title>No attribute type of xs:ENTITIES</sch:title>
  <sch:rule context="xs:attribute[exists(@type)]">
    <sch:assert test="resolve-QName(@type, .) != xs:QName('xs:ENTITIES')">Rule 9-54: A schema component MUST NOT have an attribute {}type with a value of xs:ENTITIES.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-55"><sch:title>No attribute type of xs:anySimpleType</sch:title>
  <sch:rule context="xs:attribute[exists(@type)]">
    <sch:assert test="resolve-QName(@type, .) != xs:QName('xs:anySimpleType')">Rule 9-55: A schema component MUST NOT have an attribute {}type with a value of xs:anySimpleType.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-56"><sch:title>No attribute default values</sch:title>
  <sch:rule context="xs:attribute">
    <sch:assert test="empty(@default)">Rule 9-56: An element xs:attribute MUST NOT have an attribute {}default.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-57"><sch:title>No attribute fixed values</sch:title>
  <sch:rule context="xs:attribute">
    <sch:assert test="empty(@fixed)">Rule 9-57: An element xs:attribute MUST NOT have an attribute {}fixed.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-58"><sch:title>No use of element xs:notation</sch:title>
  <sch:rule context="xs:notation">
    <sch:assert test="false()">Rule 9-58: The schema MUST NOT contain the element xs:notation.</sch:assert>
  </sch:rule>
</sch:pattern>
  
<sch:pattern id="rule_9-60"><sch:title>No xs:all</sch:title>
  <sch:rule context="xs:all">
    <sch:assert test="false()">Rule 9-60: The schema MUST NOT contain the element xs:all</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-62"><sch:title>xs:sequence must be child of xs:extension
              or xs:restriction</sch:title>
  <sch:rule context="xs:sequence">
    <sch:assert test="exists(parent::xs:extension) or exists(parent::xs:restriction)">Rule 9-62: An element xs:sequence MUST be a child of element xs:extension or xs:restriction.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-64"><sch:title>xs:choice must be child of xs:sequence</sch:title>
  <sch:rule context="xs:choice">
    <sch:assert test="exists(parent::xs:sequence)">Rule 9-64: An element xs:choice MUST be a child of element xs:sequence.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-65"><sch:title>Sequence has minimum cardinality 1</sch:title>
  <sch:rule context="xs:sequence">
    <sch:assert test="empty(@minOccurs) or xs:integer(@minOccurs) = 1">Rule 9-65: An element xs:sequence MUST either not have the attribute {}minOccurs, or that attribute MUST have a value of 1.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-66"><sch:title>Sequence has maximum cardinality 1</sch:title>
  <sch:rule context="xs:sequence">
    <sch:assert test="empty(@maxOccurs) or (@maxOccurs instance of xs:integer and 1 = xs:integer(@maxOccurs))">Rule 9-66: An element xs:sequence MUST either not have the attribute {}maxOccurs, or that attribute MUST have a value of 1.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-67"><sch:title>Choice has minimum cardinality 1</sch:title>
  <sch:rule context="xs:choice">
    <sch:assert test="empty(@minOccurs) or 1 = xs:integer(@minOccurs)">Rule 9-67: An element xs:choice MUST either not have the attribute {}minOccurs, or that attribute MUST have a value of 1.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-68"><sch:title>Choice has maximum cardinality 1</sch:title>
  <sch:rule context="xs:choice">
    <sch:assert test="empty(@maxOccurs) or (@maxOccurs instance of xs:integer and 1 = xs:integer(@maxOccurs))">Rule 9-68: An element xs:choice MUST either not have the attribute {}maxOccurs, or that attribute MUST have a value of 1.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_9-71"><sch:title>No use of xs:unique</sch:title>
  <sch:rule context="xs:unique">
    <sch:assert test="false()">Rule 9-71: The schema MUST NOT contain the element xs:unique.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-72"><sch:title>No use of xs:key</sch:title>
  <sch:rule context="xs:key">
    <sch:assert test="false()">Rule 9-72: The schema MUST NOT contain the element xs:key.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-73"><sch:title>No use of xs:keyref</sch:title>
  <sch:rule context="xs:keyref">
    <sch:assert test="false()">Rule 9-73: The schema MUST NOT contain the element xs:keyref.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-74"><sch:title>No use of xs:group</sch:title>
  <sch:rule context="xs:group">
    <sch:assert test="false()">Rule 9-74: The schema MUST NOT contain the element xs:group.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-75"><sch:title>No definition of attribute groups</sch:title>
  <sch:rule context="xs:attributeGroup[@name]">
    <sch:assert test="false()">Rule 9-75: The schema MUST NOT contain an attribute group definition schema component.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-76"><sch:title>Comment is not recommended</sch:title>
  <sch:rule context="node()[comment()]">
    <sch:report test="true()">Rule 9-76: An XML Comment is not an XML Schema annotation component; an XML comment SHOULD NOT appear in the schema.</sch:report>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-77"><sch:title>Documentation element has no element children</sch:title>
  <sch:rule context="xs:documentation/node()">
    <sch:assert test="self::text() or self::comment()">Rule 9-77: A child of element xs:documentation MUST be text or an XML comment.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-78"><sch:title>xs:appinfo children are comments, elements, or whitespace</sch:title>
  <sch:rule context="xs:appinfo/node()">
    <sch:assert test="self::comment()                       or self::element()                       or self::text()[string-length(normalize-space(.)) = 0]">Rule 9-78: A child of element xs:appinfo MUST be an element, a comment, or whitespace text.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-79"><sch:title>Appinfo child elements have namespaces</sch:title>
  <sch:rule context="xs:appinfo/*">
    <sch:assert test="namespace-uri() != xs:anyURI('')">Rule 9-79: An element that is a child of xs:appinfo MUST have a namespace name.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-80"><sch:title>Appinfo descendants are not XML Schema elements</sch:title>
  <sch:rule context="xs:appinfo//xs:*">
    <sch:assert test="false()">Rule 9-80: An element with a namespace name of xs: MUST NOT have an ancestor element xs:appinfo.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-81"><sch:title>Schema has data definition</sch:title>
  <sch:rule context="xs:schema">
    <sch:assert test="some $definition in (xs:annotation/xs:documentation)[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0">Rule 9-81: An element xs:schema MUST have a data definition.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-82"><sch:title>Schema document defines target namespace</sch:title>
  <sch:rule context="xs:schema">
    <sch:assert test="exists(@targetNamespace)">Rule 9-82: The schema MUST define a target namespace.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-83"><sch:title>Target namespace is absolute URI</sch:title>
  <sch:rule context="xs:schema[exists(@targetNamespace)]">
    <sch:report test="true()">Rule 9-83: The value of the attribute targetNamespace MUST match the production &lt;absolute-URI&gt; as defined by RFC 3986.</sch:report>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-84"><sch:title>Schema has version</sch:title>
  <sch:rule context="xs:schema">
    <sch:assert test="some $version in @version satisfies                       string-length(normalize-space(@version)) &gt; 0">Rule 9-84: An element xs:schema MUST have an attribute {}version that MUST NOT be empty.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-87"><sch:title>No use of xs:redefine</sch:title>
  <sch:rule context="xs:redefine">
    <sch:assert test="false()">Rule 9-87: The schema MUST NOT contain the element xs:redefine.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-88"><sch:title>No use of xs:include</sch:title>
  <sch:rule context="xs:include">
    <sch:assert test="false()">Rule 9-88: The schema MUST NOT contain the element xs:include.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-89"><sch:title>xs:import must have namespace</sch:title>
  <sch:rule context="xs:import">
    <sch:assert test="exists(@namespace)">Rule 9-89: An element xs:import MUST have an attribute {}namespace.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_9-91"><sch:title>Namespace referenced by attribute type is imported</sch:title>
  <sch:rule context="xs:*[@type]">
    <sch:assert test="every $namespace in namespace-uri-from-QName(resolve-QName(@type, .)) satisfies (                         $namespace = nf:get-target-namespace(.)                         or $namespace = xs:anyURI('http://www.w3.org/2001/XMLSchema')                         or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace])">Rule 9-91: The namespace of a type referenced by @type MUST be the target namespace, the XML Schema namespace, or be imported.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-92"><sch:title>Namespace referenced by attribute base is imported</sch:title>
  <sch:rule context="xs:*[@base]">
    <sch:assert test="every $namespace in namespace-uri-from-QName(resolve-QName(@base, .)) satisfies (                         $namespace = nf:get-target-namespace(.)                         or $namespace = xs:anyURI('http://www.w3.org/2001/XMLSchema')                         or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace])">Rule 9-92: The namespace of a type referenced by @base MUST be the target namespace, the XML Schema namespace, or be imported.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-93"><sch:title>Namespace referenced by attribute itemType is imported</sch:title>
  <sch:rule context="xs:*[@itemType]">
    <sch:assert test="every $namespace in namespace-uri-from-QName(resolve-QName(@itemType, .)) satisfies (                         $namespace = nf:get-target-namespace(.)                         or $namespace = xs:anyURI('http://www.w3.org/2001/XMLSchema')                         or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace])">Rule 9-93: The namespace of a type referenced by @itemType MUST be the target namespace, the XML Schema namespace, or be imported.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-94"><sch:title>Namespaces referenced by attribute memberTypes is imported</sch:title>
  <sch:rule context="xs:*[@memberTypes]">
    <sch:assert test="every $type in tokenize(normalize-space(@memberTypes), ' '),                             $namespace in namespace-uri-from-QName(resolve-QName($type, .)) satisfies (                         $namespace = nf:get-target-namespace(.)                         or $namespace = xs:anyURI('http://www.w3.org/2001/XMLSchema')                         or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace])">Rule 9-94: The namespace of a type referenced by @memberTypes MUST be the target namespace, the XML Schema namespace, or be imported.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-95"><sch:title>Namespace referenced by attribute ref is imported</sch:title>
  <sch:rule context="xs:*[@ref]">
    <sch:assert test="every $namespace in namespace-uri-from-QName(resolve-QName(@ref, .)) satisfies                         $namespace = nf:get-target-namespace(.)                         or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace]">Rule 9-95: The namespace of a component referenced by @ref MUST be the target namespace or be imported.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_9-96"><sch:title>Namespace referenced by attribute substitutionGroup is imported</sch:title>
  <sch:rule context="xs:*[@substitutionGroup]">
    <sch:assert test="every $namespace in namespace-uri-from-QName(resolve-QName(@substitutionGroup, .)) satisfies                         $namespace = nf:get-target-namespace(.)                         or nf:get-document-element(.)/xs:import[xs:anyURI(@namespace) = $namespace]">Rule 9-96: The namespace of a component referenced by @substitutionGroup MUST be the target namespace or be imported.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-2"><sch:title>Object type with complex content is derived from object type</sch:title>
  <sch:rule context="xs:complexType[exists(xs:complexContent)                                     and not(ends-with(@name, 'AssociationType')                                         or ends-with(@name, 'MetadataType')                                         or ends-with(@name, 'AugmentationType'))]">
    <sch:assert test="         every $derivation-method in (xs:complexContent/xs:extension, xs:complexContent/xs:restriction),               $base in $derivation-method/@base,               $base-qname in resolve-QName($base, $derivation-method),               $base-local-name in local-name-from-QName($base-qname) satisfies (           $base-qname = xs:QName('structures:ObjectType')           or not(ends-with($base-local-name, 'AssociationType')                  or ends-with($base-local-name, 'MetadataType')                  or ends-with($base-local-name, 'AugmentationType')))">Rule 10-2: An object type with complex content MUST be derived from structures:ObjectType or from another object type.</sch:assert>
  </sch:rule>
</sch:pattern>
                
<sch:pattern id="rule_10-3"><sch:title>RoleOf element type is an object type</sch:title>
  <sch:rule context="xs:element[@name[starts-with(., 'RoleOf')]]">
    <sch:assert test="every $type in @type,                             $type-local-name in local-name-from-QName(resolve-QName($type, .)) satisfies                         not(ends-with($type-local-name, 'AssociationType')                             or ends-with($type-local-name, 'MetadataType')                             or ends-with($type-local-name, 'AugmentationType'))">Rule 10-3: The type definition of a RoleOf element MUST be an object type.</sch:assert>
  </sch:rule>
</sch:pattern>
                
<sch:pattern id="rule_10-4"><sch:title>Only object type has RoleOf element</sch:title>
  <sch:rule context="xs:complexType[       empty(@appinfo:externalAdapterTypeIndicator)       and exists(descendant::xs:element[             exists(@ref[               starts-with(local-name-from-QName(resolve-QName(., ..)), 'RoleOf')])])]">
    <sch:assert test="not(ends-with(@name, 'AssociationType')                           or ends-with(@name, 'MetadataType')                           or ends-with(@name, 'AugmentationType'))">Rule 10-4: A complex type that includes a RoleOf element in its content model MUST be an object type.</sch:assert>
  </sch:rule>
</sch:pattern>
                
<sch:pattern id="rule_10-7"><sch:title>Import of external namespace has data definition</sch:title>
  <sch:rule context="xs:import[@appinfo:externalImportIndicator]">
    <sch:assert test="some $definition in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($definition))) &gt; 0">Rule 10-7: An element xs:import that is annotated as importing an external schema document MUST be a documented component.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_10-9"><sch:title>Structure of external adapter type definition follows pattern</sch:title>
  <sch:rule context="xs:complexType[@appinfo:externalAdapterTypeIndicator]">
    <sch:assert test="xs:complexContent/xs:extension[                         resolve-QName(@base, .) = xs:QName('structures:ObjectType')                       ]/xs:sequence">Rule 10-9: An external adapter type definition MUST be a complex type definition with complex content that extends structures:ObjectType, and that uses xs:sequence as its top-level compositor.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_10-10"><sch:title>Element use from external adapter type defined by external schema documents</sch:title>
  <sch:rule context="xs:element[@ref                                 and exists(ancestor::xs:complexType[exists(@appinfo:externalAdapterTypeIndicator)])]">
    <sch:assert test="some $ref-namespace in namespace-uri-from-QName(resolve-QName(@ref, .)) satisfies                         nf:get-document-element(.)/xs:import[                           $ref-namespace = xs:anyURI(@namespace)                           and @appinfo:externalImportIndicator]">Rule 10-10: An element reference that appears within an external adapter type MUST have a target namespace that is imported as external.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_10-11"><sch:title>External adapter type not a base type</sch:title>
  <sch:rule context="xs:*[(self::xs:extension or self::xs:restriction)                           and (some $base-qname in resolve-QName(@base, .),                                     $base-namespace in namespace-uri-from-QName($base-qname) satisfies                                  nf:get-target-namespace(.) = $base-namespace)]">
    <sch:assert test="nf:resolve-type(., resolve-QName(@base, .))[                         empty(@appinfo:externalAdapterTypeIndicator)]">Rule 10-11: An external adapter type definition MUST NOT be a base type definition.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_10-14"><sch:title>External attribute use has data definition</sch:title>
  <sch:rule context="xs:attribute[some $ref-namespace in namespace-uri-from-QName(resolve-QName(@ref, .)),                                        $import in ancestor::xs:schema[1]/xs:import satisfies (                                     xs:anyURI($import/@namespace) = $ref-namespace                                     and exists(@appinfo:externalImportIndicator))]">
    <sch:assert test="some $documentation in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($documentation))) &gt; 0">Rule 10-14: An external attribute use MUST be a documented component with a non-empty data definition.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-16"><sch:title>External element use has data definition</sch:title>
  <sch:rule context="xs:element[       some $ref-namespace in namespace-uri-from-QName(resolve-QName(@ref, .)) satisfies         nf:get-document-element(.)/self::xs:schema//xs:import[           xs:anyURI(@namespace) = $ref-namespace           and @appinfo:externalImportIndicator]]">
    <sch:assert test="some $documentation in xs:annotation/xs:documentation[1] satisfies                         string-length(normalize-space(string($documentation))) &gt; 0">Rule 10-16: An external attribute use MUST be a documented component with a non-empty data definition.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-17"><sch:title>Name of code type ends in "CodeType"</sch:title>
  <sch:rule context="xs:complexType">
    <sch:let name="has-code-type-name" value="ends-with(@name, 'CodeType')"/>
    <sch:let name="has-code-type-base" value="         exists(xs:simpleContent[           exists(xs:*[local-name() = ('extension', 'restriction')                       and (ends-with(@base, 'CodeSimpleType')                            or ends-with(@base, 'CodeType'))])])"/>
    <sch:assert test="$has-code-type-name = $has-code-type-base">Rule 10-17: A complex type definition MUST have a {name} that ends in 'CodeType' if and only if it has a {base type definition} of a code type or code simple type.</sch:assert>
  </sch:rule>
</sch:pattern>
                
<sch:pattern id="rule_10-18"><sch:title>Proxy type has designated structure</sch:title>
  <sch:rule context="xs:complexType[some $name in @name,                                          $extension in xs:simpleContent/xs:extension,                                          $base-qname in resolve-QName($extension/@base, $extension) satisfies                                       $base-qname = QName('http://www.w3.org/2001/XMLSchema', @name)]">
    <sch:assert test="xs:simpleContent[                         xs:extension[                           empty(xs:attribute)                           and count(xs:attributeGroup) = 1                           and xs:attributeGroup[                                 resolve-QName(@ref, .) = xs:QName('structures:SimpleObjectAttributeGroup')]]]">Rule 10-18: A proxy type MUST have the designated structure. It MUST use xs:extension. It MUST NOT use xs:attribute. It MUST include exactly one xs:attributeGroup reference, which must be to structures:SimpleObjectAttributeGroup.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_10-19"><sch:title>Association types is derived from association type</sch:title>
  <sch:rule context="xs:complexType">
    <sch:let name="is-association-type" value="exists(@name[ends-with(., 'AssociationType')])"/>
    <sch:let name="has-association-base-type" value="       exists(xs:complexContent[         exists(xs:*[local-name() = ('extension', 'restriction')                     and exists(@base[ends-with(., 'AssociationType')])])])"/>
    <sch:assert test="$is-association-type = $has-association-base-type">Rule 10-19: A type MUST have a association type name if and only if it is derived from an association type.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_10-20"><sch:title>Association element type is an association type</sch:title>
  <sch:rule context="xs:element[exists(@name)]">
    <sch:assert test="exists(@type[ends-with(., 'AssociationType')])                       = exists(@name[ends-with(., 'Association')])">Rule 10-20: An element MUST have a name that ends in 'Association' if and only if it has a type that is an association type.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_10-22"><sch:title>Augmentable type has at most one augmentation point element</sch:title>
  <sch:rule context="xs:complexType[                        @name[not(ends-with(., 'MetadataType'))                              and not(ends-with(., 'AugmentationType'))]                        and empty(@appinfo:externalAdapterTypeIndicator)                        and xs:complexContent]">
    <sch:let name="augmentation-point-qname" value="QName(nf:get-target-namespace(.),                           replace(./@name, 'Type$', 'AugmentationPoint'))"/>
    <sch:assert test="count(xs:complexContent/xs:extension/xs:sequence/xs:element[                               @ref[resolve-QName(., ..) = $augmentation-point-qname]]) &lt;= 1">Rule 10-22: An augmentable type MUST contain no more than one element use of its augmentation point element.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-23"><sch:title>Augmentation point corresponds to augmentable type</sch:title>
  <sch:rule context="xs:element[exists(@name[                                  matches(., 'AugmentationPoint$')])]">
    <sch:let name="element-name" value="@name"/>
    <sch:assert test="exists(                         parent::xs:schema/xs:complexType[                           @name = replace($element-name, 'AugmentationPoint$', 'Type')                           and exists(@name[                                   not(ends-with(., 'MetadataType'))                                   and not(ends-with(., 'AugmentationType'))])                                 and empty(@appinfo:externalAdapterTypeIndicator)                                 and exists(child::xs:complexContent)])">Rule 10-23: A schema document containing an augmentation point element declaration MUST also contain a corresponding augmentable type definition.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-24"><sch:title>An augmentation point has no type</sch:title>
  <sch:rule context="xs:element[exists(@name[                                  matches(., 'AugmentationPoint$')])]">
    <sch:assert test="empty(@type)">Rule 10-24: An augmentation point element MUST have no type.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-25"><sch:title>An augmentation point has no substitution group</sch:title>
  <sch:rule context="xs:element[exists(@name[                                  matches(., 'AugmentationPoint$')])]">
    <sch:assert test="empty(@substitutionGroup)">Rule 10-25: An augmentation point element MUST have no substitution group.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-26"><sch:title>Augmentation point element may only be referenced by its type</sch:title>
  <sch:rule context="xs:complexType//xs:element[exists(@ref[                        matches(local-name-from-QName(resolve-QName(., ..)), 'AugmentationPoint$')]) ]">

    <sch:assert test="QName(nf:get-target-namespace(ancestor::xs:complexType[1]), ancestor::xs:complexType[1]/@name)                       = QName(namespace-uri-from-QName(resolve-QName(@ref, .)),                 replace(local-name-from-QName(resolve-QName(@ref, .)), 'AugmentationPoint$', 'Type'))">Rule 10-26: An augmentation point element MUST only be referenced by its corresponding type.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-29"><sch:title>Augmentation point reference must be last particle</sch:title>
  <sch:rule context="xs:complexType//xs:element[exists(@ref[                            matches(local-name-from-QName(resolve-QName(., ..)), 'AugmentationPoint$')]) ]">
    <sch:assert test="empty(following-sibling::*)">Rule 10-29: An augmentation point element particle MUST be the last element occurrence in its content model.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-32"><sch:title>Schema component with name ending in "AugmentationType" is an augmentation type</sch:title>
  <sch:rule context="xs:*[ends-with(@name, 'AugmentationType')]">
    <sch:assert test="self::xs:complexType/xs:complexContent/xs:*[                         (self::xs:extension or self::xs:restriction)                         and ends-with(@base, 'AugmentationType')]">Rule 10-32: An augmentation type definition schema component with {name} ending in 'AugmentationType' MUST be an augmentation type definition that is a complex type definition with complex content that extends or restricts an augmentation type.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_10-33"><sch:title>Type derived from augmentation type is an augmentation type</sch:title>
  <sch:rule context="xs:*[(self::xs:restriction or self::xs:extension)                           and ends-with(@base, 'AugmentationType')]">
    <sch:assert test="ancestor::xs:complexType[ends-with(@name, 'AugmentationType')]">Rule 10-33: A type definition derived from an augmentation type MUST be an augmentation type definition</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-34"><sch:title>Augmentation element type is an augmentation type</sch:title>
  <sch:rule context="xs:element[exists(@name)]">
    <sch:assert test="exists(@type[ends-with(., 'AugmentationType')])                       = exists(@name[ends-with(., 'Augmentation')])">Rule 10-34: An element declaration MUST have a name that ends in "Augmentation" if and only if it has a type that is an augmentation type.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_10-38"><sch:title>Metadata types are derived from metadata types</sch:title>
  <sch:rule context="xs:complexType">
    <sch:let name="is-metadata-type" value="exists(@name[ends-with(., 'MetadataType')])"/>
    <sch:let name="has-metadata-base-type" value="       exists(xs:complexContent[         exists(xs:*[local-name() = ('extension', 'restriction')                     and exists(@base[ends-with(., 'MetadataType')])])])"/>
    <sch:assert test="$is-metadata-type = $has-metadata-base-type">Rule 10-38: A type MUST have a metadata type name if an only if it is derived from a metadata type.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_10-39"><sch:title>Metadata element declaration type is a metadata type</sch:title>
  <sch:rule context="xs:element[exists(@name)]">
    <sch:assert test="exists(@type[ends-with(., 'MetadataType')])                       = exists(@name[ends-with(., 'Metadata')])">Rule 10-39: An element MUST have a name that ends in 'Metadata' if and only if it has a type that is a metadata type.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_10-41"><sch:title>Name of element that ends in "Representation" is abstract</sch:title>
  <sch:rule context="xs:element[@name[ends-with(., 'Representation')]]">
    <sch:report test="empty(@abstract) or xs:boolean(@abstract) = false()">Rule 10-41: An element declaration with a name that ends in 'Representation' SHOULD have the {abstract} property with a value of "true".</sch:report>
  </sch:rule>
</sch:pattern>
	  
<sch:pattern id="rule_10-67"><sch:title>Deprecated annotates schema component</sch:title>
  <sch:rule context="*[exists(@appinfo:deprecated)]">
    <sch:assert test="namespace-uri-from-QName(node-name(.)) = xs:anyURI('http://www.w3.org/2001/XMLSchema')">Rule 10-67: The attribute appinfo:deprecated MUST be owned by an element with a namespace name <namespace-uri-for-prefix xmlns="https://iead.ittl.gtri.org/wr24/doc/2011-09-30-2258">xs</namespace-uri-for-prefix>.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_10-68"><sch:title>External import indicator annotates import</sch:title>
  <sch:rule context="*[exists(@appinfo:externalImportIndicator)]">
    <sch:assert test="exists(self::xs:import)">Rule 10-68: The attribute {http://release.niem.gov/niem/appinfo/3.0/}externalImportIndicator MUST be owned by an element xs:import.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_10-70"><sch:title>appinfo:appliesToTypes annotates metadata element</sch:title>
  <sch:rule context="*[exists(@appinfo:appliesToTypes)]">
    <sch:assert test="exists(self::xs:element[exists(@name)                                and ends-with(@name, 'Metadata')])">Rule 10-70: The attribute appinfo:appliesToTypes MUST be owned by a metadata element.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-72"><sch:title>appinfo:appliesToElements annotates metadata element</sch:title>
  <sch:rule context="*[exists(@appinfo:appliesToElements)]">
    <sch:assert test="exists(self::xs:element[                           exists(@name)                           and ends-with(@name, 'Metadata')])">Rule 10-72: The attribute appinfo:appliesToElements MUST be owned by a metadata element.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-74"><sch:title>term:LocalTerm annotates schema</sch:title>
  <sch:rule context="term:LocalTerm">
    <sch:assert test="parent::xs:appinfo[parent::xs:annotation[parent::xs:schema]]">Rule 10-74: The element term:LocalTerm MUST be application information an an element xs:schema.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_10-75"><sch:title>term:LocalTerm has literal or definition</sch:title>
  <sch:rule context="term:LocalTerm">
    <sch:assert test="exists(@literal) or exists(@definition)">Rule 10-75: The element {http://release.niem.gov/niem/localTerminology/3.0/}LocalTerm MUST have a literal or definition.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_11-1"><sch:title>Name of type ends in "Type"</sch:title>
  <sch:rule context="xs:complexType[some $name in @name,                                          $extension in xs:simpleContent/xs:extension,                                          $base-qname in resolve-QName($extension/@base, $extension) satisfies                                       $base-qname = QName('http://www.w3.org/2001/XMLSchema', @name)]">
    <sch:report test="false()">Rule 11-1: The name of a proxy type does not end in "Type".</sch:report>
  </sch:rule>
  <sch:rule context="xs:*[(self::xs:simpleType or self::xs:complexType) and exists(@name)]">
    <sch:assert test="ends-with(@name, 'Type')">Rule 11-1: A type definition schema component that does not define a proxy type MUST have a name that ends in "Type".</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_11-2"><sch:title>Name of type other than proxy type is in upper camel case</sch:title>
  <sch:rule context="xs:complexType[some $name in @name,                                          $extension in xs:simpleContent/xs:extension,                                          $base-qname in resolve-QName($extension/@base, $extension) satisfies                                       $base-qname = QName('http://www.w3.org/2001/XMLSchema', @name)]">
    <sch:report test="false()">Rule 11-2: The name of a proxy type is not upper camel case.</sch:report>
  </sch:rule>
  <sch:rule context="xs:*[(self::xs:simpleType or self::xs:complexType) and exists(@name)]">
    <sch:assert test="matches(@name, '^([A-Z][A-Za-z0-9\-]*)+$')">Rule 11-2: A type definition schema component that does not define a proxy type MUST be in upper camel case.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_11-3"><sch:title>Base type definition defined by conformant schema</sch:title>
  <sch:rule context="xs:*[exists(@base)]">
    <sch:assert test="some $base-namespace in namespace-uri-from-QName(resolve-QName(@base, .)) satisfies (                         $base-namespace = (nf:get-target-namespace(.), xs:anyURI('http://www.w3.org/2001/XMLSchema'))                         or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace)                                                                    and $base-namespace = xs:anyURI(@namespace)                                                                    and empty(@appinfo:externalImportIndicator)]))">Rule 11-3: The {base type definition} of a type definition MUST have the target namespace or the XML Schema namespace or a namespace that is imported as conformant.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-4"><sch:title>Name of simple type ends in "SimpleType"</sch:title>
  <sch:rule context="xs:simpleType[@name]">
    <sch:assert test="ends-with(@name, 'SimpleType')">Rule 11-4: A simple type definition schema component MUST have a name that ends in "SimpleType".</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-5"><sch:title>Name of simple type is upper camel case</sch:title>
  <sch:rule context="xs:simpleType[exists(@name)]">
    <sch:assert test="matches(string(@name), '^([A-Z][A-Za-z0-9\-]*)+$')">Rule 11-5: The name of a simple type definition schema component MUST be upper camel case.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-7"><sch:title>List item type defined by conformant schemas</sch:title>
  <sch:rule context="xs:list[exists(@itemType)]">
    <sch:let name="namespace" value="namespace-uri-from-QName(resolve-QName(@itemType, .))"/>
    <sch:assert test="$namespace = (nf:get-target-namespace(.), xs:anyURI('http://www.w3.org/2001/XMLSchema'))                       or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace)                                     and $namespace = xs:anyURI(@namespace)                                     and empty(@appinfo:externalImportIndicator)])">Rule 11-7: The item type of a list simple type definition MUST have a target namespace equal to the target namespace of the XML Schema document within which it is defined, or a namespace that is imported as conformant by the schema document within which it is defined.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_11-8"><sch:title>Union member types defined by conformant schemas</sch:title>
  <sch:rule context="xs:union[exists(@memberTypes)]">
    <sch:assert test="every $qname in tokenize(normalize-space(@memberTypes), ' '),                             $namespace in namespace-uri-from-QName(resolve-QName($qname, .))                       satisfies ($namespace = nf:get-target-namespace(.)                                  or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace)                                            and $namespace = xs:anyURI(@namespace)                                            and empty(@appinfo:externalImportIndicator)]))">Rule 11-8: Every member type of a union simple type definition MUST have a target namespace that is equal to either the target namespace of the XML Schema document within which it is defined or a namespace that is imported as conformant by the schema document within which it is defined.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_11-9"><sch:title>Name of a code simple type has standard suffix</sch:title>
  <sch:rule context="xs:simpleType[exists(@name)       and (xs:restriction/xs:enumeration            or xs:restriction[ends-with(local-name-from-QName(resolve-QName(@base, .)), 'CodeSimpleType')])]">
    <sch:assert test="ends-with(@name, 'CodeSimpleType')">Rule 11-9: A simple type definition schema component that has an enumeration facet or that is derived from a code type MUST have a name that ends in "CodeSimpleType".</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_11-10"><sch:title>Code simple type has enumerations</sch:title>
  <sch:rule context="xs:simpleType[exists(@name) and ends-with(@name, 'CodeSimpleType')]">
    <sch:assert test="xs:restriction[ends-with(local-name-from-QName(resolve-QName(@base, .)), 'CodeSimpleType')]                       or xs:restriction/xs:enumeration                       or (for $union in xs:union,                              $member-types in $union/@memberTypes return                            some $member-type in tokenize(normalize-space($member-types), ' ') satisfies                              ends-with(local-name-from-QName(resolve-QName($member-type, $union)), 'CodeSimpleType'))">Rule 11-10: A code simple type MUST be derived from a code simple type or have an enumeration facet.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_11-11"><sch:title>Complex type with simple content has structures:SimpleObjectAttributeGroup</sch:title>
  <sch:rule context="xs:simpleContent/xs:extension[       some $base-qname in resolve-QName(@base, .) satisfies         namespace-uri-from-QName($base-qname) = xs:anyURI('http://www.w3.org/2001/XMLSchema')         or ends-with(local-name-from-QName($base-qname), 'SimpleType')]">
    <sch:assert test="xs:attributeGroup[                         resolve-QName(@ref, .) = xs:QName('structures:SimpleObjectAttributeGroup')]">Rule 11-11: A complex type definition with simple content schema component with a derivation method of extension that has a base type definition that is a simple type MUST incorporate the attribute group {http://release.niem.gov/niem/structures/3.0/}SimpleObjectAttributeGroup.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_11-12"><sch:title>Element name is upper camel case</sch:title>
  <sch:rule context="xs:element[exists(@name)]">
    <sch:assert test="matches(string(@name), '^([A-Z][A-Za-z0-9\-]*)+$')">Rule 11-12: The name of an element declaration MUST be upper camel case.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-13"><sch:title>Element type does not have a simple type name</sch:title>
  <sch:rule context="xs:element[exists(@type)]">
    <sch:assert test="not(ends-with(@type, 'SimpleType'))">Rule 11-13: The {type definition} of an element declaration MUST NOT have a {name} that ends in 'SimpleType'.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-14"><sch:title>Element type is from conformant namespace</sch:title>
  <sch:rule context="xs:element[exists(@type)]">
    <sch:assert test="for $type-qname in resolve-QName(@type, .),                           $type-namespace in namespace-uri-from-QName($type-qname) return                         $type-namespace = nf:get-target-namespace(.)                         or exists(nf:get-document-element(.)/xs:import[                                     xs:anyURI(@namespace) = $type-namespace                                     and empty(@appinfo:externalImportIndicator)])">Rule 11-14: The {type definition} of an element declaration MUST have a {target namespace} that is the target namespace, or one that is imported as conformant.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-15"><sch:title>Name of element that ends in "Abstract" is abstract</sch:title>
  <sch:rule context="xs:element[@name[ends-with(., 'Abstract')]]">
    <sch:assert test="exists(@abstract) and xs:boolean(@abstract) = true()">Rule 11-15: An element declaration with a name that ends in 'Abstract' MUST have the {abstract} property with a value of "true".</sch:assert>
  </sch:rule>
</sch:pattern>
	    
<sch:pattern id="rule_11-16"><sch:title>Name of element declaration with simple content has representation term</sch:title>
  <sch:rule context="xs:element[@name and @type                                 and (some $type-qname in resolve-QName(@type, .) satisfies (                                        nf:get-target-namespace(.) = namespace-uri-from-QName($type-qname)                                        and nf:resolve-type(., $type-qname)/xs:simpleContent))]">
    <sch:assert test="some $representation-term in ('Amount', 'BinaryObject', 'Graphic', 'Picture', 'Sound', 'Video', 'Code', 'DateTime', 'Date', 'Time', 'Duration', 'ID', 'URI', 'Indicator', 'Measure', 'Numeric', 'Value', 'Rate', 'Percent', 'Quantity', 'Text', 'Name', 'List') satisfies                         ends-with(@name, $representation-term)">Rule 11-16: The name of an element declaration that is of simple content MUST use a representation term.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_11-18"><sch:title>Element substitution group defined by conformant schema</sch:title>
  <sch:rule context="xs:element[exists(@substitutionGroup)]">
    <sch:let name="namespace" value="namespace-uri-from-QName(resolve-QName(@substitutionGroup, .))"/>
    <sch:assert test="$namespace = nf:get-target-namespace(.)                       or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace)                                     and $namespace = xs:anyURI(@namespace)                                     and empty(@appinfo:externalImportIndicator)])">Rule 11-18: An element substitution group MUST have either the target namespace or a namespace that is imported as conformant.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-19"><sch:title>Attribute type defined by conformant schema</sch:title>
  <sch:rule context="xs:attribute[exists(@type)]">
    <sch:let name="namespace" value="namespace-uri-from-QName(resolve-QName(@type, .))"/>
    <sch:assert test="$namespace = (nf:get-target-namespace(.), xs:anyURI('http://www.w3.org/2001/XMLSchema'))                       or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace)                                     and $namespace = xs:anyURI(@namespace)                                     and empty(@appinfo:externalImportIndicator)])">Rule 11-19: The type of an attribute declaration MUST have the target namespace or the XML Schema namespace or a namespace that is imported as conformant.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-20"><sch:title>Attribute name uses representation term</sch:title>
  <sch:rule context="xs:attribute[exists(@name)]">
    <sch:assert test="some $representation-term in ('Amount', 'BinaryObject', 'Graphic', 'Picture', 'Sound', 'Video', 'Code', 'DateTime', 'Date', 'Time', 'Duration', 'ID', 'URI', 'Indicator', 'Measure', 'Numeric', 'Value', 'Rate', 'Percent', 'Quantity', 'Text', 'Name', 'List') satisfies                         ends-with(@name, $representation-term)">Rule 11-20: An attribute name MUST end with a representation term.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-22"><sch:title>Element reference defined by conformant schema</sch:title>
  <sch:rule context="xs:element[exists(ancestor::xs:complexType[empty(@appinfo:externalAdapterTypeIndicator)]) and @ref]">
    <sch:let name="namespace" value="namespace-uri-from-QName(resolve-QName(@ref, .))"/>
    <sch:assert test="$namespace = nf:get-target-namespace(.)                       or exists(ancestor::xs:schema[1]/xs:import[exists(@namespace)                                     and $namespace = xs:anyURI(@namespace)                                     and empty(@appinfo:externalImportIndicator)])">Rule 11-22: An element reference MUST be to a component that has a namespace that is either the target namespace of the schema document in which it appears, or which is imported as conformant by that schema document.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_11-23"><sch:title>Referenced attribute defined by conformant schemas</sch:title>
  <sch:rule context="xs:attribute[@ref]">
    <sch:let name="namespace" value="namespace-uri-from-QName(resolve-QName(@ref, .))"/>
    <sch:assert test="some $namespace in namespace-uri-from-QName(resolve-QName(@ref, .)) satisfies (                         $namespace = nf:get-target-namespace(.)                         or ancestor::xs:schema[1]/xs:import[                              @namespace                              and $namespace = xs:anyURI(@namespace)                              and empty(@appinfo:externalImportIndicator)])">Rule 11-23: An attribute {}ref MUST have the target namespace or a namespace that is imported as conformant.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-24"><sch:title>Schema uses only known attribute groups</sch:title>
  <sch:rule context="xs:attributeGroup[@ref]">
    <sch:assert test="some $ref in resolve-QName(@ref, .) satisfies (                         $ref = xs:QName('structures:SimpleObjectAttributeGroup')                         or namespace-uri-from-QName($ref) = (xs:anyURI('urn:us:gov:ic:ism'),                                                              xs:anyURI('urn:us:gov:ic:ntk')))">Rule 11-24: An attribute group reference MUST be structures:SimpleObjectAttributeGroup or have the IC-ISM or IC-NTK namespace.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_11-31"><sch:title>Standard opening phrase for element</sch:title>
  <sch:rule context="xs:element[ends-with(@name, 'AugmentationPoint')]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(starts-with(lower-case(normalize-space(.)), 'an augmentation point '))">Rule 11-31: The data definition for an augmentation point element SHOULD begin with standard opening phrase "an augmentation point...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:element[ends-with(@name, 'Augmentation')]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(some $phrase in ('supplements ', 'additional information about ')                             satisfies starts-with(lower-case(normalize-space(.)), $phrase))">Rule 11-31: The data definition for an augmentation element SHOULD begin with the standard opening phrase "supplements..." or "additional information about...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:element[ends-with(@name, 'Metadata')]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '(metadata about|information that further qualifies)'))">Rule 11-31: The data definition for a metadata element SHOULD begin with the standard opening phrase "metadata about..." or "information that further qualifies...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:element[ends-with(@name, 'Association') and empty(@abstract)                        ]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)),                                   '^an?( .*)? (relationship|association)'))">Rule 11-31: The data defintion for an association element that is not abstract SHOULD begin with the standard opening phrase "an (optional adjectives) (relationship|association)...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:element[xs:boolean(@abstract) = true()                        ]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(starts-with(lower-case(normalize-space(.)), 'a data concept'))">Rule 11-31: The data defintion for an abstract element SHOULD begin with the standard opening phrase "a data concept...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:element[ends-with(@name, 'Date')]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? (date|month|year)'))">Rule 11-31: The data defintion for an element with a date representation term SHOULD begin with the standard opening phrase "a(n?) (optional adjectives) (date|month|year)...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:element[ends-with(@name, 'Quantity')]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? (count|number)'))">Rule 11-31: The data defintion for an element with a quantity representation term SHOULD begin with the standard opening phrase "an (optional adjectives) (count|number)...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:element[ends-with(@name, 'Picture')]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? (image|picture|photograph)'))">Rule 11-31: The data defintion for an element with a picture representation term SHOULD begin with the standard opening phrase "an (optional adjectives) (image|picture|photograph)".</sch:report>
  </sch:rule>
  <sch:rule context="xs:element[ends-with(@name, 'Indicator')]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '^true if .*; false (otherwise|if)'))">Rule 11-31: The data defintion for an element with an indicator representation term SHOULD begin with the standard opening phrase "true if ...; false (otherwise|if)...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:element[ends-with(@name, 'Identification')]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '^an?( .*)? identification'))">Rule 11-31: The data defintion for an element with an identification representation term SHOULD begin with the standard opening phrase "(a|an) (optional adjectives) identification...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:element[ends-with(@name, 'Name')]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '^(a|an)( .*)? name'))">Rule 11-31: The data defintion for an element with a name representation term SHOULD begin with the standard opening phrase "(a|an) (optional adjectives) name...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:element[@name]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '^an? '))">Rule 11-31: The data defintion for an element declaration with a name SHOULD begin with the standard opening phrase "(a|an)".</sch:report>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-32"><sch:title>Standard opening phrase for complex type</sch:title>
  <sch:rule context="xs:complexType[ends-with(@name, 'AssociationType')]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '^a data type for (a relationship|an association)'))">Rule 11-32: The data definition for an association type SHOULD begin with the standard opening phrase "a datatype for (a relationship|an association)...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:complexType[ends-with(@name, 'AugmentationType')]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '^a data type (that supplements|for additional information about)'))">Rule 11-32: The data definition for an augmentation type SHOULD begin with the standard opening phrase "a data type (that supplements|for additional information about)...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:complexType[ends-with(@name, 'MetadataType')]/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '^a data type for (metadata about|information that further qualifies)'))">Rule 11-32: The data definition for a metadata type SHOULD begin with the standard opening phrase "a data type for (metdata about|information that further qualifies)...".</sch:report>
  </sch:rule>
  <sch:rule context="xs:complexType/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '^a data type'))">Rule 11-32: The data definition for a type SHOULD begin with the standard opening phrase "a data type...".</sch:report>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-33"><sch:title>Standard opening phrase for simple type</sch:title>
  <sch:rule context="xs:simpleType/xs:annotation/xs:documentation[1]">
    <sch:report test="not(matches(lower-case(normalize-space(.)), '^a data type'))">Rule 11-33: The data definition for a type SHOULD begin with a standard opening phrase "a data type...".</sch:report>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-38"><sch:title>Structures imported as conformant</sch:title>
  <sch:rule context="xs:import[exists(@namespace)                                and xs:anyURI(@namespace) = xs:anyURI('http://release.niem.gov/niem/structures/3.0/')]">
    <sch:assert test="empty(@appinfo:externalImportIndicator)">Rule 11-38: An import of the structures namespace MUST NOT be labeled as an external import.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-39"><sch:title>XML namespace imported as conformant</sch:title>
  <sch:rule context="xs:import[exists(@namespace)                                and xs:anyURI(@namespace) = xs:anyURI('http://www.w3.org/XML/1998/namespace')]">
    <sch:assert test="empty(@appinfo:externalImportIndicator)">Rule 11-39: An import of the XML namespace MUST NOT be labeld as an external import.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-41"><sch:title>Consistently marked namespace imports</sch:title>
  <sch:rule context="xs:import">
    <sch:let name="namespace" value="@namespace"/>
    <sch:let name="is-conformant" value="empty(@appinfo:externalImportIndicator)"/>
    <sch:let name="first" value="exactly-one(parent::xs:schema/xs:import[@namespace = $namespace][1])"/>
    <sch:assert test=". is $first                       or $is-conformant = empty($first/@appinfo:externalImportIndicator)">Rule 11-41: All xs:import elements that have the same namespace MUST have the same conformance marking via appinfo:externalImportIndicator.</sch:assert>
  </sch:rule>
</sch:pattern>
          </sch:schema>