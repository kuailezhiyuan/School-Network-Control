unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,TlHelp32, Vcl.ExtCtrls,SHELLAPI,WinInet;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Button1: TButton;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  IP,MAC:PAnsiChar;
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
ShowMessage(ExtractFilePath(ParamStr(0))+'Guardian.exe');
end;

procedure net_open;
begin
IP:='netsh interface ip set address name="本地连接" source=dhcp';
WinExec(IP,SW_Hide);
MAC:='netsh interface ip set dns "本地连接" static 114.114.114.114 primary';
WinExec(mac,SW_Hide);
end;

procedure net_close;
begin
IP:='netsh interface ip set address name="本地连接" source=static 192.1.1.188  255.255.255.0 192.1.1.1 1';
WinExec(IP,SW_Hide);
MAC:='netsh interface ip set dns "本地连接" static 127.0.0.1 primary';
WinExec(mac,SW_Hide);
end;

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
if InternetCheckConnection('http://www.baidu.com', 1, 0) then
  net_link:=True
else
  net_link:=False
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
if paramstr(1)='-opennet' then Timer1.Interval:=1000
else
begin
net_close;
sleep(1000);
ExitProcess(0);
Application.Terminate;
end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
if processExists('Guardian.exe') then
begin
net_open;
Timer1.Interval:=0;
Timer2.Interval:=1000;
end
else
begin
ShellExecute(self.Handle,'open',PWideChar(ExtractFilePath(ParamStr(0))+'Guardian.exe'), nil,   nil,   SW_NORMAL);
Sleep(1000);
end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
if net_link then
begin
  Timer2.Interval:=0;
  ExitProcess(0);
  Application.Terminate;
end;
end;

end.
