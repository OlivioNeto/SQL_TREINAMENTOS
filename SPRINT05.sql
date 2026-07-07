-- SPRINT 05

/*
"Quero descobrir quais vendedores estão trazendo mais dinheiro para a empresa."
Entregue um relatório contendo: Nome do vendedor, Quantidade de pedidos, Valor total vendido, Ticket médio (valor médio por pedido).
Regras
Considerar apenas pagamentos aprovados.
Mostrar somente vendedores com pelo menos 2 vendas aprovadas.
Ordenar do maior faturamento para o menor.
*/
CREATE OR ALTER PROCEDURE sp_VendedoresMaisFaturamento
AS
BEGIN
SELECT VE.NomeVendedor [Vendedor Responsável], COUNT (PE.IdPedido) [Quantidade de Pedidos], SUM (PA.ValorPago) [Valor Total Pago], AVG (PA.ValorPago) [Ticket Médio]
FROM Pagamento PA
	JOIN Pedido PE ON PA.IdPedido = PE.IdPedido
	JOIN Vendedor VE ON PE.IdVendedor = VE.IdVendedor
WHERE PA.StatusPagamento = 'Aprovado'
GROUP BY VE.IdVendedor, VE.NomeVendedor
HAVING COUNT (PE.IdPedido) >= 2
ORDER BY SUM (PA.ValorPago) DESC
END;
EXEC sp_VendedoresMaisFaturamento

/*
"Tenho vendedores ativos e inativos. Quero saber quais vendedores ativos ainda não realizaram nenhuma venda aprovada."
Entregar: Nome do vendedor, Data de admissão, Comissão, Meta de vendas
Regras
Mostrar apenas vendedores ativos (VendedorAtivo = 'S').
Mostrar somente quem não possui nenhuma venda aprovada.
Ordenar pelo vendedor admitido há mais tempo.
*/	
CREATE OR ALTER PROCEDURE sp_DesempenhoVendedores
AS
BEGIN
SELECT VE.NomeVendedor [Vendedor Responsável], VE.DataAdmissaoVendedor [Data de Admissão], VE.PercentualComissaoVendedor [Comissão do Vendedor],
VE.MetaVendasVendedor [Meta de Vendas]
FROM Vendedor VE
	LEFT JOIN Pedido PE ON PE.IdVendedor = VE.IdVendedor
	LEFT JOIN Pagamento PA ON PA.IdPedido = PE.IdPedido AND PA.StatusPagamento = 'Aprovado'
WHERE VE.VendedorAtivo = 'S' AND PA.IdPagamento IS NULL
ORDER BY VE.DataAdmissaoVendedor;
END;
EXEC sp_DesempenhoVendedores

/* 01
"Quero saber quais vendedores mais venderam."
Mostrar: Nome do vendedor, Quantidade de pedidos aprovados, Valor vendido, Comissão estimada
A comissão deve ser calculada assim: Valor vendido * PercentualComissao / 100
Ordenar: maior comissão
*/
CREATE OR ALTER PROCEDURE sp_VendedoresQueMaisVenderam
AS
BEGIN
SELECT VE.NomeVendedor [Vendedor Resposável], COUNT (PE.IdPedido) [Quantidade de Pedidos Aprovados], SUM (PA.ValorPago) [Valor Pago], 
SUM (PA.ValorPago) * VE.PercentualComissaoVendedor / 100 [Comissão Estimada]
FROM Pedido PE
	JOIN Vendedor VE ON PE.IdVendedor = VE.IdVendedor
	JOIN Pagamento PA ON PA.IdPedido = PE.IdPedido
WHERE PA.StatusPagamento = 'Aprovado'
GROUP BY VE.NomeVendedor, VE.PercentualComissaoVendedor
ORDER BY [Comissão Estimada] DESC;
END;
EXEC sp_VendedoresQueMaisVenderam

/* 02
O gerente comercial quer descobrir quais vendedores ainda não atingiram a meta de vendas.
Mostrar: Nome do vendedor, Meta de vendas, Valor vendido (somente pagamentos aprovados), Diferença para a meta (Meta - Valor vendido)
Regras:
Considerar apenas vendedores ativos.
Mostrar somente vendedores cujo valor vendido seja menor que a meta.
Caso um vendedor ativo não tenha nenhuma venda aprovada, ele também deve aparecer com Valor Vendido = 0.
Ordenar pela maior diferença para a meta (quem está mais distante de bater a meta aparece primeiro).
*/
CREATE OR ALTER PROCEDURE sp_VendedoresAbaixoMeta
AS
BEGIN
SELECT VE.NomeVendedor [Vendedor Responsável], VE.MetaVendasVendedor [Meta de Vendas], ISNULL(SUM(PA.ValorPago), 0) [Valor Vendido],
VE.MetaVendasVendedor - ISNULL(SUM(PA.ValorPago), 0) [Quanto Falta Para Bater a Meta]
FROM Vendedor VE
    LEFT JOIN Pedido PE ON PE.IdVendedor = VE.IdVendedor
    LEFT JOIN Pagamento PA ON PA.IdPedido = PE.IdPedido AND PA.StatusPagamento = 'Aprovado'
