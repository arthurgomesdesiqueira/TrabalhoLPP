local filename = "prog.bpl"
if not filename then
   print("Usage: lua interpretador.lua <prog.bpl>")
   os.exit(1)
end

local file = io.open(filename, "r")
if not file then
   print(string.format("[ERRO] Cannot open file %q", filename))
   os.exit(1)
end




-- Salva todas as linhas do codigo na variavel linhas
linhas = {}
for line in file:lines() do

	linhas[#linhas + 1] = line
end


-- Descobrir onde está a main
for i=1, #linhas do
	
	if	string.find(linhas[i], "function main()") ~= nil then
		
		mainposicao = i
	end

end





var = {}


while string.find(linhas[mainposicao], "end") == nil do
	
	
	-- Salvar as variaveis(var)
	str = string.match(linhas[mainposicao], "var %a+%[?%d?%]?")	
	if str ~= nil then
		numerovetor = string.match(str, "[%d]")
		str = string.match(str, "var (%a+)")
		
		-- Caso seja um vetor
		if numerovetor ~= nil then
		
			var[str] = {}
			for tam=1,numerovetor do
				var[str][tam] = 0
			end
		
		-- Caso seja uma variavel escalar
		else
			var[str] = 0
			
		end

	end



	














	mainposicao = mainposicao + 1

end










































file:close()
