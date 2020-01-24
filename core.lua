local ZoomButton = CreateFrame('Button', 'CamZoomClickyButton')
ZoomButton:RegisterForClicks('ANYDOWN')
SetOverrideBindingClick(ZoomButton, true, 'MOUSEWHEELDOWN', 'CamZoomClickyButton', -1)
SetOverrideBindingClick(ZoomButton, true, 'MOUSEWHEELUP', 'CamZoomClickyButton', 1)

local Hotfixed, ZoomTime, Zooming = tonumber((select(2, GetBuildInfo()))) >= 22371

local function StartZooming(factor)
	if Hotfixed and Zooming < 0 then
		MoveViewOutStart(Zooming * -factor)
	else
		MoveViewInStart(Zooming * factor)
	end
end

local function StopZooming()
	if Hotfixed and Zooming < 0 then
		MoveViewOutStop()
	else
		MoveViewInStop()
	end
end

local function OnUpdate(self, elapsed)
	if not Zooming then
		self:SetScript('OnUpdate', nil)
	else
		if GetTime() - ZoomTime >= 0.5 then
			StopZooming()
			Zooming = nil
		else
			local zoom = GetCameraZoom()
			if zoom < 1000 or Zooming > 0 then
				local factor = max(0.1, zoom / 20)
				StartZooming(factor)
			else
				StopZooming()
				Zooming = nil
			end
		end
	end
end

ZoomButton:SetScript('OnClick', function(self, direction, ...)
	direction = tonumber(direction)
	ZoomTime = GetTime()
	if not Zooming then
		Zooming = direction
		self:SetScript('OnUpdate', OnUpdate)
	else
		if (Zooming < 0 and direction > 0) or (Zooming > 0 and direction < 0) then
			StopZooming()
			Zooming = direction
		else
			Zooming = Zooming + direction
		end
	end
end)