package br.com.fiap.universidade_fiap.control;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import br.com.fiap.universidade_fiap.repository.FilialRepository;

@Controller
@RequestMapping("/filiais")
public class FilialController {

    private final FilialRepository filialRepository;

    public FilialController(FilialRepository filialRepository) {
        this.filialRepository = filialRepository;
    }

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("filiais", filialRepository.findAll());
        return "filial/lista";
    }
}


