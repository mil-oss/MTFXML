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
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:set="urn:mtf:mil:6040b:sets"
    xmlns:segment="urn:mtf:mil:6040b:segments" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <!--This Transform produces a "Garden of Eden" style global elements XML Schema for Segments in the USMTF Military Message Standard.-->
    <!--The Resulting Global Elements will be included in the "usmtf_fields" XML Schema per proposed changes of September 2014-->
    <!--Duplicate Segment Names are deconflicted using an XML document containing affected messages, elements and approved changes-->


    <xsl:variable name="msgs" select="document('../../XSD/Baseline_Schemas/messages.xsd')"/>
    <xsl:variable name="sets" select="document('../../XSD/GoE_Schemas/GoE_sets.xsd')"/>
    <xsl:variable name="fields" select="document('../../XSD/GoE_Schemas/GoE_fields.xsd')"/>
    <xsl:variable name="new_names" select="document('Segment_Name_Changes.xml')"/>

    <!-- Extract all Segments from Baseline XML Schema for messages-->
    <xsl:variable name="segment_elements">
        <xsl:apply-templates select="$msgs/*//xsd:element[contains(@name,'Segment')]" mode="topel">
            <xsl:sort select="@name" data-type="text"/>
        </xsl:apply-templates>
    </xsl:variable>

    <!-- Apply changes and de-conflict Segment names from list created as segment_elements variable-->
    <xsl:variable name="global_segment_elements">
        <xsl:apply-templates select="$segment_elements/*" mode="global"/>
    </xsl:variable>

    <!-- Extract all complexTypes from Segments.  These will be made Global and referenced.-->
    <xsl:variable name="complex_types">
        <xsl:apply-templates select="$segment_elements/*" mode="cmplxtypes"/>
    </xsl:variable>
    
    <!-- Extract all complexTypes from Segments.  These will be made Global and referenced.-->
    <xsl:variable name="norm_complex_types">
        <xsl:apply-templates select="$complex_types/*" mode="normalize"/>
    </xsl:variable>

    <!--Build XML Schema and add Global Elements and Complex Types -->
    <xsl:template match="/">
        <xsl:result-document href="../../XSD/GoE_Schemas/GoE_segments.xsd">
            <xsd:schema xmlns="urn:mtf:mil:6040b:segments"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:field="urn:mtf:mil:6040b:fields"
                xmlns:ism="urn:us:gov:ic:ism:v2" targetNamespace="urn:mtf:mil:6040b:segments">
                <xsd:import namespace="urn:mtf:mil:6040b:fields" schemaLocation="GoE_fields.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:sets" schemaLocation="GoE_sets.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <xsl:copy-of select="$norm_complex_types"/>
                <!--<xsl:copy-of select="$complex_types"/>-->
                <xsl:copy-of select="$global_segment_elements"/>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>

    <!-- Copy every Segment Element and make global.  Populates segment_elements variable which includes duplicates -->
    <!--This process preserves all structure and converts it to desired format with references which will be used in ComplexTypes-->
    <!-- Add ID to match with proposed name change list -->
    <xsl:template match="xsd:element" mode="topel">
        <xsl:choose>
            <xsl:when test="ends-with(@name,'Segment')">
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="name">
                        <xsl:value-of select="@name"/>
                    </xsl:attribute>
                    <xsl:attribute name="msgid">
                        <xsl:value-of
                            select="ancestor::xsd:element[parent::xsd:schema]/xsd:annotation/xsd:appinfo/*:MtfIdentifier"
                        />
                    </xsl:attribute>
                    <xsl:apply-templates select="*"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="contains(@name,'Segment_')">
                <xsl:copy copy-namespaces="no">
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="name">
                        <xsl:value-of select="substring-before(@name,'_')"/>
                    </xsl:attribute>
                    <xsl:attribute name="msgid">
                        <xsl:value-of
                            select="ancestor::xsd:element[parent::xsd:schema]/xsd:annotation/xsd:appinfo/*:MtfIdentifier"
                        />
                    </xsl:attribute>
                    <xsl:apply-templates select="*"/>
                </xsl:copy>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Create Global Complex Types from  segment_elements variable -->
    <xsl:template match="xsd:element" mode="global">
        <xsl:variable name="segmentName">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:variable name="mtfid">
            <xsl:value-of select="@msgid"/>
        </xsl:variable>
        <xsl:choose>
            <!--For matching message id and segment name use changed name from de-conflicted Segments document When there is no change - use first one only-->
            <xsl:when
                test="$new_names/*/*[@MSG_IDENTIFIER=$mtfid and @ElementName=$segmentName and not(preceding-sibling::*[@ElementName=@ProposedElementName])]">
                <xsl:variable name="tname">
                    <xsl:value-of
                        select="$new_names/*/*[@MSG_IDENTIFIER=$mtfid][@ElementName=$segmentName]/@ProposedElementName"
                    />
                </xsl:variable>
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="name">
                        <!--<xsl:value-of select="$tname"/>-->
                        <xsl:value-of select="substring($tname,0,string-length($tname)-6)"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="concat($tname,'Type')"/>
                        <!--<xsl:value-of
                            select="concat(substring($tname,0,string-length($tname)-6),'Type')"/>-->
                    </xsl:attribute>
                </xsl:copy>
            </xsl:when>
            <!--Duplicate but no changed name because identical structure in respective messages-->
            <xsl:when test="preceding-sibling::xsd:element[@name=$segmentName]">
                <!--Omit duplicate Element-->
            </xsl:when>
            <!--No duplicate name-->
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="name">
                        <!--<xsl:value-of select="concat($segmentName,'')"/>-->
                        <xsl:value-of
                            select="substring($segmentName,0,string-length($segmentName)-6)"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <!--add Type-->
                        <xsl:value-of select="concat($segmentName,'Type')"/>
                        <!--<xsl:value-of
                            select="concat(substring($segmentName,0,string-length($segmentName)-6),'Type')"
                        />-->
                    </xsl:attribute>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:element" mode="cmplxtypes">
        <xsl:variable name="segmentName">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:variable name="mtfid">
            <xsl:value-of select="@msgid"/>
        </xsl:variable>
        <xsl:choose>
            <!--For matching message id and segment name use changed name from de-conflicted Segments document.  When there is no change - use first one only-->
            <xsl:when
                test="$new_names/*/*[@MSG_IDENTIFIER=$mtfid and @ElementName=$segmentName and not(preceding-sibling::*[@ElementName=@ProposedElementName])]">
                <xsl:variable name="tname">
                    <xsl:value-of
                        select="$new_names/*/*[@MSG_IDENTIFIER=$mtfid][@ElementName=$segmentName]/@ProposedElementName"
                    />
                </xsl:variable>
                <xsd:complexType>
                    <!--<xsl:apply-templates select="@*"/>-->
                    <xsl:variable name="segname">
                        <xsl:value-of select="$tname"/>
                    </xsl:variable>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($tname,'Type')"/>
                        <!--<xsl:value-of
                            select="concat(substring($tname,0,string-length($tname)-6),'Type')"/>-->
                    </xsl:attribute>
                    <xsl:apply-templates select="*" mode="cmplxtypes"/>
                </xsd:complexType>
            </xsl:when>
            <!--Duplicate but no changed name because identical structure in respective messages-->
            <xsl:when test="preceding-sibling::xsd:element[@name=$segmentName]">
                <!--Omit duplicate Element-->
            </xsl:when>
            <!--No duplicate name-->
            <xsl:otherwise>
                <xsd:complexType>
                    <!--<xsl:apply-templates select="@*"/>-->
                    <xsl:attribute name="name">
                        <!--Omit ending Segment and add Type-->
                        <xsl:value-of select="concat($segmentName,'Type')"/>
                        <!--<xsl:value-of
                            select="concat(substring($segmentName,0,string-length($segmentName)-6),'Type')"
                        />-->
                    </xsl:attribute>
                    <xsl:apply-templates select="*" mode="cmplxtypes"/>
                </xsd:complexType>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:complexType" mode="cmplxtypes">
        <xsl:apply-templates select="*"/>
    </xsl:template>
   
    <xsl:template match="*" mode="cmplxtypes">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xsd:complexType" mode="normalize">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="normalize"/>
            <xsl:apply-templates select="*" mode="normalize"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*" mode="normalize">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*" mode="normalize"/>
            <xsl:apply-templates select="*" mode="normalize"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*" mode="normalize">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>
    
    <xsl:template match="xsd:element[contains(@name, '_')]" mode="normalize">
        <xsl:choose>
            <xsl:when test="contains(@name,'Segment')">
                <xsd:element ref="{substring-before(@name,'Segment')}">
                    <xsl:copy-of select="xsd:annotation"/>
                </xsd:element>
            </xsl:when>
            <xsl:otherwise>
                <xsd:element ref="{concat('set:',substring-before(@name,'_'))}">
                    <xsl:copy-of select="xsd:annotation"/>
                </xsd:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsd:documentation">
        <xsl:copy copy-namespaces="no">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:copy>
    </xsl:template>

    <!--    <xsl:template match="xsd:element[matches(@name,'\w_([0-9]{1,2})$')]">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="name">
                <xsl:value-of select="substring-before(@name,'_')"/>
            </xsl:attribute>
            <xsl:apply-templates select="@*[not(name()='name')]"/>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>-->

    <xsl:template match="xsd:element">
        <xsl:variable name="nm">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="exists($sets/xsd:schema/xsd:element[@name=$nm])">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('set:',$nm)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='name')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:when>
                <xsl:when test="exists($fields/xsd:schema/xsd:element[@name=$nm]) and $nm!='GentextTextIndicator'">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('field:',$nm)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='name')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:when>
                <xsl:when
                    test="exists($msgs/xsd:schema//xsd:element[ends-with(@name,'Segment')][@name=$nm])">
                    <xsl:attribute name="ref">
                        <!--<xsl:value-of select="$nm"/>-->
                        <xsl:value-of select="substring($nm,0,string-length($nm)-6)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[not(name()='name')]"/>
                    <xsl:apply-templates select="xsd:annotation"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="*"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:attribute">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@name"/>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy-of select="." copy-namespaces="no"/>
    </xsl:template>

    <xsl:template match="xsd:element[starts-with(@name,'GeneralText_')]">
        <xsl:variable name="per">&#46;</xsl:variable>
        <xsl:variable name="apos">&#34;</xsl:variable>
        <xsl:variable name="lparen">&#40;</xsl:variable>
        <xsl:variable name="rparen">&#41;</xsl:variable>
        <xsl:variable name="UseDesc">
            <xsl:value-of
                select="translate(upper-case(xsd:annotation/xsd:appinfo/*:SetFormatPositionUseDescription),'.','')"
            />
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
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <!--handle 2 special cases with parens-->
            <xsl:attribute name="name">
                <xsl:value-of
                    select="translate(concat('GenText',replace(replace($CCase,'(TAS)',''),'(mpa)','')),' ()','')"
                />
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:extension[@base='s:GeneralTextType']">
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
                <!--<xsl:text>GeneralTextType</xsl:text>-->
            </xsl:attribute>
            <xsl:element name="xsd:sequence">
                <xsl:element name="xsd:element">
                    <xsl:attribute name="name">
                        <xsl:text>GentextTextIndicator</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:text>field:GentextTextIndicatorSimpleType</xsl:text>
                        <!--<xsl:text>GentextTextIndicatorType</xsl:text>-->
                    </xsl:attribute>
                    <xsl:attribute name="minOccurs">
                        <xsl:text>1</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="fixed">
                        <xsl:value-of select="replace($TextInd,$apos,'')"/>
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

    <xsl:template match="@base[.!='s:SurveillanceTypeType'][starts-with(.,'s:')]">
        <xsl:attribute name="base">
            <xsl:value-of select="concat('set:',substring-after(.,'s:'))"/>
            <!--<xsl:value-of select="substring-after(.,'s:')"/>-->
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="@base[.='s:SurveillanceTypeType']">
        <xsl:attribute name="base">
            <xsl:text>set:SurveillanceType</xsl:text>
        </xsl:attribute>
    </xsl:template>

    <!--Segment sequence is not used at Global level. -->
    <xsl:template match="xsd:attribute[@name='segSeq']"/>

    <!--Filter these attributes at complexType level-->
    <xsl:template match="@maxOccurs"/>
    <xsl:template match="@msgid"/>

    <xsl:template match="*" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt=' ') and not(*) and not($txt='')">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:attribute>
        </xsl:if>
    </xsl:template>


    <xsl:template match="xsd:choice/xsd:annotation/xsd:appinfo">
        <xsl:copy copy-namespaces="no">
            <AltInfo>
                <xsl:apply-templates select="*[string-length(text())&gt;0]" mode="attr"/>
            </AltInfo>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:appinfo[*:SetFormatPositionName]">
        <xsl:copy copy-namespaces="no">
            <SetFormat>
                <xsl:apply-templates select="*[string-length(text())&gt;0]" mode="attr"/>
            </SetFormat>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:appinfo[*:SegmentStructureName]">
        <xsl:copy copy-namespaces="no">
            <SegmentStructure>
                <xsl:apply-templates select="*[string-length(text())&gt;0]" mode="attr"/>
            </SegmentStructure>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*:SegmentStructureUseDescription" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt=' ') and not(*) and not($txt='')">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="normalize-space(replace(.,'&#34;',''))"
                disable-output-escaping="yes"/>
        </xsl:attribute>
        </xsl:if>
    </xsl:template>
   
    <xsl:template match="*:SetFormatPositionUseDescription" mode="attr">
        <xsl:variable name="txt" select="normalize-space(text())"/>
        <xsl:if test="not($txt=' ') and not(*) and not($txt='')">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="normalize-space(replace(.,'&#34;',''))"
                disable-output-escaping="yes"/>
        </xsl:attribute>
        </xsl:if>
    </xsl:template>
   
   <!--Use Position relative to segment vice position relative to containing message-->
    <xsl:template match="*:SetFormatPositionNumber" mode="attr">
        <xsl:variable name="pos" select="number(text())"/>
        <xsl:variable name="initpos">
            <xsl:value-of select="ancestor::xsd:complexType[1]/ancestor::xsd:element[1]/xsd:annotation/xsd:appinfo/*:InitialSetFormatPosition"/>
        </xsl:variable>
        <xsl:attribute name="{name()}">
            <xsl:value-of select="number($pos)-$initpos+1"/>
        </xsl:attribute>
    </xsl:template>
   
    <!--InitialSetFormatPosition only applies in context of containing message-->
    <xsl:template match="*:InitialSetFormatPosition" mode="attr"/>
    
    <!--Attribute setSeq only applies in context of containing message-->
    <xsl:template match="xsd:attribute[@name='setSeq']"/>
    
    <xsl:template match="*:SetFormatPositionConcept" mode="attr"/>

    <!--Filter these elements-->
    <xsl:template match="xsd:element[@name='AirForceEquipmentSegment']" mode="topel"/>
    <xsl:template match="xsd:element[@name='AirForcePersonnelAndTrainingSegment']" mode="topel"/>
    <xsl:template match="xsd:element[@name='AirForceSpecialCapabilitySegment']" mode="topel"/>

    <xsl:template match="*:OccurrenceCategory" mode="attr">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="normalize-space(.)"
                disable-output-escaping="yes"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="*:Repeatability" mode="attr">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="normalize-space(.)"
                disable-output-escaping="yes"/>
        </xsl:attribute>
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
