/// Perioptimization Class Definition for the Provider Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Aug 23, 2022
/// Description: Class Definition for the Clinic Provider Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.Provider Extends (%Persistent, %JSON.Adaptor)
{

Parameter %JSONNULL As BOOLEAN = 1;

Property NumberofProviders As %String;

Property Providers As list Of REST.SwitchLane.Periopt.ProviderList;

Storage Default
{
<Data name="ProviderDefaultData">
<Subscript>"Provider"</Subscript>
<Value name="1">
<Value>empid</Value>
</Value>
<Value name="2">
<Value>Provider</Value>
</Value>
<Value name="3">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="4">
<Value>Providers</Value>
</Value>
<Value name="5">
<Value>NumberofProviders</Value>
</Value>
</Data>
<DataLocation>^REST.SwitchLane.P72E7.ProviderD</DataLocation>
<DefaultData>ProviderDefaultData</DefaultData>
<IdLocation>^REST.SwitchLane.P72E7.ProviderD</IdLocation>
<IndexLocation>^REST.SwitchLane.P72E7.ProviderI</IndexLocation>
<StreamLocation>^REST.SwitchLane.P72E7.ProviderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
