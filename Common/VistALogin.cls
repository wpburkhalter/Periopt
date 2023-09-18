/// SwitchLane's Periopt VistA Logon Class
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Methods to log a user on to VistA and pull user roles and permissions
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.Common.VistALogin Extends %RegisteredObject
{

ClassMethod Login(ACCESSVERIFYCODE As %String, SECID As %String, OPTIONS As %ListOfDataTypes(ELEMENTTYPE="%String"), KEYS As %ListOfDataTypes(ELEMENTTYPE="%String")) As %Status [ PublicList = (U, DT, X, Y, VAL, XUF, DUZ, DT, XUSER, XUSER, XQUR, XUNOW) ]
{
		set obj = {}
		set U = "^"
		set XUF = 0
		if ((SECID = "") && (ACCESSVERIFYCODE '= ""))
		{
			set DUZ = $$CHECKAV^XUS(ACCESSVERIFYCODE)
		}
		if (SECID '= "") 
		{
			set DUZ = $$SECMATCH^XUESSO2(SECID)
		}
		set XUNOW=$$HTFM^XLFDT($H),DT=$P(XUNOW,".")
		do USER^XUS(DUZ)
		set checkValid = $$UVALID^XUS
		if (checkValid >  0) throw ##class(%Exception.General).%New("Login Error",5035,"VistALogin.cls","You do not have permission to access this system or your access verify code was incorrect.")		
		if (OPTIONS '= "") {
			for i=1:1:OPTIONS.Count() { 
				set option = OPTIONS.GetAt(i)
				set status = ..CheckOption(DUZ,option)
				set reason = $System.Status.GetErrorText(status)
				if '+status throw ##class(%Exception.General).%New("Login Error",5035,"VistALogin.cls",$P(reason, ": ",2))	
			}	
		}
		if (KEYS '= "") {
			for i=1:1:KEYS.Count() { 
				set key = KEYS.GetAt(i)
				set status = ..CheckKey(DUZ,key)
				set reason = $System.Status.GetErrorText(status)
				if '+status throw ##class(%Exception.General).%New("Login Error",5035,"VistALogin.cls",$P(reason, ": ",2))	
			}	
		}		
		set obj.DUZ = DUZ   
		quit obj
}

ClassMethod GetDivisionForInstitution(facilityIEN As %String) As %Status [ PublicList = U ]
{
        S loop="" 
        #;;S stationNumber = $$GET1^DIQ(4,facilityIEN,99,"I")
        S facilityNum = ""
        S division = ""
        for {
            S loop=$O(^DG(40.8,loop))
            Q:loop=""
            S facilityNum = $$GET1^DIQ(40.8,loop,.07,"I")
            if (facilityNum = facilityIEN) {
				set division = $$GET1^DIQ(40.8,loop,.001,"I")             
            }
        }
		quit division
}

ClassMethod CheckOption(DUZ As %String, OPT As %String) As %Status
{
    I '$D(DUZ) || ('$D(OPT)) Q $$$ERROR($$$GeneralError, "CheckOption method must be called with both a DUZ and the Option Name")
    S RESULT=$$ACCESS^XQCHK(DUZ,OPT)
    S REASON=$case(+RESULT, -1:"No such user in the NEW PERSON file (#200)", 
                           -2:"You are terminated or have no Access code. Please submit an ePAS or local site request for reactivation.",
                           -3:"Option ["_OPT_"] does not exist in the Option file(#19). Contact the application's Developer to correct this.",
                            0:"You do not possess the Option ["_OPT_"]. Request this option through your ADPAC or through ePAS to gain access.",
                            1:"You possess the Option ["_OPT_"] through your Primary Menu.",
                            2:"You possess the Option ["_OPT_"] through Common Options [XUCOMMAND].",
                            3:"You possess ["_OPT_"] as a Secondary Option.",
                            4:"Access to Option ["_OPT_"] granted through menu "_$P(RESULT,"^",4)_".",
                             :"Unknown error while checking account for access to Option ["_OPT_"].")
    S CODE=$P(RESULT,"^",3) I CODE'="" {
        S REASON=REASON_$case(CODE, "N":"Your VistA account has no Primary Menu. "_
                                        "Contact the site Account Manager in OIT to fix this.",
                                    "L":"The option is locked by key "_$P(RESULT,"^",4)_
                                        ". Request this key through your ADPAC or through ePAS to gain access.",
                                    "R":"The option has a Reverse Lock. You cannot use this option "_
                                        "while you possess the key "_$P(RESULT,"^",4)_". The key must be "_
                                        "removed from your VistA profile before you can use this application.",
                                       :"Unknown Reason")
    }
    
    I +RESULT<1!('RESULT) {
        Q $$$ERROR($$$GeneralError, REASON)
    }
    
    Q $$$OK
}

ClassMethod CheckKey(DUZ As %String, KEY As %String) As %Status
{
    I '$D(DUZ) || ('$D(KEY)) Q $$$ERROR($$$GeneralError, "CheckKey method must be called with both a DUZ and the Key Name")
    S RESULT=$$KCHK^XUSRB(KEY,DUZ)
    I +RESULT=0!('RESULT) {
        S REASON="2^9991^You do not possess the VistA Key ["_KEY_"]. "_
                 "Request this key through your ADPAC or through ePAS to gain access."
        Q REASON  ;$$$ERROR($$$GeneralError,REASON)
    }
    
    Q $$$OK
}

}
