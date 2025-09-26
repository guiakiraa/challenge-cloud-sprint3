package br.com.fiap.universidade_fiap.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;

@Configuration
public class SegurancaConfig {
	
	@Bean
	public SecurityFilterChain chain(HttpSecurity http) throws Exception {
		
		http.authorizeHttpRequests( (request) -> request.requestMatchers("/usuario/novo").hasAuthority("ADMIN")
				.anyRequest().authenticated() )
		.formLogin( (login) -> login.loginPage("/login")
				.successHandler(authenticationSuccessHandler())
				.failureUrl("/login?falha=true").permitAll())
		.logout((logout) -> logout.logoutUrl("/logout")
				.logoutSuccessUrl("/login?logout=true").permitAll()  )
		.exceptionHandling((exception) -> 
		exception.accessDeniedHandler((request, response, AccessDeniedException) 
		-> {response.sendRedirect("/acesso_negado");}) )
		.csrf(csrf -> csrf.disable()); // Desabilitar CSRF para Azure App Service
		
		return http.build();
		
	}
	
	@Bean
	public AuthenticationSuccessHandler authenticationSuccessHandler() {
		SimpleUrlAuthenticationSuccessHandler handler = new SimpleUrlAuthenticationSuccessHandler();
		handler.setDefaultTargetUrl("/index");
		handler.setAlwaysUseDefaultTargetUrl(true);
		return handler;
	}

	@Bean
	public PasswordEncoder encoder() {
		return new BCryptPasswordEncoder();
	}

}
