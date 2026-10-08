/**
 * 탭 매니저
 * 각 탭 모듈을 관리하는 중앙 컨트롤러
 */
var MRO = MRO || {};

// 범용 탭 매니저
MRO.TabManager = (function() {
    'use strict';
    
    // Private 변수
    var modules = {};
    var currentTab = null;
    var commonData = {
        sessionComCode: null,
        dateFormat: 'YYYY.MM.DD'
    };
    var tabSwitchCallback = null; // 탭 전환 콜백 함수 (선택적)
    
    // Private 함수
    function validateModule(moduleName) {
        if (!modules[moduleName]) {
            console.warn('Module not found: ' + moduleName + '. 모듈이 아직 로드되지 않았을 수 있습니다.');
            return false;
        }
        return true;
    }
    
    // Public API
    return {
        // 공통 데이터 설정
        setCommonData: function(key, value) {
            commonData[key] = value;
        },
        
        // 공통 데이터 조회
        getCommonData: function(key) {
            return commonData[key];
        },

        // 탭 전환 콜백 등록 (선택적)
        setTabSwitchCallback: function(callback) {
            if (typeof callback === 'function') {
                tabSwitchCallback = callback;
                console.log('Tab switch callback registered');
            } else {
                console.warn('Invalid callback function provided');
            }
        },
        
        // 모듈 등록
        registerModule: function(name, module) {
            if (typeof module === 'function') {
                modules[name] = module(this); // 공통 객체 주입

                // 모듈 등록 즉시 초기화
                if (modules[name] && modules[name].init) {
                    modules[name].init();
                }

                console.log('Module registered and initialized: ' + name);
            }
        },
        
        // 모듈 가져오기
        getModule: function(name) {
            return modules[name];
        },
        
        // 탭 전환
        switchTab: function(tabName) {
            var previousTab = currentTab;

            // 이전 탭 정리
            if (currentTab && modules[currentTab] && modules[currentTab].deactivate) {
                modules[currentTab].deactivate();
            }

            // 현재 탭 설정 (모듈 존재 여부와 관계없이)
            currentTab = tabName;

            // 모듈이 등록되어 있으면 활성화
            if (validateModule(tabName)) {
                if (modules[tabName].activate) {
                    modules[tabName].activate();
                }
            } else {
                console.log('탭 ' + tabName + ' 모듈이 아직 로드되지 않았습니다. UI만 전환합니다.');
            }

            // HTML UI 상태 업데이트 (항상 실행)
            this.updateTabUI(tabName);

            // 콜백이 등록되어 있으면 호출
            if (tabSwitchCallback) {
                try {
                    tabSwitchCallback(previousTab, currentTab);
                } catch (e) {
                    console.error('Tab switch callback error:', e);
                }
            }
        },
        
        // HTML 탭 UI 상태 업데이트
        updateTabUI: function(activeTabName) {
            console.log('UI 업데이트 시작. 활성 탭:', activeTabName);

            // 모든 탭 버튼에서 active 클래스 제거
            var tabButtons = document.querySelectorAll('.SubSearchTab .TabTit');
            console.log('탭 버튼 개수:', tabButtons.length);
            tabButtons.forEach(function(button) {
                button.classList.remove('active');
            });

            // 모든 탭 컨테이너 숨김
            var tabContainers = document.querySelectorAll('[id^="Search"]');
            console.log('탭 컨테이너 개수:', tabContainers.length);
            tabContainers.forEach(function(container) {
                container.style.display = 'none';
                console.log('컨테이너 숨김:', container.id);
            });

            // 탭명을 컨테이너 ID로 동적 변환 (tab1 -> Search1, tab2 -> Search2 ...)
            var searchId = activeTabName.replace('tab', 'Search');
            console.log('변환된 컨테이너 ID:', searchId);

            // 활성 탭 버튼 활성화
            var activeButton = document.querySelector('.SubSearchTab .TabTit[data-tab="' + searchId + '"]');
            if (activeButton) {
                activeButton.classList.add('active');
                console.log('탭 버튼 활성화:', searchId, activeButton.textContent);
            } else {
                console.error('탭 버튼을 찾을 수 없음:', searchId);
            }

            // 활성 탭 컨테이너 표시
            var activeContainer = document.getElementById(searchId);
            if (activeContainer) {
                activeContainer.style.display = 'block';
                console.log('탭 컨테이너 표시:', searchId);
            } else {
                console.error('탭 컨테이너를 찾을 수 없음:', searchId);
            }

            console.log('UI 업데이트 완료');
        },
        
        // 모든 모듈 초기화
        initAll: function() {
            // 각 탭 모듈 초기화
            for (var name in modules) {
                if (modules[name].init) {
                    modules[name].init();
                }
            }
            
            // 탭 클릭 이벤트 자동 바인딩
            this.initTabClickEvents();
        },
        
        // 탭 클릭 이벤트만 바인딩 (initAll에서 자동 호출)
        initTabClickEvents: function() {
            var tabLinks = document.querySelectorAll(".SubSearchTab .TabTit");
            var self = this; // 클로저 내부에서 this 참조

            console.log('탭 버튼 개수:', tabLinks.length);

            // 탭 클릭 이벤트 바인딩
            tabLinks.forEach(function(link, index) {
                console.log('탭 버튼 ' + index + ' 바인딩:', link.dataset.tab, link.textContent);

                link.addEventListener("click", function(e) {
                    console.log('탭 클릭됨:', link.dataset.tab, link.textContent);

                    // 모듈 탭 전환 (클로저 모듈 활성화)
                    var dataTab = link.dataset.tab;

                    // Search ID를 tab 이름으로 동적 변환 (Search1 -> tab1, Search2 -> tab2 ...)
                    var moduleName = dataTab ? dataTab.replace('Search', 'tab') : null;

                    console.log('변환된 모듈명:', moduleName);

                    if (moduleName) {
                        self.switchTab(moduleName);
                    } else {
                        console.error('모듈명 변환 실패. dataTab:', dataTab);
                    }
                });
            });

            console.log('Tab click events initialized. 총 ' + tabLinks.length + '개 탭');
        },
        
        // 기본 탭 설정 (분리된 함수)
        setDefaultTab: function(defaultTab) {
            defaultTab = defaultTab || 'tab1';
            
            // 모든 탭과 컨테이너 초기화 (비활성화)
            this.resetAllTabs();
            
            // 기본 탭 활성화 (UI와 모듈 모두)
            this.switchTab(defaultTab);
            
            console.log('Default tab set to:', defaultTab);
        },
        
        // 모든 탭 초기화 (비활성화)
        resetAllTabs: function() {
            // 모든 탭 버튼 비활성화
            var tabButtons = document.querySelectorAll('.SubSearchTab .TabTit');
            tabButtons.forEach(function(button) {
                button.classList.remove('active');
            });

            // 모든 탭 컨테이너 숨김
            var tabContainers = document.querySelectorAll('[id^="Search"]');
            tabContainers.forEach(function(container) {
                container.style.display = 'none';
            });
        },

        // 탭 정보 조회
        getTabInfo: function() {
            var tabButtons = document.querySelectorAll('.SubSearchTab .TabTit');
            var tabContainers = document.querySelectorAll('[id^="Search"]');

            return {
                buttonCount: tabButtons.length,      // HTML 탭 버튼 개수
                containerCount: tabContainers.length, // HTML 탭 컨테이너 개수
                moduleCount: Object.keys(modules).length, // 등록된 모듈 개수
                registeredModules: Object.keys(modules),  // 등록된 모듈 목록
                currentTab: currentTab // 현재 활성 탭
            };
        }
    };
})();

