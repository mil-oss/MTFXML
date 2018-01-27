<map version="freeplane 1.3.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="MTF_XML_NIEM" ID="ID_1723255651" CREATED="1283093380553" MODIFIED="1502483153503"><hook NAME="MapStyle">

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
<hook NAME="AutomaticEdgeColor" COUNTER="2"/>
<node TEXT="Background" POSITION="right" ID="ID_869001170" CREATED="1500930205756" MODIFIED="1502471126377" HGAP="60" VSHIFT="-30">
<edge COLOR="#0000ff"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Beginning in 2015 the USMTF Configuration Control Board has been refactoring&#160;&#160;XML MTF to achieve NIEM Conformance.&#160;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="NIEM Conformance" POSITION="right" ID="ID_1478427438" CREATED="1502433420760" MODIFIED="1502433560494" HGAP="60" VSHIFT="-20">
<edge COLOR="#ffff00"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The decision to refactor XML MTF to be conformant to NIEM Reference Schema Naming and Design rules was approved by the CCB in 2015.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Prototype Schema" POSITION="right" ID="ID_1063768611" CREATED="1502433977155" MODIFIED="1502470601566" HGAP="60" VSHIFT="10">
<edge COLOR="#7c0000"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      USMC has generated NIEM Conformant Reference Schema to demonstrate complete representation of the MIL STD.&#160;&#160;The attachment provides counts of all required changes and lists each changed Element
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Impact on Instance Doucments" POSITION="right" ID="ID_1531040462" CREATED="1502470603524" MODIFIED="1502482751283" HGAP="60" VSHIFT="20">
<edge COLOR="#00007c"/>
<richcontent TYPE="DETAILS" HIDDEN="true">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Some XML Element Names must be changed changed in order to prevent duplication at the global level, to conform to NIEM Camel Case requirements, or to employ required representation terms.&#160;&#160;This results in changes in XML instance documents, which impact software that does not directly reference the XML Schema for field names and will require updating.&#160;&#160;The attached spreadsheet documents the number of changes, the reason for the changes, the number of changes per message, and a complete listing of all elements that require changes.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Rationale for Changes" POSITION="right" ID="ID_588524402" CREATED="1502471068998" MODIFIED="1502480545399" HGAP="60" VSHIFT="20">
<edge COLOR="#7c007c"/>
<node TEXT="CamelCase" ID="ID_587224022" CREATED="1502471640956" MODIFIED="1502480497440" VSHIFT="30"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The design of existing XML MTF Schema required that some Elements be identified uniquely by appending an underscore with a number.&#160;&#160;This naming is not NIEM conformant for Camel Case naming and is not required when using NIEM naming and design rules.&#160;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="General Text" ID="ID_1487253375" CREATED="1502471315487" MODIFIED="1502480479440" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      All GenText Elements must be unique at the global level.&#160;&#160;This is done by pre-pending a camel case concatenation of the required Text Indicator statement.&#160;&#160;Since most GenText Elements have appended numbers, they violate Camel Case naming requirements and must be changed anyway.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Heading Information" ID="ID_1820948890" CREATED="1502471587568" MODIFIED="1502480514478" VSHIFT="-16"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      All HeadingInformation Elements must be unique at the global level.&#160;&#160;This is done by pre-pending a camel case concatenation of the required Text Indicator statement. Since most HeadingInformation Elements have appended numbers, they violate Camel Case naming requirements and must be changed anyway.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Field Groups" ID="ID_485656121" CREATED="1502472245088" MODIFIED="1502480521802"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The GroupOfFields elements must be unique at the global level.&#160;&#160;For single item groups, the GroupOfFields element is eliminated and cardinality applied to the single element.&#160;&#160;For multiple item groups a FieldGroup element is created by appending &quot;FieldGroup&quot; to the name of the containing Set.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Substitution Groups" ID="ID_25871359" CREATED="1502471923492" MODIFIED="1502480545399" VSHIFT="8"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The use of substitution groups requires that each member has a unique name, and cannot be a member of more than one substitution group.&#160;&#160;These names are only changed when required by pre-appending the name of the parent Entity.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Impact Analysis" POSITION="right" ID="ID_874059769" CREATED="1502480549618" MODIFIED="1502482739690" HGAP="60" VSHIFT="20">
<edge COLOR="#7c7c00"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Because Naming Changes required due to Camel Case rules can either remain, or be accommodated by removing underscore numbers and appending consistent text, the impact may be less than those names that must be changed due to conflicts, field group modification, and substitution group membership.&#160;&#160;Services must evaluate impact on current implementations based on specific messages affected, the types of changes, and the potential difficulty in accomodating those changes.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Courses of Action" POSITION="right" ID="ID_168898236" CREATED="1502482631289" MODIFIED="1502483142343" HGAP="40" VSHIFT="60">
<edge COLOR="#ff0000"/>
<node TEXT="COA 1" ID="ID_1299839378" CREATED="1502482871034" MODIFIED="1502484929020" VSHIFT="-90"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Submit Fields, Composites, Sets, Segments and Messages for inclusion in MIL OPS Domain using NIEM Reference Schema conformant names.&#160;&#160;Field NIEM conformant MTF as a new version for all new implementations.&#160;&#160;Provide transformations to convert instances to and from older versions.
    </p>
  </body>
