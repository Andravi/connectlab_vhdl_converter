import json
import sys
from tojson import descompactar_e_renomear
from clean_json import clean_json_for_vhdl

def json_to_vhdl(input_json: str):
    with open(input_json, 'r', encoding='utf-8') as f:
        data = json.load(f)

    nodes = {n['id']: n for n in data['data']['nodes']}
    connections = data['data']['connections']
    signals = {s['id']: s['data'] for s in data['signal']}

    # Classificar componentes
    inputs = []
    outputs = []
    gates = []
    for nid, node in nodes.items():
        nt = node['nodeType']
        if nt in [100, 101, 102]:
            inputs.append(nid)
        elif nt == 200:
            outputs.append((nid, 1))
        elif nt == 201:
            outputs.append((nid, 7))
        elif nt == 0:
            gates.append((nid, 'AND'))
        elif nt == 1:
            gates.append((nid, 'NAND'))
        elif nt == 2:
            gates.append((nid, 'NOR'))
        elif nt == 3:
            gates.append((nid, 'NOT'))
        elif nt == 4:
            gates.append((nid, 'OR'))
        elif nt == 5:
            gates.append((nid, 'XNOR'))
        elif nt == 6:
            gates.append((nid, 'XOR'))

    output_ids = [o[0] for o in outputs]

    # Mapa de conexoes: destino -> {slotPosition: origem}
    conn_map = {}
    for conn in connections:
        end_node = conn['connectedTo']['end']['nodeId']
        start_node = conn['connectedTo']['start']['nodeId']
        end_slot_id = conn['connectedTo']['end']['slotId']
        end_slot = next(s for s in data['data']['slots'] if s['id'] == end_slot_id)
        slot_pos = end_slot['slotIdAtParent']
        if end_node not in conn_map:
            conn_map[end_node] = {}
        conn_map[end_node][slot_pos] = start_node

    # Nomear sinais
    def signal_name(nid):
        if nid in inputs:
            return f"input_{nid}"
        if nid in output_ids:
            return f"output_{nid}"
        return f"gate_{nid}_out"

    # Todas as portas logicas precisam de sinal declarado
    # pois podem ter realimentacao
    needs_signal = set()
    for gid, gtype in gates:
        needs_signal.add(gid)

    # Gerar entity
    entity_name = data.get('title', 'circuito').replace(' ', '_')
    vhdl = f"library IEEE;\n"
    vhdl += f"use IEEE.STD_LOGIC_1164.ALL;\n\n"
    vhdl += f"entity {entity_name} is\n"
    vhdl += f"    Port (\n"

    port_lines = []
    for inp in inputs:
        port_lines.append(f"        {signal_name(inp)} : in  STD_LOGIC")
    for out_id, width in outputs:
        if width == 1:
            port_lines.append(f"        {signal_name(out_id)} : out STD_LOGIC")
        else:
            port_lines.append(f"        {signal_name(out_id)} : out STD_LOGIC_VECTOR({width-1} downto 0)")
    vhdl += ";\n".join(port_lines) + "\n"
    vhdl += f"    );\n"
    vhdl += f"end {entity_name};\n\n"

    # Gerar architecture
    vhdl += f"architecture Behavioral of {entity_name} is\n"

    # Declarar sinais internos para TODAS as portas
    for gid, gtype in gates:
        vhdl += f"    signal {signal_name(gid)} : STD_LOGIC;\n"

    vhdl += f"\nbegin\n"

    # Gerar logica das portas
    for gid, gtype in gates:
        inputs_to_gate = conn_map.get(gid, {})
        in_signals = []
        for pos in sorted(inputs_to_gate.keys()):
            in_signals.append(signal_name(inputs_to_gate[pos]))
        
        if len(in_signals) == 0:
            continue
        
        if gtype == 'NOT':
            expr = f"NOT {in_signals[0]}"
        elif gtype == 'AND':
            expr = f"{' AND '.join(in_signals)}"
        elif gtype == 'NAND':
            expr = f"NOT ({' AND '.join(in_signals)})"
        elif gtype == 'OR':
            expr = f"{' OR '.join(in_signals)}"
        elif gtype == 'NOR':
            expr = f"NOT ({' OR '.join(in_signals)})"
        elif gtype == 'XOR':
            expr = f"{' XOR '.join(in_signals)}"
        elif gtype == 'XNOR':
            expr = f"NOT ({' XOR '.join(in_signals)})"
        else:
            expr = f"{' AND '.join(in_signals)}"
        
        vhdl += f"    {signal_name(gid)} <= {expr};\n"

    # Conectar saidas
    for out_id, width in outputs:
        if out_id in conn_map and 0 in conn_map[out_id]:
            source_id = conn_map[out_id][0]
            vhdl += f"    {signal_name(out_id)} <= {signal_name(source_id)};\n"

    vhdl += f"\nend Behavioral;\n"

    print(input_json[:-5])

    with open(input_json[:-5] + '.vhdl', 'w', encoding='utf-8') as f:
        f.write(vhdl)

    return True

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Uso: python json_to_vhdl.py arquivo.json ')
        sys.exit(1)

    arg1: str = sys.argv[1]
    
    if arg1.endswith('.json'):
        arquivo_limpo = clean_json_for_vhdl(arquivo)

    elif arg1.endswith('.simulation'):
        arquivo = descompactar_e_renomear(arg1)
        arquivo_limpo = clean_json_for_vhdl(arquivo)
        print(arquivo_limpo)

    json_to_vhdl(arquivo_limpo)