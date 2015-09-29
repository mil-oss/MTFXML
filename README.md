<img align="right"  src="./MTF_Logo.jpg" alt="MTF Logo" width="300" height="300" />
# MTFXML

This project supports collaborative development, configuration management and implementation of United States and NATO Message Text Format (MTF) military standards using the Extensible Markup Language and Web technologies.

## Background

Message Text Format (MTF) is required by all DoD Services and NATO for text based information exchanges.  MTF has been developed and maintained since 1995 and was implemented as a native XML defined MIL STD in 2004.  It represents an authoritative data source for the content, format and context of messages used to support military operations and processes.

The original format of MTF as slash delimted text entries is supported and remains interoperable with the XML defined military standards (MIL STD).  XSLT to produce and consume slash delimited messages is provided at :

LINK TBD.

Many format and design principles for MTF are driven by legacy communication systems and networks.  The proliferation of W3C web services and access to robust network connectivity across the range of military operations (ROMO) have encouraged modernization and improvement efforts which this project is intended to support.

MTF messages are in wide use across US DoD and NATO in various forms, so attention must be given to retaining compatibility and consistency.  The format is based on operator driven shorthand communication methods which pre-date similar manifestations in modern chat and texting software.   The format is based on human factors which require complete, concise, and rapid information exchange of complex mission critical data items in an efficient human readable and actionable manner.

The messages, components and data items represent operational institutional knowledge which is recognized and reinforced by continuous use in US and NATO forces for over 20 years.  In some ways this information can be regarded as a material manifestation of Western Warfighting methods and principles.  MTF provides a lexical and semantic baseline which can be leveraged to preserve knowledge and support improvements for current and emergent inter-operable military information exchanges.

The advent of the NIEM methodology in the United States to achieve inter-operable information exchanges between all government agencies, to include the military provides an opportunity to leverage the institutional knowledge which resides in MTF.  Corresponding data harmonization efforts in NATO have the same objectives and will also benefit from improvements in the MTF standard specifications and implementations. 

##Data Resources

The source XML Schema for USMTF and NATO MTF are distribution restricted.  This project does not provide any part of this data so participants must request and obtain access to these resources in order to leverage the project.

For those with access to these resources, they are at PKI and password protected sites located below.  Instructions for requesting access can be found there as well.  

USMTF:  https://disa.deps.mil/ext/cop/JINTACCS/USMTF/default.aspx

NATO MTF: https://nhqc3s.hq.nato.int/default.aspx

Required baseline USMTF files are proved in a zip file containing (5) XML files: messages.xsd, sets.xsd, composites.xsd, fields.xsd, and ISM.xsd.  NATO MTF schema are proved as individual message sets in directories with (4) files: messages.xsd, sets.xsd, composites.xsd and fields.xsd.

##XML SCHEMA RE-FACTORING

The naming and design rules for the baseline XML Schema for these MIL STDs are part of the specification.  The objectives of this project are to normalize, optimize, streamline and align these XML Schema for use in web services, achieve alignment with the emergent National Information Exchange Model (NIEM) methodology which is used for many non military purposes, and generally employ best practices for XML schema aware implementations.

NIEM specifies Naming and Design Rules (NDR) which employ the Garden of Eden schema design pattern and require naming patterns which are not part of the current MIL STD specifications.  The re-factor required to obtain equivalent XML Schema which meet these requirements is accomplished using XSLT.  These  files are provided in the source code.

All reference implementations in this project rely on re-factored and consolidated XML schema that must be produced by applying the provided XSLTs to the baseline XML schema.  This project is monitored by representatives from the US and NATO configuration management teams who will introduce recommended updates to the standards based on the advantages that may be demonstrated by reference implementations.  Developers are encouraged to use the forum on this project to communicate suggestions and recommendations to inform the process.

##Manual XML Schema Generation

An Integrated Development Environment (IDE) or command line tool is required to complete this step manually.  Instructions for executing this process are provided here:

LINK TBD.

Web Based XML Schema Generation Tools

A web based tool to automate the re-factor has been developed as a part of this project.  All transforms are executed using resources which are downloaded and cached using HTML 5 Indexed Database functionality.   Due to the size and quantity of baseline files, it is recommended that this tool be employed using a locally hosted web service.  The files that must be decompressed into a public directory on a web server are provided here:

LINK TBD.

##MTF Viewer

A web service to view generated documentation and sample forms for all messages has been developed as part of this project.  The intent of this effort is to allow familiarization with the content and context of MTF XML messages and components, and to allow individual downloads of XML Shema for messages and components.  This is a work in progress and may have limited functionality until a release version is completed.

LINK TBD.

##MTF Configuration Management Tool

This is a prototype extension of the viewer which is meant to allow maintainers and users to propose content and format changes in context of the messages and components.  This will employ forum based interaction in order to achieve consensus by service and nation representatives for approval and implementation.  Once a change request is approved or deferred, these interactions can be preserved for an official record and the alteration can be implemented directly on the XML Schema or component.  This is a planned functionality which will rely on a major shift to native XML driven configuration management tools from the current tools which employ relational databases.

LINK TBD.
