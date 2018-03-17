unit MainF;

interface

uses
  Windows,
  SysUtils,
  ShellAPI,
  Registry,
  MWpasU,
  Messages,
  KeyCodeU,
  IniFiles,
  Forms;

type
  TRunEntry = record
    Atom   : ATOM;
    Path   : String;
    Params : String;
  end;
  TRunEntries = array of TRunEntry;

  TMainForm = class(TForm)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    FConnectAtom    : ATOM;
    FDisconnectAtom : ATOM;
    FEndAtom        : ATOM;
    FInstance       : String;
    FQuitAtom       : ATOM;
    FReconnectAtom  : ATOM;
    FRunEntries     : TRunEntries;

    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure WMQueryEndSession(var Msg: TWMQueryEndSession); message WM_QUERYENDSESSION;

    procedure AddToAutostart;
    procedure RegisterHotkeys;
    procedure RemoveFromAutostart;
    procedure UnregisterHotkeys;
  public
    { Public-Deklarationen }
  end;

var
  MainForm : TMainForm;

implementation

{$R *.dfm}

{ TMainForm }

procedure TMainForm.WMHotKey(var Msg : TWMHotKey);
  procedure SendString(const AString : String);
  var
    LAccess  : TMWconnAccessMode;
    LFile    : THandle;
    LMapping : PMWconnIO;
  begin
    if (IsMWconnRunning(FInstance)) then
    begin
      LAccess := OpenMWconnIO(LFile, LMapping, FInstance);
      try
        if ((LAccess = mwamAll) or (LAccess = mwamWrite)) then
        begin
          ZeroMemory(@LMapping^.Command[0], Length(LMapping^.Command));
          CopyMemory(@LMapping^.Command[0], @AString[1], Length(AString));
        end;
      finally
        CloseMWconnIO(LFile, LMapping);
      end;
    end;
  end;

var
  LIndex : LongInt;
begin
  if (Msg.HotKey = FConnectAtom) then
    SendString(MWconn_Connect);

  if (Msg.HotKey = FDisconnectAtom) then
    SendString(MWconn_Disconnect);

  if (Msg.HotKey = FEndAtom) then
    SendString(MWconn_End);

  if (Msg.HotKey = FQuitAtom) then
  begin
    RemoveFromAutostart;
    Close;
  end;

  if (Msg.HotKey = FReconnectAtom) then
    SendString(MWconn_Reconnect);

  for LIndex := 0 to Pred(Length(FRunEntries)) do
  begin
    if (Msg.HotKey = FRunEntries[LIndex].Atom) then
    begin
      if (Trim(FRunEntries[LIndex].Path) <> '') then
        ShellExecute(Handle, 'open', PChar(FRunEntries[LIndex].Path),
                     PChar(FRunEntries[LIndex].Params),
                     PChar(ExtractFilePath(FRunEntries[LIndex].Path)), SW_SHOWNORMAL);

      Break;
    end;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  UnregisterHotkeys;
end;

procedure TMainForm.AddToAutostart;
var
  LRegistry : TRegistry;
begin
  LRegistry := TRegistry.Create(KEY_ALL_ACCESS);
  try
    LRegistry.RootKey := HKEY_CURRENT_USER;

    if LRegistry.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', false) then
    begin
      try
        LRegistry.WriteString('MWhotkey', Application.ExeName);
      finally
        LRegistry.CloseKey;
      end;
    end;
  finally
    LRegistry.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FConnectAtom    := 0;
  FDisconnectAtom := 0;
  FEndAtom        := 0;
  FQuitAtom       := 0;
  FReconnectAtom  := 0;
  SetLength(FRunEntries, 0);

  AddToAutostart;
  RegisterHotkeys;
end;

procedure TMainForm.RegisterHotkeys;
  function DoRegister(const AString : String) : ATOM;
  var
    LHotkey : THotkey;
  begin
    Result := 0;

    try
      LHotkey := StringToHotkey(AString);

      Result := GlobalAddAtom(PChar('MWhotkey: ' + LHotkey.Value));
      if (Result > 0) then
        RegisterHotKey(Handle, Result, LHotkey.Modifiers, LHotkey.Key);
    except
      // duplicate key or no key
    end;
  end;
