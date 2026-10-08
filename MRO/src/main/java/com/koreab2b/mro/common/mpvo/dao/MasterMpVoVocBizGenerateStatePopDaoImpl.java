package com.koreab2b.mro.common.mpvo.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.DateTimeUtil;

@Repository("masterMpVoVocBizGenerateStatePopDaoImpl")
@Transactional
public class MasterMpVoVocBizGenerateStatePopDaoImpl  implements MasterMpVoVocBizGenerateStatePopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> getMasterMpVoVocBizGenerateStatePop(Map<String,Object> formData) {
		
		String st_date_type = CommonUtil.nvl((String) formData.get("st_date_type"),"");
		String st_date_flag = CommonUtil.nvl((String) formData.get("st_date_flag"),"");
		String st_fromDate = CommonUtil.nvl((String) formData.get("st_fromDate"),"");
		String st_toDate = DateTimeUtil.getFormatString("yyyyMMdd");
		
		if(st_date_type.equals("WEEK")){
	    	try {
				st_fromDate    = DateTimeUtil.addDays(st_toDate, Integer.parseInt(st_date_flag));
			} catch (Exception e) {
				e.printStackTrace();
			}	
	    }else{
	    	try {
				st_fromDate    = DateTimeUtil.addMonths(st_toDate, Integer.parseInt(st_date_flag));
			} catch (Exception e) {
				e.printStackTrace();
			}
	    }
		
		formData.put("st_fromDate", st_fromDate);
		formData.put("st_toDate", st_toDate);
		
		return sqlSessionTemplate.selectList("common.mpvo.selectMasterMpVoVocBizGenerateStatePop", formData);
	}
	
	// 조회
	public List<Map<String,String>> getMasterMpVoVocBuyerGenerateStatePop(Map<String,Object> formData) {
		
		String st_date_type = CommonUtil.nvl((String) formData.get("st_date_type"),"");
		String st_date_flag = CommonUtil.nvl((String) formData.get("st_date_flag"),"");
		String st_fromDate = CommonUtil.nvl((String) formData.get("st_fromDate"),"");
		String st_toDate = DateTimeUtil.getFormatString("yyyyMMdd");
		
		if(st_date_type.equals("WEEK")){
			try {
				st_fromDate    = DateTimeUtil.addDays(st_toDate, Integer.parseInt(st_date_flag));
			} catch (Exception e) {
				e.printStackTrace();
			}	
		}else{
			try {
				st_fromDate    = DateTimeUtil.addMonths(st_toDate, Integer.parseInt(st_date_flag));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		formData.put("st_fromDate", st_fromDate);
		formData.put("st_toDate", st_toDate);
		
		return sqlSessionTemplate.selectList("common.mpvo.selectMasterMpVoVocBuyerGenerateStatePop", formData);
	}
	
	// 조회
	public List<Map<String,String>> getMasterMpVoVocAgntcmpyGenerateStatePop(Map<String,Object> formData) {
		
		String st_date_type = CommonUtil.nvl((String) formData.get("st_date_type"),"");
		String st_date_flag = CommonUtil.nvl((String) formData.get("st_date_flag"),"");
		String st_fromDate = CommonUtil.nvl((String) formData.get("st_fromDate"),"");
		String st_toDate = DateTimeUtil.getFormatString("yyyyMMdd");
		
		if(st_date_type.equals("WEEK")){
			try {
				st_fromDate    = DateTimeUtil.addDays(st_toDate, Integer.parseInt(st_date_flag));
			} catch (Exception e) {
				e.printStackTrace();
			}	
		}else{
			try {
				st_fromDate    = DateTimeUtil.addMonths(st_toDate, Integer.parseInt(st_date_flag));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		formData.put("st_fromDate", st_fromDate);
		formData.put("st_toDate", st_toDate);
		formData.put("arry_buyer_code", CommonUtil.StrToArray(CommonUtil.nvl((String) formData.get("st_buyer_code"), ""), "@"));
		
		return sqlSessionTemplate.selectList("common.mpvo.selectMasterMpVoVocAgntcmpyGenerateStatePop", formData);
	}
}
