-- Tabela pessoa - Representa pessoas que criam 0 ou n tickets dentro do sistema de banco de dados Níquel.
CREATE TABLE Pessoa (
    nome varchar(100),
    cpf varchar(20) PRIMARY KEY,
    email varchar(100)
);

-- Garantindo que o nome da pessoa seja único dentro do Banco.
ALTER TABLE Pessoa ADD CONSTRAINT unique_nome UNIQUE (nome);

-- Criação da tabela Telefone que contém 0 ou números de telefones de uma determinada pessoa.
CREATE TABLE Telefone (
    numero varchar(100),
    cpf_telefone varchar(20)
);

-- Modificando a tabela Telefone para que ela passe a ter a chave estrangeira referenciando a pessoa.
ALTER TABLE Telefone
    ADD FOREIGN KEY (cpf_telefone) REFERENCES Pessoa(cpf),
    ADD PRIMARY KEY (cpf_telefone, numero);

-- Criação da tabela Ticket. A pessoa abre o ticket.
-- Quando um ticket é aberto, a pessoa informa o endereço do local do atendimento, o título do atendimento, como o banco vai rodar sozinho então vou criar manualmente o protocolo usando integer, a data de abertura é feita dada pelo banco, o fechamento é null por que o ticket está aberto. O número de patrimônio do equipamento e o cpf_ticket que referencia o identificador da pessoa que criou o ticket.
CREATE TABLE Ticket (
    endereco varchar(100),
    titulo varchar(100),
    protocolo integer, -- Como solicitado, as consultas devem rodar fora da API Java, para isso, tornei o serial um inteiro para garantir que vou fechar os tickets corretos
    abertura timestamp,
    fechamento timestamp,
    patrimonio varchar(100),
    cpf_ticket varchar(20)
);

-- Modificando a tabela Ticket para adicionar a chave primária protocolo e a chave estrangeira que referencia pessoa no atributo cpf.
ALTER TABLE Ticket
    ADD PRIMARY KEY(protocolo),
    ADD FOREIGN KEY (cpf_ticket) REFERENCES Pessoa(cpf);

-- Criação da tabela Servidor. Um servidor é uma especialização de pessoa. Então para criar um servidor, é preciso criar uma pessoa anteriormente. Ele tem o siape, a unidade, o login, senha e o cpf_servidor.
CREATE TABLE Servidor (
    siape varchar(10),
    unidade varchar(100),
    login varchar(100),
    senha varchar(100),
    cpf_servidor varchar(20)
);

-- Modificando a tabela Servidor para que cpf_servidor seja referência do cpf na tabela pessoa.
ALTER TABLE Servidor
    ADD FOREIGN KEY (cpf_servidor) REFERENCES Pessoa(cpf),
    ADD PRIMARY KEY (login, cpf_servidor);

-- Criação da tabela Bolsista que assim como servidor também é uma especialização de pessoa. Então para criar um servidor, é preciso criar uma pessoa anteriormente. Ele tem a matricula, o login, a senha, o curso e o cpf_bolsista.
CREATE TABLE Bolsista (
    matricula varchar(10),
    login varchar(100),
    senha varchar(100),
    curso varchar(100),
    cpf_bolsista varchar(20)
);

-- Modificando a tabela Bolsista para que o cpf_bolsista se referencie a pessoa(cpf)
ALTER TABLE Bolsista
    ADD FOREIGN KEY (cpf_bolsista) REFERENCES Pessoa(cpf),
    ADD PRIMARY KEY (login, cpf_bolsista);

-- Toda vez que um ticket é criado, o usuário tem que informar uma descrição após o título para o ticket. Quando é a pessoa que abre o ticket, vai ir para o autor o pessoa(nome).
CREATE TABLE Descricao (
    descricao varchar(500),
    data timestamp,
    autor varchar(100),
    protocolo integer
);

-- Modificando a tabela Descrição para que o protocolo referencie ticket(protocolo) e autor referencie pessoa(nome).
ALTER TABLE Descricao
    ADD FOREIGN KEY (protocolo) REFERENCES Ticket(protocolo),
    ADD FOREIGN KEY (autor) REFERENCES Pessoa(nome);


