# Anon
# This is a matlab gui that anonymizes dicomfiles. 
# Its primary use is in radiotherapy where it keeps the connection between CT-data, structure-sets, treatment plan and 3D-dose. 
# It can also be used to duplicate data and storing the same CT-data twice in the treatment planning software, useful for QA-plans on multiple linacs.
# It can also be used for PET and MR image sets, However the InstanceUID disappears and you have to register the data again in the treatment planning software. This process is fairly easy and you should register images based on their dicom-origin.  
# 2016-06-15: Added duplication functionality where you now can create multiple copies of the files for use in the same database. Please note that the software automatically adds _01 etc on the CPR and the Last name for the patient.  
# 2016-11-26: Added a catch phrase for structures with non UTF-8 symbols (åäöæø etc). This is a rare error only seen for one patient this far, however to allow for a successful anonymization and import into the TPS you should rename the structures in the TPS prior to anonymization. The error will still be there, however it will allow for a successful import after anonymization. Please contact the developer if you find anything interesting. 
# 2017-04-11 Added information regarding HU-overridden structures in the helpdlg. 
