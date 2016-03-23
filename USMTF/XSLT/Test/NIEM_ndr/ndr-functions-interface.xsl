<?xml version="1.0" encoding="UTF-8"?><stylesheet xmlns:impl="http://example.org/naming-and-design-rules-3.0-functions-impl" xmlns:nf="http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#NDRFunctions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <function name="nf:get-document-element" as="element()">
    <param name="context" as="element()"/>
    <sequence select="impl:get-document-element($context)"/>
  </function>

  <!-- Yields:
       if context is a schema
         if there is a target namespace -> xs:anyURI( $namespace )
         if there is no target namespace -> xs:anyURI('')
       otherwise -> ()
  -->
  <function name="nf:get-target-namespace" as="xs:anyURI?">
    <param name="element" as="element()"/>
    <sequence select="impl:get-target-namespace($element)"/>
  </function>

  <!-- Yields:
       if the namespace is found in the catalog, and the first entry has /xs:schema  -> element(xs:schema)
       otherwise -> ()
  -->
  <function name="nf:resolve-namespace" as="element(xs:schema)?">
    <param name="context" as="element()"/>
    <param name="namespace-uri" as="xs:anyURI"/>
    <sequence select="impl:resolve-namespace($context, $namespace-uri)"/>
  </function>

  <!-- Yields:
       if the type resolves -> the first entry of xs:complexType or xs:simpleType
       if not -> ()
  -->
  <function name="nf:resolve-type" as="element()?">
    <param name="context" as="element()"/>
    <param name="qname" as="xs:QName"/>
    <sequence select="impl:resolve-type($context, $qname)"/>
  </function>

  <!-- Yields:
       if the element resolves -> the first xs:element
       if not -> ()
  -->
  <function name="nf:resolve-element" as="element(xs:element)?">
    <param name="context" as="element()"/>
    <param name="qname" as="xs:QName"/>
    <sequence select="impl:resolve-element($context, $qname)"/>
  </function>

  <function name="nf:has-effective-conformance-target-identifier" as="xs:boolean">
    <param name="context" as="element()"/>
    <param name="match" as="xs:anyURI"/>
    <sequence select="impl:has-effective-conformance-target-identifier($context, $match)"/>
  </function>

</stylesheet>