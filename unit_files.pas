/// Автор:Деревцов Павел Андреевич ВМК-22
unit unit_files;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,unit_Spiski;

type
  File_rashod=file of rashod;// тип файла для сохранения списка

 /// сохранение списка в типизированный файл
procedure SaveInType(var f:File_rashod;const Pfirst:Puzel);
/// чтение и создание списка из тип файла
procedure ReadFromType(var f:File_rashod; var Pfirst,Plast:Puzel);
/// вывод списка в текстовый файл
procedure SaveInText (var f:text; const Pfirst:Puzel);


implementation

/// сохранение списка в типизированный файл
procedure SaveInType(var f:File_rashod;const Pfirst:Puzel);
var current:Puzel;
begin
   current:=Pfirst;
   while current<>nil do begin
     write(f,current^.inf);
     current:=current^.next;
   end;
end;

/// чтение и создание списка из тип файла
procedure ReadFromType(var f:File_rashod; var Pfirst,Plast:Puzel);
var a:Puzel;
 begin
   if Pfirst=nil then begin
     New(a);
     a^.Next:=nil;
     a^.Pred:=nil;
     read(f,a^.inf);
     Pfirst:=a;
     Plast:=a;
   end;

   while not EOF(f) do begin
     new(a);
     read(f,a^.inf);
     AddEnd(a,Plast);
   end;
 end;

/// вывод списка в текстовый файл
procedure SaveInText (var f:text; const Pfirst:Puzel);
var s:string;
    current:Puzel;
begin
  current:=Pfirst;
  s:=unicodeFormat('%0:-60s %1:-60s %2:-50s %3:-10s',['ФИО выдавшего','ФИО получившего','Материал','Количество']);
  writeln(f,s);
  while current <> nil do begin
    with current^.Inf do
    s:=unicodeFormat('%0:-60s %1:-60s %2:-50s %3:4s',[vidal,poluchil,material,IntToStr(kolvo)]);
    writeln(f,s);
    current:=current^.next;
  end;
end;

end.

