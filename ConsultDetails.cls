/// Perioptimization Class Definition for the Consult Details Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Aug 25,
/// Description: Class Definition for the ConsultDetails Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.ConsultDetails Extends (%Persistent, %JSON.Adaptor)
{

Parameter %JSONNULL As BOOLEAN = 1;

// Property ConsultId As %String;

Property Consult As list Of AllConsultsAndDetails;

// %String(MAXLEN = 10000);

Storage Default
{
<Data name="ConsultDetailsDefaultData">
<Subscript>"ConsultDetails"</Subscript>
<Value name="1">
<Value>Data</Value>
</Value>
<Value name="2">
<Value>PatientICN</Value>
</Value>
<Value name="3">
<Value>ProviderSecid</Value>
</Value>
<Value name="4">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="5">
<Value>Consult</Value>
</Value>
<Value name="6">
<Value>ConsultID</Value>
</Value>
<Value name="7">
<Value>Consults</Value>
</Value>
<Value name="8">
<Value>ConsultId</Value>
</Value>
</Data>
<DataLocation>^REST.Switch72E7.ConsultDetailsD</DataLocation>
<DefaultData>ConsultDetailsDefaultData</DefaultData>
<IdLocation>^REST.Switch72E7.ConsultDetailsD</IdLocation>
<IndexLocation>^REST.Switch72E7.ConsultDetailsI</IndexLocation>
<StreamLocation>^REST.Switch72E7.ConsultDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
