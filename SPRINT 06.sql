-- SPRINT 06

/* 01
O gerente do estoque deseja visualizar o saldo de cada produto.
Mostrar: Nome do produto, Marca, Total de entradas, Total de saídas, Saldo atual
Regras:
O saldo deve ser calculado por:
Entradas − Saídas
Caso um produto nunca tenha entrada ou saída, considerar 0.
Ordenar pelo menor saldo.
*/
CREATE OR ALTER PROCEDURE sp_RelatorioEstoqueProdutoMarca
AS
BEGIN
SELECT PR.NomeProduto [Nome do Produto], MA.NomeMarca [Marca do Produto],
SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Entrada' THEN QuantidadeMovimentacaoEstoque ELSE 0 END) [Total de Entradas],
SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Saída' THEN QuantidadeMovimentacaoEstoque ELSE 0 END) [Total de Saídas], 
SUM(CASE WHEN TipoMovimentacaoEstoque = 'Entrada' THEN QuantidadeMovimentacaoEstoque ELSE 0 END)
-
SUM(CASE WHEN TipoMovimentacaoEstoque = 'Saída' THEN QuantidadeMovimentacaoEstoque ELSE 0 END) [Saldo Atual]
FROM Produto PR 
	LEFT JOIN MovimentacaoEstoque ME ON PR.IdProduto = ME.IdProduto
	JOIN Marca MA ON PR.IdMarca = MA.IdMarca
GROUP BY PR.NomeProduto, MA.NomeMarca
ORDER BY [Saldo Atual];
END;
EXEC sp_RelatorioEstoqueProdutoMarca

/* 02
O setor de compras quer descobrir quais produtos precisam ser comprados novamente.
Mostrar: Nome do produto, Marca, Categoria, Saldo atual 
Regras:
O saldo deve ser calculado por: Entradas - Saídas
Mostrar apenas produtos cujo saldo seja menor que 10 unidades.
Caso o produto nunca tenha movimentação, considerar saldo igual a 0.
Ordenar pelo menor saldo.
*/
CREATE OR ALTER PROCEDURE sp_ProdutosComSaldoMenorQueDezCategoriaMarca
AS
BEGIN
SELECT PR.NomeProduto [Nome do Produto], MA.NomeMarca [Marca do Produto], CA.NomeCategoria [Categoria do Produto],
ISNULL(SUM(CASE WHEN TipoMovimentacaoEstoque = 'Entrada' THEN QuantidadeMovimentacaoEstoque ELSE 0 END),0)
-
ISNULL(SUM(CASE WHEN TipoMovimentacaoEstoque = 'Saída' THEN QuantidadeMovimentacaoEstoque ELSE 0 END),0) [Saldo Atual]
FROM Produto PR
	JOIN Marca MA ON PR.IdMarca = MA.IdMarca
	JOIN Categoria CA ON PR.IdCategoria = CA.IdCategoria
	LEFT JOIN MovimentacaoEstoque ME ON PR.IdProduto = ME.IdProduto
GROUP BY PR.NomeProduto, MA.NomeMarca, CA.NomeCategoria
HAVING 
ISNULL(SUM(CASE WHEN TipoMovimentacaoEstoque = 'Entrada' THEN QuantidadeMovimentacaoEstoque ELSE 0 END),0)
-
ISNULL(SUM(CASE WHEN TipoMovimentacaoEstoque = 'Saída' THEN QuantidadeMovimentacaoEstoque ELSE 0 END),0) < 10
ORDER BY [Saldo Atual];
END;
EXEC sp_ProdutosComSaldoMenorQueDezCategoriaMarca

/* 03
O gerente do estoque quer saber quais produtos tiveram maior movimentação.
Mostrar: Nome do produto, Marca, Quantidade de entradas, Quantidade de saídas, Total de movimentações
Regras
O total de movimentações deve ser:
Entradas + Saídas
Mostrar apenas produtos cuja movimentação total seja superior a 20 unidades.
Ordenar pela maior movimentação.
*/
CREATE OR ALTER PROCEDURE sp_QuantidadeMovimentacaoEstoque
AS
BEGIN
SELECT PR.NomeProduto [Nome do Produto], MA.NomeMarca [Nome da Marca],
SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Entrada' THEN QuantidadeMovimentacaoEstoque ELSE 0 END) [Total de Entradas],
SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Saída' THEN QuantidadeMovimentacaoEstoque ELSE 0 END) [Total de Saídas],
ISNULL(SUM(CASE WHEN TipoMovimentacaoEstoque = 'Entrada' THEN QuantidadeMovimentacaoEstoque ELSE 0 END),0)
+
ISNULL(SUM(CASE WHEN TipoMovimentacaoEstoque = 'Saída' THEN QuantidadeMovimentacaoEstoque ELSE 0 END),0) [Total de Movimentações]
FROM Produto PR
	JOIN Marca MA ON PR.IdMarca = MA.IdMarca
	LEFT JOIN MovimentacaoEstoque ME ON PR.IdProduto = ME.IdProduto
