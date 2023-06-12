:- consult('tda_system_20915795_CaicesLima').

/* 

% ############# SCRIPT DE PRUEBAS LAB ############# %

% Caso que debe retornar true:
% Creando un sistema, con el disco C, dos usuarios: “user1” y “user2”, 
% se hace login con "user1”, se utiliza el disco "C", se crea la carpeta “folder1”, 
% “folder2”, se cambia al directorio actual “folder1", 
% se crea la carpeta "folder11" dentro de "folder1", 
% se hace logout del usuario "user1", se hace login con “user2”, 
% se crea el archivo "foo.txt" dentro de “folder1”, se acceder a la carpeta c:/folder2, 
% se crea el archivo "ejemplo.txt" dentro de c:/folder2

system("newSystem", S1), systemAddDrive(S1, "C", "OS", 10000000000, S2), systemRegister(S2, "user1", S3), systemRegister(S3, "user2", S4), systemLogin(S4, "user1", S5), systemSwitchDrive(S5, "C", S6), systemMkdir(S6, "folder1", S7), systemMkdir(S7, "folder2", S8), systemCd(S8, "folder1", S9), systemMkdir(S9, "folder11", S10), systemLogout(S10, S11), systemLogin(S11, "user2", S12), file( "foo.txt", "hello world", F1), systemAddFile(S12, F1, S13), systemCd(S13, "/folder2", S14),  file( "ejemplo.txt", "otro archivo", F2), systemAddFile(S14, F2, S15).


% ############# Casos que deben retornar false ############# %

% si se intenta añadir una unidad con una letra que ya existe

system("newSystem", S1), systemRegister(S1, "user1", S2), systemAddDrive(S2, "C", "OS", 1000000000, S3), systemAddDrive(S3, "C", "otra etiqueta", 1000000000, S4).

% si se intenta hacer login con otra sesión ya iniciada por este usuario u otro

system("newSystem", S1), systemRegister(S1, "user1", S2), systemRegister(S2, "user2", S3), systemLogin(S3, "user1", S4), systemLogin(S4, "user2", S5).

% si se intenta usar una unidad inexistente

system("newSystem", S1), systemRegister(S1, "user1", S2), systemLogin(S2, "user1", S3), systemSwitchDrive(S3, "K", S4).

% ############# SCRIPT DE PRUEBAS PRUEBA PROPIO ############# %

% Crea un sistema, añade 3 unidades, añade 3 users, logea user1, deslogea user1, 
% logea user2, se cambia a unidad D, 
% crea directorio folderA,
% entra en folderA y crea folderAA, 
% vuelve a la raiz y crea folderB,
% entra en folderB y crea archivo 1 y 2,
% se cambia a unidad C y 
% crea archivo 3, elimina archivo3


%system("mySystem",S1),systemAddDrive(S1,"C","Drive1",100,S2),systemAddDrive(S2,"K","Drive2",200,S3),systemAddDrive(S3,"D","Drive3",15000,S4),systemRegister(S4,"user1",S5),systemRegister(S5,"user2",S6),systemRegister(S6,"user3",S7),systemLogin(S7,"User1",S8),systemLogout(S8,S9),systemLogin(S9,"USER2",S10),systemSwitchDrive(S10,"D",S11),systemMkdir(S11,"folderA",S12),systemCd(S12,"folderA",S13),systemMkdir(S13,"folderAA",S14),systemCd(S14,"/",S15),systemMkdir(S15,"FolderB",S16),systemCd(S16,"D:/folderb/",S17),file( "file1.txt", "hello world", F1),file( "file2.txt", "hellooooooo world", F2),systemAddFile(S17,F1,S18),systemAddFile(S18,F2,S19),systemSwitchDrive(S19,"C",S20),file("file3.txt","labprolog2",F3),systemAddFile(S20,F3,S21),systemDel(S21,"file3.txt",S22).

% ############# Casos que deben retornar false ############# %

%system("mySystem",S1),systemAddDrive(S1,"C","Drive1",100,S2),systemAddDrive(S2,"K","Drive2",200,S3),systemAddDrive(S3,"D","Drive3",15000,S4),systemRegister(S4,"user1",S5),systemRegister(S5,"user2",S6),systemRegister(S6,"user3",S7),systemLogin(S7,"User1",S8),systemLogout(S8,S9),systemLogin(S9,"USER2",S10),systemSwitchDrive(S10,"D",S11),systemMkdir(S11,"folderA",S12),systemCd(S12,"folderA",S13),systemMkdir(S13,"folderAA",S14),systemCd(S14,"/",S15),systemMkdir(S15,"FolderB",S16),systemCd(S16,"D:/folderb/",S17),file( "file1.txt", "hello world", F1),file( "file2.txt", "hellooooooo world", F2),systemAddFile(S17,F1,S18),systemAddFile(S18,F2,S19),systemSwitchDrive(S19,"C",S20),file("file3.txt","labprolog2",F3),systemAddFile(S20,F3,S21),systemDel(S21,"file2.txt",S22).
*/