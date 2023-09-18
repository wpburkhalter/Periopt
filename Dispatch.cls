/// SwitchLane's Periopt REST End Point dispatch class
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2023
/// Description: Methods to either pull or push data between VistA and the Perioptimization application
/// Change Log:
/// Notes: in the same urls for each method, the fqdn is the fully qualified domain name
/// of the IRIS server and the port for the IRIS servers webservices port.
Class REST.SwitchLane.Periopt.Dispatch Extends (%CSP.REST, EnsLib.REST.Service, %Persistent, Ens.BusinessService)
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/appointments/surgery/appt" Method="POST" Call="REST.SwitchLane.Periopt.Index:fileSurgery"/>
    <Route Url="/clinics" Method="GET" Call="REST.SwitchLane.Periopt.Index:getClinics"/>
    <Route Url="/appointment/:action/" Method="POST" Call="REST.SwitchLane.Periopt.Index:appointmentAction"/>
    <Route Url="/patientsearchfilter/:action/" Method="POST" Call="REST.SwitchLane.Periopt.PatientFilerList:patientPostSearch"/>
    <Route Url="/procedures/:search" Method="GET" Call="REST.SwitchLane.Periopt.ProcedureList:search"/>
    <Route Url="/patients/:search" Method="GET" Call="REST.SwitchLane.Periopt.PatientList:search"/>
    <Route Url="/patient/:DFN" Method="GET" Call="REST.SwitchLane.Periopt.PatientDemo:patientdemo"/>
    <Route Url="/providers/:search" Method="GET" Call="REST.SwitchLane.Periopt.Index:getProviders:search"/>
    <Route Url="/clinics/:clinic/:start/:end" Method="GET" Call="REST.SwitchLane.Periopt.Index:getAvailability"/>
    <Route Url="/fileman/lists" Method="GET" Call="REST.SwitchLane.Periopt.FileManLists:list"/>
    <Route Url="/consults/patient/:DFN" Method="GET" Call="REST.SwitchLane.Periopt.Index:getPatientConsults"/>
    <Route Url="/appointments/requests/:DFN" Method="GET" Call="REST.SwitchLane.Periopt.Index:getPatientApptRequest"/>
    <Route Url="/appointments/clinic/:clinicid/:startdttm/:enddttim" Method="GET" Call="REST.SwitchLane.Periopt.Index:getClinicAppts"/>
    <Route Url="/consults/details/:consultid" Method="GET" Call="REST.SwitchLane.Periopt.Index:getConsultDetails"/>
    <Route Url="/appointments/patient/:DFN/:SDATE/:EDATE" Method="GET" Call="REST.SwitchLane.Periopt.Index:getPatientAppointments"/>
    <Route Url="/patients/notes" Method="POST" Call="REST.SwitchLane.Periopt.Index:fileNotes"/>
    <Route Url="/consults/all" Method="GET" Call="REST.SwitchLane.Periopt.Index:getAllConsults"/>
    <Route Url="/cpt" Method="GET" Call="REST.SwitchLane.Periopt.ListCPTCodes:getCodes"/>
    <Route Url="/patientsfilter/:search" Method="GET" Call="REST.SwitchLane.Periopt.PatientFilerList:search"/>
    <Route Url="/surgery/cases" Method="GET" Call="REST.SwitchLane.Periopt.ListOfSurgeryCases:getSurgeryCases"/>
