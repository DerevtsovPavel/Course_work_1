/// Автор: Деревцов Павел Андреевич ВМК-22
unit unit_Main_Form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus, Spin,
  Grids, unit_Spiski, unit_files;

type

  { TForm_Main }

  TForm_Main = class(TForm)
    Button_insert: TButton;
    Button_delete_number: TButton;
    Button_fix: TButton;
    Button_add: TButton;

    Edit_kolvo: TEdit; // поле ввода кол-ва выданного материала
    Edit_material: TEdit; // поле ввода материала
    Edit_poluchil: TEdit;  // поле ввода фио получившего
    Edit_vidal: TEdit;  // поле ввода фио выдавшего

    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label_size_Spisok: TLabel;// выводит кол-во эл в списке

    MainMenu: TMainMenu;
    Memo: TMemo;
    MenuItem_saveInText: TMenuItem;
    MenuItem_otchet_text: TMenuItem; // вывод отчёта в текстовый файл
    MenuItem_otchet: TMenuItem;// меню для создания отчёта о кол-ве использованных материалов
    MenuItem_seek_material: TMenuItem; // поиск по материалу
    MenuItem_seek_vidal: TMenuItem;// поиск по фио выдавшего
    MenuItem_seek: TMenuItem;
    MenuItem_sort_material: TMenuItem;// сортировка по материалу
    MenuItem_sort_poluchil: TMenuItem;// сортировка по фио получившего
    MenuItem_sort_vidal: TMenuItem;// сортировка по фио выдавшего
    MenuItem_sort_kolvo: TMenuItem;// сортировка по кол-ву
    MenuItem_sort: TMenuItem;

    MenuItem_delete: TMenuItem;// подменю для удаления списка
    MenuItem_readfromtype: TMenuItem; // подменю для чтения из типизированного файла
    MenuItem_saveintype: TMenuItem; // подменю сохранения в типизированный файл
    MenuItem_files: TMenuItem; // подменю для работы с файлами
    MenuItem_show: TMenuItem; // подменю для вывода списка в мемо
    MenuItem_spiski: TMenuItem; // подменю для работы со списком

    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SpinEdit_number: TSpinEdit;
    StringGrid: TStringGrid;

    /// добавление записи в конец
    procedure Button_addClick(Sender: TObject);
    /// удаление записи с определённым номером
    procedure Button_delete_numberClick(Sender: TObject);
    /// правка записи
    procedure Button_fixClick(Sender: TObject);
    /// вставка записи
    procedure Button_insertClick(Sender: TObject);
    /// удаление всего списка
    procedure MenuItem_deleteClick(Sender: TObject);
    /// создание отчёта
    procedure MenuItem_otchetClick(Sender: TObject);
    /// вывод отчёта в текстовый файл
    procedure MenuItem_otchet_textClick(Sender: TObject);
    /// создание списка из типизированного файла
    procedure MenuItem_readfromtypeClick(Sender: TObject);
    /// вывод списка в текстовый файл
    procedure MenuItem_saveInTextClick(Sender: TObject);
    /// сохранение списка в типизированный файл
    procedure MenuItem_saveintypeClick(Sender: TObject);
    /// поиск по материалу
    procedure MenuItem_seek_materialClick(Sender: TObject);
    /// поиск по ФИО выдавшего
    procedure MenuItem_seek_vidalClick(Sender: TObject);
    /// вывод списка на экран
    procedure MenuItem_showClick(Sender: TObject);
    /// сортировка списка по кол-ву от меньшего к большему
    procedure MenuItem_sort_kolvoClick(Sender: TObject);
    /// сортировка по названию материала от А до Я
    procedure MenuItem_sort_materialClick(Sender: TObject);
    /// сортировка по ФИО получившего от А до Я
    procedure MenuItem_sort_poluchilClick(Sender: TObject);
    /// сортировка по ФИО выдавшего от А до Я
    procedure MenuItem_sort_vidalClick(Sender: TObject);


  private

  public

  end;

