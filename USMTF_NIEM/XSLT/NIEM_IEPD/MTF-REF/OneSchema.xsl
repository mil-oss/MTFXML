<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="dirpath" select="'../../../XSD/NIEM_MTF_1_NS/'"/>
    <xsl:variable name="outpath" select="'../../../XSD/NIEM_IEPD/NIEM_MTF_MILSTD/'"/>
    <xsl:variable name="ALLMTF">
        <xsl:for-each select="document(concat($dirpath, 'NIEM_MTF_Messages.xsd'))/xsd:schema/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="document(concat($dirpath, 'NIEM_MTF_Segments.xsd'))/xsd:schema/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="document(concat($dirpath, 'NIEM_MTF_Sets.xsd'))/xsd:schema/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="document(concat($dirpath, 'NIEM_MTF_Composites.xsd'))/xsd:schema/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="document(concat($dirpath, 'NIEM_MTF_Fields.xsd'))/xsd:schema/*">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:template name="main">
        <xsl:result-document href="{concat($outpath,'NIEM_MTF.xsd')}">
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
    </xsl:template>
</xsl:stylesheet>
