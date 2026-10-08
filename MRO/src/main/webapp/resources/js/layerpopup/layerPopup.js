/**
 * MRO Layer Popup Library
 * Java 1.6 호환 레이어 팝업 라이브러리
 * IE8+ 지원, jQuery 의존성 없음
 */
(function(window) {
    'use strict';
    
    // 네임스페이스
    var LayerPopup = {
        version: '1.0.0',
        zIndex: 9999,
        popups: {},
        overlay: null,
        
        // 기본 옵션
        defaults: {
            width: 500,
            height: 'auto',
            modal: true,
            draggable: true,
            closable: true,
            overlay: true,
            animation: 'fade',
            position: 'center',
            onShow: null,
            onHide: null,
            onClose: null
        },
        
        // 초기화
        init: function() {
            this.createOverlay();
            this.bindEvents();
            return this;
        },
        
        // 오버레이 생성
        createOverlay: function() {
            if (this.overlay) return;
            
            this.overlay = document.createElement('div');
            this.overlay.className = 'layer-overlay';
            this.overlay.style.cssText = [
                'position: fixed',
                'top: 0',
                'left: 0',
                'width: 100%',
                'height: 100%',
                'background-color: rgba(0, 0, 0, 0.5)',
                'z-index: ' + (this.zIndex - 1),
                'display: none'
            ].join('; ');
            
            document.body.appendChild(this.overlay);
        },
        
        // 이벤트 바인딩
        bindEvents: function() {
            var self = this;
            
            // ESC 키로 팝업 닫기
            document.onkeydown = function(e) {
                e = e || window.event;
                if (e.keyCode === 27) {
                    self.closeTop();
                }
            };
            
            // 오버레이 클릭으로 팝업 닫기
            this.overlay.onclick = function() {
                self.closeTop();
            };
        },
        
        // 팝업 생성
        create: function(id, options) {
            options = this.extend(this.defaults, options || {});
            
            var popup = document.createElement('div');
            popup.id = id;
            popup.className = 'layer-popup';
            popup.style.cssText = [
                'position: fixed',
                'background: white',
                'border: 1px solid #ddd',
                'box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3)',
                'z-index: ' + this.zIndex++,
                'display: none',
                'width: ' + (typeof options.width === 'number' ? options.width + 'px' : options.width),
                'height: ' + (options.height === 'auto' ? 'auto' : options.height + 'px')
            ].join('; ');
            
            // 헤더 생성
            if (options.title || options.closable) {
                var header = this.createHeader(id, options);
                popup.appendChild(header);
            }
            
            // 컨텐츠 영역 생성
            var content = document.createElement('div');
            content.className = 'layer-content';
            content.style.cssText = 'padding: 20px; max-height: 70vh; overflow-y: auto;';
            popup.appendChild(content);
            
            // body에 추가
            document.body.appendChild(popup);
            
            // 팝업 객체 저장
            this.popups[id] = {
                element: popup,
                content: content,
                options: options
            };
            
            // 드래그 가능하게 설정
            if (options.draggable) {
                this.makeDraggable(popup);
            }
            
            return popup;
        },
        
        // 헤더 생성
        createHeader: function(id, options) {
            var header = document.createElement('div');
            header.className = 'layer-header';
            header.style.cssText = [
                'padding: 15px 20px',
                'border-bottom: 1px solid #eee',
                'background: #f8f9fa',
                'cursor: move',
                'position: relative'
            ].join('; ');
            
            if (options.title) {
                var title = document.createElement('h3');
                title.style.cssText = 'margin: 0; font-size: 16px; font-weight: 500;';
                title.innerHTML = options.title;
                header.appendChild(title);
            }
            
            if (options.closable) {
                var closeBtn = document.createElement('button');
                closeBtn.innerHTML = '×';
                closeBtn.className = 'layer-close';
                closeBtn.style.cssText = [
                    'position: absolute',
                    'top: 50%',
                    'right: 15px',
                    'margin-top: -12px',
                    'width: 24px',
                    'height: 24px',
                    'border: none',
                    'background: none',
                    'font-size: 18px',
                    'cursor: pointer',
                    'color: #666'
                ].join('; ');
                
                var self = this;
                closeBtn.onclick = function() {
                    self.close(id);
                };
                
                header.appendChild(closeBtn);
            }
            
            return header;
        },
        
        // 드래그 가능하게 만들기
        makeDraggable: function(popup) {
            var header = popup.querySelector('.layer-header');
            if (!header) return;
            
            var isDragging = false;
            var startX, startY, initialX, initialY;
            
            header.onmousedown = function(e) {
                e = e || window.event;
                isDragging = true;
                startX = e.clientX;
                startY = e.clientY;
                
                var rect = popup.getBoundingClientRect();
                initialX = rect.left;
                initialY = rect.top;
                
                document.onmousemove = function(e) {
                    if (!isDragging) return;
                    e = e || window.event;
                    
                    var deltaX = e.clientX - startX;
                    var deltaY = e.clientY - startY;
                    
                    popup.style.left = (initialX + deltaX) + 'px';
                    popup.style.top = (initialY + deltaY) + 'px';
                };
                
                document.onmouseup = function() {
                    isDragging = false;
                    document.onmousemove = null;
                    document.onmouseup = null;
                };
            };
        },
        
        // 팝업 표시
        show: function(id, content) {
            var popup = this.popups[id];
            if (!popup) return;
            
            // 컨텐츠 설정
            if (content) {
                if (typeof content === 'string') {
                    popup.content.innerHTML = content;
                } else if (content.nodeType) {
                    popup.content.appendChild(content);
                }
            }
            
            // 오버레이 표시
            if (popup.options.overlay) {
                this.overlay.style.display = 'block';
            }
            
            // 팝업 위치 설정
            this.setPosition(popup.element, popup.options.position);
            
            // 애니메이션과 함께 표시
            this.animate(popup.element, 'show', popup.options.animation);
            
            // 콜백 실행
            if (popup.options.onShow) {
                popup.options.onShow.call(popup.element);
            }
        },
        
        // 팝업 위치 설정
        setPosition: function(element, position) {
            if (position === 'center') {
                var rect = element.getBoundingClientRect();
                var viewportWidth = window.innerWidth || document.documentElement.clientWidth;
                var viewportHeight = window.innerHeight || document.documentElement.clientHeight;
                
                element.style.left = Math.max(0, (viewportWidth - rect.width) / 2) + 'px';
                element.style.top = Math.max(0, (viewportHeight - rect.height) / 2) + 'px';
            }
        },
        
        // 애니메이션
        animate: function(element, action, type) {
            if (action === 'show') {
                element.style.display = 'block';
                if (type === 'fade') {
                    element.style.opacity = '0';
                    this.fadeIn(element, 200);
                }
            } else if (action === 'hide') {
                if (type === 'fade') {
                    this.fadeOut(element, 200);
                } else {
                    element.style.display = 'none';
                }
            }
        },
        
        // 페이드인
        fadeIn: function(element, duration) {
            var start = Date.now();
            var opacity = 0;
            
            function frame() {
                var now = Date.now();
                var elapsed = now - start;
                opacity = elapsed / duration;
                
                if (opacity >= 1) {
                    opacity = 1;
                    element.style.opacity = opacity;
                    return;
                }
                
                element.style.opacity = opacity;
                setTimeout(frame, 16);
            }
            
            frame();
        },
        
        // 페이드아웃
        fadeOut: function(element, duration) {
            var start = Date.now();
            var opacity = 1;
            
            function frame() {
                var now = Date.now();
                var elapsed = now - start;
                opacity = 1 - (elapsed / duration);
                
                if (opacity <= 0) {
                    opacity = 0;
                    element.style.opacity = opacity;
                    element.style.display = 'none';
                    return;
                }
                
                element.style.opacity = opacity;
                setTimeout(frame, 16);
            }
            
            frame();
        },
        
        // 팝업 숨기기
        hide: function(id) {
            var popup = this.popups[id];
            if (!popup) return;
            
            this.animate(popup.element, 'hide', popup.options.animation);
            
            // 다른 모달 팝업이 없으면 오버레이 숨기기
            var hasModal = false;
            for (var popupId in this.popups) {
                var p = this.popups[popupId];
                if (p.options.modal && p.element.style.display !== 'none') {
                    hasModal = true;
                    break;
                }
            }
            
            if (!hasModal) {
                this.overlay.style.display = 'none';
            }
            
            if (popup.options.onHide) {
                popup.options.onHide.call(popup.element);
            }
        },
        
        // 팝업 닫기 (제거)
        close: function(id) {
            var popup = this.popups[id];
            if (!popup) return;
            
            if (popup.options.onClose) {
                var result = popup.options.onClose.call(popup.element);
                if (result === false) return; // 닫기 취소
            }
            
            this.hide(id);
            
            setTimeout(function() {
                if (popup.element.parentNode) {
                    popup.element.parentNode.removeChild(popup.element);
                }
                delete this.popups[id];
            }.bind(this), 200);
        },
        
        // 최상단 팝업 닫기
        closeTop: function() {
            var topPopup = null;
            var maxZIndex = 0;
            
            for (var id in this.popups) {
                var popup = this.popups[id];
                var zIndex = parseInt(popup.element.style.zIndex, 10);
                if (zIndex > maxZIndex && popup.element.style.display !== 'none') {
                    maxZIndex = zIndex;
                    topPopup = id;
                }
            }
            
            if (topPopup) {
                this.close(topPopup);
            }
        },
        
        // 객체 확장 (extend 함수)
        extend: function(target, source) {
            var result = {};
            for (var key in target) {
                result[key] = target[key];
            }
            for (var key in source) {
                result[key] = source[key];
            }
            return result;
        },
        
        // 편의 메서드들
        alert: function(message, title) {
            var id = 'alert_' + Date.now();
            this.create(id, {
                title: title || '알림',
                width: 400,
                closable: true
            });
            
            var content = '<div style="padding: 20px 0; text-align: center;">' + message + '</div>' +
                         '<div style="text-align: center; padding-top: 20px;">' +
                         '<button onclick="LayerPopup.close(\'' + id + '\')" style="padding: 8px 20px; cursor: pointer;">확인</button>' +
                         '</div>';
            
            this.show(id, content);
        },
        
        confirm: function(message, callback, title) {
            var id = 'confirm_' + Date.now();
            this.create(id, {
                title: title || '확인',
                width: 400,
                closable: true
            });
            
            var content = '<div style="padding: 20px 0; text-align: center;">' + message + '</div>' +
                         '<div style="text-align: center; padding-top: 20px;">' +
                         '<button onclick="LayerPopup.confirmOk(\'' + id + '\')" style="padding: 8px 20px; margin-right: 10px; cursor: pointer;">확인</button>' +
                         '<button onclick="LayerPopup.close(\'' + id + '\')" style="padding: 8px 20px; cursor: pointer;">취소</button>' +
                         '</div>';
            
            this.show(id, content);
            this.popups[id].callback = callback;
        },
        
        confirmOk: function(id) {
            var popup = this.popups[id];
            if (popup && popup.callback) {
                popup.callback(true);
            }
            this.close(id);
        }
    };
    
    // 전역 객체로 등록
    window.LayerPopup = LayerPopup.init();
    
})(window);