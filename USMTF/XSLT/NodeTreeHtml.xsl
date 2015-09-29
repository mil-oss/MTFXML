<!--
/* 
 * Copyright (C) 2015 JD NEUSHUL
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
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">
    <xsl:output method="html"/>
    <xsl:template match="/">

        <xsl:param name="nodeName"
            select="'A NEGATIVE BLOOD COUNT'"/>

        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>XML Node Tree</title>
                <link rel="stylesheet" href="css/schemaView.css"/>
                <link rel="stylesheet" href="css/themes/default/style.css"/>
                <link rel="stylesheet" href="css/screen.css"/>
            </head>
            <body>
                <div id="header">
                    <h1 id="banner">XML Node List</h1>
                </div>
                <div class="left_col">
                    <h4>
                        <xsl:value-of
                            select="xsd:schema/xsd:*[@name=$nodeName]/xsd:annotation/xsd:appinfo[1]/*:Field/@name"
                        />
                    </h4>
                    <div id="xmlgoetree">
                        <ul>
                            <xsl:apply-templates select="xsd:schema/xsd:*[@name=$nodeName]"
                                mode="nodeview"/>
                        </ul>
                    </div>
                </div>
                <div class="right_col">
                    <h4>
                        <xsl:value-of
                            select="xsd:schema/xsd:*[@name=$nodeName]/xsd:annotation/xsd:appinfo[1]/*:Field/@name"
                        />
                    </h4>
                    <div id="xmlmtftree">
                        <ul>
                            <xsl:apply-templates
                                select="xsd:schema/xsd:*[@name=$baslineNodeName]"
                                mode="nodeview"/>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript" src="js/jquery-2.1.1.min.js"/>
                <script type="text/javascript" src="js/elementList.js"/>
                <script type="text/javascript" src="js/jstree.min.js"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="*[not(child::*|text())]" mode="nodeview">
        <li>
            <span> &lt; <span class="node">
                    <xsl:value-of select="name()"/>
                </span>
                <xsl:apply-templates select="@*" mode="nodeview"/> /&gt;</span>
        </li>
    </xsl:template>


    <xsl:template match="*[child::*|text()]" mode="nodeview">
        <li>
            <span> &lt; <span class="node">
                    <xsl:value-of select="name()"/>
                </span>
                <xsl:apply-templates select="@*" mode="nodeview"/> &gt; </span>
            <ul>
                <xsl:apply-templates select="./text()[string-length(normalize-space(.))!=0]"
                    mode="nodeview"/>
                <xsl:apply-templates select="*" mode="nodeview"/>
                <li>
                    <span class="dedent">&lt;/ <span class="node">
                            <xsl:value-of select="name()"/>
                        </span> &gt;</span>
                </li>
            </ul>
        </li>
    </xsl:template>

    <xsl:template match="@*" mode="nodeview">
        <span>
            <span class="att">
                <xsl:value-of select="concat('&#32;','&#64;',name())"/>
            </span>=&quot; <xsl:value-of select="."/> &quot; </span>
    </xsl:template>

    <xsl:template match="text()" mode="nodeview">
        <li>
            <span>
                <xsl:value-of select="normalize-space((string(.)))"/>
            </span>
        </li>
    </xsl:template>

</xsl:stylesheet>
