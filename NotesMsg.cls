/// Class defining the JSON note msg format for sending a note to VistA to file.
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: June 23, 2023
/// Description: defines the JSON message structure for the notes to VistA
/// Change Log:
/// sample JSON message:
/// {
/// 	"Patient": "8",
/// 	"NoteTitle": "Surgery",
/// 	"VisitDateTime": "",
/// 	"VisitLocation": "",
/// 	"VisitId": "",
/// 	"ConsultId": "667",
/// 	"AuthorId": "1057",
/// 		"ECODE": "ENCRYPTED CODE",
/// 	"NoteText": [{
/// 		"NoteText(1)": "note line 1",
/// 		"NoteText(2)": "note line 2",
/// 		"NoteText(3)": "note line 3"
/// 	}]
/// }
Class REST.SwitchLane.Periopt.NotesMsg Extends (%Persistent, %XML.Adaptor, %JSON.Adaptor, %RegisteredObject)
{

/// Patient DFN or ICN
Property Patient As %String(MAXLEN = 150) [ Required ];

/// Must be a valid note title on the VistA system in field 8925.1. Note title has to match exactly.
Property NoteTitle As %String [ Required ];

/// Date/time of the visit in yyyymmdd@hh:mm:ss format
Property VisitDateTime As %String;

/// Visit Location, IEN for VistA file 44
Property VisitLocation As %String;

/// Pointer to VistA file 9000010
Property VisitId As %String;

/// Surgery consult IEN for VistA file 123
Property ConsultId As %String;

/// author's Visit DUZ or SECID
Property AuthorId As %String [ Required ];

/// author's electronic signature code (encrypted)
/// Property Ecode As %String;
Property NoteText As list Of REST.SwitchLane.Periopt.NoteText;

Storage Default
{
<Data name="NotesMsgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Patient</Value>
</Value>
<Value name="3">
<Value>DocumentTitle</Value>
</Value>
<Value name="4">
<Value>VisitDateTime</Value>
</Value>
<Value name="5">
<Value>VisitLocation</Value>
</Value>
<Value name="6">
<Value>VisitId</Value>
</Value>
<Value name="7">
<Value>ConsultId</Value>
</Value>
<Value name="8">
<Value>AuthorId</Value>
</Value>
<Value name="9">
<Value>NoteText</Value>
</Value>
<Value name="10">
<Value>NoteTitle</Value>
</Value>
</Data>
<DataLocation>^REST.SwitchLane.P72E7.NotesMsgD</DataLocation>
<DefaultData>NotesMsgDefaultData</DefaultData>
<IdLocation>^REST.SwitchLane.P72E7.NotesMsgD</IdLocation>
<IndexLocation>^REST.SwitchLane.P72E7.NotesMsgI</IndexLocation>
<StreamLocation>^REST.SwitchLane.P72E7.NotesMsgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
