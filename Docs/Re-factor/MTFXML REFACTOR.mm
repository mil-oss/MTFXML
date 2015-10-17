<map version="freeplane 1.3.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="MTFXML REFACTOR" ID="ID_1723255651" CREATED="1283093380553" MODIFIED="1444928140481"><hook NAME="MapStyle">

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
<hook NAME="AutomaticEdgeColor" COUNTER="7"/>
<node TEXT="Background" POSITION="right" ID="ID_396111513" CREATED="1444853751150" MODIFIED="1444928136842" VSHIFT="30">
<edge COLOR="#ff00ff"/>
<node TEXT="The current XML Schema for US and NATO MTF are designed for piecemeal implementation of messages based on commonly defined XML nodes which are maintained in relational databases.  This makes normalization, re-use, and configuration management difficult." ID="ID_199156720" CREATED="1444853786014" MODIFIED="1444855645114" HGAP="10" VSHIFT="-10"/>
<node TEXT="Because the current XML Schema design does not support implementation of the entire standard, there are persistent mismatches of messages implemented and versions across systems." ID="ID_1369603701" CREATED="1444854247374" MODIFIED="1444855622928" VSHIFT="-20"/>
<node TEXT="The re-factor of these standards to a Garden of Eden XML Schema Design model allows provisioning of consolidated XML Schema files with a manageable sizes to allow complete implementation of every message using a uniform and re-usable methodology." ID="ID_1109438859" CREATED="1444854148350" MODIFIED="1444856917664" VSHIFT="-10"/>
<node TEXT="Alignment with the US National Information Exchange Model (NIEM) methodology will allow the development and re-use of stndardized Information Exchange Product Documentation (IEPD) resources which will support valid implementations and promote interoperability with external specifications." ID="ID_1320508699" CREATED="1444854467693" MODIFIED="1444855633989" VSHIFT="10"/>
</node>
<node TEXT="Goals" POSITION="right" ID="ID_1741486495" CREATED="1444855666639" MODIFIED="1444857233729" VSHIFT="-10">
<edge COLOR="#00ffff"/>
<node TEXT="This project will use the Extensible Stylesheet Language for Transformation (XSLT) to convert existing XML Schema products to Garden of Eden design pattern, and will reduce file sizes by normalizing Types, using attributes in annotation elements, and applying fixed values where appropriate to reduce ambiguity and eliminate rules which specify required content." ID="ID_274447430" CREATED="1444855680286" MODIFIED="1444855954389"/>
<node TEXT="The resulting XML Schema products will support all requirements for the text based slash delimited MTF format, and will avoid alteration of XML element names except where absolutely necessary for naming deconfliction of global nodes.  Except for a few cases, XML instances from the current standard will validate against the re-factored XML Schemas if common namespaces are assigned." ID="ID_64571144" CREATED="1444855955886" MODIFIED="1444856261655" HGAP="30" VSHIFT="10"/>
<node TEXT="This project is intended to support holistic implementation of the standards in order to facilitate use in web services, allow conversion between US and NATO specification, conversion between message versions, and interoperability with other standard formats." ID="ID_589380055" CREATED="1444856263166" MODIFIED="1444856474104" VSHIFT="10"/>
</node>
<node TEXT="Usage" POSITION="right" ID="ID_1638087420" CREATED="1444856923121" MODIFIED="1444928140479" VSHIFT="-10">
<edge COLOR="#ffff00"/>
<node TEXT="The process for converting from current standard formats is provided for purposes of integrity, testing and verification.  For most use cases, the generated XML Schemas can be used without repeating this conversion." ID="ID_226841617" CREATED="1444856932239" MODIFIED="1444857188442" VSHIFT="-20"/>
<node TEXT="Reference implementation products are intended for re-use and distribution in order to promote interoperability and uniformity in implementations.  These products should load the provided re-factored XML Schemas and provide intended MTF messaging functionality for every message and message component." ID="ID_1184157034" CREATED="1444857042207" MODIFIED="1444857227178"/>
</node>
<node TEXT="Caveats" POSITION="right" ID="ID_98871154" CREATED="1444857235839" MODIFIED="1444928138529" VSHIFT="-70">
<edge COLOR="#7c0000"/>
<node TEXT="All data resources are restricted for distribution.  This requires complete separation of presentation and data.  No implementations may retain data from the XML Schema resources in code." ID="ID_996714687" CREATED="1444857241999" MODIFIED="1444857458193"/>
<node TEXT="Alteration or further re-factoring of the provided XML Schema must implement new namespace assignments." ID="ID_1920187984" CREATED="1444857468671" MODIFIED="1444857550443" VSHIFT="10"/>
<node TEXT="Because US and NATO specifications are closely aligned, all products are very similar and can often be re-used interchangeably.  Minor differences will occur, so For purposes of clarity and distribution they are provided separately with each standard." ID="ID_597604512" CREATED="1444857598111" MODIFIED="1444857749449" VSHIFT="10"/>
</node>
<node TEXT="USMTF" POSITION="right" ID="ID_1967102135" CREATED="1444842276503" MODIFIED="1445036965396" VSHIFT="50">
<edge COLOR="#ff0000"/>
<node TEXT="XML Schema Design" ID="ID_810225239" CREATED="1445035293775" MODIFIED="1445036965395" VSHIFT="-160">
<node TEXT="Adjustments are made to the format of all XML Schemas in order to reduce size, and eliminate redundant or unnecessary information." ID="ID_1480971800" CREATED="1445035365647" MODIFIED="1445035671487" VSHIFT="-130"/>
<node TEXT="Annotations" ID="ID_1750708290" CREATED="1445035672879" MODIFIED="1445037477407">
<node TEXT="Content of xsd:annotations is converted from elements to attributes in order to reduce size caused by closing tags.  Names are changed to plain language terms instead of database field names.  Elements are used for multiple items." ID="ID_1323541666" CREATED="1445035684847" MODIFIED="1445037470693" HGAP="30" VSHIFT="-10"/>
<node TEXT="When xsd:documentation and asd:appinfo items are duplicative, the information is retained in the xsd:documentation node and removed from the xsd;appinfo node." ID="ID_686135295" CREATED="1445037472232" MODIFIED="1445037478164" HGAP="30"/>
<node TEXT="The names of the items in xsd:appinfo nodes are changed as follows:" ID="ID_1166810592" CREATED="1445035779520" MODIFIED="1445037062132" HGAP="30" VSHIFT="10">
<node TEXT="Fields" ID="ID_1193573017" CREATED="1445035842367" MODIFIED="1445037202261" VSHIFT="-20">
<node TEXT="Changed" ID="ID_1404203008" CREATED="1445037164613" MODIFIED="1445037873446">
<node TEXT="FudExplanation = @explanation" ID="ID_233814453" CREATED="1445037052389" MODIFIED="1445037871918"/>
<node TEXT="VersionIndicator=@version" ID="ID_1730215180" CREATED="1445037055656" MODIFIED="1445037873446" VSHIFT="10"/>
<node TEXT="FudRelatedDocument = &lt;Document/&gt;" ID="ID_697421810" CREATED="1445037137190" MODIFIED="1445037228476" VSHIFT="10"/>
</node>
<node TEXT="Removed" ID="ID_486648130" CREATED="1445037168788" MODIFIED="1445037202260" VSHIFT="30">
<node TEXT="FieldFormatIndexReferenceNumber" ID="ID_1733493911" CREATED="1445037065257" MODIFIED="1445037162307"/>
<node TEXT="FudNumber" ID="ID_1930719625" CREATED="1445037098579" MODIFIED="1445037115425"/>
</node>
</node>
<node TEXT="Sets" ID="ID_1619470227" CREATED="1445035889168" MODIFIED="1445035910552"/>
<node TEXT="Segments" ID="ID_198106096" CREATED="1445035912432" MODIFIED="1445035915036"/>
<node TEXT="Messages" ID="ID_1821425080" CREATED="1445035915696" MODIFIED="1445035919392"/>
</node>
</node>
</node>
<node TEXT="XML Schema Re-Factor Process" ID="ID_393949117" CREATED="1444857194575" MODIFIED="1445036958997">
<node TEXT="This process is retained for purposes of verification, testing and maintenance.  It is not necessary for implementers to repeat this effort." ID="ID_375994573" CREATED="1445034474254" MODIFIED="1445036958995" HGAP="90" VSHIFT="100"/>
<node TEXT="FIELDS" ID="ID_1043767447" CREATED="1445035203262" MODIFIED="1445036417207">
<node TEXT="Normalization" ID="ID_520682973" CREATED="1445034575308" MODIFIED="1445036417206" VSHIFT="-10">
<node TEXT="Rationale" ID="ID_1934291471" CREATED="1445036249106" MODIFIED="1445036302068" VSHIFT="70">
<node TEXT="The creation of a &quot;Type&quot; for every field in MTF simply by adding &quot;Type&quot; or &quot;SimpleType&quot; to each field name does not leverage the concept of Typing appropriately.  Many fields have identical content restrictions." ID="ID_1984290996" CREATED="1445035980975" MODIFIED="1445036293806" VSHIFT="-20"/>
<node TEXT="By comparing regular expressions, numerical content, and enumerations the number of xsd:simpleTypes are significantly reduced and the XML implementation of the MIL STDs employs reuse, extension and restriction effectively." ID="ID_1350623549" CREATED="1445036280658" MODIFIED="1445036281810"/>
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
<node TEXT="Enumerations" ID="ID_1068069523" CREATED="1445035980985" MODIFIED="1445036218462">
<node TEXT="Single Enumerations." ID="ID_566778365" CREATED="1445035980987" MODIFIED="1445036135002">
<node TEXT="The use of a simple type with a restriction and a single enumeration is a result of vapid adherence to a &quot;best practice&quot; which advises avoidance of fixed and default values.  Creation of &quot;Types&quot; for elements which will only ever contain one value and will never be extended or restricted is pointless." ID="ID_579384915" CREATED="1445035980987" MODIFIED="1445036152236"/>
<node TEXT="The Enumerations.xsl converts xsd:simpleTypes with single enumerations to elements with fixed values so that they can be directly referenced from complexTypes as global elements from fields.xsd." ID="ID_1440878303" CREATED="1445035980987" MODIFIED="1445036157226"/>
</node>
<node TEXT="Common Enumerations." ID="ID_1408636520" CREATED="1445035980987" MODIFIED="1445036137233">
<node TEXT="Elements with identical Enumerations can be typed using a common xsd:simpleType definition." ID="ID_71424025" CREATED="1445035980987" MODIFIED="1445036164347"/>
<node TEXT="The NormlizedSimpleTypes.xsd has been created based on analysis to determine reusable enumeration sets.  The Enumerations.xsl applies these types to elements when content is equivalent, and include annotations at the element level." ID="ID_1679572618" CREATED="1445035980987" MODIFIED="1445036160297"/>
</node>
</node>
<node TEXT="Numerics" ID="ID_1333327536" CREATED="1445035980987" MODIFIED="1445036224010">
<node TEXT="Integers" ID="ID_985868689" CREATED="1445035980988" MODIFIED="1445036168792">
<node TEXT="(The use of xsd:simpleTypes for integers serves no purpose since XML Schema provides all means necessary to describe and validate integer content." ID="ID_9681461" CREATED="1445035980988" MODIFIED="1445036175898"/>
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
<node TEXT="XML Schema Design" ID="ID_1070499464" CREATED="1445036387503" MODIFIED="1445036871930">
<node TEXT="BaseTypes are implemented at the field level to serve the requirement to be able to add security markings at the field level.  The Baseline XML Schema accomplish this at the Set level which requires extension for every field each time it is used." ID="ID_919087704" CREATED="1445036420100" MODIFIED="1445036871924" VSHIFT="-26"/>
<node TEXT="The implementation of FieldStringBaseType, Field EnumerationBaseType, FieldIntegerBaseType, and FieldIntegerBaseType allow fields to be re-used by referencing instead of extension except where they have the nillable attribute.  This significantly reduces the size of the XML Schema files." ID="ID_236763277" CREATED="1445036563314" MODIFIED="1445036867436"/>
<node TEXT="BaseTypes also provide the opportunity for additional extensions which can be applied at the field level when they are re-used externally or when the MIL STD requirements dictates such an adjustment." ID="ID_1104095164" CREATED="1445036735475" MODIFIED="1445036869173" VSHIFT="20"/>
</node>
<node TEXT="Process" ID="ID_137274626" CREATED="1445035252766" MODIFIED="1445035290626" VSHIFT="10">
<node TEXT="The NormalizedSimpleTypes.xd file was created using a variety of methods which analyse and compare Regular Expressions.  This required subjective decisions which may be adjusted.  The XSLT scripts to accomplish this are in the USMTF/XSLT/Normalization/work directory." ID="ID_1804333818" CREATED="1445034597811" MODIFIED="1445035234191"/>
<node TEXT="The XSLT scripts to generate the normalized xsd:simpleTypes are located in the USMTF/XSLT/Normalization directory.  Data products are located in the USMTF/XSD/Normlaized/work directory." ID="ID_1608214864" CREATED="1445034741804" MODIFIED="1445035056339"/>
<node TEXT="The Strings.xsl, Numerics.xsl, and Enumerations.xsl scripts can be executed in any order.  Results are written to the USMTF/XSD/Normlaized directory." ID="ID_157188162" CREATED="1445034887757" MODIFIED="1445034989675"/>
<node TEXT="The GoE_Fields.xsl script consolidates the Strings.xsd, Integers.xsd, Decimals.xsd and Enumerations.xsd files into the GoE_field.xsd document which is stored in the USMTF/XSD/GoE_Schema directory." ID="ID_272052222" CREATED="1445035058942" MODIFIED="1445035190910"/>
</node>
</node>
</node>
<node TEXT="Testing" ID="ID_1095016314" CREATED="1444857200719" MODIFIED="1444857207213"/>
<node TEXT="Reference Implementations" ID="ID_1169000317" CREATED="1444857207646" MODIFIED="1444857584344"/>
</node>
<node TEXT="NATO MTF" POSITION="right" ID="ID_1396388343" CREATED="1444842280471" MODIFIED="1444842297977" VSHIFT="40">
<edge COLOR="#0000ff"/>
<node TEXT="Element Name Changes" ID="ID_899081510" CREATED="1444842303529" MODIFIED="1444842656535" VSHIFT="40">
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
</node>
</map>
