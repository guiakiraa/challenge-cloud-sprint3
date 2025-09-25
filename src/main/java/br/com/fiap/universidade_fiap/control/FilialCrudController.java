package br.com.fiap.universidade_fiap.control;

import org.springframework.stereotype.Controller;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import br.com.fiap.universidade_fiap.model.Filial;
import br.com.fiap.universidade_fiap.repository.EnderecoRepository;
import br.com.fiap.universidade_fiap.repository.FilialRepository;

@Controller
@RequestMapping("/filial")
public class FilialCrudController {

    private final FilialRepository filialRepository;
    private final EnderecoRepository enderecoRepository;

    public FilialCrudController(FilialRepository filialRepository, EnderecoRepository enderecoRepository) {
        this.filialRepository = filialRepository;
        this.enderecoRepository = enderecoRepository;
    }

    @GetMapping("/novo")
    public String novo(Model model) {
        model.addAttribute("filial", new Filial());
        model.addAttribute("enderecos", enderecoRepository.findAll());
        return "filial/form";
    }

    @PostMapping("/salvar")
    public String salvar(Filial filial, BindingResult result) {
        if (result.hasErrors()) {
            return "filial/form";
        }
        filialRepository.save(filial);
        return "redirect:/filiais";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        try {
            model.addAttribute("filial", filialRepository.findById(id).orElseThrow());
            model.addAttribute("enderecos", enderecoRepository.findAll());
            return "filial/form";
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("erro", "Registro de filial não encontrado.");
            return "redirect:/filiais";
        }
    }

    @PostMapping("/atualizar/{id}")
    public String atualizar(@PathVariable Long id, Filial filial, BindingResult result) {
        if (result.hasErrors()) {
            return "filial/form";
        }
        filial.setId(id);
        filialRepository.save(filial);
        return "redirect:/filiais";
    }

    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            filialRepository.deleteById(id);
        } catch (DataIntegrityViolationException ex) {
            redirectAttributes.addFlashAttribute("erro", "Não é possível remover a filial: ela está vinculada a outros registros.");
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("erro", "Falha ao remover a filial. Tente novamente mais tarde.");
        }
        return "redirect:/filiais";
    }

    @GetMapping("/detalhes/{id}")
    public String detalhes(@PathVariable Long id, Model model) {
        model.addAttribute("filial", filialRepository.findById(id).orElseThrow());
        return "filial/detalhes";
    }
}