</Routes>
}

ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status [ PublicList = (U, secid, DT, X, Y, VAL, XUF, DUZ, DT, XUSER, XUSER, XQUR, XUNOW, pContinue) ]
{
    set %response.ContentType="application/json"
    set accessVerifyCode = %request.GetCgiEnv("HTTP_AVCODE")
    set currentNameSpace = $NAMESPACE
    set status = $$$OK
    set secId=0
    set url = $piece(pUrl,"/",*)
    s secId=%request.GetCgiEnv("HTTP_SECID")
    S appkey=%request.GetCgiEnv("HTTP_APPKEY")
    
    i $g(secId)'>0
        {
            throw ##class(%Exception.General).%New("Authentication Error",5035,"","SECID Key is Missing.")
        }
    
    if ((url = "clinics") ! (url = "SurgeryAppt") ! (url = "surgeryNote") ! (url = "cases") ! (url = "patient") ! (url = "_spec") ! (url = "appt") ! (url = "appointment") ! (url = "appointments") ! (url = "requests") ! (url = "clinic") ! (url = "details") ! (url = "notes") ! (url = "all") ! (url= "cpt")) 
    {
        set pContinue = 1
        ;Quit $$$OK
    }
    /*
    ELSE {
        throw ##class(%Exception.General).%New("Authentication Error",5035,"","The API Key is invalid.")
        q 200
    }
    */

    ;i $g(secId)="" throw ##class(%Exception.General).%New("Authentication Error",5035,"DateTest.cls","SECID Key is Missing.")

    set pContinue = 0   
    set obj = {}    
    set namespaceVal = %request.GetCgiEnv("HTTP_NAMESPACE")
    if (namespaceVal '= "" &(##class(%SYS.Namespace).Exists(namespaceVal)))
    {
        set $NAMESPACE = namespaceVal
    }
    set $NAMESPACE = currentNameSpace
    set cipherText = %request.GetCgiEnv("HTTP_APIKEY")
    set appName = %request.GetCgiEnv("HTTP_APPNAME")
    if (appName="") quit $$$ERROR(500,"missing parameter: appname")
    set secId = secId 
    set upn = ""
    // Decrypt header value and extract Sec ID, UPN, and Client Timestamp
    if (cipherText '= "") {
        set apiKey = ##class(REST.SwitchLane.Periopt.Utils.AESEncryption).UnEncrypt(cipherText, appName)
        ;set secId = $P(apiKey,",",1)
        set upn = $P(apiKey,",",2)
        set timestamp = $P(apiKey,",",3)
        if ((secId = "")!(upn = "")!(timestamp = "")) throw ##class(%Exception.General).%New("Authentication Error",5035,"DateTest.cls","API Key is invalid.")
        set srvrDateTime = $ZDT($ZDT($H,-3),1)
        set timeDiff = $system.SQL.Functions.DATEDIFF("mi",timestamp,srvrDateTime)
        if (timeDiff > 5)!(timeDiff < -5) {
            throw ##class(%Exception.General).%New("Authentication Error",5035,"DateTest.cls","API Key is expired.")
        }
    }
    set U = "^"
    if (secId '= "") {
        set DUZ = $$SECMATCH^XUESSO2(secId)
        set XUNOW=$$HTFM^XLFDT($H),DT=$P(XUNOW,".")
        do USER^XUS(DUZ)
        set checkValid = $$UVALID^XUS
        if (checkValid > 0) set obj.DUZ = 0
        else  set obj.DUZ = DUZ
    }
    if (upn '="") {
      set DUZcheck = $$UPNMATCH^XUESSO2($ZCVT(upn,"L"))
      if (DUZcheck = 0) set obj.DUZ = 0
    }
    if $data(%request.CgiEnvs("HTTP_OPTIONS")) {
        
        set options = %request.CgiEnvs("HTTP_OPTIONS")
        for index=1:1:$length(options,",") {
            set option = $piece(options,",",index)
            set status = ##class(REST.SwitchLane.Periopt.Common.VistALogin).CheckOption(DUZ,option)
            set reason = $System.Status.GetErrorText(status)
            if '+status throw ##class(%Exception.General).%New("Login Error",5035,"VistALogin.cls",$P(reason, ": ",2))
        }
    }

    if (obj.DUZ > 0) {
        set pContinue = 1
    } else {
        throw ##class(%Exception.General).%New("Authentication Error",5035,"Dispatch.cls","duz is not defined. You do not have permission to access this system or your access verify code was incorrect.")     
    }

    Quit status
}

}
