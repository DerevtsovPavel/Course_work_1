/// Автор: Деревцов Павел Андреевич ВМК-22
unit unit_Spiski;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

Type
  {Информац часть списка}
  Rashod=record
    Vidal:string[60];// фио выдавшего
    Poluchil:string[60];// фио получившего
    Material:string[50];// название материала
    Kolvo:integer;// кол-во выданного материала
  end;

  //  тип указатель на узлы списка
  Puzel=^Uzel;
  // тип узла списка
  Uzel=record
    Pred:Puzel;// ук на предыдущий узел
    Next:Puzel;// ук на следующий узел
    Inf:Rashod;// инф часть
  end;

  Ar_material=array of string;// массив с названиями разных материалов
  Kol_material=array of integer;// массив с кол-вом разных материалов из Ar_material

/// добавление нового узла a в конец списка
procedure AddEnd(Var a,Plast:Puzel);
/// удаление всего списка
procedure DelSpisok(var Pfirst:Puzel);
/// удаляет из списка элемент номером n
procedure DeleteNumb(var pfirst,plast:Puzel; const n:byte);
/// вставляет эл а на место с номером n
procedure InsertOnNumb(var a,Pfirst,Plast:Puzel; const n:byte);
/// узнаём размер списка
function Size_Spisok(const Pfirst:Puzel):integer;
/// сортирует по возростанию поля кол-во
procedure Sort_kolvo(var Pfirst:Puzel);
/// сортировка по алфавиту по полю ФИО выдавшего
procedure Sort_Vidal (var Pfirst:Puzel);
/// сортировка по алфавиту по полю ФИО получившего
procedure Sort_Poluchil (var Pfirst:Puzel);
// сортировка по алфавиту по полю материал
procedure Sort_Material(var Pfirst:Puzel);
/// создаём массив a из материалов
procedure seek_material(const Pfirst:Puzel; var a:Ar_material);
/// считает кол-во различных материалов из массива а и записывает на соответствующее место в массив b
procedure schet_material(const Pfirst:Puzel; var b:Kol_material; var a:Ar_material);


implementation

 /// добавление нового узла в конец списка
 procedure AddEnd(Var a,Plast:Puzel);
 begin
   a^.Pred:=Plast;
   Plast^.Next:=a;
   Plast:=a;
 end;

  /// удаление всего списка
 procedure DelSpisok(var Pfirst:Puzel);
 var current:Puzel;
   begin
     while Pfirst<>nil do begin
       current:=Pfirst;
       Pfirst:=Pfirst^.Next;
       Dispose(current);
     end;
   end;


 /// удаляет из списка элемент номером n
 procedure DeleteNumb(var pfirst,plast:Puzel; const n:byte);
 var i:byte;
   current:Puzel;
   Pdo,Psled:Puzel;// Pdo-ук на уз перед удаляемым Psled-ук на след за удаляемым
   begin

      if n=1 then begin // если удаляем первый
        current:=Pfirst;
        Pfirst:=Pfirst^.next;
        Pfirst^.Pred:=nil;
        Dispose(current);
      end

     else begin
     current:=Pfirst;

   for i:=1 to n-1 do
       current:=current^.next;

    if current=plast then begin  // если уд последний
      Plast:=Plast^.pred;
      Plast^.Next:=nil;
      Dispose(current);
    end
      else begin
   Pdo:=current^.Pred;
   Psled:=current^.Next;

   {связываем элементы меж собой}
   Pdo^.Next:=current^.Next;
   Psled^.Pred:=current^.Pred;
   dispose(current);
   end;
     end;
   end;

 /// вставляет эл а на место с номером n
procedure InsertOnNumb(var a,Pfirst,Plast:Puzel; const n:byte);
var current:Puzel;
  i:byte;
  begin
    if n=1 then begin // если ставим на первое место
      a^.next:=Pfirst;
      Pfirst^.Pred:=a;
      Pfirst:=a;
    end

    else begin

     current:=Pfirst;
     for i:=1 to n-1 do
         current:=current^.next;

          if current=plast then // если на место последнего
             plast:=current;

       a^.Next:=current;
       a^.pred:=current^.pred;
       current^.Pred^.Next:=a; // для предыдущего эл указатель на след эл ставим на добавляемый эл
       current^.pred:=a;
    end;
  end;

