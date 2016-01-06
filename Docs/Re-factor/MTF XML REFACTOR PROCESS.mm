<map version="freeplane 1.3.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="MTF XML REFACTOR PROCESS" ID="ID_1723255651" CREATED="1283093380553" MODIFIED="1452066193085"><hook NAME="MapStyle">

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node">
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right">
<stylenode LOCALIZED_TEXT="default" MAX_WIDTH="600" COLOR="#000000" STYLE="as_parent">
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.note"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important">
<icon BUILTIN="yes"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="AutomaticEdgeColor" COUNTER="5"/>
<node TEXT="1.  Overview" POSITION="right" ID="ID_755183763" CREATED="1452055299354" MODIFIED="1452057213331"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      This process is retained for purposes of verification, testing and maintenance.&#160;&#160;It is not necessary for implementers to repeat the effort.
    </p>
  </body>
</html>

</richcontent>
<edge COLOR="#0000ff"/>
<node TEXT="a.  The NormalizedSimpleTypes.xsd file was created using a variety of methods which analyze and compare Regular Expressions. This required subjective decisions which may be adjusted. The XSLT scripts to accomplish this are in the USMTF/XSLT/Normalization/work directory." ID="ID_801444743" CREATED="1445639481024" MODIFIED="1452054914477" VSHIFT="-40"/>
<node TEXT="b  The XSLT scripts to generate the normalized simpleTypes are located in the USMTF/XSLT/Normalization directory. Data products are located in the USMTF/XSD/Normalized/work directory." ID="ID_1576488055" CREATED="1445639481024" MODIFIED="1452054919622" VSHIFT="-30"/>
<node TEXT="c  The Strings.xsl, Numerics.xsl, and Enumerations.xsl scripts can be executed in any order. Results are written to the USMTF/XSD/Normalized directory." ID="ID_27694232" CREATED="1445639481024" MODIFIED="1452054921402" HGAP="30" VSHIFT="-30"/>
<node TEXT="d.  The GoE_Fields.xsl script consolidates the Strings.xsd, Integers.xsd, Decimals.xsd and Enumerations.xsd files into the GoE_field.xsd document which is stored in the USMTF/XSD/GoE_Schema directory." ID="ID_1037640678" CREATED="1445639481024" MODIFIED="1452057181163" HGAP="30" VSHIFT="-30"/>
<node TEXT="e.  Sets Re-factor.  Sets extend the BaseSetType in order to add the security attribute group at the set level.  Because fields types are now also extended, they do not need to be extended in the Sets Schema, but can be directly referenced or typed.   Because nillable elements cannot be referenced, they are extended." ID="ID_1626783819" CREATED="1445639481024" MODIFIED="1452055326765" HGAP="30" VSHIFT="-40"/>
<node TEXT="f.  Segments Re-factor.  Segments are extracted from messages to provide the opportunity for re-use.  A new Complex Type, SegmentBaseType, is included to insert ICM security attribute group and for further Segment level extension." ID="ID_1143867056" CREATED="1445639481024" MODIFIED="1445639667079"/>
<node TEXT="g  Messages Re-factor" ID="ID_1347675679" CREATED="1445639481024" MODIFIED="1452055330185" VSHIFT="40">
<node TEXT="1.  Element Name Changes.  One of the goals for the re-factor was to minimize impact on current XML Instance documents.  In the case of General Text and Heading Information fields the proposed change adds field names which are specific to the required content and eliminate the need to distinguish XML nodes by appending numbers." ID="ID_464775862" CREATED="1445639481024" MODIFIED="1445639671094"/>
<node TEXT="2.  General Text Re-factor" ID="ID_1902399333" CREATED="1445639481024" MODIFIED="1452055406247" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      This only applies to USMTF.&#160;&#160;It was implemented in order to include fixed required values in the TextIdentification field using XML extension.&#160;&#160;This eliminates all rules specifying these values since they are verified by XML validation.&#160;&#160;This reduces the size of the XML Schema and reduces the additional rules implementation requirement.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="3.  Heading Information Re-factor" ID="ID_297034551" CREATED="1445639481024" MODIFIED="1452056041332" VSHIFT="20"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    This only applies to USMTF.&#160;&#160;&#160;This proposed change adds descriptive field names which are specific to the required content and eliminate the need to distinguish XML nodes by appending numbers.&#160;&#160;This will affect XML instances and will require mitigation with Baseline XML instances.
  </body>
