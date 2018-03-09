Description of functions inside FASM.DLL
Описание функций FASM.DLL
FASM.DLLから関数の説明です。

fasm_GetVersion()
　Returns double word containg major version in lower 16 bits, and minor version in the higher 16 bits.
　Возвращает двойное слово(dword) содержащее основную чать версии в младших 16 битах, и подверсию в сташих 16 битах.
　Dwordを返します。16ビット下位は重要なバージョン番号含みます。16ビット上位はサブバージョン番号含みます。

fasm_Assemble(lpSource,lpMemory,cbMemorySize,nPassesLimit,hDisplayPipe)
　Assembles the given source, using the provided memory block as a free storage space(which is also to contain generated output).
　Ассемблирует переданный исходный код, используя переданный блок памяти как рабочее пространство(вывод также будет находиться в нём).
　ソースをアセンブルします。ワークスペースいるにメモリブロックが渡できるをつかいます（そのメモリブロックのまん中に出力があります）。
　The lpSource should contain a pointer to zero-ended source text(pansichar).
　lpSource должен содержать указатель на оканчивающийся нулём(zero-ended) исходный код(pansichar).
　lpSourceはソースへポインタです（pansichar）。終わりの文字の値はゼロです。
　The lpMemory should be a pointer to the memory block and cbMemorySize should contain its size. In the beginning of this memory block the FASM_STATE(TFASM_STATE in Delphi) structure will reside. The assembler doesn't allocate any memory beside this block, if it is not enough for its purposes, the function return FASM_OUT_OF_MEMORY.
　lpMemory должен содержать указатель на блок памяти,а cbMemorySize должен содержать его размер. Вначале этого блока будет создана структура FASM_STATE(TFASM_STATE в Delphi). Ассемблер не выделяет память вне этого блока, если её недостаточно функция вернёт FASM_OUT_OF_MEMORY.
　lpMemoryはソースへメモリブロックです。cbMemorySizeはそのメモリブロックのサイズです。メモリブロックのはじめにFASM_STATEのレコードがあいます（DelphiのためにTFASM_STATEです）。アセンブラーはメモリ緒の割り当てを行いません。メモリを不足すが関数がFASM_OUT_OF_MEMORYを返します。
　The nPassesLimit should be a value in range from 1 to 65536, defining the maximum number of passes the assembler can perform in order to generate the code(the recommended value is 100). If the limit is reached, the function return FASM_CANNOT_GENERATE_CODE.
　nPassesLimit должен быть в диапозоне от 1 до 65536. Он задёт максимальное количество проходов, которые ассемблер может выполнить во время генерации кода (рекомендованая величина 100). Если лимит достигнут, функция вернёт FASM_CANNOT_GENERATE_CODE.
　nPassesLimitは１から６５５３６まで値があります。nPassesLimitは最大のアセンブルの段階です（デフォルトの値１００）.最大の段階を到達するが関数がFASM_CANNOT_GENERATE_CODEを返します。
　The hDisplayPipe should contain handle of the pipe, to which the output of DISPLAY directives will be written. If this parameter is 0, all the display will get discarded.
　hDisplayPipe должен содержать handle pipe'а, в котрорый будет записан вывод на экран. Если это праметр равен 0, весь вывод будет отброшен.
　hDisplayPipeにpipeのhandleがあります。pipeは表示の出力。hDisplayPipeがゼロが出力がありません。
　If the assembly is successful, function returns FASM_OK value and fills the output_data and output_length fields of the FASM_STATE structure(which resides at the beginning of provided memory block).
　Если ассемблирование пройдёт удачно, функция вернёт FASM_OK и заполнит output_data и output_length в структуре FASM_STATE(которая находится в начале выделнного блока памяти).
　アセンブルは成功するが返がFASM_OKです。FASM_STATEレコードのoutput_dataとoutput_lengthがあります（これはメモリブロックの初めてにです）。
　If the assembly failed, function returns one of the other general conditions/errors codes(see "General errors and conditions" in Fasm4Delphi.pas). If if error code is FASM_ERROR, it means that an error caused by a specific place in source occured, then the error_code and error_line fields of FASM_STATE are filled, first one with detailed error code(see "Error codes for FASM_ERROR condition" in Fasm4Delphi.pas), and the second one with pointer to a structure containing data about line that caused the error(see "TLINE_HEADER" in Fasm4Delphi.pas).
　Если ассемблирование неудалось, функция вернёт один из других основных кодов ошибок(см. "General errors and conditions" в Fasm4Delphi.pas). Если код ошибки - FASM_ERROR, это значит что ошибка произошла в определённом месте кода, тогда поля error_code and error_line FASM_STATE'а будут заполнены, первое из них будет содержать детальный код ошибки(см. "Error codes for FASM_ERROR condition" в Fasm4Delphi.pas),а вторая - указатель(pointer) на структуру содержащую информацию о строке в котрой произошла ошибка(см. "TLINE_HEADER" в Fasm4Delphi.pas).
　アセンブルは成功しないが関数がエラーコードを返します（Fasm4Delphi.pasへ「General　errors　and　conditions」を見る）。FASM_ERRORはコードへエラーを意味する。それからFASM_STATEのerror_codeとerror_lineがあります。error_codeは二番エラーコード（Fasm4Delphi.pasへ「Error　codes　for　FASM_ERROR　condition」を見る）。error_lineはエラーの文字列のレコードへポインタ（Fasm4Delphi.pasへ「TLINE_HEADER」を見る）。
fasm_AssembleFile(lpSourceFile,lpMemory,cbMemorySize,nPassesLimit,hDisplayPipe)
　This function performs identically to fasm_Assemble, except that it takes the lpSourceFile parameter in place of lpSource, and it shall contain the pointer to zero-ended path to file containing the source to assemble(pansichar).
　Эта функция работает идентично fasm_Assemble, но в отличии от неё принимает параметр lpSourceFile вместо lpSource. Этот параметр должен содержать указатель(pointer) на оканчивающийся нулём(zero-ended) путь до файла содержащего исходный код для ассемблирования(pansichar).
　この関数は同じにfasm_Assembleです。でも、一番パラメータはlpSourceFileあります。lpSourceFileはソースファイルの名前へポインタです（pansichar）。終わりの文字の値はゼロです。

