<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:slb="urn:nato:stanag:4774:confidentialitymetadatalabel:ncdf"
    exclude-result-prefixes="xs" version="1.0">

    <xsl:variable name="prefix" select="'slb'"/>

    <xsl:variable name="inputxsd" select="document('../xsd/STANAG-4774.xsd')"/>

    <xsl:variable name="RootEl" select="'ConfidentialityLabel'"/>

    <xsl:variable name="outputmap" select="'../instance/STANAG-4774-MAP.xml'"/>

    <xsl:variable name="outputxsd" select="'../xsd/STANAG-4774-NCDF.xsd'"/>

    <xsl:variable name="additions">
        <xs:simpleType name="CategoryTypeCodeSimpleType">
            <xs:annotation>
                <xs:documentation>A data type for Category Type Code</xs:documentation>
            </xs:annotation>
            <xs:restriction base="xs:token">
                <xs:enumeration value="RESTRICTIVE">
                    <xs:annotation>
                        <xs:documentation>RESTRICTIVE</xs:documentation>
                    </xs:annotation>
                </xs:enumeration>
                <xs:enumeration value="PERMISSIVE">
                    <xs:annotation>
                        <xs:documentation>PERMISSIVE</xs:documentation>
                    </xs:annotation>
                </xs:enumeration>
                <xs:enumeration value="INFORMATIVE">
                    <xs:annotation>
                        <xs:documentation>INFORMATIVE</xs:documentation>
                    </xs:annotation>
                </xs:enumeration>
            </xs:restriction>
        </xs:simpleType>
        <xs:simpleType name="AnyURISimpleType">
            <xs:annotation>
                <xs:documentation>A data type used to extend W3C anyURI data objects</xs:documentation>
            </xs:annotation>
            <xs:restriction base="xs:anyURI"/>
        </xs:simpleType>
        <xs:simpleType name="StringSimpleType">
            <xs:annotation>
                <xs:documentation>A data type used to extend W3C string data objects</xs:documentation>
            </xs:annotation>
            <xs:restriction base="xs:string"/>
        </xs:simpleType>
        <xs:simpleType name="IntegerValueSimpleType">
            <xs:annotation>
                <xs:documentation>A data type for Integer Value Type</xs:documentation>
            </xs:annotation>
            <xs:restriction base="CategoryValueSimpleType">
                <xs:pattern value="[0-9]+"/>
            </xs:restriction>
        </xs:simpleType>
        <xs:simpleType name="DateTimeSimpleType">
            <xs:annotation>
                <xs:documentation>A data type used to extend W3C dateTime data objects</xs:documentation>
            </xs:annotation>
            <xs:restriction base="xs:dateTime"/>
        </xs:simpleType>
        <xs:simpleType name="TokenSimpleType">
            <xs:annotation>
                <xs:documentation>A data type used to extend W3C Token data objects</xs:documentation>
            </xs:annotation>
            <xs:restriction base="xs:token"/>
        </xs:simpleType>
        <xs:simpleType name="BitStringValueSimpleType">
            <xs:annotation>
                <xs:documentation>A data type for Bit String Value Type</xs:documentation>
            </xs:annotation>
            <xs:restriction base="CategoryValueSimpleType">
                <xs:pattern value="[0-1]+"/>
            </xs:restriction>
        </xs:simpleType>
        <xs:simpleType name="OriginatorIDCodeSimpleType">
            <xs:annotation>
                <xs:documentation>A data type for Originator ID Types</xs:documentation>
            </xs:annotation>
            <xs:restriction base="xs:string">
                <xs:enumeration value="rfc822Name">
                    <xs:annotation>
                        <xs:documentation>rfc822Name</xs:documentation>
                    </xs:annotation>
                </xs:enumeration>
                <xs:enumeration value="dNSName">
                    <xs:annotation>
                        <xs:documentation>dNSName</xs:documentation>
                    </xs:annotation>
                </xs:enumeration>
                <xs:enumeration value="directoryName">
                    <xs:annotation>
                        <xs:documentation>directoryName</xs:documentation>
                    </xs:annotation>
                </xs:enumeration>
                <xs:enumeration value="uniformResourceIdentifier">
                    <xs:annotation>
                        <xs:documentation>uniformResourceIdentifier</xs:documentation>
                    </xs:annotation>
                </xs:enumeration>
                <xs:enumeration value="iPAddress">
                    <xs:annotation>
                        <xs:documentation>iPAddress</xs:documentation>
                    </xs:annotation>
                </xs:enumeration>
                <xs:enumeration value="x400Address">
                    <xs:annotation>
                        <xs:documentation>x400Address</xs:documentation>
                    </xs:annotation>
                </xs:enumeration>
                <xs:enumeration value="userPrincipalName">
                    <xs:annotation>
                        <xs:documentation>userPrincipalName</xs:documentation>
                    </xs:annotation>
                </xs:enumeration>
                <xs:enumeration value="jID">
                    <xs:annotation>
                        <xs:documentation>jID</xs:documentation>
                    </xs:annotation>
                </xs:enumeration>
            </xs:restriction>
        </xs:simpleType>
        
        <xs:complexType name="AnyURIType">
            <xs:annotation>
                <xs:documentation>A data type used to extend W3C anyURI data objects</xs:documentation>
            </xs:annotation>
            <xs:simpleContent>
                <xs:extension base="AnyURISimpleType">
                    <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
        <xs:complexType name="StringType">
            <xs:annotation>
                <xs:documentation>A data type used to extend W3C string data objects</xs:documentation>
            </xs:annotation>
            <xs:simpleContent>
                <xs:extension base="StringSimpleType">
                    <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
        <xs:complexType name="IntegerValueType">
            <xs:annotation>
                <xs:documentation>A data type used to extend W3C string data objects</xs:documentation>
            </xs:annotation>
            <xs:simpleContent>
                <xs:extension base="IntegerValueSimpleType">
                    <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
        <xs:complexType name="PrivacyMarkType">
            <xs:annotation>
                <xs:documentation>A data type for Privacy Mark Type</xs:documentation>
            </xs:annotation>
            <xs:simpleContent>
                <xs:extension base="PrivacyMarkSimpleType">
                    <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
        <xs:complexType name="TokenType">
            <xs:annotation>
                <xs:documentation>A data type used to extend W3C Token data objects</xs:documentation>
            </xs:annotation>
            <xs:simpleContent>
                <xs:extension base="TokenSimpleType">
                    <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
        <xs:complexType name="GenericValueType">
            <xs:annotation>
                <xs:documentation>A data type for Generic Value Type</xs:documentation>
            </xs:annotation>
            <xs:simpleContent>
                <xs:extension base="GenericValueSimpleType">
                    <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
        <xs:complexType name="DateTimeType">
            <xs:annotation>
                <xs:documentation>A data type used to extend W3C dateTime data objects</xs:documentation>
            </xs:annotation>
            <xs:simpleContent>
                <xs:extension base="DateTimeSimpleType">
                    <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
        <xs:complexType name="BitStringValueType">
            <xs:annotation>
                <xs:documentation>A data type for Bit String Value Type</xs:documentation>
            </xs:annotation>
            <xs:simpleContent>
                <xs:extension base="BitStringValueSimpleType">
                    <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
        <xs:complexType name="ClassificationType">
            <xs:annotation>
                <xs:documentation>A data type for Classification Type</xs:documentation>
                <xs:appinfo>
                    <slb:UniqueIdentifier>urn:nato:stanag:4774:confidentialitymetadatalabel:1:0:appinfo:classificationType</slb:UniqueIdentifier>
                    <slb:Name>Classification Type</slb:Name>
                    <slb:Definition>The basic hierarchical indication of sensitivity.</slb:Definition>
                    <slb:VersionIndicator>1.2</slb:VersionIndicator>
                    <slb:UsageGuidance/>
                    <slb:RestrictionType/>
                    <slb:RestrictionValue/>
                </xs:appinfo>
            </xs:annotation>
            <xs:simpleContent>
                <xs:extension base="RequiredTokenSimpleType">
                    <xs:attribute ref="uri">
                        <xs:annotation>
                            <xs:documentation>A data item for URI</xs:documentation>
                        </xs:annotation>
                    </xs:attribute>
                    <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
        <xs:complexType name="PolicyIdentifierType">
            <xs:annotation>
                <xs:documentation>A data type for Policy Identifier Type</xs:documentation>
                <xs:appinfo>
                    <slb:UniqueIdentifier>urn:nato:stanag:4774:confidentialitymetadatalabel:1:0:appinfo:policyIdentifierType</slb:UniqueIdentifier>
                    <slb:Name>Policy Identifier Type</slb:Name>
                    <slb:Definition>The Security Policy Authority, which in trun defines the value domain for the other elements within the Confidentiality Information.</slb:Definition>
                    <slb:VersionIndicator>1.2</slb:VersionIndicator>
                    <slb:UsageGuidance/>
                    <slb:RestrictionType/>
                    <slb:RestrictionValue/>
                </xs:appinfo>
            </xs:annotation>
            <xs:simpleContent>
                <xs:extension base="RequiredTokenSimpleType">
                    <xs:attribute ref="uri">
                        <xs:annotation>
                            <xs:documentation>A data item for URI</xs:documentation>
                        </xs:annotation>
                    </xs:attribute>
                    <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
        <xs:complexType name="CategoryType">
            <xs:annotation>
                <xs:documentation>A data type for Category Type</xs:documentation>
                <xs:appinfo>
                    <slb:UniqueIdentifier>urn:nato:stanag:4774:confidentialitymetadatalabel:1:0:appinfo:categoryType</slb:UniqueIdentifier>
                    <slb:Name>Category Type</slb:Name>
                    <slb:Definition>The more granular indication of sensitivity, over and above the classification.</slb:Definition>
                    <slb:VersionIndicator>1.2</slb:VersionIndicator>
                    <slb:UsageGuidance/>
                    <slb:RestrictionType/>
                    <slb:RestrictionValue/>
                </xs:appinfo>
            </xs:annotation>
            <xs:complexContent>
                <xs:extension base="structures:ObjectType">
                    <xs:sequence>
                        <xs:element ref="CategoryValueAbstract" minOccurs="0" maxOccurs="unbounded">
                            <xs:annotation>
                                <xs:documentation>A data item for Category Value</xs:documentation>
                            </xs:annotation>
                        </xs:element>
                        <xs:element ref="CategoryAugmentationPoint" minOccurs="0" maxOccurs="unbounded"/>
                    </xs:sequence>
                    <xs:attribute ref="typeCode">
                        <xs:annotation>
                            <xs:documentation>A data item for Category Type Code</xs:documentation>
                        </xs:annotation>
                    </xs:attribute>
                    <xs:attribute ref="uri">
                        <xs:annotation>
                            <xs:documentation>A data item for URI</xs:documentation>
                        </xs:annotation>
                    </xs:attribute>
                    <xs:attribute ref="tagName">
                        <xs:annotation>
                            <xs:documentation>A data item for Tag Name</xs:documentation>
                        </xs:annotation>
                    </xs:attribute>
                </xs:extension>
            </xs:complexContent>
        </xs:complexType>
        <xs:complexType name="CategoryValueType">
            <xs:annotation>
                <xs:documentation>A data type for Category Value Type</xs:documentation>
            </xs:annotation>
            <xs:simpleContent>
                <xs:extension base="CategoryValueSimpleType">
                    <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
        <xs:complexType name="OriginatorIDType">
            <xs:annotation>
                <xs:documentation>A data type for ID Type</xs:documentation>
                <xs:appinfo>
                    <slb:UniqueIdentifier>urn:nato:stanag:4774:confidentialitymetadatalabel:1:0:appinfo:originatorIDType</slb:UniqueIdentifier>
                    <slb:Name>Originator ID Type</slb:Name>
                    <slb:Definition>The originator of the confidentiality label, which may be different to the originator of the data object.</slb:Definition>
                    <slb:VersionIndicator>1.2</slb:VersionIndicator>
                    <slb:UsageGuidance/>
                    <slb:RestrictionType/>
                    <slb:RestrictionValue/>
                </xs:appinfo>
            </xs:annotation>
            <xs:simpleContent>
                <xs:extension base="StringSimpleType">
                    <xs:attribute ref="originatorIDCode">
                        <xs:annotation>
                            <xs:documentation>A data item for ID Type</xs:documentation>
                        </xs:annotation>
                    </xs:attribute>
                    <xs:attributeGroup ref="structures:SimpleObjectAttributeGroup"/>
                </xs:extension>
            </xs:simpleContent>
        </xs:complexType>
        <xs:complexType name="ConfidentialityLabelType">
            <xs:annotation>
                <xs:documentation>A data type for Confidentiality Label Type</xs:documentation>
                <xs:appinfo>
                    <slb:UniqueIdentifier>urn:nato:stanag:4774:confidentialitymetadatalabel:1:0:appinfo:confidentialityLabelType</slb:UniqueIdentifier>
                    <slb:Name>Confidentiality Label Type</slb:Name>
                    <slb:Definition>A type that is used as the base for the confidentiality label metadata elements.</slb:Definition>
                    <slb:VersionIndicator>1.3</slb:VersionIndicator>
                    <slb:UsageGuidance/>
                    <slb:RestrictionType/>
                    <slb:RestrictionValue/>
                </xs:appinfo>
            </xs:annotation>
            <xs:complexContent>
                <xs:extension base="ConfidentialityLabelBaseType">
                    <xs:sequence>
                       <xs:element ref="ConfidentialityLabelAugmentationPoint" minOccurs="0" maxOccurs="unbounded"/>
                    </xs:sequence>
                    <xs:attribute ref="id">
                        <xs:annotation>
                            <xs:documentation>A data item for ID</xs:documentation>
                        </xs:annotation>
                    </xs:attribute>
                    <xs:attribute ref="reviewDateTime">
                        <xs:annotation>
                            <xs:documentation>A data item for Date Time</xs:documentation>
                        </xs:annotation>
                    </xs:attribute>
                </xs:extension>
            </xs:complexContent>
        </xs:complexType>
        
        <xs:element name="SuccessionDateTime" type="DateTimeType" nillable="true">
            <xs:annotation>
                <xs:documentation>A data item for Succession Date Time</xs:documentation>
            </xs:annotation>
        </xs:element>
        <xs:element name="CreationDateTime" type="DateTimeType" nillable="true">
            <xs:annotation>
                <xs:documentation>A data item for Creation Date Time</xs:documentation>
            </xs:annotation>
        </xs:element>
        <xs:element name="CategoryValueAbstract" abstract="true" nillable="true">
            <xs:annotation>
                <xs:documentation>A data concept for a substituion group of Category Values</xs:documentation>
                <xs:appinfo>
                    <slb:Choice>
                        <slb:Element name="GenericValue" type="GenericValueType"/>
                        <slb:Element name="IntegerValue" type="IntegerValueType"/>
                        <slb:Element name="BitStringValue" type="BitStringValueType"/>
                    </slb:Choice>
                </xs:appinfo>
            </xs:annotation>
        </xs:element>
        <xs:element name="GenericValue" type="GenericValueType" substitutionGroup="CategoryValueAbstract" nillable="true">
            <xs:annotation>
                <xs:documentation>A data item for Generic Value</xs:documentation>
            </xs:annotation>
        </xs:element>
        <xs:element name="IntegerValue" type="IntegerValueType" substitutionGroup="CategoryValueAbstract" nillable="true">
            <xs:annotation>
                <xs:documentation>A data item for Integer Value</xs:documentation>
            </xs:annotation>
        </xs:element>
        <xs:element name="BitStringValue" type="BitStringValueType" substitutionGroup="CategoryValueAbstract" nillable="true">
            <xs:annotation>
                <xs:documentation>A data item for Bit String Value</xs:documentation>
            </xs:annotation>
        </xs:element>
        <xs:element name="ConfidentialityLabelAugmentationPoint" abstract="true">
            <xs:annotation>
                <xs:documentation>An augmentation point for ConfidentialityLabeld</xs:documentation>
            </xs:annotation>
        </xs:element>

        <xs:attribute name="id" type="StringSimpleType">
            <xs:annotation>
                <xs:documentation>A data item for ID</xs:documentation>
            </xs:annotation>
        </xs:attribute>
        <xs:attribute name="uri" type="AnyURISimpleType">
            <xs:annotation>
                <xs:documentation>A data item for URI</xs:documentation>
            </xs:annotation>
        </xs:attribute>
        <xs:attribute name="reviewDateTime" type="DateTimeSimpleType">
            <xs:annotation>
                <xs:documentation>A data item for Review date and time</xs:documentation>
            </xs:annotation>
        </xs:attribute>
        <xs:attribute name="typeCode" type="CategoryTypeCodeSimpleType">
            <xs:annotation>
                <xs:documentation>A data item for Category Type Code</xs:documentation>
            </xs:annotation>
        </xs:attribute>
    
    
    </xsl:variable>

    <xsl:variable name="changes">
        <Attribute origname="IDType" origtype="" niemname="originatorIDCode" niemtype="OriginatorIDCodeSimpleType" niemattributedoc="A data item for originator ID"/>
        <Attribute origname="Type" origtype="" niemname="typeCode" niemtype="CategoryTypeCodeSimpleType" niemattributedoc="A data item for Category Type Code"/>
        <Attribute origname="TagName" origtype="xs:string" niemname="tagName" niemtype="StringSimpleType" niemattributedoc="A data item for Tag Name"/>
        <Attribute origname="Id" origtype="xs:ID" niemname="id" niemtype="StringSimpleType" niemattributedoc="A data item for ID"/>
        <Attribute origname="ReviewDateTime" origtype="xs:dateTime" niemname="reviewDateTime" niemtype="DateTimeSimpleType" niemattributedoc="A data item for Date Time"/>
        <Attribute origname="URI" origtype="xs:anyURI" niemname="uri" niemtype="AnyURISimpleType" niemattributedoc="A data item for URI"/>
    </xsl:variable>
    
    <xsl:template match="Attribute[@origname='URI']" mode="global"/>
    
    <xsl:template match="Attribute[@origname='Id']" mode="global"/>
    
    <xsl:template match="ComplexType[@origname='ConfidentialityLabelType']" mode="global"/>

    <xsl:variable name="xsdtns">
        <refxsd tns="urn:nato:stanag:4774:confidentialitymetadatalabel:1:0" path="'../xsd/STANAG-4774.xsd'"/>
    </xsl:variable>

    <xsl:variable name="xsdmapoutpath">
        <refxsd tns="urn:nato:stanag:4774:confidentialitymetadatalabel:ncdf" path="'../xml/STANAG-4774-MAP.xml'"/>
    </xsl:variable>

    <xsl:variable name="xsdoutpath">
        <refxsd tns="urn:nato:stanag:4774:confidentialitymetadatalabel:ncdf" path="'../xsd/STANAG-4774-NCDF.xsd'"/>
    </xsl:variable>

    <xsl:variable name="appinf" select="'ncdf/ncdfappinfo.xsd'"/>

    <xsl:variable name="ref-xsd-template">
        <xs:schema xmlns="urn:nato:stanag:4774:confidentialitymetadatalabel:ncdf" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
            xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/" xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/"
            xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:slb="urn:nato:stanag:4774:confidentialitymetadatalabel:ncdf"
            xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:nato:stanag:4774:confidentialitymetadatalabel:ncdf"
            ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
            attributeFormDefault="unqualified" version="1.0">
            <xs:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="ncdf/utility/structures/4.0/structures.xsd"/>
            <xs:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="ncdf/localTerminology.xsd"/>
            <xs:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="ncdf/utility/appinfo/4.0/appinfo.xsd"/>
            <xs:import namespace="urn:int:nato:ncdf:appinfo" schemaLocation="ncdf/ncdfappinfo.xsd"/>
            <xs:annotation>
                <xs:documentation>NIEM Conformant Version of NATO STNAG 4774 Confidentiality Labelling.</xs:documentation>
            </xs:annotation>
        </xs:schema>
    </xsl:variable>

    <xsl:variable name="iep-xsd-template">
        <xs:schema xmlns="urn:int:nato:ncdf:mtf" xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:int:nato:ncdf:mtf" xml:lang="en-US"
            elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
            <xs:import namespace="urn:int:nato:ncdf:mtf:appinfo" schemaLocation="ncdf/mtfappinfo.xsd"/>
        </xs:schema>
    </xsl:variable>

    <xsl:template match="*" mode="appinf">
        <xsl:element name="{concat('slb:',name())}">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
