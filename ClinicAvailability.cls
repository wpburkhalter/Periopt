/// Perioptimization Class Definition for the Clinic Availability Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Class Definition for the Clinic Availability Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.ClinicAvailability Extends (%Persistent, Ens.Response)
{

Property SDECCLINICAVAILABILITY As %String;

Storage Default
{
<Data name="ClinicAvailabilityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDECCLINICAVAILABILITY</Value>
</Value>
</Data>
<DataLocation>^REST.Switc72E7.ClinicAvail1734D</DataLocation>
<DefaultData>ClinicAvailabilityDefaultData</DefaultData>
<IdLocation>^REST.Switc72E7.ClinicAvail1734D</IdLocation>
<IndexLocation>^REST.Switc72E7.ClinicAvail1734I</IndexLocation>
<StreamLocation>^REST.Switc72E7.ClinicAvail1734S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
