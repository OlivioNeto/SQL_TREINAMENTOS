-- Sprint 2 — Solicitações da empresa

/*O atendente precisa consultar rapidamente todos os pedidos de um cliente.
Crie uma Stored Procedure que receba o nome do cliente e retorne:
Número do pedido
Data do pedido
Nome do cliente
Ordene pela data mais recente.
*/
CREATE OR ALTER PROCEDURE sp_consulta_pedido_cliente_data
AS
BEGIN
SELECT PE.IdPedido [Número do Pedido], PE.DataPedido [Data do Pedido], C.NomeCliente [Nome do Cliente]
FROM ItemPedido ITP
	JOIN Pedido PE ON ITP.IdPedido = PE.IdPedido
	JOIN Cliente C ON PE.IdCliente = C.IdCliente
ORDER BY [Data do Pedido] DESC
END;
EXEC sp_consulta_pedido_cliente_data

/* join com item pedido desnecessário e a procedure não recebe parâmetro, versão correta corrigia pelo GPT abaixo*/
CREATE OR ALTER PROCEDURE sp_consulta_pedido_cliente_data
    @NomeCliente VARCHAR(50)
AS
BEGIN
    SELECT
        PE.IdPedido AS [Número do Pedido], PE.DataPedido AS [Data do Pedido], C.NomeCliente AS [Nome do Cliente] FROM Pedido PE
        JOIN Cliente C
            ON PE.IdCliente = C.IdCliente WHERE C.NomeCliente = @NomeCliente ORDER BY PE.DataPedido DESC;
END;
EXEC sp_consulta_pedido_cliente_data 'Ana Beatriz Souza'

--O setor comercial quer uma VIEW mostrando: Produto, categoria, fornecedor, preço, estoque.
CREATE OR ALTER VIEW vw_consulta_fornecedor_preco_estoque_categoria_produto AS
SELECT PR.NomeProduto [Nome do Produto], CA.NomeCategoria [Categoria do Produto], FO.NomeFornecedor [Fornecedor do Produto],
PR.PrecoProduto [Valor do Produto], PR.EstoqueProduto [Quantidade em Estoque]
FROM Produto PR
	JOIN Categoria CA ON PR.IdCategoria = CA.IdCategoria
	JOIN Fornecedor FO ON PR.IdFornecedor = FO.IdFornecedor
SELECT * FROM vw_consulta_fornecedor_preco_estoque_categoria_produto

/*
Crie uma Function que receba a quantidade em estoque e retorne:
Estoque	Retorno
0	ESGOTADO
1 a 10	BAIXO
acima de 10	NORMAL
Depois utilize essa Function em um SELECT.
*/
CREATE OR ALTER FUNCTION retorna_status_estoque(@valor SMALLINT)
RETURNS VARCHAR (10)
AS
BEGIN
	DECLARE @resultado VARCHAR(10)
	SET @resultado = CASE
	WHEN @valor BETWEEN 1 AND 10 THEN 'BAIXO'
	WHEN @valor > 10 THEN 'NORMAL'
	ELSE 'ESGOTADO'
	END;
	RETURN @resultado;
END;

SELECT PR.NomeProduto [Nome do Produto], PR.PrecoProduto [Preço do Produto], 
PR.EstoqueProduto [Quantidade em Estoque], dbo.retorna_status_estoque(PR.EstoqueProduto) [Status do Estoque]
FROM Produto PR


/*
Foi descoberto que alguns funcionários cadastraram produtos com preço negativo.
Crie uma Trigger que impeça: INSERT, UPDATE quando o preço for menor que zero.
A trigger deve mostrar uma mensagem de erro.
*/
CREATE OR ALTER TRIGGER tg_bloqueia_preco_negativo
ON Produto
AFTER INSERT, UPDATE
AS 
BEGIN
	IF EXISTS (SELECT 1 FROM inserted WHERE PrecoProduto < 0)
	BEGIN
		ROLLBACK TRANSACTION;
		RAISERROR ('Não foi possível completar a operação. O preço do produto tem que ser maior ou igual a zero!', 16,1);
	END
