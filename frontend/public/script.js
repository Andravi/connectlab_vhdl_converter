// Variáveis globais
let currentOutput = '';
let currentFilename = '';

// Função para executar comando com arquivo (NÃO MEXER - mantido igual)
document.getElementById('uploadForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const fileInput = document.getElementById('fileInput');
    const file = fileInput.files[0];
    
    if (!file) {
        alert('Por favor, selecione um arquivo JSON');
        return;
    }

    const formData = new FormData();
    formData.append('file', file);

    showLoading(true);
    clearResults();

    try {
        const response = await fetch('/json_to_vhdl', {
            method: 'POST',
            body: formData
        });

        const data = await response.json();
        handleResponse(data);
    } catch (error) {
        showError('Erro ao conectar com o servidor: ' + error.message);
    } finally {
        showLoading(false);
        fileInput.value = '';
        document.getElementById('fileInfo').style.display = 'none';
    }
});

// Handler para /tb_generate (2 arquivos)
document.getElementById('tbForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const vhdlInput = document.getElementById('vhdlInput');
    const csvInput = document.getElementById('csvInput');
    
    if (!vhdlInput.files[0] || !csvInput.files[0]) {
        alert('Por favor, selecione ambos os arquivos (VHDL e CSV)');
        return;
    }

    const formData = new FormData();
    formData.append('vhdlFile', vhdlInput.files[0]);
    formData.append('csvFile', csvInput.files[0]);

    showLoading(true);
    clearResults();

    try {
        const response = await fetch('/tb_generate', {
            method: 'POST',
            body: formData
        });

        const data = await response.json();
        handleResponse(data);
    } catch (error) {
        showError('Erro ao conectar com o servidor: ' + error.message);
    } finally {
        showLoading(false);
        vhdlInput.value = '';
        csvInput.value = '';
        document.getElementById('tbFileInfo').style.display = 'none';
    }
});

// Função para tratar a resposta (reutilizável)
function handleResponse(data) {
    if (data.error) {
        showError(data.error + (data.details ? '\n' + data.details : ''));
    } else {
        showResult(data);
        refreshFiles();
    }
}

// Mostrar info dos arquivos selecionados para tbForm
document.getElementById('vhdlInput').addEventListener('change', function(e) {
    const file = this.files[0];
    const infoDiv = document.getElementById('tbFileInfo');
    
    if (file) {
        infoDiv.style.display = 'block';
        infoDiv.innerHTML = `
            <strong>VHDL selecionado:</strong> ${file.name}<br>
        `;
    } else {
        infoDiv.style.display = 'none';
    }
});

document.getElementById('csvInput').addEventListener('change', function(e) {
    const file = this.files[0];
    const infoDiv = document.getElementById('tbFileInfo');
    const vhdlFile = document.getElementById('vhdlInput').files[0];
    
    if (file) {
        infoDiv.style.display = 'block';
        const vhdlInfo = vhdlFile ? `<strong>VHDL selecionado:</strong> ${vhdlFile.name}<br>` : '';
        const totalSize = ((vhdlFile?.size || 0) + (file.size || 0)) / 1024;
        infoDiv.innerHTML = `
            ${vhdlInfo}
            <strong>CSV selecionado:</strong> ${file.name}<br>
            <strong>Tamanho total:</strong> ${totalSize.toFixed(2)} KB
        `;
    } else if (!vhdlFile) {
        infoDiv.style.display = 'none';
    }
});

// Função para mostrar resultados (CORRIGIDA - removida duplicata)
function showResult(data) {
    const outputDiv = document.getElementById('resultOutput');
    const actionsDiv = document.getElementById('resultActions');

    let outputText = '';
    if (data.stdout) {
        outputText += '📝 Saída do Comando:\n' + data.stdout + '\n\n';
    }
    if (data.stderr) {
        outputText += '⚠️ Erros:\n' + data.stderr + '\n\n';
    }
    if (data.output) {
        outputText += '📄 Conteúdo do Arquivo de Saída:\n' + data.output;
    }

    outputDiv.textContent = outputText || 'Comando executado com sucesso!';
    currentOutput = data.output || outputText;
    currentFilename = data.filename;

    actionsDiv.innerHTML = '';
    
    if (data.filename) {
        const downloadBtn = document.createElement('button');
        downloadBtn.className = 'btn-download';
        downloadBtn.textContent = `⬇️ Baixar ${data.filename}`;
        downloadBtn.onclick = () => downloadFile(data.filename);
        actionsDiv.appendChild(downloadBtn);

        const copyBtn = document.createElement('button');
        copyBtn.className = 'btn-copy';
        copyBtn.textContent = '📋 Copiar Conteúdo';
        copyBtn.onclick = () => copyToClipboard(currentOutput);
        actionsDiv.appendChild(copyBtn);
    }

    if (data.command) {
        const commandInfo = document.createElement('div');
        commandInfo.style.cssText = 'margin-top: 10px; font-size: 12px; color: #6c757d;';
        commandInfo.textContent = `Comando executado: ${data.command}`;
        actionsDiv.appendChild(commandInfo);
    }

    document.getElementById('resultContainer').style.display = 'block';
}

