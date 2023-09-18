/// Response Message defining the Perioptimization data structure used to pass data to and from VistA
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Aug 12, 2022
/// Description: Class to define the properties in the response message sent to Periopt from HC
/// to provide a success or failure when filing surgery data in VistA
/// Change Log:
/// 
Class REST.SwitchLane.Periopt.SurgeryResponse Extends (%Persistent, Ens.Response, %JSON.Adaptor)
{

Property MessageId As %String;

Property ControlId As %String;

Property ResponseCode As %String;

Property ResponseMessage As %String(MAXLEN = 150);

Property SurgeryCaseNumber As %String;

Storage Default
{
<Data name="SurgeryResponseDefaultData">
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
<Value>SurgeryCaseNumber</Value>
</Value>
</Data>
<DataLocation>^REST.Switc72E7.SurgeryRespF68BD</DataLocation>
<DefaultData>SurgeryResponseDefaultData</DefaultData>
<IdLocation>^REST.Switc72E7.SurgeryRespF68BD</IdLocation>
<IndexLocation>^REST.Switc72E7.SurgeryRespF68BI</IndexLocation>
<StreamLocation>^REST.Switc72E7.SurgeryRespF68BS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
