 ###**MTF XML REFACTOR PROCESS** <p><span>1.&nbsp;&nbsp;</span><span><u>Overview</u>.&nbsp;&nbsp;</span><span>This process is retained for purposes of verification, testing and maintenance.&nbsp;&nbsp;It
      is not necessary for implementers to repeat the effort. &nbsp;This is a work in progress
      so it is recommended to refresh project files from https://github.com/mil-oss/MTFXML
      before execution.</span>.
</p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a.&nbsp;&nbsp;</span><span>The NormalizedSimpleTypes.xsd file was created using a variety of methods which analyze
      and compare Regular Expressions. This required subjective decisions which may be adjusted.
      The XSLT scripts to accomplish this are in the USMTF/XSLT/Normalization/work directory.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b.&nbsp;&nbsp;</span><span>The XSLT scripts to generate the normalized simpleTypes are located in the USMTF/XSLT/Normalization
      directory. Data products are located in the USMTF/XSD/Normalized/work directory.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c.&nbsp;&nbsp;</span><span>The Strings.xsl, Numerics.xsl, and Enumerations.xsl scripts can be executed in any
      order. Results are written to the USMTF/XSD/Normalized directory.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;d.&nbsp;&nbsp;</span><span>The GoE_Fields.xsl script consolidates the Strings.xsd, Integers.xsd, Decimals.xsd
      and Enumerations.xsd files into the GoE_field.xsd document which is stored in the
      USMTF/XSD/GoE_Schema directory.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;e.&nbsp;&nbsp;</span><span><u>Sets Re-factor</u>.&nbsp;&nbsp;</span><span>Sets extend the BaseSetType in order to add the security attribute group at the set
      level.&nbsp;&nbsp;Because fields types are now also extended, they do not need to be extended
      in the Sets Schema, but can be directly referenced or typed.&nbsp;&nbsp;&nbsp;Because nillable elements
      cannot be referenced, they are extended.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;f.&nbsp;&nbsp;</span><span><u>Segments Re-factor</u>.&nbsp;&nbsp;</span><span>Segments are extracted from messages to provide the opportunity for re-use.&nbsp;&nbsp;A new
      Complex Type, SegmentBaseType, is included to insert ICM security attribute group
      and for further Segment level extension.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;g.&nbsp;&nbsp;</span><span>Messages Re-factor</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1)&nbsp;&nbsp;</span><span><u>Element Name Changes</u>.&nbsp;&nbsp;</span><span>One of the goals for the re-factor was to minimize impact on current XML Instance
      documents.&nbsp;&nbsp;In the case of General Text and Heading Information fields the proposed
      change adds field names which are specific to the required content and eliminate the
      need to distinguish XML nodes by appending numbers.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2)&nbsp;&nbsp;</span><span><u>General Text Re-factor</u>.&nbsp;&nbsp;</span><span>This only applies to USMTF.&nbsp;&nbsp;It was implemented in order to include fixed required
      values in the TextIdentification field using XML extension.&nbsp;&nbsp;This eliminates all rules
      specifying these values since they are verified by XML validation.&nbsp;&nbsp;This reduces the
      size of the XML Schema and reduces the additional rules implementation requirement.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(3)&nbsp;&nbsp;</span><span><u>Heading Information Re-factor</u>.&nbsp;&nbsp;</span><span></span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(4)&nbsp;&nbsp;</span><span><u>Message Identification</u>.&nbsp;&nbsp;</span><span>This proposed change adds fixed values to the Message XML Schema in order toallow
      validation of Standard, MessageTextFormatIdentifier, and VersionOfMessageFormat using
      XML validation instead ofrequiring rules.</span></p>
