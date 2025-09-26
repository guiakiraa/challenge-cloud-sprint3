$RG = "rg-tria"
$LOCATION = "brazilsouth"
$SERVER_NAME = "sqlserver-tria"
$USERNAME = "admsql"
$PASSWORD = "Fiap@2tdsvms"
$DBNAME = "mottudb"

az group create --name $RG --location $LOCATION
az sql server create -l $LOCATION -g $RG -n $SERVER_NAME -u $USERNAME -p $PASSWORD --enable-public-network true
az sql db create -g $RG -s $SERVER_NAME -n $DBNAME --service-objective Basic --backup-storage-redundancy Local --zone-redundant false
az sql server firewall-rule create -g $RG -s $SERVER_NAME -n AllowAll --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255

# Cria os objetos de Banco
# Certifique-se de ter o sqlcmd instalado em seu ambiente
Invoke-Sqlcmd -ServerInstance "$SERVER_NAME.database.windows.net" `
              -Database "$DBNAME" `
              -Username "$USERNAME" `
              -Password "$PASSWORD" `
              -Query @"
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='funcao' AND xtype='U')
BEGIN
    CREATE TABLE funcao (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        nome VARCHAR(255) NOT NULL
        -- Opcional: CHECK Constraint limitando valores ('ADMIN','GERENTE')
    );
END;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='usuario' AND xtype='U')
BEGIN
    CREATE TABLE usuario (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        img_perfil VARCHAR(255) NULL,
        nome_perfil VARCHAR(255) NULL,
        senha VARCHAR(255) NULL,
        username VARCHAR(255) NULL
    );
END;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='usuario_funcao_tab' AND xtype='U')
BEGIN
    CREATE TABLE usuario_funcao_tab (
        id_funcao BIGINT NOT NULL,
        id_usuario BIGINT NOT NULL,
        CONSTRAINT PK_usuario_funcao_tab PRIMARY KEY (id_funcao, id_usuario),
        CONSTRAINT FK_usuario_funcao_func FOREIGN KEY (id_funcao) REFERENCES funcao(id),
        CONSTRAINT FK_usuario_funcao_user FOREIGN KEY (id_usuario) REFERENCES usuario(id)
    );
END;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='endereco' AND xtype='U')
BEGIN
    CREATE TABLE endereco (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        logradouro VARCHAR(255) NOT NULL,
        numero INT NOT NULL,
        bairro VARCHAR(100) NOT NULL,
        cidade VARCHAR(100) NOT NULL,
        estado CHAR(2) NOT NULL,
        cep CHAR(9) NOT NULL,
        complemento VARCHAR(255)
    );
END;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='filial' AND xtype='U')
BEGIN
    CREATE TABLE filial (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        fk_endereco BIGINT NOT NULL,
        CONSTRAINT FK_filial_endereco FOREIGN KEY (fk_endereco) REFERENCES endereco(id)
    );
END;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='moto' AND xtype='U')
BEGIN
    CREATE TABLE moto (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        placa VARCHAR(7) NOT NULL,
        ano INT NOT NULL,
        modelo VARCHAR(50) NOT NULL,
        tipo_combustivel VARCHAR(50) NOT NULL,
        fk_filial BIGINT NOT NULL,
        CONSTRAINT FK_moto_filial FOREIGN KEY (fk_filial) REFERENCES filial(id)
    );
END;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='funcionario' AND xtype='U')
BEGIN
    CREATE TABLE funcionario (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        nome VARCHAR(150) NOT NULL,
        fk_filial BIGINT NOT NULL,
        CONSTRAINT FK_funcionario_filial FOREIGN KEY (fk_filial) REFERENCES filial(id)
    );
