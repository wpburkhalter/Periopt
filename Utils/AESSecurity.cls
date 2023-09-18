/// SwitchLane's Periopt VistA Security Class
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Class definition for a security object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.Utils.AESSecurity Extends (%Persistent, %JSON.Adaptor) [ Owner = {_PUBLIC} ]
{

Index AppIndex On App [ IdKey ];

Property App As %String;

Property Key As %String(MAXLEN = 200, MINLEN = 1, TRUNCATE = 0);

Storage Default
{
<Data name="AESSecurityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Key</Value>
</Value>
</Data>
<DataLocation>^REST.SwitchLan9782.AESSecurityD</DataLocation>
<DefaultData>AESSecurityDefaultData</DefaultData>
<IdLocation>^REST.SwitchLan9782.AESSecurityD</IdLocation>
<IndexLocation>^REST.SwitchLan9782.AESSecurityI</IndexLocation>
<StreamLocation>^REST.SwitchLan9782.AESSecurityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
