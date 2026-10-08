package com.koreab2b.mro.common.wmgi.dao;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmgr.dao.MasterWmGrTrGrCreDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmGiLegacyNoPopDao")
@Transactional
public class MasterWmGiLegacyNoPopDaoImpl implements MasterWmGiLegacyNoPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrTrGrCreDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmgi.selectMasterWmGiLegacyNoPopList", formData);
	}
	
	//출고지시 
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData){
		
		String rtnMsg = "OK";
		String Invk_no = "";
		String legacyIvSerial = "";


			List<Map<String,Object>>  _rtnListorderno= sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreORDERNO", formData);
			//현재 Company 코드에 해당하는 type의 코드가 존재하지 않는 경우 새로 번호를 생성한다.
			if(_rtnListorderno.size() !=1)
			{
				sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrGrCreIcomsqmt", formData);
                int year_num = Calendar.getInstance().get(Calendar.YEAR);
                String year_str = String.valueOf(year_num);
                Invk_no = "IK"+year_str.substring(2,4) + "000001";
			}
			else
			{
				sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreIcomsqmt", formData);
				Invk_no = _rtnListorderno.get(0).get("ORDERNO").toString();
			}
			
			
			for(int i=0; i < gridData.size(); i++){
				
				formData.putAll((Map<String,String>)gridData.get(i));
				
				if(i==0)
				{
					//효성SAP
					//if("KRHYOS0033".equals(formData.get("BUYER")) || "KRHYOS0034".equals(formData.get("BUYER")) || "KRHYOS0036".equals(formData.get("BUYER")) ||"KRHYOS0037".equals(formData.get("BUYER")) ){
					//SLOGIC-BEGIN(P08-0000003-02)
						if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-02"))
						{
							try{
								List<Map<String,Object>>  _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialHyosungSAP", formData);
								
								legacyIvSerial = (String)_rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL");
								
							}catch(Exception e){
								rtnMsg = "효성 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다";
								throw new RuntimeException("효성 송장 차수(LEGACY_IV_SERIAL) 생성시  에러가 발생 하였습니다.");
							}
						
						}//SLOGIC-END 

					//}
//					else if("KRSSAN0025".equals(formData.get("BUYER")))
//					{
						//SLOGIC-BEGIN(P08-0000003-04)
						else if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-04"))
						{
							try{
								List<Map<String,Object>>  _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialSsangyong", formData);
								legacyIvSerial = _rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString();
								
							}catch(Exception e){
								rtnMsg = "쌍용자동차 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.";
								throw new RuntimeException("쌍용자동차 송장 차수(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.");
							}

						}

						//SLOGIC-BEGIN(P08-0000003-05)
						else if(CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000003-05"))
						{
							try{
								List<Map<String,Object>>  _rtnListLegacyIvSerial = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrGrCreILegacyIvSerialLTAL", formData);
								legacyIvSerial = _rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString();
//								formData.put("LEGACY_IV_SERIAL",_rtnListLegacyIvSerial.get(0).get("LEGACY_IV_SERIAL").toString());
								
							}catch(Exception e){
								rtnMsg = "롯데알미늄 송장번호(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.";
								throw new RuntimeException("롯데알미늄 송장번호(LEGACY_IV_SERIAL) 생성시 에러가 발생 하였습니다.");
							}

						}//SLOGIC-END 
//					}


				} //i== 0 end

				
				//WMSIVDT INSERT					
				//물류센터 송장 INSERT
				try{
					formData.put("INV_SEQ_I", String.valueOf(i+1));
					formData.put("INVK_NO", Invk_no);
					if("KRDAEW0016".equals(formData.get("BUYER"))  &&("1".equals(formData.get("PROCESS_TYPE")) || "2".equals(formData.get("PROCESS_TYPE")) ||"3".equals(formData.get("PROCESS_TYPE"))    ) ){
						formData.put("LEGACY_IV_SERIAL", "");
					}else{
						formData.put("LEGACY_IV_SERIAL", legacyIvSerial);
					}
			
					sqlSessionTemplate.update("common.wmgi.insertMasterWmGiLegacyNoPopList", formData);
					
					// 출고예정일 변경 ICOMPORS BUYER_DS_DATE UPDATE
					sqlSessionTemplate.update("common.wmgi.updateMasterWmGiDstbtrICOMPORS", formData);
					
				}catch(Exception se)	{
					
					rtnMsg = "송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.";
					throw new RuntimeException("송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.");
					//throw new RuntimeException( "송장생성중(WMS INSERT INTO WMSIVDT) 에러가 발생하였습니다.");
				}
				
				try{
					sqlSessionTemplate.update("common.wmgi.updateMasterWmGiDstbtrICOMPODT", formData);	
					
				}catch(Exception se)	{
					
					rtnMsg ="송장생성중(WMS UPDATE ICOMPODT) 에러가 발생하였습니다.";
					throw new RuntimeException("송장생성중(WMS UPDATE ICOMPODT) 에러가 발생하였습니다.");
				}
				
				try{
					
					sqlSessionTemplate.update("common.wmgi.updateMasterWmGiDstbtrICOMIVDT", formData);	
					
				}catch(Exception se)	{
					
					rtnMsg ="송장생성중(WMS UPDATE ICOMIVDT) 에러가 발생하였습니다.";
					throw new RuntimeException("송장생성중(WMS UPDATE ICOMIVDT) 에러가 발생하였습니다.");
				}
				
				
				if(!"2".equals(formData.get("PROCESS_TYPE"))){
					
					try{
						sqlSessionTemplate.update("common.wmgi.updateMasterWmGiDstbtrWMSSTCK2", formData);	
					}catch(Exception se)	{
						
						rtnMsg ="송장생성중(WMS UPDATE WMSSTCK) 에러가 발생하였습니다.";
						throw new RuntimeException("송장생성중(WMS UPDATE WMSSTCK) 에러가 발생하였습니다.");
					}
					
				}else if("3".equals(formData.get("PROCESS_TYPE"))){
					
					
					try{
						sqlSessionTemplate.update("common.wmgi.updateMasterWmGiDstbtrWMSSTCK3", formData);	
					}catch(Exception se)	{
						
						rtnMsg ="송장생성중(WMS UPDATE WMSSTCK) 에러가 발생하였습니다.";
						throw new RuntimeException("송장생성중(WMS UPDATE WMSSTCK) 에러가 발생하였습니다..");
					}
					
				}

					
				List<Map<String,Object>> wmsStckForSTCKCount  = sqlSessionTemplate.selectList("common.wmgi.checkMasterWmGiLegacyNoPopDuplicate", formData);
				BigDecimal tempINV_QTY = new BigDecimal(wmsStckForSTCKCount.get(0).get("INV_QTY").toString());
				BigDecimal tempWMS_IVK_QTY = new BigDecimal(wmsStckForSTCKCount.get(0).get("WMS_IVK_QTY").toString());

				if(tempINV_QTY.compareTo(tempWMS_IVK_QTY) ==-1){
					rtnMsg ="송장생성중( Duplicate Check ) 에러가 발생하였습니다.\n\nDuplicate Check ERROR.";
					throw new RuntimeException("송장생성중( Duplicate Check ) 에러가 발생하였습니다.\n\nDuplicate Check ERROR.");
				}
					
			} //END FOR
			rtnMsg +=Invk_no;
		return rtnMsg;
	}	
	
}
