package br.com.fiap.universidade_fiap.control;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import br.com.fiap.universidade_fiap.repository.LocalizacaoRepository;

@Controller
@RequestMapping("/localizacoes")
public class LocalizacaoController {

    private final LocalizacaoRepository localizacaoRepository;

    public LocalizacaoController(LocalizacaoRepository localizacaoRepository) {
        this.localizacaoRepository = localizacaoRepository;
    }

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("localizacoes", localizacaoRepository.findAll());
        return "localizacao/lista";
    }
}