WHERE VE.VendedorAtivo = 'S'
GROUP BY VE.NomeVendedor, VE.MetaVendasVendedor
HAVING ISNULL(SUM(PA.ValorPago), 0) < VE.MetaVendasVendedor
ORDER BY [Quanto Falta Para Bater a Meta] DESC;
END;
EXEC sp_VendedoresAbaixoMeta;

/* 03
O gerente comercial pediu um relatório.
Mostrar: Nome do vendedor, Quantidade de clientes diferentes atendidos, Quantidade de pedidos aprovados, Valor total vendido
Regras:
Considerar apenas pagamentos aprovados.
Mostrar somente vendedores ativos.
Mostrar apenas vendedores que atenderam 2 ou mais clientes diferentes.
Ordenar pelo maior valor vendido.
*/
CREATE OR ALTER PROCEDURE sp_VendedoresAtivosMaisPagamentosAprovador
AS
BEGIN
SELECT VE.NomeVendedor [Nome do Vendedor], COUNT(DISTINCT CL.IdCliente) [Clientes Diferentes Atendidos], COUNT(PE.IdPedido) [Quantidade de Pedidos], 
SUM(PA.ValorPago) [Soma dos Valores Pagos]
FROM Vendedor VE
	JOIN Pedido PE ON PE.IdVendedor = VE.IdVendedor
	JOIN Pagamento PA ON PA.IdPedido = PE.IdPedido AND PA.StatusPagamento = 'Aprovado'
	JOIN Cliente CL ON PE.IdCliente = CL.IdCliente
WHERE VE.VendedorAtivo = 'S'
GROUP BY VE.NomeVendedor
HAVING COUNT(DISTINCT CL.IdCliente) >= 2
ORDER BY SUM(PA.ValorPago) DESC
END;
EXEC sp_VendedoresAtivosMaisPagamentosAprovador;

/* 04
"Quero descobrir quais categorias mais faturaram."
Mostrar: Categoria, Quantidade vendida, Valor faturado
Agrupar por categoria.
*/
CREATE OR ALTER VIEW vw_QuantidadeProdutosVendidosPorCategoria AS
SELECT CA.NomeCategoria [Categoria do Produto], SUM(ITP.QuantidadeItemPedido) [Quantidade Vendida], SUM(ITP.QuantidadeItemPedido * ITP.ValorUnitario) [Valor Faturado]
FROM Produto PR 
	JOIN Categoria CA ON PR.IdCategoria = CA.IdCategoria
	JOIN ItemPedido ITP ON PR.IdProduto = ITP.IdProduto
GROUP BY CA.NomeCategoria
SELECT * FROM vw_QuantidadeProdutosVendidosPorCategoria

/* 05
"Quero descobrir qual fornecedor movimentou mais dinheiro."
Mostrar: Fornecedor, Quantidade de produtos vendidos, Valor faturado
Ordenar do maior para o menor.
*/
CREATE OR ALTER PROCEDURE sp_FornecedorMaisDinheiro
AS
BEGIN
SELECT FO.NomeFornecedor [Fornecedor do Produto], SUM(ITP.QuantidadeItemPedido) [Quantidade Vendida], SUM(ITP.QuantidadeItemPedido * ITP.ValorUnitario) [Valor Faturado]
FROM Fornecedor FO
	JOIN Produto PR ON PR.IdFornecedor = FO.IdFornecedor
	JOIN ItemPedido ITP ON ITP.IdProduto = PR.IdProduto
GROUP BY FO.NomeFornecedor
ORDER BY [Valor Faturado] DESC
END;
EXEC sp_FornecedorMaisDinheiro

/* 06
"Quero descobrir quais marcas mais venderam."
Mostrar: Marca, Quantidade vendida, Valor faturado
*/
CREATE OR ALTER VIEW vw_QuantidadeVendidaPorMarcaValores
AS
SELECT MA.NomeMarca [Nome da Marca], SUM(ITP.QuantidadeItemPedido) [Quantidade Vendida], SUM(ITP.QuantidadeItemPedido * ITP.ValorUnitario) [Valor Faturado]
FROM Marca MA
	JOIN Produto PR ON PR.IdMarca = MA.IdMarca
	JOIN ItemPedido ITP ON ITP.IdProduto = PR.IdProduto