/// узнаём размер списка
function Size_Spisok(const Pfirst:Puzel):integer;
var current:Puzel;
begin
   current:=Pfirst;
   Result:=0;
   while current<>nil do begin
      Result:=Result+1;
      current:=current^.next;
   end;
end;

/// сортирует по возростанию поля кол-во
procedure Sort_kolvo(var Pfirst:Puzel);
var n,S_S,i:integer;
  current:Puzel;
  R:Rashod;
begin
  S_S:=Size_Spisok(Pfirst);
  current:=Pfirst;
  n:=0;

   while n<S_S do begin

      for i:=1 to (S_S-n-1) do begin
        if current^.inf.Kolvo > current^.Next^.Inf.Kolvo then begin
          R:=current^.Inf;
          current^.Inf:=current^.Next^.Inf;
          current^.Next^.Inf:=R;
        end;
         current:=current^.next;
      end;

      n:=n+1;
      current:=Pfirst;
   end;
end;

/// сортировка по алфавиту по полю ФИО выдавшего
procedure Sort_Vidal (var Pfirst:Puzel);
var n,S_S,i:integer;
    current:Puzel;
    R:Rashod;
begin
  S_S:=Size_Spisok(Pfirst);
  current:=Pfirst;
  n:=0;

  while n<S_S do begin
  for i:=1 to (S_S-n-1) do begin
    if current^.Inf.Vidal > current^.Next^.Inf.Vidal then begin
      R:=current^.Inf;
      current^.Inf:=current^.Next^.Inf;
      current^.Next^.Inf:=R;
    end;
    current:=current^.next;
  end;

  n:=n+1;
  current:=Pfirst;

end;
end;

/// сортировка по алфавиту по полю ФИО получившего
procedure Sort_Poluchil (var Pfirst:Puzel);
var n,S_S,i:integer;
    current:Puzel;
    R:Rashod;
begin
  S_S:=Size_Spisok(Pfirst);
  current:=Pfirst;
  n:=0;

  while n<S_S do begin
  for i:=1 to (S_S-n-1) do begin
    if current^.Inf.Poluchil > current^.Next^.Inf.Poluchil then begin
      R:=current^.Inf;
      current^.Inf:=current^.Next^.Inf;
      current^.Next^.Inf:=R;
    end;
    current:=current^.next;
  end;

  n:=n+1;
  current:=Pfirst;
end;
end;

/// сортировка по алфавиту по полю материал
procedure Sort_Material(var Pfirst:Puzel);
var n,S_S,i:integer;
    current:Puzel;
    R:Rashod;
begin
  S_S:=Size_Spisok(Pfirst);
  current:=Pfirst;
  n:=0;

  while n<S_S do begin
  for i:=1 to (S_S-n-1) do begin
    if current^.Inf.Material > current^.Next^.Inf.Material then begin
      R:=current^.Inf;
      current^.Inf:=current^.Next^.Inf;
      current^.Next^.Inf:=R;
    end;
    current:=current^.next;
  end;

  n:=n+1;
  current:=Pfirst;
end;
end;

/// создаём массив из материалов
procedure seek_material(const Pfirst:Puzel; var a:Ar_material);
var current:Puzel;
    i,j:integer;// i-номер эл в массиве  j-параметр цикла
    k:byte;// переключатель условия
begin
  current:=Pfirst;

  i:=1;
  SetLength(a,i);
  a[0]:=current^.Inf.Material;

  current:=current^.next;

  while current <> nil do begin     // проверяем,встречался ли материал уже
  k:=0;
     for j:=0 to i-1 do begin
        if current^.Inf.Material=a[j] then k:=1;
     end;
    if k=0 then begin // если не встречался
      i:=i+1;
      SetLength(a,i);
      a[i-1]:=current^.inf.Material;
    end;
    current:=current^.next;
  end;
end;

/// считает кол-во различных материалов
procedure schet_material(const Pfirst:Puzel; var b:Kol_material; var a:Ar_material);
var current:Puzel;
    i,j,sum:integer;

begin
  j:=Length(a);
  SetLength(b,j);
   for i:=0 to Length(a)-1 do begin
     sum:=0;
     current:=Pfirst;
     while current<>nil do begin
        if current^.inf.Material=a[i] then sum:=sum+current^.inf.kolvo; // считаем сколько раз встречается материал a[i]
        current:=current^.next;
     end;
     b[i]:=sum;
   end;
end;

end.

