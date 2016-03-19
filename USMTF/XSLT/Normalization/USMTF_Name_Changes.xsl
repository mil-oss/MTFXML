<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <!--USMTF NAME CHANGES-->
    <xsl:template match="xsd:element[@name = 'InnerRadius'][@type = 'field:LengthInNauticalMilesType']">
        <xsd:element name="InnerRadiusInNauticalMiles">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'EndTime'][@type = 'field:DateTimeGroupZuluType']">
        <xsd:element name="EndTimeZulu">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'MeansOfDetection'][@type = 'field:MeansOfRadiologicalDetectionType']">
        <xsd:element name="MeansOfRadiologicalDetection">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'OuterRadius'][@type = 'field:LengthInNauticalMilesType']">
        <xsd:element name="OuterRadiusInNauticalMiles">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'Platform'][@type = 'field:LinkUnitPlatformTypeType']">
        <xsd:element name="LinkPlatformType">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'Platform'][@type = 'field:NetworkEnabledWeaponPlatformTypeType']">
        <xsd:element name="NetworkEnabledWeaponPlatformType">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'RepresentativeDownwindSpeed'][@type = 'field:SpeedAndUnitOfMeasurementType']">
        <xsd:element name="RepresentativeDownwindSpeedAndMeasurement">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'StartTime'][@type = 'field:DateTimeGroupZuluType']">
        <xsd:element name="StartTimeZulu">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'StartTime'][@type = 'field:MilitaryTimeType']">
        <xsd:element name="StartTimeMilitary">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'TimeFrom'][@type = 'field:MilitaryTimeType']">
        <xsd:element name="TimeFromMilitary">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'TimeOnTarget'][@type = 'field:TimeHourMinuteType']">
        <xsd:element name="TimeOnTargetHourMinute">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'TimeTo'][@type = 'field:MilitaryTimeType']">
        <xsd:element name="TimeToMilitary">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ActivityType'][@type = 'field:TypeOfActivityType']">
        <xsd:element name="ActivityType">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:attribute name="type">
                <xsl:text>ActivityTypeType</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CloudCoverage'][@type = 'field:CloudCoverDegreeOfType']">
        <xsd:element name="CloudCoverDegreeOf">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CountryCode'][@type = 'field:GeopoliticalEntityType']">
        <xsd:element name="GeopoliticalEntity">
            <xsl:apply-templates select="@type" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DesiredMeanPointOfImpactElevation'][@type = 'field:ElevationInFeetOrMetersQualifiedType']">
        <xsd:element name="DesiredMeanPointOfImpactElevationQualified">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'FuzeType'][@type = 'field:WeaponFuzeTypeType']">
        <xsd:element name="WeaponFuzeType">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'GroundKeyFrequencyMap'][@type = 'field:SadlFrequencyMapType']">
        <xsd:element name="SadlFrequencyMap">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'MissionType'][@type = 'field:AerialMissionTypeType']">
        <xsd:element name="AerialMissionType">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'Radius'][@type = 'field:DistanceInNauticalMilesMetersOrKilometersType']">
        <xsd:element name="RadiusInNauticalMilesMetersOrKilometers">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'Width'][@type = 'field:DistanceInNauticalMilesMetersOrKilometersType']">
        <xsd:element name="WidthInNauticalMilesMetersOrKilometers">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DeliveryMethod'][@type = 'field:AirliftDeliveryMethodType']">
        <xsd:element name="AirliftDeliveryMethod">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'LocationQualifier'][@type = 'field:ExpandedLocationQualifierType']">
        <xsd:element name="ExpandedLocationQualifier">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'MissileType'][@type = 'field:TypeOfMissileType']">
        <xsd:element name="TypeOfMissile">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'RecoveryTime'][@type = 'field:DateTimeGroupType']">
        <xsd:element name="RecoveryTimeDTG">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ReportSerialNumber'][@type = 'field:ReportSerialNumberWithTwoCharacterCodeType']">
        <xsd:element name="ReportSerialNumberWithTwoCharacterCode">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ShipType'][@type = 'field:ShipTypeCategoryType']">
        <xsd:element name="ShipTypeCategory">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'TacanChannel'][@type = 'field:TacanChannelReceiverAndTankerType']">
        <xsd:element name="TacanChannelReceiverAndTanker">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'TargetElevation'][@type = 'field:ElevationInFeetOrMetersQualifiedType']">
        <xsd:element name="TargetElevationElevationInFeetOrMetersQualified">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'TargetPriorityIdentifier'][@type = 'field:PrimaryAlternateSecondaryDesignatorType']">
        <xsd:element name="PrimaryAlternateSecondaryDesignator">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'TypeOfDelivery'][@type = 'field:TypeAndMeansOfDeliveryType']">
        <xsd:element name="TypeAndMeansOfDelivery">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'VegetationDescription'][@type = 'field:VegetationDescriptionCbrnType']">
        <xsd:element name="VegetationDescriptionCbrn">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CountryOfTheWorld'][@type = 'field:GeopoliticalEntityType']">
        <xsd:element name="CountryOfTheWorld" type="GeopoliticalEntityType">
            <xsd:annotation>
                <xsd:appinfo>
                    <Field name="GeopoliticalEntities"
                        definition="A region controlled by a political community having an organized government and
                        possessing internal and external sovereignty, most often as a State but sometimes having a dependent relationship on another
                        political authority or a special sovereignty status."
                        version="B.1.02.00"/>
                </xsd:appinfo>
            </xsd:annotation>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CountermeasuresEmployed'][@type = 'field:CountermeasuresCategoryType']">
        <xsd:element name="CountermeasuresTypeEmployed">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'TgtPriority'][@type = 'field:PriorityType']">
        <xsd:element name="TgtPriorityCode">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'TrackNumberBlock'][@type = 'field:Link1TrackNumberBlockType']">
        <xsd:element name="Link1TrackNumberBlock">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'SurfaceAirTemperature'][//@base = 'field:FieldIntegerBaseType']">
        <xsd:element name="SurfaceAirTemperatureValue">
            <xsd:complexType>
                <xsd:simpleContent>
                    <xsd:restriction base="FieldIntegerBaseType">
                        <xsd:minInclusive value="-99"/>
                        <xsd:maxInclusive value="999"/>
                    </xsd:restriction>
                </xsd:simpleContent>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'UnitLink22Address'][not(@type)][//@base = 'field:UnitAddressType']">
        <xsd:element name="Link22UnitNuAddress" type="UnitAddressType"/>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'FlashToBangTimeInSeconds'][not(@type)][//@base = 'field:FieldIntegerBaseType']">
        <xsd:element name="FlashToBangTimeInSecondsValue">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'Amplification'][not(@type)][//@base = 'AmplificationSetType']">
        <xsd:element name="AmplificationSet" type="AmplificationSetType"/>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'Platform'][not(@type)][//@base = 'field:LinkUnitPlatformTypeType']">
        <xsd:element name="LinkUnitPlatformType" type="LinkUnitPlatformTypeType"/>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'Platform'][not(@type)][not(//@base = 'field:LinkUnitPlatformTypeType')][//@base = 'field:NetworkEnabledWeaponPlatformTypeType']">
        <xsd:element name="NetworkEnabledWeaponPlatformType" type="NetworkEnabledWeaponPlatformTypeType"/>
    </xsl:template>

    <!--DUPLICATES-->
    <xsl:template match="xsd:element[@name = 'AircraftAirspeedInKnots'][not(@type)]">
        <xsd:element name="AircraftAirspeedInKnots">
            <xsd:complexType>
                <xsd:simpleContent>
                    <xsd:restriction base="FieldIntegerBaseType">
                        <xsd:minInclusive value="0"/>
                        <xsd:maxInclusive value="9999"/>
                    </xsd:restriction>
                </xsd:simpleContent>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'EffectiveDayTime'][not(@type)]">
        <xsd:element name="EffectiveDayTime">
            <xsd:complexType>
                <xsd:simpleContent>
                    <xsd:restriction base="DayTimeNumericType">
                        <xsd:length value="7"/>
                    </xsd:restriction>
                </xsd:simpleContent>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CloudRadius'][@type = 'field:RadiusType']"/>
    <xsl:template match="xsd:element[@name = 'DownwindDistanceOfZone1'][not(@type)]"/>
    <xsl:template match="xsd:element[@name = 'FreeText'][not(@type)]">
        <xsd:element name="FreeText">
            <xsd:complexType>
                <xsd:simpleContent>
                    <xsd:extension base="FreeTextType"/>
                </xsd:simpleContent>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'Ipv6Address'][not(@type)]">
        <xsd:element name="Ipv6Address">
            <xsd:annotation>
                <xsd:documentation>The Internet Protocol Version 6 (IPV6) address of the air support element. A 128-bit address scheme using eight groups of four-digit hexadecimal integers (0-9, a-f)
                    with colons used as delimiters. The use of the embedded colon is allowed as an exception to the rules of USMTF.</xsd:documentation>
                <xsd:appinfo>
                    <Field positionName="IPV6 ADDRESS" identifier="A" name="InternetProtocolAddressIpv6"
                        definition="The Internet Protocol Version 6
                        (IPV6) address. A 128-bit address scheme using eight groups of four-digit hexadecimal integers (0-9, a-f, A-F) with colons
                        used as delimiters. The use of the embedded colon is allowed as an exception to the rules of USMTF."
                        remark="Example of an
                        IPV6 address: 3ffe:ffff:0100:f101:0210:a4ff:fee3:9566 CAN BE WRITTEN AS 3ffe:ffff:100:f101:210:a4ff:fee3:9566,
                        0000:0000:0000:0000:0000:0000:0000:0001 CAN BE WRITTEN AS ::1."
                        version="B.1.01.00"/>
                </xsd:appinfo>
            </xsd:annotation>
            <xsd:complexType>
                <xsd:simpleContent>
                    <xsd:restriction base="AlphaSubsetNumericIpv6TextType">
                        <xsd:minLength value="2"/>
                        <xsd:maxLength value="45"/>
                    </xsd:restriction>
                </xsd:simpleContent>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'NumberMissiles'][not(@type)]">
        <xsd:element name="NumberMissiles">
            <xsd:annotation>
                <xsd:appinfo>
                    <Field name="CountOfOrdnance" definition="A COUNT OF ORDNANCE OR RELATED ITEMS OF A CERTAIN TYPE." version="B.1.01.00"/>
                </xsd:appinfo>
            </xsd:annotation>
            <xsd:complexType>
                <xsd:simpleContent>
                    <xsd:restriction base="FieldIntegerBaseType">
                        <xsd:minInclusive value="0"/>
                        <xsd:maxInclusive value="999"/>
                    </xsd:restriction>
                </xsd:simpleContent>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ReleaseAngle'][not(@type)]">
        <xsd:element name="ReleaseAngle">
            <xsd:annotation>
                <xsd:appinfo>
                    <Field name="AngleInDegrees" definition="AN ANGLE MEASURED IN DEGREES." version="B.1.01.00"/>
                </xsd:appinfo>
            </xsd:annotation>
            <xsd:complexType>
                <xsd:simpleContent>
                    <xsd:restriction base="FieldIntegerBaseType">
                        <xsd:minInclusive value="0"/>
                        <xsd:maxInclusive value="90"/>
                    </xsd:restriction>
                </xsd:simpleContent>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <!--SETS-->
    <xsl:template match="xsd:element[@name = 'ActivityLocation'][ancestor::xsd:complexType[1]/@name = 'AdditionalSightingsSetType']">
        <xsd:element name="AdditionalSightingsActivityLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ActivityLocation'][ancestor::xsd:complexType[1]/@name = 'EnemyActivityDataSetType']">
        <xsd:element name="EnemyActivityLocationData">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ActivityLocation'][ancestor::xsd:complexType[1]/@name = 'EnemyActivityWithMissionNumberSetType']">
        <xsd:element name="EnemyObservedActivityLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ActivityLocation'][ancestor::xsd:complexType[1]/@name = 'InflightSightingReportSetType']">
        <xsd:element name="InflightSightingActivityLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ActivityLocation'][ancestor::xsd:complexType[1]/@name = 'IntelligenceSurveillanceAndReconnaissanceMissionResultsSetType']">
        <xsd:element name="IntelligenceSurveillanceAndReconnaissanceActivityLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ActivityLocation'][ancestor::xsd:complexType[1]/@name = 'MaritimeActivitySetType']">
        <xsd:element name="MaritimeActivityLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>  
    <xsl:template match="xsd:element[@name = 'ActivityLocation'][ancestor::xsd:complexType[1]/@name = 'AircraftSituationSetType']">
        <xsd:element name="AircraftSituationLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AirdropLocation'][ancestor::xsd:complexType[1]/@name = 'DropZoneDataSetType']">
        <xsd:element name="AirdropZoneLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AirfieldLocation'][ancestor::xsd:complexType[1]/@name = 'AirfieldForceProtectionSetType']">
        <xsd:element name="AirfieldPositionLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AirfieldLocation'][ancestor::xsd:complexType[1]/@name = 'EvacuationAirfieldSetType']">
        <xsd:element name="AirfieldLocationInformation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AirfieldLocation'][ancestor::xsd:complexType[1]/@name = 'ActualAircraftArrivalAndDepartureTimesSetType']">
        <xsd:element name="AirfieldLocationInformation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AltitudeOrDepth'][ancestor::xsd:complexType[1]/@name = 'EventWithSourceSetType']">
        <xsd:element name="EventAltitudeOrDepth">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AltitudeOrDepth'][ancestor::xsd:complexType[1]/@name = 'IsolationIncidentSetType']">
        <xsd:element name="IsolationIncidentAltitudeOrDepth">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AltitudeOrFlightLevel'][ancestor::xsd:complexType[1]/@name = 'AirborneRadioRelayStationDetailsMaritimeSetType']">
        <xsd:element name="AltitudeOrFlightLevelQualified">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AltitudeOrFlightLevel'][ancestor::xsd:complexType[1]/@name = 'AirToAirRefuelingStationAssignmentsSetType']">
        <xsd:element name="AssignedAltitudeOrFlightLevel">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AltitudeOrFlightLevel'][ancestor::xsd:complexType[1]/@name = 'CombatAirPatrolSetType']">
        <xsd:element name="CombatAirPatrolAltitudeOrFlightLevel">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AltitudeOrFlightLevel'][ancestor::xsd:complexType[1]/@name = 'ElectronicWarfareAircraftSetType']">
        <xsd:element name="ElectronicWarfareAircraftAltitudeOrFlightLevel">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AreaCoordinatesOrOrigin'][ancestor::xsd:complexType[1]/@name = 'AircraftRendezvousBreakupAreaSetType']">
        <xsd:element name="AircraftRendezvousBreakupAreaCoordinatesOrOrigin">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AreaCoordinatesOrOrigin'][ancestor::xsd:complexType[1]/@name = 'GroundTargetAreaSetType']">
        <xsd:element name="GroundTargetAreaCoordinatesOrOrigin">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AreaDescription'][ancestor::xsd:complexType[1]/@name = 'PositionTracePlotSetType']">
        <xsd:element name="PositionTracePlotAreaDescription">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AreaIdentifier'][ancestor::xsd:complexType[1]/@name = 'DesignatedAreaSetType']">
        <xsd:element name="DesignatedAreaIdentifier">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AreaIdentifier'][ancestor::xsd:complexType[1]/@name = 'SubmarineModeOfOperationSetType']">
        <xsd:element name="SubmarineAreaIdentifier">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ArrivalLocation'][ancestor::xsd:complexType[1]/@name = 'AirMissionDetailsSetType']">
        <xsd:element name="ArrivalLocationInformation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ArrivalLocation'][ancestor::xsd:complexType[1]/@name = 'EventTaskingSetType']">
        <xsd:element name="ShipArrivalLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ArrivalLocation'][ancestor::xsd:complexType[1]/@name = 'SailingIntentionsSetType']">
        <xsd:element name="SailingIntentionsArrivalLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ArrivalLocation'][ancestor::xsd:complexType[1]/@name = 'ArrivalPlaceAndCargoDetailsSetType']">
        <xsd:element name="ArrivalLocation">
            <xsd:complexType>
                <xsd:choice>
                    <xsd:element ref="field:GeographicLocationLatLongSeconds"/>
                    <xsd:element ref="field:GeographicLocationLatLongMinutes"/>
                </xsd:choice>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ArrivalLocation'][ancestor::xsd:complexType[1]/@name = 'ShipArrivalSetType']">
        <xsd:element name="ArrivalLocation">
            <xsd:complexType>
                <xsd:choice>
                    <xsd:element ref="field:GeographicLocationLatLongSeconds"/>
                    <xsd:element ref="field:GeographicLocationLatLongMinutes"/>
                </xsd:choice>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ArrivalTime'][ancestor::xsd:complexType[1]/@name = 'AirMovementSetType']">
        <xsd:element name="AirMovementArrivalTime">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ArrivalTime'][ancestor::xsd:complexType[1]/@name = 'AirRouteWithRoutePointTypeSetType']">
        <xsd:element name="AirRouteArrivalTime">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'BeaconLocation'][ancestor::xsd:complexType[1]/@name = 'SearchAndRescueBeaconSetType']">
        <xsd:element name="SearchAndRescueBeaconLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CallSignOrLineNumber'][ancestor::xsd:complexType[1]/@name = 'ATDL1ReportingUnitSetType']">
        <xsd:element name="ATDL1CallSignOrLineNumber">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CallSignOrLineNumber'][ancestor::xsd:complexType[1]/@name = 'Link22UnitSetType']">
        <xsd:element name="Link22CallSignOrLineNumber">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CmIdentifier'][ancestor::xsd:complexType[1]/@name = 'CoordinatingMeasureIdentificationSetType']">
        <xsd:element name="CoordinatingMeasureIdentifier">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CmIdentifier'][ancestor::xsd:complexType[1]/@name = 'CoordinatingMeasureStatusSetType']">
        <xsd:element name="CoordinatingMeasureStatusIdentifier">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ContactPoint'][ancestor::xsd:complexType[1]/@name = 'AircraftControlAgencySetType']">
        <xsd:element name="AircraftControlAgencyContactPoint">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ContactPoint'][ancestor::xsd:complexType[1]/@name = 'ContactInstructionsSetType']">
        <xsd:element name="ContactInstructionsContactPoint">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ContactPoint'][ancestor::xsd:complexType[1]/@name = 'ControlInformationSetType']">
        <xsd:element name="ControlInformationContactPoint">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ContactPoint'][ancestor::xsd:complexType[1]/@name = 'ForwardAirControllerSetType']">
        <xsd:element name="ForwardAirControllerContactPoint">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CourseAndSpeed'][ancestor::xsd:complexType[1]/@name = 'FriendlyForcesPositionSetType']">
        <xsd:element name="FriendlyForcesPositionCourseAndSpeed">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CourseAndSpeed'][ancestor::xsd:complexType[1]/@name = 'FriendlyForcesLocationSetType']">
        <xsd:element name="FriendlyForcesLocationCourseAndSpeed">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DateTimeOfStop'][ancestor::xsd:complexType[1]/@name = 'SubSurfaceNoticeOfIntentionAreaSetType']">
        <xsd:element name="SubSurfaceDateTimeOfStop">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DateTimeOfStop'][ancestor::xsd:complexType[1]/@name = 'SubmarineLaneSetType']">
        <xsd:element name="SubmarineLaneDateTimeOfStop">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DayTimeOnTarget'][ancestor::xsd:complexType[1]/@name = 'ShipTargetRequestSetType']">
        <xsd:element name="ShipTargetDayTimeOnTarget">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DayTimeOnTarget'][ancestor::xsd:complexType[1]/@name = 'TimeOfNuclearIncidentSetType']">
        <xsd:element name="NuclearIncidentDayTimeOnTarget">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DepartureLocation'][ancestor::xsd:complexType[1]/@name = 'AirMissionDetailsSetType']">
        <xsd:element name="AirMissionDepartureLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DepartureLocation'][ancestor::xsd:complexType[1]/@name = 'AircraftMissionSetType']">
        <xsd:element name="AircraftDepartureLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DepartureLocation'][ancestor::xsd:complexType[1]/@name = 'DeparturePlaceAndCargoDetailsSetType']">
        <xsd:element name="DepartureLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DepartureLocation'][ancestor::xsd:complexType[1]/@name = 'EventTaskingSetType']">
        <xsd:element name="EventTaskingDepartureLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DepartureLocation'][ancestor::xsd:complexType[1]/@name = 'MovementMissionSetType']">
        <xsd:element name="MovementDepartureLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DepartureLocation'][ancestor::xsd:complexType[1]/@name = 'SailingIntentionsSetType']">
        <xsd:element name="SailingDepartureLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DepartureLocation'][ancestor::xsd:complexType[1]/@name = 'ShipDepartureSetType']">
        <xsd:element name="ShipDepartureLocation">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>


    <!--EQUIVALENT REPLACE-->
    <xsl:template match="xsd:element[@name = 'AreaGeometry']">
        <xsd:element name="AreaGeometry">
            <xsd:annotation>
                <xsd:appinfo>
                    <Field positionName="AREA GEOMETRY"/>
                </xsd:appinfo>
            </xsd:annotation>
            <xsd:complexType>
                <xsd:choice>
                    <xsd:element ref="field:Radius">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="Radius"
                                    definition="The radius of the circle around the location being reported. The first element is a number representing the radius, in values from 0 to 999999. The second element is the linear dimension unit of measurement, allowing a choice of CM for centimeter, FT for feet, HM for hectometers, HF for hundreds of feet, IN for inches, KF for kilofeet, KM for kilometer, M for meter, MM for millimeter, NM for nautical miles, SM for statute miles, and YD for yards."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:EllipticalArea">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="EllipticalArea"
                                    definition="The dimensions and orientation which designate an elliptical area; example: 470NM750NM180.0. The first element is a number representing the length of the semi-major axis, in values from 0 to 99999 (0 to 4 decimal places permitted), and the linear dimension unit of measurement. The second element is a number representing the length of the semi-minor axis, in values from 0 to 99999 (0 to 4 decimal places permitted), and the linear dimension unit of measurement. The third element is the orientation, true, in degrees to the tenth, in values from 000.0 to 360.0."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:SectorGeometryWithOuterRange">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="SectorGeometryWithOuterRange"
                                    definition="The parameters to define the geometry of a sector of a circle bounded by two angles and an outer range; example: 180240T27NM. The 1st element is the start radii of a sector measured in degrees, in values from 000 to 359. The 2nd element is the stop radii of a sector measured in degrees, in values from 000 to 359. The 3rd element is the angular measurement reference, allowing a choice of G for grid north, M for magnetic north, R for relative, and T for true north. The 4th element is a number representing the outer range, in values from 0 to 999999, and a unit of linear measurement, allowing a choice of NM - nautical miles, M - meters, KM - kilometers, YD - yards, and HF - hundreds of feet."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:SectorGeometryWithInnerAndOuterRange">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="SectorGeometryWithInnerAndOuterRange"
                                    definition="The parameters to define the geometry of a sector of a circle bounded by two angles and an inner and outer range; example: 180240T27-100NM. The 1st element is the start radii of a sector measured in degrees, in values from 000 to 359. The 2nd element is the stop radii of a sector measured in degrees, in values from 000 to 359. The 3rd element is the angular measurement reference, allowing a choice of G, M, R, or T. The 4th element is a number representing the inner and outer range (separated by a hyphen), in values from 0 to 999999, and a unit of linear measurement, allowing a choice of NM, M, KM, YD, or HF."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsd:choice>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AircraftIdentification']">
        <xsd:element name="AircraftIdentification">
            <xsd:complexType>
                <xsd:choice>
                    <xsd:element ref="field:AircraftName">
                        <xsd:annotation>
                            <xsd:documentation>The identification of the aircraft.</xsd:documentation>
                            <xsd:appinfo>
                                <Field name="AircraftName" definition="THE RECOGNIZED NAME OF A TYPE OF AIRCRAFT." version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:AircraftTypeAndModel">
                        <xsd:annotation>
                            <xsd:documentation>The identification of the aircraft.</xsd:documentation>
                            <xsd:appinfo>
                                <Field name="AircraftTypeAndModel" definition="The type and/or model number an aircraft." version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsd:choice>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AircraftLocation']">
        <xsd:element name="AircraftLocation">
            <xsd:annotation>
                <xsd:documentation>The approximate location of an aircraft.</xsd:documentation>
                <xsd:appinfo>
                    <Field positionName="AIRCRAFT LOCATION"/>
                </xsd:appinfo>
            </xsd:annotation>
            <xsd:complexType>
                <xsd:choice>
                    <xsd:element ref="field:LatitudeAndLongitudeMinutes04DecimalPlaces">
                        <xsd:annotation>
                            <xsd:documentation>The approximate location of the reporting aircraft.</xsd:documentation>
                            <xsd:appinfo>
                                <Field name="LatitudeAndLongitudeMinutes04DecimalPlaces"
                                    definition="The intersecting lines of latitude and longitude which determine the geographical position of any place on the earth's surface, expressed in floating point minutes."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:MgrsUtm1Meter">
                        <xsd:annotation>
                            <xsd:documentation>The approximate location of the reporting aircraft.</xsd:documentation>
                            <xsd:appinfo>
                                <Field name="MilitaryGridReferenceSystemUtmMgrsUtm"
                                    definition="The Military Grid Reference System (MGRS) is an alpha-numeric system for expressing Universal Transverse Mercator (UTM). A single alpha-numeric value references a position that is unique for the entire earth. The components of MGRS values are as follows (example: 15SWC8081751205)."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsd:choice>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CaptureLocation']">
        <xsd:element name="CaptureLocation">
            <xsd:complexType>
                <xsd:choice>
                    <xsd:element ref="field:AreaName">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="AreaName"
                                    definition="THE GEOGRAPHIC NAME THAT IDENTIFIES A SPECIFIC AREA OR TERRAIN FEATURE IN TERMS OF THE AREA OR TERRAIN FEATURE ITSELF, OR THE NEAREST IDENTIFIABLE MAN-MADE OR NATURAL FEATURE."
                                    version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:GeographicLocationLatLongSeconds">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="GeographicLocationLatLongSeconds"
                                    definition="THE LOCATION OF A POINT ON THE EARTH'S SURFACE AS DEFINED BY THE INTERSECTION OF ANGULAR DISTANCES MEASURED NORTH AND SOUTH OF THE EQUATOR AND EAST AND WEST OF A SPECIFIED MERIDIAN."
                                    version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:LocationMgrsUtm10Meter">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="LocationMgrsUtm10Meter"
                                    definition="THE MILITARY GRID REFERENCE SYSTEM (MGRS) BASED ON THE UNIVERSAL TRANSVERSE MERCATOR (UTM) SYSTEM (MGRS-UTM), USED FOR LOCATING ANY POINT ON THE EARTH BETWEEN LATITUDE 80 DEGREES SOUTH AND 84 DEGREES NORTH, WHICH CORRESPONDS TO 10-METER PRECISION."
                                    version="B.1.01.01"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:GeographicLocationLatLongMinutes">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="GeographicLocationLatLongMinutes"
                                    definition="THE DESIGNATION OF THE INTERSECTING LINES OF LATITUDE AND LONGITUDE WHICH DETERMINE THE GEOGRAPHICAL POSITION OF ANY PLACE ON THE EARTH'S SURFACE, EXPRESSED TO THE NEAREST MINUTE."
                                    version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:LocationMgrsUtm100Meter">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="LocationMgrsUtm100Meter"
                                    definition="THE MILITARY GRID REFERENCE SYSTEM (MGRS) BASED ON THE UNIVERSAL TRANSVERSE MERCATOR (UTM) SYSTEM (MGRS-UTM), USED FOR LOCATING ANY POINT ON THE EARTH BETWEEN LATITUDE 80 DEGREES SOUTH AND 84 DEGREES NORTH, WHICH CORRESPONDS TO 100-METER PRECISION."
                                    version="B.1.01.01"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsd:choice>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'CommunicationsMeansParameters']">
        <xsd:element name="CommunicationsMeansParameters">
            <xsd:complexType>
                <xsd:choice>
                    <xsd:element ref="field:NonsecureTelephoneNumber">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="Number" definition="AN IDENTIFIER OF AN ENTITY, COMMONLY CONSIDERED TO BE OR REFERRED TO AS A 'NUMBER.'" version="B.1.01.01"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:SecureTelephoneNumber">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="Number" definition="AN IDENTIFIER OF AN ENTITY, COMMONLY CONSIDERED TO BE OR REFERRED TO AS A 'NUMBER.'" version="B.1.01.01"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:SpecificRadioFrequency">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="SpecificRadioFrequency"
                                    definition="The frequency at which electromagnetic radiation of energy is possible; example: 255.55MHZ. The first element is a number representing the Frequency, in values from 0 to 99999999999 (0 to 10 decimal places allowed). The second element is the Radio Frequency Unit of Measurement, with a choice of GHZ for Gigahertz, HZ for Hertz, KHZ for Kilohertz, or MHZ for Megahertz."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:FrequencyDesignator">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="FrequencyDesignator" definition="A designator usually employed in nonsecure communications to refer to a radio frequency." version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:FrequencyNumericAndMode">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="FrequencyNumericAndMode"
                                    definition="The frequency value for radio transmission and an indicator of the frequency mode; example: A999.9. The first element is a single alphabetic code for frequency mode, allowing a choice of A for High Frequency Transmission in Kilohertz, AM; L for High Frequency Transmission in Kilohertz, Lower Sideband; U for High Frequency Transmission in Kilohertz, Upper Sideband; and T for Tropospheric Transmission in Gigahertz. The second element is a 1 to 7 digit frequency, in values from 0 to 9999999 (0 to 6 decimal places allowed)."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:ElectronicMailAddress">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="ElectronicMailAddress" definition="THE IDENTIFIER USED BY SENDERS AND RECIPIENTS OF ELECTRONIC MAIL (E-MAIL) OVER COMPUTER NETWORKS." version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:SecureElectronicMailAddress">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="ElectronicMailAddress" definition="THE IDENTIFIER USED BY SENDERS AND RECIPIENTS OF ELECTRONIC MAIL (E-MAIL) OVER COMPUTER NETWORKS." version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:NonSecureFacsimileFaxNumber">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="Number" definition="AN IDENTIFIER OF AN ENTITY, COMMONLY CONSIDERED TO BE OR REFERRED TO AS A 'NUMBER.'" version="B.1.01.01"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:SecureFacsimileFaxNumber">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="Number" definition="AN IDENTIFIER OF AN ENTITY, COMMONLY CONSIDERED TO BE OR REFERRED TO AS A 'NUMBER.'" version="B.1.01.01"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:ChatRoom">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="Chat" definition="THE ITEMS ASSOCIATED WITH CHAT ROOMS THAT WILL BE EMPLOYED TO SUPPORT TACTICAL AND OPERATIONAL OBJECTIVES." version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsd:choice>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'AltimeterSetting']">
        <xsd:element name="AltimeterSetting">
            <xsd:annotation>
                <xsd:documentation>The altimeter setting in hundredths of inches of mercury or millibars.</xsd:documentation>
                <xsd:appinfo>
                    <Field positionName="ALTIMETER SETTING"/>
                </xsd:appinfo>
            </xsd:annotation>
            <xsd:complexType>
                <xsd:choice>
                    <xsd:element ref="field:AltimeterSettingInHundredthsOfInchesOfMercury">
                        <xsd:annotation>
                            <xsd:documentation>The altimeter setting in hundredths of inches of mercury or millibars.</xsd:documentation>
                            <xsd:appinfo>
                                <Field name="PressureInformation" definition="A PRESSURE MEASURED IN HUNDREDTHS OF INCHES OF MERCURY, MILLIBARS, OR HECTOPASCALS." version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:AltimeterSettingInMillibars">
                        <xsd:annotation>
                            <xsd:documentation>The altimeter setting in hundredths of inches of mercury or millibars.</xsd:documentation>
                            <xsd:appinfo>
                                <Field name="PressureInformation" definition="A PRESSURE MEASURED IN HUNDREDTHS OF INCHES OF MERCURY, MILLIBARS, OR HECTOPASCALS." version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:AltimeterSettingInHectopascals">
                        <xsd:annotation>
                            <xsd:documentation>The altimeter setting in hundredths of inches of mercury or millibars.</xsd:documentation>
                            <xsd:appinfo>
                                <Field name="PressureInformation" definition="A PRESSURE MEASURED IN HUNDREDTHS OF INCHES OF MERCURY, MILLIBARS, OR HECTOPASCALS." version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsd:choice>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'ContaminationDoseDoseRateDosageAndHazard']">
        <xsd:element name="ContaminationDoseDoseRateDosageAndHazard">
            <xsd:complexType>
                <xsd:choice>
                    <xsd:element ref="field:LevelOfHazard">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="LevelOfHazard"
                                    definition="An indicator for type and level of hazard, expressed by a percentage of incapacitating or lethal dose/dosage. 1st element: Type of Hazard. An indication of whether the hazard is lethal or incapacitating, expressed as a dose or a dosage. Allowable values: ICT for INCAPACITATING DOSAGE, ID for INCAPACITATING DOSE, LCT for LETHAL DOSAGE, LD for LETHAL DOSE. 2nd element: A quantity in the range 1 through 99."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:LevelOfContaminationAndUnitOfMeasurement">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="LevelOfContaminationAndUnitOfMeasurement"
                                    definition="The level of contamination and the unit of measurement. 1st element: A quantity in the range .000001 through 10000000, or any combination of six or fewer digits and a significant decimal point. There is an 8-character maximum. Allowable values: .000001 through 10000000. 2nd element: Unit of contamination. Allowable values: ACPL for Agent Containing Particles Per Liter, BQM3 for Becquerel Per Cubic Meter, BQM2 for Becquerel Per Square Meter, CFUML for Colony Forming Units Per Millimeter, CFUM2 for Colony Forming Units Per Square Meter, MGM3 for Milligrams Per Cubic Meter, MGM2 for Milligrams Per Square Meter, PPB for Parts Per Billion, PPM for Parts Per Million."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:LevelOfDoseAndUnitOfMeasurement">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="LevelOfDoseAndUnitOfMeasurement"
                                    definition="The quantity of dose and the unit of measurement. 1st element: A quantity in the range .000001 through 10000000, or any combination of six or fewer digits and a significant decimal point. There is an 8-character maximum. Allowable values: .000001 through 10000000. 2nd element: Unit of dose. Allowable values: CGY for Centigray, CSV for Centisievert, UGKP for Microgram Per 70 KG Person, UGY for Microgray, USV for Microsievert, MPK for Milligram Per 70 KG Person, MGY for Milligray, MSV for Millisievert, NOO for Number Of Micro-Organisms."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:LevelOfDoseRateDosageAndUnitOfMeasurement">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="LevelOfDoseRateDosageAndUnitOfMeasurement"
                                    definition="The quantity of dose rate/dosage and the unit of measurement. 1st element: A quantity in the range .000001 through 10000000, or any combination of six or fewer digits and a significant decimal point. There is an 8-character maximum. Allowable values: .000001 through 10000000. 2nd element: Unit of Dose Rate/Dosage. Allowable values: CGH for Centigray Per Hour, CSH for Centisievert Per Hour, MGH for Milligray Per Hour, MM3 for Milligram-Minutes Per Cubic Meter, MSH for Millisievert Per Hour, UGH for Microgray Per Hour, USH for Microsievert Per Hour."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:AffirmativeOrNegativeIndicator">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="AffirmativeOrNegativeIndicator"
                                    definition="AN INDICATOR OF AN AFFIRMATIVE OR A NEGATIVE CONDITION."
                                    version="B.1.01.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsd:choice>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'DateAndOrTimeOfReference']">
        <xsd:element name="DateAndOrTimeOfReference">
            <xsd:complexType>
                <xsd:choice>
                    <xsd:element ref="field:DateTimeGroup">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="DateTimeGroup"
                                    definition="A date-time group (DTG) of six digits with a time zone suffix and the standardized abbreviation for the month and a 4-digit year; example: 141325ZFEB2009. The first pair of the six digits represents the day; the second pair the hour; the third pair the minutes. The time zone suffix can be one of 35 time zones, to include 10 half-hour increment time zones based upon the local standard time, Greenwich, England (UTC)."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:DateDdmmmyyyy">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="DateDdmmmyyy"
                                    definition="A point in time expressed as day, month, year, as defined by the Gregorian Calendar; example: 01JAN2014. The first element is a number representing the day, in values from 01 to 31. The second element is the 3-character abbreviated month name, allowing a choice of JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC. The third element is the 4-digit year, in values from 0000 to 9999."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:DateTimeIso">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="InternationalStandardDateAndTime"
                                    definition="A designation of a specified chronological point measured using Coordinated Universal Time (UTC) ISO 8601 as a standard of reference; example: 20090214T132530Z. This is expressed using a compacted ISO notation YYYYMMDDTHHMMSSZ where YYYY represents a year, MM represents a month in values from 01 to 12, DD represents a day in values from 01 to 31, character T is the time delimiter, HH represents an hour from 00 to 23, MM represents a minute from 00 to 59, SS represents the seconds from 00 to 59, and Z represents the time zone."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:element ref="field:AlphamonthYear">
                        <xsd:annotation>
                            <xsd:appinfo>
                                <Field name="AlphamonthYear"
                                    definition="A point in time expressed as month and year, as defined by the Gregorian Calendar; example: JAN2014. The first element is the 3-character abbreviated month name, allowing a choice of JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC. The second element is the 4-digit year, in values from 0000 to 9999."
                                    version="B.1.02.00"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsd:choice>
            </xsd:complexType>
        </xsd:element>
    </xsl:template>

</xsl:stylesheet>
