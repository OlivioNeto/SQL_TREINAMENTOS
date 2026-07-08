-- SPRINT 7.1 Estrutura organizacional

CREATE TABLE Departamento (
	IdDepartamento TINYINT PRIMARY KEY IDENTITY,
	NomeDepartamento VARCHAR (50) NOT NULL UNIQUE,
	DescricaoDepartamento VARCHAR (200),
	DepartamentoAtivo CHAR (1) NOT NULL DEFAULT 'S',
	DataCriacaoDepartamento DATE NOT NULL DEFAULT GETDATE(),
	DataDesativacaoDepartamento DATE NULL,
	CHECK (DepartamentoAtivo IN ('S', 'N'))
);
GO

INSERT INTO Departamento (NomeDepartamento, DescricaoDepartamento) VALUES
('Comercial', 'Responsável pelas vendas e relacionamento com clientes'),
('Financeiro', 'Controle de contas a pagar, receber e fluxo de caixa'),
('Estoque', 'Gestão e controle físico dos produtos armazenados'),
('Compras', 'Negociação e aquisição de produtos junto a fornecedores'),
('Logística', 'Planejamento e execução do transporte e entrega de mercadorias'),
('Recursos Humanos', 'Gestão de pessoas, contratações e benefícios'),
('Tecnologia da Informação', 'Suporte técnico, sistemas e infraestrutura de TI'),
('Atendimento ao Cliente', 'Suporte e pós-venda para os clientes da empresa'),
('Marketing', 'Estratégias de divulgação, publicidade e branding'),
('Diretoria', 'Alta gestão e definição de estratégias corporativas'),
('Jurídico', 'Assessoria legal e contratos da empresa'),
('Contabilidade', 'Escrituração contábil e obrigações fiscais'),
('Qualidade', 'Controle de qualidade de produtos e processos'),
('Manutenção', 'Manutenção predial e de equipamentos'),
('Segurança do Trabalho', 'Prevenção de acidentes e normas de segurança'),
('Pesquisa e Desenvolvimento', 'Inovação e desenvolvimento de novos produtos'),
('E-commerce', 'Gestão da loja virtual e canais digitais de venda'),
('Auditoria Interna', 'Verificação de processos e conformidade interna'),
('Suprimentos', 'Gestão de insumos e materiais de apoio operacional'),
('Faturamento', 'Emissão de notas fiscais e faturas'),
('Cobrança', 'Gestão de inadimplência e recuperação de crédito'),
('Planejamento Estratégico', 'Definição de metas e planos de longo prazo'),
('Treinamento e Desenvolvimento', 'Capacitação e desenvolvimento de colaboradores'),
('Importação e Exportação', 'Gestão de operações internacionais de compra e venda'),
('Business Intelligence', 'Análise de dados e geração de relatórios estratégicos'),
('Design e Criação', 'Criação visual de campanhas e materiais gráficos'),
('Infraestrutura', 'Gestão de instalações físicas e ativos da empresa'),
('Relacionamento com Fornecedores', 'Gestão de parcerias e contratos com fornecedores'),
('Controladoria', 'Controle orçamentário e análise de indicadores financeiros'),
('Sustentabilidade', 'Ações e projetos de responsabilidade socioambiental');
GO

CREATE OR ALTER TRIGGER tg_DesativaDepartamento
ON Departamento
AFTER UPDATE
AS
BEGIN
    -- Quando o departamento é desativado (S -> N)
    UPDATE D
    SET D.DataDesativacaoDepartamento = GETDATE()
    FROM Departamento D
        JOIN inserted I ON D.IdDepartamento = I.IdDepartamento
        JOIN deleted DE ON D.IdDepartamento = DE.IdDepartamento
    WHERE I.DepartamentoAtivo = 'N' AND DE.DepartamentoAtivo = 'S'

    -- Quando o departamento é reativado (N -> S)
    UPDATE D
    SET D.DataDesativacaoDepartamento = NULL
    FROM Departamento D
        JOIN inserted I ON D.IdDepartamento = I.IdDepartamento
        JOIN deleted DE ON D.IdDepartamento = DE.IdDepartamento
    WHERE I.DepartamentoAtivo = 'S' AND DE.DepartamentoAtivo = 'N'
END
GO