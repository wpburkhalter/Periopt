/// Perioptimization Class Definition for the Consult Details Array Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Class Definition for the Consult Details Array Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.ConsultDetailArray Extends Ens.Request
{

Property ConsultDetails As %List;

Storage Default
{
<Data name="ConsultDetailArrayDefaultData">
<Subscript>"ConsultDetailArray"</Subscript>
<Value name="1">
<Value>ConsultDetails</Value>
</Value>
</Data>
<DefaultData>ConsultDetailArrayDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
