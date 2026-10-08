package com.koreab2b.mro.manager.auth.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.manager.auth.domain.Auth;
import com.koreab2b.mro.manager.auth.service.AuthService;

@Controller("authController")
public class AuthController {
	
	@Autowired
	private AuthService authService;
		
	@RequestMapping(value = "/auth/getAuths.do", method = RequestMethod.GET)
	public String getAuths(HttpServletRequest request, @ModelAttribute("auth") Auth pAuth, ModelMap pModel) {
		pModel.addAttribute("auths", authService.getAuths(pAuth));
		return "manager/auth/authList";
	}

	@RequestMapping(value = "/auth/getAuth.do", method = RequestMethod.GET)
	public String getAuth(HttpServletRequest request, @RequestParam(value = "authId") String pAuthId, ModelMap pModel) {
		pModel.addAttribute("auth", authService.getAuth(pAuthId));
		return "manager/auth/authForm";
	}

	@RequestMapping(value = "/auth/saveAuth.do", method = RequestMethod.POST)
	public String saveUser(HttpServletRequest request, @ModelAttribute("auth") Auth pAuth, ModelMap pModel) {
		authService.saveAuth(pAuth);
		return "redirect:/auth/getAuths.do";
	}

	@RequestMapping(value = "/auth/deleteAuth.do", method = RequestMethod.GET)
	public String deleteUser(HttpServletRequest request, @RequestParam(value = "checkedId", required = false) String[] pAuthIds, ModelMap pModel) {
		authService.deleteAuth(pAuthIds);
		return "redirect:/auth/getAuths.do";
	}
}
