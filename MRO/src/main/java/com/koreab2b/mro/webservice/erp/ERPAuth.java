package com.koreab2b.mro.webservice.erp;

import java.net.Authenticator;
import java.net.PasswordAuthentication;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class ERPAuth {

	@Value("#{erpProps['pi.user.id']}")
	private String piUserId;

	@Value("#{erpProps['pi.user.pw']}")
	private String piUserPw;
	
	public String getPiUserId(){
		return this.piUserId;
	}

	@PostConstruct
	public void process() {
		Authenticator.setDefault(new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {				
				return new PasswordAuthentication(piUserId, piUserPw.toCharArray());
			}
		});
	}
}
