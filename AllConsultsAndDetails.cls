/// Perioptimization Class Definition for the All Consults with Details Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Aug 23, 2023
/// Description: Class Definition for the All Consults with Details Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.AllConsultsAndDetails Extends (%JSON.Adaptor, %CSP.REST, %Persistent)
{

Parameter %JSONNULL As BOOLEAN = 1;

Property consultId As %String;

Property patientName As %String(MAXLEN = 100);

Property patientICN As %String(MAXLEN = 150);

Property patientID As %String;

Property requestType As %String;

Property originalConsultDate As %String;

Property toService As %String(MAXLEN = 100);

Property clinicIEN As %String;

Property clinicName As %String;

Property dateOfRequest As %String;

Property urgencyOrErarliestDate As %String(MAXLEN = 150);

Property providerNPI As %String;

Property providerID As %String;

Property providerName As %String;

Property providerSecid As %String(MAXLEN = 150);

Property serviceRenderedAs As %String(MAXLEN = 150);

Property prohibitedClinicFlag As %String;

Property clinicIndicatedDate As %String;

Property numberOfPhoneContacts As %String;

Property dateOfLastLetter As %String;

Property covidPriority As %String;

Property consultData As %String(MAXLEN = 10000);

ClassMethod getConsultsandDetails() As %Status
{
        ;w !,"in AllConsultsAndDetails.getConsultDetails"
      
        S (STATUS,XX)=0 F  S STATUS=$O(^GMR(123,"D",STATUS)) Q:STATUS'>0  f  s XX=$O(^GMR(123,"D",STATUS,XX)) Q:XX'>0  d
        .Q:"5,6"'[STATUS
        .Q:$P(^GMR(123,XX,0),"^",5)'=9
        .;W !,STATUS,"  ",XX
        .;W !,XX,"  ",STATUS,"  ",$G(^GMR(123,XX,0))
        .s tSC=..getConsultData(XX)
        ;d consult.%JSONExport()
        q 200
}

// ClassMethod getConsultData(pCnt As %String) As %Status [ PublicList = (U, ConsultDetails, RESULTS) ]

/// Description
ClassMethod getConsultData() As %Status [ PublicList = (U, ConsultDetails, RESULTS) ]
{
    Set tSC = $$$OK

    s results=""
   		
	s Consults=##class(REST.SwitchLane.Periopt.ConsultDetails).%New()


    S (STATUS,XX)=0 F  S STATUS=$O(^GMR(123,"D",STATUS)) Q:STATUS'>0  f  s XX=$O(^GMR(123,"D",STATUS,XX)) Q:XX'>0  d
   	.s CONERR=""
   	.k results
	.Q:"5,6"'[STATUS
   	.d GETS^DIQ(123,XX,"*","IE","ConsultDetails","CONERR")
    .Q:$P(^GMR(123,XX,0),"^",5)'=9
    .s consult=..%New()
    .s consult.consultId=XX
    .s CONID=XX_","
    .s dfn=$g(ConsultDetails(123,CONID,.02,"I"))
    .S icn=$$GETICN^MPIF001(dfn)
    .s ien=XX_","
    .s consult.patientName=$g(ConsultDetails(123,CONID,.02,"E"))
    .s consult.patientID=$E(consult.patientName,1)_$E($P(^DPT(8,0),"^",9),6,9)
    .s consult.patientICN=icn
    .s consult.providerSecid=$p(^VA(200,($G(ConsultDetails(123,CONID,10,"I"))),205),"^")
    .s consult.providerID=$G(ConsultDetails(123,CONID,10,"I"))
    .s consult.providerNPI=$$GET1^DIQ(200,consult.providerID_",",41.99,"E")
    .s consult.originalConsultDate=$g(ConsultDetails(123,CONID,.01,"E"))
    .s consult.toService=$g(ConsultDetails(123,CONID,1,"E"))
    .s consult.clinicIEN=$g(ConsultDetails(123,CONID,2,"I"))
    .s consult.clinicName=$g(ConsultDetails(123,CONID,2,"E"))
    .s consult.dateOfRequest=$g(ConsultDetails(123,CONID,.01,"E"))
    .s consult.urgencyOrErarliestDate=$g(ConsultDetails(123,CONID,17,"E"))
    .s consult.serviceRenderedAs=""
    .s consult.clinicIndicatedDate=$g(ConsultDetails(123,CONID,17,"E"))
    .S X2=0 F  S X2=$O(ConsultDetails(123,CONID,20,X2)) q:X2'>0  D
    ..s results=$g(results)_"|"_ConsultDetails(123,CONID,20,X2)
    ..s consult.consultData=$g(results)
    .d Consults.Consult.Insert(consult)
    d Consults.%JSONExport()
    q 200
}

Storage Default
{
<Data name="AllConsultsAndDetailsDefaultData">
<Subscript>"AllConsultsAndDetails"</Subscript>
<Value name="1">
<Value>consultId</Value>
</Value>
<Value name="2">
<Value>PatientICN</Value>
</Value>
<Value name="3">
<Value>requestType</Value>
</Value>
<Value name="4">
<Value>originalConsultDate</Value>
</Value>
<Value name="5">
<Value>toService</Value>
</Value>
<Value name="6">
<Value>clinicIEN</Value>
</Value>
<Value name="7">
<Value>clinicName</Value>
</Value>
<Value name="8">
<Value>dateOfRequest</Value>
</Value>
<Value name="9">
<Value>urgencyOrErarliestDate</Value>
</Value>
<Value name="10">
<Value>providerID</Value>
</Value>
<Value name="11">
<Value>providerName</Value>
</Value>
<Value name="12">
<Value>providerICN</Value>
</Value>
<Value name="13">
<Value>serviceRenderedAs</Value>
</Value>
<Value name="14">
<Value>prohibitedClinicFlag</Value>
</Value>
<Value name="15">
<Value>clinicIndicatedDate</Value>
</Value>
<Value name="16">
<Value>numberOfPhoneContacts</Value>
</Value>
<Value name="17">
<Value>dateOfLastLetter</Value>
</Value>
<Value name="18">
<Value>covidPriority</Value>
</Value>
<Value name="19">
<Value>ConsultData</Value>
</Value>
</Data>
<DefaultData>AllConsultsAndDetailsDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
