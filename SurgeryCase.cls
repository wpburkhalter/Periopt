/// Perioptimization Class defining the Surgery Cases Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 13, 2023
/// Description: Defines the defining the surgery case object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.SurgeryCase Extends (%JSON.Adaptor, %Persistent)
{

Property CaseNumber As %String;

Property PatientName As %String(MAXLEN = 150);

Property PatientICN As %String;

Property SurgicalSpecialty As %String(MAXLEN = 150);

Property ScheduledDateOfOperation As %String(MAXLEN = 100);

}
