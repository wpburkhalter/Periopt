/// Perioptimization Class Definition for the List of Providers Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Class Definition for the List of Providers Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.ListOfProvider Extends (Ens.Response, %Persistent, %JSON.Adaptor)
{

Property Providers As %String;

Property empid As list Of REST.SwitchLane.Periopt.EmpId;

Property name As list Of REST.SwitchLane.Periopt.Name;

// Property ProviderList As %String(MAXLEN = 50000);

Storage Default
{
<Data name="ListOfProviderDefaultData">
<Subscript>"ListOfProvider"</Subscript>
<Value name="1">
<Value>Providers</Value>
</Value>
<Value name="2">
<Value>empid</Value>
</Value>
<Value name="3">
<Value>name</Value>
</Value>
</Data>
<DefaultData>ListOfProviderDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
