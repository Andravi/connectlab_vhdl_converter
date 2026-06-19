import gzip, shutil, sys
from pathlib import Path




def descompactar_e_renomear(arquivo):

    arquivo = Path(sys.argv[1])
    with gzip.open(arquivo, 'rb') as f_in:
        with open(arquivo.with_suffix('.json'), 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
    
    

    print(f"✅ Extraído: {arquivo} → {arquivo.with_suffix('.json')}")
    return str(arquivo.with_suffix('.json'))



if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Uso: python arquivo.py arquivo.simulation")
        sys.exit(1)
    
    descompactar_e_renomear(sys.argv[1])
