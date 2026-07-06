-- SPRINT 04

/* 01
"Temos clientes reclamando que alguns pedidos ainda não foram pagos. Preciso saber quais são eles."
Retorne: Número do pedido, Data do pedido, Nome do cliente
Regra: Mostrar apenas pedidos que não possuem nenhum pagamento cadastrado.
*/
CREATE OR ALTER VIEW vw_ClientesQueNaoPagaram AS
SELECT PE.IdPedido AS [Número do Pedido], PE.DataPedido AS [Data do Pedido], CL.NomeCliente AS [Nome do Cliente]
FROM Pedido PE
    JOIN Cliente CL ON PE.IdCliente = CL.IdCliente
    LEFT JOIN Pagamento PA ON PE.IdPedido = PA.IdPedido
WHERE PA.IdPagamento IS NULL;
SELECT * FROM vw_ClientesQueNaoPagaram

/* 02
"Quero entrar em contato com quem ainda não concluiu o pagamento."
Retorne: Cliente, Pedido, Forma de pagamento, Valor, Status
Regra: Mostrar apenas pagamentos com status Pendente.
Ordenar pela data do pagamento.
*/
CREATE OR ALTER PROCEDURE sp_ClientesQueNaoConseguiramPagar
AS
BEGIN
SELECT CL.NomeCliente [Nome do Cliente], PE.IdPedido [Qual Pedido Pertence], PA.FormaPagamento [Forma de Pagamento], PA.ValorPago [ValorPago], 
PA.StatusPagamento [Status do Pagamento]
FROM Pagamento PA
	JOIN Pedido PE ON PE.IdPedido = PA.IdPedido
	JOIN Cliente CL ON PE.IdCliente = CL.IdCliente
WHERE PA.StatusPagamento = 'Pendente'
ORDER BY PA.DataPagamento;
END;
EXEC sp_ClientesQueNaoConseguiramPagar

/* 03
"Na reunião da diretoria perguntaram quanto recebemos em cada forma de pagamento."
Retorne: Forma de pagamento, Quantidade de pagamentos aprovados, Valor total recebido
Regra: Considerar somente pagamentos aprovados.
Ordenar do maior faturamento para o menor.
*/
CREATE OR ALTER PROCEDURE sp_PagamentosAprovadosPorForma
AS
BEGIN
SELECT PA.FormaPagamento [Forma de Pagamento], COUNT(*) [Quantos Pagamento Aprovados], SUM(PA.ValorPago) [Soma dos Valores Pagos]
FROM Pagamento PA
WHERE PA.StatusPagamento = 'Aprovado'
GROUP BY PA.FormaPagamento
ORDER BY [Soma dos Valores Pagos] DESC
END;
EXEC sp_PagamentosAprovadosPorForma

/* 04
"Alguns pagamentos foram recusados e o cliente tentou outra vez."
Retorne: Nome do cliente, Número do pedido, Quantidade de tentativas de pagamento
Regra: Mostrar apenas pedidos que possuem mais de um pagamento.
*/
CREATE OR ALTER VIEW vw_TentativasDePagamentos
AS
SELECT CL.NomeCliente [Nome do Cliente], PE.IdPedido [Número do Pedido], COUNT(*) [Quantidade de Tentativas]
FROM Pagamento PA
	JOIN Pedido PE ON PA.IdPedido = PE.IdPedido
	JOIN Cliente CL ON PE.IdCliente = CL.IdCliente
GROUP BY CL.NomeCliente, PE.IdPedido
HAVING COUNT(*) > 1
SELECT * FROM vw_TentativasDePagamentos

/* 05
"Quanto dinheiro devolvemos aos clientes?"
Retorne apenas: Valor total estornado.
*/
CREATE OR ALTER VIEW vw_DinheiroEstornado
AS
SELECT SUM(PA.ValorPago) [Valor Estornado ao cliente]
FROM Pagamento PA
WHERE PA.StatusPagamento = 'Estornado'

SELECT * FROM vw_DinheiroEstornado

/* 06
O diretor pediu um relatório para a reunião.
Mostrar: Mês, Quantidade de pagamentos aprovados, Valor total recebido, Ticket médio (valor médio dos pagamentos), Maior pagamento do mês, Menor pagamento do mês
Regras: Considerar apenas pagamentos Aprovados. Agrupar por mês. Ordenar do mês mais recente para o mais antigo.
*/
CREATE OR ALTER PROCEDURE sp_RelatorioFinanceiroMes 
AS
BEGIN
SELECT DATEPART (MM, PA.DataPagamento) AS 'Mês Referente', DATEPART (YYYY, PA.DataPagamento) AS 'Ano Referente', COUNT (*) [Quantidade de Pagamentos Aprovados], SUM (PA.ValorPago) [Soma dos Valores Pagos],
AVG (PA.ValorPago) [Ticket Médio], MAX (PA.ValorPago) [Maior Valor Pago], MIN (PA.ValorPago) [Menor Valor Pago]
FROM Pagamento PA
WHERE PA.StatusPagamento = 'Aprovado'
GROUP BY DATEPART (MM, PA.DataPagamento), DATEPART (YYYY, PA.DataPagamento)
ORDER BY DATEPART (MM, PA.DataPagamento) DESC, DATEPART (YYYY, PA.DataPagamento)
END;
EXEC sp_RelatorioFinanceiroMes