var
  LAtom    : ATOM;
  LCount   : Byte;
  LIniFile : TIniFile;
begin
  UnregisterHotkeys;

  LIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    // MWconn shortcut options
    FConnectAtom    := DoRegister(LIniFile.ReadString('MWconn', 'Connect',    'CTRL+ALT+C'));
    FDisconnectAtom := DoRegister(LIniFile.ReadString('MWconn', 'Disconnect', 'CTRL+ALT+D'));
    FEndAtom        := DoRegister(LIniFile.ReadString('MWconn', 'End',        'CTRL+ALT+E'));
    FReconnectAtom  := DoRegister(LIniFile.ReadString('MWconn', 'Reconnect',  'CTRL+ALT+R'));
    // MWconn general options
    FInstance := LIniFile.ReadString('MWconn', 'Instance', '');

    // MWhotkey shortcut options
    FQuitAtom := DoRegister(LIniFile.ReadString('MWhotkey', 'Quit', 'CTRL+ALT+END'));

    // Run shortcut options
    LCount := 1;
    while (LIniFile.ValueExists('Run', 'Hotkey' + IntToStr(LCount)) and
           LIniFile.ValueExists('Run', 'Path' + IntToStr(LCount))) do
    begin
      LAtom := DoRegister(LIniFile.ReadString('Run', 'Hotkey' + IntToStr(LCount), ''));
      if (LAtom > 0) then
      begin
        SetLength(FRunEntries, Succ(Length(FRunEntries)));
        FRunEntries[High(FRunEntries)].Atom   := LAtom;
        FRunEntries[High(FRunEntries)].Path   := Trim(LIniFile.ReadString('Run', 'Path' + IntToStr(LCount),   ''));
        FRunEntries[High(FRunEntries)].Params := Trim(LIniFile.ReadString('Run', 'Params' + IntToStr(LCount), ''));
      end;

      Inc(LCount);
    end;
  finally
    LIniFile.Free;
  end;
end;

procedure TMainForm.UnregisterHotkeys;
var
  LIndex : LongInt;
begin
  if (FConnectAtom > 0) then
  begin
    UnRegisterHotKey(Handle, FConnectAtom);
    GlobalDeleteAtom(FConnectAtom);
    FConnectAtom := 0;
  end;

  if (FDisconnectAtom > 0) then
  begin
    UnRegisterHotKey(Handle, FDisconnectAtom);
    GlobalDeleteAtom(FDisconnectAtom);
    FDisconnectAtom := 0;
  end;

  if (FEndAtom > 0) then
  begin
    UnRegisterHotKey(Handle, FEndAtom);
    GlobalDeleteAtom(FEndAtom);
    FEndAtom := 0;
  end;

  if (FQuitAtom > 0) then
  begin
    UnRegisterHotKey(Handle, FQuitAtom);
    GlobalDeleteAtom(FQuitAtom);
    FQuitAtom := 0;
  end;

  if (FReconnectAtom > 0) then
  begin
    UnRegisterHotKey(Handle, FReconnectAtom);
    GlobalDeleteAtom(FReconnectAtom);
    FReconnectAtom := 0;
  end;

  for LIndex := 0 to Pred(Length(FRunEntries)) do
  begin
    if (FRunEntries[LIndex].Atom > 0) then
    begin
      UnRegisterHotKey(Handle, FRunEntries[LIndex].Atom);
      GlobalDeleteAtom(FRunEntries[LIndex].Atom);
    end;
  end;
  SetLength(FRunEntries, 0);
end;

procedure TMainForm.RemoveFromAutostart;
var
  LRegistry : TRegistry;
begin
  LRegistry := TRegistry.Create(KEY_ALL_ACCESS);
  try
    LRegistry.RootKey := HKEY_CURRENT_USER;

    if LRegistry.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', false) then
    begin
      try
        if LRegistry.ValueExists('MWhotkey') then
          LRegistry.DeleteValue('MWhotkey');
      finally
        LRegistry.CloseKey;
      end;
    end;
  finally
    LRegistry.Free;
  end;
end;

procedure TMainForm.WMQueryEndSession(var Msg : TWMQueryEndSession);
begin
  // do not interrupt Windows shutdown
  Msg.Result := 1;

  Close;
end;

end.
