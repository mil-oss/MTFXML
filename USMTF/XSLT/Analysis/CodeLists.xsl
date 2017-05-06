<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>


    <xsl:variable name="fields_xsd" select="document('../../XSD/Baseline_Schema/fields.xsd')"/>
    <xsl:variable name="enumerations_xsd" select="$fields_xsd/xsd:schema/xsd:simpleType[xsd:restriction[@base = 'xsd:string'][xsd:enumeration]]"/>
    <xsl:variable name="normenumerationtypes" select="document('../../XSD/Normalized/NormalizedSimpleTypes.xsd')/*/xsd:simpleType[xsd:restriction/xsd:enumeration]"/>

    <xsl:variable name="codelists">
        <xsl:for-each select="$enumerations_xsd">
            <xsl:sort select="@name"/>
            <CodeList name="{@name}">
                <Codes>
                    <xsl:for-each select="xsd:restriction/xsd:enumeration">
                        <xsl:sort select="@value"/>
                        <Code value="{@value}" dataItem="{xsd:annotation/xsd:appinfo/*:DataItem}" doc="{normalize-space(xsd:annotation/xsd:documentation/text())}"/>
                    </xsl:for-each>
                </Codes>
            </CodeList>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="normcodelists">
        <xsl:for-each select="$enumerations_xsd">
            <xsl:sort select="@name"/>
            <xsl:variable name="normcodes">
                <Codes>
                    <xsl:for-each select="xsd:restriction/xsd:enumeration">
                        <xsl:sort select="@value"/>
                        <Code value="{@value}" dataItem="{xsd:annotation/xsd:appinfo/*:DataItem}" doc="{normalize-space(xsd:annotation/xsd:documentation/text())}"/>
                    </xsl:for-each>
                </Codes>
            </xsl:variable>
            <CodeList name="{@name}">
                <xsl:copy-of select="$normcodes"/>
                <UsedBy>
                    <xsl:for-each select="$codelists/*">
                        <xsl:if test="deep-equal(Codes, $normcodes/Codes)">
                            <xsl:copy>
                                <xsl:copy-of select="@name"/>
                            </xsl:copy>
                        </xsl:if>
                    </xsl:for-each>
                </UsedBy>
            </CodeList>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="multipleuses">
        <xsl:for-each select="$normcodelists/*">
            <xsl:sort select="count(*:UsedBy/CodeList)"/>
            <xsl:if test="count(*:UsedBy/CodeList) &gt; 1">
                <xsl:copy>
                    <xsl:attribute name="count" select="count(*:UsedBy/CodeList)"/>
                    <xsl:copy-of select="@name"/>
                    <xsl:copy-of select="*:Codes"/>
                    <xsl:copy-of select="*:UsedBy"/>
                </xsl:copy>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="singlecodes">
        <xsl:for-each select="$normcodelists/*">
            <xsl:if test="count(*:Codes/Code) = 1">
                <xsl:copy>
                    <xsl:attribute name="count" select="count(*:UsedBy/CodeList)"/>
                    <xsl:copy-of select="@name"/>
                    <xsl:copy-of select="*:Codes"/>
                    <xsl:copy-of select="*:UsedBy"/>
                </xsl:copy>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="CLists">
        <CodeLists>
            <USMTF count="{count($enumerations_xsd)}">
                <!--<xsl:copy-of select="$codelists"/>-->
                <xsl:copy-of select="$normcodelists"/>
            </USMTF>
            <MultipleUses count="{count($multipleuses/*)}">
                <xsl:copy-of select="$multipleuses"/>
            </MultipleUses>
            <SingleCodes count="{count($singlecodes/*)}">
                <xsl:copy-of select="$singlecodes"/>
            </SingleCodes>
        </CodeLists>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="../../XSD/Analysis/CodeLists.xml">
            <xsl:copy-of select="$CLists"/>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
