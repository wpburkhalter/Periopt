/// Perioptimization Class Definition for the CPT Codes Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Aug 31, 2022
/// Description: Class Definition for the List CPT Codes Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.ListCPTCodes Extends (%JSON.Adaptor, %Persistent)
{

Parameter %JSONNULL As BOOLEAN = 1;

Property NumberOfCodes As %String;

Property Codes As list Of CPTCodes;

ClassMethod getCodes() As %Status [ PublicList = (U, ConsultDetails, RESULTS) ]
{
	Try {
		s CPTList=##class(REST.SwitchLane.Periopt.ListCPTCodes).%New()
		s (cnt,xx)=0 f  s xx=$o(^ICPT(xx)) q:xx'>0  d
		.Q:'$D(^ICPT(xx,0))
		.s cptcode=##class(REST.SwitchLane.Periopt.CPTCodes).%New()
		.s cptcode.CPTCode=xx
		.s cptcode.CPTCodeText=$p(^ICPT(xx,0),"^",2)
		.s cnt=cnt+1
		.D CPTList.Codes.Insert(cptcode)
		s CPTList.NumberOfCodes=cnt
		d CPTList.%JSONExport()
		s response=200
	}
	Catch ex {
		Set tSC=ex.AsStatus()
	}
	

	q response
}

}
