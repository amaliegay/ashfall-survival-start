local common = require("JosephMcKean.ashfallSurvivalStart.common")
local log = common.createLogger("weather")

local function changeWeather()
	timer.start({ type = timer.game, duration = 1, callback = changeWeather })
	local weatherController = tes3.worldController.weatherController
	local currentWeather = weatherController.currentWeather.index
	local randomNumber = math.random()
	local newWeather = randomNumber < 0.62 and tes3.weather.foggy or tes3.weather.thunder
	if newWeather == currentWeather then
		log:debug("Current weather %s, rolled weather %s, not changing", currentWeather, newWeather)
		return
	end
	log:debug("Current weather %s, rolled weather %s", currentWeather, newWeather)
	weatherController:switchTransition(newWeather)
end

---@param e cellChangedEventData
local function onCellChanged(e)
	local cell = e.cell
	if not cell then
		return
	end
	if not cell.id:startswith("Masartus") then
		return
	end
	log:debug("Timer starting")
	changeWeather()
end
event.register("cellChanged", onCellChanged)
