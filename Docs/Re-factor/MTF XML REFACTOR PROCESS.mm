<map version="freeplane 1.3.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="MTF XML REFACTOR PROCESS" ID="ID_1723255651" CREATED="1283093380553" MODIFIED="1452634911766"><hook NAME="MapStyle">

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
<node TEXT="Overview" POSITION="right" ID="ID_755183763" CREATED="1452055299354" MODIFIED="1452633399042" HGAP="30"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      This process is retained for purposes of verification, testing and maintenance.&#160;&#160;It is not necessary for implementers to repeat the effort. &#160;This is a work in progress so it is recommended to refresh project files from https://github.com/mil-oss/MTFXML before execution.
    </p>
  </body>
</html>
</richcontent>
<edge COLOR="#0000ff"/>
<node TEXT="The NormalizedSimpleTypes.xsd file was created using a variety of methods which analyze and compare Regular Expressions. This required subjective decisions which may be adjusted. The XSLT scripts to accomplish this are in the USMTF/XSLT/Normalization/work directory." ID="ID_801444743" CREATED="1445639481024" MODIFIED="1452632517874" VSHIFT="-40"/>
<node TEXT="The XSLT scripts to generate the normalized simpleTypes are located in the USMTF/XSLT/Normalization directory. Data products are located in the USMTF/XSD/Normalized/work directory." ID="ID_1576488055" CREATED="1445639481024" MODIFIED="1452632513890" VSHIFT="-30"/>
<node TEXT="The Strings.xsl, Numerics.xsl, and Enumerations.xsl scripts can be executed in any order. Results are written to the USMTF/XSD/Normalized directory." ID="ID_27694232" CREATED="1445639481024" MODIFIED="1452632506338" HGAP="30" VSHIFT="-30"/>
<node TEXT="The GoE_Fields.xsl script consolidates the Strings.xsd, Integers.xsd, Decimals.xsd and Enumerations.xsd files into the GoE_field.xsd document which is stored in the USMTF/XSD/GoE_Schema directory." ID="ID_1037640678" CREATED="1445639481024" MODIFIED="1452632503170" HGAP="30" VSHIFT="-30"/>
<node TEXT="Sets Re-factor" ID="ID_1626783819" CREATED="1445639481024" MODIFIED="1452637223099" HGAP="30" VSHIFT="-40"><richcontent TYPE="DETAILS">

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
<node TEXT="Segments Re-factor" ID="ID_1143867056" CREATED="1445639481024" MODIFIED="1452637236284"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Segments are extracted from messages to provide the opportunity for re-use.&#160;&#160;A new Complex Type, SegmentBaseType, is included to insert ICM security attribute group and for further Segment level extension.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Messages Re-factor" ID="ID_1347675679" CREATED="1445639481024" MODIFIED="1452632474249" VSHIFT="40">
<node TEXT="Element Name Changes" ID="ID_464775862" CREATED="1445639481024" MODIFIED="1452632456892"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      One of the goals for the re-factor was to minimize impact on current XML Instance documents.&#160;&#160;In the case of General Text and Heading Information fields the proposed change adds field names which are specific to the required content and eliminate the need to distinguish XML nodes by appending numbers.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="General Text Re-factor" ID="ID_1902399333" CREATED="1445639481024" MODIFIED="1452632433215" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
              <head> </head>
              <body>
                <p> This only applies to USMTF.&#160;&#160;It was implemented in order to include fixed required values in the TextIdentification
                  field using XML extension.&#160;&#160;This eliminates all rules specifying these values since they are verified by XML
                  validation.&#160;&#160;This reduces the size of the XML Schema and reduces the additional rules implementation requirement. </p>
              </body>
            </html>
</richcontent>
</node>
<node TEXT="Heading Information Re-factor" ID="ID_297034551" CREATED="1445639481024" MODIFIED="1452638298214" VSHIFT="20"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    This only applies to USMTF.&#160;&#160;&#160;This proposed change adds descriptive field names which are specific to the required content and eliminate the need to distinguish XML nodes by appending numbers.&#160;&#160;This will affect XML instances and will require mitigation with Baseline XML instances.
  </body>
</html>

</richcontent>
</node>
<node TEXT="Message Identification" ID="ID_463120136" CREATED="1445639481024" MODIFIED="1452638014524" VSHIFT="20"><richcontent TYPE="DETAILS">

