<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="fields_xsd" select="document('../../XSD/Baseline_Schemas/fields.xsd')"/>
    <xsl:variable name="normalizedsimpletypes"
        select="document('../Fields/NormalizedSimpleTypes.xsd')"/>

    <xsl:variable name="nfields" select="'Normalized_Fields.xsd'"/>

    <xsl:variable name="string_types">
        <xsl:apply-templates
            select="$normalizedsimpletypes/*/*[xsd:restriction[@base = 'xsd:string']][not(xsd:restriction/xsd:enumeration)]"
        />
    </xsl:variable>

    <xsl:variable name="enumeraton_types">
        <xsl:apply-templates select="$normalizedsimpletypes/*/*[xsd:restriction/xsd:enumeration]"/>
    </xsl:variable>

    <xsl:variable name="integer_types">
        <xsl:apply-templates
            select="$normalizedsimpletypes/*/*[xsd:restriction[@base = 'xsd:integer']]"/>
    </xsl:variable>

    <xsl:variable name="decimal_types">
        <xsl:apply-templates
            select="$normalizedsimpletypes/*/*[xsd:restriction[@base = 'xsd:decimal']]"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="{$nfields}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:fields" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsl:comment>**** STRING SIMPLE TYPES ****</xsl:comment>
                <xsl:copy-of select="$string_types"/>
                <xsl:comment>**** ENUMERATION SIMPLE TYPES ****</xsl:comment>
                <xsl:copy-of select="$enumeraton_types"/>
                <xsl:comment>**** INTEGER SIMPLE TYPES ****</xsl:comment>
                <xsl:copy-of select="$integer_types"/>
                <xsl:comment>**** DECIMAL SIMPLE TYPES ****</xsl:comment>
                <xsl:copy-of select="$decimal_types"/>
                <xsl:comment>**** STRING ELEMENTS ****</xsl:comment>
                <xsl:apply-templates
                    select="$fields_xsd/*/*[xsd:restriction[@base = 'xsd:string']][not(xsd:restriction/xsd:enumeration)]"
                    mode="str">
                    <xsl:sort select="@name"/>
                </xsl:apply-templates>
                <xsl:comment>**** ENUMERATION ELEMENTS ****</xsl:comment>
                <xsl:apply-templates
                    select="$fields_xsd/*/*[xsd:restriction[@base = 'xsd:string']][xsd:restriction/xsd:enumeration]"
                    mode="enum">
                    <xsl:sort select="@name"/>
                </xsl:apply-templates>
                <xsl:comment>**** INTEGER ELEMENTS ****</xsl:comment>
                <xsl:apply-templates
                    select="$fields_xsd/*/*[xsd:restriction[@base = 'xsd:integer']]"
                    mode="int">
                    <xsl:sort select="@name"/>
                </xsl:apply-templates>
                <xsl:comment>**** DECIMAL ELEMENTS ****</xsl:comment>
                <xsl:apply-templates
                    select="$fields_xsd/*/*[xsd:restriction[@base = 'xsd:decimal']]"
                    mode="dec">
                    <xsl:sort select="@name"/>
                </xsl:apply-templates>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>
    <!-- _____________________________________________________ -->
    <!-- _______________ String Simple Types _________________ -->
    <xsl:template match="xsd:simpleType" mode="str">
        <!--Compare REGEX to create Elements using normalized SimpleTypes-->
        <xsl:variable name="pattern" select="xsd:restriction/xsd:pattern/@value"/>
        <!--Extract Pattern Value from RegEx without max and min -->
        <xsl:variable name="patternvalue">
            <xsl:call-template name="patternValue">
                <xsl:with-param name="pattern">
                    <xsl:value-of select="$pattern"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="type">
            <xsl:choose>
                <!--If there is is a match - use it-->
                <xsl:when
                    test="$normalizedsimpletypes/xsd:schema/xsd:simpleType/xsd:restriction/xsd:pattern/@value = $patternvalue">
                    <xsl:value-of
                        select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[xsd:restriction/xsd:pattern/@value = $patternvalue]/@name"
                    />
                </xsl:when>
                <!--If there is is NO match - try non-stripped pattern-->
                <xsl:otherwise>
                    <xsl:value-of
                        select="$normalizedsimpletypes/*/*[xsd:restriction/xsd:pattern/@value = $pattern]/@name"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="xsd:element">
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="ends-with(@name, 'SimpleType')">
                        <xsl:value-of select="substring(@name, 0, string-length(@name) - 9)"/>
                    </xsl:when>
                    <xsl:when test="ends-with(@name, 'Type')">
                        <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="xsd:annotation"/>
            <xsd:simpleType>
                <xsl:choose>
                    <xsl:when test="string-length($type) > 0">
                        <xsd:restriction base="{$type}">
                            <xsl:apply-templates select="xsd:restriction/*"/>
                        </xsd:restriction>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsd:restriction
                            base="{concat(substring(@name,0,string-length(@name)-3),'SimpleType')}">
                            <xsl:apply-templates select="xsd:restriction/*"/>
                        </xsd:restriction>
                    </xsl:otherwise>
                </xsl:choose>
            </xsd:simpleType>
        </xsl:element>
    </xsl:template>

    <!--Call patternValue template to remove min and max length qualifiers in RegEx
    for matching and output-->
    <xsl:template match="xsd:pattern">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="value">
                <xsl:call-template name="patternValue">
                    <xsl:with-param name="pattern" select="@value"/>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>

    <!--Remove min and max length qualifiers in RegEx for matching with normalized types-->
    <xsl:template name="patternValue">
        <xsl:param name="pattern"/>
        <!--TEST FOR MIN MAX IN REGEX-->
        <xsl:choose>
            <!--If Ends with max min strip off-->
            <xsl:when
                test="$normalizedsimpletypes/xsd:schema/xsd:simpleType/xsd:restriction[@base = 'xsd:string'][not(xsd:enumeraton)]/xsd:pattern/@value = $pattern">
                <xsl:value-of select="$pattern"/>
            </xsl:when>
            <xsl:when test="ends-with($pattern, '}')">
                <xsl:choose>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 6), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 6)"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 5), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 5)"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 4), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 4)"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 3), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 3)"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with(substring($pattern, string-length($pattern) - 2), '{')">
                        <xsl:value-of select="substring($pattern, 0, string-length($pattern) - 2)"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$pattern"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- _______________________________________________________ -->
    <!-- _______________ Enumeration Simple Types ______________ -->
    <xsl:template match="xsd:simpleType" mode="enum">
        <xsl:variable name="restriction">
            <xsl:apply-templates select="xsd:restriction"/>
        </xsl:variable>
        <xsl:variable name="nm">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:variable name="type">
            <xsl:value-of
                select="$enumeraton_types/xsd:simpleType[deep-equal(xsd:restriction, $restriction)]/@name"
            />
        </xsl:variable>
        <xsl:element name="xsd:element">
            <xsl:attribute name="name">
                <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
                <!--<xsl:choose>
                    <xsl:when test="ends-with(@name, 'SimpleType')">
                        <xsl:value-of select="substring(@name, 0, string-length(@name) - 9)"/>
                    </xsl:when>
                    <xsl:when test="ends-with(@name, 'Type')">
                        <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
                    </xsl:when>
                </xsl:choose>-->
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="string-length($type) > 0">
                    <xsl:attribute name="type">
                        <xsl:value-of select="$type"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:when>
                <xsl:when test="$enumeraton_types/xsd:simpleType/@name = $nm">
                    <xsl:attribute name="type">
                        <xsl:value-of select="@name"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsd:simpleType>
                        <xsl:apply-templates select="xsd:annotation"/>
                        <xsd:restriction base="{concat(substring(@name,0,string-length(@name)-3),'SimpleType')}">
                            <xsl:apply-templates select="xsd:restriction/*"/>
                        </xsd:restriction>
                    </xsd:simpleType>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <!-- _______________________________________________________ -->
    <!-- _______________________________________________________ -->
    <!-- _______________ Integer Simple Types ______________ -->
    <xsl:template match="xsd:simpleType" mode="int">
        <xsl:variable name="nm">
            <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
        </xsl:variable>
        <xsl:variable name="min" select="xsd:restriction/xsd:minInclusive/@value"/>
        <xsl:variable name="max" select="xsd:restriction/xsd:maxInclusive/@value"/>
        <xsl:variable name="normtype">
            <xsl:call-template name="IntegerType">
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

    <xsl:template name="IntegerType">
        <xsl:param name="pattern"/>
        <xsl:choose>
            <xsl:when test="ends-with($pattern, '{1,1}')">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'IntOneSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{2,2}')">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'IntTwoSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{3,3}')">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'IntThreeSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{4,4}')">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'IntFourSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{5,5}')">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'IntFiveSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{6,6}')">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'IntSixSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{7,7}')">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'IntSevenSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{8,8}')">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'IntEightSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{9,9}')">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'IntNineSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{10,10}')">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'IntTenSimpleType']"
                />
            </xsl:when>
            <xsl:when test="ends-with($pattern, '{15,15}')">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'IntFifteenSimpleType']"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'IntSimpleType']"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- _______________________________________________________ -->
    <!-- _______________ Decimal Simple Types ______________ -->
    <xsl:template match="xsd:simpleType" mode="dec">
        <xsl:variable name="nm">
            <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
        </xsl:variable>
        <xsl:variable name="mx" select="xsd:restriction/xsd:maxInclusive/@value"/>
        <xsl:variable name="mxdec" select="number(xsd:restriction//*:MaximumDecimalPlaces/text())"/>
        <xsl:variable name="normdectype">
            <xsl:call-template name="DecimalType">
                <xsl:with-param name="max" select="$mxdec"/>
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
                        <xsl:value-of select="$normdectype/xsd:simpleType/@name"/>
                    </xsl:attribute>
                    <xsl:copy-of select="xsd:restriction/xsd:minInclusive"/>
                    <xsl:copy-of select="xsd:restriction/xsd:maxInclusive"/>
                    <xsl:element name="xsd:totalDigits">
                        <xsl:attribute name="value">
                            <xsl:choose>
                                <xsl:when test="contains($mx, '.')">
                                    <xsl:value-of
                                        select="string-length(substring-before($mx, '.')) + $mxdec"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="string-length($mx) + $mxdec"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsd:simpleType>
        </xsl:element>
    </xsl:template>

    <xsl:template name="DecimalType">
        <xsl:param name="max"/>
        <xsl:choose>
            <xsl:when test="$max = 1">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'DecimalOneSimpleType']"
                />
            </xsl:when>
            <xsl:when test="$max = 2">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'DecimalTwoSimpleType']"
                />
            </xsl:when>
            <xsl:when test="$max = 3">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'DecimalThreeSimpleType']"
                />
            </xsl:when>
            <xsl:when test="$max = 4">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'DecimalFourSimpleType']"
                />
            </xsl:when>
            <xsl:when test="$max = 5">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'DecimalFiveSimpleType']"
                />
            </xsl:when>
            <xsl:when test="$max = 6">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'DecimalSixSimpleType']"
                />
            </xsl:when>
            <xsl:when test="$max = 7">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'DecimalSevenSimpleType']"
                />
            </xsl:when>
            <xsl:when test="$max = 8">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'DecimalEightSimpleType']"
                />
            </xsl:when>
            <xsl:when test="$max = 9">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'DecimalNineSimpleType']"
                />
            </xsl:when>
            <xsl:when test="$max = 10">
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'DecimalTenSimpleType']"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of
                    select="$normalizedsimpletypes/xsd:schema/xsd:simpleType[@name = 'DecimalSimpleType']"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:enumeration">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="text()"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*">
        <xsl:element name="{name()}" namespace="urn:mtf:mil:6040b:fields">
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
    <!--<xsl:template match="*:Explanation"/>-->
    <xsl:template match="*:MinimumInclusiveValue"/>
    <xsl:template match="*:MaximumInclusiveValue"/>
    <xsl:template match="*:LengthVariable"/>
    <xsl:template match="*:DataItemSponsor"/>
    <xsl:template match="*:DataItemSequenceNumber"/>
</xsl:stylesheet>
