/// Request Message defining the Perioptimization data structure used to pass data to and from VistA
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Aug 12, 2022
/// Description: Class to define the properties in the request message sent from Periopt to HC needed
/// to schedule a surgery in VistA
/// Change Log:
/// 
Class REST.SwitchLane.Periopt.SurgeryData Extends (%Persistent, Ens.Response, %JSON.Adaptor)
{

// Property patient As %String(MAXLEN = 150) [ Required ]

Property MessageId As %String;

Property ControlId As %String;

Property Patient As %String(MAXLEN = 150) [ Required ];

Property DateOfOperation As %String;

Property PrimarySurgeon As %String(MAXLEN = 150);

Property AttendingSurgeon As %String(MAXLEN = 150);

Property SurgicalSpecialty As %String(MAXLEN = 150);

Property PrincipalOperativeProcedure As %String(MAXLEN = 150);

Property PrincipalPreOperativeDiagnosis As %String(MAXLEN = 150);

Property LateralityOfProcedure As %String;

Property PlannedAdmissionStatus As %String;

Property PlannedPrincipalProcedureCode As %String(MAXLEN = 150);

Property Icd10Code As %String;

Property HospitalAdmissionStatus As %String;

Property MajorOrMinor As %String;

Property CaseScheduleType As %String;

Property Palliation As %String;

Property PlannedPostOpCare As %String;

Property RequestedAnesthesiaTechnique As %String;

Property IntraoperativeXRays As %String;

Property ReferringPhysician As %String(MAXLEN = 150);

Property ConsultId As %String;

Property Scheduler As %String;

Property NoteTitle As %String;

Storage Default
{
<Data name="SurgeryDataDefaultData">
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
<Value>Patient</Value>
</Value>
<Value name="5">
<Value>DateOfOperation</Value>
</Value>
<Value name="6">
<Value>PrimarySurgeon</Value>
</Value>
<Value name="7">
<Value>AttendingSurgeon</Value>
</Value>
<Value name="8">
<Value>SurgicalSpecialty</Value>
</Value>
<Value name="9">
<Value>PrincipalOperativeProcedure</Value>
</Value>
<Value name="10">
<Value>PrincipalPreOperativeDiagnosis</Value>
</Value>
<Value name="11">
<Value>LateralityOfProcedure</Value>
</Value>
<Value name="12">
<Value>PlannedAdmissionStatus</Value>
</Value>
<Value name="13">
<Value>PlannedPrincipalProcedureCode</Value>
</Value>
<Value name="14">
<Value>Icd10Code</Value>
</Value>
<Value name="15">
<Value>HospitalAdmissionStatus</Value>
</Value>
<Value name="16">
<Value>MajorOrMinor</Value>
</Value>
<Value name="17">
<Value>CaseScheduleType</Value>
</Value>
<Value name="18">
<Value>Palliation</Value>
</Value>
<Value name="19">
<Value>PlannedPostOpCare</Value>
</Value>
<Value name="20">
<Value>RequestedAnesthesiaTechnique</Value>
</Value>
<Value name="21">
<Value>IntraoperativeXRays</Value>
</Value>
<Value name="22">
<Value>ReferringPhysician</Value>
</Value>
<Value name="23">
<Value>ConsultId</Value>
</Value>
<Value name="24">
<Value>Scheduler</Value>
</Value>
<Value name="25">
<Value>NoteTitle</Value>
</Value>
</Data>
<DataLocation>^REST.SwitchLan72E7.SurgeryDataD</DataLocation>
<DefaultData>SurgeryDataDefaultData</DefaultData>
<IdLocation>^REST.SwitchLan72E7.SurgeryDataD</IdLocation>
<IndexLocation>^REST.SwitchLan72E7.SurgeryDataI</IndexLocation>
<StreamLocation>^REST.SwitchLan72E7.SurgeryDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
