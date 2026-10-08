package com.koreab2b.mro.common.wmco.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmco.dao.MasterWmCoMgDaoImpl;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterWmCoWarehousingDetailPopDao")
@Transactional
public class MasterWmCoWarehousingDetailPopDaoImpl implements MasterWmCoWarehousingDetailPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmCoMgDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		sqlSessionTemplate.select("common.wmco.selectMasterWmCoWarehousingDetailPopList", formData, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		return resultList;
	}
	
	
	// 조회
	public List<Map<String,String>> selectDetail(Map<String,Object> formData) {

		return sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoWarehousingDetail", formData);
	}
	
	//입고
	public String updateSelectedData(Map<String, String> formData,List<Object> gridData){
		String OS = System.getProperty("os.name").toLowerCase();
		String rtnMsg = "OK";
		
		String hub_orderno = "";
		
		List<Map<String ,String>> _checkGr = new ArrayList<Map<String,String>>();
		
		try{
			/*
			if(OS.indexOf("win") >= 0){
				
				_checkGr = sqlSessionTemplate.selectList("common.wmco.updateMasterWmCoWarehousingDetailWMS_GR_QTY", formData);
				
					rtnMsg = "existStock@@"+formData.get("st_inv_no");
					return rtnMsg;
				
			}
			*/
			
			// 간선
			if(formData.get("st_hub_yn").equals("Y")){
				//송장번호 생성을 위한 조회 
				List<Map<String,Object>> _rtnListorderno = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreHubORDERNO", formData);
					
				//현재 Company 코드에 해당하는 type의 코드가 존재하지 않는 경우 새로 번호를 생성한다.
				if(_rtnListorderno.size() != 1){
					sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreHubIcomsqmt", formData);
	                int year_num = Calendar.getInstance().get(Calendar.YEAR);
	                String year_str = String.valueOf(year_num);
	                hub_orderno = "IH" + year_str.substring(2,4) + "000001";
				}else{
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomsqmt", formData);
					hub_orderno = _rtnListorderno.get(0).get("ORDERNO").toString();
				}
				
				formData.put("hub_orderno", hub_orderno);
				formData.put("BUYER", formData.get("st_buyer"));
				formData.put("INV_NO", formData.get("st_inv_no"));
				formData.put("PO_NO", formData.get("st_po_no"));
				
				// ICOMIVDT.HUB_FLAG 변경
				formData.put("HUB_FLAG", "G");
				sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomivdt", formData);
				// HUBIVDT 생성
				sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreHub", formData);
			}else{ // 기존 입고
				sqlSessionTemplate.update("common.wmco.updateMasterWmCoWarehousingDetail", formData);	
			}
		}catch(Exception e){
			rtnMsg = "입고등록 중 오류가 발생 하였습니다.";
			throw new RuntimeException("입고등록 중 오류가 발생 하였습니다.");
		}
		
		return rtnMsg;
	}
	
	public String updateSelectedData_v2(Map<String, String> formData,List<Object> gridData){
		String OS = System.getProperty("os.name").toLowerCase();
		String rtnMsg = "OK";
		
		String hub_orderno = "";
		
		List<Map<String ,String>> _checkGr = new ArrayList<Map<String,String>>();
		
		try{
			/*
			if(OS.indexOf("win") >= 0){
				
				_checkGr = sqlSessionTemplate.selectList("common.wmco.updateMasterWmCoWarehousingDetailWMS_GR_QTY", formData);
				
					rtnMsg = "existStock@@"+formData.get("st_inv_no");
					return rtnMsg;
				
			}
			*/
			
			// 간선
			if(formData.get("st_hub_yn").equals("Y")){
				//송장번호 생성을 위한 조회 
				List<Map<String,Object>> _rtnListorderno = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreHubORDERNO", formData);
					
				//현재 Company 코드에 해당하는 type의 코드가 존재하지 않는 경우 새로 번호를 생성한다.
				if(_rtnListorderno.size() != 1){
					sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreHubIcomsqmt", formData);
	                int year_num = Calendar.getInstance().get(Calendar.YEAR);
	                String year_str = String.valueOf(year_num);
	                hub_orderno = "IH" + year_str.substring(2,4) + "000001";
				}else{
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomsqmt", formData);
					hub_orderno = _rtnListorderno.get(0).get("ORDERNO").toString();
				}
				
				formData.put("hub_orderno", hub_orderno);
				formData.put("BUYER", formData.get("st_buyer"));
				formData.put("INV_NO", formData.get("st_inv_no"));
				formData.put("PO_NO", formData.get("st_po_no"));
				
				// ICOMIVDT.HUB_FLAG 변경
				formData.put("HUB_FLAG", "G");
				sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomivdt_v2", formData);
				// HUBIVDT 생성
				sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreHub", formData);
			}else{ // 기존 입고
				int hubIvdtCheck = sqlSessionTemplate.selectOne("master.wmgr.getMasterWmGrTrCreHubIvdtCount_v2", formData);
				if(hubIvdtCheck == 0) { //순수입고센터
					sqlSessionTemplate.update("common.wmco.updateMasterWmCoWarehousingDetail_v2", formData);	
				}else {
					sqlSessionTemplate.update("common.wmco.updateMasterWmCoWarehousingDetail", formData);	
				}
			}
		}catch(Exception e){
			rtnMsg = "입고등록 중 오류가 발생 하였습니다.";
			throw new RuntimeException("입고등록 중 오류가 발생 하였습니다.");
		}
		
		return rtnMsg;
	}
	
	//출고 
	public String updateSelectedDataIvt(Map<String, String> formData,List<Object> gridData){
		String _rtnMsg = "GR_IK_OK";
		int res_cnt = 0; 
		
		//처리 대상 조회 
		List<Map<String,Object>>  _rtnList = sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoWarehousingDetailPopForUpdate", formData);
		//송장번호 생성 
		String  _rtnListorderno= sqlSessionTemplate.selectOne("common.wmco.selectMasterWmCoWarehousingDetailPopORDERNO", formData);
		String orderno ="";
		if(_rtnListorderno== null || "".equals(_rtnListorderno))				{
			sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreIcomsqmt", formData);
            int year_num = Calendar.getInstance().get(Calendar.YEAR);
            String year_str = String.valueOf(year_num);
            orderno = "IK"+year_str.substring(2,4) + "000001";
		}
		else
		{
			sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreIcomsqmt", formData);
			orderno = _rtnListorderno;
		}
		
		for(int i=0 ; i<_rtnList.size(); i++){
			formData.put("PO_NO", _rtnList.get(i).get("PO_NO").toString());
			formData.put("BUYER", _rtnList.get(i).get("BUYER").toString());
			formData.put("PO_SEQ", _rtnList.get(i).get("PO_SEQ").toString());
			formData.put("INV_SEQ", _rtnList.get(i).get("INV_SEQ").toString());
			formData.put("INV_QTY", _rtnList.get(i).get("INV_QTY").toString());
			formData.put("INV_NO", _rtnList.get(i).get("INV_NO").toString());
			
			if(i==0)	{
				//효성SAP
				//if("KRHYOS0033".equals(formData.get("BUYER")) || "KRHYOS0034".equals(formData.get("BUYER")) || "KRHYOS0036".equals(formData.get("BUYER")) ||"KRHYOS0037".equals(formData.get("BUYER")) )
				//SLOGIC-BEGIN(P08-0000003-02)
				if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-02"))
				{
					try{
						List<Map<String,Object>>  _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialHyosungSAP", formData);
						formData.put("LEGACY_IV_SERIAL",_rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString());
						
					}catch(Exception e){
						_rtnMsg = "효성 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다";
						throw new RuntimeException("효성 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
					}
				
				}//SLOGIC-END 
				//else if("KRSSAN0025".equals(formData.get("BUYER")))
				//SLOGIC-BEGIN(P08-0000003-04)
				else if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-04"))
				{
					try{
						List<Map<String,Object>>  _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialSsangyong", formData);
						formData.put("LEGACY_IV_SERIAL",_rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString());
						
					}catch(Exception e){
						_rtnMsg = "쌍용자동차 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.";
						throw new RuntimeException("쌍용자동차 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.");
					}

				}//SLOGIC-END 
				//SLOGIC-BEGIN(P08-0000003-05)
				else if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-05"))
				{
					try{
						List<Map<String,Object>>  _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialLTAL", formData);
						formData.put("LEGACY_IV_SERIAL",_rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString());
						
					}catch(Exception e){
						_rtnMsg = "롯데알미늄 송장번호(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.";
						throw new RuntimeException("롯데알미늄 송장번호(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.");
					}

				}//SLOGIC-END 
				else
				{
					formData.put("LEGACY_IV_SERIAL","");
				}
			}//END IF
			
			
			//WMSIVDT INSERT					
			//물류센터 송장 INSERT
			try{
				formData.put("INV_SEQ_I", String.valueOf(i+1));
				formData.put("orderno", orderno);
				res_cnt= sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreWMSIVDT", formData);
				
				// 출고예정일 변경 ICOMPORS BUYER_DS_DATE UPDATE
				sqlSessionTemplate.update("common.wmgi.updateMasterWmGiDstbtrICOMPORS", formData);			
				
				if(res_cnt !=1){
					_rtnMsg = "송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.";
					throw new RuntimeException("송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.");
				}
				
			}catch(Exception se)	{
				
				_rtnMsg = "송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.";
				throw new RuntimeException("송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.");
			}
			
			try{
				   //update ICOMPODT 발주 DETAIL
					res_cnt =sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreICOMPODT", formData);
					if(res_cnt !=1){
						_rtnMsg = "송장생성중(WMS UPDATE ICOMPODT) 에러가 발생하였습니다.";
						throw new RuntimeException("송장생성중(WMS UPDATE ICOMPODT) 에러가 발생하였습니다.");
					}
			}catch(Exception se)	{
				
				_rtnMsg = "송장생성중(WMS UPDATE ICOMPODT) 에러가 발생하였습니다.";
				throw new RuntimeException("송장생성중(WMS UPDATE ICOMPODT) 에러가 발생하였습니다.");
			}

			
			try{
				
				//update ICOMIVDT 협력사 송장 
				res_cnt = sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreICOMIVDT", formData);
				if(res_cnt !=1){
					_rtnMsg = "송장생성중(WMS UPDATE ICOMIVDT) 에러가 발생하였습니다..";
					throw new RuntimeException("송장생성중(WMS UPDATE ICOMIVDT) 에러가 발생하였습니다.");
				}
			}catch(Exception se)	{
				
				_rtnMsg = "송장생성중(WMS UPDATE ICOMIVDT) 에러가 발생하였습니다.";
				throw new RuntimeException("송장생성중(WMS UPDATE ICOMIVDT) 에러가 발생하였습니다.");
				
			}
		
			
		} //END FOR
		
		_rtnMsg  += "@@" + orderno;
		
		return _rtnMsg;
	}
}
