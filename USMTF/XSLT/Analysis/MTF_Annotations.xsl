<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="../NIEM_USMTF/USMTF_Utility.xsl"/>

    <xsl:variable name="mtfmsgs" select="document('../../XSD/Baseline_Schema/messages.xsd')"/>
    <xsl:variable name="currentrules" select="'../../XSD/NIEM_MTF/Mtf_Rules.xsd'"/>
    <xsl:variable name="mtfmsgrules" select="'../../XSD/NIEM_MTF/Msg_Rules.xml'"/>
    <xsl:variable name="schematron" select="'../../XSD/NIEM_MTF/NIEM_MTF.sch'"/>
    <xsl:variable name="mtfmsgmap" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Messagemaps.xml')/Messages"/>
    <xsl:variable name="mtfsegmap" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Segmentmaps.xml')/Segments"/>
    <xsl:variable name="mtfsetmap" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Setmaps.xml')/Sets"/>
    <xsl:variable name="mtfcompmap" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Compositemaps.xml')/Composites"/>
    <xsl:variable name="mtffieldmap" select="document('../../XSD/NIEM_MTF/NIEM_MTF_Fieldmaps.xml')/Fields"/>

    <xsl:variable name="rules">
        <xsl:for-each select="document($currentrules)/xsd:schema/xsd:element">
            <xsl:sort select="@name"/>
            <MsgRules msgname="{@name}" niemname="{concat(@name,'Message')}">
                <xsl:apply-templates select="xsd:annotation/xsd:appinfo/*[name() = 'MtfStructuralRelationship']" mode="rules"/>
            </MsgRules>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="apos">
        <xsl:text>&apos;</xsl:text>
    </xsl:variable>

    <xsl:variable name="stron">
        <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <sch:pattern>
                <!-- Context-->
                <xsl:for-each select="$rules/*:MsgRules">
                    <sch:rule context="{@niemname}">
                        <xsl:for-each select="MsgRule">
                            <xsl:choose>
                                <xsl:when test="rule/rulepart[1]/@fname = 'MessageTextFormatIdentifier'">
                                    <sch:assert test="{concat('MessageIdentifierSet/MessageTextFormatIdentifier=',$apos,rule/rulepart[3]/@fixedvalue),$apos}">
                                        <xsl:value-of select="concat('Field 1 in MSGID (Set 3) is assigned the value ', $apos, rule/rulepart[3]/@fixedvalue, $apos, '.')"/>
                                    </sch:assert>
                                </xsl:when>
                                <xsl:when test="rule/rulepart[1]/@fname = 'StandardOfMessageTextFormat'">
                                    <sch:assert test="{concat('MessageIdentifierSet/StandardOfMessageTextFormat=',$apos,rule/rulepart[3]/@fixedvalue),$apos}">
                                        <xsl:value-of select="concat('Field 2 in MSGID (Set 3) is assigned the value ', $apos, rule/rulepart[3]/@fixedvalue, $apos, '.')"/>
                                    </sch:assert>
                                </xsl:when>
                                <xsl:when test="rule/rulepart[1]/@fname = 'VersionOfMessageTextFormat'">
                                    <sch:assert test="{concat('MessageIdentifierSet/VersionOfMessageTextFormat=',$apos,rule/rulepart[3]/@fixedvalue),$apos}">
                                        <xsl:value-of select="concat('Field 3 in MSGID (Set 3) is assigned the value ', $apos, rule/rulepart[3]/@fixedvalue, $apos, '.')"/>
                                    </sch:assert>
                                </xsl:when>
                                <xsl:when test="rule/rulepart[1]/@fname = 'TitleOfDocument'">
                                    <sch:assert test="exists(ReferenceSet/TitleOfDocument) and ReferenceSet/CommunicationTypeCode = 'CHT' or ReferenceSet/CommunicationTypeCode = 'DOC'">
                                        <xsl:text>Field 3 in REF (Set 4) is required if Field 2 in the same REF (Set 4) lexicographically equals 'CHT' or 'DOC'.</xsl:text>
                                    </sch:assert>
                                </xsl:when>
                                <xsl:when test="rule/rulepart[3]/@sname = 'MessageIdentifierSet'">
                                    <sch:assert
                                        test="not(exists(MessageDowngradingOrDeclassificationDataSet)) or exists(MessageDowngradingOrDeclassificationDataSet) and exists(MessageIdentifierSet/MessageSecurityClassificationExtended)">
                                        <xsl:text>DECL Set is required if Field 10 in MSGID (SET 3) lexicographically equals 'CONFIDENTIAL' or 'SECRET' or 'TOP SECRET' or 'RESTRICTED' or 'NATO RESTRICTED' or 'NATO CONFIDENTIAL' or 'NATO SECRET' or 'NATO SECRET-SAVATE' or 'NATO SECRET-AVICULA' or 'COSMIC TOP SECRET' or 'COSMIC TOP SECRET-BOHEMIA' or 'COSMIC TOP SECRET-BALK' or 'COSMIC TOP SECRET ATOMAL' or 'NATO SECRET ATOMAL' or 'NATO CONFIDENTIAL ATOMAL' otherwise it is prohibited.</xsl:text>
                                    </sch:assert>
                                </xsl:when>
                                <xsl:when test="rule/rulepart[5]/@fieldused = 'OriginalClassificationAuthorityText'">
                                    <sch:assert
                                        test="not(exists(MessageDowngradingOrDeclassificationDataSet)) or exists(MessageDowngradingOrDeclassificationDataSet/ReasonForClassification) and exists(MessageDowngradingOrDeclassificationDataSet/OriginalClassificationAuthorityText)">
                                        <xsl:text>Field 2 in DECL Set is required if Field 1 in DECL Set uses alternative ORIGINAL CLASSIFICATION AUTHORITY (FF679-4) otherwise it is prohibited.</xsl:text>
                                    </sch:assert>
                                </xsl:when>
                                <xsl:otherwise>
                                        <sch:assert test=".">
                                            <xsl:value-of select="@explanation"/>
                                        </sch:assert>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </sch:rule>
                </xsl:for-each>
            </sch:pattern>
        </sch:schema>
    </xsl:variable>

    <xsl:template name="main">
        <xsl:result-document href="{$mtfmsgrules}">
            <MTFRules>
                <xsl:for-each select="$rules/*">
                    <xsl:copy>
                        <xsl:copy-of select="@msgname"/>
                        <xsl:copy-of select="@niemname"/>
                        <xsl:for-each select="MsgRule">
                            <!--<xsl:copy-of select="."/>-->
                            <xsl:choose>
                                <xsl:when test="rule/rulepart[1]/@fname = 'MessageTextFormatIdentifier'"/>
                                <xsl:when test="rule/rulepart[1]/@fname = 'StandardOfMessageTextFormat'"/>
                                <xsl:when test="rule/rulepart[1]/@fname = 'VersionOfMessageTextFormat'"/>
                                <xsl:when test="rule/rulepart[1]/@fname = 'TitleOfDocument'"/>
                                <xsl:when test="rule/rulepart[3]/@sname = 'MessageIdentifierSet'"/>
                                <xsl:when test="rule/rulepart[5]/@fieldused = 'OriginalClassificationAuthorityText'"/>
                                <xsl:otherwise>
                                    <xsl:copy-of select="."/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:copy>
                </xsl:for-each>
            </MTFRules>
        </xsl:result-document>
        <xsl:result-document href="{$schematron}">
            <xsl:copy-of select="$stron"/>
        </xsl:result-document>
        <!--<xsl:result-document href="{$currentrules}">
            <xsd:schema xml:lang="en-US" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="urn:mtf:mil:6040b:goe:mtf" targetNamespace="urn:mtf:mil:6040b:goe:mtf" elementFormDefault="unqualified"
                attributeFormDefault="unqualified">
                <xsl:for-each select="$mtfmsgs/xsd:schema/xsd:element">
                    <xsl:copy>
                        <xsl:copy-of select="@name"/>
                        <xsd:annotation>
                            <xsd:appinfo>
                                <xsl:copy-of select="xsd:annotation/xsd:appinfo/*[name() = 'MtfStructuralRelationship']"/>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsl:copy>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>-->
    </xsl:template>

    <xsl:template match="*[name() = 'MtfStructuralRelationship']" mode="rules">
        <xsl:variable name="message" select="ancestor::xsd:element"/>
        <xsl:variable name="msgmap">
            <xsl:copy-of select="$mtfmsgmap/Message[@mtfname = $message/@name]"/>
        </xsl:variable>
        <xsl:variable name="structStr">
            <xsl:value-of select="*:MtfStructuralRelationshipRule/text()"/>
        </xsl:variable>
        <xsl:variable name="structExpl">
            <xsl:value-of select="normalize-space(lower-case(*:MtfStructuralRelationshipExplanation/text()))"/>
        </xsl:variable>
        <xsl:variable name="ruleparts">
            <ruleparts msg="{$message/@name}">
                <xsl:for-each select="tokenize($structStr, ' ')">
                    <!--SET OR SEGMENT NUMBER-->
                    <xsl:variable name="snumbervar">
                        <xsl:choose>
                            <xsl:when test="contains(., 'S]')">
                                <xsl:value-of select="substring-after(substring-before(., 'S]'), '[')"/>
                            </xsl:when>
                            <xsl:when test="contains(., '[')">
                                <xsl:value-of select="substring-after(substring-before(., ']'), '[')"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <!--SET OR SEGMENT NAME-->
                    <xsl:variable name="mtfsname">
                        <xsl:value-of select="substring-after($msgmap/*/*:Sequence/*:Element[@seq = $snumbervar]/@mtftype, ':')"/>
                    </xsl:variable>
                    <xsl:variable name="snamevar">
                        <xsl:value-of select="$msgmap/*/*:Sequence//*:Element[@seq = $snumbervar]/@niemelementname"/>
                    </xsl:variable>
                    <xsl:variable name="segmap">
                        <xsl:copy-of select="$mtfsegmap/*/Segment[@mtfname = $mtfsname]"/>
                    </xsl:variable>
                    <xsl:variable name="setmap">
                        <xsl:copy-of select="$mtfsetmap/*/Set[@mtfname = $mtfsname]"/>
                    </xsl:variable>
                    <!--FIELD NUMBER-->
                    <xsl:variable name="fnumbervar">
                        <xsl:choose>
                            <xsl:when test="contains(., 'G,ZF')">
                                <xsl:value-of select="substring-after(., 'G,ZF')"/>
                            </xsl:when>
                            <xsl:when test="contains(., ']FG,NF')">
                                <xsl:value-of select="substring-after(., ']FG,NF')"/>
                            </xsl:when>
                            <xsl:when test="contains(., '],NF')">
                                <xsl:value-of select="substring-after(., '],NF')"/>
                            </xsl:when>
                            <xsl:when test="contains(., 'AF')">
                                <xsl:value-of select="substring-after(., ',AF')"/>
                            </xsl:when>
                            <xsl:when test="contains(., ']F')">
                                <xsl:value-of select="substring-after(., ']F')"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <!--FIELD NAME-->
                    <xsl:variable name="fnamevar">
                        <xsl:choose>
                            <xsl:when test="$segmap/*/*:Sequence/*:Element[@seq = $fnumbervar]/@substgrpname">
                                <xsl:value-of select="$segmap/*/*:Sequence/*:Element[@seq = $fnumbervar]/@substgrpname"/>
                            </xsl:when>
                            <xsl:when test="$setmap/*/*:Sequence/*:Element[@seq = $fnumbervar]/@substgrpname">
                                <xsl:value-of select="$setmap/*/*:Sequence/*:Element[@seq = $fnumbervar]/@substgrpname"/>
                            </xsl:when>
                            <xsl:when test="$segmap/*/*:Sequence/*:Element[@seq = $fnumbervar]/@niemelementname">
                                <xsl:value-of select="$setmap/*/*:Sequence/*:Element[@seq = $fnumbervar]/@niemelementname"/>
                            </xsl:when>
                            <xsl:when test="$setmap/*/*:Sequence/*:Element[@seq = $fnumbervar]/@niemelementname">
                                <xsl:value-of select="$setmap/*/*:Sequence/*:Element[@seq = $fnumbervar]/@niemelementname"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="xpathvar">
                        <xsl:if test="string-length($fnamevar) &gt; 0">
                            <xsl:value-of select="concat($snamevar, '/', $fnamevar)"/>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="fixedvaluevar">
                        <xsl:if test="contains(., '/')">
                            <xsl:value-of select="substring-before(substring-after(., '/'), '/')"/>
                        </xsl:if>
                    </xsl:variable>
                   <xsl:variable name="conditionvar">
                        <xsl:if test="contains(., '(')">
                            <xsl:value-of select="substring-before(substring-after(., '('), ')')"/>
                        </xsl:if>
                    </xsl:variable>
                    <!--FIELD USED-->
                    <xsl:variable name="fieldusedvar">
                        <xsl:choose>
                            <xsl:when test="contains(., 'FFF')"/>
                            <xsl:when test="contains(., 'FF')">
                                <xsl:variable name="ffirnvar">
                                    <xsl:value-of select="translate(substring-before(substring-after(., 'FF'), '-'), '()', '')"/>
                                </xsl:variable>
                                <xsl:variable name="fudvar">
                                    <xsl:value-of select="translate(substring-after(substring-after(., 'FF'), '-'), '()', '')"/>
                                </xsl:variable>
                                <xsl:value-of select="$mtffieldmap/*[@ffirn = $ffirnvar][@fud = $fudvar]/@niemelementname"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:element name="rulepart">
                        <xsl:attribute name="str">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                        <xsl:if test="string-length($snumbervar) &gt; 0">
                            <xsl:attribute name="snumber">
                                <xsl:value-of select="$snumbervar"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($snamevar) &gt; 0">
                            <xsl:attribute name="sname">
                                <xsl:value-of select="$snamevar"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($fnumbervar) &gt; 0">
                            <xsl:attribute name="fnumber">
                                <xsl:value-of select="$fnumbervar"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($fnamevar) &gt; 0">
                            <xsl:attribute name="fname">
                                <xsl:value-of select="$fnamevar"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($xpathvar) &gt; 0">
                            <xsl:attribute name="xpath">
                                <xsl:value-of select="$xpathvar"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($fixedvaluevar) &gt; 0">
                            <xsl:attribute name="fixedvalue">
                                <xsl:value-of select="$fixedvaluevar"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($conditionvar) &gt; 0">
                            <xsl:attribute name="condition">
                                <xsl:value-of select="$conditionvar"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="string-length($fieldusedvar) &gt; 0">
                            <xsl:attribute name="fieldused">
                                <xsl:value-of select="$fieldusedvar"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:element>
                    <!--FIELD USED-->

                </xsl:for-each>
            </ruleparts>
        </xsl:variable>
        <xsl:variable name="rule">
            <rule msg="{$message/@name}">
                <xsl:for-each select="$ruleparts/*/rulepart">
                    <xsl:copy>
                        <xsl:copy-of select="@str"/>
                        <xsl:copy-of select="@snumber"/>
                        <xsl:copy-of select="@sname"/>
                        <xsl:copy-of select="@fnumber"/>
                        <xsl:copy-of select="@fname"/>
                        <xsl:copy-of select="@xpath"/>
                        <xsl:copy-of select="@fixedvalue"/>
                        <xsl:copy-of select="@condition"/>
                        <xsl:copy-of select="@fieldused"/>
                    </xsl:copy>
                </xsl:for-each>
            </rule>
        </xsl:variable>
        <xsl:element name="MsgRule">
            <xsl:apply-templates select="*[string-length(text()[1]) > 0]" mode="trimattr"/>
            <xsl:copy-of select="$rule"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*" mode="trimattr">
        <xsl:variable name="apos">&#39;</xsl:variable>
        <xsl:variable name="quot">&#34;</xsl:variable>
        <xsl:variable name="nm" select="lower-case(substring-after(name(), 'MtfStructuralRelationship'))"/>
        <xsl:choose>
            <xsl:when test="$nm = 'rule'">
                <xsl:attribute name="structure">
                    <xsl:value-of select="normalize-space(translate(replace(., $quot, $apos), '&#xA;', ''))" disable-output-escaping="yes"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="{$nm}">
                    <xsl:value-of select="normalize-space(translate(replace(., $quot, $apos), '&#xA;', ''))" disable-output-escaping="yes"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*:MtfStructuralRelationshipXsnRule" mode="trimattr"/>

</xsl:stylesheet>
