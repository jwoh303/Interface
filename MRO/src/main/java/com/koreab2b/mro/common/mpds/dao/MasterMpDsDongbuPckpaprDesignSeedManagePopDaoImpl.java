package com.koreab2b.mro.common.mpds.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmBudgetDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpDsDongbuPckpaprDesignSeedManagePopDao")
@Transactional
public class MasterMpDsDongbuPckpaprDesignSeedManagePopDaoImpl implements MasterMpDsDongbuPckpaprDesignSeedManagePopDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmBudgetDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
    int mm = 0; //마케팅 완료
    int dd = 0; //문안 완료
    int ee = 0; //디자인 완료
    int es = 0; //최종 확정

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpds.selectMasterMpDsDongbuPckpaprDesignSeedManagePopList", formData);
	}

	

	//저장MM
	public String updateRegMM(Map<String, String> formData) {
		
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
		
	try{
			sqlSessionTemplate.update("common.mpds.setBuyerDongBuJongjaOrderPackingSaveUpdate", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	//저장
	public String updateReg(Map<String, String> formData) {
		
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
		
	try{
		    
	        mm = 0;    //마케팅 완료  2일
	        dd = mm+8; //문안 완료    2일
	        ee = mm+5; //디자인 완료  3일
	        es = mm+10; //최종 확정    2일 

	       formData.put("st_mm_date", String.valueOf(mm));
	       formData.put("st_dd_date", String.valueOf(dd));
	       formData.put("st_ee_date", String.valueOf(ee));
	       formData.put("st_es_date", String.valueOf(es));

		       
			sqlSessionTemplate.update("common.mpds.setSysopDongBuJongjaOrderPackingSaveUpdate", formData);
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	
	//종결
	public String updateReg01(Map<String, String> formData) {
		
		String _rtnMsg = "정상적으로 수정이 이루어 졌습니다.";
		
		try{
			String gubun_flag = formData.get("st_gubun_flag");
			
		       if(gubun_flag.equals("NW")) { //신규
	                mm = 2;    //마케팅 완료  2일
	                dd = mm+4; //문안 완료    4일
	                ee = dd+5; //디자인 완료  5일
	                es = ee+2; //최종 확정    2일
	       }else {
	                mm = 2;    //마케팅 완료  2일
	                dd = mm+2; //문안 완료    2일
	                ee = dd+3; //디자인 완료  3일
	                es = ee+2; //최종 확정    2일
	       }
	       formData.put("st_mm_date", String.valueOf(mm));
	       formData.put("st_dd_date", String.valueOf(dd));
	       formData.put("st_ee_date", String.valueOf(ee));
	       formData.put("st_es_date", String.valueOf(es));
		       
			sqlSessionTemplate.update("common.mpds.setSysopDongBuJongjaOrderPackingSaveUpdate01", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("수정이 실패하였습니다. 다시 확인하여 주십시요.");
		}
		return _rtnMsg;
	}
	
}
