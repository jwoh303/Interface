/**
 * 
 */
package com.kep.hanssem.dao;

import java.util.List;
import java.util.Map;

/**
 * @author jiwon
 *
 */
public interface HanssemDao {	
	public List<Map<String,Object>> selectHanssemToken(Map<String,Object> target) throws Exception;
	public List<Map<String,Object>> selectHanssemAvailBdgtParam() throws Exception;
	public void insertHanssemAvailBdgt(Map<String,Object> availBdgtItem) throws Exception;
	public List<Map<String,Object>> selectHanssemBdgtParam() throws Exception;
	public void insertHanssemBdgt(Map<String,Object> bdgtItem) throws Exception;
	public void insertHanssemDtoA() throws Exception;
	public void insertHanssemDtoD() throws Exception;
	public void updateHanssemArSend(Map<String,Object> result) throws Exception;
	public List<Map<String,Object>> selectHanssemCcParam() throws Exception;
	public void insertHanssemCostCenter(Map<String,Object> cstCntrItem) throws Exception;	
	public void insertHanssemGLAccount(Map<String,Object> glAccntItem) throws Exception;
	public void updateHanssemGrSend(Map<String,Object> grItem) throws Exception;
	public void insertHanssemPoList(Map<String,Object> poLstItem) throws Exception;
	public void updateHanssemPoSend(Map<String,Object> poItem) throws Exception;
	public void insertHanssemUser(Map<String,Object> userItem) throws Exception;	
	public void execHanssemUserProc() throws Exception;
	public List<Map<String,Object>> selectHanssemTrxlPol() throws Exception;
	public void updateHanssemTrxlPol(Map<String,Object> result) throws Exception;
	public List<Map<String,Object>> selectHanssemArSend() throws Exception;
	public List<Map<String,Object>> selectHanssemPoSend() throws Exception;
	public List<Map<String,Object>> selectHanssemPoDate(Map<String,Object> poData) throws Exception;
	public List<Map<String,Object>> selectHanssemGrSend() throws Exception;
	public List<Map<String,Object>> selectHanssemGrDate() throws Exception;
	public List<Map<String,Object>> selectHanssemArDate() throws Exception;
	public void updateHanssemTrxlAvailBdgt(Map<String,Object> result) throws Exception;
	public void execHanssemAvailBdgtProc() throws Exception;
}
