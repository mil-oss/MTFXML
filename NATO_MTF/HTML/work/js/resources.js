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
//
////stores =[[storename,keyname,autoincTF,[['indexname','indexref','uniqueTF']]],[..], ..]
//storename =stores[i][0];
//storekey =stores[i][1];
//storekeyincTF =stores[i][2];
//indexname=stores[i][3][j][0];
//indexref=stores[i][3][j][1];
//indexuniqueTF=stores[i][3][j][2];

var storekeys = {
    'BaselineFields':[ 'fields.xsd.lz', 'field_', 'field_schema.xsd.lz'],
    'BaselineComposites':[ 'composites.xsd.lz', 'comp_', 'composite_schema.xsd.lz'],
    'BaselineMessages':[ 'messages.xsd.lz', 'msg_', 'message_schema.xsd.lz'],
    'BaselineSets':[ 'sets.xsd.lz', 'set_', 'set_schema.xsd.lz'],
    'GoEMessages':[ 'natomtf_goe_messages.xsd.lz', 'goemsg_', 'goe_field_schema.xsd.lz'],
    'GoESets':[ 'natomtf_goe_sets.xsd.lz', 'goeset_', 'goe_set_schema.xsd.lz'],
    'GoEFields':[ 'natomtf_goe_fields.xsd.lz', 'goefld_', 'goe_field_schema.xsd.lz']
};

var stores =[[ 'BaselineFields', 'name', false,[[ 'storename', 'storename', false],[ 'data', 'data', false],[ 'xmlview', 'xmlview', false],[ 'report', 'report', false]]],
[ 'BaselineComposites', 'name', false,[[ 'storename', 'storename', false],[ 'data', 'data', false],[ 'xmlview', 'xmlview', false],[ 'report', 'report', false]]],
[ 'BaselineMessages', 'name', false,[[ 'storename', 'storename', false],[ 'data', 'data', false],[ 'xmlview', 'xmlview', false],[ 'report', 'report', false]]],
[ 'BaselineSets', 'name', false,[[ 'storename', 'storename', false],[ 'data', 'data', false],[ 'xmlview', 'xmlview', false],[ 'report', 'report', false]]],
[ 'GoEMessages', 'name', false,[[ 'storename', 'storename', false],[ 'data', 'data', false],[ 'xmlview', 'xmlview', false],[ 'report', 'report', false]]],
[ 'GoESets', 'name', false,[[ 'storename', 'storename', false],[ 'data', 'data', false],[ 'xmlview', 'xmlview', false],[ 'report', 'report', false]]],
[ 'GoEFields', 'name', false,[[ 'storename', 'storename', false],[ 'data', 'data', false],[ 'xmlview', 'xmlview', false],[ 'report', 'report', false]]],
[ 'Resources', 'name', false,[[ 'storename', 'storename', false],[ 'url', 'url', true],[ 'etag', 'etag', true],[ 'lastmod', 'lastmod', false],[ 'data', 'data', false]]]];

var remoteurls = {
    'BaselineFields': 'xsd/fields.xsd.lz',
    'BaselineComposites': 'xsd/composites.xsd.lz',
    'BaselineMessages': 'xsd/messages.xsd.lz',
    'BaselineSets': 'xsd/sets.xsd.lz',
    'GoEMessages': 'xsd/natomtf_goe_messages.xsd.lz',
    'GoESets': 'xsd/natomtf_goe_sets.xsd.lz',
    'GoEFields': 'xsd/natomtf_goe_fields.xsd.lz'
};

var xmlresources =[
'../XSLT/NodeTreeHtm.xsl',
'../XSLT/GoE_Msg_Doc.xsl',
'../XSLT/GoE_Msg_XSD.xsl',
'../XSD/templates/composite_schema.xsd',
'../XSD/templates/field_schema.xsd',
'../XSD/templates/message_schema.xsd',
'../XSD/templates/set_schema.xsd',
'../XSD/templates/goe_message_schema.xsd',
'../XSD/templates/goe_field_schema.xsd',
'../XSD/templates/goe_set_schema.xsd',
'../XSD/APP-11C-ch1/Consolidated/fields.xsd',
'../XSD/APP-11C-ch1/Consolidated/composites.xsd',
'../XSD/APP-11C-ch1/Consolidated/messages.xsd',
'../XSD/APP-11C-ch1/Consolidated/sets.xsd',
'../XSD/APP-11C-GoE/natomtf_goe_messages.xsd',
'../XSD/APP-11C-GoE/natomtf_goe_sets.xsd',
'../XSD/APP-11C-GoE/natomtf_goe_fields.xsd'];

var compressedxmlresources =[
'xsl/NodeTreeHtm.xsl.lz',
'xsl/GoE_Msg_Doc.xsl.lz',
'xsl/GoE_Msg_XSD.xsl.lz',
'xsd/templates/composite_schema.xsd.lz',
'xsd/templates/field_schema.xsd.lz',
'xsd/templates/message_schema.xsd.lz',
'xsd/templates/set_schema.xsd.lz',
'xsd/templates/goe_message_schema.xsd.lz',
'xsd/templates/goe_field_schema.xsd.lz',
'xsd/templates/goe_set_schema.xsd.lz',
'xsd/fields.xsd.lz',
'xsd/composites.xsd.lz',
'xsd/messages.xsd.lz',
'xsd/sets.xsd.lz',
'xsd/natomtf_goe_messages.xsd.lz',
'xsd/natomtf_goe_sets.xsd.lz',
'xsd/natomtf_goe_fields.xsd.lz'];


var xsltarget = "<?xml version='1.0'?><xsd:schema xml:lang='en-US' xmlns:xsd='http://www.w3.org/2001/XMLSchema' elementFormDefault='unqualified' attributeFormDefault='unqualified'></xsd:schema>";