<html>
              <head> </head>
              <body>
                <p> This proposed change adds fixed values to the Message XML Schema in order to </p>
                <p> allow validation of Standard, MessageTextFormatIdentifier, and VersionOfMessageFormat using XML validation instead of </p>
                <p> requiring rules. </p>
              </body>
            </html>
</richcontent>
</node>
</node>
</node>
<node TEXT="Resources" POSITION="right" ID="ID_1019827985" CREATED="1452057202943" MODIFIED="1452632374638" HGAP="30" VSHIFT="40">
<edge COLOR="#00ff00"/>
<node TEXT="Details" ID="ID_798589553" CREATED="1452057937057" MODIFIED="1452632526914" VSHIFT="-50">
<node TEXT="These are documents created by human analysis of database and XML Schema nodes in order to eliminate duplication at the global levels of XML Schema,  normalize XML Schema types, and make other changes to annotations and naming." ID="ID_1030517086" CREATED="1452057523914" MODIFIED="1452632543357"/>
<node TEXT="Original products have been created as spreadsheets.  XSLT is used to convert XML versions of these spreadsheets to XML for further XSLT processing as part of the re-factor.  The conversion XSLT are dependent on Microsoft XML export from Excel but can be adjusted to accomodate any XML format for spreadsheets.  Conversion of Spreadsheets to XML is not included in this process." ID="ID_631041127" CREATED="1452057589227" MODIFIED="1452632570993" VSHIFT="10"/>
<node TEXT="All analysis and proposed changes has been conducted using USMTF.  No process has been conducted for NATO MTF.  USMTF changes are applied to NATO MTF where matches occur.  USMTF required changes are due to naming conflicts at the global level.  Normalization changes are design recommendations which pertain to re-use of fields.  Of note, NATO MTF does not require naming de-confliction changes." ID="ID_1448561967" CREATED="1452058184822" MODIFIED="1452632573586"/>
<node TEXT="These changes are subjective and subject to approval by standards bodies.  Adjustments to these files will propagate into the final refactored XML Schema." ID="ID_641612330" CREATED="1452057564702" MODIFIED="1452632575895"/>
<node TEXT="Because these documents are derived from restricted data sources they cannot be made publicly available." ID="ID_976770940" CREATED="1452057820165" MODIFIED="1452632578433" VSHIFT="-2"/>
</node>
<node TEXT="File Organization" ID="ID_731121526" CREATED="1452110718082" MODIFIED="1452632529369" HGAP="30">
<node TEXT="The public file structure can be downloaded from https://github.com/mil-oss/MTFXML as a .zip file and extracted.  Symbolic links must be added as indicated.  Only required directories are included.  Generated files are in bold face." ID="ID_1595635317" CREATED="1452110750177" MODIFIED="1452633404012"/>
<node TEXT="MTFXML" ID="ID_1541735849" CREATED="1452111107642" MODIFIED="1452111111601">
<node TEXT="USMTF" ID="ID_1195687773" CREATED="1452110833954" MODIFIED="1452111104548" VSHIFT="-40">
<node TEXT="XSD" ID="ID_1014612965" CREATED="1452110867682" MODIFIED="1452112488570" VSHIFT="-20">
<node TEXT="Baseline_Schema (Symbolic Link)" ID="ID_236836289" CREATED="1452112277349" MODIFIED="1452640208052">
<node TEXT="composites.xsd" ID="ID_1622086947" CREATED="1452111687588" MODIFIED="1452112320521"/>
<node TEXT="fields.xsd" ID="ID_717729141" CREATED="1452111710553" MODIFIED="1452112325734"/>
<node TEXT="messages.xsd" ID="ID_1774286366" CREATED="1452111713781" MODIFIED="1452112333597"/>
<node TEXT="sets.xsd" ID="ID_765854000" CREATED="1452111715380" MODIFIED="1452112340900"/>
<node TEXT="IC-ISM-v2.xsd" ID="ID_1588986314" CREATED="1452112344117" MODIFIED="1452112352764"/>
</node>
<node TEXT="Deconflicted (Symbolic Link)" ID="ID_633833504" CREATED="1452112283572" MODIFIED="1452640212827">
<node TEXT="M2014-10-C0-F Segment Deconfliction.xlsx" ID="ID_1514907195" CREATED="1452112375082" MODIFIED="1452112376158"/>
<node TEXT="M201503C0VF-Set Deconfliction.xlsx" ID="ID_942777356" CREATED="1452112392726" MODIFIED="1452112393764"/>
<node TEXT="Segment_DeconflictionEXCEL.xml" ID="ID_463068208" CREATED="1452112435885" MODIFIED="1452112445124"/>
<node TEXT="Segment_Name_Changes.xml" ID="ID_706739453" CREATED="1452112445735" MODIFIED="1452112554901">
<font BOLD="true" ITALIC="false"/>
</node>
<node TEXT="Set_DeconflictionEXCEL.xml" ID="ID_1770162256" CREATED="1452112455861" MODIFIED="1452112464053"/>
<node TEXT="Set_Name_Changes.xml" ID="ID_1560884682" CREATED="1452112464570" MODIFIED="1452112558141">
<font BOLD="true"/>
</node>
</node>
<node TEXT="GoE_Schema (Symbolic Link)" ID="ID_376440188" CREATED="1452112291381" MODIFIED="1452640216181" VSHIFT="20">
<node TEXT="SeparateMessages" ID="ID_227411434" CREATED="1452111652869" MODIFIED="1452112664637" VSHIFT="2"><richcontent TYPE="DETAILS">

