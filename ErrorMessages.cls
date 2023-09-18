Class REST.SwitchLane.Periopt.ErrorMessages Extends (%JSON.Adaptor, %Persistent)
{

Property ErrorCode As %String;

Property ExceptionName As %String(MAXLEN = 250);

Property ErrorReason As %String(MAXLEN = 250);

ClassMethod createErrorMsg(pErrCode As %String, pExceptionName As %String(MAXLEN=250), pErrorReason As %String(MAXLEN=250)) [ Language = objectscript ]
{
	s errMsg = ..%New()
	S errMsg.ErrorCode = pErrCode
	s errMsg.ExceptionName = pExceptionName
	s errMsg.ErrorReason = pErrorReason
	d errMsg.%JSONExport()
	q 0
}

}
