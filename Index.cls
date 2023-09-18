/// Perioptimization REST End Point with APIs to handle appointment actions
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Methods to either pull or push data between VistA and the Perioptimization application
/// Change Log:
/// Notes: in the same urls for each method, the fqdn is the fully qualified domain name
/// of the IRIS server and the port for the IRIS servers webservices port.
Class REST.SwitchLane.Periopt.Index Extends (%Persistent, Ens.BusinessService)
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

// Parameter EnsServicePrefix = "|periopti";

/// Periopt.SurgeryData
/// ClassMethod fileSurgery(pInput As %Library.AbstractStream, Output pOutput As %Stream.Object, pfileData As %Stream.Object) As %Status
/// input parameters:
/// pInput = JSON message with the input data
/// pOutput = JSON message with the appointment id (IEN from the Surgery File (#130))
/// url = http://fqdn:port/csp/vista/periopti/surgery:JSON msg with input data
ClassMethod fileSurgery(pInput As %DynamicAbstractObject, Output pOutput As %Stream.Object) As %Status [ PublicList = (DUZ, U) ]
{
    S status=""
    set status = ##class(REST.SwitchLane.Periopt.Common.VistALogin).CheckKey(DUZ,"SROREQ")
    I $p(status,"^")=2 d ##class(REST.SwitchLane.Periopt.ErrorMessages).createErrorMsg($p(status,"^",2),"User Security Key",$p(status,"^",3)) q 200
    set pJSON = {}.%FromJSON(%request.Content),U="^"
	s tSC=##class(REST.SwitchLane.Periopt.FileData).fileSurgery1(pJSON)
	S tSC=200
	q tSC
}

/// class getAvailability accepts the input parameters of:
/// pClinic = clinic IEN from the VistA Hospital Location file (#44)
/// pStart = start date to get clinic availability, in ISO8601 format CCYY-MM-DDTHH:MM-OFFSET
/// pEnd = end date to get clinic availability, in ISO8601 format CCYY-MM-DDTHH:MM-OFFSET
/// pStart and pEnd parameters are sent as ISO8601 format CCYY-MM-DDTHH:MM-OFFSET
/// Output = list of availability in the format: date in HL7 format (yyyymmdd)^start time^end time^number of available slots
/// url = http://fqdn:port/csp/vista/periopti/getAvailability/clinic IEN/pStart/pEnd
ClassMethod getAvailability(pClinic As %String, pStart As %String, pEnd As %String, Output pOutput As %Stream.Object) As %Status
{
	
	#dim pReply As %Stream.Object
	s pReply=""

	I pClinic="" s pReply = "{Error: Clinic parameter is not defined}"
	I pStart="" s pReply = "{Error: Start date/time is not defined}"
	I pEnd="" s pReply = "{Error: End date/time is not defined}"
	I pEnd<pStart s pReply = "{Error: End date/time is less than Start date/time}"
	try{
	D GETCLNAVAILABLTY^SDES(.LST,pClinic,pStart,pEnd)
	I $D(LST(1)) {
	S pResponse="",X1=0 F  S X1=$O(LST(X1)) Q:X1'>0  S pResponse=pResponse_$g(LST(X1))
	S pReply=$g(pResponse)

	}
	I '$D(LST(1)) {
		S pReply = "{Error: Clinic "_pClinic_" returned no availability data}"
	}
	
	}	
	catch { s pReply = "{Error: Unable to run the query}"}
	
	w pReply
	q 200
}

/// get list of appointments for a clinic and date range
/// calls the SDEC GET APPTS BY CLIN IEN 2 API/RPC in VistA
/// input parameters:
/// 		pClinic = the clinic IEN from the VistA Hospital Location File (#44)
/// 		pStart = the start date and time in ISO 8601 format, example: "2022-09-21T00:01:00-06:00"
/// 		pEnd= the end date and time in ISO 8601 format, example: "20221031T23:59:59-06:00"
/// output is a JSON list of all appointments for the clinic within the date range  
ClassMethod getClinicAppts(pClinic As %String, pStart As %String, pEnd As %String) As %Status
{
	q:pClinic=""
	q:pStart=""
	q:pEnd=""
	q:'$d(^SC(pClinic,0))
	; need to add try/catch blocks
	D GETAPPTWRAPCLIN2^SDES(.LST,pClinic,pStart,pEnd)
	
	S pResponse="",X1=0 F  S X1=$O(LST(X1)) Q:X1'>0  S pResponse=pResponse_$g(LST(X1))

	S pReply=$g(pResponse)
	w pReply
	q 200
}

