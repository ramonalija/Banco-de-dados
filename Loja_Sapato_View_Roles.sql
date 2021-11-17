USE db_loja_sapatos;

CREATE VIEW v_funcionario as 
SELECT 
	id_funcionario, 
	p.nome, cargo, 
    c.nome_cidade as cidade, 
    valor_salario as salario
		FROM tbFuncionario
			JOIN tbPessoa p 			USING (id_pessoa)
			JOIN tb_tipo_funcionario 	USING (id_tipoFuncionario)
			JOIN tbEndereco 			USING (id_endereco)
			JOIN tbBairro 				USING (id_bairro)
			JOIN tbCidade c 			USING (id_cidade)
;

SELECT * FROM v_funcionario;

drop role r_funcionario;
CREATE ROLE r_funcionario;

GRANT SELECT ON v_funcionario TO r_funcionario;

drop user lserafim@localhost;
CREATE USER calberto@localhost IDENTIFIED BY 'passwd';
CREATE USER abeatriz@localhost IDENTIFIED BY 'passwd';
CREATE USER drodrigues@localhost IDENTIFIED BY 'passwd';
CREATE USER rcarlos@localhost IDENTIFIED BY 'passwd';
CREATE USER adasdores@localhost IDENTIFIED BY 'passwd';
CREATE USER lserafim@localhost IDENTIFIED BY 'passwd';

GRANT r_funcionario TO 
	calberto@localhost, abeatriz@localhost,
    drodrigues@localhost, rcarlos@localhost,
    adasdores@localhost, lserafim@localhost;


use mysql;
show tables;
select * from user;

SET DEFAULT ROLE ALL TO 
	calberto@localhost, abeatriz@localhost,
    drodrigues@localhost, rcarlos@localhost,
    adasdores@localhost, lserafim@localhost;