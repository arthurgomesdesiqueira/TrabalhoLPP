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


-- Salvar os dados das variaveis
var = {}
-- Salva todas as linhas do codigo na variavel linhas
linhas = {}



for line in file:lines() do

	linhas[#linhas + 1] = line
end


-- Descobrir onde está a funçao
function DescobrirPosicaodaFuncao(nomedafuncao)
	for i=1, #linhas do
		
		if	string.find(linhas[i], nomedafuncao) ~= nil then
		
			posicao_funcao = i
		end

	end

	return posicao_funcao
end


--Executando a funçao
function funcao(nomedafuncao)

	-- Pega a linha da função
	local posicao = DescobrirPosicaodaFuncao(nomedafuncao)
	
	--Executa até o begin
	while string.find(linhas[posicao], "^begin") == nil do
	
		-- Salvar as variaveis(var)
		str = string.match(linhas[posicao], "var %a+%[?%d?%]?")	
		if str ~= nil then
			numerovetor = string.match(str, "[%d]")
			str = string.match(str, "var (%a+)")
		
			-- Caso seja um vetor
			if numerovetor ~= nil then
		
				var[str] = {}
				for tam=0,tonumber(numerovetor)-1 do
					var[str][tam] = 0
				end
		
			-- Caso seja uma variavel escalar
			else
				var[str] = 0
			
			end

		end
		
		posicao = posicao + 1
		
	end





	--Executa até o end
	while string.find(linhas[posicao], "^end") == nil do
	
		local valor_total

		-- Verificando se é uma atribuição
		if string.find(linhas[posicao], "%a+%[?%d?%]? = .+") ~= nil then

			-- nome_da_variavel e qtd_do_vetor pode ser variavel escalar ou vetorial
			-- qtd_do_vetor pode ter valor ou ser vazio
			nome_da_variavel, qtd_do_vetor, dpp_da_atribuicao = string.match(linhas[posicao], "(%a+)%[?(%d?)%]? = (.+)") 


			antes_da_operacao, operacao, depois_da_operacao = string.match(dpp_da_atribuicao, "(.+) ([%+%-/%*]?) (.*)")			



			-- Sem a operação(+ ou - ou / ou *)
			if antes_da_operacao == nil then

				antes_da_operacao = string.match(dpp_da_atribuicao, "(.+)")	
				operacao = nil
				depois_da_operacao = nil

				--print(string.format("dpp_da_atribuicao = %s", dpp_da_atribuicao))


				-- Se o valor for constante
				numero_constante = string.match(antes_da_operacao, "%d")
				if numero_constante ~= nil then
					valor_total = numero_constante
				end	

				-- Se o valor for escalar
				numero_escalar = string.match(antes_da_operacao, "%a+")
				if numero_escalar ~= nil then
					valor_total = var[numero_escalar]
				end

				-- Se o valor for vetorial
				numero_vetorial, qtd_numero_vetorial = string.match(antes_da_operacao, "(%a+)%[?(%d?)%]?")
				if qtd_numero_vetorial ~= "" and numero_vetorial ~= nil and qtd_numero_vetorial ~= nil then
					valor_total = var[numero_vetorial][tonumber(qtd_numero_vetorial)]						
				end



				--------------- TEM QUE ARRUMAR 
				-- Se o valor for uma função
				numero_funcao = string.match(antes_da_operacao, "%a+%(.*%)")
				
				-- Esse criterio ocorre quando está chamando alguma funçao
				-- para ser executada
				--if numero_funcao ~= nil then
				--	valor_total = numero_funcao
				--end

				--------------- TEM QUE ARRUMAR 
			
--[[


				--print(string.format("numero_constante = %s", numero_constante))
				--print(string.format("numero_escalar = %s", numero_escalar))
				--print(string.format("numero_vetorial = %s[%s]", numero_vetorial, qtd_numero_vetorial))
				--print(string.format("numero_funcao = %s", numero_funcao))

				--print(string.format("valor_total = %s", valor_total))

]]


			-- Com a operação(+ ou - ou / ou *)
			else
--[[
				--print(string.format("dpp_da_atribuicao = %s", dpp_da_atribuicao))
				--print(string.format("antes_da_operacao = %s", antes_da_operacao))
				--print(string.format("operação = %s", operacao))
				--print(string.format("depois_da_operacao = %s", depois_da_operacao))
]]

				local valor_esq, valor_dir


				---------------- Lado esquerdo --------------------------

				-- Se o valor for constante
				numero_constante = string.match(antes_da_operacao, "%d")
				if numero_constante ~= nil then
					valor_esq = numero_constante
				end	

				-- Se o valor for escalar
				numero_escalar = string.match(antes_da_operacao, "%a+")
				if numero_escalar ~= nil then
					valor_esq = var[numero_escalar]
				end

				-- Se o valor for vetorial
				numero_vetorial, qtd_numero_vetorial = string.match(antes_da_operacao, "(%a+)%[?(%d?)%]?")
				if qtd_numero_vetorial ~= "" and numero_vetorial ~= nil and qtd_numero_vetorial ~= nil then
					valor_esq = var[numero_vetorial][tonumber(qtd_numero_vetorial)]						
				end


				--------------- TEM QUE ARRUMAR 
				-- Se o valor for uma função
				numero_funcao = string.match(antes_da_operacao, "%a+%(.*%)")
				
				-- Esse criterio ocorre quando está chamando alguma funçao
				-- para ser executada
				--if numero_funcao ~= nil then
				--	valor_esq = numero_funcao
				--end

				--------------- TEM QUE ARRUMAR 
				


--[[
				print(string.format("numero_constante = %s", numero_constante))
				print(string.format("numero_escalar = %s", numero_escalar))
				print(string.format("numero_vetorial = %s[%s]", numero_vetorial, qtd_numero_vetorial))
				print(string.format("numero_funcao = %s", numero_funcao))

				print(string.format("valor_esq = %s", valor_esq))

]]

				---------------- Lado direito --------------------------



				-- Se o valor for constante
				numero_constante = string.match(depois_da_operacao, "%d")
				if numero_constante ~= nil then
					valor_dir = numero_constante
				end	

				-- Se o valor for escalar
				numero_escalar = string.match(depois_da_operacao, "%a+")
				if numero_escalar ~= nil then
					valor_dir = var[numero_escalar]
				end

				-- Se o valor for vetorial
				numero_vetorial, qtd_numero_vetorial = string.match(depois_da_operacao, "(%a+)%[?(%d?)%]?")
				if qtd_numero_vetorial ~= "" and numero_vetorial ~= nil and qtd_numero_vetorial ~= nil then
					valor_dir = var[numero_vetorial][tonumber(qtd_numero_vetorial)]						
				end





				--------------- TEM QUE ARRUMAR 
				-- Se o valor for uma função
				numero_funcao = string.match(depois_da_operacao, "%a+%(.*%)")
				-- Esse criterio ocorre quando está chamando alguma funçao
				-- para ser executada
				--if numero_funcao ~= nil then
				--	valor_dir = numero_funcao
				--end
				--------------- TEM QUE ARRUMAR 



--[[
				

				print(string.format("numero_constante = %s", numero_constante))
				print(string.format("numero_escalar = %s", numero_escalar))
				print(string.format("numero_vetorial = %s[%s]", numero_vetorial, qtd_numero_vetorial))
				print(string.format("numero_funcao = %s", numero_funcao))

				print(string.format("valor_dir = %s", valor_dir))
]]


				-- Resolve a operação juntando valor_esq com valor_dir
				if operacao == "+" then
					valor_total = tonumber(valor_esq) + tonumber(valor_dir)
				end	
				if operacao == "-" then
					valor_total = tonumber(valor_esq) - tonumber(valor_dir)
				end
				if operacao == "*" then
					valor_total = tonumber(valor_esq) * tonumber(valor_dir)
				end
				if operacao == "/" then
					valor_total = tonumber(valor_esq) / tonumber(valor_dir)
				end


				--print(string.format("valor_total = %d", valor_total))



			end

			if qtd_do_vetor == "" or qtd_do_vetor == nil then
				var[nome_da_variavel] = valor_total
				--print(string.format("%s = %d", nome_da_variavel, valor_total))
			else
				var[nome_da_variavel][tonumber(qtd_do_vetor)] = valor_total		
				--print(string.format("%s[%s] = %d", nome_da_variavel, qtd_do_vetor, valor_total))
			end	

			--print()
			--print()
			--print()
			
		end	
		















		posicao = posicao + 1	
	end

end
















-- Começando pela main
funcao("function main()")






file:close()
