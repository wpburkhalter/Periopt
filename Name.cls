/// Perioptimization Class Definition for the Name Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Class Definition for the Name Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.Name Extends (Ens.Response, %Persistent, %JSON.Adaptor)
{

Property Provider As %String;

Storage Default
{
<Data name="NameDefaultData">
<Subscript>"Name"</Subscript>
<Value name="1">
<Value>Provider</Value>
</Value>
</Data>
<DefaultData>NameDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