<html>
                        <head> </head>
                        <body>
                          <p> This directory is the target for directories for each message with separate XML Schema </p>
                        </body>
                      </html>
</richcontent>
<font BOLD="true"/>
</node>
<node TEXT="SeparateMessagesUnified" ID="ID_1107607649" CREATED="1452111676245" MODIFIED="1452112667484" VSHIFT="-10"><richcontent TYPE="DETAILS">

<html>
                        <head> </head>
                        <body>
                          <p> This directory This directory is the target for unified XML Schema for each message </p>
                        </body>
                      </html>
</richcontent>
<font BOLD="true"/>
</node>
<node TEXT="GoE_fields.xsd" ID="ID_1804629170" CREATED="1452112610478" MODIFIED="1452112657941">
<font BOLD="true"/>
</node>
<node TEXT="GoE_messages.xsd" ID="ID_116832804" CREATED="1452112613012" MODIFIED="1452112657945">
<font BOLD="true"/>
</node>
<node TEXT="GoE_segments.xsd" ID="ID_791097691" CREATED="1452112613757" MODIFIED="1452112657945">
<font BOLD="true"/>
</node>
<node TEXT="GoE_sets.xsd" ID="ID_1435990625" CREATED="1452112614243" MODIFIED="1452112657946">
<font BOLD="true"/>
</node>
<node TEXT="IC-ISM-v2.xsd" ID="ID_1693254149" CREATED="1452112344117" MODIFIED="1452112352764"/>
</node>
<node TEXT="Normalized (Symbolic Link)" ID="ID_872187799" CREATED="1452112297205" MODIFIED="1452640220709" VSHIFT="50">
<node TEXT="Decimals.xsd" ID="ID_4441201" CREATED="1452111979445" MODIFIED="1452113357192">
<font BOLD="true"/>
</node>
<node TEXT="Enumerations.xsd" ID="ID_110361963" CREATED="1452111989653" MODIFIED="1452113357189">
<font BOLD="true"/>
</node>
<node TEXT="IC-ISM-v2.xsd" ID="ID_1996738379" CREATED="1452112344117" MODIFIED="1452113360757">
<font BOLD="false"/>
</node>
<node TEXT="Integers.xsd" ID="ID_1136135183" CREATED="1452111997957" MODIFIED="1452113357196">
<font BOLD="true"/>
</node>
<node TEXT="NormalizedSimpleTypes.xsd" ID="ID_1488951463" CREATED="1452112773365" MODIFIED="1452112782062"/>
<node TEXT="Strings.xsd" ID="ID_485890484" CREATED="1452112003525" MODIFIED="1452113357196">
<font BOLD="true"/>
</node>
</node>
</node>
<node TEXT="XSLT" ID="ID_139121012" CREATED="1452111048451" MODIFIED="1452111051379">
<node TEXT="Deconfliction" ID="ID_194521415" CREATED="1452111053043" MODIFIED="1452111059935">
<node TEXT="SegmentsSpreadsheetToXML.xsl" ID="ID_1013422631" CREATED="1452113777970" MODIFIED="1452113779964"/>
<node TEXT="SetsSpreadsheetToXML.xsl" ID="ID_1521851024" CREATED="1452113781110" MODIFIED="1452113789494"/>
</node>
<node TEXT="Normalization" ID="ID_253961957" CREATED="1452111074467" MODIFIED="1452113825365">
<node TEXT="Enumerations.xsl" ID="ID_180699046" CREATED="1452113822086" MODIFIED="1452113830634"/>
<node TEXT="Numerics.xsl" ID="ID_256313295" CREATED="1452113845174" MODIFIED="1452113846245"/>
<node TEXT="Strings.xsl" ID="ID_548220526" CREATED="1452113847208" MODIFIED="1452113857052"/>
</node>
<node TEXT="Fields" ID="ID_770576093" CREATED="1452111060403" MODIFIED="1452111068438"/>
<node TEXT="Messages" ID="ID_1706599850" CREATED="1452111069636" MODIFIED="1452111073346"/>
<node TEXT="Segments" ID="ID_1950053251" CREATED="1452111078611" MODIFIED="1452111087778"/>
<node TEXT="Sets" ID="ID_173712794" CREATED="1452111088243" MODIFIED="1452111092353"/>
<node TEXT="USMTF_GoE" ID="ID_329153772" CREATED="1452111093172" MODIFIED="1452111156708"/>
</node>
</node>
<node TEXT="NATO_MTF" ID="ID_1522850166" CREATED="1452111127876" MODIFIED="1452111479401">
<node TEXT="XSD" ID="ID_108629185" CREATED="1452111194549" MODIFIED="1452114088719">
<node TEXT="APP-11C-ch1  (Symbolic Link)" ID="ID_13235046" CREATED="1452111053043" MODIFIED="1452114113127" VSHIFT="-20"><richcontent TYPE="DETAILS">

