unit ExcelActivate;
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Win.ComObj, Winapi.ActiveX, TlHelp32, ShellAPI,
  Vcl.Samples.Spin;


var

  EXC: OleVariant;
  var W:variant;
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

 {
 function DIRDetect: string;    //???????????? ?????????? ? ????????? ?????
                                //??? ??????????  ?? ? ??????
 var

 Smb      : Char;
 i        : Integer;
 DIRECTORY: string;

 begin
   DIRECTORY:=' ';

        i:=2;
        DIRECTORY:=DIRFname[1];
        while (Smb<>'.') do
          begin
          Smb:=DIRFname[i];
          DIRECTORY:=DIRECTORY+Smb;
          i:=i+1;
          end;
       result:=DIRECTORY;

 end;

 }



{procedure TForm1.Button1Click(Sender: TObject);

begin

 // if ExistExcel then
 //               ShowMessage('Excel ?????????? ?? ?????? ??????????')

                ShowMessage('Excel ??????????? ?? ?????? ??????????');
   if RunExcel then
                ShowMessage('Excel ??????? ?? ?????? ??????????')
                else
                ShowMessage('Excel ?? ??????? ?? ?????? ??????????');
   RunExcel;


   if StartExcel then
   begin
    ShowMessage('??????? ???????');
   end;

end;

    }



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
  EXC.Documents.Open(DIRExName);  //????????? ????????, ????????? ? ???????
  ShowMessage(DIRExName);   //?????????? ?????????? ????????? ????? ? ?????? ? ???????????

end;

 {
procedure DIRDetect;

begin

end;
   }



begin






end.