</html>
</richcontent>
</node>
<node TEXT="4.  Message Identification" ID="ID_463120136" CREATED="1445639481024" MODIFIED="1452056071192" VSHIFT="20"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      This proposed change adds fixed values to the Message XML Schema in order to
    </p>
    <p>
      allow validation of Standard, MessageTextFormatIdentifier, and VersionOfMessageFormat using XML validation instead of
    </p>
    <p>
      requiring rules.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="2.  Resources" POSITION="right" ID="ID_1019827985" CREATED="1452057202943" MODIFIED="1452064435857" VSHIFT="10">
<edge COLOR="#00ff00"/>
<node TEXT="a.  Details" ID="ID_798589553" CREATED="1452057937057" MODIFIED="1452066063632">
<node TEXT="1.  These are documents created by human analysis of database and XML Schema nodes in order to eliminate duplication at the global levels of XML Schema,  normalize XML Schema types, and make other changes to annotations and naming." ID="ID_1030517086" CREATED="1452057523914" MODIFIED="1452058031741"/>
<node TEXT="2.  Original products have been created as spreadsheets.  XSLT is used to convert XML versions of these spreadsheets to XML for further XSLT processing as part of the re-factor.  The conversion XSLT are dependent on Microsoft XML export from Excel but can be adjusted to accomodate any XML format for spreadsheets.  Conversion of Spreadsheets to XML is not included in this process." ID="ID_631041127" CREATED="1452057589227" MODIFIED="1452059160094" VSHIFT="20"/>
<node TEXT="3. All analysis and proposed changes has been conducted using USMTF.  No process has been conducted for NATO MTF.  USMTF changes are applied to NATO MTF where matches occur." ID="ID_1448561967" CREATED="1452058184822" MODIFIED="1452059043633" VSHIFT="20"/>
<node TEXT="3.  These changes are subjective and subject to approval by standards bodies.  Adjustments to these files will propagate into the final refactored XML Schema." ID="ID_641612330" CREATED="1452057564702" MODIFIED="1452058041952" VSHIFT="20"/>
<node TEXT="4.  Because these documents are derived from restricted data sources they cannot be made publicly available." ID="ID_976770940" CREATED="1452057820165" MODIFIED="1452066063631" VSHIFT="-52"/>
</node>
<node TEXT="b.  USMTF Source XML Schema" ID="ID_1723103337" CREATED="1452064406985" MODIFIED="1452065636115" VSHIFT="30">
<node TEXT="(1)  MTFXML/USMTF/XSD/Baseline_Schema/messages.xsd" ID="ID_1675854894" CREATED="1452064495899" MODIFIED="1452064894873"/>
<node TEXT="(2)  MTFXML/USMTF/XSD/Baseline_Schema/sets.xsd" ID="ID_3567093" CREATED="1452064495899" MODIFIED="1452064906917"/>
<node TEXT="(3)  MTFXML/USMTF/XSD/Baseline_Schema/composites.xsd" ID="ID_737296553" CREATED="1452064495899" MODIFIED="1452064909464"/>
<node TEXT="(4)  MTFXML/USMTF/XSD/Baseline_Schema/fields.xsd" ID="ID_387276683" CREATED="1452064495899" MODIFIED="1452064911797"/>
</node>
<node TEXT="c.  Proposed Changes" ID="ID_1404951550" CREATED="1452058006007" MODIFIED="1452065633640" HGAP="30" VSHIFT="50">
<node TEXT="1. Deconfliction" ID="ID_797983520" CREATED="1452058053849" MODIFIED="1452058137799" VSHIFT="-20">
<node TEXT="(a)  Set Name De-confliction" ID="ID_1926053031" CREATED="1452058379901" MODIFIED="1452063721901" VSHIFT="-20">
<node TEXT=" (1) Spreadsheet" ID="ID_457997207" CREATED="1452058627942" MODIFIED="1452063735110"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      MTFXML/USMTF/XSD/Deconflicted/M201503C0VF-Set Deconfliction.xlsx
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="(2) Conversion XSLT" ID="ID_353540863" CREATED="1452058677362" MODIFIED="1452063738048" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      MTFXML/USMTF/XSLT/Deconfliction/SetsSpreadsheetToXML.xsl
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="(3) XML Resource" ID="ID_1469958833" CREATED="1452062764562" MODIFIED="1452064817830"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      MTFXML/USMTF/XSD/Deconfliction/Set_Name_Changes.xml
    </p>
    <p>
      MTFXML/NATO_MTF/XSD/Deconfliction/Set_Name_Changes.xml
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
<node TEXT="(b)  Segment Name De-confliction" ID="ID_1365767823" CREATED="1452058404046" MODIFIED="1452063725909">
<node TEXT=" (1) Spreadsheet" ID="ID_111914636" CREATED="1452058627942" MODIFIED="1452063746525"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      MTFXML/USMTF/XSD/Deconflicted/M2014-10-C0-F Segment Deconfliction.xlsx
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="(2) Conversion XSLT" ID="ID_199055785" CREATED="1452058677362" MODIFIED="1452063748900" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      MTFXML/USMTF/XSLT/Deconfliction/SetsSpreadsheetToXML.xsl
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="(3) XML Resource" ID="ID_1161760396" CREATED="1452062764562" MODIFIED="1452064740142"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      MTFXML/USMTF/XSLT/Deconfliction/Set_Name_Changes.xml
    </p>
    <p>
      MTFXML/NATO_MTF/XSD/Deconflicted/Set_Name_Changes.xml
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
</node>
<node TEXT="2. Normalization" ID="ID_1119709898" CREATED="1452058073587" MODIFIED="1452063552702">
<node TEXT="(a)  Field Normalization proposal is a result of detailed analysis which was not automated.  This process is not covered in this guidance.  The source proposal and results are provided." ID="ID_644784010" CREATED="1452063173424" MODIFIED="1452063442689"/>
<node TEXT="(b) Proposed Field Name Changes Spreadsheet" ID="ID_1219067599" CREATED="1452063344839" MODIFIED="1452063580375" VSHIFT="14"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      MTFXML/USMTF/XSD/Normalized/USMC_Proposed_Field_Name_Changes.csv
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="(c) Proposed SimpleType Normalizations" ID="ID_1614469621" CREATED="1452063467395" MODIFIED="1452063550389" VSHIFT="20">
<node TEXT="(1)  MTFXML/USMTF/XSD/Normalized/Strings.xsd" ID="ID_1922373738" CREATED="1452063527378" MODIFIED="1452063585083"/>
<node TEXT="(2)  MTFXML/USMTF/XSD/Normalized/Decimals.xsd" ID="ID_718295615" CREATED="1452063533966" MODIFIED="1452063613847"/>
<node TEXT="(3)  MTFXML/USMTF/XSD/Normalized/Integers.xsd" ID="ID_733888579" CREATED="1452063536737" MODIFIED="1452063628479"/>
<node TEXT="(4)  MTFXML/USMTF/XSD/Normalized/Enumerations.xsd" ID="ID_1968627914" CREATED="1452063536737" MODIFIED="1452063661257"/>
</node>
</node>
</node>
<node TEXT="d.  NATO MTF Source XML Schema" ID="ID_1142510640" CREATED="1452064406985" MODIFIED="1452065168373" VSHIFT="30"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      NATO MTF XML Schemas are published as separate files per message.&#160;&#160;These are consolidated using XSLT.
    </p>
  </body>
