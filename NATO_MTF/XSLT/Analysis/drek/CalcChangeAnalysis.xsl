<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template name="calcChanges">
        <xsl:param name="field_map"/>
        <xsl:param name="composite_map"/>
        <xsl:param name="set_map"/>
        <xsl:param name="segment_map"/>
        <xsl:param name="message_map"/>
        
        <xsl:variable name="msg_seg_chg_list">
            <xsl:for-each select="$message_map//Element">
                <xsl:choose>
                    <xsl:when test="@mtfname = @niemelementname"/>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="$segment_map//Element">
                <xsl:choose>
                    <xsl:when test="@mtfname = @niemelementname"/>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="msg_seg_chg">
            <xsl:for-each select="$msg_seg_chg_list/*">
                <xsl:sort select="@mtfname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[@mtfname = $n and @niemelementname = $ne]"/>
                    <xsl:when test="not(@mtfname)"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="msg_seg_new">
            <xsl:for-each select="$msg_seg_chg_list/*[not(@mtfname)][not(@abstract)]">
                <xsl:sort select="@niemelementname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[@niemelementname = $ne]"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="msg_seg_abstracts">
            <xsl:for-each select="$msg_seg_chg_list/Element[ends-with(@niemelementname,'Choice') or @substgrpname]">
                <xsl:sort select="@mtfname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[@mtfname = $n and @niemelementname = $ne]"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="msg_seg_conflicts">
            <xsl:for-each select="$msg_seg_chg_list/*[@mtfname][@niemelementname][not(@substitutiongroup)][not(@substgrpname)]">
                <xsl:sort select="@mtfname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[@mtfname = $n and @niemelementname = $ne]"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="msg_seg_subgrps">
            <xsl:for-each select="$msg_seg_chg_list/*[@substitutiongroup]">
                <xsl:sort select="@niemelementname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="preceding-sibling::*[@mtfname = $n and @niemelementname = $ne]"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="sets_chg_list">
            <xsl:for-each select="$set_map//Element[@niemelementname]">
                <xsl:choose>
                    <xsl:when test="@mtfname = @niemelementname"/>
                    <xsl:otherwise>
                        <xsl:copy-of select="." copy-namespaces="no"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="$set_map//Sequence[@name = 'GroupOfFields']">
                <xsl:choose>
                    <xsl:when test="count(Element) = 1 and Element/@substgrpname">
                        <xsl:copy-of select="Element"/>
                    </xsl:when>
                    <xsl:when test="count(Element) = 1 and Element/@mtfname != Element/@niemelementname">
                        <xsl:copy-of select="Element"/>
                    </xsl:when>
                    <xsl:when test="count(Element) &gt; 1 and ancestor::Set/@niemelementname">
                        <Element mtfname="FieldGroup" setname="{ancestor::Set/@mtfname}" setniemname="{ancestor::Set/@niemelementname}"
                            niemelementname="{concat(ancestor::Set/@niemelementname,'FieldGroup')}" niemtype="{concat(ancestor::Set/@niemelementname,'FieldGroupType')}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="sets_chg">
            <xsl:for-each select="$sets_chg_list/Element">
                <xsl:sort select="@mtfname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="fn" select="@fieldname"/>
                <xsl:variable name="sn" select="@setniemname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="count(preceding-sibling::Element[@mtfname = $n and @niemelementname = $ne]) > 0"/>
                    <xsl:when test="count(preceding-sibling::Element[@fieldname = $fn and @niemelementname = $ne]) > 0"/>
                    <xsl:when test="count(preceding-sibling::Element[@setniemname = $sn and @niemelementname = $ne]) > 0"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="sets_new_el">
            <xsl:for-each select="$sets_chg_list/Element[not(@mtfname)][not(@substgrpname)]">
                <xsl:sort select="@niemelementname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="fn" select="@fieldname"/>
                <xsl:variable name="sn" select="@setniemname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="count(preceding-sibling::*[@mtfname = $n and @niemelementname = $ne]) > 0"/>
                    <xsl:when test="count(preceding-sibling::*[@fieldname = $fn and @niemelementname = $ne]) > 0"/>
                    <xsl:when test="count(preceding-sibling::*[@setniemname = $sn and @niemelementname = $ne]) > 0"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="sets_abstracts">
            <xsl:for-each select="$sets_chg_list/Element[ends-with(@niemelementname,'Choice') or @substgrpname]">
                <xsl:sort select="@niemelementname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="fn" select="@fieldname"/>
                <xsl:variable name="sn" select="@setniemname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="count(preceding-sibling::Element[@mtfname = $n and @niemelementname = $ne]) > 0"/>
                    <xsl:when test="count(preceding-sibling::Element[@fieldname = $fn and @niemelementname = $ne]) > 0"/>
                    <xsl:when test="count(preceding-sibling::Element[@setniemname = $sn and @niemelementname = $ne]) > 0"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="set_conflict">
            <xsl:for-each select="$sets_chg_list/Element[@mtfname][@niemelementname][not(@substitutiongroup)]">
                <xsl:sort select="@niemelementname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="fn" select="@fieldname"/>
                <xsl:variable name="sn" select="@setniemname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="count(preceding-sibling::Element[@mtfname = $n and @niemelementname = $ne]) > 0"/>
                    <xsl:when test="count(preceding-sibling::Element[@fieldname = $fn and @niemelementname = $ne]) > 0"/>
                    <xsl:when test="count(preceding-sibling::Element[@setniemname = $sn and @niemelementname = $ne]) > 0"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="set_subgrp">
            <xsl:for-each select="$sets_chg_list/Element[@substitutiongroup]">
                <xsl:sort select="@niemelementname"/>
                <xsl:variable name="n" select="@mtfname"/>
                <xsl:variable name="fn" select="@fieldname"/>
                <xsl:variable name="sn" select="@setniemname"/>
                <xsl:variable name="ne" select="@niemelementname"/>
                <xsl:choose>
                    <xsl:when test="count(preceding-sibling::*[@mtfname = $n and @niemelementname = $ne]) > 0"/>
                    <xsl:when test="count(preceding-sibling::*[@fieldname = $fn and @niemelementname = $ne]) > 0"/>
                    <xsl:when test="count(preceding-sibling::*[@setniemname = $sn and @niemelementname = $ne]) > 0"/>
                    <xsl:otherwise>
                        <xsl:copy copy-namespaces="no">
                            <xsl:for-each select="@*">
                                <xsl:copy-of select="." copy-namespaces="no"/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="field_chg">
            <xsl:for-each select="$field_map//Element[@niemelementname][@mtfname]">
                <xsl:choose>
                    <xsl:when test="@mtfname = @niemelementname"/>
                    <xsl:otherwise>
                        <Element mtfname="{@mtfname}" niemelementname="{@niemelementname}" niemsimpletype="{@niemsimpletype}" niemcomplextype="{@niemcomplextype}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="field_new">
            <xsl:for-each select="$field_map//Element[@niemelementname!=@niemcomplextype]">
                <xsl:choose>
                    <xsl:when test="@mtfname = @niemcomplextype"/>
                    <xsl:otherwise>
                        <Element mtfname="{@mtfname}" niemelementname="{@niemelementname}" niemsimpletype="{@niemsimpletype}" niemcomplextype="{@niemcomplextype}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="comp_chg">
            <xsl:for-each select="$composite_map//Element[@mtfname][@niemelementname]">
                <xsl:choose>
                    <xsl:when test="@mtfelementname = @niemelementname"/>
                    <xsl:otherwise>
                        <Element mtfname="{@mtfname}" mtftype="{@mtftype}" niemelementname="{@niemelementname}" niemtype="{@niemelementtype}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="comp_new">
            <xsl:for-each select="$composite_map//Element[@niemelementname][not(@mtfname)]">
                <xsl:choose>
                    <xsl:when test="@mtfelementname = @niemelementname"/>
                    <xsl:otherwise>
                        <Element mtfname="{@mtfname}" mtftype="{@mtftype}" niemelementname="{@niemelementname}" niemtype="{@niemelementtype}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="fcount">
            <xsl:value-of select="count($field_map//*[@niemelementname])"/>
        </xsl:variable>
        <xsl:variable name="ccount">
            <xsl:value-of select="count($composite_map//Element[@niemelementname])"/>
        </xsl:variable>
        <xsl:variable name="scount">
            <xsl:value-of select="count($set_map//Element[@mtfname])"/>
        </xsl:variable>
        <xsl:variable name="msgcount">
            <xsl:value-of select="count($message_map//Element[@niemelementname])"/>
        </xsl:variable>

        <xsl:variable name="fchg">
            <xsl:value-of select="count($field_chg//Element)"/>
        </xsl:variable>
        <xsl:variable name="fnew">
            <xsl:value-of select="count($field_new//Element)"/>
        </xsl:variable>
        <xsl:variable name="cchg">
            <xsl:value-of select="count($comp_chg//Element)"/>
        </xsl:variable>
        <xsl:variable name="cnew">
            <xsl:value-of select="count($comp_new//Element)"/>
        </xsl:variable>
        <xsl:variable name="schg">
            <xsl:value-of select="count($sets_chg//Element)"/>
        </xsl:variable>

        <xsl:variable name="schg">
            <xsl:value-of select="count($sets_chg//Element)"/>
        </xsl:variable>
        <xsl:variable name="snew">
            <xsl:value-of select="count($sets_new_el//Element)"/>
        </xsl:variable>
        <xsl:variable name="sabs">
            <xsl:value-of select="count($sets_abstracts//Element)"/>
        </xsl:variable>
        <xsl:variable name="scflct">
            <xsl:value-of select="count($set_conflict//Element)"/>
        </xsl:variable>
        <xsl:variable name="ssbgrp">
            <xsl:value-of select="count($set_subgrp//Element)"/>
        </xsl:variable>

        <xsl:variable name="mschg">
            <xsl:value-of select="count($msg_seg_chg//Element)"/>
        </xsl:variable>
        <xsl:variable name="msnew">
            <xsl:value-of select="count($msg_seg_new//Element)"/>
        </xsl:variable>
        <xsl:variable name="msabs">
            <xsl:value-of select="count($msg_seg_abstracts//Element)"/>
        </xsl:variable>
        <xsl:variable name="mscflct">
            <xsl:value-of select="count($msg_seg_conflicts//Element)"/>
        </xsl:variable>
        <xsl:variable name="mssbgrp">
            <xsl:value-of select="count($msg_seg_subgrps//Element)"/>
        </xsl:variable>
        <Elements>
            <xsl:attribute name="fieldcount">
                <xsl:value-of select="$fcount"/>
            </xsl:attribute>
            <xsl:attribute name="fieldchanges">
                <xsl:value-of select="count($field_chg/*)"/>
            </xsl:attribute>
            <xsl:attribute name="fieldnew">
                <xsl:value-of select="count($field_new/*)"/>
            </xsl:attribute>
            <xsl:attribute name="compositecount">
                <xsl:value-of select="$ccount"/>
            </xsl:attribute>
            <xsl:attribute name="compositechanges">
                <xsl:value-of select="count($comp_chg/*)"/>
            </xsl:attribute>
            <xsl:attribute name="compositenew">
                <xsl:value-of select="count($comp_new/*)"/>
            </xsl:attribute>
            <xsl:attribute name="setcount">
                <xsl:value-of select="$scount"/>
            </xsl:attribute>
            <xsl:attribute name="setchanges">
                <xsl:value-of select="count($sets_chg/Element)"/>
            </xsl:attribute>
            <xsl:attribute name="setsnew">
                <xsl:value-of select="count($sets_new_el/Element)"/>
            </xsl:attribute>
            <xsl:attribute name="setsabstracts">
                <xsl:value-of select="count($sets_abstracts)"/>
            </xsl:attribute>
            <xsl:attribute name="setsconflicts">
                <xsl:value-of select="count($set_conflict)"/>
            </xsl:attribute>            
            <xsl:attribute name="setsubgroup">
                <xsl:value-of select="count($set_subgrp/Element)"/>
            </xsl:attribute>
            <xsl:attribute name="messagecount">
                <xsl:value-of select="$msgcount"/>
            </xsl:attribute>
            <xsl:attribute name="messagechanges">
                <xsl:value-of select="count($msg_seg_chg/Element)"/>
            </xsl:attribute>
            <xsl:attribute name="messagesnew">
                <xsl:value-of select="count($msg_seg_new/Element)"/>
            </xsl:attribute>
            <xsl:attribute name="messagesabstracts">
                <xsl:value-of select="count($msg_seg_abstracts/Element)"/>
            </xsl:attribute>
            <xsl:attribute name="messageconflicts">
                <xsl:value-of select="count($msg_seg_conflicts/Element)"/>
            </xsl:attribute>
            <xsl:attribute name="msgsubgroup">
                <xsl:value-of select="count($msg_seg_subgrps/Element)"/>
            </xsl:attribute>
            <MessageChanges count="{count($msg_seg_chg/*)}">
                <xsl:for-each select="$msg_seg_chg/Element[@mtfname]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </MessageChanges>
            <!--<xsl:if test="count($msg_seg_new/Element) &gt; 0">-->
                <MessageElementsNew count="{count($msg_seg_new/Element)}">
                    <xsl:for-each select="$msg_seg_new/Element">
                        <xsl:sort select="@niemelementname"/>
                        <Element mtfname="{@mtfname}" mtftype="{@mtftype}" messagename="{@messagename}" niemelementname="{@niemelementname}" niemtype="{@niemtype}"/>
                    </xsl:for-each>
                </MessageElementsNew>
            <!--</xsl:if>-->
            <!--<xsl:if test="count($msg_seg_abstracts/Element) &gt; 0">-->
                <MessageAbstracts count="{count($msg_seg_abstracts/Element)}">
                    <xsl:for-each select="$msg_seg_abstracts/Element">
                        <xsl:sort select="@name"/>
                        <Element mtfname="{@mtfname}" mtftype="{@mtftype}" messagename="{@messagename}" niemelementname="{@niemelementname}" niemtype="{@niemtype}"/>
                    </xsl:for-each>
                </MessageAbstracts>
            <!--</xsl:if>-->
            <!--<xsl:if test="count($msg_seg_conflicts/Element) &gt; 0">-->
                <MessageConflictChanges count="{count($msg_seg_conflicts/Element)}">
                    <xsl:for-each select="$msg_seg_conflicts/Element">
                        <xsl:sort select="@name"/>
                        <Element mtfname="{@mtfname}" mtftype="{@mtftype}" messagename="{@messagename}" niemelementname="{@niemelementname}" niemtype="{@niemtype}"/>
                    </xsl:for-each>
                </MessageConflictChanges>
            <!--</xsl:if>-->
            <!--<xsl:if test="count($msg_seg_subgrps/Element) &gt; 0">-->
                <MessageSubstitutionGroupMemberChanges count="{count($msg_seg_subgrps/Element)}">
                    <xsl:for-each select="$msg_seg_subgrps/Element">
                        <xsl:sort select="@name"/>
                        <Element mtfname="{@mtfname}" mtftype="{@mtftype}" messagename="{@messagename}" niemelementname="{@niemelementname}" niemtype="{@niemtype}"/>
                    </xsl:for-each>
                </MessageSubstitutionGroupMemberChanges>
            <!--</xsl:if>-->
            <SetChanges count="{count($sets_chg/*)}">
                <xsl:for-each select="$sets_chg/Element[@mtfname]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </SetChanges>
           <!-- <xsl:if test="count($sets_new_el/Element) &gt; 0">-->
                <SetElementsNew count="{count($sets_new_el/Element)}">
                    <xsl:for-each select="$sets_new_el/Element">
                        <xsl:sort select="@niemelementname"/>
                        <Element mtfname="{@mtfname}" mtftype="{@mtftype}" messagename="{@messagename}" niemelementname="{@niemelementname}" niemtype="{@niemtype}"/>
                    </xsl:for-each>
                </SetElementsNew>
            <!--</xsl:if>-->
            <!--<xsl:if test="count($sets_abstracts/Element) &gt; 0">-->
                <SetsAbstracts count="{count($sets_abstracts/Element)}">
                    <xsl:for-each select="$sets_abstracts/Element">
                        <xsl:sort select="@name"/>
                        <Element mtfname="{@mtfname}" mtftype="{@mtftype}" messagename="{@messagename}" niemelementname="{@niemelementname}" niemtype="{@niemtype}"/>
                    </xsl:for-each>
                </SetsAbstracts>
            <!--</xsl:if>-->
            <!--<xsl:if test="count($set_conflict/Element) &gt; 0">-->
                <SetConflictChanges count="{count($set_conflict/Element)}">
                    <xsl:for-each select="$set_conflict/Element">
                        <xsl:sort select="@name"/>
                        <Element mtfname="{@mtfname}" mtftype="{@mtftype}" messagename="{@messagename}" niemelementname="{@niemelementname}" niemtype="{@niemtype}"/>
                    </xsl:for-each>
                </SetConflictChanges>
            <!--</xsl:if>-->
            <!--<xsl:if test="count($set_subgrp/Element) &gt; 0">-->
                <SetSubstitutionGroupMemberChanges count="{count($set_subgrp/Element)}">
                    <xsl:for-each select="$set_subgrp/Element">
                        <xsl:sort select="@name"/>
                        <Element mtfname="{@mtfname}" mtftype="{@mtftype}" messagename="{@messagename}" niemelementname="{@niemelementname}" niemtype="{@niemtype}"/>
                    </xsl:for-each>
                </SetSubstitutionGroupMemberChanges>
            <!--</xsl:if>-->
            <CompositeNew count="{count($comp_new/*)}">
                <xsl:for-each select="$comp_new/Element">
                    <xsl:sort select="@niemelementname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </CompositeNew>
            <CompositeChanges count="{count($comp_chg/*)}">
                <xsl:for-each select="$comp_chg/Element[@mtfname]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </CompositeChanges>
            <FieldNew count="{count($field_new/*)}">
                <xsl:for-each select="$field_new/*">
                    <xsl:sort select="@niemelementname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </FieldNew>
            <FieldChanges count="{count($field_chg/*)}">
                <xsl:for-each select="$field_chg/*[@mtfname]">
                    <xsl:sort select="@mtfname"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </FieldChanges>
        </Elements>
    </xsl:template>
</xsl:stylesheet>