END;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='localizacao' AND xtype='U')
BEGIN
    CREATE TABLE localizacao (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        pontox FLOAT NOT NULL,
        pontoy FLOAT NOT NULL,
        data_hora DATETIME2 NOT NULL,
        fonte VARCHAR(50) NOT NULL,
        fk_moto BIGINT NOT NULL,
        CONSTRAINT FK_localizacao_moto FOREIGN KEY (fk_moto) REFERENCES moto(id)
    );
END;


-- Carga inicial de segurança
IF NOT EXISTS (SELECT 1 FROM funcao)
BEGIN
    INSERT INTO funcao (nome) VALUES ('ADMIN');
    INSERT INTO funcao (nome) VALUES ('GERENTE');
END;

IF NOT EXISTS (SELECT 1 FROM usuario WHERE username = 'admin')
BEGIN
    INSERT INTO usuario (username, senha, img_perfil, nome_perfil)
    VALUES ('admin', '$2a$12$h227p1QzQEB2cIW/BrzZletfr20O0lNDBMYZM0K6z5faY6bJ17kpO', 'https://cloudfront-us-east-1.images.arcpublishing.com/estadao/IP73LLAR65PJBBPHQQL4NMBNGY.jpg', 'Admin Mottu');
END;

IF NOT EXISTS (
    SELECT 1 FROM usuario_funcao_tab uft
    JOIN usuario u ON uft.id_usuario = u.id
    JOIN funcao f ON uft.id_funcao = f.id
    WHERE u.username = 'admin' AND f.nome = 'ADMIN'
)
BEGIN
    INSERT INTO usuario_funcao_tab (id_usuario, id_funcao)
    SELECT u.id, f.id FROM usuario u CROSS JOIN funcao f
    WHERE u.username = 'admin' AND f.nome = 'ADMIN';
END;

INSERT INTO ENDERECO (NUMERO, CEP, BAIRRO, CIDADE, ESTADO, COMPLEMENTO, LOGRADOURO) VALUES ('101', '01001-000', 'Sé', 'São Paulo', 'SP', 'Edifício Central', 'Praça da Sé');
INSERT INTO ENDERECO (NUMERO, CEP, BAIRRO, CIDADE, ESTADO, COMPLEMENTO, LOGRADOURO) VALUES ('789', '20040-030', 'Centro', 'Rio de Janeiro', 'RJ', NULL, 'Av. Rio Branco');
INSERT INTO ENDERECO (NUMERO, CEP, BAIRRO, CIDADE, ESTADO, COMPLEMENTO, LOGRADOURO) VALUES ('321', '30130-005', 'Savassi', 'Belo Horizonte', 'MG', 'Loja 5', 'Rua Antônio de Albuquerque');
INSERT INTO ENDERECO (NUMERO, CEP, BAIRRO, CIDADE, ESTADO, COMPLEMENTO, LOGRADOURO) VALUES ('654', '90010-150', 'Centro Histórico', 'Porto Alegre', 'RS', 'Conjunto 2B', 'Rua da Praia');
INSERT INTO ENDERECO (NUMERO, CEP, BAIRRO, CIDADE, ESTADO, COMPLEMENTO, LOGRADOURO) VALUES ('987', '71000-000', 'Asa Sul', 'Brasília', 'DF', 'Bloco D', 'SQS 105');
INSERT INTO ENDERECO (NUMERO, CEP, BAIRRO, CIDADE, ESTADO, COMPLEMENTO, LOGRADOURO) VALUES ('1234', '80020-300', 'Centro', 'Curitiba', 'PR', 'Sala 10', 'Rua XV de Novembro');
INSERT INTO ENDERECO (NUMERO, CEP, BAIRRO, CIDADE, ESTADO, COMPLEMENTO, LOGRADOURO) VALUES ('567', '40020-000', 'Comércio', 'Salvador', 'BA', NULL, 'Av. Contorno');
INSERT INTO ENDERECO (NUMERO, CEP, BAIRRO, CIDADE, ESTADO, COMPLEMENTO, LOGRADOURO) VALUES ('890', '60115-170', 'Meireles', 'Fortaleza', 'CE', 'Andar 3', 'Av. Beira Mar');
INSERT INTO ENDERECO (NUMERO, CEP, BAIRRO, CIDADE, ESTADO, COMPLEMENTO, LOGRADOURO) VALUES ('112', '50010-240', 'Santo Antônio', 'Recife', 'PE', 'Sala 401', 'Rua do Sol');
INSERT INTO ENDERECO (NUMERO, CEP, BAIRRO, CIDADE, ESTADO, COMPLEMENTO, LOGRADOURO) VALUES ('335', '13013-010', 'Centro', 'Campinas', 'SP', 'Fundos', 'Rua Treze de Maio');

