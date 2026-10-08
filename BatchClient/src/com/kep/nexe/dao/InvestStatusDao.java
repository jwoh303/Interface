package com.kep.nexe.dao;

import java.util.Map;

public interface InvestStatusDao {

	public void insertNexeInvestBudget(Map<String, Object> iMap) throws Exception;

	public void insertNexeInvestAsset(Map<String, Object> jMap) throws Exception;

}
