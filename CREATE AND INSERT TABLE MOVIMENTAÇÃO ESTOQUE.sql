USE LojaVirtual
GO

CREATE TABLE MovimentacaoEstoque (
	IdMovimentacaoEstoque INT PRIMARY KEY IDENTITY,
	TipoMovimentacaoEstoque VARCHAR (20) NOT NULL DEFAULT 'Entrada',
	QuantidadeMovimentacaoEstoque SMALLINT NOT NULL,
	DataMovimentacaoEstoque DATE NOT NULL DEFAULT GETDATE(),
	ObservacaoMovimentacaoEstoque VARCHAR (255),
	MotivoMovimentacaoEstoque VARCHAR (100),
	IdProduto SMALLINT NOT NULL,
	IdPedido INT NULL,
	CHECK (TipoMovimentacaoEstoque IN ('Entrada', 'Saída')),
	CHECK (QuantidadeMovimentacaoEstoque > 0),
	CONSTRAINT fk_id_produto_ME FOREIGN KEY (IdProduto) REFERENCES 
	Produto(IdProduto),
	CONSTRAINT fk_id_pedido_ME FOREIGN KEY (IdPedido) REFERENCES 
	Pedido(IdPedido)
);
GO

INSERT INTO MovimentacaoEstoque (TipoMovimentacaoEstoque, QuantidadeMovimentacaoEstoque, DataMovimentacaoEstoque, 
ObservacaoMovimentacaoEstoque, MotivoMovimentacaoEstoque, IdProduto, IdPedido) VALUES
('Entrada', 20, '20240102', 'Reposição inicial de estoque', 'Compra de fornecedor', 1, NULL),
('Entrada', 40, '20240102', 'Reposição inicial de estoque', 'Compra de fornecedor', 2, NULL),
('Entrada', 15, '20240103', 'Reposição inicial de estoque', 'Compra de fornecedor', 3, NULL),
('Entrada', 10, '20240103', 'Reposição inicial de estoque', 'Compra de fornecedor', 4, NULL),
('Entrada', 18, '20240104', 'Reposição inicial de estoque', 'Compra de fornecedor', 5, NULL),
('Entrada', 120, '20240104', 'Reposição inicial de estoque', 'Compra de fornecedor', 6, NULL),
('Entrada', 50, '20240105', 'Reposição inicial de estoque', 'Compra de fornecedor', 7, NULL),
('Saída', 1, '20240105', 'Baixa referente à venda', 'Venda', 1, 1),
('Saída', 2, '20240105', 'Baixa referente à venda', 'Venda', 6, 1),
('Saída', 1, '20240112', 'Baixa referente à venda', 'Venda', 2, 2),
('Saída', 1, '20240112', 'Baixa referente à venda', 'Venda', 8, 2),
('Entrada', 60, '20240115', 'Reposição de estoque', 'Compra de fornecedor', 8, NULL),
('Entrada', 70, '20240115', 'Reposição de estoque', 'Compra de fornecedor', 9, NULL),
('Saída', 3, '20240118', 'Baixa referente à venda', 'Venda', 14, 3),
('Saída', 1, '20240118', 'Baixa referente à venda', 'Venda', 10, 3),
('Entrada', 40, '20240120', 'Reposição de estoque', 'Compra de fornecedor', 10, NULL),
('Saída', 2, '20240122', 'Baixa referente à venda', 'Venda', 9, 4),
('Saída', 1, '20240122', 'Baixa referente à venda', 'Venda', 7, 4),
('Entrada', 12, '20240201', 'Reposição de estoque', 'Compra de fornecedor', 11, NULL),
('Entrada', 45, '20240201', 'Reposição de estoque', 'Compra de fornecedor', 12, NULL),
('Saída', 1, '20240202', 'Baixa referente à venda', 'Venda', 3, 5),
('Saída', 1, '20240202', 'Baixa referente à venda', 'Venda', 4, 5),
('Entrada', 55, '20240205', 'Reposição de estoque', 'Compra de fornecedor', 13, NULL),
('Saída', 2, '20240209', 'Baixa referente à venda', 'Venda', 15, 6),
('Saída', 1, '20240209', 'Baixa referente à venda', 'Venda', 11, 6),
('Entrada', 25, '20240210', 'Reposição de estoque', 'Compra de fornecedor', 14, NULL),
('Entrada', 5, '20240212', 'Ajuste de inventário', 'Correção de contagem', 15, NULL),
('Saída', 1, '20240215', 'Baixa referente à venda', 'Venda', 5, 7),
('Saída', 3, '20240215', 'Baixa referente à venda', 'Venda', 16, 7),
('Entrada', 40, '20240220', 'Reposição de estoque', 'Compra de fornecedor', 16, NULL),
('Saída', 1, '20240220', 'Baixa referente à venda', 'Venda', 17, 8),
('Saída', 2, '20240220', 'Baixa referente à venda', 'Venda', 18, 8),
('Entrada', 8, '20240301', 'Reposição de estoque', 'Compra de fornecedor', 17, NULL),
('Saída', 1, '20240301', 'Baixa referente à venda', 'Venda', 19, 9),
('Saída', 1, '20240301', 'Baixa referente à venda', 'Venda', 20, 9),
('Entrada', 10, '20240308', 'Reposição de estoque', 'Compra de fornecedor', 18, NULL),
('Saída', 2, '20240308', 'Baixa referente à venda', 'Venda', 8, 10),
('Entrada', 6, '20240314', 'Ajuste de inventário', 'Correção de contagem', 19, NULL),
('Saída', 1, '20240314', 'Baixa referente à venda', 'Venda', 12, 10),
('Entrada', 15, '20240321', 'Reposição de estoque', 'Compra de fornecedor', 20, NULL);
GO