var
  Form_Main: TForm_Main;
  Pfirst,Plast:Puzel;// ук на голову и хвост списка
  F_T:file_rashod; // типизированный файл, для сохранения исходного списка

  M_A:Ar_material; // массив со всеми использованными материалами
  K_A:Kol_material;// кол-во различных использованных материалов

  f:Text;
implementation

{$R *.lfm}

{ TForm_Main }

/// добавление сведений в список
procedure TForm_Main.Button_addClick(Sender: TObject);
var a:Puzel;
  K:integer;
begin
  if TryStrToInt(Edit_Kolvo.Text,K) then begin
   New(a);
   a^.Pred:=nil;
   a^.Next:=nil;

   /// заполняем инф поле
   with a^.Inf do begin
     TryStrToInt(Edit_kolvo.Text,Kolvo);
     Vidal:=Edit_vidal.Text;
     Poluchil:=Edit_poluchil.Text;
     Material:=Edit_material.Text;

   end;

   if Pfirst=nil then begin
     Pfirst:=a;
     Plast:=a;
   end

   else begin
       AddEnd(a,Plast);
   end;
  Label_size_Spisok.Caption:=IntToStr(Size_spisok(Pfirst));
   SpinEdit_number.MaxValue:=Size_spisok(Pfirst);
end
  else ShowMessage('Введите число');
  end;

/// удаление элемента с номером Edit_number
procedure TForm_Main.Button_delete_numberClick(Sender: TObject);
var n:byte;
begin
    if Pfirst=nil then showMessage('Список Пуст')
    else begin
   n:=SpinEdit_number.Value;

   DeleteNumb(Pfirst,Plast,n);

   Label_size_Spisok.Caption:=IntToStr(Size_spisok(Pfirst));
   SpinEdit_number.MaxValue:=Size_spisok(Pfirst);
    end;
end;

/// редактирование узла списка с номером  Edit_number
procedure TForm_Main.Button_fixClick(Sender: TObject);
var n,i:byte;
  current:Puzel;
begin
   if Pfirst= nil then  showMessage('Список Пуст')
   else begin
   n:=SpinEdit_number.Value;
   current:=Pfirst;

   for i:=1 to n-1 do
       current:=current^.next;

   with current^.inf do begin
      Vidal:=InputBox('ФИО выдавшего','ФИО выдавшего',Vidal);
     Poluchil:=InputBox('ФИО получившего','ФИО получившего',Poluchil);
     Material:=InputBox('Материал','Материал',Material);
     Kolvo:=StrToInt(InputBox('Количество','Кол-во',IntToStr(Kolvo)));
   end;

   end;
end;

/// вставка элемента на место с номером Edit_number
procedure TForm_Main.Button_insertClick(Sender: TObject);
var n:byte;
  a:Puzel;
begin
   if Pfirst=nil then  showMessage('Список Пуст')
   else begin
   n:=SpinEdit_number.Value;

   new(a);
     a^.Pred:=nil;
   a^.Next:=nil;

   /// заполняем инф поле
   with a^.Inf do begin
     if not TryStrToInt(Edit_kolvo.Text,Kolvo) then ShowMessage('Введите Число')
     else begin
     Vidal:=Edit_vidal.Text;
     Poluchil:=Edit_poluchil.Text;
     Material:=Edit_material.Text;


   InsertOnNumb(a,Pfirst,Plast,n);
    end;
   end;


   Label_size_Spisok.Caption:=IntToStr(Size_spisok(Pfirst));
    SpinEdit_number.MaxValue:=Size_spisok(Pfirst);
end;

end;

/// удаление всего списка
procedure TForm_Main.MenuItem_deleteClick(Sender: TObject);
begin
  DelSpisok(Pfirst);
  Label_size_Spisok.Caption:=IntToStr(Size_spisok(Pfirst));
   SpinEdit_number.MaxValue:=Size_spisok(Pfirst);
end;