// Função para mostrar erro
function showError(message) {
    const outputDiv = document.getElementById('resultOutput');
    outputDiv.innerHTML = `<div class="error-message">❌ ${message.replace(/\n/g, '<br>')}</div>`;
    document.getElementById('resultContainer').style.display = 'block';
}

// Função para limpar resultados
function clearResults() {
    document.getElementById('resultOutput').innerHTML = '';
    document.getElementById('resultActions').innerHTML = '';
    document.getElementById('resultContainer').style.display = 'none';
}

// Função para mostrar/ocultar loading
function showLoading(show) {
    document.getElementById('loading').style.display = show ? 'block' : 'none';
}

// Função para baixar arquivo
function downloadFile(filename) {
    window.location.href = `/download/${encodeURIComponent(filename)}`;
}

// Função para copiar para clipboard
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        alert('Conteúdo copiado para a área de transferência!');
    }).catch(() => {
        // Fallback
        const textarea = document.createElement('textarea');
        textarea.value = text;
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand('copy');
        document.body.removeChild(textarea);
        alert('Conteúdo copiado para a área de transferência!');
    });
}

// Função para atualizar lista de arquivos
async function refreshFiles() {
    try {
        const response = await fetch('/files');
        const files = await response.json();
        
        const container = document.getElementById('filesContainer');
        container.innerHTML = '';

        if (files.length === 0) {
            container.innerHTML = '<p class="text-muted">Nenhum arquivo encontrado</p>';
            return;
        }

        files.forEach(file => {
            const fileItem = document.createElement('div');
            fileItem.className = 'file-item';
            
            const size = (file.size / 1024).toFixed(2);
            const date = new Date(file.modified).toLocaleString();
            
            fileItem.innerHTML = `
                <div>
                    <div class="file-name">${file.name}</div>
                    <div class="file-size">${size} KB - ${date}</div>
                </div>
                <div class="file-actions">
                    <button onclick="downloadFile('${file.name}')">⬇️ Baixar</button>
                    <button onclick="viewFile('${file.name}')">👁️ Visualizar</button>
                </div>
            `;
            
            container.appendChild(fileItem);
        });
    } catch (error) {
        console.error('Erro ao listar arquivos:', error);
    }
}

// Função para visualizar arquivo
async function viewFile(filename) {
    try {
        const response = await fetch(`/download/${encodeURIComponent(filename)}`);
        const text = await response.text();
        
        // Mostrar em um modal ou no resultado
        const outputDiv = document.getElementById('resultOutput');
        outputDiv.textContent = text;
        document.getElementById('resultContainer').style.display = 'block';
        
        // Adicionar botão para fechar
        const actionsDiv = document.getElementById('resultActions');
        actionsDiv.innerHTML = `
            <button onclick="document.getElementById('resultContainer').style.display = 'none'" class="btn btn-secondary">
                Fechar Visualização
            </button>
        `;
    } catch (error) {
        alert('Erro ao visualizar arquivo: ' + error.message);
    }
}

// Mostrar info do arquivo selecionado (uploadForm - NÃO MEXER)
document.getElementById('fileInput').addEventListener('change', function(e) {
    const file = this.files[0];
    const infoDiv = document.getElementById('fileInfo');
    
    if (file) {
        infoDiv.style.display = 'block';
        infoDiv.innerHTML = `
            <strong>Arquivo selecionado:</strong> ${file.name}<br>
            <strong>Tamanho:</strong> ${(file.size / 1024).toFixed(2)} KB
        `;
    } else {
        infoDiv.style.display = 'none';
    }
});

// Inicializar
refreshFiles();

// Atualizar lista a cada 30 segundos
setInterval(refreshFiles, 30000);