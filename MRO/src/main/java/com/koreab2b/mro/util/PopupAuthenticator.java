package com.koreab2b.mro.util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class PopupAuthenticator extends Authenticator{
  
	PasswordAuthentication pa;

	public PopupAuthenticator(String paramString1, String paramString2){
		this.pa = new PasswordAuthentication(paramString1, paramString2);
	}

	public PasswordAuthentication getPasswordAuthentication(){
		return this.pa;
	}
}
