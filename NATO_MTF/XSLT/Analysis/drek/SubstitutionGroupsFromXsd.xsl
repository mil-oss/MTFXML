<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:include href="../NCDF_MTF/NcdfMap.xsl"/>

    <xsl:variable name="XSDPath" select="'../../XSD/APP-11C-ch1/Consolidated/'"/>
    <xsl:variable name="choices_out" select="'../../XSD/Analysis/ChoiceMaps.xml'"/>

    <xsl:variable name="norm_choices_out" select="'../../XSD/Analysis/NormChoiceMaps.xml'"/>

    <xsl:variable name="subgrps_out" select="'../../XSD/Analysis/SubGrpMaps.xml'"/>
    <xsl:variable name="chce_elements_out" select="'../../XSD/Analysis/ChoiceElements.xml'"/>

    <xsl:variable name="niem_map_choices">
        <xsl:for-each
            select="document(concat($XSDPath, 'sets.xsd'))//xsd:element[xsd:complexType/xsd:choice]">
            <xsl:sort select="@name"/>
            <xsl:apply-templates select="."/>
        </xsl:for-each>
        <xsl:for-each select="document(concat($XSDPath, 'messages.xsd'))//xsd:choice">
            <xsl:sort select="xsd:element[1]/@name"/>
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:variable>

    <!--Remove duplicates-->
    <xsl:variable name="norm_niem_map_choices">
        <xsl:variable name="map">
            <xsl:for-each select="$niem_map_choices/*">
                <xsl:copy copy-namespaces="no">
                    <xsl:copy-of select="@substgrpname"/>
                    <xsl:copy-of select="@messagename"/>
                    <xsl:copy-of select="@setname"/>
                    <xsl:copy-of select="@parentname"/>
                    <Choice>
                        <xsl:for-each select="Choice/Element">
                            <xsl:variable name="n" select="@niemelementname"/>
                            <xsl:variable name="t" select="@niemtype"/>
                            <xsl:copy copy-namespaces="no">
                                <xsl:copy-of select="@mtfname"/>
                                <xsl:copy-of select="@niemelementname"/>
                                <xsl:copy-of select="@mtftype"/>
                                <xsl:copy-of select="@niemtype"/>
                                <xsl:for-each
                                    select="$niem_map_choices/*[Choice/Element[@niemelementname = $n][@niemtype = $t]]">
                                    <SubGrp>
                                        <xsl:copy-of select="@substgrpname"/>
                                        <xsl:copy-of select="@parentname"/>
                                        <xsl:copy-of select="@setname"/>
                                        <xsl:copy-of select="@messagename"/>
                                    </SubGrp>
                                </xsl:for-each>
                            </xsl:copy>
                        </xsl:for-each>
                    </Choice>
                </xsl:copy>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$map/Element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@substgrpname"/>
            <xsl:variable name="c" select="Choice"/>
            <xsl:variable name="precnt"
                select="count(preceding-sibling::Element[@substgrpname = $n][deep-equal(Choice, $c)])"/>
            <xsl:if test="$precnt = 0">
                <xsl:copy-of select="." copy-namespaces="no"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="chce_elements">
        <xsl:for-each select="$norm_niem_map_choices/Element">
            <xsl:sort select="@substgrpname"/>
            <xsl:for-each select="Choice/Element">
                <xsl:sort select="@niemelementname"/>
                <xsl:copy copy-namespaces="no">
                    <xsl:for-each select="@*">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                    <xsl:for-each select="SubGrp">
                        <xsl:variable name="s" select="@substgrpname"/>
                        <xsl:if test="count(preceding-sibling::SubGrp[@substgrpname = $s]) = 0">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="elist">
        <xsl:for-each select="$chce_elements/*">
            <xsl:sort select="@name"/>
            <xsl:copy copy-namespaces="no">
                <xsl:for-each select="@*">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
                <xsl:variable name="n" select="@name"/>
                <xsl:variable name="t" select="@mtftype"/>
                <xsl:variable name="s" select="@substitutiongroup"/>
                <xsl:variable name="sg">
                    <Subgrp name="{@substitutiongroup}"/>
                    <xsl:for-each
                        select="$chce_elements/*[@name = $n][@mtftype = $t][not(@substitutiongroup = $s)]">
                        <Subgrp name="{@substitutiongroup}" elname="{$n}"/>
                    </xsl:for-each>
                </xsl:variable>
                <Subgrps>
                    <xsl:for-each select="$sg/*">
                        <xsl:sort select="@name"/>
                        <xsl:variable name="sn" select="@name"/>
                        <xsl:if test="count(preceding-sibling::*[@name = $sn]) = 0">
                            <xsl:copy-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                </Subgrps>
            </xsl:copy>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="elist_subgrps">
        <xsl:for-each select="$elist/*">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@mtftype"/>
            <xsl:variable name="sg" select="Subgrps"/>
            <xsl:variable name="dups"
                select="count($elist/Element[deep-equal(*:Subgrps, $sg)][@name = $n])"/>
            <xsl:copy>
                <xsl:for-each select="@*">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:attribute name="dups">
                    <xsl:value-of select="$dups"/>
                </xsl:attribute>
                <xsl:variable name="s" select="@setname"/>
                <Subgrps>
                    <xsl:attribute name="count">
                        <xsl:value-of select="count($sg/*)"/>
                    </xsl:attribute>
                    <xsl:for-each select="$sg/*">
                        <substitutionGroup parentmtfname="{@name}" substgrpname="{@name}" setname=""
                        />
                    </xsl:for-each>
                </Subgrps>
            </xsl:copy>
        </xsl:for-each>
    </xsl:variable>

    <!--<xsl:variable name="subGrps">
        <SubstitutionGroups>
            <xsl:for-each select="$chces/*">
                <xsl:sort select="Choice/Element[1]/@name"/>
                <xsl:sort select="@name"/>
                <xsl:sort select="@members"/>
                <xsl:variable name="subGrp" select="@substgrpname"/>
                <xsl:variable name="set" select="@setname"/>
                <xsl:variable name="seg" select="@segmentname"/>
                <xsl:variable name="msg" select="@messagename"/>
                <xsl:variable name="c" select="Choice"/>
                <xsl:variable name="count" select="count($chces/*[deep-equal(Choice, $c)])"/>
                <xsl:variable name="members">
                    <xsl:for-each select="Choice/Element">
                        <xsl:variable name="n" select="@name"/>
                        <xsl:variable name="t" select="@mtftype"/>
                        <!-\-<xsl:if test="not(parent::*/preceding-sibling::*[Choice[Element[@name = $n][@mtftype = $t]]])">-\->
                        <xsl:variable name="allelementsfromallchoicesthatincludethisone">
                            <xsl:for-each select="$chces//Choice[Element[@name = $n and @mtftype = $t]]">
                                <xsl:for-each select="./Element">
                                    <xsl:copy-of select="."/>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:for-each select="$allelementsfromallchoicesthatincludethisone/Element">
                            <xsl:sort select="@name"/>
                            <xsl:variable name="en" select="@name"/>
                            <xsl:variable name="et" select="@mtftype"/>
                            <!-\-remove duplicates-\->
                            <xsl:if test="count(preceding-sibling::Element[@name = $en][@mtftype = $et]) = 0">
                                <xsl:copy-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                        <!-\-</xsl:if>-\->
                    </xsl:for-each>
                </xsl:variable>
                <substitutionGroup>
                    <xsl:if test="@name">
                        <xsl:attribute name="parentmtfname">
                            <xsl:value-of select="@name"/>
                        </xsl:attribute>
                    </xsl:if>
                    <!-\-<xsl:copy-of select="@substgrpname"/>-\->
                    <xsl:attribute name="count" select="$count"/>
                    <xsl:copy-of select="@members"/>
                    <!-\- <xsl:copy-of select="$set"/>
                    <xsl:copy-of select="$seg"/>
                    <xsl:copy-of select="$msg"/>
                    <xsl:copy-of select="@positionName"/>
                    <xsl:copy-of select="@substgrpdoc"/>
                    <xsl:copy-of select="@concept"/>-\->
                    <xsl:variable name="choices">
                        <xsl:for-each select="$members/*">
                            <xsl:variable name="mn" select="@name"/>
                            <xsl:variable name="mt" select="@mtftype"/>
                            <xsl:for-each select="$chces/Element[Choice[Element[@name = $mn and @mtftype = $mt]]]">
                                <Choice name="{@substgrpname}"/>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:variable>
                    <Choices>
                        <xsl:for-each select="$choices/*">
                            <xsl:sort select="@name"/>
                            <xsl:variable name="sn" select="@name"/>
                            <xsl:if test="count(preceding-sibling::*[@name = $sn]) = 0">
                                <xsl:copy-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </Choices>
                    <Members>
                        <!-\-<xsl:copy-of select="." copy-namespaces="no"/>-\->
                        <xsl:for-each select="$members/*">
                            <xsl:sort select="@name"/>
                            <!-\-<xsl:variable name="en" select="@mtfname"/>-\->
                            <xsl:variable name="en" select="@name"/>
                            <xsl:variable name="et" select="@mtftype"/>
                            <!-\-remove duplicates-\->
                            <xsl:if test="count(preceding-sibling::Element[@name = $en][@mtftype = $et]) = 0">
                                <xsl:copy-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </Members>
                </substitutionGroup>
                <xsl:for-each select="$members/*">
                    <xsl:sort select="@name"/>
                    <xsl:variable name="en" select="@name"/>
                    <xsl:variable name="et" select="@mtftype"/>
                    <xsl:if test="count(preceding-sibling::Element[@name = $en][@mtftype = $et]) = 0">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </SubstitutionGroups>
    </xsl:variable>

    <xsl:variable name="elmnts">
        <xsl:for-each select="$subGrps/SubstitutionGroups/Element">
            <xsl:sort select="@name"/>
            <xsl:variable name="n" select="@name"/>
            <xsl:variable name="t" select="@mtftype"/>
            <xsl:variable name="s" select="@substgrpname"/>
            <xsl:variable name="preqm" select="count(preceding-sibling::*[@name = $n and @mtftype = $t and @substgrpname = $s])"/>
            <xsl:if test="$preqm = 0">
                <xsl:copy-of select="." copy-namespaces="no"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>