<html>
                      <head> </head>
                      <body>
                        <p> This directory contains source XML Schema </p>
                      </body>
                    </html>
</richcontent>
<node TEXT="Consolidated" ID="ID_1671451576" CREATED="1452111635605" MODIFIED="1452114116822" VSHIFT="30">
<font BOLD="true"/>
<node TEXT="composites.xsd" ID="ID_106055362" CREATED="1452114144027" MODIFIED="1452114176984">
<font BOLD="true"/>
</node>
<node TEXT="fields.xsd" ID="ID_616120671" CREATED="1452114147866" MODIFIED="1452114176985">
<font BOLD="true"/>
</node>
<node TEXT="messages.xsd" ID="ID_1325301756" CREATED="1452114149913" MODIFIED="1452114176985">
<font BOLD="true"/>
</node>
<node TEXT="sets.xsd" ID="ID_390582601" CREATED="1452114154486" MODIFIED="1452114176981">
<font BOLD="true"/>
</node>
</node>
<node TEXT="Messages" ID="ID_1865831856" CREATED="1452111628084" MODIFIED="1452114260289" VSHIFT="-30"><richcontent TYPE="DETAILS">

<html>
                        <head> </head>
                        <body>
                          <p> This directory contains directories with separate XML Schema files for every NATO MTF Message. </p>
                        </body>
                      </html>
</richcontent>
</node>
</node>
<node TEXT="APP-11C-GoE  (Symbolic Link)" ID="ID_815369220" CREATED="1452111235204" MODIFIED="1452112194218"><richcontent TYPE="DETAILS">

<html>
                      <head> </head>
                      <body>
                        <p> This directory contains re-factored XML Schema </p>
                      </body>
                    </html>
</richcontent>
<node TEXT="SeparateMessages" ID="ID_1152324782" CREATED="1452111652869" MODIFIED="1452114100661" VSHIFT="-8"><richcontent TYPE="DETAILS">

<html>
                        <head> </head>
                        <body>
                          <p> This directory is the target for directories for each message with separate XML Schema </p>
                        </body>
                      </html>
</richcontent>
<font BOLD="true"/>
</node>
<node TEXT="SeparateMessagesUnified" ID="ID_824171285" CREATED="1452111676245" MODIFIED="1452114100664" VSHIFT="-10"><richcontent TYPE="DETAILS">

