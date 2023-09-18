/// A REST Service to allow VistA User Authentication at a specified site<br/>
/// Business logic class defined by OpenAPI in REST.SwitchLane.Periopt.Common.Login.spec<br/>
/// Updated Aug 25, 2023 13:44:32
Class REST.SwitchLane.Periopt.Common.Login.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 1;

/// This OpenAPI Spec
ClassMethod GetSpec() As %DynamicObject
{
    set mySpec = {}.%FromJSON(##class(%Dictionary.CompiledXData).%OpenId("REST.FES.Common.Login.spec||OpenAPI").Data.Read())
	set Host = $G(%request.CgiEnvs("HTTP_HOST"))
	set Instance = $P($G(%request.CgiEnvs("UNENCODED_URL")),"/",2)
	set Path = Host_"/"_Instance
	set mySpec.host = Path
	do mySpec.paths.%Remove("/_spec")
    return mySpec
}

/// (provide functional description here)<br/>
/// The method arguments hold values for:<br/>
///     appname<br/>
///     namespace<br/>
///     options<br/>
///     keys<br/>
///     body, Request body contents<br/>
ClassMethod Login(appname As %String, namespace As %String, options As %ListOfDataTypes(ELEMENTTYPE="%String"), keys As %ListOfDataTypes(ELEMENTTYPE="%String"), body As %Stream.Object) As %Stream.Object
{
 		Do ..%SetContentType("application/json")
		set status = $$$OK
		if (namespace '= "" &(##class(%SYS.Namespace).Exists(namespace)))
		{
			set $NAMESPACE = namespace
		}
		//Convert content from JSON to a dynamic object
		set reqObj = {}.%FromJSON(body)
		 
		set accessCode= reqObj.AccessCode
		set verifyCode= reqObj.VerifyCode
		set cipherText = reqObj.SecId
		set secId = ""
		if (cipherText '="" && (appname '= "")) set secId = ##class(REST.FES.Utils.AESEncryption).UnEncrypt(cipherText, appname)
		if (accessCode="" && (cipherText="")) throw ##class(%Exception.General).%New("Login Error",5035,"VistALogin.cls","missing parameter: access code.")
		if (verifyCode="" && (cipherText="")) throw ##class(%Exception.General).%New("Login Error",5035,"VistALogin.cls","missing parameter: verify code.")
		
		set rootObj = {}

		set avcodes = $select(((accessCode '="") && (verifyCode '= "")):accessCode_";"_verifyCode,(secId '=""):"",1:"")		
		set rootObj = ##class(REST.FES.Common.VistALogin).Login(avcodes,secId,$get(options),$get(keys))

		if (rootObj.DUZ > 0) 
		{
			set facilityIEN = $S($$DIV4^XUSER(.DIVS):$O(DIVS("")),1:$P($$SITE^VASITE($$NOW^XLFDT),$C(94),3)) ;; Get user's Facility IEN or the VistA's facility if none in NEW PERSON file
			set multipleDivisions = $P($G(^VA(200,rootObj.DUZ,2,0)),"^",4)			
			set:facilityIEN facilityName = $P(^DIC(4,facilityIEN,0),"^") ;; Get Facility Name from INSTITUTION file
			set division = ##class(REST.FES.Common.VistALogin).GetDivisionForInstitution(facilityIEN) 
			set rootObj.SiteCode = facilityIEN

			if (multipleDivisions > 1)
			{
				set SiteCode = 0
				for 
				{
					set SiteCode = $O(^VA(200,rootObj.DUZ,2,SiteCode)) 
					quit:('SiteCode)						
					set facilityToAdd = $P(^DIC(4,SiteCode,0),"^")
					set:(facilityName'[facilityToAdd) facilityName = facilityName_"^"_facilityToAdd
					set divisionToAdd = ##class(REST.FES.Common.VistALogin).GetDivisionForInstitution(SiteCode)
					set:(division'[divisionToAdd) division = division_","_divisionToAdd
				}				
			}
			set rootObj.Division = division 
			set rootObj.FacilityName = facilityName
		}
		
		quit rootObj
}

/// (provide functional description here)
ClassMethod GetWelcomeMessage() As %Stream.Object
{
    Do ..%SetStatusCode("200")
    Do ..%SetContentType("application/json")
    //Do ..%SetHeader(<name>,<value>)
	do INTRO^XUSRB(.MSG)
	set loop = ""
	set text = {}
	for {
		set loop = $order(MSG(loop))
		quit:(loop = "")
		set text.welcomeMessage = text.welcomeMessage_$CHAR(13)_$CHAR(10)_MSG(loop)
	}
	quit text
}

}
