#FASM.DLLから関数の説明です。

###fasm_GetVersion()
Dwordを返します。16ビット下位は重要なバージョン番号含みます。16ビット上位はサブバージョン番号含みます。

###fasm_Assemble(lpSource,lpMemory,cbMemorySize,nPassesLimit,hDisplayPipe)
ソースをアセンブルします。ワークスペースいるにメモリブロックが渡できるをつかいます（そのメモリブロックのまん中に出力があります）。

lpSourceはソースへポインタです（pansichar）。終わりの文字の値はゼロです。

lpMemoryはソースへメモリブロックです。cbMemorySizeはそのメモリブロックのサイズです。メモリブロックのはじめにFASM_STATEのレコードがあいます（DelphiのためにTFASM_STATEです）。アセンブラーはメモリ緒の割り当てを行いません。メモリを不足すが関数がFASM_OUT_OF_MEMORYを返します。

nPassesLimitは１から６５５３６まで値があります。nPassesLimitは最大のアセンブルの段階です（デフォルトの値１００）.最大の段階を到達するが関数がFASM_CANNOT_GENERATE_CODEを返します。

hDisplayPipeにpipeのhandleがあります。pipeは表示の出力。hDisplayPipeがゼロが出力がありません。

アセンブルは成功するが返がFASM_OKです。FASM_STATEレコードのoutput_dataとoutput_lengthがあります（これはメモリブロックの初めてにです）。

アセンブルは成功しないが関数がエラーコードを返します（Fasm4Delphi.pasへ「General　errors　and　conditions」を見る）。FASM_ERRORはコードへエラーを意味する。それからFASM_STATEのerror_codeとerror_lineがあります。error_codeは二番エラーコード（Fasm4Delphi.pasへ「Error　codes　for　FASM_ERROR　condition」を見る）。error_lineはエラーの文字列のレコードへポインタ（Fasm4Delphi.pasへ「TLINE_HEADER」を見る）。

###fasm_AssembleFile(lpSourceFile,lpMemory,cbMemorySize,nPassesLimit,hDisplayPipe)
この関数は同じにfasm_Assembleです。でも、一番パラメータはlpSourceFileあります。lpSourceFileはソースファイルの名前へポインタです（pansichar）。終わりの文字の値はゼロです。

********************************************
#FASM.DLLからエラーコードの説明です。

fasm_Assembleのためにメモリブロックの初めてにこのエラーコードがあります。conditionは同じ関数の返です。

返がFASM_OKありますがoutput_lengthとoutput_dataはアセンブルの返へポインタ（これがメモリブロックのまん中に）と出力のサイズです。

返がFASM_ERRORありますがerror_codeは二番です（Fasm4Delphi.pasへ「Error　codes　for　FASM_ERROR　condition」を見る）。error_lineはLINE_HEADERのレコードへポインタ。LINE_HEADERは文字列のインフォメーションあります。

    TLINE_HEADER=record
    file_path:PAnsiChar;
      line_number:cardinal;
      case byte of
        0:(file_offset:cardinal);
        1:(macro_calling_line:^TLINE_HEADER;
          macro_line:^TLINE_HEADER;);
    end;

このレコードは二つのバリエーション。一番バリアントはTLINE_HEADERがソースに文字列をあります。二番バリアントはTLINE_HEADERがマクロ命令の文字列をあります。一番バリアントはline_numberのビット上位に０です。二番バリアントはline_numberのビット上位に１です。

一番バリアントはfile_pathがソースのファイル名へポインタ（空文字列がlpSourceです)。line_numberは文字列の番号（一番は１）。file_offsetは文字列の初めてに文字の番号です。

一番バリアントはmacro_calling_lineがTLINE_HEADERのレコードへポインタのためにつぎのマクロ命令の呼びです。macro_lineがTLINE_HEADERのレコードへポインタのために前のマクロ命令の呼びです.

    TLINE_HEADER=record
    file_path:PAnsiChar;
      line_number:cardinal;
      case byte of
        0:(file_offset:cardinal);
        1:(macro_calling_line:^TLINE_HEADER;
          macro_line:^TLINE_HEADER;);
    end;