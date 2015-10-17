<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:set="urn:mtf:mil:6040b:sets"
    xmlns:segment="urn:mtf:mil:6040b:segments" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    
    <!--This Transform produces a "Garden of Eden" style global elements XML Schema for Segments in the USMTF Military Message Standard.-->
    <!--The Resulting Global Elements will be included in the "usmtf_fields" XML Schema per proposed changes of September 2014-->
    <!--Duplicate Segment Names are deconflicted using an XML document containing affected messages, elements and approved changes-->
    
    
    <xsl:variable name="msgs" select="document('../../Baseline_Schemas/messages.xsd')"/>
    <xsl:variable name="goe_sets_xsd" select="document('../../XSD/GoE_sets.xsd')"/>
    <xsl:variable name="goe_fields_xsd" select="document('../../XSD/GoE_fields.xsd')"/>
    <xsl:variable name="new_names" select="document('Segment_Name_Changes.xml')"/>
    
    <!-- Extract all Segments from Baseline XML Schema for messages-->
    <xsl:variable name="segment_elements">
        <xsl:apply-templates select="$msgs/*//xsd:element[ends-with(@name,'Segment')]" mode="topel">
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

    <!--Build XML Schema and add Global Elements and Complex Types -->
    <xsl:template match="/">
        <xsl:result-document href="../../XSD/GoE_segments.xsd">
            <xsd:schema xmlns="urn:mtf:mil:6040b:segments"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:field="urn:mtf:mil:6040b:goe:fields"
                xmlns:ism="urn:us:gov:ic:ism:v2" targetNamespace="urn:mtf:mil:6040b:segments">
                <xsd:import namespace="urn:mtf:mil:6040b:goe:fields"
                    schemaLocation="GoE_fields.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:sets" schemaLocation="GoE_sets.xsd"/>
                <xsd:import namespace="urn:us:gov:ic:ism:v2" schemaLocation="IC-ISM-v2.xsd"/>
                <!--<xsl:copy-of select="$segment_elements"/>-->
                <xsl:copy-of select="$global_segment_elements"/>
                <xsl:copy-of select="$complex_types"/>
            </xsd:schema>
        </xsl:result-document>
    </xsl:template>
    
    <!-- Copy every Segment Element and make global.  Populates segment_elements variable which includes duplicates -->
    <!--This process preserves all structure and converts it to desired format with references which will be used in ComplexTypes-->
    <!-- Add ID to match with proposed name change list -->
    <xsl:template match="xsd:element" mode="topel">
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
                <xsl:copy copy-namespaces="no">
                    <xsl:attribute name="name">
                        <xsl:value-of
                            select="concat($new_names/*/*[@MSG_IDENTIFIER=$mtfid][@ElementName=$segmentName]/@ProposedElementName,'')"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of
                            select="concat($new_names/*/*[@MSG_IDENTIFIER=$mtfid][@ElementName=$segmentName]/@ProposedElementName,'Type')"
                        />
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
                        <xsl:value-of select="concat($segmentName,'')"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <!--Omit add Type-->
                        <!--<xsl:value-of select="concat($segmentName,'Type')"/>-->
                        <xsl:value-of select="concat(substring($segmentName,0,string-length($segmentName)-6),'Type')"/>
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
                <xsd:complexType>
                    <xsl:apply-templates select="@*"/>
                    <xsl:variable name="segname">
                        <xsl:value-of select="$new_names/*/*[@MSG_IDENTIFIER=$mtfid][@ElementName=$segmentName]/@ProposedElementName"/>
                    </xsl:variable>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat(substring($segname,0,string-length($segname)-6),'Type')"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="*"/>
                </xsd:complexType>
            </xsl:when>
            <!--Duplicate but no changed name because identical structure in respective messages-->
            <xsl:when test="preceding-sibling::xsd:element[@name=$segmentName]">
                <!--Omit duplicate Element-->
            </xsl:when>
            <!--No duplicate name-->
            <xsl:otherwise>
                <xsd:complexType>
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="name">
                        <!--Omit ending Segment and add Type-->
                        <!--<xsl:value-of select="concat($segmentName,'Type')"/>-->
                        <xsl:value-of select="concat(substring($segmentName,0,string-length($segmentName)-6),'Type')"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="*"/>
                </xsd:complexType>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="xsd:schema/xsd:element/@msgid" mode="cmplxtypes"/>
    <xsl:template match="xsd:schema/xsd:element/@minOccurs" mode="cmplxtypes"/>
    <xsl:template match="xsd:schema/xsd:element/@maxOccurs" mode="cmplxtypes"/>
    
    <!--Root level complexTypes-->
    <xsl:template match="xsd:complexType">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!-- Elements in Fields global types converted to references..-->
    <xsl:template match="xsd:complexType//xsd:element[@name]">
        <xsl:variable name="nm">
            <xsl:value-of select="@name"/>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:choose>
                <xsl:when test="exists($goe_fields_xsd/xsd:schema/xsd:element[@name=$nm])">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="concat('field:',$nm)"/>
                    </xsl:attribute>
                    <xsl:if
                        test="xsd:annotation/xsd:appinfo/*:OccurrenceCategory/text()='Mandatory'">
                        <xsl:if test="not(not(*) and not(text()) and not(normalize-space()))">
                            <xsl:attribute name="minOccurs">
                                <xsl:text>1</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if
                        test="xsd:annotation/xsd:appinfo/*:OccurrenceCategory/text()='Operationally Determined'">
                        <xsl:if test="not(not(*) and not(text()) and not(normalize-space()))">
                            <xsl:attribute name="minOccurs">
                                <xsl:text>0</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <xsl:element name="xsd:annotation">
                        <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
                        <xsl:apply-templates select="xsd:annotation/xsd:appinfo" mode="ref"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates select="*"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <!-- type references are converted to local with SimpleType naming convention after verifying that it isn't ComplexType.-->
    <xsl:template match="xsd:element[@type]">
        <!--Create complex or simple type reference to match with global type in GoE fields-->
        <xsl:variable name="typename">
            <xsl:choose>
                <xsl:when test="starts-with(@type,'f:')">
                    <xsl:value-of
                        select="substring-after(concat(substring(@type,0,string-length(@type)-3),'SimpleType'),'f:')"
                    />
                </xsl:when>
                <xsl:when test="starts-with(@type,'c:') ">
                    <xsl:value-of select="substring-after(@type,'c:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@type"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="$typename='FreeTextSimpleType'">
                        <xsl:text>field:FreeTextFieldSimpleType</xsl:text>
                    </xsl:when>
                    <xsl:when test="$goe_fields_xsd//xsd:complexType/@name=$typename">
                        <xsl:value-of select="concat('field:',$typename)"/>
                    </xsl:when>
                    <xsl:when test="$goe_fields_xsd//xsd:simpleType/@name=$typename">
                        <xsl:value-of select="concat('field:',$typename)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$typename"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!-- base references are converted to local with SimpleType or ComplexType naming convention.-->
    <xsl:template match="xsd:extension[@base]">
        <!--Create complex or simple type reference to match with global type in GoE fields-->
        <xsl:variable name="basename">
            <xsl:choose>
                <xsl:when test="starts-with(@base,'f:')">
                    <xsl:value-of
                        select="substring-after(concat(substring(@base,0,string-length(@base)-3),'SimpleType'),'f:')"
                    />
                </xsl:when>
                <xsl:when test="starts-with(@base,'c:') ">
                    <xsl:value-of select="substring-after(@base,'c:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@base"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="base">
                <xsl:choose>
                    <!--FreeTextSimpleType treated separately since -->
                    <xsl:when test="$basename='FreeTextSimpleType'">
                        <xsl:text>field:FreeTextFieldSimpleType</xsl:text>
                    </xsl:when>
                    <xsl:when test="$goe_fields_xsd//xsd:complexType/@name=$basename">
                        <xsl:value-of select="concat('field:',$basename)"/>
                    </xsl:when>
                    <xsl:when test="$goe_fields_xsd//xsd:simpleType/@name=$basename">
                        <xsl:value-of select="concat('field:',$basename)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$basename"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>

    <!--Copy annotation only if it has descendents with text content-->
    <xsl:template match="xsd:annotation">
        <xsl:if test="*//text()">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!--Copy documentation only if it has text content-->
    <xsl:template match="xsd:documentation">
        <xsl:if test="text()">
            <xsl:copy copy-namespaces="no">
                <xsl:apply-templates select="text()"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!--Copy element and use template mode to convert elements to attributes in SET element-->
    <xsl:template match="xsd:appinfo[starts-with(child::*[1]/name(),'Set')]">
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Set" namespace="urn:mtf:mil:6040b:sets">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <!--Copy element and use template mode to convert elements to attributes in FIELD element-->
    <xsl:template match="xsd:appinfo[starts-with(child::*[1]/name(),'Field')]">
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Field" namespace="urn:mtf:mil:6040b:sets">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xsd:appinfo" mode="ref">
        <xsl:copy copy-namespaces="no">
            <xsl:element name="Field" namespace="urn:mtf:mil:6040b:sets">
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*" mode="attr"/>
            </xsl:element>
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
        <xsl:if test="not(not(*) and not(text()) and not(normalize-space()))">
            <xsl:attribute name="{name()}">
                <xsl:value-of select="normalize-space(text()[1])"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!--replace FieldFormatPositionName with "name"-->
    <xsl:template match="*:FieldFormatPositionName" mode="attr">
        <xsl:if test="not(not(*) and not(text()) and not(normalize-space()))">
            <xsl:attribute name="name">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!--replace FieldFormatPositionNumber with "sequence"-->
    <xsl:template match="*:FieldFormatPositionNumber" mode="attr">
        <xsl:if test="not(not(*) and not(text()) and not(normalize-space()))">
            <xsl:attribute name="sequence">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!--replace AlphabeticIdentifier with "id"-->
    <xsl:template match="*:AlphabeticIdentifier" mode="attr">
        <xsl:if test="not(not(*) and not(text()) and not(normalize-space()))">
            <xsl:attribute name="id">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!--replace SetFormatIdentifier with "id"-->
    <xsl:template match="*:SetFormatIdentifier" mode="attr">
        <xsl:if test="not(not(*) and not(text()) and not(normalize-space()))">
            <xsl:attribute name="id">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!--replace SetFormatName with "name"-->
    <xsl:template match="*:SetFormatName" mode="attr">
        <xsl:if test="not(not(*) and not(text()) and not(normalize-space()))">
            <xsl:attribute name="name">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!--replace SetFormatExample with "example"-->
    <xsl:template match="*:SetFormatExample" mode="attr">
        <xsl:if test="not(not(*) and not(text()) and not(normalize-space()))">
            <xsl:attribute name="example">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!--Filter empty xsd:annotations-->
    <xsl:template match="xsd:restriction[@base='xsd:integer']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base='xsd:string']/xsd:annotation"/>
    <xsl:template match="xsd:restriction[@base='xsd:decimal']/xsd:annotation"/>

    <!--Filter unused elements-->
    <xsl:template match="*:SetFormatRelatedDocuments" mode="attr"/>
    <xsl:template match="*:SetFormatSponsor" mode="attr"/>
    <xsl:template match="*:FieldFormatRelatedDocument" mode="attr"/>
    <xsl:template match="*:FieldFormatDefinition" mode="attr"/>
    <!--<xsl:template match="*:VersionIndicator" mode="attr"/>-->
    <xsl:template match="*:AssignedFfirnFudUseDescription" mode="attr"/>

    <!--************************ MAKE GENTEXT RESTRICTABLE *********************-->
    <xsl:template match="xsd:complexType[@name='GeneralTextType']">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*"/>
            <!--Add set seq for restriction in context-->
            <xsd:attribute name="setSeq" type="xsd:unsignedShort"/>
            <xsd:attributeGroup ref="ism:SecurityAttributesOptionGroup"/>
        </xsl:copy>
        <xsl:element name="xsd:complexType">
            <xsl:attribute name="name"><xsl:text>set:GentextTextIndicatorType</xsl:text></xsl:attribute>
            <xsl:apply-templates select="xsd:sequence/xsd:element[@name='TextIndicator']/xsd:complexType/*"/>
        </xsl:element>
    </xsl:template>
    
    <!--<xsl:template match="xsd:element[@name='TextIndicator']//xsd:simpleContent/xsd:extension/xsd:annotation"/>-->
    
    <!--Assign TextIndicator to global complexType made from itself-->
    <xsl:template match="xsd:element[@name='TextIndicator']">
        <xsl:element name="xsd:element">
            <xsl:attribute name="name"><xsl:text>TextIndicator</xsl:text></xsl:attribute>
            <xsl:attribute name="type"><xsl:text>GentextTextIndicatorType</xsl:text></xsl:attribute>
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:element>
    </xsl:template>
    
    <!--   ***************************************************************************-->


</xsl:stylesheet>
