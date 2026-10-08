package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIfSecItemInfoService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	/**
	 * 품목처리 이벤트 삭제
	 * @param formData
	 * @param gridData
	 * @return
	 */
	public String deleteSecItemInfo(Map<String,String>  formData, List<Object> gridData);
	/**
	 * 견적일 경우 품목정보를 수정한다.
	 * @param formData
	 * @param gridData
	 * @return
	 */
	public String updateSecItemInfo(Map<String,String>  formData, List<Object> gridData);
	/**
	 * 재견적 처리한다.
	 * @param formData
	 * @param gridData
	 * @return
	 */
	public String requotSecItemInfo(Map<String,String>  formData, List<Object> gridData);
	/**
	 * 품목등록 이벤트를 다시 등록한다.
	 * @param formData
	 * @param gridData
	 * @return
	 */
	public String registSecItemInfo(Map<String,String>  formData, List<Object> gridData);
	/**
	 * 견적을 취소한다
	 * @param formData
	 * @param gridData
	 * @return
	 */
	public String cancelQutSecItemInfo(Map<String,String>  formData, List<Object> gridData);
	
	/**
	 * 미회신 단가를 재전송한다.
	 * @param formData
	 * @param gridData
	 * @return
	 */
	public String resendPriceSecItemInfo(Map<String,String>  formData, List<Object> gridData);
}
