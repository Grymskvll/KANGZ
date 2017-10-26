-- Stolen from Atlas

function KANGZButton_OnClick()
	if KANGZ.Running then
		KANGZ:Stop()
	else
		KANGZ:Start();
	end
end

function KANGZButton_BeingDragged()
	-- Thanks to Gello for this code
    local xpos,ypos = GetCursorPosition() 
    local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom() 

    xpos = xmin-xpos/UIParent:GetScale()+70 
    ypos = ypos/UIParent:GetScale()-ymin-70 

    KANGZButton_SetPosition(math.deg(math.atan2(ypos,xpos)));
end
function KANGZButton_Init()
	if(KANGZ_Options.KANGZButtonFrameShown) then
		KANGZButtonFrame:Show();
	else
		KANGZButtonFrame:Hide();
	end
end
function KANGZButton_UpdatePosition()
	KANGZButtonFrame:SetPoint(
		"TOPLEFT",
		"Minimap",
		"TOPLEFT",
		54 - (78 * cos(KANGZ_Options.KANGZButtonPosition)),
		(78 * sin(KANGZ_Options.KANGZButtonPosition)) - 55
	);
	KANGZButton_Init();
end

function KANGZButton_SetPosition(v)
	if(v < 0) then
        v = v + 360;
    end

    KANGZ_Options.KANGZButtonPosition = v;
    KANGZButton_UpdatePosition();
end

local function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

function KANGZButton_OnEnter()
    GameTooltip:SetOwner(this, "ANCHOR_LEFT");
    GameTooltip:SetText(KANGZ_BUTTON_TOOLTIP);
	local running = KANGZ.Running
	if running then
		GameTooltip:AddLine(KANGZ_BUTTON_TOOLTIP2b);
	else
		GameTooltip:AddLine(KANGZ_BUTTON_TOOLTIP2a);
	end
    GameTooltip:AddLine(KANGZ_BUTTON_TOOLTIP3);
    GameTooltip:AddLine(KANGZ_BUTTON_TOOLTIP4);
	
	if running then
		local timeLeft = KANGZ.sessionTimer
		timeLeft = round(timeLeft, 0)
		timeLeft = KANGZ:FormatTime(timeLeft)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(timeLeft)
	end
    GameTooltip:Show();
end