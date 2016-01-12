% MTF XML REFACTOR PROCESS


# 1. Overview

This process is retained for purposes of verification, testing and maintenance.  It is not necessary for implementers to repeat the effort.

## a. The NormalizedSimpleTypes.xsd file was created using a variety of methods which analyze and compare Regular Expressions. This required subjective decisions which may be adjusted. The XSLT scripts to accomplish this are in the USMTF/XSLT/Normalization/work directory.

## b The XSLT scripts to generate the normalized simpleTypes are located in the USMTF/XSLT/Normalization directory. Data products are located in the USMTF/XSD/Normalized/work directory.

## c The Strings.xsl, Numerics.xsl, and Enumerations.xsl scripts can be executed in any order. Results are written to the USMTF/XSD/Normalized directory.

## d. The GoE_Fields.xsl script consolidates the Strings.xsd, Integers.xsd, Decimals.xsd and Enumerations.xsd files into the GoE_field.xsd document which is stored in the USMTF/XSD/GoE_Schema directory.

## e. Sets Re-factor. Sets extend the BaseSetType in order to add the security attribute group at the set level. Because fields types are now also extended, they do not need to be extended in the Sets Schema, but can be directly referenced or typed. Because nillable elements cannot be referenced, they are extended.

## f. Segments Re-factor. Segments are extracted from messages to provide the opportunity for re-use. A new Complex Type, SegmentBaseType, is included to insert ICM security attribute group and for further Segment level extension.

## g Messages Re-factor

### 1. Element Name Changes. One of the goals for the re-factor was to minimize impact on current XML Instance documents. In the case of General Text and Heading Information fields the proposed change adds field names which are specific to the required content and eliminate the need to distinguish XML nodes by appending numbers.

### 2. General Text Re-factor

This only applies to USMTF.  It was implemented in order to include fixed required values in the TextIdentification field using XML extension.  This eliminates all rules specifying these values since they are verified by XML validation.  This reduces the size of the XML Schema and reduces the additional rules implementation requirement.

### 3. Heading Information Re-factor

### 4. Message Identification

This proposed change adds fixed values to the Message XML Schema in order to

allow validation of Standard, MessageTextFormatIdentifier, and VersionOfMessageFormat using XML validation instead of

requiring rules.

# 2. Resources

## a. Details

### 1. These are documents created by human analysis of database and XML Schema nodes in order to eliminate duplication at the global levels of XML Schema, normalize XML Schema types, and make other changes to annotations and naming.

### 2. Original products have been created as spreadsheets. XSLT is used to convert XML versions of these spreadsheets to XML for further XSLT processing as part of the re-factor. The conversion XSLT are dependent on Microsoft XML export from Excel but can be adjusted to accomodate any XML format for spreadsheets. Conversion of Spreadsheets to XML is not included in this process.

### 3. All analysis and proposed changes has been conducted using USMTF. No process has been conducted for NATO MTF. USMTF changes are applied to NATO MTF where matches occur. USMTF required changes are due to naming conflicts at the global level. Normalization changes are design recommendations which pertain to re-use of fields. Of note, NATO MTF does not require naming de-confliction changes.

### 3. These changes are subjective and subject to approval by standards bodies. Adjustments to these files will propagate into the final refactored XML Schema.

### 4. Because these documents are derived from restricted data sources they cannot be made publicly available.

## b. File Organization

### (1) The public file structure can be downloaded from https://github.com/mil-oss/MTFXML as a .zip file and extracted. Symbolic links must be added as indicated. Only required directories are included. Generated files are in bold face.

### (2) Public File Orgnanization

#### MTFXML

##### USMTF

###### XSD

####### Baseline_Schema

######## composites.xsd

######## fields.xsd

######## messages.xsd

######## sets.xsd

######## IC-ISM-v2.xsd

####### Deconflicted

######## M2014-10-C0-F Segment Deconfliction.xlsx

######## M201503C0VF-Set Deconfliction.xlsx

######## Segment_DeconflictionEXCEL.xml

######## Segment_Name_Changes.xml

######## Set_DeconflictionEXCEL.xml

######## Set_Name_Changes.xml

####### GoE_Schema

######## SeparateMessages

This directory is the target for directories for each message with separate XML Schema

######## SeparateMessagesUnified

This directory This directory is the target for unified XML Schema for each message

######## GoE_fields.xsd

######## GoE_messages.xsd

######## GoE_segments.xsd

######## GoE_sets.xsd

######## IC-ISM-v2.xsd

####### Normalized

######## Decimals.xsd

######## Enumerations.xsd

######## IC-ISM-v2.xsd

######## Integers.xsd

######## NormalizedSimpleTypes.xsd

######## Strings.xsd

###### XSLT

####### Deconfliction

######## SegmentsSpreadsheetToXML.xsl

######## SetsSpreadsheetToXML.xsl

####### Normalization

######## Enumerations.xsl

######## Numerics.xsl

######## Strings.xsl

####### Fields

####### Messages

####### Segments

####### Sets

####### USMTF_GoE

##### NATO_MTF

###### XSD

####### APP-11C-ch1 (Symbolic Link)

This directory contains source XML Schema

######## Consolidated

######### composites.xsd

