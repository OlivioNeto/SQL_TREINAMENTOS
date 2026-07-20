-- SPRINT 7.1 Estrutura organizacional
-- TABELA DEPARTAMENTO
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

-- TABELA CARGO
USE LojaVirtual
GO

CREATE TABLE Cargo(
    IdCargo SMALLINT PRIMARY KEY IDENTITY,
    NomeCargo VARCHAR (50) NOT NULL UNIQUE,
    DescricaoCargo VARCHAR (200),
    NivelCargo VARCHAR (20),
    SalarioBaseCargo MONEY NOT NULL,
    CargoAtivo CHAR (1) NOT NULL DEFAULT 'S'
    CHECK (CargoAtivo IN ('S', 'N'))
);
GO

INSERT INTO Cargo (NomeCargo, DescricaoCargo, NivelCargo, SalarioBaseCargo) VALUES
('Vendedor', 'Responsável pela venda de produtos e atendimento comercial.', 'Operacional', 2500.00),
('Vendedor Sênior', 'Vendedor com experiência e atuação em negociações estratégicas.', 'Operacional', 3800.00),
('Supervisor Comercial', 'Supervisiona a equipe de vendas.', 'Tático', 5500.00),
('Gerente Comercial', 'Gerencia toda a área comercial.', 'Estratégico', 9000.00),
('Diretor Comercial', 'Responsável pela estratégia comercial da empresa.', 'Estratégico', 18000.00),

('Assistente Financeiro', 'Auxilia nas rotinas financeiras.', 'Operacional', 2600.00),
('Analista Financeiro', 'Responsável pelas análises financeiras.', 'Tático', 4500.00),
('Coordenador Financeiro', 'Coordena a equipe financeira.', 'Tático', 7000.00),
('Gerente Financeiro', 'Gerencia o departamento financeiro.', 'Estratégico', 11000.00),
('Diretor Financeiro', 'Responsável pela estratégia financeira.', 'Estratégico', 22000.00),

('Estoquista', 'Responsável pelo armazenamento de produtos.', 'Operacional', 2300.00),
('Conferente', 'Realiza conferência de mercadorias.', 'Operacional', 2500.00),
('Separador de Pedidos', 'Separa pedidos para expedição.', 'Operacional', 2300.00),
('Supervisor de Estoque', 'Coordena o estoque.', 'Tático', 5000.00),
('Gerente de Logística', 'Gerencia logística e estoque.', 'Estratégico', 9500.00),

('Comprador', 'Responsável pela aquisição de produtos.', 'Operacional', 3500.00),
('Analista de Compras', 'Negocia com fornecedores.', 'Tático', 4500.00),
('Coordenador de Compras', 'Coordena a área de compras.', 'Tático', 6500.00),
('Gerente de Compras', 'Gerencia negociações estratégicas.', 'Estratégico', 9800.00),
('Diretor de Suprimentos', 'Define estratégias de suprimentos.', 'Estratégico', 18000.00),

('Assistente Administrativo', 'Executa atividades administrativas.', 'Operacional', 2400.00),
('Analista Administrativo', 'Analisa processos administrativos.', 'Tático', 4200.00),
('Coordenador Administrativo', 'Coordena atividades administrativas.', 'Tático', 6200.00),
('Gerente Administrativo', 'Gerencia o setor administrativo.', 'Estratégico', 9800.00),

('Atendente', 'Realiza atendimento ao cliente.', 'Operacional', 2200.00),
('Supervisor de Atendimento', 'Coordena o atendimento.', 'Tático', 4700.00),
('Gerente de Atendimento', 'Gerencia a central de atendimento.', 'Estratégico', 8800.00),

('Assistente de RH', 'Auxilia nos processos de RH.', 'Operacional', 2500.00),
('Analista de RH', 'Executa processos de recursos humanos.', 'Tático', 4300.00),
('Coordenador de RH', 'Coordena a equipe de RH.', 'Tático', 6500.00),
('Gerente de RH', 'Gerencia o departamento de RH.', 'Estratégico', 10000.00),
('Diretor de RH', 'Responsável pela gestão estratégica de pessoas.', 'Estratégico', 18000.00),