</html>

</richcontent>
<node TEXT="PRO:" ID="ID_1171108435" CREATED="1502483267296" MODIFIED="1502483472100" HGAP="30" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Leverages NIEM methodology for the implementation of MTF using required external functions.&#160;&#160;These include security tagging, alignment with semantic reference models, and interoperability with other message formats.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="CON:" ID="ID_604252423" CREATED="1502483275722" MODIFIED="1502483470626" HGAP="30" VSHIFT="40"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Requires XML instance names changes that will inhibit implementation by existing software.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="COA 2" ID="ID_775501397" CREATED="1502482979709" MODIFIED="1502484938873" VSHIFT="-40"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Continue to evaluate options with regard to changing NIEM naming and design rule requirements, reducing impact on current message XML instances, and accomodating backward compatibility.
    </p>
  </body>
</html>

</richcontent>
<node TEXT="PRO:" ID="ID_1473794046" CREATED="1502483267296" MODIFIED="1502483749546" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Provides time for services and vendors to evaluate impact on existing software and propose further XML Schema designs.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="CON:" ID="ID_1734882127" CREATED="1502483275722" MODIFIED="1502483745965" VSHIFT="40"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p style="margin-top: 0">
      Ignores three years of the MTF CCB process, delays efforts to achieve NATO alignment, and may not result NIEM conformant XML Schema that can be used to fully leverage the NIEM ecosystem.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="COA 3" ID="ID_832221692" CREATED="1502482791017" MODIFIED="1502484947252" VSHIFT="40"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Submit only Fields and Composites for inclusion in MIL OPS Domain using NIEM Reference Schema conformant names.
    </p>
  </body>
</html>

</richcontent>
<node TEXT="PRO:" ID="ID_885467915" CREATED="1502483267296" MODIFIED="1502483855521" HGAP="30"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Provides MTF fields to the MIL OPS domain for external use by NEIM conformant XML Schema without impacting MTF implementation.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="CON:" ID="ID_1902231113" CREATED="1502483275722" MODIFIED="1502483889562" HGAP="30" VSHIFT="20"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Does not leverage NIEM methodology to implement MTF or enable external functions.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="Recommended Course of Action: COA 1" POSITION="right" ID="ID_695778668" CREATED="1502483144252" MODIFIED="1502483572955" HGAP="30" VSHIFT="50">
<edge COLOR="#0000ff"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Existing software that cannot adjust Element names by referencing XML Schema represents design decisions that should not be encouraged or propagated.&#160;&#160;The advantages of the NIEM methodology far outweigh the impact on legacy software.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="_Fileout" POSITION="left" ID="ID_381249361" CREATED="1475710702062" MODIFIED="1502484982100" HGAP="10" VSHIFT="-40">
<edge COLOR="#0000ff"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      /home/jdn/DATA/Development/MILSTD/MTFXML/Docs/Re-factor/MTF_NIEM_Refactor.html
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="_Subj" POSITION="left" ID="ID_1130198740" CREATED="1475711301439" MODIFIED="1502484509147" VSHIFT="-20">
<edge COLOR="#00ffff"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      NIEM RE-FACTOR DECISION PAPER
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="_Date" POSITION="left" ID="ID_299078720" CREATED="1475710798573" MODIFIED="1502482584672">
<edge COLOR="#00ff00"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      11 Aug 2017
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="_Title" POSITION="left" ID="ID_1783696170" CREATED="1475710823436" MODIFIED="1502484498869">
<edge COLOR="#ff00ff"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      NIEM RE-FACTOR DECISION PAPER
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</map>
