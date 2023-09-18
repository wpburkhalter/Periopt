/// Perioptimization VistA FileMan utility
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 1, 2022
/// Description: Class with FileMan utilities
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.FileManLists Extends %RegisteredObject
{

ClassMethod list() As %Status
{
 // JsonRequest        - JQ - ^||JQ
 // ArrayRequest       - AQ - ^||AQ
 // ArrayResults       - AR - ^||AR
 // JsonResults        - JR - ^||JR
 // File/Field Counter - FFC
 // File/Field Value   - FFV
 // File               - FILE
 // Field              - FIELD
 // FileMan Index      - INDEX
 Set ^||JQ=..ListSet()
 Do DECODE^XLFJSON("^||JQ","^||AQ")
 Merge AQ=^||AQ
 For FFC=1:1:$Order(AQ(""),-1)
   {
   Set FFV=AQ(FFC)
   Set FILE=$Translate($Piece(FFV,"F",2),"P",".")
   Set FIELD=$Translate($Piece(FFV,"F",3),"P",".")

   If $Piece(^DD(FILE,FIELD,0),"^",2)["S"
     {
     Do ..SetOfCodes(FFV, FILE, FIELD, .AR)
     }

   If $Piece(^DD(FILE,FIELD,0),"^",2)["D",$Data(AQ(FFC,"START")),$Data(AQ(FFC,"END"))
     {
	 Set START=AQ(FFC,"START")
	 Set END=AQ(FFC,"END")
     Do ..DateList(FFV, START, END, .AR)
	 }

   If $Piece(^DD(FILE,FIELD,0),"^",2)["P",$Data(AQ(FFC,"INDEX"))
     {
	 Set INDEX=AQ(FFC,"INDEX")
	 Do ..PointerList(FFV, FILE, FIELD, INDEX, .AR)
     }
   }
 Merge ^||AR=AR
 Do ENCODE^XLFJSON("^||AR","^||JR")
 Merge JR=^||JR
 Set x=0 For { Set x=$Order(JR(x)) Quit:+x=0  Write JR(x) }
 Quit $$$OK
}

ClassMethod SetOfCodes(FFV, FILE, FIELD, AR)
{
 // Get the Set Of Codes
 Set SelectionSet=$Piece(^DD(FILE,FIELD,0),"^",3)
 For SelectionCount=1:1:$Length(SelectionSet,";")
   {
   Set Selection=$Piece(SelectionSet,";",SelectionCount)
   Continue:Selection=""
   Set AR(FFV,""""_$Piece(Selection,":",2),"INT")=$Piece(Selection,":",1)
   Set AR(FFV,""""_$Piece(Selection,":",2),"EXT")=$Piece(Selection,":",2)
   }
 Quit $$$OK
}

ClassMethod DateList(FFV, START, END, AR) As %Status
{
 // Create the Date List
 For cnt=($H-START):1:($H+END)
   {
   Set AR(FFV,""""_$$HTFM^XLFDT(cnt),"INT")=$$HTFM^XLFDT(cnt)
   Set AR(FFV,""""_$$HTFM^XLFDT(cnt),"EXT")=$$HTE^XLFDT(cnt)
   }
 Quit $$$OK
}

ClassMethod PointerList(FFV, FILE, FIELD, INDEX, AR) As %Status
{
 // Create the Pointer List
 Set GLOBALROOT=$Piece(^DD(FILE,FIELD,0),"^",3)
 Set NAME=""
 For
   {
   Set FGI="^"_GLOBALROOT_""""_INDEX_""","_""""_NAME_""")"
   Set NAME=$Order(@FGI) Quit:NAME=""
   Set IEN=0 For
     {
     Set FGIEN="^"_GLOBALROOT_""""_INDEX_""","_""""_NAME_""","_IEN_")"
     Set IEN=$Order(@FGIEN) Quit:+IEN=0
     Set AR(FFV,""""_NAME,"INT")=IEN
     Set AR(FFV,""""_NAME,"EXT")=NAME
     }
   }
 Quit $$$OK
}

ClassMethod ListSet() As %String
{
 Set strval=""
 Set strval=strval_"["
 Set strval=strval_"""F130F638"","
 Set strval=strval_"""F130FP013"","
 Set strval=strval_"""F130FP011"","
 Set strval=strval_"""F130FP03"","
 Set strval=strval_"""F130FP035"","
 Set strval=strval_"""F130F661"","
 Set strval=strval_"""F130F1P01"","
 Set strval=strval_"""F130F1P035"","
 Set strval=strval_"""F130FP09"":{""START"":""10"",""END"":""10""},"
 Set strval=strval_"""F130FP04"":{""INDEX"":""B1""},"
 Set strval=strval_"""F130FP43"":{""INDEX"":""B""}"
 Set strval=strval_"]"
 Quit strval
}

}
