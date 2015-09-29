<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <!--Baseline Fields XML Schema document-->
    <xsl:variable name="mtf_goefields_xsd"
        select="document('../../XSD/APP-11C-GoE/natomtf_goe_fields.xsd')"/>
    <xsl:variable name="mtf_composites_xsd"
        select="document('../../XSD/APP-11C-ch1/Consolidated/composites.xsd')"/>
    <xsl:variable name="mtf_fields_xsd"
        select="document('../../XSD/APP-11C-ch1/Consolidated/fields.xsd')"/>


    <xsl:variable name="complex_types">
        <!--        <xsl:apply-templates select="$mtf_fields_xsd/xsd:schema/xsd:complexType"/>-->
        <xsl:apply-templates select="$mtf_composites_xsd/xsd:schema/xsd:complexType"/>
        <xsl:apply-templates select="$mtf_fields_xsd/xsd:schema/xsd:complexType"/>
    </xsl:variable>

    <xsl:variable name="global_complex_elements">
        <xsl:for-each select="$complex_types/*">
            <xsd:element>
                <xsl:attribute name="name">
                    <xsl:value-of select="substring(@name,0,string-length(@name)-3)"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
            </xsd:element>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="../../XSD/APP-11C-GoE/natomtf_goe_composites.xsd">
            <xsd:schema xmlns="urn:int:nato:mtf:app-11(c):goe:composites"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:field="urn:int:nato:mtf:app-11(c):goe:fields"
                targetNamespace="urn:int:nato:mtf:app-11(c):goe:composites" xml:lang="en-GB"
                elementFormDefault="unqualified" attributeFormDefault="unqualified">
                <xsd:import namespace="urn:int:nato:mtf:app-11(c):goe:fields"
                    schemaLocation="natomtf_goe_fields.xsd"/>
                <xsd:import namespace="http://www.w3.org/XML/1998/namespace"/>
                <xsl:for-each select="$complex_types/*">
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

    <!--Root level complexTypes-->
    <xsl:template match="xsd:complexType">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:complexType[@name='BlankSpaceCharacterType']">
        <xsd:complexType name="BlankSpaceCharacterType">
            <xsd:simpleContent>
                <xsd:extension base="field:BlankSpaceCharacterBaseSimpleType">
                    <xsd:attribute ref="xml:space"/>
                </xsd:extension>
            </xsd:simpleContent>
        </xsd:complexType>
    </xsl:template>

    <xsl:template match="xsd:complexType[@name='FreeTextType']">
        <xsd:complexType name="FreeTextType">
            <xsd:simpleContent>
                <xsd:extension base="field:FreeTextBaseSimpleType">
                    <xsd:attribute ref="xml:space"/>
                </xsd:extension>
            </xsd:simpleContent>
        </xsd:complexType>
    </xsl:template>

    <!-- type references are converted to SimpleType naming convention..-->
    <xsl:template match="xsd:element[@type]">
        <xsl:variable name="nm">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$mtf_goefields_xsd//@name=$nm">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('field:',$nm)"/>
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
                            <xsl:when
                                test="$mtf_composites_xsd/xsd:schema/xsd:complexType/@name=$typename">
                                <xsl:value-of select="$typename"/>
                            </xsl:when>
                            <xsl:when
                                test="$mtf_goefields_xsd/xsd:schema/xsd:simpleType/@name=concat(substring($typename,0,string-length($typename)-3),'SimpleType')">
                                <xsl:value-of
                                    select="concat('field:',substring($typename,0,string-length($typename)-3),'SimpleType')"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$typename"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates select="*"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

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
                    <xsl:element name="Enum">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="Field">
                        <xsl:apply-templates select="@*"/>
                        <xsl:apply-templates select="*" mode="attr"/>
                        <xsl:if
                            test="exists(*:FudNumber) and exists(*:FieldFormatIndexReferenceNumber)">
                            <xsl:attribute name="ffirnFudn">
                                <xsl:value-of
                                    select="concat('FF',*:FieldFormatIndexReferenceNumber/text(),'-',*:FudNumber/text())"
                                />
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
                <xsl:value-of select="replace(normalize-space(text()),'&#34;','')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

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
