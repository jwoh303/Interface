package com.koreab2b.mro.common.mpso.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonInfoDao;
import com.koreab2b.mro.common.mpso.dao.MasterMpSoIssueManageRemarkPopDao;

@Service("masterMpSoMpSoIssueManageScmRemarkPopService")
public class MasterMpSoIssueManageRemarkPopServiceImpl implements MasterMpSoIssueManageRemarkPopService {
	
	@Autowired
	private MasterMpSoIssueManageRemarkPopDao masterMpSoIssueManageRemarkPopDao;
	@Autowired
	private CommonInfoDao commonInfoDao;

	@Override
	public Map<String, String> RemarkPopItem(Map<String, String> formData) {
		return masterMpSoIssueManageRemarkPopDao.selectCqDt(formData);
	}

	@Override
	public Map<String, String> RemarkPopPOHD(Map<String, String> formData) {
		return masterMpSoIssueManageRemarkPopDao.selectPoHd(formData);
	}

	@Override
	public List<Map<String, String>> RemarkPopIVDT(Map<String, String> formData) {
		return masterMpSoIssueManageRemarkPopDao.selectIvDt(formData);
	}


	@Override
	public List<Map<String, String>> RemarkPopPOMN(Map<String, String> formData) {
		return masterMpSoIssueManageRemarkPopDao.selectPoMn(formData);
	}

	@Override
	public List<Map<String, String>> getList(Map<String, Object> formData) {
		return masterMpSoIssueManageRemarkPopDao.selectList(formData);
	}

	// 거래명세서 불러오기
	@Override
	public Map<String, String> RemakrRPTURL(Map<String, String> formData) {
			Map<String, String> data = masterMpSoIssueManageRemarkPopDao.selectRptInfo(formData);
			Map<String,String> map = new HashMap<String, String>();
			map.putAll(data);
			map.put("USER_ID", formData.get("st_user_id"));
	    	map.put("BUYER", formData.get("st_buyer"));
	    	map.put("PO_NO", formData.get("st_po_no"));
	    	map.put("GBN", ""); // 거래명세서 작성여부 ( 작성일경우 : WR, 아닐경우 : "")
			// 특수로직데이터를 이용해서 레포트 url 조회
	    	String rpt_url = commonInfoDao.selectRptUrl(map);
	    	
	    	data.put("RPT_URL", rpt_url);
			return data;
	}
	
	// 저장
	public String saveRemark(Map<String,String>  formData){
		return masterMpSoIssueManageRemarkPopDao.updateRemark(formData);
	}

	@Override
	public String saveMemo(Map<String, String> formData) {
		return masterMpSoIssueManageRemarkPopDao.insertMemo(formData);
	}

}

