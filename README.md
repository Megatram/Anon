# Anon
# This is a matlab script which anonymizes dicomfiles. 
# Its primary use is in radiotherapy where it keeps the connection between CT-data, structure-sets, treatment plan and 3D-dose. 
# It can also be used to duplicate data and storing the same CT-data twice in the treatment planning software. 
# It can also be used for PET and MR image sets, However the InstanceUID disappears and you have to register the data again in the treatment planning software. 
# 2016-06-15: Added duplication functionality where you now can create multiple copies of the files for use in the same database. Please note that the software automatically adds _01 etc on the CPR and the Last name for the patient.  
