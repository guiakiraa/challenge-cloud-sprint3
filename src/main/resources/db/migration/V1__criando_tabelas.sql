-- V1__create_tables.sql

CREATE TABLE FUNCAO (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(20) CHECK (nome IN ('ADMIN', 'GERENTE'))
);
GO

CREATE TABLE USUARIO (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    img_perfil VARCHAR(255),
    nome_perfil VARCHAR(255),
    senha VARCHAR(255),
    username VARCHAR(255)
);
GO

CREATE TABLE USUARIO_FUNCAO_TAB(
    id_funcao BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    PRIMARY KEY (id_funcao, id_usuario),
    CONSTRAINT FK_usuario_funcao_func FOREIGN KEY (id_funcao) REFERENCES FUNCAO(id),
    CONSTRAINT FK_usuario_funcao_user FOREIGN KEY (id_usuario) REFERENCES USUARIO(id)
);
GO

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
GO

CREATE TABLE filial (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    fk_endereco BIGINT NOT NULL,
    CONSTRAINT FK_filial_endereco FOREIGN KEY (fk_endereco) REFERENCES endereco(id)
);
GO

CREATE TABLE moto (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    placa VARCHAR(7) NOT NULL,
    ano INT NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    tipo_combustivel VARCHAR(50) NOT NULL,
    fk_filial BIGINT NOT NULL,
    CONSTRAINT FK_moto_filial FOREIGN KEY (fk_filial) REFERENCES filial(id)
);
GO

CREATE TABLE funcionario (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    fk_filial BIGINT NOT NULL,
    CONSTRAINT FK_funcionario_filial FOREIGN KEY (fk_filial) REFERENCES filial(id)
);
GO

CREATE TABLE localizacao (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    pontox FLOAT NOT NULL,
    pontoy FLOAT NOT NULL,
    data_hora DATETIME2 NOT NULL,
    fonte VARCHAR(50) NOT NULL,
    fk_moto BIGINT NOT NULL,
    CONSTRAINT FK_localizacao_moto FOREIGN KEY (fk_moto) REFERENCES moto(id)
);
GO
