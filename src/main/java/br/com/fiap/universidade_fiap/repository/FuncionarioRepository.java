package br.com.fiap.universidade_fiap.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import br.com.fiap.universidade_fiap.model.Funcionario;

public interface FuncionarioRepository extends JpaRepository<Funcionario, Long> {
}


