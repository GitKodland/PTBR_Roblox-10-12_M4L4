-- Criando a interface gráfica (GUI) para o cronômetro
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
local textLabel = Instance.new("TextLabel", screenGui)

-- Configurando a interface gráfica (GUI)
textLabel.Text = ""
textLabel.TextSize = 60
textLabel.Font = Enum.Font.SourceSansBold

-- Posicionando o TextLabel
textLabel.Position = UDim2.new(0.5, 0, 0.1, 0)

-- Armazenando os nomes dos blocos de Início e Fim
local startName = "Start"
local finishName = "Finish"

-- Criando o cronômetro
local timerStarted = false
local startTime = 0

-- Função que busca o objeto pelo nome
local function findObject(objectName)
	return game.Workspace:WaitForChild(objectName)
end

-- Função que verifica o objeto
local function checkObject(object)
	while true do
		if object then
			print("Objeto localizado: " .. object.Name)
			object.Touched:Connect(function(hit)
				if hit.Parent.Name == game.Players.LocalPlayer.Name then
					-- Verifica se o objeto tocado é o bloco de início
					if object.Name == startName then
						timerStarted = true
						startTime = os.clock()
						textLabel.TextColor3 = Color3.new(0, 0.3, 1)
						textLabel.Text = "Início!"
					-- Verifica se o objeto tocado é o bloco de fim e se o cronômetro foi iniciado
					elseif object.Name == finishName and timerStarted then
						timerStarted = false
						textLabel.TextColor3 = Color3.new(1, 0, 0)
						local finishTime = os.clock()
						local raceTime = finishTime - startTime
						local seconds = math.floor(raceTime)
						local milliseconds = math.floor((raceTime - seconds) * 100)
						local timeend = string.format("%02d:%02d", seconds, milliseconds)
						textLabel.Text = "Seu tempo foi: "..timeend.." segundos"
					end
				end
			end)
			return
		else
			wait(1) -- Pausa de 1 segundo antes de tentar buscar novamente
		end
	end
end

-- Executa uma coroutine para buscar o objeto de início
coroutine.wrap(function()
	local startObject = findObject(startName)
	checkObject(startObject)
end)()

-- Executa uma coroutine para buscar o objeto de fim
coroutine.wrap(function()
	local finishObject = findObject(finishName)
	checkObject(finishObject)
end)()

-- Código que atualiza o cronômetro a cada centésimo de segundo
while wait(0.01) do
	if timerStarted then
		local currentTime = os.clock()
		local elapsedTime = currentTime - startTime
		local seconds = math.floor(elapsedTime)
		local milliseconds = math.floor((elapsedTime - seconds) * 100)
		textLabel.Text = string.format("%02d:%02d", seconds, milliseconds)
	end
end
