/// Perioptimization Class Definition for the PatientConsults Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Class Definition for the Patient Consults Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.PatientConsults Extends (%JSON.Adaptor, Ens.Response)
{

Property consultID As array Of REST.SwitchLane.Periopt.Consults;

Storage Default
{
<Data name="consultID">
<Attribute>consultID</Attribute>
<Structure>subnode</Structure>
<Subscript>"REST.SwitchLane.Periopt.PatientConsults.consultID"</Subscript>
</Data>
<Type>%Storage.Persistent</Type>
}

}
