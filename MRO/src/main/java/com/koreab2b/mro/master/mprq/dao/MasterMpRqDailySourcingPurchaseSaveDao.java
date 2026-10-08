package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqDailySourcingPurchaseSaveDao {

	public Map<String,String> initQuotation(Map<String,String> formData, List<Object> gridData);

	public String updateEndTime(Map<String,String> formData, List<Object> gridData);

	public String updateMsdsReq(Map<String,String> formData, List<Object> gridData);

	public String updateItemChgReq(Map<String,String> formData, List<Object> gridData);

	public String updateDbCleansingCopy(Map<String,String> formData, List<Object> gridData);

}
