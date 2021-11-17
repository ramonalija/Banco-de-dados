drop schema db_Loja_Sapatos;
CREATE SCHEMA db_Loja_Sapatos;

USE db_Loja_Sapatos;


drop TABLE tbProduto;

CREATE TABLE tbProduto (
    id_produto 		INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nome 			VARCHAR(50) NOT NULL,
    valor_unitario 	DECIMAL (12,2) NOT NULL
    
);


drop TABLE tb_tipo_funcionario;

CREATE TABLE tb_tipo_funcionario(
	id_tipoFuncionario 	INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    cargo 				VARCHAR(45) NOT NULL
    
);


drop table tbEstado;

CREATE TABLE tbEstado (
    id_estado 		INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nome_estado 	char(20) NOT NULL
    
);


drop table tbCidade;

CREATE TABLE tbCidade (
    id_cidade 		INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nome_cidade 	char(20) NOT NULL,
    id_Estado 		int UNSIGNED NOT NULL,
    
    INDEX 			fk_cidade_estado_idx (id_estado ASC),
    CONSTRAINT 		fk_cidade_estado
		FOREIGN KEY (id_Estado) REFERENCES tbEstado (id_Estado)
		ON DELETE NO ACTION ON UPDATE NO ACTION
);


drop table tbBairro;

CREATE TABLE tbBairro (
	id_bairro 	INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nome 		char(50) NOT NULL,
    id_cidade 	INT UNSIGNED NOT NULL,
    
    UNIQUE INDEX id_bairro_UNIQUE (id_bairro ASC),
    
    INDEX 			fk_bairro_cidade_idx (id_cidade ASC),
    CONSTRAINT 		fk_bairro_cidade
		FOREIGN KEY (id_cidade) REFERENCES tbCidade (id_cidade)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);


drop table tbEndereco;

CREATE TABLE tbEndereco (
    id_endereco 	INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nome_rua 		CHAR(50) NOT NULL,
    numero_casa 	INT UNSIGNED,
    id_bairro 		INT UNSIGNED NOT NULL,
    
	UNIQUE INDEX id_endereco_UNIQUE (id_endereco ASC),
    
	INDEX 		fk_endereco_bairro_idx (id_bairro ASC),
    CONSTRAINT 	fk_endereco_bairro
		FOREIGN KEY (id_bairro) REFERENCES tbBairro (id_bairro)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);


drop table tbPessoa;

CREATE TABLE tbPessoa(
	id_pessoa 	INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome 		VARCHAR(100) NOT NULL,
    cpf 		VARCHAR(50) NOT NULL,
    id_endereco INT UNSIGNED NOT NULL,
    
    UNIQUE INDEX id_pessoa_UNIQUE (id_pessoa ASC),
    
    INDEX 		fk_pessoa_endereco_idx (id_endereco ASC),
    CONSTRAINT 	fk_pessoa_endereco
		FOREIGN KEY (id_endereco) REFERENCES tbEndereco (id_endereco)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);


drop table tbFuncionario;

CREATE TABLE tbFuncionario (
	id_funcionario 		INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    valor_salario 		DECIMAL(12,2) NOT NULL,
    id_pessoa 			INT UNSIGNED NOT NULL,
    id_tipoFuncionario 	INT UNSIGNED NOT NULL,
    
    UNIQUE INDEX id_funcionario_UNIQUE (id_funcionario ASC),	
    
    INDEX 		fk_funcionario_pessoa_idx (id_pessoa ASC),
    CONSTRAINT 	fk_funcionario_pessoa
		FOREIGN KEY (id_pessoa) REFERENCES tbPessoa (id_pessoa)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
        
	INDEX 		fk_funcionario_tipoFuncionario_idx (id_tipoFuncionario ASC),
    CONSTRAINT 	fk_funcionario_tipoFuncionario
		FOREIGN KEY (id_tipoFuncionario) REFERENCES tb_tipo_funcionario (id_tipoFuncionario)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);


drop table tbNotaFiscal;