<html>
                        <head> </head>
                        <body>
                          <p> This directory This directory is the target for unified XML Schema for each message </p>
                        </body>
                      </html>
</richcontent>
<font BOLD="true"/>
</node>
<node TEXT="natomtf_goe_fields.xsd" ID="ID_1872359051" CREATED="1452111687588" MODIFIED="1452114100665">
<font BOLD="true"/>
</node>
<node TEXT="natomtf_goe_messages.xsd" ID="ID_246941008" CREATED="1452111710553" MODIFIED="1452114100666">
<font BOLD="true"/>
</node>
<node TEXT="natomtf_goe_segments.xsd" ID="ID_1751372165" CREATED="1452111713781" MODIFIED="1452114100666">
<font BOLD="true"/>
</node>
<node TEXT="natomtf_goe_sets.xsd" ID="ID_857737033" CREATED="1452111715380" MODIFIED="1452114100667">
<font BOLD="true"/>
</node>
</node>
<node TEXT="Normalized  (Symbolic Link)" ID="ID_1223195950" CREATED="1452111074467" MODIFIED="1452112207238" VSHIFT="10">
<node TEXT="Decimals.xsd" ID="ID_1525509594" CREATED="1452111979445" MODIFIED="1452113374781">
<font BOLD="true"/>
</node>
<node TEXT="Enumerations.xsd" ID="ID_621037728" CREATED="1452111989653" MODIFIED="1452113374784">
<font BOLD="true"/>
</node>
<node TEXT="Integers.xsd" ID="ID_1110442442" CREATED="1452111997957" MODIFIED="1452113374785">
<font BOLD="true"/>
</node>
<node TEXT="NormalizedSimpleTypes.xsd" ID="ID_1478836241" CREATED="1452112773365" MODIFIED="1452112782062"/>
<node TEXT="Strings.xsd" ID="ID_580861529" CREATED="1452112003525" MODIFIED="1452113374786">
<font BOLD="true"/>
</node>
</node>
</node>
<node TEXT="XSLT" ID="ID_955728469" CREATED="1452111205636" MODIFIED="1452114075758" VSHIFT="20">
<node TEXT="APP-11C-ch1" ID="ID_667847173" CREATED="1452111053043" MODIFIED="1452111232351">
<node TEXT="ConsolidateComposites.xsl" ID="ID_718534932" CREATED="1452114000899" MODIFIED="1452114002238"/>
<node TEXT="ConsolidateFields.xsl" ID="ID_1257504374" CREATED="1452114003530" MODIFIED="1452114019390"/>
<node TEXT="ConsolidateMessages.xsl" ID="ID_734257333" CREATED="1452114005079" MODIFIED="1452114027061"/>
<node TEXT="ConsolidateSets.xsl" ID="ID_1485500642" CREATED="1452114010474" MODIFIED="1452114033478"/>
<node TEXT="MessageList.xsl" ID="ID_570551974" CREATED="1452114036534" MODIFIED="1452114043991"/>
</node>
<node TEXT="APP-11C-GoE" ID="ID_29460674" CREATED="1452111235204" MODIFIED="1452114074110" VSHIFT="20">
<node TEXT="NATO_GoE_Fields.xsl" ID="ID_360034418" CREATED="1452113924473" MODIFIED="1452113925895"/>
<node TEXT="NATO_GoE_Messages.xsl" ID="ID_628802145" CREATED="1452113927306" MODIFIED="1452113946646"/>
<node TEXT="NATO_GoE_Segments.xsl" ID="ID_473925147" CREATED="1452113928919" MODIFIED="1452113957038"/>
<node TEXT="NATO_GoE_Sets.xsl" ID="ID_632173317" CREATED="1452113930505" MODIFIED="1452113969125"/>
</node>
<node TEXT="Normalization" ID="ID_558109070" CREATED="1452111074467" MODIFIED="1452114075758" VSHIFT="10">
<node TEXT="Enumerations.xsl" ID="ID_1932019267" CREATED="1452113822086" MODIFIED="1452113830634"/>
<node TEXT="Numerics.xsl" ID="ID_543316145" CREATED="1452113845174" MODIFIED="1452113846245"/>
<node TEXT="Strings.xsl" ID="ID_127894629" CREATED="1452113847208" MODIFIED="1452113857052"/>
</node>
</node>
</node>
</node>
</node>
<node TEXT="Proposed Changes" ID="ID_1404951550" CREATED="1452058006007" MODIFIED="1452632531465" HGAP="30" VSHIFT="50">
<node TEXT="Deconfliction" ID="ID_797983520" CREATED="1452058053849" MODIFIED="1452632608903" VSHIFT="-20">
<node TEXT="Set Name De-confliction" ID="ID_1926053031" CREATED="1452058379901" MODIFIED="1452632615600" VSHIFT="-20">
<node TEXT="Spreadsheet" ID="ID_457997207" CREATED="1452058627942" MODIFIED="1452632622961"><richcontent TYPE="DETAILS">

