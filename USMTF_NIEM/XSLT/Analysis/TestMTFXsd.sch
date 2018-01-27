<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:pattern>
        <sch:rule context="/">
            <sch:assert test="xsd:restriction/@base='XXX'">Base type Mis-Match</sch:assert> 
            <sch:assert test="xsd:restriction/xsd:minInclusive/@value='XXX'">Min value Mis-Match</sch:assert>
            <sch:assert test="xsd:restriction/xsd:maxInclusive/@value='XXX'">Max value Mis-Match</sch:assert>
            <sch:assert test="xsd:restriction/xsd:pattern/@value='XXX'">RegEx value Mis-Match</sch:assert>
            <sch:assert test="xsd:restriction/xsd:minLength/@value='XXX'">Min Length value Mis-Match</sch:assert>
            <sch:assert test="xsd:restriction/xsd:maxLength/@value='XXX'">Max Length value Mis-Match</sch:assert>
            <sch:assert test="xsd:restriction/xsd:enumeration/@value='XXX'">Enumeration value Mis-Match</sch:assert>
        </sch:rule>
        
        <sch:rule context="xsd:complexType">
            <sch:assert test="@name='XXX'">Complex type Mis-Match</sch:assert> 
        </sch:rule>
        <sch:rule context="xsd:element">
            <sch:assert test="@type='XXX'">Type Mis-Match</sch:assert> 
        </sch:rule>
        
        <sch:rule context="xsd:annotation">
            <sch:assert test="xsd:documentation='XXX'">Documentation Error</sch:assert>
            <sch:assert test="xsd:appinfo/*/@identifier='XXX'">Identifier Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/*/@position='XXX'">Position Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/*/@positionName='XXX'">Position Name Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/*/@concept='XXX'">Concept Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/*/@name='XXX'">Name Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/*/@explanation='XXX'">Explanation Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/*/@definition='XXX'">Definition Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/*/@remark='XXX'">Remark Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/*/@version='XXX'">Version Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/*/@setid='XXX'">Version Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/*/@column='XXX'">Column Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/*/@justification='XXX'">Column Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/*/@purpose='XXX'">Purpose Mis-Match.</sch:assert>
            <sch:assert test="xsd:appinfo/Example='XXX'">Example Mis-Match.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>