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

var base = "../";

var storekeys = {
    'BaselineFields': ['fields.xsd','field_'],
    'BaselineComposites': ['composites.xsd','comp_'],
    'BaselineMessages': ['messages.xsd','msg_'],
    'BaselineSets': ['sets.xsd','set_'],
    'GoEMessages': ['GoE_messages.xsd','goemsg_'],
    'GoESegments': ['GoE_segments.xsd','goeseg_'],
    'GoESets': ['GoE_sets.xsd','goeset_'],
    'GoEFields': ['GoE_fields.xsd','goefld_']
};

var stores = [
    ['BaselineFields', 'name', false, [['storename', 'storename', false], ['data', 'data', false], ['xmlview', 'xmlview', false], ['report', 'report', false]]],
    ['BaselineComposites', 'name', false, [['storename', 'storename', false], ['data', 'data', false], ['xmlview', 'xmlview', false], ['report', 'report', false]]],
    ['BaselineMessages', 'name', false, [['storename', 'storename', false], ['data', 'data', false], ['xmlview', 'xmlview', false], ['report', 'report', false]]],
    ['BaselineSets', 'name', false, [['storename', 'storename', false], ['data', 'data', false], ['xmlview', 'xmlview', false], ['report', 'report', false]]],
    ['GoEMessages', 'name', false, [['storename', 'storename', false], ['data', 'data', false], ['xmlview', 'xmlview', false], ['report', 'report', false]]],
    ['GoESegments', 'name', false, [['storename', 'storename', false], ['data', 'data', false], ['xmlview', 'xmlview', false], ['report', 'report', false]]],
    ['GoESets', 'name', false, [['storename', 'storename', false], ['data', 'data', false], ['xmlview', 'xmlview', false], ['report', 'report', false]]],
    ['GoEFields', 'name', false, [['storename', 'storename', false], ['data', 'data', false], ['xmlview', 'xmlview', false], ['report', 'report', false]]],
    ['Resources', 'name', false, [
            ['storename', 'storename', false],
            ['url', 'url', true], ['etag', 'etag', true],
            ['lastmod', 'lastmod', false], ['data', 'data', false]]]];

var remoteurls = {
    'BaselineFields': 'XSD/Baseline_Schemas/fields.xsd',
    'BaselineComposites': 'XSD/Baseline_Schemas/composites.xsd',
    'BaselineMessages': 'XSD/Baseline_Schemas/messages.xsd',
    'BaselineSets': 'XSD/Baseline_Schemas/sets.xsd',
    'GoEMessages': 'XSD/GoE_Schemas/GoE_messages.xsd',
    'GoESegments': 'XSD/GoE_Schemas/GoE_segments.xsd',
    'GoESets': 'XSD/GoE_Schemas/GoE_sets.xsd',
    'GoEFields': 'XSD/GoE_Schemas/GoE_fields.xsd'
};

var xmlresources = [
    'xsl/NodeTreeHtm.xsl'];

var countcheck = {
    'BaselineMessages': ['#BaselineMessages_prog', 315],
    'BaselineSets': ['#BaselineSets_prog', 1910],
    'BaselineComposites': ['#BaselineComposites_prog', 585],
    'BaselineFields': ['#BaselineFields_prog', 4895],
    'GoEMessages': ['#GoEMessages_prog', 630],
    'GoESegments': ['#GoESegments_prog', 746],
    'GoESets': ['#GoESets_prog', 3822],
    'GoEFields': ['#GoEFields_prog', 10960]
};