INSERT INTO FILIAL (FK_ENDERECO, NOME) VALUES (1, 'Filial Sé');
INSERT INTO FILIAL (FK_ENDERECO, NOME) VALUES (2, 'Filial Centro RJ');
INSERT INTO FILIAL (FK_ENDERECO, NOME) VALUES (3, 'Filial Savassi');
INSERT INTO FILIAL (FK_ENDERECO, NOME) VALUES (4, 'Filial Porto Alegre');
INSERT INTO FILIAL (FK_ENDERECO, NOME) VALUES (5, 'Filial Brasília Sul');
INSERT INTO FILIAL (FK_ENDERECO, NOME) VALUES (6, 'Filial Curitiba Centro');
INSERT INTO FILIAL (FK_ENDERECO, NOME) VALUES (7, 'Filial Salvador Comércio');
INSERT INTO FILIAL (FK_ENDERECO, NOME) VALUES (8, 'Filial Fortaleza Beira Mar');
INSERT INTO FILIAL (FK_ENDERECO, NOME) VALUES (9, 'Filial Recife Antigo');
INSERT INTO FILIAL (FK_ENDERECO, NOME) VALUES (10, 'Filial Campinas Centro');

INSERT INTO FUNCIONARIO (FK_FILIAL, NOME) VALUES (1, 'Ana Souza');
INSERT INTO FUNCIONARIO (FK_FILIAL, NOME) VALUES (1, 'Bruno Costa');
INSERT INTO FUNCIONARIO (FK_FILIAL, NOME) VALUES (2, 'Carla Lima');
INSERT INTO FUNCIONARIO (FK_FILIAL, NOME) VALUES (3, 'Daniel Pereira');
INSERT INTO FUNCIONARIO (FK_FILIAL, NOME) VALUES (4, 'Eduarda Santos');
INSERT INTO FUNCIONARIO (FK_FILIAL, NOME) VALUES (5, 'Fernando Rodrigues');
INSERT INTO FUNCIONARIO (FK_FILIAL, NOME) VALUES (6, 'Gabriela Fernandes');
INSERT INTO FUNCIONARIO (FK_FILIAL, NOME) VALUES (7, 'Hugo Almeida');
INSERT INTO FUNCIONARIO (FK_FILIAL, NOME) VALUES (8, 'Isabela Gomes');
INSERT INTO FUNCIONARIO (FK_FILIAL, NOME) VALUES (9, 'Julio Martins');

