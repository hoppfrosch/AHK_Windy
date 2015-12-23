NDSummary.OnToolTipsLoaded("AutoHotKeyClass:MultiMony",{117:"<div class=\"NDToolTip TClass LAutoHotKey\"><div class=\"TTSummary\">Handling Multiple Display-Monitor Environments</div></div>",119:"<div class=\"NDToolTip TInformation LAutoHotKey\"><div class=\"TTSummary\">This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See WTFPL for more details.</div></div>",121:"<div class=\"NDToolTip TProperty LAutoHotKey\"><div class=\"TTSummary\">Debug flag for debugging the object</div></div>",122:"<div class=\"NDToolTip TProperty LAutoHotKey\"><div class=\"TTSummary\">Number of available monitors.</div></div>",123:"<div class=\"NDToolTip TProperty LAutoHotKey\"><div class=\"TTSummary\">Get the size of virtual screen in Pixel as a rectangle.</div></div>",124:"<div class=\"NDToolTip TProperty LAutoHotKey\"><div class=\"TTSummary\">Version of the class</div></div>",125:"<div class=\"NDToolTip TProperty LAutoHotKey\"><div class=\"TTSummary\">Get the size of virtual screen in Pixel as a rectangle.</div></div>",127:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype127\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">coordDisplayToVirtualScreen(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first\">id&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHNumber\">1</span>,</td></tr><tr><td class=\"PName first\">x&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHNumber\">0</span>,</td></tr><tr><td class=\"PName first\">y&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHNumber\">0</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Transforms coordinates relative to given monitor into absolute (virtual) coordinates. Returns object of type point</div></div>",128:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype128\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">coordVirtualScreenToDisplay(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first last\">x,</td></tr><tr><td class=\"PName first last\">y</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Transforms absolute coordinates from Virtual Screen into coordinates relative to screen.</div></div>",129:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype129\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">hmonFromCoord(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first\">x&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHString\">&quot;&quot;</span>,</td></tr><tr><td class=\"PName first\">y&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHString\">&quot;&quot;</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Get the handle of the monitor containing the specified x and y coordinates.</div></div>",130:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype130\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">hmonFromHwnd(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first last\">hwnd</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Get the handle of the monitor containing the swindow with given window handle.</div></div>",131:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype131\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">hmonFromid(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first\">id&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHNumber\">1</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Get the handle of the monitor from monitor id.</div></div>",132:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype132\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">hmonFromRect(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first last\">x,</td></tr><tr><td class=\"PName first last\">y,</td></tr><tr><td class=\"PName first last\">w,</td></tr><tr><td class=\"PName first last\">h</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Get the handle of the monitor that has the largest area of intersection with a specified rectangle.</div></div>",133:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype133\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">identify(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first\">disptime&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHNumber\">1500</span>,</td></tr><tr><td class=\"PName first\">txtcolor&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHString\">&quot;000000&quot;</span>,</td></tr><tr><td class=\"PName first\">txtsize&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHNumber\">300</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Identify monitors by displaying the monitor id on each monitor</div></div>",134:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype134\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">idFromCoord(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first\">x,</td><td></td><td class=\"last\"></td></tr><tr><td class=\"PName first\">y,</td><td></td><td class=\"last\"></td></tr><tr><td class=\"PName first\">default&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHNumber\">1</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Get the index of the monitor containing the specified x and y coordinates.</div></div>",135:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype135\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">idFromHwnd(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first last\">hwnd</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Get the ID of the monitor containing the swindow with given window handle.</div></div>",136:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype136\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">idFromMouse(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first\">default</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHNumber\">1</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Get the index of the monitor where the mouse is</div></div>",137:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype137\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">idFromHmon(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first last\">hmon</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Get the index of the monitor from monitor handle</div></div>",138:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype138\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">idFromRect(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first last\">x,</td></tr><tr><td class=\"PName first last\">y,</td></tr><tr><td class=\"PName first last\">w,</td></tr><tr><td class=\"PName first last\">h</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Get the ID of the monitor that has the largest area of intersection with a specified rectangle.</div></div>",139:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype139\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">idNext(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first\">currMon&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHNumber\">1</span>,</td></tr><tr><td class=\"PName first\">cycle&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHKeyword\">true</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Gets the id of the next monitor.</div></div>",140:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype140\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">idPrev(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first\">currMon&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHNumber\">1</span>,</td></tr><tr><td class=\"PName first\">cycle&nbsp;</td><td class=\"PDefaultValueSeparator\">:=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHKeyword\">true</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Gets the id of the previous monitor</div></div>",141:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype141\" class=\"NDPrototype NoParameterForm\">monitors()</div><div class=\"TTSummary\">Enumerates display monitors and returns an object all monitors (list of Mony object )</div></div>",142:"<div class=\"NDToolTip TFunction LAutoHotKey\"><div id=\"NDPrototype142\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\">__New(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PName first\">_debug</td><td class=\"PDefaultValueSeparator\">=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHKeyword\">false</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Constructor (<b>INTERNAL</b>)</div></div>"});