CREATE TABLE tbNotaFiscal (
    id_nota 		INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    data_venda 		DATE NOT NULL,
    hora_venda 		TIME NOT NULL,
    data_pagamento 	DATE NOT NULL,
    valor_NF 		DECIMAL(12,2) NOT NULL,
	id_cliente 		INT UNSIGNED NOT NULL,
    
	UNIQUE INDEX id_nota_UNIQUE (id_nota ASC),
    
    INDEX 		fk_nota_cliente_idx (id_cliente ASC),
    CONSTRAINT 	fk_nota_cliente
		FOREIGN KEY (id_cliente) REFERENCES tbPessoa (id_pessoa)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);


drop table tbNotaFiscalVenda;

CREATE TABLE tbNotaFiscalVenda (
    id_itens_venda 		INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    valor_unitario 		DECIMAL (12,2) NOT NULL,
    quantidade 			INT UNSIGNED DEFAULT 1,
    id_produto 			INT UNSIGNED NOT NULL,
    id_nota 			INT UNSIGNED NOT NULL,
    
    UNIQUE KEY id_itens_venda_UNIQUE (id_itens_venda ASC),
    
	INDEX 		fk_itensNota_produto_idx (id_produto ASC),
	CONSTRAINT 	fk_itensNota_produto
		FOREIGN KEY (id_produto) REFERENCES tbProduto (id_produto)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
        
	INDEX 		fk_itensNota_nota_idx (id_nota ASC),
	CONSTRAINT 	fk_itensNota_nota
		FOREIGN KEY (id_nota) REFERENCES tbNotaFiscal (id_nota)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);


drop table tbAtendentesNota;

CREATE TABLE tbAtendentesNota (
	id_atendentes_nota 	INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_nota 			INT UNSIGNED NOT NULL,
	id_vendedor 		INT UNSIGNED NOT NULL,
    id_caixa 			INT UNSIGNED NOT NULL,
    
    UNIQUE INDEX id_atendentes_nota_UNIQUE (id_atendentes_nota ASC),
    
    INDEX 		fk_atendentes_nota_idx (id_nota ASC),
	CONSTRAINT 	fk_atendentes_nota
		FOREIGN KEY (id_nota) REFERENCES tbNotaFiscal (id_nota)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
        
	INDEX 		fk_atendentes_vend_idx (id_vendedor ASC),
	CONSTRAINT 	fk_atendentes_vend
		FOREIGN KEY (id_vendedor) REFERENCES tbFuncionario (id_funcionario)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
        
	INDEX 		fk_atendentes_caixa_idx (id_caixa ASC),
	CONSTRAINT 	fk_atendentes_caixa
		FOREIGN KEY (id_caixa) REFERENCES tbFuncionario (id_funcionario)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);


INSERT INTO tbProduto VALUES
	(1, 'Cinto', 11.20),
    (2, 'Sapato', 40.20),
    (3, 'Meia', 5.00),
    (4, 'Tenis', 99.99),
    (5, 'Sandalia', 29.99),
    (6, 'Carteira', 14.99);
    
    
INSERT INTO tb_tipo_funcionario VALUES
	(1, 'Vendedor'),
    (2, 'Caixa');
    

INSERT INTO tbEstado VALUES
	(1, 'Parana'),
    (2, 'Santa Catarina'),
    (3, 'São Paulo'),
    (4, 'Rio de Janeiro'),
    (5, 'Pará'),
    (6, 'Rio Grande do Sul');
    
    
INSERT INTO tbCidade VALUES
	(1, 'Umuarama', 1),
    (2, 'Goioere', 1),
    (3, 'Maria Helena', 1),
    (4, 'Londrina', 3),
    (5, 'Curitiba', 4),
    (6, 'Maringa', 5),
    (7, 'Cruzeiro do Oeste', 6);
    
    
INSERT INTO tbBairro VALUES
	(1, 'Zona I', 1),
    (2, 'Zona II', 1),
    (3, 'Zona III', 7),
    (4, 'Zona IV', 3),
    (5, 'Zona V', 4),
    (6, 'Centro', 5),
    (7, 'Trindade', 6),
	(8, 'Jardim Cruzeiro', 1),
    (9, 'Lago', 4),
    (10, 'Guarani', 2),
    (11, 'Industrial', 3),
    (12, 'Ouro Verde', 4),
    (13, 'Jardim Panorama', 5),
    (14, 'Arco-Iris', 6),
    (15, 'Sonho Meu', 4),
    (16, 'Pedro II', 3);
    
    
