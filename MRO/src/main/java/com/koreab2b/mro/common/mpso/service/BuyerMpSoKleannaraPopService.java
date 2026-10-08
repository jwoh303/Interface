package com.koreab2b.mro.common.mpso.service;

import java.util.Map;

public interface BuyerMpSoKleannaraPopService {
	// 조회
	public String  getKleannaraCostCode(Map<String,String>  formData);
	public String  getKleannaraAccountCode(Map<String,String>  formData);
}