<p><span>2.&nbsp;&nbsp;</span><u>Resources</u></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a.&nbsp;&nbsp;</span><span>Details</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1)&nbsp;&nbsp;</span><span>These are documents created by human analysis of database and XML Schema nodes in
      order to eliminate duplication at the global levels of XML Schema,  normalize XML
      Schema types, and make other changes to annotations and naming.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2)&nbsp;&nbsp;</span><span>Original products have been created as spreadsheets.  XSLT is used to convert XML
      versions of these spreadsheets to XML for further XSLT processing as part of the re-factor.
      The conversion XSLT are dependent on Microsoft XML export from Excel but can be adjusted
      to accomodate any XML format for spreadsheets.  Conversion of Spreadsheets to XML
      is not included in this process.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(3)&nbsp;&nbsp;</span><span>All analysis and proposed changes has been conducted using USMTF.  No process has
      been conducted for NATO MTF.  USMTF changes are applied to NATO MTF where matches
      occur.  USMTF required changes are due to naming conflicts at the global level.  Normalization
      changes are design recommendations which pertain to re-use of fields.  Of note, NATO
      MTF does not require naming de-confliction changes.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(4)&nbsp;&nbsp;</span><span>These changes are subjective and subject to approval by standards bodies.  Adjustments
      to these files will propagate into the final refactored XML Schema.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(5)&nbsp;&nbsp;</span><span>Because these documents are derived from restricted data sources they cannot be made
      publicly available.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b.&nbsp;&nbsp;</span><span>File Organization</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1)&nbsp;&nbsp;</span><span>The public file structure can be downloaded from https://github.com/mil-oss/MTFXML
      as a .zip file and extracted.  Symbolic links must be added as indicated.  Only required
      directories are included.  Generated files are in bold face.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2)&nbsp;&nbsp;</span><span>Public File Orgnanization</span></p>
<div><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(a)&nbsp;&nbsp;</span><span>MTFXML</span></div>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>1</u>.&nbsp;&nbsp;</span><span>USMTF</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>2</u>.&nbsp;&nbsp;</span><span>NATO_MTF</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c.&nbsp;&nbsp;</span><span>Proposed Changes</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1)&nbsp;&nbsp;</span><span>Deconfliction</span></p>
<div><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(a)&nbsp;&nbsp;</span><span>Set Name De-confliction</span></div>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>1</u>.&nbsp;&nbsp;</span><span><u>Spreadsheet</u>.&nbsp;&nbsp;</span><span>MTFXML/USMTF/XSD/Deconflicted/M201503C0VF-Set Deconfliction.xlsx</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>2</u>.&nbsp;&nbsp;</span><span><u>XML Export</u>.&nbsp;&nbsp;</span><span>MTFXML/USMTF/XSD/Deconflicted/Set_DeconflictionEXCEL.xml</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>3</u>.&nbsp;&nbsp;</span><span><u>Conversion XSLT</u>.&nbsp;&nbsp;</span><span>MTFXML/USMTF/XSLT/Deconfliction/SetsSpreadsheetToXML.xsl</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>4</u>.&nbsp;&nbsp;</span><span><u>XML Resource</u>.&nbsp;&nbsp;</span><span>MTFXML/USMTF/XSD/Deconfliction/Set_Name_Changes.xmlMTFXML/NATO_MTF/XSD/Deconfliction/Set_Name_Changes.xml</span></p>
<div><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(b)&nbsp;&nbsp;</span><span>Segment Name De-confliction</span></div>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>1</u>.&nbsp;&nbsp;</span><span><u>Spreadsheet</u>.&nbsp;&nbsp;</span><span>MTFXML/USMTF/XSD/Deconflicted/M2014-10-C0-F Segment Deconfliction.xlsx</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>2</u>.&nbsp;&nbsp;</span><span><u>Conversion XSLT</u>.&nbsp;&nbsp;</span><span>MTFXML/USMTF/XSLT/Deconfliction/SegmentsSpreadsheetToXML.xsl</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>3</u>.&nbsp;&nbsp;</span><span><u>XML Resource</u>.&nbsp;&nbsp;</span><span>MTFXML/USMTF/XSLT/Deconfliction/Segment_Name_Changes.xmlMTFXML/NATO_MTF/XSD/Deconflicted/Set_Name_Changes.xml</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2)&nbsp;&nbsp;</span><span>Normalization</span></p>
<div><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(a)&nbsp;&nbsp;</span><span>Field Normalization proposal is a result of detailed analysis which was not automated.
      This process is not covered in this guidance.  The source proposal and results are
      provided in spreadsheet and XML Schema form.  The NormalizedSimpleTypes.xsd XML Schema
      is used to generate separate files for XSD SimpleTypes which are then used to generate
      the fields.xsd XML Schema.  US and NATO normalizations are largely aligned but there
      are differences based on content.</span></div>
