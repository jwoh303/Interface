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

import com.koreab2b.mro.master.mprq.dao.MasterMpRqReqNegoReceiptDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpDsPckpaprDesignManageSeedRegPopDao")
@Transactional
public class MasterMpDsPckpaprDesignManageSeedRegPopDaoImpl implements MasterMpDsPckpaprDesignManageSeedRegPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpRqReqNegoReceiptDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpds.selectMasterMpDsPckpaprDesignManageSeedRegPopList", formData);
	}
	
	/*등록*/
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		 _rtnMsg = "선택한 품목을 등록 했습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				String plant = "";
				int mm = 0;
				int dd = 0;
				int ee = 0;
				int es = 0;
				
				if(formData.get("st_gubun_flag").equals("NW")) { //신규
					mm = 0;    //마케팅 완료  2일
					dd = mm+8; //문안 완료    4일
					ee = mm+5; //디자인 완료  5일
					es = mm+10; //최종 확정    2일
				}else {
					mm = 0;    //마케팅 완료  2일
					dd = mm+8; //문안 완료    2일
					ee = mm+5; //디자인 완료  3일
					es = mm+10; //최종 확정    2일
				}
				
				if(formData.get("st_buyer").equals("KRDONG0110")) {        //동부한농 인천공장
					plant = "2210";
				}else if(formData.get("st_buyer").equals("KRDONG0107")) {  //동부한농 구미공장
					plant = "2220";
				}else if(formData.get("st_buyer").equals("KRDONG0128")) {  //동부정밀 전주공장
					plant = "5210";
				}else if(formData.get("st_buyer").equals("KRDONG0099")) {  //동부한농 울산공장
					plant = "2100";
				}else if(formData.get("st_buyer").equals("KRDONG0153")) {  //동부한농 제주공장
					plant = "2110";
				}else if(formData.get("st_buyer").equals("KRKEPB0004")) {  //테스트 고객사
					plant = "XXXX";
				}else if(formData.get("st_buyer").equals("KRKORE0001")) {  //테스트 고객사
					plant = "AAAA";
				}else if(formData.get("st_buyer").equals("KRDONG0732")) {  //동부한농 종자
					plant = "3100";
				}
				
                formData.put("PLANT" ,plant);
                formData.put("MM_DATE",String.valueOf(mm));
                formData.put("DD_DATE",String.valueOf(dd));
                formData.put("EE_DATE",String.valueOf(ee));
                formData.put("ES_DATE",String.valueOf(es));
                
                if(formData.get("st_safety_open") == null || "".equals(formData.get("st_safety_open"))) { 
                	formData.put("st_safety_open", "");
                }
                
				sqlSessionTemplate.update("common.mpds.insertMasterMpDsPckpaprDesignManageSeedRegPop", formData);
				
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("등록에 실패하였습니다.");
		}
		return _rtnMsg;
	}	
}
