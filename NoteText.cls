/// the text that makes up the note
/// Class defining the note text format for sending a note to VistA to file.
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: June 23, 2023
/// Description: defines the note text. each line is a max of 150 characters. Lines can not contain control characters
/// Change Log:
Class REST.SwitchLane.Periopt.NoteText Extends (%Persistent, %XML.Adaptor, %RegisteredObject, %JSON.Adaptor)
{

Property NoteTextLine As %String(MAXLEN = 150);

Storage Default
{
<Data name="NoteTextDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NoteTextLine</Value>
</Value>
</Data>
<DataLocation>^REST.SwitchLane.P72E7.NoteTextD</DataLocation>
<DefaultData>NoteTextDefaultData</DefaultData>
<IdLocation>^REST.SwitchLane.P72E7.NoteTextD</IdLocation>
<IndexLocation>^REST.SwitchLane.P72E7.NoteTextI</IndexLocation>
<StreamLocation>^REST.SwitchLane.P72E7.NoteTextS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
