function varargout = Anon(varargin)
% ANON M-file for Anon.fig
%      ANON, by itself, creates a new ANON or raises the existing
%      singleton*.
%
%      H = ANON returns the handle to a new ANON or the handle to
%      the existing singleton*.
%
%      ANON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANON.M with the given input arguments.
%
%      ANON('Property','Value',...) creates a new ANON or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Anon_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Anon_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Anon

% Last Modified by GUIDE v2.5 15-Jun-2016 08:36:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Anon_OpeningFcn, ...
                   'gui_OutputFcn',  @Anon_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before Anon is made visible.
function Anon_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Anon (see VARARGIN)

% Choose default command line output for Anon
handles.output = hObject;

%Declaring data
handles.patInfo.ID = get(handles.ID,'String');
handles.patInfo.FamilyName = get(handles.FamilyName,'String');
handles.patInfo.GivenName = get(handles.GivenName,'String');
handles.pathData.importPath = pwd;
handles.pathData.exportPath = [pwd,filesep,'AnonFiles'];
set(handles.currentImportPath,'String',handles.pathData.importPath )
set(handles.currentExportPath,'String',handles.pathData.exportPath )

% Update handles structure
guidata(hObject, handles);

%initialize_gui(hObject, handles, false);

% UIWAIT makes Anon wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Anon_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function ID_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function FamilyName_CreateFcn(hObject, eventdata, handles)

handles.patInfo.GivenName  = (get(hObject, 'String'));
guidata(hObject,handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function GivenName_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in makeAnon.
function makeAnon_Callback(hObject, eventdata, handles)

checkSOPwritetoRTstruct;
status = replaceUIDfunction(handles.patInfo,handles.pathData,handles);
set(handles.currentStatus,'String',status)

guidata(hObject,handles)

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)

close all;

% --- Executes on button press in changeExpPath.
function changeExpPath_Callback(hObject, eventdata, handles)

handles.pathData.exportPath = uigetdir(pwd,'Select Export Path (create a new if needed).');
set(handles.currentExportPath,'String',handles.pathData.exportPath);
guidata(hObject,handles)

% --- Executes on button press in changeImpPath.
function changeImpPath_Callback(hObject, eventdata, handles)
handles.pathData.importPath = uigetdir(pwd,'Select Import Path');
handles.pathData.exportPath = [handles.pathData.importPath,filesep,'AnonFiles'];
set(handles.currentImportPath,'String',handles.pathData.importPath);
set(handles.currentExportPath,'String',handles.pathData.exportPath);
guidata(hObject,handles)

function ID_Callback(hObject, eventdata, handles)

handles.patInfo.ID = (get(hObject, 'String'));
guidata(hObject,handles)

function GivenName_Callback(hObject, eventdata, handles)

handles.patInfo.GivenName = (get(hObject, 'String'));
guidata(hObject,handles)


function FamilyName_Callback(hObject, eventdata, handles)

handles.patInfo.FamilyName = (get(hObject, 'String'));
guidata(hObject,handles)


% --- Executes on button press in openExportFolder.
function openExportFolder_Callback(hObject, eventdata, handles)

directory = [handles.pathData.exportPath,filesep];

% Open the Explorer window with the Folders tree visible and
% with this directory as the root
if ispc
    if isdir(directory)
        command = ['explorer.exe /e,/root,' directory];
        [~,b] = dos(command);
        if ~isempty(b)
            error('Error starting Windows Explorer: %s', b);
        end
    else
        answer = questdlg('The export path does not exist. Do you want to open the Import path instead?','Path not found','Yes','No','Yes');
        if strcmpi(answer,'Yes')
            directory = handles.pathData.importPath;
            command = ['explorer.exe /e,/root,' directory];
            [~,b] = dos(command);
            if ~isempty(b)
                error('Error starting Windows Explorer: %s', b);
            end
        end
    end
