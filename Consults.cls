/// Perioptimization Class Definition for the Consults Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Class Definition for the Consults Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.Consults Extends (%JSON.Adaptor, Ens.Response)
{

// Property patientName As %String(MAXLEN = 100);

Property consultId As %String;

Property requestType As %String;

Property originalConsultDate As %String;

Property toService As %String(MAXLEN = 100);

Property clinicIEN As %String;

Property clinicName As %String;

Property dateOfRequest As %String;

Property urgencyOrErarliestDate As %String(MAXLEN = 150);

Property providerID As %String;

Property providerName As %String;

Property serviceRenderedAs As %String(MAXLEN = 150);

Property prohibitedClinicFlag As %String;

Property clinicIndicatedDate As %String;

Property numberOfPhoneContacts As %String;

Property dateOfLastLetter As %String;

Property covidPriority As %String;

Storage Default
{
<Data name="ConsultsDefaultData">
<Subscript>"Consults"</Subscript>
<Value name="1">
<Value>consultId</Value>
</Value>
<Value name="2">
<Value>requestType</Value>
</Value>
<Value name="3">
<Value>originalConsultDate</Value>
</Value>
<Value name="4">
<Value>toService</Value>
</Value>
<Value name="5">
<Value>clinicIEN</Value>
</Value>
<Value name="6">
<Value>clinicName</Value>
</Value>
<Value name="7">
<Value>dateOfRequest</Value>
</Value>
<Value name="8">
<Value>urgencyOrErarliestDate</Value>
</Value>
<Value name="9">
<Value>providerID</Value>
</Value>
<Value name="10">
<Value>providerName</Value>
</Value>
<Value name="11">
<Value>serviceRenderedAs</Value>
</Value>
<Value name="12">
<Value>prohibitedClinicFlag</Value>
</Value>
<Value name="13">
<Value>clinicIndicatedDate</Value>
</Value>
<Value name="14">
<Value>numberOfPhoneContacts</Value>
</Value>
<Value name="15">
<Value>dateOfLastLetter</Value>
</Value>
<Value name="16">
<Value>covidPriority</Value>
</Value>
</Data>
<DefaultData>ConsultsDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
