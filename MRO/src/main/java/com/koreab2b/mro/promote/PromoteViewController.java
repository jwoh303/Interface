package com.koreab2b.mro.promote;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("promoteViewController")
public class PromoteViewController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PromoteViewController.class);


	@RequestMapping(value = "/promoteDetailMain.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String promoteDetailMain() {
		return "promote/promoteDetailMain";
	}
	
	@RequestMapping(value = "/promote/promoteFooter.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String promoteFooter() {
		return "promote/include/promoteFooter";
	}
	
	@RequestMapping(value = "/promote/search_detail.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String search_detail() {
		return "promote/search_detail";
	}
		
}
