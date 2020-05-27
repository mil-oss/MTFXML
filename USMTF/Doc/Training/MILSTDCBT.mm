<map version="freeplane 1.6.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="MILSTD XML Training" FOLDED="false" ID="ID_1722819656" CREATED="1586977618436" MODIFIED="1590587692273" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle">
    <properties fit_to_viewport="false" edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24.0 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ICON_SIZE="12.0 pt" COLOR="#000000" STYLE="fork">
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ffffff" TEXT_ALIGN="LEFT"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right" STYLE="bubble">
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
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval" SHAPE_HORIZONTAL_MARGIN="10.0 pt" SHAPE_VERTICAL_MARGIN="10.0 pt">
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
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,11"/>
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="AutomaticEdgeColor" COUNTER="5" RULE="ON_BRANCH_CREATION"/>
<node TEXT="Background" POSITION="right" ID="ID_1974669059" CREATED="1586977693494" MODIFIED="1590587692271" HGAP_QUANTITY="36.49999932944776 pt" VSHIFT_QUANTITY="3.749999888241291 pt">
<edge COLOR="#ff0000"/>
<richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The maintenance and implementation of military information exchange standards requires an understanding of the technical challenges and the reason that they exist.&#160;&#160;In this course we hope to address any gaps in this understanding, and create a shared vocabulary and staring point for those interested in high assurance military information exchange capabilities.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Introduction" FOLDED="true" POSITION="right" ID="ID_1168979071" CREATED="1586977710894" MODIFIED="1590587686985" HGAP_QUANTITY="34.999999374151244 pt" VSHIFT_QUANTITY="1.4999999552965146 pt">
<edge COLOR="#0000ff"/>
<node TEXT="Automation" ID="ID_1781666327" CREATED="1586981353940" MODIFIED="1590427876378" HGAP_QUANTITY="15.499999955296518 pt" VSHIFT_QUANTITY="134.24999599903833 pt"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      XML Schema provides strong typing and relationship information that allows the creation of&#160;&#160;data objects in software, so that automated processes will consume and produce fully controlled data items in a manner that meets requirements of High Assurance information exchanges.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="High Assurance" ID="ID_975332951" CREATED="1586981344487" MODIFIED="1590427869453" HGAP_QUANTITY="16.999999910593033 pt" VSHIFT_QUANTITY="-1.4999999552964987 pt"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      This term is intended to convey the concept of trust, on the basis of the fact that specific processes are in place that verify whether or not information is complete, unaltered, comes from a verified source, and can only be shared with authorized recipients.&#160;&#160;&#160;The standard way of achieving this this in US DoD at present, requires XML Schema validation and XSLT processing.&#160;&#160;Because all security considerations must be considered holistically, the way this is done must be understood so that it does not conflict with the way that equivalent concepts are defined and handled within specific standards.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="XML Schema Design" ID="ID_1611008996" CREATED="1590427624037" MODIFIED="1590427872152" HGAP_QUANTITY="15.499999955296516 pt" VSHIFT_QUANTITY="-132.74999604374182 pt"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      US and NATO MTF were early adopters of XML Schema as a normative expression of the MIL STDs, and USMTF has integrated XML defined security tags as part of this effort.&#160;&#160;&#160;Recently the MTF XML Schema have been converted to a Garden of Eden design model conformant with the National Information Exchange Model (NIEM).&#160;&#160;&#160;From a technical perspective this means that certain XML Schema and other artifacts must conform to NIEM naming and design rules.&#160;&#160;This can be fully automated, but must be included in the verification and testing of software implementing an XML defined MIL STD.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="XML Fundamentals" FOLDED="true" POSITION="right" ID="ID_67050633" CREATED="1586977784857" MODIFIED="1590587682211" HGAP_QUANTITY="34.249999396502986 pt" VSHIFT_QUANTITY="2.9999999105930506 pt">
<edge COLOR="#00ff00"/>
<node TEXT="W3C XML" ID="ID_1858223195" CREATED="1586977803604" MODIFIED="1586984483026" HGAP_QUANTITY="18.499999865889553 pt" VSHIFT_QUANTITY="43.49999870359902 pt"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The W3C provides a set of Voluntary Consensus Standards which form the basis of web technology.&#160;&#160;The rules on how Uniform Reference Information (URI) and other basic features are expressed can be combined with basic markup rules to allow disparate applications to communicate through a common layer, which in many, but not all, cases is the World Wide Web.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="XML Applications" ID="ID_1426626609" CREATED="1586977822904" MODIFIED="1586984487149" HGAP_QUANTITY="17.74999988824129 pt" VSHIFT_QUANTITY="4.218847493575595E-15 pt"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      A specific implementation of XML markup, with associated data processing software design rules, is considered an XML application.&#160;&#160;XML Schema and Extensible Stylesheet Language for Transformation (XSLT) are XML applications for validating and processing any XML.&#160;&#160;HTML is an XML defined language that is implemented by web browsers.&#160;&#160;XML applications apply XML Schema, and follow rules which can be verified and validated, which is why they are appropriate for processing information in a manner that has inherent security requirements.&#160;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="XML Schema" ID="ID_1458600205" CREATED="1586977795864" MODIFIED="1586984489333" HGAP_QUANTITY="18.499999865889553 pt" VSHIFT_QUANTITY="1.4999999552965129 pt"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      W3C XML Schema is a standardized way to define data objects using W3C XML rules and conventions.&#160;&#160;&#160;W3C Schema themselves are defined using the same rules, so provide a basis for data verification and validation in which every component in the data supply chain can be validated, to include the component used for validation.&#160;&#160;This is appropriate for high assurance information exchanges such as those used for financial, medical and military communications.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="XSLT" ID="ID_1984116726" CREATED="1586977816692" MODIFIED="1586985772792" HGAP_QUANTITY="19.249999843537815 pt" VSHIFT_QUANTITY="2.249999932944771 pt"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      W3C XSLT is a programming language that uses XML syntax to process XML information.&#160;&#160;It is extremely useful for generating XML instances, extending and restriction XML Schema, and for validating logical business rules in XML documents.&#160;&#160;&#160;Because XSLT is XML, it can also be used auto-generate more XSLT, thus providing a consistent and automatable way to provide core functionality that can be tested and validated.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="JSON" ID="ID_1959254315" CREATED="1586984526289" MODIFIED="1586985785638" HGAP_QUANTITY="22.999999731779106 pt" VSHIFT_QUANTITY="-4.499999865889549 pt"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      JavaScript Object Notation (JSON) Schema exist, and everything XSLT can do can be done with JavaScript.&#160;&#160;For display and user functions, this is a recommended approach, and which is why all XML implementations should provide JSON output.&#160;
    </p>
  </body>
