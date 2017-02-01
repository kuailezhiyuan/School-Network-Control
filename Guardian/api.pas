unit api;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,WinInet,TlHelp32, Vcl.ExtCtrls,shellapi,
  Vcl.StdCtrls;

function processExists(exeFileName: string): Boolean;
function net_link: Boolean;
procedure net_close;
procedure w_log(s:string);
var
log_net: Boolean;
implementation

function processExists(exeFileName: string): Boolean;

var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function net_link: Boolean;
begin
if InternetCheckConnection('http://www.baidu.com/', 1, 0) then
  net_link:=True
else
  net_link:=False
end;

procedure net_close;
var
IP,MAC:PAnsiChar;
begin
IP:='netsh interface ip set address name="本地连接" source=static 192.1.1.188  255.255.255.0 192.1.1.1 1';
WinExec(IP,SW_Hide);
MAC:='netsh interface ip set dns "本地连接" static 127.0.0.1 primary';
WinExec(mac,SW_Hide);
w_log('网络关闭');
log_net:=False;
end;

procedure w_log(s:string);
var
List: TStringList;
log:string;
begin
List := TStringList.Create;
if FileExists(ExtractFilePath(ParamStr(0))+'log.klzy') then List.LoadFromFile(ExtractFilePath(ParamStr(0))+'log.klzy');{打开}
List.Add('['+formatdatetime('yyyy-MM-dd HH:mm:ss zzz', Now()) + ']:'+s);
list.SaveToFile(ExtractFilePath(ParamStr(0))+'log.klzy');
List.Clear;
list.Free;
end;

end.
