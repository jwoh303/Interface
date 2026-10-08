package com.koreab2b.mro.buyer.mcsc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.buyer.mcsc.dao.BuyerMcScCustomerCenterDao;
import com.koreab2b.mro.util.DateTimeUtil;

@Service("BuyerMcScCustomerCenterServiceImpl")
public class BuyerMcScCustomerCenterServiceImpl implements BuyerMcScCustomerCenterService {

	@Autowired
	private BuyerMcScCustomerCenterDao buyerMcScCustomerCenterDao;

	// ========================================
	// 공지사항 관련
	// ========================================

	@Override
	public List<Map<String, String>> getNoticeListCommon(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.selectNoticeListCommon(formData);
	}

	@Override
	public List<Map<String, String>> getNoticeListCompany(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.selectNoticeListCompany(formData);
	}

	@Override
	public Map<String, String> getNoticeDetail(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.selectNoticeDetail(formData);
	}

	@Override
	public void markNoticeAsRead(Map<String, String> formData) {
		int count = buyerMcScCustomerCenterDao.selectNoticeReadCount(formData);
		if (count == 0) {
			buyerMcScCustomerCenterDao.insertNoticeReadLog(formData);
		}
	}

	@Override
	public int registerNotice(Map<String, String> formData) {
		// 날짜 설정
		formData.put("REG_DATE", DateTimeUtil.getFormatString("yyyyMMdd"));
		formData.put("REG_TIME", DateTimeUtil.getFormatString("HHmmss"));
		formData.put("BTYPE", "NT");

		// 공지사항 등록
		buyerMcScCustomerCenterDao.insertNotice(formData);

		// 대상 고객사 등록 (ALL_CUSTOMER_FLAG='N' 인 경우)
		String allCustomerFlag = formData.get("ALL_CUSTOMER_FLAG");
		if (!"Y".equals(allCustomerFlag)) {
			String codes = formData.get("st_open_company_code");
			String names = formData.get("st_open_company_name");
			if (codes != null && !"".equals(codes)) {
				String[] codeArr = codes.split("@");
				String[] nameArr = names != null ? names.split("@") : new String[0];
				for (int i = 0; i < codeArr.length; i++) {
					if (codeArr[i] != null && !"".equals(codeArr[i])) {
						Map<String, String> dtMap = new HashMap<String, String>();
						dtMap.put("BID", formData.get("BID"));
						dtMap.put("BTYPE", formData.get("BTYPE"));
						dtMap.put("COMPANY", formData.get("COMPANY"));
						dtMap.put("COM_CODE", codeArr[i]);
						dtMap.put("COM_NAME", i < nameArr.length ? nameArr[i] : "");
						dtMap.put("REG_DATE", formData.get("REG_DATE"));
						dtMap.put("REG_USER_ID", formData.get("REG_USER_ID"));
						buyerMcScCustomerCenterDao.insertNoticeCustomer(dtMap);
					}
				}
			}
		}

		// 파일 업로드 처리
		if (formData.get("IMAGE_KEY") != null && !"".equals(formData.get("IMAGE_KEY"))) {
			formData.put("DOC_NO", formData.get("IMAGE_KEY"));
		}

		return 1;
	}

	@Override
	public int updateNotice(Map<String, String> formData) {
		formData.put("BTYPE", formData.get("BTYPE") != null ? formData.get("BTYPE") : "NT");

		// 공지사항 수정
		buyerMcScCustomerCenterDao.updateNotice(formData);

		// 대상 고객사 삭제 후 재등록
		buyerMcScCustomerCenterDao.deleteNoticeCustomers(formData);

		String allCustomerFlag = formData.get("ALL_CUSTOMER_FLAG");
		if (!"Y".equals(allCustomerFlag)) {
			String codes = formData.get("st_open_company_code");
			String names = formData.get("st_open_company_name");
			if (codes != null && !"".equals(codes)) {
				String regDate = DateTimeUtil.getFormatString("yyyyMMdd");
				String[] codeArr = codes.split("@");
				String[] nameArr = names != null ? names.split("@") : new String[0];
				for (int i = 0; i < codeArr.length; i++) {
					if (codeArr[i] != null && !"".equals(codeArr[i])) {
						Map<String, String> dtMap = new HashMap<String, String>();
						dtMap.put("BID", formData.get("BID"));
						dtMap.put("BTYPE", formData.get("BTYPE"));
						dtMap.put("COMPANY", formData.get("COMPANY"));
						dtMap.put("COM_CODE", codeArr[i]);
						dtMap.put("COM_NAME", i < nameArr.length ? nameArr[i] : "");
						dtMap.put("REG_DATE", regDate);
						dtMap.put("REG_USER_ID", formData.get("REG_USER_ID"));
						buyerMcScCustomerCenterDao.insertNoticeCustomer(dtMap);
					}
				}
			}
		}

		return 1;
	}

	@Override
	public int deleteNotice(Map<String, String> formData) {
		formData.put("BTYPE", formData.get("BTYPE") != null ? formData.get("BTYPE") : "NT");
		return buyerMcScCustomerCenterDao.deleteNotice(formData);
	}

	// ========================================
	// 1:1 문의(VOC) 관련 - KEPAVCDT
	// ========================================

	@Override
	public List<Map<String, String>> getInquiryList(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.selectInquiryList(formData);
	}

	@Override
	public Map<String, String> getInquiryDetail(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.selectInquiryDetail(formData);
	}

	@Override
	public List<Map<String, String>> getQtypeCodeList(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.selectQtypeCodeList(formData);
	}

	@Override
	public int cancelInquiry(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.deleteInquiry(formData);
	}

	@Override
	public int markInquiryAsRead(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.updateInquiryRead(formData);
	}

	// ========================================
	// 내부 공지사항 관련 (BUYERBOARD)
	// ========================================

	@Override
	public List<Map<String, String>> getInternalNoticeList(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.selectInternalNoticeList(formData);
	}

	@Override
	public Map<String, String> getInternalNoticeDetail(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.selectInternalNoticeDetail(formData);
	}

	@Override
	public int registerInternalNotice(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.insertInternalNotice(formData);
	}

	@Override
	public int updateInternalNotice(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.updateInternalNotice(formData);
	}

	@Override
	public int deleteInternalNotice(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.deleteInternalNotice(formData);
	}

	@Override
	public void markInternalNoticeAsRead(Map<String, String> formData) {
		// BID 재사용으로 등록일 이전의 옛 읽음로그가 남아있을 수 있어 항상 upsert 한다.
		// (insertBuyerInternalNoticeReadLog는 MERGE로, 기존 로그가 있으면 READ_DATE를 현재일자로 갱신)
		buyerMcScCustomerCenterDao.insertInternalNoticeReadLog(formData);
	}

	// ========================================
	// 고객사 메인 : 미확인 공지(일반+내부) 건수
	// ========================================

	@Override
	public Map<String, Object> getBuyerUnreadNoticeCount(Map<String, String> formData) {
		return buyerMcScCustomerCenterDao.selectBuyerUnreadNoticeCount(formData);
	}

}