elseif ismac
    if isdir(directory)
        command = ['open ' strrep(directory,' ','\ ')];
        [~,b] = dos(command);
        if ~isempty(b)
            warndlg('Error starting Finder: %s', b);
        end
    else
        answer = questdlg('The export path does not exist. Do you want to open the Import path instead?','Path not found','Yes','No','Yes');
        if strcmpi(answer,'Yes')
            directory = [handles.pathData.importPath,filesep];
            command = ['open ' strrep(directory,' ','\ ')];
            [~,b] = dos(command);
            if ~isempty(b)
                warndlg('Error starting Finder: %s', b);
            end
        end
    end
end

function checkSOPwritetoRTstruct
fid = fopen([matlabroot,filesep,'toolbox',filesep,'images',filesep,'iptformats',filesep,'private',filesep,'dicom_prep_SOPCommon.m']);

k = 1;
while ~feof(fid)
    
    curr = fscanf(fid,'%c');
    
end
fclose(fid);
checkPos = strfind(curr,'metadata.(dicom_name_lookup(''0008'', ''0018''');
if strcmpi(curr(checkPos(1)-1),'%')
else
    answer = questdlg('Your system cannot currently write RT-struct files. Would you like to correct this? (This is STRONGLY recommended!)','Incorrect Settings','Yes','No','Yes');
    if strcmpi(answer,'Yes')
        fid = fopen([matlabroot,'',filesep,'toolbox',filesep,'images',filesep,'iptformats',filesep,'private',filesep,'dicom_prep_SOPCommon.m'],'w');
        curr = [curr(1:checkPos-1),'%',curr(checkPos:end)];
        fprintf(fid,'%c',curr);
        fclose(fid);
    elseif strcmpi(answer,'No')
        errordlg('Cannot anonymize RT-struct correctly...')
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function status = replaceUIDfunction(patInfo,pathData,handles)
%Replace dicomuid
%place this file with the dcm files that should have their uids changed:
%
%NOTE!! FOR THIS TO WORK YOU HAVE TO DO THE FOLLOWING:
%1. Change the MATLAB working directory to $MATLABROOT\toolbox\images\iptformats\private, where $MATLABROOT is the MATLAB root directory.
%2. At the MATLAB command line, enter the following:
%edit dicom_prep_SOPCommon
%3. Comment out the following line:
%metadata.(dicom_name_lookup('0008', '0018')) = dicomuid;

%Name for new folder and patient specific data to be entered
%newFolderName = pathData.exportPath;%= '\newfiles';
patientNewID = patInfo.ID;%= '99TMH_Projekt';
patientNewFamilyName = patInfo.FamilyName;%'Hjerne';
PatientNewGivenName = patInfo.GivenName;%'Projekt';
%Selects the birthdate of the patient to be one year ago.
PatientNewBirthDate = datestr(now-365.24,'yyyymmdd');

here = [pathData.importPath,filesep];
writefolder = pathData.exportPath;
%Creates new dir.
mkdir (pathData.exportPath);

d = dir(here);
clear I;
% Start Loop for duplications Only sets the number of loops if the
% duplicate is active. 
useDupl = get(handles.checkboxDupli,'Value'); 
if useDupl
    numLoops = str2double(get(handles.editDupl,'String'));
else
    numLoops = 1; 
end


for Xi = 1:numLoops

%Correct output folder name in case of duplication activated.
if useDupl 
writefolder = [pathData.exportPath,num2str(Xi,'%0.2d'),filesep];

patInfo.ID = [patInfo.ID,'_',num2str(Xi,'%0.2d')]; 
patInfo.FamilyName = [patInfo.FamilyName,'_',num2str(Xi,'%0.2d')]; 
patInfo.GivenName = [patInfo.GivenName,'_',num2str(Xi,'%0.2d')]; 

else
writefolder = [pathData.exportPath,filesep];
end

