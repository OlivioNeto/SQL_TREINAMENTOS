-- SPRINT 03

/* 01 - Nome do produto, Marca, Categoria, Fornecedor, Preço, Estoque
Ordenação: Marca, Nome do produto */
CREATE OR ALTER VIEW vw_ProdutosCompletos AS
SELECT TOP (100) PERCENT
PR.NomeProduto [Nome do Produto], MA.NomeMarca [Marca do Produto], CA.NomeCategoria [Categoria do Produto],
FO.NomeFornecedor [Fornecedor do Produto], PR.PrecoProduto [Quanto ele Custa], PR.EstoqueProduto [Quantidade em Estoque]
FROM Produto PR
	JOIN Categoria CA ON PR.IdCategoria = CA.IdCategoria
	JOIN Fornecedor FO ON PR.IdFornecedor = FO.IdFornecedor
	JOIN Marca MA ON PR.IdMarca = MA.IdMarca
ORDER BY MA.NomeMarca, PR.NomeProduto

/* 02
O gerente do estoque quer consultar produtos por marca.
Ela deve receber: @NomeMarca
e retornar: Produto, Categoria, Fornecedor, Preço, Estoque
Se a marca não existir, a procedure não deve gerar erro. Apenas retornar zero registros.
*/
CREATE OR ALTER PROCEDURE sp_ProdutosPorMarca
	@NomeMarca VARCHAR(30)
AS 
BEGIN
	SELECT PR.NomeProduto [Nome do Produto], CA.NomeCategoria [Categoria do Produto], FO.NomeFornecedor [Fornecedor do Produto],
	PR.PrecoProduto [Preço do Produto], PR.EstoqueProduto [Quantidade em Estoque]
	FROM Produto PR
	JOIN Categoria CA ON PR.IdCategoria = CA.IdCategoria
	JOIN Fornecedor FO ON PR.IdFornecedor = FO.IdFornecedor
	JOIN Marca MA ON PR.IdMarca = MA.IdMarca
	WHERE MA.NomeMarca = @NomeMarca
END;

EXEC sp_ProdutosPorMarca 'Saraiva'

/*03
A diretoria quer saber quantos produtos existem por marca.
Mostrar: Marca, Quantidade de produtos
Ordenar da maior quantidade para a menor.
*/
CREATE OR ALTER VIEW vw_ProdutosMarca AS
SELECT TOP(100) PERCENT
MA.NomeMarca [Marca do Produto], COUNT(PR.NomeProduto) [Quantidade de Produtos da Marca]
FROM Produto PR
	JOIN Marca MA ON PR.IdMarca = MA.IdMarca
GROUP BY MA.NomeMarca
ORDER BY [Quantidade de Produtos da Marca] DESC;
SELECT * FROM vw_ProdutosMarca

/* 04
O marketing quer descobrir quais marcas ainda não possuem produtos cadastrados.
Mostrar apenas: Nome da marca, País de origem
*/
CREATE OR ALTER VIEW vw_MarcasSemProdutos AS
SELECT MA.NomeMarca [Marca do Produto], MA.PaisOrigemMarca [País de Origem]
FROM Marca MA
	LEFT JOIN Produto PR  ON PR.IdMarca = MA.IdMarca
WHERE PR.NomeProduto IS NULL;
SELECT * FROM vw_MarcasSemProdutos

/* 05
O financeiro quer um relatório mostrando:
Marca, Produto mais caro da marca, Produto mais barato da marca, Preço médio da marca, Mostrar apenas marcas que possuem 2 ou mais produtos.
Ordenar pela maior média de preço.
*/
CREATE OR ALTER VIEW vw_ProdutosPorMedia AS
SELECT TOP (100) PERCENT 
MA.NomeMarca [Nome da Marca], MAX(PR.PrecoProduto) [Produto Mais Caro], MIN(PR.PrecoProduto) [Produto Mais Barato],
AVG(PR.PrecoProduto) [Preço Médio da Marca]
FROM Produto PR
	JOIN Marca MA ON PR.IdMarca = MA.IdMarca
GROUP BY MA.NomeMarca
HAVING COUNT(*) >= 2
ORDER BY AVG(PR.PrecoProduto) DESC;
SELECT * FROM vw_ProdutosPorMedia

/* 06
Este é um chamado que eu receberia de um gerente de verdade. "Quero um relatório para apresentar na reunião de sexta-feira."
Mostrar: Marca, Categoria, Quantidade de produtos, Valor total em estoque, Valor total em estoque = Preço × Quantidade em Estoque
Regras:Apenas marcas brasileiras. Apenas categorias com mais de 2 produtos. Mostrar somente grupos cujo valor total em estoque seja superior a R$ 5.000,00.
Ordenar pelo maior valor em estoque.
*/
CREATE OR ALTER PROCEDURE sp_ProdutosBrasileirosAltoEstoque
AS
BEGIN
SELECT MA.NomeMarca [Marca do Produto], CA.NomeCategoria [Categoria do Produto], COUNT(PR.NomeProduto) [Quantiade de Produtos],
SUM (PR.PrecoProduto * PR.EstoqueProduto) AS [Valor Total em Estoque]
FROM Produto PR
	JOIN Marca MA ON PR.IdMarca = MA.IdMarca
	JOIN Categoria CA ON PR.IdCategoria = CA.IdCategoria
	WHERE MA.PaisOrigemMarca = 'Brasil'
GROUP BY MA.NomeMarca, CA.NomeCategoria
HAVING COUNT(*) > 2 AND SUM (PR.PrecoProduto * PR.EstoqueProduto) > 5000
ORDER BY MAX(PR.PrecoProduto * PR.EstoqueProduto)
END;
EXEC sp_ProdutosBrasileirosAltoEstoque