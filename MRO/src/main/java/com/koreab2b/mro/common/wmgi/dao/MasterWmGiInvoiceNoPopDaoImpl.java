package com.koreab2b.mro.common.wmgi.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmGiInvoiceNoPopDao")
@Transactional
public class MasterWmGiInvoiceNoPopDaoImpl implements MasterWmGiInvoiceNoPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmgi.selectMasterWmGiInvoiceNoPopList", formData);
	}

	// 조회
	public List<Map<String,String>> selectPop(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.wmgi.selectMasterWmGiInvoiceNoPop", formData);
	}
	
	// 조회
	public String selectDoosan(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.wmgi.selectMasterWmGiInvoiceNoDoosan", formData);
	}
	
	// 조회
	public List<Map<String,String>> getListDelevery(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmgi.selectMasterWmGiInvoiceNoPopListDelevery", formData);
	}
	
	//배송삭제
	public String updateSelectedDataDelevery(Map<String,String>  formData, List<Object> gridData){
			
		String rtnMsg = "OK";
		
		int wmsCount= sqlSessionTemplate.update("common.wmgi.updateMasterWmGiInvoiceNoPopListWIDTDelevery", formData);
		int cnt_ik_seq = gridData.size(); 
		int res_cnt = 0;
		if(wmsCount != cnt_ik_seq){
			rtnMsg = "배송확정삭제 오류 (UPDATE WMSIVDT) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO");
			throw new RuntimeException("배송확정삭제 오류 (UPDATE WMSIVDT) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO"));
		}
		res_cnt=  sqlSessionTemplate.update("common.wmgi.updateMasterWmGiInvoiceNoPopList_ICOMIVDTDelevery", formData);
		if(res_cnt != cnt_ik_seq){
			rtnMsg = "배송확정삭제 오류 (UPDATE ICOMIVDT) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO");
			throw new RuntimeException("배송확정삭제 오류 (UPDATE ICOMIVDT) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO"));
		}
		 
		res_cnt = sqlSessionTemplate.update("common.wmgi.updateMasterWmGiInvoiceNoPopList_ICOMPODTDelevery", formData);
		/* po항번 기준으로 분할이 발생하기때문에 의미 없음 2016년 5월31일 현명환
		if(res_cnt != cnt_ik_seq){
			rtnMsg = "배송확정삭제 오류 (UPDATE ICOMPODT) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO");
			throw new RuntimeException("배송확정삭제 오류 (UPDATE ICOMPODT) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO"));
		}*/
		for(int i=0; i < gridData.size(); i++){
			formData.putAll((Map<String,String>)gridData.get(i));
			if("1".equals(formData.get("PROCESS_TYPE"))||"3".equals(formData.get("PROCESS_TYPE"))){
				res_cnt = sqlSessionTemplate.update("common.wmgi.updateMasterWmGiInvoiceNoPopList_WMSSTCKDelevery", formData);
				if(res_cnt != 1){
					rtnMsg = "배송확정삭제 오류 (UPDATE WMSSTCK) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO");
					throw new RuntimeException("배송확정삭제 오류 (UPDATE WMSSTCK) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO"));
				}
			}

		}
		return rtnMsg;
	}
	
	
	//발주삭제
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData){
			
		String rtnMsg = "OK";

		int wmsCount= sqlSessionTemplate.update("common.wmgi.updateMasterWmGiInvoiceNoPopListWIDT", formData);
		int cnt_ik_seq = gridData.size(); 
			
		if(wmsCount != cnt_ik_seq){
			rtnMsg = "출고삭제 오류 (UPDATE WMSIVDT) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO");
			throw new RuntimeException("출고삭제 오류 (UPDATE WMSIVDT) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO"));
		}
		 sqlSessionTemplate.update("common.wmgi.updateMasterWmGiInvoiceNoPopList_ICOMIVDT", formData);
			 
		 sqlSessionTemplate.update("common.wmgi.updateMasterWmGiInvoiceNoPopList_ICOMPODT", formData);
		for(int i=0; i < gridData.size(); i++){
			formData.putAll((Map<String,String>)gridData.get(i));
			if("1".equals(formData.get("PROCESS_TYPE"))){
				int wmsstckCount  = sqlSessionTemplate.update("common.wmgi.updateMasterWmGiInvoiceNoPopList_WMSSTCK", formData);
				
				if(wmsstckCount != 1){
					rtnMsg = "출고삭제 오류 (UPDATE WMSSTCK) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO");
					throw new RuntimeException("출고삭제 오류 (UPDATE WMSSTCK) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO"));
				}
			}else if("3".equals(formData.get("PROCESS_TYPE"))){
				int wmsstckCount =  sqlSessionTemplate.update("common.wmgi.updateMasterWmGiInvoiceNoPopList_MSSTCK2", formData);
				
				if(wmsstckCount != 1){
					rtnMsg = "출고삭제 오류 (UPDATE WMSSTCK) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO");
					throw new RuntimeException("출고삭제 오류 (UPDATE WMSSTCK) ==> WAREHOUSE_CODE : " + formData.get("st_ware_house_code")+ ", BUYER : " + formData.get("st_buyer")+ ", INV_NO : " +  formData.get("st_IK_NO"));
				}
			}

			 
			
		}
		return rtnMsg;
	}
	
}
