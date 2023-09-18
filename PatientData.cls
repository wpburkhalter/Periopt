/// Perioptimization Class Definition for the PatientData Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Class Definition for the PatientData Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.PatientData Extends (%JSON.Adaptor, %Persistent)
{

Property ICN As %String(MAXLEN = 150);

Storage Default
{
<Data name="PatientDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICN</Value>
</Value>
</Data>
<DataLocation>^REST.SwitchLan72E7.PatientDataD</DataLocation>
<DefaultData>PatientDataDefaultData</DefaultData>
<IdLocation>^REST.SwitchLan72E7.PatientDataD</IdLocation>
<IndexLocation>^REST.SwitchLan72E7.PatientDataI</IndexLocation>
<StreamLocation>^REST.SwitchLan72E7.PatientDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
