unit TestCase1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,Fasm4Delphi;

type

  TTestCase1= class(TTestCase)
  published
    procedure TestHookUp;
  end;

implementation

const
  CompliterMemSize=$10000;

var
  CompliterMem:PFASM_STATE;

procedure TTestCase1.TestHookUp;
begin
  if fasm_AssembleFile('..\Tests\Test1.asm',CompliterMem,CompliterMemSize)<>FASM_OK then
    Fail('Error in test1:'+sLineBreak+
         'Condition:    '+CompliterMem^.condition.ToString+sLineBreak+
         'Error Code:   '+CompliterMem^.error_code.ToString);
  if fasm_Assemble('add eax,0',CompliterMem,CompliterMemSize)<>FASM_OK then
    writeln('Error in test2:'+sLineBreak+
         'Condition:    '+CompliterMem^.condition.ToString+sLineBreak+
         'Error Code:   '+CompliterMem^.error_code.ToString);
  if fasm_AssembleFile('..\FasmDll\FASM.ASH',CompliterMem,CompliterMemSize)=FASM_OK then
    Fail('Error in test3:'+sLineBreak+
         'FASM is compiling something that it is can not compile at all.');
  if fasm_Assemble('call -100',CompliterMem,CompliterMemSize)<>FASM_OK then
    Fail('Error in test4:'+sLineBreak+
         'Condition:    '+CompliterMem^.condition.ToString+sLineBreak+
         'Error Code:   '+CompliterMem^.error_code.ToString);
end;



initialization
  LoadFASM('..\FasmDll\FASM.DLL');
  GetMem(CompliterMem,CompliterMemSize);
  RegisterTest(TTestCase1);
end.

