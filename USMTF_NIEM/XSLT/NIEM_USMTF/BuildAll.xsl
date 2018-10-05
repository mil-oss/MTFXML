<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="NiemMap.xsl"/>

    <xsl:variable name="dirpath" select="concat($srcdir, 'NIEM_MTF/')"/>
    <xsl:variable name="sepmsgsout" select="'../../XSD/NIEM_MTF/SepMsgs/'"/>
    <!-- _______________________________________________________ -->
    <!--Fields-->
    <xsl:variable name="fieldsxsd">
        <xsl:for-each select="$stringsxsd/xsd:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$stringsxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <!--<xsl:for-each select="$stringsxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:element/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>-->
        <xsl:for-each select="$numericsxsd/xsd:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$numericsxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <!--<xsl:for-each select="$numericsxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>-->
        <xsl:for-each select="$codelistxsd/xsd:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$codelistxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <!--<xsl:for-each select="$codelistxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>-->
        <xsl:for-each select="$all_field_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:choose>
                <xsl:when test="@niemtype">
                    <xsl:variable name="n" select="@niemelementname"/>
                    <xsl:variable name="t" select="@niemtype"/>
                    <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                        <xsd:element name="{@niemelementname}">
                            <xsl:if test="@niemtype">
                                <xsl:attribute name="type">
                                    <xsl:value-of select="@niemtype"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@substgrpname">
                                <xsl:attribute name="abstract">
                                    <xsl:text>true</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@substitutiongroup">
                                <xsl:attribute name="substitutionGroup">
                                    <xsl:value-of select="@substitutiongroup"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="not(@substgrpname)">
                                <xsl:attribute name="nillable">
                                    <xsl:text>true</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsd:annotation>
                                <xsd:documentation>
                                    <xsl:value-of select="@niemelementdoc"/>
                                </xsd:documentation>
                                <xsd:appinfo>
                                    <xsl:for-each select="appinfo/*">
                                        <xsl:copy-of select="." copy-namespaces="no"/>
                                    </xsl:for-each>
                                </xsd:appinfo>
                            </xsd:annotation>
                        </xsd:element>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="name() = 'Choice'">
                    <xsd:element name="{@substgrpname}">
                        <xsl:attribute name="abstract">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xsd:documentation>
                            <xsd:appinfo>
                                <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                    <xsl:for-each select="Element">
                                        <xsl:sort select="@niemelementname"/>
                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_fields_xsd">
        <xsl:for-each select="$fieldsxsd/xsd:simpleType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:simpleType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fieldsxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:element/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_fields_map">
        <xsl:for-each select="$all_field_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Field'">
                <xsl:variable name="n" select="@niemelementname"/>
                <xsl:variable name="t" select="@niemtype"/>
                <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$all_field_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Element'">
                <xsl:variable name="n" select="@niemelementname"/>
                <xsl:variable name="t" select="@niemtype"/>
                <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Composites-->
    <xsl:variable name="elementsxsd">
        <xsl:for-each select="$all_composite_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsl:variable name="t">
                <xsl:value-of select="@niemtype"/>
            </xsl:variable>
            <xsl:variable name="s" select="@substgrpname"/>
            <xsl:choose>
                <xsl:when test="$niem_fields_map//*[@niemelementname = $n]"/>
                <!--<xsl:when test="$all_field_elements_map//*[@niemelementname = $n]"/>-->
                <xsl:when test="@substgrpname and $all_field_elements_map//*[@substgrpname = $s]"/>
                <xsl:when test="name() = 'Choice'">
                    <xsd:element name="{@substgrpname}">
                        <xsl:attribute name="abstract">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xsd:documentation>
                            <xsd:appinfo>
                                <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                    <xsl:for-each select="Element">
                                        <xsl:sort select="@niemelementname"/>
                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsd:element name="{@niemelementname}" type="{$t}" nillable="true">
                        <xsl:if test="@substitutiongroup">
                            <xsl:attribute name="substitutionGroup">
                                <xsl:value-of select="@substitutiongroup"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="@niemelementdoc"/>
                            </xsd:documentation>
                            <xsd:appinfo>
                                <xsl:for-each select="appinfo/*">
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xsl:for-each>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="compositefields">
        <xsl:for-each select="$niem_composites_map//Sequence/Element[starts-with(@mtftype, 'c:')]">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsd:element name="{@niemelementname}">
                <xsl:attribute name="type">
                    <xsl:value-of select="@niemelementtype"/>
                </xsl:attribute>
                <xsl:if test="@substitutiongroup">
                    <xsl:attribute name="substitutionGroup">
                        <xsl:value-of select="@substitutiongroup"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="nillable">
                    <xsl:text>true</xsl:text>
                </xsl:attribute>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:choose>
                            <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                <xsl:value-of select="@substgrpdoc"/>
                            </xsl:when>
                            <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                                <xsl:value-of select="@niemelementdoc"/>
                            </xsl:when>
                            <xsl:when test="string-length(@niemtypedoc) &gt; 0">
                                <xsl:value-of select="@niemtypedoc"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@mtfdoc"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsd:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xsd:appinfo>
                            <xsl:copy-of select="."/>
                        </xsd:appinfo>
                    </xsl:for-each>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:for-each select="$elementsxsd/*">
            <xsl:variable name="n" select="@name"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="compositexsd">
        <xsl:for-each select="$niem_composites_map/Composite">
            <xsl:sort select="@niemtype"/>
            <xsd:complexType name="{@niemtype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="structures:ObjectType">
                        <xsd:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="refname">
                                    <xsl:value-of select="@niemelementname"/>
                                </xsl:variable>
                                <xsd:element ref="{$refname}"/>
                            </xsl:for-each>
                            <xsd:element ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @niemtype)"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                <xsl:if test="@substitutiongroup">
                    <xsl:attribute name="substitutionGroup">
                        <xsl:value-of select="@substitutiongroup"/>
                    </xsl:attribute>
                </xsl:if>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:choose>
                            <xsl:when test="@niemelementname = 'BlankSpace'">
                                <xsl:text>A data item for a blank space character that is used to separate elements within a data chain, or to mark the beginning or end of a unit of data.</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@niemelementdoc"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsd:documentation>
                    <xsd:appinfo>
                        <xsl:for-each select="appinfo/*">
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsl:for-each>
                    </xsd:appinfo>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <xsl:copy-of select="$compositefields"/>
    </xsl:variable>
    <xsl:variable name="mtf_composites_xsd">
        <xsl:for-each select="$compositexsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$compositexsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:element/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_composites_map">
        <xsl:for-each select="$all_composite_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Composite'">
                <xsl:variable name="n" select="@niemelementname"/>
                <xsl:variable name="t" select="@niemtype"/>
                <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$all_composite_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:if test="string-length(@niemtype) &gt; 0 and name() = 'Element'">
                <xsl:variable name="n" select="@niemelementname"/>
                <xsl:variable name="t" select="@niemtype"/>
                <xsl:if test="count(preceding-sibling::*[@niemelementname = $n][@niemtype = $t]) = 0">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Sets-->
    <xsl:variable name="setfields">
        <!--Add New Elements for Field Groups when more than one child-->
        <xsl:for-each select="$niem_sets_map//Sequence[@name = 'GroupOfFields']">
            <xsl:choose>
                <xsl:when test="count(./Element) = 1"/>
                <!--                    <xsl:variable name="n" select="Element[1]/@niemelementname"/>
                    <xsd:element name="{$n}">
                        <xsl:if test="Element[1]/@niemtype">
                            <xsl:attribute name="type">
                                <xsl:value-of select="Element[1]/@niemtype"/>
                            </xsl:attribute>
                        </xsl:if>
                      
                        <xsl:if test="not(@substgrpname)">
                            <xsl:attribute name="nillable">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@niemtypedoc) &gt; 0">
                                        <xsl:value-of select="@niemtypedoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@mtfdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsd:documentation>
                            <xsl:for-each select="appinfo/*">
                                <xsd:appinfo>
                                    <xsl:copy-of select="."/>
                                </xsd:appinfo>
                            </xsl:for-each>
                            <xsl:if test="@substgrpname">
                                <xsd:appinfo>
                                    <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                        </xsl:for-each>
                                    </mtfappinfo:Choice>
                                </xsd:appinfo>
                            </xsl:if>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:when>-->
                <xsl:otherwise>
                    <xsl:variable name="setname">
                        <xsl:value-of select="ancestor::Set/@niemelementname"/>
                    </xsl:variable>
                    <xsl:variable name="setdocname">
                        <xsl:value-of select="lower-case(ancestor::Set/appinfo/mtfappinfo:Set/@setname)"/>
                    </xsl:variable>
                    <xsl:variable name="setdoc">
                        <xsl:value-of select="ancestor::Set/@niemtypedoc"/>
                    </xsl:variable>
                    <xsl:variable name="fielddocname">
                        <xsl:value-of select="lower-case(Element[1]/appinfo/mtfappinfo:Field/@positionName)"/>
                    </xsl:variable>
                    <xsl:variable name="fgname">
                        <xsl:choose>
                            <xsl:when test="exists(Element[1]/@niemelementname) and count(Element) = 1">
                                <xsl:value-of select="concat(Element[1]/@niemelementname, 'FieldGroup')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($setname, 'FieldGroup')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="doc">
                        <xsl:choose>
                            <xsl:when test="exists(Element[1]/@niemtypedoc) and count(Element) = 1">
                                <xsl:value-of select="Element[1]/@niemtypedoc"/>
                            </xsl:when>
                            <xsl:when test="count(Element) = 1">
                                <xsl:value-of select="concat('A data type for ', $fielddocname, ' field group')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('A data type for ', $setdocname, ' field group')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="datadefdoc">
                        <xsl:choose>
                            <xsl:when test="starts-with($doc, 'A data type')">
                                <xsl:value-of select="$doc"/>
                            </xsl:when>
                            <xsl:when test="starts-with($doc, 'A ')">
                                <xsl:value-of select="concat('A ', substring(lower-case($doc), 1))"/>
                            </xsl:when>
                            <xsl:when test="starts-with($doc, 'An ')">
                                <xsl:value-of select="concat('A ', substring(lower-case($doc), 1))"/>
                            </xsl:when>
                            <xsl:when test="contains('AEIOU', substring($doc, 0, 1))">
                                <xsl:value-of select="concat('An ', lower-case($doc))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('A ', lower-case($doc))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsd:element name="{$fgname}" type="{concat($fgname,'Type')}" nillable="true">
                        <!--<xsl:copy-of select="@minOccurs"/>
                        <xsl:copy-of select="@maxOccurs"/>-->
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="replace($datadefdoc, 'type', 'item')"/>
                            </xsd:documentation>
                        </xsd:annotation>
                    </xsd:element>
                    <xsd:complexType name="{concat($fgname,'Type')}">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="$datadefdoc"/>
                            </xsd:documentation>
                        </xsd:annotation>
                        <xsd:complexContent>
                            <xsd:extension base="structures:ObjectType">
                                <xsd:sequence>
                                    <xsl:for-each select="Element">
                                        <xsl:variable name="refname">
                                            <xsl:choose>
                                                <xsl:when test="@substgrpname">
                                                    <xsl:value-of select="@substgrpname"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@niemelementname"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsd:element ref="{$refname}">
                                            <xsl:copy-of select="@minOccurs"/>
                                            <xsl:copy-of select="@maxOccurs"/>
                                            <xsd:annotation>
                                                <xsd:documentation>
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                                            <xsl:value-of select="@substgrpdoc"/>
                                                        </xsl:when>
                                                        <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                                            <xsl:value-of select="replace(@mtfdoc, 'A data type', 'A data item')"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="@niemelementdoc"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsd:documentation>
                                                <xsl:for-each select="appinfo/*">
                                                    <xsd:appinfo>
                                                        <xsl:copy-of select="."/>
                                                    </xsd:appinfo>
                                                </xsl:for-each>
                                                <xsl:if test="@substgrpname">
                                                    <xsd:appinfo>
                                                        <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                                            <xsl:for-each select="Choice/Element">
                                                                <xsl:sort select="@name"/>
                                                                <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                                            </xsl:for-each>
                                                        </mtfappinfo:Choice>
                                                    </xsd:appinfo>
                                                </xsl:if>
                                            </xsd:annotation>
                                        </xsd:element>
                                    </xsl:for-each>
                                    <xsd:element ref="{concat($fgname,'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                                </xsd:sequence>
                            </xsd:extension>
                        </xsd:complexContent>
                    </xsd:complexType>
                    <xsd:element name="{concat($fgname,'AugmentationPoint')}" abstract="true">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="concat('An augmentation point for ', replace($datadefdoc, 'A data type for', ''))"/>
                            </xsd:documentation>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <!--Process all elements that reference set objects -->
        <xsl:for-each select="$all_set_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n">
                <xsl:choose>
                    <xsl:when test="@substgrpname">
                        <xsl:value-of select="@substgrpname"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@niemelementname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="starts-with(@mtftype, 'f:')"/>
                <xsl:when test="starts-with(Choice/Element[1]/@mtftype, 'f:')"/>
                <xsl:when test="starts-with(@mtftype, 'c:')"/>
                <xsl:when test="starts-with(Choice/Element[1]/@mtftype, 'c:')"/>
                <xsl:when test="@niemelementname = 'FreeText'"/>
                <xsl:otherwise>
                    <xsd:element name="{$n}">
                        <xsl:if test="@niemtype">
                            <xsl:attribute name="type">
                                <xsl:value-of select="@niemtype"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@substgrpname">
                            <xsl:attribute name="abstract">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@substitutiongroup">
                            <xsl:attribute name="substitutionGroup">
                                <xsl:value-of select="@substitutiongroup"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="not(@substgrpname)">
                            <xsl:attribute name="nillable">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@niemtypedoc) &gt; 0">
                                        <xsl:value-of select="@niemtypedoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@mtfdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsd:documentation>
                            <xsl:for-each select="appinfo/*">
                                <xsd:appinfo>
                                    <xsl:copy-of select="."/>
                                </xsd:appinfo>
                            </xsl:for-each>
                            <xsl:if test="@substgrpname">
                                <xsd:appinfo>
                                    <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                        </xsl:for-each>
                                    </mtfappinfo:Choice>
                                </xsd:appinfo>
                            </xsl:if>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="setsxsd">
        <xsl:for-each select="$niem_sets_map/Set">
            <xsl:sort select="@niemtype"/>
            <xsl:variable name="setname">
                <xsl:value-of select="@niemelementname"/>
            </xsl:variable>
            <xsl:variable name="basetype">
                <xsl:choose>
                    <xsl:when test="@mtfname = 'SetBaseType'">
                        <xsl:text>structures:ObjectType</xsl:text>
                    </xsl:when>
                    <xsl:when test="@mtfname = 'OperationIdentificationDataType'">
                        <xsl:text>structures:ObjectType</xsl:text>
                    </xsl:when>
                    <xsl:when test="@mtfname = 'ExerciseIdentificationType'">
                        <xsl:text>structures:ObjectType</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>SetBaseType</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsd:complexType name="{@niemtype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xsd:appinfo>
                            <xsl:copy-of select="."/>
                        </xsd:appinfo>
                    </xsl:for-each>
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="{$basetype}">
                        <xsd:sequence>
                            <xsl:for-each select="*:Sequence/*">
                                <xsl:variable name="refname">
                                    <xsl:choose>
                                        <xsl:when test="@name = 'GroupOfFields'">
                                            <xsl:choose>
                                                <xsl:when test="count(Element) = 1">
                                                    <xsl:choose>
                                                        <xsl:when test="string-length(Element/@substgrpname) &gt; 0">
                                                            <xsl:value-of select="Element/@substgrpname"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="Element/@niemelementname"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat($setname, 'FieldGroup')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@niemelementname"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsd:element ref="{$refname}">
                                    <xsl:copy-of select="@minOccurs"/>
                                    <xsl:copy-of select="@maxOccurs"/>
                                    <xsd:annotation>
                                        <xsd:documentation>
                                            <xsl:choose>
                                                <xsl:when test="$refname = 'FreeText'">
                                                    <xsl:text>A data item for text entry</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                                    <xsl:value-of select="@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(Choice/@substgrpdoc) &gt; 0">
                                                    <xsl:value-of select="Choice/@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(Element[1]/@substgrpdoc) &gt; 0">
                                                    <xsl:value-of select="Element[1]/@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                                                    <xsl:value-of select="@niemelementdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(Element[1]/@niemelementdoc) &gt; 0">
                                                    <xsl:value-of select="Element[1]/@niemelementdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(@niemtypedoc) &gt; 0">
                                                    <xsl:value-of select="@niemtypedoc"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:call-template name="breakIntoWords">
                                                        <xsl:with-param name="string" select="$refname"/>
                                                    </xsl:call-template>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsd:documentation>
                                        <xsl:for-each select="appinfo/*">
                                            <xsd:appinfo>
                                                <xsl:copy-of select="." copy-namespaces="no"/>
                                            </xsd:appinfo>
                                        </xsl:for-each>
                                        <xsl:if test="@substgrpname">
                                            <xsd:appinfo>
                                                <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                                    <xsl:for-each select="Choice/Element">
                                                        <xsl:sort select="@name"/>
                                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                                    </xsl:for-each>
                                                </mtfappinfo:Choice>
                                            </xsd:appinfo>
                                        </xsl:if>
                                    </xsd:annotation>
                                </xsd:element>
                            </xsl:for-each>
                            <xsd:element ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @niemtype)"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsl:choose>
                <xsl:when test="@niemelementname = 'SetBase'"/>
                <xsl:otherwise>
                    <xsd:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsd:documentation>
                            <xsl:if test="@substgrpname">
                                <xsd:appinfo>
                                    <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                        </xsl:for-each>
                                    </mtfappinfo:Choice>
                                </xsd:appinfo>
                            </xsl:if>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <!--Global Set Elements-->
        <xsl:for-each select="$setfields/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <!--Set Elements with Choice to Substitution Groups-->
        <xsl:for-each select="$all_set_elements_map//Element[@niemelementname][Choice]">
            <xsl:variable name="substgrp" select="Choice/@substgrpname"/>
            <xsl:variable name="substgrpdoc" select="Choice/@substgrpdoc"/>
            <xsl:variable name="setname" select="@setname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsd:complexType name="{concat(@niemelementname,'Type')}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="$substgrpdoc"/>
                    </xsd:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xsd:appinfo>
                            <xsl:copy-of select="." copy-namespaces="no"/>
                        </xsd:appinfo>
                    </xsl:for-each>
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="SetBaseType">
                        <xsd:sequence>
                            <xsd:element ref="{Choice/@substgrpname}">
                                <xsd:annotation>
                                    <xsd:documentation>
                                        <xsl:value-of select="$substgrpdoc"/>
                                    </xsd:documentation>
                                    <xsd:appinfo>
                                        <mtfappinfo:Choice substitutionGroup="{Choice/@substgrpname}">
                                            <xsl:for-each select="Choice/Element">
                                                <xsl:sort select="@niemelementname"/>
                                                <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                            </xsl:for-each>
                                        </mtfappinfo:Choice>
                                    </xsd:appinfo>
                                </xsd:annotation>
                            </xsd:element>
                            <xsd:element ref="{concat(@niemelementname,'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{@niemelementname}" type="{concat(@niemelementname,'Type')}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemelementdoc"/>
                    </xsd:documentation>
                    <xsl:choose>
                        <xsl:when test="Choice/@substgrpname">
                            <xsd:appinfo>
                                <mtfappinfo:Choice substitutionGroup="{Choice/@substgrpname}">
                                    <xsl:for-each select="Choice/Element">
                                        <xsl:sort select="@name"/>
                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xsd:appinfo>
                        </xsl:when>
                        <!--<xsl:when test="appinfo">
                            <xsd:appinfo>
                                <xsl:for-each select="appinfo/*">
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xsl:for-each>
                            </xsd:appinfo>
                        </xsl:when>-->
                    </xsl:choose>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="{concat(@niemelementname,'AugmentationPoint')}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', concat(@niemelementname, 'Type'))"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsl:choose>
                <xsl:when test="$all_field_elements_map/Element[@substitutiongroup = $substgrp]"/>
                <!--<xsl:when test="$all_composite_elements_map/Element[@substitutiongroup=$substgrp]"/>-->
                <xsl:otherwise>
                    <xsd:element name="{Choice/@substgrpname}" abstract="true">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="Choice/@substgrpdoc"/>
                            </xsd:documentation>
                            <xsd:appinfo>
                                <mtfappinfo:Choice substitutionGroup="{Choice/@substgrpname}">
                                    <xsl:for-each select="Choice/Element">
                                        <xsl:sort select="@niemelementname"/>
                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:otherwise>
            </xsl:choose>
            <!--<xsl:for-each select="Choice/Element">
                <xsl:sort select="@niemelementname"/>
                <xsl:variable name="n" select="@niemelementname"/>
                <xsd:element name="{@niemelementname}" type="{@niemtype}" substitutionGroup="{$substgrp}" nillable="true">
                    <xsd:annotation> 
                        <xsd:documentation>
                            <xsl:value-of select="@niemelementdoc"/>
                        </xsd:documentation>
                        <!-\-<xsd:appinfo>
                                <xsl:for-each select="appinfo/*">
                                    <xsl:copy-of select="." copy-namespaces="no"/>
                                </xsl:for-each>
                            </xsd:appinfo>-\->
                    </xsd:annotation>
                </xsd:element>
            </xsl:for-each>-->
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_sets_xsd">
        <xsl:for-each select="$setsxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:if test="not(preceding-sibling::xsd:complexType/@name = $n)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$setsxsd/xsd:element[@name]">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:choose>
                <xsl:when test="count(preceding-sibling::xsd:element[@name = $n and @type = $t]) &gt; 0"/>
                <xsl:when test="count(preceding-sibling::xsd:element[@name = $n][ends-with(@name, 'Abstract') or ends-with(@name, 'AugmentationPoint')]) &gt; 0"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Segments-->
    <xsl:variable name="segmentelements">
        <xsl:for-each select="$niem_segments_map//Sequence/Element">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map/*[@substgrpname = $n]"/>
                <xsl:when test="$all_set_elements_map/*[@niemelementname = $n]"/>
                <xsl:when test="starts-with(Choice/Element[1]/@mtftype, 's:')"/>
                <xsl:otherwise>
                    <xsl:variable name="t" select="@niemtype"/>
                    <xsl:variable name="d" select="@niemelementdoc"/>
                    <xsl:variable name="segSeq">
                        <xsl:value-of select="ancestor::Segment/@segseq"/>
                    </xsl:variable>
                    <xsd:element name="{@niemelementname}">
                        <xsl:if test="@niemtype">
                            <xsl:attribute name="type">
                                <xsl:value-of select="@niemtype"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@substgrpname">
                            <xsl:attribute name="abstract">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@substitutiongroup">
                            <xsl:attribute name="substitutionGroup">
                                <xsl:value-of select="@substitutiongroup"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="not(@substgrpname)">
                            <xsl:attribute name="nillable">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:choose>
                                    <xsl:when test="@niemtype = 'GeneralTextType'">
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="@niemtype = 'HeadingInformationType'">
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="@niemtypedoc">
                                        <xsl:value-of select="@niemtypedoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsd:documentation>
                            <xsl:choose>
                                <xsl:when test="appinfo/mtfappinfo:Segment">
                                    <xsd:appinfo>
                                        <xsl:copy-of select="appinfo/mtfappinfo:Segment"/>
                                    </xsd:appinfo>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="appinfo/*">
                                        <xsd:appinfo>
                                            <xsl:copy>
                                                <xsl:copy-of select="@positionName"/>
                                                <xsl:copy-of select="ancestor::Element/@textindicator"/>
                                                <xsl:copy-of select="@usage"/>
                                            </xsl:copy>
                                        </xsd:appinfo>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$niem_segments_map//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map/*[@substgrpname = $substgrp]"/>
                <xsl:when test="starts-with(Choice/Element[1]/@mtftype, 's:')"/>
                <xsl:otherwise>
                    <xsd:element name="{@substgrpname}" abstract="true">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xsd:documentation>
                            <xsd:appinfo>
                                <mtfappinfo:Choice>
                                    <xsl:for-each select="Choice/Element">
                                        <xsl:sort select="@niemelementname"/>
                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="Choice/Element">
                <xsl:sort select="@niemelementname"/>
                <xsl:variable name="nn" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="$all_set_elements_map/Element[@niemelementname = $nn]"/>
                    <xsl:otherwise>
                        <xsl:variable name="niemelementdoc">
                            <xsl:choose>
                                <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                                    <xsl:value-of select="@niemelementdoc"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@mtfdoc"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsd:element name="{@niemelementname}">
                            <xsl:if test="@niemtype">
                                <xsl:attribute name="type">
                                    <xsl:value-of select="@niemtype"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@substgrpname">
                                <xsl:attribute name="abstract">
                                    <xsl:text>true</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="@substitutiongroup">
                                <xsl:attribute name="substitutionGroup">
                                    <xsl:value-of select="@substitutiongroup"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="not(@substgrpname)">
                                <xsl:attribute name="nillable">
                                    <xsl:text>true</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsd:annotation>
                                <xsd:documentation>
                                    <xsl:value-of select="@niemelementdoc"/>
                                </xsd:documentation>
                            </xsd:annotation>
                        </xsd:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="$all_segment_elements_map/*">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n">
                <xsl:choose>
                    <xsl:when test="@substgrpname">
                        <xsl:value-of select="@substgrpname"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@niemelementname"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map/*[@niemelementname = $n]"/>
                <xsl:when test="starts-with(@mtftype, 's:')"/>
                <xsl:otherwise>
                    <xsd:element name="{$n}">
                        <xsl:if test="@niemtype">
                            <xsl:attribute name="type">
                                <xsl:value-of select="@niemtype"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@substgrpname">
                            <xsl:attribute name="abstract">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@substitutiongroup">
                            <xsl:attribute name="substitutionGroup">
                                <xsl:value-of select="@substitutiongroup"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="not(@substgrpname)">
                            <xsl:attribute name="nillable">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:choose>
                                    <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                        <xsl:value-of select="@substgrpdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                                        <xsl:value-of select="@niemelementdoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@niemtypedoc) &gt; 0">
                                        <xsl:value-of select="@niemtypedoc"/>
                                    </xsl:when>
                                    <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                        <xsl:value-of select="@mtfdoc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="breakIntoWords">
                                            <xsl:with-param name="string" select="@niemelementname"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsd:documentation>
                            <xsl:for-each select="appinfo/*">
                                <xsd:appinfo>
                                    <xsl:copy-of select="."/>
                                </xsd:appinfo>
                            </xsl:for-each>
                            <xsl:if test="@substgrpname">
                                <xsd:appinfo>
                                    <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                        <xsl:for-each select="Choice/Element">
                                            <xsl:sort select="@name"/>
                                            <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                        </xsl:for-each>
                                    </mtfappinfo:Choice>
                                </xsd:appinfo>
                            </xsl:if>
                        </xsd:annotation>
                    </xsd:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="segmentsxsd">
        <xsl:for-each select="$niem_segments_map/Segment">
            <xsl:sort select="@niemtype"/>
            <xsd:complexType name="{@niemtype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="structures:ObjectType">
                        <xsd:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="n" select="@niemelementname"/>
                                <xsl:variable name="refname">
                                    <xsl:choose>
                                        <xsl:when test="@substgrpname">
                                            <xsl:value-of select="@substgrpname"/>
                                        </xsl:when>
                                        <xsl:when test="$segmentelements/*[@name = $n]">
                                            <xsl:value-of select="$n"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$n"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsd:element ref="{$refname}">
                                    <xsl:copy-of select="@minOccurs"/>
                                    <xsl:copy-of select="@maxOccurs"/>
                                    <xsd:annotation>
                                        <xsd:documentation>
                                            <xsl:choose>
                                                <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                                    <xsl:value-of select="@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(Choice/@substgrpdoc) &gt; 0">
                                                    <xsl:value-of select="Choice/@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(@mtfdoc) &gt; 0">
                                                    <xsl:value-of select="replace(@mtfdoc, 'A data type', 'A data item')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@niemelementdoc"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsd:documentation>
                                        <xsl:for-each select="appinfo/*">
                                            <xsd:appinfo>
                                                <xsl:copy>
                                                    <xsl:copy-of select="@positionName"/>
                                                    <xsl:copy-of select="ancestor::Element/@textindicator"/>
                                                    <xsl:copy-of select="@usage"/>
                                                </xsl:copy>
                                            </xsd:appinfo>
                                        </xsl:for-each>
                                        <xsl:if test="@substgrpname">
                                            <xsd:appinfo>
                                                <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                                    <xsl:for-each select="Choice/Element">
                                                        <xsl:sort select="@name"/>
                                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                                    </xsl:for-each>
                                                </mtfappinfo:Choice>
                                            </xsd:appinfo>
                                        </xsl:if>
                                    </xsd:annotation>
                                </xsd:element>
                            </xsl:for-each>
                            <xsd:element ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @niemtype)"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemelementdoc"/>
                    </xsd:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xsd:appinfo>
                            <xsl:copy>
                                <xsl:copy-of select="@segmentname"/>
                                <!--<xsl:copy-of select="@positionName"/>-->
                                <xsl:copy-of select="@usage"/>
                                <xsl:copy-of select="@concept"/>
                            </xsl:copy>
                        </xsd:appinfo>
                    </xsl:for-each>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <!--Global Set Elements-->
        <xsl:copy-of select="$segmentelements"/>
        <!--Set Elements with Choice to Substitution Groups-->
        <!--<xsl:for-each select="$niem_segments_map//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xsd:element name="{@substgrpname}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="normalize-space(@substgrpdoc)"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsl:for-each select="Choice/Element">
                <xsd:element name="{@niemelementname}" type="{@niemtype}" substitutionGroup="{$substgrp}" nillable="true">
                    <xsd:annotation>
                        <xsd:documentation>
                            <xsl:value-of select="normalize-space(@niemelementdoc)"/>
                        </xsd:documentation>
                    </xsd:annotation>
                </xsd:element>
            </xsl:for-each>
        </xsl:for-each>-->
    </xsl:variable>
    <xsl:variable name="mtf_segments_xsd">
        <xsl:for-each select="$segmentsxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="pre1" select="preceding-sibling::xsd:complexType[@name = $n][1]"/>
            <xsl:variable name="pre2" select="preceding-sibling::xsd:complexType[@name = $n][2]"/>
            <xsl:variable name="pre3" select="preceding-sibling::xsd:complexType[@name = $n][3]"/>
            <xsl:choose>
                <xsl:when test="$n = $pre1/@name"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:when test="deep-equal(., $pre3)"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$segmentsxsd/xsd:element[@name]">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:choose>
                <xsl:when test="string-length(@type) = 0 and not(@abstract)"/>
                <xsl:when test="not(@type) and not(@abstract)"/>
                <xsl:when test="count(preceding-sibling::xsd:element[@name = $n and @type = $t]) &gt; 0"/>
                <xsl:when test="count(preceding-sibling::xsd:element[@name = $n][ends-with(@name, 'Abstract') or ends-with(@name, 'AugmentationPoint')]) &gt; 0"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_segments_map">
        <xsl:for-each select="$niem_segments_map/*">
            <xsl:sort select="@mtfname"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Messages-->
    <xsl:variable name="messagelements">
        <xsl:for-each select="$niem_messages_map//Sequence/Element">
            <xsl:sort select="@niemelementname"/>
            <xsl:variable name="n" select="@niemelementname"/>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map//*[@niemelementname = $n]"/>
                <xsl:when test="$all_segment_elements_map//*[@niemelementname = $n]"/>
                <xsl:otherwise>
                    <xsl:variable name="n" select="@niemelementname"/>
                    <xsl:variable name="segSeq">
                        <xsl:value-of select="ancestor::Segment/@segseq"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="@niemelementname">
                            <xsd:element name="{@niemelementname}">
                                <xsl:attribute name="type">
                                    <xsl:value-of select="@niemtype"/>
                                </xsl:attribute>
                                <xsl:attribute name="nillable">
                                    <xsl:text>true</xsl:text>
                                </xsl:attribute>
                                <xsd:annotation>
                                    <xsd:documentation>
                                        <xsl:choose>
                                            <xsl:when test="@niemtypedoc">
                                                <xsl:value-of select="replace(@niemtypedoc, 'A data type', 'A data item')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="@niemelementdoc"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsd:documentation>
                                    <xsl:for-each select="appinfo/*">
                                        <xsd:appinfo>
                                            <xsl:copy>
                                                <xsl:copy-of select="@positionName"/>
                                                <!--<xsl:copy-of select="@concept"/>
                                                    <xsl:copy-of select="@usage"/>-->
                                            </xsl:copy>
                                        </xsd:appinfo>
                                    </xsl:for-each>
                                </xsd:annotation>
                            </xsd:element>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$niem_messages_map//Element[Choice]">
            <xsl:variable name="substgrp" select="@substgrpname"/>
            <xsl:choose>
                <xsl:when test="$all_set_elements_map//*[@substgrpname = $substgrp]"/>
                <xsl:when test="$all_segment_elements_map//*[@substgrpname = $substgrp]"/>
                <xsl:when test="@substgrpname">
                    <xsd:element name="{@substgrpname}" abstract="true">
                        <xsd:annotation>
                            <xsd:documentation>
                                <xsl:value-of select="@substgrpdoc"/>
                            </xsd:documentation>
                            <xsd:appinfo>
                                <mtfappinfo:Choice>
                                    <xsl:for-each select="Choice/Element">
                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                    </xsl:for-each>
                                </mtfappinfo:Choice>
                            </xsd:appinfo>
                        </xsd:annotation>
                    </xsd:element>
                    <xsl:for-each select="Choice/Element">
                        <xsl:variable name="n" select="@niemelementname"/>
                        <xsd:element name="{@niemelementname}" type="{@niemtype}" substitutionGroup="{$substgrp}" nillable="true">
                            <xsd:annotation>
                                <xsd:documentation>
                                    <xsl:choose>
                                        <xsl:when test="@niemtypedoc">
                                            <xsl:value-of select="@niemtypedoc"/>
                                        </xsl:when>
                                        <xsl:when test="@niemelementdoc">
                                            <xsl:value-of select="@niemelementdoc"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsd:documentation>
                            </xsd:annotation>
                        </xsd:element>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="messagesxsd">
        <xsl:for-each select="$niem_messages_map/Message">
            <xsl:sort select="@niemtype"/>
            <xsd:complexType name="{@niemtype}">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemtypedoc"/>
                    </xsd:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xsd:appinfo>
                            <xsl:copy-of select="."/>
                        </xsd:appinfo>
                    </xsl:for-each>
                </xsd:annotation>
                <xsd:complexContent>
                    <xsd:extension base="structures:ObjectType">
                        <xsd:sequence>
                            <xsl:for-each select="*:Sequence/Element">
                                <xsl:variable name="n" select="@niemelementname"/>
                                <!--<xsl:variable name="p" select="substring-before(@mtftype, ':')"/>-->
                                <xsl:variable name="refname">
                                    <xsl:choose>
                                        <xsl:when test="@substgrpname">
                                            <xsl:value-of select="@substgrpname"/>
                                        </xsl:when>
                                        <xsl:when test="$messagelements/*[@name = $n]">
                                            <xsl:value-of select="$n"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$n"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsd:element ref="{$refname}">
                                    <xsl:copy-of select="@minOccurs"/>
                                    <xsl:copy-of select="@maxOccurs"/>
                                    <xsd:annotation>
                                        <xsd:documentation>
                                            <xsl:choose>
                                                <xsl:when test="string-length(@substgrpdoc) &gt; 0">
                                                    <xsl:value-of select="@substgrpdoc"/>
                                                </xsl:when>
                                                <xsl:when test="string-length(@niemelementdoc) &gt; 0">
                                                    <xsl:value-of select="@niemelementdoc"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@niemtypedoc"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsd:documentation>
                                        <xsl:for-each select="appinfo/*">
                                            <xsd:appinfo>
                                                <xsl:copy-of select="."/>
                                            </xsd:appinfo>
                                        </xsl:for-each>
                                        <xsl:if test="@substgrpname">
                                            <xsd:appinfo>
                                                <mtfappinfo:Choice substitutionGroup="{@substgrpname}">
                                                    <xsl:for-each select="Choice/Element">
                                                        <xsl:sort select="@name"/>
                                                        <mtfappinfo:Element name="{@niemelementname}" type="{@niemtype}"/>
                                                    </xsl:for-each>
                                                </mtfappinfo:Choice>
                                            </xsd:appinfo>
                                        </xsl:if>
                                    </xsd:annotation>
                                </xsd:element>
                            </xsl:for-each>
                            <xsd:element ref="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}" minOccurs="0" maxOccurs="unbounded"/>
                        </xsd:sequence>
                    </xsd:extension>
                </xsd:complexContent>
            </xsd:complexType>
            <xsd:element name="{concat(substring(@niemtype,0,string-length(@niemtype)-3),'AugmentationPoint')}" abstract="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="concat('An augmentation point for ', @niemtype)"/>
                    </xsd:documentation>
                </xsd:annotation>
            </xsd:element>
            <xsd:element name="{@niemelementname}" type="{@niemtype}" nillable="true">
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:value-of select="@niemelementdoc"/>
                    </xsd:documentation>
                    <xsl:for-each select="appinfo/*">
                        <xsd:appinfo>
                            <xsl:copy-of select="."/>
                            <!-- <xsl:copy>
                                <xsl:copy-of select="@name"/>
                                <xsl:copy-of select="@positionName"/>
                                <!-\-\\\\-<xsl:copy-of select="@usage"/>
                                <xsl:copy-of select="@concept"/> -\->
                            </xsl:copy>-->
                        </xsd:appinfo>
                    </xsl:for-each>
                </xsd:annotation>
            </xsd:element>
        </xsl:for-each>
        <!--Global Elements-->
        <xsl:copy-of select="$messagelements"/>
    </xsl:variable>
    <xsl:variable name="mtf_messages_xsd">
        <xsl:for-each select="$messagesxsd/xsd:complexType">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="pre1" select="preceding-sibling::xsd:complexType[@name = $n][1]"/>
            <xsl:variable name="pre2" select="preceding-sibling::xsd:complexType[@name = $n][2]"/>
            <xsl:choose>
                <xsl:when test="$n = $pre1/@name"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$messagesxsd/xsd:element">
            <xsl:sort select="@name"/>
            <xsl:sort select="@type"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@type"/>
            <xsl:variable name="pre1" select="preceding-sibling::xsd:element[@name = $n][1]"/>
            <xsl:variable name="pre2" select="preceding-sibling::xsd:element[@name = $n][2]"/>
            <xsl:choose>
                <xsl:when test="deep-equal(., $pre1)"/>
                <xsl:when test="deep-equal(., $pre2)"/>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="mtf_messages_map">
        <xsl:for-each select="$niem_messages_map/*">
            <xsl:sort select="@mtfname"/>
            <xsl:copy-of select="." copy-namespaces="no"/>
        </xsl:for-each>
    </xsl:variable>
    <!-- _______________________________________________________ -->
    <!--Consolidated-->
    <xsl:variable name="ALLMTF">
        <xsl:copy-of select="$mtf_fields_xsd"/>
        <xsl:copy-of select="$mtf_composites_xsd"/>
        <xsl:copy-of select="$mtf_sets_xsd"/>
        <xsl:copy-of select="$mtf_segments_xsd"/>
        <xsl:copy-of select="$mtf_messages_xsd"/>
    </xsl:variable>

    <xsl:template name="main">
        <!--Schema-->
        <xsl:result-document href="{$dirpath}/NIEM_MTF_Fields.xsd">
            <xsd:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf" ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NIEM/mtfappinfo.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Fields for MTF Messages</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:copy-of select="$mtf_fields_xsd" copy-namespaces="no"/>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/NIEM_MTF_Composites.xsd">
            <xsd:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf" ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NIEM/mtfappinfo.xsd"/>
                <xsd:include schemaLocation="NIEM_MTF_Fields.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Composite fields for MTF Composite Fields</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:copy-of select="$mtf_composites_xsd" copy-namespaces="no"/>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/NIEM_MTF_Sets.xsd">
            <xsd:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf" ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NIEM/mtfappinfo.xsd"/>
                <xsd:include schemaLocation="NIEM_MTF_Fields.xsd"/>
                <xsd:include schemaLocation="NIEM_MTF_Composites.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Set structures for MTF Messages</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:copy-of select="$mtf_sets_xsd" copy-namespaces="no"/>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/NIEM_MTF_Segments.xsd">
            <xsd:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf" ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NIEM/mtfappinfo.xsd"/>
                <xsd:include schemaLocation="NIEM_MTF_Sets.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Segment structures for MTF Segments</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:copy-of select="$mtf_segments_xsd" copy-namespaces="no"/>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/NIEM_MTF_Messages.xsd">
            <xsd:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                targetNamespace="urn:mtf:mil:6040b:niem:mtf" ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US"
                elementFormDefault="unqualified" attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NIEM/mtfappinfo.xsd"/>
                <xsd:include schemaLocation="NIEM_MTF_Sets.xsd"/>
                <xsd:include schemaLocation="NIEM_MTF_Segments.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>Message structures for MTF Messages</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:copy-of select="$mtf_messages_xsd"/>
            </xsd:schema>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/NIEM_MTF.xsd">
            <xsd:schema xmlns="urn:mtf:mil:6040b:niem:mtf" xmlns:ism="urn:us:gov:ic:ism" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/"
                xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/" xmlns:mtfappinfo="urn:mtf:mil:6040b:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:mtf:mil:6040b:niem:mtf"
                ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
                attributeFormDefault="unqualified" version="1.0">
                <xsd:import namespace="urn:us:gov:ic:ism" schemaLocation="IC-ISM.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="../NIEM/structures.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="../NIEM/localTerminology.xsd"/>
                <xsd:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="../NIEM/appinfo.xsd"/>
                <xsd:import namespace="urn:mtf:mil:6040b:appinfo" schemaLocation="../NIEM/mtfappinfo.xsd"/>
                <xsd:annotation>
                    <xsd:documentation>
                        <xsl:text>UNIFIED MTF MESSAGE SCHEMA</xsl:text>
                    </xsd:documentation>
                </xsd:annotation>
                <xsl:for-each select="$ALLMTF/xsd:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$ALLMTF/xsd:simpleType">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$ALLMTF/xsd:element">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsd:schema>
        </xsl:result-document>
        <!--Maps-->
        <xsl:result-document href="{$dirpath}/Maps/NIEM_MTF_Fieldmaps.xml">
            <Fields>
                <xsl:copy-of select="$mtf_fields_map"/>
            </Fields>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/Maps/NIEM_MTF_Compositemaps.xml">
            <Composites>
                <xsl:copy-of select="$mtf_composites_map" copy-namespaces="no"/>
            </Composites>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/Maps/NIEM_MTF_Setmaps.xml">
            <Sets>
                <xsl:copy-of select="$mtf_sets_xsd"/>
            </Sets>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/Maps/NIEM_MTF_Segmntmaps.xml">
            <Segments>
                <xsl:copy-of select="$mtf_segments_map" copy-namespaces="no"/>
            </Segments>
        </xsl:result-document>
        <xsl:result-document href="{$dirpath}/Maps/NIEM_MTF_Msgsmaps.xml">
            <Messages>
                <xsl:copy-of select="$mtf_messages_map"/>
            </Messages>
        </xsl:result-document>
        <!--Message Schema-->
        <!--<xsl:for-each select="$ALLMTF/xsd:element[xsd:annotation/xsd:appinfo/*:Msg]">
            <xsl:call-template name="ExtractMessageSchema">
                <xsl:with-param name="message" select="."/>
                <xsl:with-param name="outdir" select="$sepmsgsout"/>
            </xsl:call-template>
        </xsl:for-each>-->
    </xsl:template>


</xsl:stylesheet>
