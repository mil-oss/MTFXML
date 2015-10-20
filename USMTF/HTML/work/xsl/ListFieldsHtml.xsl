<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="html" indent="yes"/>
    

    <xsl:param name="baselineFieldsPath" select="'../../XSD/Baseline_Schemas/fields.xsd'"/>
    <xsl:param name="baselineCompPath" select="'../../XSD/Baseline_Schemas/composites.xsd'"/>
    <xsl:param name="baselineSetsPath" select="'../../XSD/Baseline_Schemas/sets.xsd'"/>
    <xsl:param name="baselineMsgPath" select="'../../XSD/Baseline_Schemas/messages.xsd'"/>
    
    <xsl:variable name="baselineFields" select="document($baselineFieldsPath)"/>
    <xsl:variable name="baselineComp" select="document($baselineCompPath)"/>
    <xsl:variable name="baselineSets" select="document($baselineSetsPath)"/>
    <xsl:variable name="baselineMsg" select="document($baselineMsgPath)"/>

    <xsl:template match="/">
        <div id="fieldtree" class="divcol">
            <h3>Messages</h3>
            <div  id="msglinks" class="scrollcol">
                <xsl:apply-templates select="$baselineMsg/xsd:schema/xsd:element" mode="msg">
                    <xsl:sort select="xsd:annotation/xsd:appinfo/*:MtfName"/>
                </xsl:apply-templates>
            </div>
            <h3>Sets</h3>
            <div id="setlinks" class="scrollcol">
                <xsl:variable name="sets">
                    <xsl:apply-templates select="$baselineSets/xsd:schema/xsd:complexType" mode="set"/>
                </xsl:variable>
                <xsl:apply-templates select="$sets/p" mode="psort">
                    <xsl:sort select="span"/>
                </xsl:apply-templates>
            </div>
            <h3>Composite Fields</h3>
            <div id="compositelinks" class="scrollcol">
                <xsl:variable name="complx">
                    <xsl:apply-templates select="$baselineComp/xsd:schema/xsd:simpleType" mode="composites"/>
                    <xsl:apply-templates select="$baselineComp/xsd:schema/xsd:complexType" mode="composites"/>
                </xsl:variable>
                <xsl:apply-templates select="$complx/p" mode="psort">
                    <xsl:sort select="span"/>
                </xsl:apply-templates>
            </div>
            <h3>Elemental Fields</h3>
            <div id="fieldlinks" class="scrollcol">
                <xsl:variable name="flds">
                    <xsl:apply-templates select="$baselineFields/xsd:schema/xsd:simpleType" mode="fld"/>
                    <xsl:apply-templates select="$baselineFields/xsd:schema/xsd:complexType" mode="fld"/>
                </xsl:variable>
                <xsl:apply-templates select="$flds/p" mode="psort">
                    <xsl:sort select="span"/>
                </xsl:apply-templates>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:simpleType|xsd:schema/xsd:complexType" mode="fld">
        <p id="{concat('field_',@name)}">
            <span>
                <xsl:value-of select="xsd:annotation[1]/xsd:appinfo[1]/*:FudName[1]"/>
            </span> 
        </p>
    </xsl:template>
    <!--FreeTextBaseType has no FudName-->
    <xsl:template match="xsd:schema/xsd:simpleType[@name='FreeTextBaseType']" mode="fld">
        <p id="{concat('field_',@name)}">
            <span>
                <xsl:text>FREE TEXT BASE</xsl:text>
            </span> 
        </p>
    </xsl:template>
    <!--FreeText ComplexType has no FudName-->
    <xsl:template match="xsd:schema/xsd:complexType[@name='FreeTextType']" mode="fld">
        <p id="{concat('field_',@name)}">
            <span>
                <xsl:text>FREE TEXT</xsl:text>
            </span> 
        </p>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:simpleType|xsd:schema/xsd:complexType" mode="composites">
        <p id="{concat('comp_',@name)}">
            <span>
                <xsl:value-of select="xsd:annotation[1]/xsd:appinfo[1]/*:FudName[1]"/>
            </span> 
        </p>
    </xsl:template>
    
    <xsl:template match="xsd:schema/xsd:simpleType|xsd:schema/xsd:complexType[@name='AltitudeOrHeightInFeetHundredsOfFeetOrMetersAglOrAmslType']" mode="composites">
        <p id="{concat('comp_',@name)}">
            <span>
                <xsl:text>ALTITUDE OR HEIGHT IN FT, METERS, AGL, OR AMSL</xsl:text>
            </span> 
        </p>
    </xsl:template>
    
    <xsl:template match="xsd:schema/xsd:simpleType|xsd:schema/xsd:complexType[@name='AltitudeBandInFeetHundredsOfFeetOrMetersAglOrAmslType']" mode="composites">
        <p id="{concat('comp_',@name)}">
            <span>
                <xsl:text>ALTITUDE BAND IN FT, METERS, AGL, OR AMSL</xsl:text>
            </span> 
        </p>
    </xsl:template>
    
    <xsl:template match="xsd:schema/xsd:simpleType|xsd:schema/xsd:complexType[@name='RangeInFtMNmType']" mode="composites">
        <p id="{concat('comp_',@name)}">
            <span>
                <xsl:text>RANGE IN FT, METERS or NAUTICAL METERS</xsl:text>
            </span> 
        </p>
    </xsl:template>
    
    <xsl:template match="xsd:schema/xsd:simpleType|xsd:schema/xsd:complexType[@name='DayTimeType']" mode="composites">
        <p id="{concat('comp_',@name)}">
            <span>
                <xsl:text>DAY TIME</xsl:text>
            </span> 
        </p>
    </xsl:template>
    
    <xsl:template match="xsd:schema/xsd:simpleType|xsd:schema/xsd:complexType[@name='IdSetRangeType']" mode="composites">
        <p id="{concat('comp_',@name)}">
            <span>
                <xsl:text>ID SET RANGE</xsl:text>
            </span> 
        </p>
    </xsl:template>
    
    <xsl:template match="xsd:schema/xsd:simpleType|xsd:schema/xsd:complexType[@name='HfLink22HopSetType']" mode="composites">
        <p id="{concat('comp_',@name)}">
            <span>
                <xsl:text>HF LINK 22 HOP SET</xsl:text>
            </span> 
        </p>
    </xsl:template>
    
    <xsl:template match="xsd:schema/xsd:simpleType|xsd:schema/xsd:complexType[@name='Link22HopSetType']" mode="composites">
        <p id="{concat('comp_',@name)}">
            <span>
                <xsl:text>LINK 22 HOP SET</xsl:text>
            </span> 
        </p>
    </xsl:template>
    
    <xsl:template match="xsd:schema/xsd:simpleType|xsd:schema/xsd:complexType[@name='UhfLink22HopSetType']" mode="composites">
        <p id="{concat('comp_',@name)}">
            <span>
                <xsl:text>UHF LINK 22 HOP SET</xsl:text>
            </span> 
        </p>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:simpleType|xsd:schema/xsd:complexType" mode="set">
        <p id="{concat('set_',@name)}">
            <span>
                <xsl:value-of select="xsd:annotation[1]/xsd:appinfo[1]/*:SetFormatName[1]"/>
            </span>
        </p>
    </xsl:template>
    
    <!--FreeText SetBaseType has no FudName-->
    <xsl:template match="xsd:schema/xsd:complexType[@name='SetBaseType']" mode="set">
        <p id="{concat('field_',@name)}">
            <span>
                <xsl:text>SET BASE TYPE</xsl:text>
            </span> 
        </p>
    </xsl:template>

    <xsl:template match="xsd:schema/xsd:simpleType|xsd:schema/xsd:element" mode="msg">
        <p id="{concat('msg_',@name)}">
            <span>
                <xsl:value-of select="xsd:annotation[1]/xsd:appinfo[1]/*:MtfName[1]"/>
            </span>
        </p>
    </xsl:template>

    <xsl:template match="p" mode="psort">
        <xsl:copy-of select="."/>
    </xsl:template>
</xsl:stylesheet>
