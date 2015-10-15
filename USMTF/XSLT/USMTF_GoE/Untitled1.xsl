<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <xsd:complexType name="MessageIdentifierType">
        <xsd:annotation>
            <xsd:appinfo>
                <SetFormatName>MESSAGE IDENTIFIER</SetFormatName>
                <SetFormatIdentifier>MSGID</SetFormatIdentifier>
                <ColumnarIndicator>N</ColumnarIndicator>
                <GroupOfFieldsIndicator>1</GroupOfFieldsIndicator>
                <RepeatabilityForGroupOfFields>1</RepeatabilityForGroupOfFields>
                <SetFormatNote/>
                <SetFormatExample>MSGID/ABSTAT/MIL-STD-6040(SERIES)/B.0.01.00/1ST FW-DO/1201003
                    /20090214T132530Z/DEV/2/USA/UNCLASSIFED//</SetFormatExample>
                <SetFormatExample> MSGID/ABSTAT/MIL-STD-6040(SERIES)/B.0.01.01/1ST FW-DO/1201003 /20090714T182530Z/-/-/USA/CONFIDENTIAL/USA CAN
                    GBR//</SetFormatExample>
                <SetFormatExample> MSGID/ABSTAT/MIL-STD-6040(SERIES)/B.1.01.02/1ST FW-DO/1201003/FEB/DEV /2/USA/OTHER:DOS UNCLASSIFED FOR
                    INTERNET//</SetFormatExample>
                <SetFormatRemark/>
                <SetFormatSponsor>DISA</SetFormatSponsor>
                <SetFormatRelatedDocuments>NONE</SetFormatRelatedDocuments>
                <VersionIndicator>B.1.01.06</VersionIndicator>
            </xsd:appinfo>
        </xsd:annotation>
        <xsd:complexContent>
            <xsd:extension base="SetBaseType">
                <xsd:sequence>
                    <xsd:element name="StandardOfMessageTextFormat" minOccurs="1" maxOccurs="1" nillable="true">
                        <xsd:annotation>
                            <xsd:documentation>The military standard that contains the message format rules.</xsd:documentation>
                            <xsd:appinfo>
                                <FieldFormatPositionName>STANDARD OF MESSAGE TEXT FORMAT</FieldFormatPositionName>
                                <FieldFormatPositionNumber>1</FieldFormatPositionNumber>
                                <OccurrenceCategory>Mandatory</OccurrenceCategory>
                                <FieldFormatPositionConcept>The military standard that contains the message format rules.</FieldFormatPositionConcept>
                                <ColumnHeader/>
                                <AlphabeticIdentifier>A</AlphabeticIdentifier>
                                <Justification/>
                                <FieldDescriptor/>
                                <AssignedFfirnFudUseDescription>The military standard that contains the message format
                                    rules.</AssignedFfirnFudUseDescription>
                            </xsd:appinfo>
                        </xsd:annotation>
                        <xsd:complexType>
                            <xsd:simpleContent>
                                <xsd:extension base="f:StandardOfMessageTextFormatType">
                                    <xsd:annotation>
                                        <xsd:documentation>The standard from which the message is derived.</xsd:documentation>
                                        <xsd:appinfo>
                                            <FieldFormatIndexReferenceNumber>180</FieldFormatIndexReferenceNumber>
                                            <FieldFormatName>Standard</FieldFormatName>
                                            <FieldFormatStructure/>
                                            <FieldFormatDefinition>The standard from which the message is derived.</FieldFormatDefinition>
                                            <FieldFormatRemark/>
                                            <FieldFormatRelatedDocument>NONE</FieldFormatRelatedDocument>
                                            <FieldFormatSponsor/>
                                            <VersionIndicator>B.1.01.00</VersionIndicator>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                    <xsd:attribute name="ffSeq" type="xsd:unsignedShort" fixed="1"/>
                                    <xsd:attribute name="ffirnFudn" type="xsd:string" fixed="FF180-2"/>
                                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                </xsd:extension>
                            </xsd:simpleContent>
                        </xsd:complexType>
                    </xsd:element>
                    <xsd:element name="VersionOfMessageTextFormat" minOccurs="1" maxOccurs="1" nillable="true">
                        <xsd:annotation>
                            <xsd:documentation>The version of the message text format. The message version consists of four parts: Part 1 is the
                                edition letter of MIL-STD-6040(SERIES), e.g., A, B, C through Z, Part 2 is the change number of the edition (0-5),
                                Part 3 is the major change for the message, e.g., 01-99, and Part 4 is the minor change for the message, e.g.,
                                00-99.</xsd:documentation>
                            <xsd:appinfo>
                                <FieldFormatPositionName>VERSION OF MESSAGE TEXT FORMAT</FieldFormatPositionName>
                                <FieldFormatPositionNumber>2</FieldFormatPositionNumber>
                                <OccurrenceCategory>Mandatory</OccurrenceCategory>
                                <FieldFormatPositionConcept>The version of the message text format. The message version consists of four parts: Part 1
                                    is the edition letter of MIL-STD-6040(SERIES), e.g., A, B, C through Z, Part 2 is the change number of the edition
                                    (0-5), Part 3 is the major change for the message, e.g., 01-99, and Part 4 is the minor change for the message,
                                    e.g., 00-99.</FieldFormatPositionConcept>
                                <ColumnHeader/>
                                <AlphabeticIdentifier>A</AlphabeticIdentifier>
                                <Justification/>
                                <FieldDescriptor/>
                                <AssignedFfirnFudUseDescription>The version of the message text format. The message version consists of four parts:
                                    Part 1 is the edition letter of MIL-STD-6040(SERIES), e.g., A, B, C through Z, Part 2 is the change number of the
                                    edition (0-5), Part 3 is the major change for the message, e.g., 01-99, and Part 4 is the minor change for the
                                    message, e.g., 00-99.</AssignedFfirnFudUseDescription>
                            </xsd:appinfo>
                        </xsd:annotation>
                        <xsd:complexType>
                            <xsd:simpleContent>
                                <xsd:extension base="f:VersionOfMessageTextFormatType">
                                    <xsd:annotation>
                                        <xsd:documentation>The standard from which the message is derived.</xsd:documentation>
                                        <xsd:appinfo>
                                            <FieldFormatIndexReferenceNumber>180</FieldFormatIndexReferenceNumber>
                                            <FieldFormatName>Standard</FieldFormatName>
                                            <FieldFormatStructure/>
                                            <FieldFormatDefinition>The standard from which the message is derived.</FieldFormatDefinition>
                                            <FieldFormatRemark/>
                                            <FieldFormatRelatedDocument>NONE</FieldFormatRelatedDocument>
                                            <FieldFormatSponsor/>
                                            <VersionIndicator>B.1.01.00</VersionIndicator>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                    <xsd:attribute name="ffSeq" type="xsd:unsignedShort" fixed="2"/>
                                    <xsd:attribute name="ffirnFudn" type="xsd:string" fixed="FF180-3"/>
                                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                </xsd:extension>
                            </xsd:simpleContent>
                        </xsd:complexType>
                    </xsd:element>
                    <xsd:element name="Originator" minOccurs="1" maxOccurs="1" nillable="true">
                        <xsd:annotation>
                            <xsd:documentation>The identifier of the originator of the message.</xsd:documentation>
                            <xsd:appinfo>
                                <FieldFormatPositionName>ORIGINATOR</FieldFormatPositionName>
                                <FieldFormatPositionNumber>3</FieldFormatPositionNumber>
                                <OccurrenceCategory>Mandatory</OccurrenceCategory>
                                <FieldFormatPositionConcept>The identifier of the originator of the message.</FieldFormatPositionConcept>
                                <ColumnHeader/>
                                <AlphabeticIdentifier>A</AlphabeticIdentifier>
                                <Justification/>
                                <FieldDescriptor/>
                                <AssignedFfirnFudUseDescription>The identifier of the originator of the message.</AssignedFfirnFudUseDescription>
                            </xsd:appinfo>
                        </xsd:annotation>
                        <xsd:complexType>
                            <xsd:simpleContent>
                                <xsd:extension base="f:OriginatorType">
                                    <xsd:annotation>
                                        <xsd:documentation>ANY COMBINATION OF CHARACTERS WHICH UNIQUELY IDENTIFY THE ORIGINATOR OF A
                                            MESSAGE.</xsd:documentation>
                                        <xsd:appinfo>
                                            <FieldFormatIndexReferenceNumber>146</FieldFormatIndexReferenceNumber>
                                            <FieldFormatName>Originator</FieldFormatName>
                                            <FieldFormatStructure/>
                                            <FieldFormatDefinition>ANY COMBINATION OF CHARACTERS WHICH UNIQUELY IDENTIFY THE ORIGINATOR OF A
                                                MESSAGE.</FieldFormatDefinition>
                                            <FieldFormatRemark/>
                                            <FieldFormatRelatedDocument>NONE</FieldFormatRelatedDocument>
                                            <FieldFormatSponsor/>
                                            <VersionIndicator>B.1.01.00</VersionIndicator>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                    <xsd:attribute name="ffSeq" type="xsd:unsignedShort" fixed="3"/>
                                    <xsd:attribute name="ffirnFudn" type="xsd:string" fixed="FF146-1"/>
                                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                </xsd:extension>
                            </xsd:simpleContent>
                        </xsd:complexType>
                    </xsd:element>
                    <xsd:element name="MessageSerialNumber" minOccurs="0" maxOccurs="1">
                        <xsd:annotation>
                            <xsd:documentation>The serial number assigned to a specific message. The originating command may develop the message
                                serial number by any method.</xsd:documentation>
                            <xsd:appinfo>
                                <FieldFormatPositionName>MESSAGE SERIAL NUMBER</FieldFormatPositionName>
                                <FieldFormatPositionNumber>4</FieldFormatPositionNumber>
                                <OccurrenceCategory>Operationally Determined</OccurrenceCategory>
                                <FieldFormatPositionConcept>The serial number assigned to a specific message. The originating command may develop the
                                    message serial number by any method.</FieldFormatPositionConcept>
                                <ColumnHeader/>
                                <AlphabeticIdentifier>A</AlphabeticIdentifier>
                                <Justification/>
                                <FieldDescriptor/>
                                <AssignedFfirnFudUseDescription>The serial number assigned to a specific message. The originating command may develop
                                    the message serial number by any method.</AssignedFfirnFudUseDescription>
                            </xsd:appinfo>
                        </xsd:annotation>
                        <xsd:complexType>
                            <xsd:simpleContent>
                                <xsd:extension base="f:MessageSerialNumberType">
                                    <xsd:annotation>
                                        <xsd:documentation>A UNIQUE IDENTIFIER SEQUENTIALLY ASSIGNED BY AN ORIGINATOR.</xsd:documentation>
                                        <xsd:appinfo>
                                            <FieldFormatIndexReferenceNumber>147</FieldFormatIndexReferenceNumber>
                                            <FieldFormatName>SerialNumber</FieldFormatName>
                                            <FieldFormatStructure/>
                                            <FieldFormatDefinition>A UNIQUE IDENTIFIER SEQUENTIALLY ASSIGNED BY AN ORIGINATOR.</FieldFormatDefinition>
                                            <FieldFormatRemark/>
                                            <FieldFormatRelatedDocument>NONE</FieldFormatRelatedDocument>
                                            <FieldFormatSponsor/>
                                            <VersionIndicator>B.1.01.00</VersionIndicator>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                    <xsd:attribute name="ffSeq" type="xsd:unsignedShort" fixed="4"/>
                                    <xsd:attribute name="ffirnFudn" type="xsd:string" fixed="FF147-5"/>
                                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                </xsd:extension>
                            </xsd:simpleContent>
                        </xsd:complexType>
                    </xsd:element>
                    <xsd:element name="ReferenceTimeOfPublication" minOccurs="1" maxOccurs="1" nillable="true">
                        <xsd:annotation>
                            <xsd:documentation>The reference time of publication using either the ISO 8601 standardized date-time or the abbreviated
                                month name.</xsd:documentation>
                            <xsd:appinfo>
                                <FieldFormatPositionName>REFERENCE TIME OF PUBLICATION</FieldFormatPositionName>
                                <FieldFormatPositionNumber>5</FieldFormatPositionNumber>
                                <OccurrenceCategory>Mandatory</OccurrenceCategory>
                                <FieldFormatPositionConcept>The reference time of publication using either the ISO 8601 standardized date-time or the
                                    abbreviated month name.</FieldFormatPositionConcept>
                                <ColumnHeader/>
                            </xsd:appinfo>
                        </xsd:annotation>
                        <xsd:complexType>
                            <xsd:choice>
                                <xsd:element name="DateTimeIso">
                                    <xsd:annotation>
                                        <xsd:documentation>The reference time of publication using either the ISO 8601 standardized date-time or the
                                            abbreviated month name.</xsd:documentation>
                                        <xsd:appinfo>
                                            <AlphabeticIdentifier>A</AlphabeticIdentifier>
                                            <Justification/>
                                            <FieldDescriptor/>
                                            <AssignedFfirnFudUseDescription>The reference time of publication using either the ISO 8601 standardized
                                                date-time or the abbreviated month name.</AssignedFfirnFudUseDescription>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                    <xsd:complexType>
                                        <xsd:simpleContent>
                                            <xsd:extension base="f:DateTimeIsoType">
                                                <xsd:annotation>
                                                    <xsd:documentation>A designation of a specified chronological point measured using Coordinated
                                                        Universal Time (UTC) ISO 8601 as a standard of reference; example: 20090214T132530Z. This is
                                                        expressed using a compacted ISO notation YYYYMMDDTHHMMSSZ where YYYY represents a year, MM
                                                        represents a month in values from 01 to 12, DD represents a day in values from 01 to 31,
                                                        character T is the time delimiter, HH represents an hour from 00 to 23, MM represents a minute
                                                        from 00 to 59, SS represents the seconds from 00 to 59, and Z represents the time
                                                        zone.</xsd:documentation>
                                                    <xsd:appinfo>
                                                        <FieldFormatIndexReferenceNumber>721</FieldFormatIndexReferenceNumber>
                                                        <FieldFormatName>InternationalStandardDateAndTime</FieldFormatName>
                                                        <FieldFormatStructure/>
                                                        <FieldFormatDefinition>A designation of a specified chronological point measured using
                                                            Coordinated Universal Time (UTC) ISO 8601 as a standard of reference; example:
                                                            20090214T132530Z. This is expressed using a compacted ISO notation YYYYMMDDTHHMMSSZ where
                                                            YYYY represents a year, MM represents a month in values from 01 to 12, DD represents a day
                                                            in values from 01 to 31, character T is the time delimiter, HH represents an hour from 00
                                                            to 23, MM represents a minute from 00 to 59, SS represents the seconds from 00 to 59, and
                                                            Z represents the time zone.</FieldFormatDefinition>
                                                        <FieldFormatRemark>ALLOWED ENTRIES: (0000 to 9999); (01 to 12); (01 to 31); T; (00 to 23); (00
                                                            to 59); (00 to 59); Z.</FieldFormatRemark>
                                                        <FieldFormatRelatedDocument>NONE</FieldFormatRelatedDocument>
                                                        <FieldFormatSponsor/>
                                                        <VersionIndicator>B.1.02.00</VersionIndicator>
                                                    </xsd:appinfo>
                                                </xsd:annotation>
                                                <xsd:attribute name="ffirnFudn" type="xsd:string" fixed="FF721-1"/>
                                                <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                            </xsd:extension>
                                        </xsd:simpleContent>
                                    </xsd:complexType>
                                </xsd:element>
                                <xsd:element name="MonthName">
                                    <xsd:annotation>
                                        <xsd:documentation>The reference time of publication using either the ISO 8601 standardized date-time or the
                                            abbreviated month name.</xsd:documentation>
                                        <xsd:appinfo>
                                            <AlphabeticIdentifier>B</AlphabeticIdentifier>
                                            <Justification/>
                                            <FieldDescriptor/>
                                            <AssignedFfirnFudUseDescription>The reference time of publication using either the ISO 8601 standardized
                                                date-time or the abbreviated month name.</AssignedFfirnFudUseDescription>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                    <xsd:complexType>
                                        <xsd:simpleContent>
                                            <xsd:extension base="f:MonthNameType">
                                                <xsd:annotation>
                                                    <xsd:documentation>THE NAME OF A SPECIFIC MONTH WHICH IS ONE OF THE TWELVE PARTS INTO WHICH A YEAR
                                                        IS DIVIDED AS DEFINED BY THE GREGORIAN CALENDAR.</xsd:documentation>
                                                    <xsd:appinfo>
                                                        <FieldFormatIndexReferenceNumber>580</FieldFormatIndexReferenceNumber>
                                                        <FieldFormatName>MonthName</FieldFormatName>
                                                        <FieldFormatStructure/>
                                                        <FieldFormatDefinition>THE NAME OF A SPECIFIC MONTH WHICH IS ONE OF THE TWELVE PARTS INTO
                                                            WHICH A YEAR IS DIVIDED AS DEFINED BY THE GREGORIAN CALENDAR.</FieldFormatDefinition>
                                                        <FieldFormatRemark/>
                                                        <FieldFormatRelatedDocument>For further U.S. implementation guidance, see Repository of USMTF
                                                            Program Items Document, item 255.</FieldFormatRelatedDocument>
                                                        <FieldFormatSponsor/>
                                                        <VersionIndicator>B.1.01.00</VersionIndicator>
                                                    </xsd:appinfo>
                                                </xsd:annotation>
                                                <xsd:attribute name="ffirnFudn" type="xsd:string" fixed="FF580-1"/>
                                                <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                            </xsd:extension>
                                        </xsd:simpleContent>
                                    </xsd:complexType>
                                </xsd:element>
                            </xsd:choice>
                            <xsd:attribute name="ffSeq" type="xsd:unsignedShort" fixed="5"/>
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        </xsd:complexType>
                    </xsd:element>
                    <xsd:element name="Qualifier" minOccurs="0" maxOccurs="1">
                        <xsd:annotation>
                            <xsd:documentation>A qualifier which caveats a message status.</xsd:documentation>
                            <xsd:appinfo>
                                <FieldFormatPositionName>QUALIFIER</FieldFormatPositionName>
                                <FieldFormatPositionNumber>6</FieldFormatPositionNumber>
                                <OccurrenceCategory>Operationally Determined</OccurrenceCategory>
                                <FieldFormatPositionConcept>A qualifier which caveats a message status.</FieldFormatPositionConcept>
                                <ColumnHeader/>
                                <AlphabeticIdentifier>A</AlphabeticIdentifier>
                                <Justification/>
                                <FieldDescriptor/>
                                <AssignedFfirnFudUseDescription>A qualifier which caveats a message status.</AssignedFfirnFudUseDescription>
                            </xsd:appinfo>
                        </xsd:annotation>
                        <xsd:complexType>
                            <xsd:simpleContent>
                                <xsd:extension base="f:QualifierType">
                                    <xsd:annotation>
                                        <xsd:documentation>A QUALIFIER WHICH CAVEATS A MESSAGE STATUS.</xsd:documentation>
                                        <xsd:appinfo>
                                            <FieldFormatIndexReferenceNumber>568</FieldFormatIndexReferenceNumber>
                                            <FieldFormatName>Qualifier</FieldFormatName>
                                            <FieldFormatStructure/>
                                            <FieldFormatDefinition>A QUALIFIER WHICH CAVEATS A MESSAGE STATUS.</FieldFormatDefinition>
                                            <FieldFormatRemark/>
                                            <FieldFormatRelatedDocument>NONE</FieldFormatRelatedDocument>
                                            <FieldFormatSponsor/>
                                            <VersionIndicator>B.1.01.00</VersionIndicator>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                    <xsd:attribute name="ffSeq" type="xsd:unsignedShort" fixed="6"/>
                                    <xsd:attribute name="ffirnFudn" type="xsd:string" fixed="FF568-1"/>
                                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                </xsd:extension>
                            </xsd:simpleContent>
                        </xsd:complexType>
                    </xsd:element>
                    <xsd:element name="SerialNumberOfQualifier" minOccurs="0" maxOccurs="1">
                        <xsd:annotation>
                            <xsd:documentation>A number assigned serially to identify the sequential version of a message qualifier for a basic
                                message.</xsd:documentation>
                            <xsd:appinfo>
                                <FieldFormatPositionName>SERIAL NUMBER OF QUALIFIER</FieldFormatPositionName>
                                <FieldFormatPositionNumber>7</FieldFormatPositionNumber>
                                <OccurrenceCategory>Operationally Determined</OccurrenceCategory>
                                <FieldFormatPositionConcept>A number assigned serially to identify the sequential version of a message qualifier for a
                                    basic message.</FieldFormatPositionConcept>
                                <ColumnHeader/>
                                <AlphabeticIdentifier>A</AlphabeticIdentifier>
                                <Justification/>
                                <FieldDescriptor/>
                                <AssignedFfirnFudUseDescription>A number assigned serially to identify the sequential version of a message qualifier
                                    for a basic message.</AssignedFfirnFudUseDescription>
                            </xsd:appinfo>
                        </xsd:annotation>
                        <xsd:complexType>
                            <xsd:simpleContent>
                                <xsd:extension base="f:SerialNumberOfQualifierType">
                                    <xsd:annotation>
                                        <xsd:documentation>AN IDENTIFIER OF AN ENTITY, COMMONLY CONSIDERED TO BE OR REFERRED TO AS A
                                            'NUMBER.'</xsd:documentation>
                                        <xsd:appinfo>
                                            <FieldFormatIndexReferenceNumber>487</FieldFormatIndexReferenceNumber>
                                            <FieldFormatName>Number</FieldFormatName>
                                            <FieldFormatStructure/>
                                            <FieldFormatDefinition>AN IDENTIFIER OF AN ENTITY, COMMONLY CONSIDERED TO BE OR REFERRED TO AS A
                                                'NUMBER.'</FieldFormatDefinition>
                                            <FieldFormatRemark/>
                                            <FieldFormatRelatedDocument>NONE</FieldFormatRelatedDocument>
                                            <FieldFormatSponsor/>
                                            <VersionIndicator>B.1.01.01</VersionIndicator>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                    <xsd:attribute name="ffSeq" type="xsd:unsignedShort" fixed="7"/>
                                    <xsd:attribute name="ffirnFudn" type="xsd:string" fixed="FF487-17"/>
                                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                </xsd:extension>
                            </xsd:simpleContent>
                        </xsd:complexType>
                    </xsd:element>
                    <xsd:element name="MessageSecurityPolicy" minOccurs="1" maxOccurs="1" nillable="true">
                        <xsd:annotation>
                            <xsd:documentation>The security policy that applies to the information contained in a message text
                                format.</xsd:documentation>
                            <xsd:appinfo>
                                <FieldFormatPositionName>MESSAGE SECURITY POLICY</FieldFormatPositionName>
                                <FieldFormatPositionNumber>8</FieldFormatPositionNumber>
                                <OccurrenceCategory>Mandatory</OccurrenceCategory>
                                <FieldFormatPositionConcept>The security policy that applies to the information contained in a message text
                                    format.</FieldFormatPositionConcept>
                                <ColumnHeader/>
                                <AlphabeticIdentifier>A</AlphabeticIdentifier>
                                <Justification/>
                                <FieldDescriptor/>
                                <AssignedFfirnFudUseDescription>The security policy that applies to the information contained in a message text
                                    format.</AssignedFfirnFudUseDescription>
                            </xsd:appinfo>
                        </xsd:annotation>
                        <xsd:complexType>
                            <xsd:simpleContent>
                                <xsd:extension base="f:MessageSecurityPolicyType">
                                    <xsd:annotation>
                                        <xsd:documentation>THE MARKINGS USED IN AN XML SCHEMA TO DOCUMENT SECURITY MARKINGS
                                            ATTRIBUTES.</xsd:documentation>
                                        <xsd:appinfo>
                                            <FieldFormatIndexReferenceNumber>105</FieldFormatIndexReferenceNumber>
                                            <FieldFormatName>SecurityMarkingsSchemaAttributes</FieldFormatName>
                                            <FieldFormatStructure/>
                                            <FieldFormatDefinition>THE MARKINGS USED IN AN XML SCHEMA TO DOCUMENT SECURITY MARKINGS
                                                ATTRIBUTES.</FieldFormatDefinition>
                                            <FieldFormatRemark/>
                                            <FieldFormatRelatedDocument>NONE</FieldFormatRelatedDocument>
                                            <FieldFormatSponsor/>
                                            <VersionIndicator>B.1.01.00</VersionIndicator>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                    <xsd:attribute name="ffSeq" type="xsd:unsignedShort" fixed="8"/>
                                    <xsd:attribute name="ffirnFudn" type="xsd:string" fixed="FF105-3"/>
                                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                </xsd:extension>
                            </xsd:simpleContent>
                        </xsd:complexType>
                    </xsd:element>
                    <xsd:element name="MessageSecurityClassification" minOccurs="1" maxOccurs="1" nillable="true">
                        <xsd:annotation>
                            <xsd:documentation>The security classification of the message.</xsd:documentation>
                            <xsd:appinfo>
                                <FieldFormatPositionName>MESSAGE SECURITY CLASSIFICATION</FieldFormatPositionName>
                                <FieldFormatPositionNumber>9</FieldFormatPositionNumber>
                                <OccurrenceCategory>Mandatory</OccurrenceCategory>
                                <FieldFormatPositionConcept>The security classification of the message.</FieldFormatPositionConcept>
                                <ColumnHeader/>
                            </xsd:appinfo>
                        </xsd:annotation>
                        <xsd:complexType>
                            <xsd:choice>
                                <xsd:element name="MessageSecurityClassificationExtended">
                                    <xsd:annotation>
                                        <xsd:documentation>The security classification of the message.</xsd:documentation>
                                        <xsd:appinfo>
                                            <AlphabeticIdentifier>A</AlphabeticIdentifier>
                                            <Justification/>
                                            <FieldDescriptor/>
                                            <AssignedFfirnFudUseDescription>The security classification of the
                                                message.</AssignedFfirnFudUseDescription>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                    <xsd:complexType>
                                        <xsd:simpleContent>
                                            <xsd:extension base="f:MessageSecurityClassificationExtendedType">
                                                <xsd:annotation>
                                                    <xsd:documentation>THE MARKINGS USED IN AN XML SCHEMA TO DOCUMENT SECURITY MARKINGS
                                                        ATTRIBUTES.</xsd:documentation>
                                                    <xsd:appinfo>
                                                        <FieldFormatIndexReferenceNumber>105</FieldFormatIndexReferenceNumber>
                                                        <FieldFormatName>SecurityMarkingsSchemaAttributes</FieldFormatName>
                                                        <FieldFormatStructure/>
                                                        <FieldFormatDefinition>THE MARKINGS USED IN AN XML SCHEMA TO DOCUMENT SECURITY MARKINGS
                                                            ATTRIBUTES.</FieldFormatDefinition>
                                                        <FieldFormatRemark/>
                                                        <FieldFormatRelatedDocument>NONE</FieldFormatRelatedDocument>
                                                        <FieldFormatSponsor/>
                                                        <VersionIndicator>B.1.01.00</VersionIndicator>
                                                    </xsd:appinfo>
                                                </xsd:annotation>
                                                <xsd:attribute name="ffirnFudn" type="xsd:string" fixed="FF105-2"/>
                                                <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                            </xsd:extension>
                                        </xsd:simpleContent>
                                    </xsd:complexType>
                                </xsd:element>
                                <xsd:element name="MessageSecurityClassificationOther">
                                    <xsd:annotation>
                                        <xsd:documentation>The security classification of the message.</xsd:documentation>
                                        <xsd:appinfo>
                                            <AlphabeticIdentifier>B</AlphabeticIdentifier>
                                            <Justification/>
                                            <FieldDescriptor>OTHER</FieldDescriptor>
                                            <AssignedFfirnFudUseDescription>The security classification of the
                                                message.</AssignedFfirnFudUseDescription>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                    <xsd:complexType>
                                        <xsd:simpleContent>
                                            <xsd:extension base="f:MessageSecurityClassificationOtherType">
                                                <xsd:annotation>
                                                    <xsd:documentation>THE MARKINGS USED IN AN XML SCHEMA TO DOCUMENT SECURITY MARKINGS
                                                        ATTRIBUTES.</xsd:documentation>
                                                    <xsd:appinfo>
                                                        <FieldFormatIndexReferenceNumber>105</FieldFormatIndexReferenceNumber>
                                                        <FieldFormatName>SecurityMarkingsSchemaAttributes</FieldFormatName>
                                                        <FieldFormatStructure/>
                                                        <FieldFormatDefinition>THE MARKINGS USED IN AN XML SCHEMA TO DOCUMENT SECURITY MARKINGS
                                                            ATTRIBUTES.</FieldFormatDefinition>
                                                        <FieldFormatRemark/>
                                                        <FieldFormatRelatedDocument>NONE</FieldFormatRelatedDocument>
                                                        <FieldFormatSponsor/>
                                                        <VersionIndicator>B.1.01.00</VersionIndicator>
                                                    </xsd:appinfo>
                                                </xsd:annotation>
                                                <xsd:attribute name="ffirnFudn" type="xsd:string" fixed="FF105-5"/>
                                                <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                            </xsd:extension>
                                        </xsd:simpleContent>
                                    </xsd:complexType>
                                </xsd:element>
                            </xsd:choice>
                            <xsd:attribute name="ffSeq" type="xsd:unsignedShort" fixed="11"/>
                            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                        </xsd:complexType>
                    </xsd:element>
                    <xsd:element name="MessageSecurityCategory" minOccurs="0" maxOccurs="1">
                        <xsd:annotation>
                            <xsd:documentation>The security category that applies to the information contained in a message text
                                format.</xsd:documentation>
                            <xsd:appinfo>
                                <FieldFormatPositionName>MESSAGE SECURITY CATEGORY</FieldFormatPositionName>
                                <FieldFormatPositionNumber>12</FieldFormatPositionNumber>
                                <OccurrenceCategory>Operationally Determined</OccurrenceCategory>
                                <FieldFormatPositionConcept>The security category that applies to the information contained in a message text
                                    format.</FieldFormatPositionConcept>
                                <ColumnHeader/>
                                <AlphabeticIdentifier>A</AlphabeticIdentifier>
                                <Justification/>
                                <FieldDescriptor/>
                                <AssignedFfirnFudUseDescription>The security category that applies to the information contained in a message text
                                    format.</AssignedFfirnFudUseDescription>
                            </xsd:appinfo>
                        </xsd:annotation>
                        <xsd:complexType>
                            <xsd:simpleContent>
                                <xsd:extension base="f:MessageSecurityCategoryType">
                                    <xsd:annotation>
                                        <xsd:documentation>THE MARKINGS USED IN AN XML SCHEMA TO DOCUMENT SECURITY MARKINGS
                                            ATTRIBUTES.</xsd:documentation>
                                        <xsd:appinfo>
                                            <FieldFormatIndexReferenceNumber>105</FieldFormatIndexReferenceNumber>
                                            <FieldFormatName>SecurityMarkingsSchemaAttributes</FieldFormatName>
                                            <FieldFormatStructure/>
                                            <FieldFormatDefinition>THE MARKINGS USED IN AN XML SCHEMA TO DOCUMENT SECURITY MARKINGS
                                                ATTRIBUTES.</FieldFormatDefinition>
                                            <FieldFormatRemark/>
                                            <FieldFormatRelatedDocument>NONE</FieldFormatRelatedDocument>
                                            <FieldFormatSponsor/>
                                            <VersionIndicator>B.1.01.00</VersionIndicator>
                                        </xsd:appinfo>
                                    </xsd:annotation>
                                    <xsd:attribute name="ffSeq" type="xsd:unsignedShort" fixed="12"/>
                                    <xsd:attribute name="ffirnFudn" type="xsd:string" fixed="FF105-4"/>
                                    <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
                                </xsd:extension>
                            </xsd:simpleContent>
                        </xsd:complexType>
                    </xsd:element>
                </xsd:sequence>
                <xsd:attribute name="setid" type="xsd:string" fixed="MSGID"/>
            </xsd:extension>
        </xsd:complexContent>
    </xsd:complexType>
</xsl:stylesheet>
