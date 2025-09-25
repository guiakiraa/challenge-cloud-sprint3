package br.com.fiap.universidade_fiap.model;

import java.time.LocalDateTime;
import org.springframework.format.annotation.DateTimeFormat;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "localizacao")
public class Localizacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "pontox", nullable = false)
    private Double pontoX;

    @Column(name = "pontoy", nullable = false)
    private Double pontoY;

    @Column(name = "data_hora", nullable = false)
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime dataHora;

    @Column(nullable = false, length = 50)
    private String fonte;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_moto", nullable = false)
    private Moto moto;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Double getPontoX() {
        return pontoX;
    }

    public void setPontoX(Double pontoX) {
        this.pontoX = pontoX;
    }

    public Double getPontoY() {
        return pontoY;
    }

    public void setPontoY(Double pontoY) {
        this.pontoY = pontoY;
    }

    public LocalDateTime getDataHora() {
        return dataHora;
    }

    public void setDataHora(LocalDateTime dataHora) {
        this.dataHora = dataHora;
    }

    public String getFonte() {
        return fonte;
    }

    public void setFonte(String fonte) {
        this.fonte = fonte;
    }

    public Moto getMoto() {
        return moto;
    }

    public void setMoto(Moto moto) {
        this.moto = moto;
    }
}


