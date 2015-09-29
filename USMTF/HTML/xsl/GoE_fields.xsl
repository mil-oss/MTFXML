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

    <xsl:variable name="simple_types">
        <xsl:apply-templates select="$mtf_fields_xsd/xsd:schema/xsd:simpleType"/>
    </xsl:variable>

    <xsl:variable name="complex_types">
        <xsl:apply-templates select="$mtf_fields_xsd/xsd:schema/xsd:complexType"/>
        <xsl:apply-templates select="$mtf_composites_xsd/xsd:schema/xsd:complexType"/>
    </xsl:variable>

    <xsl:variable name="global_simple_elements">
        <xsl:for-each select="$simple_types/*">
            <xsd:element>
                <xsl:attribute name="name">
                    <xsl:value-of select="substring(@name,0,string-length(@name)-9)"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="global_complex_elements">
        <xsl:for-each select="$complex_types/*">
            <xsd:element>
                <xsl:attribute name="name">
                    <xsl:choose>
                        <xsl:when test="@name='MissionVerificationIndexComplexType'">
                            <xsl:text>MissionVerificationIndex</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(@name,0,string-length(@name)-3)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>


    <xsl:template match="/">
        <xsl:result-document href="../../XSD/GoE_Schemas/GoE_fields.xsd">
            <xsd:schema xmlns="urn:mtf:mil:6040b:fields"
                        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                        targetNamespace="urn:mtf:mil:6040b:fields" xml:lang="en-US"
                        elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="http://www.w3.org/XML/1998/namespace"
                            schemaLocation="http://www.w3.org/2001/xml.xsd"/>
                <xsl:for-each select="$simple_types/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$complex_types/*">
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

    <!--Root level simpleTypes use SimpleType naming convention-->
    <xsl:template match="xsd:simpleType">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="name">
                <xsl:value-of
                    select="concat(substring(@name,0,string-length(@name)-3),'SimpleType')"/>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!--Root level complexTypes-->
    <xsl:template match="xsd:complexType">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!--Filter duplication of MissionVerificationIndexType in Simple and Complex types-->
    <xsl:template match="xsd:complexType[@name='MissionVerificationIndexType']">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="name">
                <xsl:text>MissionVerificationIndexComplexType</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xsd:complexType[@name='MissionVerificationIndexType']/@name"/>

    <!-- type references are converted to local with SimpleType naming convention after verifying that it isn't ComplexType.-->
    <xsl:template match="xsd:element[@type]">
        <xsl:variable name="nm">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$global_simple_elements//@name=$nm">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="$nm"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="*"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*"/>
                    <xsl:variable name="typename">
                        <xsl:choose>
                            <xsl:when test="starts-with(@type,'f:')">
                                <xsl:value-of select="substring-after(@type,'f:')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@type"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="type">
                        <xsl:choose>
                            <xsl:when test="$mtf_composites_xsd//xsd:complexType/@name=$typename">
                                <xsl:value-of select="$typename"/>
                            </xsl:when>
                            <xsl:when test="$mtf_fields_xsd//xsd:complexType/@name=$typename">
                                <xsl:value-of select="$typename"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="concat(substring($typename,0,string-length($typename)-3),'SimpleType')"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates select="*"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- base references are converted to local with SimpleType naming convention after verifying that it isn't ComplexType.-->
    <xsl:template match="xsd:extension[ends-with(@base,'Type')]">
        <xsl:variable name="basename">
            <xsl:value-of select="@base"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="base">
                <xsl:choose>
                    <xsl:when test="$mtf_composites_xsd//xsd:complexType/@name=$basename">
                        <xsl:value-of select="$basename"/>
                    </xsl:when>
                    <xsl:when test="$mtf_fields_xsd//xsd:complexType/@name=$basename">
                        <xsl:value-of select="$basename"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="concat(substring($basename,0,string-length($basename)-3),'SimpleType')"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!--Copy annotation only it has descendents with text content-->
    <!--Add xsd:documentation using FudExplanation if it exists-->
    <xsl:template match="xsd:annotation">
        <xsl:if test="*//text()">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="@*"/>
                <xsl:if test="exists(xsd:appinfo/*:FudExplanation) and not(xsd:documentation/text())">
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
                    <xsl:element name="Enum" namespace="urn:mtf:mil:6040b:fields">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="Field" namespace="urn:mtf:mil:6040b:fields">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"/>
                        <xsl:if test="exists(*:FudNumber) and exists(*:FieldFormatIndexReferenceNumber)">
                            <xsl:attribute name="ffirnFudn">
                                <xsl:value-of select="concat('FF',*:FieldFormatIndexReferenceNumber/text(),'-',*:FudNumber/text())"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <!--Copy element and iterate child attributes and elements-->
    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!--Carry through attribute-->
    <xsl:template match="@*">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

    <!--Normalize extra whitespace and linefeeds in text-->
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <!--Convert elements in xsd:appinfo to attributes-->
    <xsl:template match="*" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt=' ') and not(*) and not($txt='')">
            <xsl:attribute name="{name()}">
                <xsl:value-of select="normalize-space(text())"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
  
    <!-- SHORTENED ATTRIBUTES-->
    <!--replace ElementalFfirnFudnSequence with "sequence"-->
    <!-- <xsl:template match="*:ElementalFfirnFudnSequence" mode="attr">
        <xsl:attribute name="sequence">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->

    <!--replace DataItemSequenceNumber with "sequence"-->
    <!-- <xsl:template match="*:DataItemSequenceNumber" mode="attr">
        <xsl:attribute name="sequence">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->

    <!--replace DataItem with "name"-->
    <!-- <xsl:template match="*:DataItem" mode="attr">
        <xsl:attribute name="name">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->

    <!--replace FudName with "name"-->
    <!--<xsl:template match="*:FudName" mode="attr">
        <xsl:attribute name="name">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->
    
    <!--include FudRelatedDocument as "document"-->
    <!--<xsl:template match="*:FudRelatedDocument" mode="attr">
        <xsl:attribute name="document">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->
    
    <!--include VersionIndicator as "version"-->
    <!--<xsl:template match="*:VersionIndicator" mode="attr">
        <xsl:attribute name="version">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->
    
    <!--include EntryType as "entrytype"-->
    <!--<xsl:template match="*:EntryType" mode="attr">
        <xsl:attribute name="entrytype">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->
    
    <!--include LengthLimitation as "lengthLimit"-->
    <!-- <xsl:template match="*:LengthLimitation" mode="attr">
        <xsl:attribute name="lengthLimit">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->
    
    <!--include DataType as "datatype"-->
    <!-- <xsl:template match="*:DataType" mode="attr">
        <xsl:attribute name="datatype">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->
    
    <!--include Type as "datatype"-->
    <!--<xsl:template match="*:Type" mode="attr">
        <xsl:attribute name="datatype">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->
    
    <!--include FudNumber as "fudno"-->
    <!--    <xsl:template match="*:FudNumber" mode="attr">
        <xsl:attribute name="fudno">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->
    
    <!--include FieldFormatIndexReferenceNumber as "ffirn"-->
    <!--<xsl:template match="*:FieldFormatIndexReferenceNumber" mode="attr">
        <xsl:attribute name="ffirn">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->
    
    <!--include MinimumLength as "minlength"-->
    <!--    <xsl:template match="*:MinimumLength" mode="attr">
        <xsl:attribute name="minlength">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->
    
    <!--include MaximumLength as "maxlength"-->
    <!--<xsl:template match="*:MaximumLength" mode="attr">
        <xsl:attribute name="maxlength">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>-->
    
    <!--include FudExplanation as "explanation"-->
    <!--    <xsl:template match="*:FudExplanation" mode="attr">
            <xsl:attribute name="explanation">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
        </xsl:template>
    -->
    <!--Filter empty xsd:annotations-->
    
    <xsl:template match="xsd:restriction[@base='xsd:integer']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base='xsd:string']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base='xsd:decimal']/xsd:annotation"/>

    <!--Filter unused elements-->
    <xsl:template match="*:DataCode" mode="attr"/>
    <xsl:template match="*:MtfRegularExpression" mode="attr"/>
    <xsl:template match="*:MinimumInclusiveValue" mode="attr"/>
    <xsl:template match="*:MaximumInclusiveValue" mode="attr"/>
    <xsl:template match="*:Explanation" mode="attr"/>
</xsl:stylesheet>
