package com.kep.mail.service;

public interface SendMailService {

	public void execute();
	
	public void executeCretecItemChange();
	
	/**
	 * 코웨이 폐기발주 내역 전송
	 * 주 1회
	 * 발송 대상 : 박경혁, 홍성은, 공급사 담당()
	 */
	public void executeCowayScrapMail(String FROM_DT, String TO_DT);
}