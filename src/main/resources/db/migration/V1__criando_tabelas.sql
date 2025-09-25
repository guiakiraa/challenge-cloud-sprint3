CREATE TABLE IF NOT EXISTS FUNCAO (
    id bigint AUTO_INCREMENT,
    nome enum('ADMIN', 'GERENTE'),
    primary key (id)
);

CREATE TABLE IF NOT EXISTS USUARIO (
    id bigint AUTO_INCREMENT,
    img_perfil varchar(255),
    nome_perfil varchar(255),
    senha varchar(255),
    username varchar(255),
    primary key (id)
);

CREATE TABLE IF NOT EXISTS USUARIO_FUNCAO_TAB(
    id_funcao bigint not null,
    id_usuario bigint not null,
    primary key (id_funcao, id_usuario),
    constraint FK_usuario_funcao_func foreign key (id_funcao) references FUNCAO(id),
    constraint FK_usuario_funcao_user foreign key (id_usuario) references USUARIO(id)
);

CREATE TABLE IF NOT EXISTS endereco (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    logradouro VARCHAR(255) NOT NULL,
    numero INT NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep CHAR(9) NOT NULL,
    complemento VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS filial (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    fk_endereco BIGINT NOT NULL,
    CONSTRAINT FK_filial_endereco FOREIGN KEY (fk_endereco) REFERENCES endereco(id)
);

CREATE TABLE IF NOT EXISTS moto (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(7) NOT NULL,
    ano INT NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    tipo_combustivel VARCHAR(50) NOT NULL,
    fk_filial BIGINT NOT NULL,
    CONSTRAINT FK_moto_filial FOREIGN KEY (fk_filial) REFERENCES filial(id)
);

CREATE TABLE IF NOT EXISTS funcionario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    fk_filial BIGINT NOT NULL,
    CONSTRAINT FK_funcionario_filial FOREIGN KEY (fk_filial) REFERENCES filial(id)
);

CREATE TABLE IF NOT EXISTS localizacao (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    pontox DOUBLE NOT NULL,
    pontoy DOUBLE NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    fonte VARCHAR(50) NOT NULL,
    fk_moto BIGINT NOT NULL,
    CONSTRAINT FK_localizacao_moto FOREIGN KEY (fk_moto) REFERENCES moto(id)
);


