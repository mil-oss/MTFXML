<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="fields_xsd" select="document('../../XSD/Baseline_Schemas/fields.xsd')"/>
    <xsl:variable name="normSimpleTypes" select="document('../Fields/NormalizedSimpleTypes.xsd')"/>
    <xsl:variable name="decimals" select="'Decimals.xsd'"/>

    <xsl:variable name="decimal_types">
        <xsl:apply-templates
            select="$fields_xsd/*/xsd:simpleType[xsd:restriction[@base = 'xsd:decimal']]"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="{$decimals}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:fields" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <!--<xsl:for-each select="$normSimpleTypes/*/*[xsd:restriction[@base = 'xsd:integer']]">
                    <xsl:copy-of select="."/>
                </xsl:for-each>-->
                <xsl:for-each select="$decimal_types/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                    <!--<xsl:apply-templates select="." mode="int"/>-->
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xsd:simpleType" mode="int">
        <xsl:variable name="nm">
            <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
        </xsl:variable>
        <xsl:variable name="min" select="xsd:restriction/xsd:minInclusive/@value"/>
        <xsl:variable name="max" select="xsd:restriction/xsd:maxInclusive/@value"/>
        <xsl:variable name="normtype">
            <xsl:call-template name="NormType">
                <xsl:with-param name="pattern" select="xsd:restriction/xsd:pattern/@value"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ann">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:element name="xsd:element">
            <xsl:attribute name="name">
                <xsl:value-of select="$nm"/>
            </xsl:attribute>
            <xsl:copy-of select="$ann"/>
            <xsd:simpleType>
                <xsl:element name="xsd:restriction">
                    <xsl:attribute name="base">
                        <xsl:value-of select="$normtype/xsd:simpleType/@name"/>
                    </xsl:attribute>
                    <xsl:if
                        test="not($normtype/xsd:simpleType/xsd:restriction/xsd:minInclusive/@value = $min)">
                        <xsl:copy-of select="xsd:restriction/xsd:minInclusive"/>
                    </xsl:if>
                    <xsl:if
                        test="not($normtype/xsd:simpleType/xsd:restriction/xsd:minInclusive/@value = $max)">
                        <xsl:copy-of select="xsd:restriction/xsd:maxInclusive"/>
                    </xsl:if>
                    <xsl:copy-of select="xsd:restriction/xsd:pattern" copy-namespaces="no"/>
                </xsl:element>
            </xsd:simpleType>
        </xsl:element>
    </xsl:template>

    <xsl:template name="NormType">
        <xsl:param name="pattern"/>
        <xsl:choose>
            <xsl:when test="ends-with($pattern, '{1,1}')">
                <xsl:copy-of
                    select="$normSimpleTypes/xsd:schema/xsd:simpleType[@name = 'IntOneSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{2,2}')">
                <xsl:copy-of
                    select="$normSimpleTypes/xsd:schema/xsd:simpleType[@name = 'IntTwoSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{3,3}')">
                <xsl:copy-of
                    select="$normSimpleTypes/xsd:schema/xsd:simpleType[@name = 'IntThreeSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{4,4}')">
                <xsl:copy-of
                    select="$normSimpleTypes/xsd:schema/xsd:simpleType[@name = 'IntFourSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{5,5}')">
                <xsl:copy-of
                    select="$normSimpleTypes/xsd:schema/xsd:simpleType[@name = 'IntFiveSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{6,6}')">
                <xsl:copy-of
                    select="$normSimpleTypes/xsd:schema/xsd:simpleType[@name = 'IntSixSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{7,7}')">
                <xsl:copy-of
                    select="$normSimpleTypes/xsd:schema/xsd:simpleType[@name = 'IntSevenSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{8,8}')">
                <xsl:copy-of
                    select="$normSimpleTypes/xsd:schema/xsd:simpleType[@name = 'IntEightSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{9,9}')">
                <xsl:copy-of
                    select="$normSimpleTypes/xsd:schema/xsd:simpleType[@name = 'IntNineSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{10,10}')">
                <xsl:copy-of
                    select="$normSimpleTypes/xsd:schema/xsd:simpleType[@name = 'IntTenSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{15,15}')">
                <xsl:copy-of
                    select="$normSimpleTypes/xsd:schema/xsd:simpleType[@name = 'IntFifteenSimpleType']"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of
                    select="$normSimpleTypes/xsd:schema/xsd:simpleType[@name = 'IntSimpleType']"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:copy-of select="normalize-space(.)"/>
    </xsl:template>

    <!-- ******************** Decimal Types ******************** -->
    <!-- Update decimal type fields with fractionDigits and totalDigits attributes -->
    <xsl:template match="xsd:restriction[@base = 'xsd:decimal']">
        <xsl:variable name="minValue" select="xsd:minInclusive/@value"/>
        <xsl:variable name="maxValue" select="xsd:maxInclusive/@value"/>

        <xsl:variable name="maxDecimal">
            <xsl:call-template name="FindMaxDecimals">
                <xsl:with-param name="value1">
                    <xsl:value-of select="$minValue"/>
                </xsl:with-param>
                <xsl:with-param name="value2">
                    <xsl:value-of select="$maxValue"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="totalDigitCount">
            <xsl:call-template name="FindTotalDigitCount">
                <xsl:with-param name="value1">
                    <xsl:value-of select="$minValue"/>
                </xsl:with-param>
                <xsl:with-param name="value2">
                    <xsl:value-of select="$maxValue"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:restriction[@base = 'xsd:decimal']/xsd:length">
        <xsl:variable name="MinimumLength"
            select="parent::xsd:restriction/parent::xsd:simpleType/xsd:annotation/xsd:appinfo/*/@MinimumLength"/>
        <xsl:variable name="MaximumLength"
            select="parent::xsd:restriction/parent::xsd:simpleType/xsd:annotation/xsd:appinfo/*/@MaximumLength"/>
        <xsl:variable name="length" select="parent::xsd:restriction/xsd:length/@value"/>
        <xsl:call-template name="SetRestrictionFields">
            <xsl:with-param name="MinLen1">
                <xsl:value-of select="$MinimumLength"/>
            </xsl:with-param>
            <xsl:with-param name="MaxLen1">
                <xsl:value-of select="$MaximumLength"/>
            </xsl:with-param>
            <xsl:with-param name="Len">
                <xsl:value-of select="$length"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Determine how many placeholders are represented in the decimal value -->
    <xsl:template name="FindMaxDecimals">
        <xsl:param name="value1"/>
        <xsl:param name="value2"/>
        <xsl:choose>
            <xsl:when test="contains($value1, '.') and contains($value2, '.')">
                <xsl:if
                    test="
                        (string-length(substring-after($value1, '.')) >
                        string-length(substring-after($value2, '.')))">
                    <xsl:value-of select="string-length(substring-after($value1, '.'))"/>
                </xsl:if>
                <xsl:if
                    test="
                        (string-length(substring-after($value1, '.')) &lt;
                        string-length(substring-after($value2, '.')))">
                    <xsl:value-of select="string-length(substring-after($value2, '.'))"/>
                </xsl:if>
                <xsl:if
                    test="
                        (string-length(substring-after($value1, '.')) =
                        string-length(substring-after($value2, '.')))">
                    <xsl:value-of select="string-length(substring-after($value1, '.'))"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="contains($value1, '.')">
                <xsl:value-of select="string-length(substring-after($value1, '.'))"/>
            </xsl:when>
            <xsl:when test="contains($value2, '.')">
                <xsl:value-of select="string-length(substring-after($value2, '.'))"/>
            </xsl:when>
            <xsl:when test="(not(contains($value1, '.')) and not(contains($value2, '.')))">
                <xsl:if test="string-length($value1) > string-length($value2)">
                    <xsl:value-of select="string-length(substring-after($value1, '.'))"/>
                </xsl:if>
                <xsl:if test="string-length($value1) &lt; string-length($value2)">
                    <xsl:value-of select="string-length(substring-after($value2, '.'))"/>
                </xsl:if>
                <xsl:if test="string-length($value2) = string-length($value1)">
                    <xsl:value-of select="string-length(substring-after($value1, '.'))"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'Error'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Determine how many digits are represented in the decimal value -->
    <xsl:template name="FindTotalDigitCount">
        <xsl:param name="value1"/>
        <xsl:param name="value2"/>
        <xsl:variable name="value1nodecimal">
            <xsl:choose>
                <xsl:when test="contains($value1, '.') and contains($value1, '-')">
                    <xsl:value-of
                        select="substring-after(concat(substring-before($value1, '.'), substring-after($value1, '.')), '-')"
                    />
                </xsl:when>
                <xsl:when test="contains($value1, '.')">
                    <xsl:value-of
                        select="concat(substring-before($value1, '.'), substring-after($value1, '.'))"
                    />
                </xsl:when>
                <xsl:when test="contains($value1, '-')">
                    <xsl:value-of select="substring-after($value1, '-')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$value1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="value2nodecimal">
            <xsl:choose>
                <xsl:when test="contains($value2, '.') and contains($value2, '-')">
                    <xsl:value-of
                        select="substring-after(concat(substring-before($value2, '.'), substring-after($value2, '.')), '-')"
                    />
                </xsl:when>
                <xsl:when test="contains($value2, '.')">
                    <xsl:value-of
                        select="concat(substring-before($value2, '.'), substring-after($value2, '.'))"
                    />
                </xsl:when>
                <xsl:when test="contains($value2, '-')">
                    <xsl:value-of select="substring-after($value2, '-')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$value2"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string-length($value1nodecimal) > string-length($value2nodecimal)">
                <xsl:value-of select="string-length($value1nodecimal)"/>
            </xsl:when>
            <xsl:when test="string-length($value1nodecimal) &lt; string-length($value2nodecimal)">
                <xsl:value-of select="string-length($value2nodecimal)"/>
            </xsl:when>
            <xsl:when test="string-length($value1nodecimal) = string-length($value2nodecimal)">
                <xsl:value-of select="string-length($value1nodecimal)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'Error'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Set the value of the remaining restricted fields -->
    <xsl:template name="SetRestrictionFields">
        <xsl:param name="MinLen1"/>
        <!-- MinimumLength -->
        <xsl:param name="MaxLen1"/>
        <!-- MaximumLength -->
        <xsl:param name="Len"/>
        <!-- length -->
        <xsd:minLength>
            <xsl:attribute name="value">
                <xsl:choose>
                    <xsl:when test="(number($MinLen1) > 0)">
                        <xsl:value-of select="$MinLen1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$Len"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsd:minLength>
        <xsd:maxLength>
            <xsl:attribute name="value">
                <xsl:choose>
                    <xsl:when test="(number($MaxLen1) > 0)">
                        <xsl:value-of select="$MaxLen1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number($Len)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsd:maxLength>
    </xsl:template>

    <!-- _______________________________________________________ -->


    <!--Convert elements in xsd:appinfo to attributes-->
    <xsl:template match="*" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt = ' ') and not(*) and not($txt = '')">
            <xsl:attribute name="{name()}">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>


    <xsl:template match="*:FudName">
        <Field name="{text()}"/>
    </xsl:template>
    <xsl:template match="*:FudExplanation"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber"/>
    <xsl:template match="*:FudNumber"/>
    <xsl:template match="*:VersionIndicator"/>
    <xsl:template match="*:MinimumLength"/>
    <xsl:template match="*:MaximumLength"/>
    <xsl:template match="*:LengthLimitation"/>
    <xsl:template match="*:UnitOfMeasure"/>
    <xsl:template match="*:Type"/>
    <xsl:template match="*:FudSponsor"/>
    <xsl:template match="*:FudRelatedDocument"/>
    <xsl:template match="*:DataType"/>
    <xsl:template match="*:EntryType"/>
    <xsl:template match="*:Explanation"/>
    <xsl:template match="*:MinimumInclusiveValue"/>
    <xsl:template match="*:MaximumInclusiveValue"/>
    <xsl:template match="*:LengthVariable"/>
</xsl:stylesheet>
