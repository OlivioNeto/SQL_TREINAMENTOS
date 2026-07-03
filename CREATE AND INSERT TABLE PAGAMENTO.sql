USE LojaVirtual
GO

CREATE TABLE Pagamento(
	IdPagamento INT PRIMARY KEY IDENTITY,
	FormaPagamento VARCHAR(30) NOT NULL
		CHECK (FormaPagamento IN ('Pix', 'Cartão de Crédito', 'Cartão de Débito', 'Boleto')),
	ValorPago MONEY NOT NULL
		CHECK (ValorPago >= 0),
	DataPagamento DATE NOT NULL DEFAULT GETDATE(),
	StatusPagamento VARCHAR(20) NOT NULL DEFAULT 'Pendente'
		CHECK (StatusPagamento IN ('Pendente', 'Aprovado', 'Recusado', 'Estornado', 'Cancelado')),
	IdPedido INT NOT NULL,
	CONSTRAINT fk_pagamento_pedido FOREIGN KEY (IdPedido)
		REFERENCES Pedido(IdPedido)
);
GO

INSERT INTO Pagamento (FormaPagamento, ValorPago, DataPagamento, StatusPagamento, IdPedido) VALUES
('Pix', 2549.80, '20240105', 'Aprovado', 1), ('Cartão de Crédito', 2198.90, '20240112', 'Aprovado', 2), ('Boleto', 199.60, '20240118', 'Pendente', 3),
('Cartão de Débito', 259.80, '20240205', 'Aprovado', 5), ('Pix', 109.80, '20240212', 'Aprovado', 6), ('Boleto', 149.90, '20240220', 'Aprovado', 7),
('Cartão de Crédito', 899.80, '20240225', 'Aprovado', 8), ('Pix', 3299.00, '20240301', 'Aprovado', 9), ('Cartão de Crédito', 4198.00, '20240310', 'Aprovado', 10),
('Boleto', 119.90, '20240317', 'Recusado', 11), ('Pix', 119.90, '20240319', 'Aprovado', 11), ('Cartão de Débito', 749.70, '20240321', 'Aprovado', 12),
('Pix', 189.90, '20240403', 'Aprovado', 13), ('Cartão de Crédito', 759.80, '20240410', 'Aprovado', 14), ('Boleto', 179.70, '20240417', 'Pendente', 15),
('Pix', 129.70, '20240430', 'Aprovado', 16), ('Cartão de Crédito', 3549.00, '20240506', 'Aprovado', 17), ('Boleto', 649.80, '20240514', 'Recusado', 18),
('Pix', 649.80, '20240516', 'Aprovado', 18), ('Cartão de Débito', 1999.00, '20240523', 'Aprovado', 19), ('Pix', 448.70, '20240525', 'Aprovado', 20),
('Cartão de Crédito', 3299.00, '20240601', 'Aprovado', 22), ('Boleto', 269.80, '20240610', 'Pendente', 23), ('Pix', 1799.00, '20240618', 'Aprovado', 24),
('Cartão de Crédito', 1799.00, '20240625', 'Estornado', 24);
GO