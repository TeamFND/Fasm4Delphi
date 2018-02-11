
format PE GUI 4.0
entry start

include 'win32a.inc'
include 'fasm.ash'
include 'fedit.ash'

section '.data' data readable writeable

 _fedit db 'FEDIT.DLL',0
 _caption db 'flat assembler %d.%d',0
 _error db 'ERROR',0

 _source db 0Dh,0Ah
	 db ' org 100h',0Dh,0Ah
	 db 0Dh,0Ah
	 db ' mov ah,09h ',' ; write',0Dh,0Ah
	 db ' mov dx,text',0Dh,0Ah
	 db ' int 21h',0Dh,0Ah
	 db ' int 20h',0Dh,0Ah
	 db 0Dh,0Ah
	 db ' text db "Hello!",24h',0Dh,0Ah
	 db 0

 buffer rb 10000h

 fasm_memory:
   fasm_state FASM_STATE
   rb 800000h-($-fasm_memory)		; reserve total 8 MB for assembler

section '.code' code readable executable

  start:

	invoke	LoadLibrary,_fedit
	or	eax,eax
	jz	exit
	invoke	GetModuleHandle,0
	invoke	DialogBoxParam,eax,37,HWND_DESKTOP,DialogProc,0

  exit:
	invoke	ExitProcess,0

proc DialogProc hwnddlg,msg,wparam,lparam
	push	ebx esi edi
	cmp	[msg],WM_INITDIALOG
	je	wminitdialog
	cmp	[msg],WM_COMMAND
	je	wmcommand
	cmp	[msg],WM_CLOSE
	je	wmclose
	xor	eax,eax
	jmp	finish
  wminitdialog:
	invoke	fasm_GetVersion
	mov	edx,eax
	and	eax,0FFFFh
	shr	edx,16
	cinvoke wsprintf,buffer,_caption,eax,edx
	invoke	SendMessage,[hwnddlg],WM_SETTEXT,0,buffer
	invoke	SetDlgItemText,[hwnddlg],ID_SOURCE,_source
	jmp	processed
  wmcommand:
	cmp	[wparam],BN_CLICKED shl 16 + IDCANCEL
	je	wmclose
	cmp	[wparam],BN_CLICKED shl 16 + IDOK
	jne	processed

	invoke	GetDlgItemText,[hwnddlg],ID_SOURCE,buffer,10000h

	invoke	fasm_Assemble,buffer,fasm_memory,800000h,100,NULL
	cmp	eax,FASM_OK
	je	show_output

	invoke	SetDlgItemText,[hwnddlg],ID_OUTPUT,_error

	jmp	processed

    show_output:

	mov	esi,[fasm_state.output_data]
	mov	ecx,[fasm_state.output_length]
	mov	edi,buffer
	xor	edx,edx
	jecxz	output_ok
      output_to_hex:
	test	dl,7
	jz	@f
	mov	al,20h
	stosb
      @@:
	mov	al,[esi+edx]
	shr	al,4
	cmp	al,10
	sbb	al,69h
	das
	stosb
	mov	al,[esi+edx]
	and	al,0Fh
	cmp	al,10
	sbb	al,69h
	das
	stosb
	inc	edx
	test	dl,7
	jnz	@f
	mov	ax,0D0Ah
	stosw
      @@:
	loop	output_to_hex
      output_ok:
	xor	al,al
	stosb

	invoke	SetDlgItemText,[hwnddlg],ID_OUTPUT,buffer

	jmp	processed
  wmclose:
	invoke	EndDialog,[hwnddlg],0
  processed:
	mov	eax,1
  finish:
	pop	edi esi ebx
	ret
endp

section '.idata' import data readable writeable

  library kernel32,'KERNEL32.DLL',\
	  user32,'USER32.DLL',\
	  fasm,'FASM.DLL'

  include 'api\kernel32.inc'
  include 'api\user32.inc'

  import fasm,\
	 fasm_GetVersion,'fasm_GetVersion',\
	 fasm_Assemble,'fasm_Assemble',\
	 fasm_AssembleFile,'fasm_AssembleFile'

section '.rsrc' resource data readable

  ID_SOURCE = 100
  ID_OUTPUT = 101

  directory RT_DIALOG,dialogs

  resource dialogs,\
	   37,LANG_ENGLISH+SUBLANG_DEFAULT,demonstration

  dialog demonstration,'Memory-to-memory assembly',40,40,180,220,WS_CAPTION+WS_POPUP+WS_SYSMENU+DS_MODALFRAME
    dialogitem 'FEDIT','',ID_SOURCE,10,10,160,120,WS_VISIBLE+WS_BORDER+WS_TABSTOP
    dialogitem 'FEDIT','',ID_OUTPUT,10,150,160,60,WS_VISIBLE+WS_BORDER+WS_TABSTOP
    dialogitem 'BUTTON','Assemble',IDOK,10,132,160,15,WS_VISIBLE+WS_TABSTOP
  enddialog
