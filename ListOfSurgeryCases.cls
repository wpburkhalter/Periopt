/// Perioptimization Class for Surgery Cases Object
/// Version 1.0
/// Author: Phil Burkhalter
/// Project: Perioptimization
/// Date: Sep 13, 2023
/// Description: Defines the class object for returning surgery cases
/// Change Log:
/// Notes: 
Class REST.SwitchLane.Periopt.ListOfSurgeryCases Extends (%JSON.Adaptor, %Persistent)
{

Parameter %JSONNULL As BOOLEAN = 1;

Property SurgeryCase As list Of REST.SwitchLane.Periopt.SurgeryCase;

// getSurgeryCases method collects the list of surgery cases between the dates requested.

/// url = base url/surgery/cases?start=xxxxxxxx&?end=yyyyyyyy  where xxxxxxxx and yyyyyyyy are the dates in yyyymmyy date format
ClassMethod getSurgeryCases() As %Status [ PublicList = (U, DUZ, SurgList, SurgError, X1) ]
{
    ;S START=3230701.0000,
    s END=3231031.2359

    s listOfCases=..%New()

    s START=$get(%request.Data("start",1))-1
    s END=$get(%request.Data("end",1))
    s START=$$HL7TFM^XLFDT(START),END=$$HL7TFM^XLFDT(END)
    F  S START=$O(^SRF("AC",START)) Q:START'>0!(START>END)  S X1=0 F  S X1=$O(^SRF("AC",START,X1)) Q:X1'>0  D
    .K SurgList,IEN,SurgError,surgeryCases
    .S IEN=X1_","
    .D GETS^DIQ(130,IEN,".001;.01;.04;.09","IE","SurgList","SurgError")
    .s surgeryCases = ##class(REST.SwitchLane.Periopt.SurgeryCase).%New()
    .s surgeryCases.CaseNumber = X1
    .s surgeryCases.PatientICN = $$GET1^DIQ(2,SurgList(130,IEN,.01,"I")_",",991.1,"I")
    .s surgeryCases.PatientName = SurgList(130,IEN,.01,"E")
    .s surgeryCases.SurgicalSpecialty = SurgList(130,IEN,.04,"E")
    .s surgeryCases.ScheduledDateOfOperation = SurgList(130,IEN,.09,"E")
    .;D surgeryCases.%JSONExport()
    .d listOfCases.SurgeryCase.Insert(surgeryCases)
    d listOfCases.%JSONExport()
    Quit 200
}

}
