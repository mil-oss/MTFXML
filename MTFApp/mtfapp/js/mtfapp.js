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

var databasename = "mtfDb";
var storestructure = [
    ['Resources', 'name', false, [['url', 'url', true], ['lastmod', 'lastmod', false], ['data', 'data', false]]],
    ['MTF', 'name', false, [['lastmod', 'lastmod', false], ['data', 'data', false]]]
];

var compression = false;
var xj = new X2JS();
var mtfApp = angular.module('mtfApp', ['indexedDB']);
mtfApp.config(['$indexedDBProvider', function ($indexedDBProvider) {
        $indexedDBProvider.connection(databasename).upgradeDatabase(1, function (event, db, tx) {
            console.log("initDb");
            for (i = 0; i < storestructure.length; i++) {
                //console.log("add store " + storestructure[i][0] + " key:" + storestructure[i][1] + " autoinc:" + storestructure[i][2]);
                var objectStore = db.createObjectStore(storestructure[i][0], {
                    keyPath: storestructure[i][1], autoIncrement: storestructure[i][2]
                });
                var indices = storestructure[i][3];
                for (j = 0; j < indices.length; j++) {
                    //console.log("add index " + indices[j][0] + " ref:" + indices[j][1] + " unique:" + indices[j][2]);
                    objectStore.createIndex(indices[j][0], indices[j][1], {
                        unique: indices[j][2]
                    });
                }
            }
        });
    }], ['$routeProvider', function ($routeProvider) {
        $routeProvider.otherwise({redirectTo: '/index'});
    }]);