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
<node TEXT="USMTF" POSITION="right" ID="ID_1967102135" CREATED="1444842276503" MODIFIED="1444853729296" VSHIFT="50">
<edge COLOR="#ff0000"/>
<node TEXT="Re-Factor Process" ID="ID_393949117" CREATED="1444857194575" MODIFIED="1444857200155"/>
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
