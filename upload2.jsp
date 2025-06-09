<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%
    // 세션 확인
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect("login");
        return;
    }
%>

<%
    String relativePath = request.getParameter("path");
    if (relativePath == null) relativePath = "";

    // 보안 검증
    if (relativePath.contains("..") || relativePath.contains("\\")) {
        out.println("<h3>잘못된 경로입니다.</h3>");
        return;
    }
    
    String baseDir = "/files";
    String realPath = application.getRealPath(baseDir + "/" + relativePath);
    File currentDir = new File(realPath);
    if (!currentDir.exists() || !currentDir.isDirectory()) {
        out.println("<h3>잘못된 경로입니다.</h3>");
        return;
    }
%>

<% 
    // 페이지 타이틀 설정
    pageContext.setAttribute("pageTitle", "파일 업로드");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>파일 업로드 - <%= relativePath.isEmpty() ? "/" : ("/" + relativePath) %></title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
    <style>
        /* 업로드 페이지 전용 스타일 */
        .upload-container {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        
        .main-content {
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
            padding: var(--space-32) var(--space-16);
        }
        
        .upload-main {
            width: 100%;
            padding: 30px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .breadcrumb {
            background: #f8f9fa;
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 30px;
            font-size: 14px;
        }
        
        .breadcrumb a {
            color: #495057;
            text-decoration: none;
        }
        
        .breadcrumb a:hover {
            color: #007bff;
            text-decoration: underline;
        }
        
        .upload-form {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 8px;
            border: 2px dashed #dee2e6;
            text-align: center;
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }
        
        .upload-form:hover {
            border-color: #007bff;
            background: #e3f2fd;
        }
        
        .upload-form.dragover {
            border-color: #007bff;
            background: #e3f2fd;
            transform: scale(1.02);
        }
        
        .file-input {
            margin: 20px 0;
        }
        
        .file-input input[type="file"] {
            display: none;
        }
        
        .file-input label {
            display: inline-block;
            padding: 12px 24px;
            background: #007bff;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: background 0.3s ease;
        }
        
        .file-input label:hover {
            background: #0056b3;
        }
        
        .selected-files {
            margin-top: 20px;
            text-align: left;
        }
        
        .file-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            margin-bottom: 10px;
        }
        
        .file-info {
            display: flex;
            align-items: center;
        }
        
        .file-icon {
            margin-right: 10px;
            font-size: 20px;
        }
        
        .file-details {
            flex: 1;
        }
        
        .file-name {
            font-weight: 500;
            color: #495057;
        }
        
        .file-size {
            font-size: 12px;
            color: #6c757d;
        }
        
        .remove-file {
            color: #dc3545;
            cursor: pointer;
            padding: 5px;
            border-radius: 4px;
            transition: background 0.3s ease;
        }
        
        .remove-file:hover {
            background: #f8d7da;
        }
        
        .upload-controls {
            margin-top: 30px;
            text-align: center;
        }
        
        .upload-btn {
            padding: 12px 30px;
            font-size: 16px;
            font-weight: 500;
            margin: 0 10px;
        }
        
        .upload-info {
            background: #e7f3ff;
            border: 1px solid #b3d9ff;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 30px;
        }
        
        .upload-info h6 {
            color: #0056b3;
            margin-bottom: 10px;
        }
        
        .upload-info ul {
            margin: 0;
            padding-left: 20px;
        }
        
        .upload-info li {
            color: #495057;
            font-size: 14px;
            margin-bottom: 5px;
        }
        
        .progress-container {
            display: none;
            margin-top: 20px;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            color: #6c757d;
            text-decoration: none;
            font-size: 14px;
            margin-bottom: 20px;
        }
        
        .back-link:hover {
            color: #007bff;
            text-decoration: none;
        }
        
        .back-link i {
            margin-right: 5px;
        }
    </style>
</head>
<body class="upload-container">
    <!-- Header Include -->
    <%@ include file="includes/header.jsp" %>

    <main class="main-content">
        <div class="container">
            <div class="upload-main">
                <!-- 뒤로가기 링크 -->
                <a href="downlist.jsp?path=<%= relativePath %>" class="back-link">
                    ⬅️ 파일 목록으로 돌아가기
                </a>

                <!-- 현재 경로 표시 -->
                <div class="breadcrumb">
                    <strong>📤 업로드 위치:</strong> 
                    <a href="downlist.jsp">/</a><%
                    if (!relativePath.isEmpty()) {
                        String[] parts = relativePath.split("/");
                        String currentPath = "";
                        for (int i = 0; i < parts.length; i++) {
                            if (!parts[i].isEmpty()) {
                                currentPath += parts[i];
                                out.print("<a href=\"downlist.jsp?path=" + currentPath + "\">" + parts[i] + "</a>");
                                if (i < parts.length - 1) out.print("/");
                                currentPath += "/";
                            }
                        }
                    }
                    %>
                </div>

                <h2>📤 파일 업로드</h2>
                <p class="text-muted">업로드할 파일을 선택하거나 드래그하여 놓으세요.</p>

                <!-- 업로드 정보 -->
                <div class="upload-info">
                    <h6>📋 업로드 안내사항</h6>
                    <ul>
                        <li>최대 파일 크기: <strong>10MB</strong></li>
                        <li>허용되지 않는 파일: .exe, .jsp, .php, .bat, .cmd, .scr</li>
                        <li>동일한 이름의 파일이 있으면 자동으로 번호가 추가됩니다</li>
                        <li>여러 파일을 동시에 선택할 수 있습니다</li>
                    </ul>
                </div>

                <!-- 업로드 폼 -->
                <form id="uploadForm" action="uploadProcess.jsp" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="path" value="<%= relativePath %>">
                    
                    <div class="upload-form" id="uploadArea">
                        <div style="font-size: 48px; color: #007bff; margin-bottom: 20px;">📁</div>
                        <h4>파일을 여기에 드래그하거나</h4>
                        <div class="file-input">
                            <label for="fileInput">
                                파일 선택하기
                            </label>
                            <input type="file" id="fileInput" name="uploadFiles" multiple accept="*/*">
                        </div>
                        <p class="text-muted">여러 파일을 동시에 선택할 수 있습니다</p>
                    </div>

                    <!-- 선택된 파일 목록 -->
                    <div id="selectedFiles" class="selected-files" style="display: none;">
                        <h5>선택된 파일 목록</h5>
                        <div id="fileList"></div>
                    </div>

                    <!-- 진행률 표시 -->
                    <div class="progress-container" id="progressContainer">
                        <div class="progress">
                            <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                        </div>
                        <p class="text-center mt-2">업로드 중...</p>
                    </div>

                    <!-- 업로드 버튼 -->
                    <div class="upload-controls">
                        <button type="submit" class="btn btn-primary upload-btn" id="uploadBtn" disabled>
                            📤 업로드 시작
                        </button>
                        <button type="button" class="btn btn-secondary upload-btn" onclick="clearFiles()">
                            🗑️ 선택 취소
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <!-- Footer Include -->
    <%@ include file="includes/footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        let selectedFiles = [];
        const maxFileSize = 10 * 1024 * 1024; // 10MB
        const forbiddenExtensions = ['.exe', '.jsp', '.php', '.bat', '.cmd', '.scr'];

        // 파일 선택 이벤트
        document.getElementById('fileInput').addEventListener('change', function(e) {
            handleFiles(e.target.files);
        });

        // 드래그 앤 드롭 이벤트
        const uploadArea = document.getElementById('uploadArea');
        
        uploadArea.addEventListener('dragover', function(e) {
            e.preventDefault();
            uploadArea.classList.add('dragover');
        });

        uploadArea.addEventListener('dragleave', function(e) {
            e.preventDefault();
            uploadArea.classList.remove('dragover');
        });

        uploadArea.addEventListener('drop', function(e) {
            e.preventDefault();
            uploadArea.classList.remove('dragover');
            handleFiles(e.dataTransfer.files);
        });

        function handleFiles(files) {
            const fileArray = Array.from(files);
            
            fileArray.forEach(file => {
                // 파일 크기 검증
                if (file.size > maxFileSize) {
                    alert(`파일 "${file.name}"이 너무 큽니다. (최대 10MB)`);
                    return;
                }

                // 파일 확장자 검증
                const fileName = file.name.toLowerCase();
                const isForbidden = forbiddenExtensions.some(ext => fileName.endsWith(ext));
                if (isForbidden) {
                    alert(`파일 "${file.name}"은 보안상 업로드할 수 없습니다.`);
                    return;
                }

                // 중복 파일 검사
                const isDuplicate = selectedFiles.some(f => f.name === file.name && f.size === file.size);
                if (!isDuplicate) {
                    selectedFiles.push(file);
                }
            });

            updateFileList();
            updateUploadButton();
        }

        function updateFileList() {
            const fileList = document.getElementById('fileList');
            const selectedFilesDiv = document.getElementById('selectedFiles');

            if (selectedFiles.length === 0) {
                selectedFilesDiv.style.display = 'none';
                return;
            }

            selectedFilesDiv.style.display = 'block';
            fileList.innerHTML = '';

            selectedFiles.forEach((file, index) => {
                const fileItem = document.createElement('div');
                fileItem.className = 'file-item';
                
                const fileIcon = getFileIcon(file.name);
                const fileSize = formatFileSize(file.size);

                fileItem.innerHTML = `
                    <div class="file-info">
                        <div class="file-icon">${fileIcon}</div>
                        <div class="file-details">
                            <div class="file-name">${file.name}</div>
                            <div class="file-size">${fileSize}</div>
                        </div>
                    </div>
                    <div class="remove-file" onclick="removeFile(${index})">
                        🗑️
                    </div>
                `;

                fileList.appendChild(fileItem);
            });
        }

        function removeFile(index) {
            selectedFiles.splice(index, 1);
            updateFileList();
            updateUploadButton();
        }

        function clearFiles() {
            selectedFiles = [];
            document.getElementById('fileInput').value = '';
            updateFileList();
            updateUploadButton();
        }

        function updateUploadButton() {
            const uploadBtn = document.getElementById('uploadBtn');
            uploadBtn.disabled = selectedFiles.length === 0;
        }

        function getFileIcon(filename) {
            const ext = filename.toLowerCase().split('.').pop();
            
            if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg'].includes(ext)) return '🖼️';
            if (['mp4', 'avi', 'mov', 'wmv', 'flv', 'mkv'].includes(ext)) return '🎬';
            if (['mp3', 'wav', 'flac', 'aac', 'ogg'].includes(ext)) return '🎵';
            if (ext === 'pdf') return '📋';
            if (['doc', 'docx'].includes(ext)) return '📝';
            if (['xls', 'xlsx'].includes(ext)) return '📊';
            if (['zip', 'rar', '7z', 'tar', 'gz'].includes(ext)) return '📦';
            if (['txt', 'log'].includes(ext)) return '📃';
            
            return '📄';
        }

        function formatFileSize(bytes) {
            if (bytes === 0) return '0 B';
            
            const units = ['B', 'KB', 'MB', 'GB'];
            const k = 1024;
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            
            return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + units[i];
        }

        // 폼 제출 시 선택된 파일들을 input에 설정
        document.getElementById('uploadForm').addEventListener('submit', function(e) {
            if (selectedFiles.length === 0) {
                e.preventDefault();
                alert('업로드할 파일을 선택해주세요.');
                return;
            }

            // 진행률 표시
            document.getElementById('progressContainer').style.display = 'block';
            document.getElementById('uploadBtn').disabled = true;
        });
    </script>
</body>
</html>