</html>

</richcontent>
<node TEXT="(1) NATO XML Schema Directory" ID="ID_910468589" CREATED="1452064495899" MODIFIED="1452065047576" VSHIFT="-6"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      MTFXML/NATO_MTF/XSD/APP-11C-ch1/Messages
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="(2) Consolidation XSLT" ID="ID_627464929" CREATED="1452064495899" MODIFIED="1452065063945" VSHIFT="34">
<node TEXT="(a)  MTFXML/NATO_MTF/XSLT/APP-11C-ch1/MessageList.xsl" ID="ID_904836734" CREATED="1452065065857" MODIFIED="1452065330429"/>
<node TEXT="(b)  MTFXML/NATO_MTF/XSLT/APP-11C-ch1/ConsolidateMessages.xsl" ID="ID_1349462489" CREATED="1452065065857" MODIFIED="1452065363559"/>
<node TEXT="(c)  MTFXML/NATO_MTF/XSLT/APP-11C-ch1/ConsolidateSets.xsl" ID="ID_360650973" CREATED="1452065065857" MODIFIED="1452065368110"/>
<node TEXT="(d)  MTFXML/NATO_MTF/XSLT/APP-11C-ch1/ConsolidateComposites.xsl" ID="ID_172271627" CREATED="1452065065857" MODIFIED="1452065371594"/>
<node TEXT="(e)  MTFXML/NATO_MTF/XSLT/APP-11C-ch1/ConsolidateFields.xsl" ID="ID_1201588701" CREATED="1452065065857" MODIFIED="1452065374319"/>
</node>
<node TEXT="(3) Consolidated XML Schema" ID="ID_1898050055" CREATED="1452065151542" MODIFIED="1452065168373" VSHIFT="20">
<node TEXT="(a)  MTFXML/NATO_MTF/XSD/APP-11C-ch1/Consolidated/messages.xsd" ID="ID_380369545" CREATED="1452065065857" MODIFIED="1452065449503"/>
<node TEXT="(b)  MTFXML/NATO_MTF/XSD/APP-11C-ch1/Consolidated/sets.xsd" ID="ID_814352281" CREATED="1452065065857" MODIFIED="1452065473546"/>
<node TEXT="(c)  MTFXML/NATO_MTF/XSD/APP-11C-ch1/Consolidated/composites.xsd" ID="ID_824736845" CREATED="1452065065857" MODIFIED="1452065483725"/>
<node TEXT="(d)  MTFXML/NATO_MTF/XSD/APP-11C-ch1/Consolidated/fields.xsd" ID="ID_1202729480" CREATED="1452065065857" MODIFIED="1452065490923"/>
</node>
</node>
</node>
<node TEXT="3.  XSLT Processing" POSITION="right" ID="ID_1168431341" CREATED="1452066189880" MODIFIED="1452066799261" VSHIFT="30">
<edge COLOR="#00ffff"/>
<node TEXT="(a)  All XSLT files use XSLT 2.0 xsl:document and xsl:result-document elements to specify inputs and outputs instead of requiring that these links be specified at processing time." ID="ID_1454212290" CREATED="1452066211891" MODIFIED="1452066897814" VSHIFT="-20"/>
<node TEXT="(c) To process XSLT using and IDE or command line it is necessary to designate the main named template.  This is uniformly named &quot;main&quot; in every XSLT." ID="ID_178065227" CREATED="1452066559480" MODIFIED="1452066799259" VSHIFT="-20"/>
<node TEXT="(d)  XML Schema, XML resources, and results are all programmed to remain in directories which are defined as symbolic links in order to ensure that restricted information is not included in the project.  It is important to retain this design." ID="ID_592650779" CREATED="1452066373730" MODIFIED="1452066929417"/>
<node TEXT="(e)  All processes need to be executed in the specified order because each XSLT is designed to consume results of prior XSLT." ID="ID_983001900" CREATED="1452066952564" MODIFIED="1452067043293"/>
</node>
<node TEXT="3.  Refactored USMTF XML Schema Generation" POSITION="right" ID="ID_1595577374" CREATED="1452057516613" MODIFIED="1452066000044" VSHIFT="30">
<edge COLOR="#ff00ff"/>
<node TEXT="a.  Generate Change Resources" ID="ID_463924320" CREATED="1452065932307" MODIFIED="1452066188522" VSHIFT="-10"/>
<node TEXT="b." ID="ID_1038478486" CREATED="1452065936327" MODIFIED="1452065945398" VSHIFT="20"/>
</node>
<node TEXT="4.  Refactored NATO XML Schema Generation" POSITION="right" ID="ID_1731516315" CREATED="1452057516613" MODIFIED="1452066029420" VSHIFT="30">
<edge COLOR="#ff00ff"/>
<node TEXT="a.  USMTF" ID="ID_1116581390" CREATED="1452065932307" MODIFIED="1452065984634" VSHIFT="-10"/>
<node TEXT="b." ID="ID_367004354" CREATED="1452065936327" MODIFIED="1452065945398" VSHIFT="20"/>
</node>
</node>
</map>
