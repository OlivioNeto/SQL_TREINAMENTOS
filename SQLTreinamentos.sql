CREATE DATABASE LojaVirtual
USE LojaVirtual

CREATE TABLE Cliente(
	IdCliente INT PRIMARY KEY IDENTITY,
	NomeCliente VARCHAR (50) NOT NULL,
	CPFCliente CHAR (11) UNIQUE NOT NULL,
	EmailCliente VARCHAR (30),
	TelefoneCliente VARCHAR (15) NOT NULL
);
GO

CREATE TABLE Categoria(
	IdCategoria SMALLINT PRIMARY KEY IDENTITY,
	NomeCategoria VARCHAR (30) NOT NULL
);
GO

CREATE TABLE Fornecedor(
	IdFornecedor SMALLINT PRIMARY KEY IDENTITY,
	NomeFornecedor VARCHAR (50) NOT NULL,
	TelefoneFornecedor VARCHAR (15) NOT NULL
);
GO

CREATE TABLE Produto(
	IdProduto SMALLINT PRIMARY KEY IDENTITY,
	NomeProduto VARCHAR (50) NOT NULL,
	PrecoProduto MONEY NOT NULL,
	EstoqueProduto INT,
	IdCategoria SMALLINT NOT NULL,
	IdFornecedor SMALLINT NOT NULL,
	CONSTRAINT verifica_preco CHECK(PrecoProduto >=0),
	CONSTRAINT fk_id_categoria FOREIGN KEY (IdCategoria) REFERENCES Categoria(IdCategoria) ON DELETE CASCADE,
	CONSTRAINT fk_id_fornecedor FOREIGN KEY (IdFornecedor) REFERENCES Fornecedor(IdFornecedor) ON DELETE CASCADE
);
GO

CREATE TABLE Pedido(
	IdPedido INT PRIMARY KEY IDENTITY,
	DataPedido DATE,
	IdCliente INT NOT NULL,
	CONSTRAINT fk_id_cliente FOREIGN KEY (IdCliente)
		REFERENCES Cliente(IdCliente) ON DELETE CASCADE
);
GO

CREATE TABLE ItemPedido(
	IdItemPedido INT PRIMARY KEY IDENTITY,
	QuantidadeItemPedido INT NOT NULL,
	ValorUnitario MONEY NOT NULL,
	IdPedido INT NOT NULL,
	IdProduto SMALLINT NOT NULL,
	CONSTRAINT fk_id_pedido FOREIGN KEY (IdPedido)
		REFERENCES Pedido(IdPedido) ON DELETE CASCADE,
	CONSTRAINT fk_id_produto FOREIGN KEY (IdProduto)
		REFERENCES Produto(IdProduto) ON DELETE CASCADE
);
GO

CREATE TABLE Funcionario(
	IdFuncionario SMALLINT PRIMARY KEY IDENTITY,
	NomeFuncionario VARCHAR (30) NOT NULL,
	CargoFuncionario VARCHAR (50) NOT NULL
);
GO

-- INSERINDO DADOS
INSERT INTO Categoria (NomeCategoria) VALUES 
('Eletrônicos'), ('Informática'), ('Eletrodomésticos'), ('Moda e Vestuário'), ('Esporte e Lazer'), ('Livros'),('Beleza e Cuidados Pessoais'),
('Móveis e Decoração');
GO

INSERT INTO Fornecedor (NomeFornecedor, TelefoneFornecedor) VALUES
('Samsung Eletrônicos Ltda', '1130405060'), ('LG Distribuidora Brasil', '1140506070'), ('Positivo Informática', '4133202020'), ('Nike do Brasil', '1198765432'),
('Adidas Comércio Ltda', '1187654321'), ('Editora Saraiva', '1133445566'), ('Natura Cosméticos S.A.', '1199887766'), ('Tok&Stok Móveis e Decoração', '1122334455');
GO

INSERT INTO Produto (NomeProduto, PrecoProduto, EstoqueProduto, IdCategoria, IdFornecedor) VALUES
('Smart TV 50" 4K', 2499.90, 15, 1, 1), ('Smartphone Galaxy A54', 1899.00, 30, 1, 1), ('Geladeira Frost Free 400L', 3299.00, 10, 3, 2),        
('Ar Condicionado Split 12000 BTUs', 1799.00, 8, 3, 2), ('Notebook Positivo i5 8GB', 2899.00, 12, 2, 3), ('Mouse sem fio Positivo', 49.90, 100, 2, 3),            
('Teclado Mecânico Gamer', 199.90, 40, 2, 3), ('Tênis Nike Revolution', 299.90, 50, 4, 4), ('Camiseta Nike Dri-FIT', 129.90, 60, 4, 4),             
('Bola de Futebol Nike', 159.90, 35, 5, 4), ('Tênis Adidas Ultraboost', 599.90, 25, 4, 5), ('Mochila Adidas Esportiva', 149.90, 45, 5, 5),
('Bermuda Adidas Treino', 119.90, 55, 4, 5), ('Livro - O Pequeno Príncipe', 39.90, 80, 6, 6), ('Livro - Sapiens', 54.90, 70, 6, 6),
('Livro - Hábitos Atômicos', 49.90, 90, 6, 6), ('Perfume Natura Essencial', 189.90, 40, 7, 7),
('Kit Skincare Natura', 159.90, 35, 7, 7), ('Sofá Retrátil 3 Lugares', 1999.00, 5, 8, 8), ('Mesa de Jantar 6 Lugares', 1499.00, 7, 8, 8);
GO