######### fields.xsd

######### messages.xsd

######### sets.xsd

######## Messages

This directory contains directories with separate XML Schema files for every NATO MTF Message.

####### APP-11C-GoE (Symbolic Link)

This directory contains re-factored XML Schema

######## SeparateMessages

This directory is the target for directories for each message with separate XML Schema

######## SeparateMessagesUnified

This directory This directory is the target for unified XML Schema for each message

######## natomtf_goe_fields.xsd

######## natomtf_goe_messages.xsd

######## natomtf_goe_segments.xsd

######## natomtf_goe_sets.xsd

####### Normalized (Symbolic Link)

######## Decimals.xsd

######## Enumerations.xsd

######## Integers.xsd

######## NormalizedSimpleTypes.xsd

######## Strings.xsd

###### XSLT

####### APP-11C-ch1

######## ConsolidateComposites.xsl

######## ConsolidateFields.xsl

######## ConsolidateMessages.xsl

######## ConsolidateSets.xsl

######## MessageList.xsl

####### APP-11C-GoE

######## NATO_GoE_Fields.xsl

######## NATO_GoE_Messages.xsl

######## NATO_GoE_Segments.xsl

######## NATO_GoE_Sets.xsl

####### Normalization

######## Enumerations.xsl

######## Numerics.xsl

######## Strings.xsl

## c. Proposed Changes

### 1. Deconfliction

#### (a) Set Name De-confliction

##### (1) Spreadsheet

MTFXML/USMTF/XSD/Deconflicted/M201503C0VF-Set Deconfliction.xlsx

##### (2) XML Export

MTFXML/USMTF/XSD/Deconflicted/Set_DeconflictionEXCEL.xml

##### (2) Conversion XSLT

MTFXML/USMTF/XSLT/Deconfliction/SetsSpreadsheetToXML.xsl

##### (3) XML Resource

MTFXML/USMTF/XSD/Deconfliction/Set_Name_Changes.xml

MTFXML/NATO_MTF/XSD/Deconfliction/Set_Name_Changes.xml

#### (b) Segment Name De-confliction

##### (1) Spreadsheet

MTFXML/USMTF/XSD/Deconflicted/M2014-10-C0-F Segment Deconfliction.xlsx

##### (2) Conversion XSLT

MTFXML/USMTF/XSLT/Deconfliction/SegmentsSpreadsheetToXML.xsl

##### (3) XML Resource

MTFXML/USMTF/XSLT/Deconfliction/Segment_Name_Changes.xml

MTFXML/NATO_MTF/XSD/Deconflicted/Set_Name_Changes.xml

### 2. Normalization

#### (a) Field Normalization proposal is a result of detailed analysis which was not automated. This process is not covered in this guidance. The source proposal and results are provided in spreadsheet and XML Schema form. The NormalizedSimpleTypes.xsd XML Schema is used to generate separate files for XSD SimpleTypes which are then used to generate the fields.xsd XML Schema. US and NATO normalizations are largely aligned but there are differences based on content.

#### (b) Proposed Field Name Changes Spreadsheet

MTFXML/USMTF/XSD/Normalized/USMC_Proposed_Field_Name_Changes.csv

#### (c) Proposed SimpleType Normalizations

##### USMTF

###### MTFXML/USMTF/XSD/Normalized/NormalizedSimpleTypes.xsd

##### NATO MTF

###### MTFXML/NATO_MTF/XSD/Normalized/NormalizedSimpleTypes.xsd

# 3. XSLT Processing

## (a) All XSLT files use XSLT 2.0 xsl:document and xsl:result-document elements to specify inputs and outputs instead of requiring that these links be specified at processing time.

## (b) To process XSLT using and IDE or command line it is necessary to designate the main named template. This is uniformly named "main" in every XSLT.

## (c) XML Schema, XML resources, and results are all programmed to remain in directories which are defined as symbolic links in order to ensure that restricted information is not included in the project. It is important to retain this design.

## (d) All processes need to be executed in the specified order because each XSLT is designed to consume results of prior XSLT.

# 3. Refactored USMTF XML Schema Generation

## a. Generate Changes XML

### (1) Run XSLT: MTFXML/USMTF/XSLT/Deconfliction/SegmentsSpreadsheetToXML.xsl

### (2) Run XSLT: MTFXML/USMTF/XSLT/Deconfliction/SetsSpreadsheetToXML.xsl

## b.

### (1) Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/NATO_GoE_fields.xsl

### (2) Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/NATO_GoE_sets.xsl

### (3) Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/NATO_GoE_segments.xsl

### (4) Run XSLT: MTFXML/NATO_MTF/XSLT/APP-11C-GoE/NATO_GoE_messages.xsl

# 4. Refactored NATO XML Schema Generation

## (1) Run XSLT: MTFXML/USMTF/XSLT/USMTF_GoE/GoE_Fields.xsl

## (2) Run XSLT: MTFXML/USMTF/XSLT/USMTF_GoE/GoE_Fields.xsl

## (3) Run XSLT: MTFXML/USMTF/XSLT/USMTF_GoE/GoE_Fields.xsl

## (4) Run XSLT: MTFXML/USMTF/XSLT/USMTF_GoE/GoE_Fields.xsl
