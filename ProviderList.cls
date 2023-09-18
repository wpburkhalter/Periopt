/// Perioptimization Class Definition for the ProviderList Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Class Definition for the ProviderList Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.ProviderList Extends (%JSON.Adaptor, %Persistent)
{

Parameter %JSONNULL As BOOLEAN = 1;

Property ProviderName As %String;

Property Secid As %String;

Property Duz As %String;

Property Npi As %String;

Property Specialty As %String;

Property Phone As %String;

Property Email As %String(MAXLEN = 150);

Property Role As %String(MAXLEN = 250);

Property Qualification As %String;

Property DEANumber As %String;

ClassMethod search(search) As %Status
{
	w !,"in provider list"
	q 200
 Set limit = 0
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
       Set limit=limit+1 Quit:limit>100
       q:'$d(^XUSEC("PROVIDER",IEN))
       s provList(IEN)=NAME
       }
     }
     
     ;s provider=##class(REST.SwitchLane.Periopt.Provider).%New()
     
     
     
     
     
    ;s provider.Provider = $g(results)

     
     /*s parray=[]
     
     s xx=0,cnt=0 f  s xx=$o(provList(xx)) q:xx'>0  d
     .s pobj={}
     .s pobj.empid=xx
     .s pobj.name=$p(provList(xx),"^")
     .d parray.%Push(pobj)
     .s cnt=cnt+1
     
     s parrarylen=0
     s piter=parray.%GetIterator()
     	while piter.%GetNext(){
     		s parraylen=$l(parrarylen)
     	}
     
     s pMainObj={}
     s pMainObj.NumberOfProviders=cnt
     s pMainObj.ProviderList=parray
     
     w pMainObj.%ToJSON()
	 */     
    
   }
 Quit $$$OK
}

}