</html>
</richcontent>
<node TEXT="JSON Schema" ID="ID_1129769337" CREATED="1586984852972" MODIFIED="1586985768975" HGAP_QUANTITY="22.999999731779106 pt" VSHIFT_QUANTITY="65.24999805539852 pt"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      It is relatively easy to generate JSON Schema from JSON Schema, and slightly more difficult to use JavaScript to generate an XML Schema from a JSON Schema, but converters exist.&#160;&#160;The complexity of XML Schema is driven by the information defined, so JSON schema are be no less complex.&#160;&#160;&#160;People who don't want to learn XML will need to know all the same stuff in this course, just with different markup and tools.&#160;&#160;Anyone succeeding in replicating the power of XSLT using JavaScript or any other language should encouraged to share.&#160;&#160;Those attempting it without considerable skills should be cautioned otherwise.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="JSON Security Tags" ID="ID_1363276757" CREATED="1586984867544" MODIFIED="1586985760666" HGAP_QUANTITY="19.99999982118607 pt" VSHIFT_QUANTITY="-2.999999910593032 pt"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      In order to implement IC-ISM security tags using JavaScript vice XSLT, the IC-ISM scripts will have to be converted to JavaScript, and those conversions will have to be accredited by someone.&#160;&#160;&#160;When JSON and XML can be used interchangeably for different purposes, since they are auto-generated using the same XML Schema, this duplication of effort is avoided.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="XML Alternatives" ID="ID_1488095892" CREATED="1586984820641" MODIFIED="1586985763280" HGAP_QUANTITY="21.499999776482603 pt" VSHIFT_QUANTITY="-67.49999798834331 pt"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Those who understand the complexity and known good solutions for the high assurance and automation challenges may have a better way and should be encouraged to suggest them.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Databases" ID="ID_1888074785" CREATED="1586985777160" MODIFIED="1590430260316" HGAP_QUANTITY="22.249999754130847 pt" VSHIFT_QUANTITY="-44.999998658895535 pt"><richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The primary differentiator between an XML data object and an object in a database is that the XML object can be employed independently of a specific application, while adhering to a required format and content.&#160; An XML document is a discrete data object, while a database entry is a conceptual relationship. The Structured Query language is the database equivalent of XSLT.&#160;&#160;Most databases support XML object storage, and some support XSLT, but XML from a database can not be considered authoritative until it has been verified and validated as an XML document, so there is a strong case for just leaving it that way to begin with.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="XML Military Use Case" FOLDED="true" POSITION="right" ID="ID_1631525658" CREATED="1586979437597" MODIFIED="1590587677827" HGAP_QUANTITY="33.49999941885473 pt" VSHIFT_QUANTITY="4.499999865889556 pt">
<edge COLOR="#ff00ff"/>
<richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      All military actions are dependent on authority, and decision.&#160; Information supporting these functions must be accurate and trusted.&#160; Information shared in support of these functions must be controlled.&#160;&#160;At the very least this control must include metadata that provides classification,&#160;&#160;releasability and visibility information.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="Accurate Information Exchange" ID="ID_1660603492" CREATED="1586979752125" MODIFIED="1590587603855" HGAP_QUANTITY="16.999999910593036 pt" VSHIFT_QUANTITY="55.49999834597115 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Military information exchanges can be defined using XML Schema, which can be used to validate messages for content and context.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Trusted Data" ID="ID_926566734" CREATED="1586979802173" MODIFIED="1586980710568" HGAP_QUANTITY="22.24999975413085 pt" VSHIFT_QUANTITY="0.7499999776482635 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      XML information can be extend with components that contain classification and releasability information.&#160;&#160;An example of this is&#160; the Intelligence Community (IC) Trusted Data Format (TDF) which is an XML application that defines these components and provides the XSLT necessary to verify them.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Data Control" ID="ID_1850785304" CREATED="1586979829320" MODIFIED="1590587597011" HGAP_QUANTITY="16.249999932944775 pt" VSHIFT_QUANTITY="-83.24999751895673 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The challenges of consistently tagging all data with classification,&#160; releasability and visibility information are inherently addressed by XML tools, and organically compatible with validation and verification requirements for ensuring that this information is handled properly.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="APPENDIX A.  Learning Objectives" FOLDED="true" POSITION="right" ID="ID_92282121" CREATED="1586981686436" MODIFIED="1590587689015" HGAP_QUANTITY="34.249999396502986 pt" VSHIFT_QUANTITY="-14.999999552965186 pt">
<edge COLOR="#00ffff"/>
<richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Ideally most of the complex XML functions will be provided as trusted library functions that can be re-used without deep understanding of the process, but even after this happens,&#160;&#160;maintainers and implementers will require enough understanding to avoid inadvertently disabling compromising a critical function.&#160;
    </p>
  </body>
