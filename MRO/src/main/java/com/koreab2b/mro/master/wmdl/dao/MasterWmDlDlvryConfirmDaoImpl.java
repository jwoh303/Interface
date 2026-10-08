package com.koreab2b.mro.master.wmdl.dao;

import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmDlDlvryConfirmDao")
@Transactional
public class MasterWmDlDlvryConfirmDaoImpl implements MasterWmDlDlvryConfirmDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmDlDlvryConfirmDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		List<String> iknoParam;
		iknoParam = Arrays.asList( ((String)param.get("st_ivk_no_barcode")).split(","));
	    if(iknoParam.size() >0 )
	    {
	    	param.put("iknoParam",iknoParam);
	    	param.put("iknoCnt","1");
	    }
		return sqlSessionTemplate.selectList("master.wmdl.selectMasterWmDlDlvryConfirmList", param);
	}

	public List<Map<String,String>> selectPopList(Map<String,String> param) {
		return sqlSessionTemplate.selectList("master.wmdl.selectMasterWmDlDlvryConfirmPopList", param);
	}
	
	// 택배사 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedDataCenter(Map<String,String>  formData, List<Object> gridData) {
		
		try{
			String compUrl = "";
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.wmdl.updateMasterWmDlDlvryCenter", formData);
				
			}
			compUrl =  sqlSessionTemplate.selectOne("master.wmdl.selectMasterWmDlDlvryCenter", formData);
			_rtnMsg = "OK"+compUrl;
		}catch (Exception e){
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "배송 확정에 실패하였습니다.";
				throw new RuntimeException("배송 확정에 실패하였습니다.");
		}
		return _rtnMsg;

		
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		

		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				String Company = formData.get("st_delivery_company");
				if(!Company.equals("JIKNAB")  && !Company.equals("CENTER")) { // 택배의 경우
					sqlSessionTemplate.update("master.wmdl.updateMasterWmDlDlvryCenter", formData);
				} else { // 직납의 경우
				
					String st_gr_auto_flag = formData.get("EXE_GR_FLAG").toString();
					// STEP1
					int resultWidt = sqlSessionTemplate.update("master.wmdl.insertMasterWmDlDlvryConfirm1", formData);
					
					if(resultWidt == 0){
						_rtnMsg = "배송 확정에 실패하였습니다.";
						throw new RuntimeException();
					}
					
					//sqlSessionTemplate.update("master.wmdl.insertMasterWmDlDlvryConfirm2", formData); // ICOMIVDT 업데이트 할 이유가 없음 - 팀장님 2025.02.12
					
					sqlSessionTemplate.update("master.wmdl.insertMasterWmDlDlvryConfirm3", formData);
					if(st_gr_auto_flag.equals("Y")){
						//자동입고리스트
						List<Map<String,String>> rtnGrList = sqlSessionTemplate.selectList("master.wmdl.selectMasterWmDlWmsGrQtyList", formData);
						String grNo = "";
						//IK번호 기준 상세로 풀어서 체크
						int _seq = 0;
						for(int k=0; k < rtnGrList.size() ;k++){
							logger.debug("SQL st_gr_auto_flag ================== {}", st_gr_auto_flag);
							formData.putAll((Map<String, String>)rtnGrList.get(k));
							String _grQty = null;
							//수량체크
							_grQty = (String)sqlSessionTemplate.selectOne("master.wmdl.selectMasterWmDlWmsGrQtyCheck", formData);
							logger.debug("_grQty ==>> " + _grQty);
							if(Integer.parseInt(_grQty) > 0){
								_rtnMsg = (i+1)+"번째 입고수량이 송장수량보다 많을 수 없습니다.\n 고객사 입고 취소 후 등록 가능합니다.";
								throw new RuntimeException(_rtnMsg);
							} else {
								//입고생성
								Map<String,String> _dataGrParam = null;
								_dataGrParam = new HashMap<String,String>() ;
								if(k ==0){
									grNo = getOrderNo(formData.get("BUYER"), "GR");
								}
								logger.debug("grNo ================== {}", grNo);
								_dataGrParam.put("BUYER", formData.get("KEY_BUYER"));
								logger.debug("KEY_BUYER ================== {}", formData.get("KEY_BUYER"));
								_dataGrParam.put("PO_NO", formData.get("KEY_PO_NO").toString());
								_dataGrParam.put("PO_SEQ",formData.get("KEY_PO_SEQ").toString());
								_dataGrParam.put("INV_NO", formData.get("KEY_INV_NO").toString());
								logger.debug("KEY_INV_NO ================== {}", formData.get("KEY_INV_NO"));
								_dataGrParam.put("INV_SEQ", formData.get("KEY_INV_SEQ").toString());
								logger.debug("KEY_INV_SEQ ================== {}", formData.get("KEY_INV_SEQ"));
								_dataGrParam.put("GR_QTY", formData.get("KEY_INV_QTY").toString());
								logger.debug("KEY_INV_QTY ================== {}", formData.get("KEY_INV_QTY"));
								_dataGrParam.put("GR_NO", grNo);							
								_dataGrParam.put("GR_SEQ", String.valueOf(_seq+1));
								_dataGrParam.put("GR_DATE", formData.get("st_delivery_date"));
								//ICOMGRDT 생성
								sqlSessionTemplate.insert("master.wmdl.insertMasterWmDlWmsWarhsngProcGrdt", _dataGrParam);
								//UPDATE ICOMPODT
								sqlSessionTemplate.insert("master.wmdl.updateMasterWmDlWmsWarhsngProcPodt", _dataGrParam);
								//UPDATE WMSIVDT
								sqlSessionTemplate.insert("master.wmdl.updateMasterWmDlWmsWarhsngProcWmsIvdt", _dataGrParam);
								_seq++;
							}
						}
					}
					//재고건 조회 WMSSTCK
					List<Map<String,String>> rtnList = sqlSessionTemplate.selectList("master.wmdl.selectMasterWmDlDlvryConfirmSave", formData);
					for(int j=0; j < rtnList.size() ;j++){
						formData.putAll((Map<String, String>)rtnList.get(j));
						
						sqlSessionTemplate.update("master.wmdl.insertMasterWmDlDlvryConfirm4", formData);
						
					}
				
				}
			}
			_rtnMsg = "OK";
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "배송 확정에 실패하였습니다.";
				throw new RuntimeException("배송 확정에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.wmdl.deleteMasterWmDlDlvryConfirm", formData);
				logger.error("deleteMasterWmDlDlvryConfirm 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
	
//채번
	public String getOrderNo(String comCode, String docType){
	
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
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("입고번호 생성 중 에러가 발생하였습니다.");
		}
		
		return orderNo;
	}
}