/// создание отчёта по всем использованным материалам
procedure TForm_Main.MenuItem_otchetClick(Sender: TObject);
var
    i:integer;
    s:string;
begin
   if Pfirst=nil then ShowMessage('Список Пуст')
   else begin
   Seek_Material(Pfirst,M_A);
   schet_material(Pfirst,K_A,M_A);

   memo.append('Отчёт');
   for i:=0 to Length(M_A)-1 do begin
      s:=M_A[i]+': '+IntToStr(K_A[i]);
      Memo.Append(s);
   end;

   end;
end;

/// вывод отчёта в текстовый файл
procedure TForm_Main.MenuItem_otchet_textClick(Sender: TObject);
var i:integer;
    s:string;
begin
   if saveDialog.execute then begin
     AssignFile(f,Savedialog.FileName);
      Rewrite(f);
   for i:=0 to Length(M_A)-1 do begin
      s:=M_A[i]+': '+IntToStr(K_A[i]);
      writeln(f,s);
   end;
   closefile(f);
    end;

end;

 /// чтение и создание списка из тип файла
procedure TForm_Main.MenuItem_readfromtypeClick(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    AssignFile(F_T,OpenDialog.FileName);
    Reset(F_T);
    ReadFromType(F_T,Pfirst,Plast);
    closeFile(F_T);
  end;
  Label_size_Spisok.Caption:=IntToStr(Size_spisok(Pfirst));
   SpinEdit_number.MaxValue:=Size_spisok(Pfirst);
end;

/// вывод списка в текстовый файл
procedure TForm_Main.MenuItem_saveInTextClick(Sender: TObject);
begin
  if Pfirst=nil then ShowMessage('Список Пуст')
  else begin
  if SaveDialog.Execute then begin
  AssignFile(f,savedialog.filename);
  Rewrite(f);
  SaveInText(f,Pfirst);
  CloseFile(f);
  end;

  end;
end;


/// сохранение списка в тип файл
procedure TForm_Main.MenuItem_saveintypeClick(Sender: TObject);
begin
  if Pfirst=nil then ShowMessage('Список Пуст')
  else begin
   if SaveDialog.Execute then begin
     AssignFile(F_T,SaveDialog.FileName);
     Rewrite(F_T);
     SaveInType(F_T,Pfirst);
     CloseFile(F_T);
   end;
  end;
end;

/// Поиск материала,вывод в stringgrid
procedure TForm_Main.MenuItem_seek_materialClick(Sender: TObject);
 var s:string;
  current:Puzel;
  i:integer;
begin
  if Pfirst=nil then ShowMessage('Список Пуст')
  else begin
   s:=InputBox('Поиск по ФИО выдавшего','ФИО выдавшего','');

   stringgrid.Clear;// очищаем stringgrid

   /// создаём и заполняем fixcol row
   StringGrid.ColCount:=5;
   StringGrid.RowCount:=1;
  StringGrid.Cells[0,0]:='Номер';
  StringGrid.Cells[1,0]:='Выдал';
  StringGrid.Cells[2,0]:='Получил';
  StringGrid.Cells[3,0]:='Материал';
  StringGrid.Cells[4,0]:='Кол-во';

  i:=1;
  current:=Pfirst;

   while current<> nil do begin
   if current^.Inf.Material=s then begin // если находим,то заполняем
   StringGrid.RowCount:=i+1;

   StringGrid.Cells[0,i]:=IntToStr(i);
  StringGrid.Cells[1,i]:=current^.Inf.Vidal;
  StringGrid.Cells[2,i]:=current^.Inf.Poluchil;
  StringGrid.Cells[3,i]:=current^.Inf.Material;
  StringGrid.Cells[4,i]:=IntToStr(current^.Inf.Kolvo);
    i:=i+1;
   end;
    current:=current^.next;
   end;

  end;
end;

/// Поиск в списке по полю ФИО выдал, вывод в stringgrid
procedure TForm_Main.MenuItem_seek_vidalClick(Sender: TObject);
var s:string;
  current:Puzel;
  i:integer;
begin
  if Pfirst=nil then ShowMessage('Список Пуст')
  else begin
   s:=InputBox('Поиск по ФИО выдавшего','ФИО выдавшего','');

   stringgrid.Clear;// очищаем stringgrid

   /// создаём и заполняем fixcol row
   StringGrid.ColCount:=5;
   StringGrid.RowCount:=1;
  StringGrid.Cells[0,0]:='Номер';
  StringGrid.Cells[1,0]:='Выдал';
  StringGrid.Cells[2,0]:='Получил';
  StringGrid.Cells[3,0]:='Материал';
  StringGrid.Cells[4,0]:='Кол-во';

  i:=1;
  current:=Pfirst;

   while current<> nil do begin
   if current^.Inf.Vidal=s then begin // если находим,то заполняем
   StringGrid.RowCount:=i+1;

   StringGrid.Cells[0,i]:=IntToStr(i);
  StringGrid.Cells[1,i]:=current^.Inf.Vidal;
  StringGrid.Cells[2,i]:=current^.Inf.Poluchil;
  StringGrid.Cells[3,i]:=current^.Inf.Material;
  StringGrid.Cells[4,i]:=IntToStr(current^.Inf.Kolvo);
    i:=i+1;
   end;
    current:=current^.next;
   end;

  end;
end;


/// вывод списка в на экран
procedure TForm_Main.MenuItem_showClick(Sender: TObject);
 var current:Puzel;
   s:string;
   i:integer;
begin
   Memo.Clear;// очищаем memo от старых записей
  if Pfirst=nil then ShowMessage('Список Пуст')
  else begin
  current:=Pfirst; // ставим ук на первый эл


  while current<>nil do begin
    with current^.Inf do begin
      s:=Format('%0:-60s %1:-60s %2:-50s %3:-4s',[vidal,poluchil,material,IntToStr(kolvo)]);
    end;
    Memo.Append(s);
    current:=current^.next; // переводим ук на следующий элемент
  end;

  StringGrid.Cells[0,0]:='Номер';
  StringGrid.Cells[1,0]:='Выдал';
  StringGrid.Cells[2,0]:='Получил';
  StringGrid.Cells[3,0]:='Материал';
  StringGrid.Cells[4,0]:='Кол-во';

  StringGrid.RowCount:=Size_Spisok(Pfirst)+1;

  current:=Pfirst;
  for i:=1 to Size_Spisok(Pfirst) do begin

    StringGrid.Cells[0,i]:=IntToStr(i);
    StringGrid.Cells[1,i]:=current^.Inf.Vidal;
    StringGrid.Cells[2,i]:=current^.Inf.Poluchil;
    StringGrid.Cells[3,i]:=current^.Inf.Material;
    StringGrid.Cells[4,i]:=IntToStr(current^.Inf.Kolvo);

    current:=current^.next;
  end;

  end;
end;

/// перестановка списка по кол-ву выданых материалов от меньшего к большему
procedure TForm_Main.MenuItem_sort_kolvoClick(Sender: TObject);
begin
  if Pfirst=nil then ShowMessage('Список Пуст')
  else
   Sort_kolvo(Pfirst);
end;
/// сортировка по кол-ву
procedure TForm_Main.MenuItem_sort_materialClick(Sender: TObject);
begin
  if Pfirst=nil then ShowMessage('Список Пуст')
  else
  Sort_Material(Pfirst);
end;

/// сортировка в списке по алфавиту по фио получившего
procedure TForm_Main.MenuItem_sort_poluchilClick(Sender: TObject);
begin
  if Pfirst=nil then ShowMessage('Список Пуст')
  else
  Sort_Poluchil(Pfirst);
end;

/// сортировка в списке по алфавиту по фио выдающего
procedure TForm_Main.MenuItem_sort_vidalClick(Sender: TObject);
begin
  if Pfirst=nil then ShowMessage('Список Пуст')
  else
 Sort_Vidal ( Pfirst);
end;

end.
