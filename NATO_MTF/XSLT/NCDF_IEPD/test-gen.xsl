<?xml version="1.0" encoding="UTF-8"?>
<!--
/* 
 * Copyright (C) 2019 JD NEUSHUL
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="refsrc" select="'../../XSD/NCDF_MTF/NCDF_MTF.xsd'"/>

    <xsl:variable name="tgtdir" select="'../../XSD/IEPD/xml/instance/'"/>

    <xsl:variable name="testdata" select="'../../XSD/IEPD/xml/instance/common/mtf-testdata.xml'"/>

    <xsl:variable name="xsddoc" select="document($refsrc)"/>

    <xsl:variable name="validValues">
        <value name="AdminOrganizationAUSTextSimpleType" pattern="AUS_[A-Za-z0-9_\-\.]{1,36}" validval="AUS_B_i-bLo6OcnA"/>
        <value name="AdminOrganizationCANTextSimpleType" pattern="CAN_[A-Za-z0-9_\-\.]{1,36}" validval="CAN_B_i-bWM9dnA"/>
        <value name="AdminOrganizationGBRTextSimpleType" pattern="GBR_[A-Za-z0-9_\-\.]{1,36}" validval="GBR_B_i-M9dq6OcnA"/>
        <value name="AdminOrganizationNZLTextSimpleType" pattern="NZL_[A-Za-z0-9_\-\.]{1,36}" validval="NZL_B_i-oWMcnA"/>
        <value name="DateTimeWithTimezoneSimpleType" pattern="\-?[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]+)?(Z|[\-\+][0-9]{2}:[0-9]{2})" validval="-7909-95-55T03:29:47Z"/>
        <value name="DateWithoutTimezoneSimpleType" pattern="\-?[0-9]{4}-[0-9]{2}-[0-9]{2}" validval="8129-67-66"/>
        <value name="DigitalIdentifierSimpleType" pattern="[\s]*\-(CN|cn)=[A-Za-z0-9 .]+(,[\s]*[a-z0-9 .]+=[A-Za-z0-9 .]+)*[\s]*" validval="CN-A1B.as4_Ipsum"/>
        <value name="DutyOrganizationUnitSimpleType" pattern="[\s]*\[A-Za-z0-9\-_]+(:[A-Za-z0-9\-_]+)*[\s]*" validval="AB-C1dLorem_Ipsum_Dolor_Sit"/>
        <value name="RoleNebulaItemSimpleType" pattern="Nebula-CIA\-[A-Za-z0-9_]{1,255}" validval="Nebula-CIA-VvqVgha_k6yC3MoCTwbwHygHKENy9pX"/>
        <value name="RolePAASItemSimpleType" pattern="PAAS(\-[A-Za-z0-9_]{1,255}){3}\-[A-Z0-9_]{1,64}" validval="PAAS-wCKkhZL72GznsReCL1gA64pHyIU"/>
        <value name="UIASC2SFunctionTextSimpleType" pattern="[A-Z0-9_]{1,64}" validval="1 Lorem ipsum dolor sit amet, consectetur"/>
        <value name="VIRTNetworkNameTextSimpleType" pattern="other:\S{1,256}" validval="other: Lorem ipsum dolor sit amet consectetur"/>
        <value name="RoleC2SItemSimpleType" pattern="C2S(\-[A-Za-z0-9_]{1,255}){3}\-[A-Z0-9_]{1,64}" validval="C2S-A1B-Lorem_Ipsum_Dolor_Sit"/>
        <value name="TDFSignatureAlgorithmSimpleType" validval="SHA256withRSA"/>
    </xsl:variable>

    <xsl:variable name="choices">
        <xsl:for-each select="distinct-values($xsddoc//@substitutionGroup)">
            <xsl:variable name="sg" select="."/>
            <xsl:variable name="sgc" select="$xsddoc/*/xs:element[@substitutionGroup=$sg][1]/@name"/>
            <xsl:element name="{$sg}">
                <xsl:attribute name="choice">
                    <xsl:value-of select="$sgc"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:call-template name="main"/>
    </xsl:template>

    <xsl:template name="main">
        <xsl:result-document href="{$testdata}">
            <TestData>
                <xsl:for-each select="$xsddoc/*/xs:simpleType">
                    <xsl:element name="{@name}">
                        <xsl:apply-templates select="."/>
                    </xsl:element>
                </xsl:for-each>
                <AnyURI>
                    <Test valid="true" value="good:URI"/>
                    <Test valid="false" value="bad/URI"/>
                </AnyURI>
                <String>
                    <Test valid="true" value="Lorem ipsum dolor"/>
                    <Test valid="false" value="Lorem ipsum dolor"/>
                </String>
                <Boolean>
                    <Test valid="true" value="true"/>
                    <Test valid="false" value="maybe"/>
                </Boolean>
                <ChoiceSelections>
                    <xsl:for-each select="$choices/*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </ChoiceSelections>
            </TestData>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="xs:simpleType">
        <xsl:variable name="maxlen" select=".//xs:maxLength/@value"/>
        <xsl:variable name="minlen" select=".//xs:minLength/@value"/>
        <xsl:variable name="pattern" select=".//xs:pattern/@value"/>
        <xsl:variable name="bool" select=".//xs:restriction[@base = 'xs:boolean']/@base"/>
        <xsl:variable name="dateTime" select=".//xs:restriction[@base = 'xs:dateTime']/@base"/>
        <xsl:variable name="date" select=".//xs:restriction[@base = 'xs:date']/@base"/>
        <xsl:variable name="anyuri" select=".//xs:restriction[@base = 'xs:anyURI']/@base"/>
        <xsl:variable name="string" select=".//xs:restriction[@base = 'xs:string']/@base"/>
        <xsl:variable name="integer" select=".//xs:restriction[@base = 'xs:integer']/@base"/>
        <xsl:variable name="nmtoken" select=".//xs:restriction[@base = 'xs:NMTOKEN']/@base"/>
        <xsl:variable name="nmtokens" select=".//xs:restriction[@base = 'xs:NMTOKENS']/@base"/>
        <xsl:variable name="base64" select=".//xs:restriction[@base = 'xs:base64Binary']/@base"/>
        <xsl:variable name="idrefs" select=".//xs:restriction[@base = 'xs:IDREFS']/@base"/>
        <xsl:variable name="memberTypes" select=".//xs:union/@memberTypes"/>
        <xsl:variable name="listType" select=".//xs:list/@itemType"/>
        <xsl:variable name="enumerations">
            <xsl:for-each select=".//xs:restriction/xs:enumeration">
                <Enum value="{@value}"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="enumcount" select="count($enumerations/*)"/>
        <xsl:variable name="enumpick" select="$enumerations/Enum[ceiling(count($enumerations/*) div 2)]/@value"/>
        <xsl:variable name="simplebasetype" select="xs:restriction/@base[not(contains(.,':'))]"/>
        <xsl:if test="$maxlen">
            <xsl:attribute name="maxlen">
                <xsl:value-of select="$maxlen"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$minlen">
            <xsl:attribute name="minlen">
                <xsl:value-of select="$minlen"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$pattern">
            <xsl:attribute name="pattern">
                <xsl:value-of select="$pattern"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$bool">
            <xsl:attribute name="bool">
                <xsl:value-of select="$bool"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$dateTime">
            <xsl:attribute name="dateTime">
                <xsl:value-of select="$dateTime"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$date">
            <xsl:attribute name="date">
                <xsl:value-of select="$date"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$anyuri">
            <xsl:attribute name="anyuri">
                <xsl:value-of select="$anyuri"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$memberTypes">
            <xsl:attribute name="memberTypes">
                <xsl:value-of select="$memberTypes"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$listType">
            <xsl:attribute name="listType">
                <xsl:value-of select="$listType"/>
            </xsl:attribute>
            <xsl:variable name="list">
                <List parent="{@name}">
                    <xsl:apply-templates select="$xsddoc/*/xs:simpleType[@name = $listType]"/>
                </List>
            </xsl:variable>
            <xsl:copy-of select="$list"/>
        </xsl:if>
        <xsl:if test="$simplebasetype">
            <xsl:attribute name="simpleType">
                <xsl:value-of select="$simplebasetype"/>
            </xsl:attribute>
            <xsl:apply-templates select="$xsddoc/*/xs:simpleType[@name = $simplebasetype]"/>
        </xsl:if>
        <xsl:if test="$enumerations/*">
            <Enumerations count="{$enumcount}" pick="{$enumpick}"/>
        </xsl:if>
        <xsl:variable name="mtypes">
            <xsl:for-each select="tokenize($memberTypes, ' ')">
                <xsl:variable name="n" select="."/>
                <MemberType parent="{$n}">
                    <xsl:apply-templates select="$xsddoc/*/xs:simpleType[@name = $n]"/>
                </MemberType>
            </xsl:for-each>
        </xsl:variable>
        <xsl:copy-of select="$mtypes"/>
        <!--TESTS-->
        <xsl:if test="$base64">
            <Test valid="true" value="YmFzZTY0QmluYXJ5"/>
            <Test valid="false" value="0.5"/>
        </xsl:if>
        <xsl:if test="$idrefs">
            <Test valid="true" value="IDRef1 IDRef2 IDRef3"/>
            <Test valid="false" value="0.5"/>
        </xsl:if>
        <xsl:if test="$anyuri">
            <Test valid="true" value="good:URI"/>
            <Test valid="false" value="bad/URI"/>
        </xsl:if>
        <xsl:if test="$string and not($enumerations/*)">
            <Test valid="true" value="Lorem ipsum dolor"/>
            <Test valid="false" value=""/>
        </xsl:if>
        <xsl:if test="$integer">
            <Test valid="true" value="52"/>
            <Test valid="false" value="2.5"/>
        </xsl:if>
        <xsl:if test="$nmtokens">
            <Test valid="true" value="NameToken1 NameToken2 NameToken3"/>
            <Test valid="false" value="This, and that"/>
        </xsl:if>
        <xsl:if test="$nmtoken">
            <Test valid="true" value="NameToken"/>
            <Test valid="false" value="This,"/>
        </xsl:if>
        <xsl:if test="ends-with(@name,'CodeTextSimpleType')">
            <Test valid="true" value="TextCode"/>
            <Test valid="false" value="123"/>           
        </xsl:if>
        <xsl:if test="$pattern">
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="pv" select="$validValues/*[@name = $n]/@validval"/>
            <Test valid="true" value="{$pv}"/>
            <Test valid="false" value="X{$pv}X"/>
        </xsl:if>
        <xsl:if test="$mtypes/*[@pattern]">
            <xsl:for-each select="$mtypes/*[@pattern]">
                <xsl:variable name="p" select="@parent"/>
                <xsl:variable name="pv" select="$validValues/*[@name = $p]/@validval"/>
                <Test valid="true" value="{$pv}"/>
                <Test valid="false" value="X{$pv}X"/>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$enumerations/Enum">
            <xsl:for-each select="$enumerations/Enum">
                <Test valid="true" value="{@value}"/>
            </xsl:for-each>
            <Test valid="false" value="X{$enumerations/Enum[1]/@value}X"/>
        </xsl:if>
        <xsl:if test="$mtypes/*[@enumpick]">
            <Test valid="true" value="{$mtypes/*[@enumpick]}"/>
            <Test valid="false" value="X{$mtypes/*[@enumpick]}X"/>
        </xsl:if>
        <xsl:if test="$maxlen">
            <Test valid="true" value="{substring($longtext,0,ceiling($maxlen div 2))}"/>
            <Test valid="false" value="{substring($longtext,0,$maxlen +2)}"/>
        </xsl:if>
        <xsl:if test="$mtypes/*[@maxlen]">
            <Test valid="true" value="{substring($longtext,0,ceiling($mtypes/*[@maxlen] div 2))}"/>
            <Test valid="false" value="{substring($longtext,0,$mtypes/*[@maxlen] +2)}"/>
        </xsl:if>
        <xsl:if test="$minlen">
            <Test valid="true" value="{substring($longtext,0,$minlen)}"/>
            <Test valid="false" value="{substring($longtext,0,$minlen -1)}"/>
        </xsl:if>
        <xsl:if test="$mtypes/*[@minlen]">
            <Test valid="true" value="{substring($longtext,0,$mtypes/*[@minlen])}"/>
            <Test valid="false" value="{substring($longtext,0,$mtypes/*[@minlen] -1)}"/>
        </xsl:if>
        <xsl:if test="$bool">
            <Test valid="true" value="true"/>
            <Test valid="true" value="false"/>
            <Test valid="false" value="maybe"/>
        </xsl:if>
        <xsl:if test="$mtypes/*[@bool]">
            <Test valid="true" value="true"/>
            <Test valid="true" value="false"/>
            <Test valid="false" value="maybe"/>
        </xsl:if>
        <xsl:if test="$date">
            <Test valid="true" value="2018-09-24"/>
            <Test valid="false" value="Tuesday at 4"/>
        </xsl:if>
        <xsl:if test="$mtypes/*[@date]">
            <Test valid="true" value="2018-09-24"/>
            <Test valid="false" value="Tuesday at 4"/>
        </xsl:if>
        <xsl:if test="$dateTime">
            <Test valid="true" value="2018-05-30T09:00:00"/>
            <Test valid="false" value="Tuesday at 4"/>
        </xsl:if>
        <xsl:if test="$mtypes/*[@dateTime]">
            <Test valid="true" value="2018-05-30T09:00:00"/>
            <Test valid="false" value="tomrrow"/>
        </xsl:if>
    </xsl:template>

    <xsl:variable name="longtext">
        <xsl:text>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</xsl:text>
    </xsl:variable>

</xsl:stylesheet>
