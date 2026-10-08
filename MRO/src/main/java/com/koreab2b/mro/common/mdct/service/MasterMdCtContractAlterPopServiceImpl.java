package com.koreab2b.mro.common.mdct.service;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdct.controller.MasterMdCtStndrdContractDetailPopController;
import com.koreab2b.mro.common.mdct.dao.MasterMdCtContractAlterPopDao;

@Service("masterMdCtContractAlterPopService")
public class MasterMdCtContractAlterPopServiceImpl implements MasterMdCtContractAlterPopService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtStndrdContractDetailPopController.class);
	@Autowired
	private MasterMdCtContractAlterPopDao masterMdCtContractAlterPopDao;

	// 조회
	public Map<String,String> getList(Map<String,String> formData) {
		return masterMdCtContractAlterPopDao.selectList(formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		try {
		formData.put("st_content", setFormContractsInfo(String.valueOf(formData.get("st_oriContent")), String.valueOf(formData.get("st_inputData"))) );

		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("계약서 저장이 실패하였습니다.");
		}
		return masterMdCtContractAlterPopDao.updateSelectedData(formData);
	}
	
	public String setFormContractsInfo(String formContent, String inputData) throws Exception {
		if (null != inputData && inputData.length() > 0) {
			String[] temp = inputData.split("[|]");
			for (int i = 0; i < temp.length; i++) {
				String[] temp2 = temp[i].split("\\^");
				if(temp2[0].indexOf("Input") > -1){
  				formContent = convertTagToValue(formContent, temp2[0], temp2[1]);
  			}
			}
		}
		return formContent;
	}
	
	public String convertTagToValue(String sContent, String sFormNaMe, String sFormValue) throws Exception {
		String formType = "";
		if ("textInput".equals(sFormNaMe.substring(0, 9))) {
			formType = "<INPUT";
		} else if ("numbInput".equals(sFormNaMe.substring(0, 9))) {
			formType = "<INPUT";
		} else if ("dateInput".equals(sFormNaMe.substring(0, 9))) {
			formType = "<INPUT";
		} else if ("areaInput".equals(sFormNaMe.substring(0, 9))) {
			formType = "<TEXTAREA";
		} else if ("selcInput".equals(sFormNaMe.substring(0, 9))) {
			formType = "<SELECT";
		} else {
			formType = "<INPUT";
		}
    
		StringBuffer sbContent = new StringBuffer(sContent);
		String modFormType = "[[anchorIdx_" + sFormNaMe.substring(6) + "]]";
		int intStartPonit = 0;
		try {
			if ("<INPUT".equals(formType)) {
				int loopCount = 0;
				String strContent = sbContent.toString();
				while (strContent.indexOf(sFormNaMe) != -1) {
					strContent = sbContent.toString();
					int intStart = (strContent.toUpperCase()).indexOf(formType, intStartPonit);
					int intEnd = strContent.indexOf(">", intStart);
					int intMiddle = strContent.indexOf(sFormNaMe, intStart);
					if (intStart < intMiddle && intMiddle < intEnd) {
						sbContent.replace(intStart, intEnd + 1, modFormType);
					} else {
						intStartPonit = intStart + 6;
					}

					loopCount++;

					if (loopCount > 1000)
						throw new Exception("Loop Exception : over 1000");
				}
			} else if ("<TEXTAREA".equals(formType)) {
				intStartPonit = 0;
				int loopCount = 0;
				String strContent = sbContent.toString();
				while (sbContent.toString().indexOf(sFormNaMe) != -1) {
					strContent = sbContent.toString();
					int intStart = (strContent.toUpperCase()).indexOf(formType, intStartPonit);
					int intEnd = (strContent.toUpperCase()).indexOf("</TEXTAREA>", intStart);
					int intMiddle = strContent.indexOf(sFormNaMe, intStart);

					if (intStart < intMiddle && intMiddle < intEnd) {
						sbContent.replace(intStart, intEnd + 11, modFormType);
					} else {
						intStartPonit = intStart + 7;
					}
					loopCount++;
					if (loopCount > 1000)
						throw new Exception("Loop Exception : over 1000");
				}
			} else if ("<SELECT".equals(formType)) {
				intStartPonit = 0;
				int loopCount = 0;
				String sbString = sbContent.toString();
				while (sbContent.toString().indexOf(sFormNaMe) != -1) {
					sbString = sbContent.toString();
					int intStart = (sbString.toUpperCase()).indexOf(formType, intStartPonit);
					int intEnd = (sbString.toUpperCase()).indexOf("</SELECT>", intStart);
					int intMiddle = sbString.indexOf(sFormNaMe, intStart);
					if (intStart < intMiddle && intMiddle < intEnd) {
						sbContent.replace(intStart, intEnd + 9, modFormType);
					} else {
						intStartPonit = intStart + 9;
					}
					loopCount++;
					if (loopCount > 1000)
						throw new Exception("Loop Exception : over 1000");
				}
			}

			int count = 0;
			if (sbContent.toString().indexOf(modFormType) != -1) {
				int intStart = sbContent.toString().indexOf(modFormType);
				if (sFormValue == null) {
					sbContent.replace(intStart, intStart + modFormType.length(), "");
				} else {
					String changeValue = sFormValue;
					if (changeValue != null && "".equals(changeValue.trim()))
						changeValue = "&nbsp;";
					sbContent.replace(intStart, intStart + modFormType.length(), changeValue);
				}
				count++;
				if (count > 1000)
					throw new Exception("Loop Exception : over 1000");
			}
		} catch (Exception e) {

			throw e;
		}

		return sbContent.toString();
	}
}
