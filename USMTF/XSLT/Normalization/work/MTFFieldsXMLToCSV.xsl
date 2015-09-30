<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:mtfxml="http://usmtfxml"
	exclude-result-prefixes="xsd" xml:lang="en-US" version="2.0">
	
	<xsl:output method="text" indent="yes" encoding="iso-8859-1"/>
	
	<xsl:variable name="NEWLINE" select="'&#10;'"/>
	<xsl:variable name="BLANKSPACE" select="'&#xA;'"/>
	<xsl:variable name="QUOTE" select="'&#34;'"/>
	<xsl:variable name="COMMA" select="'&#44;'"/>
	<xsl:variable name="CSVSEPARATOR" select="'&#44;'"/>
	<xsl:variable name="MODEWRAP" select="(Mode.Wrap)"/>
	<xsl:variable name="REGEXOPENBRACKET" select="'['"/>
	<xsl:variable name="REGEXCLOSEBRACKET" select="']'"/>
	<xsl:variable name="LBRACKET" select="'{'"/>
	<xsl:variable name="RBRACKET" select="'}'"/>
	
	<xsl:variable name="source" select="document('../RegEx/FindRegExFieldsAndProposeNewNamesOut.xml')"/>
	<xsl:variable name="output" select="'USMC_Proposed_Field_Name_Changes.csv'"/>
	
	<xsl:variable name="ColNames">
		<xsl:value-of select="concat('TypeName',$CSVSEPARATOR,'RegEx',$MODEWRAP,$CSVSEPARATOR,'Proposed Type Name',$CSVSEPARATOR,'Proposed Type Extension',$CSVSEPARATOR,'Suggested RegEx')"/>
		<xsl:text>&#13;</xsl:text>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:result-document href="{$output}">
			<xsl:value-of select="$ColNames"/>
			<xsl:apply-templates select="$source/*"/>
		</xsl:result-document>
	</xsl:template>
		
	<xsl:template match="TYPES/Regex">
		<xsl:apply-templates select="RegexType/SType"/>
	</xsl:template>
	
	<xsl:template match="RegexType/SType">
		<xsl:variable name="regexField" select="../ancestor-or-self::RegexType/@regex"/>
		<xsl:variable name="occurrence" select="../ancestor-or-self::RegexType/@occurrence"/>
		<xsl:variable name="fieldName" select="@name"/>
		<xsl:variable name="proposedExtensionType" select="@ProposedExtensionType"/>
		<xsl:variable name="proposedTypeName" select="@ProposedTypeName"/>
		<xsl:variable name="escapedRegEx">
			<xsl:choose>
				<xsl:when test="(compare($fieldName,'FreeTextBaseType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'FreeTextFieldType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'MessageSerialNumberType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'CommentsType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
					<!--<xsl:apply-templates select="escapeQuotes"/>-->
				</xsl:when>
				<xsl:when test="(compare($fieldName,'MissionDesignatorCommentsType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'ContactInstructionsType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'MissionLocationCommentType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'RouteCommentType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'RemarksType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'OtherSarUnitCommentsType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'WeatherCommentsType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'TimeAmplificationCommentType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'SarMissionReportCommentType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'GroundTargetCommentsType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'SpecialTrackNumberDescriptionType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'MissionObjectiveType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'InstructionsForAcknowledgingType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'AircraftLimitationsType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'TypeOfResponseOrReactionType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'IdentifyingInformationType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'HeadingInformationType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'FilingNumberType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'ReferenceSerialNumberType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'ReferenceSerialNumberType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'DescriptionType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'ControlPointDescriptionType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'MarkerDescriptionType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'TargetDescriptionType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'TargetElementDescriptionType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'TrpDescriptionType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'NavigationAidDescriptionType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'InitialPointDescriptionType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'DesiredMeanPointOfImpactDescriptionType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'EventDescriptionType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'MajorEquipmentTypeCodeType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'ElectronicDataType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'TrademarkType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'ElectronicMailAddressType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'SecureElectronicMailAddressType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'WeaponControlAncillaryInformationType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'RoeConstraintsType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'WebsiteAddressType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:when test="(compare($fieldName,'WebsiteNameOrTitleType')=0)">
					<xsl:value-of select="'FIX REGEX OUTPUT'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(contains($regexField,$QUOTE))">
						<xsl:text>&quot;</xsl:text>
						<xsl:value-of select="$regexField"/>
						<xsl:text>&quot;</xsl:text>
					</xsl:if>
					
					<xsl:if test="contains($regexField,$QUOTE)">
						<xsl:variable name="escapedResult">
							<xsl:call-template name="escapeQuotes">
								<xsl:with-param name="string" select="$regexField"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:value-of select="$escapedResult"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
			<!-- Output the Field Name -->
			<xsl:value-of select="$fieldName"/>
			
			<xsl:value-of select="$CSVSEPARATOR"/>
			
			<!-- Output the Associated RegEx -->
			<xsl:value-of select="$escapedRegEx"/>
			
			<xsl:value-of select="$CSVSEPARATOR"/>
			
			<!-- Output any Proposed Type Name -->
			<xsl:if test="(string-length(string($proposedTypeName))>0)">
				<xsl:value-of select="$proposedTypeName"/>
			</xsl:if>
			
			<xsl:value-of select="$CSVSEPARATOR"/>
			
			<!-- Output any Proposed Extension Type  -->
			<xsl:if test="(string-length(string($proposedExtensionType))>0)">
				<xsl:value-of select="$proposedExtensionType"/>
			</xsl:if>
			
			<xsl:value-of select="$CSVSEPARATOR"/>
			<xsl:value-of select="$CSVSEPARATOR"/>
			<xsl:value-of select="$NEWLINE"/>
	</xsl:template>
	
	
	<xsl:template name="escapeQuotes">
		<xsl:param name="string" select="@value"/>
		<xsl:variable name="escapedQuotesString">
			<xsl:choose>
				<xsl:when test='contains($string,$QUOTE)'>
					<xsl:variable name="quoteString">
						<xsl:value-of select="substring-before($string,$QUOTE)"></xsl:value-of>
						<xsl:text>'123'</xsl:text>
						<xsl:call-template name="escapeQuotes">
							<xsl:with-param name="string" select="substring-after($string,$QUOTE)"/>
						</xsl:call-template>
					</xsl:variable>
					<!--<xsl:text>&quot;</xsl:text>-->
					<xsl:value-of select="$quoteString"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$string" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$escapedQuotesString"/>
	</xsl:template>
	
	<xsl:template match="xsd:import"/>
</xsl:stylesheet>