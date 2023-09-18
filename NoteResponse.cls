/// Response Message defining the Perioptimization data structure used to pass data to and from VistA
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Aug 12, 2022
/// Description: Class to define the properties in the response message sent to Periopt from HC
/// to provide a success or failure when filing clinical notes in VistA
/// Change Log:
/// 
Class REST.SwitchLane.Periopt.NoteResponse Extends (%Persistent, Ens.Response, %JSON.Adaptor)
{

Property ResponseMessage As %String(MAXLEN = 150);

Property NoteIen As %String;

Storage Default
{
<Data name="NoteResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MessageId</Value>
</Value>
<Value name="3">
<Value>ControlId</Value>
</Value>
<Value name="4">
<Value>ResponseCode</Value>
</Value>
<Value name="5">
<Value>ResponseMessage</Value>
</Value>
<Value name="6">
<Value>NoteIen</Value>
</Value>
</Data>
<DataLocation>^REST.SwitchLa72E7.NoteResponseD</DataLocation>
<DefaultData>NoteResponseDefaultData</DefaultData>
<IdLocation>^REST.SwitchLa72E7.NoteResponseD</IdLocation>
<IndexLocation>^REST.SwitchLa72E7.NoteResponseI</IndexLocation>
<StreamLocation>^REST.SwitchLa72E7.NoteResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