-- Criando no banco uma linha na tabela Pessoa com os atributos < Nome: Ana Marilza Pernas. Dados: CPF 11122233344490. E-mail: marilza@inf.ufpel.edu.br >
INSERT INTO Pessoa (nome, cpf, email)
VALUES ('Ana Marilza Pernas', '11122233344490', 'marilza@inf.ufpel.edu.br');

-- Fazendo Ana criar uma linha na tabela Ticket com os atributos: Endereço: Anglo, 329. Titulo: Projetor com Defeito. Protocolo: 1. Abertura: Timestamp (o banco gera). Fechamento (null), pois o ticket foi aberto, e não fechado. Patrimônio: RP402030. cpf_ticket é chave estrangeira de Pessoa(CPF), então recupero o CPF da Ana.
INSERT INTO Ticket (endereco, titulo, protocolo, abertura, patrimonio, cpf_ticket)
VALUES ('Anglo, 329', 'Projetor com Defeito', 1, NOW(), 'RP402030', '11122233344490');

-- Adicionar números de telefone 884475 e 998562 à tabela Telefone referenciando à Ana.
INSERT INTO Telefone (numero, cpf_telefone)
VALUES ('884475', '11122233344490'), ('998562', '11122233344490');

-- Como Ana está abrindo um ticket, é necessário criar uma descrição para esse ticket com os atributos: Descrição: O projetor apresenta linhas verdes verticais durante a projeção em HDMI. O data é timestamp, gerado pelo banco. O autor é chave estrangeira que recupera Pessoa(nome), ou seja, o nome de Ana. O protocolo é chave estrangeira do protocolo, que no caso é o protocolo 1.
INSERT INTO Descricao (descricao, data, autor, protocolo)
VALUES ('O projetor apresenta linhas verdes verticais durante a projeção em HDMI', NOW(), 'Ana Marilza Pernas', 1);

-- Criando no banco uma linha na tabela Pessoa com os atributos < Nome: Heitor Silva Avila. Dados: CPF 03191639039. Email heitoravila.ti@gmail.com > 
INSERT INTO Pessoa (nome, cpf, email)
VALUES ('Heitor Silva Avila', '03191639039', 'heitoravila.ti@gmail.com');

-- Heitor é um bolsista, então adicionar na tabela Bolsista os atributos para que Heitor seja um bolsita, sendo eles: < Matricula: 20202809. Login: heitor.avila. Senha: ana_me_ajuda. Curso: 3900 - Computação. cpf_bolsista é FK para Pessoa(cpf) de Heitor.
INSERT INTO Bolsista (matricula, login, senha, curso, cpf_bolsista)
VALUES ('20202809', 'heitor.avila', 'ana_me_ajuda', '3900 - Computação', '03191639039');

-- Adicionar números de telefone 894521 e 991562 à tabela Telefone para Heitor.
INSERT INTO Telefone (numero, cpf_telefone)
VALUES ('894521', '03191639039'), ('991562', '03191639039');

-- Agora Heitor cria uma descrição no ticket de Ana com os dados < Descrição: Equipamento recolhido! Timestamp gerado pelo banco. O autor é chave estrangeira que recupera Pessoa(nome), ou seja, o nome de Heitor. O protocolo é chave estrangeira do protocolo, que no caso é o protocolo 1.
INSERT INTO Descricao (descricao, data, autor, protocolo)
VALUES ('Equipamento recolhido!', NOW(), 'Heitor Silva Avila', 1);

-- Agora Heitor cria uma nova descrição informando Ana que o equipamento está disponível para retirada na sala 346. Nesse caso: < Descricao: Equipamento disponível para retirada. Timestamp gerado pelo banco. O autor é chave estrangeira que recupera Pessoa(nome), ou seja, o nome de Heitor. O protocolo é chave estrangeira do protocolo, que no caso é o protocolo 1.>
INSERT INTO Descricao (descricao, data, autor, protocolo)
VALUES ('Equipamento disponível para retirada', NOW(), 'Heitor Silva Avila', 1);

