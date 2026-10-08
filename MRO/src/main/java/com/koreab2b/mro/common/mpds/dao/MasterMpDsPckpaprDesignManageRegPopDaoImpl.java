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

@Repository("masterMpDsPckpaprDesignManageRegPopDao")
@Transactional
public class MasterMpDsPckpaprDesignManageRegPopDaoImpl implements MasterMpDsPckpaprDesignManageRegPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpRqReqNegoReceiptDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpds.selectMasterMpDsPckpaprDesignManageRegPopList", formData);
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
				
				/*STEP1 */
				if(formData.get("st_gubun_flag").equals("NW")) { //신규
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
				}

                formData.put("PLANT" ,plant);
                formData.put("MM_DATE",String.valueOf(mm));
                formData.put("DD_DATE",String.valueOf(dd));
                formData.put("EE_DATE",String.valueOf(ee));
                formData.put("ES_DATE",String.valueOf(es));
                
                if(formData.get("st_safety_open") == null || "".equals(formData.get("st_safety_open"))) { 
                	formData.put("st_safety_open", "");
                }
                
				sqlSessionTemplate.update("common.mpds.insertMasterMpDsPckpaprDesignManageRegPop_1", formData);
				
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("등록에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	@SuppressWarnings("unchecked")
	public void replyMail(Map<String,String> formData, List<Object> gridData) {
		/*메일링 로직 있음*/
		List<Map<String,String>>_list = null;
		for(int i=0; i < gridData.size(); i++){
			formData.putAll((Map<String, String>)gridData.get(i));
			
			_list = sqlSessionTemplate.selectList("master.mp.rq.mailMasterMpRqItemReqStndCnt", formData);
			String check_flag = CommonUtil.getListKeyValue(_list,"CNT","0");
			if(check_flag.equals("0")){	
				// MAILSEND INSERT
				sqlSessionTemplate.update("master.mp.rq.mailMasterMpRqItemReqStndMail", formData);
			}
		}
	}	
}
