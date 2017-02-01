unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,WinInet,TlHelp32, Vcl.ExtCtrls,shellapi,
  Vcl.StdCtrls,api;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    Button1: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  Form1: TForm1;
  IP:PAnsiChar;
  time2_switch: Boolean;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 if net_link then
  begin
    if (processExists('GoodSync.exe')or processExists('net.exe')) then
    begin
      if processExists('GoodSync.exe')and not(time2_switch) then
      begin
      Timer2.Interval:=5000;
      time2_switch:=True;
      end;
    end
    else
    begin
      net_close;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
net_close;
if paramstr(1)='-goodsync' then
begin
ShellExecute(Handle, 'open', PChar(ExtractFilePath(ParamStr(0))+'GoodSync.exe'), nil, nil, SW_HIDE);
ShellExecute(Handle, 'open', PChar(ExtractFilePath(ParamStr(0))+'KDaemon.exe'), nil, nil, SW_HIDE);
w_log('开机');
end;
if paramstr(1)='-KDaemon' then net_close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 if not(processExists('KDaemon.exe')) then ShellExecute(Handle, 'open', PChar(ExtractFilePath(ParamStr(0))+'KDaemon.exe'), nil, nil, SW_HIDE);
 if net_link then
  begin
    if not(log_net) then
    begin
      if not(processExists('net.exe')) then w_log('网络连通');
      log_net:=True;
    end;
    if processExists('GoodSync.exe')or processExists('net.exe') then
    begin
    if processExists('GoodSync.exe') then Timer2.Interval:=300000;
    end
    else net_close;
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  if not(processExists('net.exe')) then net_close;
  Timer2.Interval:=0;
end;

end.
