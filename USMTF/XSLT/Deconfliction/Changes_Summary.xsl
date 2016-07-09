<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="set_Changes" select="document('../../XSD/Deconflicted/Set_Name_Changes.xml')/USMTF_Sets"/>
    <xsl:variable name="segment_Changes" select="document('../../XSD/Deconflicted/Segment_Name_Changes.xml')/USMTF_Segments"/>
    <xsl:variable name="set_field_Changes" select="document('../../XSD/Deconflicted/Set_Field_Name_Changes.xml')/SetElements"/>
    <xsl:variable name="string_type_changes" select="document('../../XSD/Normalized/StringTypeChanges.xml')/StringChanges"/>
    <xsl:variable name="enumeration_type_changes" select="document('../../XSD/Normalized/EnumerationTypeChanges.xml')/EnumerationChanges"/>

    <xsl:variable name="output" select="'../../XSD/Refactor_Node_Changes/USMTFChanges.xml'"/>

    <xsl:variable name="field_chg">
        <xsl:for-each select="$string_type_changes/Change">
            <Field type="{@name}" changeto="{@changeto}"/>
        </xsl:for-each>
        <xsl:for-each select="$enumeration_type_changes/Change">
            <Field type="{@name}" changeto="{@changeto}"/>
        </xsl:for-each>
        <Field type="_2DigitYearType" changeto="TwoDigitYearType"/>
    </xsl:variable>
    <xsl:variable name="sets_chg">
        <xsl:for-each select="$set_Changes/Set">
            <xsl:sort select="@name"/>
            <xsl:variable name="proposed_name">
                <xsl:value-of select="concat(translate(@ProposedSetFormatName, ' .,/-()', ''), 'Set')"/>
            </xsl:variable>
            <Set name="{@ElementName}" msgid="{@MSGNAMESHORT}" setid="{@SETNAMESHORT}" changeto="{$proposed_name}">
                <xsl:apply-templates select="@ProposedSetFormatPositionName[string-length(.)&gt;0]"/>
                <xsl:apply-templates select="@ProposedSetFormatPositionConceptChanges[string-length(.)&gt;0]"/>
                <xsl:apply-templates select="@ProposedSetFormatDescription[string-length(.)&gt;0]"/>
            </Set>
        </xsl:for-each>
        <xsl:for-each select="$set_field_Changes/Element">
            <Field name="{@name}" type="{@type}" changeto="@changeto"/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="segments_chg">
        <xsl:for-each select="$segment_Changes/Segment">
            <xsl:variable name="proposed_name">
                <xsl:value-of select="concat(translate(@ProposedSegmentName, ' .,/-()', ''),'Segment')"/>
            </xsl:variable>
            <Segment name="{@SegmentElement}" msgid="{@MSGIDENTIFIER}" changeto="{$proposed_name}"/>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="@ProposedSetFormatPositionName">
        <xsl:attribute name="positonName">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@ProposedSetFormatPositionConceptChanges">
        <xsl:attribute name="concept">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="@ProposedSetFormatDescription">
        <xsl:attribute name="description">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="main">
        <xsl:result-document href="{$output}">
            <USMTF_Name_Changes>
                <Fields>
                    <xsl:for-each select="$field_chg/*">
                        <xsl:sort select="@type"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </Fields>
                <Sets>
                    <xsl:for-each select="$sets_chg/Set">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="s" select="."/>
                        <xsl:choose>
                            <xsl:when test="deep-equal(preceding-sibling::Set[1],$s)"/>
                            <xsl:otherwise>
                                <xsl:copy-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select="$sets_chg/Field">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </Sets>
                <Segments>
                    <xsl:for-each select="$segments_chg/Segment">
                        <xsl:sort select="@name"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </Segments>
            </USMTF_Name_Changes>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
