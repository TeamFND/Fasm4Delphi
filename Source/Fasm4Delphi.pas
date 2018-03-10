unit Fasm4Delphi platform;

{Delphi Translation&Tests:Artyom Gavrilov,Vlad Untkin.
 Donate:https://money.yandex.ru/to/410014959153552}

interface

//{$Define FasmStaticLink}
{$IFDEF WIN32}

uses
  Windows;

type
  TFasmVersion=packed record
    V1,V2:word;
  end;

  TLINE_HEADER=record 
    file_path:PAnsiChar;
    line_number:cardinal;
    case byte of
      0:(file_offset:cardinal);
      1:(macro_calling_line:^TLINE_HEADER;
	macro_line:^TLINE_HEADER;);
  end;
  PLINE_HEADER=^TLINE_HEADER;
{$EXTERNALSYM TLINE_HEADER}

  TFASM_STATE=record
    condition:Int32;  
    case byte of
    0:(error_code:Int32;    
       error_line:PLINE_HEADER;);
    1:(output_length:cardinal;
       output_data:pointer;  );   
  end;	
  PFASM_STATE=^TFASM_STATE; 
{$EXTERNALSYM TFASM_STATE}

const
  FASMDLLName='FASM.DLL';

  // General errors and conditions
  
  FASM_OK			   =0;	  //FASM_STATE points to output
  FASM_WORKING			   =1;
  FASM_ERROR			   =2;	  //FASM_STATE contains error code
  FASM_INVALID_PARAMETER	   =-1;
  FASM_OUT_OF_MEMORY		   =-2;
  FASM_STACK_OVERFLOW		   =-3;
  FASM_SOURCE_NOT_FOUND 	   =-4;
  FASM_UNEXPECTED_END_OF_SOURCE    =-5;
  FASM_CANNOT_GENERATE_CODE	   =-6;
  FASM_FORMAT_LIMITATIONS_EXCEDDED =-7;
  FASM_WRITE_FAILED		   =-8;
  FASM_INVALID_DEFINITION	   =-9;

  //Error codes for FASM_ERROR condition

  FASMERR_FILE_NOT_FOUND		      =-101;
  FASMERR_ERROR_READING_FILE		      =-102;
  FASMERR_INVALID_FILE_FORMAT		      =-103;
  FASMERR_INVALID_MACRO_ARGUMENTS	      =-104;
  FASMERR_INCOMPLETE_MACRO		      =-105;
  FASMERR_UNEXPECTED_CHARACTERS 	      =-106;
  FASMERR_INVALID_ARGUMENT		      =-107;
  FASMERR_ILLEGAL_INSTRUCTION		      =-108;
  FASMERR_INVALID_OPERAND		      =-109;
  FASMERR_INVALID_OPERAND_SIZE		      =-110;
  FASMERR_OPERAND_SIZE_NOT_SPECIFIED	      =-111;
  FASMERR_OPERAND_SIZES_DO_NOT_MATCH	      =-112;
  FASMERR_INVALID_ADDRESS_SIZE		      =-113;
  FASMERR_ADDRESS_SIZES_DO_NOT_AGREE	      =-114;
  FASMERR_DISALLOWED_COMBINATION_OF_REGISTERS =-115;
  FASMERR_LONG_IMMEDIATE_NOT_ENCODABLE	      =-116;
  FASMERR_RELATIVE_JUMP_OUT_OF_RANGE	      =-117;
  FASMERR_INVALID_EXPRESSION		      =-118;
  FASMERR_INVALID_ADDRESS		      =-119;
  FASMERR_INVALID_VALUE 		      =-120;
  FASMERR_VALUE_OUT_OF_RANGE		      =-121;
  FASMERR_UNDEFINED_SYMBOL		      =-122;
  FASMERR_INVALID_USE_OF_SYMBOL 	      =-123;
  FASMERR_NAME_TOO_LONG 		      =-124;
  FASMERR_INVALID_NAME			      =-125;
  FASMERR_RESERVED_WORD_USED_AS_SYMBOL	      =-126;
  FASMERR_SYMBOL_ALREADY_DEFINED	      =-127;
  FASMERR_MISSING_END_QUOTE		      =-128;
  FASMERR_MISSING_END_DIRECTIVE 	      =-129;
  FASMERR_UNEXPECTED_INSTRUCTION	      =-130;
  FASMERR_EXTRA_CHARACTERS_ON_LINE	      =-131;
  FASMERR_SECTION_NOT_ALIGNED_ENOUGH	      =-132;
  FASMERR_SETTING_ALREADY_SPECIFIED	      =-133;
  FASMERR_DATA_ALREADY_DEFINED		      =-134;
  FASMERR_TOO_MANY_REPEATS		      =-135;
  FASMERR_SYMBOL_OUT_OF_SCOPE		      =-136;
  FASMERR_USER_ERROR			      =-140;
  FASMERR_ASSERTION_FAILED		      =-141;

{$IFDEF FasmStaticLink}
function fasm_GetVersion:TFasmVersion;stdcall;external FASMDLLName;
function fasm_Assemble(lpSource:PAnsiChar;lpMemory:pointer;cbMemorySize:cardinal;
  nPassesLimit:word=100;hDisplayPipe:DWord=0):Int32;stdcall;external FASMDLLName;
function fasm_AssembleFile(lpSourceFile:PAnsiChar;lpMemory:pointer;cbMemorySize:cardinal;
  nPassesLimit:word=100;hDisplayPipe:DWord=0):Int32;stdcall;external FASMDLLName;
{$ELSE}
var
  fasm_GetVersion:function:TFasmVersion;stdcall;
  fasm_Assemble:function(lpSource:PAnsiChar;lpMemory:pointer;cbMemorySize:cardinal;nPassesLimit:word=100;hDisplayPipe:DWord=0):Int32;stdcall;
  fasm_AssembleFile:function(lpSourceFile:PAnsiChar;lpMemory:pointer;cbMemorySize:cardinal;nPassesLimit:word=100;hDisplayPipe:DWord=0):Int32;stdcall;
{$ENDIF}

{$IFNDEF FasmStaticLink}
procedure LoadFASM(Name:string=FASMDLLName);
procedure FreeFASM;
{$ENDIF}
{$ENDIF}

implementation

{$IFDEF WIN32}
{$IFNDEF FasmStaticLink}
var
  &Library:THandle=0;

procedure LoadFASM(Name:string=FASMDLLName);
begin
if &Library<>0 then
  FreeFasm;
{$IFDEF FPC}	
&Library:=LoadLibrary(PChar(Name));
Pointer(fasm_GetVersion):=GetProcAddress(&Library,'fasm_GetVersion');
Pointer(fasm_Assemble):=GetProcAddress(&Library,'fasm_Assemble');
Pointer(fasm_AssembleFile):=GetProcAddress(&Library,'fasm_AssembleFile');  
{$ELSE}
&Library:=LoadLibrary(PChar(Name));
fasm_GetVersion:=GetProcAddress(&Library,'fasm_GetVersion');
fasm_Assemble:=GetProcAddress(&Library,'fasm_Assemble');
fasm_AssembleFile:=GetProcAddress(&Library,'fasm_AssembleFile'); 
{$ENDIF}
end;   
 
procedure FreeFASM;
begin
if &Library=0 then
  exit;
fasm_GetVersion:=nil;
fasm_Assemble:=nil;
fasm_AssembleFile:=nil; 
&Library:=0;
end;
{$ENDIF}
{$ENDIF}

end.