</html>

</richcontent>
<node TEXT="XML Syntax" FOLDED="true" ID="ID_1074999184" CREATED="1590430356480" MODIFIED="1590435253335" HGAP_QUANTITY="17.749999888241295 pt" VSHIFT_QUANTITY="38.99999883770946 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Understand the basic syntax rules of XML, their purpose, and their significance.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="Principles" ID="ID_1866381328" CREATED="1590430381480" MODIFIED="1590432910352" HGAP_QUANTITY="14.749999977648258 pt" VSHIFT_QUANTITY="-3.7499998882412946 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Be able to articulate the principle of &quot;separation of presentation and data.&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Uniform Resource Identifier" ID="ID_588947318" CREATED="1590433119957" MODIFIED="1590434299084"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Understand W3C Uniform Resource Identifier(URI), Uniform Resource Link (URL), and Uniform Resource Name (URN) standards and how they are employed by XML technologies.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="XML Document" ID="ID_1481855053" CREATED="1590430419439" MODIFIED="1590435253334" HGAP_QUANTITY="13.250000022351742 pt" VSHIFT_QUANTITY="3.7499998882412955 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Create a basic XML document that has a practical military purpose
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="XML Schema" FOLDED="true" ID="ID_1203648223" CREATED="1590430356482" MODIFIED="1590433953435" HGAP_QUANTITY="19.24999984353781 pt" VSHIFT_QUANTITY="-0.7499999776482591 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Understand the purpose and use of XML Schema
    </p>
  </body>
