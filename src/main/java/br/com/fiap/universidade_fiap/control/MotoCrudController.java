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

import br.com.fiap.universidade_fiap.model.Moto;
import br.com.fiap.universidade_fiap.repository.FilialRepository;
import br.com.fiap.universidade_fiap.repository.MotoRepository;

@Controller
@RequestMapping("/moto")
public class MotoCrudController {

    private final MotoRepository motoRepository;
    private final FilialRepository filialRepository;

    public MotoCrudController(MotoRepository motoRepository, FilialRepository filialRepository) {
        this.motoRepository = motoRepository;
        this.filialRepository = filialRepository;
    }

    @GetMapping("/novo")
    public String novo(Model model) {
        model.addAttribute("moto", new Moto());
        model.addAttribute("filiais", filialRepository.findAll());
        return "moto/form";
    }

    @PostMapping("/salvar")
    public String salvar(Moto moto, BindingResult result) {
        if (result.hasErrors()) {
            return "moto/form";
        }
        motoRepository.save(moto);
        return "redirect:/motos";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        try {
            model.addAttribute("moto", motoRepository.findById(id).orElseThrow());
            model.addAttribute("filiais", filialRepository.findAll());
            return "moto/form";
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("erro", "Registro de moto não encontrado.");
            return "redirect:/motos";
        }
    }

    @PostMapping("/atualizar/{id}")
    public String atualizar(@PathVariable Long id, Moto moto, BindingResult result) {
        if (result.hasErrors()) {
            return "moto/form";
        }
        moto.setId(id);
        motoRepository.save(moto);
        return "redirect:/motos";
    }

    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            motoRepository.deleteById(id);
        } catch (DataIntegrityViolationException ex) {
            redirectAttributes.addFlashAttribute("erro", "Não é possível remover a moto: ela está vinculada a outros registros.");
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("erro", "Falha ao remover a moto. Tente novamente mais tarde.");
        }
        return "redirect:/motos";
    }

    @GetMapping("/detalhes/{id}")
    public String detalhes(@PathVariable Long id, Model model) {
        model.addAttribute("moto", motoRepository.findById(id).orElseThrow());
        return "moto/detalhes";
    }
}


