<map version="freeplane 1.3.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="USMTF XML" ID="ID_1723255651" CREATED="1283093380553" MODIFIED="1504295051452"><hook NAME="MapStyle">

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
<hook NAME="AutomaticEdgeColor" COUNTER="6"/>
<node TEXT="Background" POSITION="right" ID="ID_706525406" CREATED="1504144496330" MODIFIED="1505147800470" HGAP="90" VSHIFT="70">
<edge COLOR="#00ffff"/>
<node TEXT="NIEM Conformant MTF XML Schema" ID="ID_1318613280" CREATED="1504145675403" MODIFIED="1505147796925" VSHIFT="-20"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Beginning in 2015 the USMTF Configuration Control Board has been working to refactor XML MTF to achieve NIEM Conformance.&#160;&#160;USMC has generated NIEM Conformant Reference Schema to demonstrate complete representation of the MIL STD using several different formats.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Single Namespace" ID="ID_102184564" CREATED="1504145684688" MODIFIED="1505147798215"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The original MTF Schema use separate namespaces for fields, composites, sets, and messages.&#160;&#160;The reference Schema are provided in this format with separate files for fields, composites, sets, segments, and messages, as well as in a single namespace format with one file for each message.&#160;&#160;Additional name changes required for single namespace.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Conformance Levels" ID="ID_493338900" CREATED="1504145690978" MODIFIED="1505147801197" VSHIFT="20"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Because of a recent concern with the Impact of renamed Elements on existing software, the Schema generated with minimum names changes for Garden of Eden and NIEM, as well as with fully conformant NIEM names.&#160;&#160;Full conformance requires even more changes.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Changes" ID="ID_1032107218" CREATED="1504146158907" MODIFIED="1505147802921" VSHIFT="20"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The number of changes, per message breakout, and the types of changes can be compared using the Change Analysis Viewer.&#160;&#160;Impact estimates are provided in the Analysis section of this document.&#160;&#160;Data from this tool can be downloaded as XML or copied and pasted into spreadsheets.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Schema Prototypes" POSITION="right" ID="ID_740130537" CREATED="1504142581267" MODIFIED="1504147092052" HGAP="50" VSHIFT="20">
<edge COLOR="#ff0000"/>
<node TEXT="Multiple Namespace - Limited NIEM naming" ID="ID_507732308" CREATED="1504142631275" MODIFIED="1505147804739" VSHIFT="-10"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      This makes name&#160;&#160;changes only when required for global name de-confliction, or in cases where NIEM Naming and Design rules are not relaxed.&#160;&#160;Validation with the NIEM NDR 3.0 Schematron results in multiple&#160;&#160;&quot;MUST&quot; errors.&#160;&#160;Validation with the NIEM NDR 4.0 Schematron results in multiple &quot;SHOULD&quot; errors.&#160;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Single Namespace - Limited NIEM naming" ID="ID_1490254624" CREATED="1504142657226" MODIFIED="1505147807241"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      This makes name&#160;&#160;changes&#160;&#160;when required for global name de-confliction, in cases where NIEM Naming and Design rules are not relaxed, and in order to mitigate common naming between the different namespaces..&#160;&#160;Validation with the NIEM NDR 3.0 Schematron results in multiple&#160;&#160;&quot;MUST&quot; errors.&#160;&#160;Validation with the NIEM NDR 4.0 Schematron results in multiple &quot;SHOULD&quot; errors.&#160;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Single Namespace - Full NIEM naming" ID="ID_1526713325" CREATED="1504142673025" MODIFIED="1505147808715" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      This makes name&#160;&#160;changes&#160;&#160;when required for global name de-confliction, in cases where NIEM Naming and Design rules are not relaxed, and in order to mitigate common naming between the different namespaces, as well as to achieve full NIEM NDR 4.0 conformance.&#160;&#160;Validation with the NIEM NDR 3.0 or 4.0 Schematron results in no errors.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Verification Tests" POSITION="right" ID="ID_811133061" CREATED="1504142746149" MODIFIED="1504295051451" HGAP="50" VSHIFT="-20">
<edge COLOR="#ff00ff"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Schematron was used to create rules which validate context and metadata values in order to ensure the validity of the generated XML Schema.&#160; This functions independently of documentation and node naming, but these can be added once changes are complete.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="Verified Components" ID="ID_41591565" CREATED="1504143841475" MODIFIED="1504147751156" VSHIFT="-50"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      All Nodes in the Prototype XML Schema are compared with counterparts in the Baseline Schema to verify completeness and accuracy.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Schematron Rules" ID="ID_1299401048" CREATED="1504143832211" MODIFIED="1504147644941"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Each rule verifies the existence of a particular component, and compares the values of several attributes to those in the Baseline Schema.&#160;&#160;All paths and values are generated from the Baseline Schema using XSLT.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Instance Element Name Changes" POSITION="right" ID="ID_403122246" CREATED="1504142597353" MODIFIED="1504295048052" HGAP="50" VSHIFT="-30">
<edge COLOR="#0000ff"/>
<node TEXT="Analysis" ID="ID_77971403" CREATED="1504143800258" MODIFIED="1504144693440"/>
<node TEXT="Conclusions" ID="ID_80223871" CREATED="1504143809879" MODIFIED="1504144691918" VSHIFT="10"/>
</node>
<node TEXT="Resources" POSITION="right" ID="ID_447372735" CREATED="1504142621558" MODIFIED="1504295045535" HGAP="50" VSHIFT="-140">
<edge COLOR="#00ff00"/>
<node TEXT="XML Schema Browser" ID="ID_224788926" CREATED="1504144444546" MODIFIED="1504144685184" VSHIFT="-10"/>
<node TEXT="Change Analysis Viewer" ID="ID_428279350" CREATED="1504144519158" MODIFIED="1504144677668"/>
<node TEXT="Discussion" ID="ID_257781932" CREATED="1504144452779" MODIFIED="1504144687307" VSHIFT="10"/>
</node>
<node TEXT="_Fileout" POSITION="left" ID="ID_381249361" CREATED="1475710702062" MODIFIED="1505147854012" HGAP="10" VSHIFT="-40">
<edge COLOR="#0000ff"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      /home/jdn/DATA/Neushul_Solutions/Projects/MILSTD/Papers/NIEM_MTF_REFACTOR_.html
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="_Subj" POSITION="left" ID="ID_1130198740" CREATED="1475711301439" MODIFIED="1505147883194" VSHIFT="-20">
<edge COLOR="#00ffff"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      XML MTF NIEM Refactor Analysis
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="_Date" POSITION="left" ID="ID_299078720" CREATED="1475710798573" MODIFIED="1502316424893">
<edge COLOR="#00ff00"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      09 Aug 2017
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="_Title" POSITION="left" ID="ID_1783696170" CREATED="1475710823436" MODIFIED="1505147902193">
<edge COLOR="#ff00ff"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      ANALYSIS OF NIEM REFACTOR OPTIONS
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
</map>