<html>
                  <head> </head>
                  <body>
                    <p> MTFXML/USMTF/XSD/Deconflicted/M201503C0VF-Set Deconfliction.xlsx </p>
                  </body>
                </html>
</richcontent>
</node>
<node TEXT="XML Export" ID="ID_1270052326" CREATED="1452109195501" MODIFIED="1452632625342"><richcontent TYPE="DETAILS">

<html>
                  <head> </head>
                  <body>
                    <p> MTFXML/USMTF/XSD/Deconflicted/Set_DeconflictionEXCEL.xml </p>
                  </body>
                </html>
</richcontent>
</node>
<node TEXT="Conversion XSLT" ID="ID_353540863" CREATED="1452058677362" MODIFIED="1452632627585" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
                  <head> </head>
                  <body>
                    <p> MTFXML/USMTF/XSLT/Deconfliction/SetsSpreadsheetToXML.xsl </p>
                  </body>
                </html>
</richcontent>
</node>
<node TEXT="XML Resource" ID="ID_1469958833" CREATED="1452062764562" MODIFIED="1452632631779"><richcontent TYPE="DETAILS">

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
<node TEXT="Segment Name De-confliction" ID="ID_1365767823" CREATED="1452058404046" MODIFIED="1452632619319">
<node TEXT="Spreadsheet" ID="ID_111914636" CREATED="1452058627942" MODIFIED="1452632637162"><richcontent TYPE="DETAILS">

<html>
                  <head> </head>
                  <body>
                    <p> MTFXML/USMTF/XSD/Deconflicted/M2014-10-C0-F Segment Deconfliction.xlsx </p>
                  </body>
                </html>
</richcontent>
</node>
<node TEXT="Conversion XSLT" ID="ID_199055785" CREATED="1452058677362" MODIFIED="1452632641503" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
                  <head> </head>
                  <body>
                    <p> MTFXML/USMTF/XSLT/Deconfliction/SegmentsSpreadsheetToXML.xsl </p>
                  </body>
                </html>
</richcontent>
</node>
<node TEXT="XML Resource" ID="ID_1161760396" CREATED="1452062764562" MODIFIED="1452632643626"><richcontent TYPE="DETAILS">

<html>
                  <head> </head>
                  <body>
                    <p> MTFXML/USMTF/XSLT/Deconfliction/Segment_Name_Changes.xml </p>
                    <p> MTFXML/NATO_MTF/XSD/Deconflicted/Set_Name_Changes.xml </p>
                  </body>
                </html>
