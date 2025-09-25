package br.com.fiap.universidade_fiap.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import br.com.fiap.universidade_fiap.model.Localizacao;

public interface LocalizacaoRepository extends JpaRepository<Localizacao, Long> {
}


