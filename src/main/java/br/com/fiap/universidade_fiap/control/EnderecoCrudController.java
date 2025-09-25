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

import br.com.fiap.universidade_fiap.model.Endereco;
import br.com.fiap.universidade_fiap.repository.EnderecoRepository;

@Controller
@RequestMapping("/endereco")
public class EnderecoCrudController {

    private final EnderecoRepository enderecoRepository;

    public EnderecoCrudController(EnderecoRepository enderecoRepository) {
        this.enderecoRepository = enderecoRepository;
    }

    @GetMapping("/novo")
    public String novo(Model model) {
        model.addAttribute("endereco", new Endereco());
        return "endereco/form";
    }

    @PostMapping("/salvar")
    public String salvar(Endereco endereco, BindingResult result) {
        if (result.hasErrors()) {
            return "endereco/form";
        }
        enderecoRepository.save(endereco);
        return "redirect:/enderecos";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        model.addAttribute("endereco", enderecoRepository.findById(id).orElseThrow());
        return "endereco/form";
    }

    @PostMapping("/atualizar/{id}")
    public String atualizar(@PathVariable Long id, Endereco endereco, BindingResult result) {
        if (result.hasErrors()) {
            return "endereco/form";
        }
        endereco.setId(id);
        enderecoRepository.save(endereco);
        return "redirect:/enderecos";
    }

    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            enderecoRepository.deleteById(id);
        } catch (DataIntegrityViolationException ex) {
            redirectAttributes.addFlashAttribute("erro", "Não é possível remover o endereço: ele está vinculado a outros registros.");
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("erro", "Falha ao remover o endereço. Tente novamente mais tarde.");
        }
        return "redirect:/enderecos";
    }

    @GetMapping("/detalhes/{id}")
    public String detalhes(@PathVariable Long id, Model model) {
        model.addAttribute("endereco", enderecoRepository.findById(id).orElseThrow());
        return "endereco/detalhes";
    }
}


