package com.kep.taxbill.dao;

import java.util.Map;

public interface TaxAccountDao {

	public void mergeTaccountData(Map<String, Object> pMap) throws Exception;
	
	public void deleteMappingDataForTaccountCancel() throws Exception;
}