%Creates new dir.
mkdir (writefolder);
%Sets UIDs that cannot be generated on the fly:
newStudyInstanceUID = dicomuid;
newSeriesInstanceUID = dicomuid;
doseuid = dicomuid;
newFrameOfReferenceUID = dicomuid;
newStructSOPInstanceUID = dicomuid;
newCTSOPInstanceUID = dicomuid;
newDoseReferenceUID = dicomuid;
newPlanSOPInstanceUID = dicomuid;
newDoseSOPInstanceUID = dicomuid;

% Added by Christian Gustafsson
newMRStudyInstanceUID = dicomuid;
% newMRSOPInstanceUID = dicomuid; % Has to be unique for every file
newMRFrameOfReferenceUID = dicomuid; 

newMRSeriesT1InstanceUID = dicomuid;
newMRSeriesT1FatSatInstanceUID = dicomuid;
newMRSeriesT1GDInstanceUID = dicomuid;
newMRSeriesT1FLAIRInstanceUID = dicomuid;

newMRSeriesT2InstanceUID = dicomuid;

%Sets the title of the waiting window if the user is using duplication mode
if useDupl
h = waitbar(0,['Please wait, running' num2str(Xi),'/', num2str(numLoops),'...']);    
else
h = waitbar(0,'Please wait...');
end
steps = length(d);
firstTrigger = 1;

finalCutPos = length(newCTSOPInstanceUID)- 6;

