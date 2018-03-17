unit KeyCodeU;

interface

uses
  Windows,
  SysUtils;

type
  THotkey = record
    Key       : Word;
    Modifiers : Word;
    Value     : String;
  end;

  TStringArray = array of String;

function StringToHotkey(AString : String) : THotkey;

implementation

function StringToHotkey(AString : String) : THotkey;
  function SeperateString(AString : String; const ASeperator : Char) : TStringArray;
  begin
    SetLength(Result, 0);

    AString := AnsiLowerCase(Trim(AString));
    while (Pos(ASeperator, AString) > 0) do
    begin
      SetLength(Result, Succ(Length(Result)));
      Result[High(Result)] := Trim(Copy(AString, 1, Pred(Pos(ASeperator, AString))));
      Delete(AString, 1, Pos(ASeperator, AString));
    end;

    if (Length(Trim(AString)) > 0) then
    begin
      SetLength(Result, Succ(Length(Result)));
      Result[High(Result)] := Trim(AString);
    end;
  end;

type
  TEntry = record
    ID    : String;
    IsKey : Boolean;
    Value : Word;
  end;
const
  CEntries : array [0..140] of TEntry = ((ID : 'alt';        IsKey : false; Value : MOD_ALT),
                                         (ID : 'ctrl';       IsKey : false; Value : MOD_CONTROL),
                                         (ID : 'shift';      IsKey : false; Value : MOD_SHIFT),
                                         (ID : 'win';        IsKey : false; Value : MOD_WIN),
                                         (ID : 'lbutton';    IsKey : true;  Value : VK_LBUTTON),
                                         (ID : 'rbutton';    IsKey : true;  Value : VK_RBUTTON),
                                         (ID : 'cancel';     IsKey : true;  Value : VK_CANCEL),
                                         (ID : 'mbutton';    IsKey : true;  Value : VK_MBUTTON),
                                         (ID : 'back';       IsKey : true;  Value : VK_BACK),
                                         (ID : 'tab';        IsKey : true;  Value : VK_TAB),
                                         (ID : 'clear';      IsKey : true;  Value : VK_CLEAR),
                                         (ID : 'return';     IsKey : true;  Value : VK_RETURN),
                                         (ID : 'shift';      IsKey : true;  Value : VK_SHIFT ),
                                         (ID : 'control';    IsKey : true;  Value : VK_CONTROL),
                                         (ID : 'menu';       IsKey : true;  Value : VK_MENU),
                                         (ID : 'pause';      IsKey : true;  Value : VK_PAUSE),
                                         (ID : 'capital';    IsKey : true;  Value : VK_CAPITAL),
                                         (ID : 'kana';       IsKey : true;  Value : VK_KANA),
                                         (ID : 'hangul';     IsKey : true;  Value : VK_HANGUL),
                                         (ID : 'junja';      IsKey : true;  Value : VK_JUNJA),
                                         (ID : 'final';      IsKey : true;  Value : VK_FINAL),
                                         (ID : 'hanja';      IsKey : true;  Value : VK_HANJA),
                                         (ID : 'kanji';      IsKey : true;  Value : VK_KANJI),
                                         (ID : 'convert';    IsKey : true;  Value : VK_CONVERT),
                                         (ID : 'nonconvert'; IsKey : true;  Value : VK_NONCONVERT),
                                         (ID : 'accept';     IsKey : true;  Value : VK_ACCEPT),
                                         (ID : 'modechange'; IsKey : true;  Value : VK_MODECHANGE),
                                         (ID : 'escape';     IsKey : true;  Value : VK_ESCAPE),
                                         (ID : 'space';      IsKey : true;  Value : VK_SPACE ),
                                         (ID : 'prior';      IsKey : true;  Value : VK_PRIOR),
                                         (ID : 'next';       IsKey : true;  Value : VK_NEXT),
                                         (ID : 'end';        IsKey : true;  Value : VK_END),
                                         (ID : 'home';       IsKey : true;  Value : VK_HOME),
                                         (ID : 'left';       IsKey : true;  Value : VK_LEFT),
                                         (ID : 'up';         IsKey : true;  Value : VK_UP),
                                         (ID : 'right';      IsKey : true;  Value : VK_RIGHT),
                                         (ID : 'down';       IsKey : true;  Value : VK_DOWN),
                                         (ID : 'select';     IsKey : true;  Value : VK_SELECT),
                                         (ID : 'print';      IsKey : true;  Value : VK_PRINT),
                                         (ID : 'execute';    IsKey : true;  Value : VK_EXECUTE),
                                         (ID : 'snapshot';   IsKey : true;  Value : VK_SNAPSHOT),
                                         (ID : 'insert';     IsKey : true;  Value : VK_INSERT),
                                         (ID : 'delete';     IsKey : true;  Value : VK_DELETE),
                                         (ID : 'help';       IsKey : true;  Value : VK_HELP),
                                         (ID : '0';          IsKey : true;  Value : Ord('0')),
                                         (ID : '1';          IsKey : true;  Value : Ord('1')),
                                         (ID : '2';          IsKey : true;  Value : Ord('2')),
                                         (ID : '3';          IsKey : true;  Value : Ord('3')),
                                         (ID : '4';          IsKey : true;  Value : Ord('4')),
                                         (ID : '5';          IsKey : true;  Value : Ord('5')),
                                         (ID : '6';          IsKey : true;  Value : Ord('6')),
                                         (ID : '7';          IsKey : true;  Value : Ord('7')),
                                         (ID : '8';          IsKey : true;  Value : Ord('8')),
                                         (ID : '9';          IsKey : true;  Value : Ord('9')),
                                         (ID : 'a';          IsKey : true;  Value : Ord('A')),
                                         (ID : 'b';          IsKey : true;  Value : Ord('B')),
                                         (ID : 'c';          IsKey : true;  Value : Ord('C')),
                                         (ID : 'd';          IsKey : true;  Value : Ord('D')),
                                         (ID : 'e';          IsKey : true;  Value : Ord('E')),
                                         (ID : 'f';          IsKey : true;  Value : Ord('F')),
                                         (ID : 'g';          IsKey : true;  Value : Ord('G')),
                                         (ID : 'h';          IsKey : true;  Value : Ord('H')),
                                         (ID : 'i';          IsKey : true;  Value : Ord('I')),
                                         (ID : 'j';          IsKey : true;  Value : Ord('J')),
                                         (ID : 'k';          IsKey : true;  Value : Ord('K')),
                                         (ID : 'l';          IsKey : true;  Value : Ord('L')),
                                         (ID : 'm';          IsKey : true;  Value : Ord('M')),
                                         (ID : 'n';          IsKey : true;  Value : Ord('N')),
                                         (ID : 'o';          IsKey : true;  Value : Ord('O')),
                                         (ID : 'p';          IsKey : true;  Value : Ord('P')),
                                         (ID : 'q';          IsKey : true;  Value : Ord('Q')),
                                         (ID : 'r';          IsKey : true;  Value : Ord('R')),
                                         (ID : 's';          IsKey : true;  Value : Ord('S')),
                                         (ID : 't';          IsKey : true;  Value : Ord('T')),
                                         (ID : 'u';          IsKey : true;  Value : Ord('U')),
                                         (ID : 'v';          IsKey : true;  Value : Ord('V')),
                                         (ID : 'w';          IsKey : true;  Value : Ord('W')),
                                         (ID : 'x';          IsKey : true;  Value : Ord('X')),
                                         (ID : 'y';          IsKey : true;  Value : Ord('Y')),
                                         (ID : 'z';          IsKey : true;  Value : Ord('Z')),
                                         (ID : 'lwin';       IsKey : true;  Value : VK_LWIN),
                                         (ID : 'rwin';       IsKey : true;  Value : VK_RWIN),
                                         (ID : 'apps';       IsKey : true;  Value : VK_APPS),
                                         (ID : 'numpad0';    IsKey : true;  Value : VK_NUMPAD0),
                                         (ID : 'numpad1';    IsKey : true;  Value : VK_NUMPAD1),
                                         (ID : 'numpad2';    IsKey : true;  Value : VK_NUMPAD2),
                                         (ID : 'numpad3';    IsKey : true;  Value : VK_NUMPAD3),
                                         (ID : 'numpad4';    IsKey : true;  Value : VK_NUMPAD4),
                                         (ID : 'numpad5';    IsKey : true;  Value : VK_NUMPAD5),
                                         (ID : 'numpad6';    IsKey : true;  Value : VK_NUMPAD6),
                                         (ID : 'numpad7';    IsKey : true;  Value : VK_NUMPAD7),
                                         (ID : 'numpad8';    IsKey : true;  Value : VK_NUMPAD8),
                                         (ID : 'numpad9';    IsKey : true;  Value : VK_NUMPAD9),
                                         (ID : 'multiply';   IsKey : true;  Value : VK_MULTIPLY),
                                         (ID : 'add';        IsKey : true;  Value : VK_ADD),
                                         (ID : 'separator';  IsKey : true;  Value : VK_SEPARATOR),
                                         (ID : 'subtract';   IsKey : true;  Value : VK_SUBTRACT),
                                         (ID : 'decimal';    IsKey : true;  Value : VK_DECIMAL),
                                         (ID : 'divide';     IsKey : true;  Value : VK_DIVIDE),
                                         (ID : 'f1';         IsKey : true;  Value : VK_F1),
                                         (ID : 'f2';         IsKey : true;  Value : VK_F2),
                                         (ID : 'f3';         IsKey : true;  Value : VK_F3),
                                         (ID : 'f4';         IsKey : true;  Value : VK_F4),
                                         (ID : 'f5';         IsKey : true;  Value : VK_F5),
                                         (ID : 'f6';         IsKey : true;  Value : VK_F6),
                                         (ID : 'f7';         IsKey : true;  Value : VK_F7),
                                         (ID : 'f8';         IsKey : true;  Value : VK_F8),
                                         (ID : 'f9';         IsKey : true;  Value : VK_F9),
                                         (ID : 'f10';        IsKey : true;  Value : VK_F10),
                                         (ID : 'f11';        IsKey : true;  Value : VK_F11),
                                         (ID : 'f12';        IsKey : true;  Value : VK_F12),
                                         (ID : 'f13';        IsKey : true;  Value : VK_F13),
                                         (ID : 'f14';        IsKey : true;  Value : VK_F14),
                                         (ID : 'f15';        IsKey : true;  Value : VK_F15),
                                         (ID : 'f16';        IsKey : true;  Value : VK_F16),
                                         (ID : 'f17';        IsKey : true;  Value : VK_F17),
                                         (ID : 'f18';        IsKey : true;  Value : VK_F18),
                                         (ID : 'f19';        IsKey : true;  Value : VK_F19),
                                         (ID : 'f20';        IsKey : true;  Value : VK_F20),
                                         (ID : 'f21';        IsKey : true;  Value : VK_F21),
                                         (ID : 'f22';        IsKey : true;  Value : VK_F22),
                                         (ID : 'f23';        IsKey : true;  Value : VK_F23),
                                         (ID : 'f24';        IsKey : true;  Value : VK_F24),
                                         (ID : 'numlock';    IsKey : true;  Value : VK_NUMLOCK),
                                         (ID : 'scroll';     IsKey : true;  Value : VK_SCROLL),
                                         (ID : 'lshift';     IsKey : true;  Value : VK_LSHIFT),
                                         (ID : 'rshift';     IsKey : true;  Value : VK_RSHIFT),
                                         (ID : 'lcontrol';   IsKey : true;  Value : VK_LCONTROL),
                                         (ID : 'rcontrol';   IsKey : true;  Value : VK_RCONTROL),
                                         (ID : 'lmenu';      IsKey : true;  Value : VK_LMENU),
                                         (ID : 'rmenu';      IsKey : true;  Value : VK_RMENU),
                                         (ID : 'processkey'; IsKey : true;  Value : VK_PROCESSKEY),
                                         (ID : 'attn';       IsKey : true;  Value : VK_ATTN),
                                         (ID : 'crsel';      IsKey : true;  Value : VK_CRSEL),
                                         (ID : 'exsel';      IsKey : true;  Value : VK_EXSEL),
                                         (ID : 'ereof';      IsKey : true;  Value : VK_EREOF),
                                         (ID : 'play';       IsKey : true;  Value : VK_PLAY),
                                         (ID : 'zoom';       IsKey : true;  Value : VK_ZOOM),
                                         (ID : 'noname';     IsKey : true;  Value : VK_NONAME),
                                         (ID : 'pa1';        IsKey : true;  Value : VK_PA1),
                                         (ID : 'oem_clear';  IsKey : true;  Value : VK_OEM_CLEAR));
  CSeperator = '+';
