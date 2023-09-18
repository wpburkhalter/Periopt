/// Perioptimization Class Definition for the PatientList Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Class Definition for the PatientList Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.PatientList Extends (%JSON.Adaptor, %RegisteredObject)
{

ClassMethod search(search) As %Status
{
 Set limit = 0
 s search=$$UP^XLFSTR(search)
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
   Set NAME=$Order(^DPT("B",search1),-1)
   For
     {
     Set NAME=$Order(^DPT("B",NAME)) Quit:NAME=""
     Set IEN=0 For
       {
       Set IEN=$Order(^DPT("B",NAME,IEN)) Quit:+IEN=0
       Quit:$Extract(NAME,1,$Length(search1))'=search1
       If search2'="",NAME'[search2 Continue
       Set limit=limit+1 Quit:limit>100
       s icn=$p(^DPT(IEN,"MPI"),"^",10)
       s patList(IEN)=NAME_"^"_icn
       }
     }
    
     s parray=[]
     
     s xx=0,cnt=0 f  s xx=$o(patList(xx)) q:xx'>0  d
     .s pobj={}
     .s pobj.dfn=xx
     .s pobj.name=$p(patList(xx),"^")
     .s pobj.icn=$p(patList(xx),"^",2)
     .d parray.%Push(pobj)
     .s cnt=cnt+1
     
     s parrarylen=0
     s piter=parray.%GetIterator()
     	while piter.%GetNext(){
     		s parraylen=$l(parrarylen)
     	}
     
     s pMainObj={}
     s pMainObj.NumberOfPatients=cnt
     s pMainObj.PatientList=parray
     
     w pMainObj.%ToJSON()

   }
 Quit $$$OK
}

}
