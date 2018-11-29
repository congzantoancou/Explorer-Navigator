DEFAULT_LABEL := "D:"

transTopDomain(topLevel)
{
	if (topLevel == "src")
		result := "Sources"
	else if (topLevel == "rt" or topLevel == "r")
		result := "" ; Default top
	return result
}

transDomain(sub, sec, top)
{
	if (sec != "")
		res = %top%\%sec%\%sub%
	else
		res = %top%\%sub%
	return res
}

isDomainValid(domain)
{
	FoundPos := RegExMatch(domain, "\w+(\.\w+\.\w+)?") ; Accept even only top
	if (FoundPos == 1)
		return true
	else
		return false

	;return true ; Set this always true for expandability of searching folder
}

#IfWinActive, ahk_class CabinetWClass

; Explorer Navigator
; Domain format: SubDomain.SecondLevelDomain.TopLevelDomain
	$Enter::
		ControlGetFocus, ctrl, ahk_class CabinetWClass
		
		if (ctrl != "Edit1")
		{
			Send, {enter}
		}
		else ;(ctrl == "Edit1")
		{
			ControlGetText, url, Edit1, ahk_class CabinetWClass
			if RegExMatch(url, "\w:") ; D:\top\sec\sub0\sub1\sub2\...\subn
				Send, {Enter}
			else ; sub.sec.top/class1/class2/.../classn
			{
				/**
				* Todo: Split url to:
				* * domainArray: sub.sec.top
				* * domainSub: /class1/class2/.../classn
				*/
				domArr := StrSplit(url, ".")
				urlPartition := domArr.MaxIndex()
				
				if (urlPartition > 3)
					MsgBox, Invalid domain
				else if (urlPartition == 3)
				{
					; Now domArr would like: sub | sec | top/sub1/sub2/subn
					; We need to split top/sub1/sub2/subn it out to: [top][/sub1/sub2/subn]
					domSub := StrSplit(domArr[3], "/")
					subPartsSize := domSub.MaxIndex()
					if (subPartsSize > 0)
					{
						; Now domSub would like: top (| sub1 | sub2 | subn)*
						domArr[3] := domSub[1]
						; Now domArr would like: sub | sec | top
						domSub.Remove(1)
						; Update subPartsSize
						subPartsSize := domSub.MaxIndex()
						; Noew domSub would like: sub1 | sub2 | subn
						; domSub may have none elements. It's ok
						
						Loop, %subPartsSize%
						{
							subPart .= domSub[A_Index] . "\"
						}
					}
					
					; Done, the domain now is like sub.sec.top and subparts like: sub1/sub2/subn
					; We need to translate them to Label:\top\sec\sub\sub1\sub2\subn
					; First, translate top. Forturnally Only top need to be translate
					top := transTopDomain(domArr[3])
					
					sec := domArr[2]
					sub := domArr[1]
					
					url = %DEFAULT_LABEL%\%top%\%sec%\%sub%\%subPart%
					subPart := ""
				}
				else if (urlPartition == 2)
				{
					top := transTopDomain(domArr[2])
					sec := domArr[1]
					url = %DEFAULT_LABEL%\%top%\%sec%
				}
				else
				{
					url = %DEFAULT_LABEL%\%url%
				}
				ControlSetText, Edit1, %url%, ahk_class CabinetWClass
				Send {Enter}
				url := ""
			}
		}

	return
	
; Explorer omnibox control
	F6::
		Send {F4}
		Send ^a
	return
	F4::F4
	
	End::
		ControlGetFocus, ctrl, ahk_class CabinetWClass
		if (ctrl == "Edit1")
			send ^{Right 10}
		else
			Send {end}
	return
	+End::
		ControlGetFocus, ctrl, ahk_class CabinetWClass
		if (ctrl == "Edit1")
			send +{Right 255}
		else
			Send +{End}
	return
	Home::
		ControlGetFocus, ctrl, ahk_class CabinetWClass
		if (ctrl == "Edit1")
			send ^{Left 10}
		else
			Send {Home}
	return
	+Home::
		ControlGetFocus, ctrl, ahk_class CabinetWClass
		if (ctrl == "Edit1")
			send ^+{left 10}
		else
			Send +{home}
	return
#IfWinactive