warningTag = 0;
for i = 1:length(d)
    
    if isdir([here,d(i).name])
        
    else
        clear I
       
        if isdicom([here,d(i).name])
            I = dicominfo([here,d(i).name]);
            %change the name of the patient and id

        %change tags for study dates
        I.InstanceCreationDate = '19000101'; 
        I.StudyDate = I.InstanceCreationDate;
        I.SeriesDate = I.InstanceCreationDate;
        I.ContentDate = I.InstanceCreationDate;
        
        I.InstanceCreationTime = '010101.010101'; 
        I.StudyTime = I.InstanceCreationTime; 
        I.SeriesTime = I.InstanceCreationTime;
        I.ContentTime = I.InstanceCreationTime;
        
        %change tags for AccessionNumber
        I.AccessionNumber = '9999999'; 
        
        %change tags for hospital, modality and protocol
        I.InstitutionName = 'Hospital';  
        I.StationName = 'Station Name';
        I.InstitutionAddress = 'Hospital'; 
        I.InstitutionalDepartmentName = 'Hospital'; 
        I.ClinicalTrialSponsorName = '';
        I.ClinicalTrialProtocolID = ''; 
        I.DeviceSerialNumber = '';
        I.ProtocolName =''; 
        I.ImageComments='';
        I.RequestAttributesSequence='';
        I.ContentSequence=''; 
        % I.StudyDescription='';
        % I.SeriesDescription=''; 
        I.OperatorName = ''; 
        I.DerivationDescription = ''; 
        
        %change tags for physicians
        I.ReferringPhysicianName.FamilyName='';
        I.ReferringPhysicianName.GivenName='';
        I.PhysicianOfRecord.GivenName='';
        I.PhysicianOfRecord.FamilyName='';
        I.PerformingPhysicianName='';
        I.ReferringPhysicianTelephoneNumber='';
        I.PhysicianReadingStudy='';
        I.AdmittingDiagnosesDescription=''; 

        % patient data
        I.PatientID = patientNewID;
        I.PatientName.FamilyName = patientNewFamilyName;
        I.PatientName.GivenName = PatientNewGivenName;
        I.PatientName.MiddleName = '';
        I.PatientName.NamePrefix='';
        I.PatientBirthDate = PatientNewBirthDate;
        I.PatientBirthTime = '';
        I.PatientAddress = '';
        
        I.PatientSex='';
        I.OtherPatientID='';
        I.OtherPatientName='';
        I.PatientAge='';
        I.PatientSize='';
        I.PatientWeight='';
        I.MedicalRecordLocator='';
        I.EthnicGroup='';
        I.Occupation='';
        I.AdditionalPatientHistory='';
        I.PatientComments='';
        
            
            if strcmpi(d(i).name(1:2),'RD')
                %Checks the version of matlab. If version is >= 2011b
                %matlab supports writing of multiframe images to dicom
                %otherwhise this function skips the RD-file.
                if strcmpi(version('-release'),'2011b') || strcmpi(version('-release'),'2012a') || strcmpi(version('-release'),'2013b')  || strcmpi(version('-release'),'2014a') || strcmpi(version('-release'),'2014b') || strcmpi(version('-release'),'2015a') || strcmpi(version('-release'),'2015b') || strcmpi(version('-release'),'2016a') || strcmpi(version('-release'),'2016b')
                    %This data below might be incorrect... Sad panda.
                    I.StudyInstanceUID = newStudyInstanceUID;
                    I.SOPInstanceUID = newDoseReferenceUID;
                    I.MediaStorageSOPInstanceUID = I.SOPInstanceUID;
                    I.ReferencedRTPlanSequence.Item_1.ReferencedSOPInstanceUID = newPlanSOPInstanceUID;
                    I.FrameOfReferenceUID = newFrameOfReferenceUID;
                    I.SeriesInstanceUID = dicomuid;
                else
                    disp('Warning you matlab version does not support writing of multiframe images! HerpaDerp')
                    warningTag = warningTag + 1;
                    continue
                end
                
            elseif strcmpi(d(i).name(1:2),'CT') || strcmpi(I.Modality,'CT')
                %write the new SOPInstanceUID and MediaStorageSOPInstanceUID;
                if firstTrigger == 1
                    firstTrigger = i;
                end
                storedSOPInstanceUID{i-(firstTrigger-1)} = I.SOPInstanceUID;
                
                I.SOPInstanceUID = newCTSOPInstanceUID;
                I.MediaStorageSOPInstanceUID = I.SOPInstanceUID;
                %write the new StudyInstanceUID
                I.StudyInstanceUID = newStudyInstanceUID;
                %write the new SeriesInstanceUID
                I.SeriesInstanceUID = newSeriesInstanceUID;
                
                %Creates the following SOPInstanceUID for the CTdata
                numForSOPInstanceUIDcalc = str2double(newCTSOPInstanceUID(finalCutPos:end))+1;
                newCTSOPInstanceUID(finalCutPos:end) = sprintf('%07d',(numForSOPInstanceUIDcalc));
                CheckSop{i-(firstTrigger-1),1} = I.SOPInstanceUID;
                I.FrameOfReferenceUID = newFrameOfReferenceUID;
                
                
               % Addon by Christian 
            elseif strcmpi(d(i).name(1:2),'MR')    
                %write the new UID tags for all MR images
                I.StudyInstanceUID = newMRStudyInstanceUID;
                    
                %Generate the unique ID for every file
                I.SOPInstanceUID = dicomuid;
                I.MediaStorageSOPInstanceUID = I.SOPInstanceUID;
                            
                % OK to remove and replace
                I.FrameOfReferenceUID = newMRFrameOfReferenceUID;
                
               %  If I.SeriesDescription contain the keyword it genereates
               %  a vector. It will then not be empty and the function
               %  isempty will return a 0, as false. Ordering of the
               %  conditions is important. 
                
               % IF T1 serie with no GD contrast and no fat suppression and
               
                if isempty(strfind(I.SeriesDescription, 't1')) == 0 && isempty(strfind(I.SeriesDescription, 'GD')) == 1 && isempty(strfind(I.SeriesDescription, 'fat'))== 1
                      I.SeriesInstanceUID = newMRSeriesT1InstanceUID; 
                 
                      % IF T1 series with GD contrast and no fat
                      % suppression
                       elseif isempty(strfind(I.SeriesDescription, 't1')) == 0 && isempty(strfind(I.SeriesDescription, 'GD')) == 0 && isempty(strfind(I.SeriesDescription, 'fat')) == 1 
                      I.SeriesInstanceUID = newMRSeriesT1GDInstanceUID; 
                      
                      % If T1 series with fat supression, independent of
                      % GD. 
                       elseif isempty(strfind(I.SeriesDescription, 't1')) == 0 && isempty(strfind(I.SeriesDescription, 'fat')) == 0
                      I.SeriesInstanceUID = newMRSeriesT1FatSatInstanceUID; 
                       
                      % IF T2 series. 
                       elseif isempty(strfind(I.SeriesDescription, 't2')) == 0 || isempty(strfind(I.SeriesDescription, 'T2')) == 0 
                      I.SeriesInstanceUID = newMRSeriesT2InstanceUID; 
                      
                else disp('Warning! Your MRI series type can not be correctly determined. They will have their old SeriesUID now!  HerpaDerp')
                end
                
            
            elseif strcmpi(d(i).name(1:2),'RS')
                
                % more anon stuff
                I.RTPlanName = '';
                I.ReviewerName = 'KalleAnka';
                I.ReviewerDate = '1901-01-01';
                I.ReviewerTime = '010101.010101';
                
                %write the new SOPInstanceUID and MediaStorageSOPInstanceUID;
                I.SOPInstanceUID = newStructSOPInstanceUID;
                I.MediaStorageSOPInstanceUID = newStructSOPInstanceUID;
                %write the new StudyInstanceUID
                I.StudyInstanceUID = newStudyInstanceUID;
                %write the new SeriesInstanceUID
                I.SeriesInstanceUID = dicomuid;
                %write the new DoseReferenceUID
                if isfield(I,'ReferencedFrameOfReferenceSequence')
                    for xx = 1:length(fieldnames(I.ReferencedFrameOfReferenceSequence))
                        FieldName = ['Item_' num2str(xx)];
                        I.ReferencedFrameOfReferenceSequence.(FieldName).FrameOfReferenceUID = newFrameOfReferenceUID;
                        I.ReferencedFrameOfReferenceSequence.(FieldName).RTReferencedStudySequence.Item_1.RTReferencedSeriesSequence.Item_1.SeriesInstanceUID = newSeriesInstanceUID;
                        I.ReferencedFrameOfReferenceSequence.(FieldName).RTReferencedStudySequence.Item_1.ReferencedSOPInstanceUID = newStudyInstanceUID;
                        for yy = 1:length(fieldnames(I.ReferencedFrameOfReferenceSequence.(FieldName).RTReferencedStudySequence.Item_1.RTReferencedSeriesSequence.Item_1.ContourImageSequence))
                            CTNum = ['Item_' num2str(yy)];
                            if strcmpi(storedSOPInstanceUID{yy},I.ReferencedFrameOfReferenceSequence.(FieldName).RTReferencedStudySequence.Item_1.RTReferencedSeriesSequence.Item_1.ContourImageSequence.(CTNum).ReferencedSOPInstanceUID)
                            else
                                disp('Zero??')
                                disp(yy)
                            end
                            I.ReferencedFrameOfReferenceSequence.(FieldName).RTReferencedStudySequence.Item_1.RTReferencedSeriesSequence.Item_1.ContourImageSequence.(CTNum).ReferencedSOPInstanceUID = CheckSop{yy,1};
                            CheckSop{yy,2} = I.ReferencedFrameOfReferenceSequence.(FieldName).RTReferencedStudySequence.Item_1.RTReferencedSeriesSequence.Item_1.ContourImageSequence.(CTNum).ReferencedSOPInstanceUID;
                        end
                    end
                end
                if isfield(I,'StructureSetROISequence')
                    for zz = 1:length(fieldnames(I.StructureSetROISequence))
                        ROINum = ['Item_' num2str(zz)];
                        I.StructureSetROISequence.(ROINum).ReferencedFrameOfReferenceUID = newFrameOfReferenceUID;
                    end
                end
                if isfield(I,'ROIContourSequence')
                    for aa = 1:length(fieldnames(I.ROIContourSequence))
                        %Selects the ROI number
                        countNum = ['Item_' num2str(aa)];
                        
                        if isfield(I.ROIContourSequence.(countNum),'ContourSequence') 
                            for bb = 1:length(fieldnames(I.ROIContourSequence.(countNum).ContourSequence))
                                %Selects all the CT data that this ROI is
                                %connected to and corrects to the new
                                %SOPInstanceUID so the contour is drawn on the
                                %correct CT-slice
                                
                                sliceNum = ['Item_' num2str(bb)];
                                %If there's no connection between the ROI
                                %and the CT data this part prevents an
                                %error. Esp for brachy-strycture sets? 
                                if isfield (I.ROIContourSequence.(countNum).ContourSequence.(sliceNum),'ContourImageSequence')
                                    correspCTNum = strmatch(I.ROIContourSequence.(countNum).ContourSequence.(sliceNum).ContourImageSequence.Item_1.ReferencedSOPInstanceUID,storedSOPInstanceUID);
                                    I.ROIContourSequence.(countNum).ContourSequence.(sliceNum).ContourImageSequence.Item_1.ReferencedSOPInstanceUID = char(CheckSop(correspCTNum,1));
                                end
                            end
                        end
                    end
                end
                
            elseif strcmpi(d(i).name(1:2),'RP')
                
                % more anon stuff
                I.RTPlanName = 'Plan';
                I.ReviewerName = 'KalleAnka';
                I.ReviewerDate = '1901-01-01';
                I.ReviewerTime = '010101.010101';
                
                I.SOPInstanceUID = newPlanSOPInstanceUID;
                I.MediaStorageSOPInstanceUID = I.SOPInstanceUID;
                %write the new StudyInstanceUID
                I.StudyInstanceUID = newStudyInstanceUID;
                %write the new SeriesInstanceUID
                I.SeriesInstanceUID = dicomuid;
                %write the new DoseReferenceUID
                if isfield(I,'DoseReferenceSequence')
                    for xx = 1:length(fieldnames(I.DoseReferenceSequence))
                        FieldName = ['Item_' num2str(xx)];
                        I.DoseReferenceSequence.(FieldName).DoseReferenceUID = newDoseReferenceUID;
                    end
                end
                if isfield(I,'ReferencedStructureSetSequence')
                    I.ReferencedStructureSetSequence.Item_1.ReferencedSOPInstanceUID = newStructSOPInstanceUID;
                end
                %This part removes the comment for the field
                if isfield(I,'PatientSetupSequence')
                    for cc = 1:length(fieldnames(I.PatientSetupSequence))
                        FieldName = ['Item_' num2str(cc)];
                        I.PatientSetupSequence.(FieldName).SetupTechniqueDescription = 'Removed';
                    end
                end
                I.FrameOfReferenceUID = newFrameOfReferenceUID;
            elseif strcmpi(d(i).name(1:2),'MR')
                %write the new SOPInstanceUID and MediaStorageSOPInstanceUID;
                if firstTrigger == 1
                    firstTrigger = i;
                end
                storedSOPInstanceUID{i-(firstTrigger-1)} = I.SOPInstanceUID;
                
                I.SOPInstanceUID = newCTSOPInstanceUID;
                I.MediaStorageSOPInstanceUID = I.SOPInstanceUID;
                %write the new StudyInstanceUID
                I.StudyInstanceUID = newStudyInstanceUID;
                %write the new SeriesInstanceUID
                I.SeriesInstanceUID = newSeriesInstanceUID;
                
                %Creates the following SOPInstanceUID for the MRdata
                numForSOPInstanceUIDcalc = str2double(newCTSOPInstanceUID(finalCutPos:end))+1;
                newCTSOPInstanceUID(finalCutPos:end) = sprintf('%07d',(numForSOPInstanceUIDcalc));
                CheckSop{i-(firstTrigger-1),1} = I.SOPInstanceUID;
                I.FrameOfReferenceUID = newFrameOfReferenceUID;    
            
            elseif strcmpi(d(i).name(1:2),'PE') || strcmpi(I.Modality,'PT')
                %write the new SOPInstanceUID and MediaStorageSOPInstanceUID;
                if firstTrigger == 1
                    firstTrigger = i;
                end
                storedSOPInstanceUID{i-(firstTrigger-1)} = I.SOPInstanceUID;
                
                I.SOPInstanceUID = newCTSOPInstanceUID;
                I.MediaStorageSOPInstanceUID = I.SOPInstanceUID;
                %write the new StudyInstanceUID
                I.StudyInstanceUID = newStudyInstanceUID;
                %write the new SeriesInstanceUID
                I.SeriesInstanceUID = newSeriesInstanceUID;
                
                %Creates the following SOPInstanceUID for the PET
                numForSOPInstanceUIDcalc = str2double(newCTSOPInstanceUID(finalCutPos:end))+1;
                newCTSOPInstanceUID(finalCutPos:end) = sprintf('%07d',(numForSOPInstanceUIDcalc));
                CheckSop{i-(firstTrigger-1),1} = I.SOPInstanceUID;
                I.FrameOfReferenceUID = newFrameOfReferenceUID;   
            end
            
            dicomwrite(dicomread(I),[writefolder,filesep,d(i).name(1:2),'.',I.SOPInstanceUID,'.dcm'],I,'Createmode','Copy')
            %dicomwrite(dicomread(I),[here,newFolderName,filesep,d(i).name],I,'Createmode','Copy')
        end
        
        
        
    end
    
    waitbar(i / steps)
