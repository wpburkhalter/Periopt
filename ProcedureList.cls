/// Perioptimization Class Definition for the ProcedureList Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Class Definition for the ProcedureList Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.ProcedureList Extends (%JSON.Adaptor, %RegisteredObject)
{

ClassMethod search(search) As %Status
{
 Set limit = 0	
 If search'="xxxxxxxx"
   {
   ;If $Length(search)<2 Write "{}",! Quit $$$OK
   Set search=$Zconvert(search,"U")
   If search[" "
     {
     Set search1=$Piece(search," ",1)
     Set search2=$Piece(search," ",2)
     Set search3=$Piece(search," ",3)
     Set search4=$Piece(search," ",4)
     Set search5=$Piece(search," ",5)
     }
   Else
     {
     Set search1=search
     Set (search2,search3,search4,search5)=""
     }
   Set WORD=$Order(^ICD0("AD",31,search1),-1)
   For
     {
     Set WORD=$Order(^ICD0("AD",31,WORD)) Quit:WORD=""
     Quit:$Extract(WORD,1,$Length(search1))'=search1
     Set IEN1=0 For
       {
       Set IEN1=$Order(^ICD0("AD",31,WORD,IEN1))
       Quit:+IEN1=0
       Set DATE=$Order(^ICD0("AD",31,WORD,IEN1,""),-1)
       Set IEN2=$Order(^ICD0("AD",31,WORD,IEN1,DATE,0))
       Set CODE=$Piece(^ICD0(IEN1,0),"^",1)
       Set DESC=^ICD0(IEN1,68,IEN2,1)
       Set DESCU=$Zconvert(DESC,"U")
       If search2'="",DESCU'[search2 Continue
       If search3'="",DESCU'[search3 Continue
       If search4'="",DESCU'[search4 Continue
       If search5'="",DESCU'[search5 Continue
       Set limit=limit+1 Quit:limit>100
       Set ^||PLJA(CODE,"EXT")=DESC
       Set ^||PLJA(CODE,"INT")=IEN1
       }
     }
   Do ENCODE^XLFJSON("^||PLJA","^||PLJJ")
   Set outline=0 For
     {
     Set outline=$Order(^||PLJJ(outline)) Quit:+outline=0
     Write ^||PLJJ(outline)
     }
 Quit $$$OK
}
}

}
