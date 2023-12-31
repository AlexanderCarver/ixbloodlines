ITEM.name = "Игральные кости"
ITEM.description = "Кам."
ITEM.longdesc = " Кам."
ITEM.model = "models/lostsignalproject/items/misc/jar.mdl"

ITEM.width = 1
ITEM.height = 1

ITEM.price = 300

ITEM.maxDie = 6

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("diecount")) then
			draw.SimpleText("d:"..item:GetData("diecount", 1), "ixSmallFont", 3, h - 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black)
		end
	end
end

ITEM.functions.Roll = {
	name = "Разыграть",
	icon = "icon16/stalker/dice.png",
	sound = "stalkersound/inv_slot.mp3",
	OnRun = function(item)
		local client = item.player
		local resultsum = 0
		local resultstr = ""
		for i = 1, item:GetData("diecount", 1) do
			local randommeme = math.random(1,6)
			resultsum = resultsum+randommeme
			resultstr = resultstr.." "..randommeme
			if i ~= item:GetData("diecount", 1) then
				if i == (item:GetData("diecount", 1) - 1) then
					resultstr = resultstr.." и "
				else
					resultstr = resultstr..","
				end
			end
		end

		if item:GetData("diecount", 1) > 1 then
			resultstr = resultstr.." тотально "..resultsum
		end

		ix.chat.Send(client, "iteminternal", "трясёт в руках игральные кости и выбрасвыает "..resultstr.."." , false)
		return false
	end,
}

ITEM.functions.Amount = {
	name = "Кратность",
	icon = "icon16/coins.png",
	sound = "physics/body/body_medium_impact_soft1.wav",
	isMulti = true,
	multiOptions = function(item, client)
		local targets = {}
        local tempName
		for i=1,item.maxDie do
			if i == 1 then
					tempName = i.." die"
			else
					tempName = i.." dice"
			end
			table.insert(targets, {
				name = tempName,
				data = {i} ,
			})
		end

		return targets
	end,
	OnCanRun = function(item)
		return (!IsValid(item.entity))
	end,
	OnRun = function(item, data)
		if !data[1] then
			return false
		end

		item:SetData("diecount", data[1])

		return false
	end,
}

function ITEM:OnInstanced(invID, x, y)
	if !self:GetData("diecount") then
		self:SetData("diecount", 1)
	end
end
