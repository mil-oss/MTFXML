<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
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
                    <Field name="GeopoliticalEntities" definition="A region controlled by a political community having an organized government and
                        possessing internal and external sovereignty, most often as a State but sometimes having a dependent relationship on another
                        political authority or a special sovereignty status." version="B.1.02.00"/>
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
    <xsl:template match="xsd:element[@name = 'TgtPriority'][@type ='field:PriorityType']">
        <xsd:element name="TgtPriorityCode">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'TrackNumberBlock'][@type ='field:Link1TrackNumberBlockType']">
        <xsd:element name="Link1TrackNumberBlock">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'SurfaceAirTemperature'][//@base = 'field:FieldIntegerBaseType']">
        <xsd:element name="SurfaceAirTemperatureValue">
            <xsd:annotation>
                <xsd:documentation>The surface air temperature based on units of temperature specified in the UNITM set.</xsd:documentation>
                <xsd:appinfo>
                    <Field positionName="SURFACE AIR TEMPERATURE" identifier="A" name="TemperatureMeasurement" definition="THE NUMERICAL COMPONENT OF
                        A TEMPERATURE MEASUREMENT." version="B.1.01.00"/>
                </xsd:appinfo>
            </xsd:annotation>
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
        <xsd:element name="Link22UnitNuAddress">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <xsl:template match="xsd:element[@name = 'FlashToBangTimeInSeconds'][not(@type)][//@base = 'field:FieldIntegerBaseType']">
        <xsd:element name="FlashToBangTimeInSecondsValue">
            <xsl:apply-templates select="@*[not(name() = 'name')]" mode="copy"/>
            <xsl:apply-templates select="*" mode="copy"/>
        </xsd:element>
    </xsl:template>
    <!--DUPLICATES-->
    <xsl:template match="xsd:element[@name = 'AircraftAirspeedInKnots'][not(@type)]">
        <xsd:element name="AircraftAirspeedInKnots">
            <xsd:annotation>
                <xsd:appinfo>
                    <Field name="ContextQuantity" definition="AN INTEGER QUANTITY (A NUMBER WITHOUT A SIGNIFICANT DECIMAL POINT) WHOSE MEANING IS
                        DETERMINED BY THE KEYWORD DATA SET OR CHAIN IN WHICH IT IS USED." version="B.1.01.00"/>
                </xsd:appinfo>
            </xsd:annotation>
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
            <xsd:annotation>
                <xsd:appinfo>
                    <Field name="MilitaryDayTime" definition="The day of a month and timekeeping in hours and minutes of a calendar day, using the
                        24-hour clock system and an associated time zone; example: 312359Z. The first element is a number representing the day, in
                        values from 01 to 31. Followed by hour, in values from 00 to 23. Followed by a single alphanumeric character representing one
                        of 35 time zones, to include 10 half-hour increment time zones based upon the local standard time, Greenwich, England (UTC)."
                        version="B.1.02.00"/>
                </xsd:appinfo>
            </xsd:annotation>
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
                <xsd:documentation>The Internet Protocol Version 6 (IPV6) address of the air support element. A 128-bit address scheme using eight
                    groups of four-digit hexadecimal integers (0-9, a-f) with colons used as delimiters. The use of the embedded colon is allowed as
                    an exception to the rules of USMTF.</xsd:documentation>
                <xsd:appinfo>
                    <Field positionName="IPV6 ADDRESS" identifier="A" name="InternetProtocolAddressIpv6" definition="The Internet Protocol Version 6
                        (IPV6) address. A 128-bit address scheme using eight groups of four-digit hexadecimal integers (0-9, a-f, A-F) with colons
                        used as delimiters. The use of the embedded colon is allowed as an exception to the rules of USMTF." remark="Example of an
                        IPV6 address: 3ffe:ffff:0100:f101:0210:a4ff:fee3:9566 CAN BE WRITTEN AS 3ffe:ffff:100:f101:210:a4ff:fee3:9566,
                        0000:0000:0000:0000:0000:0000:0000:0001 CAN BE WRITTEN AS ::1." version="B.1.01.00"/>
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
   
</xsl:stylesheet>