</richcontent>
</node>
</node>
</node>
<node TEXT="Normalization" ID="ID_1119709898" CREATED="1452058073587" MODIFIED="1452632612715">
<node TEXT="Field Normalization proposal is a result of detailed analysis which was not automated.  This process is not covered in this guidance.  The source proposal and results are provided in spreadsheet and XML Schema form.  The NormalizedSimpleTypes.xsd XML Schema is used to generate separate files for XSD SimpleTypes which are then used to generate the fields.xsd XML Schema.  US and NATO normalizations are largely aligned but there are differences based on content." ID="ID_644784010" CREATED="1452063173424" MODIFIED="1452632664990"/>
<node TEXT="Proposed Field Name Changes Spreadsheet" ID="ID_1219067599" CREATED="1452063344839" MODIFIED="1452632671213" VSHIFT="14"><richcontent TYPE="DETAILS">

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
<node TEXT="Proposed SimpleType Normalizations" ID="ID_1614469621" CREATED="1452063467395" MODIFIED="1452632675080" VSHIFT="60">
<node TEXT="USMTF" ID="ID_1049035254" CREATED="1452113148229" MODIFIED="1452632945614" VSHIFT="-20"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      MTFXML/USMTF/XSD/Normalized/NormalizedSimpleTypes.xsd
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="NATO MTF" ID="ID_1743269012" CREATED="1452113150886" MODIFIED="1452632958267" VSHIFT="10"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      MTFXML/NATO_MTF/XSD/Normalized/NormalizedSimpleTypes.xsd
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
</node>
</node>
<node TEXT="XSLT Processing" POSITION="right" ID="ID_1168431341" CREATED="1452066189880" MODIFIED="1452633117388" VSHIFT="30">
<edge COLOR="#00ffff"/>
<node TEXT="All XSLT files use XSLT 2.0 xsl:document and xsl:result-document elements to specify inputs and outputs instead of requiring that these links be specified at processing time." ID="ID_1454212290" CREATED="1452066211891" MODIFIED="1452632709793" VSHIFT="-20"/>
<node TEXT="To process XSLT using and IDE or command line it is necessary to designate the main named template.  This is uniformly named &quot;main&quot; in every XSLT." ID="ID_178065227" CREATED="1452066559480" MODIFIED="1452632706883" VSHIFT="-20"/>
<node TEXT="XML Schema, XML resources, and results are all programmed to remain in directories which are defined as symbolic links in order to ensure that restricted information is not included in the project.  It is important to retain this design." ID="ID_592650779" CREATED="1452066373730" MODIFIED="1452633117384"/>
<node TEXT="All processes need to be executed in the specified order because each XSLT is designed to consume results of prior XSLT." ID="ID_983001900" CREATED="1452066952564" MODIFIED="1452632695530" VSHIFT="20"/>
</node>
<node TEXT="Refactored USMTF XML Schema Generation" POSITION="right" ID="ID_1595577374" CREATED="1452057516613" MODIFIED="1452632380208" VSHIFT="30">
<edge COLOR="#ff00ff"/>
<node TEXT="Generate Changes XML" ID="ID_463924320" CREATED="1452065932307" MODIFIED="1452632717805" VSHIFT="20">
<node TEXT="Run XSLT: MTFXML/USMTF/XSLT/Deconfliction/SegmentsSpreadsheetToXML.xsl" ID="ID_46924234" CREATED="1452106141909" MODIFIED="1452632883405"/>
<node TEXT="Run XSLT: MTFXML/USMTF/XSLT/Deconfliction/SetsSpreadsheetToXML.xsl" ID="ID_1623228197" CREATED="1452106187060" MODIFIED="1452632886130"/>
</node>
<node TEXT="Generate Re-Factor XML Schema" ID="ID_1038478486" CREATED="1452065936327" MODIFIED="1452632763097" VSHIFT="20">
<node TEXT="Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/NATO_GoE_fields.xsl" ID="ID_603830278" CREATED="1452583805971" MODIFIED="1452632722101"/>
<node TEXT="Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/NATO_GoE_sets.xsl" ID="ID_1056765884" CREATED="1452583808500" MODIFIED="1452632738662"/>
<node TEXT="Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/NATO_GoE_segments.xsl" ID="ID_328976642" CREATED="1452583809534" MODIFIED="1452632740648"/>
<node TEXT="Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/NATO_GoE_messages.xsl" ID="ID_1618304725" CREATED="1452583810244" MODIFIED="1452632742762"/>
</node>
</node>
<node TEXT="Refactored NATO XML Schema Generation" POSITION="right" ID="ID_1731516315" CREATED="1452057516613" MODIFIED="1452632388066" VSHIFT="30">
<edge COLOR="#ff00ff"/>
<node TEXT="Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/GoE_Fields.xsl" ID="ID_1116581390" CREATED="1452065932307" MODIFIED="1452633266376" VSHIFT="30"/>
<node TEXT="Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/GoE_Sets.xsl" ID="ID_367004354" CREATED="1452065936327" MODIFIED="1452633305128"/>
<node TEXT="Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/GoE_Segments.xsl" ID="ID_939061477" CREATED="1452583811060" MODIFIED="1452633313484"/>
<node TEXT="Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/GoE_Messages.xsl" ID="ID_1529813174" CREATED="1452583811060" MODIFIED="1452633319363" VSHIFT="-30"/>
</node>
</node>
</map>