/// getClinics returns all clinics in VistA that are active and have an appointment grid set up
/// url = https://vhalebappperiov.v04.med.va.gov/csp/vista/rest/switchlane/periopt/clinics
ClassMethod getClinics() As %Status
{
	K XX,RTN,CNT,YY,CLINIC,JR,JR1
	s XX=0,CNT=1,YY="" F  S YY=$O(^SC("B",YY)) Q:$G(YY)=""  f  s XX=$o(^SC("B",YY,XX)) Q:XX'>0  I $P($G(^SC(XX,"I")),"^",1)="" D
	.Q:$P($G(^SC(XX,"SL")),"^")=""
	.Q:$P(^SC(XX,"SL"),"^")=""
	.Q:$P(^SC(XX,"SL"),"^",3)=""
	.Q:'$D(^SC(XX,"ST"))
	.Q:$P(^SC(XX,0),"^",3)'["C"
	.S RTN($P(^SC(XX,0),"^"))=XX_"^"_$P(^SC(XX,"SL"),"^")_"^"_$P(^SC(XX,"SL"),"^",3),CNT=CNT+1

	Merge ^||AR=RTN
	S ZERR="",CLINICS=""
 	Do ENCODE^XLFJSON("^||AR","^||JR","ZERR")

 	Merge JR=^||JR
 	Set x=0 For { Set x=$Order(JR(x)) Quit:+x=0  Write JR(x) }

	K XX,RTN,CNT,YY
	
	Q $$$OK
}

// ClassMethod appointmentAction(pInput As %Library.AbstractStream, Output pOutput As %Stream.Object) As %Status