-- Como Heitor consertou o equipamento, então Heitor adiciona o timestamp de fechamento no ticket 1 criado por Ana, assim o ticket está fechado. 
UPDATE Ticket SET fechamento = NOW() WHERE protocolo = 1;

-- Criar uma pessoa chamaada Gustavo Zechlinski. CPF 33344455567. E-mail gustavo.z@ufpel.edu.br.
INSERT INTO Pessoa (nome, cpf, email)
VALUES ('Gustavo Zechlinski', '33344455567', 'gustavo.z@ufpel.edu.br');

-- Adicionar números de telefone 214589 e 89580 à Gustavo.

INSERT INTO Telefone (numero, cpf_telefone)
VALUES ('214589', '33344455567'), ('89580', '33344455567');

-- Gustavo é um servidor, possui SIAPE 88907, unidade NSMI - Suporte. Login gustavo.zech. Senha: gustavao_do_suporte. cpf_servidor é chave estrageira de Pessoa(cpf) para gustavo.
INSERT INTO Servidor (siape, unidade, login, senha, cpf_servidor)
VALUES ('88907', 'NSMI - Suporte', 'gustavo.zech', 'gustavao_do_suporte', '33344455567');

-- Criar uma pessoa chamada Luciana Foss. Ela possui CPF 92833456098 e email lfoss@inf.ufpel.edu.br.
INSERT INTO Pessoa (nome, cpf, email)
VALUES ('Luciana Foss', '92833456098', 'lfoss@inf.ufpel.edu.br');

-- Adicione os números de telefone 898450 e 654505 para Luciana.
INSERT INTO Telefone (numero, cpf_telefone)
VALUES ('898450', '92833456098'), ('654505', '92833456098');

-- Luciana abre um ticket no endereço Sala 342 com título Cabo HDMI defeituoso. Protocolo 2. Abertura em timestamp e fechamento null. Patrimonio RP449789. cpf_ticket recupera Pessoa(cpf) para Luciana.
INSERT INTO Ticket (endereco, titulo, protocolo, abertura, patrimonio, cpf_ticket)
VALUES ('Sala 342', 'Cabo HDMI defeituoso', 2, NOW(), 'RP449789', '92833456098');

-- Como Luciana abriu um ticket, ela informa a descição do ticket de que "O cabo HDMI só funciona se eu colocar um palito de dente na ponta do cabo que fica plugado no projetor. Solicito reparo." Use o timestamp da criação. Autor referencia Pessoa(nome), no caso, a Luciana e o protocolo referencia o protocolo 2.
INSERT INTO Descricao (descricao, data, autor, protocolo)
VALUES ('O cabo HDMI só funciona se eu colocar um palito de dente na ponta do cabo que fica plugado no projetor. Solicito reparo.', NOW(), 'Luciana Foss', 2);

-- Luciana abre um ticket no endereço Sala 314 com título Lousa Frouxa. Protocolo 3. Abertura em timestamp e fechamento null. Patrimonio RP77665. cpf_ticket recupera Pessoa(cpf) para Luciana.
INSERT INTO Ticket (endereco, titulo, protocolo, abertura, patrimonio, cpf_ticket)
VALUES ('Sala 314', 'Lousa Frouxa', 3, NOW(), 'RP77665', '92833456098');

-- Como Luciana abriu um ticket, ela informa a descição do ticket de que "Canto superior direito da lousa está solto. Solicito reparo." Use o timestamp da criação. Autor referencia Pessoa(nome), no caso, a Luciana e o protocolo referencia o protocolo 2.
INSERT INTO Descricao (descricao, data, autor, protocolo)
VALUES ('Canto superior direito da lousa está solto. Solicito reparo.', NOW(), 'Luciana Foss', 3);

-- O servidor Gustavo insere uma descrição no ticket 3 informando "OS 44560 criada para o SACE" e o autor é o seu nome Pessoa(nome) Gustavo.
INSERT INTO Descricao (descricao, data, autor, protocolo)
VALUES ('OS 44560 criada para o SACE', NOW(), 'Gustavo Zechlinski', 3);

