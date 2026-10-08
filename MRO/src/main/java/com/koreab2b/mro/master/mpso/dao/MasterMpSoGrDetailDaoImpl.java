package com.koreab2b.mro.master.mpso.dao;

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
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpSoGrDetailDao")
@Transactional
public class MasterMpSoGrDetailDaoImpl implements MasterMpSoGrDetailDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoGrDetailDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> searchMasterMpSoGrDetailList(Map<String,Object> param) {
		
		//고객사
		List<String> st_buyer_codeList = CommonUtil.getStringArrary((String) param.get("st_buyer_code"), "@");
		param.put("st_buyer_codeList", st_buyer_codeList);	
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mpso.selectMasterMpSoGrDetailList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> searchMasterMpSoGrDetailList_v2(Map<String,Object> param) {
		
		//고객사
		List<String> st_buyer_codeList = CommonUtil.getStringArrary((String) param.get("st_buyer_code"), "@");
		param.put("st_buyer_codeList", st_buyer_codeList);	
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mpso.selectMasterMpSoGrDetailList_v2", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	// 입고취소
	@SuppressWarnings("unchecked")
	@Transactional
	public String setNewGrDelChange_Item(Map<String,String>  formData, List<Object> gridData){
		
		_rtnMsg = "입고취소 완료되었습니다.";
		List<Map<String,String>> list = null;
		Map<String,String> _data = null;
		String processType = "";
		String check_qty = "";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
								
				String check_flag = sqlSessionTemplate.selectOne("master.mpso.getGrCloseCheck", formData);
				
				if(check_flag.equals("0")){
					list = sqlSessionTemplate.selectList("master.mpso.setNewGrDel_Item1", formData);
					list = CommonUtil.getListNvl(list);
					_data = new HashMap<String,String>() ;
					_data = list.get(0);
					formData.put("PROCESS_TYPE", _data.get("PROCESS_TYPE"));
					formData.put("WAREHOUSE_CODE", _data.get("WAREHOUSE_CODE"));
					processType =  _data.get("PROCESS_TYPE");
					 
					sqlSessionTemplate.update("master.mpso.setNewGrDel_Item3", formData); // ICOMGRDT				
					sqlSessionTemplate.update("master.mpso.setNewGrDel_Item4", formData); // ICOMPODT
					
					if("0".equals(processType)){ //  0:직납 1:물류창고 2:TR 3:VMI 4:고객위탁재고
						sqlSessionTemplate.update("master.mpso.setNewGrDel_Item5", formData); // ICOMIVDT
					}else{
						sqlSessionTemplate.update("master.mpso.setNewGrDel_Item2", formData); // WMSIVDT
					}
					
					//차파트너스인 경우 추가로직 실행
					boolean p070000025 = CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P07-0000025");
					if(p070000025) {
						//해당 품목이 재고테이블에 존재하는지 확인
						String check = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoGrDetailCarStockGrdtCheck", formData);
						if(!check.equals("0")){ //car_stock_grdt 에 해당 gr_no 정보가 있는 경우에만 나머지 특수로직 실행
							
							//(기존입고수량 - 취소하려는 입고수량)-출고수량 < 0 이 되면 안됨  
							check_qty = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoGrDetailCarStockCheckQty", formData);
							if(Integer.parseInt(check_qty) < 0) {
								_rtnMsg = "남은 재고수량보다 많은 수량을 취소할 수 없습니다.\n확인해주시기 바랍니다.";
								throw new RuntimeException(_rtnMsg);
							}
							
							//재고테이블에서 마이너스 처리
							sqlSessionTemplate.update("master.mpso.updateMasterMpSoGrDetailCarStockMinus", formData);
							//이력테이블 삭제 처리
							sqlSessionTemplate.update("master.mpso.updateMasterMpSoGrDetailCarStockGrdt", formData);
						}

					}
				}else{
					throw new RuntimeException();
				}
			}
			
		}catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "입고취소에 실패하였습니다.\\n마감여부를 확인하여 주시기 바랍니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	@Transactional
	public String setNewGrDelChange_Item_v2(Map<String,String>  formData, List<Object> gridData){
		
		_rtnMsg = "입고취소 완료되었습니다.";
		List<Map<String,String>> list = null;
		Map<String,String> _data = null;
		String processType = "";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
								
				String check_flag = sqlSessionTemplate.selectOne("master.mpso.getGrCloseCheck_v2", formData);
				
				if(check_flag.equals("0")){
					list = sqlSessionTemplate.selectList("master.mpso.setNewGrDel_Item1", formData);
					list = CommonUtil.getListNvl(list);
					_data = new HashMap<String,String>() ;
					_data = list.get(0);
					formData.put("PROCESS_TYPE", _data.get("PROCESS_TYPE"));
					formData.put("WAREHOUSE_CODE", _data.get("WAREHOUSE_CODE"));
					processType =  _data.get("PROCESS_TYPE");
					 
					sqlSessionTemplate.update("master.mpso.setNewGrDel_Item3_v2", formData); // ICOMGRDT				
					sqlSessionTemplate.update("master.mpso.setNewGrDel_Item4", formData); // ICOMPODT
					
					if("0".equals(processType)){ //  0:직납 1:물류창고 2:TR 3:VMI 4:고객위탁재고
						sqlSessionTemplate.update("master.mpso.setNewGrDel_Item5", formData); // ICOMIVDT
					}else{
						sqlSessionTemplate.update("master.mpso.setNewGrDel_Item2", formData); // WMSIVDT
					}
				}else{
					throw new RuntimeException();
				}
			}
			
		}catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if(_rtnMsg.equals("")){
				_rtnMsg = "입고취소에 실패하였습니다.\\n마감여부를 확인하여 주시기 바랍니다.";
			}
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	@Transactional
	public String saveMasterMpSoGrDetailList(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "저장 완료되었습니다.";
		List<Map<String,String>> list = null;
		Map<String,String> _data = null;
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				String check_flag = sqlSessionTemplate.selectOne("master.mpso.getGrCloseCheck", formData);
				
				if(check_flag.equals("0")){
					list = sqlSessionTemplate.selectList("master.mpso.setNewGrDel_Item1", formData);
					list = CommonUtil.getListNvl(list);
					_data = new HashMap<String,String>() ;
					_data = list.get(0);
					if(_data.get("PROCESS_TYPE").equals("0")){
						sqlSessionTemplate.update("master.mpso.updateMpSoIvhdImageKey", formData); // 배송증빙 변경 직납
					}else{
						sqlSessionTemplate.update("master.mpso.updateMpSoWmsImageKey", formData); // 배송증빈변경 직납이외
					}
					sqlSessionTemplate.update("master.mpso.updateGrCloseList", formData); // 입고일, 정산담당자, 정산담당자이메일
				}else{
					throw new RuntimeException();
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.\n마감여부를 확인하여 주시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	@Transactional
	public String saveMasterMpSoGrDetailList_v2(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "저장 완료되었습니다.";
		List<Map<String,String>> list = null;
		Map<String,String> _data = null;
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				String check_flag = sqlSessionTemplate.selectOne("master.mpso.getGrCloseCheck_v2", formData);
				
				if(check_flag.equals("0")){
					list = sqlSessionTemplate.selectList("master.mpso.setNewGrDel_Item1", formData);
					list = CommonUtil.getListNvl(list);
					_data = new HashMap<String,String>() ;
					_data = list.get(0);
					if(_data.get("PROCESS_TYPE").equals("0")){
						sqlSessionTemplate.update("master.mpso.updateMpSoIvhdImageKey", formData); // 배송증빙 변경 직납
					}else{
						sqlSessionTemplate.update("master.mpso.updateMpSoWmsImageKey", formData); // 배송증빈변경 직납이외
					}
					sqlSessionTemplate.update("master.mpso.updateGrCloseList", formData); // 입고일, 정산담당자, 정산담당자이메일
					
				}else{
					throw new RuntimeException();
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.\n마감여부를 확인하여 주시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
}