/// The appointmentAction classmethod makes a clinic or surgery appointment in VistA
/// To make a VistA Clinic Appointment, the clinic must exist and have availability for the requested time
/// The patient can't have another appointment at the same time at that medical center
/// If both the clinic and patient availability exist, generate the appointment request first. Once the 
/// request has been created in the SDEC Appointment Request file, the appointment can be made.
/// The return is the JSON ack/nak message with the appointment IEN from the SDEC Appointment file if the
/// make appointment is successful. If the appointment request can't be created, or the appointment request is
/// created but the appointment make actiion fails, the JSON ack/nak message will have a status of CR and will
/// have the return message from the API as the failure reason.
/// 
/// To make a surgery appointment, the data is filed in the VistA Surgery File (#130)
/// input data:
/// 	pInput = JSON message with the data needed to make the appointment
/// output data:
/// 	pOutput = JSON message containing the ack/nak code. if the appointment is made, return data will include the
/// 			  the IEN from SDEC Appointment file (#409.85). If the appointment is not made, the failure reason
/// 			  in the JSON return message
/// url = http://fqdn:port/csp/vista/periopti/appointment:JSON message
ClassMethod appointmentAction(pHTTPResponseOutput As %Stream.GlobalCharacter) As %Status
{
	 	 
	 // read the JSON message to determine if this is a clinic or surgery appointment
	 // call the appropriate methods in the Periopt.Utilities calls to make the correct appointment.
	 // surgery: ##class(Periopt.Utilities).surgeryAppointment(pass in data from the JSON message)
	 // clinic: ##class(Periopt.Utilities).dentalAppointment(pass in the data from the JSON message)
	 // both classes should return the ack/nak message in JSON format
	 $$$LOGINFO("REQUEST "_%request.Content)
	 ;s json=$Replace(%request.Content,"\","")
	 s pRequestBody={}.%FromJSON(%request.Content)

	 $$$LOGINFO("Scheduling Surgery for "_pRequestBody.Patient_" on date "_pRequestBody.DateOfOperation)
	 s SurgeryCaseNumber = ##class(REST.SwitchLane.Periopt.FileData).fileSurgery1(.pRequestBody)

	 s pResponseBody=##class(REST.SwitchLane.Periopt.SurgeryResponse).%New()
	 s pResponseBody.ControlId = pRequestBody.ControlId
	 s pResponseBody.MessageId = pRequestBody.MessageId
	 s pResponseBody.ResponseMessage = ""
	 s pResponseBody.ResponseCode = "AA"
	 s pResponseBody.SurgeryCaseNumber = SurgeryCaseNumber
	 d pResponseBody.%JSONExport()
	 
	 Quit $$$OK
}

/// class ReturnJSONAckMsg returns the ack or nak message in HTTP/JSON format
ClassMethod ReturnJSONAckMsg(pInput As %DynamicObject, pRejectReason As %String) As %Status
{
   	#Dim tSC3 as %Status = $$$OK
   	s apptResponseMsg=##class(REST.SwitchLane.Periopt.SurgeryResponse).%New()
   	s apptResponseMsg.ControlId=$p(pInput,"^",1)
   	s apptResponseMsg.MessageId=$p(pInput,"^",2)
   	s apptResponseMsg.ResponseCode=$p(pInput,"^",3)
   	s apptResponseMsg.ResponseMessage=$p(pInput,"^",4)
   	s apptResponseMsg.SurgeryCaseNumber=$p(pInput,"^",5)
   	s msglen=$l(apptResponseMsg)
	s tMsg=##class(%GlobalCharacterStream).%New()
	d tMsg.CopyFrom(pStream)
	d pResponseBody.StreamSet(tMsg)
	d pResponseBody.HTTPHeaders.SetAt("application/json","Content-Type")
	d pResponseBody.HTTPHeaders.SetAt(msglen,"Content-Length")
	d pResponseBody.HTTPHeaders.SetAt("application/json","Accept")
   	
   	d pResponseBody.%JSONExport()
   	quit 1 ;pResponseBody
}

/// gets a list of a patient's appointment requests
/// the list includes the patient's active appointment requests
/// including any RTC's. Consults are not returned by this API
/// for Consults use the getPatientConsults API
/// input is the patient ICN
/// returns a list the patient's appointment request in JSON format
/// URL: http://fqdn:port/csp/vista/periopti/getPatientApptRequest/8
/// gets a list of a patient's appointment requests
/// the list includes the patient's active appointment requests
/// including any RTC's. Consults are not returned by this API
/// for Consults use the getPatientConsults API
/// input is the patient ICN
/// returns a list the patient's appointment request in JSON format
/// URL: http://fqdn:port/csp/vista/periopti/getPatientApptRequest/8
ClassMethod getPatientApptRequest(pInput As %String) As %Status [ PublicList = U ]
{
	q:$g(pInput)'>0
	S U="^"
	s DFN=##class(REST.SwitchLane.Periopt.Utilities).patientLookup(pInput)
	;need a check to make sure the patient exists on the VistA system
	D GETREQSBYDFN^SDES(.LST,DFN)
	s pReply=$p(LST(1),"=",2)
	w LST(1)
	q $$$OK
}

/// gets a list of a patient's appointments
/// input is the patient DFN, start and end date/time, both dates are in yyyymmdd@00:01
/// returns a list the patient's appointments in JSON format
/// URL: http://fqdn:port/csp/vista/periopti/getPatientAppointments/8/20230601/20230630
ClassMethod getPatientAppointments(pInput As %String, pSdate As %String, pEdate As %String) As %Status [ PublicList = U ]
{
	;need a check to make sure the patient exists on the VistA system
	S U="^"
	s DFN=##class(REST.SwitchLane.Periopt.Utilities).patientLookup(pInput)
	D GETAPPTBYPATDFN^SDESGETAPPTWRAP4(.LST,DFN,pSdate,pEdate)
	s pReply=$p(LST(1),"=",2)
	;w LST(1)
	;W LST(2)
	S i=0 f  s i=$o(LST(i)) q:i'>0  w LST(i)
	q $$$OK
}

/// files surgery notes in VistA
/// ClassMethod fileNotes(pInput As periopti.NotesMsg, Output pOutput As %Stream.Object) As %Status
ClassMethod fileNotes(pInput As %DynamicAbstractObject, Output pOutput As %Stream.Object) As %Status [ PublicList = (U, DT, DUZ, ES, RTN, RTN1, RTN2, TIUX) ]
{

	set pJSON = {}.%FromJSON(%request.Content)
	s appkey = $SYSTEM.Encryption.Base64Decode(%request.GetCgiEnv("HTTP_APPKEY"))
	s DUZ = ##class(REST.SwitchLane.Periopt.Utilities).checkUser(appkey)
	I $G(DUZ)'>0 throw ##class(%Exception.General).%New("Authentication Error",5035,"index.fileNotes","DUZ is not defined.")
	I $G(DUZ)'>0 Q "{ ""FailureReason : ""User not found on this VistA system.""}"
	d NOW^%DTC
	s U="^",DT=$P(%,".")
	s DUZ=pJSON.Authorid
	s NoteIEN = ##class(REST.SwitchLane.Periopt.FileData).fileSurgeryNote(pJSON)
	w NoteIEN
	q 200
}

/// gets a list of all the patients pending consult requests.
/// will only return active and pending consult requests
/// input is the patient's ICN
/// returns a list of active or pending consult requests in JSON format
/// URL: http://fqdn:port/csp/vista/periopti/getPatientConsults/8
ClassMethod getPatientConsults(pInput As %String) As %Status
{
	
	q:$g(pInput)'>0
	s DFN=##class(Periopt.Utilities).patientLookup(pInput)
	;need a check to make sure the patient exists on the VistA system
	D JSONCONSLIST^SDEC1(.LST,DFN)
	K LAST,XX,I
	
	S XX=0 F  S XX=$O(LST(XX)) Q:XX'>0  S LAST=XX
	F I=1:1:LAST D
	.w !,LST(I)
	K LAST,XX,I
	q $$$OK
}

/// gets the details for a consult for a patient
/// url: http://fqdn:port/csp/vista/periopti/getConsultDetails/consultid
ClassMethod getConsultDetails(pInput As %String) As %Status
{

 	S tSC=..pullConsultDetails(pInput)
 	;w tSC

	Q 200
}

/// gets all the active/pending consults from VistA
/// filters: consult service IEN
/// returns: patient name and DFN, Provider name and secid, all the data from get patient consults and the consult details.
ClassMethod getAllConsults() As %Status
{
	S (STATUS,XX)=0 F  S STATUS=$O(^GMR(123,"D",STATUS)) Q:STATUS'>0  f  s XX=$O(^GMR(123,"D",STATUS,XX)) Q:XX'>0  d
        .Q:"5,6"'[STATUS
        .Q:$P(^GMR(123,XX,0),"^",5)'=9
		.s consultList=##class(REST.SwitchLane.Periopt.ConsultDetails).%New()
		d ##class(REST.SwitchLane.Periopt.AllConsultsAndDetails).getConsultData()
	q 200
}

ClassMethod getProviders(search) As %Status [ PublicList = (U, DT, DUZ, List, pList) ]
{
	Set limit = 0
	k pList

 	If search'="xxxxxxxx"
   		{
   			If $Length(search)<1 Write "{}",! Quit $$$OK
   			Set search=$Zconvert(search,"U")
   			If search[" "
     		{
    			Set search1=$Piece(search," ",1)
    			Set search2=$Piece(search," ",2)
     		}
   Else
     	{
     		Set search1=search
     		Set (search2)=""
     	}
   Set NAME=$Order(^VA(200,"B",search1),-1)
   
   For
     	{
     		Set NAME=$Order(^VA(200,"B",NAME)) Quit:NAME=""
     		Set IEN=0 For
       		{
       			Set IEN=$Order(^VA(200,"B",NAME,IEN)) Quit:+IEN=0
       			Quit:$Extract(NAME,1,$Length(search1))'=search1
       			If search2'="",NAME'[search2 Continue
       			Set limit=limit+1 Quit:limit>1500
       			q:'$d(^XUSEC("PROVIDER",IEN))
       			s pList(IEN)=NAME
       		}
    	 }
	}
	
	k List
	S allProviders=##class(REST.SwitchLane.Periopt.Provider).%New()
	s (cnt,XX)=0 f  s XX=$o(pList(XX)) q:XX'>0  s cnt=cnt+1  d
	.s ien=XX_","
	.s provList=##class(REST.SwitchLane.Periopt.ProviderList).%New()
	.d GETS^DIQ(200,ien,".01;.131;8;41.99;53.2;53.5;205.1;205.5","IE","List","PROVERR")
	.s provList.ProviderName=List(200,ien,.01,"E")
	.s provList.DEANumber=List(200,ien,53.2,"E")
	.s provList.Duz=XX
	.s provList.Email=List(200,ien,205.5,"E")
	.s provList.Phone=List(200,ien,.131,"E")
	.s provList.Qualification=List(200,ien,8,"E")
	.s provList.Npi=List(200,ien,41.99,"E")
	.s provList.Secid=List(200,ien,205.1,"E")
	.s provList.Role=$g(List(200,ien,53.5,"E"))
	.d allProviders.Providers.Insert(provList) 

	s allProviders.NumberofProviders=cnt
	d allProviders.%JSONExport()
	q 200
}

ClassMethod pullConsultDetails(pConid As %String) As %Status [ PublicList = (U, ConsultDetails) ]
{
	
	d GETS^DIQ(123,pConid,"*","E","ConsultDetails","CONERR")
	s CONID=pConid_","
	#dim RESULTS As %Stream
	S RESULTS=""
	;ConsultDetails(123,"667,",14,"E")="inpatient"
	s patientICN=$$GET1^DIQ(2,$P(^GMR(123,pConid,0),"^",2),991.01,"I")
	W !,"patienticn= ",patientICN
	s ProviderSecid=$$GET1^DIQ(200,$P(^GMR(123,pConid,0),"^",14),205.1,"I")
	w !,"provider secid= ",ProviderSecid

	s X1=0 F  S X1=$O(ConsultDetails(123,CONID,X1)) Q:X1'>0  D
	.Q:X1=20
	.S:X1>1 RESULTS=RESULTS_"|"_$P(^DD(123,X1,0),"^")_": "_$G(ConsultDetails(123,CONID,X1,"E"))
	S X2=0,RESULTS=RESULTS_"|"_$P(^DD(123,20,0),"^")_": "  F  S X2=$O(ConsultDetails(123,CONID,20,X2)) q:X2'>0  D
	.s RESULTS=RESULTS_"|"_$G(ConsultDetails(123,CONID,20,X2))
	s pResponseMsg=##class(REST.SwitchLane.Periopt.ConsultDetails).%New()
	;S pResponseMsg.PatientICN=patientICN
	;s pResponseMsg.ProviderSecid=ProviderSecid
	s pResponseMsg.Data=RESULTS
	d pResponseMsg.%JSONExport()
	q RESULTS
}

Storage Default
{
<Data name="IndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>%WaitForNextCallInterval</Value>
</Value>
<Value name="3">
<Value>ThrottleDelay</Value>
</Value>
<Value name="4">
<Value>%PreserveSession</Value>
</Value>
<Value name="5">
<Value>%RequestHeader</Value>
</Value>
<Value name="6">
<Value>%AlertStartTime</Value>
</Value>
<Value name="7">
<Value>%ProcessError</Value>
</Value>
<Value name="8">
<Value>AlertGracePeriod</Value>
</Value>
<Value name="9">
<Value>%OutsideCreated</Value>
</Value>
<Value name="10">
<Value>%SessionId</Value>
</Value>
<Value name="11">
<Value>%SuperSessionCreatedBeforeSession</Value>
</Value>
<Value name="12">
<Value>%SuperSession</Value>
</Value>
<Value name="13">
<Value>Adapter</Value>
</Value>
<Value name="14">
<Value>%ConfigQueueName</Value>
</Value>
<Value name="15">
<Value>%ConfigName</Value>
</Value>
<Value name="16">
<Value>%QuitTask</Value>
</Value>
<Value name="17">
<Value>AlertGroups</Value>
</Value>
<Value name="18">
<Value>AlertOnError</Value>
</Value>
<Value name="19">
<Value>ArchiveIO</Value>
</Value>
<Value name="20">
<Value>BusinessPartner</Value>
</Value>
<Value name="21">
<Value>GenerateSuperSessionID</Value>
</Value>
<Value name="22">
<Value>IOLogEntry</Value>
</Value>
<Value name="23">
<Value>InactivityTimeout</Value>
</Value>
</Data>
<DataLocation>^REST.SwitchLane.Periopt.IndexD</DataLocation>
<DefaultData>IndexDefaultData</DefaultData>
<IdLocation>^REST.SwitchLane.Periopt.IndexD</IdLocation>
<IndexLocation>^REST.SwitchLane.Periopt.IndexI</IndexLocation>
<StreamLocation>^REST.SwitchLane.Periopt.IndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
