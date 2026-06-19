import json
import sys

def clean_json_for_vhdl(input_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    node_visual_fields = [
        'componentType',
        'position',
        'slotIds'
    ]

    slot_visual_fields = [
        'componentType',
        'position',
        'color',
        'colorActive',
        'radius',
        'attractionRadius'
    ]

    connection_visual_fields = [
        'componentType',
        'position',
        'endPosition',
        'anchors'
    ]

    if 'nodes' in data['data']:
        for node in data['data']['nodes']:
            for field in node_visual_fields:
                node.pop(field, None)

    if 'slots' in data['data']:
        for slot in data['data']['slots']:
            for field in slot_visual_fields:
                slot.pop(field, None)

    if 'connections' in data['data']:
        for conn in data['data']['connections']:
            for field in connection_visual_fields:
                conn.pop(field, None)

    if 'texts' in data['data'] and not data['data']['texts']:
        del data['data']['texts']


    with open(input_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)

    return input_file

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Uso: python clean_json.py entrada.json')
        sys.exit(1)

    clean_json_for_vhdl(sys.argv[1], )