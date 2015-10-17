<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2015 JD NEUSHUL
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <!--  This XSLT refactors baseline USMTF "fields" XML Schema by replacing annotation elements
    with attributes, removing unused elements and other adjustments-->
    <!--Fields from the baseline Composites XML Schema are also included as ComplexTypes in accordance with the intent to 
    consolidate fields and composites as global elements in the "Fields" XML Schema for the GoE refactor.
    type references are converted to local.-->
    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="mtf_fields_xsd" select="document('../../XSD/Baseline_Schemas/fields.xsd')"/>
    <xsl:variable name="mtf_composites_xsd"
        select="document('../../XSD/Baseline_Schemas/composites.xsd')"/>
    <xsl:variable name="outputdoc" select="'../../XSD/GoE_Schemas/GoE_fields.xsd'"/>

    <!--A normalized list of xsd:string types with common REGEX patterns for 
        re-use globally Length qualifiers for min and max are not used.-->
    <xsl:variable name="normalizedtypes" select="document('NormalizedSimpleTypes.xsd')"/>

    <!-- Contains a list of all xsd:simpleTypes in baseline format.-->
    <xsl:variable name="mtf_simpletypes">
        <xsl:for-each select="$mtf_fields_xsd/xsd:schema/xsd:simpleType">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
        <xsl:for-each select="$mtf_composites_xsd/xsd:schema/xsd:simpleType">
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>

    <!-- Contains a list of all baseline xsd:simpleTypes with xsd:string
        restrictions that have a REGEX pattern matching one in normalized types.
        The patternValue template is called to remove min and max qualifiers from 
        the original RegEx for matching.  This list has the NIEM naming 
        convention and is Used to create global xsd:element nodes which extend
        normalized types and include max min qualifiers.-->
    <xsl:variable name="niem_str_simpletypes">
        <xsl:for-each select="$mtf_simpletypes/xsd:simpleType[xsd:restriction/@base = 'xsd:string']">
            <xsl:variable name="pattern" select="xsd:restriction/xsd:pattern/@value"/>
            <xsl:variable name="patternvalue">
                <xsl:call-template name="patternValue">
                    <xsl:with-param name="pattern">
                        <xsl:value-of select="$pattern"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when
                    test="$normalizedtypes/xsd:schema/xsd:simpleType/xsd:restriction/xsd:pattern/@value = $patternvalue"/>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="niem"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="niem_simpletypes">
        <xsl:for-each
            select="$mtf_simpletypes/xsd:simpleType[not(xsd:restriction/@base = 'xsd:string')]">
            <xsl:apply-templates select="." mode="niem"/>
        </xsl:for-each>
    </xsl:variable>

    <!-- Contains a list of all baseline and normalized xsd:simpleTypes 
        to be included in result document with the NIEM xsd:{name}SimpleType 
        naming convention.-->
    <xsl:variable name="allsimpletypes">
        <xsl:for-each select="$normalizedtypes/xsd:schema/xsd:simpleType">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:apply-templates select="$niem_str_simpletypes/*" mode="global"/>
        <xsl:apply-templates select="$niem_simpletypes/*" mode="global"/>
    </xsl:variable>

    <!-- Contains a list of all xsd:complexTypes with the NIEM xsd:{name}Type
        naming convention and incorporating normalized xsd:simpleTypes for extensions.-->
    <xsl:variable name="complextypes">
        <xsl:apply-templates select="$mtf_fields_xsd/xsd:schema/xsd:complexType"/>
        <xsl:apply-templates select="$mtf_composites_xsd/xsd:schema/xsd:complexType"/>
    </xsl:variable>

    <!-- Contains a list of xsd:elements with normalized xsd:simpleTypes and 
        including xsd:maxLength and xsd:minLength extensions for xsd:simpleTypes 
        with base xsd:string-->
    <xsl:variable name="global_simple_elements">
        <xsl:apply-templates select="$mtf_simpletypes/*" mode="el">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsd:element name="BlankSpaceCharacter" type="BlankSpaceSimpleType"/>
    </xsl:variable>

    <!-- Contains a list of xsd:elements with normalized xsd:complexTypes and 
        including xsd:maxLength and xsd:minLength extensions for xsd:simpleTypes 
        with base xsd:string-->
    <xsl:variable name="global_complex_elements">
        <xsl:apply-templates select="$complextypes/*" mode="cmplxel"/>
    </xsl:variable>

    <!--    OUTPUT RESULT-->
    <xsl:template match="/">
        <xsl:result-document href="{$outputdoc}">
            <xsd:schema xmlns="urn:mtf:mil:6040b:goe:fields"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                targetNamespace="urn:mtf:mil:6040b:goe:fields" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsl:for-each select="$allsimpletypes/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$complextypes/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$global_simple_elements/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$global_complex_elements/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <!-- ******************** SIMPLE TYPES ******************** -->
    <!--Convert xsd:simpleType to NIME SImpleType naming convention-->
    <xsl:template match="xsd:simpleType" mode="niem">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="ends-with(@name, 'SimpleType')">
                        <xsl:value-of select="@name"/>
                    </xsl:when>
                    <xsl:when test="ends-with(@name, 'Type')">
                        <xsl:value-of
                            select="concat(substring(@name, 0, string-length(@name) - 3), 'SimpleType')"
                        />
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
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

    <!--Remove min and max length qualifiers in RegEx for matching with normaized types-->
    <xsl:template name="patternValue">
        <xsl:param name="pattern"/>
        <!--TEST FOR MIN MAX IN REGEX-->
        <xsl:choose>
            <!--If Ends with max min strip off-->
            <xsl:when
                test="$normalizedtypes/xsd:schema/xsd:simpleType/xsd:restriction/xsd:pattern/@value = $pattern">
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

    <!-- ******************** COMPLEX TYPES ******************** -->
    <!--Copy root level complexTypes-->
    <xsl:template match="xsd:complexType">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    <!-- _______________________________________________________ -->

    <!-- ******************** SIMPLE TYPE ELEMENTS ********************  -->

    <!--Create global xsd:element nodes for xsd:simpleTypes -->
    <xsl:template match="xsd:simpleType" mode="el">
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
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="ends-with(@name, 'SimpleType')">
                        <xsl:value-of select="@name"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="concat(substring(@name, 0, string-length(@name) - 3), 'SimpleType')"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <!--Compare REGEX to create Elements using normalized SimpleTypes-->
    <xsl:template match="xsd:simpleType[xsd:restriction[@base = 'xsd:string']/xsd:pattern]"
        mode="el">
        <xsl:variable name="pattern" select="xsd:restriction/xsd:pattern/@value"/>
        <!--TEST FOR MIN MAX IN REGEX-->
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
                    test="$normalizedtypes/xsd:schema/xsd:simpleType/xsd:restriction/xsd:pattern/@value = $patternvalue">
                    <xsl:value-of
                        select="$normalizedtypes/xsd:schema/xsd:simpleType[xsd:restriction/xsd:pattern/@value = $patternvalue]/@name"
                    />
                </xsl:when>
                <!--If there is is NO match - try non-stripped pattern-->
                <xsl:otherwise>
                    <xsl:value-of
                        select="$normalizedtypes/*/*[xsd:restriction/xsd:pattern/@value = $pattern]/@name"
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
                            <xsl:apply-templates select="xsd:restriction/*" mode="el"/>
                        </xsd:restriction>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsd:restriction
                            base="{concat(substring(@name,0,string-length(@name)-3),'SimpleType')}">
                            <xsl:apply-templates select="xsd:restriction/*" mode="el"/>
                        </xsd:restriction>
                    </xsl:otherwise>
                </xsl:choose>
            </xsd:simpleType>
        </xsl:element>
    </xsl:template>

    <!--Normalize Yes/No YES/NO, Y/N enumerations-->
    <xsl:template
        match="xsd:simpleType[xsd:restriction/xsd:enumeration[@value = 'YES']][xsd:restriction/xsd:enumeration[@value = 'NO']]" mode="el">
        <xsl:call-template name="YesNoType">
            <xsl:with-param name="sType" select="."/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template
        match="xsd:simpleType[xsd:restriction/xsd:enumeration[@value = 'Y']][xsd:restriction/xsd:enumeration[@value = 'N']]" mode="el">
        <xsl:call-template name="YesNoType">
            <xsl:with-param name="sType" select="."/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="YesNoType">
        <xsl:param name="sType"/>
        <xsl:element name="xsd:element">
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="ends-with($sType/@name, 'SimpleType')">
                        <xsl:value-of select="substring($sType/@name, 0, string-length($sType/@name) - 9)"/>
                    </xsl:when>
                    <xsl:when test="ends-with($sType/@name, 'Type')">
                        <xsl:value-of select="substring($sType/@name, 0, string-length($sType/@name) - 3)"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="$sType/xsd:restriction/xsd:enumeration[@value = 'UNK']">
                        <xsl:text>YesNoUnknownSimpleType</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>YesNoSimpleType</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="$sType/xsd:annotation"/>
        </xsl:element>
    </xsl:template>
    <!-- _______________________________________________________ -->


    <!-- ******************** COMPLEX TYPE ELEMENTS ********************  -->

    <!--Create global xsd:element nodes for xsd:complexTypes -->
    <xsl:template match="xsd:complexType" mode="cmplxel">
        <xsd:element>
            <xsl:attribute name="name">
                <xsl:value-of select="substring(@name, 0, string-length(@name) - 3)"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
        </xsd:element>
    </xsl:template>

    <!-- Replace type names with normalized type names for xsd:emlement nodes
         used in xsd:complexTypes-->
    <xsl:template match="xsd:element[@type]">
        <xsl:variable name="nm">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:variable name="typename">
            <xsl:choose>
                <xsl:when test="starts-with(@type, 'f:')">
                    <xsl:value-of select="substring-after(@type, 'f:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@type"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--Use Regex without min max qalifiers to match with normalized types-->
        <xsl:variable name="typepattern">
            <xsl:call-template name="patternValue">
                <xsl:with-param name="pattern"
                    select="$mtf_fields_xsd/xsd:simpleType[@name = $nm]/xsd:restriction/xsd:pattern/@value"
                />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when
                    test="$normalizedtypes//xsd:simpleType/xsd:restriction/xsd:pattern/@value = $typepattern">
                    <xsl:value-of
                        select="$normalizedtypes//xsd:simpleType[xsd:restriction/xsd:pattern/@value = $typepattern]/@name"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="concat(substring($typename, 0, string-length($typename) - 3), 'SimpleType')"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--Use modifed name to replace elements with numeric qualifiers in the names with references to global types-->
        <xsl:variable name="refName">
            <xsl:value-of select="substring-before($nm, '_')"/>
        </xsl:variable>
        <xsl:choose>
            <!--Create reference when name matches global type-->
            <xsl:when test="$global_simple_elements//@name = $nm">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="$nm"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="*"/>
                </xsl:copy>
            </xsl:when>

            <!--Create reference when modifed name matches global type-->
            <xsl:when test="exists($global_simple_elements/*[@name = $refName])">
                <xsd:element ref="{$refName}">
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsd:element>
            </xsl:when>

            <!--Eliminate BlankSpaceCharacter type name variants-->
            <xsl:when test="starts-with(@name, 'BlankSpaceCharacter')">
                <xsd:element ref="BlankSpaceCharacter">
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsd:element>
            </xsl:when>

            <!--Include element name variants with normalized type-->
            <xsl:when test="starts-with($nm, 'BlankSpace')">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="name">
                        <xsl:value-of select="$nm"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:text>BlankSpaceSimpleType</xsl:text>
                    </xsl:attribute>
                </xsl:element>
            </xsl:when>

            <!--Create BlankSpace xsd:element node using normalized type restriction-->
            <xsl:when
                test="exists($mtf_simpletypes/*[@name = $type]/xsd:restriction[@base = 'xsd:string']/xsd:pattern)">
                <xsl:apply-templates select="$mtf_simpletypes/*[@name = $type]" mode="el"/>
            </xsl:when>

            <!--Use type complex name or simple type name from matching normalized simple type-->
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="type">
                        <xsl:choose>
                            <xsl:when test="$mtf_composites_xsd//xsd:complexType/@name = $typename">
                                <xsl:value-of select="$typename"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="elname">
                                    <xsl:value-of
                                        select="substring($typename, 0, string-length($typename) - 3)"
                                    />
                                </xsl:variable>
                                <xsl:value-of
                                    select="$global_simple_elements/*[@name = $elname]/@type"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates select="*"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- _______________________________________________________ -->

    <!-- ******************** Utilty Transforms ******************** -->
    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="replace(., '&#34;', '')"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*" mode="global">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="global"/>
            <xsl:apply-templates select="*" mode="global"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="global">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="replace(., '&#34;', '')"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:minLength" mode="global"/>
    <xsl:template match="xsd:maxLength" mode="global"/>
    <xsl:template match="xsd:length" mode="global"/>

    <xsl:template match="*" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="el"/>
            <xsl:apply-templates select="*" mode="el"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@*" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="replace(., '&#34;', '')"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:annotation" mode="el"/>

    <!--Copy annotation only it has descendents with text content-->
    <!--Add xsd:documentation using FudExplanation if it exists-->
    <xsl:template match="xsd:annotation">
        <xsl:if test="*//text()">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="@*"/>
                <xsl:if
                    test="exists(xsd:appinfo/*:FudExplanation) and not(xsd:documentation/text())">
                    <xsl:element name="xsd:documentation">
                        <xsl:value-of select="normalize-space(xsd:appinfo[1]/*:FudExplanation[1])"/>
                    </xsl:element>
                </xsl:if>
                <xsl:apply-templates select="*"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!--Copy documentation only it has text content-->
    <xsl:template match="xsd:documentation">
        <xsl:if test="text()">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="text()"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!--Copy element and use template mode to convert elements to attributes-->
    <xsl:template match="xsd:appinfo">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="exists(ancestor::xsd:enumeration)">
                    <xsl:element name="Enum" namespace="urn:mtf:mil:6040b:goe:fields">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="Field" namespace="urn:mtf:mil:6040b:goe:fields">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <!--Convert elements in xsd:appinfo to attributes-->
    <xsl:template match="*" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt = ' ') and not(*) and not($txt = '')">
            <xsl:attribute name="{name()}">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!--Normalize extra whitespace and linefeeds in text-->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    <!-- _______________________________________________________ -->

    <!-- ******************** FILTERS ******************** -->
    <xsl:template match="*[@name = 'FreeTextType']"/>
    <xsl:template match="*[@name = 'FreeTextBaseType']"/>
    <xsl:template match="*[@name = 'FreeTextBase']"/>
    <xsl:template match="*[@name = 'BlankSpaceCharacterType']"/>
    <xsl:template match="*[@name = 'BlankSpaceCharacterBaseType']"/>
    <!--- Remove Pattern for element generation-->
    <xsl:template match="xsd:pattern" mode="el"/>
    <!--- Remove Pattern from type containing base of xsd:integer -->
    <xsl:template match="xsd:pattern[parent::xsd:restriction/@base = 'xsd:integer']"/>
    <!--- Remove Pattern from type containing base of xsd:decimal -->
    <xsl:template match="xsd:pattern[parent::xsd:restriction/@base = 'xsd:decimal']"/>
    <!--- Remove Pattern from enumerations -->
    <xsl:template
        match="xsd:restriction/xsd:pattern[exists(parent::xsd:restriction/xsd:enumeration)]"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:integer']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:string']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base = 'xsd:decimal']/xsd:annotation"/>
    <xsl:template match="*:FieldFormatIndexReferenceNumber" mode="attr"/>
    <xsl:template match="*:FudNumber" mode="attr"/>
    <xsl:template match="*:VersionIndicator" mode="attr"/>
    <xsl:template match="*:MinimumLength" mode="attr"/>
    <xsl:template match="*:MaximumLength" mode="attr"/>
    <xsl:template match="*:LengthLimitation" mode="attr"/>
    <xsl:template match="*:Type" mode="attr"/>
    <xsl:template match="*:FudRelatedDocument" mode="attr"/>
    <xsl:template match="*:ffirnFudn" mode="attr"/>
    <xsl:template match="*:DataCode" mode="attr"/>
    <xsl:template match="*:DataType" mode="attr"/>
    <xsl:template match="*:EntryType" mode="attr"/>
    <xsl:template match="*:MtfRegularExpression" mode="attr"/>
    <xsl:template match="*:MinimumInclusiveValue" mode="attr"/>
    <xsl:template match="*:MaximumInclusiveValue" mode="attr"/>
    <xsl:template match="*:Explanation" mode="attr"/>
    <!-- _______________________________________________________ -->
</xsl:stylesheet>