END;

/*
Crie uma consulta mostrando: Cliente, Produto, Quantidade, Valor Unitário, Valor Total do Item
Mas apenas para pedidos cujo valor total do item seja superior a R$ 2.000,00.
*/
CREATE OR ALTER VIEW vw_cliente_pedido_maior_doismil AS
SELECT CL.NomeCliente [Nome do Cliente], PR.NomeProduto [Nome do Produto], ITP.QuantidadeItemPedido [Quantidade Pedida],
ITP.ValorUnitario [Valor da Unidade], (ITP.QuantidadeItemPedido * ITP.ValorUnitario) AS [Valor total do Item]
FROM ItemPedido ITP
	JOIN Produto PR ON ITP.IdProduto = PR.IdProduto
	JOIN Pedido PE ON ITP.IdPedido = PE.IdPedido
	JOIN Cliente CL ON PE.IdCliente = CL.IdCliente
WHERE (ITP.QuantidadeItemPedido * ITP.ValorUnitario) > 2000.00

SELECT * FROM vw_cliente_pedido_maior_doismil

-- A gerência deseja descobrir os produtos que nunca foram vendidos.
CREATE OR ALTER VIEW vw_produtos_nao_vendidos AS
SELECT PR.NomeProduto
FROM ItemPedido ITP
	JOIN Produto PR ON ITP.IdProduto = PR.IdProduto
	WHERE ITP.IdItemPedido IS NULL
/*único problema aqui é que fiz com JOIN, na verdade era left, do jeito que está os produtos não vendidos nem aparecem*/

SELECT PR.NomeProduto FROM Produto PR
LEFT JOIN ItemPedido ITP
    ON PR.IdProduto = ITP.IdProduto
WHERE ITP.IdProduto IS NULL;

/*
Ele quer visualizar:
Cliente, Data do pedido, Produto, Categoria, Fornecedor, Estoque atual, Quantidade comprada, Valor unitário, Valor total

Regras:
Apenas produtos com estoque menor que 20 unidades.
Apenas clientes que possuem e-mail cadastrado.
Apenas pedidos realizados a partir de 01/02/2024.
Mostrar o status do estoque utilizando a Function criada no exercício 3.

Ordenar por: Cliente, Data do pedido (mais recente primeiro).
*/
CREATE OR ALTER PROCEDURE sp_relatorio_venda_estoque_categoria_fornecedor_emailvalido
AS
BEGIN
SELECT CL.NomeCliente [Nome do Cliente], PE.DataPedido [Data do Pedido],PR.NomeProduto [Nome do Produto],
CA.NomeCategoria [Categoria que Pertence], FO.NomeFornecedor [Nome do Forncedor], PR.EstoqueProduto [Quantidade em Estoque],
ITP.QuantidadeItemPedido [Quantidade Comprada], ITP.ValorUnitario [Valor Unitário], (ITP.QuantidadeItemPedido * ITP.ValorUnitario) AS [Valor total do Item],
dbo.retorna_status_estoque (PR.EstoqueProduto) [Status do Estoque]
FROM ItemPedido ITP
	JOIN Pedido PE ON ITP.IdPedido = PE.IdPedido
	JOIN Produto PR ON ITP.IdProduto = PR.IdProduto
	JOIN Cliente CL ON PE.IdCliente = CL.IdCliente
	JOIN Categoria CA ON PR.IdCategoria = CA.IdCategoria
	JOIN Fornecedor FO ON PR.IdFornecedor = FO.IdFornecedor
WHERE CL.EmailCliente IS NOT NULL AND PR.EstoqueProduto < 20.00 AND PE.DataPedido >= '2024/02/01'
ORDER BY [Nome do Cliente], [Data do Pedido] DESC
END;
-- única dúvida que tive aqui foi em relação a quantidade comprada, de resto acho que foi certinho
EXEC sp_relatorio_venda_estoque_categoria_fornecedor_emailvalido