end
close(h)
% End loop
end
status = ['Success! There were ',num2str(warningTag),' warning(s). Files are in Export folder(s)'];

function helpButton_Callback(hObject, ~, handles)
% hObject    handle to helpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg({'Currently Anon can anonymize the following dicom-file combinations'
    '* 1 CT-set + RS + RP  + RD (Atleast matlab v2011b or later is needed).'
    '* 1 CT-set + RS + RP '
    '* 1 CT-set + RS '
    '* 1 CT-set'
    '* 1 MR-set'
    '* 1 PET-set Note: registration with CT disappears'
    '* 1 RP'
    ''
    ''
    'Usage: '
    '1. Export you dicomdata to a new separate folder from you TPS or other.' 
    '2. Select appropriate name and CPR for your new Anonpatient'
    '3. Navigate to this folder by clicking ''Change...'' next to Import path'
    '4. The export folder is automagically selected as the import folder + /AnonFiles (This can be changed if needed).'
    '5. Click Anonymize to start the process, this can take between 1-4 minutes depending on the number of structures'
    '6. When the anonymization process is completed the files should be in the /AnonFiles folder.' 
    'Click ''Open Export Folder'' to navigate your newly created anonymized dicomdata.'
    ''
    'NOTE: On first usage you will be asked to edit the file dicom_prep_SOPCommon.m as this file contains an error code which will make the program unable to write the correct UID to dicom-RS files.'
    ''
    'News: You can now duplicate sets if you need multiple copies of the patient in you database.'
    ''
    'Disclamer:'
    'You use this program at your own responsibility. Plans that has been saved with the program shall in no case be used to treat human beings or animals and only be used in research or QA. It is expressly prohibited to use the software for any commercial purposes. And remember to give credit where credit is due.'
    ''
    'Report any bugs to jonas.bengtssonscherman@gmail.com'})



function editDupl_Callback(hObject, eventdata, handles)
% hObject    handle to editDupl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDupl as text
%        str2double(get(hObject,'String')) returns contents of editDupl as a double


% --- Executes during object creation, after setting all properties.
function editDupl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDupl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxDupli.
function checkboxDupli_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxDupli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Min')
    set(handles.editDupl,'Visible','off')
elseif button_state == get(hObject,'Max')
    set(handles.editDupl,'Visible','on')  
end


% Hint: get(hObject,'Value') returns toggle state of checkboxDupli
