unit WordActivate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Win.ComObj, Winapi.ActiveX, TlHelp32, ShellAPI,
  Vcl.Samples.Spin;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  WRD,Book: OleVariant;
  EXC,MyRange,MyRange2: OleVariant;
  var W:variant;
  var DIRFName: string;
  var DIRName: string;
   var DIRExName: string;
implementation

{$R *.dfm}


function GetProcessByEXE(exename: string): THandle;
var
  hSnapshoot: THandle;
  pe32: TProcessEntry32;
begin
  Result:= 0;
  hSnapshoot:= CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (hSnapshoot = 0) then Exit;
  pe32.dwSize:= SizeOf(TProcessEntry32);
  if (Process32First(hSnapshoot, pe32)) then
    repeat
      if (pe32.szExeFile = exename) then
      begin
        Result:= pe32.th32ProcessID;
        exit;
      end;
    until not Process32Next(hSnapshoot, pe32);
end;


function  ExistExcel: Boolean;
   var
   ID:TCLSID;
   Res: HRESULT;
begin
    Res:= CLSIDFromProgID('Excel.Application',ID);
     if Res=S_OK then
     Result:= True
     else
     Result:= False;
end;




function  ExistWORD: Boolean;
   var
   ID:TCLSID;
   Res: HRESULT;
begin
    Res:= CLSIDFromProgID('Word.Application',ID);
     if Res=S_OK then
     Result:= True
     else
     Result:= False;
end;



function RunExcel: Boolean;
begin

  if GetProcessByEXE('Excel.EXE')<>0 then

  begin
  EXC:=GetActiveOLEObject('Excel.Application');
  Result:=true;
  end
  else
  Result:= false;
  end;



function RunWORD: Boolean;
begin

  if GetProcessByEXE('WORD.EXE')<>0 then

  begin
  WRD:=GetActiveOLEObject('Word.Application');
  Result:=true;
  end
  else
  Result:= false;
  end;

  function StartExcel: boolean;
 begin
    if ExistExcel then
    begin
    if RunExcel=false then
    EXC:=CreateOleObject('Excel.Application');
    result:=True;
    end
    else
    begin
    ShowMessage('?????????? Excel ?? ?????????? ?? ?????? ?????????');
     result:=False;
    end;
 end;



 function StartWORD: boolean;
 begin
    if ExistWORD then
    begin
    if RunWORD=false then
    WRD:=CreateOleObject('Word.Application');
    result:=True;
    end
    else
    begin
    ShowMessage('?????????? WORD ?? ?????????? ?? ?????? ?????????');
     result:=False;
    end;
 end;


 function DIRDetect: string;    //???????????? ?????????? ? ????????? ?????
                                //??? ??????????  ?? ? ??????
 var

 Smb      : Char;
 i        : Integer;
 DIRECTORY: string;

 begin
   DIRECTORY:=' ';
    {len:=Length(DIRFName);

       for I := 1 to len do
          begin
           Smb:=DIRFname[i];
           if Smb='.' then

          end;
      }
        i:=2;
        DIRECTORY:=DIRFname[1];
        while (Smb<>'.') do
          begin
          Smb:=DIRFname[i];
          DIRECTORY:=DIRECTORY+Smb;
          i:=i+1;
          end;
       result:=DIRECTORY;


  {  if ExistWORD then
    begin
    if RunWORD=false then
    WRD:=CreateOleObject('Word.Application');
    result:=True;
    end
    else
    begin
    ShowMessage('?????????? WORD ?? ?????????? ?? ?????? ?????????');
     result:=False;
    end;
  }
 end;


 procedure ActExcelOpenDoc;
begin
  //if not OpenDialog1.Execute then Exit;  //??? ??????????? ?????? ?????? ?????, ? ???? ???????????? ????? "Cancel", ?? ???????
 // W:=CreateOLEObject('Excel.Application');  //??????????? ?????? ?????????????
  if StartExcel then
   begin
    ShowMessage('??????? Excel ???????');
   end;

  EXC.visible:=true;     //?????? Excel ???????
  DIRExName:=DIRName+'xlsx';
  EXC.WorkBooks.Open(DIRExName);  //????????? ????????, ????????? ? ???????
 // EXC.Range['B2']:='??????!';   //????? ???? ?? ??????
 // MyRange:=EXC.Range['A1:g4'];
 // MyRange.Copy;

    MyRange:=EXC.Range['A2'];
    MyRange.Copy;
    MyRange2:=EXC.Range['h1'];
   // MyRange2.Paste;
     EXC.Paste;

  ShowMessage(DIRExName);   //?????????? ?????????? ????????? ????? ? ?????? ? ???????????

end;



procedure TForm1.Button1Click(Sender: TObject);

begin
 {
  if ExistWORD then
                ShowMessage('WORD ?????????? ?? ?????? ??????????')
                else
                ShowMessage('WORD ??????????? ?? ?????? ??????????');
   if RunWORD then
                ShowMessage('WORD ??????? ?? ?????? ??????????')
                else
                ShowMessage('WORD ?? ??????? ?? ?????? ??????????');
   RunWORD;
     }

   if StartWORD then
   begin
    ShowMessage('??????? ???????');
   end;

end;





procedure TForm1.Button2Click(Sender: TObject);
begin
  if not OpenDialog1.Execute then Exit;  //??? ??????????? ?????? ?????? ?????, ? ???? ???????????? ????? "Cancel", ?? ???????
 // W:=CreateOLEObject('Word.Application');  //??????????? ?????? ?????????????
  WRD.visible:=true;     //?????? ???? ???????
  WRD.Documents.Open(OpenDialog1.FileName);  //????????? ????????, ????????? ? ???????
  DIRFName := OpenDialog1.FileName;
  ShowMessage(DIRFName);   //?????????? ?????????? ????????? ????? ? ?????? ? ???????????
  DIRName:= DIRDetect;
  ShowMessage(DIRName);
  //***********************************????????? ? ????????? EXCEL ?? ???????? ??????????************************
  ActExcelOpenDoc;
  //EXC.Range[EXC.Cells[1, 1], EXC.Cells[5, 3]].Select;

  Book:=WRD.Documents.Open(OpenDialog1.FileName);
  Book.Range(1,1).Paste;



end;

 {
procedure DIRDetect;

begin

end;
   }



begin






end.