</html>
</richcontent>
<node TEXT="XML Schema" ID="ID_840349696" CREATED="1590430356482" MODIFIED="1590433794305" HGAP_QUANTITY="16.249999932944775 pt" VSHIFT_QUANTITY="18.749999441206477 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Create an XML Schema that has a practical military purpose.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="W3C Schema Validation." ID="ID_1088213302" CREATED="1590430791188" MODIFIED="1590433034079" HGAP_QUANTITY="15.499999955296516 pt" VSHIFT_QUANTITY="-14.999999552965177 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Validate the XML Schema&#160;&#160;against the W3C XML Schema Schema using a W3C compliant application.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Instance" ID="ID_1275458363" CREATED="1590430356483" MODIFIED="1590433796065" HGAP_QUANTITY="14.0 pt" VSHIFT_QUANTITY="-24.74999926239254 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Validate the XML instance against the XML Schema using a W3C compliant application.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="XML Validation" FOLDED="true" ID="ID_235804224" CREATED="1590430356484" MODIFIED="1590433948430" HGAP_QUANTITY="18.499999865889553 pt" VSHIFT_QUANTITY="4.499999865889551 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Be able to articulate the purpose and importance of XML validation.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="XML Namespaces" ID="ID_1398934861" CREATED="1590430356487" MODIFIED="1590433788941" HGAP_QUANTITY="17.749999888241295 pt" VSHIFT_QUANTITY="23.999999284744284 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Be able to articulate the purpose and application of XML Namespaces.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Namespace Validation" ID="ID_372208543" CREATED="1590430356486" MODIFIED="1590433791108" HGAP_QUANTITY="17.74999988824129 pt" VSHIFT_QUANTITY="-23.24999930709602 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Create an XML document that incorporates and validates against multiple XML Schemas using XML Namespace declarations and syntax.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Processing" FOLDED="true" ID="ID_1710964681" CREATED="1590430356484" MODIFIED="1590434077459" HGAP_QUANTITY="17.74999988824129 pt" VSHIFT_QUANTITY="-0.7499999776482618 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Use an automated method to produce an XML document that is compliant to an XML Schema.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="Development" ID="ID_1737367691" CREATED="1590430356485" MODIFIED="1590431507486" HGAP_QUANTITY="16.249999932944778 pt" VSHIFT_QUANTITY="13.499999597668669 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Be able to describe the various ways that XML can be created and validated using common tools.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Production" ID="ID_550122747" CREATED="1590431366994" MODIFIED="1590432800949" HGAP_QUANTITY="17.749999888241295 pt" VSHIFT_QUANTITY="-17.249999485909953 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Be able to employ command line tools.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Extensible Stylesheet Language for Transformation (XSLT)" FOLDED="true" ID="ID_58218630" CREATED="1590430356488" MODIFIED="1590434903477" HGAP_QUANTITY="23.749999709427364 pt" VSHIFT_QUANTITY="-30.749999083578615 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Be able to articulate the purpose and potential of XSLT.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="Transform XML" ID="ID_1723194617" CREATED="1590430356488" MODIFIED="1590433653959" HGAP_QUANTITY="23.749999709427367 pt" VSHIFT_QUANTITY="148.49999557435524 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Write an XSLT script to transform an XML document that is valid against one schema to an XML document that is valid against another Schema.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Generate HTML" ID="ID_1785995724" CREATED="1590430356489" MODIFIED="1590433825877" HGAP_QUANTITY="20.74999979883433 pt" VSHIFT_QUANTITY="1.4999999552965178 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Write an XSLT script to transform an XML document that is compliant with an XML Schema to one that is compliant with the W3C XHTML Schema specification for viewing in a web browser.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Generate XML Schema" ID="ID_1803841076" CREATED="1590433552138" MODIFIED="1590433822407" HGAP_QUANTITY="22.999999731779106 pt" VSHIFT_QUANTITY="-6.749999798834333 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Write an XSLT script to generate an XML Schema
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Generate XSLT" ID="ID_1695622641" CREATED="1590433586154" MODIFIED="1590434261832" HGAP_QUANTITY="25.999999642372146 pt" VSHIFT_QUANTITY="-142.49999575316917 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Write an XSLT script to generate another XSLT script
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Schematron" FOLDED="true" ID="ID_359790757" CREATED="1590433853159" MODIFIED="1590435285234" HGAP_QUANTITY="19.249999843537815 pt" VSHIFT_QUANTITY="1.4999999552965155 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Understand the way that this specific implementation of XSLT is used to create rules to validate relational content.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="Verify XML Schema Design" ID="ID_955858469" CREATED="1590434742081" MODIFIED="1590435285233" HGAP_QUANTITY="17.74999988824129 pt" VSHIFT_QUANTITY="22.499999329447768 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Use the Schematron for the NIEM Naming and Design Rules to evaluate an XML Schema
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Validate XML Content" ID="ID_510529262" CREATED="1590434812843" MODIFIED="1590435282353" HGAP_QUANTITY="19.999999821186073 pt" VSHIFT_QUANTITY="-2.6645352591003757E-15 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Use Schematron Rules to validate an XML instance for required contextual relationships
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Validate Security Tags" ID="ID_1098755583" CREATED="1590434905717" MODIFIED="1590435280621" HGAP_QUANTITY="17.74999988824129 pt" VSHIFT_QUANTITY="-32.99999901652339 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Use Schematron Rules to validate the the required uses of XML Schema defined security tags
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Design Strategies" FOLDED="true" ID="ID_1840952706" CREATED="1590431545250" MODIFIED="1590434242498" HGAP_QUANTITY="22.249999754130847 pt" VSHIFT_QUANTITY="5.999999821186069 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Understand the differences between presentation-centric XML, and data-centric XML
    </p>
  </body>
