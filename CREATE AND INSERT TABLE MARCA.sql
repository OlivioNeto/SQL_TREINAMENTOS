USE LojaVirtual

CREATE TABLE Marca (
	IdMarca SMALLINT IDENTITY PRIMARY KEY,
	NomeMarca VARCHAR (30) NOT NULL,
	TelefoneMarca VARCHAR (15) NOT NULL,
	PaisOrigemMarca VARCHAR (30) NOT NULL,
	LogoMarca VARCHAR (255),
	DescricaoMarca VARCHAR (100)
)

select * from Produto

-- 1. Adiciona a coluna permitindo NULL
ALTER TABLE Produto
ALTER IdMarca SMALLINT NULL;
GO

-- 2. Atualiza os produtos existentes com a marca correta
UPDATE Produto SET IdMarca = 1 WHERE IdProduto IN (1,2,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20); -- exemplo
UPDATE Produto SET IdMarca = 2 WHERE IdProduto IN (3,4);       -- exemplo
-- ... continue para os demais produtos
GO

-- 3. Agora torna a coluna obrigatória
ALTER TABLE Produto
ALTER COLUMN IdMarca SMALLINT NOT NULL;
GO

-- 4. Cria a FK
ALTER TABLE Produto
ADD CONSTRAINT fk_id_marca FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca);
GO
/*USEI IA NESSA PARTE*/

USE LojaVirtual
GO

INSERT INTO Marca (NomeMarca, TelefoneMarca, PaisOrigemMarca, LogoMarca, DescricaoMarca) VALUES
('Samsung', '1130001111', 'Coreia do Sul', '/logos/samsung.png', 'Eletrônicos e tecnologia de ponta'),
('LG', '1130002222', 'Coreia do Sul', '/logos/lg.png', 'Eletrodomésticos e eletrônicos'),
('Positivo', '4130003333', 'Brasil', '/logos/positivo.png', 'Informática e notebooks nacionais'),
('Nike', '1130004444', 'Estados Unidos', '/logos/nike.png', 'Artigos esportivos e streetwear'),
('Adidas', '1130005555', 'Alemanha', '/logos/adidas.png', 'Artigos esportivos e moda'),
('Saraiva', '1130006666', 'Brasil', '/logos/saraiva.png', 'Livros e material editorial'),
('Natura', '1130007777', 'Brasil', '/logos/natura.png', 'Cosméticos e perfumaria'),
('Tok&Stok', '1130008888', 'Brasil', '/logos/tokstok.png', 'Móveis e decoração'),
('Apple', '1130009999', 'Estados Unidos', '/logos/apple.png', 'Eletrônicos premium e tecnologia'),
('Sony', '1130010000', 'Japão', '/logos/sony.png', 'Eletrônicos e entretenimento'),
('Philips', '1130011111', 'Holanda', '/logos/philips.png', 'Eletrodomésticos e saúde'),
('Motorola', '1130012222', 'Estados Unidos', '/logos/motorola.png', 'Smartphones e telecomunicações'),
('Puma', '1130013333', 'Alemanha', '/logos/puma.png', 'Artigos esportivos e calçados'),
('Under Armour', '1130014444', 'Estados Unidos', '/logos/underarmour.png', 'Roupas e acessórios esportivos'),
('Editora Rocco', '1130015555', 'Brasil', '/logos/rocco.png', 'Livros e literatura'),
('O Boticário', '1130016666', 'Brasil', '/logos/boticario.png', 'Cosméticos e perfumaria nacional'),
('Etna', '1130017777', 'Brasil', '/logos/etna.png', 'Móveis e artigos para casa'),
('Xiaomi', '1130018888', 'China', '/logos/xiaomi.png', 'Eletrônicos e smart devices'),
('Whirlpool', '1130019999', 'Estados Unidos', '/logos/whirlpool.png', 'Eletrodomésticos de grande porte'),
('Dell', '1130020000', 'Estados Unidos', '/logos/dell.png', 'Notebooks e equipamentos de informática');
GO

UPDATE Produto SET IdMarca = 1 WHERE IdProduto = 1;
UPDATE Produto SET IdMarca = 1 WHERE IdProduto = 2;
UPDATE Produto SET IdMarca = 2 WHERE IdProduto = 3;
UPDATE Produto SET IdMarca = 2 WHERE IdProduto = 4;
UPDATE Produto SET IdMarca = 3 WHERE IdProduto = 5;
UPDATE Produto SET IdMarca = 3 WHERE IdProduto = 6;
UPDATE Produto SET IdMarca = 3 WHERE IdProduto = 7;
UPDATE Produto SET IdMarca = 4 WHERE IdProduto = 8;
UPDATE Produto SET IdMarca = 4 WHERE IdProduto = 9;
UPDATE Produto SET IdMarca = 4 WHERE IdProduto = 10;
UPDATE Produto SET IdMarca = 5 WHERE IdProduto = 11;
UPDATE Produto SET IdMarca = 5 WHERE IdProduto = 12;
UPDATE Produto SET IdMarca = 5 WHERE IdProduto = 13;
UPDATE Produto SET IdMarca = 6 WHERE IdProduto = 14;
UPDATE Produto SET IdMarca = 6 WHERE IdProduto = 15;
UPDATE Produto SET IdMarca = 6 WHERE IdProduto = 16;
UPDATE Produto SET IdMarca = 7 WHERE IdProduto = 17;
UPDATE Produto SET IdMarca = 7 WHERE IdProduto = 18;
UPDATE Produto SET IdMarca = 8 WHERE IdProduto = 19;
UPDATE Produto SET IdMarca = 8 WHERE IdProduto = 20;
GO