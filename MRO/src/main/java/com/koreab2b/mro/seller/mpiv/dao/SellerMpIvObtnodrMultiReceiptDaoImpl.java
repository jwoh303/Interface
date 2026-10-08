package com.koreab2b.mro.seller.mpiv.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("sellerMpIvObtnodrMultiReceiptDao")
@Transactional
public class SellerMpIvObtnodrMultiReceiptDaoImpl implements SellerMpIvObtnodrMultiReceiptDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> param) {

		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		
		sqlSessionTemplate.select("seller.mpiv.selectSellerMpIvObtnodrMultiReceiptList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	public List<Map<String,String>> selectExcelList(Map<String,String> param) {

		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvObtnodrMultiReceiptList", param);
	}

	// 수주접수 저장
	@SuppressWarnings("unchecked")
	public String saveSellerMpIvObtnodrMultiReceiptList(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "";
		List<Map<String,String>>_list = null;
		
		try{

			formData.putAll((Map<String, String>)gridData.get(0));		
			
			_list = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivObtnodrReceiptOrderCheck",formData);
			
			String check_flag = CommonUtil.getListKeyValue(_list,"DUP_CNT","0");

			if(check_flag.equals("0")){
				String po_seq = "";
				String admin_flag1 = "Y";
				for(int i=0; i < gridData.size(); i++){
					List<Map<String,String>>_list2 = null;					
					formData.putAll((Map<String, String>)gridData.get(i));
					//여신한도 초과시 수주접수 불가능.
					_list2 = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivCreditLimitSttsCheck",formData);
					String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
					if(credit_limit_flag.equals("Y")){
						_rtnMsg = "수주접수가 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
								+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
						throw new RuntimeException(_rtnMsg);
						
					}
					// 납기요청일이 납품예정일보다 이전이면 admin_flag1값을 N으로 입력
					if(Integer.parseInt(CommonUtil.nvl(formData.get("rd_date"),"0")) < Integer.parseInt(CommonUtil.nvl(formData.get("st_ds_date"),"0"))){
						admin_flag1 = "N";	
					}
					
					formData.put("admin_flag1", admin_flag1);
					
					sqlSessionTemplate.insert("common.mpiv.insertSellerMpivObtnodrReceiptOrder", formData);
					
					if(!po_seq.equals(formData.get("st_po_seq"))){
						po_seq = formData.get("st_po_seq");
						
						// ICOMPODT 발주제품정보 update
						sqlSessionTemplate.update("common.mpiv.updateSellerMpivObtnodrProductInfo",formData);
					}
				}
				
				// ICOMPOHD 발주마스터정보 update
				sqlSessionTemplate.update("common.mpiv.updateSellerMpivObtnodrMasterInfo",formData);
				
				Map<String,String> _pMap2 = new HashMap<String,String>();
				
				_pMap2.put("BUYER",formData.get("st_buyer"));
				_pMap2.put("PO_NO", formData.get("st_po_no"));
				_pMap2.put("CODE", "PO_RECV_SB");
				_pMap2.put("USER_ID",formData.get("st_user_id"));		

				buyerMpSoOrderInfoDao.call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO(_pMap2); // 메일 발송 패키지

			} else {
				_rtnMsg = "이미 수주 접수가 완료된 발주건 입니다.";
				throw new RuntimeException(_rtnMsg);
			}	

		}catch(Exception e){
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
		
	}
}
