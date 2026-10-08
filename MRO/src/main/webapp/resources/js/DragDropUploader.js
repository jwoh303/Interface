/**
 * DragDropUploader.js
 * 파일 드래그앤드롭 업로드 유틸리티
 *
 * 사용법:
 * var uploader = new DragDropUploader({
 *     dropZoneId: 'msdsFileDropZone',        // 드롭존 ID (필수)
 *     fileListId: 'msdsFileListContainer',   // 파일 리스트 컨테이너 ID (필수)
 *     uploadButtonSelector: '.ButMSmallDarkGray',  // 파일찾기 버튼 선택자 (필수)
 *     maxFiles: 3,                            // 최대 파일 개수 (기본값: 3)
 *     maxFileSize: 50 * 1024 * 1024,         // 최대 파일 크기 (기본값: 50MB)
 *     allowedExtensions: ['doc', 'docx', 'txt', 'pdf', 'jpg', 'jpeg', 'gif', 'png', 'xls', 'xlsx', 'zip'],  // 허용 확장자
 *     container: $('#msdsPopupContainer')     // 컨테이너 (이벤트 위임용, 선택사항)
 * });
 *
 * // 업로드된 파일 목록 가져오기
 * var files = uploader.getUploadedFiles();
 *
 * // 파일 개수 확인
 * var count = uploader.getFileCount();
 *
 * // 파일 초기화
 * uploader.reset();
 */

