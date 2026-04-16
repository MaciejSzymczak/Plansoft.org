unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TForm1 = class(TForm)
    acl1_Edit: TEdit;
    ac1_ListBox: TListBox;
    ac1_Timer: TTimer;
    Edit2: TEdit;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure acl1_EditChange(Sender: TObject);
    procedure ac1_ListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ac1_ListBoxClick(Sender: TObject);
    procedure acl1_EditExit(Sender: TObject);
    procedure ac1_TimerTimer(Sender: TObject);
    procedure acl1_EditEnter(Sender: TObject);
    procedure ac1_ListBoxExit(Sender: TObject);
    procedure acl1_EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ac1_ListBoxDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


var
  Values: TStringList;
  ac1_skip : boolean;
  ac1_Count : Integer;
  ac1_Action : string;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Values := TStringList.Create;
  Values.Add('Ala ma kota');
  Values.Add('Kot ma Alê');
  Values.Add('Ala i kot');
  Values.Add('Pies i kot');
  Values.Add('Matematyka');

  ac1_Timer.Enabled := false;

  ac1_skip := false;
end;


function GetTextWithoutSelection(Edit: TEdit): string;
begin
  Result :=
    Copy(Edit.Text, 1, Edit.SelStart) +
    Copy(Edit.Text, Edit.SelStart + Edit.SelLength + 1, MaxInt);
end;



//----------------------------------------------------------
procedure TForm1.acl1_EditEnter(Sender: TObject);
begin
  ac1_Count := 1;
  ac1_Action := 'Change';
  ac1_Timer.Enabled := true;
end;

//----------------------------------------------------------
procedure TForm1.acl1_EditChange(Sender: TObject);
begin
  //No recurrency
  if ac1_skip then begin
    ac1_skip := false;
    exit;
  end;

  ac1_Count := 10;
  ac1_Action := 'Change';
  ac1_Timer.Enabled := true;
end;

//----------------------------------------------------------
procedure TForm1.acl1_EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key = 40 then begin
  ac1_Count := 1;
  ac1_Action := 'KeyDown';
  ac1_Timer.Enabled := true;
 end;
end;

//----------------------------------------------------------
procedure TForm1.acl1_EditExit(Sender: TObject);
begin
 if ac1_ListBox.Items.Count = 1 then begin
    ac1_Skip := true;
    acl1_Edit.Text := ac1_ListBox.Items[0];
   ac1_ListBox.Visible := False;
 end;

  ac1_Count := 1;
  ac1_Action := 'Exit';
  ac1_Timer.Enabled := true;
end;


//----------------------------------------------------------
procedure TForm1.ac1_ListBoxClick(Sender: TObject);
begin
  if ac1_ListBox.ItemIndex <> -1 then begin
    ac1_skip := true;
    acl1_Edit.Text := ac1_ListBox.Items[ac1_ListBox.ItemIndex];
  end;
  //ListBox1.Visible := False;
end;

//----------------------------------------------------------
procedure TForm1.ac1_ListBoxDblClick(Sender: TObject);
begin
  ac1_Count := 1;
  ac1_Action := 'Complete';
  ac1_Timer.Enabled := true;
end;

//----------------------------------------------------------
procedure TForm1.ac1_ListBoxExit(Sender: TObject);
begin
  ac1_Count := 1;
  ac1_Action := 'Complete';
  ac1_Timer.Enabled := true;
end;


//----------------------------------------------------------
procedure TForm1.ac1_ListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  s, search: string;
  p: Integer;
begin
  with ac1_ListBox.Canvas do
  begin
    FillRect(Rect);
    s := ac1_ListBox.Items[Index];

    if activeControl = ac1_ListBox  then begin
      TextOut(Rect.Left + 2, Rect.Top, s);
      exit;
    end;

    search := LowerCase(GetTextWithoutSelection(acl1_Edit));

    p := Pos(search, LowerCase(s));

    if p > 0 then
    begin
      TextOut(Rect.Left + 2, Rect.Top, Copy(s,1,p-1));

      Brush.Color := clYellow;


      TextOut(Rect.Left + 2 + TextWidth(Copy(s,1,p-1)),
              Rect.Top,
              Copy(s,p,Length(search)));

      Brush.Color := clWindow;
      TextOut(Rect.Left + 2 + TextWidth(Copy(s,1,p-1)+Copy(s,p,Length(search))),
              Rect.Top,
              Copy(s,p+Length(search),Length(s)));
    end
    else
      TextOut(Rect.Left + 2, Rect.Top, s);
  end;