('Auxiliar de TI', 'Presta suporte técnico básico.', 'Operacional', 2800.00),
('Técnico de TI', 'Executa manutenção de hardware e software.', 'Operacional', 3600.00),
('Analista de Sistemas', 'Desenvolve e mantém sistemas.', 'Tático', 6500.00),
('Desenvolvedor Full Stack', 'Desenvolve aplicações web.', 'Tático', 7200.00),
('DBA', 'Administra bancos de dados.', 'Tático', 8500.00),
('Administrador de Redes', 'Administra a infraestrutura de redes.', 'Tático', 7000.00),
('Especialista em Segurança da Informação', 'Protege os ativos digitais.', 'Estratégico', 10500.00),
('Gerente de TI', 'Gerencia a área de tecnologia.', 'Estratégico', 13000.00),
('Diretor de Tecnologia', 'Define estratégias de tecnologia.', 'Estratégico', 22000.00),

('Motorista', 'Realiza transporte de mercadorias.', 'Operacional', 2800.00),
('Motorista Entregador', 'Realiza entregas aos clientes.', 'Operacional', 3000.00),
('Supervisor de Logística', 'Coordena entregas e transporte.', 'Tático', 6000.00),
('Coordenador Logístico', 'Coordena operações logísticas.', 'Tático', 7000.00),
('Analista Logístico', 'Analisa processos logísticos.', 'Tático', 4800.00),

('Assistente de Marketing', 'Auxilia nas campanhas.', 'Operacional', 2600.00),
('Analista de Marketing', 'Planeja campanhas.', 'Tático', 4500.00),
('Designer Gráfico', 'Produz materiais gráficos.', 'Operacional', 4200.00),
('Social Media', 'Gerencia redes sociais.', 'Operacional', 3800.00),
('Coordenador de Marketing', 'Coordena campanhas.', 'Tático', 7000.00),
('Gerente de Marketing', 'Gerencia a área de marketing.', 'Estratégico', 11000.00),

('Analista de Qualidade', 'Controla padrões de qualidade.', 'Tático', 4600.00),
('Supervisor de Qualidade', 'Coordena inspeções de qualidade.', 'Tático', 6200.00),
('Gerente de Qualidade', 'Gerencia programas de qualidade.', 'Estratégico', 9800.00),

('Analista Contábil', 'Executa atividades contábeis.', 'Tático', 4800.00),
('Contador', 'Responsável pela contabilidade.', 'Estratégico', 7500.00),
('Controller', 'Responsável pelo controle financeiro.', 'Estratégico', 11000.00),

('Analista Jurídico', 'Auxilia nas demandas jurídicas.', 'Tático', 5200.00),
('Advogado', 'Representa juridicamente a empresa.', 'Estratégico', 9000.00),
('Coordenador Jurídico', 'Coordena o departamento jurídico.', 'Estratégico', 12000.00),

('Auxiliar de Produção', 'Auxilia na produção.', 'Operacional', 2200.00),
('Operador de Máquinas', 'Opera equipamentos industriais.', 'Operacional', 3200.00),
('Supervisor de Produção', 'Coordena a produção.', 'Tático', 6000.00),
('Gerente Industrial', 'Gerencia operações industriais.', 'Estratégico', 12000.00),

('Auxiliar de Limpeza', 'Realiza limpeza das instalações.', 'Operacional', 1800.00),
('Porteiro', 'Controla acesso às dependências.', 'Operacional', 2100.00),
('Vigia', 'Realiza vigilância patrimonial.', 'Operacional', 2400.00),

('Auxiliar de Manutenção', 'Executa manutenção preventiva.', 'Operacional', 2500.00),
('Técnico de Manutenção', 'Executa manutenção corretiva.', 'Operacional', 3900.00),
('Supervisor de Manutenção', 'Coordena manutenção.', 'Tático', 6200.00),

('Analista de BI', 'Analisa indicadores e dashboards.', 'Tático', 7000.00),
('Cientista de Dados', 'Modela e analisa dados.', 'Estratégico', 11000.00),
('Engenheiro de Dados', 'Desenvolve pipelines de dados.', 'Estratégico', 10500.00),

('Auditor Interno', 'Realiza auditorias internas.', 'Tático', 6500.00),
('Coordenador de Auditoria', 'Coordena auditorias.', 'Estratégico', 9000.00),

('Assistente de Faturamento', 'Emite notas fiscais.', 'Operacional', 2600.00),
('Analista de Faturamento', 'Controla faturamento.', 'Tático', 4300.00),

