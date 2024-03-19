Const
     FolderGeneratedFiles='OUTPUTS';
     FolderAssembly='AssemblyData';
     FolderPCB='PCBData';
     FolderAltiumProj='AltiumProject'

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

Function MakeAssemblyPDF;
Begin
     // Beschreibung siehe "og0109 publish to pdf_scripting.pdf" in Pfad: "K:\ENTW\Software\Altium\Documentation\KomaxVorlagen\zAdmin_EntwicklungVorlagen\Dokumentation_Ablagestruktur\scripting"
     PreparePDF;
     AddStringParameter ('OutputMedium'        ,'1-1_Assembly_SCH_PDF');// Select an existing PDF Output Medium. If not found, first PDF Medium will be used.
     AddStringParameter ('OutputFilePath'      ,GetWorkspace.DM_FocusedProject.DM_GetOutputPath+'\'+FolderAssembly);// Override the Output File path setting in the Publish to PDF Settings dialog
     RunProcess('WorkspaceManager:Print');

     PreparePDF;
     AddStringParameter ('OutputMedium'        ,'1-2_Assembly_BOM_PDF');// Select an existing PDF Output Medium. If not found, first PDF Medium will be used.
     AddStringParameter ('OutputFilePath'      ,GetWorkspace.DM_FocusedProject.DM_GetOutputPath+'\'+FolderAssembly);// Override the Output File path setting in the Publish to PDF Settings dialog
     RunProcess('WorkspaceManager:Print');
	 ShowMessage('Please check the generated BOM...');    // Workaround for crash (with AD17.0.11) to update GUI

     PreparePDF;
     AddStringParameter ('OutputMedium'        ,'1-3_Assembly_AssyDraw_PDF');// Select an existing PDF Output Medium. If not found, first PDF Medium will be used.
     AddStringParameter ('OutputFilePath'      ,GetWorkspace.DM_FocusedProject.DM_GetOutputPath+'\'+FolderAssembly);// Override the Output File path setting in the Publish to PDF Settings dialog
     RunProcess('WorkspaceManager:Print');

     PreparePDF;
     AddStringParameter ('OutputMedium'        ,'1-4_Assembly_Instr_PDF');// Select an existing PDF Output Medium. If not found, first PDF Medium will be used.
     AddStringParameter ('OutputFilePath'      ,GetWorkspace.DM_FocusedProject.DM_GetOutputPath+'\'+FolderAssembly);// Override the Output File path setting in the Publish to PDF Settings dialog
     RunProcess('WorkspaceManager:Print');
End;

Function MakePcbPDF;
Begin
     // Beschreibung siehe "og0109 publish to pdf_scripting.pdf" in Pfad: "K:\ENTW\Software\Altium\Documentation\KomaxVorlagen\zAdmin_EntwicklungVorlagen\Dokumentation_Ablagestruktur\scripting"
     PreparePDF;
     AddStringParameter ('OutputMedium'        ,'2_PCB_PDF');// Select an existing PDF Output Medium. If not found, first PDF Medium will be used.
     AddStringParameter ('OutputFilePath'      ,GetWorkspace.DM_FocusedProject.DM_GetOutputPath+'\'+FolderPCB);// Override the Output File path setting in the Publish to PDF Settings dialog
     RunProcess('WorkspaceManager:Print');
     
     PreparePDF;
     AddStringParameter ('OutputMedium'        ,'3_PCB_Specifications_PDF');// Select an existing PDF Output Medium. If not found, first PDF Medium will be used.
     AddStringParameter ('OutputFilePath'      ,GetWorkspace.DM_FocusedProject.DM_GetOutputPath+'\'+FolderPCB);// Override the Output File path setting in the Publish to PDF Settings dialog
     RunProcess('WorkspaceManager:Print');
End;

Function MakeAssembly;
Begin
// Idee aus "XIA_Release_Manager.pas"
    ResetParameters;
    AddStringParameter ('Action'                 ,'Run');
    AddStringParameter ('OutputMedium'           ,'4_Assembly');// Select an existing PDF Output Medium. If not found, first PDF Medium will be used.
    AddStringParameter ('ObjectKind'             ,'OutputBatch');
    AddStringParameter ('OutputFilePath'         ,GetWorkspace.DM_FocusedProject.DM_GetOutputPath+'\'+FolderAssembly);// Override the Output File path setting in the Publish to PDF Settings dialog
    RunProcess('WorkspaceManager:GenerateReport');
End;

Function MakePCB;
Begin
// Idee aus "XIA_Release_Manager.pas"
    ResetParameters;
    AddStringParameter ('Action'                 ,'Run');
    AddStringParameter ('OutputMedium'           ,'5-1_PCB');// Select an existing PDF Output Medium. If not found, first PDF Medium will be used.
    AddStringParameter ('ObjectKind'             ,'OutputBatch');
    AddStringParameter ('OutputFilePath'         ,GetWorkspace.DM_FocusedProject.DM_GetOutputPath+'\'+FolderPCB);// Override the Output File path setting in the Publish to PDF Settings dialog
    RunProcess('WorkspaceManager:GenerateReport');

    ResetParameters;
    AddStringParameter ('Action'                 ,'Run');
    AddStringParameter ('OutputMedium'           ,'5-2_PCB_ASCII');// Select an existing PDF Output Medium. If not found, first PDF Medium will be used.
    AddStringParameter ('ObjectKind'             ,'OutputBatch');
    AddStringParameter ('OutputFilePath'         ,GetWorkspace.DM_FocusedProject.DM_GetOutputPath+'\'+FolderPCB);// Override the Output File path setting in the Publish to PDF Settings dialog
    RunProcess('WorkspaceManager:GenerateReport');
End;

Function Generate(Parameters : String);
// Diese Funktion wird vom Outjob aufgerufen.
var
    ProjPath : string;
    buttonResult : Integer;
Begin
    MakeAssemblyPDF;
    MakeAssembly;
    buttonResult := MessageDlg('Any changes in the PCB? Do you want to generate new PCB data?', mtConfirmation, mbYesNo, False);
    If buttonResult = mrYes Then
    Begin
       MakePcbPDF;
       MakePCB;
    End;

    // Get all Files to ZIP
    ProjPath := ExtractFilePath(GetWorkspace.DM_FocusedProject.DM_ProjectFullPath);
    RunApplication('"' + ProjPath + 'Tools\7ZIP_ASSEMBLY_PCB.bat" "' + GetWorkspace.DM_FocusedProject.DM_GetOutputPath + '" "' + FolderAssembly + '" "' + FolderPCB + '"');

    ResetParameters;
    AddStringParameter ('Action'                 ,'Run');
    AddStringParameter ('OutputMedium'           ,'0_Generate_All_Files');// Select an existing PDF Output Medium. If not found, first PDF Medium will be used.
    Sleep(5000);
    ShowMessage('All files generated in the folder ' + FolderGeneratedFiles);

    Result := '';
End;


