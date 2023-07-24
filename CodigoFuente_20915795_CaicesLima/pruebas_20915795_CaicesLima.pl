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

 Scrip para system

    system(1,S). % intenta crear un sistema de nombre incorrecto
    system(c,S). % intenta crear un sistema de nombre incorrecto
    system("123456",S). % Crea un sistema de Nombre "123456" que es un string


    Scrip para AddDrive
    system("newSystem", S1),systemAddDrive(S1,123,"Nombre",1000000,S3). % se intenta crear un Drive de "Letra" 1 que es entero y no char.
    system("newSystem", S1),systemAddDrive(S1,"D",nombre,1000000,S3). % se intenta crear un Drive, ingresando un "atomo" de nombre. este debe ser string
    system("newSystem", S1), systemAddDrive(S1, "C", "NewDrive", 100, S2),systemAddDrive(S2, "C", "NewDrive2", 1000, S3). % "C" ya existe en el sistema

    Scrip para systemRegister
    system("newSystem", S1), systemRegister(S1, 123, S2). % Se intenta registrar un usuario con nombre numérico, debe fallar
    system("newSystem", S1), systemRegister(S1, "Usuario1", S2), systemRegister(S1, "Usuario1", S3). % Se intenta registrar el mismo usuario dos veces, por lo cual S2 = S3
    system("newSystem", S1), systemRegister(S1, usuario , S2), systemRegister(S2, "Usuario2", S3). % Se intenta registrar un usuario ingresando un atomo por nombre.

    Scrip para systemLogin
    system("newSystem", S1), systemRegister(S1, "Usuario1", S2), systemLogin(S2, "Usuario2", S3). % Intenta iniciar sesión con un usuario no registrado, debe fallar
    system("newSystem", S1), systemRegister(S1, "Usuario1", S2), systemLogin(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4). % Un usuario inicia sesión dos veces, debería ser exitoso
    system("newSystem", S1), systemRegister(S1, "Usuario1", S2), systemLogin(S2, "Usuario1", S3), systemLogin(S3, "Usuario2", S4). % Un usuario inicia sesión y luego otro usuario intenta iniciar sesión, debe fallar

    Scrip para systemLogout
    system("newSystem", S1), systemLogout(S1, S2). % Intenta cerrar la sesión sin haber iniciado sesión, debe fallar
    system("newSystem", S1), systemRegister(S1, "Usuario1", S2), systemLogin(S2, "Usuario1", S3), systemLogout(S3, S4),systemLogout(S4,S5). % Inicia sesión con un usuario y luego cierra sesión dos veces, la segunda falla por que no hay usuario logeado
    system("newSystem", S1), systemRegister(S1, "Usuario1", S2), systemLogin(S2, "Usuario1", S3), systemLogout(S3, S4). % Inicia sesión con un usuario y luego cierra la sesión correctamente

    Scrip para systemSwitchDrive
    system("newSystem", S1), systemSwitchDrive(S1, "D", S2). % Intenta cambiar el drive sin tener un usuario logeado, debe fallar
    system("newSystem", S1), systemRegister(S1, "Usuario1", S2), systemLogin(S2, "Usuario1", S3), systemSwitchDrive(S3, "D", S4). % Intenta cambiar a un drive que no existe, debe fallar
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 100, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5). % Registra un usuario, inicia sesión, añade un drive y cambia a ese drive correctamente

    Scrip para systemMkdir
    system("newSystem", S1), systemMkdir(S1, "NuevaCarpeta", S2). % Intenta crear una carpeta sin tener un usuario logeado, debe fallar
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 100, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5), systemMkdir(S5, 12345 , S6). % intenta crear una carpeta de nombre no String. 
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 100, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5), systemMkdir(S5, "NuevaCarpeta", S6). % Registra un usuario, inicia sesión, añade un drive, cambia a ese drive y crea una carpeta correctamente

    Scrip para systemCd

    % Registra un usuario, inicia sesión, añade un drive, cambia a ese drive, crea una carpeta e intenta ingresar a un carpeta que no existe. 
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5), systemMkdir(S5, "NuevaCarpeta", S6), systemCd(S6, "NuevaCarpeta2", S7). 

    % Registra un usuario, inicia sesión, añade un drive, cambia a ese drive, crea una carpeta y cambia a esa carpeta, y luego vuelve a la raiz con "/".
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5), systemMkdir(S5, "NuevaCarpeta", S6), systemCd(S6, "NuevaCarpeta", S7),systemCd(S7,"/",S8).

    % Registra un usuario, inicia sesión, añade un drive, cambia a ese drive, crea una carpeta, cambia a esa carpeta y luego vuelve al directorio padre correctamente
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5), systemMkdir(S5, "NuevaCarpeta", S6),systemCd(S6, "NuevaCarpeta", S7),systemMkdir(S7,"NuevaCarpeta2",S8), systemCd(S8, "NuevaCarpeta2", S9),systemCd(S9,"..",S10).


    Scrip para systemAddFile

    % Se intenta registar un File creado incorrecto, en donde recibe un Nombre que no es string.
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5), file( 123, "hello world", F1), systemAddFile(S5, F1, S6).

    % se intenta registrar un File creado incorrecto, en donde recibe un Atomo en nombre, que no es un string.
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5), file( nombreatomo, "hello world", F1), systemAddFile(S5, F1, S6).

    % se registra el File creado correctamente con un nombre "123", que es un string.
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5), file( "123", "hello world", F1), systemAddFile(S5, F1, S6).
    
    
    Scrip para systemDel

    % Registra un usuario, inicia sesión, añade un drive, cambia a ese drive, crea un archivo, y luego intenta eliminar un archivo que no existe
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5), file("NombreFile", "Archivo1.txt", F1), systemAddFile(S5, F1, S6), systemDel(S6, "ArchivoInexistente.txt", S7). % False, ya que "ArchivoInexistente.txt" no existe en el sistema
    
    % Registra un usuario, inicia sesión, añade un drive, cambia a ese drive, crea un archivo, ingresa, crea otro archivo y lo elimina correctamente, lo guarda en papelera.
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5),systemMkdir(S5,"Carpeta1",S6),systemCd(S6,"/Carpeta1",S7),systemMkdir(S7,"Carpeta2",S8),systemDel(S8,"Carpeta2",S9). 
    
    % Crea dos carpetas y utliza la entrada "*" para eliminar todo el contenido del dir actual. se va a papelera.
    system("newSystem", S1), systemAddDrive(S1, "C", "OS", 10000000000, S2), systemRegister(S2, "user1", S3), systemRegister(S3, "user2", S4), systemLogin(S4, "user1", S5), systemSwitchDrive(S5, "C", S6), systemMkdir(S6, "folder1", S7), systemCd(S7, "folder1", S9), systemLogout(S9, S11), systemLogin(S11, "user2", S12), file( "file1A.txt", "hello world", F1), file("file1B.txt","hola mundo",F2),file("file1C.doc","holaaa",F3),file("file2A.doc","holaaa",F4),file("file2B.doc","holaaa",F5),file("file2C.txt","holaaa",F6),systemAddFile(S12, F1, S13),systemAddFile(S13, F2, S14),systemAddFile(S14, F3, S15),systemMkdir(S15,"folder2",S16),systemCd(S16,"folder2",S17),systemAddFile(S17,F4,S18),systemAddFile(S18, F5, S19),systemAddFile(S19, F6, S20),systemCd(S20,"..",S21),systemDel(S21,"folder2",S22).

    Script para systemCopy

    % Realizamos todo el procedimiento hasta cambiar el drive, luego creamos una carpeta, entramos, creamos otra carpeta, y luego esta ultima la copiamos en la raiz.
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5),systemMkdir(S5,"Carpeta1",S6),systemCd(S6,"Carpeta1",S7),systemMkdir(S7,"Carpeta2",S8),systemCopy(S8,"Carpeta2","D:/",S9).

    % se intenta copiar una carpeta que no existe, retorna false.
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5),systemMkdir(S5,"Carpeta1",S6),systemCopy(S6,"Carpeta2","D:/",S7).

    % copia el file que se creó dentro de la carpeta1, hacia la ruta raiz.
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5),systemMkdir(S5,"Carpeta1",S6),systemCd(S6,"Carpeta1",S7),file("file.txt","Hola",F1),systemAddFile(S7,F1,S8),systemCopy(S8,"file.txt","D:/",S9).

    % copia carpeta y sus subdirectorios a target path
    system("newSystem", S1), systemAddDrive(S1, "C", "OS", 10000000000, S2), systemRegister(S2, "user1", S3), systemRegister(S3, "user2", S4), systemLogin(S4, "user1", S5), systemSwitchDrive(S5, "C", S6), systemMkdir(S6, "folder1", S7),systemMkdir(S7, "folder11", S8),systemCd(S8, "folder1", S9),file("file1a.txt","archivo1",F1),file("file2a.txt","archivo2a",F2A),file("file2b.doc","archivo2c",F2B),file("file3a.txt","archivo3",F3),systemAddFile(S9,F1,S10),systemMkdir(S10,"folder2",S11),systemCd(S11,folder2,S12),systemAddFile(S12,F2A,S13),systemAddFile(S13,F2B,S14),systemMkdir(S14,"folder3",S15),systemCd(S15,folder3,S16),systemAddFile(S16,F3,S17),systemCd(S17,"c:/folder1/",S18),systemCopy(S18,"folder2","c:/folder11/",S19).


    Script para systemMove

    % creamos la carpeta Carpeta1 e ingresamos, creamos la carpeta Carpeta2 dentro de Carpeta1, movemos Carpeta2 a la raiz.
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5),systemMkdir(S5,"Carpeta1",S6),systemCd(S6,"/Carpeta1",S7),systemMkdir(S7,"Carpeta2",S8),systemMove(S8,"Carpeta2","D:/",S9).

    % creamos la carpeta Carpeta1 e ingresamos, creamos la carpeta Carpeta2 dentro de Carpeta1, intentamos mover una carpeta inexistente, false.
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5),systemMkdir(S5,"Carpeta1",S6),systemCd(S6,"/Carpeta1",S7),systemMkdir(S7,"Carpeta2",S8),systemMove(S8,"CarpetaInexistente","D:/",S9).

    % mueve carpeta y sus subdirectorios a target path
    system("newSystem", S1), systemAddDrive(S1, "C", "OS", 10000000000, S2), systemRegister(S2, "user1", S3), systemRegister(S3, "user2", S4), systemLogin(S4, "user1", S5), systemSwitchDrive(S5, "C", S6), systemMkdir(S6, "folder1", S7),systemMkdir(S7, "folder11", S8),systemCd(S8, "folder1", S9),file("file1a.txt","archivo1",F1),file("file2a.txt","archivo2a",F2A),file("file2b.doc","archivo2c",F2B),file("file3a.txt","archivo3",F3),systemAddFile(S9,F1,S10),systemMkdir(S10,"folder2",S11),systemCd(S11,folder2,S12),systemAddFile(S12,F2A,S13),systemAddFile(S13,F2B,S14),systemMkdir(S14,"folder3",S15),systemCd(S15,folder3,S16),systemAddFile(S16,F3,S17),systemCd(S17,"c:/folder1/",S18),systemMove(S18,"folder2","c:/folder11/",S19).
    
    Script para systemRen

    % crea una carpeta1 y carpeta2 dentro de carpeta1, luego renombra carpeta2 por otro nombre, realizando sin probemas.
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5),systemMkdir(S5,"Carpeta1",S6),systemCd(S6,"/Carpeta1",S7),systemMkdir(S7,"Carpeta2",S8),systemRen(S8,"Carpeta2","NewCarpeta2",S9).
    
    % crea un file1 en la raiz, y luego renombra el file1 por otro nombre, esto se realiza sin problemas.
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5),file("file1.txt","HGolaaa",F1),systemAddFile(S5,F1,S6),systemRen(S6,"file1.txt","HOla.txt",S7).

    % se intenta renombrar una carpeta que no existe, retorna false.
    system("newSystem", S1), systemAddDrive(S1, "D", "Drive1", 1000000, S2), systemRegister(S2, "Usuario1", S3), systemLogin(S3, "Usuario1", S4), systemSwitchDrive(S4, "D", S5),systemMkdir(S5,"Carpeta1",S6),systemRen(S6,"CarpetaInexistente","Carpeta",S7).

    Script para systemDir

    % Lista con []
    system("newSystem", S1), systemAddDrive(S1, "C", "OS", 10000000000, S2), systemRegister(S2, "user1", S3), systemRegister(S3, "user2", S4), systemLogin(S4, "user1", S5), systemSwitchDrive(S5, "C", S6), systemMkdir(S6, "folder1", S7),systemMkdir(S7, "folder11", S8),systemCd(S8, "folder1", S9),file("file1a.txt","archivo1",F1),file("file2a.txt","archivo2a",F2A),file("file2b.doc","archivo2c",F2B),file("file3a.txt","archivo3",F3),systemAddFile(S9,F1,S10),systemMkdir(S10,"folder2",S11),systemCd(S11,"folder2",S12),systemAddFile(S12,F2A,S13),systemAddFile(S13,F2B,S14),systemMkdir(S14,"folder3",S15),systemCd(S15,"folder3",S16),systemAddFile(S16,F3,S17),systemCd(S17,"c:/folder1/",S18),systemDir(S18,[],Str),writeln(Str).

    % Lista con ["/s"]
    system("newSystem", S1), systemAddDrive(S1, "C", "OS", 10000000000, S2), systemRegister(S2, "user1", S3), systemRegister(S3, "user2", S4), systemLogin(S4, "user1", S5), systemSwitchDrive(S5, "C", S6), systemMkdir(S6, "folder1", S7),systemMkdir(S7, "folder11", S8),systemCd(S8, "folder1", S9),file("file1a.txt","archivo1",F1),file("file2a.txt","archivo2a",F2A),file("file2b.doc","archivo2c",F2B),file("file3a.txt","archivo3",F3),systemAddFile(S9,F1,S10),systemMkdir(S10,"folder2",S11),systemCd(S11,"folder2",S12),systemAddFile(S12,F2A,S13),systemAddFile(S13,F2B,S14),systemMkdir(S14,"folder3",S15),systemCd(S15,"folder3",S16),systemAddFile(S16,F3,S17),systemCd(S17,"c:/folder1/",S18),systemDir(S18,["/s"],Str),writeln(Str).

    % Lista con ["/o N"]
    system("newSystem", S1), systemAddDrive(S1, "C", "OS", 10000000000, S2), systemRegister(S2, "user1", S3), systemRegister(S3, "user2", S4), systemLogin(S4, "user1", S5), systemSwitchDrive(S5, "C", S6), systemMkdir(S6, "folder1", S7),systemMkdir(S7, "folder11", S8),systemCd(S8, "folder1", S9),file("file1a.txt","archivo1",F1),file("file2a.txt","archivo2a",F2A),file("file2b.doc","archivo2c",F2B),file("file3a.txt","archivo3",F3),systemAddFile(S9,F1,S10),systemMkdir(S10,"folder2",S11),systemCd(S11,"folder2",S12),systemAddFile(S12,F2A,S13),systemAddFile(S13,F2B,S14),systemMkdir(S14,"folder3",S15),systemCd(S15,"folder3",S16),systemAddFile(S16,F3,S17),systemCd(S17,"c:/folder1/folder2/",S18),systemDir(S18,["/o N"],Str),writeln(Str).

    % Lista parametros que puede utilizar ["/?"]
    system("newSystem", S1),systemDir(S1,["/?"],R),writeln(R).
*/
%