('Assistente de Cobrança', 'Realiza cobranças.', 'Operacional', 2400.00),
('Analista de Cobrança', 'Analisa inadimplência.', 'Tático', 4200.00),

('Analista de E-commerce', 'Administra a loja virtual.', 'Tático', 5200.00),
('Coordenador de E-commerce', 'Coordena operações digitais.', 'Tático', 7800.00),
('Gerente de E-commerce', 'Gerencia os canais digitais.', 'Estratégico', 12000.00),

('Assistente de Pesquisa', 'Auxilia em projetos de inovação.', 'Operacional', 2700.00),
('Pesquisador', 'Desenvolve novos produtos.', 'Tático', 6500.00),
('Coordenador de P&D', 'Coordena projetos de inovação.', 'Estratégico', 11000.00),

('Auxiliar de Segurança do Trabalho', 'Auxilia nas normas de segurança.', 'Operacional', 2800.00),
('Técnico de Segurança do Trabalho', 'Fiscaliza normas de segurança.', 'Tático', 5200.00),
('Engenheiro de Segurança do Trabalho', 'Responsável pela engenharia de segurança.', 'Estratégico', 11000.00),

('CEO', 'Diretor executivo da empresa.', 'Estratégico', 30000.00),
('Presidente', 'Presidente da organização.', 'Estratégico', 35000.00),
('Vice-Presidente', 'Vice-presidente executivo.', 'Estratégico', 25000.00),
('Conselheiro', 'Participa das decisões estratégicas.', 'Estratégico', 20000.00),
('Estagiário', 'Colaborador em formação profissional.', 'Operacional', 1500.00),
('Jovem Aprendiz', 'Programa de aprendizagem profissional.', 'Operacional', 1400.00);
GO

-- TABELA DEPARTAMENTOCARGO
CREATE TABLE DepartamentoCargo(
    IdDepartamentoCargo SMALLINT PRIMARY KEY IDENTITY,
    DepartamentoCargoAtivo CHAR(1) NOT NULL DEFAULT 'S',
    DataCriacaoDepartamentoCargo DATE NOT NULL DEFAULT GETDATE(),
	DataDesativacaoDepartamentoCargo DATE NULL,
    IdCargo SMALLINT NOT NULL,
    IdDepartamento TINYINT NOT NULL,
    CHECK (DepartamentoCargoAtivo IN ('S', 'N')),
    CONSTRAINT fk_id_cargo_DC FOREIGN KEY (IdCargo) REFERENCES
    Cargo(IdCargo),
    CONSTRAINT fk_id_departamento_DC FOREIGN KEY (IdDepartamento) REFERENCES
    Departamento(IdDepartamento),
    CONSTRAINT uq_departamento_cargo UNIQUE (IdDepartamento, IdCargo)
);

-- ALTERANDO A TABELA FUNCIONARIO
ALTER TABLE Funcionario
ADD
    CPFFuncionario CHAR (11) NULL,
    EmailFuncionario VARCHAR (60),
    TelefoneFuncionario VARCHAR (20) NULL,
    DataNascimentoFuncionario DATE NULL,
    DataAdmissaoFuncionario DATE NULL,
    FuncionarioAtivo CHAR (1) NULL DEFAULT 'S',
    DataCriacaoFuncionario DATE NULL DEFAULT GETDATE(),
    DataDesligamentoFuncionario DATE,
    MatriculaFuncionario SMALLINT NULL, 
    IdDepartamentoCargo SMALLINT NULL,
    CONSTRAINT fk_departamento_cargo_FU FOREIGN KEY (IdDepartamentoCargo)
    REFERENCES DepartamentoCargo (IdDepartamentoCargo),
    CHECK (FuncionarioAtivo IN ('S', 'N'))

-- ALTERANDO A TABELA VENDEDOR
    /*DataInicioComoVendedor
      DataFimComoVendedor
      PercentualComissaoVendedor
      VendedorAtivo
      MetaVendasVendedor
      TipoComissaoVendedor
      fk de pedido
      fk de funcionario*/

ALTER TABLE Vendedor
ADD IdFuncionario SMALLINT NULL
    CONSTRAINT fk_funcionario_VE FOREIGN KEY (IdFuncionario)
    REFERENCES Funcionario (IdFuncionario)

    select NomeFuncionario from Funcionario