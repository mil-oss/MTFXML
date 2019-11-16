<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="dirpath" select="'../../XSD/Baseline_Schema/SepMsg/'"/>
    <xsl:include href="USMTF_Utility.xsl"/>
    <xsl:include href="GetPath.xsl"/>

    <!--Baseline XML Schema documents-->
    <xsl:variable name="baseline_msgs_xsd" select="document('../../XSD/Baseline_Schema/messages.xsd')"/>

    <xsl:variable name="apos" select='"&apos;"'/>
    <xsl:variable name="apos2" select='"&apos;&apos;"'/>
    <xsl:variable name="q" select="'&quot;'"/>
    <xsl:variable name="lt" select="'&lt;'"/>
    <xsl:variable name="gt" select="'&gt;'"/>

    <xsl:template name="main">
        <xsl:for-each select="$baseline_msgs_xsd/xsd:schema/xsd:element[xsd:annotation/xsd:appinfo/*:MtfName]">
            <xsl:variable name="msgid" select="./xsd:annotation/xsd:appinfo/*:MtfIdentifier"/>
            <xsl:variable name="mid" select="translate($msgid, ' .:()', '')"/>
            <xsl:call-template name="MapMessage">
                <xsl:with-param name="messageid" select="$mid"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- MESSAGE XSD MAP-->
    <!-- _______________________________________________________ -->
    <xsl:template name="MapMessage">
        <xsl:param name="messageid"/>
        <xsl:result-document href="{concat($dirpath,'_Maps/',$messageid,'_BaselineMap.xml')}">
            <xsl:element name="{$messageid}">
                <xsl:apply-templates select="document(concat($dirpath, $messageid, '/', $messageid, '_message.xsd'))/xsd:schema/xsd:element" mode="msgglobal"/>
                <Sets>
                    <xsl:apply-templates select="document(concat($dirpath, $messageid, '/', $messageid, '_sets.xsd'))/xsd:schema/xsd:complexType" mode="setglobal"/>
                </Sets>
                <Composites>
                    <xsl:apply-templates select="document(concat($dirpath, $messageid, '/', $messageid, '_composites.xsd'))/xsd:schema/xsd:complexType" mode="compositeglobal"/>
                </Composites>
                <Fields>
                    <xsl:apply-templates select="document(concat($dirpath, $messageid, '/', $messageid, '_fields.xsd'))/xsd:schema/*" mode="fieldglobal"/>
                </Fields>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:element" mode="msgglobal">
        <xsl:variable name="annot">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="mtfnamevar" select="@name"/>
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="mtfdoc">
            <xsl:choose>
                <xsl:when test="xsd:annotation/xsd:documentation">
                    <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($annot/*/xsd:documentation)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfid">
            <xsl:value-of select="xsd:complexType/xsd:attribute[@name = 'mtfid'][1]/@fixed"/>
        </xsl:variable>
        <xsl:variable name="path">
            <xsl:call-template name="getPath">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="annot" select="$appinfovar"/>
            </xsl:call-template>
        </xsl:variable>
        <Message mtfname="{@name}" mtfid="{$mtfid}" mtfdoc="{$mtfdoc}" path="{replace($path,'/xsd:schema/xsd:element','/xsd:schema/xsd:complexType/complexContent/')}">
                <xsl:for-each select="$appinfovar/*">
                        <xsl:for-each select="@*">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                </xsl:for-each>
            <xsl:apply-templates select="*" mode="map"/>
        </Message>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:complexType" mode="setglobal">
        <xsl:variable name="annot">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*:Set" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="path">
            <xsl:call-template name="getPath">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="annot" select="$appinfovar"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mtfdocvar">
            <xsl:value-of select="$annot/*/xsd:documentation"/>
        </xsl:variable>
        <Set mtfname="{@name}" mtfdoc="{$mtfdocvar}" path="{replace($path,'/xsd:schema/xsd:element/','/xsd:schema/xsd:complexType/complexContent/')}">
            <appinfo>
                <xsl:for-each select="$appinfovar/*">
                    <xsl:element name="{substring-after(name(),':')}">
                        <xsl:for-each select="@*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:for-each>
            </appinfo>
            <xsl:apply-templates select="*" mode="map"/>
        </Set>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:complexType" mode="compositeglobal">
        <xsl:variable name="n" select="@name"/>
        <xsl:variable name="annot">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*:Set" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="mtfdoc">
            <xsl:value-of select="$annot/*/xsd:documentation"/>
        </xsl:variable>
        <xsl:variable name="namesc" select="replace(@name, $apos, $apos2)"/>
        <xsl:variable name="path">
            <xsl:call-template name="getPath">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="annot" select="$appinfovar"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <Composite>
                    <xsl:for-each select="*:Field/@*">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:for-each>
                </Composite>
            </xsl:for-each>
        </xsl:variable>
        <Composite mtfname="{$n}" mtfdoc="{$mtfdoc}" path="{$path}">
            <appinfo>
                <xsl:for-each select="$appinfovar">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </appinfo>
            <xsl:apply-templates select="*" mode="map"/>
        </Composite>
    </xsl:template>
    <xsl:template match="xsd:schema/xsd:simpleType | xsd:complexType" mode="fieldglobal">
        <xsl:variable name="mtfname" select="@name"/>
        <xsl:variable name=" base" select="xsd:restriction/@base"/>
        <xsl:variable name="pattern" select="xsd:restriction/xsd:pattern/@value"/>
        <xsl:variable name="min" select="xsd:restriction/xsd:minInclusive/@value"/>
        <xsl:variable name="max" select="xsd:restriction/xsd:maxInclusive/@value"/>
        <xsl:variable name="annot">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <Field>
                    <xsl:for-each select="*:Field/@*">
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:for-each>
                </Field>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="namesc" select="replace($appinfovar/*/@name, $apos, $apos2)"/>
        <xsl:variable name="path">
            <xsl:call-template name="getPath">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="annot" select="$appinfovar"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mtfdoc">
            <xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
        </xsl:variable>
        <xsl:variable name="minlength">
            <xsl:value-of select="xsd:restriction/xsd:minLength/@value"/>
        </xsl:variable>
        <xsl:variable name="maxlength">
            <xsl:value-of select="xsd:restriction/xsd:maxLength/@value"/>
        </xsl:variable>
        <xsl:variable name="lengthvar">
            <xsl:value-of select="xsd:restriction/xsd:length/@value"/>
        </xsl:variable>
        <Field mtfname="{@name}" base="xsd:string" mtfdoc="{$mtfdoc}" path="{$path}">
            <xsl:if test="string-length($base) &gt; 0">
                <xsl:attribute name="base" select="$base"/>
            </xsl:if>
            <xsl:if test="string-length($pattern) &gt; 0">
                <xsl:attribute name="pattern" select="$pattern"/>
            </xsl:if>
            <xsl:if test="string-length($lengthvar) &gt; 0">
                <xsl:attribute name="length" select="$lengthvar"/>
            </xsl:if>
            <xsl:if test="string-length($minlength) &gt; 0">
                <xsl:attribute name="minLength" select="$minlength"/>
            </xsl:if>
            <xsl:if test="string-length($maxlength) &gt; 0">
                <xsl:attribute name="maxLength" select="$maxlength"/>
            </xsl:if>
            <xsl:if test="string-length($min) &gt; 0">
                <xsl:attribute name="minInclusive" select="$min"/>
            </xsl:if>
            <xsl:if test="string-length($max) &gt; 0">
                <xsl:attribute name="maxInclusive" select="$max"/>
            </xsl:if>
            <xsl:attribute name="ffirn" select="xsd:annotation/xsd:appinfo/*:FieldFormatIndexReferenceNumber"/>
            <xsl:attribute name="fud" select="xsd:annotation/xsd:appinfo/*:FudNumber"/>
            <appinfo>
                <xsl:for-each select="$appinfovar/*">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </appinfo>
            <xsl:for-each select="xsd:restriction/xsd:enumeration">
                <xsl:sort select="@value"/>
                <Enumeration value="{@value}" dataItem="{xsd:annotation/xsd:appinfo/*:DataItem}" doc="{normalize-space(xsd:annotation/xsd:documentation/text())}"/>
            </xsl:for-each>
        </Field>
    </xsl:template>
    <xsl:template match="xsd:element" mode="map">
        <xsl:variable name="mtfnamevar" select="@name"/>
        <xsl:variable name="annot">
            <xsl:apply-templates select="xsd:annotation"/>
        </xsl:variable>
        <xsl:variable name="appinfovar">
            <xsl:for-each select="$annot/*/xsd:appinfo">
                <xsl:copy-of select="*" copy-namespaces="no"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="path">
            <xsl:call-template name="getPath">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="annot" select="$appinfovar"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mtftype">
            <xsl:value-of select="xsd:complexType/*/xsd:extension/@base"/>
        </xsl:variable>
        <xsl:variable name="UseDesc">
            <xsl:value-of select="translate(upper-case($appinfovar/*/@usage), '.', '')"/>
        </xsl:variable>
        <xsl:variable name="ffirnfud">
            <xsl:value-of select="xsd:complexType/*//xsd:attribute[@name = 'ffirnFudn']/@fixed"/>
        </xsl:variable>
        <xsl:variable name="seq">
            <xsl:choose>
                <xsl:when test="xsd:annotation/xsd:appinfo/*:InitialSetFormatPosition">
                    <xsl:value-of select="xsd:annotation/xsd:appinfo/*:InitialSetFormatPosition"/>
                </xsl:when>
                <xsl:when test="xsd:annotation/xsd:appinfo/*:SetFormatPositionNumbern">
                    <xsl:value-of select="xsd:annotation/xsd:appinfo/*:SetFormatPositionNumber"/>
                </xsl:when>
                <xsl:when test="xsd:complexType/xsd:complexContent/xsd:extension/xsd:attribute[@name = 'setSeq'][1]/@fixed">
                    <xsl:value-of select="xsd:complexType/xsd:complexContent/xsd:extension/xsd:attribute[@name = 'setSeq'][1]/@fixed"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mtfdoc">
            <xsl:choose>
                <xsl:when test="xsd:annotation/xsd:documentation">
                    <xsl:value-of select="normalize-space(xsd:annotation/xsd:documentation)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($annot/xsd:documentation)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <Element mtfname="{@name}" mtfdoc="{$mtfdoc}" path="{$path}">
            <xsl:if test="string-length($mtftype) &gt; 0">
                <xsl:attribute name="mtftype">
                    <xsl:value-of select="$mtftype"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($appinfovar/*/@usage) &gt; 0">
                <xsl:attribute name="usage">
                    <xsl:value-of select="$appinfovar/*/@usage"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($seq) &gt; 0">
                <xsl:attribute name="seq">
                    <xsl:value-of select="$seq"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="string-length($ffirnfud) &gt; 0">
                <xsl:attribute name="identifier">
                    <xsl:value-of select="$ffirnfud"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="@minOccurs"/>
            <xsl:copy-of select="@maxOccurs"/>
            <appinfo>
                <xsl:for-each select="$appinfovar/*">
                    <xsl:element name="{substring-after(name(),':')}">
                        <xsl:for-each select="@*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:for-each>
            </appinfo>
            <xsl:apply-templates select="*" mode="map"/>
        </Element>
    </xsl:template>
    <xsl:template match="xsd:sequence" mode="map">
        <Sequence>
            <xsl:apply-templates select="*" mode="map"/>
        </Sequence>
    </xsl:template>
    <!--  Choice / Substitution Groups Map -->
    <xsl:template match="xsd:choice" mode="map">
        <xsl:variable name="path">
            <xsl:call-template name="getPath">
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
        </xsl:variable>
         <Choice path="{$path}">
            <xsl:copy-of select="@minOccurs"/>
            <xsl:copy-of select="@maxOccurs"/>
            <xsl:apply-templates select="*" mode="map"/>
         </Choice>
    </xsl:template>
    <xsl:template match="xsd:complexType | xsd:simpleContent | xsd:complexContent | xsd:extension" mode="map">
        <xsl:apply-templates select="*" mode="map"/>
    </xsl:template>
    <xsl:template match="xsd:annotation" mode="map"/>

    <!-- _______________________________________________________ -->
</xsl:stylesheet>