GROUP BY MA.NomeMarca
SELECT * FROM vw_QuantidadeVendidaPorMarcaValores

/* 07
O diretor pediu um relatório enorme.
Mostrar: Vendedor, Cliente, Produto, Marca, Categoria, Forma de pagamento, Data, Quantidade, Valor unitário, Valor total
Regras:
somente pagamentos aprovados;
apenas produtos com estoque menor que 30;
apenas vendedores ativos;
apenas clientes com e-mail cadastrado.
Ordenar:
vendedor
data
maior valor vendido
*/
CREATE OR ALTER PROCEDURE sp_QuantidadePedidosAprovadosVendedoresAtivosEstoqueMaisTrinta
AS
BEGIN
SELECT VE.NomeVendedor [Nome do Vendedor], CL.NomeCliente [Cliente que Comprou], PR.NomeProduto [Produto Comprado],
MA.NomeMarca [Marca do Produto], CA.NomeCategoria [Categoria do Produto], PA.FormaPagamento [Forma de Pagamento], PA.DataPagamento [Data do Pagamento],
ITP.QuantidadeItemPedido [Quantidade do Item], ITP.ValorUnitario [Valor do Item],
(ITP.QuantidadeItemPedido * ITP.ValorUnitario) [Valor Total do Item]
FROM ItemPedido ITP
	JOIN Produto PR ON ITP.IdProduto = PR.IdProduto AND PR.EstoqueProduto < 30
	JOIN Pedido PE ON ITP.IdPedido = PE.IdPedido
	JOIN Vendedor VE ON PE.IdVendedor = VE.IdVendedor AND VE.VendedorAtivo = 'S'
	JOIN Cliente CL ON PE.IdCliente = CL.IdCliente AND CL.EmailCliente IS NOT NULL
	JOIN Marca MA ON PR.IdMarca = MA.IdMarca
	JOIN Pagamento PA ON PA.IdPedido = PE.IdPedido AND PA.StatusPagamento = 'Aprovado'
	JOIN Categoria CA ON PR.IdCategoria = CA.IdCategoria
ORDER BY VE.NomeVendedor, PA.DataPagamento, [Valor Total do Item] DESC;
END;
EXEC sp_QuantidadePedidosAprovadosVendedoresAtivosEstoqueMaisTrinta

/* 08
Mostrar: Nome do vendedor, Quantidade de pedidos, Clientes diferentes atendidos, Produtos diferentes vendidos, Valor vendido, Ticket médio,
Comissão, Meta, Percentual da meta atingido
Regras:
considerar apenas pagamentos aprovados;
mostrar somente vendedores ativos;
exibir apenas vendedores com pelo menos 2 pedidos aprovados.
Ordenação:
Maior percentual da meta
Maior faturamento
*/
SELECT VE.NomeVendedor [Nome do Vendedor], COUNT(PE.IdPedido) [Quantidade de Pedidos], COUNT(DISTINCT CL.IdCliente) [Clientes Diferentes Atendidos],
COUNT(DISTINCT PR.IdProduto) [Produtos Diferentes Vendidos], SUM(ITP.QuantidadeItemPedido * ITP.ValorUnitario) [Valor Vendido], AVG (PA.ValorPago) [Ticket Médio],
SUM(ITP.QuantidadeItemPedido * ITP.ValorUnitario) * VE.PercentualComissaoVendedor / 100 [Comissão], VE.MetaVendasVendedor [Meta de Vendas], 
(SUM(ITP.QuantidadeItemPedido * ITP.ValorUnitario) / VE.MetaVendasVendedor) * 100 [Percentual da Meta Atingida]
FROM ItemPedido ITP
	JOIN Pedido PE ON ITP.IdPedido = PE.IdPedido
	JOIN Vendedor VE ON PE.IdVendedor = VE.IdVendedor AND VE.VendedorAtivo = 'S'
	JOIN Cliente CL ON PE.IdCliente = CL.IdCliente
	JOIN Produto PR ON ITP.IdProduto = PR.IdProduto
	JOIN Pagamento PA ON PA.IdPedido = PE.IdPedido AND PA.StatusPagamento = 'Aprovado'
GROUP BY VE.NomeVendedor, VE.PercentualComissaoVendedor, VE.MetaVendasVendedor
HAVING COUNT(DISTINCT PE.IdPedido) >= 2
ORDER BY [Percentual da Meta Atingida] DESC, [Valor Vendido] DESC