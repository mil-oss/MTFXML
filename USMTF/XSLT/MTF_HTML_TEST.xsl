<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" version="2.0">

    <xsl:variable name="msg" select="document('../SCHEMA/MTF_MESSAGES.xml')"/>
    <xsl:variable name="newline" select="'&#xa;'"/>
    <xsl:variable name="blankSpace" select="' '"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>USMTF MESSAGES</title>
                <link rel="stylesheet" href="css/schemaView.css"/>
            </head>
            <body>
                <table>
                    <tr class="ctr bld">
                        <td>Msg ID</td>
                        <td>Msg Name</td>
                        <td>Msg Decription</td>
                    </tr>
                <xsl:apply-templates select="$msg/xsd:schema/xsd:element"/>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="xsd:element">
        <xsl:variable name="classification">U</xsl:variable>
        <xsl:variable name="mtfName">
            <xsl:value-of select="string(@name)"/>
        </xsl:variable>
        <xsl:variable name="typ">
            <xsl:value-of select="concat($mtfName,'Type')"/>
        </xsl:variable>
        <xsl:variable name="mtfIdentifier">
            <xsl:value-of select=".//@MtfIdentifier"/>
        </xsl:variable>
        <xsl:variable name="mtfVersion">
            <xsl:value-of select=".//@VersionIndicator"/>
        </xsl:variable>
        <xsl:variable name="mtfDoc">
            <xsl:value-of select="string(.//@MtfRelatedDocument)"/>
        </xsl:variable>
        <xsl:variable name="mtfPurpose">
            <xsl:value-of select="string(.//@MtfPurpose)"/>
        </xsl:variable>
        <xsl:variable name="mtfNote">
            <xsl:value-of select="string(.//@MtfNote)"/>
        </xsl:variable>
        <xsl:variable name="mtfRefNo">
            <xsl:value-of select=".//@MtfIndexReferenceNumber"/>
        </xsl:variable>
        <xsl:variable name="mtfSponsor">
            <xsl:value-of select=".//@MtfSponsor"/>
        </xsl:variable>
        <xsl:variable name="mtfRmk">
            <xsl:value-of select=".//@MtfRemark"/>
        </xsl:variable>        
        <xsl:variable name="mtfNotation">
            <xsl:value-of select=".//@Rule"/>
        </xsl:variable>
        <xsl:variable name="mtfExplanation">
            <xsl:value-of select=".//@Explanation"/>
        </xsl:variable>
        
     
        
        <xsl:if test="string($mtfIdentifier) = 'ABSTAT'">
            <xsl:result-document method="html" href="OUT/{.//@MtfIdentifier}.html">
                <table>
                    <tr>
                        <td><b>INDEX REFERENCE NUMBER:</b><xsl:value-of select='$mtfRefNo'/></td>
                        <td><b>Status:</b>AGREED</td>
                    </tr>
                    <tr><td></td></tr>
                    <tr>
                        <td><b>MTF Identifier:</b><xsl:value-of select='$mtfIdentifier'/></td>
                        <td><b>Version:</b><xsl:value-of select='$mtfVersion'/></td>
                    </tr>
                    <tr>
                        <td><b>Message Text Format Name:</b><xsl:value-of select='$mtfName'/></td>
                        <td><b>Classification:</b><xsl:value-of select='$classification'/></td>
                    </tr>
                    <tr>
                        <td><b>Purpose:</b><xsl:value-of select='$mtfPurpose'/></td>
                    </tr>
                    <tr>
                        <td><b>Message Notes:</b><xsl:value-of select='$mtfNote'/></td>
                    </tr>
                    <tr>
                        <td><b>Related Documents:</b><xsl:value-of select='$mtfDoc'/></td>
                    </tr>
                    <tr>
                        <td><b>Sponsors:</b><xsl:value-of select='$mtfSponsor'/></td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td><b>Remarks:</b><xsl:value-of select='$mtfRmk'/></td>
                    </tr>
                 </table>
            
                <xsl:call-template name="processElementTypes">
                   <xsl:with-param name="ctElements" select="$msg/xsd:schema/xsd:complexType"/>
                   <xsl:with-param name="ctType" select="$typ"/>
                </xsl:call-template>
                <table><tr><td><text> </text></td></tr></table>
                <xsl:call-template name="processNotation">                    
                    <xsl:with-param name="mtfNotation" select="$mtfNotation"/>
                </xsl:call-template>
            </xsl:result-document>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="processElementTypes">
        <xsl:param name="ctElements" select="."/>
        <xsl:param name="ctType" select="."/>
       
        <!-- Show Template Variables -->
        <!--<ctType>
            <xsl:value-of select="$ctType"/>
        </ctType>
        
        <ctElements>
       <xsl:for-each select="$ctElements">
           <xsl:if test="@name=$ctType">
               <xsl:copy-of copy-namespaces="no" select="."/>               
           </xsl:if>
       </xsl:for-each>
        </ctElements> -->
        
        
        <table border="0" cellpadding="10">
            <tr>
                <td><u>POS</u></td>
                <td><u>SEG</u></td>
                <td><u>RPT</u></td>
                <td><u>OCC</u></td>
                <td><u>SETPOSITION</u></td>
                <td><u>SEQ</u></td>
                <td><u>SET/SEGMENT USAGE</u></td>
            </tr>
        
            <xsl:for-each select="$ctElements">
                <xsl:if test="@name=$ctType">
                    <xsl:for-each select="descendant::*">
                        <xsl:variable name="mtfSegName" select="@SegmentStructureName"/>
                        <xsl:variable name="mtfRepeat" select="@Repeatability"/>
                        <xsl:variable name="mtfSetName" select="@SetFormatPositionName"/>
                        <xsl:variable name="mtfSetPos" select="@SetFormatPositionNumber"/>
                        <xsl:variable name="mtfChoices" select="xsd:choice"/>
                        <xsl:variable name="mtfOccuranceCat" select="@OccurrenceCategory"/>
                        <xsl:variable name="mtfDoc" select="./xsd:annotation/xsd:documentation"/>
                        <xsl:variable name="PrecedingElementCnt" select="count(preceding-sibling::xsd:element)"/>
                        
                                     
                        <xsl:if test="number($PrecedingElementCnt) = 0 and $mtfSetPos &gt; 0">
                            <tr>

                                <!-- POS -->
                                <td><xsl:value-of select="number($mtfSetPos)"/></td>
                                    
                                <!-- SEG (Always Empty) -->
                                 <td></td>
                                    
                                <!-- RPT -->
                                <xsl:choose>
                                    <xsl:when test="$mtfRepeat='1'">
                                        <td><xsl:value-of select="$blankSpace"/></td>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <td><xsl:value-of select="'R'"/></td>
                                    </xsl:otherwise>
                                </xsl:choose>
                                    
                                <!-- OCC -->
                                <xsl:if test="string-length($mtfOccuranceCat) = 0">
                                    <td></td>
                                </xsl:if>
                                <xsl:if test="string-length($mtfOccuranceCat) &gt; 0">
                                    <xsl:choose>
                                         <xsl:when test="string-length($mtfOccuranceCat)>0">
                                                  <xsl:choose>
                                                      <xsl:when test="$mtfOccuranceCat='Mandatory'">
                                                          <td style="color:red">M</td>
                                                      </xsl:when>
                                                      <xsl:when test="$mtfOccuranceCat='Conditional'">
                                                          <td style="color:#FFCC00">C</td>
                                                      </xsl:when>
                                                      <xsl:when test="$mtfOccuranceCat='Operationally Determined'">
                                                          <td style="color:Green">O</td>
                                                      </xsl:when>
                                                      <xsl:otherwise>
                                                          <td style="color:red">#ERR#</td>
                                                      </xsl:otherwise>
                                                  </xsl:choose>
                                         </xsl:when>
                                    </xsl:choose>
                                </xsl:if>
                                
                                <xsl:value-of select="concat('SETNAME: ',$mtfSetName,' ','SETPOS: ',$mtfSetPos,$newline)"/>
                                    
                                <!-- SETPOSITION -->
                                <td>
                                    <xsl:if test="number($mtfSetPos) &lt; 3">
                                        <xsl:value-of select="string('EXER | OPER')"/>
                                        <xsl:if test="contains($mtfSetName,'EXERCISE IDENTIFICATION')">
                                            <tr><td><td><td><td><td colspan="5"><xsl:value-of select="'EXER'"/></td></td></td></td></td></tr>
                                        </xsl:if>
                                        <xsl:if test="contains($mtfSetName,'OPERATION IDENTIFICATION DATA')">
                                            <!--<tr><td colspan="5"><xsl:value-of select="'OPER'"/></td></tr>-->
                                            <tr><td><td><td><td><td colspan="5"><xsl:value-of select="'OPER'"/></td></td></td></td></td></tr>
                                        </xsl:if>  
                                    </xsl:if>
                                    <xsl:if test="$mtfSetPos &gt; 2">
                                        <xsl:choose>
                                            <!--<xsl:when test="contains($mtfSetName,'EXERCISE IDENTIFICATION')">
                                                <tr><td><td><td><td><td colspan="5"><xsl:value-of select="'EXER'"/></td></td></td></td></td></tr>
                                            </xsl:when>-->
                                           <!--<xsl:when test="contains($mtfSetName,'OPERATION IDENTIFICATION DATA')"> -->
                                                <!--<tr><td colspan="5"><xsl:value-of select="'OPER'"/></td></tr>-->
                                               <!-- <tr><td><td><td><td><td colspan="5"><xsl:value-of select="'OPER'"/></td></td></td></td></td></tr>
                                            </xsl:when> -->                                           
                                            <xsl:when test="contains($mtfSetName,'MESSAGE IDENTIFIER')">
                                                <xsl:value-of select="'MSGID'"/>
                                            </xsl:when>
                                            <xsl:when test="contains($mtfSetName,'REFERENCE')">
                                                <xsl:value-of select="'REF'"/>
                                            </xsl:when>
                                            <xsl:when test="contains($mtfSetName,'MESSAGE CANCELLATION')">
                                                <xsl:value-of select="'CANX'"/>
                                            </xsl:when>
                                            <xsl:when test="contains($mtfSetName,'AIRBASE OPERATIONAL STATUS')">
                                                <xsl:value-of select="'BASESTAT'"/>
                                            </xsl:when>
                                            <xsl:when test="contains($mtfSetName,'RUNWAY STATUS')">
                                                <xsl:value-of select="'8RUNWAY'"/>
                                            </xsl:when>
                                            <xsl:when test="contains($mtfSetName,'RUNWAY LIGHTING')">
                                                <xsl:value-of select="'LIGHTING'"/>
                                            </xsl:when>
                                            <xsl:when test="contains($mtfSetName,'ARRESTING GEAR')">
                                                <xsl:value-of select="'8ARREST'"/>
                                            </xsl:when>
                                            <xsl:when test="contains($mtfSetName,'AIR MISSION RADIO')">
                                                <xsl:value-of select="'8RADIO'"/>
                                            </xsl:when>
                                            <xsl:when test="contains($mtfSetName,'NAVIGATIONAL AID')">
                                                <xsl:value-of select="'8NAVAID'"/>
                                            </xsl:when>
                                            <xsl:when test="contains($mtfSetName,'POL STATUS')">
                                                <xsl:value-of select="'8POL'"/>
                                            </xsl:when>
                                            <xsl:when test="contains($mtfSetName,'ACKNOWLEDGEMENT')">
                                                <xsl:value-of select="'AKNLDG'"/>
                                            </xsl:when>
                                            <xsl:when test="contains($mtfSetName,'MESSAGE DOWNGRADING')">
                                                <xsl:value-of select="'DECL'"/>
                                            </xsl:when>
                                         <xsl:otherwise/>
                                        </xsl:choose>
                                    </xsl:if>
                                </td>
                                    
                                <!-- SEQ -->
                                <td><xsl:value-of select="concat('mtfSetPos: ',$mtfSetPos)"/></td>
                               
                                <!-- SET/SEGMENT USAGE -->
                                <xsl:if test="string-length($mtfDoc) > 0 and number($mtfSetPos) &gt; 0 and $mtfSetPos != ' '">
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="$mtfOccuranceCat='Operationally Determined'">
                                                &#x20;SETS ARE MUTUALLY EXCLUSIVE WITH NONE REQUIRED.
                                            </xsl:when>
                                            <xsl:when test="$mtfOccuranceCat='Mandatory'">
                                                &#x20;SETS IS MUTUALLY EXCLUSIVE WITH ONE REQUIRED.
                                            </xsl:when>
                                            <xsl:when test="$mtfOccuranceCat='Conditional'">
                                                &#x20;SETS MUST BE USED. ALL MAY BE USED.
                                            </xsl:when>
                                            <!-- This handles ALors -->
                                            <xsl:when test="xsd:sequence[position()=1]/xsd:element/xsd:annotation/xsd:appinfo/*[$mtfOccuranceCat]='Operationally Determined'">
                                                &#x20;SETS ARE MUTUALLY EXCLUSIVE WITH NONE REQUIRED.
                                            </xsl:when>
                                            <xsl:when test="xsd:sequence[position()=1]/xsd:element/xsd:annotation/xsd:appinfo/*[$mtfOccuranceCat]='Mandatory' or 'M'">
                                                &#x20;SETS IS MUTUALLY EXCLUSIVE WITH ONE REQUIRED.
                                            </xsl:when>
                                            <xsl:when test="xsd:sequence[position()=1]/xsd:element/xsd:annotation/xsd:appinfo/*[$mtfOccuranceCat]='Conditional' or 'C'">
                                                &#x20;SETS MUST BE USED. ALL MAY BE USED.
                                            </xsl:when>
                                        </xsl:choose>
                                    </td>
                                </xsl:if>
                                <xsl:if test="string-length($mtfDoc) > 0 and number($mtfSetPos) &gt; 0">
                                    <td><xsl:value-of select="$mtfDoc"/></td>
                                </xsl:if>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
         </table>
    </xsl:template>
    
    
    <xsl:template name="processNotation">
        <xsl:param name="mtfNotation" select="."/>
        
        <table>
          <xsl:for-each select="$mtfNotation">
             <tr>
                 <td><xsl:value-of select="position()"/></td>
                 <td><text><xsl:value-of select="."/></text></td>
             </tr>
          </xsl:for-each>
        </table>
    </xsl:template>
    
    <xsl:template name="processExplanation">
        <xsl:param name="mtfExplanation" select="."/>
        
        <table>
            <xsl:for-each select="$mtfExplanation">
                <tr>
                    <td><xsl:value-of select="position()"/></td>
                    <td><text><xsl:value-of select="."/></text></td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
</xsl:stylesheet>
