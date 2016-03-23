<?xml version="1.0" encoding="UTF-8"?><stylesheet xmlns:catalog="urn:oasis:names:tc:entity:xmlns:xml:catalog" xmlns:ct="http://release.niem.gov/niem/conformanceTargets/3.0/" xmlns:extra="http://example.org/extra-xsl" xmlns:impl="http://example.org/naming-and-design-rules-3.0-functions-impl" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <import href="ndr-functions-interface.xsl"/>

  <param name="xml-catalog" as="document-node()?"/>

  <function name="impl:get-clark-name" as="xs:string">
    <param name="qname" as="xs:QName"/>
    <value-of select="concat( '{', namespace-uri-from-QName($qname), '}', local-name-from-QName($qname) )"/>
  </function>

  <function name="impl:get-document-element" as="element()">
    <param name="context" as="element()"/>
    <sequence select="root($context)/*"/>
  </function>

  <function name="impl:get-target-namespace" as="xs:anyURI?">
    <param name="element" as="element()"/>
    <variable name="schema" as="element(xs:schema)?" select="root($element)/xs:schema"/>
    <choose>
      <when test="empty($schema)">
        <message>
          <value-of select="impl:get-location($element)"/>
          <text>: impl:get-target-namespace(.): document element is not xs:schema.</text>
        </message>
        <sequence select="()"/>
      </when>
      <otherwise>
        <variable name="target-namespace-attr" as="attribute()?" select="$schema/@targetNamespace"/>
        <sequence select="xs:anyURI(if (exists($target-namespace-attr))                                     then string($target-namespace-attr)                                      else '')"/>
      </otherwise>
    </choose>
  </function>

  <function name="impl:resolve-namespace" as="element(xs:schema)?">
    <param name="context" as="element()"/>
    <param name="namespace-uri" as="xs:anyURI"/>
    <variable name="context-target-namespace-uri" as="xs:anyURI?" select="impl:get-target-namespace($context)"/>
    <choose>
      <!-- this SHOULD work for target namespace = xs:anyURI('') -->
      <when test="exists($context-target-namespace-uri)                    and exactly-one($context-target-namespace-uri) = $namespace-uri">
        <sequence select="root($context)/xs:schema"/>
      </when>
      <when test="empty($xml-catalog)">
        <sequence select="error(xs:QName('impl:xml-catalog-not-set'), 'Error: $xml-catalog is not set')"/>
      </when>
      <otherwise>
        <variable name="catalog-element" as="element(catalog:catalog)?" select="$xml-catalog/catalog:catalog"/>
        <choose>
          <when test="empty($catalog-element)">
            <message>
              <value-of select="impl:get-location($context)"/>
              <text>: resolved catalog does not have document element catalog:catalog.</text>
            </message>
            <sequence select="()"/>
          </when>
          <otherwise>
            <apply-templates select="$catalog-element" mode="impl:resolve-namespace">
              <with-param name="namespace-uri" tunnel="yes" select="$namespace-uri"/>
            </apply-templates>
          </otherwise>
        </choose>
      </otherwise>
    </choose>
  </function>

  <function name="impl:resolve-type" as="element()?">
    <param name="context" as="element()"/>
    <param name="qname" as="xs:QName"/>
    <variable name="namespace-uri" as="xs:anyURI" select="namespace-uri-from-QName($qname)"/>
    <variable name="schema" as="element(xs:schema)?" select="impl:resolve-namespace($context, $namespace-uri)"/>
    <choose>
      <when test="empty($schema)">
        <sequence select="()"/>
      </when>
      <otherwise>
        <variable name="type" as="element()?" select="$schema/*[(self::xs:complexType                                      or self::xs:simpleType)                                     and @name = local-name-from-QName($qname)                                    ][1]"/>
        <choose>
          <when test="empty($type)">
            <message>
              <value-of select="impl:get-location($context)"/>
              <text>: type not found: </text>
              <value-of select="impl:get-clark-name($qname)"/>
              <text>.</text>
            </message>
            <sequence select="()"/>
          </when>
          <otherwise>
            <sequence select="$type"/>
          </otherwise>
        </choose>
      </otherwise>
    </choose>
  </function>

  <function name="impl:resolve-element" as="element(xs:element)?">
    <param name="context" as="element()"/>
    <param name="qname" as="xs:QName"/>
    <variable name="namespace-uri" as="xs:anyURI" select="namespace-uri-from-QName($qname)"/>
    <variable name="schema" as="element(xs:schema)?" select="impl:resolve-namespace($context, $namespace-uri)"/>
    <choose>
      <when test="empty($schema)">
        <!-- message has already been dispatched by the catalog resolver -->
        <sequence select="()"/>
      </when>
      <otherwise>
        <variable name="element" as="element(xs:element)?" select="$schema/xs:element[@name = local-name-from-QName($qname)][1]"/>
        <choose>
          <when test="empty($element)">
            <message>
              <value-of select="impl:get-location($context)"/>
              <text>: element not found.</text>
            </message>
            <sequence select="()"/>
          </when>
          <otherwise>
            <sequence select="$element"/>
          </otherwise>
        </choose>
      </otherwise>
    </choose>
  </function>

  <function name="impl:has-effective-conformance-target-identifier" as="xs:boolean">
    <param name="context" as="element()"/>
    <param name="match" as="xs:anyURI"/>
    <variable name="effective-conformance-targets-attribute" as="attribute()?" select="(root($context)//*[exists(@ct:conformanceTargets)])[1]/@ct:conformanceTargets"/>
    <sequence select="if (empty($effective-conformance-targets-attribute))                       then false()                       else some $effective-conformance-target-string                            in tokenize(normalize-space(string($effective-conformance-targets-attribute)), ' ')                            satisfies (                              $effective-conformance-target-string castable as xs:anyURI                              and xs:anyURI($effective-conformance-target-string) = $match)"/>
  </function>

  <!-- ================================================================== -->
  <!-- implementation details -->
  <!-- ================================================================== -->

  <function name="impl:get-location" as="xs:string">
    <param name="context" as="node()"/>
    <value-of>
      <value-of select="base-uri($context)"/>
      <value-of use-when="function-available('saxon:line-number')" select="concat(':', saxon:line-number($context))"/>
    </value-of>
  </function>

  
    

    <template match="/catalog:catalog" mode="impl:resolve-namespace" as="element(xs:schema)?">
      <param name="namespace-uri" as="xs:anyURI" tunnel="yes"/>
      <variable name="next" as="element()?" select="(catalog:uri|catalog:nextCatalog)[1]"/>
      <choose>
        <when test="empty($next)">
          <sequence select="()"/>
        </when>
        <otherwise>
          <apply-templates select="$next" mode="impl:resolve-namespace"/>
        </otherwise>
      </choose>
    </template>

    <template match="catalog:uri" mode="impl:resolve-namespace" as="element(xs:schema)?">
      <param name="namespace-uri" as="xs:anyURI" tunnel="yes"/>
      <choose>
        <when test="empty(@name)">
          <message>
            <value-of select="impl:get-location(.)"/>
            <text>: catalog:uri has no @name.</text>
          </message>
          <sequence select="()"/>
        </when>
        <when test="xs:anyURI(@name) = $namespace-uri">
          <variable name="uri" as="xs:anyURI?" select="resolve-uri(@uri, base-uri(.))"/>
          <choose>
            <when test="empty($uri)">
              <message>
                <value-of select="impl:get-location(.)"/>
                <text>: catalog:uri has no @uri.</text>
              </message>
              <sequence select="()"/>
            </when>
            <when test="not(doc-available($uri))">
              <message>
                <value-of select="impl:get-location(.)"/>
                <text>: catalog:uri @uri (</text>
                <value-of select="$uri"/>
                <text>) does not resolve.</text>
              </message>
              <sequence select="()"/>
            </when>
            <otherwise>
              <variable name="doc" as="element(xs:schema)?" select="doc($uri)/xs:schema"/>
              <choose>
                <when test="empty($doc)">
                  <message>
                    <value-of select="impl:get-location(.)"/>
                    <text>: catalog:uri @uri does not resolve to schema</text>
                  </message>
                </when>
                <otherwise>
                  <sequence select="$doc"/>
                </otherwise>
              </choose>
            </otherwise>
          </choose>
        </when>
        <otherwise>
          <apply-templates mode="impl:resolve-namespace" select="following-sibling::*[1]"/>
        </otherwise>
      </choose>
    </template>

    <template match="catalog:nextCatalog" mode="impl:resolve-namespace" as="element(xs:schema)?">
      <param name="namespace-uri" as="xs:anyURI" tunnel="yes"/>
      <variable name="catalog-uri" as="xs:anyURI" select="resolve-uri(@catalog, base-uri(.))"/>
      <choose>
        <when test="empty($catalog-uri)">
          <message>
            <value-of select="impl:get-location(.)"/>
            <text>: catalog:nextCatalog does not have @catalog.</text>
          </message>
          <sequence select="()"/>
        </when>
        <when test="not(doc-available($catalog-uri))">
          <message>
            <value-of select="impl:get-location(.)"/>
            <text>: catalog:nextCatalog/@catalog does not resolve.</text>
          </message>
          <sequence select="()"/>
        </when>
        <otherwise>
          <variable name="catalog" as="element(catalog:catalog)?" select="doc($catalog-uri)/catalog:catalog"/>
          <choose>
            <when test="empty($catalog)">
              <message>
                <value-of select="impl:get-location(.)"/>
                <text>: catalog:nextCatalog/@catalog resolves to something that is not a catalog.</text>
              </message>
              <sequence select="()"/>
            </when>
            <otherwise>
              <apply-templates mode="impl:resolve-namespace" select="$catalog"/>
            </otherwise>
          </choose>
        </otherwise>
      </choose>
    </template>

  

</stylesheet>