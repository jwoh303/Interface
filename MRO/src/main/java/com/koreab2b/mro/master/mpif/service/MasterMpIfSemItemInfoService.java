package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIfSemItemInfoService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	/**
	 * 견적일 경우 품목정보를 수정한다.
	 * @param formData
	 * @param gridData
	 * @return
	 */
	public String updateSemItemInfo(Map<String,String>  formData, List<Object> gridData);
	/**
	 * 재견적 처리한다.
	 * @param formData
	 * @param gridData
	 * @return
	 */
	public String requotSemItemInfo(Map<String,String>  formData, List<Object> gridData);
	/**
	 * 견적을 취소한다
	 * @param formData
	 * @param gridData
	 * @return
	 */
	public String cancelQutSemItemInfo(Map<String,String>  formData, List<Object> gridData);
}
