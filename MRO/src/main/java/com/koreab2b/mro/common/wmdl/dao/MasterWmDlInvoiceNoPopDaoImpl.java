package com.koreab2b.mro.common.wmdl.dao;

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

@Repository("masterWmDlInvoiceNoPopDao")
@Transactional
public class MasterWmDlInvoiceNoPopDaoImpl implements MasterWmDlInvoiceNoPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmDlInvoiceNoPopDaoImpl.class);
	private String _rtnMsg = "";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmdl.selectMasterWmDlInvoiceNoPopList", formData);
	}
	
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		

		
		try{				
				String Company = formData.get("st_delivery_company");
				String st_auto_gr_flag = formData.get("AUTO_GR_FLAG");
				if(!Company.equals("JIKNAB")  && !Company.equals("CENTER")) { // 택배의 경우
					sqlSessionTemplate.update("common.wmdl.updateMasterWmDlDlvryCenterPop", formData);
				} else {
					// STEP1
					int resultWidt = sqlSessionTemplate.update("common.wmdl.insertMasterWmDlInvoiceNoPop1", formData);
					
					if(resultWidt == 0){
						_rtnMsg = "배송 확정에 실패하였습니다.";
						throw new RuntimeException();
					}
					
					sqlSessionTemplate.update("common.wmdl.insertMasterWmDlInvoiceNoPop2", formData);
					
					sqlSessionTemplate.update("common.wmdl.insertMasterWmDlInvoiceNoPop3", formData);
					
					if(st_auto_gr_flag.equals("Y")){
						String grNo = "";					
						//자동입고리스트
						List<Map<String,String>> rtnGrList = sqlSessionTemplate.selectList("common.wmdl.selectMasterWmDlInvoiceNoPopGrList", formData);
						//IK번호 기준 상세로 풀어서 체크
						int _seq = 0;
						for(int k=0; k < rtnGrList.size(); k++){
							formData.putAll((Map<String, String>)rtnGrList.get(k));
							String _grQty = null;
							//수량체크
							_grQty = (String)sqlSessionTemplate.selectOne("common.wmdl.selectMasterWmDlInvoiceNoPopGrQtyCheck", formData);
							if(Integer.parseInt(_grQty) > 0){
								_rtnMsg = "입고수량이 송장수량보다 많을 수 없습니다.\n 고객사 입고 취소 후 등록 가능합니다.";
								throw new RuntimeException(_rtnMsg);
							} else {
								//입고생성
								Map<String,String> _dataGrParam = null;
								_dataGrParam = new HashMap<String,String>() ;
								if(k == 0){
									grNo = getOrderNo(formData.get("BUYER"), "GR");
								}
								_dataGrParam.put("BUYER", formData.get("KEY_BUYER"));								
								_dataGrParam.put("PO_NO", formData.get("KEY_PO_NO").toString());
								_dataGrParam.put("PO_SEQ",formData.get("KEY_PO_SEQ").toString());
								_dataGrParam.put("INV_NO", formData.get("KEY_INV_NO").toString());								
								_dataGrParam.put("INV_SEQ", formData.get("KEY_INV_SEQ").toString());								
								_dataGrParam.put("GR_QTY", formData.get("KEY_INV_QTY").toString());								
								_dataGrParam.put("GR_NO", grNo);							
								_dataGrParam.put("GR_SEQ", String.valueOf(_seq+1));
								_dataGrParam.put("GR_DATE", formData.get("st_delivery_date"));
								//ICOMGRDT 생성
								sqlSessionTemplate.insert("common.wmdl.insertMasterWmDlInvoiceNoPopProcGrdt", _dataGrParam);
								//UPDATE ICOMPODT
								sqlSessionTemplate.insert("common.wmdl.updateMasterWmDlInvoiceNoPopProcPodt", _dataGrParam);
								//UPDATE WMSIVDT
								sqlSessionTemplate.insert("common.wmdl.updateMasterWmDlInvoiceNoPopProcWmsIvdt", _dataGrParam);
								_seq++;
							}						
						}
					}
					
					List<Map<String,String>> rtnList = sqlSessionTemplate.selectList("common.wmdl.selectMasterWmDlInvoiceNoPopListSave", formData);
					
					for(int j=0; j < rtnList.size() ;j++){
						formData.putAll((Map<String, String>)rtnList.get(j));
						
						sqlSessionTemplate.update("common.wmdl.insertMasterWmDlInvoiceNoPop4", formData);
						
					}
				}				

			_rtnMsg = "OK";
		} catch (Exception e){
		
			_rtnMsg = "배송 확정에 실패하였습니다.";
				throw new RuntimeException("배송 확정에 실패하였습니다.");
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
