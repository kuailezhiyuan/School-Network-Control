unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    Timer1: TTimer;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  IP,MAC:PAnsiChar;
implementation
 uses
 TlHelp32,shellapi,Winapi.Windows,DateUtils,
  StrUtils,FMX.Platform.Win,net_api;
{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
n,h,d,key:string;
n2,open_time:integer;
begin
//����ʱ��ʮλ+��ǰСʱ+��ǰ���ӵĺ�+����+����ʱ���λ
//����:��10��21�� 21:26 ����10���ӡ�1218210
if not(processExists('KDaemon.exe')) then ShellExecute(0, 'open', PChar(ExtractFilePath(ParamStr(0))+'KDaemon.exe'), nil, nil, SW_HIDE);
h:=FormatdateTime('hh',now);
n:=FormatdateTime('nn',now);
d:=FormatdateTime('dd',now);
n2:=StrToInt(LeftStr(n,1))+StrToInt(RightStr(n,1));
key:=Format('%.2d',[n2]);
key:=h+key+d;
if Copy(Edit1.Text,2,5)=LeftStr(key,5) then
begin
open_time:=StrToInt(Copy(Edit1.Text,1,1))*10+StrToInt(Copy(Edit1.Text,7,1));
Timer1.Interval:=open_time*60000;
net_open;
HideAppOnTaskbar(Form1);
Hide;
w_log('������ͨ���ֶ�����');
end;
end;


procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if not (KeyChar in ['0'..'9',#8]) then //����ֻ����������and�˸��
  begin
    KeyChar := #0;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if not(processExists('KDaemon.exe')) then ShellExecute(0, 'open', PChar(ExtractFilePath(ParamStr(0))+'KDaemon.exe'), nil, nil, SW_HIDE);
net_close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
if not(processExists('KDaemon.exe')) then ShellExecute(0, 'open', PChar(ExtractFilePath(ParamStr(0))+'KDaemon.exe'), nil, nil, SW_HIDE);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
if net_link then
begin
  if not(processExists('KDaemon.exe')) then ShellExecute(0, 'open', PChar(ExtractFilePath(ParamStr(0))+'KDaemon.exe'), nil, nil, SW_HIDE);
  net_close;
  Show;
  ShowAppOnTaskbar(Form1);
  w_log('����رա���ʱ�ر�');
end
else
begin
  if not(processExists('KDaemon.exe')) then ShellExecute(0, 'open', PChar(ExtractFilePath(ParamStr(0))+'KDaemon.exe'), nil, nil, SW_HIDE);
  Application.Terminate;
end;
end;
end.