-- Como Gustavo acionou o SACE, ele "consertou" o ticket, então ele adiciona o timestamp de fechamento no ticket de protocolo 3.
UPDATE Ticket SET fechamento = NOW() WHERE protocolo = 3;

-- Criando 6 consultas no banco

-- Consulta 1 -- Verificando tickets abertos (selecionando todos os que possuem timestamp null).
SELECT * FROM Ticket WHERE fechamento IS NULL;

-- Consulta 2 -- Verificando tickets fechados (todos que possuem timestamp preenchido).
SELECT * FROM Ticket WHERE fechamento IS NOT NULL;

-- Consulta 3 -- Verificando todas as informações referentes ao ticket 1, ou seja, juntar tudo da tabela telefone, ticket, pessoa e descrição.
SELECT t.*, p.*, d.descricao, d.data as data_descricao, d.autor as autor_descricao, tel.numero as telefone
-- Seleciono todas as colunas de Ticket(t.*), todas as colunas de Pessoa (p.*).
-- Depois eu busco "from" Ticket
FROM Ticket t
-- Fazendo uma junção com todas todas as pessoas e todos os CPF.
JOIN Pessoa p ON t.cpf_ticket = p.cpf
-- E depois faço uma jução com as descrições DE FORMA (ON) que consigamos agrupar as informações de cada um (=).
JOIN Descricao d ON t.protocolo = d.protocolo
LEFT JOIN Telefone tel ON p.cpf = tel.cpf_telefone
-- O Left Join me garante que mesmo que a pessoa não tenha telefones eu consiga recuperar as informações dela botando telefones como null.
WHERE t.protocolo = 1;

-- Consulta 4 -- Verificando todas as informações referentes ao ticket 2, ou seja, juntar tudo da tabela telefone, ticket, pessoa e descrição.
-- A mesma lógica é usada aqui na consulta 4, 5 e 6.
SELECT t.*, p.*, d.descricao, d.data as data_descricao, d.autor as autor_descricao, tel.numero as telefone
FROM Ticket t
JOIN Pessoa p ON t.cpf_ticket = p.cpf
JOIN Descricao d ON t.protocolo = d.protocolo
LEFT JOIN Telefone tel ON p.cpf = tel.cpf_telefone
WHERE t.protocolo = 2;


-- Consulta 4 -- Listar todos os servidores e bolsistas e exibir suas informações pessoais e números de telefone.
(SELECT p.*, tel.numero as telefone, s.siape, s.unidade, s.login as login_servidor, s.senha as senha_servidor
FROM Pessoa p
JOIN Servidor s ON p.cpf = s.cpf_servidor
LEFT JOIN Telefone tel ON p.cpf = tel.cpf_telefone)
UNION
(SELECT p.*, tel.numero as telefone, b.matricula, b.curso, b.login as login_bolsista, b.senha as senha_bolsista
FROM Pessoa p
JOIN Bolsista b ON p.cpf = b.cpf_bolsista
LEFT JOIN Telefone tel ON p.cpf = tel.cpf_telefone);

-- Consulta 5 -- Listar todas as informações a respeito de todas as pessoas cadastradas no sistema de banco de dados.
SELECT p.*, tel.numero as telefone
FROM Pessoa p
LEFT JOIN Telefone tel ON p.cpf = tel.cpf_telefone;

-- Consulta 6 -- Liste todas as informações a respeito de todas as pessoas que possuam pelo menos dois tickets dentro do banco.
-- O replace garante que se já existe a visão, ela será atualizada!
CREATE OR REPLACE VIEW view_pessoas_com_2_tickets AS
SELECT p.*, COUNT(t.protocolo) as num_tickets
FROM Pessoa p
JOIN Ticket t ON p.cpf = t.cpf_ticket
GROUP BY p.cpf
HAVING COUNT(t.protocolo) >= 2;
SELECT * FROM view_pessoas_com_2_tickets;