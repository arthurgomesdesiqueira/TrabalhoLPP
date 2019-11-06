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


--Transformando o nome em vetorial
function Transformar_em_Vetorial(nome)

	local numero_vetorial, qtd_numero_vetorial = string.match(nome, "(%a+)%[?(%d?)%]?")
	return numero_vetorial, qtd_numero_vetorial	

end

--Transformando o nome em constante
function Transformar_em_Constante(nome)

	local numero_constante = string.match(nome, "%d")
	return numero_constante
end

--Transformando o nome em escalar
function Transformar_em_Escalar(nome)
	
	local numero_escalar = string.match(nome, "%a+")
	return numero_escalar	
end


-- Descobrir a posicao onde está a funçao
function DescobrirPosicaodaFuncao(nomedafuncao)
	for i=1, #linhas do
		
		if	string.find(linhas[i], nomedafuncao) ~= nil then
		
			posicao_funcao = i
		end

	end

	return posicao_funcao
end


function Verificando_atribuicao(nome)


	-- nome_da_variavel e qtd_do_vetor pode ser variavel escalar ou vetorial
	-- qtd_do_vetor pode ter valor ou ser vazio
	local nome_da_variavel, qtd_do_vetor, dpp_da_atribuicao = string.match(nome, "(%a+)%[?(%d?)%]? = (.+)") 


	local antes_da_operacao, operacao, depois_da_operacao = string.match(dpp_da_atribuicao, "(.+) ([%+%-/%*]?) (.*)")			
	local valor_total   


	-- Sem a operação(+ ou - ou / ou *)
	if antes_da_operacao == nil then

		antes_da_operacao = string.match(dpp_da_atribuicao, "(.+)")	
		operacao = nil
		depois_da_operacao = nil

		--print(string.format("dpp_da_atribuicao = %s", dpp_da_atribuicao))


		-- Se o valor for constante
		numero_constante = Transformar_em_Constante(antes_da_operacao)
		if numero_constante ~= nil then
			valor_total = numero_constante
		end	

		-- Se o valor for escalar
		numero_escalar = Transformar_em_Escalar(antes_da_operacao)
		if numero_escalar ~= nil then
			valor_total = var[numero_escalar]
		end

		-- Se o valor for vetorial
		numero_vetorial, qtd_numero_vetorial = Transformar_em_Vetorial(antes_da_operacao)
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

		print(string.format("numero_constante = %s", numero_constante))
		print(string.format("numero_escalar = %s", numero_escalar))
		print(string.format("numero_vetorial = %s[%s]", numero_vetorial, qtd_numero_vetorial))
		print(string.format("numero_funcao = %s", numero_funcao))
		print(string.format("valor_total = %s", valor_total))

]]


	-- Com a operação(+ ou - ou / ou *)
	else
--[[
		print(string.format("dpp_da_atribuicao = %s", dpp_da_atribuicao))
		print(string.format("antes_da_operacao = %s", antes_da_operacao))
		print(string.format("operação = %s", operacao))
		print(string.format("depois_da_operacao = %s", depois_da_operacao))

]]
		local valor_esq, valor_dir


		---------------- Lado esquerdo --------------------------

		-- Se o valor for constante
		numero_constante = Transformar_em_Constante(antes_da_operacao)
		if numero_constante ~= nil then
			valor_esq = numero_constante
		end	

		-- Se o valor for escalar
		numero_escalar = Transformar_em_Escalar(antes_da_operacao)
		if numero_escalar ~= nil then
			valor_esq = var[numero_escalar]
		end

		-- Se o valor for vetorial
		numero_vetorial, qtd_numero_vetorial = Transformar_em_Vetorial(antes_da_operacao)
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
		numero_constante = Transformar_em_Constante(depois_da_operacao)
		if numero_constante ~= nil then
			valor_dir = numero_constante
		end	

		-- Se o valor for escalar
		numero_escalar = Transformar_em_Escalar(depois_da_operacao)
		if numero_escalar ~= nil then
			valor_dir = var[numero_escalar]
		end

		-- Se o valor for vetorial
		numero_vetorial, qtd_numero_vetorial = Transformar_em_Vetorial(depois_da_operacao)
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

	-- Se for escalar
	if qtd_do_vetor == "" or qtd_do_vetor == nil then
		var[nome_da_variavel] = valor_total
		--print(string.format("%s = %d", nome_da_variavel, valor_total))
		
	-- Se for vetorial
	else
		var[nome_da_variavel][tonumber(qtd_do_vetor)] = valor_total		
		--print(string.format("%s[%s] = %d", nome_da_variavel, qtd_do_vetor, valor_total))
	end	

	--print()
	--print()
	--print()

end


function Verificando_var(nome)
	local str = string.match(nome, "var %a+%[?%d?%]?")	
	local numerovetor

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
end


--Executando a funçao
function funcao(nomedafuncao)

	-- Pega a linha da função
	local posicao = DescobrirPosicaodaFuncao(nomedafuncao)
	
	--Executa até o begin
	while string.find(linhas[posicao], "^begin") == nil do
	
		-- Salvar as variaveis(var)         
		Verificando_var(linhas[posicao])
		posicao = posicao + 1
		
	end


	--Executa até o end
	while string.find(linhas[posicao], "^end") == nil do
	
		
		-- Verificando se é uma atribuição
		if string.find(linhas[posicao], "%a+%[?%d?%]? = .+") ~= nil then
			Verificando_atribuicao(linhas[posicao])
		end


			
		
--[[
		--Aqui é onde ficara o if
		-- Verificando se é um if
		if string.find(linhas[posicao], "") ~= nil then
			Verificando_if(linhas[posicao])

		end

]]













		posicao = posicao + 1	
	end -- Fim do while

end
















-- Começando pela main
funcao("main()")






file:close()
