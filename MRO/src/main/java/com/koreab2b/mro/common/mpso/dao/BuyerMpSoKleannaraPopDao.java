package com.koreab2b.mro.common.mpso.dao;

import java.util.Map;

public interface BuyerMpSoKleannaraPopDao {
	// 조회
	public String getKleannaraCostCode(Map<String,String>  formData);
	public String getKleannaraAccountCode(Map<String, String> formData);
}
