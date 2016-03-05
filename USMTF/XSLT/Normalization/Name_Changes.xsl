<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd"
    version="2.0">
    <!--NAME CHANGES-->
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

<!--DUPLICATES-->
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
    
    <xsl:template match="xsd:element[@name = 'ActualArrivalDayTime'][not(@type)]"/>

</xsl:stylesheet>
