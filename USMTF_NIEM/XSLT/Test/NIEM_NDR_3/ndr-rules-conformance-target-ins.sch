<?xml version="1.0" encoding="US-ASCII" standalone="yes"?><sch:schema xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"><sch:title>Rules for instance XML documents</sch:title><xsl:include href="ndr-functions.xsl"/>
<sch:ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
<sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
<sch:ns prefix="nf" uri="http://reference.niem.gov/niem/specification/naming-and-design-rules/3.0/#NDRFunctions"/>
<sch:ns prefix="ct" uri="http://release.niem.gov/niem/conformanceTargets/3.0/"/>
<sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
<sch:ns prefix="appinfo" uri="http://release.niem.gov/niem/appinfo/3.0/"/>
<sch:ns prefix="structures" uri="http://release.niem.gov/niem/structures/3.0/"/>
<sch:ns prefix="term" uri="http://release.niem.gov/niem/localTerminology/3.0/"/>
      
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
        
<sch:pattern id="rule_12-2"><sch:title>Element with structures:ref does not have content</sch:title>
  <sch:rule context="*[@structures:ref]">
    <sch:assert test="empty(element() | text())">Rule 12-2: An element that has attribute structures:ref MUST NOT have element or text content.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_12-3"><sch:title>Attribute structures:ref must reference structures:id</sch:title>
  <sch:rule context="*[@structures:ref]">
    <sch:let name="ref" value="@structures:ref"/>
    <sch:assert test="exists(//*[@structures:id = $ref])">Rule 12-3: The value of an attribute structures:ref MUST match the value of an attribute structures:id of some element in the XML document.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_12-13"><sch:title>Attribute structures:metadata references metadata element</sch:title>
  <sch:rule context="*[exists(@structures:metadata)]">
    <sch:assert test="every $metadata-ref in tokenize(normalize-space(@structures:metadata), ' ') satisfies                         exists(//*[exists(@structures:id[. = $metadata-ref])                                    and ends-with(local-name(), 'Metadata')])">Rule 12-13: Each item in the value of an attribute structures:metadata MUST appear as the value of an attribute structures:id with an owner element that is a metadata element.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_12-14"><sch:title>Attribute structures:relationshipMetadata references metadata element</sch:title>
  <sch:rule context="*[exists(@structures:relationshipMetadata)]">
    <sch:assert test="every $metadata-ref in tokenize(normalize-space(@structures:relationshipMetadata), ' ') satisfies                         exists(//*[exists(@structures:id[. = $metadata-ref])                                    and ends-with(local-name(), 'Metadata')])">Rule 12-14: Each item in the value of an attribute structures:relationshipMetadata MUST appear as the value of an attribute structures:id with an owner element that is a metadata element.</sch:assert>
  </sch:rule>
</sch:pattern>
        </sch:schema>