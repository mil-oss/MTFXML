<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="nxsd">
        <xsl:apply-templates select="." mode="identity"/>
    </xsl:variable>

    <xsl:variable name="ref-xsd-template">
        <xs:schema xmlns="urn:nato:stanag:4774:confidentialitymetadatalabel:1:0" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/"
            xmlns:structures="http://release.niem.gov/niem/structures/4.0/" xmlns:term="http://release.niem.gov/niem/localTerminology/3.0/" xmlns:appinfo="http://release.niem.gov/niem/appinfo/4.0/"
            xmlns:mtfappinfo="urn:int:nato:ncdf:mtf:appinfo" xmlns:ddms="http://metadata.dod.mil/mdr/ns/DDMS/2.0/" xmlns:slab="urn:nato:stanag:4774:confidentialitymetadatalabel:1:0"
            xmlns:xs="http://www.w3.org/2001/XMLSchema" targetNamespace="urn:nato:stanag:4774:confidentialitymetadatalabel:1:0"
            ct:conformanceTargets="http://reference.niem.gov/niem/specification/naming-and-design-rules/4.0/#ReferenceSchemaDocument" xml:lang="en-US" elementFormDefault="unqualified"
            attributeFormDefault="unqualified" version="1.0">
            <xs:import namespace="http://release.niem.gov/niem/structures/4.0/" schemaLocation="ncdf/utility/structures/4.0/structures.xsd"/>
            <xs:import namespace="http://release.niem.gov/niem/localTerminology/3.0/" schemaLocation="ncdf/localTerminology.xsd"/>
            <xs:import namespace="http://release.niem.gov/niem/appinfo/4.0/" schemaLocation="ncdf/utility/appinfo/4.0/appinfo.xsd"/>
            <xs:import namespace="urn:int:nato:ncdf:mtf:appinfo" schemaLocation="ncdf/mtfappinfo.xsd"/>
        </xs:schema>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:for-each select="$ref-xsd-template/*">
            <xsl:copy>
                <xsl:apply-templates select="@*" mode="identity"/>
                <xsl:apply-templates select="*" mode="identity"/>
                <xsl:for-each select="$nxsd/*/xs:complexType">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
                <xsl:for-each select="$nxsd/*/xs:simpleType">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
                <xsl:for-each select="$nxsd/*/xs:element">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
                <xsl:for-each select="$nxsd/*/xs:attribute">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*" mode="identity">
        <xsl:copy inherit-namespaces="no">
            <xsl:apply-templates select="@*" mode="identity"/>
            <xsl:apply-templates select="text()" mode="identity"/>
            <xsl:apply-templates select="*" mode="identity"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="identity">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="text()" mode="identity">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

</xsl:stylesheet>
