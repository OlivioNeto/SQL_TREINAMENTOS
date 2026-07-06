USE LojaVirtual
GO

CREATE TABLE Vendedor (
	IdVendedor SMALLINT PRIMARY KEY IDENTITY,
	NomeVendedor VARCHAR (70) NOT NULL,
	CPFVendedor CHAR (11) NOT NULL UNIQUE,
	TelefoneVendedor VARCHAR (15) NOT NULL,
	EmailVendedor VARCHAR (30),
	DataAdmissaoVendedor DATE NOT NULL,
	PercentualComissaoVendedor SMALLINT NOT NULL,
	VendedorAtivo CHAR (1) NOT NULL DEFAULT 'S',
	MetaVendasVendedor MONEY NOT NULL,
	CHECK (PercentualComissaoVendedor >= 0),
	CHECK (VendedorAtivo IN ('S', 'N'))
);

ALTER TABLE Vendedor
ALTER COLUMN EmailVendedor VARCHAR(60) NULL;
GO

ALTER TABLE Pedido
ADD IdVendedor SMALLINT NULL;
GO

ALTER TABLE Pedido
ADD CONSTRAINT fk_id_vendedor FOREIGN KEY (IdVendedor) REFERENCES Vendedor(IdVendedor);
GO

INSERT INTO Vendedor (NomeVendedor, CPFVendedor, TelefoneVendedor, EmailVendedor, DataAdmissaoVendedor, PercentualComissaoVendedor, VendedorAtivo, MetaVendasVendedor) VALUES
('Rodrigo Alves Nascimento', '10293847561', '11991234567', 'rodrigo.nascimento@lojavirtual.com', '20200315', 5, 'S', 15000.00),
('Tatiane Ferreira Duarte', '11304958672', '11982345678', 'tatiane.duarte@lojavirtual.com', '20201122', 8, 'S', 20000.00),
('Vinicius Rocha Batista', '12405967783', '11973456789', NULL, '20210208', 6, 'S', 18000.00),
('Aline Cristina Moraes', '13506078894', '11964567890', 'aline.moraes@lojavirtual.com', '20210617', 10, 'S', 25000.00),
('Gustavo Henrique Prado', '14607189905', '11955678901', 'gustavo.prado@lojavirtual.com', '20211003', 7, 'N', 16000.00),
('Priscila Santos Vieira', '15708290016', '11946789012', 'priscila.vieira@lojavirtual.com', '20220114', 5, 'S', 15000.00),
('Leonardo Dias Cunha', '16809301127', '11937890123', NULL, '20220522', 9, 'S', 22000.00),
('Simone Aparecida Reis', '17900412238', '11928901234', 'simone.reis@lojavirtual.com', '20220830', 6, 'S', 17000.00),
('Anderson Luiz Farias', '18001523349', '11919012345', 'anderson.farias@lojavirtual.com', '20221105', 8, 'S', 21000.00),
('Cristiane Melo Andrade', '19102634450', '11900123456', 'cristiane.andrade@lojavirtual.com', '20230210', 4, 'N', 12000.00),
('Fabio Junior Teixeira', '20203745561', '11891234567', 'fabio.teixeira@lojavirtual.com', '20230419', 7, 'S', 19000.00),
('Michele Cristina Lopes', '21304856672', '11882345678', NULL, '20230725', 10, 'S', 26000.00),
('Wagner Souza Pinheiro', '22405967783', '11873456789', 'wagner.pinheiro@lojavirtual.com', '20231030', 5, 'S', 15500.00),
('Tainara Cristina Borges', '23507078894', '11864567890', 'tainara.borges@lojavirtual.com', '20240108', 6, 'S', 17500.00),
('Rogerio Nascimento Alves', '24608189905', '11855678901', 'rogerio.alves@lojavirtual.com', '20240320', 9, 'S', 23000.00);
GO

UPDATE Pedido SET IdVendedor = 1  WHERE IdPedido = 1;
UPDATE Pedido SET IdVendedor = 2  WHERE IdPedido = 2;
UPDATE Pedido SET IdVendedor = 3  WHERE IdPedido = 3;
UPDATE Pedido SET IdVendedor = 4  WHERE IdPedido = 4;
UPDATE Pedido SET IdVendedor = 5  WHERE IdPedido = 5;
UPDATE Pedido SET IdVendedor = 6  WHERE IdPedido = 6;
UPDATE Pedido SET IdVendedor = 7  WHERE IdPedido = 7;
UPDATE Pedido SET IdVendedor = 8  WHERE IdPedido = 8;
UPDATE Pedido SET IdVendedor = 9  WHERE IdPedido = 9;
UPDATE Pedido SET IdVendedor = 10 WHERE IdPedido = 10;
UPDATE Pedido SET IdVendedor = 11 WHERE IdPedido = 11;
UPDATE Pedido SET IdVendedor = 12 WHERE IdPedido = 12;
UPDATE Pedido SET IdVendedor = 13 WHERE IdPedido = 13;
UPDATE Pedido SET IdVendedor = 14 WHERE IdPedido = 14;
UPDATE Pedido SET IdVendedor = 15 WHERE IdPedido = 15;
UPDATE Pedido SET IdVendedor = 1  WHERE IdPedido = 16;
UPDATE Pedido SET IdVendedor = 2  WHERE IdPedido = 17;
UPDATE Pedido SET IdVendedor = 3  WHERE IdPedido = 18;
UPDATE Pedido SET IdVendedor = 4  WHERE IdPedido = 19;
UPDATE Pedido SET IdVendedor = 5  WHERE IdPedido = 20;
UPDATE Pedido SET IdVendedor = 6  WHERE IdPedido = 21;
UPDATE Pedido SET IdVendedor = 7  WHERE IdPedido = 22;
UPDATE Pedido SET IdVendedor = 8  WHERE IdPedido = 23;
UPDATE Pedido SET IdVendedor = 9  WHERE IdPedido = 24;
UPDATE Pedido SET IdVendedor = 10 WHERE IdPedido = 25;
GO

ALTER TABLE Pedido
ALTER COLUMN IdVendedor SMALLINT NOT NULL;
GO