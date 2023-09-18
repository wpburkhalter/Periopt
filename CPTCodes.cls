/// Perioptimization Class Definition for the CPT Code Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Aug 31, 2022
/// Description: Class Definition for the CPT Code Object
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.CPTCodes Extends (%JSON.Adaptor, %Persistent)
{

Parameter %JSONNULL As BOOLEAN = 1;

Property CPTCode As %String;

Property CPTCodeText As %String(MAXLEN = 200);

}