end;

//----------------------------------------------------------
procedure TForm1.ac1_TimerTimer(Sender: TObject);
var
  s: String;
  success : boolean;
  matches : integer;

  procedure showList (focusAllowed : boolean);
  var i: Integer;
  begin
		  //show list
		  ac1_ListBox.Items.Clear;
		  s := LowerCase(GetTextWithoutSelection(acl1_Edit));

		  if s = '' then
		  begin
			ac1_ListBox.Visible := False;
			Exit;
		  end;

		  // *** tutaj pobierz Values z bazy dabych ***
		  for i := 0 to Values.Count - 1 do
			if Pos(s, LowerCase(Values[i])) > 0 then
			  ac1_ListBox.Items.Add(Values[i]);


		  ac1_ListBox.Visible := ac1_ListBox.Items.Count > 1;

		  if ac1_ListBox.Visible then
		  begin
			ac1_ListBox.BringToFront;
			ac1_ListBox.Left := acl1_Edit.Left;
			ac1_ListBox.Top := acl1_Edit.Top + acl1_Edit.Height;
			ac1_ListBox.Width := acl1_Edit.Width;
		  end;


		  //auto complete
		  s := LowerCase(acl1_Edit.Text);

		  success := false;

		  matches := 0;
		  for i := 0 to Values.Count - 1 do
		   if Pos(s, LowerCase(Values[i])) =1 then
		   begin
			 matches := matches + 1;
		   end;

		  if matches = 1 then begin
			for i := 0 to Values.Count - 1 do
			 if Pos(s, LowerCase(Values[i])) =1 then
			 begin
			   ac1_skip := true;
			   acl1_Edit.Text := Values[i];
         if focusAllowed then begin
			     acl1_Edit.SetFocus;
			     acl1_Edit.SelStart := Length(s);
			     acl1_Edit.SelLength := Length(Values[i]) - Length(s);
         end;
			   success := true;
			   Break;
			end;
		  end;

		  if success = false then begin
			matches := 0;
			for i := 0 to Values.Count - 1 do
			 if Pos(s, LowerCase(Values[i])) >0 then
			 begin
			   matches := matches +1;
			 end;

			if matches = 1 then
			for i := 0 to Values.Count - 1 do
			 if Pos(s, LowerCase(Values[i])) >0 then
			 begin
			   ac1_skip := true;
			   acl1_Edit.Text := Values[i];
			   success := true;
			   Break;
			 end;

       //force user to enter correct value
       //if focusAllowed=false and success=false then begin
       // acl1_Edit.SetFocus;
       // acl1_Edit.SelStart := 1;
       // acl1_Edit.SelLength := 1;
       //end;

		  end;
  end;

begin

  ac1_Count := ac1_Count - 1;
  if ac1_Count = 0 then begin
    ac1_Timer.Enabled := false;


  if ac1_Action = 'Complete' then begin
    ac1_ListBox.Visible := false;
    exit;
  end;

  if ac1_Action = 'Exit' then begin
    showList(false);
    if activecontrol <> ac1_ListBox then
       ac1_ListBox.Visible := false;
    exit;
  end;

  if ac1_Action = 'KeyDown' then begin
    if ac1_ListBox.Visible  then begin
       ActiveControl := ac1_ListBox;
       if ac1_ListBox.ItemIndex = -1 then ac1_ListBox.ItemIndex := 0;
       ac1_ListBoxClick(nil);
     end;
    exit;
  end;

  showList(true);

  end; //if ac1_Count = 0 then begin
end;

// !!!TO DO!!!
// wypuszcza z pola nawet ja jest zla wartosc
// wpisz kod i stralka z dol - zle dziala

end.
