/// Utilities used by Perioptimization to pass data to and from VistA
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Aug 12, 2022
/// Description: Methods to either pull or push data between VistA and the Perioptimization application
/// Change Log:
/// Notes:
Class REST.SwitchLane.Periopt.Utilities Extends %Persistent
{

/// ClassMethod used to file data in the VistA SURGERY File (#130)
/// Typically called from the Periopt.ProcessSurgeryData business process in the Periopt production
ClassMethod filePerioptA(ICN As %String, DateofOperation As %String, OperationText As %String) As %Status
{
	K ^||IEN,^||ZERR
	S (FDAIEN,XX)=0 F  S XX=$O(^PER(500001,XX)) Q:XX'>0  S:XX>0 FDAIEN=XX
 	S ^||IEN(1)=FDAIEN   ;+1
 	S X1=FDAIEN+1
	S ^zzphil("periopt","fdaien")=^||IEN(1)_" ^ "_$J
	;s fileSurgery("periopt","fdaien")=
	S ^||ZERR=1 
 	
 	
 	I $G(ICN)["V" 
 	{
	 	S ICN=$$GETDFN^MPIF001($P(ICN,"V"))
 	}
 	I $G(ICN)'["V" 
 	{
	 	S ICN=$$GETDFN^MPIF001(ICN)
 	}
 	I '$D(^DPT(ICN,0)) S ZERR="CE^PATIENT IS NOT ON THIS VISTA SYSTEM" Q ZERR
 	
 	S ^||TMPPER(1,500001,"+1,",.01)=ICN
 	S ^||TMPPER(1,500001,"+1,",1)=DateofOperation
 	S ^||TMPPER(1,500001,"+1,",2)=OperationText
 	
 	D UPDATE^DIE("","^||TMPPER(1)","^||IEN","^||ZERR")
	
 	
 	S ZERR=$g(^||ZERR("DIERR",1))_"^"_$g(^||ZERR("DIERR",1,"TEXT",1))
 	 	
 	I $P(ZERR,"^",2)=""
 		{
	 		I $P($G(^PER(500001,X1,0)),"^",1)=ICN S ZERR=X1_"^"_""
 		}
 		
 	K ^||IEN
 	Q ZERR
}

/// Class Method used to check a user's VistA access
ClassMethod checkUser(pSecId As %String) As %Status [ PublicList = (U, DT, DUZ) ]
{
	set U = "^",DUZ=0
	if (pSecId '= "") {
		set DUZ = $$SECMATCH^XUESSO2(pSecId)
		set XUNOW=$$HTFM^XLFDT($H),DT=$P(XUNOW,".")
		do USER^XUS(DUZ)
		set checkValid = $$UVALID^XUS
		;if (checkValid > 0) set obj.DUZ = 0
		;else  set obj.DUZ = DUZ
	}
	
	if DUZ>0 s checkOptions=..checkOptions("GMR MGR,OR CPRS GUI CHART")
	
    Q DUZ
}

ClassMethod checkOptions(pOptions As %String) As %Status
{
	s options = "GMRC MGR,OR CPRS GUI CHART",DUZ=1057
	for index=1:1:$length(options,",") {
		set option = $piece(options,",",index)
		set status = ##class(REST.SwitchLane.Periopt.Common.VistALogin).CheckOption(DUZ,option)
		set reason = $System.Status.GetErrorText(status)
		if '+status throw ##class(%Exception.General).%New("Login Error",5035,"checkUser.Utilities.cls",$P(reason, ": ",2))
	    }
	 
	q status
}

/// Class method that will accept a list of parameters to update the VistA SURGERY File (#130)
/// Typically called from the Periopt.ProcessSurgeryData business process in the Periopt production
/// ClassMethod filePerioptB(ByRef pInput, msgid As %String) As %Status
ClassMethod surgeryAppointment(ByRef pInput) As %Status
{
	
	
	
	;s ^zzphil("periopt","b",1)=msgid
	;s ^zzphil("periopt b","patient")=..patientLookup(pInput.GetAt("patient"))
	;s ^zzphil("periopt b","date of operation")=pInput.GetAt("dateofoperation")
	;s pData=##class(Periopt.SurgeryData).%Open(pInput)
	;s pData=##class(Periopt.SurgeryData).%New(pInput.Id)
	;d pInput.Rewind()
	;s pData=pInput.Read()
	;s pData=pInput.CopyFrom()
	;s ^zzphil("in filePerioptb","pData")=pInput.patient
	;d APPERROR^%ZTER("IN B")
	
	
	/**
	K ^||IEN,^||ZERR
	S XX=0 F  S XX=$O(^PER(500001,XX)) Q:XX'>0  S:XX>0 FDAIEN=XX
 	S ^||IEN(1)=FDAIEN+1
	S ^zzphil("periopt","b","fdaien")=^||IEN(1)_" ^ "_$J
	S ^||ZERR=1 
 	
 	M ^zzphil("periopt","b","SURGDATA")=SURG
 	M ^||SURGDATA = SURG
 	S ^TMPPER(1,500001,"+1,",.01)=list.PatientICN  ;context.PatientICN
 	S ^TMPPER(1,500001,"+1,",1)=list.DateofOperation  ;context.DateOfOperation
 	S ^TMPPER(1,500001,"+1,",2)=list.OperationText  ;"THIS IS TEST "_context.MSGID
 	
 	D UPDATE^DIE("","^||SURGDATA","^||IEN","^||ZERR")
 	D APPERROR^%ZTER("class method b")
 	
 	S ^zzphil("zerr1","b")=$g(^||ZERR("DIERR",1))
 	S ^zzphil("zerr","b")=$g(^||ZERR("DIERR",1,"TEXT",1))
 	S ZERR=$g(^||ZERR("DIERR",1))_"^"_$g(^||ZERR("DIERR",1,"TEXT",1))
 	K ^||IEN
 	Q ZERR
 	**/
 	q 1
}

ClassMethod patientLookup(ICN As %String)
{
	I $G(ICN)["V" 
 	{
		S DFN=$$GETDFN^MPIF001($P(ICN,"V"))
 	}
 	I $G(ICN)'["V" 
 	{
	 	S DFN=$$GETDFN^MPIF001(ICN)
 	}
 	Q DFN
}

/// dentalAppointment handles regular clinic appointment actions
/// method parses the data and calls methods make or cancel the appointment
ClassMethod dentalAppointment(ByRef pData) As %Status
{
	//if make do ..make(data)
	//if cancle do ..cancel(data)
	//if reschedule do ..reschedule(data)
	q
}

/// Get Available slots for a VistA clinic for a date range
/// clinic is pointer to the clinic in the Hospital Location file (#44)
/// startDt is the start date and time in VA VistA FileMan Format
/// endDt is the end date and time in VA VistA FileMan Format
ClassMethod getAvailableSlots(clinic As %List, Output pOuput As %Stream.Object) As %Status
{
	K LST
	s iClinic=$g(clinic("clinic"))
	s iStartDt=$g(clinic("start"))
	s iEndDt=$g(clinic("end"))
	
	
	
	d GETCLNAVAILABLTY^SDES(.LST,iClinic,iStartDt,iEndDt)
	S pResponse=##class(Periopt.ClinicAvailability).%New()
	s pResponse.SDECCLINICAVAILABILITY=$p(LST(1),":",3)
	set tSC=##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.pStream,pResponse,,,,"eloiw")

	q "FINISHED"  ;LST(1)
}

Storage Default
{
<Data name="UtilitiesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^REST.SwitchLane72E7.UtilitiesD</DataLocation>
<DefaultData>UtilitiesDefaultData</DefaultData>
<IdLocation>^REST.SwitchLane72E7.UtilitiesD</IdLocation>
<IndexLocation>^REST.SwitchLane72E7.UtilitiesI</IndexLocation>
<StreamLocation>^REST.SwitchLane72E7.UtilitiesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
