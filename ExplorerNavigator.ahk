
transTopDomain(topLevel)
{
	result := ""
	if (topLevel == "src")
		result := "D:\Sources"
	else if (topLevel == "rt" or topLevel == "r" or topLevel == "")
		result := "D:" ; Default top
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
/*
	FoundPos := RegExMatch(domain, "\w+\.\w+\.\w+")
	if (FoundPos == 1)
		return true
	else
		return false
*/
	return true ; Set this always true for expandability of searching folder
}

#IfWinActive, ahk_class CabinetWClass

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

; Explorer Navigator
	Enter::
		ControlGetFocus, ctrl, ahk_class CabinetWClass
		if (ctrl == "Edit1")
		{
			ControlGetText, domain, Edit1, ahk_class CabinetWClass
			domainArray := StrSplit(domain, ".")
			; SubDomain.SecondLevelDomain.TopLevelDomain
			if isDomainvalid(domain)
			{
				subDomain := domainArray[1]
				secDomain := domainArray[2]
				topDomain := domainArray[3]
				realTopDomain := transTopDomain(topDomain)
				
				if (realTopDomain != "")
				{
					path := transDomain(subDomain, secDomain, realTopDomain)
					ControlSetText, Edit1, %path%, ahk_class CabinetWClass
					Send, {enter}
					return
				}
				
			}
			else {
				MsgBox, Domain is invalid
			}
			
		}
		else
			Send, {enter}
	return
#IfWinActive
