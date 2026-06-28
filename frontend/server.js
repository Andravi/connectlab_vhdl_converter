const express = require('express');
const multer = require('multer');
const { exec } = require('child_process');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 3000;

// Configurar multer para upload de arquivos
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadDir = './uploads';
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir);
        }
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        cb(null, file.originalname);
    }
});

const upload = multer({
    storage: storage,
    fileFilter: (req, file, cb) => {
        cb(null, true);

    }
});



// Servir arquivos estáticos
app.use(express.static('public'));
app.use(express.json());

// Endpoint para executar o comando
// Endpoint para executar o comando com um arquivo
app.post('/json_to_vhdl', upload.single('file'), (req, res) => {
    if (!req.file) {
        return res.status(400).json({ error: 'Nenhum arquivo enviado' });
    }

    const filePath = req.file.path;
    const pythonScript = '../json_to_vhdl.py';
    const command = `python ${pythonScript} ${filePath}`;

    console.log(`Executando: ${command}`);

    exec(command, (error, stdout, stderr) => {
        // Limpar arquivo temporário
        if (filePath && fs.existsSync(filePath)) {
            fs.unlink(filePath, (err) => {
                if (err) console.error('Erro ao deletar arquivo:', err);
            });
        }

        if (error) {
            console.error(`Erro: ${error}`);
            return res.status(500).json({
                error: 'Erro ao executar comando',
                details: stderr || error.message
            });
        }

        // Tentar encontrar o arquivo de saída
        let outputFiles = [];
        const searchDirs = ['./uploads'];
        
        for (const dir of searchDirs) {
            try {
                if (fs.existsSync(dir)) {
                    const files = fs.readdirSync(dir)
                        .filter(f => {
                            const isVHDL = f.endsWith('.vhdl');
                            const isNotOriginal = f !== req.file.originalname;
                            return isVHDL && isNotOriginal;
                        })
                        .sort((a, b) => {
                            const statA = fs.statSync(path.join(dir, a));
                            const statB = fs.statSync(path.join(dir, b));
                            return statB.mtime.getTime() - statA.mtime.getTime();
                        });
                    
                    if (files.length > 0) {
                        outputFiles = files.map(f => path.join(dir, f));
                        break;
                    }
                }
            } catch (err) {
                console.error(`Erro ao ler diretório ${dir}:`, err);
            }
        }

        console.log('Arquivos VHDL encontrados:', outputFiles);
        
        if (outputFiles.length > 0) {
            const outputFile = outputFiles[0];
            try {
                const outputContent = fs.readFileSync(outputFile, 'utf8');
                return res.json({
                    success: true,
                    output: outputContent,
                    filename: path.basename(outputFile),
                    filepath: outputFile,
                    command: command,
                    stdout: stdout,
                    stderr: stderr
                });
            } catch (err) {
                console.error('Erro ao ler arquivo de saída:', err);
                return res.json({
                    success: true,
                    output: stdout || 'Comando executado, mas erro ao ler saída',
                    filename: null,
                    command: command,
                    stdout: stdout,
                    stderr: stderr
                });
            }
        }

        res.json({
            success: true,
            output: stdout || 'Comando executado com sucesso!',
            filename: null,
            command: command,
            stdout: stdout,
            stderr: stderr
        });
    });
});


// Endpoint para executar comando com dois arquivos
app.post('/tb_generate', upload.fields([
    { name: 'vhdlFile', maxCount: 1 },
    { name: 'csvFile', maxCount: 1 }
]), (req, res) => {
    const vhdlFile = req.files['vhdlFile'] ? req.files['vhdlFile'][0] : null;
    const csvFile = req.files['csvFile'] ? req.files['csvFile'][0] : null;

    if (!vhdlFile || !csvFile) {
        return res.status(400).json({ error: 'Ambos os arquivos são obrigatórios' });
    }

    const vhdlPath = vhdlFile.path;
    const csvPath = csvFile.path;
    const pythonScript = '../generate_testbanch.py';
    const command = `python ${pythonScript} ${csvPath} ${vhdlPath}`;

    console.log(`Executando: ${command}`);

    exec(command, (error, stdout, stderr) => {
        // Limpar arquivos temporários
        const filesToDelete = [vhdlPath, csvPath];
        filesToDelete.forEach(filePath => {
            if (filePath && fs.existsSync(filePath)) {
                fs.unlink(filePath, (err) => {
                    if (err) console.error('Erro ao deletar arquivo:', err);
                });
            }
        });

        if (error) {
            console.error(`Erro: ${error}`);
            return res.status(500).json({
                error: 'Erro ao executar comando',
                details: stderr || error.message
            });
        }

        // Tentar encontrar o arquivo de saída
        let outputFiles = [];
        const searchDirs = ['.', './uploads', './output'];
        
        for (const dir of searchDirs) {
            try {
                if (fs.existsSync(dir)) {
                    const files = fs.readdirSync(dir)
                        .filter(f => {
                            const isVHDL = f.endsWith('.vhdl');
                            const isNotTemp = f !== vhdlFile.originalname && f !== csvFile.originalname;
                            return isVHDL && isNotTemp;
                        })
                        .sort((a, b) => {
                            const statA = fs.statSync(path.join(dir, a));
                            const statB = fs.statSync(path.join(dir, b));
                            return statB.mtime.getTime() - statA.mtime.getTime();
                        });
                    
                    if (files.length > 0) {
                        outputFiles = files.map(f => path.join(dir, f));
                        break;
                    }
                }
            } catch (err) {
                console.error(`Erro ao ler diretório ${dir}:`, err);
            }
        }

        console.log('Arquivos VHDL encontrados:', outputFiles);
        
        if (outputFiles.length > 0) {
            const outputFile = outputFiles[0];
            try {
                const outputContent = fs.readFileSync(outputFile, 'utf8');
                return res.json({
                    success: true,
                    output: outputContent,
                    filename: path.basename(outputFile),
                    filepath: outputFile,
                    command: command,
                    stdout: stdout,
                    stderr: stderr
                });
            } catch (err) {
                console.error('Erro ao ler arquivo de saída:', err);
                return res.json({
                    success: true,
                    output: stdout || 'Comando executado, mas erro ao ler saída',
                    filename: null,
                    command: command,
                    stdout: stdout,
                    stderr: stderr
                });
            }
        }

        res.json({
            success: true,
            output: stdout || 'Comando executado com sucesso!',
            filename: null,
            command: command,
            stdout: stdout,
            stderr: stderr
        });
    });
});

// Endpoint para baixar arquivo
app.get('/download/:filename', (req, res) => {
    let filename = req.params.filename;

    // Se o arquivo NÃO terminar com 'tb.vhdl', adiciona o prefixo 'uploads/'
    if (!filename.endsWith('tb.vhdl')) {
        filename = 'uploads/' + filename;
    }

    const filepath = path.join(__dirname, filename);

    console.log(filepath);
    if (fs.existsSync(filepath)) {
        res.download(filepath);
    } else {
        res.status(404).json({ error: 'Arquivo não encontrado' });
    }
});

// Endpoint para listar arquivos
app.get('/files', (req, res) => {
    const files = fs.readdirSync('.')
        .filter(f => f.endsWith('.json'))
        .map(f => ({
            name: f,
            size: fs.statSync(f).size,
            modified: fs.statSync(f).mtime
        }));
    res.json(files);
});

app.listen(PORT, () => {
    console.log(`Servidor rodando em http://localhost:${PORT}`);
});