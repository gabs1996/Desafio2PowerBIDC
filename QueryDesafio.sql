
SELECT * FROM exercnovemescla
SELECT * FROM project
SELECT * FROM departament
SELECT * FROM dependent
SELECT * FROM dept_locations
SELECT * FROM employee
SELECT * FROM exercnovemescla
SELECT * FROM project
SELECT * FROM works_on

ALTER TABLE employee
ADD Gerente varchar
-------------------------------------------------------VERIFICAR QUEM ERAM OS GERENTES
UPDATE employee
SET Gerente = 
  CASE 
    WHEN Ssn IN ('888665555', '987654321', '333445555') THEN 'S'
    ELSE 'N'
  END;
------------------------------------------------NOVAS COLUNAS PARA COLOCAR DADOS DO ENDEREÇO
  ALTER TABLE employee
ADD NumeroEndereco NVARCHAR(255),
    RuaEndereco NVARCHAR(255),
    CidadeEndereco NVARCHAR(255),
    EstadoEndereco NVARCHAR(255);
--------------------------------------------------QUEBRANDO DADOS DO ENDEREÇO PARA AS NOVAS COLUNAS
	UPDATE employee
SET NumeroEndereco = PARSENAME(REPLACE(Endereco, '-', '.'), 4),
    RuaEndereco = PARSENAME(REPLACE(Endereco, '-', '.'), 3),
    CidadeEndereco = PARSENAME(REPLACE(Endereco, '-', '.'), 2),
    EstadoEndereco = PARSENAME(REPLACE(Endereco, '-', '.'), 1);
-----------------------------------------------------------------ALTERANDO MANUALMENTE UM REGISTRO POIS ELE TINHA MAIS ITENS POR "-"
UPDATE employee
SET NumeroEndereco = '975',
    RuaEndereco = 'Fire Oak',
    CidadeEndereco = 'Humble',
    EstadoEndereco = 'TX'
WHERE NomeCompleto = 'Ramesh Narayan';
--------------------------------------------------------------------------------------COLOQUEI O DADO DO GERENTE QUE FALTAVA
UPDATE employee
SET NumeroGerente = '888665555'
WHERE Ssn = 888665555;

---------------------------------------------------------------------------------------COLOQUEI O NOME DOS GERENTES NA TABELA PARA FAZER UM JOIN COM EMPLOYEE E CRIAR A NOVA TABELA SOLICITADA
ALTER TABLE departament
add NomeGerente nvarchar(255)

UPDATE departament
SET departament.NomeGerente = employee.NomeCompleto
FROM departament
RIGHT JOIN employee
ON departament.NumeroGerente = employee.Ssn

ALTER TABLE employee
add NomeGerente nvarchar(255)

Begin transaction
UPDATE employee
SET employee.NomeGerente = departament.NomeGerente
FROM employee
RIGHT JOIN departament
ON employee.NumeroGerente = departament.NumeroGerente

----------------------------------------------------------------------------------------ATUALIZEI A TABELA DE TRABALHO PARA SABER QUAIS PRODUTOS ERAM MAIS TRABALHADOS

ALTER TABLE works_on
add NomeProduto nvarchar(255)

Begin transaction
UPDATE works_on
SET works_on.NomeProduto = project.NomeProduto
FROM works_on
RIGHT JOIN project
ON works_on.NumeroProduto = project.NumeroProduto

----------------------------------------------------------------------------------------LOCALIZAÇÃO E DEPARTAMENTO
begin transaction
ALTER TABLE project
add NomeDepartamento nvarchar(255)

Begin transaction
UPDATE project
SET project.NomeDepartamento = departament.NomeDepartamento
FROM project
left JOIN departament
ON departament.NumeroDepartamento = project.NumeroDepartamento

---------------------------------------------------------------------------------------CONSULTA QUE UTILIZEI PARA ALTERAR NOMES DOS CAMPOS

EXEC sp_rename 'works_on.Hours', 'Horas', 'COLUMN';

--para comitar as mudanças
begin transaction
commit
-- para desfazer as mudanças
rollback


/* O processo de ETL foi criado a partir de um servidor e um banco de dados que criei na Azure
com nome de "desafio-dio1" e banco de dados com o mesmo nome, foi conectado o Banco de dados ao
SQL Server e assim fui criando e fazendo as alterações necessárias no Banco de Dados, quando finalizado
fiz os ajustes do painel gerencial no Power BI, organizando as relações por lá também. */
