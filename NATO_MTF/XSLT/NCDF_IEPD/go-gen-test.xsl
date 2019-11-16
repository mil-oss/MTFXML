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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="text" indent="yes"/>

    <!-- 
    input: /iepd/xml/xsd/iep.xsd
    output:/iepd/src/golang/struct/xsd-struct.go
   -->

    <!-- <xsl:template match="/">
        <xsl:call-template name="makego">
            <xsl:with-param name="rootname" select="'Root'"/>
        </xsl:call-template>
    </xsl:template>-->

    <xsl:variable name="a">
        <xsl:text>&amp;</xsl:text>
    </xsl:variable>
    <xsl:variable name="as">
        <xsl:text>*</xsl:text>
    </xsl:variable>
    <xsl:variable name="lb">
        <xsl:text>{</xsl:text>
    </xsl:variable>
    <xsl:variable name="rb">
        <xsl:text>}</xsl:text>
    </xsl:variable>
    <xsl:variable name="cm">
        <xsl:text>,</xsl:text>
    </xsl:variable>
    <xsl:variable name="cr">
        <xsl:text>&#10;</xsl:text>
    </xsl:variable>
    <xsl:variable name="lf">
        <xsl:text>&#13;</xsl:text>
    </xsl:variable>
    <xsl:variable name="qt">
        <xsl:text>&quot;</xsl:text>
    </xsl:variable>
    <xsl:variable name="bq">
        <xsl:text>&#96;</xsl:text>
    </xsl:variable>
    <xsl:variable name="sp">
        <xsl:text>&#32;</xsl:text>
    </xsl:variable>
    <xsl:variable name="in">
        <xsl:value-of select="concat($sp, $sp, $sp, $sp)"/>
    </xsl:variable>
    <xsl:variable name="tab">
        <xsl:text>&#09;</xsl:text>
    </xsl:variable>
    <xsl:variable name="json" select="' json:'"/>
    <xsl:variable name="omitempty" select="'omitempty'"/>

    <xsl:variable name="goVarChanges">
        <Rename from="id" to="ID"/>
        <Rename from="idRef" to="IDRef"/>
        <Rename from="Assertion" to="TdfAssertion"/>
        <Rename from="uri" to="URI"/>
        <Rename from="testId" to="TestID"/>
        <Rename from="requirementId" to="RequirementID"/>
    </xsl:variable>

    <xsl:param name="ChoiceSelections">
        <AssertionGroupChoiceAbstract choice="HandlingAssertion"/>
        <TdcTypeChoiceAbstract choice="TrustedDataObject"/>
        <HandlingStatementChoiceAbstract choice="HandlingStatementEdh"/>
        <BindingGroupChoiceAbstract choice="Binding"/>
        <EncryptionInformationChoiceAbstract choice="KeyAccess"/>
        <PayloadGroupChoiceAbstract choice="StructuredPayload"/>
        <KeyAccessTypeChoiceAbstract choice="PasswordKey"/>
        <BindingTypeChoiceAbstract choice="Signer"/>
    </xsl:param>


    <xsl:template name="maketests">
        <xsl:param name="pckgname"/>
        <xsl:param name="testdata"/>
        <xsl:param name="testpath"/>
        <xsl:param name="testurl"/>
        <xsl:variable name="rootname" select="//xs:schema/xs:annotation/xs:appinfo/*/@name"/>
        <xsl:variable name="roottype" select="//xs:schema/xs:annotation/xs:appinfo/*/@type"/>
        <xsl:call-template name="teststart">
            <xsl:with-param name="appname" select="$rootname"/>
            <xsl:with-param name="pckgname" select="$pckgname"/>
            <xsl:with-param name="rootname" select="$rootname"/>
            <xsl:with-param name="testpath" select="$testpath"/>
            <xsl:with-param name="testurl" select="$testurl"/>
        </xsl:call-template>
        <xsl:apply-templates select="//xs:schema/xs:complexType[@name = $roottype]/*"
            mode="maketest">
            <xsl:with-param name="pckgname" select="$pckgname"/>
            <xsl:with-param name="testdata" select="$testdata"/>
        </xsl:apply-templates>
        <xsl:variable name="b" select="//xs:schema/xs:complexType[@name = $roottype]//@base"/>
        <xsl:apply-templates select="//xs:schema/xs:complexType[@name = $b]/*" mode="maketest">
            <xsl:with-param name="pckgname" select="$pckgname"/>
            <xsl:with-param name="testdata" select="$testdata"/>
        </xsl:apply-templates>
        <xsl:value-of select="concat($in, '})', $cr)"/>
        <xsl:value-of select="concat($cr, '}')"/>
    </xsl:template>

    <xsl:template name="teststart">
        <xsl:param name="appname"/>
        <xsl:param name="pckgname"/>
        <xsl:param name="testpath"/>
        <xsl:param name="testurl"/>
        <xsl:value-of select="concat('package ', $pckgname, $cr, $cr)"/>
        <xsl:value-of select="concat('import (', $cr)"/>
        <xsl:value-of select="concat($in, $qt, 'encoding/xml', $qt, $cr)"/>
        <xsl:value-of select="concat($in, $qt, 'fmt', $qt, $cr)"/>
        <xsl:value-of select="concat($in, $qt, 'io/ioutil', $qt, $cr)"/>
        <xsl:value-of select="concat($in, $qt, 'xsdprov', $qt, $cr)"/>
        <xsl:value-of
            select="concat($in, $qt, 'testing', $qt, $cr, $cr, $in, $qt, 'github.com/franela/goblin', $qt, $cr)"/>
        <xsl:value-of select="concat($in, '. ', $qt, 'github.com/onsi/gomega', $qt, $cr)"/>
        <xsl:value-of select="concat(')', $cr, $cr)"/>
        <xsl:value-of select="concat('var testinstances = map[string]string{', $cr)"/>
        <xsl:value-of
            select="concat($in, $qt, 'test_instance.xml', $qt, ':', '      ', $qt, $testpath, $qt, $cm, $cr, $rb, $cr)"/>
        <xsl:value-of
            select="concat('func Test', $appname, '(t *testing.T) {', $cr, $in, 'g := goblin.Goblin(t)', $cr)"/>
        <xsl:value-of
            select="concat($in, 'xsdprov.WgetFile(testinstances[', $qt, 'test_instance.xml', $qt, ']', $cm, $qt, $testurl, $qt, ')', $cr)"/>
        <xsl:value-of
            select="concat($in, 'RegisterFailHandler(func(m string, _ ...int) { g.Fail(m) })', $cr, $cr)"/>
        <xsl:value-of
            select="concat($in, 'xf, ferr := ioutil.ReadFile(testinstances[', $qt, 'test_instance.xml', $qt, '])', $cr)"/>
        <xsl:value-of select="concat($in, 'if ferr != nil {', $cr)"/>
        <xsl:value-of select="concat($in, $in, 'fmt.Printf(ferr.Error())', $cr, $in, '}', $cr)"/>
        <xsl:value-of select="concat($in, 'var ', $pckgname, ' = New', $appname, '()', $cr)"/>
        <xsl:value-of
            select="concat($in, 'err := xml.Unmarshal([]byte(xf), ', $a, $pckgname, ')', $cr)"/>
        <xsl:value-of select="concat($in, 'if err != nil {', $cr)"/>
        <xsl:value-of select="concat($in, $in, 'fmt.Printf(err.Error())', $cr, $in, '}', $cr)"/>
        <xsl:value-of select="concat($in, 'g.Describe(', $qt, $appname, $qt, $cm, 'func() {', $cr)"
        />
    </xsl:template>

    <xsl:template match="*" mode="maketest">
        <xsl:param name="pckgname"/>
        <xsl:param name="testdata"/>
        <xsl:param name="dotpath"/>
        <xsl:apply-templates select="*" mode="maketest">
            <xsl:with-param name="pckgname" select="$pckgname"/>
            <xsl:with-param name="testdata" select="$testdata"/>
            <xsl:with-param name="dotpath" select="$dotpath"/>
        </xsl:apply-templates>
    </xsl:template>

    <!--Processes Ref Elements-->
    <xsl:template match="xs:element[@ref][not(@ref = 'StructuredPayload')]" mode="maketest">
        <xsl:param name="pckgname"/>
        <xsl:param name="testdata"/>
        <xsl:param name="dotpath"/>
        <xsl:variable name="r" select="@ref"/>
        <xsl:if test="exsl:node-set($testdata)//*[name() = $r]">
            <xsl:variable name="node" select="/xs:schema/xs:element[@name = $r]"/>
            <xsl:variable name="ty" select="$node/@type"/>
            <xsl:variable name="b" select="//xs:schema/xs:complexType[@name = $ty]//@base"/>
            <xsl:variable name="root" select="substring-before(substring-after($dotpath, '.'), '.')"/>
            <xsl:variable name="parent">
                <xsl:call-template name="lastel">
                    <xsl:with-param name="str" select="$dotpath"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when
                    test="not(//xs:schema/xs:complexType[@name = $ty]//xs:element[@ref]) and not(//xs:schema/xs:complexType[@name = $b]//xs:element[@ref])">
                    <xsl:variable name="ary1">
                        <xsl:if test="@maxOccurs > 1">
                            <xsl:text>[0]</xsl:text>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="testval">
                        <xsl:value-of
                            select="normalize-space(exsl:node-set($testdata)//*[name() = $root][1]//*[name() = $parent][1]//*[name() = $r][1])"
                        />
                    </xsl:variable>
                    <xsl:if test="string-length($testval) &gt; 0">
                        <xsl:value-of
                            select="concat($in, $in, $in, 'Expect(', $pckgname, $dotpath, '.', $r, $ary1, '.Value', ').To(Equal(', $qt, $testval, $qt, '))', $cr)"
                        />
                    </xsl:if>
                    <xsl:apply-templates select="//xs:schema/xs:complexType[@name = $ty]/*"
                        mode="maketest">
                        <xsl:with-param name="pckgname" select="$pckgname"/>
                        <xsl:with-param name="testdata" select="$testdata"/>
                        <xsl:with-param name="dotpath" select="concat($dotpath, '.', $r)"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="parentType"
                        select="/xs:schema/xs:element[@name = $parent]/@type"/>
                    <xsl:choose>
                        <xsl:when
                            test="//xs:schema/xs:complexType[@name = $parentType]//xs:element[@ref]">
                            <xsl:apply-templates select="//xs:schema/xs:complexType[@name = $ty]/*"
                                mode="maketest">
                                <xsl:with-param name="pckgname" select="$pckgname"/>
                                <xsl:with-param name="testdata" select="$testdata"/>
                                <xsl:with-param name="dotpath" select="concat($dotpath, '.', $r)"/>
                            </xsl:apply-templates>
                            <xsl:apply-templates select="//xs:schema/xs:complexType[@name = $b]/*"
                                mode="maketest">
                                <xsl:with-param name="pckgname" select="$pckgname"/>
                                <xsl:with-param name="testdata" select="$testdata"/>
                                <xsl:with-param name="dotpath" select="concat($dotpath, '.', $r)"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="concat('g.It(', $qt, 'Must Have ', $node/@name, $qt, $cm, 'func() {', $cr)"/>
                            <xsl:apply-templates select="//xs:schema/xs:complexType[@name = $ty]/*"
                                mode="maketest">
                                <xsl:with-param name="pckgname" select="$pckgname"/>
                                <xsl:with-param name="testdata" select="$testdata"/>
                                <xsl:with-param name="dotpath" select="concat($dotpath, '.', $r)"/>
                            </xsl:apply-templates>
                            <xsl:value-of select="concat($in, $in, '})', $cr)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xs:attribute[@ref]" mode="maketest">
        <xsl:param name="pckgname"/>
        <xsl:param name="testdata"/>
        <xsl:param name="dotpath"/>
        <xsl:variable name="r" select="@ref"/>
        <xsl:variable name="rn">
            <xsl:call-template name="varname">
                <xsl:with-param name="n" select="$r"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="exsl:node-set($testdata)//@*[name() = $r]">
            <xsl:variable name="node" select="/xs:schema/xs:attribute[@name = $r]"/>
            <xsl:variable name="ty" select="$node/@type"/>
            <xsl:variable name="b" select="//xs:schema/xs:complexType[@name = $ty]//@base"/>
            <xsl:variable name="root" select="substring-before(substring-after($dotpath, '.'), '.')"/>
            <xsl:variable name="parent">
                <xsl:call-template name="lastel">
                    <xsl:with-param name="str" select="$dotpath"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="testval">
                <xsl:choose>
                    <xsl:when test="string-length($parent) = 0">
                        <xsl:value-of
                            select="normalize-space(exsl:node-set($testdata)/*/@*[name() = $r])"/>
                    </xsl:when>
                    <xsl:when test="string-length($root) &gt; 0">
                        <xsl:value-of
                            select="normalize-space(exsl:node-set($testdata)//*[name() = $root][1]//*[name() = $parent][1]//@*[name() = $r][1])"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="normalize-space(exsl:node-set($testdata)//*[name() = $parent][1]//@*[name() = $r][1])"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="parentType" select="/xs:schema/xs:element[@name = $parent]/@type"/>
            <xsl:choose>
                <xsl:when test="string-length($parent) = 0">
                    <xsl:value-of
                        select="concat('g.It(', $qt, 'Must Have ', $node/@name, $qt, $cm, 'func() {', $cr)"/>
                    <xsl:value-of
                        select="concat($in, $in, $in, 'Expect(', $pckgname, $dotpath, '.', $rn, '.Value', ').To(Equal(', $qt, $testval, $qt, '))', $cr)"/>
                    <xsl:value-of select="concat($in, $in, '})', $cr)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="concat($in, $in, $in, 'Expect(', $pckgname, $dotpath, '.', $rn, '.Value', ').To(Equal(', $qt, $testval, $qt, '))', $cr)"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="xs:attributeGroup[@ref]" mode="maketest">
        <xsl:param name="pckgname"/>
        <xsl:param name="testdata"/>
        <xsl:param name="dotpath"/>
        <xsl:variable name="an" select="@ref"/>
        <xsl:apply-templates select="//xs:schema/xs:attributeGroup[@name = $an]/xs:attribute"
            mode="maketest">
            <xsl:with-param name="pckgname" select="$pckgname"/>
            <xsl:with-param name="testdata" select="$testdata"/>
            <xsl:with-param name="dotpath" select="$dotpath"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="xs:choice" mode="maketest">
        <xsl:param name="pckgname"/>
        <xsl:param name="testdata"/>
        <xsl:param name="dotpath"/>
        <xsl:variable name="n" select="xs:annotation/xs:appinfo//@substitutionGroup"/>
        <xsl:variable name="c">
            <xsl:value-of select="exsl:node-set($ChoiceSelections)/*[name() = $n]/@choice"/>
        </xsl:variable>
        <xsl:comment>
            <xsl:value-of select="concat($n, ' .. ', $c)"/>
        </xsl:comment>
        <xsl:apply-templates select="xs:element[@ref = $c]" mode="maketest">
            <xsl:with-param name="pckgname" select="$pckgname"/>
            <xsl:with-param name="testdata" select="$testdata"/>
            <xsl:with-param name="dotpath" select="$dotpath"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template name="lastel">
        <xsl:param name="str"/>
        <xsl:choose>
            <xsl:when test="contains($str, '.')">
                <xsl:call-template name="lastel">
                    <xsl:with-param name="str" select="substring-after($str, '.')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$str"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="varname">
        <xsl:param name="n"/>
        <xsl:choose>
            <xsl:when test="exsl:node-set($goVarChanges)/Rename[@from = $n]">
                <xsl:value-of select="exsl:node-set($goVarChanges)/Rename[@from = $n]/@to"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="uppercase">
                    <xsl:with-param name="txt" select="$n"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="uppercase">
        <xsl:param name="txt"/>
        <xsl:value-of
            select="translate(substring($txt, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        <xsl:value-of select="substring($txt, 2, string-length($txt) - 1)"/>
    </xsl:template>


</xsl:stylesheet>
