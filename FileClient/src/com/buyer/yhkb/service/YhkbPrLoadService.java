package com.buyer.yhkb.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.buyer.yhkb.dao.YhkbPrDao;
import com.kep.common.CommonUtil;
import com.kep.common.service.FileService;
import com.kep.common.vo.PrdtVo;

public class YhkbPrLoadService extends FileService implements Runnable {
	private YhkbPrDao dao = new YhkbPrDao();
	@Override
	public void run() {
		boolean isBreak = false;
		
		try {
			String path = hdInfo.get("FOLDER");
			String prefix = hdInfo.get("PREFIX");
			String charset = hdInfo.get("CHARSET");
			List<String> fList = fUtil.getFileList(path, prefix);
			
			if (fList.size() > 0) {
				for(String fName : fList) {
					try {
						logInfo("file info : " + fName);
						List<String> fContent = fUtil.getFileContent(path, fName, charset);
						int lineCnt = 0;
						int totCnt = 0;
						int eCnt = 0;
						this.prList.clear();
						
						for(String line : fContent) {
							String gubun = line.substring(0, 1);
							PrdtVo item = (PrdtVo) convertStringToVo(line, new PrdtVo());
							
							if ("5".equals(gubun)) {
								lineCnt++;
								String plant = item.getPLANT();
								
								if ("5133".equals(plant)) {
									item.setBUYER("KRYUHA0010");
								} else if ("5134".equals(plant)) {
									item.setBUYER("KRYUHA0011");
								} else if ("5132".equals(plant)) {
									item.setBUYER("KRYUHA0013");
								} else if ("5130".equals(plant)) {
									item.setBUYER("KRYUHA0012");
								} else if ("5151".equals(plant)) {
									item.setBUYER("KRUHAN0004");
								} else if ("5131".equals(plant)) {
									item.setBUYER("KRUHAN0003");
								} else {
									item.setBUYER("KRUHAN0010");
								}
								
								item.setFILE_NAME(fName);
								item.setREVISION("1");
								item.setSTATUS("C");
								item.setIF_FLAG("N");
								int buyer_item_no = Integer.valueOf(item.getBUYER_ITEM_NO());
								item.setBUYER_ITEM_NO(Integer.toString(buyer_item_no));
								
								Map <String, String> cMap = dao.SelectIcomcqdt(item);
	//							double total = Double.valueOf(String.valueOf(cMap.get("UNIT_PRICE"))) * Double.valueOf(item.getITEM_QTY());
								int total = Double.valueOf(String.valueOf(cMap.get("UNIT_PRICE"))).intValue() * Double.valueOf(item.getITEM_QTY()).intValue();
								
								String item_qty[] = item.getITEM_QTY().split("\\.");
								String total_amt[] = String.valueOf(total).split("\\.");
								
								item.setITEM_QTY(item_qty[0]);
								item.setITEM_AMT(Integer.toString(total));
								
								this.prList.add(item);
							}
						}
						
						if (lineCnt > 0 ) {
							
							String ifChkFlag = "N";
							String prevKey = "";
							PrdtVo pItem = null;
							
							for(PrdtVo item : this.prList) {
								String nextKey = item.getBUYER() + item.getLEGACY_PR_NO() + item.getREVISION();
								System.out.println("item.getITEM_QTY() = "+item.getITEM_QTY());
								if(  !prevKey.equals(nextKey)) {
									if(!"".equals(prevKey)) {
										Map<String, String> lMap = new HashMap<String, String>();
										lMap.put("BUYER", pItem.getBUYER());
										lMap.put("GUBUN", "PR");
										lMap.put("LEGACY_NO", pItem.getLEGACY_PR_NO());
										lMap.put("REVISION", pItem.getREVISION());
										lMap.put("FILE_NAME", pItem.getFILE_NAME());
										lMap.put("IF_CHK_FLAG", ifChkFlag);
										
										dao.logWrite(lMap);
									}
									pItem = item;
									prevKey = nextKey;
								}
								// if_podt 생성 및 변경
								boolean bRtn = dao.insertYhkbPr(item);
								if (bRtn == false ) {
									ifChkFlag = "E";
									eCnt++;
									logError("ICOMTRXL_InsertFile Insert Error [ "+item.getLEGACY_PR_NO()+" / "+item.getLEGACY_PR_SEQ()+  " ]");
								}	
								
								
							}
							Map<String, String> lMap = new HashMap<String, String>();
							lMap.put("BUYER", pItem.getBUYER());
							lMap.put("GUBUN", "PR");
							lMap.put("LEGACY_NO", pItem.getLEGACY_PR_NO());
							lMap.put("REVISION", pItem.getREVISION());
							lMap.put("FILE_NAME", pItem.getFILE_NAME());
							lMap.put("IF_CHK_FLAG", ifChkFlag);
							
							dao.logWrite(lMap);
							
							logInfo("Result : TotCnt["+totCnt+"], ErrCnt["+eCnt+"], File:" + path + "/" + fName);
						} else {
							// 비정상 처리.
							logError("File Error LineCnt["+lineCnt+"] / TotCnt["+totCnt+"] " + path + "/" + fName);
							isBreak = true;
						}
						// move back
						fUtil.moveBack(path, fName);
						logInfo("file Success : " + fName );
						// 정지여부.
						if (isBreak) break;
					}catch (Exception e) {
						logError(CommonUtil.printStackTraceToString(e));
						logInfo(CommonUtil.printStackTraceToString(e));
					}
				}
			}	
		}catch (Exception e) {
			logError(CommonUtil.printStackTraceToString(e));
			logInfo(CommonUtil.printStackTraceToString(e));
		}
		
	}
}
