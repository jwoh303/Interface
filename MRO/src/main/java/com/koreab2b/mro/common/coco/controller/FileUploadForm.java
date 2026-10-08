package com.koreab2b.mro.common.coco.controller;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class FileUploadForm {
	private List<MultipartFile> files;
	private List<MultipartFile> files1;
	private List<MultipartFile> files2;
	private List<MultipartFile> files3;

	// Getter and setter methods}

	public List<MultipartFile> getFiles() {
		return files;
	}

	public void setFiles(List<MultipartFile> pFiles) {
		files = pFiles;
	}
	
	public List<MultipartFile> getFiles1() {
		return files1;
	}

	public void setFiles1(List<MultipartFile> pFiles) {
		files1 = pFiles;
	}
	
	public List<MultipartFile> getFiles2() {
		return files2;
	}

	public void setFiles2(List<MultipartFile> pFiles) {
		files2 = pFiles;
	}
	
	public List<MultipartFile> getFiles3() {
		return files3;
	}

	public void setFiles3(List<MultipartFile> pFiles) {
		files3 = pFiles;
	}
}
