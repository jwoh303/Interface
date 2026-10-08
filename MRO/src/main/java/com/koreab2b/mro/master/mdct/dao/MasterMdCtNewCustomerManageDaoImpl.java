package com.koreab2b.mro.master.mdct.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCtNewCustomerManageDao")
@Transactional
public class MasterMdCtNewCustomerManageDaoImpl implements MasterMdCtNewCustomerManageDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtNewCustomerManageDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	

	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtNewCustomerManageList", param);
	}
	// 잠재고객 등록	
	public String saveMasterMdCtNewCustomer(Map<String,String> formData) {
		String rtnMsg = "Ok";
		try{
			List<Map<String,String>>_list = null;
			_list = sqlSessionTemplate.selectList("master.mdct.checkMasterMdCtNewCustomer",formData);
			String resultYn = CommonUtil.getListKeyValue(_list,"RESULT_YN","");
			//실적등록처리 확인
			if(resultYn.equals("Y")){
				rtnMsg = "등록 된 사업자 번호입니다. 확인 바랍니다.";
			}else{
				String cmpyNo =  getCmpyNo("KRKORE0001","CP");
				formData.put("cmpyNo", cmpyNo);
				//잠재고객사 정보 등록
				sqlSessionTemplate.update("master.mdct.saveMasterMdCtNewCustomer", formData);
				//잠재고객사 사전영업정보 등록
				sqlSessionTemplate.update("master.mdct.saveMasterMdCtNewCustomerRfq", formData);
				//잠재고객사 영업활동 마스터 등록
				sqlSessionTemplate.update("master.mdct.saveMasterMdCtNewCustomerkepVisit", formData);				
			}
		}catch(Exception e){
			rtnMsg = "잠재고객사 등록 중 오류가 발생 하였습니다.";
			throw new RuntimeException();
		}
		
		return rtnMsg;
	}
	//채번
	public String getCmpyNo(String comCode, String docType){
		String orderNo = "";
		Map<String,String> _map = new HashMap<String,String>();
		try{
			_map.put("st_com_code", comCode);
			_map.put("st_doc_type", docType);
			// 기존 고객사화면에서 사용하는 쿼리 사용
			orderNo = CommonUtil.nvl((String)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingGrNo", _map));
			if(orderNo.equals("")){
				sqlSessionTemplate.insert("buyer.wmgr.insertBuyerWmGrWarehousingGrNo", _map);
				orderNo = "" + Calendar.getInstance().get(Calendar.YEAR);
				orderNo = _map.get("st_doc_type") + orderNo.substring(2,4) + "000001";
			} else {
				sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingGrNo", _map);
			}
		}catch(Exception e){
			throw new RuntimeException("잠재고객사 코드 생성 중 에러가 발생하였습니다.");
		}
		return orderNo;
	}
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "법인그룹 정보 저장이 완료 되었습니다.";
		
		try {
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("updateMasterMdCtNewCustomerManageList 요청 파라미터 : formData {}", formData.get("sStatus"));
				
				if ( "I".equals(formData.get("sStatus")) ) {
					sqlSessionTemplate.insert("master.mdct.insertMasterMdCtNewCustomerManageList", formData);
				} else {
					// 법인그룹 저장
					sqlSessionTemplate.update("master.mdct.updateMasterMdCtNewCustomerManageList", formData);
				}
			}
		} catch (Exception e) {
			_rtnMsg = "법인그룹 정보 저장에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("법인그룹 정보 저장에 실패했습니다.\n\n관리자에게 문의 하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	// 잠재고객 상세조회
	public List<Map<String,String>> getDetailList(Map<String,String> formData) {
		String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("master.mdct.selectMasterMdCtNewCustomerDt").getBoundSql(formData).getSql();
		String attr_01 = "";
		for(Map.Entry<String, String>entry: formData.entrySet()){
			attr_01 += entry.getKey() + "="+entry.getValue() + "/";
		}
		Map<String, String> data = new HashMap<String, String>();
		data.putAll(formData);
		data.put("SYSTEM", "KOREAB2B");
		data.put("MENU", "잠재고객정보조회(팝업)");
		data.put("LOG_TYPE", "조회");				
		data.put("ATTR_01", strSql+"/"+attr_01);
		data.put("ATTR_02", "");
		data.put("ATTR_03", "");
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
		
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtNewCustomerDt",formData);
	}
	// 잠재고객 수정
	public String updateMasterMdCtNewCustomer(Map<String,String> formData) {
		String rtnMsg = "Ok";
		try{
			//잠재고객사 수정
			sqlSessionTemplate.update("master.mdct.updateMasterMdCtNewCustomer", formData);
		}catch(Exception e){
			rtnMsg = "잠재고객사 수정 중 오류가 발생 하였습니다.";
			throw new RuntimeException();
		}
		
		return rtnMsg;
	}
	// 잠재고객 재개/종결
	public String endMasterMdCtNewCustomer(Map<String,String> formData) {
		String rtnMsg = "Ok";
		try{
			//잠재고객 재개
			if(formData.get("st_buyer_close_flag_in").equals("N")){
				List<Map<String,String>> list = null;
				list = sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtRestartNewCustomer", formData);
				Map<String,String> mp = (Map<String,String>)list.get(0);
				//사전영업(GA) 아니면 차수 증가하여 RFQ 생성..
				if(!mp.get("PROCESS_TYPE").equals("GA")){
					//기존차수 종결
					sqlSessionTemplate.update("master.mdct.updateMasterMdCtNewCustomerMtEnd", formData);
					//차수 증가 INSERT
					sqlSessionTemplate.update("master.mdct.saveMasterMdCtNewCustomerRfqAdd", formData);
				}
			}
			//잠재고객사 종결여부 수정 수정			
			sqlSessionTemplate.update("master.mdct.endMasterMdCtNewCustomer", formData);
		}catch(Exception e){
			rtnMsg = "잠재고객사 처리중 오류가 발생 하였습니다.";
			throw new RuntimeException();
		}
		
		return rtnMsg;
	}
	// 잠재고객 사전영업 완료
	public String saveMasterMdCtNewCustomerMtComp(Map<String,String> formData) {
		String rtnMsg = "Ok";
		try{
			//잠재고객사 사전영업 완료
			sqlSessionTemplate.update("master.mdct.saveMasterMdCtNewCustomerMtComp", formData);
		}catch(Exception e){
			rtnMsg = "사전영업 완료 처리중 오류가 발생 하였습니다.";
			throw new RuntimeException();
		}
		
		return rtnMsg;
	}
	// 기업정보 업데이트
	public String updateMasterMdCtMSTNewCustomer(Map<String,String> formData) {
		String rtnMsg = "Ok";
		try{
			//잠재고객사 수정
			sqlSessionTemplate.update("master.mdct.updateMasterMdCtMSTNewCustomer", formData);
		}catch(Exception e){
			rtnMsg = "기업정보 업데이트 중 오류가 발생 하였습니다.";
			throw new RuntimeException();
		}
		
		return rtnMsg;
	}
}
