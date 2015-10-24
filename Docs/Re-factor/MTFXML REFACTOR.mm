<map version="freeplane 1.3.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="MTFXML REFACTOR" ID="ID_1723255651" CREATED="1283093380553" MODIFIED="1445639330806"><hook NAME="MapStyle">

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
<hook NAME="AutomaticEdgeColor" COUNTER="10"/>
<node TEXT="Background" POSITION="right" ID="ID_396111513" CREATED="1444853751150" MODIFIED="1445457338623" HGAP="30">
<edge COLOR="#ff00ff"/>
<node TEXT="The current XML Schema for US and NATO MTF are designed for piecemeal implementation of messages based on commonly defined XML nodes which are maintained in relational databases.  This makes normalization, re-use, and configuration management difficult." ID="ID_199156720" CREATED="1444853786014" MODIFIED="1445284302206" VSHIFT="-10"/>
<node TEXT="Because the current XML Schema design does not support implementation of the entire standard, there are persistent mismatches of messages implemented and versions across systems." ID="ID_1369603701" CREATED="1444854247374" MODIFIED="1444855622928" VSHIFT="-20"/>
<node TEXT="The re-factor of these standards to a Garden of Eden XML Schema Design model allows provisioning of consolidated XML Schema files with a manageable sizes to allow complete implementation of every message using a uniform and re-usable methodology." ID="ID_1109438859" CREATED="1444854148350" MODIFIED="1444856917664" VSHIFT="-10"/>
<node TEXT="Alignment with the US National Information Exchange Model (NIEM) methodology will allow the development and re-use of stndardized Information Exchange Product Documentation (IEPD) resources which will support valid implementations and promote interoperability with external specifications." ID="ID_1320508699" CREATED="1444854467693" MODIFIED="1444855633989" VSHIFT="10"/>
</node>
<node TEXT="Goals" POSITION="right" ID="ID_1741486495" CREATED="1444855666639" MODIFIED="1445457334535" HGAP="30" VSHIFT="20">
<edge COLOR="#00ffff"/>
<node TEXT="This project will use the Extensible Stylesheet Language for Transformation (XSLT) to convert existing XML Schema products to Garden of Eden design pattern, and will reduce file sizes by normalizing Types, using attributes in annotation elements, and applying fixed values where appropriate to reduce ambiguity and eliminate rules which specify required content." ID="ID_274447430" CREATED="1444855680286" MODIFIED="1445284452340" VSHIFT="-20"/>
<node TEXT="The resulting XML Schema products will support all requirements for the text based slash delimited MTF format, and will avoid alteration of XML element names except where absolutely necessary for naming deconfliction of global nodes.  Except for a few cases, XML instances from the current standard will validate against the re-factored XML Schemas if common namespaces are assigned." ID="ID_64571144" CREATED="1444855955886" MODIFIED="1445284450554" HGAP="30" VSHIFT="-10"/>
<node TEXT="This project is intended to support holistic implementation of the standards in order to facilitate use in web services, allow conversion between US and NATO specification, conversion between message versions, and interoperability with other standard formats." ID="ID_589380055" CREATED="1444856263166" MODIFIED="1445284448672" VSHIFT="-10"/>
</node>
<node TEXT="Usage" POSITION="right" ID="ID_1638087420" CREATED="1444856923121" MODIFIED="1445457336245" HGAP="30" VSHIFT="30">
<edge COLOR="#ffff00"/>
<node TEXT="The process for converting from current standard formats is provided for purposes of integrity, testing and verification.  For most use cases, the generated XML Schemas can be used without repeating this conversion." ID="ID_226841617" CREATED="1444856932239" MODIFIED="1444857188442" VSHIFT="-20"/>
<node TEXT="Reference implementation products are intended for re-use and distribution in order to promote interoperability and uniformity in implementations.  These products should load the provided re-factored XML Schemas and provide intended MTF messaging functionality for every message and message component." ID="ID_1184157034" CREATED="1444857042207" MODIFIED="1444857227178"/>
</node>
<node TEXT="Caveats" POSITION="right" ID="ID_98871154" CREATED="1444857235839" MODIFIED="1445639330805" HGAP="30" VSHIFT="30">
<edge COLOR="#7c0000"/>
<node TEXT="All data resources are restricted for distribution.  This requires complete separation of presentation and data.  No implementations may retain data from the XML Schema resources in code.  For this reason, all samples supporting this documentation must be provided separately." ID="ID_996714687" CREATED="1444857241999" MODIFIED="1445457662175" VSHIFT="20"/>
<node TEXT="Alteration or further re-factoring of the provided XML Schema must implement new namespace assignments." ID="ID_1920187984" CREATED="1444857468671" MODIFIED="1444857550443" VSHIFT="10"/>
<node TEXT="Because US and NATO specifications are closely aligned, all products are very similar and can often be re-used interchangeably.  Differences occur, so for purposes of clarity and distribution they are provided separately with each standard." ID="ID_597604512" CREATED="1444857598111" MODIFIED="1445457720365" VSHIFT="-40"/>
</node>
<node TEXT="USMTF XML Schema Design" POSITION="right" ID="ID_810225239" CREATED="1445035293775" MODIFIED="1445458674089" HGAP="30">
<edge COLOR="#00007c"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Adjustments are made to the format of all XML Schemas in order to reduce size, and eliminate redundant or unnecessary information.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="Annotations" ID="ID_1750708290" CREATED="1445035672879" MODIFIED="1445457598060">
<node TEXT="Content of xsd:annotations is converted from elements to attributes in order to reduce size caused by closing tags.  Names are changed to plain language terms instead of database field names.  Elements are used for multiple items." ID="ID_1323541666" CREATED="1445035684847" MODIFIED="1445284310321" HGAP="30" VSHIFT="80"/>
<node TEXT="When xsd:documentation and asd:appinfo items are duplicative, the information is retained in the xsd:documentation node and removed from the xsd;appinfo node." ID="ID_686135295" CREATED="1445037472232" MODIFIED="1445457598056" HGAP="30" VSHIFT="-80"/>
</node>
<node TEXT="Field Base Types" ID="ID_392965696" CREATED="1445370811628" MODIFIED="1445375733842">
<node TEXT="The requirement to apply security markings to every field is currently accomplished by extending xsd:simpleType fields at the Set level to add the ICM attribute group.  This reduces the ability to reference fields at the Set level and causes unnecessary repetition in the XML Schema design." ID="ID_719629895" CREATED="1445370877548" MODIFIED="1445375733837" VSHIFT="-20"/>
<node TEXT="The Re-Factor approach is to create FieldBaseTypes which carry the ICM attribute group and can be used to add other field level extensions.  All fields are provided as xsd:complexTypes which extend the base types.  This typing methodology separates FIelds into data categories that have respectively uniform processing requirements and can be extended or restricted accordingly." ID="ID_1668263500" CREATED="1445371057357" MODIFIED="1445371737730">
<node TEXT="FieldStringBaseType" ID="ID_1633830116" CREATED="1445371373153" MODIFIED="1445375711106" VSHIFT="10">
<node TEXT="&lt;xsd:complexType name=&quot;FieldStringBaseType&quot;&gt;&#xa;      &lt;xsd:simpleContent&gt;&#xa;         &lt;xsd:extension base=&quot;xsd:string&quot;&gt;&#xa;            &lt;xsd:attributeGroup ref=&quot;ism:SecurityAttributesOptionGroup&quot;/&gt;&#xa;         &lt;/xsd:extension&gt;&#xa;      &lt;/xsd:simpleContent&gt;&#xa;   &lt;/xsd:complexType&gt;" ID="ID_154209698" CREATED="1445371205645" MODIFIED="1445375470478" HGAP="30" VSHIFT="-10"/>
</node>
<node TEXT="FieldEnumeratedBaseType" ID="ID_1795967299" CREATED="1445371373153" MODIFIED="1445373558687" VSHIFT="30">
<node TEXT="&lt;xsd:complexType name=&quot;FieldEnumeratedBaseType&quot;&gt;&#xa;      &lt;xsd:simpleContent&gt;&#xa;         &lt;xsd:extension base=&quot;xsd:string&quot;&gt;&#xa;            &lt;xsd:attributeGroup ref=&quot;ism:SecurityAttributesOptionGroup&quot;/&gt;&#xa;         &lt;/xsd:extension&gt;&#xa; &lt;/xsd:simpleContent&gt;" ID="ID_1653855346" CREATED="1445371205645" MODIFIED="1445375014840" VSHIFT="-20"/>
</node>
<node TEXT="FieldIntegerBaseType" ID="ID_175990284" CREATED="1445371373153" MODIFIED="1445371431140" VSHIFT="30">
<node TEXT="&lt;xsd:complexType name=&quot;FieldIntegerBaseType&quot;&gt;&#xa;      &lt;xsd:simpleContent&gt;&#xa;         &lt;xsd:extension base=&quot;xsd:integer&quot;&gt;&#xa;            &lt;xsd:attributeGroup ref=&quot;ism:SecurityAttributesOptionGroup&quot;/&gt;&#xa;         &lt;/xsd:extension&gt;&#xa;      &lt;/xsd:simpleContent&gt;&#xa;   &lt;/xsd:complexType&gt;" ID="ID_1397746145" CREATED="1445371205645" MODIFIED="1445371478791"/>
</node>
<node TEXT="FieldDecimalBaseType" ID="ID_865962864" CREATED="1445371373153" MODIFIED="1445371489941" VSHIFT="30">
<node TEXT="&lt;xsd:complexType name=&quot;FieldIntegerBaseType&quot;&gt;&#xa;      &lt;xsd:simpleContent&gt;&#xa;         &lt;xsd:extension base=&quot;xsd:integer&quot;&gt;&#xa;            &lt;xsd:attributeGroup ref=&quot;ism:SecurityAttributesOptionGroup&quot;/&gt;&#xa;         &lt;/xsd:extension&gt;&#xa;      &lt;/xsd:simpleContent&gt;&#xa;   &lt;/xsd:complexType&gt;" ID="ID_512605430" CREATED="1445371205645" MODIFIED="1445371478791"/>
</node>
</node>
</node>
<node TEXT="Fields Refactor" ID="ID_367208974" CREATED="1445375606297" MODIFIED="1445401138456">
<node TEXT="Strings" ID="ID_588492347" CREATED="1445375806285" MODIFIED="1445457228030" HGAP="30" VSHIFT="-40"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      By comparing Regular Expressions the number of types extended by FieldStringBase Type is&#160;&#160;reduced.&#160;&#160;Types which include length and value restrictions in the Regular Expression are removed.&#160;&#160;String types are defined using xsd:pattern for content, and XML Schema nodes to specify lengths at the element level.&#160;&#160;For example, the field:AlphaNumericBlankSpecialTextType is re-used 877 times, thereby eliminating and re-using this duplicative definition.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Enumerations" ID="ID_1437957964" CREATED="1445375811577" MODIFIED="1445457229213" HGAP="30" VSHIFT="-40"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Enumerations are normalized using common code lists.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Integers" ID="ID_380764250" CREATED="1445375815209" MODIFIED="1445457230565"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Integers do not require Regular Expressions or types.&#160;&#160;the XML Schema xsd:integer is extended by FieldIntegerBaseType to include security markings, and each Integer field restricts FieldIntegerBaseType to add value restrictions.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Decimals" ID="ID_1282382012" CREATED="1445375818233" MODIFIED="1445457232293" VSHIFT="20"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Decimals do not require Regular Expressions or types.&#160;&#160;the XML Schema xsd:decimal is extended by FieldIntegerBaseType to include security markings, and each Decimal field restricts FieldDecimalBaseType to add value restrictions.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Normalization" ID="ID_520682973" CREATED="1445034575308" MODIFIED="1445457095402" VSHIFT="20">
<node TEXT="Rationale" ID="ID_1934291471" CREATED="1445036249106" MODIFIED="1445036302068" VSHIFT="70">
<node TEXT="The creation of a &quot;Type&quot; for every field in MTF simply by adding &quot;Type&quot; or &quot;SimpleType&quot; to each field name does not leverage the concept of Typing appropriately.  Many fields have identical content restrictions." ID="ID_1984290996" CREATED="1445035980975" MODIFIED="1445036293806" VSHIFT="-20"/>
<node TEXT="By comparing regular expressions, numerical content, and enumerations the number of xsd:simpleTypes are significantly reduced and the XML implementation of the MIL STDs employs reuse, extension and restriction effectively." ID="ID_1350623549" CREATED="1445036280658" MODIFIED="1445036281810"/>
<node TEXT="BaseTypes are implemented at the field level to serve the requirement to be able to add security markings at the field level.  The Baseline XML Schema accomplish this at the Set level which requires extension for every field each time it is used." ID="ID_919087704" CREATED="1445036420100" MODIFIED="1445036871924" VSHIFT="-26"/>
<node TEXT="The implementation of FieldStringBaseType, Field EnumerationBaseType, FieldIntegerBaseType, and FieldIntegerBaseType allow fields to be re-used by referencing instead of extension except where they have the nillable attribute.  This significantly reduces the size of the XML Schema files." ID="ID_236763277" CREATED="1445036563314" MODIFIED="1445036867436"/>
<node TEXT="BaseTypes also provide the opportunity for additional extensions which can be applied at the field level when they are re-used externally or when the MIL STD requirements dictates such an adjustment." ID="ID_1104095164" CREATED="1445036735475" MODIFIED="1445036869173" VSHIFT="20"/>
</node>
<node TEXT="Strings" ID="ID_344351083" CREATED="1445035980978" MODIFIED="1445036212794">
<node TEXT="Regular Expression Comparison" ID="ID_1934849309" CREATED="1445035980985" MODIFIED="1445036124979" VSHIFT="-50">
<node TEXT="Fields with identical regular expresssions (REGEX) exclusive of length can be assigend common xsd:simpleTypes.  Length restrictions are applied at the element level." ID="ID_376684320" CREATED="1445035980985" MODIFIED="1445036124975" VSHIFT="-10"/>
<node TEXT="The NormlizedSimpleTypes.xsd has been created based on analysis to determine common REGEX categories for re-use.  The Stingse.xsl applies these types to simpleTypes with min and max length restrictions removed in order to generate Elements with common types.  Min and max are assigned at the element level." ID="ID_682476621" CREATED="1445035980985" MODIFIED="1445036099770"/>
</node>
<node TEXT="FreeText simplification" ID="ID_1708985859" CREATED="1445035980985" MODIFIED="1445036108011">
<node TEXT="The baseline XML Schema defines field:FreeTextType using an xsd:complexType which extends a xsd:simpleType in order to include the xsd:space attribute which can be used or preserve whitespace or not.  This is not used anywhere in the standard.  If it were to be used - it can be applied by extension in that case." ID="ID_1525872726" CREATED="1445035980985" MODIFIED="1445036108006" HGAP="30" VSHIFT="-40"/>
<node TEXT="The Strings.xsl replaces all uses of FreeTextType with the normalized AlphaNumericSpecialFreeTextSimpleType, and generates the FreeText element which has this type." ID="ID_1231843799" CREATED="1445035980985" MODIFIED="1445036038187"/>
</node>
<node TEXT="BlankSpace simplification" ID="ID_1791807237" CREATED="1445035980985" MODIFIED="1445036118017" VSHIFT="50">
<node TEXT="The baseline XML Schema defines BlankSpaceCharacterType using a complexType which extends a simpleType in order to include the xsd:space attribute which can be used or preserve whitespace or not.  This is not used anywhere in the standard.  If it were to be used - it can be applied by extension in that case." ID="ID_1771771810" CREATED="1445035980985" MODIFIED="1445036116146" VSHIFT="-50"/>
<node TEXT="The Strings.xsl replaces all uses of BlankSpaceCharacterType with a BlankSpaceSimpleType, and generates the BlankSpace element which has this type." ID="ID_1728855240" CREATED="1445035980985" MODIFIED="1445036118013" VSHIFT="10"/>
</node>
</node>
<node TEXT="Enumerations" ID="ID_1068069523" CREATED="1445035980985" MODIFIED="1445457089606"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The NormlizedSimpleTypes.xsd has been created based on analysis to determine reusable enumeration sets.&#160;&#160;The Enumerations.xsl applies these types to elements when content is equivalent, and include annotations at the element level.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Numerics" ID="ID_1333327536" CREATED="1445035980987" MODIFIED="1445457095400" VSHIFT="30">
<node TEXT="Integers" ID="ID_985868689" CREATED="1445035980988" MODIFIED="1445036168792">
<node TEXT="The use of xsd:simpleTypes for integers serves no purpose since XML Schema provides all means necessary to describe and validate integer content." ID="ID_9681461" CREATED="1445035980988" MODIFIED="1445457125648"/>
<node TEXT="Numerics.xsl converts all xsd:simpleTypes with xsd:decimal restrictions to elements." ID="ID_1410742524" CREATED="1445035980988" MODIFIED="1445036182221"/>
</node>
<node TEXT="Decimals" ID="ID_1496953844" CREATED="1445035980988" MODIFIED="1445036172648">
<node TEXT="The use of xsd:simpleTypes for decimals serves no purpose since XML Schema provides all means necessary to describe and validate decimal content." ID="ID_36320522" CREATED="1445035980988" MODIFIED="1445036184952"/>
<node TEXT="Numerics.xsl converts all xsd:simpleTypes with xsd:integer restrictions to elements." ID="ID_1328570272" CREATED="1445035980988" MODIFIED="1445036190013"/>
</node>
</node>
<node TEXT="Summary." ID="ID_1076519237" CREATED="1445035980988" MODIFIED="1445036383426" VSHIFT="-80">
<node TEXT="String type normalization reduces the number of string xsd:simpleTypes from 1624 to 153 without impacting message content." ID="ID_361180251" CREATED="1445035980988" MODIFIED="1445036193372"/>
<node TEXT="Enumeration normalization reduces the number of enumerated xsd:simpleTypes from 1766 to 1473 without impacting message content." ID="ID_1405688239" CREATED="1445035980988" MODIFIED="1445036195985"/>
<node TEXT="Numeric normalization eliminates 1337 integer xsd:simpleTypes and 245 decimal xsd:simpleTypes." ID="ID_522866828" CREATED="1445035980988" MODIFIED="1445036197665"/>
</node>
</node>
<node TEXT="Process" ID="ID_137274626" CREATED="1445035252766" MODIFIED="1445457273699" VSHIFT="-10"><richcontent TYPE="DETAILS">

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
<node TEXT="The NormalizedSimpleTypes.xd file was created using a variety of methods which analyse and compare Regular Expressions.  This required subjective decisions which may be adjusted.  The XSLT scripts to accomplish this are in the USMTF/XSLT/Normalization/work directory." ID="ID_1804333818" CREATED="1445034597811" MODIFIED="1445035234191"/>
<node TEXT="The XSLT scripts to generate the normalized xsd:simpleTypes are located in the USMTF/XSLT/Normalization directory.  Data products are located in the USMTF/XSD/Normlaized/work directory." ID="ID_1608214864" CREATED="1445034741804" MODIFIED="1445035056339"/>
<node TEXT="The Strings.xsl, Numerics.xsl, and Enumerations.xsl scripts can be executed in any order.  Results are written to the USMTF/XSD/Normlaized directory." ID="ID_157188162" CREATED="1445034887757" MODIFIED="1445034989675"/>
<node TEXT="The GoE_Fields.xsl script consolidates the Strings.xsd, Integers.xsd, Decimals.xsd and Enumerations.xsd files into the GoE_field.xsd document which is stored in the USMTF/XSD/GoE_Schema directory." ID="ID_272052222" CREATED="1445035058942" MODIFIED="1445035190910"/>
</node>
</node>
<node TEXT="Sets Refactor" ID="ID_841286324" CREATED="1445401131593" MODIFIED="1445457999306" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Sets extend the BaseSetType in order to add the security attribute group at the set level.&#160;&#160;Because fields types are now also extended, they do not need to be extended in the Sets Schema, but can be directly referenced or typed.&#160;&#160;&#160;Because nillable elements cannot be referenced, they are extended.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Segments Refactor" ID="ID_142376675" CREATED="1445401131593" MODIFIED="1445458048783" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Segments are extracted from messages to provide the opportunity for re-use.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Messages Refactor" ID="ID_913438226" CREATED="1445458053876" MODIFIED="1445458075975">
<node TEXT="Element Name Changes" ID="ID_1171916047" CREATED="1445457351750" MODIFIED="1445458075973" VSHIFT="20"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      One of the goals for the re-factor was to minimize impact on current XML Instance documents.&#160;&#160;In the case of General Text and Heading Information fields the proposed change adds field names which are specific to the required content and eliminate the need to distinguish XML nodes by appending numbers.&#160;&#160;The list of proposed changes is provided in attached restricted material.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="General Text Refactor" ID="ID_356849527" CREATED="1445458077940" MODIFIED="1445458086113"/>
<node TEXT="Heading Information Refactor" ID="ID_1586742814" CREATED="1445458086580" MODIFIED="1445458094961"/>
<node TEXT="Message Identification" ID="ID_1194973068" CREATED="1445458096340" MODIFIED="1445458121819"/>
</node>
</node>
<node TEXT="NATO MTF  XML Schema Design" POSITION="right" ID="ID_1396388343" CREATED="1444842280471" MODIFIED="1445638890106" HGAP="50" VSHIFT="-350">
<edge COLOR="#0000ff"/>
<node TEXT="Element Name Changes" ID="ID_899081510" CREATED="1444842303529" MODIFIED="1445458141690" VSHIFT="40"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The only two naming conflicts which occurred will require Element name changes impacting XML instances and are provided in attached restricted material.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="composite: DutyOther" ID="ID_412615499" CREATED="1444842377384" MODIFIED="1444842592507" VSHIFT="-30">
<node TEXT="name=&apos;DutyOtherCode&apos;" ID="ID_1684602174" CREATED="1444842521003" MODIFIED="1444842590027" VSHIFT="-20"/>
<node TEXT="type=&apos;DutyOtherCodeType&apos;" ID="ID_1719537331" CREATED="1444842546330" MODIFIED="1444842592507" VSHIFT="20"/>
</node>
<node TEXT="composite: QRoutePointDesignatorType" ID="ID_196619321" CREATED="1444842447758" MODIFIED="1444842516915">
<node TEXT="name=&apos;DQRoutePointCode&apos;" ID="ID_1094196049" CREATED="1444842521003" MODIFIED="1444842613496" VSHIFT="-20"/>
<node TEXT="type=&apos;QRoutePointCodeType&apos;" ID="ID_1764706316" CREATED="1444842546330" MODIFIED="1444842625453" VSHIFT="20"/>
</node>
</node>
</node>
<node TEXT="Current Paper" POSITION="right" ID="ID_205345619" CREATED="1445638910795" MODIFIED="1445639216317">
<edge COLOR="#7c007c"/>
<node TEXT="1.        Background" ID="ID_1436650638" CREATED="1445638953298" MODIFIED="1445638953298">
<node TEXT="a.        The current XML Schema for US and NATO MTF are designed for piecemeal implementation of messages based on commonly defined XML nodes which are maintained in relational databases. This makes normalization, re-use, and configuration management difficult.  Because the current XML Schema design does not support implementation of the entire standard, there are persistent mismatches of messages implemented and versions across systems." ID="ID_1018463361" CREATED="1445638953298" MODIFIED="1445638953298"/>
<node TEXT="c.        The re-factor of these standards to a Garden of Eden XML Schema Design model allows provisioning of consolidated XML Schema files with a manageable sizes to allow complete implementation of every message using a uniform and re-usable methodology.  Alignment with the US National Information Exchange Model (NIEM) methodology will allow the development and re-use of standardized Information Exchange Product Documentation (IEPD) resources which will support valid implementations and promote interoperability with external specifications." ID="ID_1051985515" CREATED="1445638953298" MODIFIED="1445638953298"/>
</node>
<node TEXT="2.        Goals" ID="ID_262114409" CREATED="1445638953298" MODIFIED="1445638953298">
<node TEXT="a.        This project will use the Extensible Style-sheet Language for Transformation (XSLT) to convert existing XML Schema products to Garden of Eden design pattern, and will reduce file sizes by normalizing Types, using attributes in annotation elements, and applying fixed values where appropriate to reduce ambiguity and eliminate rules which specify required content.  The resulting XML Schema products will support all requirements for the text based slash delimited MTF format, and will avoid alteration of XML element names except where absolutely necessary for naming de-confliction of global nodes. Except for a few cases, XML instances from the current standard will validate against the re-factored XML Schema if common name-spaces are assigned." ID="ID_1600566510" CREATED="1445638953301" MODIFIED="1445638953301"/>
<node TEXT="b.       This project is intended to support holistic implementation of the standards in order to facilitate use in web services, allow conversion between US and NATO specification, conversion between message versions, and interoperability with other standard formats." ID="ID_271663236" CREATED="1445638953301" MODIFIED="1445639196692"/>
</node>
<node TEXT="3.        Usage.  The process for converting from current standard formats is provided for purposes of integrity, testing and verification. For most use cases, the generated XML Schema can be used without repeating this conversion.  Reference implementation products are intended for re-use and distribution in order to promote interoperability and uniformity in implementations. These products should load the provided re-factored XML Schema and provide intended MTF messaging functionality for every message and message component." ID="ID_1372738245" CREATED="1445638953301" MODIFIED="1445638953301"/>
<node TEXT="4. Normalization" ID="ID_1579886535" CREATED="1445639206876" MODIFIED="1445639216303" HGAP="40" VSHIFT="80">
<node TEXT="a.  Rationale" ID="ID_833913977" CREATED="1445639254189" MODIFIED="1445639269324">
<node TEXT="1.  The creation of a &quot;Type&quot; for every field in MTF simply by adding &quot;Type&quot; or &quot;SimpleType&quot; to each field name does not leverage the concept of Typing appropriately. Many fields have identical content restrictions." ID="ID_731195158" CREATED="1445639254189" MODIFIED="1445639254189"/>
<node TEXT="2.  By comparing regular expressions, numerical content, and enumerations the number of simpleTypes are significantly reduced and the XML implementation of the MIL STDs employs reuse, extension and restriction effectively." ID="ID_11134108" CREATED="1445639254189" MODIFIED="1445639254189"/>
<node TEXT="3.  Base Types are implemented at the field level to serve the requirement to be able to add security markings at the field level. The Baseline XML Schema accomplish this at the Set level which requires extension for every field each time it is used." ID="ID_700117037" CREATED="1445639254189" MODIFIED="1445639254189"/>
<node TEXT="4.  The implementation of FieldStringBaseType, Field EnumerationBaseType, FieldIntegerBaseType, and FieldIntegerBaseType allow fields to be re-used by referencing instead of extension except where they have the nillable attribute. This significantly reduces the size of the XML Schema files." ID="ID_1851100404" CREATED="1445639254189" MODIFIED="1445639254189"/>
<node TEXT="5.  Base Types also provide the opportunity for additional extensions which can be applied at the field level when they are re-used externally or when the MIL STD requirements dictates such an adjustment." ID="ID_1227911003" CREATED="1445639254189" MODIFIED="1445639254189"/>
</node>
</node>
<node TEXT="5.  USMTF XML Schema Design.  Adjustments are made to the format of all XML Schema in order to reduce size, and eliminate redundant or unnecessary information." ID="ID_1022169540" CREATED="1445638953301" MODIFIED="1445639453073">
<node TEXT="a.          Annotations" ID="ID_515941484" CREATED="1445638953304" MODIFIED="1445638953304">
<node TEXT="(1)  Content of annotations is converted from elements to attributes in order to reduce size caused by closing tags. Names are changed to plain language terms instead of database field names.  Elements are used for Examples and Documents which have multiple items. When documentation and appinfo items are duplicative, the information is retained in the documentation node and removed from the appinfo node.  Empty items are omitted." ID="ID_1317650701" CREATED="1445638953304" MODIFIED="1445638953304"/>
</node>
<node TEXT="b.          Fields Re-factor" ID="ID_1444218123" CREATED="1445638974757" MODIFIED="1445638974757">
<node TEXT="(1)        Field Base Types.  The requirement to apply security markings to every field is currently accomplished by extending Simple Type fields at the Set level to add the ICM attribute group. This reduces the ability to reference fields at the Set level and causes unnecessary repetition in the XML Schema design.  The Re-Factor approach is to create FieldBaseTypes which carry the ICM attribute group and can be used to add other field level extensions. All fields are provided as Complex Types which extend the base types." ID="ID_284143835" CREATED="1445638974757" MODIFIED="1445639157827"/>
<node TEXT="(2)  Strings.  By comparing Regular Expressions the number of types extended by FieldStringBase Type is reduced.  Types which include length and value restrictions in the Regular Expression are removed.  String types are defined using pattern for content, and XML Schema elements to specify lengths at the element level.  The provided example &quot;AlphaNumericBlankSpecialTextType&quot; is re-used 877 times in the USMTF GoE_fields.xsd schema." ID="ID_422057800" CREATED="1445638987959" MODIFIED="1445638987959">
<node TEXT="1.  Regular Expression Comparison" ID="ID_1529821547" CREATED="1445639401275" MODIFIED="1445639401275"/>
<node TEXT="2.  FreeText simplification" ID="ID_411403596" CREATED="1445639401275" MODIFIED="1445639401275"/>
<node TEXT="3.  BlankSpace simplification" ID="ID_1363232522" CREATED="1445639401276" MODIFIED="1445639401276"/>
</node>
<node TEXT="(3)  Enumerations.  Enumerations do not require Regular Expressions or types.  the XML Schema integer is extended by FieldIntegerBaseType to include security markings." ID="ID_1486169141" CREATED="1445638997730" MODIFIED="1445638997730"/>
<node TEXT="(4)  Integers.  Integers do not require Regular Expressions or types.  the XML Schema integer is extended by FieldIntegerBaseType to include security markings, and each Integer field restricts FieldIntegerBaseType to add value restrictions." ID="ID_432099801" CREATED="1445639007421" MODIFIED="1445639007421"/>
<node TEXT="(5)  Decimals.  Decimals do not require Regular Expressions or types.  the XML Schema decimal is extended by FieldIntegerBaseType to include security markings, and each Decimal field restricts FieldDecimalBaseType to add value restrictions." ID="ID_1583010864" CREATED="1445639022820" MODIFIED="1445639022820"/>
</node>
<node TEXT="c.        Sets Re-factor.  Application of security attribute group at the Field level reduces the need for extensions at the set level." ID="ID_612557000" CREATED="1445639054735" MODIFIED="1445639109982" HGAP="40" VSHIFT="210"/>
<node TEXT="e.        Segments Re-factor.  Segments are extracted from messages to provide the opportunity for re-use." ID="ID_614797433" CREATED="1445639078646" MODIFIED="1445639113730" HGAP="40" VSHIFT="60"/>
<node TEXT="f. Summary." ID="ID_1587601114" CREATED="1445639444380" MODIFIED="1445639458910" HGAP="40" VSHIFT="40">
<node TEXT="1.  String type normalization reduces the number of string simpleTypes from 1624 to 153 without impacting message content." ID="ID_1538999414" CREATED="1445639444380" MODIFIED="1445639444380"/>
<node TEXT="2.  Enumeration normalization reduces the number of enumerated simpleTypes from 1766 to 1473 without impacting message content." ID="ID_233952357" CREATED="1445639444381" MODIFIED="1445639444381"/>
<node TEXT="3.  Numeric normalization eliminates 1337 integer simpleTypes and 245 decimal simpleTypes." ID="ID_374397770" CREATED="1445639444381" MODIFIED="1445639444381"/>
</node>
</node>
<node TEXT="6. Processs" ID="ID_1857506947" CREATED="1445639369485" MODIFIED="1445639472552"><richcontent TYPE="DETAILS">

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
<node TEXT="a.  The NormalizedSimpleTypes.xsd file was created using a variety of methods which analyze and compare Regular Expressions. This required subjective decisions which may be adjusted. The XSLT scripts to accomplish this are in the USMTF/XSLT/Normalization/work directory." ID="ID_801444743" CREATED="1445639481024" MODIFIED="1445639522402"/>
<node TEXT="b  The XSLT scripts to generate the normalized simpleTypes are located in the USMTF/XSLT/Normalization directory. Data products are located in the USMTF/XSD/Normalized/work directory." ID="ID_1576488055" CREATED="1445639481024" MODIFIED="1445639527155"/>
<node TEXT="c  The Strings.xsl, Numerics.xsl, and Enumerations.xsl scripts can be executed in any order. Results are written to the USMTF/XSD/Normalized directory." ID="ID_27694232" CREATED="1445639481024" MODIFIED="1445639531217"/>
<node TEXT="d.  The GoE_Fields.xsl script consolidates the Strings.xsd, Integers.xsd, Decimals.xsd and Enumerations.xsd files into the GoE_field.xsd document which is stored in the USMTF/XSD/GoE_Schema directory." ID="ID_1037640678" CREATED="1445639481024" MODIFIED="1445639539720"/>
<node TEXT="e.  Sets Re-factor.  Sets extend the BaseSetType in order to add the security attribute group at the set level.  Because fields types are now also extended, they do not need to be extended in the Sets Schema, but can be directly referenced or typed.   Because nillable elements cannot be referenced, they are extended." ID="ID_1626783819" CREATED="1445639481024" MODIFIED="1445639544064"/>
<node TEXT="f.  Segments Re-factor.  Segments are extracted from messages to provide the opportunity for re-use.  A new Complex Type, SegmentBaseType, is included to insert ICM security attribute group and for further Segment level extension." ID="ID_1143867056" CREATED="1445639481024" MODIFIED="1445639667079"/>
<node TEXT="g  Messages Re-factor" ID="ID_1347675679" CREATED="1445639481024" MODIFIED="1445639680287">
<node TEXT="1.  Element Name Changes.  One of the goals for the re-factor was to minimize impact on current XML Instance documents.  In the case of General Text and Heading Information fields the proposed change adds field names which are specific to the required content and eliminate the need to distinguish XML nodes by appending numbers." ID="ID_464775862" CREATED="1445639481024" MODIFIED="1445639671094"/>
<node TEXT="2.  General Text Re-factor" ID="ID_1902399333" CREATED="1445639481024" MODIFIED="1445639845965" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      This was implemented in order to include fixed required values in the TextIdentification field using XML extension.&#160;&#160;This eliminates all rules specifying these values since they are verified by XML validation.&#160;&#160;This reduces the size of the XML Schema and reduces the additional rules implementation requirement.
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="3.  Heading Information Re-factor" ID="ID_297034551" CREATED="1445639481024" MODIFIED="1445639857411" VSHIFT="20"><richcontent TYPE="DETAILS">

<html>
  

  <head>

  </head>
  <body>
  </body>
</html>

</richcontent>
</node>
<node TEXT="4.  Message Identification" ID="ID_463120136" CREATED="1445639481024" MODIFIED="1445639678701" VSHIFT="20"/>
</node>
</node>
</node>
</node>
</map>
