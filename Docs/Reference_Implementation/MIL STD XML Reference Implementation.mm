<map version="freeplane 1.3.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="MIL STD XML Reference Implementation" ID="ID_1723255651" CREATED="1283093380553" MODIFIED="1430766026824"><hook NAME="MapStyle">

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
<node TEXT="Preparation" POSITION="right" ID="ID_232159495" CREATED="1430501763996" MODIFIED="1430768996792" HGAP="10" VSHIFT="-30">
<edge COLOR="#ff0000"/>
<node TEXT="Use Subversion to check out MTF XML, VMF XML and TDL XML projects from Forge.mil" ID="ID_1894085896" CREATED="1430501770361" MODIFIED="1430501816985"/>
<node TEXT="Obtain Saxon XSLT" ID="ID_528410927" CREATED="1430503203144" MODIFIED="1430503218105"/>
<node TEXT="Create a continuous test/build environment (CBTE)" ID="ID_1884866634" CREATED="1430501923944" MODIFIED="1430505311264"/>
</node>
<node TEXT=" Phase 1: XML Schema Definitions" POSITION="right" ID="ID_1241364749" CREATED="1430502009634" MODIFIED="1430769040610">
<edge COLOR="#00ff00"/>
<node TEXT="Tasks" ID="ID_1511553894" CREATED="1430504702296" MODIFIED="1430769040609" HGAP="10" VSHIFT="-70">
<node TEXT="Leverage existing work to complete XML Schema representations of MTF, VMF and TDL standards in order to create NIEM conformant products which include all cases and conditions using rule based schema language." ID="ID_307006838" CREATED="1430502009634" MODIFIED="1430767840806" VSHIFT="800">
<node TEXT="MTF" ID="ID_1846652153" CREATED="1430504997464" MODIFIED="1430514633691" VSHIFT="30">
<node TEXT="Create a branch in MTFXML named mtfxml-1.0 and add to the CBTE" ID="ID_997766959" CREATED="1430503103915" MODIFIED="1430511779923"/>
<node TEXT="Create Java code using Saxon to run all XSLTs in the correct order to generate GoE XML Schemas from the lastest MIL STD version for NATO MTF and USMTF.  Generate reports to verify valid XML Schemas in CBTE" ID="ID_1335536329" CREATED="1430505054440" MODIFIED="1430506425319"/>
<node TEXT="Create tests which apply Saxon XML Validation to verify that all XML Schemas are valid per W3C XML Schema 1.1" ID="ID_1317936458" CREATED="1430503271304" MODIFIED="1430768135235"/>
<node TEXT="Modify current XSLT to replace SimpleTypes with proposed normalized SimpleTypes in US MTF and NATO MTF" ID="ID_382946005" CREATED="1430505398616" MODIFIED="1430505557480"/>
<node TEXT="Modify NATO MTF XSLT to extract Segments as ComplexTypes in NATO MTF in the same way it is done in USMTF" ID="ID_1969061881" CREATED="1430505678504" MODIFIED="1430505800873"/>
<node TEXT="Create an XML Document containing required name de-confliction modifications and modify XSLT to reference this to autogenerate NATO MTF XML Schemas" ID="ID_725258972" CREATED="1430505730920" MODIFIED="1430506550745"/>
<node TEXT="Use XSLT to create an XML file containing all cases and conditions mapped to each message." ID="ID_82156444" CREATED="1430504104888" MODIFIED="1430507298409"/>
<node TEXT="Use manual entry, XSLT, or other automated means to convert all validation parameters to XML SChema 1.1 compliant xsd: assert statements which use XPATH  2.0 expressions." ID="ID_383885632" CREATED="1430504170024" MODIFIED="1430505462988"/>
<node TEXT="Modify XSLT to reference assertions.xml document to replace rules at the message level with xsd:assert statements." ID="ID_1347679215" CREATED="1430504274361" MODIFIED="1430507370264"/>
<node TEXT="Verify CBTE report of valid XML Schemas are generated from latest approved standard." ID="ID_1504068696" CREATED="1430505489016" MODIFIED="1430505902041"/>
</node>
<node TEXT="VMF" ID="ID_1922743931" CREATED="1430502077724" MODIFIED="1430502082617">
<node TEXT="Create a branch in VMFXML named vmfxml-1.4 from vmfxml-1.3 and add to the CBTE" ID="ID_876629696" CREATED="1430503103915" MODIFIED="1430506361812"/>
<node TEXT="Add vmfxml-1.4 to the continuous build environment (CBTE)" ID="ID_19750169" CREATED="1430503351752" MODIFIED="1430505347380"/>
<node TEXT="Run Java code to apply Saxon to generate XML Schemas" ID="ID_981417479" CREATED="1430506770409" MODIFIED="1430506798409"/>
<node TEXT="Create tests which apply Saxon XML Validation to verify that all XML Schemas are valid per W3C XML Schema 1.1." ID="ID_1032939618" CREATED="1430503271304" MODIFIED="1430506430146"/>
<node TEXT="Apply XSLT to VML SimpleTypes to create an XML map of DFIs to REGEX" ID="ID_1398222474" CREATED="1430502111656" MODIFIED="1430503583408"/>
<node TEXT="Modify vmfxml-1.4 XSLT to reference REGEX map to include xsd:pattern values" ID="ID_452158632" CREATED="1430503567799" MODIFIED="1430503638917"/>
<node TEXT="Use XLST to generate a list of unique simpleTypes from XML Schemas in vmfxml-1.4" ID="ID_1288037881" CREATED="1430503639416" MODIFIED="1430503810995"/>
<node TEXT="Use MTF XML proposed normalized SimpleTypes as a reference to assign SimpleTypes to coresponding fields in vmfxml-1.4.  Assign new SimpleTypes as required." ID="ID_1509643700" CREATED="1430503733888" MODIFIED="1430505472675"/>
<node TEXT="Modify XSLT in vmlxml-1.4 to assign SimpleTypes to elements, generate ComplexTypes, and generate Garden of Eden XML Schemas with SimpleTypes and ComplexTypes." ID="ID_1315934484" CREATED="1430503776615" MODIFIED="1430504060876"/>
<node TEXT="Use XSLT to create an XML file containing all VALIDATION_PARAMETERS mapped to each message." ID="ID_1401096239" CREATED="1430504104888" MODIFIED="1430504169543"/>
<node TEXT="Use manual entry, XSLT, or other automated means to convert all validation parameters to XML SChema 1.1 compliant xsd: assert statements which use XPATH  2.0 expressions." ID="ID_1649257019" CREATED="1430504170024" MODIFIED="1430505462988"/>
<node TEXT="Modify XSLT in vmfxml-1.4 to reference assertions.xml document to replace VALIDATION_PARAMETERS at the message level with xsd:assert statements." ID="ID_265809363" CREATED="1430504274361" MODIFIED="1430504382166"/>
<node TEXT="Ensure that the CBTE build process provides reports which verify the generation of valid XML Schema version 1.1 documents from the latest VID" ID="ID_977366943" CREATED="1430504382568" MODIFIED="1430505377802"/>
</node>
<node TEXT="TDL" ID="ID_1142124443" CREATED="1430505916440" MODIFIED="1430768617453" VSHIFT="-10">
<node TEXT="Create a branch in TDLXML named tdlxml-1.0 and add to CBTE" ID="ID_554821206" CREATED="1430503103915" MODIFIED="1430506717553"/>
<node TEXT="Apply Java XSLT code to generate XML Schemas using XLST in GoE_LINK16 directory" ID="ID_1674943883" CREATED="1430503351752" MODIFIED="1430506833253"/>
<node TEXT="Use MTF XML proposed normalized SimpleTypes as a reference to assign SimpleTypes to coresponding fields in tdlxml-1.0.  Assign new SimpleTypes as required." ID="ID_1141129117" CREATED="1430506833720" MODIFIED="1430506883784"/>
<node TEXT="Create XML document with required name deconflictions for GoE XML Schemas." ID="ID_434558404" CREATED="1430506890484" MODIFIED="1430507191782"/>
<node TEXT="Modify XSLT to create GoE XML Schemas which pull all ComplexTypes and SimpleTypes to global level and apply name deconflictions" ID="ID_283692373" CREATED="1430507192296" MODIFIED="1430768617451"/>
<node TEXT="Inspect existing Case/Condition methodology and Use manual entry, XSLT, or other automated means to convert all validation parameters to XML Schema 1.1 compliant xsd: assert statements which use XPATH  2.0 expressions." ID="ID_1087269309" CREATED="1430507250152" MODIFIED="1430766463553"/>
<node TEXT="Ensure that the CBTE build process provides reports which verify the generation of valid XML Schema version 1.1 documents from the latest VID" ID="ID_574856174" CREATED="1430504382568" MODIFIED="1430505377802"/>
</node>
</node>
<node TEXT="Leverage existing work to create web based views of all components of each standard which include the ability to annotate, adjust and track changes to the XML Schemas using a collaborative web interface." ID="ID_583333680" CREATED="1430502009634" MODIFIED="1430767839453"/>
<node TEXT="Leverage existing work to create reusable web based form fields for all components of each standard.  Employ user-interface validation using Javascript." ID="ID_1032913515" CREATED="1430502009634" MODIFIED="1430767673075"/>
<node TEXT="Create unit tests using JavaScript to validate content of components using XML Schema and rules which can be employed individually or in context of combinatorial data structures." ID="ID_536613789" CREATED="1430502009634" MODIFIED="1430504739284"/>
<node TEXT="Create sample data collections for use in auto-population and testing of all message components." ID="ID_33943245" CREATED="1430502009634" MODIFIED="1430768980098" VSHIFT="-820"/>
</node>
</node>
<node TEXT="Phase 2:  Message Implementation" POSITION="right" ID="ID_531398227" CREATED="1430502009634" MODIFIED="1430504864359" VSHIFT="90">
<edge COLOR="#ff00ff"/>
<node TEXT="(1)        Create XML Schema Aware Javascript modules to generate valid text and binary data formats from XML Instances." ID="ID_1345344884" CREATED="1430502009634" MODIFIED="1430502009634"/>
<node TEXT="(2)        Create XML Schema Aware Javascript models to parse text and binary formats into XML Instances." ID="ID_504335915" CREATED="1430502009634" MODIFIED="1430502009634"/>
<node TEXT="(3)        Create Unit Tests which leverage sample data to verify all message generation and parsing operations." ID="ID_1564930809" CREATED="1430502009634" MODIFIED="1430502009634"/>
<node TEXT="(4)        Create user interfaces to support configuration of automated message exchanges which populate cumulative data products." ID="ID_729787374" CREATED="1430502009634" MODIFIED="1430502009634"/>
<node TEXT="(5)        Create and interface that allows selection of specific messages for implementation, and provides a means to set default values and specify or create required supplemental information resources." ID="ID_1632185270" CREATED="1430502009634" MODIFIED="1430502009634"/>
<node TEXT="(6)        Generate NIEM compliant Information Exchange Product Documentation (IEPD) for each message which includes documentation, forms, sample data and specifications for default values and supplemental data sources." ID="ID_1631758793" CREATED="1430502009634" MODIFIED="1430502009634"/>
<node TEXT="(7)        Create Unit Tests for all user interface implementations and for all processing modules." ID="ID_343986399" CREATED="1430502009634" MODIFIED="1430502009634"/>
</node>
<node TEXT="Phase 3: Deployment" POSITION="right" ID="ID_225385779" CREATED="1430502009634" MODIFIED="1430504864372">
<edge COLOR="#00ffff"/>
<node TEXT="(1)        Publish and document all implementation and testing products using a web service which allows performance or replication of all functions." ID="ID_1079134495" CREATED="1430502009634" MODIFIED="1430502009634"/>
<node TEXT="(2)  Create a web service which allows customization and generation of Mobile compatible application packages for deployment." ID="ID_1703339721" CREATED="1430502009634" MODIFIED="1430502009634"/>
<node TEXT="(3)   Create a web service which leverages the continuous build environment to provide validation reports for proposed changes to XML Schema definitions." ID="ID_1136215449" CREATED="1430502009634" MODIFIED="1430502009634"/>
<node TEXT="(4)   Create a web service which generates and consumes valid and invalid test data for use in the testing of external systems." ID="ID_60990964" CREATED="1430502009634" MODIFIED="1430502009634"/>
<node TEXT="(5)   Create message viewing service which includes the representation of individual and cumulative messages using web based Geodesy services and views." ID="ID_667168190" CREATED="1430502009634" MODIFIED="1430502009634"/>
<node TEXT="(6)   Create a Configuration Management service which supports collaboration and digital signature so that Interface Change Proposals to MIL STDs can be generated and validated for content by Standards Board members with access to the analysis and reporting tools inherent to the reference implementations." ID="ID_740275006" CREATED="1430502009634" MODIFIED="1430502009634"/>
</node>
</node>
</map>