-->
    <xsl:template name="main">
        <xsl:result-document href="{$choices_out}">
            <MtfChoices>
                <xsl:for-each select="$niem_map_choices/*">
                    <xsl:sort select="@substgrpname"/>
                    <xsl:sort select="@mtfname"/>
                    <xsl:sort select="@choicename"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </MtfChoices>
        </xsl:result-document>
        <xsl:result-document href="{$norm_choices_out}">
            <MtfChoices>
                <xsl:for-each select="$norm_niem_map_choices/Element">
                    <xsl:sort select="@substgrpname"/>
                    <xsl:variable name="n" select="@substgrpname"/>
                    <xsl:copy>
                        <xsl:for-each select="@*">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                        <xsl:if test="count($norm_niem_map_choices/*[@substgrpname = $n]) &gt; 1">
                            <xsl:attribute name="count">
                                <xsl:value-of
                                    select="count($norm_niem_map_choices/*[@substgrpname = $n])"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:for-each select="Choice">
                            <xsl:copy copy-namespaces="no">
                                <xsl:for-each select="@*">
                                    <xsl:copy-of select="."/>
                                </xsl:for-each>
                                <xsl:for-each select="Element">
                                    <xsl:copy copy-namespaces="no">
                                        <xsl:for-each select="@*">
                                            <xsl:copy-of select="."/>
                                        </xsl:for-each>
                                    </xsl:copy>
                                </xsl:for-each>
                            </xsl:copy>
                        </xsl:for-each>
                        <!--<xsl:copy-of select="Choice" copy-namespaces="no"/>-->
                    </xsl:copy>
                </xsl:for-each>
            </MtfChoices>
        </xsl:result-document>
        <xsl:result-document href="{$chce_elements_out}">
            <ChoiceElements>
                <xsl:for-each select="$chce_elements/Element">
                    <xsl:sort select="@niemelementname"/>
                    <!--<xsl:if test="count(SubGrp) &gt; 1">-->
                    <xsl:copy copy-namespaces="no">
                        <xsl:copy-of select="@mtfname"/>
                        <xsl:copy-of select="@mtftype"/>
                        <xsl:copy-of select="@niemelementname"/>
                        <xsl:copy-of select="@niemtype"/>
                        <!--<xsl:copy-of select="SubGrp/@substgrpname"/>
                        <xsl:copy-of select="SubGrp/@parentname"/>-->
                        <xsl:for-each select="SubGrp">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </xsl:copy>
                    <!--</xsl:if>-->
                </xsl:for-each>
            </ChoiceElements>
        </xsl:result-document>

        <xsl:result-document href="{$subgrps_out}">
            <SubstitutionGroups>
                <xsl:for-each select="$chce_elements/*">
                    <xsl:sort select="@name"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </SubstitutionGroups>
        </xsl:result-document>
        <!--<xsl:result-document href="{$chce_elements_out}">
            <ChoiceElements>
                <xsl:for-each select="$elist_subgrps/*">
                    <xsl:sort select="@name"/>
                    <xsl:if test="Subgrps/@count &gt; 1">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </ChoiceElements>
        </xsl:result-document>-->
    </xsl:template>

</xsl:stylesheet>