********************************************
Description of structures used in FASM.DLL
Описание структур используемых FASM.DLL
FASM.DLLからエラーコードの説明です。

　The following structure resides at the beginning of memory block provided to the fasm_Assemble function. The condition field contains the same value as the one returned by function.
　Следующая структура находится в начале блока памяти передаваемого в fasm_Assemble. Поле condition содержит тоже значение которое возвращается функцией.
　fasm_Assembleのためにメモリブロックの初めてにこのエラーコードがあります。conditionは同じ関数の返です。
　　When function returns FASM_OK condition, the output_length and output_data fields are filled - with pointer to generated output(somewhere within the provided memory block) and the count of bytes stored there.
　　Когда функция возвращает FASM_OK, поля output_length и output_data заполнены указателем(pointer) на результат ассемблирования(он находится внутри блока памяти внутри блока памяти) и длинной этого блока памяти соответственно.
　　返がFASM_OKありますがoutput_lengthとoutput_dataはアセンブルの返へポインタ（これがメモリブロックのまん中に）と出力のサイズです。
　　When function returns FASM_ERROR, the error_code is filled with the code of specific error(see "Error codes for FASM_ERROR condition" in Fasm4Delphi.pas) that happened and error_line is a pointer to the LINE_HEADER structure, providing information about the line that caused the error.
　　Когда функция возвращает FASM_ERROR - error_code содержит детальный код ошибки(см. "Error codes for FASM_ERROR condition" в Fasm4Delphi.pas), а error_line - указатель(pointer) на структуру LINE_HEADER, передающую информацию о строке в которой произошла ошибка.
　　返がFASM_ERRORありますがerror_codeは二番です（Fasm4Delphi.pasへ「Error　codes　for　FASM_ERROR　condition」を見る）。error_lineはLINE_HEADERのレコードへポインタ。LINE_HEADERは文字列のインフォメーションあります。

TFASM_STATE=record
  condition:Int32;
  case byte of
  0:(error_code:Int32;
     error_line:PLINE_HEADER;);
  1:(output_length:cardinal;
     output_data:pointer;);
end;

　The following structure has two variants - it either defines the line that was loaded directly from source, or the line that was generated by macroinstruction. First case has the highest bit of line_number set to 0, while the second case has this bit set.
　Следующая структура имеет два варианта - она либо определяет строку, котрая была загружена непосредственно из исходного кода, либо линию,которая была сгенерирована макроинструкцией. В первом случае старший бит line_number'а установлен в 0, в то время как во втором этот бит установлен в 1.
　このレコードは二つのバリエーション。一番バリアントはTLINE_HEADERがソースに文字列をあります。二番バリアントはTLINE_HEADERがマクロ命令の文字列をあります。一番バリアントはline_numberのビット上位に０です。二番バリアントはline_numberのビット上位に１です。
　　In the first case, the file_path field contains pointer to the path of source file(empty string if it's the source that was provided directly to fasm_Assemble function), the line_number is the number of line within that file(starting from 1) and the file_offset field contains the offset within the file where the line starts.
　　В первом случае, поле file_path содержит указатель(pointer) на путь до файла с исходным кодом(пустая строка означает, что это исходный код переданный в fasm_Assemble), line_number - номер строки в этом файле(считая с 1), а поле file_offset содержит смешение в файле, на котором начинается строка.
　　一番バリアントはfile_pathがソースのファイル名へポインタ（空文字列がlpSourceです)。line_numberは文字列の番号（一番は１）。file_offsetは文字列の初めてに文字の番号です。
　　In the second case the macro_calling_line field contains the pointer to LINE_HEADER structure for the line which called the macroinstruction, and the macro_line field contains the pointer to LINE_HEADER structure for the line within the definition of macroinstruction, which generated this one.
　　Во втором случае поле macro_calling_line содержит указатель(pointer) на структуру TLINE_HEADER для строки, которую вызывает макроинструкция, а поле macro_line содержит указатель(pointer) на структуру TLINE_HEADER для строки, в которой находится макроинструкция, указывающая на текущую.
　　一番バリアントはmacro_calling_lineがTLINE_HEADERのレコードへポインタのためにつぎのマクロ命令の呼びです。macro_lineがTLINE_HEADERのレコードへポインタのために前のマクロ命令の呼びです.

TLINE_HEADER=record
  file_path:PAnsiChar;
  line_number:cardinal;
  case byte of
    0:(file_offset:cardinal);
    1:(macro_calling_line:^TLINE_HEADER;
      macro_line:^TLINE_HEADER;);
end;