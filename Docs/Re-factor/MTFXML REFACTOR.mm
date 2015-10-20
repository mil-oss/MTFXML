<map version="freeplane 1.3.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="MTFXML REFACTOR" ID="ID_1723255651" CREATED="1283093380553" MODIFIED="1445284475804"><hook NAME="MapStyle">

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
<node TEXT="Background" POSITION="right" ID="ID_396111513" CREATED="1444853751150" MODIFIED="1445284456812">
<edge COLOR="#ff00ff"/>
<node TEXT="The current XML Schema for US and NATO MTF are designed for piecemeal implementation of messages based on commonly defined XML nodes which are maintained in relational databases.  This makes normalization, re-use, and configuration management difficult." ID="ID_199156720" CREATED="1444853786014" MODIFIED="1445284302206" VSHIFT="-10"/>
<node TEXT="Because the current XML Schema design does not support implementation of the entire standard, there are persistent mismatches of messages implemented and versions across systems." ID="ID_1369603701" CREATED="1444854247374" MODIFIED="1444855622928" VSHIFT="-20"/>
<node TEXT="The re-factor of these standards to a Garden of Eden XML Schema Design model allows provisioning of consolidated XML Schema files with a manageable sizes to allow complete implementation of every message using a uniform and re-usable methodology." ID="ID_1109438859" CREATED="1444854148350" MODIFIED="1444856917664" VSHIFT="-10"/>
<node TEXT="Alignment with the US National Information Exchange Model (NIEM) methodology will allow the development and re-use of stndardized Information Exchange Product Documentation (IEPD) resources which will support valid implementations and promote interoperability with external specifications." ID="ID_1320508699" CREATED="1444854467693" MODIFIED="1444855633989" VSHIFT="10"/>
</node>
<node TEXT="Goals" POSITION="right" ID="ID_1741486495" CREATED="1444855666639" MODIFIED="1445284465810" HGAP="50" VSHIFT="20">
<edge COLOR="#00ffff"/>
<node TEXT="This project will use the Extensible Stylesheet Language for Transformation (XSLT) to convert existing XML Schema products to Garden of Eden design pattern, and will reduce file sizes by normalizing Types, using attributes in annotation elements, and applying fixed values where appropriate to reduce ambiguity and eliminate rules which specify required content." ID="ID_274447430" CREATED="1444855680286" MODIFIED="1445284452340" VSHIFT="-20"/>
<node TEXT="The resulting XML Schema products will support all requirements for the text based slash delimited MTF format, and will avoid alteration of XML element names except where absolutely necessary for naming deconfliction of global nodes.  Except for a few cases, XML instances from the current standard will validate against the re-factored XML Schemas if common namespaces are assigned." ID="ID_64571144" CREATED="1444855955886" MODIFIED="1445284450554" HGAP="30" VSHIFT="-10"/>
<node TEXT="This project is intended to support holistic implementation of the standards in order to facilitate use in web services, allow conversion between US and NATO specification, conversion between message versions, and interoperability with other standard formats." ID="ID_589380055" CREATED="1444856263166" MODIFIED="1445284448672" VSHIFT="-10"/>
</node>
<node TEXT="Usage" POSITION="right" ID="ID_1638087420" CREATED="1444856923121" MODIFIED="1445284470353" HGAP="40" VSHIFT="30">
<edge COLOR="#ffff00"/>
<node TEXT="The process for converting from current standard formats is provided for purposes of integrity, testing and verification.  For most use cases, the generated XML Schemas can be used without repeating this conversion." ID="ID_226841617" CREATED="1444856932239" MODIFIED="1444857188442" VSHIFT="-20"/>
<node TEXT="Reference implementation products are intended for re-use and distribution in order to promote interoperability and uniformity in implementations.  These products should load the provided re-factored XML Schemas and provide intended MTF messaging functionality for every message and message component." ID="ID_1184157034" CREATED="1444857042207" MODIFIED="1444857227178"/>
</node>
<node TEXT="Caveats" POSITION="right" ID="ID_98871154" CREATED="1444857235839" MODIFIED="1445284475803" HGAP="30" VSHIFT="40">
<edge COLOR="#7c0000"/>
<node TEXT="All data resources are restricted for distribution.  This requires complete separation of presentation and data.  No implementations may retain data from the XML Schema resources in code." ID="ID_996714687" CREATED="1444857241999" MODIFIED="1445283802071" VSHIFT="20"/>
<node TEXT="Alteration or further re-factoring of the provided XML Schema must implement new namespace assignments." ID="ID_1920187984" CREATED="1444857468671" MODIFIED="1444857550443" VSHIFT="10"/>
<node TEXT="Because US and NATO specifications are closely aligned, all products are very similar and can often be re-used interchangeably.  Minor differences will occur, so For purposes of clarity and distribution they are provided separately with each standard." ID="ID_597604512" CREATED="1444857598111" MODIFIED="1445283723238" VSHIFT="-40"/>
</node>
<node TEXT="USMTF" POSITION="right" ID="ID_1967102135" CREATED="1444842276503" MODIFIED="1445375951948" VSHIFT="50">
<edge COLOR="#ff0000"/>
<node TEXT="XML Schema Design" ID="ID_810225239" CREATED="1445035293775" MODIFIED="1445370827892" VSHIFT="-160">
<node TEXT="Adjustments are made to the format of all XML Schemas in order to reduce size, and eliminate redundant or unnecessary information." ID="ID_1480971800" CREATED="1445035365647" MODIFIED="1445370511189" VSHIFT="-10"/>
<node TEXT="Annotations" ID="ID_1750708290" CREATED="1445035672879" MODIFIED="1445370827892" VSHIFT="10">
<node TEXT="Content of xsd:annotations is converted from elements to attributes in order to reduce size caused by closing tags.  Names are changed to plain language terms instead of database field names.  Elements are used for multiple items." ID="ID_1323541666" CREATED="1445035684847" MODIFIED="1445284310321" HGAP="30" VSHIFT="80"/>
<node TEXT="When xsd:documentation and asd:appinfo items are duplicative, the information is retained in the xsd:documentation node and removed from the xsd;appinfo node." ID="ID_686135295" CREATED="1445037472232" MODIFIED="1445284397448" HGAP="30" VSHIFT="30"/>
<node TEXT="The names of the items in xsd:appinfo nodes are changed as follows:" ID="ID_1166810592" CREATED="1445035779520" MODIFIED="1445284403200" HGAP="30" VSHIFT="-70">
<node TEXT="Fields" ID="ID_100473284" CREATED="1445370612088" MODIFIED="1445370688955">
<node TEXT="Baseline" ID="ID_34265425" CREATED="1445370612089" MODIFIED="1445370643587">
<node TEXT="&lt;FudName/&gt;" ID="ID_909463173" CREATED="1445370612089" MODIFIED="1445370612089"/>
<node TEXT="&lt;FudExplanation/&gt;" ID="ID_1405532511" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;FieldFormatIndexReferenceNumber/&gt;" ID="ID_1348676922" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;FudNumber/&gt;" ID="ID_1159183985" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;VersionIndicator/&gt;" ID="ID_1226458599" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;MinimumLength/&gt;" ID="ID_356371889" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;MaximumLength/&gt;" ID="ID_438776037" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;LengthLimitation/&gt;" ID="ID_920385990" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;UnitOfMeasure/&gt;" ID="ID_236333864" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;Type/&gt;" ID="ID_151867158" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;FudSponsor/&gt;" ID="ID_762539737" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;FudRelatedDocument/&gt;" ID="ID_1031334117" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;EntryType/&gt;" ID="ID_1177096757" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;DataType/&gt;" ID="ID_682534319" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;Explanation/&gt;" ID="ID_1992920320" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;MtfRegularExpression/&gt;" ID="ID_927907341" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;MinimumInclusiveValue/&gt;" ID="ID_397058136" CREATED="1445370612090" MODIFIED="1445370612090"/>
<node TEXT="&lt;MaximumInclusiveValue/&gt;" ID="ID_1217968447" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;LengthVariable/&gt;" ID="ID_1303897518" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;DataCode/&gt;" ID="ID_429643928" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;DataItem/&gt;" ID="ID_63027644" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;DataItemSequenceNumber/&gt;" ID="ID_1564552499" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;DataItemSponsor/&gt;" ID="ID_747216300" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;MinimumDecimalPlaces/&gt;" ID="ID_1181725721" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;MaximumDecimalPlaces/&gt;" ID="ID_4993624" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;ElementalFfirnFudnSequence/&gt;" ID="ID_191571258" CREATED="1445370612091" MODIFIED="1445370612091"/>
</node>
<node TEXT="Refactor" ID="ID_556967687" CREATED="1445370612091" MODIFIED="1445370649822">
<node TEXT="&lt;Field name=&quot;FudName&quot; explanation=&quot;FudExplanation or Explanation&quot; version=&quot;VersionIndicator&quot; sponsor=&quot;FudSponsor&quot;&gt;" ID="ID_360379861" CREATED="1445370612091" MODIFIED="1445370612091">
<node TEXT="&lt;Document&gt;FudRelatedDocument1&lt;/Document&gt;" ID="ID_456292364" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Document&gt;FudRelatedDocument2&lt;/Document&gt;" ID="ID_69990456" CREATED="1445370612091" MODIFIED="1445370612091"/>
</node>
<node TEXT="&lt;/Field&gt;" ID="ID_831035542" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Enum dataItem=&quot;DataItem&quot;/&gt;" ID="ID_1569228776" CREATED="1445370612091" MODIFIED="1445370612091"/>
</node>
<node TEXT="Removed" ID="ID_1864136806" CREATED="1445370612091" MODIFIED="1445370658693">
<node TEXT="&lt;FieldFormatIndexReferenceNumber/&gt;" ID="ID_1888193502" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FudNumber/&gt;" ID="ID_912654653" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;MinimumLength/&gt;" ID="ID_584313651" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;MaximumLength/&gt;" ID="ID_1031775589" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;LengthLimitation/&gt;" ID="ID_344683434" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;UnitOfMeasure/&gt;" ID="ID_1156036719" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Type/&gt;" ID="ID_768232846" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;EntryType/&gt;" ID="ID_1346890980" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;DataType/&gt;" ID="ID_354105568" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;MtfRegularExpression/&gt;" ID="ID_936130868" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;MinimumInclusiveValue/&gt;" ID="ID_1604458006" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;MaximumInclusiveValue/&gt;" ID="ID_911630308" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;LengthVariable/&gt;" ID="ID_629636488" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;DataItem/&gt;" ID="ID_415255446" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;DataItemSequenceNumber/&gt;" ID="ID_808075469" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;DataItemSponsor/&gt;" ID="ID_349324922" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;MinimumDecimalPlaces/&gt;" ID="ID_430763356" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;MaximumDecimalPlaces/&gt;" ID="ID_112052193" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;ElementalFfirnFudnSequence/&gt;" ID="ID_1566187675" CREATED="1445370612091" MODIFIED="1445370612091"/>
</node>
</node>
<node TEXT="Sets" ID="ID_1229427480" CREATED="1445370612091" MODIFIED="1445370697369">
<node TEXT="Baseline" ID="ID_1980521781" CREATED="1445370612091" MODIFIED="1445370734179">
<node TEXT="&lt;SetFormatName/&gt;" ID="ID_1584373509" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;SetFormatIdentifier/&gt;" ID="ID_1227917816" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;ColumnarIndicator/&gt;" ID="ID_412781752" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;GroupOfFieldsIndicator/&gt;" ID="ID_653259486" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;RepeatabilityForGroupOfFields/&gt;" ID="ID_572973586" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;SetFormatNote/&gt;" ID="ID_568891183" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;SetFormatExample/&gt;" ID="ID_1069482152" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;SetFormatRemark/&gt;" ID="ID_1290948" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;SetFormatSponsor/&gt;" ID="ID_889000451" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;SetFormatRelatedDocuments/&gt;" ID="ID_268356142" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;VersionIndicator/&gt;" ID="ID_225940216" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldFormatPositionName/&gt;" ID="ID_1837699254" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldFormatPositionNumber/&gt;" ID="ID_1407047314" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;OccurrenceCategory/&gt;" ID="ID_1033662588" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldFormatPositionConcept/&gt;" ID="ID_935130810" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;ColumnHeader/&gt;" ID="ID_1025563123" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;AlphabeticIdentifier/&gt;" ID="ID_1922240351" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Justification/&gt;" ID="ID_341309563" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldDescriptor/&gt;" ID="ID_300107549" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;AssignedFfirnFudUseDescription/&gt;" ID="ID_756802562" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldFormatIndexReferenceNumber/&gt;" ID="ID_759472798" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldFormatName/&gt;" ID="ID_133658205" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldFormatStructure/&gt;" ID="ID_826932045" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldFormatDefinition/&gt;" ID="ID_86018735" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldFormatRemark/&gt;" ID="ID_263786983" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldFormatRelatedDocument/&gt;" ID="ID_1211072466" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldFormatSponsor/&gt;" ID="ID_1591321152" CREATED="1445370612091" MODIFIED="1445370612091"/>
</node>
<node TEXT="ReFactor" ID="ID_1056498762" CREATED="1445370612091" MODIFIED="1445370739066">
<node TEXT="&lt;Set name=&quot;SetFormatName&quot; id=&quot;SetFormatIdentifier&quot; column=&quot;ColumnarIndicator&quot; note=&quot;SetFormatNote&quot; remark=&quot;SetFormatRemark&quot;" ID="ID_1411938039" CREATED="1445370612091" MODIFIED="1445370612091">
<node TEXT="sponsor=&quot;SetFormatSponsor&quot; version=&quot;VersionIndicator&quot;&gt;" ID="ID_1638006702" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Example&gt;SetFormatExample1&lt;/Example&gt;" ID="ID_1116997235" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Example&gt;SetFormatExample2&lt;/Example&gt;" ID="ID_1656180319" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Document&gt;SetFormatRelatedDocuments1&lt;/Document&gt;" ID="ID_119057802" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Document&gt;SetFormatRelatedDocuments2&lt;/Document&gt;" ID="ID_663118267" CREATED="1445370612091" MODIFIED="1445370612091"/>
</node>
<node TEXT="&lt;/Set&gt;" ID="ID_355512775" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Field name=&quot;FieldFormatName or FieldDescriptor&quot; positionName=&quot;FieldFormatPositionName&quot; position=&quot;FieldFormatPositionNumber&quot;" ID="ID_226458098" CREATED="1445370612091" MODIFIED="1445370612091">
<node TEXT="concept=&quot;FieldFormatPositionConcept&quot; columnHeader=&quot;ColumnHeader&quot; identifier=&quot;AlphabeticIdentifier&quot; alignment=&quot;Justification&quot;" ID="ID_613455754" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="usage=&quot;AssignedFfirnFudUseDescription&quot; remark=&quot;FieldFormatRemark&quot; sponsor=&quot;FieldFormatSponsor&quot;&gt;" ID="ID_689801351" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Example&gt;SetFormatExample1&lt;/Example&gt;" ID="ID_543344469" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Example&gt;SetFormatExample2&lt;/Example&gt;" ID="ID_1901475036" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Document&gt;FieldFormatRelatedDocument1&lt;/Document&gt;" ID="ID_952716650" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;Document&gt;FieldFormatRelatedDocument2&lt;/Document&gt;" ID="ID_1301755104" CREATED="1445370612091" MODIFIED="1445370612091"/>
</node>
<node TEXT="&lt;/Field&gt;" ID="ID_555195968" CREATED="1445370612091" MODIFIED="1445370612091"/>
</node>
<node TEXT="Removed" ID="ID_740758700" CREATED="1445370612091" MODIFIED="1445370742153">
<node TEXT="&lt;GroupOfFieldsIndicator/&gt;" ID="ID_1150967729" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;RepeatabilityForGroupOfFields/&gt;" ID="ID_1490337520" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;OccurrenceCategory/&gt;" ID="ID_1781133936" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldFormatIndexReferenceNumber/&gt;" ID="ID_1003046229" CREATED="1445370612091" MODIFIED="1445370612091"/>
<node TEXT="&lt;FieldFormatStructure/&gt;" ID="ID_321485345" CREATED="1445370612091" MODIFIED="1445370612091"/>
</node>
</node>
<node TEXT="Messages" ID="ID_924279169" CREATED="1445370612092" MODIFIED="1445370707236">
<node TEXT="Baseline" ID="ID_1059614298" CREATED="1445370612092" MODIFIED="1445370745850">
<node TEXT="&lt;MtfName/&gt;" ID="ID_134112095" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;MtfIdentifier/&gt;" ID="ID_1075711266" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;MtfIndexReferenceNumber/&gt;" ID="ID_1818646788" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;MtfSponsor/&gt;" ID="ID_1835510634" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;MtfPurpose/&gt;" ID="ID_440113662" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;MtfRelatedDocument/&gt;" ID="ID_629427204" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;MtfRemark/&gt;" ID="ID_800595375" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;MtfNote/&gt;" ID="ID_1932610136" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;MtfStructuralRelationship/&gt;" ID="ID_1178294804" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;VersionIndicator/&gt;" ID="ID_1490431402" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;AlternativeType/&gt;" ID="ID_1104580885" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;SetFormatPositionName/&gt;" ID="ID_1496618422" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;SetFormatPositionNumber/&gt;" ID="ID_786145073" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;SetFormatPositionConcept/&gt;" ID="ID_871677190" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;SetFormatPositionUseDescription/&gt;" ID="ID_850414699" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;OccurrenceCategory/&gt;" ID="ID_1492398300" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;Repeatability/&gt;" ID="ID_931269542" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;SegmentStructureName/&gt;" ID="ID_4471593" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;SegmentStructureConcept/&gt;" ID="ID_1082573961" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;SegmentStructureUseDescription/&gt;" ID="ID_1167931590" CREATED="1445370612092" MODIFIED="1445370612092"/>
</node>
<node TEXT="Refactor" ID="ID_1739811853" CREATED="1445370612092" MODIFIED="1445370749173">
<node TEXT="&lt;Msg name=&quot;MtfName&quot; identifier=&quot;MtfIdentifier&quot; sponsor=&quot;MtfSponsor&quot; purpose=&quot;MtfPurpose&quot; remark=&quot;MtfRemark&quot; note=&quot;MtfNote&quot;" ID="ID_1392072844" CREATED="1445370612092" MODIFIED="1445370612092">
<node TEXT="version=&quot;VersionIndicator&quot;&gt;" ID="ID_427210143" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;Document&gt;MtfRelatedDocument1&lt;/Document&gt;" ID="ID_1237791685" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;Document&gt;MtfRelatedDocument2&lt;/Document&gt;" ID="ID_1111594398" CREATED="1445370612092" MODIFIED="1445370612092"/>
</node>
<node TEXT="&lt;/Msg&gt;" ID="ID_1544776570" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;Segment name=&quot;SegmentStructureName&quot; concept=&quot;SegmentStructureConcept&quot; usage=&quot;SegmentStructureUseDescription&quot;/&gt;" ID="ID_1445204610" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;Set positionName=&quot;SetFormatPositionName&quot; position=&quot;SetFormatPositionNumber&quot; concept=&quot;SetFormatPositionConcept&quot;" ID="ID_315437279" CREATED="1445370612092" MODIFIED="1445370612092">
<node TEXT="usage=&quot;SetFormatPositionUseDescription&quot;/&gt;" ID="ID_225769550" CREATED="1445370612092" MODIFIED="1445370612092"/>
</node>
</node>
<node TEXT="Removed" ID="ID_90330812" CREATED="1445370612092" MODIFIED="1445370751916">
<node TEXT="&lt;MtfIndexReferenceNumber/&gt;" ID="ID_1234125811" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;MtfStructuralRelationship/&gt;" ID="ID_1102108697" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;AlternativeType/&gt;" ID="ID_727966983" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;OccurrenceCategory/&gt;" ID="ID_215549737" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;Repeatability/&gt;" ID="ID_782649451" CREATED="1445370612092" MODIFIED="1445370612092"/>
<node TEXT="&lt;InitialSetFormatPosition/&gt;" ID="ID_1429337226" CREATED="1445370612092" MODIFIED="1445370612092"/>
</node>
</node>
</node>
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
<node TEXT="Field Refactor" ID="ID_367208974" CREATED="1445375606297" MODIFIED="1445375690556">
<node TEXT="By comparing Regular Expressions the number of types extended by FieldStringBase Type was greatly reduced.  One factor was the removal of types which included length and value restrictions in the REGEX.  String types have been defined using xsd:pattern for content, and XML Schema nodes to specify lengths at the element level.  While a single iteration may seem more verbose, the AlphaNumericBlankSpecialTextType is re-used 877 times, thereby eliminating and re-using this duplicative definition." ID="ID_673543804" CREATED="1445371789869" MODIFIED="1445373473845" HGAP="30" VSHIFT="-20"/>
<node TEXT="Strings" ID="ID_588492347" CREATED="1445375806285" MODIFIED="1445375870828">
<node TEXT="Baseline String Field" ID="ID_1057235228" CREATED="1445372043183" MODIFIED="1445375851488" HGAP="50" VSHIFT="50">
<node TEXT="&lt;simpleType name=&quot;MissionNumberType&quot;&gt;&#xa;       &lt;annotation/&gt;&#xa;              &lt;restriction base=&quot;string&quot;&gt;&#xa;                      &lt;annotation/&gt;&#xa;                          &lt;minLength value=&quot;1&quot;/&gt;&#xa;                          &lt;maxLength value=&quot;8&quot;/&gt;&#xa;                          &lt;pattern value=&quot;[\-\.,\(\)\?A-Z0-9&amp;#x20;]{1,8}&quot;/&gt;&#xa;                  &lt;/restriction&gt;&#xa;&lt;/simpleType&gt;&#xa;&lt;element name=&quot;MissionNumber&quot; type=&quot;MissionNumberType&quot;/&gt;" ID="ID_554398573" CREATED="1445372934071" MODIFIED="1445372973890"/>
</node>
<node TEXT="Refactor String Field" ID="ID_1916378606" CREATED="1445372043183" MODIFIED="1445375870828" HGAP="50" VSHIFT="-50">
<node TEXT="&lt;complexType name=&quot;AlphaNumericBlankSpecialTextType&quot;&gt;&#xa;         &lt;simpleContent&gt;&#xa;                 &lt;restriction base=&quot;FieldStringBaseType&quot;&gt;&#xa;                        &lt;pattern value=&quot;[\-\.,\(\)\?A-Z0-9 ]+&quot;/&gt;&#xa;                 &lt;/restriction&gt;&#xa;         &lt;/simpleContent&gt;&#xa;&lt;/complexType&gt;&#xa;&lt;element name=&quot;MissionNumber&quot;&gt;&#xa;       &lt;annotation/&gt;&#xa;       &lt;complexType&gt;&#xa;                &lt;simpleContent&gt;&#xa;                         &lt;restriction base=&quot;AlphaNumericBlankSpecialTextType&quot;&gt;&#xa;                                &lt;minLength value=&quot;1&quot;/&gt;&#xa;                                &lt;maxLength value=&quot;8&quot;/&gt;&#xa;                        &lt;/restriction&gt;&#xa;                &lt;/simpleContent&gt;&#xa;       &lt;/complexType&gt;&#xa;&lt;/element&gt;" ID="ID_787853920" CREATED="1445372934071" MODIFIED="1445373102791"/>
</node>
</node>
<node TEXT="Enumerations" ID="ID_1437957964" CREATED="1445375811577" MODIFIED="1445375867234">
<node TEXT="Baseline Enumeration Field" ID="ID_1407073886" CREATED="1445374989529" MODIFIED="1445375867233" HGAP="40" VSHIFT="30">
<node TEXT=" &lt;simpleType name=&quot;PersistentIndicatorType&quot;&gt;&#xa;          &lt;annotation/&gt;&#xa;            &lt;restriction base=&quot;string&quot;&gt;&#xa;                    &lt;enumeration value=&quot;YES&quot;&gt;&#xa;                            &lt;annotation&gt;&#xa;                    &lt;/enumeration&gt;&#xa;                    &lt;enumeration value=&quot;NO&quot;&gt;&#xa;                            &lt;annotation/&gt;&#xa;                     &lt;/enumeration&gt;&#xa;           &lt;/restriction&gt;&#xa;&lt;/simpleType&gt; &#xa;&lt;element name=&quot;PersistentIndicator&quot; type=&quot;YesNoType&quot;/&gt;" ID="ID_173667910" CREATED="1445375113832" MODIFIED="1445375434121"/>
</node>
<node TEXT="Refactor Enumeration Field" ID="ID_791867798" CREATED="1445374999192" MODIFIED="1445375858177" HGAP="50" VSHIFT="-30">
<node TEXT=" complexType name=&quot;YesNoType&quot;&gt;&#xa;         &lt;simpleContent&gt;&#xa;                   &lt;restriction base=&quot;FieldEnumeratedBaseType&quot;&gt;&#xa;                            &lt;enumeration value=&quot;YES&quot;&gt;&#xa;                                &lt;annotation&gt;&#xa;                                    &lt;appinfo&gt;&#xa;                                        &lt;Enum dataItem=&quot;AFFIRMATIVE INDICATOR&quot;/&gt;&#xa;                                    &lt;/appinfo&gt;&#xa;                                &lt;/annotation&gt;&#xa;                            &lt;/enumeration&gt;&#xa;                            &lt;enumeration value=&quot;NO&quot;&gt;&#xa;                                &lt;annotation&gt;&#xa;                                    &lt;appinfo&gt;&#xa;                                        &lt;Enum dataItem=&quot;NEGATIVE INDICATOR&quot;/&gt;&#xa;                                    &lt;/appinfo&gt;&#xa;                                &lt;/annotation&gt;&#xa;                            &lt;/enumeration&gt;&#xa;                     &lt;/restriction&gt;&#xa;           &lt;/simpleContent&gt;&#xa;&lt;/complexType&gt;&#xa;&lt;element name=&quot;PersistentIndicator&quot; type=&quot;YesNoType&quot;&gt;&#xa;      &lt;annotation/&gt;&#xa;&lt;/element&gt;" ID="ID_19077431" CREATED="1445375019992" MODIFIED="1445375111944"/>
</node>
</node>
<node TEXT="Integers" ID="ID_380764250" CREATED="1445375815209" MODIFIED="1445375817766"/>
<node TEXT="Decimals" ID="ID_1282382012" CREATED="1445375818233" MODIFIED="1445375822025"/>
</node>
</node>
<node TEXT="XML Schema Re-Factor Process" ID="ID_393949117" CREATED="1444857194575" MODIFIED="1445375898495">
<node TEXT="This process is retained for purposes of verification, testing and maintenance.  It is not necessary for implementers to repeat this effort." ID="ID_375994573" CREATED="1445034474254" MODIFIED="1445375898492" HGAP="32" VSHIFT="-30"/>
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
<node TEXT="Testing" ID="ID_1095016314" CREATED="1444857200719" MODIFIED="1445375951947" HGAP="70" VSHIFT="-20"/>
<node TEXT="Reference Implementations" ID="ID_1169000317" CREATED="1444857207646" MODIFIED="1445375948370" HGAP="70"/>
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