(function(window) {
    'use strict';

    /**
     * DragDropUploader 생성자
     * @param {Object} options - 설정 옵션
     */
    function DragDropUploader(options) {
        // 필수 파라미터 검증
        if (!options || !options.dropZoneId || !options.fileListId || !options.uploadButtonSelector) {
            throw new Error('[DragDropUploader] dropZoneId, fileListId, uploadButtonSelector는 필수입니다.');
        }

        // 기본 설정
        this.config = {
            dropZoneId: options.dropZoneId,
            fileListId: options.fileListId,
            uploadButtonSelector: options.uploadButtonSelector,
            maxFiles: options.maxFiles || 3,
            maxFileSize: options.maxFileSize || (50 * 1024 * 1024), // 기본값: 50MB
            allowedExtensions: options.allowedExtensions || ['doc', 'docx', 'txt', 'pdf', 'jpg', 'jpeg', 'gif', 'png', 'xls', 'xlsx', 'zip'],
            container: options.container || $(document),  // jQuery 컨테이너 (이벤트 위임용)
            customMaxFilesMessage: options.customMaxFilesMessage || null,  // 커스텀 파일 개수 제한 메시지
            onFileAdded: options.onFileAdded || null,     // 파일 추가 콜백
            onFileRemoved: options.onFileRemoved || null, // 파일 삭제 콜백
            onFileCountChange: options.onFileCountChange || null  // 파일 개수 변경 콜백
        };

        // DOM 요소 참조
        this.$dropZone = $('#' + this.config.dropZoneId);
        this.$fileList = $('#' + this.config.fileListId);
        this.$uploadButton = this.config.container.find(this.config.uploadButtonSelector);
        this.$container = this.config.container;

        // DOM 요소 존재 확인
        if (!this.$dropZone.length) {
            throw new Error('[DragDropUploader] 드롭존을 찾을 수 없습니다: ' + this.config.dropZoneId);
        }
        if (!this.$fileList.length) {
            throw new Error('[DragDropUploader] 파일 리스트 컨테이너를 찾을 수 없습니다: ' + this.config.fileListId);
        }

        // 업로드된 파일 배열 (File 객체 저장)
        this.uploadedFiles = [];

        // 삭제된 서버 파일 목록 (수정 모드에서 사용)
        this.deletedServerFiles = [];

        // 공유 파일 키 (여러 파일이 동일 DOC_NO로 관리)
        this.sharedFileKey = null;

        // 초기화
        this.init();

        console.log('[DragDropUploader] 초기화 완료');
    }

    /**
     * 초기화
     */
    DragDropUploader.prototype.init = function() {
        this.bindDragDropEvents();
        this.bindFileButtonEvent();
        this.bindDeleteEvent();
        this.toggleDisplayByFileCount();
    };

    /**
     * 파일 개수에 따라 드롭존/리스트 표시 전환
     */
    DragDropUploader.prototype.toggleDisplayByFileCount = function() {
        // 삭제 예정 파일 제외하고 실제 파일만 카운트
        var displayedFileCount = this.$fileList.find('.UploaderListImg:not(.deleted)').length;

        if (displayedFileCount > 0) {
            this.$dropZone.hide();
            this.$fileList.show();
            console.log('[DragDropUploader] 파일 목록 표시 (총 ' + displayedFileCount + '개, 삭제 예정 제외)');
        } else {
            this.$dropZone.show();
            this.$fileList.hide();
            console.log('[DragDropUploader] 드롭존 표시 (파일 없음)');
        }
    };

    /**
     * 파일 확장자 추출
     */
    DragDropUploader.prototype.getFileExtension = function(filename) {
        return filename.slice((filename.lastIndexOf('.') - 1 >>> 0) + 2).toLowerCase();
    };

    /**
     * 파일 검증
     */
    DragDropUploader.prototype.validateFile = function(file) {
        var ext = this.getFileExtension(file.name);

        // ========== 디버깅 로그 (문제 해결 후 삭제) ==========
        console.log('=== 파일 검증 디버깅 ===');
        console.log('file.name:', file.name);
        console.log('file.name 길이:', file.name.length);
        console.log('file.name charCodes:', Array.from(file.name).map(function(c) { return c.charCodeAt(0); }));
        console.log('추출된 확장자:', ext);
        console.log('확장자 길이:', ext.length);
        console.log('확장자 charCodes:', Array.from(ext).map(function(c) { return c.charCodeAt(0); }));
        console.log('허용 확장자 목록:', this.config.allowedExtensions);
        console.log('확장자 포함 여부:', this.config.allowedExtensions.indexOf(ext));
        console.log('========================');

        // 확장자 검증 (빈 배열이면 모든 확장자 허용)
        if (this.config.allowedExtensions.length > 0 && this.config.allowedExtensions.indexOf(ext) === -1) {
            alert('허용되지 않는 파일 형식입니다.\n허용 확장자: ' + this.config.allowedExtensions.join(', '));
            return false;
        }

        // 파일 크기 검증
        if (file.size > this.config.maxFileSize) {
            var maxSizeMB = Math.floor(this.config.maxFileSize / (1024 * 1024));
            var fileSizeMB = (file.size / (1024 * 1024)).toFixed(2);
            alert('파일 크기가 너무 큽니다.\n파일: ' + file.name + ' (' + fileSizeMB + 'MB)\n최대 크기: ' + maxSizeMB + 'MB');
            return false;
        }

        // 중복 검증
        for (var i = 0; i < this.uploadedFiles.length; i++) {
            if (this.uploadedFiles[i].name === file.name) {
                alert('이미 등록된 파일입니다: ' + file.name);
                return false;
            }
        }

        // 개수 제한 - 기존 서버 파일 + 신규 파일 총합으로 검사
        var existingFileCount = this.$fileList.find('.UploaderListImg[data-existing="true"]:not(.deleted)').length;
        var totalFileCount = existingFileCount + this.uploadedFiles.length;

        if (totalFileCount >= this.config.maxFiles) {
            var message = this.config.customMaxFilesMessage || ('최대 ' + this.config.maxFiles + '개까지 등록가능합니다.');
            alert(message);
            return false;
        }

        return true;
    };

    /**
     * 파일 아이콘 선택 (이미지/문서)
     */
    DragDropUploader.prototype.getFileIcon = function(filename) {
        var ext = this.getFileExtension(filename);
        var imageExts = ['jpg', 'jpeg', 'gif', 'png'];

        if (imageExts.indexOf(ext) !== -1) {
            return '/resources/imgs/Add_img.png';
        } else {
            return '/resources/imgs/Add_file.png';
        }
    };

    /**
     * 파일 리스트에 추가 (UI만 표시, 서버 업로드 X)
     */
    DragDropUploader.prototype.addFileToList = function(file) {
        var ext = this.getFileExtension(file.name);
        var icon = this.getFileIcon(file.name);
        var fileName = file.name.replace('.' + ext, ''); // 확장자 제거

        // 파일 아이템 HTML 생성
        var fileHtml =
            '<div class="UploaderListImg" data-filename="' + file.name + '">' +
            '    <img class="Delete" src="/resources/imgs/delete_02.png" />' +
            '    <img class="img" src="' + icon + '" />' +
            '    <div class="Txt"><p>' + fileName + '</p><span>.' + ext + '</span></div>' +
            '</div>';

        this.$fileList.append(fileHtml);

        // File 객체만 배열에 저장
        this.uploadedFiles.push({
            file: file,
            name: file.name,
            size: file.size
        });

        // 표시 전환
        this.toggleDisplayByFileCount();

        // 콜백 실행
        if (this.config.onFileAdded) {
            this.config.onFileAdded(file);
        }
        if (this.config.onFileCountChange) {
            this.config.onFileCountChange(this.uploadedFiles.length);
        }

        console.log('[DragDropUploader] 파일 추가:', file.name, '(총 ' + this.uploadedFiles.length + '개)');
    };

    /**
     * 파일 처리
     */
    DragDropUploader.prototype.handleFiles = function(files) {
        for (var i = 0; i < files.length; i++) {
            if (this.validateFile(files[i])) {
                this.addFileToList(files[i]);
            }
        }
    };

    /**
     * 드래그앤드롭 이벤트 바인딩
     */
    DragDropUploader.prototype.bindDragDropEvents = function() {
        var self = this;

        // ========== 드롭존(dropZone) 이벤트 ==========
        this.$dropZone.on('dragenter', function(e) {
            e.preventDefault();
            e.stopPropagation();
            $(this).addClass('drag-over');
        });

        this.$dropZone.on('dragover', function(e) {
            e.preventDefault();
            e.stopPropagation();
        });

        this.$dropZone.on('dragleave', function(e) {
            e.preventDefault();
            e.stopPropagation();
            $(this).removeClass('drag-over');
        });

        this.$dropZone.on('drop', function(e) {
            e.preventDefault();
            e.stopPropagation();
            $(this).removeClass('drag-over');

            var files = e.originalEvent.dataTransfer.files;
            if (files.length > 0) {
                self.handleFiles(files);
            }
        });

        // ========== 파일 리스트(fileList) 이벤트 (UI 변경 없이 파일만 추가) ==========
        this.$fileList.on('dragenter', function(e) {
            e.preventDefault();
            e.stopPropagation();
        });

        this.$fileList.on('dragover', function(e) {
            e.preventDefault();
            e.stopPropagation();
        });

        this.$fileList.on('dragleave', function(e) {
            e.preventDefault();
            e.stopPropagation();
        });

        this.$fileList.on('drop', function(e) {
            e.preventDefault();
            e.stopPropagation();

            var files = e.originalEvent.dataTransfer.files;
            if (files.length > 0) {
                self.handleFiles(files);
            }
        });

        console.log('[DragDropUploader] 드래그앤드롭 이벤트 바인딩 완료');
    };

    /**
     * 파일찾기 버튼 이벤트 바인딩
     */
    DragDropUploader.prototype.bindFileButtonEvent = function() {
        var self = this;

        if (!this.$uploadButton.length) {
            console.warn('[DragDropUploader] 파일찾기 버튼을 찾을 수 없습니다.');
            return;
        }

        // 기존 이벤트 제거 후 재바인딩 (중복 방지)
        this.$uploadButton.off('click').on('click', function(e) {
            e.preventDefault();

            // hidden input file 생성
            var $fileInput = $('<input type="file" multiple style="display:none">');
            $fileInput.attr('accept', '.' + self.config.allowedExtensions.join(',.'));

            $fileInput.on('change', function() {
                var files = this.files;
                if (files.length > 0) {
                    self.handleFiles(files);
                }
                $(this).remove(); // 사용 후 제거
            });

            $fileInput.trigger('click');
        });

        console.log('[DragDropUploader] 파일찾기 버튼 이벤트 바인딩 완료');
    };

    /**
     * 파일 삭제 이벤트 바인딩 (이벤트 위임)
     */
    DragDropUploader.prototype.bindDeleteEvent = function() {
        var self = this;

        // 컨테이너 기반 이벤트 위임 (동적 생성된 요소에도 적용)
        this.$container.on('click', '#' + this.config.fileListId + ' .UploaderListImg .Delete', function(e) {
            e.preventDefault();

            var $item = $(this).closest('.UploaderListImg');
            var filename = $item.data('filename');
            var isExistingFile = $item.data('existing') === true;

            if (isExistingFile) {
                // 기존 서버 파일: 즉시 삭제 (확인 다이얼로그 표시)
                if (!confirm('파일을 삭제하시겠습니까?\n삭제된 파일은 복구할 수 없습니다.')) {
                    return;
                }

                // Get DOC_NO and DOC_SEQ from data attributes
                var docNo = $item.data('doc-no');
                var docSeq = $item.data('doc-seq');

                // Call immediate deletion
                self.deleteServerFileImmediately(docNo, docSeq, filename, $item);

            } else {
                // 신규 파일 삭제 (로컬에서만 제거)
                for (var i = 0; i < self.uploadedFiles.length; i++) {
                    if (self.uploadedFiles[i].name === filename) {
                        self.uploadedFiles.splice(i, 1);
                        console.log('[DragDropUploader] 신규 파일 삭제:', filename);
                        break;
                    }
                }

                // UI에서 제거
                $item.remove();
                console.log('[DragDropUploader] 신규 파일 UI에서 제거:', filename);

                // 표시 전환
                self.toggleDisplayByFileCount();

                // 모든 파일 삭제 시 sharedFileKey 초기화
                if (self.uploadedFiles.length === 0) {
                    self.sharedFileKey = null;
                    console.log('[DragDropUploader] 모든 신규 파일 삭제 - sharedFileKey 초기화');
                }

                // 콜백 실행
                if (self.config.onFileRemoved) {
                    self.config.onFileRemoved(filename, false);
                }
                if (self.config.onFileCountChange) {
                    self.config.onFileCountChange(self.uploadedFiles.length);
                }

                console.log('[DragDropUploader] 신규 파일 삭제 완료:', filename, '(신규:', self.uploadedFiles.length, '개)');
            }
        });

        console.log('[DragDropUploader] 파일 삭제 이벤트 바인딩 완료');
    };

    /**
     * 기존 서버 파일 로드 (수정 모드)
     * @param {Array} fileList - 서버에서 받은 파일 목록 [{FILE_NAME: 'file.pdf'}, ...]
     */
    DragDropUploader.prototype.loadExistingFiles = function(fileList) {
        if (!Array.isArray(fileList) || fileList.length === 0) {
            console.log('[DragDropUploader] 기존 파일 없음');
            return;
        }

        var self = this;

        fileList.forEach(function(fileInfo) {
            var fileName = fileInfo.FILE_NAME || fileInfo.fileName || fileInfo.SRC_FILE_NAME || '';

            // 중복 확인: 이미 표시된 파일인지 체크 (data-existing="true"인 파일)
            var existingFile = self.$fileList.find('.UploaderListImg[data-existing="true"][data-filename="' + fileName + '"]');
            if (existingFile.length > 0) {
                console.log('[DragDropUploader] 이미 로드된 파일 건너뛰기:', fileName);
                return; // forEach의 continue 역할
            }

            var ext = self.getFileExtension(fileName);
            var fileNameOnly = fileName.replace('.' + ext, '');
            var icon = self.getFileIcon(fileName);

            // 파일 정보 추출 (DOC_NO, DOC_SEQ)
            var docNo = fileInfo.DOC_NO || '';
            var docSeq = fileInfo.DOC_SEQ || '';

            // 기존 파일 표시 (data-existing="true", data-doc-no, data-doc-seq 추가)
            var fileHtml =
                '<div class="UploaderListImg" data-filename="' + fileName + '" data-existing="true" data-doc-no="' + docNo + '" data-doc-seq="' + docSeq + '">' +
                '    <img class="Delete" src="/resources/imgs/delete_02.png" />' +
                '    <img class="img" src="' + icon + '" />' +
                '    <div class="Txt"><p>' + fileNameOnly + '</p><span>.' + ext + '</span></div>' +
                '</div>';

            self.$fileList.append(fileHtml);
            console.log('[DragDropUploader] 서버 파일 추가:', fileName);
        });

        this.toggleDisplayByFileCount();
        console.log('[DragDropUploader] 기존 파일 로드 완료 (총 ' + fileList.length + '개 중 신규 추가된 파일만 표시)');
    };

    /**
     * 업로드된 파일 목록 가져오기
     * @returns {Array} File 객체 배열
     */
    DragDropUploader.prototype.getUploadedFiles = function() {
        return this.uploadedFiles;
    };

    /**
     * 삭제된 서버 파일 목록 가져오기
     * @returns {Array} 파일명 배열
     */
    DragDropUploader.prototype.getDeletedServerFiles = function() {
        return this.deletedServerFiles;
    };

    /**
     * 서버 파일 즉시 삭제 (AJAX 호출)
     * @param {String} docNo - 문서 번호
     * @param {String} docSeq - 문서 순번
     * @param {String} filename - 파일명 (로그용)
     * @param {jQuery} $item - 파일 아이템 DOM 요소
     */
    DragDropUploader.prototype.deleteServerFileImmediately = function(docNo, docSeq, filename, $item) {
        var self = this;

        // HttpUtil 사용하여 서버 삭제 API 호출
        if (typeof HttpUtil === 'undefined') {
            console.error('[DragDropUploader] HttpUtil이 로드되지 않았습니다.');
            alert('파일 삭제 기능을 사용할 수 없습니다. 페이지를 새로고침해주세요.');
            return;
        }

        HttpUtil.post('/common/deleteIcomatchFile.do', {
            D_DOC_NO: docNo,
            D_DOC_SEQ: docSeq
        }, {
            showLoader: true,
            showDefaultAlert: false
        }).then(function(response) {
            if (response && response.data && response.data.success) {
                // 삭제 성공: UI에서 완전 제거
                $item.remove();
                console.log('[DragDropUploader] 서버 파일 삭제 완료:', filename);

                // 콜백 실행
                if (self.config.onFileRemoved) {
                    self.config.onFileRemoved(filename, true);
                }

                // 파일 개수 체크하여 드롭존 표시 여부 결정
                self.toggleDisplayByFileCount();

                // 성공 메시지 (선택사항)
                // alert('파일이 삭제되었습니다.');
            } else {
                var errorMsg = response && response.data && response.data.message
                    ? response.data.message
                    : '파일 삭제에 실패했습니다.';
                alert(errorMsg);
                console.error('[DragDropUploader] 파일 삭제 실패:', response);
            }
        }).catch(function(error) {
            console.error('[DragDropUploader] 파일 삭제 중 오류 발생:', error);
            alert('파일 삭제 중 오류가 발생했습니다.\n\n' + (error.message || '알 수 없는 오류'));
        });
    };

    /**
     * 파일 개수 가져오기
     * @returns {Number} 신규 파일 개수
     */
    DragDropUploader.prototype.getFileCount = function() {
        return this.uploadedFiles.length;
    };

    /**
     * 공유 파일 키 설정
     * @param {String} fileKey - 공유 파일 키
     */
    DragDropUploader.prototype.setSharedFileKey = function(fileKey) {
        this.sharedFileKey = fileKey;
        console.log('[DragDropUploader] 공유 fileKey 설정:', fileKey);
    };

    /**
     * 공유 파일 키 가져오기
     * @returns {String} 공유 파일 키
     */
    DragDropUploader.prototype.getSharedFileKey = function() {
        return this.sharedFileKey;
    };

    /**
     * 파일 목록 초기화
     */
    DragDropUploader.prototype.reset = function() {
        this.uploadedFiles = [];
        this.deletedServerFiles = [];
        this.sharedFileKey = null;
        this.$fileList.empty();
        this.toggleDisplayByFileCount();
        console.log('[DragDropUploader] 초기화 완료');
    };

    /**
     * 이벤트 제거
     */
    DragDropUploader.prototype.destroy = function() {
        this.$dropZone.off('dragenter dragover dragleave drop');
        this.$fileList.off('dragenter dragover dragleave drop');
        this.$uploadButton.off('click');
        this.$container.off('click', '#' + this.config.fileListId + ' .UploaderListImg .Delete');
        console.log('[DragDropUploader] 이벤트 제거 완료');
    };

    // 전역 노출
    window.DragDropUploader = DragDropUploader;

})(window);
