<?xml version="1.0" encoding="UTF-8"?>
<schema 
   queryBinding="xslt2"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://purl.oclc.org/dsdl/schematron">

  <title>Assertions about CTAS-Conformant Documents</title>

  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <ns prefix="ctas" uri="http://release.niem.gov/niem/conformanceTargets/3.0/"/>
  <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>

  <pattern>
    <rule context="*[exists(@ctas:*[local-name() != 'conformanceTargets'])]">
      <assert test="false()">Bad attribute (by CTAS rule 3-3: A conformant document MUST NOT contain any element or attribute information item that has the namespace name http://release.niem.gov/conformanceTargets/3.0/, other than attribute {http://release.niem.gov/conformanceTargets/3.0/}conformanceTargets).</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="ctas:*">
      <assert test="false()">Bad element (by CTAS rule 3-3: A conformant document MUST NOT contain any element or attribute information item that has the namespace name http://release.niem.gov/conformanceTargets/3.0/, other than attribute {http://release.niem.gov/conformanceTargets/3.0/}conformanceTargets).</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="*[exists(@xsi:type['http://release.niem.gov/niem/conformanceTargets/3.0/' = namespace-uri-from-QName(resolve-QName(., ..))])]">
      <assert test="false()">Bad xsi:type attribute (by CTAS rule 3-4: A conformant document MUST NOT contain an attribute {http://www.w3.org/2001/XMLSchema-instance}type with a value that has a namespace name of http://release.niem.gov/conformanceTargets/3.0/).</assert>
      </rule>
  </pattern>

</schema>
