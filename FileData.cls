/// Perioptimization Class to file a note for a surgery consult
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Jul 26, 2023
/// Description: Files a note in VistA
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.FileData Extends %RegisteredObject
{

// Receives a JSON message type NotesMsg and uses the data to set the parameters for each of the APIs to be called

// the data in the JSON message is then filed in VistA by calling the code for the RPCs below:

// 	TIU CREATE RECORD - MAKE^TIUSRVP(.RETURN,DFN,TITLE,VDT,VLOC,VSIT,TIUX(ARRAY),VSTR,SUPPRESS,NOASF)

//  TIU SET DOCUMENT TEXT - SETTEXT^TIUSRVPT(.RETURN,TIUDA,TIUX(ARRAY),SUPPRESS)

//  TIU SIGN RECORD - SIGN^TIUSRVP(.RETURN,TIUDA,TIUX) - TIUX is the encoded electronic signature, -- maybe just send user's

//  DUZ and then lookup the esignature and use it.

// ClassMethod fileSurgeryNote(pInput As REST.SwitchLane.Periopt.NotesMsg, Output pOutput As %String) As %Status

ClassMethod fileSurgeryNote(pInput As REST.SwitchLane.Periopt.NotesMsg, Output pOutput As %String) As %Status [ PublicList = (U, DT, DUZ, ES, ORIGSTAT, RTN, RTN1, RTN2, TIU, VNUM, TIUX) ]
{
	s Results=##class(REST.SwitchLane.Periopt.NoteResponse).%New()
	s Results.ResponseMessage="Note successfully filed in VistA"
	s stop=0
 	S NoteTitleIen=$O(^TIU(8925.1,"B",$ZCONVERT(pInput.NoteTitle,"U"),""))
 	I '$D(^VA(200,$p(pInput.AuthorId,"^",1),0)) 
 	{
	 	S Results.ResponseMessage="Author doesn't have an account on this VistA system!"
	 	s stop=1
 	}  ;Q "{"_"""Failure Reason"""_""" : """_"""1^Author doesn't exist on this VistA system!"""_"}"
 	i stop=1 d Results.%JSONExport() Q 200
 	
 	;S ES=$$GET1^DIQ(200,$G(TIU("AUIEN")),20.4) ;W !,"ES = ",ES
 	;I $g(ES)="" s Results.ResponseMessage="Author doesn't have an electronic signature on VistA. The note is filed, but not signed. Only the Author can see the note until it is signed."
 	s pJSONIn=pInput.%ToJSON()
 
 	s pMessageText=##class(%DynamicObject).%New()
 	s pMessageText=pInput.NoteText.%ToJSON()
 	s pMessageText=$TR(pMessageText,"[]","")

 	s dynEntity = {}.%FromJSON(pMessageText) ;w !,"here ",dynEntity,!
 	s itr = dynEntity.%GetIterator()
 	s cnt=0
 	while itr.%GetNext(.key,.val) 
 		{	
 			S TIUX("TEXT",cnt+1,0)=val
 			s cnt=cnt+1
 			;w !,"tiux ",cnt," = ",val
 		}

 	S VDT=$$HL7TFM^XLFDT(pInput.VisitDateTime)

 	S DUZ=pInput.AuthorId,DUZ(2)=$$KSP^XUPARAM("INST")
	D MAKE^TIUSRVP(.RTN,pInput.Patient,NoteTitleIen,VDT,,,.TIUX)
 	I $P($G(RTN),"^")>0 D SETTEXT^TIUSRVPT(.RTN1,$P(RTN,"^",1),.TIUX) ;W !,RTN1
 	// Need to use the call to SIGNDOC^TIUCCRHL7P2
 	S TIU("AVAIL")="AV",TIU("COMP")="LA",TIU("SIGNED")=$$NOW^TIULC,TIU("CSIGNED")="",TIU("EC")=0,TIU("AUDA")=DUZ
 	s VNUM=pInput.ConsultId,ORIGSTAT=2,DUZ(2)=$$KSP^XUPARAM("INST")
	D SIGNDOC^TIUCCRHL7P2(RTN)
 	S RTN2="NOT SIGNED"
 	S:$P($G(^TIU(8925,RTN,15)),"^",2)'="" RTN2="SIGNED"
 	;S RTN = "{""NoteIen"" : "_RTN_" }"
 	s Results.NoteIen=RTN
 	d Results.%JSONExport()
 	q 200
 
 Quit $$$OK
}

ClassMethod fileSurgery1(pInput As REST.SwitchLane.Periopt.SurgeryData, Output pOutput As %String) As %Status [ PublicList = (DUZ, U) ]
{
	k Z1,DFN
	S tIEN=0,DUZ=0,GMRCDUZ=0
	s Results=##class(REST.SwitchLane.Periopt.SurgeryResponse).%New()
	s Results.ControlId=pInput.ControlId
	s Results.MessageId=pInput.MessageId
	s Results.ResponseMessage="Surgery Case Created"
	s Z1=pInput.Patient
	s scheduler=pInput.Scheduler
	I scheduler'="" s (DUZ,GMRCDUZ)=$O(^VA(200,"ASECID",scheduler,""))
	I $G(DUZ)'>0 
		{
			s Results.ResponseMessage="Scheduler doesn't have an account on VistA"
		}
	;d pResponseBody.%JSONExport()
	I $g(DUZ)'>0 D Results.%JSONExport() Q 200
	S Z1=$P(Z1,"V")
	S DFN=$$GETDFN^MPIF001(Z1),DUZ(2)=$$KSP^XUPARAM("INST")
	I $G(DFN)'>0 S IEN="Patient doesn't exist on this VistA" Q IEN
	S OperationDate=pInput.DateOfOperation
	S OperationDate=$$HL7TFM^XLFDT(OperationDate,"L")
	I OperationDate="" s IEN="Missing or incorrect date." Q IEN
	k ^||FDA(1,130,"+1,",999)
	S ^||FDA(1,130,"+1,",.01)=DFN
	;S ^||FDA(1,130,"+1,",.09)=pInput.DateOfOperation
	S ^||FDA(1,130,"+1,",.09)=OperationDate
	S ^||FDA(1,130,"+1,",.14)=pInput.PrimarySurgeon
	S ^||FDA(1,130,"+1,",.164)=pInput.AttendingSurgeon
	S ^||FDA(1,130,"+1,",.04)=pInput.SurgicalSpecialty
	S ^||FDA(1,130,"+1,",26)=pInput.PrincipalOperativeProcedure
	S ^||FDA(1,130,"+1,",33)=pInput.PrincipalPreOperativeDiagnosis
	S ^||FDA(1,130,"+1,",638)=pInput.LateralityOfProcedure
	S ^||FDA(1,130,"+1,",.013)=pInput.PlannedAdmissionStatus
	S ^||FDA(1,130,"+1,",27)=pInput.PlannedPrincipalProcedureCode
	S ^||FDA(1,130,"+1,",32.5)=pInput.Icd10Code
	S ^||FDA(1,130,"+1,",.011)=pInput.HospitalAdmissionStatus
	S ^||FDA(1,130,"+1,",.03)=pInput.MajorOrMinor
	S ^||FDA(1,130,"+1,",.035)=pInput.CaseScheduleType
	S ^||FDA(1,130,"+1,",661)=pInput.Palliation
	S ^||FDA(1,130,"+1,",.43)=pInput.PlannedPostOpCare
	S ^||FDA(1,130,"+1,",1.01)=pInput.RequestedAnesthesiaTechnique
	S ^||FDA(1,130,"+1,",1.035)=pInput.IntraoperativeXRays
	
	;$$$LOGINFO("IN FILING SURGERY DATA")
	s ERRORS="^||SURGERROR",^||FDAIEN(1)=""
	D UPDATE^DIE("","^||FDA(1)","^||FDAIEN","^||SURGERROR")
	w !,"duz2= ",DUZ(2)
	S (tIEN,IEN)=$S($G(^||FDAIEN(1))>0:$G(^||FDAIEN(1)),1:$G(^||SURGERROR))
	I $g(IEN)>0 {
		q:$g(GMRCDUZ)'>0
		D NOW^%DTC S NOTEDT=%
		S SURGDATE=$e(pInput.DateOfOperation,5,6)_"/"_$e(pInput.DateOfOperation,7,8)_"/"_$e(pInput.DateOfOperation,3,4)
		S COMMENT(1)="SCHEDULED FOR "_$g(SURGDATE)
		S (GMRCO,GMRCDA,GMRCA)=pInput.ConsultId
		S GMRCSTS=2,DUZ(2)=$$KSP^XUPARAM("INST")
		S PERERR=$$STATUS^GMRCGUIS(GMRCDA,2,3,GMRCDUZ,"","",.COMMENT)
		}
		
	I IEN>0 S Results.SurgeryCaseNumber=IEN ;s Results="{ "_"""SurgeryCaseNumber"""_" : "_IEN_" }"
	D Results.%JSONExport() Q 200
 	Q 200
}

}
