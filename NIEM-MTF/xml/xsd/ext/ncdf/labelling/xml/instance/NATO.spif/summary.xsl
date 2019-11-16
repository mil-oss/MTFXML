<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:spif="http://www.xmlspif.org/spif">
	<xsl:output method="html"/>
	<xsl:param name="oidwebsite">http://www.oid-info.com/get/</xsl:param>

	<xsl:template match="/spif:SPIF">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<link rel="shortcut icon" href="http://www.smhs.co.uk/files/favicon.ico" type="image/x-icon"/>
			<link type="text/css" rel="stylesheet" media="all" href="http://www.smhs.co.uk/modules/book/book.css?Z"/>

			<link type="text/css" rel="stylesheet" media="all" href="http://www.smhs.co.uk/modules/node/node.css?Z"/>
			<link type="text/css" rel="stylesheet" media="all" href="http://www.smhs.co.uk/modules/system/defaults.css?Z"/>
			<link type="text/css" rel="stylesheet" media="all" href="http://www.smhs.co.uk/modules/system/system.css?Z"/>
			<link type="text/css" rel="stylesheet" media="all" href="http://www.smhs.co.uk/modules/system/system-menus.css?Z"/>
			<link type="text/css" rel="stylesheet" media="all" href="http://www.smhs.co.uk/modules/user/user.css?Z"/>
			<link type="text/css" rel="stylesheet" media="all" href="http://www.smhs.co.uk/sites/all/themes/smhs/style.css?Z"/>

			<title>Security Policy Information File <xsl:value-of select="spif:securityPolicyId/@name"/></title>

			<table id="primary-menu" summary="Navigation elements." border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="primary-links" width="5%" align="center" valign="middle"/>
					<td id="home" width="240px" border="1">
						<a href="http://www.smhs.co.uk/" title="Home">
							<img src="http://www.smhs.co.uk/sites/all/themes/smhs/logo.png" alt="Home" border="0"/>
						</a>
					</td>

					<td class="primary-links" align="center" valign="middle">
						<ul class="links" id="navlist">
							<li class="menu-31 first">
								<a href="#information">Information</a>
							</li>
							<li class="menu-33">
								<a href="#classifications">Classifications</a>
							</li>
							<xsl:if test="/spif:SPIF/spif:privacyMarks">
								<li class="menu-33">
									<a href="#privacyMarks">Privacy Marks</a>
								</li>
							</xsl:if>
							<xsl:if test="/spif:SPIF/spif:securityCategoryTagSets">
								<li class="menu-32 last">
									<a href="#securityCategoryTagSets">TagSets</a>
								</li>
							</xsl:if>
						</ul>
					</td>
				</tr>
			</table>

			<table id="secondary-menu" summary="Navigation elements." border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="secondary-links" width="100%" align="center" valign="middle"> </td>
				</tr>
			</table>

			<h1>Security Policy Information File <xsl:value-of select="securityPolicyId/@name"/></h1>
			<h2 id="information">Information</h2>
			<body>
				<table width="100%" class="vertical">
					<tr/>
					<tr>
						<th class="horizontal" width="20%">Policy Name:</th>
						<td width="30%">
							<xsl:value-of select="spif:securityPolicyId/@name"/>
						</td>
						<th class="horizontal" width="20%">Policy ID:</th>
						<td width="30%" valign="top">
							<a href="{$oidwebsite}{spif:securityPolicyId/@id}">
								<xsl:value-of select="spif:securityPolicyId/@id"/>
							</a>
						</td>
					</tr>
					<tr>
						<th class="horizontal">Version:</th>
						<td>
							<xsl:value-of select="@version"/>
						</td>
						<th class="horizontal">Creation Date:</th>
						<td>
							<xsl:value-of select="@creationDate"/>
						</td>
					</tr>
					<tr>
						<th class="horizontal">Originator DN:</th>
						<td>
							<xsl:value-of select="@originatorDN"/>
						</td>
						<th class="horizontal">Key Identifier:</th>
						<td>
							<xsl:value-of select="@keyIdentifier"/>
						</td>
					</tr>
					<tr>
						<th class="horizontal">Privilege ID:</th>
						<td>
							<xsl:value-of select="@privilegeId"/>
						</td>
						<th class="horizontal">RBAC ID:</th>
						<td>
							<xsl:value-of select="@rbacId"/>
						</td>
					</tr>
					<xsl:if test="defaultSecurityPolicyId">
						<tr>
							<th class="horizontal">Default Policy Name:</th>
							<td>
								<xsl:value-of select="spif:defaultSecurityPolicyId/@name"/>
							</td>
							<th class="horizontal">Default Policy ID:</th>
							<td>
								<xsl:value-of select="spif:defaultSecurityPolicyId/@id"/>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<th class="horizontal">Note:</th>
						<td colspan="3">
							<i>There is additional information contained within the XML Security Policy which is not displayed on this page.</i>
						</td>
					</tr>
				</table>
				<hr/>
				<h2 id="classifications">Classifications</h2>
				<p class="index">(<xsl:apply-templates select="spif:securityClassifications/spif:securityClassification" mode="index"/>)</p>
				<table class="classifications" align="center">
					<tbody>
						<tr>
							<th>Name</th>
							<th>LACV</th>
							<th>Hierarchy</th>
							<th>Colour</th>
						</tr>
						<xsl:apply-templates select="spif:securityClassifications/spif:securityClassification"/>
					</tbody>
				</table>
				<hr/>
				<xsl:if test="spif:privacyMarks">
					<h2 id="privacyMarks">Privacy Marks</h2>
					<table class="privacyMarks" align="center">
						<tbody>
							<xsl:apply-templates select="spif:privacyMarks/spif:privacyMark"/>
						</tbody>
					</table>
					<hr/>
				</xsl:if>
				<xsl:if test="spif:securityCategoryTagSets">
					<h2 id="securityCategoryTagSets">Tag Sets</h2>
					<p class="index">(<xsl:apply-templates select="spif:securityCategoryTagSets/spif:securityCategoryTagSet" mode="index"/>)</p>
					<table class="securityCategoryTagSets" width="100%" border="1">
						<tbody>
							<xsl:apply-templates select="spif:securityCategoryTagSets/spif:securityCategoryTagSet"/>
						</tbody>
					</table>
					<hr/>
				</xsl:if>
			</body>
		</html>
	</xsl:template>


	<xsl:template match="spif:markingData">
		<xsl:if test="@phrase">
			<xsl:text> (</xsl:text>
			<xsl:if test="@xml:lang">
				<xsl:value-of select="@xml:lang"/>: </xsl:if>
			<xsl:value-of select="@phrase"/>
			<xsl:text>)</xsl:text>
		</xsl:if>

	</xsl:template>

	<xsl:template match="spif:excludedClass">
		<xsl:text> (Excluded </xsl:text>
		<xsl:value-of select="text()"/>
		<xsl:text>)</xsl:text>
	</xsl:template>


	<xsl:template match="spif:qualifier">
		<tr>
			<th class="horizontal">
				<xsl:text>Marking Qualifier </xsl:text>
				<xsl:value-of select="@qualifierCode"/>
				<xsl:if test="@xml:lang"> (<xsl:value-of select="@xml:lang"/>) </xsl:if>
			</th>
			<td align="left">
				<xsl:text>"</xsl:text>
				<xsl:value-of select="@markingQualifier"/>
				<xsl:text>"</xsl:text>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="spif:securityClassification">
		<tr bgcolor="{@color}" id="{@name}">
			<td align="left">
				<xsl:choose>
					<xsl:when test="@obsolete = 'true'">
						<strike>
							<xsl:value-of select="@name"/>
						</strike>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@name"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates/>
			</td>
			<td align="center">
				<xsl:value-of select="@lacv"/>
			</td>
			<td align="center">
				<xsl:value-of select="@hierarchy"/>
			</td>
			<td>
				<xsl:value-of select="@color"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="spif:securityCategoryTagSet">
		<tr id="{@name}">
			<td width="10%" valign="top">
				<table width="100%">
					<tr>
						<th class="horizontal" width="50%">Category Tag Set:</th>
						<td align="left">
							<xsl:value-of select="@name"/>
						</td>
					</tr>
					<tr>
						<th class="horizontal">ID:</th>
						<td align="left">
							<xsl:value-of select="@id"/>
						</td>
					</tr>
					<tr>
						<td class="index" colspan="2">(<xsl:apply-templates select="spif:securityCategoryTag" mode="index"/>)</td>
					</tr>
				</table>
			</td>
			<td>
				<table class="securityCategoryTags" width="100%">
					<tbody>
						<xsl:apply-templates select="spif:securityCategoryTag"/>
					</tbody>
				</table>
			</td>
		</tr>
		<tr/>
	</xsl:template>

	<xsl:template match="spif:securityCategoryTag">
		<tr id="{@name}">
			<td width="30%" valign="top">
				<table width="100%">
					<tr>
						<th class="horizontal" width="50%">Category Tag:</th>
						<td align="left">
							<xsl:value-of select="@name"/>
						</td>
					</tr>
					<tr>
						<th class="horizontal">Type:</th>
						<td align="left">
							<xsl:value-of select="@tagType"/>
						</td>
					</tr>
					<xsl:if test="@enumType">
						<tr>
							<th class="horizontal">Enum Type:</th>
							<td align="left">
								<xsl:value-of select="@enumType"/>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="@tag7Encoding">
						<tr>
							<th class="horizontal">Tag7 Encoding:</th>
							<td align="left">
								<xsl:value-of select="@tag7Encoding"/>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="@singleSelection">
						<tr>
							<th class="horizontal">Single selection:</th>
							<td align="left">
								<xsl:value-of select="@singleSelection"/>
							</td>
						</tr>
					</xsl:if>
					<xsl:apply-templates select="spif:markingQualifier"/>
				</table>
			</td>
			<td valign="top">
				<table class="tagCategories" width="100%">
					<tbody>
						<tr>
							<th width="10%" align="left">Category</th>
							<th/>
							<th width="10%" align="left">LACV</th>
						</tr>
						<xsl:apply-templates select="spif:tagCategory"/>
					</tbody>
				</table>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="spif:tagCategory">
		<tr id="{@name}">
			<td align="left">
				<xsl:choose>
					<xsl:when test="@obsolete = 'true'">
						<strike>
							<xsl:value-of select="@name"/>
						</strike>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@name"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td align="left">
				<xsl:apply-templates/>
			</td>
			<td align="left">
				<xsl:value-of select="@lacv"/>
				<xsl:if test="@requiredClass">(requires <a href="#{@requiredClass}"><xsl:value-of select="@requiredClass"/>)</a></xsl:if>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="spif:privacyMark">
		<tr id="{@name}">
			<td align="left">
				<xsl:choose>
					<xsl:when test="@obsolete = 'true'">
						<strike>
							<xsl:value-of select="@name"/>
						</strike>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@name"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="spif:securityClassification | spif:securityCategoryTagSet | spif:securityCategoryTag" mode="index">
		<xsl:if test="position() != 1">, </xsl:if>
		<a href="#{@name}">
			<xsl:value-of select="@name"/>
		</a>
	</xsl:template>

</xsl:stylesheet>
