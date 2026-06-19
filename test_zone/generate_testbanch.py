#!/usr/bin/env python3
import csv
import sys
import os

def generate_testbench(csv_file, entity_name, output_file=None):
    """
    Gera um testbench VHDL a partir de uma tabela verdade em CSV.
    Suporta múltiplas entradas e múltiplas saídas.
    """
    
    # Lê o CSV
    with open(csv_file, 'r') as f:
        reader = csv.reader(f)
        header = next(reader)  # Primeira linha é o cabeçalho
        rows = list(reader)
    
    # Identifica entradas e saídas
    inputs = header[:-1]  # Todas as colunas exceto a última
    outputs = header[-1:]  # Última coluna é a saída (ajustar para múltiplas)
    
    # Nome do testbench
    tb_name = f"{entity_name}_tb"
    if output_file is None:
        output_file = f"{tb_name}.vhdl"
    
    # Gera o código VHDL
    vhdl = []
    
    # Cabeçalho
    vhdl.append("-- Testbench gerado automaticamente a partir de tabela verdade")
    vhdl.append(f"-- Arquivo CSV: {csv_file}")
    vhdl.append("")
    vhdl.append("library ieee;")
    vhdl.append("use ieee.std_logic_1164.all;")
    vhdl.append("")
    vhdl.append(f"entity {tb_name} is")
    vhdl.append(f"end {tb_name};")
    vhdl.append("")
    vhdl.append(f"architecture sim of {tb_name} is")
    
    # Sinais
    for sig in header:
        vhdl.append(f"    signal {sig} : std_logic;")
    
    vhdl.append("begin")
    vhdl.append("")
    vhdl.append(f"    -- Instancia o componente")
    vhdl.append(f"    UUT: entity work.{entity_name} port map (")
    
    # Mapeamento das portas
    port_map = []
    for sig in header:
        port_map.append(f"        {sig} => {sig}")
    vhdl.append(",\n".join(port_map))
    vhdl.append("    );")
    vhdl.append("")
    vhdl.append("    process")
    vhdl.append("    begin")
    vhdl.append("        -- Testa todas as combinações da tabela verdade")
    
    # Gera os testes
    for i, row in enumerate(rows, 1):
        values = [v.strip() for v in row]
        
        # Aplica os estímulos
        stim = []
        for idx, sig in enumerate(inputs):
            stim.append(f"{sig} <= '{values[idx]}'")
        stim_str = "; ".join(stim)
        
        # Verifica todas as saídas
        for idx, sig in enumerate(outputs):
            expected = values[-1]  # Última coluna
        
        vhdl.append("")
        vhdl.append(f"        -- Teste {i}: {' '.join([f'{sig}={values[idx]}' for idx, sig in enumerate(header)])}")
        vhdl.append(f"        {stim_str};")
        vhdl.append("        wait for 10 ns;")
        
        # Verifica todas as saídas
        for idx, sig in enumerate(outputs):
            expected_idx = len(inputs) + idx
            if expected_idx < len(values):
                expected = values[expected_idx]
                vhdl.append(f"        assert ({sig} = '{expected}')")
                vhdl.append(f"            report \"Falha no teste {i}: {sig} deveria ser {expected} mas foi \" & std_logic'image({sig})")
                vhdl.append("            severity error;")
    
    # Finaliza
    vhdl.append("")
    vhdl.append("        report \"✅ Todos os testes passaram!\";")
    vhdl.append("        std.env.finish;")
    vhdl.append("    end process;")
    vhdl.append("")
    vhdl.append(f"end sim;")
    
    # Escreve o arquivo
    with open(output_file, 'w') as f:
        f.write("\n".join(vhdl))
    
    print(f"✅ Testbench gerado: {output_file}")
    print(f"   {len(rows)} testes gerados a partir de {csv_file}")

def extract_entity_name(file_path):
    """
    Extrai o nome da entidade do caminho do arquivo.
    Exemplo: ../simulacoes/or_simples.vhdl -> or_simples
    """
    # Pega apenas o nome do arquivo (remove caminho)
    base_name = os.path.basename(file_path)
    
    # Remove extensão (.vhd, .vhdl, .v)
    base_name = base_name.replace('.vhd', '').replace('.vhdl', '').replace('.v', '')
    
    return base_name

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python generate_tb.py <csv_file> <entity_file>")
        print("Exemplo: python generate_tb.py and_gate_truth.csv and_gate.vhd")
        print("Exemplo: python generate_tb.py and_gate_truth.csv ../simulacoes/or_simples.vhdl")
        sys.exit(1)
    
    csv_file = sys.argv[1]
    entity_file = sys.argv[2]
    
    # Extrai o nome da entidade do arquivo
    entity_name = extract_entity_name(entity_file)
    print(entity_name)
    # Gera o testbench com o nome extraído
    generate_testbench(csv_file, entity_name)