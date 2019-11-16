<?xml version="1.0" encoding="US-ASCII" standalone="yes"?><sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2">
      <sch:title>Rules for instance XML documents</sch:title>
    
      <xsl:include href="ndr-functions.xsl"/>
    
<sch:ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
<sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
<sch:ns prefix="nf" uri="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#NDRFunctions"/>
<sch:ns prefix="ct" uri="http://release.niem.gov/niem/conformanceTargets/3.0/"/>
<sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
<sch:ns prefix="appinfo" uri="http://release.niem.gov/niem/appinfo/4.0/"/>
<sch:ns prefix="structures" uri="http://release.niem.gov/niem/structures/4.0/"/>
      
<sch:pattern id="rule_12-3"><sch:title>Element has only one resource identifying attribute</sch:title>
  <sch:rule context="*[exists(@structures:id) or exists(@structures:ref) or exists(@structures:uri)]">
    <sch:assert test="count(@structures:id | @structures:ref | @structures:uri) le 1">Rule 12-3: An element MUST NOT have more than one attribute that is structures:id, structures:ref, or structures:uri.</sch:assert>
  </sch:rule>
</sch:pattern>
            
<sch:pattern id="rule_12-4"><sch:title>Attribute structures:ref must reference structures:id</sch:title>
  <sch:rule context="*[@structures:ref]">
    <sch:let name="ref" value="@structures:ref"/>
    <sch:assert test="exists(//*[@structures:id = $ref])">Rule 12-4: The value of an attribute structures:ref MUST match the value of an attribute structures:id of some element in the XML document.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_12-15"><sch:title>Attribute structures:metadata references metadata element</sch:title>
  <sch:rule context="*[exists(@structures:metadata)]">
    <sch:assert test="every $metadata-ref in tokenize(normalize-space(@structures:metadata), ' ') satisfies                         exists(//*[exists(@structures:id[. = $metadata-ref])                                    and ends-with(local-name(), 'Metadata')])">Rule 12-15: Each item in the value of an attribute structures:metadata MUST appear as the value of an attribute structures:id with an owner element that is a metadata element.</sch:assert>
  </sch:rule>
</sch:pattern>
          
<sch:pattern id="rule_12-16"><sch:title>Attribute structures:relationshipMetadata references metadata element</sch:title>
  <sch:rule context="*[exists(@structures:relationshipMetadata)]">
    <sch:assert test="every $metadata-ref in tokenize(normalize-space(@structures:relationshipMetadata), ' ') satisfies                         exists(//*[exists(@structures:id[. = $metadata-ref])                                    and ends-with(local-name(), 'Metadata')])">Rule 12-16: Each item in the value of an attribute structures:relationshipMetadata MUST appear as the value of an attribute structures:id with an owner element that is a metadata element.</sch:assert>
  </sch:rule>
</sch:pattern>
        </sch:schema>