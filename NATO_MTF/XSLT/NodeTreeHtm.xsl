<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="html"/>
    
    <xsl:param name="tagName"/>
    
<!--Creates HTML Tree View of XML -->
    
    <xsl:template match="/">
        <div>
            <h3>
                <xsl:value-of select="$tagName"/>
            </h3>
            <div class="xmlnodetree">
                <ul>
                    <xsl:apply-templates/>
                </ul>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="processing-instruction()">
        <div class="e">
            <span class="b">
                <xsl:text>&#032;</xsl:text>
            </span>
            <span class="m">
                <xsl:text>&#060;&#063;</xsl:text>
            </span>
            <span class="pi">
                <xsl:value-of select="name(.)"/>
                <xsl:value-of select="."/>
            </span>
            <span class="m">
                <xsl:text>?></xsl:text>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="processing-instruction('xml')">
        <div class="e">
            <span class="b">
                <xsl:text>&#032;</xsl:text>
            </span>
            <span class="m">
                <xsl:text>&#060;&#063;</xsl:text>
            </span>
            <span class="pi">
                <xsl:text>xml </xsl:text>
                <xsl:for-each select="@*">
                    <xsl:value-of select="name(.)"/>
                    <xsl:text>="</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" </xsl:text>
                </xsl:for-each>
            </span>
            <span class="m">
                <xsl:text>?></xsl:text>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="@*">
        <span>
            <xsl:attribute name="class">
                <xsl:if test="xsl:*/@*">
                    <xsl:text>x</xsl:text>
                </xsl:if>
                <xsl:text>at</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="concat('&#032;',name(.))"/>
        </span>
        <span class="m">="</span>
        <b>
            <xsl:value-of select="."/>
        </b>
        <span class="m">"</span>
    </xsl:template>

    <xsl:template match="text()">
        <div class="e">
            <span class="b"> </span>
            <span class="tx">
                <xsl:value-of select="."/>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="comment()">
        <div class="k">
            <span>
                <a style="visibility:hidden" class="b" onclick="return false" onfocus="h()">-</a>
                <span class="m">
                    <xsl:text/>
                </span>
            </span>
            <span class="ci" id="clean">
                <pre>
                    <xsl:value-of select="."/>
                </pre>
            </span>
            <span class="b">
                <xsl:text>&#032;</xsl:text>
            </span>
            <span class="m">
                <xsl:text>
                </xsl:text>
            </span>
            <script>f(clean);</script>
        </div>
    </xsl:template>

    <xsl:template match="*">
        <div class="e">
            <div style="margin-left:1em;text-indent:-2em">
                <span class="b">
                    <xsl:text>&#032;</xsl:text>
                </span>
                <span class="m">&#060;</span>
                <span>
                    <xsl:attribute name="class">
                        <xsl:if test="xsl:*">
                            <xsl:text>x</xsl:text>
                        </xsl:if>
                        <xsl:text>t</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="name(.)"/>
                    <xsl:if test="@*">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </span>
                <xsl:apply-templates select="@*"/>
                <span class="m">
                    <xsl:text>/></xsl:text>
                </span>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="*[node()]">
        <div class="e">
            <div class="c">
                <a class="b" href="#" onclick="return false" onfocus="h()">-</a>
                <span class="m">&#060;</span>
                <span>
                    <xsl:attribute name="class">
                        <xsl:if test="xsl:*">
                            <xsl:text>x</xsl:text>
                        </xsl:if>
                        <xsl:text>t</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="name(.)"/>
                    <xsl:if test="@*">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </span>
                <xsl:apply-templates select="@*"/>
                <span class="m">
                    <xsl:text>></xsl:text>
                </span>
            </div>
            <div>
                <xsl:apply-templates/>
                <div>
                    <span class="b">
                        <xsl:text>&#032;</xsl:text>
                    </span>
                    <span class="m">
                        <xsl:text>&#060;&#047;</xsl:text>
                    </span>
                    <span>
                        <xsl:attribute name="class">
                            <xsl:if test="xsl:*">
                                <xsl:text>x</xsl:text>
                            </xsl:if>
                            <xsl:text>t</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="name(.)"/>
                    </span>
                    <span class="m">
                        <xsl:text>></xsl:text>
                    </span>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="*[text() and not (comment() or processing-instruction())]">
        <div class="e">
            <div style="margin-left:1em;text-indent:-2em">
                <span class="b">
                    <xsl:text>&#032;</xsl:text>
                </span>
                <span class="m">
                    <xsl:text>&#060;</xsl:text>
                </span>
                <span>
                    <xsl:attribute name="class">
                        <xsl:if test="xsl:*">
                            <xsl:text>x</xsl:text>
                        </xsl:if>
                        <xsl:text>t</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="name(.)"/>
                    <xsl:if test="@*">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </span>
                <xsl:apply-templates select="@*"/>
                <span class="m">
                    <xsl:text>></xsl:text>
                </span>
                <span class="tx">
                    <xsl:value-of select="."/>
                </span>
                <span class="m">&#060;&#047;</span>
                <span>
                    <xsl:attribute name="class">
                        <xsl:if test="xsl:*">
                            <xsl:text>x</xsl:text>
                        </xsl:if>
                        <xsl:text>t</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="name(.)"/>
                </span>
                <span class="m">
                    <xsl:text>></xsl:text>
                </span>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="*[*]" priority="20">
        <div class="e">
            <div style="margin-left:1em;text-indent:-2em" class="c">
                <a class="b" href="#" onclick="return false" onfocus="h()">-</a>
                <span class="m">&#060;</span>
                <span>
                    <xsl:attribute name="class">
                        <xsl:if test="xsl:*">
                            <xsl:text>x</xsl:text>
                        </xsl:if>
                        <xsl:text>t</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="name(.)"/>
                    <xsl:if test="@*">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </span>
                <xsl:apply-templates select="@*"/>
                <span class="m">
                    <xsl:text>></xsl:text>
                </span>
            </div>
            <div>
                <xsl:apply-templates/>
                <div>
                    <span class="b">
                        <xsl:text>&#032;</xsl:text>
                    </span>
                    <span class="m">
                        <xsl:text>&#060;&#047;</xsl:text>
                    </span>
                    <span>
                        <xsl:attribute name="class">
                            <xsl:if test="xsl:*">
                                <xsl:text>x</xsl:text>
                            </xsl:if>
                            <xsl:text>t</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="name(.)"/>
                    </span>
                    <span class="m">
                        <xsl:text>></xsl:text>
                    </span>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="entity-ref">
        <xsl:param name="name"/>
        <xsl:text disable-output-escaping="yes">&#038;</xsl:text>
        <xsl:value-of select="$name"/>
        <xsl:text>;</xsl:text>
    </xsl:template>

</xsl:stylesheet>
