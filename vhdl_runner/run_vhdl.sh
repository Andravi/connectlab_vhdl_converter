#!/bin/bash

# Script simples para compilar e simular VHDL com GHDL
# Uso: ./run_vhdl.sh -n arquivo.vhd testbench.vhd

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuração
WAVE_FILE="waves.vcd"
STD="08"

# Mostrar ajuda
show_help() {
    echo "Uso: $0 -n arquivo.vhd testbench.vhd"
    echo ""
    echo "OPÇÕES:"
    echo "  -n NOME    Especifica os arquivos (arquivo.vhd testbench.vhd)"
    echo "  -c, --clean  Limpa arquivos gerados"
    echo "  -v, --view   Abre GTKWave"
    echo "  -h, --help   Mostra esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  $0 -n and_gate.vhd and_gate_tb.vhd"
    echo "  $0 -n and_gate.vhdl and_gate_tb.vhdl"
    echo "  $0 -c"
    echo "  $0 -v"
}

# Limpar arquivos
clean_files() {
    echo -e "${YELLOW}Limpando...${NC}"
    rm -f *.o *.cf *.vcd *.ghw
    echo -e "${GREEN}✓ Limpo!${NC}"
}

# Compilar e executar
compile_and_run() {
    local main_file=$1
    local tb_file=$2
    
    # Extrai o nome da entidade (sem extensão)
    local entity_name=$(echo "$main_file" | sed 's/\.vhd$//' | sed 's/\.vhdl$//')
    
    echo -e "${YELLOW}📝 Compilando ${main_file} e ${tb_file}...${NC}"
    
    # Análise
    ghdl -a --std=${STD} ${main_file} ${tb_file} || {
        echo -e "${RED}✗ Erro na análise${NC}"
        exit 1
    }
    
    # Extrai nome do testbench (sem extensão)
    local tb_name=$(echo "$tb_file" | sed 's/\.vhd$//' | sed 's/\.vhdl$//')
    
    echo -e "${YELLOW}🔧 Elaborando ${tb_name}...${NC}"
    ghdl -e --std=${STD} ${tb_name} || {
        echo -e "${RED}✗ Erro na elaboração${NC}"
        exit 1
    }
    
    echo -e "${YELLOW}🚀 Simulando...${NC}"
    ghdl -r --std=${STD} ${tb_name} --vcd=${WAVE_FILE} || {
        echo -e "${RED}✗ Erro na simulação${NC}"
        exit 1
    }
    
    echo -e "${GREEN}✓ Concluído! Waveform: ${WAVE_FILE}${NC}"
    echo -e "${GREEN}  Use 'rv -v' para abrir o GTKWave${NC}"
}

# Processar argumentos
if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

case $1 in
    -c|--clean)
        clean_files
        exit 0
        ;;
    -v|--view)
        if [[ -f "${WAVE_FILE}" ]]; then
            gtkwave ${WAVE_FILE} &
        else
            echo -e "${RED}✗ Arquivo ${WAVE_FILE} não encontrado!${NC}"
        fi
        exit 0
        ;;
    -h|--help)
        show_help
        exit 0
        ;;
    -n)
        if [[ $# -lt 3 ]]; then
            echo -e "${RED}✗ Erro: Faltam arquivos!${NC}"
            echo "Uso: $0 -n arquivo.vhd testbench.vhd"
            exit 1
        fi
        compile_and_run "$2" "$3"
        ;;
    *)
        echo -e "${RED}✗ Opção inválida!${NC}"
        show_help
        exit 1
        ;;
esac
