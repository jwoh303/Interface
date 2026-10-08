package com.koreab2b.mro.seller.mpiv.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpiv.dao.SellerMpIvMkImScheduleRegDao;

@Service("sellerMpIvMkImScheduleRegService")
public class SellerMpIvMkImScheduleRegServiceImpl implements SellerMpIvMkImScheduleRegService {

	@Autowired
	private SellerMpIvMkImScheduleRegDao sellerMpIvMkImScheduleRegDao;

	/**
	 * 조회
	 * 
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> getList(Map<String, String> pMap) {
		return sellerMpIvMkImScheduleRegDao.selectList(pMap);
	}

	public List<Map<String, String>> getPopupList(Map<String, String> pMap) {
		return sellerMpIvMkImScheduleRegDao.selectPopupList(pMap);
	}

	public int saveMkImScheduleReg(Map<String, String> formData) {
		int totalCnt = Integer.parseInt(formData.get("total_cnt"));
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		Map<String, String> map = null;
		for (int i = 1; i <= totalCnt; i++) {
			map = new HashMap<String, String>();
			if (!"".equals(formData.get("st_mk_date" + i))) {
				map.putAll(formData);
				map.put("st_mk_date", formData.get("st_mk_date" + i));
				map.put("st_mk_type", formData.get("st_mk_type" + i));
				map.put("st_mk_seq", formData.get("st_mk_seq" + i));
				map.put("st_admin_image_key", formData.get("st_admin_image_key" + i));
				map.put("st_admin_remark", formData.get("st_admin_remark" + i));
				map.put("st_admin_check", formData.get("st_admin_check"+i));
				map.put("st_agent_image_key", formData.get("st_agent_image_key" + i));
				map.put("st_agent_remark", formData.get("st_agent_remark" + i));
				map.put("st_agent_check", formData.get("st_agent_check"+i));
				list.add(map);
			}
		}
		return sellerMpIvMkImScheduleRegDao.saveMkImScheduleReg(list);
	}

	public int saveMkImScheduleUpdate(Map<String, String> formData) {
		return sellerMpIvMkImScheduleRegDao.saveMkImScheduleUpdate(formData);
	}

}
