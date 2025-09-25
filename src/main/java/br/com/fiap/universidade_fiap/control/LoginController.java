package br.com.fiap.universidade_fiap.control;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import br.com.fiap.universidade_fiap.model.Usuario;
import br.com.fiap.universidade_fiap.repository.UsuarioRepository;

@Controller
public class LoginController {
	
	@Autowired
	private UsuarioRepository usuarioRepository;
	
	@GetMapping("/login")
	public ModelAndView logar() {
		return new ModelAndView("/login");
	}
	
	@GetMapping("/acesso_negado")
	public ModelAndView retornarAcessoNegado() {
		return new ModelAndView("acesso_negado");
	}
	
	@GetMapping({"/", "/index"})
	public ModelAndView home() {
		ModelAndView mv = new ModelAndView("home/index");
		
		// Obter o usuário autenticado
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String username = authentication.getName();
		
		// Buscar o usuário completo no banco
		Usuario usuario = usuarioRepository.findByUsername(username).orElse(null);
		
		if (usuario != null) {
			mv.addObject("usuario", usuario);
		}
		
		return mv;
	}

}