INSERT INTO Cliente (NomeCliente, CPFCliente, EmailCliente, TelefoneCliente) VALUES
('Ana Beatriz Souza', '12345678901', 'ana.souza@email.com', '11987654321'),
('Carlos Eduardo Lima', '23456789012', 'carlos.lima@email.com', '11976543210'),
('Mariana Oliveira Santos', '34567890123', 'mariana.santos@email.com', '11965432109'),
('João Pedro Almeida', '45678901234', 'joao.almeida@email.com', '11954321098'),
('Fernanda Costa Ribeiro', '56789012345', 'fernanda.ribeiro@email.com', '11943210987'),
('Rafael Henrique Souza', '67890123456', 'rafael.souza@email.com', '11932109876'),
('Juliana Pereira Gomes', '78901234567', 'juliana.gomes@email.com', '11921098765'),
('Bruno Carvalho Martins', '89012345678', NULL, '11910987654'),
('Camila Rodrigues Silva', '90123456789', 'camila.silva@email.com', '11909876543'),
('Lucas Fernandes Barbosa', '01234567890', 'lucas.barbosa@email.com', '11898765432'),
('Patrícia Mendes Araújo', '11223344556', 'patricia.araujo@email.com', '11887654321'),
('Diego Augusto Cardoso', '22334455667', NULL, '11876543210'),
('Larissa Nunes Teixeira', '33445566778', 'larissa.teixeira@email.com', '11865432109'),
('Felipe Castro Moreira', '44556677889', 'felipe.moreira@email.com', '11854321098'),
('Gabriela Lopes Ferreira', '55667788990', 'gabriela.ferreira@email.com', '11843210987');
GO

INSERT INTO Funcionario (NomeFuncionario, CargoFuncionario) VALUES
('Marcos Vinícius Souza', 'Gerente de Vendas'), ('Beatriz Almeida Ramos', 'Atendente de Loja'), ('Thiago Henrique Costa', 'Analista de Estoque'),
('Renata Sales Pinto', 'Supervisora Financeira'), ('Eduardo Lima Barros', 'Auxiliar Administrativo'), ('Vanessa Cristina Rocha', 'Vendedora');
GO

INSERT INTO Pedido (DataPedido, IdCliente) VALUES
('2024-01-05', 1), ('2024-01-12', 3), ('2024-01-18', 5), ('2024-01-22', 7), ('2024-02-02', 2), ('2024-02-09', 9), ('2024-02-15', 11), ('2024-02-20', 4),
('2024-03-01', 6), ('2024-03-08', 13), ('2024-03-14', 8), ('2024-03-21', 15), ('2024-04-03', 10), ('2024-04-10', 1), ('2024-04-17', 12), ('2024-04-25', 14),
('2024-05-02', 3), ('2024-05-09', 7), ('2024-05-16', 9), ('2024-05-23', 2), ('2024-06-01', 5), ('2024-06-10', 11), ('2024-06-18', 6), ('2024-06-25', 13),
('2024-07-02', 8);
GO

INSERT INTO ItemPedido (QuantidadeItemPedido, ValorUnitario, IdPedido, IdProduto) VALUES
(1, 2499.90, 1, 1), (2, 49.90, 1, 6), (1, 1899.00, 2, 2), (1, 299.90, 2, 8), (3, 39.90, 3, 14), (1, 159.90, 3, 10), (2, 129.90, 4, 9), (1, 199.90, 4, 7),
(1, 3299.00, 5, 3), (1, 1799.00, 5, 4), (2, 54.90, 6, 15), (1, 599.90, 6, 11), (1, 2899.00, 7, 5), (3, 49.90, 7, 16), (1, 189.90, 8, 17), (2, 159.90, 8, 18),
(1, 1999.00, 9, 19), (1, 1499.00, 9, 20), (2, 299.90, 10, 8), (1, 149.90, 10, 12), (1, 119.90, 11, 13), (4, 39.90, 11, 14), (1, 2499.90, 12, 1), (1, 49.90, 12, 6),
(2, 199.90, 13, 7), (1, 1899.00, 13, 2), (1, 159.90, 14, 10), (1, 599.90, 14, 11), (3, 129.90, 15, 9), (1, 3299.00, 15, 3), (1, 1799.00, 16, 4), (2, 54.90, 16, 15),
(1, 2899.00, 17, 5), (1, 189.90, 17, 17), (2, 159.90, 18, 18), (1, 1999.00, 18, 19), (1, 1499.00, 19, 20), (1, 299.90, 19, 8), (2, 149.90, 20, 12),(1, 119.90, 20, 13),
(3, 39.90, 21, 14), (1, 2499.90, 21, 1), (1, 49.90, 22, 6), (2, 199.90, 22, 7), (1, 1899.00, 23, 2), (1, 159.90, 23, 10), (1, 599.90, 24, 11), (2, 129.90, 24, 9),
(1, 3299.00, 25, 3), (1, 1799.00, 25, 4), (2, 54.90, 25, 15);
GO

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