GROUP BY PR.NomeProduto, MA.NomeMarca
HAVING 
ISNULL(SUM(CASE WHEN TipoMovimentacaoEstoque = 'Entrada' THEN QuantidadeMovimentacaoEstoque ELSE 0 END),0)
+
ISNULL(SUM(CASE WHEN TipoMovimentacaoEstoque = 'Saída' THEN QuantidadeMovimentacaoEstoque ELSE 0 END),0) > 20
ORDER BY [Total de Movimentações] DESC;
END;
GO
EXEC sp_QuantidadeMovimentacaoEstoque
GO

/* 04
O gerente financeiro quer acompanhar as perdas e reposições de estoque.
Mostrar: Nome do produto, Marca, Quantidade de entradas por compra de fornecedor, Quantidade de entradas por ajuste de inventário, Quantidade de saídas por venda
Regras
Considere apenas movimentações com os seguintes motivos:
Compra de fornecedor
Correção de contagem
Venda
Cada coluna deve representar a soma das quantidades daquele motivo.
Ordenar pelo maior número de saídas por venda.
*/
CREATE OR ALTER PROCEDURE sp_PerdasEReposicaoDeEstoque
AS
BEGIN
SELECT PR.NomeProduto [Nome do Produto], MA.NomeMarca [Marca do Produto],
SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Entrada' AND ME.MotivoMovimentacaoEstoque = 'Compra de fornecedor' 
THEN ME.QuantidadeMovimentacaoEstoque ELSE 0 END) [Total de Entradas Por Compras de Fornecedor],
SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Entrada' AND ME.MotivoMovimentacaoEstoque = 'Correção de contagem' 
THEN ME.QuantidadeMovimentacaoEstoque ELSE 0 END) [Total de Entradas Por Ajuste de Inventário],
SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Saída' AND ME.MotivoMovimentacaoEstoque = 'Venda'
THEN ME.QuantidadeMovimentacaoEstoque ELSE 0 END) [Quantidade de Saídas por Venda]
FROM Produto PR
	JOIN Marca MA ON PR.IdMarca = MA.IdMarca
	LEFT JOIN MovimentacaoEstoque ME ON PR.IdProduto = ME.IdProduto 
WHERE ME.MotivoMovimentacaoEstoque IS NULL OR 
ME.MotivoMovimentacaoEstoque IN ('Compra de fornecedor', 'Correção de contagem', 'Venda')
 GROUP BY PR.NomeProduto, MA.NomeMarca
ORDER BY [Quantidade de Saídas por Venda] DESC;
END;
EXEC sp_PerdasEReposicaoDeEstoque

/* 05
O gerente de compras quer acompanhar quais marcas mais receberam reposição de estoque.
Mostrar: Nome da marca, Quantidade total recebida em reposições, Quantidade de produtos diferentes que receberam reposição
Regras
Considerar apenas movimentações de Entrada.
Considerar apenas reposições por Compra de fornecedor.
Mostrar somente marcas que receberam mais de 30 unidades em reposições.
Ordenar da maior quantidade recebida para a menor.
*/
CREATE OR ALTER PROCEDURE sp_ProdutosQueReceberamReposicao
AS
BEGIN
SELECT MA.NomeMarca [Marca do Produto], 
SUM(ME.QuantidadeMovimentacaoEstoque) [Quantidade Total de Reposições],
COUNT(DISTINCT PR.IdProduto) [Produtos Diferentes que Receberam Reposição]
FROM Produto PR
	JOIN Marca MA ON PR.IdMarca = MA.IdMarca
	JOIN MovimentacaoEstoque ME ON PR.IdProduto = ME.IdProduto
WHERE ME.TipoMovimentacaoEstoque = 'Entrada' AND ME.MotivoMovimentacaoEstoque = 'Compra de fornecedor'
GROUP BY MA.NomeMarca
HAVING SUM(ME.QuantidadeMovimentacaoEstoque) > 30
ORDER BY [Quantidade Total de Reposições] DESC;
END;
EXEC sp_ProdutosQueReceberamReposicao

