CREATE DATABASE desafio;

USE desafio;

CREATE SCHEMA qualidade;

CREATE TABLE qualidade.dados_avaliacao(
cd_avaliacao CHAR(2) PRIMARY KEY NOT NULL,
nm_avaliacao VARCHAR(50) NOT NULL);

CREATE TABLE qualidade.funcionario(
cd_matricula INT PRIMARY KEY IDENTITY(1,1),
nm_funcionario VARCHAR(50) NOT NULL);

CREATE TABLE qualidade.producao(
cd_linha_producao INT PRIMARY KEY NOT NULL);

CREATE TABLE qualidade.produto(
cd_produto INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
nm_produto VARCHAR(50) NOT NULL);

CREATE TABLE qualidade.dados_produto(
cd_produto INT  PRIMARY KEY IDENTITY (1,1),
aa_fabricacao DATE NOT NULL,
cd_linha_producao INT NOT NULL
FOREIGN KEY(cd_linha_producao) REFERENCES qualidade.producao(cd_linha_producao));

CREATE TABLE qualidade.avaliacao(
cd_ficha INT PRIMARY KEY IDENTITY (1,1),
cd_avaliacao CHAR (2),
dt_avaliacao DATE,
nm_funcionario VARCHAR (50) NOT NULL,
hr_inicio DATETIME NOT NULL,
hr_fim  DATETIME NOT NULL,
cd_matricula INT NOT NULL,
cd_produto INT NOT NULL
FOREIGN KEY (cd_avaliacao) REFERENCES qualidade.dados_avaliacao(cd_avaliacao),
FOREIGN KEY (cd_matricula) REFERENCES qualidade.funcionario(cd_matricula),
FOREIGN KEY (cd_produto)   REFERENCES qualidade.produto(cd_produto));

INSERT INTO qualidade.dados_avaliacao(cd_avaliacao, nm_avaliacao) VALUES 
('OK', 'LIBERADO'),
('EL', 'PROBLEMA ELÉTRICO'),
('PT', 'PROBLEMA DE PINTURA'), 
('PE', 'PROBLEMA NA ESTRUTURA'),
('TR', 'TODO REJEITADO')

INSERT INTO qualidade.funcionario(nm_funcionario) VALUES
('TRANCOSO'),
('ANDERSON'),
('ELAINE'),
('TATIANE'),
('JULIO')

INSERT INTO qualidade.producao(cd_linha_producao) VALUES ('1'), ('2'), ('3'), ('4')

INSERT INTO qualidade.produto(nm_produto) VALUES 
('GELADEIRA'),
('MAQUINA DE LAVAR'),
('FOGAO'),
('FREEZER'),
('FRIGOBAR')

INSERT INTO qualidade.dados_produto(aa_fabricacao,cd_linha_producao) VALUES 
('2022', 2),
('2022', 1),
('2022', 1),
('2022', 3),
('2022', 3)

INSERT INTO qualidade.avaliacao(cd_avaliacao, dt_avaliacao, nm_funcionario, hr_inicio, hr_fim, cd_matricula, cd_produto) VALUES
('OK', '2022-12-01', 'JULIO', '08:53', '11:00', 1, 1),
('EL', '2022-12-16', 'TRANCOSO', '08:48', '10:31', 1, 2),
('TR', '2022-12-22', 'ELAINE', '08:30', '11:30', 1, 3),
('EL', '2022-12-21', 'TRANCOSO', '08:30', '09:57', 1, 4),
('OK', '2023-01-04', 'TRANCOSO', '07:53', '12:00', 1, 1),
('PE', '2022-12-21', 'ANDERSON',  '08:21', '12:00', 2, 5),
('PT', '2022-12-21', 'ELAINE',   '08:21', '12:00', 3, 2),
('OK', '2022-12-21', 'TATIANE',  '08:21', '12:00', 4, 4)

--Quantas horas de controle de qualidade o inspetor Trancoso da Silva fez no dia 16/12/2022?
SELECT
DATEDIFF(MINUTE, hr_inicio, hr_fim) AS horas
FROM qualidade.avaliacao 
WHERE dt_avaliacao = '2022-12-16' AND cd_matricula = 1 
--Foram 103 minutos.

--Quantas horas o inspetor Trancoso da Silvatrabalhou no período de 01/12/2022 à 22/12/2022?
SELECT
SUM(DATEDIFF(MINUTE, hr_inicio, hr_fim)) AS tempo
FROM qualidade.avaliacao
WHERE cd_matricula = 1 AND dt_avaliacao BETWEEN '2022-12-01' AND '2022-12-22'
--Foram 954 minutos.

--Quais os tipos de defeito mais recorrentes no período de 01/12/2022 à 22/12/2022?
SELECT
COUNT(cd_avaliacao), 
cd_avaliacao
FROM qualidade.avaliacao
WHERE dt_avaliacao BETWEEN '2022-12-01' AND '2022-12-22'
GROUP BY cd_avaliacao 
--O erro mais recorrente foi pane elétrica (EL).

--Quais inspetores atestam mais produtos com avaliação TR, todo rejeitado.
SELECT 
COUNT(cd_avaliacao), 
nm_funcionario
FROM qualidade.avaliacao
WHERE cd_avaliacao = 'TR'
GROUP BY nm_funcionario
--Elaine foi quem mais atestou TR: 1 vez.

--Quais produtos que só foram liberados depois da detecção de algum problema?
SELECT 
COUNT(cd_avaliacao) as cod_avaliacao,
cd_produto
FROM qualidade.avaliacao
WHERE cd_avaliacao != 'OK' AND cd_avaliacao !='TR'
GROUP BY cd_produto
--Produtos 2 Maq de Lavar, 4 Freezer e 5 Frigobar.