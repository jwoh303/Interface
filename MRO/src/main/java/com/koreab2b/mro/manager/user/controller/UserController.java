package com.koreab2b.mro.manager.user.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.manager.user.domain.User;
import com.koreab2b.mro.manager.user.service.UserService;

@Controller("userConrtroller")
public class UserController {

	@Autowired
	private UserService userService;
		
	@RequestMapping(value = "/user/getUsers.do", method = RequestMethod.GET)
	public String getUsers(HttpServletRequest request, @ModelAttribute("user") User pUser, ModelMap pModel) {
		pModel.addAttribute("users", userService.getUsers(pUser));
		return "manager/user/userList";
	}

	@RequestMapping(value = "/user/getUser.do", method = RequestMethod.GET)
	public String getUser(HttpServletRequest request, @RequestParam(value = "userId") String pUserId, ModelMap pModel) {
		pModel.addAttribute("user", userService.getUser(pUserId));
		return "manager/user/userForm";
	}

	@RequestMapping(value = "/user/saveUser.do", method = RequestMethod.POST)
	public String saveUser(HttpServletRequest request, @ModelAttribute("user") User pUser, ModelMap pModel) {
		userService.saveUser(pUser);
		return "redirect:/user/getUsers.do";
	}

	@RequestMapping(value = "/user/deleteUser.do", method = RequestMethod.GET)
	public String deleteUser(HttpServletRequest request, @RequestParam(value = "checkedId", required = false) String[] pUserIds, ModelMap pModel) {
		userService.deleteUser(pUserIds);
		return "redirect:/user/getUsers.do";
	}
}
