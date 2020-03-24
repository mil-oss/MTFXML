<?xml version="1.0" encoding="US-ASCII" standalone="yes"?><sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
      <sch:title>Rules XML Schema document sets</sch:title>
    
      <xsl:include href="ndr-functions.xsl"/>
    
<sch:ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
<sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
<sch:ns prefix="nf" uri="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#NDRFunctions"/>
<sch:ns prefix="ct" uri="http://release.niem.gov/niem/conformanceTargets/3.0/"/>
<sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
<sch:ns prefix="appinfo" uri="http://release.niem.gov/niem/appinfo/4.0/"/>
<sch:ns prefix="structures" uri="http://release.niem.gov/niem/structures/4.0/"/>
      
<sch:pattern id="rule_9-32"><sch:title>Base type of complex type with complex content must have complex content</sch:title>
  <sch:rule context="xs:complexType[         nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))         or nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument'))       ]/xs:complexContent">
    <sch:assert test="some $derivation in xs:*[self::xs:extension or self::xs:restriction],                            $base-qname in resolve-QName($derivation/@base, $derivation),                            $base-type in nf:resolve-type($derivation, $base-qname) satisfies                          empty($base-type/self::xs:complexType/xs:simpleContent)">Rule 9-32: The base type of complex type that has complex content MUST have complex content.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-12"><sch:title>External adapter type not a base type</sch:title>
  <sch:rule context="xs:*[(self::xs:extension or self::xs:restriction)                           and (nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))                                or nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument')))                           and (some $base-qname in resolve-QName(@base, .),                                     $base-namespace in namespace-uri-from-QName($base-qname) satisfies                                  not($base-namespace = (nf:get-target-namespace(.), xs:anyURI('http://www.w3.org/2001/XMLSchema'))))]">
    <sch:assert test="nf:resolve-type(., resolve-QName(@base, .))[                         empty(@appinfo:externalAdapterTypeIndicator)]">Rule 10-12: An external adapter type definition MUST NOT be a base type definition.</sch:assert>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_10-72"><sch:title>appinfo:appliesToTypes references types</sch:title>
  <sch:rule context="*[exists(@appinfo:appliesToTypes)]">
    <sch:assert test="every $item in tokenize(normalize-space(@appinfo:appliesToTypes), ' ') satisfies                         exists(nf:resolve-type(., resolve-QName($item, .)))">Rule 10-72: Every item in @appinfo:appliesToTypes MUST resolve to a type.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_10-74"><sch:title>appinfo:appliesToElements references elements</sch:title>
  <sch:rule context="*[exists(@appinfo:appliesToElements)]">
    <sch:assert test="every $item in tokenize(normalize-space(@appinfo:appliesToElements), ' ') satisfies                         count(nf:resolve-element(., resolve-QName($item, .))) = 1">Rule 10-74: Every item in @appinfo:appliesToElements MUST resolve to an element.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_11-15"><sch:title>Name of element declaration with simple content has representation term</sch:title>
  <sch:rule context="xs:element[@name and @type        and (nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))             or nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument')))        and (some $type-qname in resolve-QName(@type, .) satisfies (               nf:get-target-namespace(.) != namespace-uri-from-QName($type-qname)               and nf:resolve-type(., $type-qname)/xs:simpleContent))]">
    <sch:report role="warning" test="every $representation-term               in ('Amount', 'BinaryObject', 'Graphic', 'Picture', 'Sound', 'Video', 'Code', 'DateTime', 'Date', 'Time', 'Duration', 'ID', 'URI', 'Indicator', 'Measure', 'Numeric', 'Value', 'Rate', 'Percent', 'Quantity', 'Text', 'Name', 'List')               satisfies not(ends-with(@name, $representation-term))">Rule 11-15: the name of an element declaration that is of simple content SHOULD use a representation term.</sch:report>
  </sch:rule>
</sch:pattern>
              
<sch:pattern id="rule_11-48"><sch:title>Reference schema document imports reference schema document</sch:title>
  <sch:rule context="xs:import[                          nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))                          and exists(@namespace)                          and empty(@appinfo:externalImportIndicator)                          and not(xs:anyURI(@namespace) = (xs:anyURI('http://release.niem.gov/niem/structures/4.0/'),                                                           xs:anyURI('http://www.w3.org/XML/1998/namespace')))]">
    <sch:assert test="some $schema in nf:resolve-namespace(., @namespace) satisfies                         nf:has-effective-conformance-target-identifier($schema, xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))">Rule 11-48: A namespace imported as conformant from a reference schema document MUST identify a namespace defined by a reference schema document.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_11-49"><sch:title>Extension schema document imports reference or extension schema document</sch:title>
  <sch:rule context="xs:import[                          nf:has-effective-conformance-target-identifier(., xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument'))                          and exists(@namespace)                          and empty(@appinfo:externalImportIndicator)                          and not(xs:anyURI(@namespace) = (xs:anyURI('http://release.niem.gov/niem/structures/4.0/'),                                                           xs:anyURI('http://www.w3.org/XML/1998/namespace')))]">
    <sch:assert test="some $schema in nf:resolve-namespace(., @namespace) satisfies (                         nf:has-effective-conformance-target-identifier($schema, xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument'))                         or nf:has-effective-conformance-target-identifier($schema, xs:anyURI('http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ExtensionSchemaDocument')))">Rule 11-49: A namespace imported as conformant from an extension schema document MUST identify a namespace defined by a reference schema document or an extension schema document.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_11-52"><sch:title>Each namespace may have only a single root schema in a schema set</sch:title>
  <sch:rule context="xs:schema[exists(@targetNamespace)                                and (some $element                                    in nf:resolve-namespace(., xs:anyURI(@targetNamespace))                                    satisfies $element is .)]">
    <sch:assert test="count(nf:resolve-namespace(., xs:anyURI(@targetNamespace))) = 1">Rule 11-52: A namespace may appear as a root schema in a schema set only once.</sch:assert>
  </sch:rule>
</sch:pattern>
          </sch:schema>