</html>
</richcontent>
<node TEXT="Data&#xad;Dentric XML" ID="ID_1461181341" CREATED="1590430356489" MODIFIED="1590432664455" HGAP_QUANTITY="14.749999977648258 pt" VSHIFT_QUANTITY="87.74999738484628 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Be able to recognize and articulate the purpose of XML Schema that are used to define data objects and formats
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT=" Presentation&#xad;Centric XML" ID="ID_1053450959" CREATED="1590430356491" MODIFIED="1590433680986" HGAP_QUANTITY="14.0 pt" VSHIFT_QUANTITY="-64.49999807775026 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Be able to recognize and articulate the purpose of XML Schema that are used to present or display data objects and formats.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="HTML" ID="ID_1190131667" CREATED="1590432382616" MODIFIED="1590432671270" HGAP_QUANTITY="19.249999843537815 pt" VSHIFT_QUANTITY="-5.249999843537811 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Understand how HTML Data Objects are used by web applications.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Communication Protocols" ID="ID_1485102975" CREATED="1590432403561" MODIFIED="1590433403126" HGAP_QUANTITY="20.749999798834327 pt" VSHIFT_QUANTITY="-4.499999865889549 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Understand how information is transformed for delivery purposes, and the various ways this is accomplished.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="Implementation" FOLDED="true" ID="ID_1814062398" CREATED="1590430356491" MODIFIED="1590435273339" HGAP_QUANTITY="22.9999997317791 pt" VSHIFT_QUANTITY="-7.105427357601002E-15 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Use a web server to create, validate, transform, query and present XML data.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="Cloud Containers" ID="ID_9768686" CREATED="1590435017859" MODIFIED="1590435270930" HGAP_QUANTITY="18.49999986588955 pt" VSHIFT_QUANTITY="47.99999856948857 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Understand how software is tested, build, packaged and deployed to cloud servers.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Cloud Processing" ID="ID_324553953" CREATED="1590435047206" MODIFIED="1590435273338" HGAP_QUANTITY="19.999999821186073 pt" VSHIFT_QUANTITY="-47.24999859184031 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Understand the capabilities and limitations of XML technologies in cloud compute environments, and the recommended best practices.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Data Standards" FOLDED="true" ID="ID_1247060910" CREATED="1590430356492" MODIFIED="1590435007695" HGAP_QUANTITY="19.999999821186073 pt" VSHIFT_QUANTITY="-68.99999794363981 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Be able to articulate the role of XML in standards based architectures.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="Understand the Design of MTF XML" ID="ID_1287234918" CREATED="1590434351663" MODIFIED="1590435007694" HGAP_QUANTITY="20.749999798834327 pt" VSHIFT_QUANTITY="12.7499996200204 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      All of the steps in these objectives can be completed using the example resources.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Understand the Creation of IEPD Schema and Resources" ID="ID_810549211" CREATED="1590434503772" MODIFIED="1590434717031"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Scripts for doing this are provided in the examples.&#160;&#160;If Understanding is achieved in the preceding steps, then it will be possible to re-purpose these examples for use with authoritative MIL STD data.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="_Fileout" POSITION="left" ID="ID_381249361" CREATED="1475710702062" MODIFIED="1590586370127">
<edge COLOR="#0000ff"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      /home/jdn/DATA/Development/MILSTD/MTFXML/USMTF/Doc/Training/MILSTDCBT.html
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="_Subj" POSITION="left" ID="ID_1130198740" CREATED="1475711301439" MODIFIED="1590586072070" VSHIFT_QUANTITY="-20.0 px">
<edge COLOR="#00ffff"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      MTF XML SCHEMA TRAINING
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="_Date" POSITION="left" ID="ID_299078720" CREATED="1475710798573" MODIFIED="1590586094436">
<edge COLOR="#00ff00"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      27 May 2020
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="_Title" POSITION="left" ID="ID_1783696170" CREATED="1475710823436" MODIFIED="1590586117994">
<edge COLOR="#ff00ff"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      XML Schema Design Training for the Message Text Format Military Standard.
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="_bash" LOCALIZED_STYLE_REF="default" POSITION="left" ID="ID_1253692164" CREATED="1513800134836" MODIFIED="1590586742948" HGAP_QUANTITY="11.000000089406964 pt" VSHIFT_QUANTITY="14.249999575316918 pt">
<edge COLOR="#ff0000"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      #!/bin/bash
    </p>
    <p>
      java -cp /home/jdn/DATA/Development/DevRepo/docformat/xslt/saxon9he.jar net.sf.saxon.Transform -s:/home/jdn/DATA/Development/MILSTD/MTFXML/USMTF/Doc/Training/MILSTDCBT.mm -xsl:/home/jdn/DATA/Development/DevRepo/docformat/xslt/mil_format_xslproc.xsl
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
</map>
