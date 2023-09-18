/// Perioptimization Class Definition for the EmpId Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Aug 22, 2023
/// Description: Class Definition for the EmpId Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.EmpId Extends (Ens.Response, %Persistent, %JSON.Adaptor)
{

Property Provider As %String;

Storage Default
{
<Data name="EmpIdDefaultData">
<Subscript>"EmpId"</Subscript>
<Value name="1">
<Value>Provider</Value>
</Value>
</Data>
<DefaultData>EmpIdDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