INSERT INTO MOTO (ANO, FK_FILIAL, PLACA, MODELO, TIPO_COMBUSTIVEL) VALUES (2024, 1, 'GHI4J56', 'MOTTU_SPORT', 'Gasolina');
INSERT INTO MOTO (ANO, FK_FILIAL, PLACA, MODELO, TIPO_COMBUSTIVEL) VALUES (2023, 1, 'KLM7N89', 'MOTTU_POP', 'Eletrico');
INSERT INTO MOTO (ANO, FK_FILIAL, PLACA, MODELO, TIPO_COMBUSTIVEL) VALUES (2022, 2, 'OPQ1R23', 'MOTTU_E', 'Gasolina');
INSERT INTO MOTO (ANO, FK_FILIAL, PLACA, MODELO, TIPO_COMBUSTIVEL) VALUES (2024, 3, 'STU4V56', 'MOTTU_SPORT', 'Gasolina');
INSERT INTO MOTO (ANO, FK_FILIAL, PLACA, MODELO, TIPO_COMBUSTIVEL) VALUES (2023, 4, 'WXY7Z89', 'MOTTU_POP', 'Eletrico');
INSERT INTO MOTO (ANO, FK_FILIAL, PLACA, MODELO, TIPO_COMBUSTIVEL) VALUES (2021, 5, 'BCD1E23', 'MOTTU_E', 'Gasolina');
INSERT INTO MOTO (ANO, FK_FILIAL, PLACA, MODELO, TIPO_COMBUSTIVEL) VALUES (2024, 6, 'FGH4I56', 'MOTTU_SPORT', 'Gasolina');
INSERT INTO MOTO (ANO, FK_FILIAL, PLACA, MODELO, TIPO_COMBUSTIVEL) VALUES (2022, 7, 'JKL7M89', 'MOTTU_POP', 'Eletrico');
INSERT INTO MOTO (ANO, FK_FILIAL, PLACA, MODELO, TIPO_COMBUSTIVEL) VALUES (2023, 8, 'NÃO0P12', 'MOTTU_E', 'Gasolina');
INSERT INTO MOTO (ANO, FK_FILIAL, PLACA, MODELO, TIPO_COMBUSTIVEL) VALUES (2024, 9, 'QRS3T45', 'MOTTU_SPORT', 'Gasolina');

INSERT INTO LOCALIZACAO (PONTOX, PONTOY, DATA_HORA, FK_MOTO, FONTE) VALUES (-46.633309, -23.550520, '2025-05-19 09:00:00', 1, 'GPS');
INSERT INTO LOCALIZACAO (PONTOX, PONTOY, DATA_HORA, FK_MOTO, FONTE) VALUES (-46.640000, -23.560000, '2025-05-19 09:05:00', 1, 'GPS');
INSERT INTO LOCALIZACAO (PONTOX, PONTOY, DATA_HORA, FK_MOTO, FONTE) VALUES (-43.172897, -22.906847, '2025-05-19 09:10:00', 3, 'Visao_Computacional');
INSERT INTO LOCALIZACAO (PONTOX, PONTOY, DATA_HORA, FK_MOTO, FONTE) VALUES (-43.180000, -22.910000, '2025-05-19 09:15:00', 3, 'Sensor');
INSERT INTO LOCALIZACAO (PONTOX, PONTOY, DATA_HORA, FK_MOTO, FONTE) VALUES (-47.882432, -15.794229, '2025-05-19 09:20:00', 5, 'GPS');
INSERT INTO LOCALIZACAO (PONTOX, PONTOY, DATA_HORA, FK_MOTO, FONTE) VALUES (-47.890000, -15.800000, '2025-05-19 09:25:00', 5, 'Visao_Computacional');
INSERT INTO LOCALIZACAO (PONTOX, PONTOY, DATA_HORA, FK_MOTO, FONTE) VALUES (-51.220000, -30.030000, '2025-05-19 09:30:00', 4, 'Sensor');
INSERT INTO LOCALIZACAO (PONTOX, PONTOY, DATA_HORA, FK_MOTO, FONTE) VALUES (-51.230000, -30.040000, '2025-05-19 09:35:00', 4, 'GPS');
INSERT INTO LOCALIZACAO (PONTOX, PONTOY, DATA_HORA, FK_MOTO, FONTE) VALUES (-38.520000, -3.730000, '2025-05-19 09:40:00', 8, 'Visao_Computacional');
INSERT INTO LOCALIZACAO (PONTOX, PONTOY, DATA_HORA, FK_MOTO, FONTE) VALUES (-38.530000, -3.740000, '2025-05-19 09:45:00', 8, 'Sensor');
"@