/* 06
O gerente de estoque quer identificar os produtos que mais sofreram movimentações.
Mostrar: Nome do produto, Marca, Quantidade de entradas, Quantidade de saídas, Saldo de movimentação (Entradas − Saídas)
Regras:
Considerar todas as movimentações.
Mostrar apenas produtos cuja quantidade total movimentada (Entradas + Saídas) seja superior a 50 unidades.
Ordenar pelo maior saldo de movimentação.
*/
CREATE OR ALTER PROCEDURE sp_ProdutoMarcaSaldoMovimentacoes
AS
BEGIN
SELECT PR.NomeProduto [Nome do Produto], MA.NomeMarca [Marca do Produto],
SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Entrada' THEN QuantidadeMovimentacaoEstoque ELSE 0 END) [Total de Entradas],
SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Saída' THEN QuantidadeMovimentacaoEstoque ELSE 0 END) [Total de Saídas],
ISNULL(SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Entrada' THEN ME.QuantidadeMovimentacaoEstoque ELSE 0 END),0)
-
ISNULL(SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Saída' THEN ME.QuantidadeMovimentacaoEstoque ELSE 0 END),0) [Saldo de Movimentações]
FROM Produto PR
	JOIN Marca MA ON PR.IdMarca = MA.IdMarca
	JOIN MovimentacaoEstoque ME ON PR.IdProduto = ME.IdProduto
GROUP BY PR.NomeProduto, MA.NomeMarca
HAVING
ISNULL(SUM(CASE WHEN TipoMovimentacaoEstoque = 'Entrada' THEN QuantidadeMovimentacaoEstoque ELSE 0 END),0)
+
ISNULL(SUM(CASE WHEN TipoMovimentacaoEstoque = 'Saída' THEN QuantidadeMovimentacaoEstoque ELSE 0 END),0) > 50
ORDER BY [Saldo de Movimentações] DESC;
END;
EXEC sp_ProdutoMarcaSaldoMovimentacoes

/* 07
Crie uma Stored Procedure que receba: Parâmetro: @NomeProduto VARCHAR(50)
A procedure deve retornar: Produto, Tipo da movimentação, Quantidade, Motivo, Observação
Regras
A procedure deve receber o nome do produto.
Deve mostrar todas as movimentações daquele produto.
Ordenar pela movimentação mais recente primeiro.
Se o produto não existir, a procedure não deve gerar erro; apenas retornar 0 registros.
*/
CREATE OR ALTER PROCEDURE sp_RecebeNomeProdutoExibeMovimentacoes (@NomeProduto AS VARCHAR (50))
AS
BEGIN
SELECT PR.NomeProduto [Produto], ME.TipoMovimentacaoEstoque [Tipo da Movimentação], ME.DataMovimentacaoEstoque [Data da Movimentação], 
ME.QuantidadeMovimentacaoEstoque [Quantidade Movimentada],ME.MotivoMovimentacaoEstoque [Motivo da Movimentação], 
ME.ObservacaoMovimentacaoEstoque [Observação da Movimentação]
FROM Produto PR
	JOIN MovimentacaoEstoque ME ON PR.IdProduto = ME.IdProduto
WHERE PR.NomeProduto = @NomeProduto
ORDER BY [Data da Movimentação] DESC;
END;
EXEC sp_RecebeNomeProdutoExibeMovimentacoes 'Sofá Retrátil 3 Lugares'

/* 08
O gerente de logística pediu um relatório completo da movimentação de estoque.
Mostrar: Nome da marca, Quantidade de produtos diferentes movimentados, Total de entradas, Total de saídas, Saldo de estoque (Entradas − Saídas)
Regras
Considerar todas as movimentações.
Mostrar somente marcas que movimentaram pelo menos 3 produtos diferentes.
Mostrar somente marcas cujo saldo seja positivo.
Ordenar pelo maior saldo.
*/
CREATE OR ALTER PROCEDURE sp_MovimentacoesProdutosSaldoEstoquePositivo
AS
BEGIN
SELECT MA.NomeMarca [Marca do Produto], COUNT(DISTINCT PR.IdProduto) [Produtos Diferentes Movimentados],
SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Entrada' THEN ME.QuantidadeMovimentacaoEstoque ELSE 0 END) [Total de Entradas],
SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Saída' THEN ME.QuantidadeMovimentacaoEstoque ELSE 0 END) [Total de Saídas],
ISNULL(SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Entrada' THEN ME.QuantidadeMovimentacaoEstoque ELSE 0 END),0)
-
ISNULL(SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Saída' THEN ME.QuantidadeMovimentacaoEstoque ELSE 0 END),0) [Saldo em Estoque]
FROM Produto PR
	JOIN MARCA MA ON PR.IdMarca = MA.IdMarca
	JOIN MovimentacaoEstoque ME ON PR.IdProduto = ME.IdProduto
GROUP BY MA.NomeMarca
HAVING 
ISNULL(SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Entrada' THEN ME.QuantidadeMovimentacaoEstoque ELSE 0 END),0)
-
ISNULL(SUM(CASE WHEN ME.TipoMovimentacaoEstoque = 'Saída' THEN ME.QuantidadeMovimentacaoEstoque ELSE 0 END),0) > 0 AND
COUNT(DISTINCT PR.IdProduto) >=3
ORDER BY [Saldo em Estoque] DESC;
END;
EXEC sp_MovimentacoesProdutosSaldoEstoquePositivo


SELECT * FROM MovimentacaoEstoque