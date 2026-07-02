-- SPRINT 1
-- O gerente deseja uma lista contendo: Nome do produto, categoria, preço, estoque. Ordene: Categoria, nome do produto
CREATE OR ALTER PROCEDURE sp_consulta_produtos_categorias
AS 
BEGIN
SELECT P.NomeProduto [Nome do Produto], C.NomeCategoria [Nome da Categoria], 
P.PrecoProduto [Valor do Produto], P.EstoqueProduto [Quantidade em Estoque]
FROM Produto P
	JOIN Categoria C ON P.IdCategoria = C.IdCategoria
ORDER BY C.NomeCategoria, P.NomeProduto
END;
EXEC sp_consulta_produtos_categorias

-- Mostre: nome do cliente data do pedido. Somente dos pedidos realizados em abril de 2024.
SELECT C.NomeCliente [Nome do Cliente], P.DataPedido [Data do Pedido]
FROM Pedido P
	JOIN Cliente C ON P.IdCliente = C.IdCliente
WHERE P.DataPedido BETWEEN '2024-04-01' AND '2024-04-30'

-- O setor de estoque quer saber quais produtos possuem menos de 20 unidades. Mostrar: Nome, estoque, fornecedor. Ordenar pelo estoque crescente.
CREATE OR ALTER PROCEDURE sp_estoque_acabando
AS
BEGIN 
	SELECT P.NomeProduto [Nome do Produto], P.EstoqueProduto [Quantidade em Estoque], F.NomeFornecedor [Fornecedor do Produto]
	FROM Produto P
	JOIN Fornecedor F ON P.IdFornecedor = F.IdFornecedor
	WHERE P.EstoqueProduto < 20.00
	ORDER BY P.EstoqueProduto 
END;
EXEC sp_estoque_acabando

-- O gerente deseja saber quais clientes possuem e-mail cadastrado. Mostrar: Nome, email. Ordenar alfabeticamente.
CREATE OR ALTER PROCEDURE sp_email_valido
AS
BEGIN
	SELECT C.NomeCliente [Nome do Cliente], C.EmailCliente [Email do Cliente] FROM Cliente C
	WHERE C.EmailCliente IS NOT NULL ORDER BY C.NomeCliente;
END;
EXEC sp_email_valido

-- Mostre todos os pedidos contendo: Número do pedido, nome do cliente, quantidade de itens
CREATE OR ALTER VIEW vw_QuantidadePedidos AS
SELECT P.IdPedido [Número do Pedido], ITP.QuantidadeItemPedido [Quantidade de itens],  C.NomeCliente [Nome do Cliente]
FROM ItemPedido ITP
	JOIN Pedido P ON ITP.IdPedido = P.IdPedido
	JOIN Cliente C ON P.IdCliente = C.IdCliente
SELECT * FROM vw_QuantidadePedidos

/*O financeiro quer conferir os valores vendidos. Mostrar: Nome do cliente, produto, quantidade, valor unitário
 Valor total do item (Quantidade × ValorUnitario). Ordenar pelo maior valor total.*/
SELECT C.NomeCliente, P.NomeProduto [Nome do Produto], ITP.QuantidadeItemPedido [Quantidade Requisitada], ITP.ValorUnitario [Valor do Produto]
FROM ItemPedido ITP
	JOIN Produto P ON ITP.IdProduto = P.IdProduto
	JOIN Pedido PE ON ITP.IdPedido = PE.IdPedido
	JOIN Cliente C ON PE.IdCliente = C.IdCliente
	WHERE QuantidadeItemPedido < (
		SELECT
		SUM(ITP.QuantidadeItemPedido * ITP.ValorUnitario) AS [Valor Total do Item]
		FROM ItemPedido ITP
	)
ORDER BY [Valor Total do Item]

/* cheguei até aqui*/

SELECT C.NomeCliente, P.NomeProduto, ITP.QuantidadeItemPedido, ITP.ValorUnitario, (ITP.QuantidadeItemPedido * ITP.ValorUnitario) AS [Valor Total do Item]
FROM ItemPedido ITP
	JOIN Produto P ON ITP.IdProduto = P.IdProduto
	JOIN Pedido PE ON ITP.IdPedido = PE.IdPedido
	JOIN Cliente C ON PE.IdCliente = C.IdCliente
ORDER BY [Valor Total do Item] DESC;

/*
O diretor quer um relatório com:
Nome do cliente, data do pedido, produto, categoria, fornecedor, quantidade, valor unitário, valor total do item

Regras:
Mostrar apenas produtos com valor unitário acima de R$ 500,00.
Pedidos realizados entre 01/03/2024 e 30/06/2024.
Produtos das categorias Eletrônicos, Informática ou Móveis e Decoração.

Ordenar por:
Data do pedido;
Valor total do item (decrescente).
*/
CREATE OR ALTER PROCEDURE sp_produtos_categorias_preco_data
AS
BEGIN
SELECT C.NomeCliente [Nome do Cliente], PE.DataPedido [Data Realizada], PR.NomeProduto [Nome do Produto],
CA.NomeCategoria [Categoria do Produto], F.NomeFornecedor [Nome do Fornecedor], ITP.QuantidadeItemPedido [Quantidade do Produto],
ITP.ValorUnitario [Valor Unitário], (ITP.QuantidadeItemPedido * ITP.ValorUnitario) AS [Valor Total do Item]
FROM ItemPedido ITP
	JOIN Pedido PE ON ITP.IdPedido = PE.IdPedido
	JOIN Produto PR ON ITP.IdProduto = PR.IdProduto
	JOIN Cliente C ON PE.IdCliente = C.IdCliente
	JOIN Categoria CA ON PR.IdCategoria = CA.IdCategoria
	JOIN Fornecedor F ON PR.IdFornecedor = F.IdFornecedor
	WHERE ITP.ValorUnitario > 500.00 AND PE.DataPedido BETWEEN '2024-03-01' AND '2024-06-30' 
	AND CA.NomeCategoria IN ('Eletrônicos', 'Informática', 'Móveis e Decoração')
ORDER BY PE.DataPedido, [Valor Total do Item] DESC
END;
EXEC sp_produtos_categorias_preco_data