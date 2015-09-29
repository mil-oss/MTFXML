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

    <xsl:variable name="mtfmsgs" select="document('../../XSD/Baseline_Schemas/messages.xsd')"/>

    <xsl:variable name="fields" select="document('../../XSD/GoE_Schemas/GoE_fields.xsd')"/>
    <xsl:variable name="sets" select="document('../../XSD/GoE_Schemas/GoE_sets.xsd')"/>
    <xsl:variable name="segments" select="document('../../XSD/GoE_Schemas/GoE_segments.xsd')"/>
    <xsl:variable name="vAllowedSymbols"
        select="'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'"/>

    <xsl:variable name="msgs">
        <xsl:apply-templates select="$mtfmsgs/xsd:schema/xsd:element" mode="el"/>
    </xsl:variable>

    <xsl:variable name="ctypes">
        <xsl:apply-templates select="$mtfmsgs/xsd:schema/xsd:element" mode="ctype"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document href="../../XSD/GoE_Schemas/GoE_messages.xsd">
            <xsd:schema xml:lang="en-US" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns="urn:mtf:mil:6040b" targetNamespace="urn:mtf:mil:6040b"
                xmlns:field="urn:mtf:mil:6040b:fields" xmlns:set="urn:mtf:mil:6040b:sets"
                xmlns:seg="urn:mtf:mil:6040b:segments"
                xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                xmlns:ism="urn:us:gov:ic:ism:v2" elementFormDefault="unqualified"
                attributeFormDefault="unqualified">
                <xsd:import namespace="urn:mtf:mil:6040b:fields" schemaLocation="GoE_fields.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:sets" schemaLocation="GoE_sets.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:segments" schemaLocation="GoE_segments.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsl:copy-of select="$ctypes"/>
                <xsl:copy-of select="$msgs"/>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="concat(@name,'Type')"/>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:element/xsd:annotation" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="*" mode="el"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:documentation" mode="el">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element/xsd:annotation/xsd:appinfo" mode="el">
        <xsl:copy copy-namespaces="no">
            <MsgInfo>
                <xsl:apply-templates select="*[not(name()='MtfStructuralRelationship')]" mode="attr"
                />
            </MsgInfo>
            <xsl:apply-templates select="*[name()='MtfStructuralRelationship']" mode="attr"/>
        </xsl:copy>
    </xsl:template>

    <!--Include Rules as attribute strings.  Replace double quotes with single quotes-->
    <xsl:template match="*" mode="trimattr">
        <xsl:variable name="apos">&#39;</xsl:variable>
        <xsl:variable name="quot">&#34;</xsl:variable>
        <xsl:attribute name="{substring-after(name(),'MtfStructuralRelationship')}">
            <xsl:value-of select="normalize-space(replace(.,$quot,$apos))"
                disable-output-escaping="yes"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element" mode="ctype">
        <xsd:complexType name="{concat(@name,'Type')}">
            <xsl:apply-templates select="@*" mode="ctype"/>
            <xsl:apply-templates select="xsd:annotation" mode="el"/>
            <xsl:apply-templates select="*[not(name()='xsd:annotation')]" mode="ctype"/>
        </xsd:complexType>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element/@name" mode="ctype"/>

    <xsl:template match="xsd:schema/xsd:element/xsd:annotation/xsd:appinfo" mode="ctype"/>

    <xsl:template match="xsd:element" mode="ctype">
        <xsl:variable name="nm">
            <!--<xsl:choose>
              <xsl:when test="starts-with(@name,'_')">
                    <xsl:value-of select="@name"/>
                </xsl:when>
                <xsl:when test="contains(@name,'_')">
                    <xsl:value-of select="substring-before(@name,'_')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@name"/>
                </xsl:otherwise>
            </xsl:choose>-->
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exists($sets/xsd:schema/xsd:element[@name=$nm])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('set:',$nm)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='name')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="exists($fields/xsd:schema/xsd:element[@name=$nm])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('field:',$nm)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='name')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="starts-with(./xsd:complexType/xsd:complexContent/xsd:extension/@base,'s:')">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="name">
                        <xsl:value-of select="$nm"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="replace(xsd:complexType/xsd:complexContent/xsd:extension/@base,'s:','set:')"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='name')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*" mode="ctype"/>
                    <xsl:apply-templates select="*" mode="ctype"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:element[ends-with(@name,'Segment')]" mode="ctype">
        <xsl:variable name="nm">
            <xsl:value-of select="substring(@name,0,string-length(@name)-6)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exists($segments/xsd:schema/xsd:element[@name=$nm])">
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('seg:',$nm)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='name')]" mode="ctype"/>
                    <xsl:apply-templates select="xsd:annotation" mode="ctype"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*" mode="ctype"/>
                    <xsl:apply-templates select="*" mode="ctype"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:element[starts-with(@name,'GeneralText_')]" mode="ctype">
        <xsl:variable name="per">&#46;</xsl:variable>
        <xsl:variable name="apos">&#34;</xsl:variable>
        <xsl:variable name="doc">
            <xsl:value-of
                select="upper-case(*/ancestor::xsd:element[1]/xsd:annotation/xsd:documentation)"/>
        </xsl:variable>
        <xsl:variable name="UseDesc">
            <xsl:value-of
                select="upper-case(xsd:annotation/xsd:appinfo/*:SetFormatPositionUseDescription)"/>
        </xsl:variable>
        <xsl:variable name="TextInd">
            <xsl:value-of select="normalize-space(substring-after($UseDesc,'MUST EQUAL'))"/>
        </xsl:variable>
        <xsl:variable name="CCase">
            <xsl:call-template name="CamelCase">
                <xsl:with-param name="text">
                    <xsl:value-of select="replace($TextInd,$apos,'')"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="nametxt0">
            <!--handle 2 special cases with parens-->
            <xsl:value-of
                select="translate(translate(concat('GenText',replace(replace($CCase,'(TAS)',''),'(mpa)','')),' ()',''),translate(., $vAllowedSymbols, ''),'')"
            />
        </xsl:variable>
        <!--handle 2 special cases with GenTextAcsign and OperationalTaskingCommonTacticalPicture Gentext -->
        <xsl:variable name="nametxt">
            <xsl:choose>
                <xsl:when test="$nametxt0='GenTextAcsign'">
                    <xsl:choose>
                        <xsl:when test="contains($doc,'AIRBORNE')">
                            <xsl:value-of select="concat($nametxt0,'Airborne')"/>
                        </xsl:when>
                        <xsl:when test="contains($doc,'GROUND')">
                            <xsl:value-of select="concat($nametxt0,'GroundAlert')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($nametxt0,'Shipborne')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$nametxt0='GenTextArchitectureConfigurationAmplification'">
                    <xsl:choose>
                        <xsl:when test="contains($doc,'BGDBM')">
                            <xsl:value-of select="concat($nametxt0,'Bgdm')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$nametxt0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$nametxt0"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="name">
                <xsl:value-of select="$nametxt"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[not(name()='name')]" mode="ctype"/>
            <xsl:apply-templates select="*" mode="ctype"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:extension[@base='s:GeneralTextType']" mode="ctype">
        <xsl:variable name="apos">&#34;</xsl:variable>
        <xsl:variable name="quot">"</xsl:variable>
        <xsl:variable name="per">.</xsl:variable>
        <xsl:variable name="UseDesc">
            <xsl:value-of
                select="upper-case(*/ancestor::xsd:element[1]/xsd:annotation/xsd:appinfo/*:SetFormatPositionUseDescription)"
            />
        </xsl:variable>
        <xsl:variable name="TextInd">
            <xsl:choose>
                <xsl:when test="contains($UseDesc,$per)">
                    <xsl:value-of
                        select="normalize-space(substring-before(substring-after($UseDesc,'MUST EQUAL'),$per))"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(substring-after($UseDesc,'MUST EQUAL'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="xsd:extension">
            <xsl:attribute name="base">
                <xsl:text>set:GeneralTextType</xsl:text>
            </xsl:attribute>
            <xsl:element name="xsd:sequence">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="name">
                        <xsl:text>GentextTextIndicator</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:text>field:GentextTextIndicatorSimpleType</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="minOccurs">
                        <xsl:text>1</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="fixed">
                        <xsl:value-of select="replace(replace($TextInd,$apos,''),'”','')"/>
                    </xsl:attribute>
                </xsl:element>
                <xsl:element name="xsd:element">
                    <xsl:attribute name="ref">
                        <xsl:text>field:FreeText</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="minOccurs">
                        <xsl:text>1</xsl:text>
                    </xsl:attribute>
                </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="xsd:attribute"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:element/xsd:complexType" mode="ctype">
        <xsl:apply-templates select="@*" mode="ctype"/>
        <xsl:apply-templates select="*" mode="ctype"/>
    </xsl:template>

    <xsl:template match="*" mode="ctype">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="ctype"/>
            <xsl:apply-templates select="*" mode="ctype"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:documentation" mode="ctype">
            <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="text()" mode="ctype"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:complexType/xsd:sequence/xsd:choice/xsd:annotation/xsd:appinfo"
        mode="ctype">
        <xsl:copy copy-namespaces="no">
            <AltInfo>
                <xsl:apply-templates select="*" mode="attr"/>
            </AltInfo>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:appinfo" mode="ctype">
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="child::node()[starts-with(name(),'SetFormat')]">
                    <SetFormat>
                        <xsl:apply-templates select="*[string-length(text())&gt;0]" mode="attr"/>
                    </SetFormat>
                </xsl:when>
                <xsl:when test="child::node()[starts-with(name(),'SegmentStructure')]">
                    <SegmentStructure>
                        <xsl:apply-templates select="*[string-length(text())&gt;0]" mode="attr"/>
                    </SegmentStructure>
                </xsl:when>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" mode="ctype">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="@*" mode="ctype">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="@base" mode="ctype">
        <xsl:attribute name="base">
            <xsl:value-of select="replace(.,'s:','set:')"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="*" mode="attr">
        <xsl:variable name="apos">
            <xsl:text>&apos;</xsl:text>
        </xsl:variable>
        <xsl:variable name="quot">
            <xsl:text>&quot;</xsl:text>
        </xsl:variable>
        <xsl:if test="string-length(text())!=0">
            <xsl:attribute name="{name()}">
                <xsl:value-of select="replace(normalize-space(.),$quot,$apos)"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[name()='MtfStructuralRelationship']" mode="attr">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="*[string-length(text()[1])&gt;0]" mode="trimattr"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="CamelCase">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text,' ')">
                <xsl:call-template name="CamelCaseWord">
                    <xsl:with-param name="text" select="substring-before($text,' ')"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="CamelCase">
                    <xsl:with-param name="text" select="substring-after($text,' ')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="CamelCaseWord">
                    <xsl:with-param name="text" select="$text"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="CamelCaseWord">
        <xsl:param name="text"/>
        <xsl:value-of
            select="translate(substring($text,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        <xsl:value-of
            select="translate(substring($text,2,string-length($text)-1),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"
        />
    </xsl:template>
</xsl:stylesheet>