var
  LIndexA : LongInt;
  LIndexB : LongInt;
  LIsKey  : Boolean;
  LParts  : TStringArray;
begin
  Result.Key       := 0;
  Result.Modifiers := 0;
  Result.Value     := '';

  // return array of lowercase IDs
  LParts := SeperateString(AString, CSeperator);
  LIsKey := false;
  for LIndexA := 0 to Pred(Length(LParts)) do
  begin
    for LIndexB := 0 to Pred(Length(CEntries)) do
    begin
      if (LParts[LIndexA] = CEntries[LIndexB].ID) then
      begin
        if (CEntries[LIndexB].IsKey) then
        begin
          // only proceed if there is only one key value
          if (LIsKey) then
          begin
            // raise duplicate key exception
            raise Exception.Create('Error: Duplicate Keys Encountered.');
          end
          else
          begin
            // save key value
            LIsKey     := CEntries[LIndexB].IsKey;
            Result.Key := CEntries[LIndexB].Value;
          end;
        end
        else
        begin
          // calculate modifier value
          Result.Modifiers := Result.Modifiers or CEntries[LIndexB].Value;
        end;

        Result.Value := Result.Value + CEntries[LIndexB].ID;
        if (LIndexA < Pred(Length(LParts))) then
          Result.Value := Result.Value + CSeperator;

        // proceed with next ID
        Break;
      end;
    end;
  end;

  if not(LIsKey) then
  begin
    // raise no key exception
    raise Exception.Create('Error: No Key Encountered.');
  end;
end;

end.
