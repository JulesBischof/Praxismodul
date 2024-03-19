Function PredictOutputFileNames(Parameters : String) : String;
// Diese Funktion wird aufgerufen, wenn im Outjob die Einstellungen des
// Output-Mediums mit dem Script-File Aufgerufen werden.
Begin
    ShowMessage('Do not change any settings');  //
    Result := '';                       // Rückgabe-Wert
End;

Function Configure(Parameters : String) : String;
// Diese Funktion wird aufgerufen, wenn im Outjob auf dem Script
// mit dem Kontext-Menü (rechte Maus-Taste) auf Configure geclickt wird.
Begin
    ShowMessage('Nothing to configure');  //
    Result := '';                       // Rückgabe-Wert
End;

Function PreparePDF;
Begin
    ResetParameters;
    AddStringParameter ('Action'              ,'PublishToPDF');
    AddIntegerParameter('PublishMethod'       ,0);//Publish selected Output Jobs in a single PDF file
    AddStringParameter ('ObjectKind'          ,'OutputBatch');
    //AddStringParameter ('SelectedName1'     ,'Assembly Drawings');  //when ObjectKind = OutputSelected
    //AddStringParameter ('SelectedName2'     ,'Schematic Prints');
    AddStringParameter ('DisableDialog'       ,'True');

    AddStringParameter ('OpenOutput'           ,'False');
    AddIntegerParameter('ZoomLevel'            ,50);
    AddStringParameter ('FitSCHPrintSizeToDoc' ,'True');
    AddStringParameter ('FitPCBPrintSizeToDoc' ,'True');
    AddStringParameter ('GenerateNetsInfo'     ,'True');
    AddStringParameter ('MarkPins'             ,'True');
    AddStringParameter ('MarkNetLabels'        ,'True');
    AddStringParameter ('MarkPorts'            ,'True');
End;

Function Make3D;
Begin
// Idee aus "XIA_Release_Manager.pas"
    ResetParameters;
    AddStringParameter ('Action'                 ,'Run');
    AddStringParameter ('OutputMedium'           ,'6_3D');// Select an existing PDF Output Medium. If not found, first PDF Medium will be used.
    AddStringParameter ('ObjectKind'             ,'OutputBatch');
    RunProcess('WorkspaceManager:GenerateReport');

    PreparePDF;
    AddStringParameter ('OutputMedium'        ,'6_3D_PDF');// Select an existing PDF Output Medium. If not found, first PDF Medium will be used.
    RunProcess('WorkspaceManager:Print');
End;

Function Generate(Parameters : String);
// Diese Funktion wird vom Outjob aufgerufen.
Const
     FolderGeneratedFiles='OUTPUTS';
     FolderAssembly='AssemblyData';
     FolderPCB='PCBData';
     FolderAltiumProj='AltiumProject'
var
    ProjPath : string;
    ProjIdx : string;
    ParamNum : Integer;
    Parameter : IParameter;
Begin
    ProjPath := ExtractFilePath(GetWorkspace.DM_FocusedProject.DM_ProjectFullPath);

    Make3D;

    // Get the project parameter "KPP_Idx"
    ProjIdx := 'i';
    for ParamNum := 0 to GetWorkspace.DM_FocusedProject.DM_ParameterCount - 1 do
    begin
        Parameter := GetWorkspace.DM_FocusedProject.DM_Parameters(ParamNum);
        if (Parameter.DM_Name = 'KPP_Idx') then
        begin
             ProjIdx := Parameter.DM_Value;
        end;
    end;

    RunApplication(ProjPath + 'Tools\7ZIP_PROJ_ARCHIVE.bat' + ' "'
                            + GetWorkspace.DM_FocusedProject.DM_GetOutputPath + '" "'
                            + FolderAltiumProj + '" "'
                            + Copy(GetWorkspace.DM_FocusedProject.DM_ProjectFileName,0,Length(GetWorkspace.DM_FocusedProject.DM_ProjectFileName)-7)
                            + '_project_altium_' + ProjIdx + '"');

    Sleep(5000);
    Result := '';
End;




