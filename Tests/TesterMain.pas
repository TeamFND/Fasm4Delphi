unit TesterMain;

interface

uses
  DUnitX.TestFramework,Fasm4Delphi,SysUtils;

type
  [TestFixture]
  TMyTestObject = class(TObject) 
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Test1;
    [Test]
    procedure Test2;      
    [Test]
    procedure Test3;
    [Test]
    procedure Test4;
  end;

const
  CompliterMemSize=$10000;  

var
  CompliterMem:PFASM_STATE;
  
implementation

procedure TMyTestObject.Setup;
begin
end;

procedure TMyTestObject.TearDown;
begin
end;

procedure TMyTestObject.Test1;
begin
if fasm_AssembleFile('..\..\Test1.ASM',CompliterMem,CompliterMemSize)<>FASM_OK then
  raise Exception.Create('Condition:    '+CompliterMem^.condition.ToString+sLineBreak+
                         'Error Code:   '+CompliterMem^.error_code.ToString+sLineBreak);
end;

procedure TMyTestObject.Test2;
begin
if fasm_Assemble('add eax,0',CompliterMem,CompliterMemSize)<>FASM_OK then
  raise Exception.Create('Condition:    '+CompliterMem^.condition.ToString+sLineBreak+
                         'Error Code:   '+CompliterMem^.error_code.ToString+sLineBreak);
end;

procedure TMyTestObject.Test3;
begin
if fasm_AssembleFile('..\..\..\FasmDll\FASM.ASH',CompliterMem,CompliterMemSize)=FASM_OK then
  raise Exception.Create('FASM is compiling something that it is can not compile at all.');
end;

procedure TMyTestObject.Test4;
begin
if fasm_Assemble('call -100',CompliterMem,CompliterMemSize)<>FASM_OK then
  raise Exception.Create('Condition:    '+CompliterMem^.condition.ToString+sLineBreak+
                         'Error Code:   '+CompliterMem^.error_code.ToString+sLineBreak);
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
  LoadFASM('..\..\..\FasmDll\FASM.DLL');
  GetMem(CompliterMem,CompliterMemSize);
end.