<div><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(b)&nbsp;&nbsp;</span><u>Proposed Field Name Changes Spreadsheet</u>.&nbsp;&nbsp;<span>MTFXML/USMTF/XSD/Normalized/USMC_Proposed_Field_Name_Changes.csv</span></div>
<div><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(c)&nbsp;&nbsp;</span><span>Proposed SimpleType Normalizations</span></div>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>1</u>.&nbsp;&nbsp;</span><span><u>USMTF</u>.&nbsp;&nbsp;</span><span>MTFXML/USMTF/XSD/Normalized/NormalizedSimpleTypes.xsd</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>2</u>.&nbsp;&nbsp;</span><span><u>NATO MTF</u>.&nbsp;&nbsp;</span><span>MTFXML/NATO_MTF/XSD/Normalized/NormalizedSimpleTypes.xsd</span></p>
<p><span>3.&nbsp;&nbsp;</span><u>XSLT Processing</u></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a.&nbsp;&nbsp;</span><span>All XSLT files use XSLT 2.0 xsl:document and xsl:result-document elements to specify
      inputs and outputs instead of requiring that these links be specified at processing
      time.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b.&nbsp;&nbsp;</span><span>To process XSLT using and IDE or command line it is necessary to designate the main
      named template.  This is uniformly named "main" in every XSLT.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c.&nbsp;&nbsp;</span><span>XML Schema, XML resources, and results are all programmed to remain in directories
      which are defined as symbolic links in order to ensure that restricted information
      is not included in the project.  It is important to retain this design.</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;d.&nbsp;&nbsp;</span><span>All processes need to be executed in the specified order because each XSLT is designed
      to consume results of prior XSLT.</span></p>
<p><span>4.&nbsp;&nbsp;</span><u>Refactored USMTF XML Schema Generation</u></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a.&nbsp;&nbsp;</span><span>Generate Changes XML</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1)&nbsp;&nbsp;</span><span>Run XSLT: MTFXML/USMTF/XSLT/Deconfliction/SegmentsSpreadsheetToXML.xsl</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2)&nbsp;&nbsp;</span><span>Run XSLT: MTFXML/USMTF/XSLT/Deconfliction/SetsSpreadsheetToXML.xsl</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b.&nbsp;&nbsp;</span><span>Generate Re-Factor XML Schema</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1)&nbsp;&nbsp;</span><span>Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/NATO_GoE_fields.xsl</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2)&nbsp;&nbsp;</span><span>Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/NATO_GoE_sets.xsl</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(3)&nbsp;&nbsp;</span><span>Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/NATO_GoE_segments.xsl</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(4)&nbsp;&nbsp;</span><span>Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/NATO_GoE_messages.xsl</span></p>
<p><span>5.&nbsp;&nbsp;</span><u>Refactored NATO XML Schema Generation</u></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a.&nbsp;&nbsp;</span><span>Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/GoE_Fields.xsl</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b.&nbsp;&nbsp;</span><span>Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/GoE_Sets.xsl</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c.&nbsp;&nbsp;</span><span>Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/GoE_Segments.xsl</span></p>
<p><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;d.&nbsp;&nbsp;</span><span>Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/GoE_Messages.xsl</span></p>