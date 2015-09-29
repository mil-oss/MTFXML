NATO MTF GARDEN OF EDEN XML SCHEMA CONVERSION

This project uses XSLT scripts to convert NATO MTF XML Schemas provided as individual per-message collections into 3 consolidated XML Schemas which follow the "Garden of Eden" design pattern which uses global elements which can be readily referenced for implementation of NATO MTF messages and for use in Information Exchanges with non NATO MTF message systems.

All XSLT are v 2.0.  Schemas must be generated in the given order for required refrences to be created.
 
 PROCESS:
 
1. Generate the /XML/MessageList.xml file using /XSLT/MessageList.xsl
 
2. Generate the /XSD/fields.xsd file using /XSLT/ConsolidateFields.xsl
 
3. Generate the /XSD/composites.xsd file using /XSLT/ConsolidateComposites.xsl
  
4. Generate the /XSD/sets.xsd file using /XSLT/ConsolidateSets.xsl
   
5. Generate the /XSD/messages.xsd file using /XSLT/ConsolidateMessages.xsl