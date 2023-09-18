/// Perioptimization Class Definition for the Consults Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Aug 23, 2023
/// Description: Class to get all open and pending consults at a site
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.GetAllConsultsAndDetails Extends (%Persistent, %JSON.Adaptor)
{

ClassMethod getAllConsultsAndDetails() As %Status
{
        w !,"NOW in get all consults and details"
      
        S (STATUS,XX)=0 F  S STATUS=$O(^GMR(123,"D",STATUS)) Q:STATUS'>0  f  s XX=$O(^GMR(123,"D",STATUS,XX)) Q:XX'>0  d
        .W !,STATUS,"  ",XX
        .Q:STATUS'=5!(STATUS'=6)
        .W !,$G(^GMR(123,XX,0))
        
         q 200
}

Storage Default
{
<Data name="GetAllConsultsAndDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^REST.Switc72E7.GetAllConsuEEB5D</DataLocation>
<DefaultData>GetAllConsultsAndDetailsDefaultData</DefaultData>
<IdLocation>^REST.Switc72E7.GetAllConsuEEB5D</IdLocation>
<IndexLocation>^REST.Switc72E7.GetAllConsuEEB5I</IndexLocation>
<StreamLocation>^REST.Switc72E7.GetAllConsuEEB5S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
