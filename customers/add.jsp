<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="새 고객사 추가" scope="request" />
<%@ include file="/includes/header.jsp" %>

<div class="container">
    <div class="page-header">
        <h2><i class="fas fa-plus-circle"></i> 새 고객사 등록</h2>
        <p>새로운 고객사의 기본 정보를 입력해주세요.</p>
    </div>
    
    <!-- 오류 메시지 -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i> ${error}
        </div>
    </c:if>
    
    <!-- 등록 폼 -->
    <div class="form-container">
        <form method="post" action="${pageContext.request.contextPath}/customers">
            <input type="hidden" name="action" value="add">
            
            <!-- 기본 정보 -->
            <div class="section-title">기본 정보</div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="customer_name">고객사명 <span class="required">*</span></label>
                    <input type="text" id="customer_name" name="customer_name" required>
                </div>
                <div class="form-group">
                    <label for="first_introduction_year">도입년도</label>
                    <input type="number" id="first_introduction_year" name="first_introduction_year" min="2000" max="2030">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="db_name">DB명</label>
                    <input type="text" id="db_name" name="db_name">
                </div>
                <div class="form-group">
                    <label for="vertica_version">Vertica 버전</label>
                    <input type="text" id="vertica_version" name="vertica_version">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="vertica_eos">EOS 일자</label>
                    <input type="date" id="vertica_eos" name="vertica_eos">
                </div>
                <div class="form-group">
                    <label for="mode">모드</label>
                    <select id="mode" name="mode">
                        <option value="">선택하세요</option>
                        <option value="ENT">ENT</option>
                        <option value="EON">EON</option>
                    </select>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="os">운영체제</label>
                    <input type="text" id="os" name="os">
                </div>
                <div class="form-group">
                    <label for="nodes">노드 수</label>
                    <input type="number" id="nodes" name="nodes" min="1">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="license_size">라이선스 크기</label>
                    <input type="text" id="license_size" name="license_size">
                </div>
                <div class="form-group">
                    <label for="said">SAID</label>
                    <input type="text" id="said" name="said">
                </div>
            </div>
            
            <!-- 담당자 정보 -->
            <div class="section-title">담당자 정보</div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="manager_name">담당자</label>
                    <input type="text" id="manager_name" name="manager_name">
                </div>
                <div class="form-group">
                    <label for="sub_manager_name">부담당자</label>
                    <input type="text" id="sub_manager_name" name="sub_manager_name">
                </div>
            </div>
            
            <!-- 시스템 구성 -->
            <div class="section-title">시스템 구성</div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="os_storage_config">스토리지 구성</label>
                    <textarea id="os_storage_config" name="os_storage_config" rows="3"></textarea>
                </div>
                <div class="form-group">
                    <label for="backup_config">백업 구성</label>
                    <textarea id="backup_config" name="backup_config" rows="3"></textarea>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="customer_type">고객 유형</label>
                    <input type="text" id="customer_type" name="customer_type">
                </div>
                <div class="form-group">
                    <!-- 빈 칸으로 두어 균형 맞춤 -->
                </div>
            </div>
            
            <!-- 외부 솔루션 -->
            <div class="section-title">외부 솔루션</div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="etl_tool">ETL Tool</label>
                    <input type="text" id="etl_tool" name="etl_tool">
                </div>
                <div class="form-group">
                    <label for="bi_tool">BI Tool</label>
                    <input type="text" id="bi_tool" name="bi_tool">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="db_encryption">DB 암호화</label>
                    <input type="text" id="db_encryption" name="db_encryption">
                </div>
                <div class="form-group">
                    <label for="cdc_tool">CDC Tool</label>
                    <input type="text" id="cdc_tool" name="cdc_tool">
                </div>
            </div>
            
            <!-- 비고 -->
            <div class="form-row">
                <div class="form-group full-width">
                    <label for="note">비고</label>
                    <textarea id="note" name="note" rows="3"></textarea>
                </div>
            </div>
            
            <!-- 버튼 -->
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/customers?view=list" class="btn btn-cancel">취소</a>
                <button type="submit" class="btn btn-primary">등록하기</button>
            </div>
        </form>
    </div>
</div>

<style>
/* 기본 레이아웃 */
.container {
    max-width: 1000px;
    margin: 0 auto;
    padding: 20px;
}

.page-header {
    margin-bottom: 30px;
    text-align: center;
}

.page-header h2 {
    color: #333;
    margin-bottom: 10px;
}

.page-header p {
    color: #666;
    margin: 0;
}

/* 폼 컨테이너 */
.form-container {
    background: white;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 30px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

/* 섹션 제목 */
.section-title {
    font-size: 16px;
    font-weight: bold;
    color: #333;
    margin: 25px 0 15px 0;
    padding-bottom: 8px;
    border-bottom: 2px solid #007bff;
}

.section-title:first-child {
    margin-top: 0;
}

/* 폼 행 */
.form-row {
    display: flex;
    gap: 20px;
    margin-bottom: 15px;
}

.form-group {
    flex: 1;
}

.form-group.full-width {
    flex: 1 1 100%;
}

/* 라벨 */
.form-group label {
    display: block;
    margin-bottom: 5px;
    font-weight: 500;
    color: #333;
    font-size: 14px;
}

.required {
    color: #dc3545;
}

/* 입력 필드 */
.form-group input,
.form-group select,
.form-group textarea {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
    background: white;
    transition: border-color 0.2s;
    box-sizing: border-box;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    outline: none;
    border-color: #007bff;
    box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
}

.form-group textarea {
    resize: vertical;
    min-height: 80px;
}

/* 버튼 그룹 */
.button-group {
    text-align: center;
    margin-top: 30px;
    padding-top: 20px;
    border-top: 1px solid #eee;
}

.btn {
    display: inline-block;
    padding: 12px 24px;
    margin: 0 5px;
    border: none;
    border-radius: 4px;
    font-size: 14px;
    font-weight: 500;
    text-decoration: none;
    cursor: pointer;
    transition: all 0.2s;
}

.btn-primary {
    background: #007bff;
    color: white;
}

.btn-primary:hover {
    background: #0056b3;
}

.btn-cancel {
    background: #6c757d;
    color: white;
}

.btn-cancel:hover {
    background: #545b62;
    text-decoration: none;
}

/* 알림 메시지 */
.alert {
    padding: 12px 16px;
    margin-bottom: 20px;
    border-radius: 4px;
    border: 1px solid transparent;
}

.alert-danger {
    color: #721c24;
    background-color: #f8d7da;
    border-color: #f5c6cb;
}

/* 반응형 */
@media (max-width: 768px) {
    .container {
        padding: 15px;
    }
    
    .form-container {
        padding: 20px;
    }
    
    .form-row {
        flex-direction: column;
        gap: 10px;
    }
    
    .form-group {
        flex: none;
    }
    
    .button-group {
        text-align: stretch;
    }
    
    .btn {
        display: block;
        width: 100%;
        margin: 5px 0;
    }
}
</style>

<script>
// 현재 연도 설정
document.addEventListener('DOMContentLoaded', function() {
    const currentYear = new Date().getFullYear();
    const yearInput = document.getElementById('first_introduction_year');
    if (yearInput && !yearInput.value) {
        yearInput.value = currentYear;
    }
});

// 폼 유효성 검사
document.querySelector('form').addEventListener('submit', function(e) {
    const customerName = document.getElementById('customer_name').value.trim();
    
    if (!customerName) {
        e.preventDefault();
        alert('고객사명은 필수 입력 항목입니다.');
        document.getElementById('customer_name').focus();
        return false;
    }
});
</script>

<%@ include file="/includes/footer.jsp" %>