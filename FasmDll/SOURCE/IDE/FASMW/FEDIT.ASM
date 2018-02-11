
; flat editor DLL interface for Win32
; Copyright (c) 2001-2014, Tomasz Grysztar.
; All rights reserved.

format PE DLL GUI 4.0
entry DLLEntryPoint

include 'win32a.inc'

include 'fedit.ash'

section '.data' data readable writeable

  _fedit_class db 'FEDIT',0

  _user_library db 'USER32.DLL',0
  _setgestureconfig_api db 'SetGestureConfig',0
  _getgestureinfo_api db 'GetGestureInfo',0
  _closegestureinfohandle_api db 'CloseGestureInfoHandle',0

  align 4

  SetGestureConfig dd 0
  GetGestureInfo dd 0
  CloseGestureInfoHandle dd 0

  wheel_scroll_lines dd 3

  fedit_font dd ?

  char rb 4
  kbstate rb 100h
  line_colors rb 100h
  line_buffer rb 100h
  text_buffer rb 100h
  upper_case_table rb 100h

  wc WNDCLASS
  ps PAINTSTRUCT
  tm TEXTMETRIC
  sc SCROLLINFO
  rect RECT

section '.text' code readable executable

proc DLLEntryPoint uses ebx esi edi,hinstDLL,fdwReason,lpvReserved
	cmp	[fdwReason],DLL_PROCESS_ATTACH
	jne	.done
	invoke	GetModuleHandle,_user_library
	or	eax,eax
	jz	.gesture_api_unavailable
	mov	ebx,eax
	invoke	GetProcAddress,ebx,_setgestureconfig_api
	or	eax,eax
	jz	.gesture_api_unavailable
	mov	esi,eax
	invoke	GetProcAddress,ebx,_getgestureinfo_api
	or	eax,eax
	jz	.gesture_api_unavailable
	mov	edi,eax
	invoke	GetProcAddress,ebx,_closegestureinfohandle_api
	or	eax,eax
	jz	.gesture_api_unavailable
	mov	[CloseGestureInfoHandle],eax
	mov	[SetGestureConfig],esi
	mov	[GetGestureInfo],edi
      .gesture_api_unavailable:
	invoke	LoadCursor,0,IDC_IBEAM
	mov	[wc.hCursor],eax
	mov	[wc.style],CS_GLOBALCLASS+CS_DBLCLKS
	mov	[wc.lpfnWndProc],FlatEditor
	mov	eax,[hinstDLL]
	mov	[wc.hInstance],eax
	mov	[wc.cbWndExtra],4
	xor	eax,eax
	mov	[wc.hbrBackground],eax
	mov	[wc.cbClsExtra],eax
	mov	[wc.lpszMenuName],eax
	mov	[wc.lpszClassName],_fedit_class
	invoke	RegisterClass,wc
	or	eax,eax
	jz	.failed
	invoke	CreateFont,0,0,0,0,0,FALSE,FALSE,FALSE,ANSI_CHARSET,OUT_RASTER_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FIXED_PITCH+FF_DONTCARE,NULL
	or	eax,eax
	jz	.failed
	mov	[fedit_font],eax
	push	ebx esi edi
	mov	edi,upper_case_table
	xor	ebx,ebx
	mov	esi,100h
    .make_upper_case_table:
	invoke	CharUpper,ebx
	stosb
	inc	bl
	dec	esi
	jnz	.make_upper_case_table
	pop	edi esi ebx
    .done:
	mov	eax,TRUE
	ret
    .failed:
	mov	eax,FALSE
	ret
endp

include 'fedit.inc'

section '.idata' import data readable writeable

  library kernel,'KERNEL32.DLL',\
	  user,'USER32.DLL',\
	  gdi,'GDI32.DLL'

  import kernel,\
	 GetModuleHandle,'GetModuleHandleA',\
	 GetProcAddress,'GetProcAddress',\
	 GlobalAlloc,'GlobalAlloc',\
	 GlobalReAlloc,'GlobalReAlloc',\
	 GlobalLock,'GlobalLock',\
	 GlobalUnlock,'GlobalUnlock',\
	 GlobalFree,'GlobalFree',\
	 VirtualAlloc,'VirtualAlloc',\
	 VirtualFree,'VirtualFree',\
	 ExitProcess,'ExitProcess'

  import user,\
	 RegisterClass,'RegisterClassA',\
	 CreateCaret,'CreateCaret',\
	 ShowCaret,'ShowCaret',\
	 HideCaret,'HideCaret',\
	 SetCaretPos,'SetCaretPos',\
	 DestroyCaret,'DestroyCaret',\
	 BeginPaint,'BeginPaint',\
	 EndPaint,'EndPaint',\
	 GetDC,'GetDC',\
	 GetUpdateRect,'GetUpdateRect',\
	 ReleaseDC,'ReleaseDC',\
	 GetCursorPos,'GetCursorPos',\
	 ClientToScreen,'ClientToScreen',\
	 TrackPopupMenu,'TrackPopupMenu',\
	 DrawText,'DrawTextA',\
	 FillRect,'FillRect',\
	 InvalidateRect,'InvalidateRect',\
	 GetKeyboardState,'GetKeyboardState',\
	 ToAscii,'ToAscii',\
	 GetScrollInfo,'GetScrollInfo',\
	 SetScrollInfo,'SetScrollInfo',\
	 SetCapture,'SetCapture',\
	 ReleaseCapture,'ReleaseCapture',\
	 OpenClipboard,'OpenClipboard',\
	 CloseClipboard,'CloseClipboard',\
	 EmptyClipboard,'EmptyClipboard',\
	 GetClipboardData,'GetClipboardData',\
	 SetClipboardData,'SetClipboardData',\
	 LoadCursor,'LoadCursorA',\
	 IsClipboardFormatAvailable,'IsClipboardFormatAvailable',\
	 CharUpper,'CharUpperA',\
	 GetWindowLong,'GetWindowLongA',\
	 SetWindowLong,'SetWindowLongA',\
	 DefWindowProc,'DefWindowProcA',\
	 GetClientRect,'GetClientRect',\
	 UpdateWindow,'UpdateWindow',\
	 SetFocus,'SetFocus',\
	 GetSysColor,'GetSysColor',\
	 MessageBox,'MessageBoxA',\
	 SendMessage,'SendMessageA',\
	 PostMessage,'PostMessageA'

  import gdi,\
	 SetBkColor,'SetBkColor',\
	 SetTextColor,'SetTextColor',\
	 CreateSolidBrush,'CreateSolidBrush',\
	 CreateFont,'CreateFontA',\
	 GetTextMetrics,'GetTextMetricsA',\
	 GetTextExtentPoint32,'GetTextExtentPoint32A',\
	 DeleteDC,'DeleteDC',\
	 SelectObject,'SelectObject',\
	 DeleteObject,'DeleteObject'

section '.reloc' fixups data readable discardable

section '.rsrc' resource data readable

  directory RT_VERSION,versions

  resource versions,\
	   1,LANG_NEUTRAL,version

  versioninfo version,VOS__WINDOWS32,VFT_APP,VFT2_UNKNOWN,LANG_ENGLISH+SUBLANG_DEFAULT,0,\
	      'FileDescription','flat editor',\
	      'LegalCopyright',<'Copyright ',0A9h,' 1999-2014 Tomasz Grysztar.'>,\
	      'FileVersion',FEDIT_VERSION_STRING,\
	      'ProductVersion',FEDIT_VERSION_STRING,\
	      'OriginalFilename','FEDIT.DLL'
