/// SwitchLane's Periopt Security Class
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: decrypts a string based on a key
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.Utils.AESEncryption Extends %RegisteredObject
{

ClassMethod UnEncrypt(cipherText, appName) As %String
{
        set IV = $Extract(cipherText,0,24)
        set cText = $Extract(cipherText,25,9999)
        set key = {}
        if (##class(REST.SwitchLane.Periopt.Utils.AESSecurity).%ExistsId(appName))
        {
            set obj = ##class(REST.SwitchLane.Periopt.Utils.AESSecurity).%OpenId(appName)
            set key = obj.Key
        }
        else
        {
            quit $$$ERROR(500,"No decrypt key found.")
        }
        Set key = $SYSTEM.Encryption.Base64Decode(key)
        Set IV = $SYSTEM.Encryption.Base64Decode(IV)
        Set cText = $SYSTEM.Encryption.Base64Decode(cText)
        Set apikey = $SYSTEM.Encryption.AESCBCDecrypt(cText, key, IV)
        quit apikey
}

}
