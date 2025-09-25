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

import br.com.fiap.universidade_fiap.model.Localizacao;
import br.com.fiap.universidade_fiap.repository.LocalizacaoRepository;
import br.com.fiap.universidade_fiap.repository.MotoRepository;

@Controller
@RequestMapping("/localizacao")
public class LocalizacaoCrudController {

    private final LocalizacaoRepository localizacaoRepository;
    private final MotoRepository motoRepository;

    public LocalizacaoCrudController(LocalizacaoRepository localizacaoRepository, MotoRepository motoRepository) {
        this.localizacaoRepository = localizacaoRepository;
        this.motoRepository = motoRepository;
    }

    @GetMapping("/novo")
    public String novo(Model model) {
        model.addAttribute("localizacao", new Localizacao());
        model.addAttribute("motos", motoRepository.findAll());
        return "localizacao/form";
    }

    @PostMapping("/salvar")
    public String salvar(Localizacao localizacao, BindingResult result) {
        if (result.hasErrors()) {
            return "localizacao/form";
        }
        localizacaoRepository.save(localizacao);
        return "redirect:/localizacoes";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        try {
            model.addAttribute("localizacao", localizacaoRepository.findById(id).orElseThrow());
            model.addAttribute("motos", motoRepository.findAll());
            return "localizacao/form";
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("erro", "Registro de localização não encontrado.");
            return "redirect:/localizacoes";
        }
    }

    @PostMapping("/atualizar/{id}")
    public String atualizar(@PathVariable Long id, Localizacao localizacao, BindingResult result) {
        if (result.hasErrors()) {
            return "localizacao/form";
        }
        localizacao.setId(id);
        localizacaoRepository.save(localizacao);
        return "redirect:/localizacoes";
    }

    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            localizacaoRepository.deleteById(id);
        } catch (DataIntegrityViolationException ex) {
            redirectAttributes.addFlashAttribute("erro", "Não é possível remover a localização: ela está vinculada a outros registros.");
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("erro", "Falha ao remover a localização. Tente novamente mais tarde.");
        }
        return "redirect:/localizacoes";
    }

    @GetMapping("/detalhes/{id}")
    public String detalhes(@PathVariable Long id, Model model) {
        model.addAttribute("localizacao", localizacaoRepository.findById(id).orElseThrow());
        return "localizacao/detalhes";
    }
}