INSERT INTO tbEndereco VALUES
	(1, 'AAAA', 1243, 1),
    (2, 'AAAB', 1646, 2),
    (3, 'AAAC', 7789, 3),
    (4, 'AAAD', 3094, 4),
    (5, 'AAAE', 4132, 5),
    (6, 'AAAF', 5254, 6),
    (7, 'AAAG', 6234, 7),
	(8, 'AAAH', 1754, 8),
    (9, 'AAAI', 4435, 9),
    (10, 'AAAJ', 2632, 10),
    (11, 'AAAK', 3547, 11),
    (12, 'AAAL', 4632, 12),
    (13, 'AAAM', 5134, 13),
    (14, 'AAAN', 6765, 14);
    
    
INSERT INTO tbPessoa VALUES
	(1, 'Ana', '4724321421', 1),
    (2, 'Roberto', '453425326', 2),
    (3, 'Carlos', '5325743665', 3),
    (4, 'Darlon', '56352543247', 4),
    (5, 'Amélia', '543254235', 5),
    (6, 'Lúcia', '53245234523', 6),
    (7, 'Raul', '5435324523', 7),
    (8, 'Ruan', '5767866698', 8),
    (9, 'Juliana', '314321423', 9), 
    (10, 'Isabela', '6476856965', 10), 
    (11, 'Juan', '2141254326532', 11),
    (12, 'Wilson', '34674764367', 12),
    (13, 'Aline', '27139041432', 13),
    (14, 'Eliane', '4215743280', 14),
    (15, 'Thomas', '3427583263', 14),
    (16, 'Henrick', '45255459070', 14);


INSERT INTO tbFuncionario VALUES
	(1, 1000, 1, 1),
    (2, 2000, 2, 1),
    (3, 3000, 3, 2),
    (4, 4000, 4, 2),
    (5, 5000, 5, 1),
    (6, 6000, 6, 1);
    

INSERT INTO tbNotaFiscal VALUES
	(1, '2021-02-02', '09:44', '2021-02-02', '80', 7),
	(2, '2021-02-01', '11:33', '2021-02-01', '235', 8),
	(3, '2021-02-02', '16:21', '2021-02-02', '30', 9),
	(4, '2021-02-01', '13:04', '2021-02-01', '160', 10),
	(5, '2021-02-03', '14:12', '2021-02-03', '103', 11),
    (6, '2021-02-03', '12:55', '2021-02-03', '307', 12),
	(7, '2021-02-04', '08:46', '2021-02-04', '70', 13),
	(8, '2021-02-04', '10:46', '2021-02-04', '110', 14),
    (9, '2021-02-05', '18:00', '2021-02-05', '25', 15),
	(10, '2021-02-05', '09:46', '2021-02-05', '600', 16);
    

INSERT INTO tbNotaFiscalVenda VALUES
	(1, 12.76, 1, 1, 1), 
    (2, 12.76, 3, 2, 2), 
    (3, 12.76, 2, 3, 3), 
    (4, 12.76, 3, 6, 4), 
    (5, 12.76, 2, 4, 5), 
    (6, 12.76, 6, 2, 6), 
    (7, 12.76, 3, 6, 7), 
    (8, 12.76, 5, 5, 8), 
    (9, 12.76, 2, 3, 9), 
    (10, 12.76, 1, 4, 10);
    

INSERT INTO tbAtendentesNota VALUES
	(1, 1, 1, 3),
    (2, 2, 2, 3),
    (3, 3, 5, 4),
    (4, 4, 6, 3),
    (5, 5, 6, 4),
    (6, 6, 5, 3), 
    (7, 7, 2, 3),
    (8, 8, 1, 4),
    (9, 9, 5, 4),
    (10, 10, 1, 3);
    
    
    
    
    
    




