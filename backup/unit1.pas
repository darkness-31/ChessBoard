unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    CalculateFigure: TButton;
    Label1: TLabel;
    procedure CalculateFigureClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BoardButtonClick(sender: TObject);
    function  CheckModLadia(const figure: TButton): Boolean;
    function CheckModFerzin(const figure: TButton): Boolean;
    function FindToIndex(arr:Array of string; str:string):integer;
  private

  public

  end;

var
  Form1: TForm1;
const
  TopChess : Array [1..8] of string = ('A','B','C','D','E','F','G','H');
  Ladia : string = '';
  Ferzin : string = '';
  King: string = '';
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  column, row : integer;
  TempLabelNameChess : TLabel;
  TempButtonFigure : TButton;
begin
  for column := 1 to 8 do
  begin
    TempLabelNameChess := TLabel.Create(self);
    TempLabelNameChess.Name := 'TopBoard' + IntToStr(column);
    TempLabelNameChess.Caption := TopChess[column];
    TempLabelNameChess.Left := column * 32 + 13;
    TempLabelNameChess.Top := 10;
    TempLabelNameChess.Visible := true;
    TempLabelNameChess.Parent := self;
  end;
  for row := 1 to 8 do
  begin
    TempLabelNameChess := TLabel.Create(self);
    TempLabelNameChess.Name := 'LeftBoard' + IntToStr(row);
    TempLabelNameChess.Caption := IntToStr(row);
    TempLabelNameChess.Left := 10;
    TempLabelNameChess.Top := row * 32 + 10;
    TempLabelNameChess.Visible := true;
    TempLabelNameChess.Parent := self;
  end;

  for row := 1 to 8 do
  for column := 1 to 8 do
  begin
    TempButtonFigure := TButton.Create(self);
    TempButtonFigure.Parent := self;
    TempButtonFigure.Width:=32;
    TempButtonFigure.Height:=32;
    TempButtonFigure.Top:= row * 32;
    TempButtonFigure.Left:= column * 32;
    TempButtonFigure.Name := TopChess[column] + IntToStr(row);
    TempButtonFigure.Caption := '';
    TempButtonFigure.OnClick:=@BoardButtonClick;
  end;
end;

procedure TForm1.CalculateFigureClick(Sender: TObject);
var
  L,F:TButton;
  i:integer;
  Temp:string;
begin
      if (King = '') then Temp += 'Нет Короля ';
      if (Ferzin = '') and (Ladia = '') then Temp += 'Нет чёрных фигур ';

      if not (Ladia = '') then
      begin                                
        L := FindComponent(Ladia) as TButton;         
        if CheckModLadia(L) then Temp += 'Шах от ладьи ';
      end;
      if not (Ferzin = '') then
      begin
        F := FindComponent(Ferzin) as TButton;
        if CheckModFerzin(F) then Temp += 'Шах от слона ';
      end;

      if Temp = '' then Temp += 'Нет шаха';

      Label1.Caption := Temp;
end;

procedure TForm1.BoardButtonClick(sender: TObject);
const
  cnt: integer = 1;
  figure: Array[1..4] of string = ('К', 'Л', 'Ф', '');
var
  but: TButton;
begin
  but := sender as TButton;
  if cnt = 5 then cnt := 1;
  if not (King   = '') and (cnt = 1) then cnt += 1;
  if not (Ladia  = '') and (cnt = 2) then cnt += 1;
  if not (Ferzin = '') and (cnt = 3) then cnt += 1;

  if but.Name = Ladia then Ladia := ''
  else if but.Name = King then King := ''
  else if but.Name = Ferzin then Ferzin := '';

  but.Caption := figure[cnt];

  if figure[1] = but.Caption then King := but.Name
  else if figure[2] = but.Caption then Ladia := but.Name
  else if figure[3] = but.Caption then Ferzin := but.Name;

  cnt += 1;
end;

function TForm1.CheckModLadia(const figure: TButton): Boolean;
var
  temp,column:string;
  row,i,TCi:integer;
  cells: array[1..16] of string;
  answer:boolean = False;
  tempBut: TButton;
begin
  column := figure.Name[1];
  row := StrToInt(figure.Name[2]);
  TCi := FindToIndex(TopChess,column);

  for i:= row+1 to 8 do
  begin
    if (column+IntToStr(i)) = Ferzin then break;
    cells[i] := column + IntToStr(i);
  end;

  i:=row-1;
  while i > 0 do
  begin
    if (column+IntToStr(i)=Ferzin) then break;
    cells[i] := column + IntToStr(i);
    i-=1;
  end;

  for i:=TCi+2 to 8 do
  begin
    if TopChess[i]+IntToStr(row) = Ferzin then break;
    cells[8+i] := TopChess[i] + IntToStr(row);
  end;

  i:=TCi;
  while i > 0 do
  begin
    if TopChess[i]+IntToStr(row) = Ferzin then break;
    cells[8+i] := TopChess[i] + IntToStr(row);
    i-=1;
  end;

  for i:= 1 to length(cells) do
  begin
    if cells[i] = '' then continue;
    tempBut := FindComponent(cells[i]) as TButton;
    if tempBut.Name = King then answer := True;
  end;

  exit(answer);
end;
function TForm1.CheckModFerzin(const figure: TButton): Boolean;
var      
  column:string;
  row,TCi,i:integer;
  cells: array[1..16] of string;
  answer: boolean = False;
  tempBut: TButton;
begin
  column := figure.Name[1];
  row := StrToInt(figure.Name[2]);

  //нижняя правая \
  for i:=row+1 to 8 do
  begin
    TCi := FindToIndex(TopChess,column) + (i - row) + 1;
    if (length(TopChess) < TCi) or
       (TopChess[TCi] + IntToStr(i) = Ladia) then break;
    cells[i] := TopChess[TCi] + IntToStr(i);
  end;
  //Верхняя правая /
  i:=row-1;
  while i <= 8 do
  begin
    TCi := FindToIndex(TopChess,column) + (row - i) + 1;
    if (i <= 0) or
       (Length(TopChess) < TCi) or
       (TopChess[TCi] + IntToStr(i) = Ladia) then break;
    cells[i] := TopChess[TCi] + IntToStr(i);
    i -= 1;
  end;
  //Верхняя левая \
  i:=row-1;
  while i <= 8 do
  begin
    TCi := FindToIndex(TopChess,column) - (row - i) + 1;
    if (i <= 0) or
       (TCi <= 0) or
       (TopChess[TCi] + IntToStr(i) = Ladia) then break;
    cells[i+8] := TopChess[TCi] + IntToStr(i);
    i-=1;
  end;
  //Нижняя левая /
  for i:=row+1 to 8 do
  begin
    TCi := FindToIndex(TopChess,column) - (i - row-1);
    if (i > 8) or
       (TCi <= 0) or
       (TopChess[TCi] + IntToStr(i) = Ladia) then break;
    cells[i+8]:= TopChess[TCi] + IntToStr(i);
  end;

  for i:= 1 to length(cells) do
  begin
    if cells[i] = '' then continue;
    tempBut := FindComponent(cells[i]) as TButton;
    if tempBut.Name = King then answer := True;
  end;

  Exit(answer);
end;

function TForm1.FindToIndex(arr:Array of string;str:string):integer;
var
  i : integer;
begin
    for i:=0 to Length(arr) do
    begin
      if arr[i] = str then Exit(i);
    end;
end;

end.
