var xslt = require('./Saxon');
var fs = require('fs');

// This example is not working. Not sure why yet :-(
var input = fs.readFileSync('./Example.xml', {encoding:'utf8'});
var transform = fs.readFileSync('./Skeleton.xslt', {encoding:'utf8'});

var output = xslt(input, transform);

fs.writeFileSync('./output.xml', output);
console.log("done");
